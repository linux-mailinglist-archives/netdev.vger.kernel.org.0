Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6E400EBB
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 10:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhIEIq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 04:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhIEIqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 04:46:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4816FC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 01:45:21 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g22so5026195edy.12
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 01:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FO7lFv9XyLRqwhYHetjaVRvwm/NC924o/W2Xp9IcMYk=;
        b=ZOaOPb0+qNDRQlTjsPdJkv5douEswYqrWSZ+f08QNajvXGWwtsKvLwozfWLrxpC52x
         v7XLEqZKXCtUdpHRMFAblaFG9RbtDA9FvUC4n6bmakhQZyVztam0a1BUtcFp5+WhReW0
         pU/Co30/VM/E2KvEV9HcdC+JpuRnivOQ+nldznmUCDAQ/GHJ9U62q9WaNy/NnnuNWK5q
         QAnycO5nytXYZ3xIVHfq8YeISxBXeWfqJxpRfKZGw7Xb0ahlsSHdp5fCWylnM30GPp19
         x/RKqz2ptLUR988id9016apBTUexXb1vM6mrCNsqAlcZA1+ifJse8gwol3NdyV5hUQD7
         wuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FO7lFv9XyLRqwhYHetjaVRvwm/NC924o/W2Xp9IcMYk=;
        b=KnE5c8CQ5nyPEzTyN5yypd4XeEVI9D+aPYQZFXOwpQyI83ihzi+/I3ZOeyOotHwHcb
         sNSHczWkYGyYyNSV2wng0s3nejznja5tRLS4bK+wpjedPUW5Z5FDXLXfn84mmDaoO27R
         1kYS10Bjb5TSylbZtFp6D99gggpSu+Orh3V7PrPh2EnAWb2NKDzxNlA9YZKPd4TGOQcz
         nxvZm/hXz6y/ZS25LzC1sTbgEdjslIy4pNavBXv0625CkQ0FzjYRdYH/TqUOjxTxNPGt
         54pZfvurVJK9Hs4ci4AjN1uOYYLpEbROqLkZbLL9Lrt3jQrzwGep4v+DBKI2aP+19Skf
         +y1g==
X-Gm-Message-State: AOAM532NO856ZI9Iki+HFt3UqfWP39PqiKX3IcpQs+SRRiZO5jvbQlTE
        qtaVZxA+76aK4BM05X8QA+19LiG6XX4FiA==
X-Google-Smtp-Source: ABdhPJxl/yvLifk1f8l1YRS8sKXzAz0nLwH1ROCM7Y6Xl0edSBQhkcDeDDp2mjF7mcqkQ4ykjUkrzw==
X-Received: by 2002:a50:d844:: with SMTP id v4mr522661edj.73.1630831519762;
        Sun, 05 Sep 2021 01:45:19 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id i4sm2539543edq.34.2021.09.05.01.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 01:45:19 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:45:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <20210905084518.emlagw76qmo44rpw@skbuf>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
 <YTRswWukNB0zDRIc@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTRswWukNB0zDRIc@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 10:07:45AM +0300, Leon Romanovsky wrote:
> On Fri, Sep 03, 2021 at 02:17:38AM +0300, Vladimir Oltean wrote:
> > Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> > decided it was fine to ignore errors on certain ports that fail to
> > probe, and go on with the ports that do probe fine.
> > 
> > Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
> > noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
> > called, and devlink notices after a timeout of 3700 seconds and prints a
> > WARN_ON. So it went ahead to unregister the devlink port. And because
> > there exists an UNUSED port flavour, we actually re-register the devlink
> > port as UNUSED.
> > 
> > Commit 08156ba430b4 ("net: dsa: Add devlink port regions support to
> > DSA") added devlink port regions, which are set up by the driver and not
> > by DSA.
> > 
> > When we trigger the devlink port deregistration and reregistration as
> > unused, devlink now prints another WARN_ON, from here:
> > 
> > devlink_port_unregister:
> > 	WARN_ON(!list_empty(&devlink_port->region_list));
> > 
> > So the port still has regions, which makes sense, because they were set
> > up by the driver, and the driver doesn't know we're unregistering the
> > devlink port.
> > 
> > Somebody needs to tear them down, and optionally (actually it would be
> > nice, to be consistent) set them up again for the new devlink port.
> > 
> > But DSA's layering stays in our way quite badly here.
> 
> I don't know anything about DSA

It is sufficient to know in this case that it is a multi-port networking
driver.

> and what led to the decision to ignore devlink registration errors,

But we are not ignoring devlink registration errors...

The devlink_port must be initialized prior to initializing the net_device.

Initializing a certain net_device may fail due to reasons such as "PHY
not found". It is desirable in certain cases for a net_device
initialization failure to not fail the entire switch probe.

So at the very least, rollback of the registration of that port must be
performed before continuing => the devlink_port needs to be unregistered
when the net_device initialization has failed.

> but devlink core is relying on the simple assumption that everything
> is initialized correctly.
> 
> So if DSA needs to have not-initialized port, it should do all the needed
> hacks internally.

So the current problem is that the DSA framework does not ask the hardware
driver whether it has devlink port regions which need to be torn down
before unregistering the devlink port.

I was expecting the feedback to be "we need to introduce new methods in
struct dsa_switch_ops which do .port_setup and .port_teardown, similar
to the already existing per-switch .setup and .teardown, and drivers
which set up devlink port regions should set these up from the port
methods, so that DSA can simply call those when it needs to tear down a
devlink port without tearing down the entire switch and devlink instance".
The proposed patch is horrible and I agree, but not for the reasons you
might think it is.

Either way, "all the needed hacks" are already done internally, and from
devlink's perspective everything is initialized correctly, not sure what
this comment is about. I am really not changing anything in DSA's
interaction with the devlink core, other than ensuring we do not
unregister a devlink port with regions on it.
