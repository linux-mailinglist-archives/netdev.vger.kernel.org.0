Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6F02DC6FC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgLPTVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:21:07 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:56121
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387989AbgLPTVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:21:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eyol7zuSdboDBQmiO3U1QBUGCZ7ECbmYf7cnBvN1WzeC7hOApIIrPWAwePhX3LlnaIlIkRLWCfMevbKwA/iAW5wc/GKWOIR1Q+DsixmkBZrN0fV29b3ferNaj9miJojVPSSnzQP7yDVTBnhS2nXh7fncnFbPxu7txP2ZaQcRv26wC3AfmoSAzEvHl91UB3/N26G7c6+4m0XFCZwr1Xvf8tbZ8SfWWycsI9l01STxAoq/Wzttld6z+snyTt6gPXDE91q3hKzgX+fbVmCmWDoIRpMPkYjfg2vMq8/2S5iOMi7cByLpO4UfFEiCNaZme43oIlrecPEsiGVmXYuFbxkKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrtBevypp0O/FIZ91hbukzfAICeTVxrrPrkZE9TTDrk=;
 b=jMiKj8HSjdYPSKRlKP8H9r3884iU/4siBlzYtT7p8pGaR7aYZ6gxkd3axkECKZOL7q19RfHawuXfFQdpQleSepDfHX0xgZiN+4CARSceZQR8ZBJ1M3lj0urHFrm6s+1DxYkrnXz12/a9ARjMh84YR+QzIg4oWES1hWDCasfYsxh/Eier1Glcf0SHWfbpP8989SeBzvngezXy4kQhsceWod/ZH7ptYEFjluiKXtvZss6sHBpI9NI0MMG+lHpm7obBUaHV5rSa4oR8zIZNFjaZz27tzzdZpHdptsPQEBDaqe6+Ed7LdJeEtaiDCwMb2EMCsnjjNhkwtaEKzXnEvJYc5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrtBevypp0O/FIZ91hbukzfAICeTVxrrPrkZE9TTDrk=;
 b=kE450d/xB+Vi0gWXWrOERrnfkVZP6pJv8rl2Y98N1cW5pAL90JyRIAMoJCguxSVCxlhccIxJCgJzuyB9EB80LSOKjHGkRMJFbqwzSNbcdmF1nR3vURehNFS5ofcKhpIY+lQnxN4+JDmUI8zHilkXS2qxrw+ScPNN6eb3Oi0C30A=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 19:20:17 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 19:20:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 1/4] enetc: drop unneeded indirection
