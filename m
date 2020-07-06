Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412D0215A4D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgGFPIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFPIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:08:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97340C061755;
        Mon,  6 Jul 2020 08:08:18 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id rk21so42928702ejb.2;
        Mon, 06 Jul 2020 08:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+QV0foaqZfR1DGTEKz4tnb7W5JLiiR6E9hmIsjOaInY=;
        b=eRWNAlNZNgupqf/XW+C4vAF8eh7vePcdv6oiE8s87gxTkZGqEsEBbVe49Lo7v1QOQ2
         ClaMf13wmAfdlY42+jT8j75GvgKlLSERkFGMqLWFAQ0qDFmMLMYjOZmNHpiPUiEVGEHp
         z2gvRxZiE+vIwBs5q2owvrp41jdKlxe8+lVNIOq8jS/HEzDCe8dl7RgjgnxgJMHrLxd4
         Ef5V9EgzLH/X7CemCHZUCoBFI0FclmYdH5A3X8zWGiTqPuGiEWeByijAiazr/jYYd12K
         CZ5kQiHebxKZIwPySsxaS1zn0UW34MzusEH5AWPAyXMovZ1iYhMOM5H6u0WKyU9/LdWt
         9wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+QV0foaqZfR1DGTEKz4tnb7W5JLiiR6E9hmIsjOaInY=;
        b=fSIXlfHq1SewDLTsojM8xb9jTGSMKAuAeAReKs99N1LtRmZJK364rDEWpQlvaCR71M
         AFUhRuPtcKxnkP8SG2aU2/nq+DaWmB/rco857n8/oU7wCpM/EVNmS9hdcTmKU+ZvMLsV
         H7YWT6QdAuC7f3KTFWaTGe7UFPY/Slw7Feds7guzhGH3ARhau3gN8C1zW/7I+MzDSFF6
         B91aUPv4DecRf+JO2I+iMawj2eiFxvmXzeupFk31tqVqSdU6SaHw+oe0pqzjkWODsk1A
         QyAV7LfqnCjyZqDvsVY2R+swvuv8scybLY9KZcsQEGVH4HsjCqBD89+4hzUY6GJX22uM
         donw==
X-Gm-Message-State: AOAM532WNAtzoI3xAuif/HNw9gl3pEUfyno1A3JKxPbFcqtobNMDgRPY
        3jtFuF7tFNxjvIqTPFQ+I2U=
X-Google-Smtp-Source: ABdhPJx/FKMlLT2apCdXfjM3rMGs1ywVu/BWMY9t0TXGsw7WrkqfVEI3IC2yYq9h6CXPNq4nt2gS3A==
X-Received: by 2002:a17:906:2a91:: with SMTP id l17mr45311743eje.539.1594048097227;
        Mon, 06 Jul 2020 08:08:17 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id v5sm16730084ejj.61.2020.07.06.08.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:08:16 -0700 (PDT)
Date:   Mon, 6 Jul 2020 18:08:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     sorganov@gmail.com, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
Message-ID: <20200706150814.kba7dh2dsz4mpiuc@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-2-sorganov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706142616.25192-2-sorganov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Mon, Jul 06, 2020 at 05:26:12PM +0300, Sergey Organov wrote:
> When external PTP-aware PHY is in use, it's that PHY that is to time
> stamp network packets, and it's that PHY where configuration requests
> of time stamping features are to be routed.
> 
> To achieve these goals:
> 
> 1. Make sure we don't time stamp packets when external PTP PHY is in use
> 
> 2. Make sure we redirect ioctl() related to time stamping of Ethernet
>    packets to connected PTP PHY rather than handle them ourselves
> 
> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec.h      |  1 +
>  drivers/net/ethernet/freescale/fec_main.c | 18 ++++++++++++++----
>  drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
>  3 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index a6cdd5b6..de9f46a 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -595,6 +595,7 @@ struct fec_enet_private {
>  void fec_ptp_init(struct platform_device *pdev, int irq_idx);
>  void fec_ptp_stop(struct platform_device *pdev);
>  void fec_ptp_start_cyclecounter(struct net_device *ndev);
> +void fec_ptp_disable_hwts(struct net_device *ndev);
>  int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
>  int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
>  
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2d0d313..995ea2e 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1298,7 +1298,11 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>  			ndev->stats.tx_bytes += skb->len;
>  		}
>  
> +		/* It could be external PHY that had set SKBTX_IN_PROGRESS, so
> +		 * we still need to check it's we who are to time stamp
> +		 */
>  		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> +		    unlikely(fep->hwts_tx_en) &&

I think this could qualify as a pretty significant fix in its own right,
that should go to stable trees. Right now, this patch appears pretty
easy to overlook.

Is this the same situation as what is being described here for the
gianfar driver?

https://patchwork.ozlabs.org/project/netdev/patch/20191227004435.21692-2-olteanv@gmail.com/

If so, it is interesting because I thought we had agreed that it's only
DSA who suffers from the double-TX-timestamp design issue, not PHYTER.
Not to mention, interesting because FEC + a timestamping DSA switch such
as mv88e6xxx is not unheard of. Hmmm...

>  			fep->bufdesc_ex) {
>  			struct skb_shared_hwtstamps shhwtstamps;
>  			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
> @@ -2755,10 +2759,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
>  		return -ENODEV;
>  
>  	if (fep->bufdesc_ex) {
> -		if (cmd == SIOCSHWTSTAMP)
> -			return fec_ptp_set(ndev, rq);
> -		if (cmd == SIOCGHWTSTAMP)
> -			return fec_ptp_get(ndev, rq);
> +		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
> +
> +		if (cmd == SIOCSHWTSTAMP) {
> +			if (use_fec_hwts)
> +				return fec_ptp_set(ndev, rq);
> +			fec_ptp_disable_hwts(ndev);
> +		} else if (cmd == SIOCGHWTSTAMP) {
> +			if (use_fec_hwts)
> +				return fec_ptp_get(ndev, rq);
> +		}
>  	}
>  
>  	return phy_mii_ioctl(phydev, rq, cmd);
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index 945643c..f8a592c 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -452,6 +452,18 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
>  	return -EOPNOTSUPP;
>  }
>  
> +/**
> + * fec_ptp_disable_hwts - disable hardware time stamping
> + * @ndev: pointer to net_device
> + */
> +void fec_ptp_disable_hwts(struct net_device *ndev)
> +{
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +
> +	fep->hwts_tx_en = 0;
> +	fep->hwts_rx_en = 0;
> +}
> +
>  int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> -- 
> 2.10.0.1.g57b01a3
> 

Cheers,
-Vladimir
