Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4142D4B4998
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 11:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbiBNKNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 05:13:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345779AbiBNKNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 05:13:14 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130055.outbound.protection.outlook.com [40.107.13.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A909E657A7;
        Mon, 14 Feb 2022 01:51:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jw6X5MYEb5vqJw1VTPOYyiKLTGczPlCBPimZruUeQTJ6Aj/vghkB3DKfAWiKHnJvdpreconYu3ZC8n6t1oe1fXjfp6Bn0PyJJSSaDoloSo2F81woSm4/C1B61+AUoJ5HdmbwUwHWVJVwp1lAm+eTm5E80LPmzzkuqqWhzgQh9CZcC7QX/h4sFkD16A8G7TglTUzh+OxHahskJ+1a3O7J2nnXlmtdSqC5x3wkgdEFbQmr8Fgyg2jLAww1Rw8yH6SFOMgqriDXDvDkcHs+MNdY54kJDIHgig8URXruubXoaYTgZM2Ffh4HmHa1VpPUj29Sk1qMEH44k8krLBNjtQgsVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s5qj6ZbAYYJo2HZeMMBwMaIySq+Z6lG7jSlAFeUt0k=;
 b=cQKUVg9/Vk/lTMIfUoNM4Sl2Q4ji/R5CTYXGWeYeKs3DNToLbuV+hcbzvLrWvkAxjqA8Do6MZyaBRKPKzAZ7XGOHph/S7yLxjUQTr2qZoAEXpnsJugbp12kjDvIWJO3E4XOGQz3g5Mx2tKoYNfyWDWnpuEe+Aj8QMv8e2knt8OdHgTwmF5dJ03e6Nxif219G3kuzLTLmOE7oRWmBYw4eYTnNhq05DbBZ0oL0b9MY/P3tL0oBcM8g1tS//K11DAFC90At+zeO1GfA2uqLf5hU+lXXHtPvwWEDLiMUiT0Ej+i/7T2Y1VuOwSR6X5MHcgZHUDJwS/yQ2aaGEsIoX1R6Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7s5qj6ZbAYYJo2HZeMMBwMaIySq+Z6lG7jSlAFeUt0k=;
 b=Ok1QPf7Y5A0ipfxLzsluY6jcmKysIUlvZ42Qv1gvxpM921Mm1woQonYT0TGi1ag0ehyxQcG+Xf1VcnlTT6aOz9ZZUaq9sBEJlsctFCVlZm4ko8YIraYqX0j8qhkMWiYkllubNpEWmFN+kc3azk87hvnFGAIIh9Jen8Gg5q8mNXU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8382.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 09:51:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 09:51:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v7 net-next 4/4] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v7 net-next 4/4] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYIQ3AYXOdYKMSCUmkRckqwTRmUaySztIA
Date:   Mon, 14 Feb 2022 09:51:40 +0000
Message-ID: <20220214095140.gkltte6lbr7uzoze@skbuf>
References: <20220213191254.1480765-1-colin.foster@in-advantage.com>
 <20220213191254.1480765-5-colin.foster@in-advantage.com>
