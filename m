Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472D53FF4F6
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbhIBUdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbhIBUdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:33:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E61C061575;
        Thu,  2 Sep 2021 13:32:51 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s25so4846141edw.0;
        Thu, 02 Sep 2021 13:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X0qjDEGyIu9rzYFLWwmgoerPbUzMgWFfQroqEuwB9JU=;
        b=B6Udg4XDmUI1iuyP3qAtJ1Blcha/YUArvQ/Q/PC2atJ7Kfs1/kd2Tr8P2BOfJgajg5
         XbLayn5DulUXCgxivIqs0Sxj7M6dwZ6BC6zaZjqfh02MIMRGsZk5TU/5rWhIt++GELrQ
         YBOBk1MFLEXy/s2hYiCnV02a3+cqErJL8WhKEtWMWbp+Ez/fW+MKXBIOZ2utfYFT+oT4
         ysexm1I8IgcZ1CELkTS/l8ODG+uHZfwhKSuIZT4qYaBtFWvgrHT4/KVjv2laVQ/J/4GN
         YwET/KwVR9Sp5cVXYBkIVo22/Y+/HjTFFm6jRR2DxwEu8U8ojYF5rwxEa9DBbLnFBZnB
         3rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X0qjDEGyIu9rzYFLWwmgoerPbUzMgWFfQroqEuwB9JU=;
        b=JlYpMfF79aqNt7W7/ephgEYQVZgrjjJYYFfTYP8hudQrn1BtOmukcWJKN70i87o2DZ
         gxoTQNTcvilDVb6jtruh1EQVdVwlpujooUDYueN6ALwo81MtKY0A5/5SfBbS0JS8ONBm
         sLrO83qi66dl8jvifIUuT+amVOWPhXyW2/4Pb7Rw9jT+CEYWiM+Erm9LFvWmnlAq1UKo
         64GqUYvco9TGz69zmfTcHpWazY15IzXzZtXXTUjOwLT6rfDvsXLmd6bI2Ha0/JXHqYgp
         vtgHhpdiZ1sUXNGPISqx1Ry/sqCbyAS2HGZpujdUrrETlSl+6Rp+23lc2OT1YbzmB9Z4
         u/bA==
X-Gm-Message-State: AOAM532G5D8yjupmTPz/Z8QqnHXMJcgCk5jUT7HtECXpPAs8SI25gHkZ
        uf0GOOwq64t5cbVX0rTWkuQ=
X-Google-Smtp-Source: ABdhPJxDUDr8ed8YrnRw/o/YF/UeV8ClZtarD7oF7ezGtr4f06+cbb7ZdYmuZSm0sKbvNT3urXYBWw==
X-Received: by 2002:a05:6402:5148:: with SMTP id n8mr165714edd.277.1630614770176;
        Thu, 02 Sep 2021 13:32:50 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id f30sm1638442ejl.78.2021.09.02.13.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:32:49 -0700 (PDT)
Date:   Thu, 2 Sep 2021 23:32:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902203248.dy5b6ismgb55s5cd@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <YTEvFR2WGQmG3h/C@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTEvFR2WGQmG3h/C@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 10:07:49PM +0200, Andrew Lunn wrote:
> > The interrupt controller _has_ been set up. The trouble is that the
> > interrupt controller has the same OF node as the switch itself, and the
> > same OF node. Therefore, fw_devlink waits for the _entire_ switch to
> > finish probing, it doesn't have insight into the fact that the
> > dependency is just on the interrupt controller.
>
> That seems to be the problem. fw_devlink appears to think probe is an
> atomic operation. A device is not probed, or full probed. Where as the
> drivers are making use of it being non atomic.
>
> Maybe fw_devlink needs the third state, probing. And when deciding if
> a device can be probed and depends on a device which is currently
> probing, it looks deeper, follows the phandle and see if the resource
> is actually available?

This is interesting because there already exists a device link state for
when the consumer is "probing", but for the supplier, it's binary:

/**
 * enum device_link_state - Device link states.
 * @DL_STATE_NONE: The presence of the drivers is not being tracked.
 * @DL_STATE_DORMANT: None of the supplier/consumer drivers is present.
 * @DL_STATE_AVAILABLE: The supplier driver is present, but the consumer is not.
 * @DL_STATE_CONSUMER_PROBE: The consumer is probing (supplier driver present).
 * @DL_STATE_ACTIVE: Both the supplier and consumer drivers are present.
 * @DL_STATE_SUPPLIER_UNBIND: The supplier driver is unbinding.
 */

The check that's killing us is in device_links_check_suppliers, and is
for DL_STATE_AVAILABLE:

	list_for_each_entry(link, &dev->links.suppliers, c_node) {
		if (!(link->flags & DL_FLAG_MANAGED))
			continue;

		if (link->status != DL_STATE_AVAILABLE &&
		    !(link->flags & DL_FLAG_SYNC_STATE_ONLY)) {
			device_links_missing_supplier(dev);
			dev_err(dev, "probe deferral - supplier %s not ready\n",
				dev_name(link->supplier));
			ret = -EPROBE_DEFER;
			break;
		}
		WRITE_ONCE(link->status, DL_STATE_CONSUMER_PROBE);
	}

Anyway, I was expecting quite a different reaction from this patch
series, and especially one from Saravana. We are essentially battling to
handle an -EPROBE_DEFER we don't need (the battle might be worth it
though, in the general case, which is one of the reasons I posted them).

But these patches also solve DSA's issue with the circular dependency
between the switch and its internal PHYs, and nobody seems to have asked
the most important question: why?

The PHY should return -EPROBE_DEFER ad infinitum, since its supplier has
never finished probing by the time it calls phy_attach_direct.
