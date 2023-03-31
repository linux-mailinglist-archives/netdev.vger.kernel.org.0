Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEFB6D22C4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjCaOi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbjCaOi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:38:58 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF4B1DFAE;
        Fri, 31 Mar 2023 07:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuxEd1iSlACnAGuzkLA9euZqnbITZAnrMEhBF4NVU0W8fJ1ebR8Q+HcW6WN3rv0LGVTgv7HJHjr91qVF1YJfr4NhFNWkPi9kCPzWKb/7uYguL3mtENK6qUUCtu/16uQ0MO684h7ALQB2yCx/T/xKdFakk933ex+1g/osue4SOvuUpUI6SnLVg/whhdpT+Gu8hRiNL9TvjtyHvi+Cu6NbuKU+QF/DPXtKDK5dG48Q7b6AhfPodOLXgT+qlkBpxjdfFa/KVmy50201Ko546j6ZbtcuPaPiX5TfTaNa/x9i6IyExmmgVinR6L5PTr3qCJiwnYzUIez/w4wsJ954cMCQ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jPsdZpc0j2WH7clz4TVW75mgT9+gcbcOXNK8X2MSv8=;
 b=BYYuIPtlmcbujBvp6pmw284SbCiVCpSxZRq0v+tTKLSCDsNvm0vVmwUKu8/O/LEimLgl5MmZV6tMwANslD8R4fOnJ1uJZEQ7J14/dy4FcU06M25i2koP9OBh0aC2tArpFudzXxfX4lmcD2iKxkuYD+BYK/9uOhlS86rCbWLLpMQ19asej6ZP3+FSJdN4kuR/Wo/lk1gOERUSSQRuIEwJAABIjoaZK48FQp6XTlUGUubc7pTSdFhhAivqIRsf97WGFzo0zkyGCGiwkQZimSolCFpOH7M0dypMGWEJCQQ5lmbl6hpNWW9S7HZghLTpJHxTcwR/Gn04UWhVQVSichTK/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jPsdZpc0j2WH7clz4TVW75mgT9+gcbcOXNK8X2MSv8=;
 b=gnaHysZx7mujIHZStTkJRADvo2+1KWWFPM3GXfkwxSPPjc0+zElpxXBpqT9x1o8HJacfq/ZL1wCPtzmfg/LLCDyN901yumhRUGZs7NY1kuHg0s7IwcLbCVZ6m5FZXI6W6GW9RH9IRPT9aUD97VNJefKBMKO2HZpCxkn8/grWkz8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PAXPR04MB9594.eurprd04.prod.outlook.com (2603:10a6:102:23c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 14:38:53 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%5]) with mapi id 15.20.6222.034; Fri, 31 Mar 2023
 14:38:53 +0000
Message-ID: <76eb7a6b861ea4b06056552e08c01cc2b378a137.camel@oss.nxp.com>
Subject: Re: [RFC net-next] net: phy: introduce phy_reg_field interface
From:   "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 Mar 2023 17:38:48 +0300
In-Reply-To: <d001e708-b5ac-4aa5-9624-4d9ae375d282@lunn.ch>
References: <20230331123259.567627-1-radu-nicolae.pirea@oss.nxp.com>
         <d001e708-b5ac-4aa5-9624-4d9ae375d282@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
