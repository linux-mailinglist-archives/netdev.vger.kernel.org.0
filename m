Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D8CFB073
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 13:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfKMMZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 07:25:02 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:28093
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfKMMZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 07:25:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLiMeuPst/KQIukQ/zPTIUkAajNhWHw5txj35h0Wb97b9M21rKyNk5JLEACyJOzSsWIgTmMHv5mj5C7bH2CZG6aHchp5BaJQEXdiBZqI1PqoAhvn6o5K0AJARsK/CiLDlLzq1/r7vTPzS/pan7qLEE3CqCSpX5IJbyh4gFxgAAxh2m+OZH07UGWxmti9Wluf+5VIf6S7h/nnMQRrRNpb30zyvsqzmPtUsPRFV11btgCytvOppbo5C1hy0f36GO/wsyE8GGViBSiSTxogUeFs5dZY+xfwgOJI5BMx3pvGhC5pCVBs3TlpTgJ6dnJSlbGIB4/BBalw8jvM2FA7/YB5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DpofxCMyAgJCTZ1sUOB884BST8xJfXAYUtzzds67u8=;
 b=iffUgQnCgPR9XOUVeoCSIRMURgNhe7pLKqwHbVYfjK50HUw9s5EZE+A0I7wPSw7Kc+UGLN0n9wG2s02Ms751eWmGACUhYCy1tIMZAoeNohiPuZkc82IU8K4fBgB2IT+/CDoIxYkPJ7u3rEf4VkID9487R5qoOXLv6tocw23Cj/cQBjfrHFcR1o1OTLLvkmcV/GYTirjbgKeCZr4qqeY/Dq4wnJ/pkK/kMWnTVp7r/i/pyfV0E94IPBaie3BuEovLz09SrdYFaO4B+uQCko+LilBfQHAXqy0yaBao3ncnXAE78+4hbKnaNdZGdPVU/P7jqegheSe0w9TgZOqZbRJ5JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DpofxCMyAgJCTZ1sUOB884BST8xJfXAYUtzzds67u8=;
 b=jFMGKMVB9K/WqKVR0i/PRcyg8oUyPHgfg6rh7UaK7C/6Y9PdwvF5fL9w9FbmZuRa8MD0a00a3yGvAk0O3lY3WZQaZtxtZJ4JqfgNI45I+R/rNLpGsMSn8llEyuyw10q6RHE0JaMK5eew4HVf0oYR+Qfs/ii5btIFZYaGdbG3skc=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB6142.eurprd04.prod.outlook.com (20.179.27.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 12:24:17 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::71d2:55b3:810d:c75b%7]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 12:24:17 +0000
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
Subject: [PATCH v3 0/4] dma-mapping: introduce new dma unmap and sync variants
Thread-Topic: [PATCH v3 0/4] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Index: AQHVmh1EAM9HSxnkaEm+5zOWq0YV/g==
Date:   Wed, 13 Nov 2019 12:24:17 +0000
Message-ID: <20191113122407.1171-1-laurentiu.tudor@nxp.com>
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
x-ms-office365-filtering-correlation-id: 9fcb4b72-3d95-4cf0-4dd7-08d768346707
x-ms-traffictypediagnostic: VI1PR04MB6142:|VI1PR04MB6142:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB614249E8389401ADCB6E2761EC760@VI1PR04MB6142.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(189003)(199004)(6486002)(66066001)(486006)(966005)(110136005)(86362001)(6436002)(44832011)(6306002)(5660300002)(54906003)(2906002)(305945005)(476003)(14454004)(2201001)(6512007)(186003)(3846002)(316002)(6116002)(66946007)(2616005)(7736002)(256004)(14444005)(66556008)(66446008)(99286004)(52116002)(6636002)(36756003)(64756008)(25786009)(2501003)(386003)(71190400001)(6506007)(478600001)(1076003)(8936002)(71200400001)(26005)(50226002)(102836004)(81156014)(81166006)(4326008)(66476007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6142;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PdQAEznC9yQnYG7dSl1MAIwwiwTHxK+rkV30FMI3AVPjlg9FNUqVmnCricJOQgym31LJVTW273u9T5DGkE0UHb2OxgXsS/VFmFvd+dDMh8T3Nk/K5xqilB7j0ZB7AEJ/ixU+Nv5L3Xuzxt7C+fVT4FMQGBnB5TH2ZShsMvt7TBrRBOsIPJzDZ7kqtZ7xbB8E4B1F97PbgSAWy9+J3f/cWcOomYYq0gk/1cBB4qNfL243snY8h2pe6RVeSKuzuchwDCKuB437RZP+hnCtwy+YAYL3MErDXp/AmzQKe5DNdiPj3Ex9mjPhYgsqsk7F1+pp9ENINJyNo3Sam+FGxzznvtqw+6CXGjF7oHRz43L5bZqEayTHGfhzAkPNxGH5SK8c13TWr9NU4frifm+m50kqkBhESdMI83zIi0TFdDA13pzln2kKQOtwMkRNuDld1sPhq/MeWJ+7zk4SB4A8ku8OLF/gtojDvSvGr4TGI2j+Ni0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC0B467A1118CD40BBB0E04D9E025C72@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fcb4b72-3d95-4cf0-4dd7-08d768346707
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 12:24:17.5423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B/ME1afsdfW/HOnKGOZRrFNpFSdeo2dk5e0uhmzUtNVtjtrhu3sG4l5nNcyG+60GLyZ5DNlzaJRWYUl0H3RspQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

This series introduces a few new dma unmap and sync api variants that,
on top of what the originals do, return the virtual address
corresponding to the input dma address. In order to do that a new dma
map op is added, .get_virt_addr that takes the input dma address and
returns the virtual address backing it up.
The second patch adds an implementation for this new dma map op in the
generic iommu dma glue code and wires it in.
The third patch updates the dpaa2-eth driver to use the new apis.

Context: https://lkml.org/lkml/2019/5/31/684

Changes in v3
 * drop useless check for null iommu domain (Robin)
 * add dma_can_unmap_by_dma_addr() to check availability of
   these new apis (Christoph)
 * make apis work with direct dma (Christoph)
 * add support for swiotlb (Robin)
 * simplify dpaa2_eth driver code by using dma_unmap_single_desc()
   instead of dma_unmap_page_desc()

Changes in v2
 * use "dma_unmap_*_desc" names (Robin)
 * return va/page instead of phys addr (Robin)

Changes since RFC
 * completely changed the approach: added unmap and sync variants that
   return the phys addr instead of adding a new dma to phys conversion
   function

Laurentiu Tudor (4):
  dma-mapping: introduce new dma unmap and sync api variants
  iommu/dma: wire-up new dma map op .get_virt_addr
  swiotlb: make new {unmap,sync}_desc dma apis work with swiotlb
  dpaa2_eth: use new unmap and sync dma api variants

 drivers/iommu/dma-iommu.c                     | 13 ++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 43 +++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 -
 include/linux/dma-mapping.h                   | 45 +++++++++++
 include/linux/swiotlb.h                       |  7 ++
 kernel/dma/mapping.c                          | 78 +++++++++++++++++++
 kernel/dma/swiotlb.c                          |  8 ++
 7 files changed, 169 insertions(+), 26 deletions(-)

--=20
2.17.1

