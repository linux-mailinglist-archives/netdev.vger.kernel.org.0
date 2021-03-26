Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A59934B17B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhCZVnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:43:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:19095 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhCZVnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 17:43:05 -0400
IronPort-SDR: 6I8C7xiNI4hl0x0sMjkEfMFjh97pt4AAMix1MxNV6AED9P5D3Go6CaHRquU6ylhjDAXZuPIfqh
 gEtOkl7UnX2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="178352800"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="178352800"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 14:42:59 -0700
IronPort-SDR: cNojrf+tiikCPGWgRb3ibY3Q/jovmS8uKWnJmBvLnZfc+CV7+xWZZ05N7eGLEjHmDUBPP/m7Xc
 U7ViBKcq2BbQ==
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="437024048"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 14:42:51 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lPuEA-00GV4K-I1; Fri, 26 Mar 2021 23:42:46 +0200
Date:   Fri, 26 Mar 2021 23:42:46 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
Message-ID: <YF5VVjQ7q/JBSR1Z@smile.fi.intel.com>
References: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com>
 <20210326212655.GA912670@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326212655.GA912670@bjorn-Precision-5520>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 04:26:55PM -0500, Bjorn Helgaas wrote:
> [+cc Randy, Andrew (though I'm sure you have zero interest in this
> ancient question :))]
> 
> On Wed, Dec 09, 2020 at 09:31:21AM +0100, Heiner Kallweit wrote:
> > pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
> > former one is declared as __must_check. However also some callers of
> > pci_set_mwi() have a comment that it's an optional feature. I don't
> > think there's much sense in this separation and the use of
> > __must_check. Therefore remove pci_try_set_mwi() and remove the
> > __must_check attribute from pci_set_mwi().
> > I don't expect either function to be used in new code anyway.
> 
> There's not much I like better than removing things.  But some
> significant thought went into adding pci_try_set_mwi() in the first
> place, so I need a little more convincing about why it's safe to
> remove it.
> 
> The argument should cite the discussion about adding it.  I think one
> of the earliest conversations is here:
> https://lore.kernel.org/linux-ide/20070404213704.224128ec.randy.dunlap@oracle.com/

It's solely PCI feature which is absent on PCIe.

So, if there is a guarantee that the driver never services a device connected
to old PCI bus, it's okay to remove the call (it's no-op on PCIe anyway).

OTOH, PCI core may try MWI itself for every device (but this is an opposite,
what should we do on broken devices that do change their state based on that
bit while violating specification).

In any case

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

for DesignWare DMA case. I have added that and I never saw that IP connected
to the old PCI.

-- 
With Best Regards,
Andy Shevchenko