X-ClientProxiedBy: AM0PR02CA0164.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::31) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PAXPR04MB9594:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bda29ff-7208-4b6f-2fcb-08db31f5a615
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FFFe43ttJVJmctNyt0OT6Wqy2QVqf5/dpDDoMjVihjxzfJVaFyYJyaNnutAfQTU11dFF1TmmX0XZJQi4HBKZ8DNZdRbxCcpsoTB8tZqobZ9fcGCKY5uTow9wBeDTj3JcYGj+xl0bkuEjcHIcbZInZe/HRx+JX8xKPmPEyWrmMVpI1swuWTb+ZiZCRNakvtxtrXJbfzTNQlGYNPCwEAqhue72YRWkrykaTDsnz85ntOz6TS3d6rCuVKiNKQmjADP2EaUauiDhFPHl92BWHhxVIVuXNMFmuUL3awDQBneQ/aE3f3S9mxh29DThR+xVfnVrFPrCuD0mgh7bCgTtNKd6LLwbXa2/ftI1Abgwa/FCL3XiN731pZug0M0cPw/vY8MIlKIYF47Ry2hLhUThpR3imHLH9ZrfpHdJbxFo7GyqqYAsf4KwQ8IVNil6LYo7sHN7ISmIuvoBm6P+mPrIlGpD4jT7QNWiR18T7uBmlavdIsJX7e1EaNNpV8rG7+four4Q+H4Urzj1fJnUZI9GbCgVDlcw4ZGcUh3+esqwKwNsgsZQJ2t+azQRvOR/jcqmu4FOfSRZCV8sAfQCXaYe7kabab/pxGWyv1XhiIEGPGAhLuiHdHvzClr7RAPXXU3MJZ+k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199021)(8676002)(4326008)(6916009)(316002)(66946007)(66556008)(66476007)(6486002)(52116002)(478600001)(8936002)(5660300002)(41300700001)(2906002)(86362001)(38100700002)(38350700002)(186003)(2616005)(26005)(6666004)(6506007)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGE4V3R2TXNSTUVnc1RxbGU5VS9aTVp3cE9YU1N3R1R4eFdtcUdZR0ttZjdI?=
 =?utf-8?B?NDlYYjRraGc1WG0wcVVaMzRtUGFGVlVUZGJuVGc1QXZHK1pjT3FNaHMrY2kv?=
 =?utf-8?B?d1cwUXovQllyZ2h2OGs3Uk9iRHRRRzNaeDBQZmhEaGRmMnNwMEFNSUR3YWxC?=
 =?utf-8?B?K0ZjK0V5b1BldG5PSzlkMDYrZng3cVdlV2g4dFc3L0xoWWdzaEtJeEJOc1pC?=
 =?utf-8?B?QzJTQ1RQWmIrNkkzdUoyZFZ3aHNYZ0w3MlBBckV6K3Zwd1FyVzNibXJiL3p5?=
 =?utf-8?B?MW1PaWZ0VUZ6T0ZaRytQbFNUcGpiNUplamEwOXdOVmJ2cnhGTkdZbHFLTGdC?=
 =?utf-8?B?VWk3QTZXUVF2bFhiWVVPK0swakNFQXkyWkRSbUhWY3VMeTFrbDVkbjg1RDVz?=
 =?utf-8?B?OHVncW5rcW5EbkJGSWEyeHF4ZHJpOGMwZVQ3QWlCOStaVTd3cVVWNU9mMjcw?=
 =?utf-8?B?NDhlczd3WldrdGwvWlVFOWhBTlhzQUlCdTZlK25TeTY5bnBMMmNnTWhzLzA0?=
 =?utf-8?B?YUVDR1U4YWZhajY4UXk0aDE5R0kxcDYrSDh6dWFBODdTSU0wMHN3QlNMUmJu?=
 =?utf-8?B?b0xmT3BJWm1pVkdCamlOSHI4K2VUUk8wMW9jZ3ZmeTZYNUNZSVVYSC9TMm5s?=
 =?utf-8?B?dndXblJaZGRhK21XdWg0YTBVZ09XQjlubEJFRXNYZDFGMldMWmp5SVdnYkZt?=
 =?utf-8?B?MUI5bmszQWlVdzU1ZEw1RXRNSkwyZnJieTZudis3c0hwWDhRNXp0RW1GcUR3?=
 =?utf-8?B?dlh6K2VSb3J3STcvUlkrd2J5M2UrbzRGb3ZGS3NyMHRvSVlQUC9oVFlBYTEw?=
 =?utf-8?B?WFdmR05leGtPbS9XdHlGdVZkYlF2TGRDWUdwbUkxZmdQNGo0cjdobldjOGpG?=
 =?utf-8?B?bTk4TmZCR1ZrN0RScis5dDRIR3I3bEpvaXBrdWtkWnZnQzRRcEZQdHNHeG9Q?=
 =?utf-8?B?a0J0MjFmWThMTHhyT3hwR0FxZ1pkTExNb1NTUldINDhlMlhZQjlFbmUxK0ky?=
 =?utf-8?B?bkZKOEdwZWRVL3JiN2hVYWRGNk94dUkxa2RJSDI3RnRqcEFFd3hYTDRXRitZ?=
 =?utf-8?B?UDZiSGdFQStpdW5BcnVtb05SYU84S0JRNWxvaW5nMkJWeDZlVDg5bmFZbzZY?=
 =?utf-8?B?YjZiaU9OOUxramcwK04yczVTckh1cHFVK3gzZDQybGJwbFJaNVVveW9ibTha?=
 =?utf-8?B?dXRsK3pjRHFqWCthNFNqUU95ZEI5T1ZUTVEvVzhuVTUxM1VtT0YxUWoxaHIy?=
 =?utf-8?B?eWNjWFQzaHlnZFdRRUd3Tkhxb00vaUU0czlkY002ejBwRVJTVkpCamt1R01j?=
 =?utf-8?B?bmJ4Vi9XcFRidDRvSm1YTmt0Z3NsRWY1SHZxRGlBc0lpRUZMSm5kQ1lJOWJF?=
 =?utf-8?B?UmVEdlNHOHpNUkFKZWNEaDdGU1g3UVNoTUF2MXViTEJYQXY3NDBYWENobnVm?=
 =?utf-8?B?bjNxMDhBOEZZTlpiUm9lWlBtY0JNcWZIMlNxTGpBWkNGNUFRUVp3Z0pKQXFN?=
 =?utf-8?B?aXNoWU9sMktjVm9McXMrbDY0ZE8rN0x4UG5sd3hNOG90c1BsQUxQSkFxQjVu?=
 =?utf-8?B?TnE2KzJpaVp5TktXRUsyV3NHVnRDRkw3UWNOaUNiV1lvM2NsTzJQTkhWQlZW?=
 =?utf-8?B?TVVOcURibmVxOXNELzlHZk9mTHZjYk5rYTl4MDljS2J4N1p1ZlFtaWdXL2ZB?=
 =?utf-8?B?eVN4eUo0RGN0elBNSGFEUzFhbWlRS0FYblk1M2F1S1VQVWRJeFhVRW56bDZn?=
 =?utf-8?B?VkJpdmlHQkVMT1FsZXMycS9QbVU3UzJ4OERKK21tMG1BcTJXMlJqNmlQUGZE?=
 =?utf-8?B?Rm4rSmxHc3ZuNGZKZnUxbDJUdjlkZC95WjN0Y3JWWlkzeXNtcWNHRGJ0by83?=
 =?utf-8?B?NEpTM1JtT2N3d2N2Ujg1cCtBSzBXV3Y0N3I4UUJpcTJLdjdqb3dKK1RZd3M2?=
 =?utf-8?B?bU9CYksxTG9TZEtueEtuaFFpclQ4MDRrMEZNSWhqc3dnQTE0MjUybjlBQkVN?=
 =?utf-8?B?Rm8zZEpMSnF6My9ETWpCSUFoTlk4RU5zbk56UEE0MllodnNjN2VpeFZkUDBS?=
 =?utf-8?B?akpnejIwUzltdUpPVnZFNURLbHVLWnhVekdBcGorN1Z5Y1VZTjh2OHI0dDI0?=
 =?utf-8?B?MzltU1VoMWRtelVOUVljdWtJYXJOMnFUZ3hndksra0xlR0l4RXFOZFBJaFlt?=
 =?utf-8?B?bHc9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bda29ff-7208-4b6f-2fcb-08db31f5a615
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:38:53.1562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WI3D5iHRy2avHn1CLWWfLbFpbU3dPKCgItl/Mup+HkItFhtHZmGdRX90dN5Edmka2NWjqkgCB1UpgS6cjIEXHlNPO5ykbK9UnKvRF+0u/ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9594
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-31 at 15:07 +0200, Andrew Lunn wrote:
> On Fri, Mar 31, 2023 at 03:32:59PM +0300, Radu Pirea (OSS) wrote:
> > Some PHYs can be heavily modified between revisions, and the
> > addresses of
> > the registers are changed and the register fields are moved from
> > one
> > register to another.
> >=20
> > To integrate more PHYs in the same driver with the same register
> > fields,
> > but these register fields were located in different registers at
> > different offsets, I introduced the phy_reg_fied structure.
>=20
> Maybe you are solving the wrong problem. Maybe you should be telling
> the hardware/firmware engineers not to do this!
I agree with this. I am trying to solve the wrong problem.

