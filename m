Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42267E2F98
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438710AbfJXKz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:55:57 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:58381
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393365AbfJXKzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 06:55:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlrQ4ep/SZ9yMk0E7+wBH0FMpfXckZryVTRpq2ven1pujd3jg3IPOEFjBA+eSJ+hm91KDE2+NdZ2yhRSc4XjlQYJR/3hrxYpfTXjVNiFtiG9VreI6fZRyfyUiCXMz+39JIdjBSIofwH1lchiQNWqstj+HorMkLb5sih1LRGrJmBkDO3+JGwRQs1EmIxcKhruSdbvuEXaLhTRc1DoNIV4HoXSKYP7a8THZjY2E69U/ssL8xiaCFHedP3QmDJ/7gdGI2baC7AFmxwAfOuaieBRyYDAyOuXwHB5lBbLjY0gXAv//xx8X5b1GoGPDCFHhZA8POLARzTgz2LKppVmEpOQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pq1ec1XvJwCWM1E7JXBUlPWyzNHgc3lN2eA5NeeX9ZQ=;
 b=ghFeEec73VnWwL8iJG81BgQGaPL3bQSwevHKKwROA65n1LvQCUXb/Zn7Ff2D1WegY93a9uJQ7mQ4efl/ttqI+fRVb/rJPfmK7dtoKESsVUCEbKBTdD3Z3dpKsY1BpmI9Y3VKdGHhET/TfQMXwYYmNJ2S/cFlHcpLv48EmrnBsliQIQHAZdm5usnNfyheDZxTtHGTx6SZOS3w0yewcEVb9yItF294xcEb5REPxEHIZ3xUSH2tnuywBuTuJL2L6tYw3F0dApWCkjQYfhSpFOi8xgLnQI1xR0bJYmnWbImoqt64vbAsawECjmiBN/MExDIi/35IoADt39COYBMSooDZng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pq1ec1XvJwCWM1E7JXBUlPWyzNHgc3lN2eA5NeeX9ZQ=;
 b=HVCFPgRBDMzv57aa7sWPHcXtiwqHorb+k7+JpQ7wdlO7y//8i6Vr20oflqlW3GlggmVHLkYDvisGQSMiVmlDE5wfokJeoC6tI0LSZx5vMnAQ6KSRPe1+tm2d5Eo8/K5NgEfxyeciVn01Rj5eFx9aADyrGyEhvwEYohqCQeJHEH8=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4190.eurprd04.prod.outlook.com (52.134.123.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Thu, 24 Oct 2019 10:55:49 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 10:55:49 +0000
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
Subject: [PATCH 2/3] iommu/dma: wire-up new dma map op .get_phys_addr
Thread-Topic: [PATCH 2/3] iommu/dma: wire-up new dma map op .get_phys_addr
Thread-Index: AQHVilmYluhQYIla606h5x3C4ecuMA==
Date:   Thu, 24 Oct 2019 10:55:49 +0000
Message-ID: <20191024105534.16102-3-laurentiu.tudor@nxp.com>
References: <20191024105534.16102-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20191024105534.16102-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::28) To VI1PR04MB5134.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::16)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 97b9c41b-717b-4cf3-3e43-08d75870baff
x-ms-traffictypediagnostic: VI1PR04MB4190:|VI1PR04MB4190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4190401B932C3FC32981D679EC6A0@VI1PR04MB4190.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(189003)(199004)(446003)(71190400001)(71200400001)(2906002)(476003)(8676002)(2201001)(36756003)(316002)(1076003)(11346002)(52116002)(81156014)(14454004)(2501003)(81166006)(478600001)(7736002)(2616005)(6436002)(6486002)(4326008)(66446008)(86362001)(54906003)(186003)(6636002)(66066001)(99286004)(6116002)(66946007)(66476007)(305945005)(66556008)(8936002)(50226002)(64756008)(3846002)(256004)(5660300002)(25786009)(486006)(6512007)(6506007)(110136005)(76176011)(44832011)(102836004)(386003)(26005)(142923001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4190;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F5BtaUOmF3tQEHdyED7WqI007wWz4jhQcAfUE3OfEIxAmkDqj4YDwo+diBtqwmrHGa9HR5hx2vTRtqJ30kPvKHDmFxZ61GF8vytK/seblXMbcNppxPUpixZAgCYB2JN8RVNbDeyy9buAIpa5uoDupQQGTOmGYryyBfELf6WZgof+oFEtkYxl6b/yn914rqihSzENX8T7RuQbdSy9Jr3RQCfS75+VmT810ngJKB9cbh1zA42s9bRzH9aksyAVG6HyuKIEo+lLp91uovQaWrSQeZZ6Cmo6wNydEdSUHbQ9fK0R82CIIQkGEElpJ6+M2Uneyao3CFEgh2HUDX6fPcDFBvmt7LJ/6MKTSg9a7xBnhRjlR6INxeql2PrC0ZYogXLsmQyGiX1kyT5c6y3YSjoP1l36yOQpYnGRQQuBUWwev1eqte670FQDqRuFbjJ0oqBA
Content-Type: text/plain; charset="us-ascii"
Content-ID: <617F4E376146EF4D97683683A9E7AE1B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b9c41b-717b-4cf3-3e43-08d75870baff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 10:55:49.5994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gmOBY+WdAXNhMzIO3XRrhLz19Iyupl/MuHUSAztzEEFfJ2W8mEJIrsei7X2I73kaSx+rM24oA6HXaDqCf8X/xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Add an implementation of the newly introduced dma map op in the
generic DMA IOMMU generic glue layer and wire it up.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 drivers/iommu/dma-iommu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index f321279baf9e..e4e2bde586e0 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1091,6 +1091,17 @@ static unsigned long iommu_dma_get_merge_boundary(st=
ruct device *dev)
 	return (1UL << __ffs(domain->pgsize_bitmap)) - 1;
 }
=20
+static phys_addr_t iommu_dma_get_phys_addr(struct device *dev,
+					   dma_addr_t dma_handle)
+{
+	struct iommu_domain *domain =3D iommu_get_domain_for_dev(dev);
+
+	if (domain)
+		return iommu_iova_to_phys(domain, dma_handle);
+
+	return 0;
+}
+
 static const struct dma_map_ops iommu_dma_ops =3D {
 	.alloc			=3D iommu_dma_alloc,
 	.free			=3D iommu_dma_free,
@@ -1107,6 +1118,7 @@ static const struct dma_map_ops iommu_dma_ops =3D {
 	.map_resource		=3D iommu_dma_map_resource,
 	.unmap_resource		=3D iommu_dma_unmap_resource,
 	.get_merge_boundary	=3D iommu_dma_get_merge_boundary,
+	.get_phys_addr		=3D iommu_dma_get_phys_addr,
 };
=20
 /*
--=20
2.17.1

