Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CF9FB06A
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 13:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKMMZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 07:25:15 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:28093
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfKMMZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 07:25:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4Ls8jjvOafFIR1QoyZmt7TQ0PKsVLZXALKdWWiBlK5tdMnT8Z/h6E7y88chILRU41hEOAfaSPBabHTfjr2jV0/VVU/fe2MtFATrZ2sRK2x9Ptpv78ttkN6fZKaKHFoHELk73BH67N53W32IshaBwe0pZzRONztt5OUCH8d40SmwBIOJZspImsnm/UjXPGTx9frMzVOq4jdlaZr7lLN1jRhR9iyRIkJpKnrQHfErmuTLSSfmuW1QXCmPFZ/FyHu7m62mzPSXQ6u7WS2tjo31y8Evh8DM3TAD9AhCWy0nhBCX6Z4ZwlMZJTq84U6s+GCvRXKCNR7ewpH4CgTPHiiJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaagySirNNgd3CM8gwOIKutAoLS9kOCvrt+uOfm21rE=;
 b=fA0qIzZTfC/xh+BKdFSv2Uv4eEDfIPcUf79B/25d6DcYvVA9Mt18Fc0H+MVJa6vZBu+rY8Apj1KQaGO2Y66COoaaqqIogV6Vflqfw+7HhN6s7qrk7xOYPiilqS1ewD0qhfciL8z4GECTefXgPtGMHZ9yvCOAqx4tqj+7+UL8QPQqquBK4QnKFWcjnBbWlKNf6BPNYRPY/SfQFKu8iRTDTMAZJtG9HN4JLTt4at5M8+Rc3mpFwV2Lq78Q6p7UBeDfiqjazHj7AOeU3DsBYtc2OhjVnyMG2C1ccf70aeCG1IiZnESzwYChVz7mtCbeoS+YEAcT1mU8ROvZWMBjjJJVsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaagySirNNgd3CM8gwOIKutAoLS9kOCvrt+uOfm21rE=;
 b=WqhV48oI54V0fD5co6g9V+maXgeGSpo86MME7DGEiUTeFSjdimM7n8ZL/fqEzUUPE3AzTHVn/RQQ7/a1rxiSa9DrOSVNnG1wOXjGX9/bpYVFo/Fl3M/blQ7WcocHi2SkrZi5WtbQRotV99yZGLPSkQz9RfuxogMss4liRMA4y70=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB6142.eurprd04.prod.outlook.com (20.179.27.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 12:24:23 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b%7]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 12:24:23 +0000
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
Subject: [PATCH v3 3/4] swiotlb: make new {unmap,sync}_desc dma apis work with
 swiotlb
Thread-Topic: [PATCH v3 3/4] swiotlb: make new {unmap,sync}_desc dma apis work
 with swiotlb
Thread-Index: AQHVmh1ItS8w1JFcTUSfhlzcd9FmWA==
Date:   Wed, 13 Nov 2019 12:24:23 +0000
Message-ID: <20191113122407.1171-4-laurentiu.tudor@nxp.com>
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
x-ms-office365-filtering-correlation-id: 4bbab7d3-d441-4608-e950-08d768346a77
x-ms-traffictypediagnostic: VI1PR04MB6142:|VI1PR04MB6142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6142AC7FD085C941CEAA6984EC760@VI1PR04MB6142.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(189003)(199004)(6486002)(66066001)(486006)(446003)(110136005)(86362001)(6436002)(44832011)(5660300002)(54906003)(2906002)(305945005)(476003)(14454004)(2201001)(6512007)(186003)(3846002)(11346002)(316002)(6116002)(66946007)(2616005)(7736002)(256004)(66556008)(66446008)(99286004)(52116002)(76176011)(6636002)(36756003)(64756008)(25786009)(2501003)(386003)(71190400001)(6506007)(478600001)(1076003)(8936002)(71200400001)(26005)(50226002)(102836004)(81156014)(81166006)(4326008)(66476007)(8676002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6142;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BjqF+6Q9gMBNFc4h93uOgrLdgvfN54nl+qh1hJdt4vjv7o3ewPX7dQ8j239OvX16kF57747tIKmePTx564nW90WyvOb8fs4ZEgoDnzgHnkYlaa9eOkJHL138wTa82szP9UFDjXg1CNDxIF8L1YCuVbGnzQ3yC4YwVAc/IHlYVKoOJiGAJxGw2LuE+E9wxEf78thftNsCptls9Z107T44MVnTq4olfIxluydELnIoUjKdxElXQPh5gHxAb4Eo36BQFPeDZ1gkbZxj1buSxZnGG/lAcZ5ZQX3SvvBzjnVafCnvkgLLKi8b6Po9VF6higv/D33DwJLXS/nNwHddUEbWhQ0hdkRzAGelsuFC0mSBhtmn0TohDDzz1bTKuX+k54cPTlqRsswwzx2TvGITqdYL/qAdnTiTC/c3AJonA4/8niXNrf9rAMs7UKpLAAsXRpmE
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C5CD9B8D2FA7D4B959FF56039DFA957@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bbab7d3-d441-4608-e950-08d768346a77
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 12:24:23.2745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EDYvSD5MQh+w2k41hT7jBhUah8R4ROmUK+jckc6OpWMOpYuMVpqyDuCvHXnhPflcZNAlckoZNtFaSkmSTv9B/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Add a new swiotlb helper to retrieve the original physical
address given a swiotlb physical address and use it in the new
dma_unmap_single_attrs_desc(), dma_sync_single_for_cpu_desc() and
dma_unmap_page_attrs_desc() APIs to make them work with swiotlb.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 include/linux/swiotlb.h |  7 +++++++
 kernel/dma/mapping.c    | 43 ++++++++++++++++++++++++++++++++---------
 kernel/dma/swiotlb.c    |  8 ++++++++
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cde3dc18e21a..7a6883a71649 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -73,6 +73,8 @@ static inline bool is_swiotlb_buffer(phys_addr_t paddr)
 	return paddr >=3D io_tlb_start && paddr < io_tlb_end;
 }
