Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF33D201F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhGVIFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhGVIFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A43AE6128C;
        Thu, 22 Jul 2021 08:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626943559;
        bh=iHEKpKP05yPtSDo0WVw13tR4OsPIw3x7iurEQu7Pc7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d2l4V14jYNVya/romP2w2ezg4x2LnX47K9dLSJmCxQOKyIqkdonEoIsuSyzycFfD4
         aHamBXJweC7B8K4Qi3lPBaud6oc7vHctb7fViEzj6oXWZWpeL9VSuOZpThr23TyNei
         Kh7xAATxCTMeB2NBX21iFqK668swZChaCi9FSwpo=
Date:   Thu, 22 Jul 2021 10:45:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     kernel@pengutronix.de,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, Alex Elder <elder@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andy Gross <agross@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Dexuan Cui <decui@microsoft.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Farman <farman@linux.ibm.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Li <lznuaa@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geoff Levand <geoff@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>, Ira Weiny <ira.weiny@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Wang <jasowang@redhat.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Jon Mason <jdmason@kudzu.us>, Juergen Gross <jgross@suse.com>,
        Julien Grall <jgrall@amazon.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Michael Buesch <m@bues.ch>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Jamet <michael.jamet@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Christie <michael.christie@oracle.com>,
        Moritz Fischer <mdf@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Samuel Holland <samuel@sholland.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        SeongJae Park <sjpark@amazon.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Tom Rix <trix@redhat.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Wei Liu <wei.liu@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Wu Hao <hao.wu@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        YueHaibing <yuehaibing@huawei.com>,
        Yufen Yu <yuyufen@huawei.com>, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org, greybus-dev@lists.linaro.org,
        industrypack-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-parisc@vger.kernel.org,
        linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-sunxi@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nvdimm@lists.linux.dev,
        platform-driver-x86@vger.kernel.org, sparclinux@vger.kernel.org,
        target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 0/5] bus: Make remove callback return void
Message-ID: <YPkwQwf0dUKnGA7L@kroah.com>
References: <20210713193522.1770306-1-u.kleine-koenig@pengutronix.de>
 <YPfyZen4Y0uDKqDT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YPfyZen4Y0uDKqDT@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 12:09:41PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 13, 2021 at 09:35:17PM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > this is v4 of the final patch set for my effort to make struct
