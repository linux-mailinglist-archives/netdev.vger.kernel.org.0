Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC628100945
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKRQeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:34:13 -0500
Received: from mail-eopbgr790134.outbound.protection.outlook.com ([40.107.79.134]:10164
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726314AbfKRQeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 11:34:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcFSc6hmQn2lBVUIt3G20ELpsopb0rj7Z5vF7m103hqbSApcKA1TVFlFUgC4yV2ZIYhwXFlVmBCVAmlOAciPSAEqfc1Ks9LNqw4sj1hnuhLJF+uwwjQgH1x7NXlnbymiC3G6S6gr0PUOSdtM4kSMa5m7dmuxTNzrhYHsXjU8IkKgOhfYUfZtqTEE5ByUhyzYfxZmv5WJ9ZkC6lTVRZTycUGb/bW6dKujnWySpf3EMWH7LgXyxEgURJuJL4mRUsz6GFvwG4l0Lu4e1Py+CNoB8ZY34o39A4SJILpZHA3RvIbPkojeVdtmcr8lVajVQHCNLQof14v50nN3+0pgc8Kvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z12Eg9U0HompOZEJRgpq+arohvCmnoV1YRS255MtJUM=;
 b=V/nK9aif4l+/6X4J4lg+84ku7QgB5Ihv3r07w/uaCINpk5rLUf2tlvyYloDHE5WVXFJ0+2+j3gpDVwT+YZGxu3+e2pZxHSRQ/Jsam2RRLWiNO9PyTw1DLeyzjks1In2VPQY3B865AAGl/v5v70pikgiIgFfz9BKpgjdMxnrfp02ypI62jXKMSUO3KL6OqZmtKM2a5apNm7FB5mOeiWYo7jYhaPokhiU+xgdYbk9jxxdz3Jpqwk2mVKGmqUin6rjMn9lpFYeAv1wC2PoBAzlVIsuGgbRZzwLB/THo/15U3LhjczKm+P7gMjQdkkc2iQxRolJmFezoX4lcgXGtxdRYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z12Eg9U0HompOZEJRgpq+arohvCmnoV1YRS255MtJUM=;
 b=SWWl+XaBloUJ6H1+EGYHYwZXkJdY6VbDXgMxl1tslrADk2RZM4d4CyeQXzqrW/Y4zZONnZeyPfo4MD584+fPMn5YURY3Fu2RAQZxdVBoEmJbY3jcraRsJupk3VT1Mv8XHybHPu7tw1uaEvbsDnW3IN1V9xF10ltohjvOKGS6lUU=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1147.namprd21.prod.outlook.com (20.179.50.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.0; Mon, 18 Nov 2019 16:34:10 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::2c55:a47d:cd39:94d6]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::2c55:a47d:cd39:94d6%9]) with mapi id 15.20.2474.015; Mon, 18 Nov 2019
 16:34:10 +0000
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CY4PR01CA0019.prod.exchangelabs.com (2603:10b6:903:1f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 18 Nov 2019 16:34:09 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net, 1/2] hv_netvsc: Fix offset usage in netvsc_send_table()
Thread-Topic: [PATCH net, 1/2] hv_netvsc: Fix offset usage in
 netvsc_send_table()