Thread-Topic: [PATCH net-next 1/4] enetc: drop unneeded indirection
Thread-Index: AQHW0yhcRARJ23eLyEi0KH6fwGgCfqn6GqcA
Date:   Wed, 16 Dec 2020 19:20:17 +0000
Message-ID: <20201216192016.q5klhv2mdv6yg73a@skbuf>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201215212200.30915-2-michael@walle.cc>
In-Reply-To: <20201215212200.30915-2-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8da74d04-c2f9-4017-8ed5-08d8a1f79f6a
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB663771C25BA0D85E686E4F20E0C50@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TBzEH6dW3ktlZ6WPzr+yD3drAk85S4NrqTW4ibKLfQi2PbuyqbPZbmaRl5K8g0RyCU2kjL5ygRW40OH/JbFU/qFZfjhTGWjE1kATPmGpnJ0Ca566KXApmwzm6hSriUGMU0/aRK3gTH8s5Ei2+XEhDn/cphvcN3mvFiFAQEAEb1hPXRsAu/unpMOKxZmD2r2sz6qTnLFwjABrMAhQhw5k02zadvVolrJWzdlSE0XFvwuHoC58gj/iwto7pHuL/4Cwf/46TLWxu8j3R/pPtWeROG8S/mXABIVvSP2VRk25OuBnFWzFPhZhskT/uI3aiG0N
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(91956017)(86362001)(1076003)(76116006)(4744005)(478600001)(54906003)(2906002)(186003)(71200400001)(26005)(4326008)(5660300002)(6506007)(6486002)(33716001)(6916009)(316002)(83380400001)(44832011)(6512007)(8936002)(9686003)(66476007)(64756008)(66446008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oNLWa3oYXXRslMq/rFoqHm6GIHpg+sa3+BfLPEWkSJhnhD17C+CBIGixqM/X?=
 =?us-ascii?Q?9i5NvlJhYGZTaV6t862v3KuiH/Sgaw154hDf1EqWmYC8Yp5/621yLJw1t6Qm?=
 =?us-ascii?Q?emFuRYsSQCSBv7WvoBym9TN78evToE8UmUq7yMwc8rEF/nIJ8eMeiEhTJBha?=
 =?us-ascii?Q?xApLxtWo07+rSit+ar3hAcYxkwpR60X0YD7Cny7HPTr/tUyRnRBTDAMK5RnS?=
 =?us-ascii?Q?CwaoBaPHL0cMpiyaCgqpTOMng/T5rWl61rmY1TIyJXTbYlnQkCUpl+PkOt8a?=
 =?us-ascii?Q?zTpLIyL3mDchHMVIFEMff1LYZ+Dkm3idTiQI7j7nKDCTLrJUflnj0vfmKfQy?=
 =?us-ascii?Q?jI+LfotnRDraVG3bo4F6WwgSRF9nsxjUwIA/XfbJyOW9dYp0lcViKj0kjWx4?=
 =?us-ascii?Q?1/iofafPOF2kEsPUIfrF11Aj6u0D6Cje4deB+rZUDxdsH1McTMFUK7JQPMoV?=
 =?us-ascii?Q?OLWuF6AmL39cr0pcZ+IwHxwYn/+WhHTR+jM8rnYrIKTRU6VyXoITp4mEvJKv?=
 =?us-ascii?Q?6Kn2e2YwEvB48VXbRjANea4Rrj/v9SEV+p9GzY5PqGDALlnwL32Y0jy2xKnH?=
 =?us-ascii?Q?+TQuDCelNcCluTRzFfwgp4UucQnibifE5UnN0tR3NRQo6KjzolfJR8mpsL1K?=
 =?us-ascii?Q?eCzEY6P/lpenUxH9Xb0mrlhfHOS74gWHqsGgz5VIQVFhobR6jrrIRz1MG3Nz?=
 =?us-ascii?Q?cGVdJY6NyKswDd3I+qODbX1HAe/HZn/EKoR1aqKp6H03k04mDTLr0LxtwbaG?=
 =?us-ascii?Q?scyUd16U7wYdvl9tS3vYSYVh9ITG5SefDsdXzEMjOZlB4KmU6dRz9to0Zt6S?=
 =?us-ascii?Q?kn5utwVqBptd/TSnyvkldGQ4lR530UyvnfOFHcn82KCuxYjVrWfW9LuNe3/w?=
 =?us-ascii?Q?EJhTIOiWYjuSjGrUAc9hsAoytbY2foouf0jKzUKAxm6TfprocbOaOTLlpT0J?=
 =?us-ascii?Q?8VCAEP2zYmKnvg7GNEAJyrVA1SeFvTLg2xw2HNzIObS6Oj5Wv5IomGbUZ4ok?=
 =?us-ascii?Q?mwwE?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE8169166DEF0C4C8ED8562D99B7A387@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da74d04-c2f9-4017-8ed5-08d8a1f79f6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 19:20:17.5560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SxxCVJoCcI0NHDtFO7hh2wTYPvO9Eg3VH+N8fTev/r4w0wIrRmrO57PxtbK9M+S2HEtNV+4G2Qu5j5egfies9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:21:57PM +0100, Michael Walle wrote:
> Before commit 6517798dd343 ("enetc: Make MDIO accessors more generic and
> export to include/linux/fsl") these macros actually had some benefits.
> But after the commit it just makes the code hard to read. Drop the macro
> indirections.
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
