Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945B941868F
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 06:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhIZEzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 00:55:53 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:20656 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhIZEzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 00:55:52 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18Q4rlKB004686;
        Sun, 26 Sep 2021 04:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=FF+i3VEEAzA1GlcYCIQdd2qepjLlYyi1xVEOQt1HZRI=;
 b=JrZLpRJcznU5Dy2W99K1OvN5XYAe4IKkd/LAHlxk988J2o4oOlRxre5n5mdyDGTRF8uR
 kWkiiLPsJSFOhlCr0n9oHe/vD2rx9ZlFKu3WzLezsAit38C2sCSAtKjrUtu/f6Gp8SDt
 Z2IWux0ijanf8XfHa/Kxx3m/o3EbVcBpdoimcIO3x2kzDvPNmtI9bmhrk8yziDwHWxda
 Fush5lOb6Fw1MuQPkVolYJXs8NKFwkHETbTcBxY4+dJzqSer1VgPp8J+EhlcKPHJWqnu
 AbOdplSYeDGfDyDxjdDeJ+DMqb29Bes1RO7IWFi1/QZIe6FYMTLCzLcZydqdR9p3Ocia xg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bacqmr41q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 26 Sep 2021 04:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GepLB46b6edLLpZe3Act59rzsHpKmQN1C/7VBFKNn2RluVikDdF+MQfP5e7XXD8ErOPeai0S78i/BpNt0cun8XCpks1nIJqPHd/NFgR+Eey8u4pbE6EHztopY275LmVsksQ63dnuYUz676lJ5l6wRB6+BT2TWwmACdmbD0iLvEgaghsl22U5eXgNDbZiAwFkTscLiAODYFIIRAhxuEglTyLZoy2nXOZtYqu5FSfuF34a5BMuimmTIn3qWGotowCj072DnIiehW/CQKy0dZf4DbKb2gtTk21lkncnSzUzqIaDBVCfpYbM4X1IHE8YI9suSHc+4KkBNXl2+HGiDk1ioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FF+i3VEEAzA1GlcYCIQdd2qepjLlYyi1xVEOQt1HZRI=;
 b=Zjn2rqJ9TD82XWTVSDHJDsfApk+vRJ0qS0IZgLv8C7k15HdVfcCgVUQ2az3tH87scsUp20ZKk7llgN7xbpqtoIfWgr0xK1bgGTpOVJpotIjA5K+jlCiYYCnqUKz5svYaVjnelbrr7pT1mwhMBXj6GIWnZgXQHX7WwSMXO4NpK30YLP4Om79TTThVX+r5JYgxGC0MOWGnMUIPDGQdixEbUqwKK/seghomKbuPYP2mTfiC5K0eZvE8oNOYUBpHMiJypKrY+cy1J/tRmSqtE2qntOhu6ZHJM2NRkrUfGv+GhQJczVB/zCiLmwKxI77S4GH43oMvRfdW2aBs4ZbdYKjmlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=windriver.com;
