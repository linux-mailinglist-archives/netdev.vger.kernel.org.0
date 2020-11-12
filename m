Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5012B0071
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 08:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKLHmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 02:42:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:21554 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgKLHmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 02:42:05 -0500
IronPort-SDR: t2PVUlgrtzVIM/1j1E0EfiTnS3m8n4VvPljQnYiz5ZWYQjFFfT9yffPutJSS7vvPcizmqvG4GM
 G95ct/Hn9JzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="169486939"
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="169486939"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 23:42:03 -0800
IronPort-SDR: fOS0fEC/RpEPzpI6YHZeAKkrZiP3VuvhNoWoYlHcHNMEsoG7jqHG0mh3WpuXy3PIhzSJF0BBOv
 Ds7zhhUTLpCw==
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="474177420"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 23:42:00 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 12 Nov 2020 09:41:58 +0200
Date:   Thu, 12 Nov 2020 09:41:58 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Christian Eggers <ceggers@gmx.de>
Cc:     thunderbolt-software@lists.01.org,
        Christian Kellner <christian@kellner.me>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Gil Fine <gil.fine@intel.com>, netdev@vger.kernel.org
Subject: Re: thunderbolt: How to disconnect without physically unplugging
Message-ID: <20201112074158.GP2495@lahna.fi.intel.com>
References: <12647082.uLZWGnKmhe@zbook-opensuse.wgnetz.xx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12647082.uLZWGnKmhe@zbook-opensuse.wgnetz.xx>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Nov 12, 2020 at 07:55:23AM +0100, Christian Eggers wrote:
> Hi,
> 
> sorry for asking "user" questions directly to developers. But I didn't find a
> better place for asking.
> 
> I own a "hp zbook thunderbolt 3 dock". This docking station has 2 thunderbolt
> connectors, the first (primary?) is connected to my personal laptop and the
> other port I use for my company's laptop for working at home. It seems that
> only one laptop at a time can access the dock peripherals (display port,
> ethernet, usb) at a time.

Yes, this is the way the protocol works. Only one host can enumerate a
device.

> Unfortunately there is no button for selecting the "active" port (like on a KVM
> switch), so the only way for switching between the two laptops is pulling the
> cable every time (unplugging the "active" laptop for a short period lets the
> dock automatically switch to the "inactive" laptop).
> 
> Is there a possibility to do this "short disconnect" in software (either
> - by raising an "unplug" sequence to to the thunderbolt itself, or
> - by temporarily removing the thunderbolt controller from the PCI bus)?

Not with the currect systems out there. With USB4 and software based
connection manager this could be done by disabling the lanes but that is
not implemented in the driver.

> My concern is that pulling the cables multiple times a day would wear out the
> connectors quickly and render my hardware unusable. Additionally I see not much
> value having two connectors on the dock when I have to manually plug cables
> anyway (although the dock may offer the ability to establish a "thunderbolt
> networking connection" between both laptops).

The idea of the two connectors (and with USB4 more than two) is that you
can plug more periperals there as a sort of "daisy chain". TBT3 it is up
to 6 peripherals and then you can plug in a monitor as 7th device and
another host of course to allow networking or so.

What I've seen many docks actually only charge at one port so you may
need to physically unplug and plug the laptops anyway. The Type-C
connectors I've used seem to be pretty durable compared to USB micro-B
connectors so hard to imagine that they would "wear out" from this.
