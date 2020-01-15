Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA4413B711
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgAOBk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:40:27 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42689 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728844AbgAOBk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:40:27 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F79221F85;
        Tue, 14 Jan 2020 20:40:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 14 Jan 2020 20:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=pOYd6CkHXgZyYUiNpxp7kp1OKE
        FH4VCsoXBLNAdANrg=; b=hae356Skf0i9tddQOFHh+aTYeK6OqNhRcFPraY9+Dl
        dwMja8naUGP1YXL7jWAC6W0SEWIopC9bitP6tLy/KfCsUtvhT/sI7g3qDtZHpC9u
        Fwu/cdgVrqzuuEXNDj3RRHRulPyBfSyzmTg2lsB8ZdsY0VBIusaaVkCt8thXSbs6
        F5uVVvdTHHrKsrPLzI8nAuFRuZs+LFAApU7p5/OcCq/MXgY5uj7j9vO2mb2b2X32
        141oicrSULyccntpnkb/J98Y/ZvBMNriWmDOZ29CWHf5KYctmuTmjaCGzY96IW1X
        R8aiLiT8AeBE5N2AlRcqDeR9p029uWheW2ev2TBQvuEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=pOYd6CkHXgZyYUiNpxp7kp1OKEFH4VCsoXBLNAdAN
        rg=; b=rQZigUUMjamVClM2aM3XlrAFpg+0bFsE0rB59G7oXBaetjjxmelffha00
        ln7k6u9jEiKzBrbjVZ3f/s4idtw7/oxb1uqpbby0jIP+kfcmm3+wnsWUrrR8ccGJ
        HJNFn2U5pH8QNd8OZECEb6Qd1RcNJIzJW7GN2SCL6VBDu5t8VWt+QLzAtNZxBI0D
        GRAC5/K/4TeFe6djfuNcl5v1/IfIsYVSjf78yzypc6X67zSiIYI0hAUtz1I5Kcqr
        fIfe1huz51SnBnmpamZd9OrieaBewOu0A1HqAp1JievaJd6uDfPYp0URneNU1Xwf
        Na6bl/HGhVJbuEWzYTmQe8ACN5DXg==
X-ME-Sender: <xms:im0eXhHxHx6Q20FiaON9Tq0HzyEsORJZDQWNunmCSi_pkUYYjLgwWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddvgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftgfoggfgsehtjeertdertdejnecuhfhrohhmpehsrghmjhho
    nhgrshcuoehsrghmsehmvghnughoiigrjhhonhgrshdrtghomheqnecuffhomhgrihhnpe
    hophgvrhgrthhinhhgrdgtrghtnecukfhppeehgedrvdegtddrudelfedrudenucfrrghr
    rghmpehmrghilhhfrhhomhepshgrmhesmhgvnhguohiirghjohhnrghsrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:im0eXiDBJxvhMG1CS3kgnWxxZZvuTZl-6spNUzcm_d16SJKH_FHc-g>
    <xmx:im0eXqDyYd1gaop-OHZtEYv3RIEAEIhZkERwF1ey3ojMiTf3vY7N4g>
    <xmx:im0eXr7OHPzs3BMw0YRpOJAuTdZSUuHVOYvx0HKFn1dXOn1hwkjcEw>
    <xmx:im0eXmHiHv2uYZJeLRevgkF5wnx9RsAhmxbWn9KwUBtrVg4nzQLlWA>
Received: from cdg1-dhcp-7-194.amazon.fr (unknown [54.240.193.1])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD89030607B0;
        Tue, 14 Jan 2020 20:40:24 -0500 (EST)
Message-ID: <770869e375d49c2d5ced183e1f0466644c2be783.camel@mendozajonas.com>
Subject: Re: [PATCH] Propagate NCSI channel carrier loss/gain events to the
 kernel
From:   samjonas <sam@mendozajonas.com>
To:     Johnathan Mantey <johnathanx.mantey@intel.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net
Date:   Tue, 14 Jan 2020 17:40:21 -0800
In-Reply-To: <eaaa9fcf678a7d71b43c0792b559d9958e7af191.camel@mendozajonas.com>
References: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
         <20b75baf4fa6781278614162b05918dcdedd2e29.camel@mendozajonas.com>
         <54db4c95-44a1-da74-a6d4-21d591926dbd@intel.com>
         <eaaa9fcf678a7d71b43c0792b559d9958e7af191.camel@mendozajonas.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-01-14 at 17:24 -0800, samjonas wrote:
