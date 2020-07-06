Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245E3215B1C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgGFPrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729321AbgGFPrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:47:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D76C061755;
        Mon,  6 Jul 2020 08:47:32 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a1so43068775ejg.12;
        Mon, 06 Jul 2020 08:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GgEH+thtSKg/or9HUMra9bnT61TmLhwCmU7Zb8ZLTGY=;
        b=qxDMYEtajR3ujNHhFHo3vjLOrgRHHTEldmv9gu8mn26xgHWx2zNJDjANX+N/ixlwNs
         P2siORRQ3w5lJnN2U7p0h2LUnJHgPsQi0dpEx57aKedj1ZWnh6iQHpxMmdhbrnveUabq
         //QmwG1QqC3Kk9DorpFWivKMsDAsXf70MjVod+QU9nsnq+1LUXSEizL3a3ticr9WYNeB
         27Dc39tXbuGm9lvh2cSjvdhpls7Uy0s3siQRp9o/utxt2B2OD87Luaspsk1WzmvzD1a9
         v/6KEHcwmNxO+ApZsetgr5LrqOnrpHN7H+YHUuxXSKzAj2EOrBxr3JzhHmN5UWPD2Oky
         H9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GgEH+thtSKg/or9HUMra9bnT61TmLhwCmU7Zb8ZLTGY=;
        b=QzRyeWZEkBhIB8rnFBxL6DpKQNd0aUW+iXsG89jmnFjUahFI+tO1G0k8zAWzGBw+gN
         C3cbYbmO99Zl8LoZo742tvIIcEiSn56hEvcGNg2TF59huRCVBks39NbPE4ymF1gV9vqo
         jrhw3OfgCrfznKwpn2WpMWSD0WRFwvjrafz7T/Gwco5Y+KkF3wVrPdcbQA2bQq0rdVaN
         0V6tqZKNYiM2j3NHPJFHpl/DbN7TF9RMXwFxcCwrMOiDGDYnT3HCAFjWxBZXmcaKOVPp
         FCEy9ogDJUdxnyWB3UX0RnD+r3mK7mv++pEfhvQ10/YqCp4wxQyfPCMFKrZb8CWL2bCh
         tR6A==
X-Gm-Message-State: AOAM530l86uosfNDg6Mb0rvc3nfJuH63HAyGRqx5BXqDeeraCt7FE36F
        x9NUNbSpQlcBIz3I1fOBn40=
X-Google-Smtp-Source: ABdhPJzBSrCrbMVxgvim0NIed6j+Pj+XoRe75JSR/2ZA2aXEC1y61HJ/sz2KqI4Y2rhAFcsjth48xQ==
X-Received: by 2002:a17:907:2058:: with SMTP id pg24mr46160600ejb.79.1594050450849;
        Mon, 06 Jul 2020 08:47:30 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id n9sm20924913edr.46.2020.07.06.08.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:47:30 -0700 (PDT)
Date:   Mon, 6 Jul 2020 18:47:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
Message-ID: <20200706154728.lfywhchrtaeeda4g@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-2-sorganov@gmail.com>
 <20200706150814.kba7dh2dsz4mpiuc@skbuf>
 <87zh8cu0rs.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh8cu0rs.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 06:21:59PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > Hi Sergey,
> >
> > On Mon, Jul 06, 2020 at 05:26:12PM +0300, Sergey Organov wrote:
> >> When external PTP-aware PHY is in use, it's that PHY that is to time
> >> stamp network packets, and it's that PHY where configuration requests
> >> of time stamping features are to be routed.
> >> 
> >> To achieve these goals:
> >> 
> >> 1. Make sure we don't time stamp packets when external PTP PHY is in use
> >> 
> >> 2. Make sure we redirect ioctl() related to time stamping of Ethernet
> >>    packets to connected PTP PHY rather than handle them ourselves
> 
> [...]
> 
> >> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> >> index 2d0d313..995ea2e 100644
> >> --- a/drivers/net/ethernet/freescale/fec_main.c
> >> +++ b/drivers/net/ethernet/freescale/fec_main.c
> >> @@ -1298,7 +1298,11 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
> >>  			ndev->stats.tx_bytes += skb->len;
> >>  		}
> >>  
> >> +		/* It could be external PHY that had set SKBTX_IN_PROGRESS, so
> >> +		 * we still need to check it's we who are to time stamp
> >> +		 */
> >>  		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> >> +		    unlikely(fep->hwts_tx_en) &&
> >
> > I think this could qualify as a pretty significant fix in its own right,
> > that should go to stable trees. Right now, this patch appears pretty
> > easy to overlook.
> >
> > Is this the same situation as what is being described here for the
> > gianfar driver?
> >
> > https://patchwork.ozlabs.org/project/netdev/patch/20191227004435.21692-2-olteanv@gmail.com/
> 
> Yes, it sounds exactly like that!
> 

Cool. Join the club! You were lucky though, in your case it was pretty
evident where the problem might be, so you were already on your way even
though you didn't know exactly what was going on.

Towards the point that you brought up in that thread:

> Could somebody please help me implement (or point me to) proper fix to
> reliably use external PHY to timestamp network packets?

We do it like this:
- DSA: If there is a timestamping switch stacked on top of a
  timestamping Ethernet MAC, the switch hijacks the .ndo_do_ioctl of the
  host port, and you are supposed to use the PTP clock of the switch,
  through the .ndo_do_ioctl of its own (virtual) net devices. This
  approach works without changing any code in each individual Ethernet
  MAC driver.
- PHY: The Ethernet MAC driver needs to be kind enough to check whether
  the PHY supports hw timestamping, and pass this ioctl to that PHY
  while making sure it doesn't do anything stupid in the meanwhile, like
  also acting upon that timestamping request itself.

Both are finicky in their own ways. There is no real way for the user to
select which PHC they want to use. The assumption is that you'd always
want to use the outermost one, and that things in the kernel side always
collaborate towards that end.

> However, I'd insist that the second part of the patch is as important.
> Please refer to my original post for the description of nasty confusion
> the second part of the patch fixes:
> 
> https://lore.kernel.org/netdev/87r1uqtybr.fsf@osv.gnss.ru/
> 
> Basically, you get PHY response when you ask for capabilities, but then
> MAC executes ioctl() request for corresponding configuration!
> 
> [...]
> 

Yup, sure, _but_ my point is: PHY timestamping is not supposed to work
unless you do that phy_has_hwtstamp dance in .ndo_do_ioctl and pass it
to the PHY driver. Whereas, timestamping on a DSA switch is supposed to
just work. So, the double-TX-timestamp fix is common for both DSA and
PHY timestamping, and it should be a separate patch that goes to David's
"net" tree and has an according Fixes: tag for the stable people to pick
it up. Then, the PHY timestamping patch is technically a new feature,
because the driver wasn't looking at the PHY's ability to perform PTP
timestamping, and now it does. So that part is a patch for "net-next".

> Thanks,
> -- Sergey

Thank you,
-Vladimir
