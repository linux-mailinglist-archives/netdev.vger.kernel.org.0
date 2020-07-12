Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7CD21C9EA
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 17:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgGLPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 11:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbgGLPBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 11:01:55 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7CDC061794;
        Sun, 12 Jul 2020 08:01:55 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a1so11398416ejg.12;
        Sun, 12 Jul 2020 08:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lgNUnkTyeGBs+S6AQcsSeWMybtOFf3sw9okmc9BlVSI=;
        b=Kily82oybKD/xxOI35j/aOshNnJvbkhdUu8acB9DWvUQ81xe9rwFkQQIXCD89XtMBb
         dSCb3ldF2ytwEGOSU4lFw69UueID2G4wXljWstYJ27nBN1onLbOxwzOwiDmDkPcmVwou
         72Fg1j5iDZ5/uQFrtzSqUDfDnySMn3Hajf+4RhMuSU/Dgnb1+Ew+T5lHh/dT/21FWj1I
         Enu2OnU8YdChx/YJjeNNASvEyHRnivLKLnY0rfEIMH9aMx/8SvEfa06FUFD+f1sMeeON
         cA6kkUX2zvJAI3YmzjlA5w95uHBvCOz1EZj7JZh51ftxpO3J7IMcvoLIfGXsClZKBRsG
         FeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lgNUnkTyeGBs+S6AQcsSeWMybtOFf3sw9okmc9BlVSI=;
        b=WH4+pPmPaaCzX2KVh4DR3veFb9aWm+IACJoUzMTtaXFrMnKUYDWAbHBhJz6lFzRJQi
         3BdA5kTYcRUGYCMi2zOP1Dh51ucyrLdY4EfD5I39XnmAKf1aWMzXTkmz/y15HwDGvrfy
         ZstJ7TjwWW36oV0VWzHqj/AeL39TU9Ze2MbuyEj2PjPKzEdsuoGYiF/zN7VhH2u3SGbk
         4Z/dN+H5R+qzn8ZIZHtEGI85BhyYvTiK6zq6Dq0xY0QGS02yrC/Py5U1dXtz2vNFS38w
         hUh4oCv2lQziec6wZsueMId10zwyxbiSVvSVUkYUEs9IDIspxkYrX6fqKZeEwbHe+q6t
         O3+w==
X-Gm-Message-State: AOAM530O0+x+j5mDSHGXINtHqed2dxU2HEB+fdLm7ihuzSsEJtgspGps
        3btV5LjEznprHL4ogGorq/U=
X-Google-Smtp-Source: ABdhPJz6yVjS5VEog+aHysyHOtEc2rc0ATbXdP9hF4bOZaEIB8tHm7ZsgmdHLO0tEeyV0VSCbm6FGQ==
X-Received: by 2002:a17:906:f98e:: with SMTP id li14mr69419503ejb.174.1594566113955;
        Sun, 12 Jul 2020 08:01:53 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ay27sm9436171edb.81.2020.07.12.08.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 08:01:53 -0700 (PDT)
Date:   Sun, 12 Jul 2020 18:01:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200712150151.55jttxaf4emgqcpc@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
 <20200711231937.wu2zrm5spn7a6u2o@skbuf>
 <87wo387r8n.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo387r8n.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 05:16:56PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > Hi Sergey,
