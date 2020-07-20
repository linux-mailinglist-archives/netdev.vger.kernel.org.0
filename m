Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06918225842
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgGTHRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:17:08 -0400
Received: from mail-eopbgr1300139.outbound.protection.outlook.com ([40.107.130.139]:32077
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgGTHRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 03:17:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=depLZnVxd2wzVRNjsyMUxmVMtxPeNf8CwC9FLxwUbr46C/hl5gKuSgjWtaFbe3ijZ3FWzGjYNgQftdDMmtgWv39F7CBhum6a+9zRw/654Pc9ksYqpp3z4n4gg6R/bmQ/NDocx2FedP7XzcXwdquWDPRcGkF6pS26t0LXK5UvEnkWrw2kFSewZWA4n+pfArQpz+6ypds7Vi1G2gRjBOKP7mWPXh97yiWn3UkCirXWvvwdQ8a3R1WY32oym0ZlU+v9BkI0ulSjmr0oiRBNdqwVzjohWW6WTxFiom6mhShnHWIP1ERLy5p97Exp49iN9OwC9MSzOOkRvhOr+NYyJclOEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42/GJe7gRwprNTw/l/iMz4mVALiFBPpt4BS9ssiK2ro=;
 b=llgPta/wyjljWhNSaBGsYMNY72Fmw3QxnODcOd/bnucCUVVOjOqtNGhZd6i5yMYOdIuGHtt3wuy5vive+8VeGtOS5TNByO7GhAWMtJrycPd39v9i3BNXGXbNzgcCgUOxUced7etsWt6Sr3QYO3YlsgtlawXfO1LaaemrFMjpLwTMZD+lvDOP7Kfpa+qlwglN3JQy5iCs/Q0ZfxNpN480tAX6FA664qJXWrFbX7yvmt3AFkc+XlZpe37PAmwT1cr9lCrxP61AEqcDyTWQ2kdLQ440oWzhf9Pu4YcntaBUN015Ius4v9C9woTnJW6zaWgW52dqV/gIYyd3wq9C6WEdeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42/GJe7gRwprNTw/l/iMz4mVALiFBPpt4BS9ssiK2ro=;
 b=ML5NdeUoTPpVyx7Ip4PV9R34QX4cPvPU60q6zv5SJeGdCiqLIptcb0q9KqMvW4qogmwumEkNDQFaw4K3MtVhvat+wdgfEQBTsfRZeu18prJ4j3MI47h5ccEpEaD5RbBy2SiqK4wekAI6DoE6RkXCZXZICR/OLfLQNM88BJVi1qE=
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::14)
 by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7; Mon, 20 Jul
 2020 07:17:00 +0000
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e]) by HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e%6]) with mapi id 15.20.3216.018; Mon, 20 Jul 2020
 07:17:00 +0000
