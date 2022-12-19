Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CA0650A6A
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiLSKyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiLSKyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:54:44 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D724F6446;
        Mon, 19 Dec 2022 02:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671447283; x=1702983283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UqqooEtrMV+dvuey2hZwSGHvztjA8kHAau/7RZeUH+w=;
  b=JQMlylBMW/Y4aIPR5+lc7lWOetoELAogaTuNwqBaTRSymbCTIxzd2lqh
   sKsAz307rNUSvLZL9BXO8jFlq5y+psMdQkqxW/k3u8Doinp24zFHECsGO
   iCy8BOCAgUVxU/E1RNAkyHGEE6GEC50Y7WcqEfxnr4he41bvYM9qokYiN
   fCtB5dsYLhsSisttwNy1adJpU0GmMMa5qRpyUqePiLZwX/VSL2jWDcbYi
   hZRngiP+Smc2F1E6xWFMlHqbhjjlD6diWXyn7GC/MAz85z6Whq2x3Y9rD
   RJSjhO+QydQUCS+DOLpcsYdZjeMMsHB4gitvOjPnPNDFXgQOtyOOBNLhl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="318010451"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="318010451"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 02:54:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="792836756"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="792836756"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 19 Dec 2022 02:54:37 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 417CAF7; Mon, 19 Dec 2022 12:55:06 +0200 (EET)
Date:   Mon, 19 Dec 2022 12:55:06 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH RFC net-next v2 1/2] i2c: add fwnode APIs
Message-ID: <Y6BDCl4VXygVrjCU@black.fi.intel.com>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
 <E1p7CoU-0012Ul-MM@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1p7CoU-0012Ul-MM@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 09:52:02AM +0000, Russell King (Oracle) wrote:
> Add fwnode APIs for finding and getting I2C adapters, which will be
> used by the SFP code. These are passed the fwnode corresponding to
> the adapter, and return the I2C adapter. It is the responsibility of
> the caller to find the appropriate fwnode.
> 
> We keep the DT and ACPI interfaces, but where appropriate, recode them
> to use the fwnode interfaces internally.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
