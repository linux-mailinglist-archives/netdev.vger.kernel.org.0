Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA202B9037
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgKSKhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgKSKhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 05:37:24 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5FFC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 02:37:24 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id m16so5315007edr.3
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 02:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=d7fZYyeWGlGQbshikTpsKZw0jlK0AhXwYdksilCOxE0=;
        b=hN92SvbxlPFxUrIsxUyAB3rW8FZ+Bj1oPlnn8dnUK0ZXZ9RoVPq4gPNF1ICx1QK0tE
         v/Dj5cuYulqsX1YTkj9etWPcKMo327/iDfB5nfrNGaO4P9fl0E4nAutRLophqzrY2FNe
         gOP3qbtvTW5xP60i93XPCUnqKYCNa7AWdvwlQQtQ8vVOWelhdJa0F86PXEFUJYu0HaRI
         6SIDsYBnDE4O7diUO3qOKKJGxP+XemVC8EEp3lys9QJXA0TYSHErlRbACeaDC7ZapRD1
         QSVKfZpeDJ4VC5EpHXNFH8izuMO/mh62qYi8OQRLHb92LNl+va7QXpseZgRL/W5RFfYm
         iPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=d7fZYyeWGlGQbshikTpsKZw0jlK0AhXwYdksilCOxE0=;
        b=lGfYGsfNjsXDnLZCASq8cZOtCbrk0Wgl7uy8SKDky4ERiZl5lP90xt2XQV5pBucc3A
         37Nd1iDFWXHT99Hsa2biYUInTgVZ8PgAu9LLMg2jtIIqDh2FFSfrbj2FC8fsymt7CQyn
         3Fz8VfD+X5QgUeTC+wEg6I7aCJIgc+VBnEGYGhkN9LgskAs7joi2qDf1AyqYOp7mja3G
         8ZXBPbxe6VbkO3tXfuy9k4+aNLjYnS1oLycoVso3oN5VLNTSvBvRT1HQIB09G+g5bEFp
         aCNmHfSCjAwPN30mEbPFWpcFCZ+t8zG9MJ/gsVV9N1eDXadNVSCq8lS1NtM87tla5cNO
         2E2g==
X-Gm-Message-State: AOAM533j+Z9qTZ1wOshG6DhjjYNRaox2qdx9PbsuK7SeFC7jPSZW5hsg
        z6WI5oxH/T/qvegaeRn0zwo6C/2ZpjkwwgIzpRK58Q==
X-Google-Smtp-Source: ABdhPJz1u6qbwoaJZheTGOE/yWjZsHppvPbeFQSqMWl5m2COvz7P/6KybgQMbqMNvR1hwx9Mlf5AiuPH/dtY67MKS2U=
X-Received: by 2002:a05:6402:b8a:: with SMTP id cf10mr316218edb.130.1605782242632;
 Thu, 19 Nov 2020 02:37:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:380d:0:0:0:0:0 with HTTP; Thu, 19 Nov 2020 02:37:21
 -0800 (PST)
X-Originating-IP: [5.35.99.104]
In-Reply-To: <20201119101215.19223-2-claudiu.manoil@nxp.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com> <20201119101215.19223-2-claudiu.manoil@nxp.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 19 Nov 2020 13:37:21 +0300
Message-ID: <CAOJe8K1ccPn8fJc1bfNwt2O7Z2cYmCXiUmytgp-O4RUO5GhC3Q@mail.gmail.com>
Subject: Re: [PATCH net-next resend 1/2] enetc: Fix endianness issues for enetc_ethtool
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/20, Claudiu Manoil <claudiu.manoil@nxp.com> wrote:
> These particular fields are specified in the H/W reference
> manual as having network byte order format, so enforce big
> endian annotation for them and clear the related sparse
> warnings in the process.
>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_hw.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> index 68ef4f959982..04efccd11162 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -472,10 +472,10 @@ struct enetc_cmd_rfse {
>  	u8 smac_m[6];
>  	u8 dmac_h[6];
>  	u8 dmac_m[6];
> -	u32 sip_h[4];
> -	u32 sip_m[4];
> -	u32 dip_h[4];
> -	u32 dip_m[4];
> +	__be32 sip_h[4];
> +	__be32 sip_m[4];
> +	__be32 dip_h[4];
> +	__be32 dip_m[4];
>  	u16 ethtype_h;
>  	u16 ethtype_m;
>  	u16 ethtype4_h;

Hi Claudiu,

Why the struct is declared without packed?
I'm seeing that the structure is used in dma transfers in the driver

> --
> 2.17.1
>
>
