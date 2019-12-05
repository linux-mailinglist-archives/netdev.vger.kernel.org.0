Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44088114414
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfLEPvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 10:51:22 -0500
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:63710
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726257AbfLEPvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 10:51:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvVklZa1g7L9pN14mKagDlrRdp/Oz7kNZOETHlj4udBp5bcShyFu0FMJufcCc4AKi+41f4QI4n8ar0TXFv03mEMUSD2BVn6/nQu+5lMuslEIG/PGMPFNx5lbr55pjmMAaBrKBZhFi8qVI2lbjwX7lTAX5LrLhtXJAAOLkng9K2YoZrXDCllsOTyQIP7Ml5IU1TsCyCCz6JxOQc328F0ydiDzJlBlxqB18qLtl6rbbkpQWKh6pQ1gEf4pdjjwTR/uck2zxjGC1ugrnKAr0wbouKqNVGhM9j5l9/dNXs+Mmx2xH1M97WESfjx0wWEjQbfF31OWvQ8Aa85y987fcaEH5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4err6LsxWP36fJt+zmA22ZiyXPzySRemu9AS355mQhM=;
 b=RwE7aOMX/p1pu5KSB/cF0ce/DRdAiBaUA9hcLXrQcM6wonVfE6/rHjFLDagutiPJDETSt27CtWIxku6oGg9/w8RJ54kFM4fc6o9KhApO0g+U1vlgQiG6xjudxQz+IPu4cgyE/sT0h+zjFgO462ru/QYHxl0Gdebi+rc739mPd3xsUnFOHaIH2908/zocpRYlZ27TJgLDSurrIs4lYE4jmTQ17RiVh8n+6PFp+btWUvnFDiK5zQpY1MdccMhA/Xe+XUuz0cZ36pk3MTaHmxTL8CUZuD1uENPKgryTueFMPpQULmnyR4J8mWmBczrwt7yl5yIJkDtHsdFuubNIZNM0JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4err6LsxWP36fJt+zmA22ZiyXPzySRemu9AS355mQhM=;
 b=mTF777Td27pZ3GG6sn3lthsmaefH/uEZ1Xfg3o8g0Q3HiLK0a59CAY2zq15hlfwT0kDWAHHFsAAd3vyjHuj3O9ePzpmNASl1YW9CUSy8FOHR1YJ4/mC1gqwf1E8zJWNz3v3NQUf7T3PG9BQn4N4tCuA5th92ARP3H4BBxvd5cYc=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4851.eurprd05.prod.outlook.com (20.176.214.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Thu, 5 Dec 2019 15:51:17 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e%7]) with mapi id 15.20.2516.013; Thu, 5 Dec 2019
 15:51:17 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf 4/4] net/ixgbe: Fix concurrency issues between config flow
 and XSK
Thread-Topic: [PATCH bpf 4/4] net/ixgbe: Fix concurrency issues between config
 flow and XSK
Thread-Index: AQHVq4PUgLCY15zljUmnkB2blsgKSg==
Date:   Thu, 5 Dec 2019 15:51:17 +0000
Message-ID: <20191205155028.28854-5-maximmi@mellanox.com>
References: <20191205155028.28854-1-maximmi@mellanox.com>
In-Reply-To: <20191205155028.28854-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0044.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::21) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66ca26ff-ae0d-410b-60a2-08d7799af712
x-ms-traffictypediagnostic: AM0PR05MB4851:|AM0PR05MB4851:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4851FC25248A857171507730D15C0@AM0PR05MB4851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(189003)(199004)(6506007)(50226002)(6512007)(316002)(2906002)(81156014)(8936002)(102836004)(99286004)(8676002)(4326008)(76176011)(86362001)(305945005)(25786009)(64756008)(11346002)(2616005)(186003)(7416002)(54906003)(71190400001)(36756003)(478600001)(52116002)(14454004)(81166006)(5660300002)(14444005)(66476007)(71200400001)(66946007)(6486002)(66556008)(107886003)(1076003)(110136005)(66446008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4851;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: suYGecS2gr8nRkyMD8eps9vQHACANuyA1whfwQrxb3xpFqfG1rZ1/JN3PQLgXyy7B2r4QjjzYx8S4BmwzJLIO/DJLjW2c4BvKpQj2fdmHr5sqGE9E57YvXsh4elEGMXInkEvxVsjkVz8MUyHU8fILQv7nEXwljG+FtavtM1VYuJkhO5zsH+AF7l+6Al6crMouCiN78RotNFkTshZeiwPDLLvo3ezXgv2th0p5NmhDRso8mgNhNtaaK7sFc3MZ+w0AbDuZLFNPWlZegT/6gUFwHVCCb0ZAZCPCDWMyLmToEMQQQecz69Fcw9hmvbyjhPRAWb+RpmZPLMBvgQ7zWl2HDLUgi2TKKchi7GaUDXf/5lTpdBFR7JB0Ds29pPx0bzU0YaVWOUOPPxAuPHNdHh71s1tiKG6gsESL22wnqrJbAsA+1b5+R71TyqOMY2aTYmW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ca26ff-ae0d-410b-60a2-08d7799af712
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 15:51:17.6863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 85HloPmJnow3WavmoZzt087p7UA+7pcsAx5zGTLjvkdXj4S8N/aF/j6brdYAUoyXDKNybYSGqNygnlWlHeT9TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use synchronize_rcu to wait until the XSK wakeup function finishes
before destroying the resources it uses:

1. ixgbe_down already calls synchronize_rcu after setting __IXGBE_DOWN.

2. After switching the XDP program, call synchronize_rcu to let
ixgbe_xsk_async_xmit exit before the XDP program is freed.

3. Changing the number of channels brings the interface down.

4. Disabling UMEM sets __IXGBE_TX_DISABLED before closing hardware
resources and resetting xsk_umem. Check that bit in ixgbe_xsk_async_xmit
to avoid using the XDP ring when it's already destroyed. synchronize_rcu
is called from ixgbe_txrx_ring_disable.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 +++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index 25c097cd8100..60503318c7e5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10273,8 +10273,12 @@ static int ixgbe_xdp_setup(struct net_device *dev,=
 struct bpf_prog *prog)
 			    adapter->xdp_prog);
 	}
=20
-	if (old_prog)
+	if (old_prog) {
+		/* Wait until ndo_xsk_async_xmit completes. */
+		synchronize_rcu();
+
 		bpf_prog_put(old_prog);
+	}
=20
 	/* Kick start the NAPI context if there is an AF_XDP socket open
 	 * on that queue id. This so that receiving will start.
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/eth=
ernet/intel/ixgbe/ixgbe_xsk.c
index d6feaacfbf89..b43be9f14105 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -709,10 +709,14 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid,=
 u32 flags)
 	if (qid >=3D adapter->num_xdp_queues)
 		return -ENXIO;
=20
-	if (!adapter->xdp_ring[qid]->xsk_umem)
+	ring =3D adapter->xdp_ring[qid];
+
+	if (test_bit(__IXGBE_TX_DISABLED, &ring->state))
+		return -ENETDOWN;
+
+	if (!ring->xsk_umem)
 		return -ENXIO;
=20
-	ring =3D adapter->xdp_ring[qid];
 	if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
 		u64 eics =3D BIT_ULL(ring->q_vector->v_idx);
=20
--=20
2.20.1

