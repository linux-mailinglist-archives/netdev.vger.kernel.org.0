Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2164C161F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241901AbiBWPF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiBWPF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:05:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343C5B8227;
        Wed, 23 Feb 2022 07:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645628731; x=1677164731;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GpIZwevORM2TSatP2ZtsNzaCweqnETuuYDt5aPe0Q5k=;
  b=nhW5OANRO3wL0A3q4Tm99l+0hHiwRMVzKOYuYHkrVcC1jdLL7GbRrB3d
   prcnAE4UNzmh8nua0bSLSIWzM+SzWd6l5ggJI9EdaQiJA4u9P7+DfjWNx
   rAb8UTYQzgAEDf5feiAfwbmmOyWxnEk3d4rb7CZ2dvJM9YVxLokS2p+NQ
   9DGjmCCAMSksldWtJZ8fThm91kEi3j73XVWPybgcB7ML2l9C69co/AMTc
   8qXejNMtPuZfiv27pfYo5Ur5tAs2euUq8Hu25gFK6+7wyTWhuqu0RNQTP
   Wcd/ZEtIaKQr0PG2vL08fEpmiR2OD+Y4u4jjh4xUnNdYK4n0OKH9pImUq
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="249564799"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="249564799"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:05:29 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="591729239"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:05:24 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 1C750201C2;
        Wed, 23 Feb 2022 17:05:22 +0200 (EET)
Date:   Wed, 23 Feb 2022 17:05:22 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Subject: Re: [RFC 03/10] base: swnode: use fwnode_get_match_data()
Message-ID: <YhZNMkwN3o40jDP5@paasikivi.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-4-clement.leger@bootlin.com>
 <YhPQUPzz5vPvHUAy@smile.fi.intel.com>
 <20220222093921.24878bae@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220222093921.24878bae@fixe.home>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Tue, Feb 22, 2022 at 09:39:21AM +0100, Clément Léger wrote:
> Le Mon, 21 Feb 2022 19:48:00 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> 
> > On Mon, Feb 21, 2022 at 05:26:45PM +0100, Clément Léger wrote:
> > > In order to allow matching devices with software node with
> > > device_get_match_data(), use fwnode_get_match_data() for
> > > .device_get_match_data operation.  
> > 
> > ...
> > 
> > > +	.device_get_match_data = fwnode_get_match_data,  
> > 
> > Huh? It should be other way around, no?
> > I mean that each of the resource providers may (or may not) provide a
> > method for the specific fwnode abstraction.
> > 
> 
> Indeed, it should be the other way. But since this function is generic
> and uses only fwnode API I guessed it would be more convenient to
> define it in the fwnode generic part and use it for specific
> implementation. I could have modified device_get_match_data to call it
> if there was no .device_get_match_data operation like this:
> 
> const void *device_get_match_data(struct device *dev)
> {
> 	if (!fwnode_has_op(fwnode, device_get_match_data)
> 		return fwnode_get_match_data(dev);
> 	return fwnode_call_ptr_op(dev_fwnode(dev),device_get_match_data, dev);
> }
> 
> But I thought it was more convenient to do it by setting the
> .device_get_match_data field of software_node operations.

Should this function be called e.g. software_node_get_match_data() instead,
as it seems to be specific to software nodes?

-- 
Regards,

Sakari Ailus