>=20
> How many drivers can actually use this?=C2=A0I don't=C2=A0really want to
> encourage vendors to make such a mess of their hardware, so i'm
> wondering if this should be hidden away in the driver, if there=C2=A0is
> only one driver which needs it.=C2=A0If there are multiple drivers which
> can use this, please do=C2=A0modify at least=C2=A0one other driver to use=
=C2=A0it,
> hence showing it is generic.
The nxp-c45-tja11xx driver will be the user of this kind of abstraction
layer. I was looking to get a quick review on this, before sending it
integrated into a patch series.

>=20
> > +int phy_read_reg_field(struct phy_device *phydev,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct phy_=
reg_field *reg_field)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u16 mask;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (reg_field->size =3D=3D 0=
) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0phydev_warn(phydev, "Trying to read a reg field of
> > size 0.");
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0phy_lock_mdio_bus(phydev);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (reg_field->mmd)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0ret =3D __phy_read_mmd(phydev, reg_field->devad,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg_fiel=
d->reg);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0ret =3D __phy_read(phydev, reg_field->reg);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0phy_unlock_mdio_bus(phydev);
> > +
>=20
> Could you please explain the locking. It appears you are trying to
> protect reg_field->mmd? Does that really change? Especially since you
> have _const_ struct phy_reg_field *
I am trying to protect the __phy_read_mmd and __phy_read calls, not the
reg_field->mmd.

Radu P.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Andrew

