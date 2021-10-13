Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4AF42C156
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhJMNZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:25:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:29501 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhJMNZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 09:25:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="208223337"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="208223337"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 06:23:29 -0700
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="626341116"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.159])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 06:23:15 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1maeDt-000LPO-Od;
        Wed, 13 Oct 2021 16:23:09 +0300
Date:   Wed, 13 Oct 2021 16:23:09 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        linux-pci <linux-pci@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jack Xu <jack.xu@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Russell Currey <ruscur@russell.cc>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        USB <linux-usb@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, netdev <netdev@vger.kernel.org>,
        oss-drivers@corigine.com, qat-linux@intel.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <YWbdvc7EWEZLVTHM@smile.fi.intel.com>
References: <CAHp75Vd0uYEdfB0XaQuUV34V91qJdHR5ARku1hX_TCJLJHEjxQ@mail.gmail.com>
 <20211013113356.GA1891412@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211013113356.GA1891412@bhelgaas>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 06:33:56AM -0500, Bjorn Helgaas wrote:
> On Wed, Oct 13, 2021 at 12:26:42PM +0300, Andy Shevchenko wrote:
> > On Wed, Oct 13, 2021 at 2:33 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Mon, Oct 04, 2021 at 02:59:24PM +0200, Uwe Kleine-König wrote:

...

> > It's a bit unusual. Other to_*_dev() are not NULL-aware IIRC.
> 
> It is a little unusual.  I only found three of 77 that are NULL-aware:
> 
>   to_moxtet_driver()
>   to_siox_driver()
>   to_spi_driver()
> 
> It seems worthwhile to me because it makes the patch and the resulting
> code significantly cleaner.

I'm not objecting the change, just a remark.

...

> > > +       for (id = drv ? drv->id_table : NULL; id && id->vendor; id++)
> > > +               if (id->vendor == vendor && id->device == device)
> > 
> > > +                       break;
> > 
> > return true;
> > 
> > >         return id && id->vendor;
> > 
> > return false;
> 
> Good cleanup for a follow-up patch, but doesn't seem directly related
> to the objective here.

True. Maybe you can bake one while not forgotten?

...

> > > +       return drv && drv->resume ?
> > > +                       drv->resume(pci_dev) : pci_pm_reenable_device(pci_dev);
> > 
> > One line?
> 
> I don't think I touched that line.

Then why they are both in + section?

...

> > > +       struct pci_driver *drv = to_pci_driver(dev->dev.driver);
> > >         const struct pci_error_handlers *err_handler =
> > > -                       dev->dev.driver ? to_pci_driver(dev->dev.driver)->err_handler : NULL;
> > > +                       drv ? drv->err_handler : NULL;
> > 
> > Isn't dev->driver == to_pci_driver(dev->dev.driver)?
> 
> Yes, I think so, but not sure what you're getting at here, can you
> elaborate?

Getting pointer from another pointer seems waste of resources, why we
can't simply

	struct pci_driver *drv = dev->driver;

?

...

> > Stray change? Or is it in a separate patch in your tree?
> 
> Could be skipped.  The string now fits on one line so I combined it to
> make it more greppable.

This is inconsistency in your changes, in one case you are objecting of
doing something close to the changed lines, in the other you are doing
unrelated change.

-- 
With Best Regards,
Andy Shevchenko


