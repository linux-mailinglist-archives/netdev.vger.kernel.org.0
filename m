Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5DA3FBCBE
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 21:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhH3TEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 15:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbhH3TEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 15:04:46 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A69C06175F
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 12:03:52 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r4so30192793ybp.4
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2bxnmb0ihpOea9bKFBJwN2QiE7nKKp/Kf8m8WRCLmQ=;
        b=CNXv9uQY/btGpuGZCGIeiwDkbadXPvVPJGX8i+eMZ94MOA1GM1y93ZATn5Ei0ThY+i
         JTjfMEaijan7LRBtEtM5It2Yg9iQ5piQQycZRmmHt+mIfxP8D9saNFiGT+F6FaI2mnN1
         LnCl45iXefqt9y4KBuDEFRCmohy3sNSy1hsaRqjNAcY3XBhkC/aCTPy7kun43JxxXbUF
         ZiZhgvGhYNK+g9yIztL2E04zfwdkMgBpMRTBngU0KkgHBmqMJtqvDX4lbzZvz4iLVO3Y
         Lu1pEj2hQ4LRYAsuo6jGb617+9fd0pcLfd/EWU8aZvpFFKvcMZrYsVkpo5VpUeG5F5gK
         zKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2bxnmb0ihpOea9bKFBJwN2QiE7nKKp/Kf8m8WRCLmQ=;
        b=s4tOE8dqcBehznU3I0GPxd0WoKRTafG0V8Fm9SWMw1mbOtIKNlMNf1MObB/3DEOZIt
         xaGuJAzKOpw4UpushagQOK/dKSzVQPtvznPdsGTioTiVGYDYQxdaE93fBu1MK4+3sfE2
         jDP5uKMLHmV2+u7bP4GfDF3dIGpFMQBX5V/BVSjQ+qV5tS/dmd2wG073uiCYgjDIfeyd
         SsSfDHyNud6s9xBeT0G4uoiQF1FcMHAap8q0jwxEL/IPlUE6IdaVC/C3AST9U7+rtzyB
         szxYPn7woFWb7AlAK7DhSkkczK5rgBHuz+Un4GipFBT3h0UINA2LMZ437cdP+GuFMb6u
         hifQ==
X-Gm-Message-State: AOAM530rNpLwEiWBonG7qXgNw/hprb5puzcCP0lCt9ykQ6jLE9cG3U6c
        aOd56wpJurfzqu5MwN4R2hyb3SQ7/Bs/ZTatcbiq4g==
X-Google-Smtp-Source: ABdhPJz9aD6FzTGpzWANYNoSRWYbWlVX4WNltzALVRrIK1we8xo3YfH38PlE1sT1b+6yUjbcDmqzWkoGLExhUMGBhIE=
X-Received: by 2002:a25:804:: with SMTP id 4mr24050887ybi.346.1630350231696;
 Mon, 30 Aug 2021 12:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <YSeTdb6DbHbBYabN@lunn.ch> <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch> <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch> <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch> <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch> <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
In-Reply-To: <YSpr/BOZj2PKoC8B@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 30 Aug 2021 12:03:15 -0700
Message-ID: <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 28, 2021 at 10:01 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Aug 27, 2021 at 02:33:02PM -0700, Saravana Kannan wrote:
> > On Fri, Aug 27, 2021 at 1:11 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > > I've not yet looked at plain Ethernet drivers. This pattern could also
> > > > > exist there. And i wonder about other complex structures, i2c bus
> > > > > multiplexors, you can have interrupt controllers as i2c devices,
> > > > > etc. So the general case could exist in other places.
> > > >
> > > > I haven't seen any generic issues like this reported so far. It's only
> > > > after adding phy-handle that we are hitting these issues with DSA
> > > > switches.
> > >
> > > Can you run your parser over the 2250 DTB blobs and see how many
> > > children have dependencies on a parent? That could give us an idea how
> > > many moles need whacking. And maybe, where in the tree they are
> > > hiding?
> >
> > You are only responding to part of my email. As I said in my previous
> > email: "There are plenty of cases where it's better to delay the child
> > device's probe until the parent finishes. You even gave an example[7]
> > where it would help avoid unnecessary deferred probes." Can you please
> > give your thoughts on the rest of the points I made too?
>
> I must admit, my main problem at the moment is -rc1 in two weeks
> time. It seems like a number of board with Ethernet switches will be
> broken, that worked before. phy-handle is not limited to switch
> drivers, it is also used for Ethernet drivers. So it could be, a
> number of Ethernet drivers are also going to be broken in -rc1?

Again, in those cases, based on your FEC example, fw_devlink=on
actually improves things.

> But the issues sounds not to be specific to phy-handle, but any
> phandle that points back to a parent.

I feel like I'm going in circles here. This statement is not true.
Please read my previous explanations.

> So it could be drivers outside
> of networking are also going to be broken with -rc1?
> You have been very focused on one or two drivers. I would much rather
> see you getting an idea of how wide spread this problem is, and what
> should we do for -rc1?

Again, it's not a widespread problem as I explained before.
fw_devlink=on has been the default for 2 kernel versions now. With no
unfixed reported issues.

> Even if modifying DSA drivers to component drivers is possible, while
> not breaking backwards compatibility with DT,

It should be possible without needing any DT changes.

> it is not going to
> happen over night. That is something for the next merge window, not
> this merge window.

Right, I wasn't suggesting the component driver option be implemented
right away. We were talking about what the longer term proper fix
would be for DSA (and Ethernet if we actually find issues there) and
who would do it. That's what I hope this discussion could be.

Also, if we replace Patch 2/2 in this series with the patch below, it
will work as a generic quick fix for DSA that we could use for -rc1.
And if we still have issues reported on the phy-handle patch by -rc5
or so, we could revert the phy-handle patch then so that v5.15 isn't
broken.

-Saravana

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1286,6 +1286,17 @@ static int dsa_switch_parse_of(struct
dsa_switch *ds, struct device_node *dn)
 {
        int err;

+       /* A lot of switch devices have their PHYs as child devices and have
+        * the PHYs depend on the switch as a supplier (Eg: interrupt
+        * controller). With fw_devlink=on, that means the PHYs will defer
+        * probe until the probe() of the switch completes. However, the way
+        * the DSA framework is designed, the PHYs are expected to be probed
+        * successfully before the probe() of the switch completes.
+        *
+        * So, mark the switch devices as a "broken parent" so that fw_devlink
+        * knows not to create device links between PHYs and the parent switch.
+        */
+       np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
        err = dsa_switch_parse_member_of(ds, dn);
        if (err)
                return err;
