Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06F4E235B
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391376AbfJWTjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:39:03 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:11076
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389916AbfJWTjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:39:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDLjdRhpbt+aO6h0ufXF1FL3DkW85p1wd33OPqzOvkSyfbbVbG4EgIG21WFPMzXHbrNNyf60YIH5gGn90yu1AViTuCT8R35qon4S6AMkpueEwrE5ANDL44SW259GWNqgNwRJkc2zN/V/fISN32wBSeYha+vYilr2ESehrEfuzLU9jpHQyG6s6XcfVOaarR1tph82lkL6KZw+st5uiMDb7DhQC0B8v4YaXysm+wLPphkajxX7WrsdcG7AjVdjOEgdsRchwDO/PDIBO2Gykb0tq0hB8R9cD1BKyqZTI90ES/DVtPrCcfR4OSkgRDyDPaKdNxklvaNm1NEaBxJ3xSkX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOsis0VbI0Lo2iGczQSjNmCOfiJ//WLvHNfsZNfsg4U=;
 b=VYzkzA7HS7vpB6fgzBI08EUOmcBOKBJ+bAvb8Eg90X4teHKLf9NJcCxteOxU1At0N2XdSY8Vr4JxJdC+JsNZZg83MJgBf+FVaHBL9ROsQyJD2f/ueWcOOvpvNdu+j1KOLh3XZhJNQ33m2+A0gE0gzJRrtb/8mJhKf6leMNHuj3+1nI2RQz1GQ6aLcy3iA6rCwAmg+ewbFRb+nKAZCRHPu+gCoyx0ctcLDSBTG9vBG7LYqNx9lTvP8CtjoOOJab/MvZEKdlktZOdQjx2SOHl5V2SFBsRb9ZWMf+cHWr9Sz0Lgsgq2k8xZwGLoDWkvpG2j/fAmTkPKb6Imk/AtnT6QXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOsis0VbI0Lo2iGczQSjNmCOfiJ//WLvHNfsZNfsg4U=;
 b=gg5gH+rBgMy7x+XAt+dwXD6ldFUKlN7o4CoVuoe9/YHJiK9ZMOYMq4ksRjUz1Q/sEldt5XZvaVBqQAAEK4puON4Uiy9x0GtDTMYHMCqJvv/XVzRHowwIMrM8SaM5uU2nRTbE8reoc2SkXNj6DY/GAIurW964JOSZ5Po1tOAgh14=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5744.eurprd05.prod.outlook.com (20.178.121.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 19:36:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:36:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-nex V2 1/3] page_pool: Add API to update numa node
Thread-Topic: [PATCH net-nex V2 1/3] page_pool: Add API to update numa node
Thread-Index: AQHVidk8nrkMR820/02NfFPDcjf0Aw==
Date:   Wed, 23 Oct 2019 19:36:58 +0000
Message-ID: <20191023193632.26917-2-saeedm@mellanox.com>
References: <20191023193632.26917-1-saeedm@mellanox.com>
In-Reply-To: <20191023193632.26917-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e257a44a-c0ce-48fd-7619-08d757f05e6a
x-ms-traffictypediagnostic: VI1PR05MB5744:|VI1PR05MB5744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5744E66EB9D8B06CFA3D5C69BE6B0@VI1PR05MB5744.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(76176011)(11346002)(446003)(15650500001)(6506007)(66066001)(186003)(6116002)(25786009)(8676002)(3846002)(66446008)(14454004)(66476007)(36756003)(71190400001)(2616005)(71200400001)(478600001)(102836004)(107886003)(26005)(66556008)(99286004)(4326008)(52116002)(81156014)(8936002)(386003)(50226002)(6436002)(6486002)(81166006)(14444005)(1076003)(5660300002)(64756008)(6512007)(110136005)(486006)(256004)(2906002)(305945005)(7736002)(66946007)(54906003)(476003)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5744;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m1R+nO8r62VDEfSA0hbJgtXalJblLwiJZACT5r45LbnBDoYBbsG/hAqP3NdLFlwKlt5iSG4bPYneyoxjyCqiUa20irwWxugbmBDVBpTTufeXe8FPXYUEnOx+svOA8BqVLjelgWlbWNuWBJhg2VT9450Mhc/0TDGlOpvTBK+f3qzvdI+2+hgvp4dJXOMjJ+SeR1w4HBc3/F+mDml0q6/i/K0imP0B22h6fCRbM/MvsC1Qzedid/Aoae5TBt9GgR/ty5LS4R9O6J4d6qGfm5Hxt7Mp4V8MFMWGy7iQ+GHCFC4pRaI1eWucdWjJzDnBpC+oEPC6IFF58TAWtBtdMZgOxAiscKc29JEZnLZkn/lkF3B3XAiXwSyxUojLHy6lBzMEngeh51qXjEjAtYSbHCscNkI7EC0vypEa42R95tUmOZXyLVp5aQoTYJXrXwCnDIEe
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e257a44a-c0ce-48fd-7619-08d757f05e6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:36:58.5996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HODHZdK+ZjFUN3J6aGZ1WZAQtFhuZesAyoUVItQtC0qm3XRfTKdTrEigdpkeUWicnSDJMO5SEURMXo+Y2yQcGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5744
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
---
 include/net/page_pool.h          |  7 +++++++
 include/trace/events/page_pool.h | 22 ++++++++++++++++++++++
 net/core/page_pool.c             |  8 ++++++++
 3 files changed, 37 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..f46b78408e44 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -226,4 +226,11 @@ static inline bool page_pool_put(struct page_pool *poo=
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
index 47b5ee880aa9..b58b6a3a3e57 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -81,6 +81,28 @@ TRACE_EVENT(page_pool_state_hold,
 		  __entry->pool, __entry->page, __entry->hold)
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
index 5bc65587f1c4..953af6d414fb 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -397,3 +397,11 @@ bool __page_pool_request_shutdown(struct page_pool *po=
ol)
 	return __page_pool_safe_to_destroy(pool);
 }
 EXPORT_SYMBOL(__page_pool_request_shutdown);
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

