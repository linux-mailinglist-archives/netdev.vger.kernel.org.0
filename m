Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4948C82ACF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 07:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbfHFFSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 01:18:18 -0400
Received: from mail-eopbgr1300094.outbound.protection.outlook.com ([40.107.130.94]:34048
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfHFFSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 01:18:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCwylK22+SaUBsaQHd+lTb0yc1c2hDCAcDYD11XhWagkYaPljr35Adhmt1yG9a8eqj2L1hApxlVx/NOWBCGxO1INB7K/HY/Ilq+bcF9T1Sksn1tRSpa7//EOvgNsaEUSkNTJiW9aGl/05Yf4ybKZQT8Jpc9kucmtn8U5GLwZ/fblku1c/cfdcgNnJHJrSXwamoxZrT2eIzqVoeOdtpr3n1V1QwZ7bUPh6OSs8JDQohJlfcZk5on/2alqOI+eTJ+f9L8x8jZ+0RaY2U/rmVGYxiHgYu7GZXZvQsa61veH+IGTkgXG6+pFbpn8GxNIT4oTo1d7DvTsR4IEizGMTUA/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyEG+Ela2OW7niYY7Nbb2krLEK5P1iF/Sdg80C2D5LI=;
 b=DAN0mEl/nihblhdDr897ShmMeIzH421WNr7cLWsVuLAVcFy1aB7vy3AoUiQJZKpZTWQaiWNfMYQ9AqLoCUzLFNDODF1mCZxHnJefVfqOMZ/2bYYWYkU+Bh6hQW1Z7mfsDsuPMQ4ePVHY+MObNQEa5Z9jO9SmCkdHZMKQ0xY3PnzfOROFSndw30jcJDpPpVtj0Dd4dXjE/xwmcYYfGsPnWmfzw2dJRQoxzkBTYdnPkmXtqIxvqKVGNKP6QEwVIJqi9iQ+ZZ+WuPvmIjC+4tMQF9jSOERE1W2LuFbhwcsdnQoU+4UDgCAaec8uogeuMWGDq2MdyS8+ZBXuekpnFx/N8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyEG+Ela2OW7niYY7Nbb2krLEK5P1iF/Sdg80C2D5LI=;
 b=hqzOdPVd30pRHT5uBIAn6+mKl306bTpA7d2Uz0PptzWuEB2w3bCQSJ+E85XWhI7GnBomfRqMgavWqJB9wGP5GsIisu5qAaCbysP72RD35jHJpbpT53oXCOyz4kvkPdIKHbohj7kcSnXIRBRSbw1+DXsnx6YKLC2yiMkDpIxObFQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0186.APCP153.PROD.OUTLOOK.COM (10.170.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Tue, 6 Aug 2019 05:17:44 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Tue, 6 Aug 2019
 05:17:44 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Topic: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Index: AdVMFVwGFODpycnVS02FuESxq+YKEg==
Date:   Tue, 6 Aug 2019 05:17:44 +0000
Message-ID: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-06T05:17:40.7810580Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0a7ae532-a90b-4d21-8231-087ebdf2b42d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:f805:f5de:9ada:9d42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbf3047f-598a-4ffa-9caa-08d71a2d69cd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0186;
x-ms-traffictypediagnostic: PU1P153MB0186:|PU1P153MB0186:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB018689130AB5F533B71B0027BFD50@PU1P153MB0186.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(189003)(199004)(186003)(102836004)(7736002)(2501003)(9686003)(66476007)(66556008)(64756008)(5660300002)(14444005)(76116006)(110136005)(66446008)(66946007)(256004)(4326008)(10290500003)(86362001)(46003)(305945005)(52536014)(68736007)(6506007)(53936002)(6436002)(486006)(6116002)(1511001)(22452003)(476003)(55016002)(10090500001)(74316002)(2906002)(7416002)(8936002)(81156014)(81166006)(14454004)(8676002)(7696005)(8990500004)(71200400001)(6636002)(316002)(25786009)(71190400001)(99286004)(478600001)(54906003)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0186;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GNvyxGs+Oa/AujcPoaZU/IRqJLvhQnxbg/6MYKSYq3dqP2JGrPPzjw4hpc5cc6cazlcV8L/FFIQmgt/XbgGspVSnoXwUZHlPQGTEMbO6Yy3a2ql/skOn7aEvxF74XLsjshAbNxz8KM1KH8bkIpfl03AHJHY8uzAQ+o6VQroohyS1l6FmqH+1l2kYX1gst29R7kUA484bG/0rGPI5PxazCI9kEQX9QDU4q4kWuiM4OEx4xkQCf3aWJCr+gPZzbUMdhm5vSDD68b3v5Cb3IFprxgffRD8Cu7xu1Ab3jwSmi1WhxAQ9qfg9PPCyRFXb953HpKeaa8fanZ3MYj0xa3XnqR8ZT1s+TxpQdSinSPgPblAMJyhfQwQ2ikpoYrxsRZRVZFNgEIq46gkjaAtKCef9Tv4F4qpwJ+kiPfrXZvHf+rk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf3047f-598a-4ffa-9caa-08d71a2d69cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 05:17:44.2600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3qBai28Ik47qz2GhqLz1Mjc08gOiQTvymDu63nWVMENVH3KKHBpYnfjP4spnfYT9yGEqCpFUxTBOUQSXDSXk4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This fixes a warning of "suspicious rcu_dereference_check() usage"
when nload runs.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 44 +++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index f9209594624b5..25502d335b94f 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1236,25 +1236,10 @@ static void netvsc_get_pcpu_stats(struct net_device=
 *net,
 	}
 }
=20
-static void netvsc_get_stats64(struct net_device *net,
-			       struct rtnl_link_stats64 *t)
+static void netvsc_get_per_chan_stats(struct netvsc_device *nvdev,
+				      struct rtnl_link_stats64 *t)
 {
-	struct net_device_context *ndev_ctx =3D netdev_priv(net);
-	struct netvsc_device *nvdev =3D rcu_dereference_rtnl(ndev_ctx->nvdev);
-	struct netvsc_vf_pcpu_stats vf_tot;
-	int i;
-
-	if (!nvdev)
-		return;
-
-	netdev_stats_to_stats64(t, &net->stats);
-
-	netvsc_get_vf_stats(net, &vf_tot);
-	t->rx_packets +=3D vf_tot.rx_packets;
-	t->tx_packets +=3D vf_tot.tx_packets;
-	t->rx_bytes   +=3D vf_tot.rx_bytes;
-	t->tx_bytes   +=3D vf_tot.tx_bytes;
-	t->tx_dropped +=3D vf_tot.tx_dropped;
+	u32 i;
=20
 	for (i =3D 0; i < nvdev->num_chn; i++) {
 		const struct netvsc_channel *nvchan =3D &nvdev->chan_table[i];
@@ -1286,6 +1271,29 @@ static void netvsc_get_stats64(struct net_device *ne=
t,
 	}
 }
=20
+static void netvsc_get_stats64(struct net_device *net,
+			       struct rtnl_link_stats64 *t)
+{
+	struct net_device_context *ndev_ctx =3D netdev_priv(net);
+	struct netvsc_device *nvdev;
+	struct netvsc_vf_pcpu_stats vf_tot;
+
+	netdev_stats_to_stats64(t, &net->stats);
+
+	netvsc_get_vf_stats(net, &vf_tot);
+	t->rx_packets +=3D vf_tot.rx_packets;
+	t->tx_packets +=3D vf_tot.tx_packets;
+	t->rx_bytes   +=3D vf_tot.rx_bytes;
+	t->tx_bytes   +=3D vf_tot.tx_bytes;
+	t->tx_dropped +=3D vf_tot.tx_dropped;
+
+	rcu_read_lock();
+	nvdev =3D rcu_dereference(ndev_ctx->nvdev);
+	if (nvdev)
+		netvsc_get_per_chan_stats(nvdev, t);
+	rcu_read_unlock();
+}
+
 static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
 {
 	struct net_device_context *ndc =3D netdev_priv(ndev);
