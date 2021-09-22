Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E546413EB2
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 02:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhIVAri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 20:47:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53272 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhIVArh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 20:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SsDk/XrP1AwPSiOD71NDEDCySTD+v4MTOEa9mTcxVkA=; b=wzcVZDrvuFZ9HHKwDn+nJtKT8m
        7A0yhl//EQd0moVGdM+TM1Yf2QudwgBtq7zuNsoMtkO7l+Syh3zeQbiQ+JVNHMUgAF+UboXxiJ//l
        HeDzAvzk+Lv/6WmclCH1d60nfClokjYNFXRyo7hEuYVIlEvjv9CTollsaTSPrK5ARiMQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSqOU-007hwP-WB; Wed, 22 Sep 2021 02:45:51 +0200
Date:   Wed, 22 Sep 2021 02:45:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for
 FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Message-ID: <YUp8vu1zUzBTz6WP@lunn.ch>
References: <YUoFFXtWFAhLvIoH@kroah.com>
 <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch>
 <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch>
 <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
 <YUpIgTqyrDRXMUyC@lunn.ch>
 <CAGETcx_50KQuj0L+MCcf2Se8kpFfZwJBKP0juh_T7w+ZCs2p+g@mail.gmail.com>
 <YUpW9LIcrcok8rBa@lunn.ch>
 <CAGETcx_CNyKU-tXT+1_089MpVHQaBoNiZs6K__MrRXzWSi6P8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_CNyKU-tXT+1_089MpVHQaBoNiZs6K__MrRXzWSi6P8g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Wait, what's the difference between a real fix vs a long term fix? To
> me those are the same.

Maybe the long term fix is you follow the phandle to the actual
resources, see it is present, and allow the probe? That brings you in
line with how things actually work with devices probing against
resources.

I don't know how much work that is, since there is no uniform API to
follow a phandle to a resource. I think each phandle type has its own
helper. For an interrupt phandle you need to use of_irq_get(), for a
gpio phandle maybe of_get_named_gpio_flags(), for a reset phandle
__of_reset_control_get(), etc.

Because this does not sounds too simple, maybe you can find something
simpler which is a real fix for now, good enough that it will get
merged, and then you can implement this phandle following for the long
term fix?

	 Andrew
