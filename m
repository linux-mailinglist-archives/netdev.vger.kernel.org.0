Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CE314402D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgAUPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:09:48 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:63468
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727255AbgAUPJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 10:09:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RroqTRl+T84C6f4nAD2wH9O1DruQijXteqjP8uPUiTfxhtcN0op/0vXmQDejS1w453lySds4TcI5Wp1v9WlnFr4OPqyAjNLrqdHuLDRjZHj5NhpLdTp+7/jYNJn1oWy2WmO65b39p1cV+lgIsKZnLmY40KfyXIyZV7/1gx4EylXFwp79h3zFN0/aYwgFU6mDo2Zmel7BXBuNGTKTD/gdlZkaUaLirG4TRwptQ54XnQGSQyLKucP4uLy3LpZZmYA/iw6sHHJx2AaumhuyZHUyogW89Hj1dvAnDi6BnynWTiDZ9jpW0JYSQIRBgr0qLDCNEc7hy1C+rjCiFK6cE27vuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kD9fYG7WBANWkAcVX1kRx+B9/jLk/iBDrNQkvF/ZNgQ=;
 b=PL7F/Xv9rTalsaH0Bxtj0KAk5jJ1lV8dh3SHWrSN5m+MncdRg8ZOqmuQpaWjoa7EcOYtQxqwP4akWVWV6dwrGVhuuqbPxrQi+0w15c/QuSg1poZ4eO6r66TEJBcC+XJCH7Xmn8avTHo3GdmvXcnARzbbogaeMiPlEUcWknV/lGG3FjOGghmsqlMVdT6bz170QzICZ0JjP8qiCHpvGVKHwEQ2ZlbqlfbN6D5/XmMbA/VQ32D8lkREOggUPoZHteSTMe0eqMgrAuiLyPKIxICiOW0vHEPDaAoGI4ekuUqXyNhxqukwIk8S0vs58rLJtYKkGECS3ACtujFsgQV/9QHFsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kD9fYG7WBANWkAcVX1kRx+B9/jLk/iBDrNQkvF/ZNgQ=;
 b=c4/aZkDol9rC4yqFdti6be3kk5CaXAdLWRzF25XBMbcyBQ00ggY4P8lLxUL47g+yNAKdV7oh67IMK8xRUKIT98c/845ir5isqWfVzZQNgexkcxUoR7gO/R+s0Y5eytRaDfbd40LqKBWkJy44WsQZPlDRB8hFv2VY4PeThxzXlOs=
Received: from DB6PR0501MB2566.eurprd05.prod.outlook.com (10.168.73.138) by
 DB6PR0501MB2775.eurprd05.prod.outlook.com (10.172.226.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Tue, 21 Jan 2020 15:09:40 +0000
Received: from DB6PR0501MB2566.eurprd05.prod.outlook.com
 ([fe80::6069:622d:9337:2d01]) by DB6PR0501MB2566.eurprd05.prod.outlook.com
 ([fe80::6069:622d:9337:2d01%10]) with mapi id 15.20.2644.026; Tue, 21 Jan
 2020 15:09:40 +0000
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Tue, 21 Jan 2020 15:09:39 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net v2] net: Fix packet reordering caused by GRO and listified
 RX cooperation
Thread-Topic: [PATCH net v2] net: Fix packet reordering caused by GRO and
 listified RX cooperation
