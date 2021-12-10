Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D9B46F981
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbhLJDOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:14:54 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:58080
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236262AbhLJDOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 22:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7aeLi8Fw/AGWHVUaNMrjccPqpBrcjcqlan3szbBqA2Zpxfm1C+fkborVXH1VzyznRLrYREYuTVOLqFqQIw1ILzciTmTnXXYBlPihFqJcoc0C7+UxdX3v524UwipH0d78PH6mXw4/h6wJl84EZ6hCFYkPn1R6K+OI+pkGdbxsyLWJB0KVVu5sa7bCs8QgnnI0YgU3j5V85uY5rlM2tfuRklxezdqUUzwc7bP6JzcomIV+VggZ7FvXgHgxjzlIoGmwelbwnnuqoSkuNsk1LK6GWGFjqWTPRfu4SITqC2T2w846oqtLCBslCshh6SCeZM4XIqTWsl75+03NNtrcsEWoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nn11dOAOaUchvgvGEDbgQnYdkE2duCIvtciKs04xRaI=;
 b=W99p2CyXE5mdg2UV6CBI8aZJMx1wlbgI06vE8s6tlNwOEvIRiSKYzXnxaGSl4M59ij/RWos4PCp0/W4eS3WrZQpcAGv8bAXgDKcGUspsAvsbfMsTQM/7kEOy+QXuanHZEcBr60whfcbzdubSApjwH/h1qm7LVAJg1MjYrJpbEWB12DDrNnV3IAbjfXVMFjTfLZr6u2hawTzENyIjl4Uk2Nle6s65au0ylOL7n3I7u9ITqJyNyaLh1/zLAET4YnODz5Hm8pAm5YVWKkN+qVjTaScG6VwNZyBJDlcWZ/pJ4qY8q5YoHrWZK9hAf+mTCfhpYibaL06o+zhV32glQj0PzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nn11dOAOaUchvgvGEDbgQnYdkE2duCIvtciKs04xRaI=;
 b=U9zerHl93SkBTqvIkn2LFZrVTtA1r2i1Xkgf+yTowRa/5OkJhm1eJJhXmD8nxXO87KGxWiEXdp2lDFKEIrapnc+IsuSrKkUfFitVqdYSpBYWNcHuUgMAIyY/oiEctmVQSabo/d93HPofUYi8xaE71NX7A0PIaR4egsDKrBj4LiQ=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 03:11:16 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf%5]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 03:11:16 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: stmmac: bump tc when get
 underflow error from DMA descriptor
Thread-Topic: [EXT] Re: [PATCH net-next] net: stmmac: bump tc when get
 underflow error from DMA descriptor
Thread-Index: AQHX7Bmwj7VotTMrk0auLbMKkiRGRqwpYOIAgAGlwYCAAAEj4A==
Date:   Fri, 10 Dec 2021 03:11:16 +0000
Message-ID: <DB8PR04MB57852B80794A0B487167D3A2F0719@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
        <VI1PR04MB68009F16CAA80DCEBFA8F170E6709@VI1PR04MB6800.eurprd04.prod.outlook.com>
 <20211209184123.63117f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209184123.63117f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33c650b-3539-45e4-4ecd-08d9bb8abaec
