Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36442277D1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 06:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgGUE7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 00:59:08 -0400
Received: from mail-eopbgr1320095.outbound.protection.outlook.com ([40.107.132.95]:25216
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGUE7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 00:59:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SO17GC/kCnhiMkAYNlptLykW9sAfPNU2khiv2UlwHqkJxNP+xLCSMdKHj+2kDJPgV4Gix50qi8Jo0V++m3J2+1tU01p9b3Is9sCHk4XzilSnkxyqjkJ6qt0IDUM8G54VQd7iGvaz6mAm47aBABGr8uAVcyHScL+tFIrJf+Tur+xhyjP7aW/1g4A2o0BsID9Loer8UQ1SHUiaGOTWM4iDnj/e/t6R6DtlETH8csdZRdqV6vZinKPsL6/AnBtV7asSxw1bonIFelgy7PZc7TxzbzC1NRQ7tWLqurzsc6jiQyPgItn83c/VAyxqh9MTVwVdP0q9CcOj33jAi7s2qTWMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e805MkGPiwoAj6Bwo7NTbUn0uzIPgySTmE6N3nUmDM4=;
 b=bTZ8O4dTF2gFAEh1qqvPGQ+DSr0KJuk2VJNVC8xLSjOEQO9kKCWhmBcam8PR2lPBMI0dk2Y0HZLF4BtNLFKke4v80kjx5wnT8xpp+0e1gWwdFd/AtT7NJWdJnRo9Dr/GqmJchTfxfWyRNkpVijbV11frI3oaufkyN8sru5xrk3dmaaLOusmeDaLFXS/NO72sQeznQCG1iCm0gkedlUu6eaTWGq1Ee0nWnP05VvlM8JYKKjsNmlEKuuxm3MMiMQIBOCeUlBpurHGkeRzNIGpyQzm7ntIRC4K6RkejGwJLqWtVO52qrbm+z1oEdf6+5s0HHIflNC2XLHOXKqIZ3kFn8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e805MkGPiwoAj6Bwo7NTbUn0uzIPgySTmE6N3nUmDM4=;
 b=EhdaRibEXRxnyM/2V+9SmxxHM7mf8CxVLwJM3qbyPEhfWEVviOumzR9KU6MKaEWNpcvdSkO2gnTKm8I9JByt8cugFI+1eD0hZ+awDxtDKORIpkchIdoxvaqHbBH9EOtFdUFGPoBeVFHA3Jm5LiQg9OcBpqy77E39Np/8XC9R0m0=
Received: from PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM (2603:1096:300:7f::17)
 by PU1P153MB0139.APCP153.PROD.OUTLOOK.COM (2603:1096:803:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.14; Tue, 21 Jul
 2020 04:59:00 +0000
Received: from PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM
 ([fe80::84ff:3f88:836e:39b8]) by PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM
 ([fe80::84ff:3f88:836e:39b8%7]) with mapi id 15.20.3216.021; Tue, 21 Jul 2020
 04:59:00 +0000
From:   Chi Song <Song.Chi@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Topic: [PATCH v6 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Index: AdZfG0GKTJv85JzZS3GaPc7Fu5spkQ==
Date:   Tue, 21 Jul 2020 04:58:59 +0000
Message-ID: <PS1P15301MB028211A9D09DA5601EBEBEA298780@PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-21T04:58:58Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d3b0d683-b31a-4af6-8e2f-f4e0d3c15ea6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2404:f801:8050:3:b1cc:4ac6:46d:28d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40a6cd3a-b2bd-42f2-9bda-08d82d32c807
x-ms-traffictypediagnostic: PU1P153MB0139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0139A6A3744C599A7D4F584698780@PU1P153MB0139.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:628;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7qIiElqs2bD6xG0C8v7D8K0EDABZqnm43nCTV3gzcFqgkeedWQ0YdjOYx+UKHDIDsaV3daXapm0hxE8MdnDimNjD8L82j0QC59kP9zwJ2C48KSWnTNH7bIqyexSaLr+5P++iEi8+5MmKsPtlMAcV7K0FMjMbT7s3BpI9VVpQAAgVGMZR4aI1EcdQJe15T93iFoRhdyt+pUC7El2LRlEMVySiqSMUM9ZjDEI2r8LrE8AvWyQ7jxHmj8hjTbqBAkwPfHxRqA1846lfU1SXju9CpmldvnY1nfwk0r96RGDa5yqzgwyob1zuTI3U5PgvGDqB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(478600001)(76116006)(66946007)(4326008)(64756008)(66476007)(186003)(8676002)(8990500004)(33656002)(55016002)(71200400001)(66446008)(9686003)(7696005)(5660300002)(86362001)(10290500003)(316002)(66556008)(6506007)(54906003)(8936002)(2906002)(110136005)(52536014)(82950400001)(83380400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EiGPOhD8X/zoaDFJQq0vs4ovkqIEo22buCoAw3nV17/dse12pep2gdNVDnc+uDY8u8GOZoEnr51xSKUbr+GrfJl41k/Ant3XrtF5BhZCx0hvs93gKhCmsq4sRgujelCYrIEZ1BVSRk6X8086lWaZOTorLTYMO7tfoxG7dtjrSR0e7tqxgbygFH9UJwtTNspZzMKdxvy+o6OwGx1YwoVoErZP1EpvWI1mHRIX9x1MBSqgNVq18sVdwhZagzqUKrobqz3nL9FlQvA45MFGLWjJGW1hV9NweESf/pQoihOTwpo2L5z7Gu5aIWV3HdrqHV+G9h707B9lQXiztbbyf9/qABj+qk/xE/sOxRpCrIQCnAqGHC1FP7DjJe/B9nkmnKP1t/jnYWY+5HB1ZEmVrRCInDuRRb7YlGlPjLSvFEP1d+6LC/vZS0AAkHIerkw+dl0kbGB45Pgs0/mmRS3LsChi2Wg82oEjUuCugZP+4wWZVk9q5YLvkexdRzsVeMbLUjcueC0DzEl/rLDnwndgprRf/Al1J/2tm6s/Qax3HjBTfJo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a6cd3a-b2bd-42f2-9bda-08d82d32c807
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 04:58:59.6793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V/SwrOsH4j5kHzDW9YKXCC/dL7LQrHVki/OVYBx3DG9AqNBVrTuZjm1cmFh4xbhhwDbsA7xPrTXuEjy/DZ78Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An imbalanced TX indirection table causes netvsc to have low
performance. This table is created and managed during runtime. To help
better diagnose performance issues caused by imbalanced tables, add
device attributes to show the content of TX indirection tables.

Signed-off-by: Chi Song <chisong@microsoft.com>
---
v4: use a separated group to organize tx_indirection better, change=20
 location of attributes init/exit to netvsc_drv_init/exit
v5: update variable orders
v6: update names to be more precise, remove useless assignment

Thank you all for comments, learned a lot.

 drivers/net/hyperv/netvsc_drv.c | 48 +++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 6267f706e8ee..f6ad13ed320f 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2370,6 +2370,50 @@ static int netvsc_unregister_vf(struct net_device *v=
f_netdev)
 	return NOTIFY_OK;
 }
=20
+static struct device_attribute dev_attr_tx_indirection_attrs[VRSS_SEND_TAB=
_SIZE];
+static struct attribute *tx_indirection_attrs[VRSS_SEND_TAB_SIZE + 1];
+
+const struct attribute_group tx_indirection_group =3D {
+	.name =3D "tx_indirection",
+	.attrs =3D tx_indirection_attrs,
+};
+
+static ssize_t tx_indirection_show(struct device *dev,
+				   struct device_attribute *dev_attr, char *buf)
+{
+	int index =3D dev_attr - dev_attr_tx_indirection_attrs;
+	struct net_device *ndev =3D to_net_dev(dev);
+	struct net_device_context *ndc =3D netdev_priv(ndev);
+
+	return sprintf(buf, "%u\n", ndc->tx_table[index]);
+}
+
+static void netvsc_attrs_init(void)
+{
+	char buffer[4];
+	int i;
+
+	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++) {
+		sprintf(buffer, "%02u", i);
+		dev_attr_tx_indirection_attrs[i].attr.name =3D
+			kstrdup(buffer, GFP_KERNEL);
+		dev_attr_tx_indirection_attrs[i].attr.mode =3D 0444;
+		sysfs_attr_init(&dev_attr_tx_indirection_attrs[i].attr);
+
+		dev_attr_tx_indirection_attrs[i].show =3D tx_indirection_show;
+		tx_indirection_attrs[i] =3D
+			&dev_attr_tx_indirection_attrs[i].attr;
+	}
+}
+
+static void netvsc_attrs_exit(void)
+{
+	int i;
+
+	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++)
+		kfree(dev_attr_tx_indirection_attrs[i].attr.name);
+}
+
 static int netvsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -2410,6 +2454,7 @@ static int netvsc_probe(struct hv_device *dev,
=20
 	net->netdev_ops =3D &device_ops;
 	net->ethtool_ops =3D &ethtool_ops;
+	net->sysfs_groups[0] =3D &tx_indirection_group;
 	SET_NETDEV_DEV(net, &dev->device);
=20
 	/* We always need headroom for rndis header */
@@ -2665,6 +2710,7 @@ static void __exit netvsc_drv_exit(void)
 {
 	unregister_netdevice_notifier(&netvsc_netdev_notifier);
 	vmbus_driver_unregister(&netvsc_drv);
+	netvsc_attrs_exit();
 }
=20
 static int __init netvsc_drv_init(void)
@@ -2678,6 +2724,8 @@ static int __init netvsc_drv_init(void)
 	}
 	netvsc_ring_bytes =3D ring_size * PAGE_SIZE;
=20
+	netvsc_attrs_init();
+
 	ret =3D vmbus_driver_register(&netvsc_drv);
 	if (ret)
 		return ret;
--=20
2.25.1
