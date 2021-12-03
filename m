Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B281D467F29
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 22:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383223AbhLCVTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 16:19:52 -0500
Received: from mail-bn7nam10on2100.outbound.protection.outlook.com ([40.107.92.100]:20512
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1383198AbhLCVTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 16:19:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwkVflpex5VISdAj4ZwWEurFsB4vBzKneKtJ4NUtmeoY2g+YjmGXhZ5DiPqi/h7pJNYoC8DJXxqv5OdeWGTv5f3UOm2kRF+UODsImqzRQyaFi5E8jf30W3/ix9o0jzR5OU7mPxjFO98CLgau74vEemV0wLIq+f4IXADSb0Tuv/XAoUD8qUX+eWoqD234NJedj+UwFcWtQlckTMwc2olObwJfLukWZY67quUTfzfbkDeVWi4H3IOMohCr5yPfCAIscocTG3ZTbkbwb4QXRP+SriK6GoTfgDzGaqqXOrPHlQZ9924x6KLvw3LPMsCfsimcRLaG1Vo0EDGJseN7LRCx7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBynjm8i+RuSTE/ot98jPxUSiazCEDkavxFeUOZat4g=;
 b=hGP4hz+jHIUq+kMLpzEiujOagS8arfFdLY0KE0gXotRgsSuJZjVmLVuutig0JyRLLfPB+TigR2wEhLGa+7WpLYsnbB+Hke+ReHdVe+eMWR0LNGzqGooFw6/1+ixwgNS9RppIl+bpCd1LOFQUc1d4k2POXbBzJ5aY+cy3KMM2pElJsLR2AOUtb28PTmXWQTUuagzUaVadGJrAMXaXUlprzLaZmIZcV0JrriK5E8rVi9HE1NEd0JMzSJRbvV9hB6I9aiLiKoIPUFrVv0hcuZJtviZu8eGLQB+f2fEpqVjDxFMrlMmC4E46592jWkSDITYpiYMDG24cv5QWehmkh9UsHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBynjm8i+RuSTE/ot98jPxUSiazCEDkavxFeUOZat4g=;
 b=u8aaTxqhdpMAo6vRmQ78+b6GNF+hQaySIB0VyfIlJLvdYqzu+3fT+4PCzIecgSF39iMgp424MlhR65kM14ylMDuGxMLROm+azZrNMmb9gugm2KFHknXyA2tOgoNW9icLUV9Hr+Xqhwm+zJ5TwE0T8s7u4G3spVrSCAaP5tioQ6Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5881.namprd10.prod.outlook.com
 (2603:10b6:303:18e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 3 Dec
 2021 21:16:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 21:16:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        katie.morris@in-advantage.com
Subject: [RFC v1] mfd: pinctrl: RFC only: add and utilze mfd option in pinctrl-ocelot
Date:   Fri,  3 Dec 2021 13:16:11 -0800
Message-Id: <20211203211611.946658-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:300:6c::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR04CA0071.namprd04.prod.outlook.com (2603:10b6:300:6c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 3 Dec 2021 21:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4efe2577-0098-4f25-dd05-08d9b6a227e4
X-MS-TrafficTypeDiagnostic: MW4PR10MB5881:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5881414FC61C474CDE5DA537A46A9@MW4PR10MB5881.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8+SMHpkLbOc6CcFyUAFfYHwG2U0y5lHr5f6i4cgEw7T5D/1Yow1qkkLK5jvDU+ypehgR1CFcQ0VtTtPUIDiAR1nVJVo3TRE3JyGITToVdLWhrSvaElG03eQSuGqbZuZsOJCsc/3RG/D8NNqqIksqZL089P2duL6z/KUWJfjus7yqSbZiD37/iLQMGASx7xUwi3ZCzj/Hm3WmKJ1JRGTIx8Ki7yv6rvFXavQv8XhEo/fOngcFEA6/lJW6d+Mk9h6x+LEKThTvwxxi1Hi7brQvrij7teoJv3HocItmagJ6FC653JFNNZCYwixFo64WDgz+GJBJSeUX3tNBWwFnyigq9R5qUrOHpNk/mB1OrQ5xcGPhixAqgrndQRP2isoxpz4qoLEF8jbiT3OXkmCfyoyOWk78DTDFYA+aZf3ut/16lE6PMSL1kFtnXAE4W+JwkfFYipZioW72PsanQU0EkwK9b+8DOEXFLb1oxpZf3/xD5XI2T9x+MS5BjLY4Gj16AoRE228gJN1RzcJKvVi23mKgr0p5rddcNMTsDPjFxQgSgVZhE0DGjZr/FgtKYKx6QwhkwXNcJJuBvL0SLgpVOSWg1fhVTgroZuu19YSEmaJG/ljMGjGNqRgHcWpttSGAwFuZUaN8x5Tew61Gb79hurJ2BIb1uOYZBnLcwFMHxhH6V8Rp/RlzPOlgttdXBDLcC2tIZMOsG1y1y0q4q6T43HrPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(136003)(346002)(366004)(376002)(396003)(107886003)(38350700002)(6512007)(956004)(8936002)(66946007)(6486002)(6506007)(66476007)(1076003)(38100700002)(508600001)(86362001)(8676002)(2616005)(44832011)(66556008)(36756003)(2906002)(26005)(186003)(316002)(6666004)(52116002)(5660300002)(83380400001)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F3hssjVPZr70bkfBZrPfVtKXYAzMsgr9m0zG1bHWgmZZjiq83Z9aCGkJudDZ?=
 =?us-ascii?Q?j4sWN3jYpL5dJ5Za3TX26TuY/3FSFoZvwVDtSsRE+2MntHj8DBzwj15PnFkH?=
 =?us-ascii?Q?svmmGefPv7qFc+cALLHB5BCWzunmiFRVEWb5T5mSk8hDPW21ly/BtSKBh4hL?=
 =?us-ascii?Q?uKjTEGDZtNfqel35SnT9J8lMyRMNmfB3OmJAW+boCL1gKHaJUe3Nw28m/iyR?=
 =?us-ascii?Q?QzbaKdSz1nyBm9aQn2iFEeJD98GI1ZkgaTDhh9eY2Buws+4TUXooo9KNaDBH?=
 =?us-ascii?Q?B+KW6/oWure61sDc8eKAbre8dULUeqrHkmDgFEr25z8HFqN09K4jx3TQGmzL?=
 =?us-ascii?Q?Ky/D2xGXXKSA149hrpIWxKydXOcBxOz+QO1U8YX8Or5qxxa6E6LKBWsGA27h?=
 =?us-ascii?Q?mvpr22MmRJao2RTqsKH4nIjbre7rzdsJ1OpRE0a22qrWyNp0FLILxfXkVVMq?=
 =?us-ascii?Q?heyIRspOmgVSw7/KOmmXVWxXGxrphPZdgKOHXaDaGbgoovYHqVww2UzngPtz?=
 =?us-ascii?Q?QbfqKOHgVI4gWcWEv0n4zKwyjr5WCPMXMv9zBM9589avUUuAkn3e8BlUPLW6?=
 =?us-ascii?Q?A2rSk+2E+rFwaGnQetER5Pntsq67UbVifBxdC6bFZjYaHp6GCqs3zVeyk88V?=
 =?us-ascii?Q?92KPk/Dc/s0PgsiJbCPKFL3DkkGHwm8HcQLcOXaQUxUOLH58ns0Mk+rJs1Ul?=
 =?us-ascii?Q?xnn6V1Z5hYIOrkCShrrWgQWnQBsywxTQFc4fyaGf4mUyrGCIndZE4YI/SDF0?=
 =?us-ascii?Q?H7fSJmevh1B9bdyjTsg6opNn+IzSNh6mNxIcqj1HjtD7/mpTb9buYS+j/yxx?=
 =?us-ascii?Q?pFM+UPaGRFIdU8/0kArqx58MssHRrddyY12oL1PBA5kuZo+rBwjjqe/jPTvz?=
 =?us-ascii?Q?fFGJPOYFuI43/H/3DhCanQin1liEwV0bxi91Mj52i7bum25UIozLkomy33v7?=
 =?us-ascii?Q?sTS+g3MmbHaYJOHldW9LCjE/1uQ8IUDYRGWWrnCmlzbXPuYheZSq+tWaG9pR?=
 =?us-ascii?Q?Mzuyrg5zoacCg0dVcQcduxGt6go6vnC1C1eHr9rWE+nH3sGuo4QwKUDJnkJQ?=
 =?us-ascii?Q?V1XX2WzTfC1VDDcHNYVpae3J6eNLB2BQU2NAk68etVL8oKurA0rblpGNQCSN?=
 =?us-ascii?Q?ACenR9GlQcBjq4L5uK/wJMsG6vLd9TJMlz2VshVipcjD9lYJrOTzSaZdJ62X?=
 =?us-ascii?Q?vz5ul4JgIatkVOmDPPPHEMS0oxD8xlmZ6smEDgBjpftrCOcLO+7vBkYqUZTJ?=
 =?us-ascii?Q?OABI1JBWf5lrtRLfsmFobKv/vjDcFKD0IcKKaSIHHZz4AKLuCKdC11m8yK7p?=
 =?us-ascii?Q?7+2e1tzQcue3jz1faQtmK7TIeHNv0kZG7ZW9eSq2ATM2O8UKAhyNTuIhQu9Z?=
 =?us-ascii?Q?vE3MhbWGN1wasz/6/vqcH05lj1HkU/Gqtex1dawPEXFr3ztXrdtpDK4O0PIV?=
 =?us-ascii?Q?3HGOu8ofbZX4qhhK2fMEyJbjTmHjoc28szt+jc6Tn2P9A3q0TqCZjtNmKm8f?=
 =?us-ascii?Q?YlrRa6L5I95VU6KjxCPfMW1wlAWAFm/1B3x1Tc6RqQNM0u/ZDlZRkADQQRqn?=
 =?us-ascii?Q?ULVWGNFS1SDtatPm35iLcUtDgRbSaO1FJ5STCFmcpaHN1/YVnOyMQV8zu5A3?=
 =?us-ascii?Q?7dUFeIZ9okM0ds/mOgl+72840kfNTe9a2BWNUL0+98mXbVtt0Iccw2ZIZlqi?=
 =?us-ascii?Q?e6PAxg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efe2577-0098-4f25-dd05-08d9b6a227e4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 21:16:22.3411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ke8X1aYuV02Ed/3+INQMXzndnfJneDTWUcR/WmxbSy6AEkIfZwi4btNMwl5iO3QuysbTTDrcdaFfbWpLRLqAUO1T0f1awv4H3xv8I1TGFfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5881
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a psuedo-commit, but one that tells the complete story of what I'm
looking at. During an actual submission this'll be broken up into two
commits, but I'd like to get some feedback on whether this is the correct
path for me to be going down.

Background:

Microchip has a family of chips - the VSC7511, 7512, 7513, and 7514. The
last two have an internal MIPS processor, which are supported by
drivers/net/ethernet/mscc/ocelot_*. The former two lack this processor.

All four chips can be configured externally via a number of interfaces:
SPI, I2C, PCIe... This is currently not supported and is my end goal.

The networking portion of these chips have been reused in other products as
well. These utilize the common code by way of mscc_ocelot_switch_lib and
net/dsa/ocelot/*. Specifically the "Felix" driver.

Current status:

I've put out a few RFCs on the "ocelot_spi" driver. It utilizes Felix and
invokes much of the network portion of the hardware (VSC7512). It works
great! Thanks community :)

There's more hardware that needs to get configured, however. Currently that
includes general pin configuration, and an optional serial GPIO expander.
The former is supported by drivers/pinctrl/pinctrl-ocelot.c and the latter
by drivers/pinctrl/pinctrl-microchip-sgpio.c.

These drivers have been updated to use regmap instead of iomem, but that
isn't the complete story. There are two options I know about, and maybe
others I don't.

Option 1 - directly hook into the driver:

This was the path that was done in
commit b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim
driver for indirect MDIO access").
This is in the net-next tree. In this case the Seville driver passes in its
regmap to the mscc_miim_setup function, which bypasses mscc_miim_probe but
allows the same driver to be used.

This was my initial implementation to hook into pinctrl-ocelot and
pinctrl-microchip-sgpio. The good thing about this implementation is I have
direct control over the order of things happening. For instance, pinctrl
might need to be configured before the MDIO bus gets probed.

The bad thing about this implementation is... it doesn't work yet. My
memory is fuzzy on this, but I recall noticing that the application of a
devicetree pinctrl function happens in the driver probe. I ventured down
this path of walking the devicetree, applying pincfg, etc. That was a path
to darkness that I have abandoned.

What is functioning is I have debugfs / sysfs control, so I do have the
ability to do some runtime testing and verification.

Option 2 - MFD (this "patch")

It really seems like anything in drivers/net/dsa/ should avoid
drivers/pinctl, and that MFD is the answer. This adds some complexity to
pinctrl-ocelot, and I'm not sure whether that breaks the concept of MFD. So
it seems like I'm either doing something unique, or I'm doing something
wrong.

I err on the assumption that I'm doing something wrong.

pinctrl-ocelot gets its resources the device tree by way of
platform_get_and_ioremap_resource. This driver has been updated to support
regmap in the pinctrl tree:
commit 076d9e71bcf8 ("pinctrl: ocelot: convert pinctrl to regmap")

The problem comes about when this driver is probed by way of
"mfd_add_devices". In an ideal world it seems like this would be handled by
resources. MFD adds resources to the device before it gets probed. The
probe happens and the driver is happy because platform_get_resource
succeeds.

In this scenario the device gets probed, but needs to know how to get its
regmap... not its resource. In the "I'm running from an internal chip"
scenario, the existing process of "devm_regmap_init_mmio" will suffice. But
in the "I'm running from an externally controlled setup via {SPI,I2C,PCIe}"
the process needs to be "get me this regmap from my parent". It seems like
dev_get_regmap is a perfect candidate for this.

Perhaps there is something I'm missing in the concept of resources /
regmaps. But it seems like pinctrl-ocelot needs to know whether it is in an
MFD scenario, and that concept didn't exist. Hence the addition of
device_is_mfd as part of this patch. Since "device_is_mfd" didn't exist, it
feels like I might be breaking the concept of MFD.

I think this would lend itself to a pretty elegant architecture for the
VSC751X externally controlled chips. In a manner similar to
drivers/mfd/madera* there would be small drivers handling the prococol
layers for SPI, I2C... A core driver would handle the register mappings,
and could be gotten by dev_get_regmap. Every sub-device (DSA, pinctrl,
other pinctrl, other things I haven't considered yet) could either rely on
dev->parent directly, or in this case adjust. I can't imagine a scenario
where someone would want pinctrl for the VSC7512 without the DSA side of
things... but that would be possible in this architecture that would
otherwise not.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/mfd-core.c           | 6 ++++++
 drivers/pinctrl/pinctrl-ocelot.c | 7 ++++++-
 include/linux/mfd/core.h         | 2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 684a011a6396..2ba6a692499b 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -33,6 +33,12 @@ static struct device_type mfd_dev_type = {
 	.name	= "mfd_device",
 };
 
+int device_is_mfd(struct platform_device *pdev)
+{
+	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
+}
+EXPORT_SYMBOL(device_is_mfd);
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 0a36ec8775a3..758fbc225244 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/core.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -1368,7 +1369,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	if (device_is_mfd(pdev))
+		info->map = dev_get_regmap(dev->parent, "GCB");
+	else
+		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 0bc7cba798a3..9980bcc8456d 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -123,6 +123,8 @@ struct mfd_cell {
 	int			num_parent_supplies;
 };
 
+int device_is_mfd(struct platform_device *pdev);
+
 /*
  * Convenience functions for clients using shared cells.  Refcounting
  * happens automatically, with the cell's enable/disable callbacks
-- 
2.25.1

