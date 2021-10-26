Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4FB43B4D9
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhJZOzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhJZOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:55:12 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D94C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:52:49 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so17621808ote.8
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ggIEajTIJZ9pjb6h9Yfl1Q1AiXRfxaF8TetiL4XvNK8=;
        b=IzMkdpnUjiU/ewuxiOmXDbUad1TDMFqKLqrr6FjGAMb5eC6YGkgZHg2XaNgF5QD/ko
         ettt9HZOrd9VYtf23Nrsq4cvdQUIHhbPUHlqOLaM79BvbVdNFGIW5LEf5d0gTyC00YLp
         0qrlfk6s+aOGD/SBUmzaajkayAxzWJgjpucN3V/BJpDYwxa6UgX0/c26q+pf9nFO1qbM
         pkPPutpktak5YpM1sPcsjnVATWlmIpx2zDDSJBCbrpj8s55UdxIoLWJzeq285eKOj/Y7
         XmooQRBWmCApFkJjuelQEOLtZ01O2FoY6gG0iJezdNob2GcpfLmOGBP2JzMX98+8S0pj
         28yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ggIEajTIJZ9pjb6h9Yfl1Q1AiXRfxaF8TetiL4XvNK8=;
        b=4gEzgL55sYJKOUiNcxIaKaDiEH2KxQMWVCTl7JME5D+LCIoHVM5nM8LCEdmGCty03C
         ugVvtdxCm/lBFqC0f9tRyPXJEiy/LwarraLUHC97yDHjpEXrrOyoQdTekDVuOsuw/rjR
         U8ZYDltPYNJuUoCatYhbOnoNvBOypIhUjPJvvHIp2ua3+nR0amW/9qCa7awLdmP04m1f
         L1aoN/jt2+Xr+zdtijWKQzZeUW38NyQar8YRJNYQJH9v/SKBwox9foFX1Wf5Lb4Z9QXc
         nzY9CY405uGs8tpVBqsl45/BQnwCMwxLCES1ROQJQ78HVngHwCZ42J95+An9hlHVegDG
         cSyg==
X-Gm-Message-State: AOAM532An+iwPkYr2fS8ghnQjoxRfJI5zyA/VKFsaL+BaTynWb/+IZwB
        8L+7cYkufhuJPUeinCATwdg=
X-Google-Smtp-Source: ABdhPJxDNdhFkLexor9deO91MCnn0B7gcgw8pTuv4L7OoErJOro9E/u4RaLLaCK70p+ozq3EYSPFvg==
X-Received: by 2002:a9d:7153:: with SMTP id y19mr19903333otj.41.1635259968389;
        Tue, 26 Oct 2021 07:52:48 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bc41sm4199681oob.2.2021.10.26.07.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 07:52:47 -0700 (PDT)
Message-ID: <4dd34a92-bfcf-27ad-2d32-c93f7a9082a9@gmail.com>
Date:   Tue, 26 Oct 2021 08:52:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [RESEND PATCH v7 2/3] net: ndisc: introduce ndisc_evict_nocarrier
 sysctl parameter
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
References: <20211025164547.1097091-1-prestwoj@gmail.com>
 <20211025164547.1097091-3-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211025164547.1097091-3-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 10:45 AM, James Prestwood wrote:
> In most situations the neighbor discovery cache should be cleared on a
> NOCARRIER event which is currently done unconditionally. But for wireless
> roams the neighbor discovery cache can and should remain intact since
> the underlying network has not changed.
> 
> This patch introduces a sysctl option ndisc_evict_nocarrier which can
> be disabled by a wireless supplicant during a roam. This allows packets
> to be sent after a roam immediately without having to wait for
> neighbor discovery.
> 
> A user reported roughly a 1 second delay after a roam before packets
> could be sent out (note, on IPv4). This delay was due to the ARP
> cache being cleared. During testing of this same scenario using IPv6
> no delay was noticed, but regardless there is no reason to clear
> the ndisc cache for wireless roams.
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  9 +++++++++
>  include/linux/ipv6.h                   |  1 +
>  include/uapi/linux/ipv6.h              |  1 +
>  net/ipv6/addrconf.c                    | 12 ++++++++++++
>  net/ipv6/ndisc.c                       | 12 +++++++++++-
>  5 files changed, 34 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