> > bus_type::remove return void.
> > 
> > The first four patches contain cleanups that make some of these
> > callbacks (more obviously) always return 0. They are acked by the
> > respective maintainers. Bjorn Helgaas explicitly asked to include the
> > pci patch (#1) into this series, so Greg taking this is fine. I assume
> > the s390 people are fine with Greg taking patches #2 to #4, too, they
> > didn't explicitly said so though.
> > 
> > The last patch actually changes the prototype and so touches quite some
> > drivers and has the potential to conflict with future developments, so I
> > consider it beneficial to put these patches into next soon. I expect
> > that it will be Greg who takes the complete series, he already confirmed
> > via irc (for v2) to look into this series.
> > 
> > The only change compared to v3 is in the fourth patch where I modified a
> > few more drivers to fix build failures. Some of them were found by build
> > bots (thanks!), some of them I found myself using a regular expression
> > search. The newly modified files are:
> > 
> >  arch/sparc/kernel/vio.c
> >  drivers/nubus/bus.c
> >  drivers/sh/superhyway/superhyway.c
> >  drivers/vlynq/vlynq.c
> >  drivers/zorro/zorro-driver.c
> >  sound/ac97/bus.c
> > 
> > Best regards
> > Uwe
> 
> Now queued up.  I can go make a git tag that people can pull from after
> 0-day is finished testing this to verify all is good, if others need it.

Ok, here's a tag that any other subsystem can pull from if they want
these changes in their tree before 5.15-rc1 is out.  I might pull it
into my char-misc-next tree as well just to keep that tree sane as it
seems to pick up new busses on a regular basis...

thanks,

greg k-h

-----------------------------------


The following changes since commit 2734d6c1b1a089fb593ef6a23d4b70903526fe0c:

  Linux 5.14-rc2 (2021-07-18 14:13:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git tags/bus_remove_return_void-5.15

for you to fetch changes up to fc7a6209d5710618eb4f72a77cd81b8d694ecf89:

  bus: Make remove callback return void (2021-07-21 11:53:42 +0200)

----------------------------------------------------------------
Bus: Make remove callback return void tag

Tag for other trees/branches to pull from in order to have a stable
place to build off of if they want to add new busses for 5.15.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Uwe Kleine-König (5):
      PCI: endpoint: Make struct pci_epf_driver::remove return void
      s390/cio: Make struct css_driver::remove return void
      s390/ccwgroup: Drop if with an always false condition
      s390/scm: Make struct scm_driver::remove return void
      bus: Make remove callback return void

 arch/arm/common/locomo.c                  | 3 +--
 arch/arm/common/sa1111.c                  | 4 +---
 arch/arm/mach-rpc/ecard.c                 | 4 +---
 arch/mips/sgi-ip22/ip22-gio.c             | 3 +--
 arch/parisc/kernel/drivers.c              | 5 ++---
 arch/powerpc/platforms/ps3/system-bus.c   | 3 +--
 arch/powerpc/platforms/pseries/ibmebus.c  | 3 +--
 arch/powerpc/platforms/pseries/vio.c      | 3 +--
 arch/s390/include/asm/eadm.h              | 2 +-
 arch/sparc/kernel/vio.c                   | 4 +---
 drivers/acpi/bus.c                        | 3 +--
 drivers/amba/bus.c                        | 4 +---
 drivers/base/auxiliary.c                  | 4 +---
 drivers/base/isa.c                        | 4 +---
 drivers/base/platform.c                   | 4 +---
 drivers/bcma/main.c                       | 6 ++----
 drivers/bus/sunxi-rsb.c                   | 4 +---
 drivers/cxl/core.c                        | 3 +--
 drivers/dax/bus.c                         | 4 +---
 drivers/dma/idxd/sysfs.c                  | 4 +---
 drivers/firewire/core-device.c            | 4 +---
 drivers/firmware/arm_scmi/bus.c           | 4 +---
 drivers/firmware/google/coreboot_table.c  | 4 +---
 drivers/fpga/dfl.c                        | 4 +---
 drivers/hid/hid-core.c                    | 4 +---
 drivers/hid/intel-ish-hid/ishtp/bus.c     | 4 +---
 drivers/hv/vmbus_drv.c                    | 5 +----
 drivers/hwtracing/intel_th/core.c         | 4 +---
 drivers/i2c/i2c-core-base.c               | 5 +----
 drivers/i3c/master.c                      | 4 +---
 drivers/input/gameport/gameport.c         | 3 +--
 drivers/input/serio/serio.c               | 3 +--
 drivers/ipack/ipack.c                     | 4 +---
 drivers/macintosh/macio_asic.c            | 4 +---
 drivers/mcb/mcb-core.c                    | 4 +---
 drivers/media/pci/bt8xx/bttv-gpio.c       | 3 +--
 drivers/memstick/core/memstick.c          | 3 +--
 drivers/mfd/mcp-core.c                    | 3 +--
 drivers/misc/mei/bus.c                    | 4 +---
 drivers/misc/tifm_core.c                  | 3 +--
 drivers/mmc/core/bus.c                    | 4 +---
 drivers/mmc/core/sdio_bus.c               | 4 +---
 drivers/net/netdevsim/bus.c               | 3 +--
 drivers/ntb/core.c                        | 4 +---
 drivers/ntb/ntb_transport.c               | 4 +---
 drivers/nubus/bus.c                       | 6 ++----
 drivers/nvdimm/bus.c                      | 3 +--
 drivers/pci/endpoint/pci-epf-core.c       | 7 ++-----
 drivers/pci/pci-driver.c                  | 3 +--
 drivers/pcmcia/ds.c                       | 4 +---
 drivers/platform/surface/aggregator/bus.c | 4 +---
 drivers/platform/x86/wmi.c                | 4 +---
 drivers/pnp/driver.c                      | 3 +--
 drivers/rapidio/rio-driver.c              | 4 +---
 drivers/rpmsg/rpmsg_core.c                | 7 ++-----
 drivers/s390/block/scm_drv.c              | 4 +---
 drivers/s390/cio/ccwgroup.c               | 6 +-----
 drivers/s390/cio/chsc_sch.c               | 3 +--
 drivers/s390/cio/css.c                    | 7 +++----
 drivers/s390/cio/css.h                    | 2 +-
 drivers/s390/cio/device.c                 | 9 +++------
 drivers/s390/cio/eadm_sch.c               | 4 +---
 drivers/s390/cio/scm.c                    | 5 +++--
 drivers/s390/cio/vfio_ccw_drv.c           | 3 +--
 drivers/s390/crypto/ap_bus.c              | 4 +---
 drivers/scsi/scsi_debug.c                 | 3 +--
 drivers/sh/superhyway/superhyway.c        | 8 ++------
 drivers/siox/siox-core.c                  | 4 +---
 drivers/slimbus/core.c                    | 4 +---
 drivers/soc/qcom/apr.c                    | 4 +---
 drivers/spi/spi.c                         | 4 +---
 drivers/spmi/spmi.c                       | 3 +--
 drivers/ssb/main.c                        | 4 +---
 drivers/staging/fieldbus/anybuss/host.c   | 4 +---
 drivers/staging/greybus/gbphy.c           | 4 +---
 drivers/target/loopback/tcm_loop.c        | 5 ++---
 drivers/thunderbolt/domain.c              | 4 +---
 drivers/tty/serdev/core.c                 | 4 +---
 drivers/usb/common/ulpi.c                 | 4 +---
 drivers/usb/serial/bus.c                  | 4 +---
 drivers/usb/typec/bus.c                   | 4 +---
 drivers/vdpa/vdpa.c                       | 4 +---
 drivers/vfio/mdev/mdev_driver.c           | 4 +---
 drivers/virtio/virtio.c                   | 3 +--
 drivers/vlynq/vlynq.c                     | 4 +---
 drivers/vme/vme.c                         | 4 +---
 drivers/xen/xenbus/xenbus.h               | 2 +-
 drivers/xen/xenbus/xenbus_probe.c         | 4 +---
 drivers/zorro/zorro-driver.c              | 3 +--
 include/linux/device/bus.h                | 2 +-
 include/linux/pci-epf.h                   | 2 +-
 sound/ac97/bus.c                          | 6 ++----
 sound/aoa/soundbus/core.c                 | 4 +---
 93 files changed, 107 insertions(+), 263 deletions(-)
