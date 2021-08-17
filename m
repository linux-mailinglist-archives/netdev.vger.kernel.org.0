Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A1F3EEA02
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhHQJhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:37:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:53022 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235124AbhHQJhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:37:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="195615318"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="195615318"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:36:45 -0700
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="676416363"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:36:43 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mFvWP-00Ah8m-U8; Tue, 17 Aug 2021 12:36:37 +0300
Date:   Tue, 17 Aug 2021 12:36:37 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <YRuDJUobH+ULYmZe@smile.fi.intel.com>
References: <20210817141643.0705a6e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817141643.0705a6e9@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 02:16:43PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/ptp/Kconfig
> 
> between commit:
> 
>   55c8fca1dae1 ("ptp_pch: Restore dependency on PCI")
> 
> from the net tree and commit:
> 
>   e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks, the result is correct.

> diff --cc drivers/ptp/Kconfig
> index e085c255da0c,823eae1b4b53..000000000000
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@@ -90,9 -103,8 +103,9 @@@ config PTP_1588_CLOCK_INE
>   config PTP_1588_CLOCK_PCH
>   	tristate "Intel PCH EG20T as PTP clock"
>   	depends on X86_32 || COMPILE_TEST
>  -	depends on HAS_IOMEM && NET
>  +	depends on HAS_IOMEM && PCI
>  +	depends on NET
> - 	imply PTP_1588_CLOCK
> + 	depends on PTP_1588_CLOCK
>   	help
>   	  This driver adds support for using the PCH EG20T as a PTP
>   	  clock. The hardware supports time stamping of PTP packets



-- 
With Best Regards,
Andy Shevchenko


