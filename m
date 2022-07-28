Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30B9584826
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiG1WU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiG1WU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:20:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3981D78DEA;
        Thu, 28 Jul 2022 15:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=alEH1WwUjVCElaffThQK0Suy1kY+uR7uRYgblI7vhIY=; b=Op
        Ms15cG37Mp5ahueu4ZFT91aBVuu61pybdt4tWRkuIM7bySs4MdBR1kl6u2Hx9+D0dgGNWDIk3n+aY
        wrMBqy8YSvxCbb1efxfD+jbOnArPvuG/95X11McX1vgHmmJpb8cGMctPOLCXLZ2xJS2FYKG/FVwAQ
        BGL4OVrAPmrgMCM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHBsA-00Bqex-7A; Fri, 29 Jul 2022 00:20:50 +0200
Date:   Fri, 29 Jul 2022 00:20:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to
 fwnode_find_net_device_by_node()
Message-ID: <YuMLwlqfhQoaNh6K@lunn.ch>
References: <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf>
 <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
 <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
 <20220727211112.kcpbxbql3tw5q5sx@skbuf>
 <CAPv3WKcc2i6HsraP3OSrFY0YiBOAHwBPxJUErg_0p7mpGjn3Ug@mail.gmail.com>
 <20220728195607.co75o3k2ggjlszlw@skbuf>
 <YuLvFQiZP6qmWcME@lunn.ch>
 <CAPv3WKeD_ZXeH-Y_YP91Ba6nZagzBVPoWbmFE8WtRw-NYxdEaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKeD_ZXeH-Y_YP91Ba6nZagzBVPoWbmFE8WtRw-NYxdEaA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 11:23:31PM +0200, Marcin Wojtas wrote:
> czw., 28 lip 2022 o 22:18 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > > The 'label' thing is actually one of the things that I'm seriously
> > > considering skipping parsing if this is an ACPI system, simply because
> > > best practices are different today than they were when the OF bindings
> > > were created.
> >
> > Agreed. We want the ACPI binding to learn from what has worked and not
> > worked in DT. We should clean up some of the historical mess. And
> > enforce things we don't in DT simply because there is too much
> > history.
> >
> > So a straight one to one conversion is not going to happen.
> 
> I understand your standpoint - there is a long history, possible
> clean-ups, backward compatibility considerations, etc. that should not
> be zero-day baggage of ACPI. Otoh, we don't need to be worried about
> the ACPI binding too much now - as agreed it was removed from this
> series, beginning from v2. IMO it may be better to return to that once
> the ACPI Spec is updated with the MDIOSerialBus and the patches are
> resubmitted on whatever shape of the DSA subsystem is established
> within the next weeks/months from now.
> 
> In v1 we discussed also the resubmission of the non-ACPI-related
> patches, which would pave the way to dropping the explicit OF_
> dependency in the DSA and moving to a generic hardware description
> kernel API - without any functional change.

Ideally, we want to keep all the ugly DT stuff in DT. We want to
ensure that any "generic hardware description kernel API" does not
inherit all the ugly DT stuff.

ACPI and DT are different things, so i don't see why they need to
share code.

      Andrew