Thread-Index: AQHV0GzNGcLYgDu8uEmAjawQrOpYjA==
Date:   Tue, 21 Jan 2020 15:09:40 +0000
Message-ID: <20200121150917.6279-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::23) To DB6PR0501MB2566.eurprd05.prod.outlook.com
 (2603:10a6:4:5d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 159d5dce-dfd5-487d-24f9-08d79e83f037
x-ms-traffictypediagnostic: DB6PR0501MB2775:|DB6PR0501MB2775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB27759588C3DCF21FCC081661D10D0@DB6PR0501MB2775.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(107886003)(956004)(2616005)(4326008)(8936002)(316002)(478600001)(8676002)(71200400001)(2906002)(1076003)(36756003)(81166006)(6666004)(81156014)(5660300002)(66446008)(66556008)(66946007)(52116002)(66476007)(64756008)(6636002)(26005)(6512007)(186003)(110136005)(6506007)(54906003)(6486002)(86362001)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2775;H:DB6PR0501MB2566.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S7UMl+WDBPC3YkvSi002GGAu//HZdLIpnf9CczNduMOdr8V1Nq7opa2mBbAlWjr9FE9BSHxdX8x+0zETt/Wo4NHwM7wAGdePSdWG0vqsbhsZ4EytLUTzkT23LXLUUJYfbMJ0isY8QO/yXCSUemMT5z3wFN85B0b2aUSE0o8SGoOEuxL0g29i5AJnaSuguCvm3XB+cUasv2iNgvDz9QRl7rgUAPE6+GR6Hyu+304uPS99Dt5XttJaQzMgJxPmfX3SLg27S8fwNSzQT6yfG1wL5OvBwF0BHPtnWJjeFh/TAMAnZXBrL0xyxGj7QxcV7gJrvbs/kSd/cDnn8IBjtCuGH+csxv93fhNd2pP+07vU0pNzmATF4KLRFQ4/3BeETS6htKloedG0vIwoNxdeDlXPscnGmOACjik3AWMvmqWss0V3/fxAM13rfJeQskQiGrx+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 159d5dce-dfd5-487d-24f9-08d79e83f037
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 15:09:40.7103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZKsI85ntx3+cusb3ZQYW+B1tpHLB0Mm3YuIbLvWOXtul2nuAUVisCospiZkSUSIi2PgbunFRZTr4+onit3EzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2775
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
skbs") introduces batching of GRO_NORMAL packets in napi_frags_finish,
and commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
napi_gro_receive()") adds the same to napi_skb_finish. However,
dev_gro_receive (that is called just before napi_{frags,skb}_finish) can
also pass skbs to the networking stack: e.g., when the GRO session is
flushed, napi_gro_complete is called, which passes pp directly to
netif_receive_skb_internal, skipping napi->rx_list. It means that the
packet stored in pp will be handled by the stack earlier than the
packets that arrived before, but are still waiting in napi->rx_list. It
leads to TCP reorderings that can be observed in the TCPOFOQueue counter
in netstat.

This commit fixes the reordering issue by making napi_gro_complete also
use napi->rx_list, so that all packets going through GRO will keep their
order. In order to keep napi_gro_flush working properly, gro_normal_list
calls are moved after the flush to clear napi->rx_list.

iwlwifi calls napi_gro_flush directly and does the same thing that is
done by gro_normal_list, so the same change is applied there:
napi_gro_flush is moved to be before the flush of napi->rx_list.

A few other drivers also use napi_gro_flush (brocade/bna/bnad.c,
cortina/gemini.c, hisilicon/hns3/hns3_enet.c). The first two also use
napi_complete_done afterwards, which performs the gro_normal_list flush,
so they are fine. The latter calls napi_gro_receive right after
napi_gro_flush, so it can end up with non-empty napi->rx_list anyway.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Alexander Lobakin <alobakin@dlink.ru>
Cc: Edward Cree <ecree@solarflare.com>
---
v2 changes:

Flush napi->rx_list after napi_gro_flush, not before. Do it in iwlwifi
as well.

Please also pay attention that there is gro_flush_oldest that also calls
napi_gro_complete and DOESN'T do gro_normal_list to flush napi->rx_list.
I guess, it's not required in this flow, but if I'm wrong, please tell
me.

 drivers/net/wireless/intel/iwlwifi/pcie/rx.c |  4 +-
 net/core/dev.c                               | 64 ++++++++++----------
 2 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wir=
eless/intel/iwlwifi/pcie/rx.c
index 452da44a21e0..f0b8ff67a1bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1529,13 +1529,13 @@ static void iwl_pcie_rx_handle(struct iwl_trans *tr=
ans, int queue)
=20
 	napi =3D &rxq->napi;
 	if (napi->poll) {
+		napi_gro_flush(napi, false);
+
 		if (napi->rx_count) {
 			netif_receive_skb_list(&napi->rx_list);
 			INIT_LIST_HEAD(&napi->rx_list);
 			napi->rx_count =3D 0;
 		}
-
-		napi_gro_flush(napi, false);
 	}
=20
 	iwl_pcie_rxq_restock(trans, rxq);
diff --git a/net/core/dev.c b/net/core/dev.c
index e82e9b82dfd9..cca03914108a 100644
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
@@ -6200,8 +6201,6 @@ bool napi_complete_done(struct napi_struct *n, int wo=
rk_done)
 				 NAPIF_STATE_IN_BUSY_POLL)))
 		return false;
=20
-	gro_normal_list(n);
-
 	if (n->gro_bitmask) {
 		unsigned long timeout =3D 0;
=20
@@ -6217,6 +6216,9 @@ bool napi_complete_done(struct napi_struct *n, int wo=
rk_done)
 			hrtimer_start(&n->timer, ns_to_ktime(timeout),
 				      HRTIMER_MODE_REL_PINNED);
 	}
+
+	gro_normal_list(n);
+
 	if (unlikely(!list_empty(&n->poll_list))) {
 		/* If n->poll_list is not empty, we need to mask irqs */
 		local_irq_save(flags);
@@ -6548,8 +6550,6 @@ static int napi_poll(struct napi_struct *n, struct li=
st_head *repoll)
 		goto out_unlock;
 	}
=20
-	gro_normal_list(n);
-
 	if (n->gro_bitmask) {
 		/* flush too old packets
 		 * If HZ < 1000, flush all packets.
@@ -6557,6 +6557,8 @@ static int napi_poll(struct napi_struct *n, struct li=
st_head *repoll)
 		napi_gro_flush(n, HZ >=3D 1000);
 	}
=20
+	gro_normal_list(n);
+
 	/* Some drivers may have called napi_schedule
 	 * prior to exhausting their budget.
 	 */
--=20
2.20.1

