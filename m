Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21310309D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfKTAPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:15:35 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:50450
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727324AbfKTAPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 19:15:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNbC3iD5b6R+IoZEcx1qKUoUVD+xxYIH3wyGy8+E84jJtza6Xi/gw8aYhYgC1EgDvXEG879wP8GEQ8ZLNT8yypXsyrK3WfiqT1aZiIPLGXMhKLa1ak3hNbfX28ROkb/6KdEiwdsNuRA1lt6zR9TX1EhZxYsBks+9IBk5+gSMteOrBIp5vC89amlDUldo1hbKZ/PQsMM8un+GxSMMwZEyllmzWT06MmKtPX3tBTFxRqPDbs93vwKQKDpP0cCf3V/qNKgalBt3KqiF9G9cuhsL85aqi7aKrMALIV/rVRnNq9uX2TcKsq1Ex9KZ9BEG2+AdJSrgUxJhFfLhIzcSraH/YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4F+VAqlmwgRU/4t8bBDw5GWw5F9LgxyM9JNQedna7U=;
 b=WDbG2OaDDAhGmZxzbok6aHQrLPezLnIJD91IELsAu3teWuy6Z//V6V8rYsaoR9QQxALwEeMeto7GcZUNnz1Xyq/GMRMm+23RTUGBnBU924MzOEiqr4Fq/MuAzbOjXLmdI+qfLmWQxikwuit1+MJPLf/FXWGirAITu8UNdebVLfAihvQZc306sThWo03uokKfU9NZq7ysiys7s9Abx6WYVYUhVj/SnTcKZq4JJQ85tbkEV5EwefoLfLDCrWel4psZFY/ZxEM6q0FhTZN9PM8GjrXrH58t0bBlD8elKUwBk1U/+LuenBtoTpKmMUZAgJP/5FNUivSOHSAF19xRijPa8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4F+VAqlmwgRU/4t8bBDw5GWw5F9LgxyM9JNQedna7U=;
 b=sqS7PZW2yjYKdpIJMRY1Iqo3gAc4Rg1QUqEULWQO2kT+fHs+cptCCetnIibFGVoHl3ek/KRLfvqX+bdQFRdrRdNwJnarzwGMnsZZ/vL+X/mFW6eHM71nizqfONKaPK2j83tAKVqGP/hlRr7/VR7gS6Uz2wJG2TLUxOuMW7NQcHk=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5378.eurprd05.prod.outlook.com (20.177.188.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 00:15:17 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4%6]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 00:15:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH net-next V3 1/3] page_pool: Add API to update numa node