x-ms-traffictypediagnostic: DB8PR04MB5785:EE_
x-microsoft-antispam-prvs: <DB8PR04MB57855D9C65568C941E9DFEFDF0719@DB8PR04MB5785.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TRdDvfBUn9fUbEqduWY6606s/DmQMJpp0VNad4hacnM9G6CPCOl7fjGmzSVa286CPgC3lfnSLf57XAciHty6JfnyAB7GtdGhuVH9I1KAvQn7zrL2J/n8vTmIjx+TZWUCz8m5d6y007OB5ezUw8RcqjyHuFSccpzNUiIDEHSKe+KLZ9Ei6KWQhu3ghSz3uRUPd/m8j7POoBdhUEeBaKqQXcZItuCKujMrEd2kS2GO2wMYIpIqN4p+FU1dVU9MvZWt/TxD+NcAsIOFzSustWgTT0PaIqXZnaZnyQ8T5Bbq4rQCl2f6y8z4FySLzxaH0i0fstwJ3rj0xXW3YQSUR9FKI8uTi3PmLVxLcIls8po6kCsYr1EBuOzI+O1b24gPoGO/NHX8PASsZrFiRIl6QMn4x0dePFZcHUn+NXB+86I57p4lhygbcNQMaQ1BFQwDxIR7jDfT9+PqeOp82AmQtjxUsMSWJE0mbAAcS2oGFCsUFt4xuGYYRa6zE2C+77ksCnXfuP53TSIwFeoFaDsDmlFNOyp3ZEkEnETbWSiaITx+ozLG7YhxXqv5XDS30rZ/ans1BZt2S8WdSL6Pv+NQqa8g3EF3sx7D/EatEsfZbj8UQNakpaHbl0WaYLEAkt5v1kALfy8vEhs7kSK/8DNXTUcdQLlkNHmamTA/lhfnKCG9RwUtJe8XmSaNSHatkFjhUTk+7R/bfksMBKJ6RKNaTTKwmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(5660300002)(7416002)(66946007)(76116006)(8676002)(4326008)(86362001)(38070700005)(38100700002)(508600001)(8936002)(66446008)(66476007)(64756008)(66556008)(316002)(54906003)(110136005)(71200400001)(122000001)(26005)(6636002)(186003)(52536014)(33656002)(55016003)(9686003)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8CkQ8D1Hn8cLUo9hsW5nMip8vRiUgAzlIKJ574GER8L1CbQ6DAbku+++PTU2?=
 =?us-ascii?Q?e6EQ0veDR4iVYRc2+Emp3o498+FXOaCxB9ylfsS7HXs1lOWdW7zt+2DfOwHu?=
 =?us-ascii?Q?A8ZprMzbZMyFfkV69eRuklDD7Q9GStCc++SZS24vb+zIw7Bi5XKM7/M970ji?=
 =?us-ascii?Q?sqDNKboC8CtWiq3493NuoGslJ52Yew8Z73087NOAOgj0t3KBfloQ9mZBiKU0?=
 =?us-ascii?Q?Lf3bKj3aRl1lRbKmz7xRY/4BYyc9yCz5ZxAdSpF0BSyQhXWdHvYtNRTBzLzE?=
 =?us-ascii?Q?htD1+TotDXevkqdrIecyrywxTgXIXPehzZXQSR4Mkq4Hfg2mkAcL54qSd2g7?=
 =?us-ascii?Q?PsUORyNQxE1t7x+rIEdA8Y6yi1XF1yt//45N3Mw3zGgTBlXfY1JhvKghH9la?=
 =?us-ascii?Q?WmZRJ2d6bpOBpa2/qsEUGqckF9HagoBxU+pQ/JBxujvBbz15B24GSJWyzF4n?=
 =?us-ascii?Q?nIhJv3cVFUQeNSBOqQ1QApqj7I11dP+R0dr1vWy1RGRNV9wxK9GbB0Htie3F?=
 =?us-ascii?Q?HnomdW4jx9OE80EVyL70dfYX5CY3BuY4qjhfQ0TvbvbpQ2ObZpN4Rdyv/UQe?=
 =?us-ascii?Q?A3A1VOGT/y9+I+WsYzI+RK1aEjXlUUPnORoRnb2kYD8XQ/sox1/mVuydXaMi?=
 =?us-ascii?Q?CMLshFaFuR59DwDdbS47oaAeGis0KpnU+m0i0BGOlOXmU0cRD+94kc1omsNC?=
 =?us-ascii?Q?V+nIn9m/0LMvg7dN9mWCXn7k0hMdvgNAe/eMJZClJJxUra+meIA1HTwobnZq?=
 =?us-ascii?Q?7EMiSp11m+9SVnI+q9CQo3bX3BjVwtDo5bzRXGMzWEW2w8PuKa+SIz0PG3mg?=
 =?us-ascii?Q?I1batlJce9RqXhFAljwCrIQ7wa1TLFuzCAopi221gkorGptRS6mea/qoeHUH?=
 =?us-ascii?Q?Z4ZJTjpaGgcNX9880dzGV2MMs339bj31vjvoLBI15kp9/+Wq50rwLqjqfWk4?=
 =?us-ascii?Q?yxfL5Qm88zSc2+gANLBL2hdxysWUjACoNoZbQN3+lb85xnnm66kqZhpumla8?=
 =?us-ascii?Q?RncQUBRIzzoADvDT/W0Kyl0OqgrnsmsY4srlVE/Lxv1haqwE1oVqgOhs56B0?=
 =?us-ascii?Q?ulMvkt7cY7b7kF7WAg2fEXEDlAsAQ+x6qCZNKXYrggbABGiPnHqBPD9OdHOB?=
 =?us-ascii?Q?vNARqS3qOvO3dYsf3IWu7RYjSQAu7gXnR5Zz1/dAN1rbjbUyXB/y+8Cepf4J?=
 =?us-ascii?Q?VksmRkYNho0UUtonf8GTstGfK8q51whYKgOMK17Qrt6p3oA+yZN4hCEtDVGK?=
 =?us-ascii?Q?ESplL/ctA7j7hmvHTKca5ISVTl1nsUMvQbNe9vx6/DZITOxT8IF08FZTCbAl?=
 =?us-ascii?Q?QVllxeiPfjvTiPYWH0fLbF0laxeVxyzxDeIS2ZfMLHtNVtQb0JZShEdXv1bu?=
 =?us-ascii?Q?2Abdp3CdHi3xBZl3ESoTzdxyQDMQa1hmAnMBRks7d5t9wBD02NtyOsStAfPO?=
 =?us-ascii?Q?nuQwNMTJupvO9VFOSup+Lj8yO3TaXuZkhTZwj6iF2kXVB6k8emZuvoaqm6AH?=
 =?us-ascii?Q?w7TCiT3gsGe/KKaTwl8Dkt44lCHHTBQPDDaQcDhDslIUkhxgXDO2ahhzUToG?=
 =?us-ascii?Q?EUZT/x3VfsD2PmyfNZirSDhRyUUzb9RkGe34/k6Jdb9im9PWRDyWFwyh1f81?=
 =?us-ascii?Q?H1jQomVRbRkmPSvR2FBwsiTWLearlstDBGw/re+SvxCRL8LrEGnz6VIZiBRX?=
 =?us-ascii?Q?DUM5SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33c650b-3539-45e4-4ecd-08d9bb8abaec
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 03:11:16.2877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zpb+e9UWQKUPKzmYK+AulWvugwxSflybqqb2qGA0rBHxov1Arb9kozgaDVRMvzCq42GAJDk3PKi175sMMqVvndaT9pfUDXNyyrdD5P2nh+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5785
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, 10 Dec 2021 10:41:00 +0800 Jakub Kicinski wrote:
> > > net: stmmac: bump tc when get underflow error from DMA descriptor
> > >
> > > In DMA threshold mode, frame underflow errors may sometimes occur
> > > when the TC(threshold control) value is not enough. The TC value
> > > need to be bumped up in this case.
> > >
> > > There is no underflow interrupt bit on DMA_CH(#i)_Status of dwmac4,
> > > so the DMA threshold cannot be bumped up in stmmac_dma_interrupt().
> > > The i.mx8mp board observed an underflow error while running NFS
> > > boot, the NFS rootfs could not be mounted.
> > >
> > > The underflow error can be got from the DMA descriptor TDES3 on
> dwmac4.
> > > This patch bump up tc value once underflow error is got from TDES3.
> > >
> > > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> >
> > 5 queues with FIFO cut-through mode can work well after applying this
> patch.
>=20
> This never worked, correct? It's not a regression fix?
Yes, it's never worked when the underflow error is observed in the case of =
NFS boot on i.mx8mp. I'm not sure if other SoC have same issue in this case=
, but I think it's necessary to increase the threshold value in case of und=
erflow error.
Do you mean that I need to send the patch as a bug fix to net branch?

Regards,
Xiaoliang
