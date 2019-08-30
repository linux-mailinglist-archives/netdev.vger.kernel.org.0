Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCC8A2D8D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfH3Dpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:45:40 -0400
Received: from mail-eopbgr780137.outbound.protection.outlook.com ([40.107.78.137]:57344
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbfH3Dpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 23:45:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFL37l3+8E0gNAnm+kevhxjXpGKXG1y6Me4Lu9D9yUjJ2zFmnwxMDx4TeyAWCAppG+ZjJ6jx97cI63SdOqW5vN0Eb/aDHBkKI44ZHfCoIfmpg/ST1odQqjsAc7k+12Z8Nz8tshLLN1pYodzFtaqXkjxMfGMx+JkQd3vAHOMSTQjBUzYkSYEmNnOlOMUqnJ3oLjQe7CeZgrsWwVd0Z9WfylHEKrv88WLZzOvM7BjnayI91nM+4v7QIDiDDxS+27DjwvNJC5RaS5B4ouiMDildjse+RgqBjAhZaOGgq/GKml0v8+wOXd0/KpfelkHjEIhGhqOz2wI2Ev29U643jF0mPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLXZJoFvAsuji7Xt+B38YnSUmRLxb+E15GK8aClGxK8=;
 b=A8CWphiomoPs1Ipgg055/+Ki9epHm7HG2YA4e977e9+G8z/H4E28oRl4v9wz4A8HaYEpQQxREav7YHziHTZfM+hrigG9EGEwxrA5ngV2EIsOTaWRwtFzy8cAZp1upLvr9J4zK98Tq4j+o6yjmbUW/VqJVD2Kpw+/JvWQilPuzZHY6APrO4VnbuWVvgQFGUjlMlGFoUD4pSzZwddVW36V6N0tLUnOvoCNl8ytp5H1nn9ZdL+94WFRpy5auzX9Hu4yYOAQWcBvxTX/XfuXIsUSbt7h9hIX51iIrkiBdtR+SLPwOrP9gUEzC8ES008DOfdfvswFV9ycYc6wUv4M9sQ9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLXZJoFvAsuji7Xt+B38YnSUmRLxb+E15GK8aClGxK8=;
 b=eOMoA+0oNJQJ8w/jflcxt6Ib12YSCYRnniLre2QNgvlHzDHb/sKdwgHn8XtxmZqi+ujkL4w7tck+Rs75TlVM5Iyskdlsa06sxc21En2ddKgCpER1WwvkZJVVzas3d8jy7JT6IpAYY37WKJN+tUdrKzjtodFQu9q+6Ry/TAAGzy4=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1307.namprd21.prod.outlook.com (20.179.52.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.1; Fri, 30 Aug 2019 03:45:38 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::d44f:19d0:c437:5785%5]) with mapi id 15.20.2241.000; Fri, 30 Aug 2019
 03:45:38 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF NIC
