Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140113DF09C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhHCOsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbhHCOre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:47:34 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D87C0617BA;
        Tue,  3 Aug 2021 07:45:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x90so29266434ede.8;
        Tue, 03 Aug 2021 07:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nLjEw0HuIJj34h6UU+m/vkoLg+whogx5QH5dKh0TA1A=;
        b=aRSQXGQlKK76xI1w7OSHP7cBvNpZGU15KzeZeqH3cDl0kUuLvC+B6xNdkO9Clg7xz0
         mPshYEYJEX5GYkJKW7r4yuNGmHjdkF+m5umM/PFmOzyqBgRTRR5CNp+rUE+SlNE4Izb1
         3Q+KGc8vOZ/yq/Ya8otsRjhq7+jGjifH2quonMlY8pcsnROXYXZ8GhfQ3tllyodcKEtv
         Py4WnMQOxX3kgM7a1VeVrXRBGi13NRSfswqfY6Cy92vh1T2Md6dY9sjFEonJpzNcIymp
         CbUzCMHCa58RAmB3KpdrbD3NlmQwJSg/jDo+gBnTEMidK4w+eqYJWRXK0H1qvapkj7IJ
         1cSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nLjEw0HuIJj34h6UU+m/vkoLg+whogx5QH5dKh0TA1A=;
        b=PNPEp/trV5b/ilhsUtJS71SKtY4MQL2irHqXx4DOQM7uLVBNrISkv1ryahwcg1wL9l
         AFdrUmeG38LoCoNFymA8Krr+eDdyWkTEWuDRRR6O0ks9HHz9bwpoiVICRhSmJGGpMfCa
         F9+wDJefqJieMJz3cla5uovd4WqPxbNF+ZZi5zsuPG6p68PQa2U+/vN9Gqc0e4lkpNlB
         RpAzyP6nW824EIurQRh0CY/UCytXz31G56K7qd+0MStQkDRNFFIn/+C5ENW0VwTo49ka
         nNF6+tVOY7akOPcD7Dtb+25xkEOLm59/TEAkKdfpMklyYTo145yvLawQp0QFKXjiGx6a
         Yfhw==
X-Gm-Message-State: AOAM531/kKpfKqrbQCEGEmXdSV0lu0W15JYbrvZchI/9MS9mHLcv4U2U
        ZxcncnP+beYpoUcnf9ufw58=
X-Google-Smtp-Source: ABdhPJysB/KYPljDZl8pqFu38R/m8VQYjciFVwRM65/pDUF9OZlb1yM/kbSAt6w9AUrYvkrXO4OxWw==
X-Received: by 2002:a05:6402:270f:: with SMTP id y15mr25959942edd.65.1628001954301;
        Tue, 03 Aug 2021 07:45:54 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id cm1sm8246886edb.68.2021.08.03.07.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:45:53 -0700 (PDT)
Date:   Tue, 3 Aug 2021 17:45:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: mt7530: always install FDB
 entries with IVL and FID 1
Message-ID: <20210803144552.fluxxfoey2tbqyyu@skbuf>
References: <20210803124022.2912298-1-dqfext@gmail.com>
 <20210803124022.2912298-5-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803124022.2912298-5-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:40:22PM +0800, DENG Qingfang wrote:
> This reverts commit 7e777021780e ("mt7530 mt7530_fdb_write only set ivl
> bit vid larger than 1").
> 
> Before this series, the default value of all ports' PVID is 1, which is
> copied into the FDB entry, even if the ports are VLAN unaware. So
> `bridge fdb show` will show entries like `dev swp0 vlan 1 self` even on
> a VLAN-unaware bridge.
> 
> The blamed commit does not solve that issue completely, instead it may
> cause a new issue that FDB is inaccessible in a VLAN-aware bridge with
> PVID 1.
> 
> This series sets PVID to 0 on VLAN-unaware ports, so `bridge fdb show`
> will no longer print `vlan 1` on VLAN-unaware bridges, and that special
> case in fdb_write is not required anymore.
> 
> Set FDB entries' filter ID to 1 to match the VLAN table.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC -> v1: Detailed commit message. Also set FDB entries' FID to 1.
> 
>  drivers/net/dsa/mt7530.c | 4 ++--
>  drivers/net/dsa/mt7530.h | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 8d84d7ddad38..ac2b45e472bd 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -366,8 +366,8 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
>  	int i;
>  
>  	reg[1] |= vid & CVID_MASK;
> -	if (vid > 1)
> -		reg[1] |= ATA2_IVL;
> +	reg[1] |= ATA2_IVL;
> +	reg[1] |= ATA2_FID(1);

Maybe it would be good to resend with a set of #defines for the
standalone/bridged port FID values after all, what do you think?

>  	reg[2] |= (aging & AGE_TIMER_MASK) << AGE_TIMER;
>  	reg[2] |= (port_mask & PORT_MAP_MASK) << PORT_MAP;
>  	/* STATIC_ENT indicate that entry is static wouldn't
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 53b7bb1f5368..73b0e0eb8f2f 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -80,6 +80,7 @@ enum mt753x_bpdu_port_fw {
>  #define  STATIC_ENT			3
>  #define MT7530_ATA2			0x78
>  #define  ATA2_IVL			BIT(15)
> +#define  ATA2_FID(x)			(((x) & 0x7) << 12)
>  
>  /* Register for address table write data */
>  #define MT7530_ATWD			0x7c
> -- 
> 2.25.1
> 

