Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B13EECA9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhHQMnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:43:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:2376 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhHQMnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 08:43:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="195654147"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208,223";a="195654147"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 05:43:12 -0700
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208,223";a="680334682"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 05:43:10 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1mFyQq-00Ak4X-Fe; Tue, 17 Aug 2021 15:43:04 +0300
Date:   Tue, 17 Aug 2021 15:43:04 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 1/3] ptp_ocp: Switch to use
 module_pci_driver() macro
Message-ID: <YRuu2G4esO76dZOC@smile.fi.intel.com>
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
 <20210813111407.0c2288f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHp75VeEO+givZ_SvUc2Wu7=iKvoqJEWYnMD=RHZCxKhqsV-9Q@mail.gmail.com>
 <20210816210101.cnhb4xfifzctr4kj@bsd-mbp.dhcp.thefacebook.com>
 <YRuF5hd0BL/RAEZw@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qyz0v6NZnXXnrAAo"
Content-Disposition: inline
In-Reply-To: <YRuF5hd0BL/RAEZw@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qyz0v6NZnXXnrAAo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 17, 2021 at 12:48:22PM +0300, Andy Shevchenko wrote:
> On Mon, Aug 16, 2021 at 02:01:01PM -0700, Jonathan Lemon wrote:
> > On Fri, Aug 13, 2021 at 10:30:51PM +0300, Andy Shevchenko wrote:
> > > On Fri, Aug 13, 2021 at 9:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > On Fri, 13 Aug 2021 15:27:35 +0300 Andy Shevchenko wrote:
> > > > > Eliminate some boilerplate code by using module_pci_driver() instead of
> > > > > init/exit, and, if needed, moving the salient bits from init into probe.
> > > > >
> > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > >
> > > > Jonathan has a series in flight which is fixing some of the same issues:
> > > > https://patchwork.kernel.org/project/netdevbpf/list/?series=530079&state=*
> > > >
> > > > Please hold off for a day or two so it can get merged, and if you don't
> > > > mind double check at that point which of your patches are still needed.
> > > 
> > > Actually it may be the other way around. Since patch 2 in his series
> > > is definitely an unneeded churn here, because my devm conversion will
> > > have to effectively revert it.
> > > 
> > > 
> > > > According to patchwork your series does not apply to net-next as of
> > > > last night so it'll need a respin anyway.
> > > 
> > > I hope he will chime in and see what we can do the best.
> > 
> > I'm going to submit a respin of the last patch, I screwed something
> > up from all the various trees I'm using.
> > 
> > Please update to net-next first - the firat patch in your series
> > doesn't make any longer, given the current status.
> 
> I'll rebase my stuff on top of net-next and resubmit.
> 
> Thanks!

It seems the driver disrupted so much that it requires much more work
to make it neat. New code looks like a custom MFD approach (WRT resource
management).

I have sent only patch 3 out of this series and have attached here the
problematic places in my opinion. Feel free to convert them to patches
with Suggested-by tag. But converting to MFD will make this driver much
much better to read, understand and maintain.


-- 
With Best Regards,
Andy Shevchenko



--qyz0v6NZnXXnrAAo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-TODO-ptp_ocp-Convert-to-use-managed-functions-pcim_-.patch"

From b8b54ce18d724fd2c730b553a67c77f2c4a0fcf2 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 17 Aug 2021 15:25:38 +0300
Subject: [PATCH 1/1] TODO: ptp_ocp: Convert to use managed functions pcim_*
 and devm_*

This makes the error handling much more simpler than open-coding everything
and in addition makes the probe function smaller an tidier.

TODO: split out unrelated changes to their own patches.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 56 ++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 922f92637db8..d118da95a46c 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2020 Facebook */
 
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+
 #include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -303,7 +305,7 @@ static struct ocp_resource ocp_fb_resource[] = {
 
 static const struct pci_device_id ptp_ocp_pcidev_id[] = {
 	{ PCI_DEVICE_DATA(FACEBOOK, TIMECARD, &ocp_fb_resource) },
-	{ 0 }
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
 
@@ -344,6 +346,7 @@ ptp_ocp_clock_val_from_name(const char *name)
 
 	for (i = 0; i < ARRAY_SIZE(ptp_ocp_clock); i++) {
 		clk = ptp_ocp_clock[i].name;
+		/* FIXME: What's the point of 'n' + strlen()? */
 		if (!strncasecmp(name, clk, strlen(clk)))
 			return ptp_ocp_clock[i].value;
 	}
@@ -363,6 +366,7 @@ __ptp_ocp_gettime_locked(struct ptp_ocp *bp, struct timespec64 *ts,
 	ptp_read_system_prets(sts);
 	iowrite32(ctrl, &bp->reg->ctrl);
 
+	/* FIXME: iopoll.h + respective macro */
 	for (i = 0; i < 100; i++) {
 		ctrl = ioread32(&bp->reg->ctrl);
 		if (ctrl & OCP_CTRL_READ_TIME_DONE)
@@ -686,6 +690,9 @@ ptp_ocp_read_i2c(struct i2c_adapter *adap, u8 addr, u8 reg, u8 sz, u8 *data)
 		reg += len;
 		sz -= len;
 	}
+
+	/* FIXME: shouldn't be using word transfers then? */
+
 	return 0;
 }
 
@@ -870,21 +877,13 @@ static const struct devlink_ops ptp_ocp_devlink_ops = {
 	.info_get = ptp_ocp_devlink_info_get,
 };
 
-static void __iomem *
-__ptp_ocp_get_mem(struct ptp_ocp *bp, unsigned long start, int size)
-{
-	struct resource res = DEFINE_RES_MEM_NAMED(start, size, "ptp_ocp");
-
-	return devm_ioremap_resource(&bp->pdev->dev, &res);
-}
-
 static void __iomem *
 ptp_ocp_get_mem(struct ptp_ocp *bp, struct ocp_resource *r)
 {
-	unsigned long start;
+	resource_size_t start = pci_resource_start(bp->pdev, 0) + r->offset;
+	struct resource res = DEFINE_RES_MEM_NAMED(start, r->size, "ptp_ocp");
 
-	start = pci_resource_start(bp->pdev, 0) + r->offset;
-	return __ptp_ocp_get_mem(bp, start, r->size);
+	return devm_ioremap_resource(&bp->pdev->dev, &res);
 }
 
 static void
@@ -908,7 +907,7 @@ ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r)
 	struct pci_dev *pdev = bp->pdev;
 	struct platform_device *p;
 	struct resource res[2];
