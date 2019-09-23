Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AFABB3FA
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439512AbfIWMkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:40:11 -0400
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:54791
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438917AbfIWMkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:40:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrlYGRfR47EQOds2azsw1bN2Y2s9beKPWv9ErLEWMFmdXuBjKlx2ttttrITJEFJTsXbapfqIRqy84sHoABuYIktS4Wfc54ReRkdaFLgqzgEqHYU2OYDFY3GctxaKSOXo4ZYjUxa0YbfocFcIKDNb5/ydDTr8tfg6YWRbk/k9ON6L6lizXgQS757G1TsH24pu7kfYiCTcYZYP5uMHZx1x4mJsS/uGkPXpkwQfmG3z2SKxH3H/NJjlO8Q5hNm/VHlHHpWA5d9xofmf9OXl92kfAedpyh3J2ZCaX4Qsjc0IxODfb2BPk/BsW8CSmCWLEkIL8XyirTC513aaKYmv6TG3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwFY7aM03UZGjQijS7KO7K+kQbsHkb8840t5aJZB2/4=;
 b=iQBIwjGtUT54aU9ABT0aPJ7bu6Mm+/QgjNN8P6NnZOp/6w0kV8Fm2Exixn/QQtvtcg6autYWjjcACpZmW4Exgkwccgi6ya7AOY5u5QObOMq9OOm78pPAUynt0KvpPzN5U3TJ93I2Oa2UzmVGcqc1hch+1QmP8zHt0C+SqwBmp3GlMvYzvniZkuoRgx/usdK9UYpOuasdz/AzpwJBV+RaiELO4ppBwijM7ThAUsaH+rZ8a487R52WrLckrCsrxZEThdEMkMqvC+R4OIo0liShobSCUHmYux3nScyrG+pzCmtHcw1PPtgy6FMzDJiFpdFx5lrIOa/ZMaWXfErB5bLHuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwFY7aM03UZGjQijS7KO7K+kQbsHkb8840t5aJZB2/4=;
 b=UMEHBGx/qILBqy/536HeArXCPaqiEe+lqEuibilRmRDRwKPOY/l2AwY3f+o37rprjzHuaNxTPDpsb/UvBOhtciHC1gXO2zglCfK0yjz1WAKyXNF+aWJE5v8ORzbvN3wdQ2/mnyPKpLXCzGaxQ9a8IorngaThUksgtKgIlQjPtV0=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:06 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alaa Hleihel <alaa@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19-stable 2/7] net/mlx5e: don't set CHECKSUM_COMPLETE on
 SCTP packets
Thread-Topic: [PATCH 4.19-stable 2/7] net/mlx5e: don't set CHECKSUM_COMPLETE
 on SCTP packets
Thread-Index: AQHVcgwHgbqLwACgI0OaT+z2HWUUnA==
Date:   Mon, 23 Sep 2019 12:40:06 +0000
Message-ID: <20190923123917.16817-3-saeedm@mellanox.com>
References: <20190923123917.16817-1-saeedm@mellanox.com>
In-Reply-To: <20190923123917.16817-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [89.138.141.98]
x-clientproxiedby: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7896e0e5-1253-4ed4-fb78-08d7402329a2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2339F5972B6D45729460ED40BE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:346;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(14444005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pXbx91ZWZt75lGIL2wLzFxn814VuI++E+ZkcGNhIteJPPNlodV1UoQZYhSI42zyL6v6zLMXgjaPUL4olowQO5DTuRczXv3BxoI/pv4rr23mbrhorVkiZ8hKnp+m/rSK9okgZKPn2J0irzQkI0+xj7brIOP8QR++DUaUOGYd3aS5FaLOPJxani7Tz+pwg22KMHS+lmTn+W4uRCD0JqzfV+G3fXGRV3SOuNBuvAM9F2RhmiyLWMN84W0iszPMckCDg/LwmNczpUQB8BksO2YMwa7op+F/TxNArVIpJtBMFsNDiuDVXb/bSDBZJpsQ2blXl6X4VHwI6WQSGkl1okITBOSshsq0ohdf4MiEqZ+sQWByc//vlxQ8XvDo7xA+v3gRSVw+szzSuIgUX46tZ5zw7cF/8i0v8+IMDiU4r0nA33/M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7896e0e5-1253-4ed4-fb78-08d7402329a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:06.6612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1IPMvB9pvooAektyl4VElQazNJLee6U3TBcLs8L1ynwLCSRcCR9Nk/gf0JW3hOOUp00sLgjhL/a4U6plAVbxTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

[ Upstream commit fe1dc069990c1f290ef6b99adb46332c03258f38 ]

CHECKSUM_COMPLETE is not applicable to SCTP protocol.
Setting it for SCTP packets leads to CRC32c validation failure.

Fixes: bbceefce9adf ("net/mlx5e: Support RX CHECKSUM_COMPLETE")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 2a37f5f8a290..61eab0c55fca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -725,6 +725,14 @@ static u32 mlx5e_get_fcs(const struct sk_buff *skb)
 	return __get_unaligned_cpu32(fcs_bytes);
 }
=20
+static u8 get_ip_proto(struct sk_buff *skb, __be16 proto)
+{
+	void *ip_p =3D skb->data + sizeof(struct ethhdr);
+
+	return (proto =3D=3D htons(ETH_P_IP)) ? ((struct iphdr *)ip_p)->protocol =
:
+					    ((struct ipv6hdr *)ip_p)->nexthdr;
+}
+
 #define short_frame(size) ((size) <=3D ETH_ZLEN + ETH_FCS_LEN)
=20
 static inline void mlx5e_handle_csum(struct net_device *netdev,
@@ -758,6 +766,9 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 		goto csum_unnecessary;
=20
 	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
+		if (unlikely(get_ip_proto(skb, proto) =3D=3D IPPROTO_SCTP))
+			goto csum_unnecessary;
+
 		skb->ip_summed =3D CHECKSUM_COMPLETE;
 		skb->csum =3D csum_unfold((__force __sum16)cqe->check_sum);
 		if (network_depth > ETH_HLEN)
--=20
2.21.0

