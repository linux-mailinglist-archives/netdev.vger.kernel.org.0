Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDAABBB409
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501917AbfIWMlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:41:06 -0400
Received: from mail-eopbgr40086.outbound.protection.outlook.com ([40.107.4.86]:43238
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436953AbfIWMlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:41:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqYwBsm6VntyYaZnp8VpJhkrNY62BinEMsUXOF1C3GxO1iUK0+2ubo1FauxdpGwf3TbfTj6eVu/aod+hoRbAANODdNs2BCXihGjC+z3ZU2ZRuFt/fZtHdVvJJQqET+2Nbl4GWUVMfPwVp3k3sE4aP9mzfrHhOhre0ddWMAhMGy/60FlIDvzoQju8YrSxW4ALb72ug+N3TWrs7IKcBOd69iRG0AD200WbNJfQ2EBzdBntrRWmFLeWfImifTiPTb2cUog3h1nLTNZp6+6I0uia/Vx4kz6N2m+6NX61+SMpL7TuSb9gaHUJ/dX5V3Lmn6mcsm0SOLgBPczk0I/sRMqhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzWSwT/arT2fTLmI0JPvwrLFLLKxYDNUVbH6pE5nLxs=;
 b=POyjZg6FZWY7SfaWhV6sI6FmQfOsVRHjY9cW0eCWKW3WN0RAaujlVD9FWuOFjc9xvBBcppBuvAFKiTgSjPw1fH8K2FWrJCe9USq64J7Q0Gw63xXKkmcXorLqV5X9QQaXyDuxlL63NnUJc4ZTDZz/SZMZSBGI+ROpIgQnDJKAe00HbuofRiUy7YGuCha1/B9S8LgMDs7nIQFe4RQrrTaPZY9dj6bL21YIyhZbGlYG6j5HPK4nFj3TuHgxZXVwMAcBf0k068gjAjzSTJ/lFKn2n0grzLPE4CQL9VzwzOgAxYWpnRgTXS8o5JGL/9DPhr5CgKZybqQ4DHNNXyKPpN9NRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzWSwT/arT2fTLmI0JPvwrLFLLKxYDNUVbH6pE5nLxs=;
 b=Gmi8b7ZObR5L2G7D62JXV2NEhO+SdSiffOMYwQEwHTTsZdI5q1m/bUBwA+5sIXZ/HDkaGxBXb35Xp6QRJLU2FNoZAYmSimBG08yjg3P8qxv5KJmPZ35LW0C8PRoFApw1q3JdifgMbz4zYC2HE/hPT49eiVxkJQoV66pbIzkHOV4=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2339.eurprd05.prod.outlook.com (10.165.45.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:40:30 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:40:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 4.19-stable 7/7] net/mlx5e: Rx, Check ip headers sanity
Thread-Topic: [PATCH 4.19-stable 7/7] net/mlx5e: Rx, Check ip headers sanity
Thread-Index: AQHVcgwVSXIYts5S+02jZBxzHfEZlw==
Date:   Mon, 23 Sep 2019 12:40:29 +0000
Message-ID: <20190923123917.16817-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 4eb3dd11-3ab2-4b49-689d-08d74023376e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2339;
x-ms-traffictypediagnostic: AM4PR0501MB2339:|AM4PR0501MB2339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2339AE6EC04C1B59802BF51CBE850@AM4PR0501MB2339.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(189003)(199004)(6436002)(11346002)(81156014)(81166006)(54906003)(71200400001)(2616005)(1076003)(476003)(6512007)(71190400001)(305945005)(66066001)(446003)(36756003)(486006)(316002)(478600001)(102836004)(7736002)(66946007)(52116002)(186003)(66476007)(8936002)(76176011)(6916009)(107886003)(14454004)(26005)(14444005)(50226002)(5660300002)(99286004)(256004)(64756008)(3846002)(6486002)(2906002)(66446008)(8676002)(86362001)(25786009)(6116002)(66556008)(4326008)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2339;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ic4n5Fymw8l5HDiKePQm13OkGdodGdxBprpaV8HObQF6OU4ZWS9br1tzjmur3X1n5kQcp1I5Z9UYZVMzLETZ8wkK94kDvQSWekjR6WmBYoYPtOlArNB7VUxEtEvi7Pa8/gH3IEvy3PYQkO5QQlQSF0stxlIJNtetmWpr789Gt/H+xi4lBHybCXy/3APwc3Vdnj4r2KSrFoLWqRg48Czz3mBQnAfHXplYCdpvripJcUzo1KnLq5KFh5Mho/bVq6lNLrgGSrPsClz9vVdQ6iwB6CqbgtMLAAeQpraNk6KpkAQw4mAqjbzyx9N4eevfMzcCRx1/GJ1hgVsUyQ49/Jsa/HjAdIssAnC+l6Qw0pqk5jwcfoOZuOsmWHAGXbMl3uloBLvX3ppR1OBbtBqlZ1rnAu1jlfYl8eXaHZrQ1vyYdIU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb3dd11-3ab2-4b49-689d-08d74023376e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:40:29.8948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hO94XlluWH/dpHl9VsX+bHYue7g0jP26WDWnFwaFV8H1bL0nbmHa+In6FUT8Aps2dvA1Z2v5Ky1bNSFfkOYWcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 0318a7b7fcad9765931146efa7ca3a034194737c ]

In the two places is_last_ethertype_ip is being called, the caller will
be looking inside the ip header, to be safe, add ip{4,6} header sanity
check. And return true only on valid ip headers, i.e: the whole header
is contained in the linear part of the skb.

Note: Such situation is very rare and hard to reproduce, since mlx5e
allocates a large enough headroom to contain the largest header one can
imagine.

Fixes: fe1dc069990c ("net/mlx5e: don't set CHECKSUM_COMPLETE on SCTP packet=
s")
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 318fee09f049..df49dc143c47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -694,7 +694,14 @@ static inline bool is_last_ethertype_ip(struct sk_buff=
 *skb, int *network_depth,
 {
 	*proto =3D ((struct ethhdr *)skb->data)->h_proto;
 	*proto =3D __vlan_get_protocol(skb, *proto, network_depth);
-	return (*proto =3D=3D htons(ETH_P_IP) || *proto =3D=3D htons(ETH_P_IPV6))=
;
+
+	if (*proto =3D=3D htons(ETH_P_IP))
+		return pskb_may_pull(skb, *network_depth + sizeof(struct iphdr));
+
+	if (*proto =3D=3D htons(ETH_P_IPV6))
+		return pskb_may_pull(skb, *network_depth + sizeof(struct ipv6hdr));
+
+	return false;
 }
=20
 static inline void mlx5e_enable_ecn(struct mlx5e_rq *rq, struct sk_buff *s=
kb)
--=20
2.21.0

