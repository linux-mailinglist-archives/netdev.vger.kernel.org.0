Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9474D100946
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKRQeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:34:17 -0500
Received: from mail-eopbgr790110.outbound.protection.outlook.com ([40.107.79.110]:29024
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbfKRQeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 11:34:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoupD3a3gRTMyK0444BHaUvgE+fbrgolqWMDyxt9aOXdrVBCu5thXGuHx/mOeLAx7qBqFngIWMiejEJR1dIdM0EwbO7B20pqRcFynS9qf8tKck/ri/87hWKTjgGbxhw8KA3PuMvhoXq2tvaRjGZU0PiWcEfTTx9VUiHpZ4qApCOjZ1cu81GT6YSyJUOxnU+AfWGshHrgzXsyxb9Rc5TGlUfwAylXWQA5sCCmCsg5GnlRt/SPnZHY348cZScdAn/79MWACGrk6Gwpt6HejKDqXo4yoUb/xodjJxGIwqxfsDwI7OPu/0Z4PZgG95jhgzrdnOVP90CTs2es4jTblBUaRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lobSHtg/0E2VJByIX2yN9I1+j1YoYY5Ketxk+6AtTW8=;
 b=KPOId82elWXvK1taQrHQArXVFJYHLzw6ptbJIGuamn/IpZDSU+yf9skjRLm0gJ1tiP4rEgRrGSfiNgvTR/K5/io0ojGXlZ2cY1HtodwYmhWrGsvcx0LFyBHvj/mHl5f/8ZAxlzBIghXHFvw+yLu9Z1E+FVVnqJtCKIKIJ+3pBoyIAn1UV/LRnQj0I1FvZqYpusBiI6IBNm5XmOyrdWHZky3RjVBZtInHYX2ZfddkijuzGQabdET2ErpLLTM8koXLx2sUY670Rx8KYlHNIakqhUqQ61kZE0MUat+qheLCV/NbogKIxBHEEpu22it3W9gcsSk+Zet18V8SKOpy59oGmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lobSHtg/0E2VJByIX2yN9I1+j1YoYY5Ketxk+6AtTW8=;
 b=XtmBOSrqszKepv1tsu4i7z3fACmLWvLvwAk8m7tB/zdB/IOgpLGj+JuukLX6pY0ImedZl2aTzxiMY2yIWqp8zOfRI1hdEIG5A2bYD5RwWW5PcR564OFmEZ8uQ4xAMnO4PxlXv+3U6gVlN8LS6GLZisnKkg/f6u1Y5O/e0v0SdG4=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1147.namprd21.prod.outlook.com (20.179.50.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.0; Mon, 18 Nov 2019 16:34:14 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::2c55:a47d:cd39:94d6]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::2c55:a47d:cd39:94d6%9]) with mapi id 15.20.2474.015; Mon, 18 Nov 2019
 16:34:14 +0000
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CY4PR01CA0019.prod.exchangelabs.com (2603:10b6:903:1f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 18 Nov 2019 16:34:13 +0000
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
Subject: [PATCH net, 2/2] hv_netvsc: Fix send_table offset in case of a host
 bug
Thread-Topic: [PATCH net, 2/2] hv_netvsc: Fix send_table offset in case of a
 host bug
Thread-Index: AQHVni4DVVlGMTbd+EO5+K+J9FRNjA==
Date:   Mon, 18 Nov 2019 16:34:14 +0000
Message-ID: <1574094751-98966-3-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: c5db569c-0e02-4c2b-cf8c-08d76c4525d0
x-ms-traffictypediagnostic: DM6PR21MB1147:|DM6PR21MB1147:|DM6PR21MB1147:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB114706108D2D3E8D343F668FAC4D0@DM6PR21MB1147.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(136003)(346002)(366004)(199004)(189003)(22452003)(2906002)(2201001)(6506007)(7736002)(6116002)(52116002)(3846002)(71200400001)(71190400001)(256004)(305945005)(66946007)(66446008)(22746008)(66476007)(10090500001)(5660300002)(478600001)(10290500003)(4720700003)(25786009)(36756003)(66066001)(486006)(316002)(102836004)(64756008)(66556008)(7846003)(6436002)(6392003)(6486002)(110136005)(54906003)(2616005)(956004)(11346002)(476003)(2501003)(446003)(16526019)(186003)(6512007)(81166006)(81156014)(8676002)(26005)(76176011)(386003)(4326008)(50226002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1147;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 35aNpX704zNDjMoiini8MuXzg1glzH0lCXevtp7omS/4qnaR9UDN0jwU+UQ82zFfWxhGxGi3grvx3/e2CIGKr0w8KD6QzDbCuA81xPDvS94V2BbYmsGRiASzB+rvq6YWaOT67+Yryg5fquoT9Ewmz73gApByxOjXUY7pT4W67bnAp4lyCcaVqrOKT//1rQYwnPBZoYOck+Nx0LZSzN2C4Sqrt+IYstJsjgKan5VYOgkWgDZovVGbSLYIRcDGU9whyL5+rrd1uxypggGT9MYEZQEg3dB7SeZ4GhMW9spa2Rh6LcLGWCxiQlDlDnEZBjj3INjVhe+uP5yTNZQsrpbgQeKwrVEisiXNnRMoS7yjO9vgCGg+u7O54JjJL4QcLImG808VQLjha6VCcozhX2Ccg/ryOB5jpnznoLhQbRpqm+eGD/rygpUO1HUT13Na1hSW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5db569c-0e02-4c2b-cf8c-08d76c4525d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 16:34:14.0138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Ud4Om2qAgxQhHr8mQ/alqQtyHb9zHx4JNNG/+DLOraWd5xaIZhfbYz44NegZSp4/3AvPjMyPiK371YmwS7ZoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If negotiated NVSP version <=3D NVSP_PROTOCOL_VERSION_6, the offset may
be wrong (too small) due to a host bug. This can cause missing the
end of the send indirection table, and add multiple zero entries from
leading zeros before the data region. This bug adds extra burden on
channel 0.

So fix the offset by computing it from the end of the table. This
will ensure netvsc driver runs normally on unfixed hosts, and future
fixed hosts.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling =
(vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index efd30e2..7c5481a 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1178,6 +1178,7 @@ static int netvsc_receive(struct net_device *ndev,
 }
=20
 static void netvsc_send_table(struct net_device *ndev,
+			      struct netvsc_device *nvscdev,
 			      const struct nvsp_message *nvmsg,
 			      u32 msglen)
 {
@@ -1193,6 +1194,13 @@ static void netvsc_send_table(struct net_device *nde=
v,
 		return;
 	}
=20
+	/* If negotiated version <=3D NVSP_PROTOCOL_VERSION_6, the offset may be
+	 * wrong due to a host bug. So fix the offset here.
+	 */
+	if (nvscdev->nvsp_version <=3D NVSP_PROTOCOL_VERSION_6)
+		offset =3D msglen - count * sizeof(u32);
+
+	/* Boundary check for all versions */
 	if (offset + count * sizeof(u32) > msglen) {
 		netdev_err(ndev, "Received send-table offset too big:%u\n",
 			   offset);
@@ -1218,12 +1226,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 }
=20
 static void netvsc_receive_inband(struct net_device *ndev,
+				  struct netvsc_device *nvscdev,
 				  const struct nvsp_message *nvmsg,
 				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg, msglen);
+		netvsc_send_table(ndev, nvscdev, nvmsg, msglen);
 		break;
=20
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1257,7 +1266,7 @@ static int netvsc_process_raw_pkt(struct hv_device *d=
evice,
 		break;
=20
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg, msglen);
+		netvsc_receive_inband(ndev, net_device, nvmsg, msglen);
 		break;
=20
 	default:
--=20
1.8.3.1

