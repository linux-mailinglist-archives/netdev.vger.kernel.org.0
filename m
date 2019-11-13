Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AB2FB068
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 13:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKMMZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 07:25:05 -0500
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:43648
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727089AbfKMMZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 07:25:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1OebdPVZPovdkXySKmAOqgundWJyXzhOcRm64Uk4h0hL3WO2rOJMgZbDsBjMTzTeq+S0CuUzlR+nf7uVvKC5n3UNomxEZ6puXV/wmuCkhc7GEd+mG/BIL8blC90NB2LNm4xC0G0d3HLTbVKMzT7UjcGhe6rjvomwV74wUtGiIh4H5VF16QWfo7LHZKgVp2QamoZX3MtB5CPcHARvWx2RaExGnVjZhUMLoGAjFV3XwQbBwdmBiFTXresiNsPyRiwO3369y+EdeRvylK9ik45LdsDFsxCsSmCCuuM89tD38XKZwq3dk3lAymtTsj0Nmqa6rj5o494KHr/tfeMBB0HjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYkqeuGjr9wYrGN5dDVfenme5Bs+Sb7EnpApwRwUb0M=;
 b=hzjYuoyXwRnskou/eBAYGhX/GzvwSCc3MJ3w/T7V1xqcbMnc+S38E7EyB1L7Zt/YXXR4IIQkyUHCINJk3vQ0C1QGRx7YhLb4liZtGZ44+joiTnM5cMyHCgyYumY/PR+Mu1U4+evVhn0Q+wT4c24yaKPe8YsKW63eX4eM9/8UMla4gPGooEyuKTlOLeOf7/469Gm88yQxspECQl+SCB7K/HUKsEq28yCoM5b7iep0OCqSEYMEsyv1dCVBVrXUF+Bytg+DxwEdBx4bmP0Qh1eSBe7A4/voGCZd9NiuY1Ip9H/1X8iBntyi18YvX0TZSgucxqptCHpFFqtUi9RyxRVUzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYkqeuGjr9wYrGN5dDVfenme5Bs+Sb7EnpApwRwUb0M=;
 b=f5dspnA+dCNlD4BBNJNP9exLSS0Ll9cs5N9ifWC2XILrShlhuH+y6lb8CjSxY++v6c7gFiIs/Sdrb+tAnQ3Gt5Ba4RXOKqTHnmPhGvqEcvvpVu/p/5Qz1bY0YhdbQQs2LXRFklefTe9YO/FKx/gAQi2YBTRwJleNpFYtTVhVgm0=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB6142.eurprd04.prod.outlook.com (20.179.27.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 12:24:19 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b%7]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 12:24:19 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v3 1/4] dma-mapping: introduce new dma unmap and sync api
 variants
Thread-Topic: [PATCH v3 1/4] dma-mapping: introduce new dma unmap and sync api
 variants
