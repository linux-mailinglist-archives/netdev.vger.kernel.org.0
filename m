Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B16D8EF5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404857AbfJPLH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:07:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40211 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbfJPLH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:07:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so2277463wmj.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 04:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y4I2x7tWbjHIR6xTqmE1PmJ0AHLSUiZ9eMRjokfF2f0=;
        b=nAyv7Qvv1dZv+r7nArBKVE2s5tuoW8GeBlFmiiCW9xJp8gffcVYwwgmec14C0cFbyF
         2k4PdOGE69GZ4s3uy46kSagz42tsdqmH+CLCDSdedH0sXcGhndyXrV741iXe4yX8FRCx
         XGqmVQEAcYVEHsziUBtsD+bXlVhUOEZ41rF2ug6qZ1eNRjR3VtmuvR+0BROaqA9il5vR
         ToG08pbJj+JW/GjSNl7ue9hcWuJEro2L7Jcv9IjJhA1JspXicRo9ICYe0v1N9MY+bdgF
         z26VvoEVxlUmLkIeGgj2CadhwSee0u6UTKQfxLYQ7kMAQ9/oInukvpWT2eThrJsGrgOy
         4APQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y4I2x7tWbjHIR6xTqmE1PmJ0AHLSUiZ9eMRjokfF2f0=;
        b=JUTmAeRJqBQemzGMBU1v2ZQVb8ThrWEofTlhZzC3K8vOsiQrHRhN1oFcCq2B2zRC3v
         wS+Zcl0+5tViSiIbukNCc57hmF4N+DgI+grmmLGWgnQ1U5ZfSGp2DnTojR2d00VaD8A5
         IrnW3lBr4MR2ZwV4ptGkj8gYHiqAfidWruhiGbePYf1Y3W2ffzFiXHfgLGLzldych3ra
         9g8ZAvvgqMYrD+EVKNPF9v9QY0Hz/0gLVCq/M1ytcli1s32+DfCjQ7FRlfEcitFj+1eH
         AErQVqC6PeRaRDUT9kTlndM+XMQQnyCCY1JkKXFL2vF1QaIFVRTehI1L6v8yj8ssTKdN
         KF6A==
X-Gm-Message-State: APjAAAXiyi1lOgS6MCrQCUoRikY1m0WsY03bvJ+vt6KNJ1COGYkccuUV
        7GoJBdv6DVcHMj93sxGNxb+Yow==
X-Google-Smtp-Source: APXvYqzHrsCUSfOEd3jBzMVXytMECiSrtKiRxzvKrzB6clcSVqBaSh1yDxrE/wpb8ElLYbGXFQAQdw==
X-Received: by 2002:a1c:48d6:: with SMTP id v205mr2717744wma.35.1571224074980;
        Wed, 16 Oct 2019 04:07:54 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id e18sm34085839wrv.63.2019.10.16.04.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 04:07:54 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:07:52 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        netdev@vger.kernel.org,
        Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
Subject: Re: [PATCH v3 net 1/2] dpaa2-eth: add irq for the dpmac
 connect/disconnect event
Message-ID: <20191016110751.rkt3tgdlkxjf4ip3@netronome.com>
References: <1571211383-5759-1-git-send-email-ioana.ciornei@nxp.com>
 <1571211383-5759-2-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571211383-5759-2-git-send-email-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 10:36:22AM +0300, Ioana Ciornei wrote:
> From: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> 
> Add IRQ for the DPNI endpoint change event, resolving the issue
> when a dynamically created DPNI gets a randomly generated hw address
> when the endpoint is a DPMAC object.
> 
> Signed-off-by: Florin Chiculita <florinlaurentiu.chiculita@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - none
> Changes in v3:
>  - none
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++++-
>  drivers/net/ethernet/freescale/dpaa2/dpni.h      | 5 ++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 162d7d8fb295..5acd734a216b 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -3306,6 +3306,9 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
>  	if (status & DPNI_IRQ_EVENT_LINK_CHANGED)
>  		link_state_update(netdev_priv(net_dev));
>  
> +	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED)
> +		set_mac_addr(netdev_priv(net_dev));
> +
>  	return IRQ_HANDLED;
>  }
>  
> @@ -3331,7 +3334,8 @@ static int setup_irqs(struct fsl_mc_device *ls_dev)
>  	}
>  
>  	err = dpni_set_irq_mask(ls_dev->mc_io, 0, ls_dev->mc_handle,
> -				DPNI_IRQ_INDEX, DPNI_IRQ_EVENT_LINK_CHANGED);
> +				DPNI_IRQ_INDEX, DPNI_IRQ_EVENT_LINK_CHANGED |
> +				DPNI_IRQ_EVENT_ENDPOINT_CHANGED);
>  	if (err < 0) {
>  		dev_err(&ls_dev->dev, "dpni_set_irq_mask(): %d\n", err);
>  		goto free_irq;
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
> index fd583911b6c0..ee0711d06b3a 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
> @@ -133,9 +133,12 @@ int dpni_reset(struct fsl_mc_io	*mc_io,
>   */
>  #define DPNI_IRQ_INDEX				0
>  /**
> - * IRQ event - indicates a change in link state
> + * IRQ events:
> + *       indicates a change in link state
> + *       indicates a change in endpoint
>   */
>  #define DPNI_IRQ_EVENT_LINK_CHANGED		0x00000001
> +#define DPNI_IRQ_EVENT_ENDPOINT_CHANGED		0x00000002

Perhaps (as a follow-up?) this is a candidate for using the BIT() macro.

>  
>  int dpni_set_irq_enable(struct fsl_mc_io	*mc_io,
>  			u32			cmd_flags,
> -- 
> 1.9.1
> 
