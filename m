Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AA5400F20
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 12:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbhIEKcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 06:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbhIEKcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 06:32:31 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F65CC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 03:31:28 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mf2so7224108ejb.9
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 03:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6u6j4elA2jvv7uJCxxxamOnb64LJBuzUmgYpcboZaFE=;
        b=c6jLCYP0hakfrABIDruy+enxB4Bn8PdIGV48uvL5dWF+H4uEb6Ym5lO/5jiOUArr4b
         E1U4Q4d+1Ktxtho1clDM9YYJNxe/5H9XV4eIjDTv3WlP+dcF7R0Jx9ujyrAWMJUwfXhZ
         um8GUzZJ+SdgRZLt7tWFhkQgCL1oo6vTmMdlIGQkhilDHUVD2+BabLdffCm9dSlq8XdY
         Zl4hLtggLJLc+s7P/7sGs2G2vV9MMsKHKsmMeL6IT3nshykvLKF/U0Lrndpjm7v70RNk
         kzHsKWrlj/y54KPDFkKKd/y65qgVaGLxA0emPpHW0VnKW2u3qihpXF+tp9ORmPjJgwfK
         OzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6u6j4elA2jvv7uJCxxxamOnb64LJBuzUmgYpcboZaFE=;
        b=UuZAlk0LtziZafJP4Yb8V0r0CBPW603Sh3BfpzGDYe7PZlJBJaXfXnjiOePcq4nSj0
         sz+FBIHpiBhUvp8EMJRQlcMNKaeoBkgurKHZOQY10dF3CqHj3JxpgNpjd3KoxGDQ61Ue
         tYkt4q1LvtE5t1wJbey2Eckwq19s2Bz/RZVByqWJzMGyRebvcAdyXDYCtkHf+Z48oAc2
         rB5uTS8s3C7g8xNrRuz6b0qrZ08VOUR/U7Cqlltz40X3OJv6Odmoebs3j22pql6ZPFTL
         WoRgOIxq8aBXhVaN4DuO6uK09Jt6QG1aKLOnYRU5pS3p9lYfqnnxFwyxRM343vKtxygM
         PFBQ==
X-Gm-Message-State: AOAM530Hb7QuKoyEVoy6ffwDGS0yTHaPzvTyQA2vt5K8VIOZxxMGmkXM
        wlQD2hY/XHOybe2S9Yq7PUc=
X-Google-Smtp-Source: ABdhPJwaQk8JC2NH+X3f+cd/AAOW3ww2JHQTH6r9vu3Ueeu2WQvSvxOiDBHptk1H2B7o5UbXO8dVqQ==
X-Received: by 2002:a17:906:1956:: with SMTP id b22mr8231720eje.104.1630837886600;
        Sun, 05 Sep 2021 03:31:26 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id q6sm2148864ejm.106.2021.09.05.03.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 03:31:26 -0700 (PDT)
Date:   Sun, 5 Sep 2021 13:31:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <20210905103125.2ulxt2l65frw7bwu@skbuf>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTSa/3XHe9qVz9t7@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 01:25:03PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 05, 2021 at 11:45:18AM +0300, Vladimir Oltean wrote:
> > On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> > > On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> > > > Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> > > > decided it was fine to ignore errors on certain ports that fail to
> > > > probe, and go on with the ports that do probe fine.
> > > > 
> > > > Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
> > > > noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
> > > > called, and devlink notices after a timeout of 3700 seconds and prints a
> > > > WARN_ON. So it went ahead to unregister the devlink port. And because
> > > > there exists an UNUSED port flavour, we actually re-register the devlink
> > > > port as UNUSED.
> > > > 
> > > > Commit 08156ba430b4 ("net: dsa: Add devlink port regions support to
> > > > DSA") added devlink port regions, which are set up by the driver and not
> > > > by DSA.
> > > > 
> > > > When we trigger the devlink port deregistration and reregistration as
> > > > unused, devlink now prints another WARN_ON, from here:
> > > > 
> > > > devlink_port_unregister:
> > > > 	WARN_ON(!list_empty(&devlink_port->region_list));
> > > > 
> > > > So the port still has regions, which makes sense, because they were set
> > > > up by the driver, and the driver doesn't know we're unregistering the
> > > > devlink port.
> > > > 
> > > > Somebody needs to tear them down, and optionally (actually it would be
> > > > nice, to be consistent) set them up again for the new devlink port.
> > > > 
> > > > But DSA's layering stays in our way quite badly here.
> > > 
> > > I don't know anything about DSA
> > 
> > It is sufficient to know in this case that it is a multi-port networking
> > driver.
> > 
> > > and what led to the decision to ignore devlink registration errors,
> > 
> > But we are not ignoring devlink registration errors...
> > 
> > The devlink_port must be initialized prior to initializing the net_device.
> > 
> > Initializing a certain net_device may fail due to reasons such as "PHY
> > not found". It is desirable in certain cases for a net_device
> > initialization failure to not fail the entire switch probe.
> > 
> > So at the very least, rollback of the registration of that port must be
> > performed before continuing => the devlink_port needs to be unregistered
> > when the net_device initialization has failed.
> > 
> > > but devlink core is relying on the simple assumption that everything
> > > is initialized correctly.
> > > 
> > > So if DSA needs to have not-initialized port, it should do all the needed
> > > hacks internally.
> > 
> > So the current problem is that the DSA framework does not ask the hardware
> > driver whether it has devlink port regions which need to be torn down
> > before unregistering the devlink port.
> > 
> > I was expecting the feedback to be "we need to introduce new methods in
> > struct dsa_switch_ops which do .port_setup and .port_teardown, similar
> > to the already existing per-switch .setup and .teardown, and drivers
> > which set up devlink port regions should set these up from the port
> > methods, so that DSA can simply call those when it needs to tear down a
> > devlink port without tearing down the entire switch and devlink instance".
> > The proposed patch is horrible and I agree, but not for the reasons you
> > might think it is.
> > 
> > Either way, "all the needed hacks" are already done internally, and from
> > devlink's perspective everything is initialized correctly, not sure what
> > this comment is about. I am really not changing anything in DSA's
> > interaction with the devlink core, other than ensuring we do not
> > unregister a devlink port with regions on it.
> 
> That sentence means that your change is OK and you did it right by not
> changing devlink port to hold not-working ports.

You're with me so far.

There is a second part. The ports with 'status = "disabled"' in the
device tree still get devlink ports registered, but with the
DEVLINK_PORT_FLAVOUR_UNUSED flavour and no netdev. These devlink ports
still have things like port regions exported.

What we do for ports that have failed to probe is to reinit their
devlink ports as DEVLINK_PORT_FLAVOUR_UNUSED, and their port regions, so
they effectively behave as though they were disabled in the device tree.
