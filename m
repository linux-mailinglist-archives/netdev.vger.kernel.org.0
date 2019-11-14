Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3665FD0AD
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 23:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKNWCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 17:02:05 -0500
Received: from mail-eopbgr20079.outbound.protection.outlook.com ([40.107.2.79]:59195
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfKNWCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 17:02:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giU1Y9dL4qXppuLFqdPq2ORLVSWIwBt7iUR+cvL8O6EUzREXPy8S5wBavff6hZtGHL9Ns9cGOOWf3glK4Y01pFNnRCC4blr1zXtkThHRnCIwStbW4zjHXG6GJE0hbR/cjGiPwAcvyxC+6zENCpJBBV2V/NWGB8Gjs4QQm27mna9QlojdN1T/XTV+TWvzk6lEr6SPXG7kpfVn+wbZZUgfca2ryFhSQgk/SpZNw+5WW++XIaglSahiNt/drVpZleNx5/njj9YWX02RMfmAYIdk9CPyX7beqt/PESLl2giRZDlB3xd//hgTnM4vDFwA20Rx6oVs+qI01f3IpnhVW5NqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkTJvTTSmZcWzM/EXXGM9T1cRi3UuWAsbZR5eAQN+ak=;
 b=WdpVs1GZp/FO6vQ5gssUZuiGdlWDQPiLSRJP4IUq5wuCiy+tYn7kPvzDyvmqQUj1ldad1HMz3Lp2P32ANMjifJG9TIRSPLzNVGouxjAH7hVoQQGhQpPYIJ3b81e8i0t4t9lVHuUF4dpa5za+QXtmRDUKUWsPqDp1tC79opg7DAqVqafhi/NWDzRoJjegBoP7VJOFo5KOd6U/HJPe98URAGteQnSlvRfiUxeLwVVVCyH3289S0r/oWcJLyVR8zyqyokj2YMPIaquxSt0gGkyFsMD7UMjJgVg/nHZvZ5aNpmf9SUzvc57s4d5AfRX1VFe7TDON2gnLgF+7ut3bPiVqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkTJvTTSmZcWzM/EXXGM9T1cRi3UuWAsbZR5eAQN+ak=;
 b=he37sdc1vFlIzF1lbDM+l9bBtLQssEU4b92AkPZSInBKsK21P+VnVbf86asloGqc+m0Sa0mj/WMt+nH2dDAeel6M2MRbl8eyt+xmva3KqP3eVi+9RPkYsDtWpU3PL+LjbiOjUXjnjjsk9DgJPx8VIcG7tEktN9N7982lCIRtRN4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5790.eurprd05.prod.outlook.com (20.178.120.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 22:02:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 22:02:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/1] netfilter: nf_tables_offload: Fix dangling extack
 pointer
Thread-Topic: [net-next 1/1] netfilter: nf_tables_offload: Fix dangling extack
 pointer
Thread-Index: AQHVmzcjC8JEuq1jMkKDRHZKKzKSig==
Date:   Thu, 14 Nov 2019 22:02:00 +0000
Message-ID: <20191114220139.11138-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82afd357-bcf9-4856-0af3-08d7694e4635
x-ms-traffictypediagnostic: VI1PR05MB5790:|VI1PR05MB5790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5790925C21CD09301761C346BE710@VI1PR05MB5790.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(54906003)(478600001)(256004)(71190400001)(64756008)(50226002)(26005)(8936002)(66476007)(476003)(486006)(186003)(52116002)(81166006)(66556008)(102836004)(66946007)(8676002)(81156014)(36756003)(386003)(71200400001)(66446008)(1076003)(6506007)(5660300002)(66066001)(2906002)(6116002)(3846002)(14444005)(86362001)(6436002)(6486002)(110136005)(99286004)(316002)(2501003)(2616005)(14454004)(305945005)(7736002)(25786009)(107886003)(6512007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5790;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oZis1Qvx0S1vj87OLrcdUwsjojrMBQKra5ilcFjPPgdUPLK8X/Oy06nax2uoFdOP7AGDWKqyk45HqkWEYiswieMgPukRIsXst2irAST9jdebGNoEjSe5xWxezrg90xGCaxY2PlqP/QtdFxuprUnNX4iiV8GipfIBqn5owgjKtIiwd91u8WHe+4i0GeXzxzjxYmn3hTWnxX8gxh1oJs2/UfkB+93XP1GghKhh/aMKXniFwo9sJMTrADX7Kb6HZH5l432UPALjZZ5EFNl8mqrHUl+NL6nhvN5ciqHwgP83bbBpgS/O35WKV6hvXPrk0NV309TRAMidZVyCW0EPNC4k2RE9xUZeLMizHPL+6jw6ehY9pZd0St87iUr09X01bqUT78Chu4pCdJecfK106dLz36OtIt8tGoCxRBBpEZPGtn+1lLmBgX2LPkVWVWD7fp8A
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82afd357-bcf9-4856-0af3-08d7694e4635
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 22:02:00.5869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /KbL1GlLbfDIxAoiXJPSXcJWE9mpDD1BMYSWMDWVmerflMWTh0mDz0Dmh9FIRZWSyDwuNe9+m3cbCCwH6Ignjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5790
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_flow_cls_offload_setup() will setup cls_flow->common->extack to point
to a local extack object on its stack, this extack pointer is meant to
be used on nft_setup_cb_call() driver's callbacks, which is called after
nft_flow_cls_offload_setup() is terminated and thus will lead to a
dangling pointer.

Apparently no one is going to be actually using this extack pointer to
report issues to netlink, although drivers might still write to it.

Since this is never going to be read, we can make it static to avoid
crashing.

Alternatively we can:
1. move the extack object to the callers stack.
2. set cls_flow->common->extack =3D NULL.

I chose this approach since it has the least impact.

This was found by a code review, i didn't encounter any actual issue nor
i tried to reproduce.

Fixes: c5d275276ff4 ("netfilter: nf_tables_offload: add nft_flow_cls_offloa=
d_setup()")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_of=
fload.c
index cdea3010c7a0..6178b8ace3d3 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -161,7 +161,7 @@ static void nft_flow_cls_offload_setup(struct flow_cls_=
offload *cls_flow,
 				       const struct nft_flow_rule *flow,
 				       enum flow_cls_command command)
 {
-	struct netlink_ext_ack extack;
+	static struct netlink_ext_ack extack; /* not actually read into netlink *=
/
 	__be16 proto =3D ETH_P_ALL;
=20
 	memset(cls_flow, 0, sizeof(*cls_flow));
--=20
2.21.0