Thread-Index: AQHVmh1FVruaxGPRC0WPLuJ8uvQXog==
Date:   Wed, 13 Nov 2019 12:24:19 +0000
Message-ID: <20191113122407.1171-2-laurentiu.tudor@nxp.com>
References: <20191113122407.1171-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20191113122407.1171-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0008.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::21) To VI1PR04MB5134.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::16)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 877b6c57-c99c-4b33-81c6-08d768346813
x-ms-traffictypediagnostic: VI1PR04MB6142:|VI1PR04MB6142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB61420FC8086434DC4C7D6719EC760@VI1PR04MB6142.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(189003)(199004)(6486002)(66066001)(486006)(446003)(110136005)(86362001)(6436002)(44832011)(5660300002)(54906003)(2906002)(305945005)(476003)(14454004)(2201001)(6512007)(186003)(3846002)(11346002)(316002)(6116002)(66946007)(2616005)(7736002)(256004)(14444005)(66556008)(66446008)(99286004)(52116002)(76176011)(6636002)(36756003)(64756008)(25786009)(2501003)(386003)(71190400001)(6506007)(478600001)(1076003)(8936002)(71200400001)(26005)(50226002)(102836004)(81156014)(81166006)(4326008)(66476007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6142;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x845+H7+YZBFm/kN8BOCzSUG2qB62NISJ7zdWh8nIydsuVF96WZO1Mt8/OWpZdyVbCFygA3C0HLAwMckzSeMlYROUhNBezz0BW4kdn69kXs0IQXAJ4alhpXLhM/J7U39DMtKwPfaQ2aZn7TpdFyfCVB3MhW4tefl+nYReBEjTaCWA8/Nu0O3uiB3bYhfi5IqGHQLd5gZP9KyIErJvk0SGbIBL21P0jElEiTIueiqnCSuLhD0sxlnml403HZtLIFsM3IpL9XBMmdzCmccwjHU1n61AbUeVTLtacS+BxAFbizGZ5nVuS89AaMRVvEf6hHosfb6SBC1tqttEzzG94ekhB1XsPKrGLJhTvgEmvNURdsZ1TW4ToyCfGa8p6Ppy1rMK+0NUunP4/ME6wma0DMrtRo102RvjA2MPz18/hXLneeZsFa/1V9/IIzHFn3wogc8
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4EC7A97EFE68D442962C66A49DBE335E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 877b6c57-c99c-4b33-81c6-08d768346813
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 12:24:19.6020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b0EUCii+Tsvqr6r9dfqKv/eGpRzPl9dVaJ9E1l/kugH7iydcJq1i75JfEg9qFJJRvF7p2UxVx+MRFbdO5AfUaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Introduce a few new dma unmap and sync variants that, on top of the
original variants, return the virtual address corresponding to the
input dma address. Additionally, provide an api that can be used to
check at runtime if these variants are actually available.
In order to implement them, a new dma map op is added and used:
    void *get_virt_addr(dev, dma_handle);
It does the actual conversion of an input dma address to the output
virtual address.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 include/linux/dma-mapping.h | 45 +++++++++++++++++++++++++++++++
 kernel/dma/mapping.c        | 53 +++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4a1c4fca475a..0940bd75df8e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -132,6 +132,7 @@ struct dma_map_ops {
 	u64 (*get_required_mask)(struct device *dev);
 	size_t (*max_mapping_size)(struct device *dev);
 	unsigned long (*get_merge_boundary)(struct device *dev);
+	void *(*get_virt_addr)(struct device *dev, dma_addr_t dma_handle);
 };
=20
 #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
@@ -442,6 +443,13 @@ static inline int dma_mapping_error(struct device *dev=
, dma_addr_t dma_addr)
 	return 0;
 }
=20
+static inline bool dma_can_unmap_by_dma_addr(struct device *dev)
+{
+	const struct dma_map_ops *ops =3D get_dma_ops(dev);
+
+	return dma_is_direct(ops) || (ops && ops->get_virt_addr);
+}
+
 void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_han=
dle,
 		gfp_t flag, unsigned long attrs);
 void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
