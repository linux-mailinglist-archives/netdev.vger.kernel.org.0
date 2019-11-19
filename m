Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202B4102215
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKSK1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:27:46 -0500
Received: from mga12.intel.com ([192.55.52.136]:4760 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfKSK1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 05:27:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 02:27:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,322,1569308400"; 
   d="scan'208";a="237281749"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002.fm.intel.com with ESMTP; 19 Nov 2019 02:27:44 -0800
Received: from andy by smile with local (Exim 4.93-RC1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iX0jY-0002EQ-32; Tue, 19 Nov 2019 12:27:44 +0200
Date:   Tue, 19 Nov 2019 12:27:44 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 1/1] mdio_bus: fix mdio_register_device when
 RESET_CONTROLLER is disabled
Message-ID: <20191119102744.GD32742@smile.fi.intel.com>
References: <20191118181505.32298-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191118181505.32298-1-marek.behun@nic.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 07:15:05PM +0100, Marek Behún wrote:
> When CONFIG_RESET_CONTROLLER is disabled, the
> devm_reset_control_get_exclusive function returns -ENOTSUPP. This is not
> handled in subsequent check and then the mdio device fails to probe.
> 
> When CONFIG_RESET_CONTROLLER is enabled, its code checks in OF for reset
> device, and since it is not present, returns -ENOENT. -ENOENT is handled.
> Add -ENOTSUPP also.
> 
> This happened to me when upgrading kernel on Turris Omnia. You either
> have to enable CONFIG_RESET_CONTROLLER or use this patch.

In the long term prospective shouldn't it use
reset_control_get_optional_exclusive() instead?

-- 
With Best Regards,
Andy Shevchenko


