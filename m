Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF6F1478EB
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgAXHXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:23:43 -0500
Received: from mail-eopbgr60129.outbound.protection.outlook.com ([40.107.6.129]:30452
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725817AbgAXHXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 02:23:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdJtuhdBH3yn86tbmo8ZPcFBaan6bRO//560lRCWuIDSRBpzx18aJlJFt9dXppBTpafqPSTLAK8P9GKryP+rsmFAUKQOvl6mXrjUH8+PmHBWBUdJxfCrHDiC0xSlldymVBnZDT4fUspkjry1XN6p/C+uh6V2wYvP5XIRdIF5qqeOAvVwrNUJJV0zL7rvoy477udSsewqjk9YyFoeuLpbNByIbOMYctDHOur8IDA64/xI9YFTvpUm1exTTn6Ys/1307y8jB2mkNJQNK2palNaE5af/ThSkkK4Y4iulpsXKAuYZl7L0KAEvYVi+g/cRJJrXJjV6DDypSz6hhGoaaW5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YJ5rxl7zuNkaJWf0hvC+fF9TLUgIYZMd+FvmL62CgE=;
 b=VeO80PKmp/XVIQf3r3JSGlwkbSOHHLXZ7+3PcLLgr9D6pq+TCv8iIW23/10uzOQKcziyDWp0ULtliMGEFIW0Hq5fWT9qpD5FUmqzPGUseEuNeUgjIzYYYi2a2Vp6TEEOiCEOTjo2D1ZHgGpb8mEQ4KrMj/1fIp/hSjA6y+z9St61nI8Ot9BDSgBLCKM1vr5Mq9RSYKN6ZY4V10eiumCVLRsONxYwJCuPonBra2MOlIysP6SGXjsDOdrLudQBUo9IDx3I7IMK+rmNFusSgmPAHeoKNLD7kSrOZ61SBbqqhTmwPkYwKS5LUnGKOD5XJGPZd3d76LCxfV8oPh8MIYpkGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YJ5rxl7zuNkaJWf0hvC+fF9TLUgIYZMd+FvmL62CgE=;
 b=Q6keHQUeqSW952lLbb3kfT1gAGslpIGdvzv1suwvzhlVazAb24p6l+3AZVtSjs6TjZ5A39npUrL+3I6K6bpQpUU4zEOgcbztVwEdVn9tYVR4cBaQ2aSi+7t20icbhj/TwZQHvhxmRHfYK0XpaPTcQ0V75zVT8e8U5z/gzwFYF9U=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB6644.eurprd05.prod.outlook.com (10.186.172.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 07:23:40 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 07:23:40 +0000
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM0PR0102CA0050.eurprd01.prod.exchangelabs.com (2603:10a6:208::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 07:23:39 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: [PATCH v3] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v3] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV0oczqcCRJjLzUkCRqylCBDsonQ==
Date:   Fri, 24 Jan 2020 07:23:39 +0000
Message-ID: <20200124072338.75163-1-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.1 (Apple Git-122.3)
x-clientproxiedby: AM0PR0102CA0050.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::27) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [78.43.2.70]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 834b5f16-6123-4a33-245b-08d7a09e55a5
x-ms-traffictypediagnostic: AM0PR05MB6644:|AM0PR05MB6644:
x-microsoft-antispam-prvs: <AM0PR05MB664479A94F1C6014E2C57AA1EF0E0@AM0PR05MB6644.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(39830400003)(346002)(366004)(136003)(189003)(199004)(508600001)(71200400001)(66946007)(66556008)(66476007)(66446008)(64756008)(316002)(6916009)(54906003)(86362001)(5660300002)(8676002)(2906002)(36756003)(81156014)(1076003)(81166006)(8936002)(107886003)(6486002)(4326008)(2616005)(956004)(16526019)(26005)(6512007)(44832011)(6506007)(52116002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB6644;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S4wiy292JGnOWjMfgE8NomnX8I2RXdjjOlf/D8a8TrP35GE9U6bB/hX8jYF0N+bxqjariDP7CpLAWFFSS9WHVc0tBJbnjc2qi6eF6JOWNTl10mHMmpNgsEsN5foy585XGhn1Gf5HTN17nMH2wVShCGd+EEa+BFeA+UZ3Pk0tQ7TLzlMA7HnpAYHTrmhTzSQQW3NwkjkfJ9JTnX7y7vQVPbX+7AO+v8Sf5R/LAIRuDE/daY3Qa0tP3irY0VVK3b5XVz7rtwLFgPugeOhoXiww2BiJisD6GUlgMK+BJ2Wec03TvXeIU+tqCtH+NQQocM0nYvEyBwg5ht+cN04a2ZWt5RqM7faKcomz8lEJWLLOJwHbmfNE+6mG5fMCzPBduCuyvhN1yb4XZed+lvr2FjqnSpzBEFF/GThMN7E81t6rG8joTiMboeWCo7Zz+Dzhm1qh
x-ms-exchange-antispam-messagedata: du1hdxvva2W3pRC5cBnKIgq9Zb/dWuoO+8tOioRHZvSNROF/hb4qPQnpsCT+NCIY4xO0EYWFzh1aUP6oqMFz//enJ7SVVgOVEQDKRkDxtgfK4d1I6+LzrYhbwkRoDPHErBM9XwVw11OlCT7YWMiweg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 834b5f16-6123-4a33-245b-08d7a09e55a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 07:23:39.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E2SExzDeikzt18CkowN5j0hzPqxRAmnPZP5gqBZYEFDQY9tCWq/Hcv93AtNnRTIBTXnIx5HZERY5D7gRGZVJxj92EMAAtUydeKgHJtx+808=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently XDP Support was added to the mvneta driver
for software buffer management only.
It is still possible to attach an XDP program if
hardware buffer management is used.
It is not doing anything at that point.

The patch disallows attaching XDP programs to mvneta
if hardware buffer management is used.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 71a872d46bc4..a2e9ba9b918f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	prefetch(data);
=20
 	xdp->data_hard_start =3D data;
-	xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
+	xdp->data =3D data + pp->rx_offset_correction;
 	xdp->data_end =3D xdp->data + data_len;
 	xdp_set_data_meta_invalid(xdp);
=20
@@ -4960,9 +4960,10 @@ static int mvneta_probe(struct platform_device *pdev=
)
 		 * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
 		 * platforms and 0B for 32-bit ones.
 		 */
-		pp->rx_offset_correction =3D max(0,
-					       NET_SKB_PAD -
-					       MVNETA_RX_PKT_OFFSET_CORRECTION);
+		if (pp->bm_priv)
+			pp->rx_offset_correction =3D max(0,
+						       NET_SKB_PAD -
+						       MVNETA_RX_PKT_OFFSET_CORRECTION);
 	}
 	of_node_put(bm_node);
=20
