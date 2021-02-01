Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61AF30A011
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 02:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhBABor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 20:44:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40610 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhBABoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Jan 2021 20:44:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l6OFx-003Z9c-1A; Mon, 01 Feb 2021 02:43:57 +0100
Date:   Mon, 1 Feb 2021 02:43:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadim Pasternak <vadimp@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBdc3c26Af6chAZM@lunn.ch>
References: <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
 <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion>
 <YBQujIdnFtEhWqTF@lunn.ch>
 <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Platform line card driver is aware of line card I2C topology, its
> responsibility is to detect line card basic hardware type, create I2C
> topology (mux), connect all the necessary I2C devices, like hotswap
> devices, voltage and power regulators devices, iio/a2d devices and line
> card EEPROMs, creates LED instances for LED located on a line card, exposes
> line card related attributes, like CPLD and FPGA versions, reset causes,
> required powered through line card hwmon interface.

Jiri says the hardware is often connected to the BMC. But you do
expose much of this to the host as well? You want devlink dev info to
show the version information. Use devlink dev flash to upgrade the
bitfile in the CPD and FPGA. The hwmon instances are pretty pointless
on the BMC where nobody can see them. Are there temperature sensors
involved? The host is where the thermal policy is running, deciding
what to throttle, or shut down when it gets too hot. LEDs can be
controlled via /sys/class/led as expected?

So exporting what the line card actually is to the host is not really
a problem, it is just one more bit of information amongst everything
else already exposed to it.

	Andrew
