Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DCDDEC2B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfJUM16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:27:58 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:5347
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfJUM15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:27:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGwcUFqXST8igv9H9fkahf5bS1N9oVloUJhZD4O6U8+fVICGk6Q8BzUL/BIFv0m29UG6H+o4vldrQeTBPU3Lp1rFahc2/MxP1hQ7rmm51leZHdVrtUFbAwS9bcIDpEXwIhlJTOS9i9e6ftXtOU1MmfnIjfayl35qOxt/bP+NGry7uiq84FfU6VBDBRXt6V/TkAQ2Z6m8Q2dydl7WHWuLrBVwP/TLZBn5UZhunLzYXcjOrQlY2BiCea4B6Z2U9lK27cnWh0vzoVbuJvOTEM3nvVTTNGoGYoJqcQzfDPRyImjU/3RsaDTboAPOXRtA4ywoilp6UAGO1OwKAxwX3vImSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgfthfdNlGnvdc8VQv23NhmOtdpFaVHYLPDzpbK81Tw=;
 b=E7/Ph1bmf5NX2GFU01ODewMyfdwmRFWNtB1QxaHeNsRHNlJbzfID1O+E8Os+vxVTVXuv5r0QI8UXOsidVnMGW3nw/MABm07q2JbagQAggLQc9yib/ugSJ/LCsLYt9CfPmy7YEpFyFVjANx7K8xvcpYsg2MHEoLIYmvAqwb/J9iKC8mA9RfzimfjslimpEfBgEkGsuxLu/SJo5dpF6CU/4Hqmh5cQPibUoKtwsQzJFRW1GUZDPtEHtbF8YjTdjIpAGqaWnmuftJVAdTKSM3pfN/g9ZhDGsNMrXmmJ9VxHLDTubIopS317Zb7UEkGtuiTe2RkVB3zHXPSdRthIiDEMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgfthfdNlGnvdc8VQv23NhmOtdpFaVHYLPDzpbK81Tw=;
 b=DDBTFuyEnjuScTEMYuclpN+3gpkNynhxZvYt5reLHjPh9/FhUv6XZrEQzXyXGPMyug40I64YWJRPdJ2C6+r6QmXhrRCtmB+SK8a/krD5glYRnXeZVCGfQBFUtvIaM2i08QDOdmcluKnhIik2La0pYi/9snNQlxjXdwO3RRHZ6AU=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5807.eurprd04.prod.outlook.com (20.178.204.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Mon, 21 Oct 2019 12:27:54 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:27:54 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 1/6] fsl/fman: don't touch liodn base regs reserved
 on non-PAMU SoCs
Thread-Topic: [PATCH net-next 1/6] fsl/fman: don't touch liodn base regs
 reserved on non-PAMU SoCs
Thread-Index: AQHViAr2AzSLc8moC0WsjWwzc0ue6w==
Date:   Mon, 21 Oct 2019 12:27:54 +0000
Message-ID: <1571660862-18313-2-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
In-Reply-To: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.37.124.34]
x-clientproxiedby: AM7PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::32) To VI1PR04MB5567.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::21)
x-mailer: git-send-email 2.1.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e604ac58-e80c-4041-1617-08d7562218a7
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5807:|VI1PR04MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB58073A64D917602F625C4B4BEC690@VI1PR04MB5807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6029001)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(102836004)(486006)(3846002)(26005)(6486002)(446003)(11346002)(2616005)(476003)(6116002)(2906002)(3450700001)(36756003)(86362001)(25786009)(8676002)(6506007)(386003)(7736002)(186003)(305945005)(99286004)(4326008)(6436002)(52116002)(81166006)(81156014)(76176011)(6512007)(66066001)(14454004)(50226002)(478600001)(54906003)(2501003)(8936002)(316002)(5660300002)(110136005)(66946007)(14444005)(71200400001)(71190400001)(256004)(66556008)(66476007)(64756008)(66446008)(43066004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5807;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o0a7BJXVviKMxvLtM87pEuyW+IhbwTlr7yCCRoGwlEdpJVxBhQTm4nZ+KTcoENtotOBkDY9Ttuq7mPPSxGbHyELpzS69BuqQTdWnxf51gz8T8vjlgLoKMo/J5iEi4fNN0Tv8G5/pdQqJTOR3mY4x1IcBz4LUJNERI96L+Iwoi+NlibeYDWz/q5UICHc4lAqo+Il2VF09y+kXQ6fMarDozs3W6S6B9loXO6G2pwcVPM29KM2WVIM9n5kNaiNl2pNiFsW756B3i5eIfv4Y41y403uJ6cs2ckMywZTt12G7WuqlCPT61FJnCpIT0JmiDOlKB8hyzSrpRwHF5GHQ3TreS7FT8QZ9gkvWxEfQUaq18G3BOLH3SK7fl7o/95dTnVdWsb76qinvQdGkjXNbWO1HBTZcGX7GSCZrpw9qdyM4LQhMo/AR54SYCYH0ohdtxfNi
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C699C10A72B2847937C8C7BBA8687F2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e604ac58-e80c-4041-1617-08d7562218a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:27:54.0783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: br+Wi47f/no5eLnqwRHbTlSw89bmcgxF4mZWt3Z7tWBX8n+6a34SH++q8afHm8NFiUFlocR/9dDXzPd/V2bkiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

The liodn base registers are specific to PAMU based NXP systems and are
reserved on SMMU based ones. Don't access them unless PAMU is compiled in.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ether=
net/freescale/fman/fman.c
index 210749bf1eac..934111def0be 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -634,6 +634,9 @@ static void set_port_liodn(struct fman *fman, u8 port_i=
d,
 {
 	u32 tmp;
=20
+	iowrite32be(liodn_ofst, &fman->bmi_regs->fmbm_spliodn[port_id - 1]);
+	if (!IS_ENABLED(CONFIG_FSL_PAMU))
+		return;
 	/* set LIODN base for this port */
 	tmp =3D ioread32be(&fman->dma_regs->fmdmplr[port_id / 2]);
 	if (port_id % 2) {
@@ -644,7 +647,6 @@ static void set_port_liodn(struct fman *fman, u8 port_i=
d,
 		tmp |=3D liodn_base << DMA_LIODN_SHIFT;
 	}
 	iowrite32be(tmp, &fman->dma_regs->fmdmplr[port_id / 2]);
-	iowrite32be(liodn_ofst, &fman->bmi_regs->fmbm_spliodn[port_id - 1]);
 }
=20
 static void enable_rams_ecc(struct fman_fpm_regs __iomem *fpm_rg)
@@ -1942,6 +1944,8 @@ static int fman_init(struct fman *fman)
=20
 		fman->liodn_offset[i] =3D
 			ioread32be(&fman->bmi_regs->fmbm_spliodn[i - 1]);
+		if (!IS_ENABLED(CONFIG_FSL_PAMU))
+			continue;
 		liodn_base =3D ioread32be(&fman->dma_regs->fmdmplr[i / 2]);
 		if (i % 2) {
 			/* FMDM_PLR LSB holds LIODN base for odd ports */
--=20
2.1.0

