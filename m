Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A934BEBDB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiBUU3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:29:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiBUU3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:29:01 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1840722BFF
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:28:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LF6d6kZBEpx3qOHpwSq/4gF7fbsEmszaF4R2Nacxl+JhBGYjmpiLcTd/tPCtTNoW3AYk9BBjuIQWFPfo30Lu/zdYk3gR/khAK3ROYUewwtezJB/Qzgsx6I67zfJuGJOJiUbsOqu3vkkRyYdju4DN7HaQteRFb8KrFWUEIY+tjRGpjl0/eJS+o9RUZ1elifzEmYRS0Ts6Nc7H0WTioDxdvi9OxiE8+l/S/KZXQ8eW8kVW4y85Xaoq9BPYuT6QA10KMxBvD231qe6vxu34x7jsIdt1r+WOK+f82Skg1ZQCc/DISEkFbEIRwX8Bd1Ur9jYlh7UBbvAYv0csB0XZpPqO5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZH+LMeQ0BVClRtHXmINl71GhAkJNpNGJ/tsTxzExtI=;
 b=mPfCGTDdq5RFR2TCo8EDjba4SPZgD752bPA51FfRil+3YhnZo254m7kdhE3Ro0Ss0o+KHxDkvnwuwgPt9PkupYDZ6jw7poPhTQI64caaMwu/FoKR5UgMJl+GocL32CIyf/3odmSowRFxdD6ET5ZzbAiprDWd1yY9mgV66dpiTQ4LczoCOthwnP/5SV7YcrCRIMp2Uhkx4RE8KOaasS0X3qDzVDHPxbKpdwA5neDvjUJqWc0vjVY3nrX0dCKvI31c/mWMWpmhqQnpEwF35hMhKlGw01z2C42ZqrEcUck1lVt9AnGVfZdD8x7pPx7HDecqoP6LZ8WAlBdqgCnEwOENyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZH+LMeQ0BVClRtHXmINl71GhAkJNpNGJ/tsTxzExtI=;
 b=PFbhO/vbzWCgri++rzLEmyv3iLKtJtzZz+P7MP5x6P25nMNpKdQd5kua91SlXcKoaDrNWY961MqaN6YO1rw0FMDXNqGKrhFKDyaff9PatYNeYSWT7HSui8uLE2OMpjWU1/BVxYSzTBaNqt2qWLBtjizAi8BWjhxoPGSXNQrsdCc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5604.eurprd04.prod.outlook.com (2603:10a6:208:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 20:28:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 20:28:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v3 net-next 00/11] FDB entries on DSA LAG interfaces
