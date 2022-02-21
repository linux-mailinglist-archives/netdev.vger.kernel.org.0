Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51174BEA9F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiBUSKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:10:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiBUSIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:08:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD2E027;
        Mon, 21 Feb 2022 09:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645466316; x=1677002316;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=F5Erzo7moAppweyNzBFU2zwfIhgVP+wmsJ3bqhuiQtI=;
  b=AmpnkJ7k18zZY+NRIcEeF3ANyA2owVqL4Eq1BXiF2gvtGBhTuvSwpot2
   f/d6aUM59PA3DbMHoWxxm03fwT0pXawR8WhshovA8xR/nN7zjwYsBLNgO
   DG/cKv479GzttmeO252R5CaAeTEYW7ky1dYA9+D46np++Z6c4OU1dad3K
   0LHpf6N48je4W8+Zlk6zMOT+InCGNURxhzE5n4N+V8N89IEGHWaZA8aOl
   vCeW+YEG0bn5gKHfsl8tbCHt2VavN93cw8FF8bzfMOFr7Nwf+v624G2M2
   8yW3ziMt4Pr7hrv1tV/M48VjyGTf44wraeQ4yorRX9ims8p24Vl89Tnm3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251307194"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251307194"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:58:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="636735094"
Received: from smile.fi.intel.com ([10.237.72.59])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:58:31 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMCwN-006s9N-GW;
        Mon, 21 Feb 2022 19:57:39 +0200
Date:   Mon, 21 Feb 2022 19:57:39 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
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
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <YhPSkz8+BIcdb72R@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-11-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:52PM +0100, Clément Léger wrote:
> Add support to retrieve a i2c bus in sfp with a fwnode. This support
> is using the fwnode API which also works with device-tree and ACPI.
> For this purpose, the device-tree and ACPI code handling the i2c
> adapter retrieval was factorized with the new code. This also allows
> i2c devices using a software_node description to be used by sfp code.

If I'm not mistaken this patch can even go separately right now, since all used
APIs are already available.

-- 
With Best Regards,
Andy Shevchenko


