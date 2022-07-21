Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1173B57CB56
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbiGUNGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiGUNFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:05:46 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FC279EF8;
        Thu, 21 Jul 2022 06:04:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dpt3yUCq50azDNl4oRzlaj4TeVvg0XF7BcK+1ul2IXkz6i8qwMtSiC0ArZQhgF6s9dfIKvtKVtp6XXg/W09kePNU/vSf22Qwigrv4gbTEgqDV/gLjcwAmJU3Hz1IGZ5qRUPo6IpqcJA7aS4v755+HqTdFgiw16dPAAc4JaeTpTnEKIQ+bhOcYADMlgFeBKj2y9jh9Fl9tYLairBStINUhua6Nzuka7D74H1R2dEk+pBUuwkUskfvIp44XLpRvIDhZ/fsFjGu+TVHDUEVEfQBCZ8V2BEP2i+8V8OwFuR9fewMQGexjSKA9KH7nSZm4A1J1VAG2vDaiit+oleVTwqnrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAXVS1XECBpXXFI7Z1i4y1jH/kgrTaiQ5DX2qZFhZAA=;
 b=PUvMKpaPAM32/xo5k6RmmdBTSrqvPy3zsmX66LrRV+0SrwJfYajbBdxJ/cdyOo9wzwgD0LUfD34r+k8O6XNrJhpT4FvNA6eWy4QLHM5vGJ1tbCqSltuh+NGz5KSVbyyV6E7GX7z6G8Y7zUp28r0XZcpjfhmjUaz7q8NnJ1VOHzEhVy00XXIZnVXJxHOHUNoI7HxZzCd1OqhruLrWBVY8Gd0wcBeENzyJbPxdjGWqBC77FsEqzjoBWwz8Age3Ex9lH+p9wgSaq3tiZVVMrWLOVVW7+WWBnls+iWzqv++uDjQzsU6VswHXu52ngJjdwZeZI1qqSsaR0v9AVWfjeOESpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAXVS1XECBpXXFI7Z1i4y1jH/kgrTaiQ5DX2qZFhZAA=;
 b=Aqbeaof0vngsdaq1v72oPa3aWDTrYlfQZP3vLMYtY9qa3F1mKstFoDBoh3Q1ymFhH9ydUidWfiGbzl9fPpvCw8MfBVQtEyB/+7v59mTb/zzWTrOSkiOo4VEZ3iDB8QwLGEh6BAnFNshnmnH2bX1MuDec7on6UwOq0KAILvpFmpA=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2560.eurprd04.prod.outlook.com (2603:10a6:800:58::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 13:04:37 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:04:37 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 29/47] net: fman: Map the base address once