Thread-Topic: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Thread-Index: AQHVXuVjcLTsBjXUAk6+Rk/JN7f/sw==
Date:   Fri, 30 Aug 2019 03:45:38 +0000
Message-ID: <1567136656-49288-3-git-send-email-haiyangz@microsoft.com>
References: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:301:74::28) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 399048f8-76ba-40ef-8d7a-08d72cfc85a1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1307;
x-ms-traffictypediagnostic: DM6PR21MB1307:|DM6PR21MB1307:|DM6PR21MB1307:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB130754E034E56DA8FB1D246AACBD0@DM6PR21MB1307.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(189003)(199004)(81156014)(8676002)(99286004)(50226002)(7846003)(66446008)(476003)(71200400001)(4326008)(66476007)(102836004)(3846002)(14454004)(8936002)(2906002)(14444005)(81166006)(256004)(478600001)(10090500001)(76176011)(22452003)(6436002)(26005)(52116002)(316002)(6486002)(2616005)(25786009)(11346002)(66946007)(446003)(64756008)(6116002)(66556008)(2201001)(10290500003)(2501003)(5660300002)(36756003)(7736002)(53936002)(54906003)(6506007)(110136005)(386003)(4720700003)(305945005)(71190400001)(6392003)(6512007)(486006)(186003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1307;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uVwjhBBLPxSDcA1wnBZGBiyzjDT7RVy530VreZXCGlTF4QTgHl/29sbqqHlbN0W0Z1+pR1535IQ9VFI47zZSX0kMkwJralIvVEB9foDwDtvlzZ1UIxDFYSAupKueNitIJQcr5h1h4Uf5VBNn5govALDR8pNWUJeZDjpgCh7EM/b5+qzXskdtmmnwSu0tAsXpHn0st6cHISr2cBuJ7SHUZcplKEEdrHJ7uxpj5whDktG9EKv3hgKZj+H28+31hjNgCffGnwBwdyBwYXHpSyeUWXHPomUEYFHzuCYbhXEzLxcj+pLyyah/zUffgueSgMZ1StHytQKifooR9PMk+zlxEePAx54r9I+xETlFStYEgZTk+a1GNA47rf+4eabCjbaR6q3tY4JfK/UuU41oEfMick86PzQq/FW1wCGF6Ms+YEE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399048f8-76ba-40ef-8d7a-08d72cfc85a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 03:45:38.3111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tKHXX42brYj6042MorfJvkxUm+zsW7i70EsWjxcPVL9mDFJJb9lCKr7bvjvn0j+GHQFRrMa9iR07w6FKJOTVpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VF NIC may go down then come up during host servicing events. This
causes the VF NIC offloading feature settings to roll back to the
defaults. This patch can synchronize features from synthetic NIC to
the VF NIC during ndo_set_features (ethtool -K),
and netvsc_register_vf when VF comes back after host events.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Mark Bloch <markb@mellanox.com>
---
 drivers/net/hyperv/netvsc_drv.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 1f1192e..39dddcd 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1785,13 +1785,15 @@ static int netvsc_set_features(struct net_device *n=
dev,
 	netdev_features_t change =3D features ^ ndev->features;
 	struct net_device_context *ndevctx =3D netdev_priv(ndev);
 	struct netvsc_device *nvdev =3D rtnl_dereference(ndevctx->nvdev);
+	struct net_device *vf_netdev =3D rtnl_dereference(ndevctx->vf_netdev);
 	struct ndis_offload_params offloads;
+	int ret =3D 0;
=20
 	if (!nvdev || nvdev->destroy)
 		return -ENODEV;
=20
 	if (!(change & NETIF_F_LRO))
-		return 0;
+		goto syncvf;
=20
 	memset(&offloads, 0, sizeof(struct ndis_offload_params));
=20
@@ -1803,7 +1805,19 @@ static int netvsc_set_features(struct net_device *nd=
ev,
 		offloads.rsc_ip_v6 =3D NDIS_OFFLOAD_PARAMETERS_RSC_DISABLED;
 	}
=20
-	return rndis_filter_set_offload_params(ndev, nvdev, &offloads);
+	ret =3D rndis_filter_set_offload_params(ndev, nvdev, &offloads);
+
+	if (ret)
+		features ^=3D NETIF_F_LRO;
+
+syncvf:
+	if (!vf_netdev)
+		return ret;
+
+	vf_netdev->wanted_features =3D features;
+	netdev_update_features(vf_netdev);
+
+	return ret;
 }
=20
 static u32 netvsc_get_msglevel(struct net_device *ndev)
@@ -2181,6 +2195,10 @@ static int netvsc_register_vf(struct net_device *vf_=
netdev)
=20
 	dev_hold(vf_netdev);
 	rcu_assign_pointer(net_device_ctx->vf_netdev, vf_netdev);
+
+	vf_netdev->wanted_features =3D ndev->features;
+	netdev_update_features(vf_netdev);
+
 	return NOTIFY_OK;
 }
=20
--=20
1.8.3.1

