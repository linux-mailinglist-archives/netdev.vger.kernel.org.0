Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48A4DFCCE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387565AbfJVEo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:44:56 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:34154
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387541AbfJVEoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 00:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xu4wyK055FO+wszdI5veTGtAKo+5njRLABNWlvgORixFyUzjgPtP13uPZs0mQ5tHAv+z72XyUXUBIUsretcv+0wXyN4OVGBXpDAJggYKIVJSTgD9aKoHf/sIA/fVNKo3r0Gz2NLCSmwx6EFLhb9RvkowCbJGi/aoLplLjJDLhA+eQIarcjdB+UYb/iGYoGXQPbY+eC3yXX2raE7aXi5+LzMI5ed2owyyXSHwEzjTN8ekcxTetvs4NBp1msO+2Uo9+RxVFS0W06xuPeI7b9m9ReeyoL/fqeR4KLzdiBmEwMch1iJHKfdFXsqkmDvFGkSwPGIu1jO0gkSK+w65brtEoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsDqoda+voB8JNx3EvYGD1S75LJbvFQbQzhRVkSrQCI=;
 b=EagakwT/OWIch0oi4Ozxu8xdMmIyR3SKd9VdqcWCUR+3Ny8YAxmsz+Z+1bsTLiMv1c0rM6lCVRcgwBrFsEad1Gp4SHd6UEyRxRtBTbVnInIJ0nyScRdKl4xDgz2ifwrFSilF0wza/sf1H95I9R3lWuDb/Qsyvx+GJnspFybUA9jhGLBWnYVHzWXjyT5kptwBlNKetCWmmjT81Y2hqFgESv66wO4VuaEFmVGsbpozIZN4+NRkGEKgfKZg30TMEXeuyuZKY1VN31mcZFKODg+kUn1W1kjobwhKLZQETYXcZLrjTiNorosHNL7LsxYjoJLmdhkmNVK1mfgvAz9owUplLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsDqoda+voB8JNx3EvYGD1S75LJbvFQbQzhRVkSrQCI=;
 b=CuAJFvOmq5XDigPoSxXmdLp12Bz83nr5zCvCxHpfFoQgU3bWmzYV8cj5sInKjjoZfG1JCmrTZCNpFWPFXURBG0MQIbFZToF3EkMfCyaIBMq9b++I/Tscg/pHxeXh4PK5Vv9kLZdE250RzvR5YQEgjEFTd/9AVknBC/x5Ih00+jM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4272.eurprd05.prod.outlook.com (10.171.182.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 22 Oct 2019 04:44:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 04:44:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 1/4] page_pool: Add API to update numa node
Thread-Topic: [PATCH net-next 1/4] page_pool: Add API to update numa node
Thread-Index: AQHViJNe9VzEVb27bkyetqXTqDa5Ow==
Date:   Tue, 22 Oct 2019 04:44:19 +0000
Message-ID: <20191022044343.6901-2-saeedm@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
In-Reply-To: <20191022044343.6901-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 07fe77b4-5e8b-4765-4a12-08d756aa8077
x-ms-traffictypediagnostic: VI1PR05MB4272:|VI1PR05MB4272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB427297A38370541073D94624BE680@VI1PR05MB4272.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(4326008)(81166006)(36756003)(316002)(110136005)(25786009)(14444005)(81156014)(256004)(15650500001)(8676002)(305945005)(7736002)(14454004)(54906003)(8936002)(478600001)(2906002)(1076003)(71200400001)(71190400001)(66476007)(50226002)(52116002)(6116002)(11346002)(6436002)(76176011)(3846002)(446003)(386003)(26005)(102836004)(86362001)(6506007)(6486002)(6512007)(5660300002)(186003)(66446008)(66946007)(486006)(99286004)(476003)(64756008)(66066001)(107886003)(2616005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4272;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zJ5Wh4TxzevK04Scs8p7XSMSj2p/7JGHs68JGtHo4+j6OGlsBfOwwpWIvm+TdcFT2J0QmQOvos+4anKj3VfNLEZDeFQEA5HZZVzHPB9hJHasHcFtUdHDPh1vlXpdkKDM6/0qU/vJo4lbmHu1HAaMnWrmd4fC2sLToJZayyhYP9P5MpJeeNuiVLR3qoPE/vcLNZt6e8QPIT74HqOaKE0nxHSNLH7mcl/kYCGFYM97XbOw24HxFfcLFMHWDVzNVqHRYBjqctTwdoXzKWyWI9G0eYZEb+uSZ90xGheN7QBmxURqKaIVbNmrv3mLILXG1Grly1ih9Ml64C7hqMyzxahsSZfKffyJkiXqZIzZ39cYTxj9OqD+Q2LPZg/6IGMXURe0fH9kREmB5nME5A5EPryE3e6gQTl2UMr9PUGr1d1DdOqFIgbyrOKWcug6uTiKg8n
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fe77b4-5e8b-4765-4a12-08d756aa8077
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 04:44:19.8473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uytGYsQPRCNewo36nhRtzVJm5a0syb5MEDalzSwNivOqBSioMhfnCPIXrCoHOl93WskmyktZc8uo939KSBrfWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4272
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
index 47b5ee880aa9..2507c5ff19e6 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -81,6 +81,28 @@ TRACE_EVENT(page_pool_state_hold,
 		  __entry->pool, __entry->page, __entry->hold)
 );
=20
+TRACE_EVENT(page_pool_nid_update,
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
index 5bc65587f1c4..08ca9915c618 100644
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
+	trace_page_pool_nid_update(pool, new_nid);
+	pool->p.nid =3D new_nid;
+}
+EXPORT_SYMBOL(page_pool_update_nid);
--=20
2.21.0