Thread-Topic: [PATCH net-next v3 29/47] net: fman: Map the base address once
Thread-Index: AQHYmJcNhh8WReUf00m8grOHHLnSX62I008Q
Date:   Thu, 21 Jul 2022 13:04:37 +0000
Message-ID: <VI1PR04MB580763F33F7EFB0265DB1C40F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-30-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-30-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8758259d-bb22-4f98-1f4a-08da6b19909c
x-ms-traffictypediagnostic: VI1PR0401MB2560:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RNRQFo3fYk7IZMK+hBkGm4ua/bc+0LjrXRHbLbdRlReLyTeY2p0MH29WrjuZ9olXWSnWI+AReQBOYGuDWkmf1snfWcUzrziCsUAzleJNXH7EgKH7AyEURmUS0a2AbI7GB2vuUWZmZmNCW0h8hmf9drG14J3aE0nldXc/uzUZTPYD9zSJVVnE+GRAKd48DDdTSYIjmKmm8BBsus1twmWK0Bw6cF7CJYIy/IsWQfnjYyVBOYdGdTLnNg1dBhcsWgEzTQzuc64P/mvmkC3ihCY+fNMLAGvFGb3/9yeR9/HmTap+cVECL1nx4chHcdCUj5IbB8tp0B4/P+pneAa2jKGfdNqLfxkz6RgF0CTbFyzJV0XAJS0cQfCbhHD4HgQkpaZirYk7+hLAAhlaw8P7pFDIjGl36CjzZ3oF9qLfwxVKXlfkfhdWKmGjx7NxfgcWPv+6R4kmngjz6BhiWKWPh/0bRnxZCU9WPv82BYds9OhxB+WDp5ETTLy2Ko2rCt+JlsKB8vT+yqLYLGgcykIZB8rTsLLdPhDVFGdOMmnIhyixARiWnc3lzfowQ/a1EZFlmemxV7E9YFNdTfgZgcM7z1s4lQMBJxZxtLmceo76+2zQQcCrxPtCQniTqdGB4EccO0Ee6jdfWI1AuogEar4UwN47BKMNJYBV207Fk1nu+x8hiwJRCB28xnt8zFCI4gbzqIqgudYjW6IYQOLGi9GPhkMxdvhcQilpI/ypdW3GI0rG/vxkh9hEVVTaq1SJUngHuHCeys3ZP4NAvu+pS7gwGzkX3+gB3kxHBylQsIbioyCDiO2xvlGC5W0waIOdAm2SdtQ5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(33656002)(4326008)(66946007)(76116006)(66446008)(52536014)(66476007)(41300700001)(2906002)(55016003)(8936002)(122000001)(8676002)(316002)(66556008)(64756008)(71200400001)(478600001)(5660300002)(186003)(110136005)(6506007)(38100700002)(53546011)(83380400001)(54906003)(86362001)(26005)(9686003)(7696005)(38070700005)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7scF2+P3hzuzzUsaK12idXciG+tyeKdn3X1St+og6BRwRA7y4qvtDaH8q40S?=
 =?us-ascii?Q?Dr379scxlyDxFXFg4C8jcr/NB90s9fR7hY8RYWW4Kj+Ga2s6LAPwdsLGKK91?=
 =?us-ascii?Q?Kd3cmc7gYnQFX5IsoARWQpuZwsWnayC42y3PguhvWgMKc6OAaXGltI1vj50D?=
 =?us-ascii?Q?EpKlb7BcHKhOVW6sX4gvOVOH/sr0J60SdMaxq0QAIlO22UG4H6eb66TA9df0?=
 =?us-ascii?Q?yDvpoWdVS34nNmqqowvT9ELNjWT1ON5Ww3UEaOuLEAM74g/UeDfNFQgn2M0A?=
 =?us-ascii?Q?CpDNMCeTdH/LsitKLG0VqmkI8Np0eooHbt0BVI9XQzcbzfbg0oX+sBKZ1s7i?=
 =?us-ascii?Q?YV6LI2C44U9FT0L52e67QSnptzNB9CPriLDgLp6d+7CasSFf2qZEXWYsFuhQ?=
 =?us-ascii?Q?5TUJXUZWITNJEbOgQtnefBYdGXnx5a6L/zqhVJyzEPrQHwBLDmWbz2gu8LvZ?=
 =?us-ascii?Q?YOgvTRVp5a8KeQiQMPtBhm00lJ+u7lO5eg6Lg5iGX8HPDskMotmgvwY/f37x?=
 =?us-ascii?Q?sF9nC/dhZgO1SiziUmLiAbWMBmkQ2V8+1HzbULRZwhCq1fkXkwyXxN1YcPCA?=
 =?us-ascii?Q?tP4G8ALdQE/KnxamazcGyvP4JVJftjxXzClZ4aE/YsQKQ9v/PO4bFscOQCFJ?=
 =?us-ascii?Q?pMCUP5IifTHmWpusQJkLj0Zk4uB4J9sH7bsPsx/QrnUxiawJXLsOXc0W9a6F?=
 =?us-ascii?Q?Ls8LttJOLtfO66qFyrQP5emE4QY4sh0B6jIuk2wmH5IN8/M02+t27R5Inz/E?=
 =?us-ascii?Q?4oOvBgmZQ4GcNLDEcu5lVN84RZ6UqSYJy4xuWL6N5ly5kJBIHPd0xoM9wmFO?=
 =?us-ascii?Q?ZIh8nGaoDBwHY8AOiCDLHiqNleZr01Qs5I37KtsR1509htK25atNA1qwxeam?=
 =?us-ascii?Q?HEbn2E2Irchx24aPN1ygWEZU6APm5+EwzUthg4XXYM0KV0jtCCBX1MgC+zfg?=
 =?us-ascii?Q?443EA1qd2XP83waZGDIPSbX+h1QB7Vs8DV8Bv+OO0+qBIT9Z0XGf9E9vlDwK?=
 =?us-ascii?Q?Bzdmt+/TOq55Nt9MlSzjDcsCjMiuGMdZJVJzRkGPYAZ2Ts5s7lS2LBGkI8WO?=
 =?us-ascii?Q?sbZutB1SBT0UfPOjJAPKljh6wE7EFU6rpORT08rbnp1zPz6tA/9VN6PU72GZ?=
 =?us-ascii?Q?mvxt0eUxnZgwHeQM62kojuKyFUqWeze8CoeeyEl1VviaYCAZ1ZYvAahI1VP2?=
 =?us-ascii?Q?dOyz0H9I46ZAHJZ3kdpMzs4haLLYbpN2TZZofUAkOKMHLz+fFtSQTCNc/0CB?=
 =?us-ascii?Q?M+M86pvefNFDoO2WAciz9x5imhaEMMfKWUzWZEhWE8IhicZEeweJGECv2AeH?=
 =?us-ascii?Q?FYAK1+/5eRZTRZTCIKmVHIPW3hB6npOjB4IywYJP+0vdvKVvEJ2z0B/UmvGg?=
 =?us-ascii?Q?9IVaqYCbbeq4C3LLcPndlyBLgvuPafRCvE6mwAUXOeDxDxA6c1SaHOt1lTWF?=
 =?us-ascii?Q?DcdgNYp1NArmchoRP2uMOOJMxqSEcwLR2HCECqDMWlZLJX55QolT9Gw/1EU/?=
 =?us-ascii?Q?sthqwiKcnqCohVejfgRkInnKJoWZusRZR+I48soinuPRyqUrs5IJPKceurR2?=
 =?us-ascii?Q?htTAUcPqAR36JKVzCw/Ktq4DDJkOIcixCw4iPE8A?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8758259d-bb22-4f98-1f4a-08da6b19909c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:04:37.0539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3cZmexQbx1P0kusaulqhmqTagBpgergc6kCrbWsTBb/6+4VlksMU05HweF4e+N56xKgtaoZsYOZ7I0BHV1Lu+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2560
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 29/47] net: fman: Map the base address once
>=20
> We don't need to remap the base address from the resource twice (once in
> mac_probe() and again in set_fman_mac_params()). We still need the
> resource to get the end address, but we can use a single function call
> to get both at once.
>=20
> While we're at it, use platform_get_mem_or_io and
> devm_request_resource
> to map the resource. I think this is the more "correct" way to do things
> here, since we use the pdev resource, instead of creating a new one.
> It's still a bit tricy, since we need to ensure that the resource is a

*tricky* typo

> child of the fman region when it gets requested.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

