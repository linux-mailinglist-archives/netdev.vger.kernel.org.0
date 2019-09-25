Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920EFBE80A
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 00:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfIYWEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 18:04:08 -0400
Received: from mail-eopbgr820093.outbound.protection.outlook.com ([40.107.82.93]:56576
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727197AbfIYWEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 18:04:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/p0igB1SXmItGZvb2pr2ve3Rk2x16t2n3MR5Ah2KkKgNLWOTnNaCAQDTlfap9RU7/OcnHkVQm7PE4Fud9K+qUZA701e8oZUDcHIV4UHm2eHYV9cWxIGITcb9+wHoD/F4tQ6lsvkCbeJEJSGH9R4TUlRml+SPN7JIxe96VhKXq3RmboKWp+I86xd4/RDT0EWEsvpuPeQ1sAWASc4pfm4kkfBNxJdBMK/UvaBvoDnQ9GtsxO9zdB7GykRC83uM1f2P9GPkOfgOASwLrllryB2ED4YYBZXsyIX3cjernzov/27RosTIcRsI/kpz1Yd5S2S9h4WZ+Ypl+Okv6Alj6R4VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOr3onUxRcpbq5hwk+0IMExh3ZYH3QBT3khVb05JrnQ=;
 b=GhCnQexXUBwLJl2b96AOTNaKFbK66Jc1SQEd9Y9cw98DBtbMEigehnyBoq9Ayp4pbceCYjaR4DnxbS8KuDjYkWZJxoOTNmN0fZd+A9xZ22GpoB6TxXr18QJvccs9HlWKRxaa6Q+rmFU9xv4LyPgJLNhs84QG//ae2xCnYx5Nii99BbAUFti1lZ5eE+TaYtD2SWAR1rlceSoTUGZKZZko1O/VMK1slTL/NTNyEcgrquT9c6nlGCL9C3TFJoRaerZjvVFs/qv+ivZyo5T/ozRgw/fuKroSlgbTCEYhxRhl2d31cgMcHEQHao9UpcqrD40KZyQoldpmu8SV4/N6zSdgEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOr3onUxRcpbq5hwk+0IMExh3ZYH3QBT3khVb05JrnQ=;
 b=FceGiady5cRj7v04KxQb/GFuGKLgDyBLr7OitnoK5h7eWqXMYX9MCMCBRtfH9yhAGDkcOq4/GFU+CX8rqLS2bV7DbJZMXoZ0Z6RVxWhDV1j5bE2LqZyAC0jLcPZOUD22PrF7e6G+z7J4Y3GIcss6FoKK9ymsc0VYS4ILYTpMbh0=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB0992.namprd21.prod.outlook.com (52.132.114.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.7; Wed, 25 Sep 2019 22:04:05 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::7d1a:ddb:3473:b383]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::7d1a:ddb:3473:b383%9]) with mapi id 15.20.2327.004; Wed, 25 Sep 2019
 22:04:05 +0000
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
Subject: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Thread-Topic: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Thread-Index: AQHVc+0lDC5AZrZT/kSUmTsZN92eDA==
Date:   Wed, 25 Sep 2019 22:04:04 +0000
Message-ID: <1569449034-29924-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0035.namprd14.prod.outlook.com
 (2603:10b6:300:12b::21) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ffaa024-c710-401c-3c9b-08d7420447cc
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: SN6PR2101MB0992:|SN6PR2101MB0992:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <SN6PR2101MB0992D6F74A0767570FF5B256BF870@SN6PR2101MB0992.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(40224003)(199004)(189003)(3450700001)(1511001)(22452003)(6436002)(6486002)(3846002)(107886003)(7736002)(4720700003)(6636002)(36756003)(6306002)(6512007)(5660300002)(966005)(4326008)(2501003)(14454004)(6116002)(25786009)(71200400001)(2906002)(10290500003)(71190400001)(110136005)(66556008)(6506007)(386003)(66066001)(102836004)(2616005)(486006)(478600001)(2201001)(86362001)(66446008)(476003)(43066004)(81166006)(52116002)(66476007)(186003)(26005)(66946007)(64756008)(99286004)(305945005)(50226002)(256004)(81156014)(5024004)(10090500001)(8936002)(14444005)(8676002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0992;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HnnZkUtC84Lxvx9W4+gIMSMUfqE6OKpBSBrFvX4mWqtgRUDFP3AfDonV4vy7CzJqLwh6C4jsdylYSVQdUwf4HRjUPrLyckd6hD6Ez82l6Kfm4Y1QGMOwXYgE0cVucbRszGAc+YYmJo8wU5v3nZOTP6IzvGCypTgs1G7zU+s/XMeHmK6jKGKFLT+F9qI8Wn+XkoI/PxP8qMq3c49UoX/x+jdOQ7dkHindIAKfnyVaTQMsPnvzd9KDb4Xuw6bFuO2Wflyra5Zb28nLCi4bSfOn0F0ySZprNS2zfqhK9uvKbw+Et1daQQay6NhTfDoFgfWorZJH/TsEwHPTcpVa0kDnlseNNcyCM+RWqdS8x+sReW6zDCOWBcWUN9A6aVonipJ526Lbt9JGDLjlXScbxjtPBlQgJGLXMFT3lORsiDVOP+G/3l6lAZLM1ZLYvprYC0//huSWWlpxSr0BISW0Z6xTkA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffaa024-c710-401c-3c9b-08d7420447cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 22:04:04.9943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UX4avhtUsE4H/xSv537oUmahab7P7Aqk1+0Fyxd3/rXyZQ1qTjRuamnBEZ8AWCh5UrU8qvhrCmD362+jbyOUhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing netvsc_detach() and netvsc_attach() APIs make it easy to
implement the suspend/resume callbacks.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

This patch is basically a pure Hyper-V specific change. I request this
patch should go through Sasha's Hyper-V tree rather than the net tree.

Sasha's Hyper-V tree is here:
https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git

Previously there was a dependency on the commit 271b2224d42f ("Drivers:
hv: vmbus: Implement suspend/resume for VSC drivers for hibernation"),
which was only on Sasha Levin's Hyper-V tree's hyperv-next branch:
https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/log/?h=3Dh=
yperv-next
. Now the patch has been merged into Linus's master tree, but as of now,
the patch (271b2224d42f) has not appeared in the net.git tree, so IMO
it's better for this patch to go through the Hyper-V tree. The added
code in this patch is unlikely to cause a conflict.

In v2:
    Removed the superfluous "cancel_work_sync(&nvdev->subchan_work)".

    Changed the [PATCH net-next] to [PATCH net] in the Subject, because
    IMO this is more of a bug fix rather than a new feaure.

    No other change.

 drivers/net/hyperv/hyperv_net.h |  3 ++
 drivers/net/hyperv/netvsc_drv.c | 57 +++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_ne=
t.h
index ecc9af050387..b8763ee4c0d0 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -952,6 +952,9 @@ struct net_device_context {
 	u32 vf_alloc;
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
+
+	/* Used to temporarily save the config info across hibernation */
+	struct netvsc_device_info *saved_netvsc_dev_info;
 };
=20
 /* Per channel data */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index afdcc5664ea6..53a9451a58a7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2392,6 +2392,61 @@ static int netvsc_remove(struct hv_device *dev)
 	return 0;
 }
=20
+static int netvsc_suspend(struct hv_device *dev)
+{
+	struct net_device_context *ndev_ctx;
+	struct net_device *vf_netdev, *net;
+	struct netvsc_device *nvdev;
+	int ret;
+
+	net =3D hv_get_drvdata(dev);
+
+	ndev_ctx =3D netdev_priv(net);
+	cancel_delayed_work_sync(&ndev_ctx->dwork);
+
+	rtnl_lock();
+
+	nvdev =3D rtnl_dereference(ndev_ctx->nvdev);
+	if (nvdev =3D=3D NULL) {
+		ret =3D -ENODEV;
+		goto out;
+	}
+
+	vf_netdev =3D rtnl_dereference(ndev_ctx->vf_netdev);
+	if (vf_netdev)
+		netvsc_unregister_vf(vf_netdev);
+
+	/* Save the current config info */
+	ndev_ctx->saved_netvsc_dev_info =3D netvsc_devinfo_get(nvdev);
+
+	ret =3D netvsc_detach(net, nvdev);
+out:
+	rtnl_unlock();
+
+	return ret;
+}
+
+static int netvsc_resume(struct hv_device *dev)
+{
+	struct net_device *net =3D hv_get_drvdata(dev);
+	struct net_device_context *net_device_ctx;
+	struct netvsc_device_info *device_info;
+	int ret;
+
+	rtnl_lock();
+
+	net_device_ctx =3D netdev_priv(net);
+	device_info =3D net_device_ctx->saved_netvsc_dev_info;
+
+	ret =3D netvsc_attach(net, device_info);
+
+	rtnl_unlock();
+
+	kfree(device_info);
+	net_device_ctx->saved_netvsc_dev_info =3D NULL;
+
+	return ret;
+}
 static const struct hv_vmbus_device_id id_table[] =3D {
 	/* Network guid */
 	{ HV_NIC_GUID, },
@@ -2406,6 +2461,8 @@ static struct  hv_driver netvsc_drv =3D {
 	.id_table =3D id_table,
 	.probe =3D netvsc_probe,
 	.remove =3D netvsc_remove,
+	.suspend =3D netvsc_suspend,
+	.resume =3D netvsc_resume,
 	.driver =3D {
 		.probe_type =3D PROBE_FORCE_SYNCHRONOUS,
 	},
--=20
2.19.1