=20
+phys_addr_t swiotlb_get_orig_phys(phys_addr_t tlb_addr);
+
 bool swiotlb_map(struct device *dev, phys_addr_t *phys, dma_addr_t *dma_ad=
dr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs);
 void __init swiotlb_exit(void);
@@ -85,6 +87,11 @@ static inline bool is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return false;
 }
+
+static inline phys_addr_t swiotlb_get_orig_phys(phys_addr_t tlb_addr)
+{
+	return PHYS_ADDR_MAX;
+}
 static inline bool swiotlb_map(struct device *dev, phys_addr_t *phys,
 		dma_addr_t *dma_addr, size_t size, enum dma_data_direction dir,
 		unsigned long attrs)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 2b6f245c9bb1..1a2d02727271 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -14,6 +14,7 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/swiotlb.h>
=20
 /*
  * Managed DMA API
@@ -352,10 +353,18 @@ dma_unmap_page_attrs_desc(struct device *dev, dma_add=
r_t addr, size_t size,
 	const struct dma_map_ops *ops =3D get_dma_ops(dev);
 	void *ptr =3D NULL;
=20
-	if (dma_is_direct(ops))
-		ptr =3D phys_to_virt(dma_to_phys(dev, addr));
-	else if (ops && ops->get_virt_addr)
+	if (dma_is_direct(ops)) {
+		phys_addr_t phys =3D dma_to_phys(dev, addr);
+
+		if (is_swiotlb_buffer(phys)) {
+			phys =3D swiotlb_get_orig_phys(phys);
+			ptr =3D phys =3D=3D PHYS_ADDR_MAX ? NULL : phys_to_virt(phys);
+		} else {
+			ptr =3D phys_to_virt(phys);
+		}
+	} else if (ops && ops->get_virt_addr) {
 		ptr =3D ops->get_virt_addr(dev, addr);
+	}
=20
 	dma_unmap_page_attrs(dev, addr, size, dir, attrs);
=20
@@ -370,10 +379,18 @@ void *dma_unmap_single_attrs_desc(struct device *dev,=
 dma_addr_t addr,
 	const struct dma_map_ops *ops =3D get_dma_ops(dev);
 	void *ptr =3D NULL;
=20
-	if (dma_is_direct(ops))
-		ptr =3D phys_to_virt(dma_to_phys(dev, addr));
-	else if (ops && ops->get_virt_addr)
+	if (dma_is_direct(ops)) {
+		phys_addr_t phys =3D dma_to_phys(dev, addr);
+
+		if (is_swiotlb_buffer(phys)) {
+			phys =3D swiotlb_get_orig_phys(phys);
+			ptr =3D phys =3D=3D PHYS_ADDR_MAX ? NULL : phys_to_virt(phys);
+		} else {
+			ptr =3D phys_to_virt(phys);
+		}
+	} else if (ops && ops->get_virt_addr) {
 		ptr =3D ops->get_virt_addr(dev, addr);
+	}
=20
 	dma_unmap_single_attrs(dev, addr, size, dir, attrs);
=20
@@ -387,10 +404,18 @@ void *dma_sync_single_for_cpu_desc(struct device *dev=
, dma_addr_t addr,
 	const struct dma_map_ops *ops =3D get_dma_ops(dev);
 	void *ptr =3D NULL;
=20
-	if (dma_is_direct(ops))
-		ptr =3D phys_to_virt(dma_to_phys(dev, addr));
-	else if (ops && ops->get_virt_addr)
+	if (dma_is_direct(ops)) {
+		phys_addr_t phys =3D dma_to_phys(dev, addr);
+
+		if (is_swiotlb_buffer(phys)) {
+			phys =3D swiotlb_get_orig_phys(phys);
+			ptr =3D phys =3D=3D PHYS_ADDR_MAX ? NULL : phys_to_virt(phys);
+		} else {
+			ptr =3D phys_to_virt(phys);
+		}
+	} else if (ops && ops->get_virt_addr) {
 		ptr =3D ops->get_virt_addr(dev, addr);
+	}
=20
 	dma_sync_single_for_cpu(dev, addr, size, dir);
=20
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 673a2cdb2656..9b241cc0535b 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -701,6 +701,14 @@ bool is_swiotlb_active(void)
 	return io_tlb_end !=3D 0;
 }
=20
+phys_addr_t swiotlb_get_orig_phys(phys_addr_t tlb_addr)
+{
+	int index =3D (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	phys_addr_t phys =3D io_tlb_orig_addr[index];
+
+	return phys =3D=3D INVALID_PHYS_ADDR ? PHYS_ADDR_MAX : phys;
+}
+
 #ifdef CONFIG_DEBUG_FS
=20
 static int __init swiotlb_create_debugfs(void)
--=20
2.17.1