Received: from DM8PR11MB5734.namprd11.prod.outlook.com (2603:10b6:8:31::22) by
 DM5PR1101MB2188.namprd11.prod.outlook.com (2603:10b6:4:53::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.18; Sun, 26 Sep 2021 04:53:39 +0000
Received: from DM8PR11MB5734.namprd11.prod.outlook.com
 ([fe80::51b7:91e3:7c34:57a5]) by DM8PR11MB5734.namprd11.prod.outlook.com
 ([fe80::51b7:91e3:7c34:57a5%3]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 04:53:39 +0000
From:   Yanfei Xu <yanfei.xu@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Date:   Sun, 26 Sep 2021 12:53:13 +0800
Message-Id: <20210926045313.2267655-1-yanfei.xu@windriver.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0144.apcprd02.prod.outlook.com
 (2603:1096:202:16::28) To DM8PR11MB5734.namprd11.prod.outlook.com
 (2603:10b6:8:31::22)
MIME-Version: 1.0
Received: from pek-lpggp1.wrs.com (60.247.85.82) by HK2PR02CA0144.apcprd02.prod.outlook.com (2603:1096:202:16::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Sun, 26 Sep 2021 04:53:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dd73702-2c39-4fa7-7a96-08d980a99b29
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2188:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2188286B2229A8559C2119DDE4A69@DM5PR1101MB2188.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fGbQ/4aGUkVMmfN+CBLwN35MUBgSOLNwfuf8CCrXCxUGyrMf58A8M/j/j9ilj4n4SDp30k78Yaa1H6tvTdBBpDUoVRzd/Y4v3FNJ6vNvpmm4MF9aPabOz8GNxNUMVvZ7Nes9b45Gf6a44Zx9ptsFafvoP4GC2DUV58cxSc4rn5IEf+u0kK9PKDPZxFDYn8N+0I3tONS2YO8MBLlTPxRYlU1FLkTF466omuel6gzl6sHFL2XkZTkx1HI2GsR1tx8kqqMBy/7TBd8y5ZVQw0DmdFVARk3zvDZmGb1Eqo/22Q8Vfzvw7zVjBpXnhz69lujjntMm5NcNlrvQwfsANmOakWuDZPR4RJOPIEIaH3zziaKxOwPZ4BKKV2eRFyexzic3Ur97xCUqfxJEFRDJjuKQ6i9Odnupu4KmyLhGLj/b35eiwD2Rk9Ve5EAVgTYDhXDaFNcgmdeyuatXzgxbcY88IqkObNLyBiD5k13B08aIdxI5c6QDXhe9AqHFW6rOLh99xkJzZ/Lr+L+VCc4Tc9LzCskaZnnVmVu8PiY93YUY700BXF21BKQO3HJYEFP3iE16E9VcIO92+en0uB11HkUzoJpDJQSElvWdNGUh+AxkRzKcy9aIXvizj+urN9yjvCISUoR1Tix20zB1i56GLzFXD9jDSRVW8grPdA5+7WaFiCDp2fM9L0O1yQosHiIk9AnJFFQAyV1p0NfV0dux5jPiDCjq1vyJstfhw0j2yMu9vg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(2906002)(8676002)(5660300002)(44832011)(36756003)(52116002)(38100700002)(38350700002)(4326008)(6486002)(83380400001)(86362001)(6666004)(26005)(66556008)(316002)(66476007)(66946007)(6512007)(6506007)(956004)(2616005)(186003)(508600001)(1076003)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rdH2+1eks4AjCGDL/QmM75jftFFB/LAToCH9qyjJ62geV3vua6xolDGLj8AQ?=
 =?us-ascii?Q?P/93udpqI0jgrQPlRWq6fAqnVoWbe4OQalH2ony13MMJ+jz3A1wWS4SGh9Ms?=
 =?us-ascii?Q?U6UC26K8cLKBIB3KSSauOxl1Q2ZMM3atkH2oYqyQPRaXAtTn+owUS9WsLjI1?=
 =?us-ascii?Q?H3n4KeqIbN3mj6yre+RecvhcymH6c0+57Qe/k7y7LXqSpnxRU5HzlxRkGSHA?=
 =?us-ascii?Q?hXHuCT+QlUECVhZDpGYnBLQfAuU4JDDxpwoQrYrCXY0GobTd9aZ4Wwz6W+mK?=
 =?us-ascii?Q?AzIpMD7qoeV8XlJgxbRaghU+RYrNc3NYEYNZ66kmetvUQ6DPDjKIB1mlF5Ps?=
 =?us-ascii?Q?iHWepoZoqx0qKjeGCZRV34l9TXkmeGgXHr3n9KNPyCe7DMfdZLWk+Zkr/ICS?=
 =?us-ascii?Q?Ix1iBOnBc9fW2n/pc3dNnYBUY2EpJj0vZ0K1b47sUcbOIZGBkl3qA+nyTDx4?=
 =?us-ascii?Q?iiRKJVUmt5sqy5w4VZMddR+Siir6zhzWH/lg+hzBbQTXJ5AAp530Aw6VJlxv?=
 =?us-ascii?Q?EpiQLueB/mNenSwHRQpASCkaSBJxFh4aIWZBP6tHkW44npUrW1tnaECqySIY?=
 =?us-ascii?Q?FJ3kjNsLqJztXCDHfaIyhBjmyc0rqyI1ITYGUNYW+zjzV/0dOFAkKZtcjU0d?=
 =?us-ascii?Q?BYAL2xLCPdRHvJUowP4Hq6gNvj5Ait35aW6NivsAVlF3uR8hXkPZodcMSexK?=
 =?us-ascii?Q?QzaKoVh+/8va9S3kRqYXhEExullpDGun/ng+GFRHQ++Zc2WQ/xk+eErEHeJI?=
 =?us-ascii?Q?sJBxnhXHx57wOZw6ZS8MSR/ikwh9OffVbYOnoNhuSckX9jwmoRUU3tRECP94?=
 =?us-ascii?Q?VQSpMhsQHUHrK/86xdxCYofhBsx8rC3bhQQY7vvfstj3m6vIHf0YnGowdAJt?=
 =?us-ascii?Q?Waj2Muavl3WDnpIWX5kJqkmzcgI9MSq63SbJnRtGRXRTlsjwellvCZXjNScx?=
 =?us-ascii?Q?xrENQqMhC05hNjpSve5UyteJgpeCpK44s4eRJR/ejjjOHJXM8Vvs8Sang5RY?=
 =?us-ascii?Q?ib+wuVVWcSg0Hot0VSKPf9FggzGykO0IOPqJCW3n7jZ89tEaLBn+vYrPzwYL?=
 =?us-ascii?Q?TkX4Y/+ONdcmGyOnOqF+x24XguRV6ztOQUzM/kfxM8WQWSexRVc6R2lQk0KM?=
 =?us-ascii?Q?JqCg5PS8aGXSrT8O4Aj9jk23qKoOg+SpVQ4iYm55l2X5Yqn0gw+RINOQmarj?=
 =?us-ascii?Q?LQpyBbV1x4genEtBCn4myQvVPGI0z5A9rr87qjDDALu6drV/wuc6eWPDWDAL?=
 =?us-ascii?Q?0oik4Q5QwRUEg9MRMgoFN4IhwlxyWPA4sDff4Jrd67Vo+E8HmK+SCq0YHU5D?=
 =?us-ascii?Q?aZfDIYdVi9x0QNmMXT3nKmFX?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd73702-2c39-4fa7-7a96-08d980a99b29
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2021 04:53:39.3349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvbw7KOJ/0tr7Xw2M0msKKMzeHZOiI26BPqoVkTZJlmy6/XeEbVr2K2hSoPIiibw71/n4EcJjrrHjvpai/WHYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2188
X-Proofpoint-GUID: dMZP4dVgUyp1bkn3Bo1NCUGuWP25jLmZ
X-Proofpoint-ORIG-GUID: dMZP4dVgUyp1bkn3Bo1NCUGuWP25jLmZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-25_07,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=671 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109260036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once device_register() failed, we should call put_device() to
decrement reference count for cleanup. Or it will cause memory
leak.

BUG: memory leak
unreferenced object 0xffff888114032e00 (size 256):
  comm "kworker/1:3", pid 2960, jiffies 4294943572 (age 15.920s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 2e 03 14 81 88 ff ff  ................
    08 2e 03 14 81 88 ff ff 90 76 65 82 ff ff ff ff  .........ve.....
  backtrace:
    [<ffffffff8265cfab>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff8265cfab>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff8265cfab>] device_private_init drivers/base/core.c:3203 [inline]
    [<ffffffff8265cfab>] device_add+0x89b/0xdf0 drivers/base/core.c:3253
    [<ffffffff828dd643>] __mdiobus_register+0xc3/0x450 drivers/net/phy/mdio_bus.c:537
    [<ffffffff828cb835>] __devm_mdiobus_register+0x75/0xf0 drivers/net/phy/mdio_devres.c:87
    [<ffffffff82b92a00>] ax88772_init_mdio drivers/net/usb/asix_devices.c:676 [inline]
    [<ffffffff82b92a00>] ax88772_bind+0x330/0x480 drivers/net/usb/asix_devices.c:786
    [<ffffffff82baa33f>] usbnet_probe+0x3ff/0xdf0 drivers/net/usb/usbnet.c:1745
    [<ffffffff82c36e17>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<ffffffff82661d17>] call_driver_probe drivers/base/dd.c:517 [inline]
    [<ffffffff82661d17>] really_probe.part.0+0xe7/0x380 drivers/base/dd.c:596
    [<ffffffff826620bc>] really_probe drivers/base/dd.c:558 [inline]
    [<ffffffff826620bc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826621ba>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff82662a26>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff8265eca7>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826625a2>] __device_attach+0x122/0x260 drivers/base/dd.c:969
    [<ffffffff82660916>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:487
    [<ffffffff8265cd0b>] device_add+0x5fb/0xdf0 drivers/base/core.c:3359
    [<ffffffff82c343b9>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2170
    [<ffffffff82c4473c>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238

BUG: memory leak
unreferenced object 0xffff888116f06900 (size 32):
  comm "kworker/0:2", pid 2670, jiffies 4294944448 (age 7.160s)
  hex dump (first 32 bytes):
    75 73 62 2d 30 30 31 3a 30 30 33 00 00 00 00 00  usb-001:003.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81484516>] kstrdup+0x36/0x70 mm/util.c:60
    [<ffffffff814845a3>] kstrdup_const+0x53/0x80 mm/util.c:83
    [<ffffffff82296ba2>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82358d4b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:289
    [<ffffffff826575f3>] dev_set_name+0x63/0x90 drivers/base/core.c:3147
    [<ffffffff828dd63b>] __mdiobus_register+0xbb/0x450 drivers/net/phy/mdio_bus.c:535
    [<ffffffff828cb835>] __devm_mdiobus_register+0x75/0xf0 drivers/net/phy/mdio_devres.c:87
    [<ffffffff82b92a00>] ax88772_init_mdio drivers/net/usb/asix_devices.c:676 [inline]
    [<ffffffff82b92a00>] ax88772_bind+0x330/0x480 drivers/net/usb/asix_devices.c:786
    [<ffffffff82baa33f>] usbnet_probe+0x3ff/0xdf0 drivers/net/usb/usbnet.c:1745
    [<ffffffff82c36e17>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<ffffffff82661d17>] call_driver_probe drivers/base/dd.c:517 [inline]
    [<ffffffff82661d17>] really_probe.part.0+0xe7/0x380 drivers/base/dd.c:596
    [<ffffffff826620bc>] really_probe drivers/base/dd.c:558 [inline]
    [<ffffffff826620bc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826621ba>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff82662a26>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff8265eca7>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826625a2>] __device_attach+0x122/0x260 drivers/base/dd.c:969

Reported-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
---
 drivers/net/phy/mdio_bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..6f4b4e5df639 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -537,6 +537,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
+		put_device(&bus->dev);
 		return -EINVAL;
 	}
 
-- 
2.27.0

