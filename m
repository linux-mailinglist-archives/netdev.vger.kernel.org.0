Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD6B6B8F0D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCNJ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNJ6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:58:17 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4E9234EE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:58:15 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id eg48so327231edb.13
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678787894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4vP5Re9zdzb1bRofWgWepOPFplfR8l8nesMdEtwvF5M=;
        b=PrGnaFMh+qT/JrPlVs2caRruOTu0onIr+D3ZYEwAGzaMIL42Yuh9bLiLsGZodKPGDy
         44CK1mPHmrJrYKwec4+kYXXbm7h81VlRvFf+qtw0iVeDOgujKsXnVe6AnbL4KyAyjDX/
         RfIqI0Dr/vC5g40GeatzTEN0tYKU9FWpqAvCSuG5dXAbPKnXyD2q3rA/6R/71nvWgCCM
         0Y+Of9uZcMUf2Pk0+HonoeldJ1DpOtxN5tFRHijRJj5yJbK1ehxWxPuAcvcwTm//SCK7
         17+Vk/YyC1+pePhrvD+Xqt8XRqYy9Z54DaN4POOL8CSZRRXwmGGxsl4CsE/0zyldqZLo
         hPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678787894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vP5Re9zdzb1bRofWgWepOPFplfR8l8nesMdEtwvF5M=;
        b=kT1b0hM4nuOTmgUYyz767f7ifw0YAa1oLqJ5Sa2KaiVWd8kwIlvfclcMrjb+HouIY9
         piroDTbMAeuORwjf2CcwX2H4T+q5UDkccOv8qJ8F3ZyrjLxZ4L5uWb+iMsiuVUYcMp17
         JztPNmyfxuV3fevHzODyZ7+bZdezUg5JrdSuOs5NSP3Helmi5Twtit3Z5Z0k/6xK54Jr
         EaJWZOzILnLc/mZBqxaOMg2RrB4XGBH5IeItkhQftLP0yVZA+cLJua8cWVy99V02gN1X
         M23KlwEXoXFflMoSE5McmqicEG1014sz8e/UEaEGiyubAXy2mpIIH5YVu4pcTbOXtM9W
         i03w==
X-Gm-Message-State: AO0yUKUfetwlGNO5VYOVsInA98LM5H9EMaT1A9yY16tnQO+NSGYdmX6v
        b/7m74odrMwp5fhwDksnIc8RWw==
X-Google-Smtp-Source: AK7set+ukPMWQe8pHWElrAzMp+7HukhhGDeZiRval42phOLC7IbIEMLTtPZd/+v9W82x1MKGOvNY0Q==
X-Received: by 2002:a05:6402:8d9:b0:4fb:f9a9:c791 with SMTP id d25-20020a05640208d900b004fbf9a9c791mr7112889edz.18.1678787893735;
        Tue, 14 Mar 2023 02:58:13 -0700 (PDT)
Received: from [192.168.3.222] ([213.211.148.158])
        by smtp.gmail.com with ESMTPSA id t14-20020a508d4e000000b004fc01b0aa55sm771207edt.4.2023.03.14.02.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 02:58:13 -0700 (PDT)
Message-ID: <3a6f95c4-14bd-fc83-3a36-49eedd4442aa@tessares.net>
Date:   Tue, 14 Mar 2023 10:58:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] veth: rely on rtnl_dereference() instead of on
 rcu_dereference() in veth_set_xdp_features()
Content-Language: en-GB
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
References: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <dfd6a9a7d85e9113063165e1f47b466b90ad7b8a.1678748579.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On 14/03/2023 00:08, Lorenzo Bianconi wrote:
> Fix the following kernel warning in veth_set_xdp_features routine
> relying on rtnl_dereference() instead of on rcu_dereference():

Thank you for the formal patch!

If needed:

Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

(...)

> Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Link: https://lore.kernel.org/netdev/cover.1678364612.git.lorenzo@kernel.org/T/#me4c9d8e985ec7ebee981cfdb5bc5ec651ef4035d

Just in case we want shorter links -- I know some people prefer them,
I'm not sure here in fact -- we can also use the "permalink":

Link:
https://lore.kernel.org/all/f5167659-99d7-04a1-2175-60ff1dabae71@tessares.net/

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
