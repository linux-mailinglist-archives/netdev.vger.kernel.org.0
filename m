Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6895467FE0E
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjA2KJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2KJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:09:51 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7B22794
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:09:50 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mg12so24309346ejc.5
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4CsT+NMYktzeydFPAHImkzr8929Eu6j85d9i8GMD/Zk=;
        b=gcT8L98xIM2tz4DFl9Z7r2oIUKwwC/eZt8BCs7XuG9aT99dv1SgOcGFHnIXKJY/mAD
         qNPHKq0iQThy10UVMpv11YjuM1n4xbpFDccX8MoOPCz+ptqOx8uEiKji623v86GMAWOA
         TzuYCaAbnEmkWGvSUsWB9conRzTdgDTtZc2OzowO+AYqhrMvVNugUwitCrJXTp5pwA9c
         C8MR+unp1bAdjRcSj6XiBxu1dfoqNCsMPafoM8HYVFXofxgTD/ZxOmfY/j9kxonPCeGL
         WjXX2x7+U/HsbID1xGMDN4dMZGhbE6vF7fQcqwRkRlMyOp80m0IfJZwo9svh+JDZzIIG
         plWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CsT+NMYktzeydFPAHImkzr8929Eu6j85d9i8GMD/Zk=;
        b=T8oQP1P5b4xBcPGm1GN3s+0aXTdQQBugHn3rYLJzN8FTnW3I8Vch6eT4dT0lFvVCBi
         KPP34yg1DEGIXNEOvVaAByskmzLmJWFpZnVtXW+MT+WVDcqHOC3NOn6P4RGgx1hSiGqz
         Nm0Dquc2Gop+2JB8rnsmq2dqLAeuza9aAUxXfUZrIlLG75+YJCFRgNOR27VVGCYXlK1i
         CrGttb4kQLuGskilH8hxqgaA1r32+Tr000s9bLq63pJWta3QMv5F9rC83sCGgvXQ/9qr
         ujsQBPk7DMGTujNIecdENzE1MCTngO6NXYyiB+pJy7kVX0nFbT7xfn8g7YeAsGuSg3IN
         eaNA==
X-Gm-Message-State: AO0yUKUr6oMrOKAgHXcwzyD2aIkkw/wIEAr8T6Lu2RVnd7I/1ofP8t/W
        J2pjuA0Deg40+W/MdJPcC+fVDQ==
X-Google-Smtp-Source: AK7set91jVdgKfpsBHwRb75uJfTU4zF4sKaDS1QHpXUYyfDwAC5zCwt7nkYS6fzT3G1pRwc7b7wRxw==
X-Received: by 2002:a17:906:3da:b0:887:d0e6:fa24 with SMTP id c26-20020a17090603da00b00887d0e6fa24mr751395eja.76.1674986989208;
        Sun, 29 Jan 2023 02:09:49 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id gy13-20020a170906f24d00b008787edd2f74sm117317ejb.50.2023.01.29.02.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:09:48 -0800 (PST)
Message-ID: <273f85f3-0eee-467e-29bb-018b7c0b8fd6@blackwall.org>
Date:   Sun, 29 Jan 2023 12:09:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 11/16] selftests: forwarding: lib: Add helpers
 for IP address handling
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <cc8762f78b2468f9b48288235470bd606fddbd96.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <cc8762f78b2468f9b48288235470bd606fddbd96.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> In order to generate IGMPv3 and MLDv2 packets on the fly, we will need
> helpers to expand IPv4 and IPv6 addresses given as parameters in
> mausezahn payload notation. Add helpers that do it.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 37 +++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
