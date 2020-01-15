Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D61513B6C4
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgAOBYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:24:25 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47453 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728877AbgAOBYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:24:25 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D87C42215D;
        Tue, 14 Jan 2020 20:24:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 14 Jan 2020 20:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        mendozajonas.com; h=message-id:subject:from:to:cc:date
        :in-reply-to:references:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=hb6V/AgXglW+Zdj+K0/AgRXdrK
        Vf08r3BT/Gn6LVHvA=; b=wcGmVZJMKtHjD9cOlCND7mDDf/spQ+9RImrPXZGN2C
        kQX5ywRO1vcLzKzdPmql+so94W1InpHK81dZ6UKTtyY/WBsVJKaTtSpeu3P1R1Wf
        JKs6TrPljguBQfhmehxaURrh+qA/SASfCWcbHuiv+tR6wO01zCVH1za7T8LcUvaR
        WTEkLvVbF4e2fDvfjtK9HDvyF0ycrnwoxIhWb0QHFygVjZeFVKmlHuiQZir6dLmX
        +cewqk3QmIYm3jentZk9rKh+H8F/3MwyLzm2fUBiyf1dkOZJ2SYqKlMyE33rg+Z3
        k1AbHtEkYXoaR/15MR7eoNMG8EHbLgvO4Gd2rd8LtozA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=hb6V/AgXglW+Zdj+K0/AgRXdrKVf08r3BT/Gn6LVH
        vA=; b=sHs4lzmQBLZKPxE+n090gn57jx/FUtAtqNas/6I8aL+vYID+34WckSReH
        usHgWvLrKKo4r3x/lIrcYSz7iuv32kGvnPvgfFfkv4z3AiySHFcBrMJGH058LDTx
        EC33V3F4hqDppzI30auNujk6eCqqg5bFVgoyHLiqaul1lSUVvOhf55RRia07tX2h
        kRk7KTMG4jyGSTk71oZATerz+d5De9kYEwwo0T0LPyo1oq0bu1kgTRbo6/CAjkBl
        7Ei7nzsRLJRzhlK68/hbmmgOuWMVX+ifrIT0dqK7tZ45bBXjtimO/h2mcXX/3gCR
        Uh9yZZ9xR612lcLg0Kj84yYYeqr8w==
X-ME-Sender: <xms:x2keXqEcKr-EDMbTqdMGQyZEyNm0bOK7MbHnQWrdRiCg9yTdy7pl7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddvgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftgfoggfgsehtjeertdertdejnecuhfhrohhmpehsrghmjhho
    nhgrshcuoehsrghmsehmvghnughoiigrjhhonhgrshdrtghomheqnecuffhomhgrihhnpe
    hophgvrhgrthhinhhgrdgtrghtnecukfhppeehgedrvdegtddrudelfedruddvleenucfr
    rghrrghmpehmrghilhhfrhhomhepshgrmhesmhgvnhguohiirghjohhnrghsrdgtohhmne
    cuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:x2keXnrDvf5LwLdooKSZ5m6klMhYIU-KjnnZypKJQn_C7vsUND4LIg>
    <xmx:x2keXm7g4gOu6OYMQweN7jrZ-BZySUiY0jUern08XlxegL9HC6nUgQ>
    <xmx:x2keXl4COJ_EHd7YvCQbdUANWbwmSWISFw74ElKZ6j06XD5Kc5BBQA>
    <xmx:x2keXnUqKUFuKnxeJ10ItAQ0zoc-x-Ub_7-W8qI0duvs19E0YAbhKQ>
