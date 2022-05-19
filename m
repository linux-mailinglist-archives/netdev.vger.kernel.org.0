Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A234152DB64
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242235AbiESRet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241532AbiESRel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:34:41 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B871DF;
        Thu, 19 May 2022 10:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrYyCeG3XErFY5XiXB3Ia/9ongAkE1S7kCmsVWWorM+dSInEplXf3bI7rV6oDTJosQjoISj/wIiUTs4UPOw41jek1lrEQBZ5WEms42xazceJ6nAUbe3HErpgTkS4OKYYMu0cmu7yF6t2/FwM+zHAUyXzLqGyGaGgnKlEjbzHvm2WMaQcLqv9h3eFrUi3pMCPVoK1e3xmnkJ2lX2FH/FJA9x+ejTKqAKSs3vir/jfojhCeZI9FZEnXwQouo4w4FOQbjPIJme/14DJm/iUsxHL4d2S5zdjyGWPkGA0vesr0M9Z4mEGggXcIONq+tqU4dR7TgdIzC8Bldn+9kIU5vZbxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6POtEPrd8n/bo7FiDcRoj6AakvdDw2ULlf48OhOAfeQ=;
 b=bcEklOnWZI65XvCTdIxRL00+226DVLwmWk5ocJCqU2S806nyt7CExcCIUATK+CCMG9djdRxcfzaP3Uyi6OwQ955Q8ytjfGS5ylHpHRrXqlAvIlbp3zdrfm5U+Ne0NOK/5yZ3Hx0cKXWbj7BczFFakZQeUPityrdtqhCJjr6EnZ9rn9xEp59Rbl1qzKdhVjP6b+baj3LjmpBmwN8S4/NrS2wHaMzKUe3hPqrfhQpFdyxLAn+v9sAIqLD+IaiZPn2ZzyBy87jNXsyCLFCL5aK0qmJ4OAZpBd3J92tkUzkveCqtxQiyxSneUnvDsIfr68xLzPvsYxTps1J54yEAkGtGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6POtEPrd8n/bo7FiDcRoj6AakvdDw2ULlf48OhOAfeQ=;
 b=hk3qEEyTA0gV/CaMGkwEKdeU9hkGupi/crXzt6CbwbHXyhOBsz+Cdtc0lbs29HepXE9PLBbQhlA0a8CwxRjAfHKZmFCZPjuerXoBjs0+xUOpl9OrQTb+9/rq9G2KOACMtXgec9EC/PKLr5fa6YIdaMiPl4zS7KVnmrmAsbSVVEY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4098.eurprd04.prod.outlook.com (2603:10a6:208:64::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 17:34:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 17:34:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHYZ6RHhg5iGg0Rm0uC0ArSy8F0MK0e99AAgAOw5ACAA6gZgIAAJsyAgAAGiQA=
Date:   Thu, 19 May 2022 17:34:37 +0000
Message-ID: <20220519173436.z7g2sshz5ivqlpe7@skbuf>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-3-maxime.chevallier@bootlin.com>
 <20220514224002.vvmd43lnjkbsw2g3@skbuf> <20220517090156.3fde5a8f@pc-20.home>
 <20220519145221.odisjsmjojrpuutp@skbuf>
 <c16384a3-d868-11e7-ceed-bc8e7029962a@gmail.com>
In-Reply-To: <c16384a3-d868-11e7-ceed-bc8e7029962a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96dfc634-d13b-47dd-68dd-08da39bdd8cd
x-ms-traffictypediagnostic: AM0PR04MB4098:EE_
x-microsoft-antispam-prvs: <AM0PR04MB40986D0AF3C71D7832561C53E0D09@AM0PR04MB4098.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AZStP7UN8kIbW7DPLuF7f9i8RvEKUjJOi33RExKQLcVWnJZEM60B3wnyxRUhnrIjcuum3aZPb6h8oQopkKCkBaUROfMoJjoH4UpQH6AZxc6K51f8LSQvXjdJ4q8hM8T1Nwq6amAYsMb/tLR8zWv/TveMDikAh6afzPxxCkhfBsRelQDDy4zTkFDemJhc3F51q8CLZ1/4QUZyjmF796Q/JFd7xMQqHjCCkLzKRC0hTlo0pejKvN6MbHunJft51JGsMPbEaTgh9mLh40VUfjiha9kDaBdEwZlT6ZVzzk/I+TIHpiVOVEgsxuZRVlP0II4XinwJkn6wlyhrSKFP9p/jBrs7/+bR9Y1/U5Xv3/P23CTW5ts6FP3aSD00Dymipc/bqDBYVC7xugDjJh8gotxOyFegf4V/VE6UizB3emuMvTntB2rk3qXhZeA9aOrnbJEC5ALcYGsA76D7olht53dCbjtLKr0ZnQbVcns5zwBtk4O1trDCsZbN30BbxnYy6Yy24/Dwl9PEop3gVIchxYRDCgp18gv/ctZ3WnoCPHwS3nv2d3tIF6L4dsoSoV6HoGrVG3uqkGuIQANmdRxZY926qFihHD/4l0z6ygM1++rXxigo4w920ixlyFCY2He0/no+KoDGJPkVGdjuuuALxm/pOzqpwqPj1479m8rY7PIydJEirM/dRXieCQJJmMaJmmA4PjuowVebLrvEJjnc9rmxxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38100700002)(38070700005)(2906002)(6512007)(316002)(6916009)(26005)(6506007)(4744005)(7416002)(8936002)(33716001)(44832011)(5660300002)(186003)(66946007)(86362001)(1076003)(508600001)(54906003)(9686003)(66476007)(4326008)(66556008)(71200400001)(76116006)(6486002)(122000001)(91956017)(8676002)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xlRmF0DBlXV6IrkeWE2HWwueQRRikOqQKqXvRWY484LjkNuMWQZx6OuVB5jM?=
 =?us-ascii?Q?5L4wbA/z2AOSJL+swmuMPcmDtHVAtGkX3Bb1Zuf2/SzcG0kDwqYWaksp9Xzh?=
 =?us-ascii?Q?JqliidTA75tsFeHnoYT0D4pzAqElyt2Q6VfKvUOW371IDgu6pshJ4KiRRXro?=
 =?us-ascii?Q?vGApk7LvyWyIVN6rbGMjMNqeK9rOVE17GnQiw6hP1eoNQ2IhprDJ3JjgIW+C?=
 =?us-ascii?Q?oNKIUp83BKEoByfab+2XhCPYLpr2TUW7VobSZVMP8o8CeLWRg5IF0udWK9DX?=
 =?us-ascii?Q?/Gbpjhzs/AmhMaqlriIrdNJvNBTD0RoSQjE86FE4YGaKBUmZ4pBWu9Mz00Zm?=
 =?us-ascii?Q?b2Z+t+/Isb/pY0Kse+WcUv9i74pori/ratgUb3/mQZ/0XqTj1f/MVAZYg2NX?=
 =?us-ascii?Q?OrW7FHTvybOipeaAE9GsuTxQKqba4Brlp5aV4MSdQNt2fqdxrSURurrZ545e?=
 =?us-ascii?Q?3bSra602GVyuiE67iuxLrfet8raNP/5zsUJzozOPV2zO/JxAiX04CppEqPBu?=
 =?us-ascii?Q?SKLLKeBZY9U/9rUk1TOWBpTTDcKGFou49IHShCvAukFjsriyFDG1PbTCPESx?=
 =?us-ascii?Q?Qo9I+NbSzOSlLsky1XjP/yD5ZEo69g6Bj8nZ4kL2dQlC/F4QlSeCOBW5B9kg?=
 =?us-ascii?Q?FY6DF1Agb2X8obHFUiO7KSnJLeu4njsP/ScNss7B2QTfm7iqDuyTcEZxjb7x?=
 =?us-ascii?Q?LkAZGTORoKTK4Mx4e9YQqv4O/Pt0TQ/qHjrFEEMnF7boRS2CTkIQlhcilOdS?=
 =?us-ascii?Q?uuKxo2SU8xhyELPN8Nr92nrtZzunQMh8il236VF9J+myowg55X+xdEAJaYUs?=
 =?us-ascii?Q?4Nm9J7JILJwE4dhjY7KxNAz2n/JeD2p6mO/WngGQvdJuM7+TaztEAJEPXzH9?=
 =?us-ascii?Q?rv383GJKCNJO8sW/08oRdxftsQzATlboxOI1f8svNFbGjV2to1RB8Yf9Nvvs?=
 =?us-ascii?Q?iEuxCDarFuGP2g7B68YTzYaz4uGkdKT6tdZvZz6Uwyo5PFdcZB+MOJ3L8FkT?=
 =?us-ascii?Q?fMznRwDoUtnACphk+Q6/5zvBOnr4JB0XC0RA4xVe/POdJx4JOTRT1PvE/wLI?=
 =?us-ascii?Q?D5WZsYSKiCK6bD5ziuOv0pYaZhqxd4IGgju6/TnhEI2XgEHpSFoO+xuiUciS?=
 =?us-ascii?Q?c88IgVlAY9xKaf+eXmLWH14IN470f/KOYJc6UtPt3nDFjlYNdxmhhuOxLNto?=
 =?us-ascii?Q?b3YJt+4B4VKEbSBpK/fjQW0n9Olw9zzcTEJMGIAoZG6lRpgcDcB5Pw3OZcQS?=
 =?us-ascii?Q?t3E+GWaTFlaNMQvmbITYBGbRoKShH2wA7tkdyPKOf37o/fIDbc4DBRLuwD78?=
 =?us-ascii?Q?+3JMwW6mvcMR6FfVj5kGOCx9hZrhcWTRAxO9Vew8MOkgodaC/qaC75FIfoeG?=
 =?us-ascii?Q?SDhNLr0mONZrjDOwRy/6ua1eSc0yuBLIygb9aHuwmEMrfkPD2CN/HdoBgWtF?=
 =?us-ascii?Q?vzkWH9MBRhK6o2ej+Tkcz1NbtjOIT7qM06UhzH/qoycFBn//yvf+lyO/dfT1?=
 =?us-ascii?Q?RhF/RzTJZCRKZJb4p0MT9sAOacirM1YClsCHrBoDBfYqvsuhWc283cJYd3iv?=
 =?us-ascii?Q?002bsQsVJcLd6rkdW1wNhQ7NYW5cb5Whe+tgHBXZCJzNkCXTe4RPA3eq2WYk?=
 =?us-ascii?Q?jJzfRfD9d+87XX9Se1W5atPPo/UoEkErbwlh700ig7yYNGXxsIDR5CCeRWO2?=
 =?us-ascii?Q?9BqCcPi+fhHD8y9vmUZHU8x/pwErjStgtjK6xQ5D/C8AM5gTIEU/zExLHNmn?=
 =?us-ascii?Q?kA3WmcelPcp1fYses6gjLz+9mJevKFU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E94C3E544C4A404080C579AD1C2E0849@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96dfc634-d13b-47dd-68dd-08da39bdd8cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 17:34:37.4976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ocxqgsrwx2rUhrkYkDoHyeE+bnuFXQRSwpyZKYUjEak5FsFsslI3SiQnmxpf1Yukpm7SZULhhi9hWbzubii+dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4098
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:11:13AM -0700, Florian Fainelli wrote:
> unless we somehow manage to put it in the linear portion of
> the SKB to avoid using any control buffer or extension.

But how? Essentially the DSA master has to look at a packet and
determine whether it came from DSA based on something which non-DSA
code could not have done. In fact, I'm looking at the calls to
skb_reset_mac_{header,len} from net/core/skbuff.c, specifically at VLAN
and MPLS, and I believe (but haven't tested) that pushing such headers
would also alter skb->mac_len to some value !=3D ETH_HLEN. So simply
having the DSA master check whether DSA was there by checking whether
skb->mac_len is ETH_HLEN + DSA tag len could easily confuse DSA with
some other protocol of same header size.=
