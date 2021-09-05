Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4D7401073
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhIEPCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhIEPCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:02:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA262C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 08:01:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u19so5777145edb.3
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 08:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6FSYcDWm+4S9jb5bd50cdI1NecgOvuSlVsQaD6ceUg0=;
        b=e53M0K/lZp+TEcAOtPEoqgluWJI4ilSFgVm44ddJregfgtU00wjlbmdFPKPLU+qWHS
         LPNXbilhleJ0eGsooZAYMNU9IU3UN0+cMro15MZEJhf766r4ea2UnuOnwJ6tq3jbGMNY
         4kc9YtmnyzwcRUfXvCRFqFtxqofXDzjialQU6F9/n4LsgeKD3U8r6i2ODrr2uXbw24LJ
         oRg09e6IqW2fOMBeom4v342SoqqCFgr0RNnO0M5QPHl6eOkJUnuQkiZxWtmhhEMlSJYW
         7hhUl+bIyofrltwUfnt7alEOK1o+bf60oM9YWzEgfdJlTYXQ6tLUyQhMYx+YgN4m4Boz
         gELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6FSYcDWm+4S9jb5bd50cdI1NecgOvuSlVsQaD6ceUg0=;
        b=mhQsI+AGAGkVbWQE97ZYyHng/7+YMYNLzLGEuvBizbm8cRF6Part7nLWP/aarEl9pG
         IYMdN5w0ECx8WJ9e3AbmGu6HfRaIs4GnA1mL+METr0a8u2XwkJkan5prY+Q+2IdAgdEa
         qwSGfk5XvabsbPtNVtoMitjqfK5+gYWptqqepjtDofl9jN+JHVrqDJ/QZO6Lv/FUGucn
         4AbybMcQptOPcVFORZAZna4Iqvv9Hb4Dc6uXwc+7aKJIlg8GG8zlC2FFdMYgZ3hXtXg2
         Ww3/WmKT912EqxeyNIN31rgzPPngsIegdb9HGLA/tQa0DZ3W9LTEY6UdCGvpBQPtPi53
         2M1g==
X-Gm-Message-State: AOAM532fKBhY8aFToS9IPodx9z0lkDoWcSFnTra4Bev1Oqrvn0pbUxC9
        xxg3YyMdBCO3MfqQ+tY5q+Y=
X-Google-Smtp-Source: ABdhPJxzsfMqrhLis9jvvr09JmhuQfiytsNauAWRIvjHj0LOVh2rFx6uAFzabI4JQvaYPA+3MY8eSg==
X-Received: by 2002:aa7:d592:: with SMTP id r18mr9130774edq.317.1630854077239;
        Sun, 05 Sep 2021 08:01:17 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id y21sm2972448edu.13.2021.09.05.08.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:01:16 -0700 (PDT)
Date:   Sun, 5 Sep 2021 18:01:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <20210905150115.bw5cgv572my5cmep@skbuf>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal>
 <20210905110735.asgsyjygsrxti6jk@skbuf>
 <YTS/rK73Qbd3KAtz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTS/rK73Qbd3KAtz@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 04:01:32PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 05, 2021 at 02:07:35PM +0300, Vladimir Oltean wrote:
> > On Sun, Sep 05, 2021 at 01:47:51PM +0300, Leon Romanovsky wrote:
> > > On Sun, Sep 05, 2021 at 01:31:25PM +0300, Vladimir Oltean wrote:
> > > > On Sun, Sep 05, 2021 at 01:25:03PM +0300, Leon Romanovsky wrote:
> > > > > On Sun, Sep 05, 2021 at 11:45:18AM +0300, Vladimir Oltean wrote:
> > > > > > On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> > > > > > > On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> > > 
> > > <...>
> > > 
> > > > > That sentence means that your change is OK and you did it right by not
> > > > > changing devlink port to hold not-working ports.
> > > > 
> > > > You're with me so far.
> > > > 
> > > > There is a second part. The ports with 'status = "disabled"' in the
> > > > device tree still get devlink ports registered, but with the
> > > > DEVLINK_PORT_FLAVOUR_UNUSED flavour and no netdev. These devlink ports
> > > > still have things like port regions exported.
> > > > 
> > > > What we do for ports that have failed to probe is to reinit their
> > > > devlink ports as DEVLINK_PORT_FLAVOUR_UNUSED, and their port regions, so
> > > > they effectively behave as though they were disabled in the device tree.
> > > 
> > > Yes, and this part require DSA knowledge that I don't have, because you
> > > suggest fallback for any error during devlink port register,
> > 
> > Again, fallback but not during devlink port register. The devlink port
> > was registered just fine, but our plans changed midway. If you want to
> > create a net device with an associated devlink port, first you need to
> > create the devlink port and then the net device, then you need to link
> > the two using devlink_port_type_eth_set, at least according to my
> > understanding.
> > 
> > So the failure is during the creation of the **net device**, we now have a
> > devlink port which was originally intended to be of the Ethernet type
> > and have a physical flavour, but it will not be backed by any net device,
> > because the creation of that just failed. So the question is simply what
> > to do with that devlink port.
> 
> I lost you here, from known to me from the NIC, the **net devices** are
> created with devlink_alloc() API call and devlink_port_register comes
> later. It means that net device is created (or not) before devlink port
> code.
> 
> Anyway, it is really not important to me as long as changes won't touch
> net/core/devlink.c.

Unless I am mistaken, there is a DEVLINK_PORT_TYPE_WARN_TIMEOUT of 3600
seconds until you can associate the devlink_port with the net_device via
devlink_port_type_eth_set, _after_ you've registered the net_device.
Is that incorrect, or is that not what the timeout is for?
