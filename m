Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538F44BEA06
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiBURzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:55:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiBURxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:53:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B32FDEEB;
        Mon, 21 Feb 2022 09:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645465738; x=1677001738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=zwiNRlhLeWQqN35/KdrWsXpG2B+PLJoioW20hr3nYM4=;
  b=Fpj6r1A0icBVFRchNGO1e+H1iS37obos0vdGnmhX9q/wYCFMcAwBlGUV
   z4h5n+FpGvqCHbsc1dsVexNhdj02ZvolJ4/cvi/W11q3fIpJM6ojqGryz
   ZTA6Q5ZPmB/4NzaWXkSCL2vlI+4p0NKoQ6q/nBMjDwAI7gpt/e9Ii3O53
   Tiwso0TRkuAwPZPJj0AsJCggvnOjEiNnkcPUkIN1HIMphaaLZm23AeeMi
   c2ekN99W7mp+X5hFxhpoSI0gpm/2hc6KDPuotb/0ysLk3tVQIKqScLwYp
   rUNHmXwvIXlesGH5enw4pg2bBxVd/ywRIqybKOKl+KFNrdirgzY1t0nuL
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251732801"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251732801"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:48:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="507704887"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:48:53 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMCn2-006s1L-U8;
        Mon, 21 Feb 2022 19:48:00 +0200
Date:   Mon, 21 Feb 2022 19:48:00 +0200
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
Subject: Re: [RFC 03/10] base: swnode: use fwnode_get_match_data()
Message-ID: <YhPQUPzz5vPvHUAy@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-4-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-4-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:45PM +0100, Clément Léger wrote:
> In order to allow matching devices with software node with
> device_get_match_data(), use fwnode_get_match_data() for
> .device_get_match_data operation.

...

> +	.device_get_match_data = fwnode_get_match_data,

Huh? It should be other way around, no?
I mean that each of the resource providers may (or may not) provide a method
for the specific fwnode abstraction.

-- 
With Best Regards,
Andy Shevchenko


