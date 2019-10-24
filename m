Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B27E329A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502022AbfJXMlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 08:41:51 -0400
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:37188
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729969AbfJXMlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 08:41:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBzGwoVgfw0qblpWmD7km1OeSgIfsj+Y6/e+NCLUwvScu/tjBYYt3asybe1f3OWC+bRZWq6WGrMp2v8DaqaMbqEH/FZRzGbZ/9IrbY/jOHlwPbddBNVKKXo9M88BZca2PaE4OXpBFUt2bCV1iUOZsldxv0Vwl7/eGXZXkWxKaKXUnMQxdk+wwwJGP24rF8s7v04bXY9lM0tgquasCU33Vf1ISpPeU5A8wmUPXLm6bioiydDsG+pqp5NlbSsKBfPnJSJz2a9KzwuVoaek3CyoF7VimybOqh7z9x4rn72fgYzUYsZSKouUCnTap5oHFR9Y3cbj4jMtEJ5uH916PENS5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgFGyCkyqFbrDnuWmZ97OtKvHcJYbnfowcT2OlPaPbc=;
 b=iOcTRMnP9jVknaTGTcUdVyY8YruigmHe3iL7xAF96Yw0qQXjQT0Zuo/5tRo0VP3cruJnK9S3fUC2f2IbAJH0QBPJtD7KyloA3uUpy2iYi6JKVIMMBeOyj1MdqKN66dO3PYfeskPazn3b4fSY9ZTdarq9j60ZDuyiH7n5yClkv3kU6nU2qcSPztVsvwqXyOjLW3lWo9WGil+bh+0su3v2vp4KlafbjMTwk1Jds2jL3f+n55dYH9xdX0r4N0E9E5PEDTpgdqcGqizx3h7QwBpnZjwGRNN+DB/1pOIF8nZAdv16HyzGxVKVSmRnyTR6onc2Ht0EhqxfQxNrQPOH3nxZcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgFGyCkyqFbrDnuWmZ97OtKvHcJYbnfowcT2OlPaPbc=;
 b=rv9CV1fYFIhfyYWfS42sUOo4Zdx7ODjcTWWPoRhRok1NqrUjE2seEMUlvLUiV2ImeTg60PdvZk7ZProPUx04RdUITP4PyhI5LxOHEtqYBR9aF/XHHLG3ImzILyGMZyKcoiTslFNQMtFSiQ5a6rIOyJopJexuvZKyQito3OwVrog=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4701.eurprd04.prod.outlook.com (20.177.48.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 12:41:44 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 12:41:43 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Leo Li <leoyang.li@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v2 2/3] iommu/dma: wire-up new dma map op .get_virt_addr
Thread-Topic: [PATCH v2 2/3] iommu/dma: wire-up new dma map op .get_virt_addr
Thread-Index: AQHVimhko79KRtEs6EStpPYaN5eAjw==
Date:   Thu, 24 Oct 2019 12:41:43 +0000
Message-ID: <20191024124130.16871-3-laurentiu.tudor@nxp.com>
References: <20191024124130.16871-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20191024124130.16871-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0278.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::26) To VI1PR04MB5134.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::16)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54059b2e-0e4c-4bd8-616e-08d7587f8649
x-ms-traffictypediagnostic: VI1PR04MB4701:|VI1PR04MB4701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB47018D27899133BDFFB52A18EC6A0@VI1PR04MB4701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(199004)(189003)(66556008)(64756008)(66476007)(66946007)(66446008)(1076003)(8676002)(8936002)(81156014)(50226002)(2201001)(305945005)(66066001)(7736002)(2501003)(54906003)(99286004)(81166006)(86362001)(186003)(5660300002)(14454004)(76176011)(316002)(52116002)(6506007)(2616005)(256004)(26005)(102836004)(386003)(6512007)(71200400001)(71190400001)(446003)(11346002)(6486002)(6436002)(25786009)(486006)(110136005)(478600001)(44832011)(4326008)(476003)(2906002)(6636002)(6116002)(3846002)(36756003)(142923001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4701;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ld79sbmm9WZG7DtSj0PUKNfl8b9TP+M3QNGIyMPuGuslER1xXKoACE1pOF8gj5xzRsyjwIghLbXpb2wQ8IlUWDSMk0KUyWdYWBg4nQKd9Q46wOMsgkeyLbHQKbKTKqOpH5dXo2ORtiOS9aDfOhpH7/lFuYwe5vLebr6OCtbHci1Tf9rIAezBVYK+ByJWfKp7gVcJVvNhpDST2VucdZY/WE88KeeZTT5MnSNhEe2SMWGR5Nqk96hRopN6tfiliNlTHDfAEHDL3iy91zGcA0ZJf/HMmmHlHZn9igzayecxJsM6ikWum+v9kstjBD2aWjZqDqLSqMq/eSUqTRhoqc+jywOkBi5iLq51FqT6Eu5bvY7fXd8YhBPFTVONqY9N3UykWqsyAXLfdfqzh5KThgnjVOnoASD0tibnWeAW3Sv2+rE4esTbvCYvFOzyWSh97X4I
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B907ECAE4977574B85D045A2EE738DF0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54059b2e-0e4c-4bd8-616e-08d7587f8649
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 12:41:43.8488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mMYzoQSiUkhQClDHJc/rMqqNmxtmHaaVWpZWDLJ1uUAIUbQuka1qNfzcAc9zozpFlnJDNEsmclJ7f0Z0eT8Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4701
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Add an implementation of the newly introduced dma map op in the
generic DMA IOMMU generic glue layer and wire it up.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 drivers/iommu/dma-iommu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index f321279baf9e..15e76232d697 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1091,6 +1091,21 @@ static unsigned long iommu_dma_get_merge_boundary(st=
ruct device *dev)
 	return (1UL << __ffs(domain->pgsize_bitmap)) - 1;
 }
=20
+static void *iommu_dma_get_virt_addr(struct device *dev, dma_addr_t dma_ha=
ndle)
+{
+	struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
+
+	if (domain) {
+		phys_addr_t phys;
+
+		phys =3D iommu_iova_to_phys(domain, dma_handle);
+		if (phys)
+			return phys_to_virt(phys);
+	}
+
+	return NULL;
+}
+
 static const struct dma_map_ops iommu_dma_ops =3D {
 	.alloc			=3D iommu_dma_alloc,
 	.free			=3D iommu_dma_free,
@@ -1107,6 +1122,7 @@ static const struct dma_map_ops iommu_dma_ops =3D {
 	.map_resource		=3D iommu_dma_map_resource,
 	.unmap_resource		=3D iommu_dma_unmap_resource,
 	.get_merge_boundary	=3D iommu_dma_get_merge_boundary,
+	.get_virt_addr		=3D iommu_dma_get_virt_addr,
 };
=20
 /*
--=20
2.17.1

