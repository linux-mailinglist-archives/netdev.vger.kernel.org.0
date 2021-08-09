Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BD83E4BF6
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhHISOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234847AbhHISOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 14:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5978561002;
        Mon,  9 Aug 2021 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628532859;
        bh=qXeJ0P/U8JvDxO9kR9G0/0wx57hQ6JjYEoFVv0vPQv8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=WW6aFqzA3dvX3Ze6M+eftHp7JaBZzCklo9aY7tR1PQm8w/hnkzEnuCle4tCjoZiSe
         nT6rKeORsoNdjHgHs9BqQjZRVKkrC6rxN1uu2Ygmc41jcEEm8UEVPbXxSnQ6K0Wfj8
         qSINXH8XorzrEZOa15qbiDu7ItPII0bkSjch0lXkcnkoO4HSU1QbFOtyKkGI+wZYNN
         0+0+St5OBLuFlSt+oW4UklxyjCkK/jpDv/4IACdl9gU6SOxr0i2z8LDiCotUp5Fcfn
         PGIel408/Vk6fQxN4caUeDLV9ODEWUpMqiy48I+zaYWawQn9qjAcLm5+IUrHSYXRZm
         w1DE8HFaMxc8g==
Date:   Mon, 9 Aug 2021 13:14:18 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>, x86@kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Taras Chornyi <tchornyi@marvell.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        qat-linux@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <simon.horman@corigine.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/6] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <20210809181418.GA2168343@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210807092645.52kn4ustyjudztvl@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 11:26:45AM +0200, Uwe Kleine-König wrote:
> On Fri, Aug 06, 2021 at 04:24:52PM -0500, Bjorn Helgaas wrote:
> > On Fri, Aug 06, 2021 at 08:46:23AM +0200, Uwe Kleine-König wrote:
> > > On Thu, Aug 05, 2021 at 06:42:34PM -0500, Bjorn Helgaas wrote:
> > 
> > > > I looked at all the bus_type.probe() methods, it looks like pci_dev is
> > > > not the only offender here.  At least the following also have a driver
> > > > pointer in the device struct:
> > > > 
> > > >   parisc_device.driver
> > > >   acpi_device.driver
> > > >   dio_dev.driver
> > > >   hid_device.driver
> > > >   pci_dev.driver
> > > >   pnp_dev.driver
> > > >   rio_dev.driver
> > > >   zorro_dev.driver
> > > 
> > > Right, when I converted zorro_dev it was pointed out that the code was
> > > copied from pci and the latter has the same construct. :-)
> > > See
> > > https://lore.kernel.org/r/20210730191035.1455248-5-u.kleine-koenig@pengutronix.de
> > > for the patch, I don't find where pci was pointed out, maybe it was on
> > > irc only.
> > 
> > Oh, thanks!  I looked to see if you'd done something similar
> > elsewhere, but I missed this one.
> > 
> > > > Looking through the places that care about pci_dev.driver (the ones
> > > > updated by patch 5/6), many of them are ... a little dubious to begin
> > > > with.  A few need the "struct pci_error_handlers *err_handler"
> > > > pointer, so that's probably legitimate.  But many just need a name,
> > > > and should probably be using dev_driver_string() instead.
> > > 
> > > Yeah, I considered adding a function to get the driver name from a
> > > pci_dev and a function to get the error handlers. Maybe it's an idea to
> > > introduce these two and then use to_pci_driver(pdev->dev.driver) for the
> > > few remaining users? Maybe doing that on top of my current series makes
> > > sense to have a clean switch from pdev->driver to pdev->dev.driver?!
> > 
> > I'd propose using dev_driver_string() for these places:
> > 
> >   eeh_driver_name() (could change callers to use dev_driver_string())
> >   bcma_host_pci_probe()
> >   qm_alloc_uacce()
> >   hns3_get_drvinfo()
> >   prestera_pci_probe()
> >   mlxsw_pci_probe()
> >   nfp_get_drvinfo()
> >   ssb_pcihost_probe()
> 
> So the idea is:
> 
> 	PCI: Simplify pci_device_remove()
> 	PCI: Drop useless check from pci_device_probe()
> 	xen/pci: Drop some checks that are always true
> 
> are kept as is as preparation. (Do you want to take them from this v2,
> or should I include them again in v3?)

Easiest if you include them until we merge the series.

> Then convert the list of functions above to use dev_driver_string() in a
> 4th patch.
> 
> > The use in mpt_device_driver_register() looks unnecessary: it's only
> > to get a struct pci_device_id *, which is passed to ->probe()
> > functions that don't need it.
> 
> This is patch #5.
> 
> > The use in adf_enable_aer() looks wrong: it sets the err_handler
> > pointer in one of the adf_driver structs.  I think those structs
> > should be basically immutable, and the drivers that call
> > adf_enable_aer() from their .probe() methods should set
> > ".err_handler = &adf_err_handler" in their static adf_driver
> > definitions instead.
> 
> I don't understand that one without some research, probably this yields
> at least one patch.

Yeah, it's a little messy because you'd have to make adf_err_handler
non-static and add an extern for it.  Sample below.

> > I think that basically leaves these:
> > 
> >   uncore_pci_probe()     # .id_table, custom driver "registration"
> >   match_id()             # .id_table, arch/x86/kernel/probe_roms.c
> >   xhci_pci_quirks()      # .id_table
> >   pci_error_handlers()   # roll-your-own AER handling, drivers/misc/cxl/guest.c
> > 
> > I think it would be fine to use to_pci_driver(pdev->dev.driver) for
> > these few.
> 
> Converting these will be patch 7 then and patch 8 can then drop the
> duplicated handling.
> 
> Sounds reasonable?

Sounds good to me.  Thanks for working on this!

Bjorn


diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index a8805c815d16..75e6c5540523 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -310,6 +310,7 @@ static struct pci_driver adf_driver = {
 	.probe = adf_probe,
 	.remove = adf_remove,
 	.sriov_configure = adf_sriov_configure,
+	.err_handler = adf_err_handler,
 };
 
 module_pci_driver(adf_driver);
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index d2ae293d0df6..701c3c5f8b9b 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -166,7 +166,7 @@ static void adf_resume(struct pci_dev *pdev)
 	dev_info(&pdev->dev, "Device is up and running\n");
 }
 
-static const struct pci_error_handlers adf_err_handler = {
+const struct pci_error_handlers adf_err_handler = {
 	.error_detected = adf_error_detected,
 	.slot_reset = adf_slot_reset,
 	.resume = adf_resume,
@@ -187,7 +187,6 @@ int adf_enable_aer(struct adf_accel_dev *accel_dev)
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	struct pci_driver *pdrv = pdev->driver;
 
-	pdrv->err_handler = &adf_err_handler;
 	pci_enable_pcie_error_reporting(pdev);
 	return 0;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index c61476553728..98a29e0b8769 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -95,6 +95,7 @@ void adf_ae_fw_release(struct adf_accel_dev *accel_dev);
 int adf_ae_start(struct adf_accel_dev *accel_dev);
 int adf_ae_stop(struct adf_accel_dev *accel_dev);
 
+extern const struct pci_error_handlers adf_err_handler;
 int adf_enable_aer(struct adf_accel_dev *accel_dev);
 void adf_disable_aer(struct adf_accel_dev *accel_dev);
 void adf_reset_sbr(struct adf_accel_dev *accel_dev);
