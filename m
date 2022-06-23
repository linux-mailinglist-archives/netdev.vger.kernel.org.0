Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AED35586BE
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiFWSQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiFWSQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:16:36 -0400
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06B25DF35;
        Thu, 23 Jun 2022 10:22:44 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id u9so219638ybq.3;
        Thu, 23 Jun 2022 10:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QzySQcL24GEYxXoJc82RsC0c2BhGDpj4k4DOkY9xrS0=;
        b=EA9QO/BQU35unKlx6FbkmO5/gPZgmhdZgoPbgFC6ffBaA9VooOcc0BRLOU39xQVF5u
         oCQBgnLZoYCyzVFx7UIoZDv9EQX6dTDh4Rgq+u/q19CS8XJPMXCMbOzr/wvoN8a+JJEX
         n+dfZAHFvr9Z2RZB/XL9H/844Gm0m5QrkH2LAFi2Edlk952DPNVmyNwpHEo0zDEgttH/
         rh/cvmHqXZv3hq9jo2fuvJWXhzak+RaB6VSTOM7wwmz9+vUeiVyRW9eHndW02UhCqfSG
         zciotoAlnfZ/mSNthxa1kW0Dqxa+aopjSNJbaqDfEBibkC99qnrZLbTwsBuiL8Fdv7Fv
         iS+g==
X-Gm-Message-State: AJIora8hjXpF/oHWli0PfCcSNJcgeSauYfwdswID16swkOdq45TP3wEt
        BttImfYagxBaZOWbKf9rxILcTsZ7uMFC93gcX1A=
X-Google-Smtp-Source: AGRyM1vlR+G3ynXaQ+rOy9k5hMBPieUkqHmh9QChAgpgAs7VODTNv3swHyAeiQ4sYXpc/+o+j6AcUnENYWlbLbMDoS8=
X-Received: by 2002:a05:6902:1141:b0:669:3f2a:c6bb with SMTP id
 p1-20020a056902114100b006693f2ac6bbmr10551083ybu.365.1656004963776; Thu, 23
 Jun 2022 10:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com> <20220623080344.783549-3-saravanak@google.com>
 <20220623100421.GY1615@pengutronix.de> <YrSXKkYfr+Hinsuu@smile.fi.intel.com>
In-Reply-To: <YrSXKkYfr+Hinsuu@smile.fi.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 23 Jun 2022 19:22:32 +0200
Message-ID: <CAJZ5v0girHMO5v=KMXmTuXNjrfx+1gi8ma25mNc+gt=3U8pppA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when fw_devlink.strict=1
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     sascha hauer <sha@pengutronix.de>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 6:39 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, Jun 23, 2022 at 12:04:21PM +0200, sascha hauer wrote:
> > On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
>
> ...
>
> > I wonder if it wouldn't be a better approach to just probe all devices
> > and record the device(node) they are waiting on. Then you know that you
> > don't need to probe them again until the device they are waiting for
> > is available.
>
> There may be no device, but resource. And we become again to the something like
> deferred probe ugly hack.
>
> The real solution is to rework device driver model in the kernel that it will
> create a graph of dependencies and then simply follow it. But actually it should
> be more than 1 graph, because there are resources and there are power, clock and
> resets that may be orthogonal to the higher dependencies (like driver X provides
> a resource to driver Y).

There is one graph, or it wouldn't be possible to shut down the system orderly.

The problem is that this graph is generally dynamic, especially during
system init, and following dependencies in transient states is
generally hard.

Device links allow the already known dependencies to be recorded and
taken into account later, so we already have a graph for those.

The unknown dependencies obviously cannot be used for creating a graph
of any sort, though, and here we are in the business of guessing what
the unknown dependencies may be IIUC.