From:   Chi Song <Song.Chi@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Topic: [PATCH v3 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Index: AdZeZbrV+t5rWB2ETh+y8GF8jKdgPA==
Date:   Mon, 20 Jul 2020 07:17:00 +0000
Message-ID: <HK0P153MB0275B086FDE4B26D39E41059987B0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
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
x-originating-ip: [2404:f801:8050:3:b9c1:8617:1570:6fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e98313ac-1a7e-4035-b912-08d82c7ce55b
x-ms-traffictypediagnostic: HK0P153MB0273:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB027307A7E59DB0A54E940585987B0@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l7skfKXClVyBK4e+DsUY051wDwHRlFdQz5/NRfeo5kLsK1E7OZsZfrPZl4Y3FpeIpAS+9gYXQl3jkS0v34adgiXjW8y/OX9Bb53z5YgJXG1Hn9XoSC/XHt2YBik/tVclcjzT2vju2h1rehsmSUjuH5eU0I+2sssgze5I2v/hrLxBdeClqV2M7M/+CxbR4oPSf62eaMcpYGq03kCTvRBssDcpy3z0V/MK6cjkNPOA73zOJ2RTErJgARO9+2UeVuYOjGbB5mmH7AOBr4uyFXVy1SzylPqihsFGM//dbCWmtnzJfLVxSDvriwMt88Qq0aS/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0275.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(110136005)(9686003)(54906003)(478600001)(8990500004)(4326008)(2906002)(82950400001)(66556008)(66446008)(66476007)(66946007)(64756008)(76116006)(82960400001)(186003)(316002)(10290500003)(52536014)(86362001)(33656002)(71200400001)(5660300002)(8936002)(7696005)(83380400001)(55016002)(6506007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bOxCZd+EJmKurWwDXAtXBhxMkipsonpBRjJI61duTDVf3jFz/xXYEME6aJ0Y/4CJOZK05NumUhZqtzZkBzAGKJf4kIuCXkTgaRCv/flUhhm+nhZuXZ9xfPhrf6mNUcBJ/8SHsiBCkSXriOwqu9qS1skmffResbsGpgsJb9ll0oXF3Glff/Rem9n7IhIv/Bp34h/1R9xM2F2wRtUQ7GjNlnSjcFoX9HV2sa6a5hdIV2VYo37tMvR+qoiejgRcwFPKnnAzqqXV9LDAdfLnpEX8dYdznvPkak5lEBSuDEk6Jz7bCh0N49YOjAkt+mq4qFr2clYpz80G3YZv2t1VZn0x1BcRzg3IAqvMwUxV5AwnAd3f/Ic4LBdfNoUa/+4n2Hsvp6mVYlGPAtZNXM3xaxc+k46ekg4qqJLbqzxWfJSHuSLvcb8l2FCoei/P0/ofV6TIBcgZB8TJNL1O6r7pGIbJXLGsfzZI6RuSDyAWs/D506cLvNVIRaPZkTqBcpJS70qbryIh6zhchLcLJNwcyzpcv0gqqoOUMEVljnhyQY6kST4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e98313ac-1a7e-4035-b912-08d82c7ce55b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 07:17:00.3728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aVU4PxejJgxIqQKkieH8iGTlCG0pPs+rE4e/xU7C0yDAR+6oZ/3sJs1YtiVhhFzajlO4sLVfDSmpjoRki5al0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0273
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
v2: remove RX as it's in ethtool already, show single value in each file,
 and update description.
v3: fix broken format by alpine.

Thank you for comments. Let me know, if I miss something.

---
 drivers/net/hyperv/netvsc_drv.c | 53 +++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 6267f706e8ee..222c2fad9300 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2370,6 +2370,55 @@ static int netvsc_unregister_vf(struct net_device *v=
f_netdev)
 	return NOTIFY_OK;
 }
=20
+static struct device_attribute dev_attr_netvsc_dev_attrs[VRSS_SEND_TAB_SIZ=
E];
+static struct attribute *netvsc_dev_attrs[VRSS_SEND_TAB_SIZE + 1];
+
+const struct attribute_group netvsc_dev_group =3D {
+	.name =3D NULL,
+	.attrs =3D netvsc_dev_attrs,
+};
+
+static ssize_t tx_indirection_table_show(struct device *dev,
+					 struct device_attribute *dev_attr,
+					 char *buf)
+{
+	struct net_device *ndev =3D to_net_dev(dev);
+	struct net_device_context *ndc =3D netdev_priv(ndev);
+	ssize_t offset =3D 0;
+	int index =3D dev_attr - dev_attr_netvsc_dev_attrs;
+
+	offset =3D sprintf(buf, "%u\n", ndc->tx_table[index]);
+
+	return offset;
+}
+
+static void netvsc_attrs_init(void)
+{
+	int i;
+	char buffer[32];
+
+	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++) {
+		sprintf(buffer, "tx_indirection_table_%02u", i);
+		dev_attr_netvsc_dev_attrs[i].attr.name =3D
+			kstrdup(buffer, GFP_KERNEL);
+		dev_attr_netvsc_dev_attrs[i].attr.mode =3D 0444;
+		sysfs_attr_init(&dev_attr_netvsc_dev_attrs[i].attr);
+
+		dev_attr_netvsc_dev_attrs[i].show =3D tx_indirection_table_show;
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
@@ -2396,6 +2445,7 @@ static int netvsc_probe(struct hv_device *dev,
 			   net_device_ctx->msg_enable);
=20
 	hv_set_drvdata(dev, net);
+	netvsc_attrs_init();
=20
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);
=20
@@ -2410,6 +2460,7 @@ static int netvsc_probe(struct hv_device *dev,
=20
 	net->netdev_ops =3D &device_ops;
 	net->ethtool_ops =3D &ethtool_ops;
+	net->sysfs_groups[0] =3D &netvsc_dev_group;
 	SET_NETDEV_DEV(net, &dev->device);
=20
 	/* We always need headroom for rndis header */
@@ -2533,6 +2584,7 @@ static int netvsc_remove(struct hv_device *dev)
=20
 	rtnl_unlock();
=20
+	netvsc_attrs_exit();
 	hv_set_drvdata(dev, NULL);
=20
 	free_percpu(ndev_ctx->vf_stats);
@@ -2683,6 +2735,7 @@ static int __init netvsc_drv_init(void)
 		return ret;
=20
 	register_netdevice_notifier(&netvsc_netdev_notifier);
+
 	return 0;
 }
=20
--=20
2.25.1
