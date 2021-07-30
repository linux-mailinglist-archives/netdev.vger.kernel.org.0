Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44D63DB4E3
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 10:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhG3IGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 04:06:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:13027 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbhG3IGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 04:06:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="213084655"
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="213084655"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 01:06:43 -0700
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="635393118"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 01:06:29 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1m9NXA-003JSv-6T; Fri, 30 Jul 2021 11:06:20 +0300
Date:   Fri, 30 Jul 2021 11:06:20 +0300
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Michael Buesch <m@bues.ch>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        xen-devel@lists.xenproject.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v1 0/5] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <YQOy/OTvY66igEoe@smile.fi.intel.com>
References: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 10:37:35PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> struct pci_dev tracks the bound pci driver twice. This series is about
> removing this duplication.
> 
> The first two patches are just cleanups. The third patch introduces a
> wrapper that abstracts access to struct pci_dev->driver. In the next
> patch (hopefully) all users are converted to use the new wrapper and
> finally the fifth patch removes the duplication.
> 
> Note this series is only build tested (allmodconfig on several
> architectures).
> 
> I'm open to restructure this series if this simplifies things. E.g. the
> use of the new wrapper in drivers/pci could be squashed into the patch
> introducing the wrapper. Patch 4 could be split by maintainer tree or
> squashed into patch 3 completely.

I see only patch 4 and this cover letter...

-- 
With Best Regards,
Andy Shevchenko


