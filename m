Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403C1B05FB
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfIKXhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 19:37:31 -0400
Received: from mail-eopbgr720102.outbound.protection.outlook.com ([40.107.72.102]:52592
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbfIKXhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 19:37:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xko9EdG9zfgVIir79UkLZgncUmrZRHY1KA9qGgGu+rpcqHrLXwNfzKHELU8CZVZ8OFgJePxPJoICBivIkVzDZzZL16LXMY94st0pC6wavvEohYuDb39juP92Wd5qVEM1MYos77sRFtUt75I31i5H82xLp086ye9u86NDZY9bGfzFWlK+OFs+YGXHIyAYOlNyzk/Rn7tI24u5UwRtRG3g3Hihbe0W2CLVbnthhh7CiAXfFyIBEX1vcUl8xbJqWvSc82r+S1wy2GiiceZebqMiDQ8WZep/dzHSFOM7myP3gIPK9g5Ftm6vHuTSAyfKMqU3RChJS3ECuhkMWES6jq03rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2RfyMarTjtOdxIZOz56Nq7RKWw2Q6J7zXiEC/6iWEs=;
 b=WmF03bLhKOITvx6U0SzXtWMnbrabPsXZQjnwjUSyeN25K1B9qN8CushNex7oO38bAc3OhnOT0NpHYL+RL5GDtKgz6jb1L1MbZFjpggG2vLOxExqONEDxuP46Wr2u5JpEWGEQc5rDwHaKPXQ5Swy42DsPnR+/0uVkREcVmBck6ejINR0ujyydobdjmkmxRDiU7tYODY5UdpniQOwtS554gKlzNZTd/rMj4G0C51O9a9kG/e5Ip6BCTiay2pv8/5GHk70567VCqAjdI40jwETIjd4r67mE6hKCmw1mPrbbeXb5LlCITgsFQGdMK4cp/Ii1kp0tVwZkfN4fhOTiKicMAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2RfyMarTjtOdxIZOz56Nq7RKWw2Q6J7zXiEC/6iWEs=;
 b=hf+XtLZ/jRuJV/ydkz73Snncyh8rV6Ev4fMFnnaxLXLhVw3av9cLbJtUeKnt5r3Dzy/PWueZNPpfnh5kSUmLuTDpcCClaByvRkfFillqoeUpzTb0fYpP9KZC+y7mWz7fbetKbArpFKQutfYqiDoZWaIv25Y6Bh6sWIoE0V5riEY=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB0909.namprd21.prod.outlook.com (52.132.117.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Wed, 11 Sep 2019 23:37:28 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::dd56:aa4f:204f:86a4]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::dd56:aa4f:204f:86a4%3]) with mapi id 15.20.2263.005; Wed, 11 Sep 2019
 23:37:28 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
CC:     Dexuan Cui <decui@microsoft.com>
Subject: [PATCH][PATCH net-next] hv_sock: Add the support of hibernation
Thread-Topic: [PATCH][PATCH net-next] hv_sock: Add the support of hibernation
Thread-Index: AQHVaPnfZEIF1mWagU2tFFfpr8fxkg==
Date:   Wed, 11 Sep 2019 23:37:27 +0000
Message-ID: <1568245042-66967-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0050.namprd02.prod.outlook.com
 (2603:10b6:301:60::39) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a176173-3073-44b7-c30e-08d73711019e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:SN6PR2101MB0909;
x-ms-traffictypediagnostic: SN6PR2101MB0909:|SN6PR2101MB0909:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR2101MB090917EB59C04E79FA6E17EFBFB10@SN6PR2101MB0909.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(3450700001)(6512007)(6306002)(486006)(476003)(2616005)(2201001)(14444005)(256004)(6486002)(86362001)(36756003)(5660300002)(186003)(4326008)(102836004)(6436002)(53936002)(25786009)(26005)(107886003)(10290500003)(316002)(478600001)(2501003)(43066004)(52116002)(14454004)(386003)(6506007)(110136005)(66066001)(99286004)(1511001)(22452003)(6636002)(4720700003)(71200400001)(71190400001)(305945005)(66446008)(66946007)(66476007)(66556008)(64756008)(50226002)(966005)(10090500001)(7736002)(2906002)(81156014)(8676002)(8936002)(81166006)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0909;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GUwaCMkCZHcPaNzY+1f6Dd4GZPDhcxs4oovNerpbqtPW7SZ26HN7pEW6oNmsyeUzvXOcf6v1Zy3L5GwqiGcJrd4QEOXd/QDNEMNC2X06V2o6mueEJYZYflJ7mByMag/rCNRvDl3Tv1vBxHUu6E0H8ckFNniJmJ2nNWgVm1IKVeBPC4ZRstH5Z4dbgq9cOazokvk63buWCGRAOrsLsRGWOjTvj+DvoqyiyxKNr/tdAG2ZhtimBXLFHN0G1Z2tp3Ogb5dp83DH+jADOXxK7u+/BEPRCHkfc3Fp32RiMxbA3mRF3kw2gj92dyKK66dnlsaG/TXkqd4KMn1p7LCACWP8slaNgFp2rNmvVsyzLrBw1PvdDX/PzKcVIR06XktEwv5defDCV+efR30v7KB/oDtjoBaY51mJpvAmUqZJxtVKgJo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a176173-3073-44b7-c30e-08d73711019e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 23:37:27.9816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8FLn5qAgL+BlqYfxGH7mar5NUayA8C8RcIrlGq1OKA8CPnby1pKnzjjQpcvJORHHBaMRJdO8FxF637kpwxRLwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0909
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary dummy callbacks for hibernation.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
This patch is basically a pure Hyper-V specific change and it has a
build dependency on the commit 271b2224d42f ("Drivers: hv: vmbus: Implement
suspend/resume for VSC drivers for hibernation"), which is on Sasha Levin's
Hyper-V tree's hyperv-next branch:
https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/log/?h=3Dh=
yperv-next

I request this patch should go through Sasha's tree rather than the
net-next tree.

 net/vmw_vsock/hyperv_transport.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index f2084e3..e91a884 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -930,6 +930,24 @@ static int hvs_remove(struct hv_device *hdev)
 	return 0;
 }
=20
+/* hv_sock connections can not persist across hibernation, and all the hv_=
sock
+ * channels are forceed to be rescinded before hibernation: see
+ * vmbus_bus_suspend(). Here the dummy hvs_suspend() and hvs_resume()
+ * are only needed because hibernation requires that every device's driver
+ * should have a .suspend and .resume callback: see vmbus_suspend().
+ */
+static int hvs_suspend(struct hv_device *hv_dev)
+{
+	/* Dummy */
+	return 0;
+}
+
+static int hvs_resume(struct hv_device *dev)
+{
+	/* Dummy */
+	return 0;
+}
+
 /* This isn't really used. See vmbus_match() and vmbus_probe() */
 static const struct hv_vmbus_device_id id_table[] =3D {
 	{},
@@ -941,6 +959,8 @@ static int hvs_remove(struct hv_device *hdev)
 	.id_table	=3D id_table,
 	.probe		=3D hvs_probe,
 	.remove		=3D hvs_remove,
+	.suspend	=3D hvs_suspend,
+	.resume		=3D hvs_resume,
 };
=20
 static int __init hvs_init(void)
--=20
1.8.3.1

