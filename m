Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E08C453AD6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhKPUYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhKPUYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 15:24:14 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9895C061570;
        Tue, 16 Nov 2021 12:21:16 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id b5-20020a9d60c5000000b0055c6349ff22so398670otk.13;
        Tue, 16 Nov 2021 12:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MNU5uPxjn+7slB6v30//uhSN/kHUFZf1pbWCXTfuxkc=;
        b=Kc5EtmkLFgfVOPPFngYcV9Xh0dWQDXhWHuD90qOVAZCEwOKRWeEpYW5zyIcjBnGmBL
         h8IOX0Fh0uvGoeJz7at7JCjAlmKT9aub+jcuYkkYBJsruZ9K5L2i5qUOkxvfHNk8iQsG
         z/4LArJ+Ll/8ASGgsNmljeur/kMPH5ZKZIHDPza3bALzBZLvowTjUSDyv72rNWtViqaS
         FuDBGBwkNHt2NBmCUWXSih0EsOx1kZ/wQ5IZ89Fv74Hd12+YGcdIDTpXVbRfe3Dtwh7p
         +srecF2UDDbEpDFvRhN0MrJZJ9zqhRCVZ32xB5QLj9nyXeRhao+QgPFkrUxKX12/l3EY
         RK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MNU5uPxjn+7slB6v30//uhSN/kHUFZf1pbWCXTfuxkc=;
        b=5Kjp41Nk2IRUMHhXJFd3COwDL+MA0YHns8BOOFWDADFISmlWPUhOwbJgBp3q5/wpIU
         rrtICSBtXDqDT3AYE8D2RTo3asKXRv/SzY4SnzN0DwQ/TTZ13CbSmQVm/EyY4oTWwXTo
         jTv0wUymxje7lJrnX9jJ9LIHpCg+/cnvpLW3/lklIKPCfV4LQwfbC4vpFkl7xFHTLVKh
         WJPB0USk8EdSShCRbihr0RVUxDQlBHaW8iDTsBnsr4WG/CnXfS7xOd+89xSg5K/cW4n+
         Z8DHNY6eB/IECEGMjEPqzrnyAI6w1r7vCF/YI7UtoORA6KqagiPjOp02HVveP7ceXhdq
         WZeg==
X-Gm-Message-State: AOAM530+EdDQnXftdESTVhyCqxNcG95ZWXAm39HdlLGpTypCvZDRnslk
        B5cGjeLRtltAvN1o2kNK6sM=
X-Google-Smtp-Source: ABdhPJwDvm24qITUfktAE3pnK4QPKqP6e7by0HDu9aSWX/Pt5/6meUIhZfFtzlEmiot/XUyXB3vnTg==
X-Received: by 2002:a9d:6254:: with SMTP id i20mr8441556otk.343.1637094076083;
        Tue, 16 Nov 2021 12:21:16 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r11sm3915874oth.48.2021.11.16.12.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:21:15 -0800 (PST)
Message-ID: <14eee606-427b-e0e4-abe2-de4e166c1585@gmail.com>
Date:   Tue, 16 Nov 2021 13:21:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next v2] ipv6: don't generate link-local addr in
 random or privacy mode
Content-Language: en-US
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Rocco.Yue@gmail.com,
        chao.song@mediatek.com, yanjie.jiang@mediatek.com,
        kuohong.wang@mediatek.com, zhuoliang.zhang@mediatek.com,
        lorenzo@google.com, maze@google.com, markzzzsmith@gmail.com
References: <20211116060959.32746-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211116060959.32746-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 11:09 PM, Rocco Yue wrote:
> In the 3GPP TS 29.061, here is a description as follows:
> "In order to avoid any conflict between the link-local address
> of the MS and that of the GGSN, the Interface-Identifier used by
> the MS to build its link-local address shall be assigned by the
> GGSN. The GGSN ensures the uniqueness of this Interface-Identifier.
> The MT shall then enforce the use of this Interface-Identifier by
> the TE"
> 
> In other words, in the cellular network, GGSN determines whether
> to reply a solicited RA message by identifying the bottom 64 bits
> of the source address of the received RS message. Therefore,
> cellular network device's ipv6 link-local address should be set
> as the format of fe80::(GGSN assigned IID).
> 
> To meet the above spec requirement, this patch adds two new
> addr_gen_mode:
> 
> 1) IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA, this mode is suitable
> for cellular networks that support RFC7217. In this mode, the
> kernel doesn't generate a link-local address for the cellular
> NIC, and generates an ipv6 stable privacy global address after
> receiving the RA message.
> 
> 2) IN6_ADDR_GEN_MODE_RANDOM_NO_LLA, in this mode, the kernel
> doesn't generate a link-local address for the cellular NIC,
> and will use the bottom 64 bits of the link-local address(same
> as the IID assigned by GGSN) to form an ipv6 global address
> after receiveing the RA message.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
> v1->v2: Add new addr_gen_mode instead of adding a separate sysctl.
> 
> v1 link:
> https://patchwork.kernel.org/patch/12353465
> 
> ---
>  include/uapi/linux/if_link.h       |  2 ++
>  net/ipv6/addrconf.c                | 22 ++++++++++++++++------
>  tools/include/uapi/linux/if_link.h |  2 ++
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

you should add tests under tools/testing/selftests/net.
