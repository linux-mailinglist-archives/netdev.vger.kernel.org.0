Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DFCB05FD
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 01:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfIKXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 19:37:52 -0400
Received: from mail-eopbgr770133.outbound.protection.outlook.com ([40.107.77.133]:3739
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbfIKXhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 19:37:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2EXfu6F7N6kh2p4OOjBRKNP7SkRqp43hVbVYdkpoVzmK6As8yn9KdYE2M1guLharQywJtiVP2XNYyVBJPrNJw+Q+ezs0CgjXPeM7/yN53P3A3t5Xv8Rk8dfDvrBVZ50yHKCe5g2r1KFu+JPWni/BpZtvnY9/pRjU05Eo5NfVPK0ci8UQcVIK5hORASKn+0sVVBoE9b67IsC2iZS1w+DN16PAcBd94nsAOLseNKLunPI0EKVMa+/Sc28N7/hiaN7M08Ktv/MUF2WnhdUg2KAYQ4mEuSlR7A/3XTTZG2U9cW7qKjU/6hJ1TYrSZ4thNmSbGYTINJqYZ7z0vV78LhCmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU5OsBlNZYLs+pfgRHkSGQcW/lt3AQ4pt3BPnhucPCQ=;
 b=h7Em+rYBXvUdET7oI6lhvnOsHFblT006l/gj4fwh7qKaCA70sUIaReFZZYLFZ2i+C8oPincunevMGtiK0XoTyzrliTI8XH/3TkIu3WOM40hlKChDT31qaIB1aSkgDyb34mgfR9aI2oIQhbIJ05eb6tbs5eIu0JAPoAqNSheFKuRkb6GJP3j0IkGVM13pBbpspwoJB7ztwyH2aG8F+7PaEPA4hsKnKEhwYbRX+uKe2CG5GrHTRjAMIAHRHUOeftmR0vB3W/0DzCc6od+b6/18HDhwhWx2tWhUfkdlzzg0ygpnh3fgLF1yVqVCuEJHYLoij09llhcrGXrURhppL028Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU5OsBlNZYLs+pfgRHkSGQcW/lt3AQ4pt3BPnhucPCQ=;
 b=KSeu5NhKuuiXcU/LzOWOOqXPc0qMXfV0TifFV0G/TptFMXmW4g3DkdWffB2+02XLOv5JIP6vf7kwa2s123agL8CF4/+HtUtMKhU0GgAFGTpLqJTz5QAQInw1Pbeo5GGGcxvcBDqvpu8b7GIVh2MjpC9+ChvlpPLrJtR61QHjgyM=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (52.132.114.19) by
 SN6PR2101MB0909.namprd21.prod.outlook.com (52.132.117.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Wed, 11 Sep 2019 23:37:49 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::dd56:aa4f:204f:86a4]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::dd56:aa4f:204f:86a4%3]) with mapi id 15.20.2263.005; Wed, 11 Sep 2019
 23:37:49 +0000
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
Subject: [PATCH][PATCH net-next] hv_netvsc: Add the support of hibernation
Thread-Topic: [PATCH][PATCH net-next] hv_netvsc: Add the support of
 hibernation
Thread-Index: AQHVaPnrTXkpPrlV+ESDlk6ioSqLfw==
Date:   Wed, 11 Sep 2019 23:37:49 +0000
Message-ID: <1568245063-69693-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:101:1f::24) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b84e40c-4466-48cc-35fb-08d737110e28
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:SN6PR2101MB0909;
x-ms-traffictypediagnostic: SN6PR2101MB0909:|SN6PR2101MB0909:
x-ms-exchange-transport-forked: True
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN6PR2101MB09095DA0E7360814884B9774BFB10@SN6PR2101MB0909.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(40224003)(3450700001)(6512007)(6306002)(486006)(476003)(2616005)(2201001)(5024004)(14444005)(256004)(6486002)(86362001)(36756003)(5660300002)(186003)(4326008)(102836004)(6436002)(53936002)(25786009)(26005)(107886003)(10290500003)(316002)(478600001)(2501003)(43066004)(52116002)(14454004)(386003)(6506007)(110136005)(66066001)(99286004)(1511001)(22452003)(6636002)(4720700003)(71200400001)(71190400001)(305945005)(66446008)(66946007)(66476007)(66556008)(64756008)(50226002)(966005)(10090500001)(7736002)(2906002)(81156014)(8676002)(8936002)(81166006)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0909;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IFrZkaQpp1taeoeBnAgDtGwkGLGYQWQEDDVvVE1NDZizokeHxhOyGttPT+M/PtW7RwLJW8t6W6Dqx0BdIqmb+RxFB/FIk8pwaYOaFuUMFglFEoeOyOldnau33D9mJTXnzqMglTmPV3Ww2s4c8Vq8ErwivOGsywATCSfrk3aQvtGaJev49TYzhREV+zFBmPxoIA3QeywvB5HBZ5vR2pjS6f8MX86Y+AC/3c0uA/SaJzUbDmGIUHlSN1tXTQDyyNfm511T76IAM60QbkiSucujzbhAZEcWV8yJ34n0E56EEA8px1RSV5cM/2W87cfAk+KgjNhUXtlTxd7293jh9uKcelnMsAqXwaEmvebAD9UuWZckwGqqCZsi/U9YPSUhEXoG653RRPEX8Bi1yy/vKpetLARqWKCK1FzgBSznQ2LhVPE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b84e40c-4466-48cc-35fb-08d737110e28
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 23:37:49.1320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bx5epKjww/ENxr18E6b9mHD6BJWVjGs80IXEwOWT0ragsgC9KZ4UKepkHvpRE8t+8jwZR//3/e7tES55cm2tOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0909
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing netvsc_detach() and netvsc_attach() APIs make it easy to
implement the suspend/resume callbacks.

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

 drivers/net/hyperv/hyperv_net.h |  3 +++
 drivers/net/hyperv/netvsc_drv.c | 59 +++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_ne=
t.h
index ecc9af0..b8763ee 100644
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
index afdcc56..f920959 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2392,6 +2392,63 @@ static int netvsc_remove(struct hv_device *dev)
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
+	cancel_work_sync(&nvdev->subchan_work);
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
@@ -2406,6 +2463,8 @@ static int netvsc_remove(struct hv_device *dev)
 	.id_table =3D id_table,
 	.probe =3D netvsc_probe,
 	.remove =3D netvsc_remove,
+	.suspend =3D netvsc_suspend,
+	.resume =3D netvsc_resume,
 	.driver =3D {
 		.probe_type =3D PROBE_FORCE_SYNCHRONOUS,
 	},
--=20
1.8.3.1