Thread-Index: AQHVni4A79ZQWidGmUiZGe0+Wk49NQ==
Date:   Mon, 18 Nov 2019 16:34:09 +0000
Message-ID: <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
References: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CY4PR01CA0019.prod.exchangelabs.com (2603:10b6:903:1f::29)
 To DM6PR21MB1242.namprd21.prod.outlook.com (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 459085d3-6698-40b1-5b24-08d76c45235c
x-ms-traffictypediagnostic: DM6PR21MB1147:|DM6PR21MB1147:|DM6PR21MB1147:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB114702CF0A590F868BA18F68AC4D0@DM6PR21MB1147.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(136003)(346002)(366004)(199004)(189003)(22452003)(2906002)(2201001)(6506007)(7736002)(6116002)(52116002)(3846002)(71200400001)(71190400001)(256004)(305945005)(66946007)(66446008)(22746008)(66476007)(10090500001)(5660300002)(478600001)(10290500003)(4720700003)(25786009)(36756003)(66066001)(486006)(316002)(102836004)(64756008)(66556008)(7846003)(6436002)(6392003)(6486002)(110136005)(54906003)(2616005)(956004)(11346002)(476003)(2501003)(446003)(16526019)(186003)(6512007)(81166006)(81156014)(8676002)(26005)(76176011)(386003)(4326008)(50226002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1147;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CACwf/jMAIRkwxAGK4bj+ntDG7KKbbAp/7O21XNn3+3imNqrb0eY/HzwbP9YpMpgqpRevZRcb7tatu8hnpWggnf/C4D/taOq9yjev2bxBsphB2LN5qXW/UiCir3sDoDvaGwRQqUq0xvJVwl+IaQabQ7DevfLdHJPw+AmVR0RUA1xi2y31a63EFIFS1YxAzFJE8kPbLHq6cWpq0jDcDJazHjBEDtMDfxVKFF+v4wbEr2cw0QyrOsS6ArhUIzIvSD+4ycEQLgxyUqL3506Hk7spaWMM31PyLxbTSN6ESdgiL6EXLTMnIjPEkXtzYuZmKoHizVLLHA1xtrI5fqZA2m2p6mIn2G7WqG6w7zxenb/ox+OmIwqP0/FbnBmUgspQLAQgUCyFS8D0Bzf0GZR5vrqDhNz1oDB8PIZv7fPun0XTgsnyiRrQOkgrXYfwCyLSi3R
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459085d3-6698-40b1-5b24-08d76c45235c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 16:34:09.9702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YIp3YeE3jesL42CtjAJNvOmAIF5dRAZimsj+HPKYMdxfYx/EswkjKkD0o5vne2IFsFOcgNK3s+u1UMjMUofnsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reach the data region, the existing code adds offset in struct
nvsp_5_send_indirect_table on the beginning of this struct. But the
offset should be based on the beginning of its container,
struct nvsp_message. This bug causes the first table entry missing,
and adds an extra zero from the zero pad after the data region.
This can put extra burden on the channel 0.

So, correct the offset usage. Also add a boundary check to ensure
not reading beyond data region.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling =
(vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_ne=
t.h
index 670ef68..fb547f3 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -609,7 +609,8 @@ struct nvsp_5_send_indirect_table {
 	/* The number of entries in the send indirection table */
 	u32 count;
=20
-	/* The offset of the send indirection table from top of this struct.
+	/* The offset of the send indirection table from the beginning of
+	 * struct nvsp_message.
 	 * The send indirection table tells which channel to put the send
 	 * traffic on. Each entry is a channel number.
 	 */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index d22a36f..efd30e2 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1178,20 +1178,28 @@ static int netvsc_receive(struct net_device *ndev,
 }
=20
 static void netvsc_send_table(struct net_device *ndev,
-			      const struct nvsp_message *nvmsg)
+			      const struct nvsp_message *nvmsg,
+			      u32 msglen)
 {
 	struct net_device_context *net_device_ctx =3D netdev_priv(ndev);
-	u32 count, *tab;
+	u32 count, offset, *tab;
 	int i;
=20
 	count =3D nvmsg->msg.v5_msg.send_table.count;
+	offset =3D nvmsg->msg.v5_msg.send_table.offset;
+
 	if (count !=3D VRSS_SEND_TAB_SIZE) {
 		netdev_err(ndev, "Received wrong send-table size:%u\n", count);
 		return;
 	}
=20
-	tab =3D (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
-		      nvmsg->msg.v5_msg.send_table.offset);
+	if (offset + count * sizeof(u32) > msglen) {
+		netdev_err(ndev, "Received send-table offset too big:%u\n",
+			   offset);
+		return;
+	}
+
+	tab =3D (void *)nvmsg + offset;
=20
 	for (i =3D 0; i < count; i++)
 		net_device_ctx->tx_table[i] =3D tab[i];
@@ -1209,12 +1217,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 		    net_device_ctx->vf_alloc ? "added" : "removed");
 }
=20
-static  void netvsc_receive_inband(struct net_device *ndev,
-				   const struct nvsp_message *nvmsg)
+static void netvsc_receive_inband(struct net_device *ndev,
+				  const struct nvsp_message *nvmsg,
+				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg);
+		netvsc_send_table(ndev, nvmsg, msglen);
 		break;
=20
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1232,6 +1241,7 @@ static int netvsc_process_raw_pkt(struct hv_device *d=
evice,
 {
 	struct vmbus_channel *channel =3D nvchan->channel;
 	const struct nvsp_message *nvmsg =3D hv_pkt_data(desc);
+	u32 msglen =3D hv_pkt_datalen(desc);
=20
 	trace_nvsp_recv(ndev, channel, nvmsg);
=20
@@ -1247,7 +1257,7 @@ static int netvsc_process_raw_pkt(struct hv_device *d=
evice,
 		break;
=20
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg);
+		netvsc_receive_inband(ndev, nvmsg, msglen);
 		break;
=20
 	default:
--=20
1.8.3.1

