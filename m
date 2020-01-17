Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D737E140D75
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 16:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgAQPJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 10:09:51 -0500
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:39654
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728512AbgAQPJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 10:09:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0KWDJhllG66vNd/xrcj0rvlPJAy1LuBc8mG/Po9o7rU6i3cYlmN4h50sEsDlEpS4HtP/XQqEiKKg3wlgF4VsAlGpeYunlwRm3kLbjnkqIKrDbfC1mYrzeC12EHqh/LnP4W/vbYg/W0VcSeL1dGO3jVGO/YiQWpRcxA/reQ12c65rL1l0K6zYWt2QyuXAUpZP+BTyp0sRHuXPYfmSRDB+rRKSf/uB03/OXs0r/xYSrSvxgj1sBsY8x5qB1Lj0aS98TZSsWOMhxefL6Waq+Dq9TYBBWIcXq296DpUaIqI4ds6U+dbYFShXW1G02KFDpuTkXvxl5VczRdnuj+zWoZRhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKCW7/2gmKBa+gZgtUWVLD+fRIzKDMW3pStptBWtcrw=;
 b=Qn5eimnhIgbV/oPe6pRv7ozo7FCFgY686uXmCpVPDTOSwL0se+B42WnBrjuWBYelEl236XlrZ5hcbc/VcRJoAHV5oyPPLhJcOKS+gHfAiV0AL3CuMK8ng7fRpoIG6VjIB3OITGkhd3k58vSxiADLaRBzAvdZoBfu1JbgLEOkiWaRGZANH5PXAQ8Qqy4uIkjazbvUY5ZqUl9XaJgc5fk8yLqucQVSp+IlGvXdzHH7UjtusHtBZh0/JXffhEhaXX9+bKuz/Z+HlfVWKFROcb9K9hPOA7AWKD/1fDN5G8chqWyryWm+qOGm8WMTdrEW3XF0GxME6VvrKDz7ti6c+bRxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKCW7/2gmKBa+gZgtUWVLD+fRIzKDMW3pStptBWtcrw=;
 b=NsMY7VTNq8qYF/FH5fQ+j6nXigSwQhFujXP3thUB7oHFfLGw6UdzQAVNznVBgl+/dGlEPdND5l2XPx6sbu97SSRr+/2dT35OtOoneeD2tgan+QU3xI7T4D2NZIsvd6NWDdVeI1lJ3MT5xugqE7J7gO2F4BVTjR64P2d81Lk2Ay4=
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (10.168.126.17) by
 HE1PR0501MB2828.eurprd05.prod.outlook.com (10.172.131.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.12; Fri, 17 Jan 2020 15:09:44 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::6131:363b:61b8:680a]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::6131:363b:61b8:680a%11]) with mapi id 15.20.2644.023; Fri, 17 Jan
 2020 15:09:44 +0000
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by FR2P281CA0025.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Fri, 17 Jan 2020 15:09:43 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net] net: Fix packet reordering caused by GRO and listified RX
 cooperation
Thread-Topic: [PATCH net] net: Fix packet reordering caused by GRO and
 listified RX cooperation