Received: from cdg1-dhcp-7-194.amazon.fr (unknown [54.240.193.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1862980062;
        Tue, 14 Jan 2020 20:24:21 -0500 (EST)
Message-ID: <eaaa9fcf678a7d71b43c0792b559d9958e7af191.camel@mendozajonas.com>
Subject: Re: [PATCH] Propagate NCSI channel carrier loss/gain events to the
 kernel
From:   samjonas <sam@mendozajonas.com>
To:     Johnathan Mantey <johnathanx.mantey@intel.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net
Date:   Tue, 14 Jan 2020 17:24:19 -0800
In-Reply-To: <54db4c95-44a1-da74-a6d4-21d591926dbd@intel.com>
References: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
         <20b75baf4fa6781278614162b05918dcdedd2e29.camel@mendozajonas.com>
         <54db4c95-44a1-da74-a6d4-21d591926dbd@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-01-14 at 08:47 -0800, Johnathan Mantey wrote:
> Sam,
> 
> This code is working on a channel that is completely
> configured.  This
> code is covering a situation where the RJ45 cable is intentionally or
> mistakenly removed from a system. In the event that the network cable
> is
> removed/damaged/slips, the kernel needs to change state to show that
> network interface no longer has a link.  For my employers use case
> the
> loss of carrier is then added to a log of system state changes. Thus
> for
> each internal channel there needs to be a way to report that the
> channel
> has/does not have a link carrier.

Hi Johnathan,

Right, updating the carrier status for NC-SI enabled interfaces is
helpful for a number of use cases (DHCP, etc). At the moment this will
only update the status after a LSC AEN appears, so on init the carrier
status will always be "up" regardless of what's plugged into the
channels. Does NC-SI still behave as expected if the carrier status is
initially set to "down"?
(However if we did do that we would also need a change to set the
carrier status on on configuration, or for packages that don't support
AENs).

Cheers,
Sam

> 
> On 1/13/20 4:43 PM, samjonas wrote:
> > On Fri, 2020-01-10 at 14:02 -0800, Johnathan Mantey wrote:
> > > From 76d99782ec897b010ba507895d60d27dca8dca44 Mon Sep 17 00:00:00
> > > 2001
> > > From: Johnathan Mantey <johnathanx.mantey@intel.com>
> > > Date: Fri, 10 Jan 2020 12:46:17 -0800
> > > Subject: [PATCH] Propagate NCSI channel carrier loss/gain events
> > > to
> > > the
> > > kernel
> > > 
> > > Problem statement:
> > > Insertion or removal of a network cable attached to a NCSI
> > > controlled
> > > network channel does not notify the kernel of the loss/gain of
> > > the
> > > network link.
> > > 
> > > The expectation is that /sys/class/net/eth(x)/carrier will change
> > > state after a pull/insertion event. In addition the
> > > carrier_up_count
> > > and carrier_down_count files should increment.
> > > 
> > > Change statement:
> > > Use the NCSI Asynchronous Event Notification handler to detect a
> > > change in a NCSI link.
> > > Add code to propagate carrier on/off state to the network
> > > interface.
> > > The on/off state is only modified after the existing code
> > > identifies
> > > if the network device HAD or HAS a link state change.
> > 
> > If we set the carrier state off until we successfully configured a
> > channel could we avoid this limitation?
> > 
> > Cheers,
> > Sam
> > 
> > > 
> > > Test procedure:
> > > Connected a L2 switch with only two ports connected.
> > > One port was a DHCP corporate net, the other port attached to the
> > > NCSI
> > > controlled NIC.
> > > 
> > > Starting with the L2 switch with DC on, check to make sure the
> > > NCSI
> > > link is operating.
> > > cat /sys/class/net/eth1/carrier
> > > 1
> > > cat /sys/class/net/eth1/carrier_up_count
> > > 0
> > > cat /sys/class/net/eth1/carrier_down_count
> > > 0
> > > 
> > > Remove DC from the L2 switch, and check link state
> > > cat /sys/class/net/eth1/carrier
> > > 0
> > > cat /sys/class/net/eth1/carrier_up_count
> > > 0
> > > cat /sys/class/net/eth1/carrier_down_count
> > > 1
> > > 
> > > Restore DC to the L2 switch, and check link state
> > > cat /sys/class/net/eth1/carrier
> > > 1
> > > cat /sys/class/net/eth1/carrier_up_count
> > > 1
> > > cat /sys/class/net/eth1/carrier_down_count
> > > 1
> > > 
> > > Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
> > > ---
> > >  net/ncsi/ncsi-aen.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
> > > index b635c194f0a8..274c415dcead 100644
> > > --- a/net/ncsi/ncsi-aen.c
> > > +++ b/net/ncsi/ncsi-aen.c
> > > @@ -89,6 +89,12 @@ static int ncsi_aen_handler_lsc(struct
> > > ncsi_dev_priv
> > > *ndp,
> > >      if ((had_link == has_link) || chained)
> > >          return 0;
> > >  
> > > +    if (had_link) {
> > > +        netif_carrier_off(ndp->ndev.dev);
> > > +    } else {
> > > +        netif_carrier_on(ndp->ndev.dev);
> > > +    }
> > > +
> > >      if (!ndp->multi_package && !nc->package->multi_channel) {
> > >          if (had_link) {
> > >              ndp->flags |= NCSI_DEV_RESHUFFLE;
> 
> 

