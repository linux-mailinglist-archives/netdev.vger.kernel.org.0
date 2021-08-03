Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717803DF090
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbhHCOoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbhHCOoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:44:05 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E8BC0617A3;
        Tue,  3 Aug 2021 07:43:48 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gs8so36677403ejc.13;
        Tue, 03 Aug 2021 07:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=21UEaA5NxYYRGJ/hxwmq634fV1jMJGF++85jofJtE4A=;
        b=Q4oH2X4OQYM73if3DK/fZ+5YpoM9OTrVM+kYPYrIMzB92rcHm/00kpquUGrft3M6Aq
         bhog5UVno6hGuaED69POea7w3kKwejBNU7W4OFPcWxF3DYJOVA9wCODq6ljR8oB/Xqlq
         CixV30eSX2w8G1JCJkff317rU62YhLloYVuz0tIErdz4OEWfrs8GY4N9I0/zXb6OpHD2
         5LmCa/uXKuUFxtym0ZiM8YUE+TRaKAtwLRnmIlBQ/ytnN8IANA/MDIO9tr02tEOX2kMC
         AXih8MH8W/HtLxJH9iEafug5VMjfm6+tx7JJaWwJhcz+xFlrAjuPKPqv5Axc1VWQk8qi
         KJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=21UEaA5NxYYRGJ/hxwmq634fV1jMJGF++85jofJtE4A=;
        b=iD04e0mSxLnCjQAGT3X3bBk8p3gJN9Otah6JntAoSzDyu1thIEgLTzEQZ9oarCqhOB
         pht54ETuoJyKlD/lEueYIa8caue2jU4Z+RKQ/5/H1CgkqBHrVAWF3qZlC7C2tm05RfAt
         56fl+0Gj2I6oPtHxgq5GKGq2bRE9yCbB9KdoHatffdjwAoMDhqSYjh7nprTq8nXujWct
         0BiPWdnqNALYcDFmfH+w/NKhGTFzHhS6EGD6QqMeKkZMg/bAplZHcqUY8VgKu4iRA4br
         BYCWk/FVSmTy8W5kF1RtIoHVWvLdI09KGf9LpTVKNoL8rQVwWgO13sy+zbrS+Vd2QHEE
         xjgg==
X-Gm-Message-State: AOAM530kjmBZQt1rDYPr0eV1fAQVoAoEwm1MKtixq6kYPeLHNAZtnGaJ
        bh8y84F+J6Wbd4h6qdkTIU0=
X-Google-Smtp-Source: ABdhPJxBxb7VU3wDfc3Bj+zyEzT3+H5FmMb9p5alU9qeXPwGhB2s1WjRkH53fmF9Kynm+p4O7FWrrg==
X-Received: by 2002:a17:906:2dc5:: with SMTP id h5mr10464333eji.515.1628001827204;
        Tue, 03 Aug 2021 07:43:47 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id dg20sm8120790edb.13.2021.08.03.07.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:43:46 -0700 (PDT)
Date:   Tue, 3 Aug 2021 17:43:45 +0300
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
Subject: Re: [PATCH net-next 3/4] net: dsa: mt7530: set STP state on filter
 ID 1
Message-ID: <20210803144345.jmucndmrflnqlfo3@skbuf>
References: <20210803124022.2912298-1-dqfext@gmail.com>
 <20210803124022.2912298-4-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803124022.2912298-4-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:40:21PM +0800, DENG Qingfang wrote:
> As filter ID 1 is the only one used for bridges, set STP state on it.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC -> v1: only set FID 1's state
> 
>  drivers/net/dsa/mt7530.c | 3 ++-
>  drivers/net/dsa/mt7530.h | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 12f449a54833..8d84d7ddad38 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1147,7 +1147,8 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  		break;
>  	}
>  
> -	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
> +	mt7530_rmw(priv, MT7530_SSP_P(port), FID1_PST_MASK,
> +		   FID1_PST(stp_state));
>  }
>  
>  static int
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index a308886fdebc..53b7bb1f5368 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -181,8 +181,8 @@ enum mt7530_vlan_egress_attr {
>  
>  /* Register for port STP state control */
>  #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
> -#define  FID_PST(x)			((x) & 0x3)
> -#define  FID_PST_MASK			FID_PST(0x3)
> +#define  FID1_PST(x)			(((x) & 0x3) << 2)
> +#define  FID1_PST_MASK			FID1_PST(0x3)

Not a reason to resend, but I still would have expected a macro:

#define FID_PST(fid, state)		((state) & 0x3) << ((fid) * 2)
#define FID_PST_MASK(fid)		FID_PST(fid, 0x3)

#define FID_STANDALONE			0
#define FID_BRIDGED			1

and called with:

	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK(FID_BRIDGED),
		   FID_PST(FID_BRIDGED, stp_state));

>  
>  enum mt7530_stp_state {
>  	MT7530_STP_DISABLED = 0,
> -- 
> 2.25.1
> 

Anyhow.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
