Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C023F64EA
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239193AbhHXRIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239198AbhHXRGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:06:33 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F5BC0611C2;
        Tue, 24 Aug 2021 09:57:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a25so19014430ejv.6;
        Tue, 24 Aug 2021 09:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2CPHVf9LVvR1vrFypltnSkd8psChBds8RTv71kfke/g=;
        b=VAjjLhwy5EUDHkBFLS6IK/OURmv9p6XDFTIdDQrxNgXUrBpLHyjoRWx1AFS+Y9ZFZE
         mRbocH6GFcBOoMBfw7pBBf5/+E+jiKWVggYX8UAONU+90/q2JL6KG7NN1hm1VVp+arhk
         Gp1QFr/gXj2TMfaIL0cbP2rQdpetGkn7CRzK4TTvnG7ozydtXXZeFbqoG8PtqSTfiMhi
         OdNp4yn5RmtsHDIlJ6COOuyS95a0NexigEqGT9waGhePHJUaIlFKEZ+9pH1OtcVBUv8X
         QmM+/lk9ypH1T1kLaKyRfysicQVTli907NmoOIBhuMqo6bTgJyfSmfbaIM1wC5MrmZcW
         oFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2CPHVf9LVvR1vrFypltnSkd8psChBds8RTv71kfke/g=;
        b=spP50nPR79kqCYPi4GHbTsQ3+SX2yzVu8l8TLSuKeoQyZkg4pTyM9bECJGzc+AFx8n
         CD3Nc4QjPqbBZYOPDyVNBZoshfcOSeG35UrcF+iJTCq79uBaSLI0GVRNfiNlPSVfuWyj
         xn9PscPFZ3ZctWwnoEw6U0PxbJd22HVNHCyOgfpwvr5rZ3dv5Zo784pr5oSLI4nYalbD
         9azWw/ss4icqG24FiYJTPnkLuR865OM44bEoRhKQuhkMMvjOcCNov0o1BZP1ZtOTa0zn
         of8oSC19SfP9uSmpBxZNdHu39mWcf/1s9Xkl+E46ec200LfYqkrxqCq5QxeKFNWlgz11
         31jA==
X-Gm-Message-State: AOAM533bstC+CcjDAouKDncCsQhObCSbUKYqBxsih7MF3rwim2NqcsL/
        3/c2K7TY2BgfdmlyLiHKz/M=
X-Google-Smtp-Source: ABdhPJz35lI7gG+zU2usTviK/+6HHY2TQK8d1wdwtxQLUYeHHWpj4yZQVaxPxFC2dCOBTq1kpsr9lw==
X-Received: by 2002:a17:906:374e:: with SMTP id e14mr20474775ejc.161.1629824264492;
        Tue, 24 Aug 2021 09:57:44 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c19sm6732518ejs.116.2021.08.24.09.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 09:57:44 -0700 (PDT)
Date:   Tue, 24 Aug 2021 19:57:42 +0300
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
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mt7530: manually set up VLAN ID 0
Message-ID: <20210824165742.xvkb3ke7boryfoj4@skbuf>
References: <20210824165253.1691315-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824165253.1691315-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 12:52:52AM +0800, DENG Qingfang wrote:
> The driver was relying on dsa_slave_vlan_rx_add_vid to add VLAN ID 0. After
> the blamed commit, VLAN ID 0 won't be set up anymore, breaking software
> bridging fallback on VLAN-unaware bridges.
> 
> Manually set up VLAN ID 0 to fix this.
> 
> Fixes: 06cfb2df7eb0 ("net: dsa: don't advertise 'rx-vlan-filter' when not needed")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

I understand that this is how you noticed the issue, but please remember
that one can always compile a kernel with CONFIG_VLAN_8021Q=n. So the
issue predates my patch by much longer. You might reconsider the Fixes:
tag in light of this, maybe the patch needs to be sent to stable.

>  drivers/net/dsa/mt7530.c | 25 +++++++++++++++++++++++++
>  drivers/net/dsa/mt7530.h |  2 ++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index d757d9dcba51..d0cba2d1cd68 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1599,6 +1599,21 @@ mt7530_hw_vlan_update(struct mt7530_priv *priv, u16 vid,
>  	mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, vid);
>  }
>  
> +static int
> +mt7530_setup_vlan0(struct mt7530_priv *priv)
> +{
> +	u32 val;
> +
> +	/* Validate the entry with independent learning, keep the original
> +	 * ingress tag attribute.
> +	 */
> +	val = IVL_MAC | EG_CON | PORT_MEM(MT7530_ALL_MEMBERS) | FID(FID_BRIDGED) |

FID_BRIDGED?

> +	      VLAN_VALID;
> +	mt7530_write(priv, MT7530_VAWD1, val);
> +
> +	return mt7530_vlan_cmd(priv, MT7530_VTCR_WR_VID, 0);
> +}
> +
>  static int
>  mt7530_port_vlan_add(struct dsa_switch *ds, int port,
>  		     const struct switchdev_obj_port_vlan *vlan,
> @@ -2174,6 +2189,11 @@ mt7530_setup(struct dsa_switch *ds)
>  			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
>  
> +	/* Setup VLAN ID 0 for VLAN-unaware bridges */
> +	ret = mt7530_setup_vlan0(priv);
> +	if (ret)
> +		return ret;
> +
>  	/* Setup port 5 */
>  	priv->p5_intf_sel = P5_DISABLED;
>  	interface = PHY_INTERFACE_MODE_NA;
> @@ -2346,6 +2366,11 @@ mt7531_setup(struct dsa_switch *ds)
>  			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
>  	}
>  
> +	/* Setup VLAN ID 0 for VLAN-unaware bridges */
> +	ret = mt7530_setup_vlan0(priv);
> +	if (ret)
> +		return ret;
> +
>  	ds->assisted_learning_on_cpu_port = true;
>  	ds->mtu_enforcement_ingress = true;
>  
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index fe4cd2ac26d0..91508e2feef9 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -145,6 +145,8 @@ enum mt7530_vlan_cmd {
>  #define  PORT_STAG			BIT(31)
>  /* Independent VLAN Learning */
>  #define  IVL_MAC			BIT(30)
> +/* Egress Tag Consistent */
> +#define  EG_CON				BIT(29)
>  /* Per VLAN Egress Tag Control */
>  #define  VTAG_EN			BIT(28)
>  /* VLAN Member Control */
> -- 
> 2.25.1
> 
