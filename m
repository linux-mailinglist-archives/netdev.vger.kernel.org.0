Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2D42BDDA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhJMK4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhJMK4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 06:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85F6E60ED4;
        Wed, 13 Oct 2021 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634122469;
        bh=7iHTFHMgD8tHMQJ8um3MWnq2WmS30AxI0TP6/V1BtV4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OqtFMqGMGFV4K9yVj94P1PdYhryA/CdqOslHcpNhaQ08AmoURmbWpdbwgGLpBRtvv
         GOsgbbkXEnNemfGxenULuEuLWhQSBLZDlcXtsIPUtWRz0Xquu4nM3on/FjIIYLKVym
         bnMheTYnvnPKKCMeJmHy92kqkk6lJLUVe2jWrwP9ZfoZxr9KzicovqTES+nvgUJrgd
         CW5TCOmBqfvu1ALAWILVarLhtB0Ty7o6Te/0Wlj3D4Ep4xDYZe5KxmPTRIsD28cE8M
         U3L0ny1u+JWyxeAAoH7731EvVOLTcEPfK9OIXkjw0dh6LOeY9oV0Ng9JEnXKuTIMCX
         IWg5mdhv7zLQg==
Date:   Wed, 13 Oct 2021 05:54:28 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>, x86@kernel.org,
        qat-linux@intel.com, oss-drivers@corigine.com,
        Oliver O'Halloran <oohall@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jack Xu <jack.xu@intel.com>, Borislav Petkov <bp@alien8.de>,
        Michael Buesch <m@bues.ch>, Jiri Pirko <jiri@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v6 00/11] PCI: Drop duplicated tracking of a pci_dev's
 bound driver
Message-ID: <20211013105428.GA1890798@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211013085131.5htnch5p6zv46mzn@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 10:51:31AM +0200, Uwe Kleine-König wrote:
> On Tue, Oct 12, 2021 at 06:32:12PM -0500, Bjorn Helgaas wrote:
> > On Mon, Oct 04, 2021 at 02:59:24PM +0200, Uwe Kleine-König wrote:
> > > Hello,
> > > 
> > > this is v6 of the quest to drop the "driver" member from struct pci_dev
> > > which tracks the same data (apart from a constant offset) as dev.driver.
> > 
> > I like this a lot and applied it to pci/driver for v5.16, thanks!
> > 
> > I split some of the bigger patches apart so they only touched one
> > driver or subsystem at a time.  I also updated to_pci_driver() so it
> > returns NULL when given NULL, which makes some of the validations
> > quite a bit simpler, especially in the PM code in pci-driver.c.
> 
> OK.
> 
> > Full interdiff from this v6 series:
> > 
> > diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
> > index deaaef6efe34..36e84d904260 100644
> > --- a/arch/x86/kernel/probe_roms.c
> > +++ b/arch/x86/kernel/probe_roms.c
> > @@ -80,17 +80,15 @@ static struct resource video_rom_resource = {
> >   */
> >  static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
> >  {
> > +	struct pci_driver *drv = to_pci_driver(pdev->dev.driver);
> >  	const struct pci_device_id *id;
> >  
> >  	if (pdev->vendor == vendor && pdev->device == device)
> >  		return true;
> >  
> > -	if (pdev->dev.driver) {
> > -		struct pci_driver *drv = to_pci_driver(pdev->dev.driver);
> > -		for (id = drv->id_table; id && id->vendor; id++)
> > -			if (id->vendor == vendor && id->device == device)
> > -				break;
> > -	}
> > +	for (id = drv ? drv->id_table : NULL; id && id->vendor; id++)
> > +		if (id->vendor == vendor && id->device == device)
> > +			break;
> >  
> >  	return id && id->vendor;
> >  }
> > diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
> > index d997c9c3ebb5..7eb3706cf42d 100644
> > --- a/drivers/misc/cxl/guest.c
> > +++ b/drivers/misc/cxl/guest.c
> > @@ -20,38 +20,38 @@ static void pci_error_handlers(struct cxl_afu *afu,
> >  				pci_channel_state_t state)
> >  {
> >  	struct pci_dev *afu_dev;
> > +	struct pci_driver *afu_drv;
> > +	struct pci_error_handlers *err_handler;
> 
> These two could be moved into the for loop (where afu_drv was with my
> patch already). This is also possible in a few other drivers.

That's true, they could.  I tried to follow the prevailing style in
the file.  At least in cxl, I didn't see any other cases of
declarations being in the minimal scope like that.

Bjorn
