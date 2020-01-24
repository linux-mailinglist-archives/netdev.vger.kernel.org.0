Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756A7148F43
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404326AbgAXUVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:14 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404257AbgAXUVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jv2sh0G+7cbJ7JrrTIhj71KiTI8gXnJqDmObHb1+s3E++wM5DRI3YdD8WWXr39nTLucucV8ai13bTP2f/Ohb1SlasyfJinTIQW00O9Hg6EpzeIQxoigG8ozsiI21tr5Oewf96IzTtIuXVRSWkubZOLVpCWFY7lJO5r5uebp9xfFyDgthK4mKxt7NCNBiGcK+WDGrSnZ1OZeyB0jAnjW/jckQ/S4LsdFHS6UyzKmnbenvRnseXOfHrVpZmHdmacAyK6gb37pK3cDM1RNatnSxsSaP0EWySN8pwkIXucS1iRL2FbCXQYtr1zmPGpnm4DYVc4jUSjhqs2I4KOm6JCEzUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTQotmHLh2tmMum6ygzaWbDXvaHD7klhXr0cPcOIdWw=;
 b=dNTMycKsNF0LZoN3gUvH0FmTabpDI783Y02t9w/ff8LzA1Nb8/0Qgx9ddWSeDkoSHAAeHs/0oATokvbyBidaGE3YmMIpV/5R8Zpjm/xS//gpXKUs0W1aBhXQeqAn4EHqRjjY9ufNyQHMAjunSIxSqEUXePRHxHTOtsXn2QBbVFkUHTgDTaEFUIFujw0vgkt/1V1Q0KeOMK0ddWM8LqI5hOYhIcMne8f0WACp2yFPfKw8d291QCoAbDeeBldnibRpafsocAt822fPUhkgIg+FCW8cLpDMtZvq2S9VZStdaiajM/0rZfcRtQw/8tTzSLYQ7OjW64PugJnsSzvjQANiJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTQotmHLh2tmMum6ygzaWbDXvaHD7klhXr0cPcOIdWw=;
 b=LZ/NhxIWYWkqzo0/CvZi9SOKG3aNQm7z0P4hERogLNjsi9G9gC4D7zs13rTCAV04xS0N8ZstBuKGoTcX7CHzH/c944zPVrPcUx0gUSFmQRgJdPQDUmoALJstWsdjUzOeXfMzOilPa+UQM4M89GOcO868/KfmqIariyRd/z9weOw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:21:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:21:02 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:21:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/9] net/mlx5e: kTLS, Fix corner-case checks in TX resync flow
Thread-Topic: [net 7/9] net/mlx5e: kTLS, Fix corner-case checks in TX resync
 flow
Thread-Index: AQHV0vPM23smq4Mv4kGGfA5KWpfs/A==
Date:   Fri, 24 Jan 2020 20:21:02 +0000
Message-ID: <20200124202033.13421-8-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0958f57-f407-4cb9-b983-08d7a10aee8a
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5552B919017A4E401B14E310BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HJ8QwgQPc3xGzF3r0Pw48IUxtXF34y1GkDtzP0sVmxBiC2GJRi4a3UkY/NgunJ5+k30Dzhl1dYtE1S5p91JoBBDT98Sw7FMeI+t1pcyB4ZLO8KafyYyekHrY/aNlXyU6V0jmkPfMf3mSjvDN/sexstXLMWZ90L/G23grhqUl2jOzRGRID8lA/LZAa8CJBaHI080GLLbH57Sw51mCqKRNS8TcpeqGOGgBFTpxDXRAcSssSd8qMUfSe+SiTDW4IwjvPSP7PT7JRB2vW2124NlCyuX0jKRfekCwf6LsDHIUiWycnrnTs24mS6cXxs8IsXlWIx6DIb4sjAhfagFsCEztL+x8fyM4djE841xMjVkG0EqmejiWYLdNepTtJhvoNj7+k3T0KnCZVK5J5MG13JOIgb6BR57omzJNpuLnR4zEUEyqFegNhQMAtYGP5hFK0jVPJ77vYBXsVqMCurp13so9qhaBZfwaTI/AGqTYt4uySokQ+eyEVDL0TdoLBF3PsyBVe4qUmJYULhvuXYg3qpmyKqAnihK7eWHj9+mVPghAhMI=
x-ms-exchange-antispam-messagedata: M3gY4bglkEYzvYjmuYIZYMYeyaILHtf/Ki7vPK9ttKT80e0l+dc9p1ZPN061zXB6UC8QPjKZ3tbHZlEjwy34LO7FZcyudha2X36gagKgWmEL6UyJAK7B597z3HLI9ftz8w/EuxNgHB28EJuoqA4r5w==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0958f57-f407-4cb9-b983-08d7a10aee8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:21:02.2077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pXDR3CZ36F5E7Rh+gyDjN+4ORTPiXtn+6rpeU9I9cvPaQk6WmzmHu8M1ficD6csDWFmU5KS4d5D0tF6rFPDHtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

