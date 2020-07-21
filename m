Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48E122773C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGUDuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:50:08 -0400
Received: from mail-eopbgr1320137.outbound.protection.outlook.com ([40.107.132.137]:33056
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbgGUDuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 23:50:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFKhC8cKJgW4SZ40F7jsNj/QprOk3Ffp3csGQk4Pom7t83asqjaxUFPQeHwXrm6olTmcDeC5tVb9sFMFbyiRpzFh+HNNtKWKjbCHv9d4d+tzBU8nDxx4LEgSi/Ry9+85gKRKiS0ngkQnwusgGAbEpEqVCKQYVYLyGZ7LExXR9DlLCva/9YRYCFhiskoV7HAQRrxlXIpmm7qhtPhdV9khiqtj57By6n3Ay5b7bCasa7qZHKQ0iGf3OIPsoud/ZY/JGgICPCI4UfNum+7tX/Ug8tPufijOYThLiZBzP6yoJh4OksTXHhERcIyvYDPec58WcufQkLSGf4dNRmyvGIiEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jukI3T1SdY7BD63o/7jL2tkXfaWvYnjmuXJh8IayEhk=;
 b=Ft+X9ipzlRTzlwsGXSu87RRpD9fwlN2kNRGopzMXIz5NEdA9eW5CXT2VVgMFeRgZ8bhqdKWNhNZaGuI1ogMsfbt7pRjOJBxqDfW60Cmut0HEamGyVM2Ikp8TAewtFBbxqD0Q6hBvxnn54KT5/xvj53AHgKnIDCdYwtWR6cQytWXxJtr6YKsaeeGNkyvekJh9cB+8ns+bx6mUwHRK2i0yfoNBKDAfkfQFh65Lq+zHcVPB7M91TZ0uIQw+Ntd/a9tbkqggQi3dGhzMIA58+Yd8qUpRntqnihFho9VgOvuO/vIKPnH7jqtk5loy1ENQHKj14ClrgPWj9RQdCBi600CyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jukI3T1SdY7BD63o/7jL2tkXfaWvYnjmuXJh8IayEhk=;
 b=Zs/uCH9IBy9l1fvqM36yooySs2gpODrjAkii8Fs4K9z6zQXgQuUlUBl4L5uK55nV0mlf8ul9B5QpABLX9ahLJ+xdhbRRkzGHdWx8WGFdf63QJBgaIoXAuk1wFKT+CpMeVbJRpV/1SPtXgk0qBCLilJ0Oy3yHQpf6U3EXcAF/+sc=
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::14)
 by HK0P153MB0148.APCP153.PROD.OUTLOOK.COM (2603:1096:203:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7; Tue, 21 Jul
 2020 03:50:01 +0000
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e]) by HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e%6]) with mapi id 15.20.3216.020; Tue, 21 Jul 2020
 03:50:01 +0000
