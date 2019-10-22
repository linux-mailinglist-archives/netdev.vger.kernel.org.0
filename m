Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1643CE0447
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388814AbfJVMzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:55:23 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:59022
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388150AbfJVMzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 08:55:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFFst3xb2cRumq8mW093jRyLkHp1zP/vCBX9x/Xogkzi5P4UHryx7ZYn8DV5zoqKRbsZNwWwBSsCpZ3k5MHmOMi1urN8Pe2t8G0NAmrxLX+1PN2e/S6wt7z8zoAbVUFwETOJIL+lbmcnb/ow2Dd1L3MBSltktQxLsWJgrajgp5IH7/NWNnHRzC7w5POySC1+p+UqI5aEyRpWlMHS3A44eZP5HvFBtCCzzAxrbvCUhwf9/GjX3zDrSKOhNeW0wttCYX4YqUirZ9DDTm4QDIzWFzqA+AT4pJMiS6fOavsLGHH2G80cWNCqYLO8YHsZvpdFZuUKYfztY4Lvp1DS3Y4law==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viOZsT/ko0NUbQpxkY17xqGAZLfzy6WUH86M6aiWDRM=;
 b=FqxZcVRAQPSAw3zFJznJO2VNBZQ8VVYsm+MpowYTR8PlbZ0VxJ3tCCy7tjufns9xK0z8Xh8P86/YwLs1bsoh30m/GUSinLchM50RrEKSB8T5lq9+gD3UeJx7Yhl9+oNtBUUK7fljJXEBBu3RFwcj4/BJCqGkKHcfZu1lx8LzMBUTArUvkSLLAUpxpa791IYXioYsHURr1DtYYRtybOu/r1CM8FAy1HaL9dswB4EoX3rS/2Rowp67Cj64BjIvyNnBlFzAcX0XbjdZeOYoNIHblIDc/f4ikZY+gtZgq1VU0f5I9e8gtwAeQ0ZUG/Ag/dcagtlzDdMf8M824ob0yWtf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viOZsT/ko0NUbQpxkY17xqGAZLfzy6WUH86M6aiWDRM=;
 b=rUhYxRrAR1tIT3LxjLZeymPKxwSotuTVI6YkhjwKx0Uc9R/ewfqH4vK9vzRvsBobIHlvwiFJ9KW/yg/6lli+a8VleJ6KDG4R2qL9pII1rh2K67XXvLMsKcQWYkBgnSZ9U5L0VEM6JR4l+sGC3eq0PgPXHgdkvPMa9UKwi4xjERs=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4208.eurprd04.prod.outlook.com (52.133.14.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 12:55:16 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 12:55:16 +0000
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
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [RFC PATCH 2/3] iommu/dma: wire-up new dma op dma_addr_to_phys_addr()
Thread-Topic: [RFC PATCH 2/3] iommu/dma: wire-up new dma op
 dma_addr_to_phys_addr()
Thread-Index: AQHViNfz5abage57dEawKYHQ0us7sQ==
Date:   Tue, 22 Oct 2019 12:55:16 +0000
Message-ID: <20191022125502.12495-3-laurentiu.tudor@nxp.com>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0066.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::43) To VI1PR04MB5134.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::16)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d0e04da6-71fc-41ca-2b48-08d756ef15bf
x-ms-traffictypediagnostic: VI1PR04MB4208:|VI1PR04MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB42085BD84E1A796168959425EC680@VI1PR04MB4208.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(199004)(189003)(386003)(6506007)(102836004)(6486002)(76176011)(25786009)(54906003)(110136005)(26005)(186003)(44832011)(486006)(2616005)(476003)(4326008)(446003)(11346002)(316002)(66946007)(64756008)(66556008)(66476007)(6116002)(66446008)(3846002)(6636002)(2201001)(86362001)(7736002)(305945005)(52116002)(99286004)(8936002)(2501003)(2906002)(50226002)(81166006)(81156014)(6512007)(8676002)(36756003)(5660300002)(66066001)(71190400001)(71200400001)(478600001)(256004)(1076003)(6436002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4208;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZIpP49oW72my8L1mzwnrSXJ43qNS0D0T24/4boDa9hvrpkUsS10P7xJrRO/cfg69XOkB/hBhReJPuwlwvjAxJ6b7bhctdMMtVM4icZeUk4+hNAlBji7pddYsAZ6u8f51D/ZLQ4Kk1duoOX9KErEjLohaoNMWE5ZEMxX6evcJSwVo+oY1OfscJycuCGZVnlETHlfqYdQVEI84/CUs2HdRkNPimh9tFXK1OGkaDboc/H4DDYzbDD1Tc07cJHcTgR5z/jvwqwRsXxPbUFpUpTBef+rqLxfgoDel1HRm7cbfAPuBoAdtcNaUDfGGPd4d5cl1KjDdPjcOWyrexM2VaDwnRcYlFbPPcyIJ2GC95LWLE5snlCByJBcONCyMWI1jH0nDAXLI2cA8F/ra+B3hkRosc9RdnK8yr6Ne8PYI61kCSgj2r3wigM1Tm3pMj28OlJMs
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF246F413CD4AE4E824350A41D34E387@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e04da6-71fc-41ca-2b48-08d756ef15bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 12:55:16.1924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zBZLDSLu/LuCDXu65F0XTT/8XNk4yK2lDLdKUJKmv9TS65tb3OKAAtXYdecOUMm1M/Qsmm40HhYcrsW9yHuyBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4208
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
index f321279baf9e..0d2856793ecd 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1091,6 +1091,17 @@ static unsigned long iommu_dma_get_merge_boundary(st=
ruct device *dev)
 	return (1UL << __ffs(domain->pgsize_bitmap)) - 1;
 }
=20
+static phys_addr_t iommu_dma_dma_addr_to_phys_addr(struct device *dev,
+						   dma_addr_t dma_handle)
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
+	.dma_addr_to_phys_addr	=3D iommu_dma_dma_addr_to_phys_addr,
 };
=20
 /*
--=20
2.17.1

