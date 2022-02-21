Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664EF4BE9F9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiBURtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:49:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiBURqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:46:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9530D104;
        Mon, 21 Feb 2022 09:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645465551; x=1677001551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OFeVuQJxbkfoS9+1vyjdsM6EYDJG7wppqkjlvIPVVkI=;
  b=Vf1n31GSqm4imwWNMvbNH4QpXNkVQzGQc8fikFVgNHyuYwKtf4/79UCR
   UYOk6U+I06A3sNMT0Pp7d2w8YE88OgyK3SMI38ZEmVodq7HIzUpCB8A6G
   5ZDi/dnOWErcTJotfQ3kPEetvfzxHCtEYRgHxgAtQ91KoVpH9AiXTUu0z
   NweaupwKR7a7wTDNaonObLk4sLY4NtxzDi87+dXz/nlWzcqM4u0IHv01M
   Tgvh2lGzzRxKO04QA+E8imICUHiOTf09k2NWdyPpUw3lGvQ/l2IB+9w/Q
   9dUjewp1SGJcy4vCb2Ugfowl1i/sCiAS5dSHY9VEhbaSH1UujEA4qErQe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="232169153"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="232169153"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:45:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="490508692"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:45:45 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMCk1-006ryd-5n;
        Mon, 21 Feb 2022 19:44:53 +0200
Date:   Mon, 21 Feb 2022 19:44:52 +0200
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
Subject: Re: [RFC 01/10] property: add fwnode_match_node()
Message-ID: <YhPPlFZGFvbNs+ZJ@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-2-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:43PM +0100, Clément Léger wrote:
> Add a function equivalent to of_match_node() which is usable for fwnode
> support. Matching is based on the compatible property and it returns
> the best matches for the node according to the compatible list
> ordering.

Not sure I understand the purpose of this API.
We have device_get_match_data(), maybe you want similar for fwnode?

-- 
With Best Regards,
Andy Shevchenko