Thread-Index: AQHVzUgms2l8GwZu90ePYDOhN5a7nA==
Date:   Fri, 17 Jan 2020 15:09:44 +0000
Message-ID: <20200117150913.29302-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::12) To HE1PR0501MB2570.eurprd05.prod.outlook.com
 (2603:10a6:3:6c::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 09af187f-0a28-43ff-52a9-08d79b5f4901
x-ms-traffictypediagnostic: HE1PR0501MB2828:|HE1PR0501MB2828:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0501MB28280353EC57A743D1D1BE19D1310@HE1PR0501MB2828.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(86362001)(316002)(66946007)(5660300002)(71200400001)(1076003)(36756003)(64756008)(508600001)(54906003)(66476007)(52116002)(66556008)(66446008)(110136005)(6506007)(2616005)(186003)(81166006)(81156014)(8676002)(2906002)(956004)(16526019)(6512007)(6486002)(26005)(107886003)(8936002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2828;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VE7/hkC1qE3rrMvhi/lsuP4e63uzP5jmFk+N/opL5IrFWUzk/iQLh1fKEcOGiTU6QNXiyOY/I3wPbJgTGeDvoyWracXs9rnWkoLae/Bu+DSBu8XMs2sCIS3Q41qbNLY3uL7Jyb9hUWjSLnk+AzJTS0qOukRCZWL+c0HPjBuRR+CvGhDIhg8aMhVWUmGDU0XNov70d0rWS4DSqNRmnxoLq1iiz+dQYeGUY1sE+VS4BvX0/OIYD/AUynzBZvnkLpmgpW0cqttevkNiLI1egXVqYmyuTDJjTk35EheVZnMlbq6WH1LWmOR/MoDU/ZXrO57lp4UUZKCF5CNCuQM9qPptujK5ym4lN6Z4vTf91gTOyhLg8Tf/6yxqC4VN9L/54lXGajbsRM9UZbiX2xk3+sZS06QNJwf5x4XRNza/2x3LWHU7biMVHVdi7vG5XpEFXvv0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09af187f-0a28-43ff-52a9-08d79b5f4901
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 15:09:44.7435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XN9M6p9Zp31Cnlk2DsU+Sy8OU9h0qAWqHPTSa+G9e7lfxSUIqpEMYLUH3L0KZtZoEceD651B5mBz/PmMXXengg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2828
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
napi_gro_receive()") introduces batching of GRO_NORMAL packets in
napi_skb_finish. However, dev_gro_receive, that is called just before
napi_skb_finish, can also pass skbs to the networking stack: e.g., when
the GRO session is flushed, napi_gro_complete is called, which passes pp
directly to netif_receive_skb_internal, skipping napi->rx_list. It means
that the packet stored in pp will be handled by the stack earlier than
the packets that arrived before, but are still waiting in napi->rx_list.
It leads to TCP reorderings that can be observed in the TCPOFOQueue
counter in netstat.

This commit fixes the reordering issue by making napi_gro_complete also
use napi->rx_list, so that all packets going through GRO will keep their
order.

Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gr=
o_receive()")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Alexander Lobakin <alobakin@dlink.ru>
Cc: Edward Cree <ecree@solarflare.com>
---
Alexander and Edward, please verify the correctness of this patch. If
it's necessary to pass that SKB to the networking stack right away, I
can change this patch to flush napi->rx_list by calling gro_normal_list
first, instead of putting the SKB in the list.

 net/core/dev.c | 55 +++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0ad39c87b7fd..db7a105bbc77 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5491,9 +5491,29 @@ static void flush_all_backlogs(void)
 	put_online_cpus();
 }
=20
+/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
+static void gro_normal_list(struct napi_struct *napi)
+{
+	if (!napi->rx_count)
+		return;
+	netif_receive_skb_list_internal(&napi->rx_list);
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count =3D 0;
+}
+
+/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded=
,
+ * pass the whole batch up to the stack.
+ */
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+{
+	list_add_tail(&skb->list, &napi->rx_list);
+	if (++napi->rx_count >=3D gro_normal_batch)
+		gro_normal_list(napi);
+}
+
 INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
-static int napi_gro_complete(struct sk_buff *skb)
+static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb=
)
 {
 	struct packet_offload *ptype;
 	__be16 type =3D skb->protocol;
@@ -5526,7 +5546,8 @@ static int napi_gro_complete(struct sk_buff *skb)
 	}
=20
 out:
-	return netif_receive_skb_internal(skb);
+	gro_normal_one(napi, skb);
+	return NET_RX_SUCCESS;
 }
=20
 static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
@@ -5539,7 +5560,7 @@ static void __napi_gro_flush_chain(struct napi_struct=
 *napi, u32 index,
 		if (flush_old && NAPI_GRO_CB(skb)->age =3D=3D jiffies)
 			return;
 		skb_list_del_init(skb);
-		napi_gro_complete(skb);
+		napi_gro_complete(napi, skb);
 		napi->gro_hash[index].count--;
 	}
=20
@@ -5641,7 +5662,7 @@ static void gro_pull_from_frag0(struct sk_buff *skb, =
int grow)
 	}
 }
=20
-static void gro_flush_oldest(struct list_head *head)
+static void gro_flush_oldest(struct napi_struct *napi, struct list_head *h=
ead)
 {
 	struct sk_buff *oldest;
=20
@@ -5657,7 +5678,7 @@ static void gro_flush_oldest(struct list_head *head)
 	 * SKB to the chain.
 	 */
 	skb_list_del_init(oldest);
-	napi_gro_complete(oldest);
+	napi_gro_complete(napi, oldest);
 }
=20
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_hea=
d *,
@@ -5733,7 +5754,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
=20
 	if (pp) {
 		skb_list_del_init(pp);
-		napi_gro_complete(pp);
+		napi_gro_complete(napi, pp);
 		napi->gro_hash[hash].count--;
 	}
=20
@@ -5744,7 +5765,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 		goto normal;
=20
 	if (unlikely(napi->gro_hash[hash].count >=3D MAX_GRO_SKBS)) {
-		gro_flush_oldest(gro_head);
+		gro_flush_oldest(napi, gro_head);
 	} else {
 		napi->gro_hash[hash].count++;
 	}
@@ -5802,26 +5823,6 @@ struct packet_offload *gro_find_complete_by_type(__b=
e16 type)
 }
 EXPORT_SYMBOL(gro_find_complete_by_type);
=20
-/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
-static void gro_normal_list(struct napi_struct *napi)
-{
-	if (!napi->rx_count)
-		return;
-	netif_receive_skb_list_internal(&napi->rx_list);
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count =3D 0;
-}
-
-/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded=
,
- * pass the whole batch up to the stack.
- */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
-{
-	list_add_tail(&skb->list, &napi->rx_list);
-	if (++napi->rx_count >=3D gro_normal_batch)
-		gro_normal_list(napi);
-}
-
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
 	skb_dst_drop(skb);
--=20
2.20.1