> >
> > On Sat, Jul 11, 2020 at 03:08:42PM +0300, Sergey Organov wrote:
> >> Fix support for external PTP-aware devices such as DSA or PTP PHY:
> >> 
> >> Make sure we never time stamp tx packets when hardware time stamping
> >> is disabled.
> >> 
> >> Check for PTP PHY being in use and then pass ioctls related to time
> >> stamping of Ethernet packets to the PTP PHY rather than handle them
> >> ourselves. In addition, disable our own hardware time stamping in this
> >> case.
> >> 
> >> Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")
> >
> > Please use a 12-character sha1sum. Try to use the "pretty" format
> > specifier I gave you in the original thread, it saves you from
> > counting,
> 
> I did as you suggested:
> 
> [pretty]
>         fixes = Fixes: %h (\"%s\")
> [alias]
> 	fixes = show --no-patch --pretty='Fixes: %h (\"%s\")'
> 
> And that's what it gave me. Dunno, maybe its Git version that is
> responsible?
> 
> I now tried to find a way to specify the number of digits in the
> abbreviated hash in the format, but failed. There is likely some global
> setting for minimum number of digits, but I'm yet to find it. Any idea?
> 

Sorry, my fault. I gave you only partial settings. Use this:

[core]
	abbrev = 12
[pretty]
	fixes = Fixes: %h (\"%s\")

> > and also from people complaining once it gets merged:
> >
> > https://www.google.com/search?q=stephen+rothwell+%22fixes+tag+needs+some+work%22
> >
> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> >> ---
> >> 
> >> v2:
> >>   - Extracted from larger patch series
> >>   - Description/comments updated according to discussions
> >>   - Added Fixes: tag
> >> 
> >>  drivers/net/ethernet/freescale/fec.h      |  1 +
> >>  drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++++++++++------
> >>  drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
> >>  3 files changed, 30 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> >> index d8d76da..832a217 100644
> >> --- a/drivers/net/ethernet/freescale/fec.h
> >> +++ b/drivers/net/ethernet/freescale/fec.h
> >> @@ -590,6 +590,7 @@ struct fec_enet_private {
> >>  void fec_ptp_init(struct platform_device *pdev, int irq_idx);
> >>  void fec_ptp_stop(struct platform_device *pdev);
> >>  void fec_ptp_start_cyclecounter(struct net_device *ndev);
> >> +void fec_ptp_disable_hwts(struct net_device *ndev);
> >>  int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
> >>  int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
> >>  
> >> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> >> index 3982285..cc7fbfc 100644
> >> --- a/drivers/net/ethernet/freescale/fec_main.c
> >> +++ b/drivers/net/ethernet/freescale/fec_main.c
> >> @@ -1294,8 +1294,13 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
> >>  			ndev->stats.tx_bytes += skb->len;
> >>  		}
> >>  
> >> -		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
> >> -			fep->bufdesc_ex) {
> >> +		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
> >> +		 * are to time stamp the packet, so we still need to check time
> >> +		 * stamping enabled flag.
> >> +		 */
> >> +		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS &&
> >> +			     fep->hwts_tx_en) &&
> >> +		    fep->bufdesc_ex) {
> >>  			struct skb_shared_hwtstamps shhwtstamps;
> >>  			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
> >>  
> >> @@ -2723,10 +2728,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
> >>  		return -ENODEV;
> >>  
> >>  	if (fep->bufdesc_ex) {
> >> -		if (cmd == SIOCSHWTSTAMP)
> >> -			return fec_ptp_set(ndev, rq);
> >> -		if (cmd == SIOCGHWTSTAMP)
> >> -			return fec_ptp_get(ndev, rq);
> >> +		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
> >
> > I thought we were in agreement that FEC does not support PHY
> > timestamping at this point, and this patch would only be fixing DSA
> > switches (even though PHYs would need this fixed too, when support is
> > added for them)? I would definitely not introduce support (and
> > incomplete, at that) for a new feature in a bugfix patch.
> >
> > But it looks like we aren't.
> 
> We were indeed, and, honestly, I did prepare the split version of the
> changes. But then I felt uneasy describing these commits, as I realized
> that I fix single source file and single original commit by adding
> proper support for a single feature that is described in your (single)
> recent document, but with 2 separate commits, each of which solves only
> half of the problem. I felt I need to somehow explain why could somebody
> want half a fix, and didn't know how, so I've merged them back into
> single commit.
> 

Right now there are 2 mainline DSA timestamping drivers that could be
paired with the FEC driver: mv88e6xxx and sja1105 (there is a third one,
felix, which is an embedded L2 switch, so its DSA master is known and
fixed, and it's not FEC). In practice, there are boards out there that
use FEC in conjunction with both these DSA switch families.

As far as I understand. the reason why SKBTX_IN_PROGRESS exists is for
skb_tx_timestamp() to only provide a software timestamp if the hardware
timestamping isn't going to. So hardware timestamping logic must signal
its intention. With SO_TIMESTAMPING, this should not be strictly
necessary, as this UAPI supports multiple sources of timestamping
(including software and hardware together), but I think
SKBTX_IN_PROGRESS predates this UAPI and timestamping should continue to
work with older socket options.

Now, out of the 2 mainline DSA drivers, 1 of them isn't setting
SKBTX_IN_PROGRESS, and that is mv88e6xxx. So mv88e6xxx isn't triggerring
this bug. I'm not sure why it isn't setting the flag. It might very well
be that the author of the patch had a board with a FEC DSA master, and
setting this flag made bad things happen, so he just left it unset.
Doesn't really matter.
But sja1105 is setting the flag:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/sja1105/sja1105_ptp.c#n890

So, at the very least, you are fixing PTP on DSA setups with FEC as
master and sja1105 as switch. Boards like that do exist.

> In case you insist they are to be separate, I do keep the split version
> in my git tree, but to finish it that way, I'd like to clarify a few
> details:
> 
> 1. Should it be patch series with 2 commits, or 2 entirely separate
> patches?
> 

Entirely separate.

> 2. If patch series, which change should go first? Here please notice
> that ioctl() change makes no sense without SKBTX fix unconditionally,
> while SKBTX fix makes no sense without ioctl() fix for PTP PHY users
> only.
> 

Please look at the SKBTX fix from the perspective of code that currently
exists in mainline, and not from the perspective of what you have in
mind.

> 3. If entirely separate patches, should I somehow refer to SKBTX patch in
> ioctl() one (and/or vice versa), to make it explicit they are
> (inter)dependent? 
> 

Nope. The PHY timestamping support will go to David's net-next, this
common PHY/DSA bugfix to net, and they'll meet sooner rather than later.

> 4. How/if should I explain why anybody would benefit from applying
> SKBTX patch, yet be in trouble applying ioctl() one? 
> 

Could you please rephrase? I don't understand the part about being in
trouble for applying the ioctl patch.

Thanks,
-Vladimir