Thread-Topic: [PATCH v3 net-next 00/11] FDB entries on DSA LAG interfaces
Thread-Index: AQHYJ0wFRbD/5sOL0E2Ki5kKBFM+MqyedJoA
Date:   Mon, 21 Feb 2022 20:28:34 +0000
Message-ID: <20220221202834.ldtk65x3r3zssygm@skbuf>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 507ef283-befb-4d58-9f6b-08d9f578bbfe
x-ms-traffictypediagnostic: AM0PR04MB5604:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5604B8E3D5AB87434F310E85E03A9@AM0PR04MB5604.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FGTF1iYZrSoUwG/lcPICb3azo7b5rnpSkKtDvmhtTmd9E9NKoOc1nqPlT0wCRWIxfB3vG4rreTL6I9qSg9uxe0u3opC6U9HpBGvxAB4bNijocmOzglQxXLxSXbVUTabVt5Di7Rd2qfU9wYO50Q43Au4YTP2Tll1gKucGKUElwNwlAB0iwPZ08yLYDar0gkVse5dlv3dlT3oofNX2XVpm+PyDqWhqnfxbhill+F8/Jj0AY2MC8DztZqKJt/6jIC2fWSascrywXDqol9NsrKW+b/1b/zwUoruSPCN8sBGWm6Lcx2b7RU5PF0i3PXhkRA2B3/9vKAdZhgGBpESIymf/KvMRVWd+KUA7zUkBf0/4bH4AFnV8IXknN2a4Dq8WQ6qaWjJ+PlaLUmEf/PcpxytlFXliywDyxIYgISVYa4zlwIgM72bGDsPu64+XzVJxlLBYPLTYj0mDKeHUsEIVeg1zKzAfWekVgpKM+ByrF50Rf/HaKQuXBg27bDs8gSOUolVqe3JB51na7/qEF6LDW3YffParOXLQ8af9OSPzVTSSCKJBdnKzrbCj8PKOhhMgtxIF+cLBA0U5e7OIZuFq5y8aBBow0FAObWKgFxFXb+3DiuziZcTWtRhknXab1q3lbIbQ+dzAo8v0wNr27u4qhy4K/k0ef/sjqAzk6sZ56oYCGSQEmbYH8geJPta1ptyKtHYHXw/PBl25woUrUDBV2gEmJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66556008)(64756008)(6916009)(54906003)(71200400001)(8676002)(508600001)(4326008)(66446008)(66476007)(66946007)(76116006)(6506007)(6486002)(86362001)(26005)(33716001)(122000001)(1076003)(38070700005)(8936002)(4744005)(2906002)(44832011)(316002)(5660300002)(9686003)(6512007)(7416002)(38100700002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FD6I/tVWIQyU/OGIqtdK02j+il90wDfJgabkLQFWI/pZZpc5XNHzt4QPbiPa?=
 =?us-ascii?Q?0jZeOU2Ah15fYn7nWEbABsVaT0xpAEmJPl0tGYHY3pSNkdf+79PC3krrX/NO?=
 =?us-ascii?Q?+1QDU//4s+wY1E3g8NLbwmI87dGtk91mIqJdeR8ZzV3ZpHzXunjQrTTFpBGc?=
 =?us-ascii?Q?6mHeChI+NnukXROISjobXl7iULN4mg1BRCTTAlsHWphwqfHSYJMdh3wAay7Z?=
 =?us-ascii?Q?rfSwjvw0BmiuxkoIuTslBcm+QKDlpGydm2GFa+rHsN/o4+LXIq/YTweVJHRN?=
 =?us-ascii?Q?nx0vNN+cy7eltKhdUrizPbtbVbJWi944coMi+rpa7Vd2nZgs3vRo151D9pMx?=
 =?us-ascii?Q?M1oyJsMQWZh0b8ao/XJJET2rOEr8K6EAZkNhNdHJ38cz1ta388ge50W87vkX?=
 =?us-ascii?Q?5J1VrOKilVrp1CUeSvky2m6h0FEEMvyFuIozKQWZnReAFcvEc+5JzOfM7M+z?=
 =?us-ascii?Q?1g3LJfaUkrhhYhrD6J0D+7tsOb4E/d/eEP+1H9z03kCO8+SjmAY+K/k2Df4w?=
 =?us-ascii?Q?0fvlWKNwweVWQFzPd2hAstpJLwA5mPH6UO5moleVx8M8444StYNwHb69OJKh?=
 =?us-ascii?Q?Q7zSYiVTHfC+JHVwDf4aS8Otq5kZqJom/WAgpegzne0yNG8q53hwTaTg4LL9?=
 =?us-ascii?Q?kON4mITGMNlHvpg5M+6xvZO7zHn2TayX/RJvtMt5ACbrr9QBvd5w5LAwj+rx?=
 =?us-ascii?Q?yIYFu/4Bk2YY3tRQQpknQl5uzuX13bk0mBtHefOghdeZjrOpsV58tk79WPKg?=
 =?us-ascii?Q?rJzooXkTjXaHA/v4hrC6GB99t7IB+5ldQzX6SP4TkEtU6nvM+vdxNh27nLgC?=
 =?us-ascii?Q?5UvrQ3YaKft5MvngoYoAwDLkWHTDX5nFPnmpHRXVGpcV76XLOcMV8vFio6LM?=
 =?us-ascii?Q?4w4RpozTi86bNOUw2V77jr59RDU4N2Ohs7HlBhSb7F8l37T6o2avjZumV/6q?=
 =?us-ascii?Q?jHWESb2nAyTSSnQauYSc0QRlmyPc9kLkQf1AFN81v32rS4B6dCc9MxNnaANU?=
 =?us-ascii?Q?Z58sj7mqZ8LXHAI9xttLf3uYqv0z/u670v6jQcvCyXiJuc9xfCxK4tchR5FK?=
 =?us-ascii?Q?h2vKjm8UVj2Vgjl9Mcp5IPHtkQQO0tMdCNCqAGCG7BTiUz6ugIbpQCBuf9tw?=
 =?us-ascii?Q?gG9V7o77BDWHhIg3/bNW1HYtkUcRPzQEJivq2Q0PrLdj04/YRM6od1N1qbaF?=
 =?us-ascii?Q?mOri6+vFo6Si3w70vFNgRU4tLMS0qeIN2ibrwI2HqQvyyvkY7fO2UNxwYg2d?=
 =?us-ascii?Q?MKThQwFVJj1xMsItmbiOy+xLm6WpWjCa/3obys6Uh00WVU8fZb4M9DPnBOWg?=
 =?us-ascii?Q?QqGUIooJuTDd/gAX8BJxX/Y22lIIQXhAWvUEod2zVCZfCH5CTP/gjgpBNfqD?=
 =?us-ascii?Q?9fqgfvdJVp+Q24aWpa67f6sWrgZYut+jOIlgrbHtKKuQ5V0wOM5IDrdmfGg7?=
 =?us-ascii?Q?V2U9Y5sRN5+KmXTtikIKlisB2BXQTxU6SkMNbdTXSWTbTZ/DuDbta+lHdlbd?=
 =?us-ascii?Q?t6DeqXsU1TzcHgRDU4JqpA5IeH2CzzZ8oN9U7YSGwdYbT7fIA0rxydqt1rZh?=
 =?us-ascii?Q?s8hfCYtjgBX1hZX2xRFk1Ytg4B6dxPcVfVHR+NvkeNjM8fzk0wCDnD2EJWtT?=
 =?us-ascii?Q?sZuzR4UJVUFc/pCbYAmvC8E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <92544C1062055348B13B4A5E1C783E1F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507ef283-befb-4d58-9f6b-08d9f578bbfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 20:28:34.7292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGXG6eXjxjAiao/tM/rW+5vPPGSFqcrwBLj5542kgIVWWTSa1b2DlUyWgtaStgz+0npPVGwddxAEXi/ZFq4o3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5604
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 07:53:45PM +0200, Vladimir Oltean wrote:
> v2->v3: Move the complexity of iterating over DSA slave interfaces that
> are members of the LAG bridge port from dsa_slave_fdb_event() to
> switchdev_handle_fdb_event_to_device().
>=20
> This work permits having static and local FDB entries on LAG interfaces
> that are offloaded by DSA ports. New API needs to be introduced in
> drivers. To maintain consistency with the bridging offload code, I've
> taken the liberty to reorganize the data structures added by Tobias in
> the DSA core a little bit.

There is one critical and one non-critical issue with this patch set.
I'll resend soon. Please disregard this version.=
