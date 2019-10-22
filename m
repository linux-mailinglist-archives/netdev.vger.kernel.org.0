Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF82E0443
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389128AbfJVMzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:55:18 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:11892
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388150AbfJVMzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 08:55:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOsFq5SAanE2gYZju8xjWhZnAEk5/mJ88g6duqf5S6OuJ8jDGjPg4PvCJqImvwcQDqKR8NW/tzr1p3d1Y7pKdcfmbbPsxdkOK4KhXY5zlq+HO30orPtyZK6qai+U1SF7qEBmvY+TXoUznRSJSy2W2PiJCTKpP8YHp0SYJHuw4Yi18Tq2yaWRZUq/c+IheOVBL4Uempr1xV894m5PQp1LgfoO6xasiOKowJ1i9onbKIAl0Oxxmtad5zNwQpGt5ggVivYONkJw9g2iduaIlywD11qjqMkCzIkUBi5JH913EiHzjZcWMpUe8AF5y1KrmfFZs0zp3EYssYPOL8xtLK6LNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGD0jjORZmQW5QO3lINfC969KZL0GxYHLC4Wb89bhg4=;
 b=eeleywsLg0zbKcPObivqk1KtPhT22ULpUfRE8TR/cGYBuNxgcx3mqJtKR/pmMGdIv4kNguXsKTZGuq9jBlIvlPYmFI8orF4zZJ3w+vg9hvtocqi/bjsGTXqmpUbBqKRnZbaqT/CvS1MAl0QIe7A/9jCjUy/VRnAVPuAHouxa+sgpohNLwfMcEVcr1lV4b6i136JPGdsWBc9RoJAX5973SUMssjlVimj35z9pTLz5pHmHCcKtKaqAaG+q6TlbRpnTaVnW11usbsANpwNmgdj9hI+0woYHFs+ibl7eemIzKMFa0ExjqAeOTT3OSUXe/HufxiNI+LtcGL7PpF6+/cCCJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGD0jjORZmQW5QO3lINfC969KZL0GxYHLC4Wb89bhg4=;
 b=q/eafR5IL4K3Pv34TKhVG07NLV37R1tWPwPFR29ZQD2kgSIierIcH3UXADAiSrIdvqjbOH8QN/dBmZfI39bFWccaU67yn/b9clW30NIgc3SDchmy9xKIsBs7w3XlTthLcYsBlyJvqashrGkKWUpgYOwzOMUys90WAzi/3qVrFxc=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB5053.eurprd04.prod.outlook.com (20.177.49.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 22 Oct 2019 12:55:14 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 12:55:14 +0000
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
Subject: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Topic: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Index: AQHViNfyo/IzAF7o50+e1U9qS9i5xQ==
Date:   Tue, 22 Oct 2019 12:55:13 +0000
Message-ID: <20191022125502.12495-2-laurentiu.tudor@nxp.com>
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
x-ms-office365-filtering-correlation-id: 9928d6bc-a698-4e44-9d6d-08d756ef147e
x-ms-traffictypediagnostic: VI1PR04MB5053:|VI1PR04MB5053:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5053AC4522889593BB572B20EC680@VI1PR04MB5053.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(189003)(66446008)(64756008)(5660300002)(66556008)(25786009)(66476007)(66946007)(36756003)(2501003)(14454004)(71190400001)(71200400001)(110136005)(54906003)(1076003)(478600001)(316002)(66066001)(7736002)(102836004)(6636002)(186003)(2906002)(6486002)(476003)(6512007)(3846002)(386003)(6436002)(50226002)(2201001)(26005)(81156014)(305945005)(81166006)(8936002)(86362001)(76176011)(6116002)(6506007)(99286004)(8676002)(52116002)(2616005)(44832011)(446003)(4326008)(486006)(256004)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5053;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pcX6PL195c4JEtRNn0fBodkaST32z0OBzmsxVp68yq5fG1ESB3pWw6xbcm7IdbCoLz7Iv3IutGpbGKsiUzSERwCYrM0enjo2cJdwIqpTkArXUn4lrLEg5L7U8KXzowxjYVzLicCg/E5K0bHRWeYCQnLQG/qp6MrkICWoR8XAXPOxfWLy7cc56S4mgzBQbn7d4Jx0BH4v8YaeEFXQYjFZGbl+IDsOeIjkS5rbKfRQXY3yJ6cSIcWKZx0jBckns0ml2+7s2U/D7DL2gqdYKONfhEF1R+I0Qs6YA54aQK5MVs59qjFIo1/GcxN+tRbXN2A1IAy9rZiOThPT8MJsDhKXI630FobhJaZ2e38dRVRghQL/Pe+K7pywYcpwfGhkrBE6tl3DFUcUh78N9j9W8ZU6hC+gbJhRwLxqgzu4o7/Zp1aCVcYJiWvbbzsHf1TJxZqv
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8947CA0246151F4A89CAF14C1FC89F95@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9928d6bc-a698-4e44-9d6d-08d756ef147e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 12:55:13.9687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSGnWyAqlZwrXC6KqQGfmWcR3SJP7pmfimgCUa7iLl7WaANqnn39+QMsDzhB3L6pP1dTNRuTLoskjAWOt+Dsrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5053
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Introduce a new dma map op called dma_addr_to_phys_addr() that converts
a dma address to the physical address backing it up and add wrapper for
it.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 include/linux/dma-mapping.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4a1c4fca475a..5965d159c9a9 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -132,6 +132,8 @@ struct dma_map_ops {
 	u64 (*get_required_mask)(struct device *dev);
 	size_t (*max_mapping_size)(struct device *dev);
 	unsigned long (*get_merge_boundary)(struct device *dev);
+	phys_addr_t (*dma_addr_to_phys_addr)(struct device *dev,
+					     dma_addr_t dma_handle);
 };
=20
 #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
@@ -442,6 +444,19 @@ static inline int dma_mapping_error(struct device *dev=
, dma_addr_t dma_addr)
 	return 0;
 }
=20
+static inline phys_addr_t dma_addr_to_phys_addr(struct device *dev,
+						dma_addr_t dma_handle)
+{
+	const struct dma_map_ops *ops =3D get_dma_ops(dev);
+
+	if (dma_is_direct(ops))
+		return (phys_addr_t)dma_handle;
+	else if (ops->dma_addr_to_phys_addr)
+		return ops->dma_addr_to_phys_addr(dev, dma_handle);
+
+	return 0;
+}
+
 void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_han=
dle,
 		gfp_t flag, unsigned long attrs);
 void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
@@ -578,6 +593,12 @@ static inline unsigned long dma_get_merge_boundary(str=
uct device *dev)
 {
 	return 0;
 }
+
+static inline phys_addr_t dma_addr_to_phys_addr(struct device *dev,
+						dma_addr_t dma_handle)
+{
+	return 0;
+}
 #endif /* CONFIG_HAS_DMA */
=20
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *pt=
r,
--=20
2.17.1

