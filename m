Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60AA4C3474
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbiBXSQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiBXSP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:15:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EAA253151;
        Thu, 24 Feb 2022 10:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645726529; x=1677262529;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XijmOSBFg2r2w0bH7u5K1EPX285/C0Q7dvemmZGlDXA=;
  b=WI4UE60KOL4tDE9N2Co+B+hm6iO8Wn+l5cQHAyfhWJ2/fRMrxtWOe9qr
   XQOieByuYKl8GMwGrlX6hf+JXPHznZQzOxRTQ86zMHP2cd81tsWH2luLN
   KgBrSDMqsQ2vTx5MkQkF7SPSp+GLngX3TqjxFUkgi5VuRdEg03WNvgxBN
   VR9zMBMlkpeWy0OzhgjOLitC9JEZUDLVQ8mGUnJ+rgEguur/JnnKGVqJE
   AggrMpcZj8EaRSVWAJvIaHshV/sQ7N3Suhnr6X9ar23bMj98g6A8hONtm
   MIX1TgzNa4wCNwyENlC7waAZVEZrA5IgWUXaHIdLfrOHLSjuGYqpLbzX4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="232934278"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="232934278"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 10:15:28 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="777145359"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 10:15:24 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id 056B5203BA;
        Thu, 24 Feb 2022 20:14:52 +0200 (EET)
Date:   Thu, 24 Feb 2022 20:14:51 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhfLG6wlFvYY3YU8@paasikivi.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
 <YhelOFYKBsfQ8SRW@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhelOFYKBsfQ8SRW@sirena.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Thu, Feb 24, 2022 at 03:33:12PM +0000, Mark Brown wrote:
> On Thu, Feb 24, 2022 at 03:58:04PM +0100, Hans de Goede wrote:
> 
> > As Mark already mentioned the regulator subsystem has shown to
> > be a bit problematic here, but you don't seem to need that?
> 
> I believe clocks are also potentially problematic for similar reasons
> (ACPI wants to handle those as part of the device level power management
> and/or should have native abstractions for them, and I think we also
> have board file provisions that work well for them and are less error
> prone than translating into an abstract data structure).

Per ACPI spec, what corresponds to clocks and regulators in DT is handled
through power resources. This is generally how things work in ACPI based
systems but there are cases out there where regulators and/or clocks are
exposed to software directly. This concerns e.g. camera sensors and lens
voice coils on some systems while rest of the devices in the system are
powered on and off the usual ACPI way.

So controlling regulators or clocks directly on an ACPI based system
wouldn't be exactly something new. All you need to do in that case is to
ensure that there's exactly one way regulators and clocks are controlled
for a given device. For software nodes this is a non-issue.

This does have the limitation that a clock or a regulator is either
controlled through power resources or relevant drivers, but that tends to
be the case in practice. But I presume it wouldn't be different with board
files.

-- 
Sakari Ailus