Thread-Topic: [PATCH net-next V3 1/3] page_pool: Add API to update numa node
Thread-Index: AQHVnzeWi5SO0+3v3Ei79aDVcE1cmw==
Date:   Wed, 20 Nov 2019 00:15:17 +0000
Message-ID: <20191120001456.11170-2-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
In-Reply-To: <20191120001456.11170-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22cc4bf1-8739-4eeb-9f57-08d76d4eb8a7
x-ms-traffictypediagnostic: AM6PR05MB5378:|AM6PR05MB5378:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5378D292B28F3B1517A37A29BE4F0@AM6PR05MB5378.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(15650500001)(6116002)(3846002)(256004)(14444005)(66946007)(110136005)(446003)(305945005)(81156014)(6506007)(386003)(81166006)(36756003)(6512007)(2906002)(54906003)(14454004)(71190400001)(71200400001)(11346002)(316002)(7736002)(64756008)(66556008)(66476007)(66446008)(486006)(476003)(2616005)(102836004)(50226002)(99286004)(52116002)(186003)(5660300002)(6486002)(86362001)(478600001)(8936002)(76176011)(25786009)(6436002)(26005)(4326008)(1076003)(66066001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5378;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lrEMmBZQwyOnM4CQtzrCgDN6HBPx/uzCpx2TR1ObpiSQjJ9V/UkdU+pMVq5xyHbEkrYf7Zljxcu2ZPdZGKWjhveNYhQgOBa8YlyvuViWfbSu7xbvFmmnbr5n31SjqqJzBGDDA+UPXkigExFNbcU9Z2NT04TXU92DjEB142iLdu8mcyGxeuo70I/oAlht0+OFkPu1/IKf1dBluFjrE9wHwzOyt9oTk4Gk68O2HmNhpo3lHUABaojqD5GQrDDGjC5+BnMoah2/QRve/2JzmY1ci33Fpp3VurIS6CWAGWqf0IIOsSGlHgccpjGAe+M5NSOmVtX2PWhfaUtFviCQ9AH5eVaV1DcjqYPHKqmrjYMG9x+fhOtjrk9h4dlHxLfbYzmygyb4bZv7bhJXx7+RFiSj36msg0iRfrOsMy3W6yH1szMJChfq8inLRHSvUWRnKpp/
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cc4bf1-8739-4eeb-9f57-08d76d4eb8a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 00:15:17.3351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c9IXo8vxtKFbrBbSyyvOf5XtoH9lHzax5zEGTmN4AvDQTXtKnDJG1XFR4d+rZSFNNfTC9ovc6Nm/Dht6jsBE8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add page_pool_update_nid() to be called by page pool consumers when they
detect numa node changes.

It will update the page pool nid value to start allocating from the new
effective numa node.

This is to mitigate page pool allocating pages from a wrong numa node,
where the pool was originally allocated, and holding on to pages that
belong to a different numa node, which causes performance degradation.

For pages that are already being consumed and could be returned to the
pool by the consumer, in next patch we will add a check per page to avoid
recycling them back to the pool and return them to the page allocator.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 include/net/page_pool.h          |  7 +++++++
 include/trace/events/page_pool.h | 22 ++++++++++++++++++++++
 net/core/page_pool.c             |  8 ++++++++
 3 files changed, 37 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ace881c15dcb..e2e1b7b1e8ba 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -204,4 +204,11 @@ static inline bool page_pool_put(struct page_pool *poo=
l)
 	return refcount_dec_and_test(&pool->user_cnt);
 }
=20
+/* Caller must provide appropriate safe context, e.g. NAPI. */
+void page_pool_update_nid(struct page_pool *pool, int new_nid);
+static inline void page_pool_nid_changed(struct page_pool *pool, int new_n=
id)
+{
+	if (unlikely(pool->p.nid !=3D new_nid))
+		page_pool_update_nid(pool, new_nid);
+}
 #endif /* _NET_PAGE_POOL_H */
diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_p=
ool.h
index 2f2a10e8eb56..ad0aa7f31675 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -89,6 +89,28 @@ TRACE_EVENT(page_pool_state_hold,
 		  __entry->pool, __entry->page, __entry->pfn, __entry->hold)
 );
=20
+TRACE_EVENT(page_pool_update_nid,
+
+	TP_PROTO(const struct page_pool *pool, int new_nid),
+
+	TP_ARGS(pool, new_nid),
+
+	TP_STRUCT__entry(
+		__field(const struct page_pool *, pool)
+		__field(int,			  pool_nid)
+		__field(int,			  new_nid)
+	),
+
+	TP_fast_assign(
+		__entry->pool		=3D pool;
+		__entry->pool_nid	=3D pool->p.nid;
+		__entry->new_nid	=3D new_nid;
+	),
+
+	TP_printk("page_pool=3D%p pool_nid=3D%d new_nid=3D%d",
+		  __entry->pool, __entry->pool_nid, __entry->new_nid)
+);
+
 #endif /* _TRACE_PAGE_POOL_H */
=20
 /* This part must be outside protection */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e28db2ef8e12..9b704ea3f4b2 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -436,3 +436,11 @@ void page_pool_destroy(struct page_pool *pool)
 	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
 }
 EXPORT_SYMBOL(page_pool_destroy);
+
+/* Caller must provide appropriate safe context, e.g. NAPI. */
+void page_pool_update_nid(struct page_pool *pool, int new_nid)
+{
+	trace_page_pool_update_nid(pool, new_nid);
+	pool->p.nid =3D new_nid;
+}
+EXPORT_SYMBOL(page_pool_update_nid);
--=20
2.21.0

