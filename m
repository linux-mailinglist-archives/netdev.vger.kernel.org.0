Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7EFBB3FC
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439538AbfIWMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:40:15 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51684
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438917AbfIWMkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:40:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUi7GfFZRYyRDDpF+m71mwXp1FXYKcAn29JmQxE03frVcFU+5ZpZsXel0PMKOt9GRozZ//SvdMIKbfgThGQyI5ewWAoLGCZ6nkfSd98RlKG7CGEN37ZISlO8dr2SNCwIR8yM8d05kPkFp1RMfetDnNhCzp0S6BDHHpyJ2T05IYTE1wzea6KrtlI6VWf/xAlJnci+FpaTNMqdIPIqudvVdii70ZDqrZLAi6mD5O0/XcdG2Kjagqn4VrL+BmbSTvmUh3WWXRQfXX9h0Mbs9Wk0cnYsLNj5SDbVdhS1CvHz0qz5CPrEVjFtZvexmX1nLMokMyoSDVJLitFWDAiA+Wh+0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LK6VpO8eLxx9dayreLPi1htyhVNOaDLaA5/Wtrr5iQ=;
 b=Es9nu9MhWLGkrDFKVf6YmBlL96V7aM2lS/mdo52VUmt6+GuHkhrG9otF437H3HettjZ3pd8cFySeOOk6jyC6CIIuK9ycd7dF0WxYjAJ7vfSRRD4dBxQvr1rEoG2Ao9qD7k2J3ykabEMdNXPYXcLALoitAgaZkmH530UeG+vaVaFIayWwHQNOdn+61xd6bVoPWBwOQeu4mWgs6Bdh1J3mNqTZaawVbhtOYWeHGCqGKGxrRMRxYJHUoyiH4eNROKNCiSk9rocld9VlwCzkEvoPV7pW3ASchSKl5OI+w/s0qMiP4fL51UBbOKwXnrYicRnJ3b3btsXjOLPi+DBwXTIfkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LK6VpO8eLxx9dayreLPi1htyhVNOaDLaA5/Wtrr5iQ=;
 b=Rh26NSJSSaUizqLBgR+h9rxw7L3rdgmR5StNmY3njl7uDET/L4gnoHtT8QrNdCiBL+a6o1ereLMgcoLbJ6WsN14Wi3eRAzReKtzlhCdQYJuF0+m6xjMK0U8sqU/8CFc1HulrwoMLY5kSQ48ZF/MQNY2Jnb6X406vRlkqawKO+fA=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:12 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alaa Hleihel <alaa@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 4.19-stable 3/7] mlx5: fix get_ip_proto()
Thread-Topic: [PATCH 4.19-stable 3/7] mlx5: fix get_ip_proto()
Thread-Index: AQHVcgwKxY5fsy135U+/NimuAaNNYA==
Date:   Mon, 23 Sep 2019 12:40:12 +0000
Message-ID: <20190923123917.16817-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0706f7da-e13d-4709-9a91-08d740232ccf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB23398592DB9802B543D7D35FBE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:390;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FOM+z5eoLpZ57KJAmSAujJ5tBjU0C0tyAAYy9l9D5v1zm5IhJ525HGIXZazNaC5cNneBzuDjisL4Us7c8RV2STeZfuUJroIFmCGJT3uAINzXdck+eO1cUHkkHrb0PysGwNe9uJT3qsCle5+kYOpwxwYtPKJHFiCnOqKm7JtKCUrSBWsXzWVoBTJPhSCIfNOk2uPsjbYWEJn8QIAcZ1/PK5yoMBK9BtuIOn0R5a4YDVuaquh1/RZXLXZVri9+TPps3bK14sXgSTeyB7U0yqwomQAXqAIpR5yUx72Bn7PrHWgbbPH8PrUtd86OdHZ5O4gqy3tGFrddU3cgLGuKeY0zC7mrQaRn/MhrappM9+5iOvtcy6ZUn3gVBVwcIDyScPnWks6vyoMQwZ+0AAFVU+tspNPiPiNILOtqv3bCDeqNrBY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0706f7da-e13d-4709-9a91-08d740232ccf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:12.0628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CWaUsYtGjjt6YxG+K8IQvhgR75p4DXuETLvMyhscdaCAj+Rj8juqzbq87L2xTy7FOo+34rIkfuVujILNBXj4hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit ef6fcd455278c2be3032a346cc66d9dd9866b787 ]

IP header is not necessarily located right after struct ethhdr,
there could be multiple 802.1Q headers in between, this is why
we call __vlan_get_protocol().

Fixes: fe1dc069990c ("net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packet=
s")
Cc: Alaa Hleihel <alaa@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 61eab0c55fca..8323534f075a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -725,9 +725,9 @@ static u32 mlx5e_get_fcs(const struct sk_buff *skb)
 	return __get_unaligned_cpu32(fcs_bytes);
 }
=20
-static u8 get_ip_proto(struct sk_buff *skb, __be16 proto)
+static u8 get_ip_proto(struct sk_buff *skb, int network_depth, __be16 prot=
o)
 {
-	void *ip_p =3D skb->data + sizeof(struct ethhdr);
+	void *ip_p =3D skb->data + network_depth;
=20
 	return (proto =3D=3D htons(ETH_P_IP)) ? ((struct iphdr *)ip_p)->protocol =
:
 					    ((struct ipv6hdr *)ip_p)->nexthdr;
@@ -766,7 +766,7 @@ static inline void mlx5e_handle_csum(struct net_device =
*netdev,
 		goto csum_unnecessary;
=20
 	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
-		if (unlikely(get_ip_proto(skb, proto) =3D=3D IPPROTO_SCTP))
+		if (unlikely(get_ip_proto(skb, network_depth, proto) =3D=3D IPPROTO_SCTP=
))
 			goto csum_unnecessary;
=20
 		skb->ip_summed =3D CHECKSUM_COMPLETE;
--=20
2.21.0

