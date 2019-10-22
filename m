Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E952E0441
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbfJVMzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:55:16 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:11892
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387695AbfJVMzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 08:55:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfATZIM3AlGB8kppQxwIsd0qn/oGqPhtU5MP7mlGmGu4PiQLLshfx2dS/kadARCAkYJy6GDT0x11O9zn+RL3jvofSfsrDaG85CixdvFc2MPG9bqnSk2vYs/8aYUhdGW23zSWo+GOFN/G56w4LlkI/udiRlhqJp7Hh4V4iRSxCKqWH2fZG9KG5nPXd/OQi+ElgKxwTisMJlqP3l4EsGbdCLzC9iOA69O/mNDVKP1t8QVymb3tpM2bgXftJz4DQjvYoJ2TfimfwW20Qu2L/6OsXNxn/fE9Ch31IjwFJynvlH8OVM+M9Py/6bNYn3sdr1P8bl+3gnIr6RO8eN3symbl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNv6IjX7NTRaLHa/KsqXe3PRSpyE5yjkmEdxKIOz3R0=;
 b=NDHGwWT2w9c2EaSaHHMTvp/spcnia4cFRblWWjMRWyUhsKXiH0Vz0ApEXQ/SrXU904eAuwlDiXpjwJsV7aajRS+IBqtFK6UjwZiQt4I43v9nhNjZgxjwsDdI3wLZX8o+KEp+EzINK/cywN1M+FSLHJw1j8efgIbMCcs0g61B0Gu7VaBNhkt8k3mz3aUshZPkWbM+Is5OBNktSYxqOBjyv9YFujura+RXsDPmD1cmMI6Hl/+RSAvfNCmQwg0Ofk7HNtt+a8qklxAXJ4zy/sQ2qLWH69IaD3fDqmQoQz6D0gzpkyl8Ijo7pZZMQKpgKbiawdhTNknaerRMAIRJWKfExg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNv6IjX7NTRaLHa/KsqXe3PRSpyE5yjkmEdxKIOz3R0=;
 b=doyFGHdgOrxf/Af8D2m14H1xG2XSYvYkg117/D3PF9AJVSZhRuIbx7N7j/IxD2YY9Aek/uKHtbz7fafbVoJiWfe7JCbOqfa76/NqiDTkKQlxk2hkO4oYgAEHQ2M5c3Q8THqV3BY9CLIFHnmFvQ0D+V6B79IjWGSJL1V9FdrPl4g=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB5053.eurprd04.prod.outlook.com (20.177.49.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 22 Oct 2019 12:55:12 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 12:55:12 +0000
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
Subject: [RFC PATCH 0/3] dma-mapping: introduce a new dma api
Thread-Topic: [RFC PATCH 0/3] dma-mapping: introduce a new dma api
Thread-Index: AQHViNfxj8gDRGiIWke6+ObDJgNM6A==
Date:   Tue, 22 Oct 2019 12:55:12 +0000
Message-ID: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
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
x-ms-office365-filtering-correlation-id: 11d3349c-534f-41ba-7928-08d756ef1366
x-ms-traffictypediagnostic: VI1PR04MB5053:|VI1PR04MB5053:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB505327E2D7564B081C052439EC680@VI1PR04MB5053.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(189003)(66446008)(64756008)(5660300002)(66556008)(25786009)(66476007)(66946007)(36756003)(2501003)(14454004)(71190400001)(71200400001)(110136005)(54906003)(1076003)(478600001)(316002)(966005)(66066001)(7736002)(102836004)(6636002)(186003)(2906002)(6486002)(476003)(6512007)(3846002)(386003)(6436002)(50226002)(2201001)(26005)(81156014)(305945005)(81166006)(8936002)(86362001)(6116002)(6506007)(6306002)(99286004)(8676002)(52116002)(2616005)(44832011)(4326008)(486006)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5053;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fbGiEArBH6hzXAucqeFjXWk/81+/8Wp6v93sAbazGPHTQxAReuwvGUKlicmyPU+vGRj6UGkJtbCfmm8GMuINwUAMKP/Sh0rpTg1WhDxURjBtrE2oqGWp59Zs5kX+6Q8DofVKnWXsOex1huDtcpRU/jAbbRKVXLSGG+OCU3solJBq9SmJ9uzAzDpSqQ/K4pIx0T/l0jNfhnC4i60ua99NZXu30D7UVnli8fGCbUypdEtehQ3Jw1sxKUy48bdgpsKvTV++ez7YtlLMxUx20XV+nT21BLg3hxwrNL2pkH/PZgfTfkp79suJN3D3u/zov3e60DTzyH1/4CRpztl3/zDgQvQv2YMZkUFuisllIYiDTO4gklFh3SJV1qdg9PRMNbAOEBVkSGuyFVTdDD1z00Go35pvg38oV0YGfMBIJcG40bld6bx9VLDkDs9SJ1D+j7DNQ4gd52UP41zf+zZospz4hYjBJyIVZF/+MaE8YcA3bMw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C7EB76BC7266544BAF01690F3809CB4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d3349c-534f-41ba-7928-08d756ef1366
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 12:55:12.2127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9d5Uns1TK6r7ZeSHL/w5XlNjeukaSyml3D96A/MvHD6hCO8Gh+jsHdasqOnyb+k+ItUDmwAZmPIyGeXNDxdzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5053
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

This series introduces a new dma api called dma_addr_to_phys_addr()
that converts a dma address to the corresponding physical address.
It consists in a new dma map op and the wrapper api, both added
in the first patch. The second patch adds an implementation in the
iommu dma glue code and wires it up. The third patch updates a driver
to use the new api.

Note: Originally i wanted to use the simpler api name dma_to_phys()
but it's already used in the dma direct apis. It would be great if
there would be a solution (unifying them?) to use this nicer naming.

Context: https://lkml.org/lkml/2019/5/31/684

Laurentiu Tudor (3):
  dma-mapping: introduce a new dma api dma_addr_to_phys_addr()
  iommu/dma: wire-up new dma op dma_addr_to_phys_addr()
  dpaa2_eth: use dma_addr_to_phys_addr() new dma api

 drivers/iommu/dma-iommu.c                     | 12 +++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 21 +++++++------------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 -
 include/linux/dma-mapping.h                   | 21 +++++++++++++++++++
 4 files changed, 40 insertions(+), 15 deletions(-)

--=20
2.17.1

