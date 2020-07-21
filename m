Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142AA2275AE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgGUChw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:37:52 -0400
Received: from mail-eopbgr1310127.outbound.protection.outlook.com ([40.107.131.127]:16000
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726264AbgGUChw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 22:37:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hv3FyxlSf7lX6C/6YswFIq4tfvm1WpzurJ1iVwtwI7gDDPMAeMbFH/MASnAsH6ofPmNtGXLcEDtDdI2VKI4BHL91/3aba4zDqHe653RG0V2Hiwua2KKDoenFSkgKtIvNihocXoksqWBqqWj217quAMNW78DwdGl+t3DPEDPy1EfOCz6wc805GOBT11cDuDQJAGN5gnH7l185328nXzuOLpgd2ekG6t2uoCRCcLym4lhSYSDuR3Nz1U2/UAkpMgiGv8Y5GrYR4xYmbgedhnTkqJSFJA0xbvtcWiWKwgQ440PT+1/Vylwk0oWGLkg1K7i1q+ej4Bt+Uqs095vMrVJ9fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ur0MloEGZv72ysbErDVQp8qYR76mK7vZWGqskGft2g=;
 b=G0n0QTProQxgF7KdNS97ZXr6MNxhdDX+m3c1mz9FgSxFWFLkzoVCq5DK6JFJIXfdd2SDCrTNpowqY/1OCVuLeiSqk2mrxKfbPQa5Tbqx28nD8XNp7gxhceOETfFdjycUutB8Cidkz/pTB0IcEkLSbcij84f/BWQXSreQYDwiGsYcMjQndudaTl0MSiuiQAPDUumgQyHgxQ4luaUcJ7EIp2dD5LtMfVTgFM0WjhnUfoE4ehNAPPJR7hb7RE4KcVwt7p3z/IyOvS1aWU15sz0V9CU2oHGRK7AFii36k1HySzdFlKA5lazeybEkx169wTuYVDQB+5iX5pQFWyumuvSswA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ur0MloEGZv72ysbErDVQp8qYR76mK7vZWGqskGft2g=;
 b=UafoDTLGm852ugwElHCPyCiFvwWsiB0ukEmn//YyIjkRTphpon8HtVz4L0Po/Cip802w3dCuNR9Nn2JYPMq4ClHK7H1ZoXcB5VI9Zfn2O8TF/bMe0mR3HIRYd4y4M/8Zl2Rp5nSzasokx4pKHCPPbxVco3vOEv0M35gH0xX9l+U=
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::14)
 by HK0P153MB0323.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7; Tue, 21 Jul
 2020 02:37:43 +0000
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e]) by HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e%6]) with mapi id 15.20.3216.020; Tue, 21 Jul 2020
 02:37:43 +0000
From:   Chi Song <Song.Chi@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Topic: [PATCH v4 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Index: AdZe+8HxuV5eYFd1QcWUIR0SG3uRnQ==
Date:   Tue, 21 Jul 2020 02:37:42 +0000
Message-ID: <HK0P153MB02751820DD4F8892DEFA13D098780@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-20T07:16:58Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=04b9772d-b507-4872-a4fc-786c63f4656c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2404:f801:8050:1:b1ce:4ac6:46d:28d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0affd6b-c34d-4bba-9d61-08d82d1f0b65
x-ms-traffictypediagnostic: HK0P153MB0323:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB0323159A1E6C444B1D73AE7B98780@HK0P153MB0323.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CF9BqsHOUfQvAjNDjLiZSqHHYBb0rwvL2t4K+yF4+FaRMzQIOghbrHil+FET6E3580TRqK6bCbajhpsjnogCOSJsD8IDzjb256xSH4DkuHvE17s8opKooxuabAnCnoGcp9Q21O3ClIU8aX/ifGgYyAZKlW+wQKxBCVGWUHHAEoM9Q0+6t3WsxOOy4BrZcfPti2Tgg1D6oTMNHODmyboXVLrQm9QWgCF7zhTnF9g0UFUKEHy1Sr4O6g8n6BImSzez+UkGKdYOFIbd5apwSKMQ7aN1VzYOsk9zSZLKbtW3NEuL4OyTSCWQfah0YubD0/K/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0275.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(2906002)(66446008)(82960400001)(82950400001)(8676002)(110136005)(64756008)(66556008)(76116006)(86362001)(66946007)(66476007)(5660300002)(52536014)(10290500003)(54906003)(478600001)(33656002)(316002)(8990500004)(4326008)(8936002)(9686003)(55016002)(6506007)(7696005)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HDu+s0xGjEz/3Uvc5oNQBAaS6BGFXL49TO9vfSN9Nwlxq9umbDDf/lpyysEcHy7oY9cuEppQUsw/DuP3+stJq5OtrNeLCPw6JSDewaI9CDRombWbOdxvLXmSJyAgfN5bWKRN7MKW+hI+vTuClVEmNQdGmZydXYv7SwolUVVyTOCA69T9BlrWw5VDNbwA9BcQD0MGNQKDYZGqmp2pVLfh+rbQ0wIVBn/Gnk6yeuxOharUgfoH4dBJmaPXwLuZyuCL1aT7ftXDTwfAqUF78U0Ez6PR2IdCZ22iMiVeKR/TGt7Jt1CuChVhKhVnm86nrqUqUtzZZtZ8FC29FfP8oOA3LHrybMBLN8nsFJJMPth2PghEMRy3S2Kr7PanrqHqaggVTOH/clvMv38b6MxkSubJOhOEG45o+ZVa6gPPpE/fmwfKGiWSRGx2n6+0ZDVoUFbpTlfs1yNjK+tjMl8mVadJuSncsCukbtTVSHxy0bSNXPZ8vunDUwNyZJ8ywJamr6gUpeECo6xOV/LWvcj5iGVc9r09naUWxzp0tq2il2RTcic=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e0affd6b-c34d-4bba-9d61-08d82d1f0b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 02:37:42.7172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jrdnt7pZCCasfCHZoqQX8GCWq5IyMcCTmSGO+OwrRcN1/Dc050JkNECc4EjUjy6853dLMUnkxwq5yqOMnVlKQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0323
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
 location of init, exit to drve

---
 drivers/net/hyperv/netvsc_drv.c | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 6267f706e8ee..280de1067f40 100644
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
+	struct net_device *ndev =3D to_net_dev(dev);
+	struct net_device_context *ndc =3D netdev_priv(ndev);
+	int index =3D dev_attr - dev_attr_netvsc_dev_attrs;
+
+	return sprintf(buf, "%u\n", ndc->tx_table[index]);
+}
+
+static void netvsc_attrs_init(void)
+{
+	int i;
+	char buffer[4];
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
