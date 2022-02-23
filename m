Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42B14C1692
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbiBWPWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241991AbiBWPWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:22:25 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32ED2CCA1;
        Wed, 23 Feb 2022 07:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645629708; x=1677165708;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0ZozrDOT5hEY8nbN0S1K7IzzFmPYdzqoUy5eruKY6N0=;
  b=MZfn4KsptiDz98zIkxEX3ayJcdcxL+mxrGV0mVXj2h4y7YUAU8xtxX2v
   0JeSBsTpd4i+b9qRcUUe1D9nGy2hnOObSUdEPGZ2+jLGSHJ/RrtIPOpvj
   4rJFo3cJhsmTIIcgGROqwi1K/tgEQ5ePOEx7vivua+Pe5DdGH0GmqlLtZ
   T12o0KZwQ9ul+23it0hZP+6g9HHB/+kU/xAb4HWmzympyuLGbrxKF1H8m
   lqGgYLLT0fVv5cQNdbffZNCT69hQXyMTH5rRduZcrVP1MCSn1e1pyxauu
   zU/ZtF+UJBKkcI8vaH+Um3a0haJD0mFU8+RVuS7/0kno0IX91v/W7i4SM
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="338423546"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="338423546"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:21:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="637461341"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 07:21:16 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 6BD39201C2;
        Wed, 23 Feb 2022 17:21:14 +0200 (EET)
Date:   Wed, 23 Feb 2022 17:21:14 +0200
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
Message-ID: <YhZQ6mZfQeVdNBR2@paasikivi.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-4-clement.leger@bootlin.com>
 <YhPQUPzz5vPvHUAy@smile.fi.intel.com>
 <20220222093921.24878bae@fixe.home>
 <YhZNMkwN3o40jDP5@paasikivi.fi.intel.com>
 <20220223161535.15f45d0e@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220223161535.15f45d0e@fixe.home>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 04:15:35PM +0100, Clément Léger wrote:
> Le Wed, 23 Feb 2022 17:05:22 +0200,
> Sakari Ailus <sakari.ailus@linux.intel.com> a écrit :
> 
> > > const void *device_get_match_data(struct device *dev)
> > > {
> > > 	if (!fwnode_has_op(fwnode, device_get_match_data)
> > > 		return fwnode_get_match_data(dev);
> > > 	return fwnode_call_ptr_op(dev_fwnode(dev),device_get_match_data, dev);
> > > }
> > > 
> > > But I thought it was more convenient to do it by setting the
> > > .device_get_match_data field of software_node operations.  
> > 
> > Should this function be called e.g. software_node_get_match_data() instead,
> > as it seems to be specific to software nodes?
> 
> Hi Sakari,
> 
> You are right, since the only user of this function currently is the
> software_node operations, then I should rename it and move it to
> swnode.c maybe.

It might be also fit to be used in OF, based on how it looks like.

But currently the original naming makes it seem an fwnode property API
function and that is misleading. I'd move this to swnode.c now with a new
software node specific name, and rethink the naming matter if there would
seem to be possibilities for code re-use.

-- 
Sakari Ailus
