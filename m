Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834AC3238DF
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhBXIn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBXInK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:43:10 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05BDC06174A;
        Wed, 24 Feb 2021 00:42:29 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id hs11so1665593ejc.1;
        Wed, 24 Feb 2021 00:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XVG9kkpo/lXRBZutmGYmQBFfXrsF0BkcDwDodruvH/c=;
        b=rafZ6ScglMDahYvRIlpX2R5wkAI9vtSwEx4LGzYdK88Szfo3hqY+8beG5h+XBbyTYZ
         gN+k68/9zGJu5rR1rHltKG8X8CTZffU0B1ICjjfp6lMRE4N9+RC7SFVkYWuEIO/GkfRB
         5fzuUZB7AIPoAbYYfTKakHRogP0MTRH4DAtJEf0BlhkASlzsgo0O1D+WZrSOvbOX6UBo
         HIUxzhi9v5znmgZaFB2RtJ7u2BVg5fYx6En1Xfv0cuhpbdpzCW+e2ssVVJkebNLognUH
         +pkUISgDyEGLZt/IPGltODNcz5/BtU+1o+h/t/W1irL+K7FkAtn67v/JwjdX96AEqyVC
         MSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XVG9kkpo/lXRBZutmGYmQBFfXrsF0BkcDwDodruvH/c=;
        b=ryWpyhAK32+rF2LdDLPVlsSK0U8g/YB7ZatJhk25Rjvh2JUmGNkq25Z/CSetm4v9ww
         /Hrst0zIjJ27B/f7PGVqTODaobIjXGYdyWlfstdot45ul+3b+uHwsatP1RBnTQDJhUPZ
         F/RjfMobUF1bkPG5/YaHYIFagqpM33EiRK65AUA/BI5qjwNZBh9LGtEIVvJejC2+Ai53
         oHTlqyT6oihkYU4S6Y5D4W5HCnYVqlWJhoKQsyALmJA93iCsoeZmRVIkvhoJucxhADs5
         /ZJnk2W7xDBX5gG6wfOOa8AVx3o3pRix+cnnK7iTz6EsdvMejmj5qZcsvTDPHzP3dgha
         DBQQ==
X-Gm-Message-State: AOAM531R8HVV+AOCO2xXmWZXEGG+yNMhFIXgazGmWxoIbglStRsW/84l
        ayEV9Z/VlJoRFR384Z+iUpo=
X-Google-Smtp-Source: ABdhPJz9qlNumriQMVcc5+WWdSZbUlP/J55REHufHMwlsZDBxMiiGgA9Jk88kJX7NGlU+EEblwLHIA==
X-Received: by 2002:a17:906:3786:: with SMTP id n6mr15645084ejc.496.1614156148700;
        Wed, 24 Feb 2021 00:42:28 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id f11sm790947eje.107.2021.02.24.00.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:42:28 -0800 (PST)
Date:   Wed, 24 Feb 2021 10:42:26 +0200
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
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [RFC net-next] net: dsa: mt7530: support MDB and bridge flag
 operations
Message-ID: <20210224084226.idtvqtdpl5vbstup@skbuf>
References: <20210224081018.24719-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224081018.24719-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 04:10:18PM +0800, DENG Qingfang wrote:
> Support port MDB and bridge flag operations.
> 
> As the hardware can manage multicast forwarding itself, offload_fwd_mark
> can be unconditionally set to true.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> Changes:
> Add bridge flag operations and resend as RFC
> 
>  drivers/net/dsa/mt7530.c | 123 +++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/mt7530.h |   1 +
>  net/dsa/tag_mtk.c        |  14 +----
>  3 files changed, 121 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index bca4fc724e45..341a6b3f7ef6 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1000,8 +1000,9 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  	mt7530_write(priv, MT7530_PVC_P(port),
>  		     PORT_SPEC_TAG);
>  
> -	/* Unknown multicast frame forwarding to the cpu port */
> -	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
> +	/* Disable flooding by default */

I think the comment is incorrect and this _enables_ flooding (which btw
is ok until we get the address filtering thing sorted out).

> +	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
> +		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
>  
>  	/* Set CPU port number */
>  	if (priv->id == ID_MT7621)
> @@ -1138,6 +1139,55 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
>  }
>  
> +static int
> +mt7530_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> +			     struct switchdev_brport_flags flags,
> +			     struct netlink_ext_ack *extack)
> +{
> +	if (flags.mask & ~(BR_AUTO_MASK | BR_MCAST_FLOOD | BR_BCAST_FLOOD))
> +		return -EINVAL;

I think BR_AUTO_MASK is confusing (because it is internal to the bridge
layer) and could be better expressed as BR_FLOOD | BR_LEARNING.

> +
> +	return 0;
> +}
> +
