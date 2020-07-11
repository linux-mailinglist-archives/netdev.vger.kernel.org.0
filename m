Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2197421C6AE
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 01:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGKXTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 19:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgGKXTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 19:19:43 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4129C08C5DD;
        Sat, 11 Jul 2020 16:19:42 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so10195386ejc.8;
        Sat, 11 Jul 2020 16:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mStXnp/SmkzvT0Fl4Wmo68hNfOn131BHCllSW8c4OE8=;
        b=tUg3QFcMP3HvbwT0/5qBEzoXID4WYdW5CbjRCt/pfzYuexj+Y525yp+QObN0QIdS6e
         owp2y4/ToJMnSFZXklLVQQYP7eZ6n6w1AZpFWYX46zOV6XVnaIqt6XgCLU3M779f98op
         Fj8YrF0N+X5FicbbLKz8Egxshpg6UNBAUZy0uPW1o88PlGTnuI5AkqYbZMKHr9fykYOy
         H8t7zUd95MY6iYwltcXethpLWO9Cw3/yKHfbos5sHjyIYdCIoYwimLgUeW+/83ezIXgu
         e/+9OOaT0wOX+6CxYwAtKq+pcPlufFrzpCh0zzSXJLkiSeu8O2ilp0EPN57+CQKsPJpJ
         Vtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mStXnp/SmkzvT0Fl4Wmo68hNfOn131BHCllSW8c4OE8=;
        b=iq4rtf5uRgym7d0YK7dgFXcp5LrYhCiU1Q3gY6WQK7PP3ZaF1G+WMzdiDpb7qPRwcd
         2rllF/EROcPvaB5I/WVPU4FlVdBSXsX1pZ3kqH4rvbyOwoTxWjMs4X9IFvTNWuPmmSvD
         BWgKsJoo/EFyc/UdUBTeSMJCmSDfNsVvdTO0kpevW+QmW2w0R5mJqbvmex6VLDKOotvP
         EuYCSluUVpn9YLwdstWwB6gsgHCA5FDVrKkv+svbRRYKHL/sbKfEXUbosGDQxc4YD/DL
         e5nOsI8Ms+kfsNEzHeW77wSCMYUD2m+pfjOyTDdUOFa8fIRd7YdclurI7D3OUdcxO0If
         IJZQ==
X-Gm-Message-State: AOAM531hs6DHrwI21eAQYU4rYxTwr1QpLAIuOsYqfOfigZ0v3dchCFVu
        BWj9ckT7PgD/VyZiA50Y9kA=
X-Google-Smtp-Source: ABdhPJx/FqQRkidC7vfAzlHTR1kPS/Dy8FM97IHngdxCJQW93VMmXdVwh/4FfI4hM0i76/wOJfyFFQ==
X-Received: by 2002:a17:906:7709:: with SMTP id q9mr10249158ejm.123.1594509581172;
        Sat, 11 Jul 2020 16:19:41 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id n9sm7983490edr.46.2020.07.11.16.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 16:19:40 -0700 (PDT)
Date:   Sun, 12 Jul 2020 02:19:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200711231937.wu2zrm5spn7a6u2o@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711120842.2631-1-sorganov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Sat, Jul 11, 2020 at 03:08:42PM +0300, Sergey Organov wrote:
> Fix support for external PTP-aware devices such as DSA or PTP PHY:
> 
> Make sure we never time stamp tx packets when hardware time stamping
> is disabled.
> 
> Check for PTP PHY being in use and then pass ioctls related to time
> stamping of Ethernet packets to the PTP PHY rather than handle them
> ourselves. In addition, disable our own hardware time stamping in this
> case.
> 
> Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")

Please use a 12-character sha1sum. Try to use the "pretty" format
specifier I gave you in the original thread, it saves you from counting,
and also from people complaining once it gets merged:

https://www.google.com/search?q=stephen+rothwell+%22fixes+tag+needs+some+work%22

> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> ---
> 
> v2:
>   - Extracted from larger patch series
>   - Description/comments updated according to discussions
>   - Added Fixes: tag
> 
>  drivers/net/ethernet/freescale/fec.h      |  1 +
>  drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++++++++++------
>  drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
>  3 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index d8d76da..832a217 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -590,6 +590,7 @@ struct fec_enet_private {
>  void fec_ptp_init(struct platform_device *pdev, int irq_idx);
>  void fec_ptp_stop(struct platform_device *pdev);
>  void fec_ptp_start_cyclecounter(struct net_device *ndev);
> +void fec_ptp_disable_hwts(struct net_device *ndev);
>  int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
>  int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
>  
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 3982285..cc7fbfc 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1294,8 +1294,13 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>  			ndev->stats.tx_bytes += skb->len;
>  		}
>  
> -		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> -			fep->bufdesc_ex) {
> +		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
> +		 * are to time stamp the packet, so we still need to check time
> +		 * stamping enabled flag.
> +		 */
> +		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS &&
> +			     fep->hwts_tx_en) &&
> +		    fep->bufdesc_ex) {
>  			struct skb_shared_hwtstamps shhwtstamps;
>  			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
>  
> @@ -2723,10 +2728,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
>  		return -ENODEV;
>  
>  	if (fep->bufdesc_ex) {
> -		if (cmd == SIOCSHWTSTAMP)
> -			return fec_ptp_set(ndev, rq);
> -		if (cmd == SIOCGHWTSTAMP)
> -			return fec_ptp_get(ndev, rq);
> +		bool use_fec_hwts = !phy_has_hwtstamp(phydev);

I thought we were in agreement that FEC does not support PHY
timestamping at this point, and this patch would only be fixing DSA
switches (even though PHYs would need this fixed too, when support is
added for them)? I would definitely not introduce support (and
incomplete, at that) for a new feature in a bugfix patch.

But it looks like we aren't.

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

This is not really needed, is it?
- PHY ability of hwtstamping does not change across the runtime of the
  kernel (or do you have a "special" one where it does?)
- The initial values for hwts_tx_en and hwts_rx_en are already 0
- There is no code path for which it is possible for hwts_tx_en or
  hwts_rx_en to have been non-zero prior to this call making them zero.

It is just "to be sure", in a very non-necessary way.

But nonetheless, it shouldn't be present in this patch either way, due
to the fact that one patch should have one topic only, and the topic of
this patch should be solving a clearly defined bug.

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

Thanks,
-Vladimir
