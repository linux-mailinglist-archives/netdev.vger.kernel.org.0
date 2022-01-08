Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEB8488645
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiAHV36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:29:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbiAHV35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:29:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641677396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TeSsd+eGYxY9ET76GpMaGOKTHlyy8/aZTUAhONjSzxE=;
        b=RHsywMOw1vkxU8UVv9PiJO1f6LKmAC/aMfTVGBxPF3xJBSU+zMSBe41YiSxeS3zYJNTF7n
        x297qW76XNjc9asBaj2TBQVAZf8qT92NkOziYqPHQVe0jkCeWsFwPWX0V/a5EcoxSz54yD
        9UYU9JPUp2vw8qb+8jdt1SfbpMo7rFU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-iEim6jvPPiW_CWquB0VEtw-1; Sat, 08 Jan 2022 16:29:55 -0500
X-MC-Unique: iEim6jvPPiW_CWquB0VEtw-1
Received: by mail-wr1-f71.google.com with SMTP id k4-20020adfc704000000b001a32d86a772so2705312wrg.5
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 13:29:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TeSsd+eGYxY9ET76GpMaGOKTHlyy8/aZTUAhONjSzxE=;
        b=Rg4Kp9J60AR2tpKHM4JZ48mkfsU21d8UeodqqffYgYVr5k1I44zYc/UMkIhMd5JRXJ
         JQxBwiRdtKeLP5kqa1Jm9AmUi1U/cB8NFC+yoUUZUl/EpN0g4jZkEUCZdXDxRKbuH3Zl
         Yw5WAhQyf2TBD6gravCCXPjQkaUCBlg5vM+pnJZbBTKfKkNdLE5UzoMIBWTib2Mdqjmu
         3LJAFJb4H9txu9OiJMlENmBSvJkNywMX8m4/Ltv9iYJYc6Gm6kKp+JxMhXbiMWqe/Uoh
         16zTwF45N2SLDUTwhld1CdXcNTMMl0SjZpqQMWywFJLaEH2xHTIL4p5SUoHLqRo2P/0r
         412Q==
X-Gm-Message-State: AOAM533d4svUTuwsTFg1xrtBOdgt+g+LYNcFplFfPiMdLYhiCvhSshb2
        UJ+q2WO3op4YXRi4XrF0A9+nNpPEwJC+darXA4WhcuEStZkkFwkG8IILJAjQP2uw5vpBC1KMRSh
        IVIJtEnxAUlV7GofY
X-Received: by 2002:a05:600c:600c:: with SMTP id az12mr15834732wmb.86.1641677394157;
        Sat, 08 Jan 2022 13:29:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTg0/JYO8QF2XPhQiIisq/9tOBFl5jBcqd7Np7+z37VIZsvK+r/q2v9cr2aDbu8lc/wvJs0w==
X-Received: by 2002:a05:600c:600c:: with SMTP id az12mr15834729wmb.86.1641677394008;
        Sat, 08 Jan 2022 13:29:54 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p18sm2621997wmq.23.2022.01.08.13.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 13:29:53 -0800 (PST)
Date:   Sat, 8 Jan 2022 22:29:51 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH iproute2-next 04/11] m_vlan: fix formatting of push
 ethernet src mac
Message-ID: <20220108212951.GA22261@pc-4.home>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
 <20220108204650.36185-5-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108204650.36185-5-sthemmin@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 08, 2022 at 12:46:43PM -0800, Stephen Hemminger wrote:
> This was reported as a clang warning:
>     CC       m_vlan.o
> m_vlan.c:282:32: warning: converting the enum constant to a boolean [-Wint-in-bool-context]
>                 if (tb[TCA_VLAN_PUSH_ETH_SRC &&
>                                              ^
> 
> But it is really a bug in the code for displaying the pushed
> source mac.
> 
> Fixes: d61167dd88b4 ("m_vlan: add pop_eth and push_eth actions")
> Cc: gnault@redhat.com
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  tc/m_vlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/m_vlan.c b/tc/m_vlan.c
> index 221083dfc0da..1b2b1d51ed2d 100644
> --- a/tc/m_vlan.c
> +++ b/tc/m_vlan.c
> @@ -279,8 +279,8 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
>  				    ETH_ALEN, 0, b1, sizeof(b1));
>  			print_string(PRINT_ANY, "dst_mac", " dst_mac %s", b1);
>  		}
> -		if (tb[TCA_VLAN_PUSH_ETH_SRC &&
> -		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN]) {
> +		if (tb[TCA_VLAN_PUSH_ETH_SRC] &&
> +		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN) {
>  			ll_addr_n2a(RTA_DATA(tb[TCA_VLAN_PUSH_ETH_SRC]),
>  				    ETH_ALEN, 0, b1, sizeof(b1));
>  			print_string(PRINT_ANY, "src_mac", " src_mac %s", b1);

This is already fixed in iproute2 with commit 0e949725908b ("tc/m_vlan:
fix print_vlan() conditional on TCA_VLAN_ACT_PUSH_ETH").

