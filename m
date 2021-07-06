Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9C13BCD88
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhGFLWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:22:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233278AbhGFLUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 07:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625570276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjbCzRDVGxTPwLr0ZAizMTX8crBOOlyEFb2n3sNXFts=;
        b=Mg8Za+5cuo7gsg5xUintaXZdpb7JPWlWjhMbKDaaHFvrPHG9u162FVMM44sUxPDjAvo+CV
        pehcatdBLRDxpOtKwAlUwSeT/UdfkEq7ov4HyGbqnWJ39ysdx3Q570HQ3uaTdAONxNF4RD
        v9/Jy/0cEAYWX/g3ITkFEiDgBiJQeqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-0awj3QsmOBmPU2KgCkEgvQ-1; Tue, 06 Jul 2021 07:17:54 -0400
X-MC-Unique: 0awj3QsmOBmPU2KgCkEgvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95A44800D62;
        Tue,  6 Jul 2021 11:17:49 +0000 (UTC)
Received: from localhost (ovpn-113-13.ams2.redhat.com [10.36.113.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FC1919C79;
        Tue,  6 Jul 2021 11:17:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82eck?= =?utf-8?Q?i?= 
        <zajec5@gmail.com>, Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84sk?= =?utf-8?Q?i?= 
        <kw@linux.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thorsten Scherer <t.scherer@eckelmann.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, Michael Buesch <m@bues.ch>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Martyn Welch <martyn@welchs.me.uk>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Marc Zyngier <maz@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Samuel Holland <samuel@sholland.org>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joey Pabalan <jpabalanb@gmail.com>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frank Li <lznuaa@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        SeongJae Park <sjpark@amazon.de>,
        Julien Grall <jgrall@amazon.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-cxl@vger.kernel.org,
        nvdimm@lists.linux.dev, dmaengine@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-input@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-i3c@lists.infradead.org,
        industrypack-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, target-devel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH] bus: Make remove callback return void
In-Reply-To: <87pmvvhfqq.fsf@redhat.com>
Organization: Red Hat GmbH
References: <20210706095037.1425211-1-u.kleine-koenig@pengutronix.de>
 <87pmvvhfqq.fsf@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 06 Jul 2021 13:17:37 +0200
Message-ID: <87mtqzhesu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06 2021, Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, Jul 06 2021, Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.d=
e> wrote:
>
>> The driver core ignores the return value of this callback because there
>> is only little it can do when a device disappears.
>>
>> This is the final bit of a long lasting cleanup quest where several
>> buses were converted to also return void from their remove callback.
>> Additionally some resource leaks were fixed that were caused by drivers
>> returning an error code in the expectation that the driver won't go
>> away.
>>
>> With struct bus_type::remove returning void it's prevented that newly
>> implemented buses return an ignored error code and so don't anticipate
>> wrong expectations for driver authors.
>
> Yay!
>
>>
>> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>> ---
>> Hello,
>>
>> this patch depends on "PCI: endpoint: Make struct pci_epf_driver::remove
>> return void" that is not yet applied, see
>> https://lore.kernel.org/r/20210223090757.57604-1-u.kleine-koenig@pengutr=
onix.de.
>>
>> I tested it using allmodconfig on amd64 and arm, but I wouldn't be
>> surprised if I still missed to convert a driver. So it would be great to
>> get this into next early after the merge window closes.
>
> I'm afraid you missed the s390-specific busses in drivers/s390/cio/
> (css/ccw/ccwgroup).

The change for vfio/mdev looks good.

The following should do the trick for s390; not sure if other
architectures have easy-to-miss busses as well.

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 9748165e08e9..a66f416138ab 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -439,17 +439,15 @@ module_exit(cleanup_ccwgroup);
=20
 /************************** driver stuff ******************************/
=20
-static int ccwgroup_remove(struct device *dev)
+static void ccwgroup_remove(struct device *dev)
 {
 	struct ccwgroup_device *gdev =3D to_ccwgroupdev(dev);
 	struct ccwgroup_driver *gdrv =3D to_ccwgroupdrv(dev->driver);
=20
 	if (!dev->driver)
-		return 0;
+		return;
 	if (gdrv->remove)
 		gdrv->remove(gdev);
-
-	return 0;
 }
=20
 static void ccwgroup_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index a974943c27da..ebc321edba51 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1371,15 +1371,14 @@ static int css_probe(struct device *dev)
 	return ret;
 }
=20
-static int css_remove(struct device *dev)
+static void css_remove(struct device *dev)
 {
 	struct subchannel *sch;
-	int ret;
=20
 	sch =3D to_subchannel(dev);
-	ret =3D sch->driver->remove ? sch->driver->remove(sch) : 0;
+	if (sch->driver->remove)
+		sch->driver->remove(sch);
 	sch->driver =3D NULL;
-	return ret;
 }
=20
 static void css_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 84f659cafe76..61d5d55bd9c8 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1742,7 +1742,7 @@ ccw_device_probe (struct device *dev)
 	return 0;
 }
=20
-static int ccw_device_remove(struct device *dev)
+static void ccw_device_remove(struct device *dev)
 {
 	struct ccw_device *cdev =3D to_ccwdev(dev);
 	struct ccw_driver *cdrv =3D cdev->drv;
@@ -1776,8 +1776,6 @@ static int ccw_device_remove(struct device *dev)
 	spin_unlock_irq(cdev->ccwlock);
 	io_subchannel_quiesce(sch);
 	__disable_cmf(cdev);
-
-	return 0;
 }
=20
 static void ccw_device_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index 9f26d4310bb3..b6b4589c70bd 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -28,12 +28,13 @@ static int scmdev_probe(struct device *dev)
 	return scmdrv->probe ? scmdrv->probe(scmdev) : -ENODEV;
 }
=20
-static int scmdev_remove(struct device *dev)
+static void scmdev_remove(struct device *dev)
 {
 	struct scm_device *scmdev =3D to_scm_dev(dev);
 	struct scm_driver *scmdrv =3D to_scm_drv(dev->driver);
=20
-	return scmdrv->remove ? scmdrv->remove(scmdev) : -ENODEV;
+	if (scmdrv->remove)
+		scmdrv->remove(scmdev);
 }
=20
 static int scmdev_uevent(struct device *dev, struct kobj_uevent_env *env)
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index d2560186d771..8a0d37c0e2a5 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -884,7 +884,7 @@ static int ap_device_probe(struct device *dev)
 	return rc;
 }
=20
-static int ap_device_remove(struct device *dev)
+static void ap_device_remove(struct device *dev)
 {
 	struct ap_device *ap_dev =3D to_ap_dev(dev);
 	struct ap_driver *ap_drv =3D ap_dev->drv;
@@ -909,8 +909,6 @@ static int ap_device_remove(struct device *dev)
 	ap_dev->drv =3D NULL;
=20
 	put_device(dev);
-
-	return 0;
 }
=20
 struct ap_queue *ap_get_qdev(ap_qid_t qid)

