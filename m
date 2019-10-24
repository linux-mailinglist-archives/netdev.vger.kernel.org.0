Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37A8E2F97
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393340AbfJXKzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:55:50 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:58381
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731524AbfJXKzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 06:55:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrnphfQmJCVSGleiVlsgDlzuy3+CdcnPGbMrnfEqd+utTdpX09L1jO4lA6gh7wwu8c2Nq/t8f4PnsgMTQqLAIPDNyxA7zSGSVtPBjmkmd5/wlL4NO1w0zbYQ54/t8Urvnq9hjxTUTJoui83jOSF3flE0Okx+Ro7M6wk7HLvfism4ZWEoY069X+8gARY01/lnczlypNrduRz8OyS8F7bcdlPSvqnyL1v0UGKqhIAVcFmqK3onXzlLRmhUWRPx2F5vJxqD/tAbwM9Wt3FBEC/w7xFHMa+n3/kxmb82TOET49t6z8m/U7mVzMUpq161WseLSuxBVQFtnvNB63nYhxVICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK/VUYkuopB9YKqkb8pfdqdhlyaubzd5T82wEHuaK9M=;
 b=l6Fja/UoYZATfy9Hk+AXNAEoQfKTyN6AKfvxwFBZcTl4Enl5WS6EugoIPHnfAry0TbtwgvYozaPw/5d6Pgg1iTxohRCZarG/pxKbjyJbjeTrnsvVwDHFDvH5lL9X+Zfc+8xDF9wLJLxlWILmRV2lJTVx/FlrAwGGb2cXj30HvXWP9ivqvnlPsmVsJNfRVmw/hyfkfJMN2B4ME9edtg4UIBaR1T1Q5x2Y/KC7f74PNKKCRCfnt+6KGqkYxk46Bqjv3G7BRmxaiI0FWBpVsZjmgW/DtwDxtT1LCAw6ygHMpODj8MEjjDjIrO4Iyrg4oROrk4b11+Fbz+P6u9I6CpfO1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK/VUYkuopB9YKqkb8pfdqdhlyaubzd5T82wEHuaK9M=;
 b=H1gxlygdmqxlWen7vygdk0rkMZ9hm5YxO+jl1yXSrO/1E6z1VNqeAlNj0ktrM9acUHpI7R/CxnyCvANurkd5+fsU098mIXs1+/9Wu7/jguc/MGJ6Vxpe2aFZJZkya/YVyPkjsqFcju9OvWstu54amWGPRI46JameXQ4be9J2q00=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4190.eurprd04.prod.outlook.com (52.134.123.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Thu, 24 Oct 2019 10:55:45 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 10:55:45 +0000
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
Subject: [PATCH 0/3] dma-mapping: introduce new dma unmap and sync variants
Thread-Topic: [PATCH 0/3] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Index: AQHVilmWnBiSTB7mCkK1r1G1J/8hmw==
Date:   Thu, 24 Oct 2019 10:55:45 +0000
Message-ID: <20191024105534.16102-1-laurentiu.tudor@nxp.com>
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
x-ms-office365-filtering-correlation-id: 539f9a76-1983-4447-8656-08d75870b8a1
x-ms-traffictypediagnostic: VI1PR04MB4190:|VI1PR04MB4190:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4190ED777B074B4925AAF75FEC6A0@VI1PR04MB4190.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(189003)(199004)(71190400001)(71200400001)(2906002)(476003)(8676002)(2201001)(36756003)(316002)(1076003)(52116002)(966005)(81156014)(14454004)(2501003)(81166006)(478600001)(7736002)(2616005)(6436002)(6486002)(4326008)(66446008)(86362001)(54906003)(186003)(6636002)(66066001)(99286004)(6116002)(66946007)(66476007)(305945005)(66556008)(8936002)(50226002)(64756008)(14444005)(3846002)(256004)(5660300002)(25786009)(486006)(6512007)(6506007)(110136005)(6306002)(44832011)(102836004)(386003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4190;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6L+YwMmISylrxdh0fhJntkgZV4KWY8Yxt0coX9kp50MVXorTrZxRgAlrQ0UZ+1lmw43PgLDRbxh1dFqEBXD4z8o34cqPaQdBcfds9g6DxH6K+7c48k2ksTvz4gMb8NXbnq84Awxm3cmCywvPrx/dhw5RKYDHwBri4+TsOV5nyvlw49qbwCKFFX28xJya1eWgzrA9GJzdUX3qAxA70sOBdMR4gV81tq7ha9ZXnb+Ikf6viAMT6l7P2km47W3+//Ekqfs/8JTWjPAlkiRocMmnZDRE0/kHrImV7eZ4e7bydF/NoJTHyLSOkRkEiPvQNLLq16QJEQr+H+7YW8Q6EczaFdlQhHEY2Q9IMiJ6DunVxf2v+2XOt93nbqvGvSU/388YhdZ7VmUhIrhcvCtrCV8HtLI6f766YGpYsR262p5ZlXS5Du3lf5pNrol0ePMeg5N6vGEpC1s7Ndnx0M6WbskiGZmiEfX7VeMvaXjaRyMSnhk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F968FEAF617D9D47AB288047DA22708F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539f9a76-1983-4447-8656-08d75870b8a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 10:55:45.6767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51MN89D8M+hSPG9l5X+AjzMPyDm+FCS3yJLJt/x3oxShKSPBFdM/rPlte4EsVWUOJtF3T15nqUnC7o2xQVSkIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

This series introduces a few new dma unmap and sync api variants that,
on top of what the originals do, return the physical address
corresponding to the input dma address. In order to do that a new dma
map op is added, .get_phys_addr that takes the input dma address and
returns the physical address backing it up.
The second patch adds an implementation for this new dma map op in the
generic iommu dma glue code and wires it in.
The third patch updates the dpaa2-eth driver to use the new apis.

Context: https://lkml.org/lkml/2019/5/31/684

Changes since RFC
 * completely changed the approach: added unmap and sync variants that
   return the phys addr instead of adding a new dma to phys conversion
   function

Laurentiu Tudor (3):
  dma-mapping: introduce new dma unmap and sync api variants
  iommu/dma: wire-up new dma map op .get_phys_addr
  dpaa2_eth: use new unmap and sync dma api variants

 drivers/iommu/dma-iommu.c                     | 12 ++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 43 ++++++---------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 -
 include/linux/dma-mapping.h                   | 55 +++++++++++++++++++
 4 files changed, 85 insertions(+), 26 deletions(-)

--=20
2.17.1

