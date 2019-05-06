Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB80414E35
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfEFOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 10:42:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:16244 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbfEFOml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 10:42:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 May 2019 07:42:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,438,1549958400"; 
   d="scan'208";a="140532081"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by orsmga008.jf.intel.com with ESMTP; 06 May 2019 07:42:38 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hNepA-0006aJ-R8; Mon, 06 May 2019 17:42:36 +0300
Date:   Mon, 6 May 2019 17:42:36 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 net-next tree
Message-ID: <20190506144236.GL9224@smile.fi.intel.com>
References: <20190506204303.0d0082d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506204303.0d0082d7@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 08:43:03PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in:
> 
>   lib/Makefile
> 
> between commit:
> 
>   554aae35007e ("lib: Add support for generic packing operations")
> 
> from the net-next tree and commit:
> 
>   1a1e7f563bd5 ("lib: Move mathematic helpers to separate folder")
> 
> from the akpm-current tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 

Seems correct to me.
Thanks!

> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc lib/Makefile
> index 83d7df2661ff,4eeb814eee2e..000000000000
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@@ -17,20 -17,9 +17,20 @@@ KCOV_INSTRUMENT_list_debug.o := 
>   KCOV_INSTRUMENT_debugobjects.o := n
>   KCOV_INSTRUMENT_dynamic_debug.o := n
>   
>  +# Early boot use of cmdline, don't instrument it
>  +ifdef CONFIG_AMD_MEM_ENCRYPT
>  +KASAN_SANITIZE_string.o := n
>  +
>  +ifdef CONFIG_FUNCTION_TRACER
>  +CFLAGS_REMOVE_string.o = -pg
>  +endif
>  +
>  +CFLAGS_string.o := $(call cc-option, -fno-stack-protector)
>  +endif
>  +
>   lib-y := ctype.o string.o vsprintf.o cmdline.o \
>   	 rbtree.o radix-tree.o timerqueue.o xarray.o \
> - 	 idr.o int_sqrt.o extable.o \
> + 	 idr.o extable.o \
>   	 sha1.o chacha.o irq_regs.o argv_split.o \
>   	 flex_proportions.o ratelimit.o show_mem.o \
>   	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> @@@ -120,8 -110,6 +122,7 @@@ obj-$(CONFIG_DEBUG_LIST) += list_debug.
>   obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
>   
>   obj-$(CONFIG_BITREVERSE) += bitrev.o
>  +obj-$(CONFIG_PACKING)	+= packing.o
> - obj-$(CONFIG_RATIONAL)	+= rational.o
>   obj-$(CONFIG_CRC_CCITT)	+= crc-ccitt.o
>   obj-$(CONFIG_CRC16)	+= crc16.o
>   obj-$(CONFIG_CRC_T10DIF)+= crc-t10dif.o



-- 
With Best Regards,
Andy Shevchenko