From:   Chi Song <Song.Chi@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Topic: [PATCH v5 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Index: AdZfEcPKGd7xulNnRpunpA+7DCPz/w==
Date:   Tue, 21 Jul 2020 03:50:00 +0000
Message-ID: <HK0P153MB0275B7FFBA43843CC7B1EABB98780@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-21T03:49:59Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=22e5ad65-f8db-4b06-8dee-ceac40c0f86e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2404:f801:8050:1:b1ce:4ac6:46d:28d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 633fa444-b542-4431-c02a-08d82d29250e
x-ms-traffictypediagnostic: HK0P153MB0148:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB0148A4FBA108CF04213DF7C398780@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9DTL0mUykFlI/Vj/kzavtYpIQlRWlqr4Lu+oAR3FYC1TG13vhu+2f2dD7zABoeSi874y25GbPOMEDZtNINUG20PW80Bq5PVV/70h2Rgc2Yo78z5nis2oOZFuVOTbHVSMtQOy4u2S6GHpphf+B8cKUiBRcq/PuYMWoXKD76VIKNdDrV0a8x5vCA+32nooy8DEzSzfIqSm6B4R2UTzWiPyn/4BxO9VZQa7Cb4XTb27Z5buW0HP+JiFklUfIGXFP0GXrw/SlDjSCgul8mZJr8t29veOX4nZIMnpFsQ7nmq/WPSSe/waL8dhDI2boFzjdm2iTvRoTu9iXjieiO8wh86SUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0275.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(86362001)(33656002)(76116006)(82960400001)(83380400001)(52536014)(82950400001)(5660300002)(66946007)(66476007)(66556008)(64756008)(66446008)(9686003)(55016002)(10290500003)(7696005)(316002)(4326008)(8676002)(2906002)(186003)(54906003)(8990500004)(110136005)(6506007)(71200400001)(478600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xmzDA8bWly9Z9V+6mkMh1oOj0FE4BKlJtbUy84UtfN+Emu1l2sX18mjXbEUx696NTwTjhw+t34I0QW8fZmk360xMletuHbbW6kyKyHQHINxL/M18ceg4sK56MO69LQHgwWzt2VpDyomw5APaVVBmKBwZuxAuTzLzmQTwkI7kxDrUy57HCNkGe/sZ9SdF/ZKNELyKNz9q7kjvusLhm/mdIakqQCGxC2hjgCvQ5zvR8Z8Li8NGLSO3Kzpu07pUOZYLPfZpFLScGMAUKXSAq+hrGJfaZDE+Y52KZDyVSHcIPPrR21PXHHqZprWxWEQ29A2xwro3tjh+i+3et8PUfJgjvSVv4JSlya7gWu007TdTgVGwlnn7X87+IBujOfJELaEmohp85GXsopYixoKavS9bn03TAYQ6jVwL4RuLvYJ0cqa7rnKo2FggdPEvwNYRUlouSHQOWRsg4P36H9ZQoV/YRv9jt802GcN6/HjgKuv2yYy9V2fjp1KzWOHfn2XKIsPNONuR18CpV0lpdWnqSNNNXgDrE6nb5Y+Ns1PNHE7NS1M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 633fa444-b542-4431-c02a-08d82d29250e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 03:50:00.7160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GIR9a5lUtX6/jy+hz5/zkDQdjLgjUIJz5WqJmtNgwObOQhWNp8g5nhTKNkSLqaSfv06mhL1MhyuTXI4F35BXXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0148
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
v5: update variable orders.

 drivers/net/hyperv/netvsc_drv.c | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 6267f706e8ee..a1e009edd37e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2370,6 +2370,51 @@ static int netvsc_unregister_vf(struct net_device *v=
f_netdev)
 	return NOTIFY_OK;
 }
=20
+static struct device_attribute dev_attr_netvsc_dev_attrs[VRSS_SEND_TAB_SIZ=
E];
+static struct attribute *netvsc_dev_attrs[VRSS_SEND_TAB_SIZE + 1];
+
+const struct attribute_group netvsc_dev_group =3D {
+	.name =3D "tx_indirection",
+	.attrs =3D netvsc_dev_attrs,
+};
+
+static ssize_t tx_indirection_show(struct device *dev,
+				   struct device_attribute *dev_attr, char *buf)
+{
+	int index =3D dev_attr - dev_attr_netvsc_dev_attrs;
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
+		dev_attr_netvsc_dev_attrs[i].attr.name =3D
+			kstrdup(buffer, GFP_KERNEL);
+		dev_attr_netvsc_dev_attrs[i].attr.mode =3D 0444;
+		sysfs_attr_init(&dev_attr_netvsc_dev_attrs[i].attr);
+
+		dev_attr_netvsc_dev_attrs[i].show =3D tx_indirection_show;
+		dev_attr_netvsc_dev_attrs[i].store =3D NULL;
+		netvsc_dev_attrs[i] =3D &dev_attr_netvsc_dev_attrs[i].attr;
+	}
+	netvsc_dev_attrs[VRSS_SEND_TAB_SIZE] =3D NULL;
+}
+
+static void netvsc_attrs_exit(void)
+{
+	int i;
+
+	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++)
+		kfree(dev_attr_netvsc_dev_attrs[i].attr.name);
+}
+
 static int netvsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -2410,6 +2455,7 @@ static int netvsc_probe(struct hv_device *dev,
=20
 	net->netdev_ops =3D &device_ops;
 	net->ethtool_ops =3D &ethtool_ops;
+	net->sysfs_groups[0] =3D &netvsc_dev_group;
 	SET_NETDEV_DEV(net, &dev->device);
=20
 	/* We always need headroom for rndis header */
@@ -2665,6 +2711,7 @@ static void __exit netvsc_drv_exit(void)
 {
 	unregister_netdevice_notifier(&netvsc_netdev_notifier);
 	vmbus_driver_unregister(&netvsc_drv);
+	netvsc_attrs_exit();
 }
=20
 static int __init netvsc_drv_init(void)
@@ -2678,6 +2725,8 @@ static int __init netvsc_drv_init(void)
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