@@ -458,6 +466,14 @@ int dma_get_sgtable_attrs(struct device *dev, struct s=
g_table *sgt,
 int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
+void *dma_unmap_single_attrs_desc(struct device *dev, dma_addr_t addr,
+				  size_t size, enum dma_data_direction dir,
+				  unsigned long attrs);
+struct page *
+dma_unmap_page_attrs_desc(struct device *dev, dma_addr_t addr, size_t size=
,
+			  enum dma_data_direction dir, unsigned long attrs);
+void *dma_sync_single_for_cpu_desc(struct device *dev, dma_addr_t addr,
+				   size_t size, enum dma_data_direction dir);
 bool dma_can_mmap(struct device *dev);
 int dma_supported(struct device *dev, u64 mask);
 int dma_set_mask(struct device *dev, u64 mask);
@@ -534,6 +550,27 @@ static inline void dmam_free_coherent(struct device *d=
ev, size_t size,
 		void *vaddr, dma_addr_t dma_handle)
 {
 }
+
+static inline void *
+dma_unmap_single_attrs_desc(struct device *dev, dma_addr_t addr, size_t si=
ze,
+			    enum dma_data_direction dir, unsigned long attrs)
+{
+	return NULL;
+}
+
+static inline struct page *
+dma_unmap_page_attrs_desc(struct device *dev, dma_addr_t addr, size_t size=
,
+			  enum dma_data_direction dir, unsigned long attrs)
+{
+	return NULL;
+}
+
+static inline void *
+dma_sync_single_for_cpu_desc(struct device *dev, dma_addr_t addr, size_t s=
ize,
+			     enum dma_data_direction dir)
+{
+	return NULL;
+}
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t =
size,
 		enum dma_data_direction dir)
 {
@@ -578,6 +615,11 @@ static inline unsigned long dma_get_merge_boundary(str=
uct device *dev)
 {
 	return 0;
 }
+
+static inline bool dma_can_unmap_by_dma_addr(struct device *dev)
+{
+	return false;
+}
 #endif /* CONFIG_HAS_DMA */
=20
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *pt=
r,
@@ -610,10 +652,13 @@ static inline void dma_sync_single_range_for_device(s=
truct device *dev,
=20
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, 0)
 #define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, 0)
+#define dma_unmap_single_desc(d, a, s, r) \
+		dma_unmap_single_attrs_desc(d, a, s, r, 0)
 #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, 0)
 #define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, 0)
 #define dma_map_page(d, p, o, s, r) dma_map_page_attrs(d, p, o, s, r, 0)
 #define dma_unmap_page(d, a, s, r) dma_unmap_page_attrs(d, a, s, r, 0)
+#define dma_unmap_page_desc(d, a, s, r) dma_unmap_page_attrs_desc(d, a, s,=
 r, 0)
 #define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s=
, 0)
 #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, 0)
=20
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index d9334f31a5af..2b6f245c9bb1 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -345,6 +345,59 @@ void dma_free_attrs(struct device *dev, size_t size, v=
oid *cpu_addr,
 }
 EXPORT_SYMBOL(dma_free_attrs);
=20
+struct page *
+dma_unmap_page_attrs_desc(struct device *dev, dma_addr_t addr, size_t size=
,
+			  enum dma_data_direction dir, unsigned long attrs)
+{
+	const struct dma_map_ops *ops =3D get_dma_ops(dev);
+	void *ptr =3D NULL;
+
+	if (dma_is_direct(ops))
+		ptr =3D phys_to_virt(dma_to_phys(dev, addr));
+	else if (ops && ops->get_virt_addr)
+		ptr =3D ops->get_virt_addr(dev, addr);
+
+	dma_unmap_page_attrs(dev, addr, size, dir, attrs);
+
+	return ptr ? virt_to_page(ptr) : NULL;
+}
+EXPORT_SYMBOL_GPL(dma_unmap_page_attrs_desc);
+
+void *dma_unmap_single_attrs_desc(struct device *dev, dma_addr_t addr,
+				  size_t size, enum dma_data_direction dir,
+				  unsigned long attrs)
+{
+	const struct dma_map_ops *ops =3D get_dma_ops(dev);
+	void *ptr =3D NULL;
+
+	if (dma_is_direct(ops))
+		ptr =3D phys_to_virt(dma_to_phys(dev, addr));
+	else if (ops && ops->get_virt_addr)
+		ptr =3D ops->get_virt_addr(dev, addr);
+
+	dma_unmap_single_attrs(dev, addr, size, dir, attrs);
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(dma_unmap_single_attrs_desc);
+
+void *dma_sync_single_for_cpu_desc(struct device *dev, dma_addr_t addr,
+				   size_t size, enum dma_data_direction dir)
+{
+	const struct dma_map_ops *ops =3D get_dma_ops(dev);
+	void *ptr =3D NULL;
+
+	if (dma_is_direct(ops))
+		ptr =3D phys_to_virt(dma_to_phys(dev, addr));
+	else if (ops && ops->get_virt_addr)
+		ptr =3D ops->get_virt_addr(dev, addr);
+
+	dma_sync_single_for_cpu(dev, addr, size, dir);
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(dma_sync_single_for_cpu_desc);
+
 int dma_supported(struct device *dev, u64 mask)
 {
 	const struct dma_map_ops *ops =3D get_dma_ops(dev);
--=20
2.17.1