In-Reply-To: <20220213191254.1480765-5-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0648487-c5a1-4e41-6872-08d9ef9f99de
x-ms-traffictypediagnostic: AM9PR04MB8382:EE_
x-microsoft-antispam-prvs: <AM9PR04MB83822110B955F2E1F0FE2AF9E0339@AM9PR04MB8382.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m7WmOTpHqC/qYnhjh/1klJCgUMpEuShS9z4X5wUdx7al2xHgbg6kCO9fWkO61QByxakKn8VaePHkY4Ddvhu0YoVcssQ24F1GS+9ag7LJrHw/Y02bWmLIoHq2t1sVmbOpDVmescu2wBl+34PcQ/Rh05S8mOcXXRXelCzTG9gHqTxoCS6EWk7DcUQgtjVjwb+8YgpUTfGDA6HmQxOI41y/GMqvb8Vp8QNv24WuIyH1iiZC4YyMqSqaQdGn15ySDalsdvkHq76BLQuWNlX8f87IByErMnbdVF5+y7gGJvA40VjWD4iGZa0Ximt+LLcO/d1K74779k1v+vneY/XMS65eIEmIok0wAIAicXriXo9lL3KSdYAaSj80plcn6qY2Op9N9Jm6MrMDqtNW5GB7eGqNUbbCD9Y87cY6fi5gWXr57MoDzMBpLsEfW/pxkWR1kfr/+r7A6EMiAVTLfTSiXoOawbNx0dADKdD/pfo2Xob7/6NZYV/Uc6+CKFlx++MVrKkOuS25QV4V2ULb1PB91cyicbjUmrl/GSPM6ADLWvV9S/xpaJ8YvHHg5rrUy9CQb1NbwSYGTLDgFPNiTV3+JCCiS0bxEIQPIm3T6SoA2M1VAwVk+y1cKflp3TRCVLH7aQOYoyIyEDwBFV4FJXkGUkzu6lTSTpXtTzB7bKRff4BM5Bt+pU/1c09xAGeUHbgKOHto2U25vGVReY1L8BD59aXbPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(8936002)(26005)(186003)(86362001)(6506007)(122000001)(38070700005)(71200400001)(2906002)(83380400001)(1076003)(4326008)(91956017)(5660300002)(9686003)(6512007)(44832011)(4744005)(33716001)(508600001)(6486002)(54906003)(6916009)(316002)(76116006)(66476007)(8676002)(66446008)(66946007)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SoFwHl+8hHlSJrhmc2bzQf363t1LRlvaMrJvcEoOsVTnv1PtKmgS5HlruP8i?=
 =?us-ascii?Q?9WRnmq2H8OLBIt193vJo1eGmydEzkk5A8TuegGXLSC/JjuTNo/WJ4MjaB4ow?=
 =?us-ascii?Q?VTCoDV3SuQnZmmcq1IDQYSU3pirvFNA1yWlJSmTUjU5ATtk4Bs44xIxCHwy3?=
 =?us-ascii?Q?Egk3N4ncLpAq5XJ68+VFDbGQ+k+IoVtZDschtYuFtEDDyYO+YGuPOtsZIAjT?=
 =?us-ascii?Q?d1AEW1RSeLWFoY2UUJ0VBOI9LmvfOPDSnqMj7tiAwWtRpx/A4vToPiBVzL1J?=
 =?us-ascii?Q?Pgl6z4+J2yDcjiw3d3ZOUPex9apkErVLiUMVYfnCBF046qCYrY+V+OLs8At7?=
 =?us-ascii?Q?Cu39Zr0NIfo9jq9IdUFsVKyUDmBGuhz+7F+kwU90ZmF1J861x2JnKv+1gx/6?=
 =?us-ascii?Q?BSGoPTdQbbWU9HBlqvsQGxHvgmt67WyEfjOolsqFmuRxb2XfalpTX7MdbB7V?=
 =?us-ascii?Q?IPbD4OMfXVj9jlJp5s5t7qzTjr1qdWX90/3tf79pnzXANUqVL1kRSPAojJj2?=
 =?us-ascii?Q?zoozHXbXc4xE3zyHNw3uQ999JCyRzDfROm34E1WAJYotRbdT+d3+S3posvdv?=
 =?us-ascii?Q?Ipy/rK50cwKGLaFfdzy1LpVOjosvQpis7JqXGI+4oJfNjoa7yxRKCjfyOR2z?=
 =?us-ascii?Q?mO8FkJVzNi4ujltwsDoHLUOF3BKGk8OLS80PSlm/IeSxTiP9j/ZGT4YpdXJe?=
 =?us-ascii?Q?T1q26WMcJwOMrpUPsdqKvRbK2Kvm1aZURWA5brAKGgaG1Neo17VRg6tZANTl?=
 =?us-ascii?Q?gydPoKiHdlDKfVvv11tVRWsEiDji9B66Ide/0dx42gH6FNUGmeyPXfKYphUB?=
 =?us-ascii?Q?FT7uxUTAlduaeWdX7fCK473Q7cTmYH9QcChu/R4QC2iAQOwqBdMkL0AhATcx?=
 =?us-ascii?Q?9/sOuB0+BTZPGLcGpdCx5h9jkVHoJCU+e+wMoaj+WweU8p//eGJNCjZV7Tbk?=
 =?us-ascii?Q?DQGUcD5gCLVoWm2/Fm6LzgSPCbxakuzu8Adqk74FEEVx5oOyDDPeeBkLMiaQ?=
 =?us-ascii?Q?ukDShyoMPPN5CHTkLKEnviGjszt+o1quxmz2bTR5tn9EMEB02WSG3h+cjuCF?=
 =?us-ascii?Q?NFOJUBYqTTGsXkSN9oIjzraoXqfXbmWZRFIjXssw8vtbIjVYbaxL8eIk51kJ?=
 =?us-ascii?Q?HbHy72YuZsY4L42kI9xx355SKkZ/nW6rPp6D34vU6J1FCY5jwv3/+1ETNqY7?=
 =?us-ascii?Q?uqPUlfFgcIkFq1rpqN7M8Zihe3sRG+X4H4VEpZPvsgXzSofiiiwffPS527bY?=
 =?us-ascii?Q?QKfNaQw4dgsUlj0RFhQfb3bi58TunGg+ZCqaOvZ/CDM1je1BdTT0csD1Yk8c?=
 =?us-ascii?Q?xidj/VsK4XomXWsFIiNtqCdidIejlJtNPyQnhwyXZumX8q8FTiGwB+XKlt+8?=
 =?us-ascii?Q?gr0psdnP9VUEIIUPmJHf/ahVRU1fmVgzgjWZFUSrdDgQRLN06kTXEHh17dYQ?=
 =?us-ascii?Q?7lm+jGODyfVJyDRSNrcV88Kd/aAYrmOqcJYM226sCICYgQ+UGubnZxEPLxn/?=
 =?us-ascii?Q?KNLHt0EhnK+b7VXGMU2mCKY4IPCjJMvI7OQU7b1u9Qqo3OEo0GgvGqJPzhG9?=
 =?us-ascii?Q?OcuTPtbWdetcdsVwG2IYA/6rqLsTxHIH4IdttI8+CtuFIDT+t+q7uR+6iDNw?=
 =?us-ascii?Q?JXguyze9TpHU1nCJnAIt0Dk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F3DADFB82496F47AB8941F075547397@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0648487-c5a1-4e41-6872-08d9ef9f99de
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 09:51:40.8870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 69iiEutXixPtTId9+GhsYPTNl7+uZQXWu8Nd/3bZcWXTX8AYAEJ5TSJT7fuaCiiadMuoeOT/FoOxvmr+d1z60Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8382
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 11:12:54AM -0800, Colin Foster wrote:
> Create and utilize bulk regmap reads instead of single access for gatheri=
ng
> stats. The background reading of statistics happens frequently, and over
> a few contiguous memory regions.
>=20
> High speed PCIe buses and MMIO access will probably see negligible
> performance increase. Lower speed buses like SPI and I2C could see
> significant performance increase, since the bus configuration and registe=
r
> access times account for a large percentage of data transfer time.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
