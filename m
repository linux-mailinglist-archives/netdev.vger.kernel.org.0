Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9139986F7F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbfHIB7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:59:23 -0400
Received: from mail-eopbgr1310110.outbound.protection.outlook.com ([40.107.131.110]:46646
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729418AbfHIB7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 21:59:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJXAp/2AkU22Z4liuSLKHhrXX3QJ1yhiIKL7hr58Bzm6Y/5HCU2i1rzYJML8XjV0mNZ6z2wl2aojshUZ4N2KlYTrVDHO/352gkRN0EAinTvcNEm1lMb4SoMC2Pyg2OC9tK8NCpD7SWp+TcWTEjvL2/EsCm9djzB7ocwORmNN8EfsV8GN30MXHIx/0nbPHtJxDigVp/+36zlI8aG+jIN/4AsvYZpRvTvYesAyTlZp1/TKdnC0nbENsM/LDonqJeiLR/aIV4pIrVpcyfS/qnIIpgdIiWvoyYUzTx/PmDxfi5aPTwrw/59mT1iOsx/4ZmNGY2YGoRn8C5QWKpDZ+qykfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wOZSCg2VTqZ4zEfjjKVdyprhmpUtHEynjwd3l05h1E=;
 b=gCzXbm1sohYN7PfpbfMwDAO2EV95AouhcC2pB389rH08IMMh4N+h4483Ub2EtSdYuaZvObBMPEZ0xumDCBxxvi2/8ib5vRlFQOnuds3qUDjv5uiwTqOGU1/Gk0N1I7QU8VzCFie3LRqXeMXs0TX6UzHAjWIk28e+ZzIWJgvCNbWYkXQ6cLX1vDgcweqKoxtUlXAE0qFOsoemAxKy6FozyV3TBJDTo0SMYDD7/43u7LvQxPef/YhZ5QPmNmmkew1ebxRrP6MfVK2hzEx2bZDc+S70Ncf6f+V057n+oxTS0yTu0FEWr61cWtFL8+mbYEogCCxuKzx34K/GQoL9bd1lUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wOZSCg2VTqZ4zEfjjKVdyprhmpUtHEynjwd3l05h1E=;
 b=UtoVo6lJgJ6pX83NFWkDgZSx3s3FFk0HVY51B2cUQIP9fDkTo12q8nFW9c7wCAejh7/R6oFKURfhTUIXLjxOK9dlxPUJtX8BhbXJux77IJuJ6IShDMKVMxMCkpcolrKA6XylWsA7itMqKsjn4C4tN5FbSTaHJ7FtL9gVqrm3TfQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0122.APCP153.PROD.OUTLOOK.COM (10.170.188.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.11; Fri, 9 Aug 2019 01:58:09 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Fri, 9 Aug 2019
 01:58:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
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
Subject: [PATCH net v2] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Topic: [PATCH net v2] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Index: AdVOVD9gLFcQf0/RTjuMeKNDKND6rA==
Date:   Fri, 9 Aug 2019 01:58:08 +0000
Message-ID: <PU1P153MB0169A6492DCBB490FE7FE52CBFD60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-09T01:58:05.7733632Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2a2d5270-0545-433c-a357-4b4931a48124;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:c9b5:49d6:29e2:b6ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3270e8e2-c20c-46c0-9ae1-08d71c6d071f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600158)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0122;
x-ms-traffictypediagnostic: PU1P153MB0122:|PU1P153MB0122:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB0122251C24A2985CA187F4FFBFD60@PU1P153MB0122.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(189003)(33656002)(2501003)(66946007)(76116006)(66446008)(64756008)(66556008)(66476007)(14444005)(6116002)(7416002)(256004)(81156014)(8676002)(10290500003)(8990500004)(4326008)(81166006)(53936002)(478600001)(71200400001)(71190400001)(25786009)(74316002)(14454004)(6436002)(22452003)(55016002)(10090500001)(305945005)(8936002)(9686003)(7736002)(1511001)(99286004)(46003)(52536014)(2906002)(5660300002)(476003)(86362001)(102836004)(486006)(6506007)(110136005)(54906003)(186003)(7696005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0122;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pm0yeMl6RMoSBIK16+r3kmk1hV/3QCuIRU1GZTYOMFS8PUiNgf7fIQN5TQIeALPVU+3IMyn9ktGuy1drpMwaQjD81DI5/bq5rRitxkwO/WiVvojV1fNERD0bIQ98YTqBx2qsX7Kx/cMGE4gk/5oSkUPaf7JLidYys9bRHJGmnBw9KXTpgwaRqAllrySa5yfqDJDv52LWPO8MwZ3hJtUY5YEQ5Jjp4bldQ9b3lZUrwp2M8fAYnpoCXYy57anE1xRUN0zFe+Vyz4LhpH7Zi8qttxlTlzk21hAUVtFmwFFOJToGJyQnwAfruRJlePYeGkTYtooPROuVSSKUdgBRlPsaJnCXekD+U2I2sLKs+mQkfzjLkhBspJ8qvSfrtC/xXYNNhrE2rfo0G9alE1fIU2+zBw4MLn+pga77AlO/VWtuBrw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3270e8e2-c20c-46c0-9ae1-08d71c6d071f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 01:58:08.8711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8WsU+9uo2DPihQr7H0jDf6hiHXGiiLQQDaR61J9+kQfjeanmqVK3XPkv3GiTk7bYNQEppJXWQDi1RHtINCGbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This fixes a warning of "suspicious rcu_dereference_check() usage"
when nload runs.

Fixes: 776e726bfb34 ("netvsc: fix RCU warning in get_stats")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2:
    Made the minimal required change.
	Added a Fixes tag.
	Removed Stephen H.'s Signed-off-by since this is somewhat different from t=
he=20
		v1 from him; if there is any bug in v2, it's all my fault. :-)

 drivers/net/hyperv/netvsc_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index f9209594624b..b6357a75712c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1240,12 +1240,15 @@ static void netvsc_get_stats64(struct net_device *n=
et,
 			       struct rtnl_link_stats64 *t)
 {
 	struct net_device_context *ndev_ctx =3D netdev_priv(net);
-	struct netvsc_device *nvdev =3D rcu_dereference_rtnl(ndev_ctx->nvdev);
+	struct netvsc_device *nvdev;
 	struct netvsc_vf_pcpu_stats vf_tot;
 	int i;
=20
+	rcu_read_lock();
+
+	nvdev =3D rcu_dereference(ndev_ctx->nvdev);
 	if (!nvdev)
-		return;
+		goto out;
=20
 	netdev_stats_to_stats64(t, &net->stats);
=20
@@ -1284,6 +1287,8 @@ static void netvsc_get_stats64(struct net_device *net=
,
 		t->rx_packets	+=3D packets;
 		t->multicast	+=3D multicast;
 	}
+out:
+	rcu_read_unlock();
 }
=20
 static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
--=20
2.19.1

