Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870094149BC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhIVMyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:54:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236001AbhIVMym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 08:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZWdV3Ywl5E2tBReyRKkp3nub36ib8xsMWJxoWC+tqZM=; b=EFXR3GlnMnGHIw2VtBsFrp4XLU
        5ZmpUW7Pwnd7V9z7BtVI69IYgbLKkBa6YZlMCO7gwM/msu3eBMkA6D41LWrWhJ8CTUtZbu05jLBzF
        wZNctlNM1G4dtdIURdc7QizcwaF+yTZLSOARQwfIhJGz8+sZ5pgpyDnZ0Fwt0UrZRNTg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mT1k9-007mXu-9X; Wed, 22 Sep 2021 14:52:57 +0200
Date:   Wed, 22 Sep 2021 14:52:57 +0200
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
Message-ID: <YUsnKX1pYc9K8f95@lunn.ch>
References: <YUocuMM4/VKzNMXq@lunn.ch>
 <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch>
 <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
 <YUpIgTqyrDRXMUyC@lunn.ch>
 <CAGETcx_50KQuj0L+MCcf2Se8kpFfZwJBKP0juh_T7w+ZCs2p+g@mail.gmail.com>
 <YUpW9LIcrcok8rBa@lunn.ch>
 <CAGETcx_CNyKU-tXT+1_089MpVHQaBoNiZs6K__MrRXzWSi6P8g@mail.gmail.com>
 <YUp8vu1zUzBTz6WP@lunn.ch>
 <CAGETcx9YPZ3nSF7ghjiaALa_DMJXqkR45-VL5SA+xT_jd7V+zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9YPZ3nSF7ghjiaALa_DMJXqkR45-VL5SA+xT_jd7V+zQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That goes back to Rafael's reply (and I agree):
> 
> "Also if the probe has already started, it may still return
> -EPROBE_DEFER at any time in theory, so as a rule the dependency is
> actually known to be satisfied when the probe has successfully
> completed."
> 
> So waiting for the probe to finish is the right behavior/intentional
> for fw_devlink.

But differs to how things actually work in the driver model. The
driver model does not care if a driver has finished probing, you can
use a resource as soon as it is registered. Hence this whole
problem/discussion.

	Andrew