There are the following cases:

1. Packet ends before start marker: bypass offload.
2. Packet starts before start marker and ends after it: drop,
   not supported, breaks contract with kernel.
3. packet ends before tls record info starts: drop,
   this packet was already acknowledged and its record info
   was released.

Add the above as comment in code.

Mind possible wraparounds of the TCP seq, replace the simple comparison
with a call to the TCP before() method.

In addition, remove logic that handles negative sync_len values,
as it became impossible.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 33 +++++++++++--------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 778dab1af8fc..8dbb92176bd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -180,7 +180,7 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
=20
 struct tx_sync_info {
 	u64 rcd_sn;
-	s32 sync_len;
+	u32 sync_len;
 	int nr_frags;
 	skb_frag_t frags[MAX_SKB_FRAGS];
 };
@@ -193,13 +193,14 @@ enum mlx5e_ktls_sync_retval {
=20
 static enum mlx5e_ktls_sync_retval
 tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
-		 u32 tcp_seq, struct tx_sync_info *info)
+		 u32 tcp_seq, int datalen, struct tx_sync_info *info)
 {
 	struct tls_offload_context_tx *tx_ctx =3D priv_tx->tx_ctx;
 	enum mlx5e_ktls_sync_retval ret =3D MLX5E_KTLS_SYNC_DONE;
 	struct tls_record_info *record;
 	int remaining, i =3D 0;
 	unsigned long flags;
+	bool ends_before;
=20
 	spin_lock_irqsave(&tx_ctx->lock, flags);
 	record =3D tls_get_record(tx_ctx, tcp_seq, &info->rcd_sn);
@@ -209,9 +210,21 @@ tx_sync_info_get(struct mlx5e_ktls_offload_context_tx =
*priv_tx,
 		goto out;
 	}
=20
-	if (unlikely(tcp_seq < tls_record_start_seq(record))) {
-		ret =3D tls_record_is_start_marker(record) ?
-			MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAIL;
+	/* There are the following cases:
+	 * 1. packet ends before start marker: bypass offload.
+	 * 2. packet starts before start marker and ends after it: drop,
+	 *    not supported, breaks contract with kernel.
+	 * 3. packet ends before tls record info starts: drop,
+	 *    this packet was already acknowledged and its record info
+	 *    was released.
+	 */
+	ends_before =3D before(tcp_seq + datalen, tls_record_start_seq(record));
+
+	if (unlikely(tls_record_is_start_marker(record))) {
+		ret =3D ends_before ? MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAI=
L;
+		goto out;
+	} else if (ends_before) {
+		ret =3D MLX5E_KTLS_SYNC_FAIL;
 		goto out;
 	}
=20
@@ -337,7 +350,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	u8 num_wqebbs;
 	int i =3D 0;
=20
-	ret =3D tx_sync_info_get(priv_tx, seq, &info);
+	ret =3D tx_sync_info_get(priv_tx, seq, datalen, &info);
 	if (unlikely(ret !=3D MLX5E_KTLS_SYNC_DONE)) {
 		if (ret =3D=3D MLX5E_KTLS_SYNC_SKIP_NO_DATA) {
 			stats->tls_skip_no_sync_data++;
@@ -351,14 +364,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_con=
text_tx *priv_tx,
 		goto err_out;
 	}
=20
-	if (unlikely(info.sync_len < 0)) {
-		if (likely(datalen <=3D -info.sync_len))
-			return MLX5E_KTLS_SYNC_DONE;
-
-		stats->tls_drop_bypass_req++;
-		goto err_out;
-	}
-
 	stats->tls_ooo++;
=20
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
--=20
2.24.1

