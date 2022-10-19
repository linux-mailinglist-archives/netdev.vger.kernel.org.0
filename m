Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CBB604B33
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiJSPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiJSPXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:23:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22781DDC00
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:16:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v11so3133134wmd.1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t8mbyz005k1ZCB0lm92YQ3sRD1pQLUKEAM6sS32v9xA=;
        b=c+3bVrBXYN4nrzsuDgmO2S8ltukeYMIfhDpvuO6yVJ0KxthTuANe4qDgs5yE/VtpAc
         T05OIoBGLS3C9dwTHlAkX+w05LkaSRsRF4CmHszCSuFoyKxTfpwDxM3dBJdFVWEc+2T9
         oe+nC6MjolXYnHB1I6aZzuSqt+yGA7+I4TxZXtBfKAgsu0fT2fG2ka2Fqj2BxWFypV1W
         io51YJRoXwW2haEiE+V0ALoFtPJBkoh9oZ7pO6q5wqg8YoNfgHRaw2V54RrHIY+f70rW
         UFkDSL1mp4qXGt9A1huaDbtwvjKxcbPM2DRzToEGOKXrjq46hUEqEmr80OoGOaAAVtnI
         DJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t8mbyz005k1ZCB0lm92YQ3sRD1pQLUKEAM6sS32v9xA=;
        b=p4ISCz70djRMMTjMtQixnKkl9dk7ugSAh3xtj4z7/hOA6FirmW5mPy6uE6R2X+/mDM
         5mQI4brux2e4eu4K36Fcwb16MvkjCgvguwdw+8FC3yQBz3qayY1iXEn/EMlWwXFoiEIQ
         bGQr4esWuTSaFPeyAJaHEHp6/iZkzUFn2eE8O5EPZRY8hJLkncVNFAT02fm4cuzFBdjc
         RLbqzVxqrLWv2cj9KF0fhW+IPtJob6Kwtq3in87x1F3pPnxKVebOLO8CTixMjhIi0pcE
         lS6dv173tdmDzZuSg1lxN9mBlCtzCK/6gnS4xuVRWKI4iuoaYzerCiWu3rk7RyginkNr
         KFJA==
X-Gm-Message-State: ACrzQf1I65/hM88YWb7KQUgUE0L4iOTXv/OiOD/tWviieDmGBZwYH8Pv
        xHdaj1fbyqO3pcnc1QesRLC3cw==
X-Google-Smtp-Source: AMsMyM48se/OCyFP0vQ3MGzScXKz6W2eWWxuP1+zMUJDQ6tL6hFXXW18pp53YabhfymcZUiMtrWXVw==
X-Received: by 2002:a05:600c:15cc:b0:3c6:6ff5:21b8 with SMTP id v12-20020a05600c15cc00b003c66ff521b8mr5929774wmf.55.1666192586471;
        Wed, 19 Oct 2022 08:16:26 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:3000:72c0:ef02:f180? ([2a02:578:8593:1200:3000:72c0:ef02:f180])
        by smtp.gmail.com with ESMTPSA id u10-20020a5d468a000000b0021badf3cb26sm16757337wrq.63.2022.10.19.08.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 08:16:26 -0700 (PDT)
Message-ID: <9ec8db28-8b61-ce53-f247-b7ab7de7d5d6@tessares.net>
Date:   Wed, 19 Oct 2022 17:16:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH net-next 1/2] net: introduce and use custom sockopt socket
 flag
Content-Language: en-GB
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <cover.1666173045.git.pabeni@redhat.com>
 <b9ca7b78bec42047bc9935be2697328c7b71b391.1666173045.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <b9ca7b78bec42047bc9935be2697328c7b71b391.1666173045.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 19/10/2022 12:02, Paolo Abeni wrote:
> We will soon introduce custom setsockopt for UDP sockets, too.
> Instead of doing even more complex arbitrary checks inside
> sock_use_custom_sol_socket(), add a new socket flag and set it
> for the relevant socket types (currently only MPTCP).

Good idea, it is clearer and it looks good to me!

For the modifications in MPTCP:

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