-	unsigned long start;
+	resource_size_t start;
 	int id;
 
 	/* XXX hack to work around old FPGA */
@@ -932,7 +931,7 @@ ptp_ocp_register_spi(struct ptp_ocp *bp, struct ocp_resource *r)
 	id += info->pci_offset;
 
 	p = platform_device_register_resndata(&pdev->dev, info->name, id,
-					      res, 2, info->data,
+					      res, ARRAY_SIZE(res), info->data,
 					      info->data_size);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
@@ -1036,7 +1035,6 @@ ptp_ocp_unregister_ext(struct ptp_ocp_ext_src *ext)
 {
 	ext->info->enable(ext, false);
 	pci_free_irq(ext->bp->pdev, ext->irq_vec, ext);
-	kfree(ext);
 }
 
 static int
@@ -1046,14 +1044,13 @@ ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r)
 	struct ptp_ocp_ext_src *ext;
 	int err;
 
-	ext = kzalloc(sizeof(*ext), GFP_KERNEL);
+	ext = devm_kzalloc(&pdev->dev, sizeof(*ext), GFP_KERNEL);
 	if (!ext)
 		return -ENOMEM;
 
-	err = -EINVAL;
 	ext->mem = ptp_ocp_get_mem(bp, r);
 	if (!ext->mem)
-		goto out;
+		return -EINVAL;
 
 	ext->bp = bp;
 	ext->info = r->extra;
@@ -1063,16 +1060,12 @@ ptp_ocp_register_ext(struct ptp_ocp *bp, struct ocp_resource *r)
 			      ext, "ocp%d.%s", bp->id, ext->info->name);
 	if (err) {
 		dev_err(&pdev->dev, "Could not get irq %d\n", r->irq_vec);
-		goto out;
+		return err;
 	}
 
 	bp_assign_entry(bp, r, ext);
 
 	return 0;
-
-out:
-	kfree(ext);
-	return err;
 }
 
 static int
@@ -1240,7 +1233,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_gnss_sync.attr,
 	&dev_attr_clock_source.attr,
 	&dev_attr_available_clock_sources.attr,
-	NULL,
+	NULL
 };
 ATTRIBUTE_GROUPS(timecard);
 
@@ -1430,7 +1423,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto out_free;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
 		goto out_unregister;
@@ -1439,7 +1432,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bp = devlink_priv(devlink);
 	err = ptp_ocp_device_init(bp, pdev);
 	if (err)
-		goto out_disable;
+		goto out_unregister;
 
 	/* compat mode.
 	 * Older FPGA firmware only returns 2 irq's.
@@ -1456,7 +1449,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = ptp_ocp_register_resources(bp, id->driver_data);
 	if (err)
-		goto out;
+		goto out_free_irq;
 
 	bp->ptp = ptp_clock_register(&bp->ptp_info, &pdev->dev);
 	if (IS_ERR(bp->ptp)) {
@@ -1477,9 +1470,8 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out:
 	ptp_ocp_detach(bp);
-	pci_set_drvdata(pdev, NULL);
-out_disable:
-	pci_disable_device(pdev);
+out_free_irq:
+	pci_free_irq_vectors(pdev);
 out_unregister:
 	devlink_unregister(devlink);
 out_free:
@@ -1495,8 +1487,6 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(bp);
 
 	ptp_ocp_detach(bp);
-	pci_set_drvdata(pdev, NULL);
-	pci_disable_device(pdev);
 
 	devlink_unregister(devlink);
 	devlink_free(devlink);
@@ -1577,7 +1567,7 @@ ptp_ocp_init(void)
 out_notifier:
 	class_unregister(&timecard_class);
 out:
-	pr_err(KBUILD_MODNAME ": failed to register %s: %d\n", what, err);
+	pr_err("failed to register %s: %d\n", what, err);
 	return err;
 }
 
-- 
2.32.0


--qyz0v6NZnXXnrAAo--
