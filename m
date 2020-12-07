Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07122D0943
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 04:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgLGDFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 22:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLGDFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 22:05:12 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1CEC0613D0
        for <netdev@vger.kernel.org>; Sun,  6 Dec 2020 19:04:31 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id j12so11230907ota.7
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 19:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MoRQyw2VsRoKvCxhsQ7m5n4padLmazVQT/RLy0wkx0E=;
        b=Bn1+cRbiT2rWgNC1qo9ZuUg/4jyNcm2ozMJx6he0c736ZSIatDMocGD/THLUmUjX3J
         OYTfRyVD9o0PMP4pCqdMSzWYxtyrqe2eSQGZWqcTPnYlIxuzEE3yrsJj61Np5g80lyMs
         w6qRhMfmqxY2JVKQscvpyzrmXwQtrzkwd6CIReHKQ+IaetgI0uqN1GFO9RiXZK2IFMlt
         rhgjd6/FoEzcIo1mfTerCHLhOo0L6aKJBfwKcPh3aZ5KaUJBzOjPK6obbazmsZu2jPEc
         CT0Vs4pDuoFJV+2ZN4h8ceqx2C1BXpEZE/QlvzVqh9OOayBNg7ddKRYv2PBBrtT1DPBs
         TJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MoRQyw2VsRoKvCxhsQ7m5n4padLmazVQT/RLy0wkx0E=;
        b=lus/+w/cPoUkY8zoQSlttBnpmArpfp8YJ18MZ0W8OvlUhOMU2J0wy/uU63oCVvXd/d
         eCD/xjhQAWJaGTTRFPJPFIX+0iHVhyx1T29h6hzOQAXNs79U+DgyoKSSGTaKUS2wf0De
         Mp/jHoH6hEpXWBad7hGlLOa75GOwzBVUCQlecuxebEhg1YProluszsympOMXik1Nls9e
         WTJ5OxMytQHVt31LunwKmonMUGOFn2JvXDq8JgM001Q55f0DhiUZkeEqz11Jn0Xfb8Jy
         cMFLO/oFz28HmseISzW4KJInudw1ermOZMguELqCRoVBcXCVgNkS/rYhuA05X4ymTvhs
         LGAw==
X-Gm-Message-State: AOAM531KDQGvGfT1TkSQZrkX/NAi2NwwCIlEGH5r7/ByQFcRLr/67BBY
        jHxwpw3edPIMmwKz5zfiCAyLz2NTXaMNbcK7F3zAbBl4ZycsHg==
X-Google-Smtp-Source: ABdhPJyxDCvFpy/BhQlxawDGUoCC2uPvjNdO30GiHJxJg35f01+3lX4QxysTgn0v35Ze7JtGDn0NFhnUckOxkrYab1E=
X-Received: by 2002:a05:6830:22d3:: with SMTP id q19mr4758289otc.115.1607310270658;
 Sun, 06 Dec 2020 19:04:30 -0800 (PST)
MIME-Version: 1.0
References: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
 <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfmpSdv5onOGk=VtEO1fWxxhaVvi96Tz-wCFcNE5R9cdXNgkg@mail.gmail.com> <20201206164924.baczz7eyxz6czro2@lion.mk-sys.cz>
In-Reply-To: <20201206164924.baczz7eyxz6czro2@lion.mk-sys.cz>
From:   Limin Wang <lwang.nbl@gmail.com>
Date:   Sun, 6 Dec 2020 22:04:19 -0500
Message-ID: <CACpdL30W2rSTxiQR649v_hpzmLBR7R8-3BU2wnetBpV8Fihmrw@mail.gmail.com>
Subject: Re: LRO: creating vlan subports affects parent port's LRO settings
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to Jakub, Michal and Jarod for the time and consideration. I
have been caught up with other stuff, and not spent much time on this
since.

I am not that familiar with the upper/lower sync logic and
implications. But I agree with Michal,  it may not be necessary to
have a blanket exclusion of certain type of devices in those sync
functions.

I was thinking something maybe in vlan_dev.c:

static int vlan_dev_init(struct net_device *dev)
{
struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;

netif_carrier_off(dev);

/* IFF_BROADCAST|IFF_MULTICAST; ??? */
dev->flags  = real_dev->flags & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI |
 IFF_MASTER | IFF_SLAVE);
dev->state  = (real_dev->state & ((1<<__LINK_STATE_NOCARRIER) |
 (1<<__LINK_STATE_DORMANT))) |
     (1<<__LINK_STATE_PRESENT);

dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG |
  NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
  NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
  NETIF_F_ALL_FCOE;

here, maybe check if real_dev's NETIF_F_UPPER_DISABLES features bits
are set, and add them to vlan_dev?

On Sun, Dec 6, 2020 at 11:49 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Sat, Dec 05, 2020 at 07:04:06PM -0500, Jarod Wilson wrote:
> > On Mon, Nov 23, 2020 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 19 Nov 2020 20:37:27 -0500 Limin Wang wrote:
> > > > Under relatively recent kernels (v4.4+), creating a vlan subport on a
> > > > LRO supported parent NIC may turn LRO off on the parent port and
> > > > further render its LRO feature practically unchangeable.
> > >
> > > That does sound like an oversight in commit fd867d51f889 ("net/core:
> > > generic support for disabling netdev features down stack").
> > >
> > > Are you able to create a patch to fix this?
> >
> > Something like this, perhaps? Completely untested copy-pasta'd
> > theoretical patch:
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 8588ade790cb..a5ce372e02ba 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9605,8 +9605,10 @@ int __netdev_update_features(struct net_device *dev)
> >         features = netdev_fix_features(dev, features);
> >
> >         /* some features can't be enabled if they're off on an upper device */
> > -       netdev_for_each_upper_dev_rcu(dev, upper, iter)
> > -               features = netdev_sync_upper_features(dev, upper, features);
> > +       netdev_for_each_upper_dev_rcu(dev, upper, iter) {
> > +               if (netif_is_lag_master(upper) || netif_is_bridge_master(upper))
> > +                       features = netdev_sync_upper_features(dev,
> > upper, features);
> > +       }
> >
> >         if (dev->features == features)
> >                 goto sync_lower;
> > @@ -9633,8 +9635,10 @@ int __netdev_update_features(struct net_device *dev)
> >         /* some features must be disabled on lower devices when disabled
> >          * on an upper device (think: bonding master or bridge)
> >          */
> > -       netdev_for_each_lower_dev(dev, lower, iter)
> > -               netdev_sync_lower_features(dev, lower, features);
> > +       if (netif_is_lag_master(dev) || netif_is_bridge_master(dev)) {
> > +               netdev_for_each_lower_dev(dev, lower, iter)
> > +                       netdev_sync_lower_features(dev, lower, features);
> > +       }
> >
> >         if (!err) {
> >                 netdev_features_t diff = features ^ dev->features;
> >
> > I'm not sure what all other upper devices this excludes besides just
> > vlan ports though, so perhaps safer add upper device types to not do
> > feature sync on than to choose which ones to do them on?
>
> I'm not sure excluding devices from feature sync is the right way,
> whether it's an explicit list types or default. The logic still makes
> sense to me. Couldn't we address the issue by either setting features in
> NETIF_F_UPPER_DISABLES) by default for a new vlan (and probably macvlan)
> device? Or perhaps inheriting their values from the lower device.
>
> Michal