> On Tue, 2020-01-14 at 08:47 -0800, Johnathan Mantey wrote:
> > Sam,
> > 
> > This code is working on a channel that is completely
> > configured.  This
> > code is covering a situation where the RJ45 cable is intentionally
> > or
> > mistakenly removed from a system. In the event that the network
> > cable
> > is
> > removed/damaged/slips, the kernel needs to change state to show
> > that
> > network interface no longer has a link.  For my employers use case
> > the
> > loss of carrier is then added to a log of system state changes.
> > Thus
> > for
> > each internal channel there needs to be a way to report that the
> > channel
> > has/does not have a link carrier.
> 
> Hi Johnathan,
> 
> Right, updating the carrier status for NC-SI enabled interfaces is
> helpful for a number of use cases (DHCP, etc). At the moment this
> will
> only update the status after a LSC AEN appears, so on init the
> carrier
> status will always be "up" regardless of what's plugged into the
> channels. Does NC-SI still behave as expected if the carrier status
> is
> initially set to "down"?

Ah I think I remember the issue with this; AFAIK netif_carrier_off()
will stop scheduling packets for the interface. The change here should
work for this specific case because the remote NIC will fire the LSC
asynchronously, but it probably has the nasty side effect of stopping
xmit for the entire local interface - ie, all packages and channels on
this interface.

With this change can you confirm that normal failover still works for
example, or otherwise try to configure the interface after a LSC/down
event?

Thanks,
Sam

> (However if we did do that we would also need a change to set the
> carrier status on on configuration, or for packages that don't
> support
> AENs).
> 
> Cheers,
> Sam
> 
> > 
> > On 1/13/20 4:43 PM, samjonas wrote:
> > > On Fri, 2020-01-10 at 14:02 -0800, Johnathan Mantey wrote:
> > > > From 76d99782ec897b010ba507895d60d27dca8dca44 Mon Sep 17
> > > > 00:00:00
> > > > 2001
> > > > From: Johnathan Mantey <johnathanx.mantey@intel.com>
> > > > Date: Fri, 10 Jan 2020 12:46:17 -0800
> > > > Subject: [PATCH] Propagate NCSI channel carrier loss/gain
> > > > events
> > > > to
> > > > the
> > > > kernel
> > > > 
> > > > Problem statement:
> > > > Insertion or removal of a network cable attached to a NCSI
> > > > controlled
> > > > network channel does not notify the kernel of the loss/gain of
> > > > the
> > > > network link.
> > > > 
> > > > The expectation is that /sys/class/net/eth(x)/carrier will
> > > > change
> > > > state after a pull/insertion event. In addition the
> > > > carrier_up_count
> > > > and carrier_down_count files should increment.
> > > > 
> > > > Change statement:
> > > > Use the NCSI Asynchronous Event Notification handler to detect
> > > > a
> > > > change in a NCSI link.
> > > > Add code to propagate carrier on/off state to the network
> > > > interface.
> > > > The on/off state is only modified after the existing code
> > > > identifies
> > > > if the network device HAD or HAS a link state change.
> > > 
> > > If we set the carrier state off until we successfully configured
> > > a
> > > channel could we avoid this limitation?
> > > 
> > > Cheers,
> > > Sam
> > > 
> > > > 
> > > > Test procedure:
> > > > Connected a L2 switch with only two ports connected.
> > > > One port was a DHCP corporate net, the other port attached to
> > > > the
> > > > NCSI
> > > > controlled NIC.
> > > > 
> > > > Starting with the L2 switch with DC on, check to make sure the
> > > > NCSI
> > > > link is operating.
> > > > cat /sys/class/net/eth1/carrier
> > > > 1
> > > > cat /sys/class/net/eth1/carrier_up_count
> > > > 0
> > > > cat /sys/class/net/eth1/carrier_down_count
> > > > 0
> > > > 
> > > > Remove DC from the L2 switch, and check link state
> > > > cat /sys/class/net/eth1/carrier
> > > > 0
> > > > cat /sys/class/net/eth1/carrier_up_count
> > > > 0
> > > > cat /sys/class/net/eth1/carrier_down_count
> > > > 1
> > > > 
> > > > Restore DC to the L2 switch, and check link state
> > > > cat /sys/class/net/eth1/carrier
> > > > 1
> > > > cat /sys/class/net/eth1/carrier_up_count
> > > > 1
> > > > cat /sys/class/net/eth1/carrier_down_count
> > > > 1
> > > > 
> > > > Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
> > > > ---
> > > >  net/ncsi/ncsi-aen.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
> > > > index b635c194f0a8..274c415dcead 100644
> > > > --- a/net/ncsi/ncsi-aen.c
> > > > +++ b/net/ncsi/ncsi-aen.c
> > > > @@ -89,6 +89,12 @@ static int ncsi_aen_handler_lsc(struct
> > > > ncsi_dev_priv
> > > > *ndp,
> > > >      if ((had_link == has_link) || chained)
> > > >          return 0;
> > > >  
> > > > +    if (had_link) {
> > > > +        netif_carrier_off(ndp->ndev.dev);
> > > > +    } else {
> > > > +        netif_carrier_on(ndp->ndev.dev);
> > > > +    }
> > > > +
> > > >      if (!ndp->multi_package && !nc->package->multi_channel) {
> > > >          if (had_link) {
> > > >              ndp->flags |= NCSI_DEV_RESHUFFLE;
> > 
> > 

