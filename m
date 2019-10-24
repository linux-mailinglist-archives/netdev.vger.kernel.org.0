Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864B2E329C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501989AbfJXMlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 08:41:46 -0400
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:37188
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728034AbfJXMlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 08:41:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjOCm2LQ9SK7AfTb3L8T2rnHSs1pDXcxf9ds2mHbYkkkCaLDGtvnyQefDTJQAqAfDo6mcHq0nsyp/dTDdyI+O/LZLyBqucSvxN7KrLnZ+C9gTiunDix8RsmHNRkcyC3lzV8tmN7hRjxqe7mKSXsEL596L92woODdbZvIpJAa91BHL4a7xxD+hMfO3zvrWImQEl4XOXrdGPAT8iuRk/rwRBO6dFjl7UGF4BO/2UCnQL6lH6qG3JxZUn+bbmIjrSxgUiRH0bZqigkXiD9Lffj0GxqFAytMxO2JpqhwLr+qIKS8ZqZ5ykRdWVbuUMAgPGaRSsfum1ynPaQUd/mr6oI2Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6rBLvHYFcbEahyZuys4gDUn7xt/7+w5yuYCF9fU/J0=;
 b=h0DsIwiqq3FX/SPKQj7Oa3YpAc8G4URiTbBmx1RmiMETb2oLmcnS701+jrVYvw9IjVx6iKvA4+LdPCyKy/9laRjlfwheU5hVXTgy0jrc9Tk6bR4vVU3U9BQa0BMnm60HMHbhtW/jHRH+T6ELWG6SQymEU7HWkfRqDBzixitPnzRCGFyHUyo35SKvWqFeLpBvTjqG+uVk8wmn8ooi+/N1fvvUSRK9T8a/LpY1NPQpGcwNKzI9cy6Kn0XtKYfwCsnswy3ulh7ueRzS6LOIof5iW3iSReSa9jFNKrSTOktg9DYoB6wbeAby8tnxgipaR31iqYsA0bFAOx/7c4cLHnrhBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6rBLvHYFcbEahyZuys4gDUn7xt/7+w5yuYCF9fU/J0=;
 b=DA8mu3C34yVZ4Gv5M2ha2/r4QlR1a7w7lEFavjcKGskj7VN4NOP04IZO+gng7ovkiBsqih4bn5BeFLt2AfGsMHxSNu+kFj7MGmw9GZUas47EptxDI7HlAjsRWV2pveSkr7WSEf6EC5Iu7mUMAeh8cvihblQnIpuBva/hFEyNFmo=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB4701.eurprd04.prod.outlook.com (20.177.48.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 12:41:40 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 12:41:40 +0000
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
Subject: [PATCH v2 0/3] dma-mapping: introduce new dma unmap and sync variants
Thread-Topic: [PATCH v2 0/3] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Index: AQHVimhhuMRbxKrZqkygDgTD8mS8Pw==
Date:   Thu, 24 Oct 2019 12:41:40 +0000
Message-ID: <20191024124130.16871-1-laurentiu.tudor@nxp.com>
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
x-ms-office365-filtering-correlation-id: b2ebf557-6ff8-4985-3fe0-08d7587f845f
x-ms-traffictypediagnostic: VI1PR04MB4701:|VI1PR04MB4701:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4701101BB20CD68AEDCAA947EC6A0@VI1PR04MB4701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(199004)(189003)(66556008)(64756008)(66476007)(66946007)(66446008)(1076003)(8676002)(8936002)(81156014)(50226002)(2201001)(305945005)(66066001)(7736002)(2501003)(54906003)(99286004)(81166006)(86362001)(186003)(5660300002)(14454004)(316002)(52116002)(6506007)(2616005)(256004)(14444005)(26005)(102836004)(386003)(6306002)(6512007)(71200400001)(71190400001)(6486002)(6436002)(25786009)(486006)(110136005)(478600001)(44832011)(4326008)(476003)(2906002)(966005)(6636002)(6116002)(3846002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4701;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5sPC0aiWACVfaSy11GuFC9KYgdzKrDdzxXVAiFC07r3P0isvsknAy4vbtwbiasdf1zDla5J3trYGMqOPzmJC47M8FyAcgwJiJ7cBPVdIinbc9k2aOidx1yMC1LuFdPYI88j5/WLOjILcZc5k6qZhc4HV67lOS31hmwMLLjign95OUielTW9kme8R8L/n8DzpChpalpejF9Kxe1LanPUDuvhfc7Tm3EvE0uLdpB9xko1GtdXu/AdKdNgybdu1BJY/4rA4FdMT5r2l2hX1mwgcOxGpQrhGNDlpfWZ/AVEBXqaMtqgvYSJISCI5QurnNYoprrPf9gmgurCVTDCQSQKLqUYkTOdgw4mhBkmixfjGbuyKOyY+8/UKK6hkaIKejwFH0yoZhLmjPZ07iHZ3qWcvsqjEtNBm80tO4lUwkAYpWztaDqJQlduzCYMB0v2TRcwWUR9c6JYw1Ea++zipjfbetutlmNuxjwNRfEnOVyRH53Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E0571BA8D5EC9242B37A84DAD6498C98@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2ebf557-6ff8-4985-3fe0-08d7587f845f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 12:41:40.2669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sw63SrA/qDBJAtmd7W4R1kw4Lh4Um7jJgXzp5QTgWwdtNA1VOzx8BE2cqzvQI7Hdiw9Ih8sUDGqeqR6Bpj7H3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4701
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

Changes in v2
 * use "dma_unmap_*_desc" names (Robin)
 * return va/page instead of phys addr (Robin)

Changes since RFC
 * completely changed the approach: added unmap and sync variants that
   return the phys addr instead of adding a new dma to phys conversion
   function

Laurentiu Tudor (3):
  dma-mapping: introduce new dma unmap and sync api variants
  iommu/dma: wire-up new dma map op .get_virt_addr
  dpaa2_eth: use new unmap and sync dma api variants

 drivers/iommu/dma-iommu.c                     | 16 ++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 40 +++++---------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 -
 include/linux/dma-mapping.h                   | 55 +++++++++++++++++++
 4 files changed, 86 insertions(+), 26 deletions(-)

--=20
2.17.1

