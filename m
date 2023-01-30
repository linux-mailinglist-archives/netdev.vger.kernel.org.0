Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FB5680DB1
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbjA3Mbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbjA3Mb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:31:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8368C367DA;
        Mon, 30 Jan 2023 04:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675081887; x=1706617887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Us4t9RfFIA7QDDFmTvE79SoNQbhU2WQe72gtsd+ApzY=;
  b=dyChAvkIXOiUF12arWmG1yEJFd2ihEPZMLleSPUGPY3HGnxvr5ELrzMP
   RRHOT+tZTJG/buGW3Xc8lZvkZoJcnd46WS/YluJlEOXw5HXLfZA16HRl8
   zEnkSP9QTP5WTrxpmJiUI0cbR9FQbGRT7FgqKzeYux+IGd73dVb0xumrd
   yAzSpml9X68gjR714qWRs5XOSlrjO31MCcQk1w2zscctCGmZ+n4TY8O+U
   cwGaF58OGEVuTOa6SDUgMVualuSpsBpYL5OvaEQsKR8eqihoLjqPMJ9kO
   xBuzWw1vEmQphx5xQUhxholexU83OgMbK+/KG9LdlLoq/mfRZQojWHl1Q
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="327562232"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="327562232"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:31:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="696379714"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="696379714"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2023 04:31:18 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pMTJc-00HLVK-33;
        Mon, 30 Jan 2023 14:31:16 +0200
Date:   Mon, 30 Jan 2023 14:31:16 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 net-next tree
Message-ID: <Y9e4lFKZMylweoQF@smile.fi.intel.com>
References: <20230130153229.6cb70418@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130153229.6cb70418@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 03:32:29PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the driver-core tree got a conflict in:
> 
>   include/linux/acpi.h
> 
> between commit:
> 
>   1b94ad7ccc21 ("ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_dsm() stubs")
> 
> from the net-next tree and commit:
> 
>   162736b0d71a ("driver core: make struct device_type.uevent() take a const *")
> 
> from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Seems correct, thank you!

-- 
With Best Regards,
Andy Shevchenko


