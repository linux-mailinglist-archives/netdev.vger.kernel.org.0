Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6E57CAFE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGUM6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiGUM6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:58:15 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045883AE6E;
        Thu, 21 Jul 2022 05:58:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0aCOP0MPrCynVY8ygUroNhUMdURJ5MHXpaRO+gOws/nvSvuPAHwjvaDsEqNFp6yWcw3aAgvBB8BWmgAG91mKMIvdr9/IUk84EmsJKUNrx28NZnRW4hQsRYI1CbdrmdIIrhLutbQMp5QohVb9dxouvsCaHg4N4lHL/D0tYjfYeUKGKLJFz1urEqISBnKv4l3FelnlY4k+hZprdZ9oWP9c/Ji5jD8aAoHvgO9FvnfqMwzYRIQWGHEwQWWdmJ43+qzst36Xw3iBqR3VxcjYw24nvONFan5wp/sKFFUOBi947jPHzZrDbhroioOM6ImNVpv07asdaM6pBTWsbV9oIxDSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYWmLfppGz/JhWFCbKKUwPTjBWtGclog5nA9XATtWvQ=;
 b=LVznc+bo3szI6xllgvqTQZJZAFxVMnGaGqPf3+4eaY4zYFrw9j54Il5afECVOQ0dK8dYexa93yNftaEx9DtoPwheOHT8Vbj0qhRKD6oVfCfGnjY8ALoLavhABMrQuX0ks9m1ii9hX9JJPiQ60H3A0xM6Ar8ShxX1gEQ5/3ObsVO5dqQwW9cLIX6ZfyIhN10+qw5Feia6UixgVtqfE9Nc0P4e2MeFmkVbKH+stD8h5uJ564V7Q874wFLVjW88n8Hxt8B7KoGVOFCwbb91fXDHsYXXL/NZ21HYQv/SXXSIfJ1fynvM2h3vXzA7kOblbGVZIbKtSwkjZN1nE/uhhpqkhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYWmLfppGz/JhWFCbKKUwPTjBWtGclog5nA9XATtWvQ=;
 b=TMMZgMQ6zUT4Pq5IfsY09L1CTlhUOK9oJ0UVcSUtVTC6x3O3u5OhoFW9lh2eL/8AzZhgD5QyjZLQZdwv33oOK1R0/LS7v07RQZSmLRjOw7K80MHBH5J3xkMgopFUXRjG1fSUuEEzdhJzQ7hNJPhib6DH0p4JvnGXp0Ce9kgS9ws=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6671.eurprd04.prod.outlook.com (2603:10a6:803:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 12:58:08 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 12:58:08 +0000
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
Subject: RE: [PATCH net-next v3 23/47] net: fman: Export/rename some common
 functions
Thread-Topic: [PATCH net-next v3 23/47] net: fman: Export/rename some common
 functions
Thread-Index: AQHYmJcYSZNZxqMlOESxmhVa+zQKN62I0b0w
Date:   Thu, 21 Jul 2022 12:58:08 +0000
Message-ID: <VI1PR04MB5807CD84AA46B1C82DF47236F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-24-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-24-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe8dddef-9ce9-44a2-ae34-08da6b18a90f
x-ms-traffictypediagnostic: VE1PR04MB6671:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: StRH+twB1kUf+bkGzQledGLC0lZpJQmrupY3Bp4kGbpLFOIrOSX+pUQZz7HR6uvmvG/o1kHuR2UxN2cqoP1cIyUaFT7BBPwm0yTP3FtYtf2P3+8z//nX80ykuBO1gEBswPZ4MjCCDB8oVO9fFGtoTNspljDW8D5Ymsn8Gysx8bejrsHuFJw2yxr2UbQAEU3YjXD9DvyY5G7NiobNWquuUbAujCbkN5uUYOkwHk7/QCgg2/5N0WxB6zpuJ7UerLA5zfkPk1Sxk7XRZQpLy6Dy2IwcHQA2mUig0zJ5QEAtqyycvUiiTZSZN7Eor5KcmatxTDXhUUQqZXu5b2TtE2DDP/Wya0pCQBG5TQY/OkkjNskhHUEJCAJqNvFsP5iNuUSlrJfP66Wqj8tz1ZH7IK9q+CHahR8Hx/pwBXXzQDFG+FZtzPJRMNYzQCrwfRNyy6A6mU4nH2qJJC4VLlJbcAjWmh5ONMLxwT43StDeMKECxXemHNqUMQtm4J3qYAqK6SoNkfro1E4VscovgJk5NMUjkS0cMGbqSR6cb85K0Fug0O8MzVarF+aPz8GrEFn4Rz4FDxT2VSz+N4V6ra+yiY1QzkmuWV4W45rBcH7bV5KGOVk2+ZSV6017KmiUNu5OL6phl6QUiGMwtHp5Bp4P9V6FSxnOoWpM4ByZH7E7n9a+V2fS324fx1647e6m5yyrg1uWgql7Vkg+YdizJ3b5o1xlNA3ES8iQjNZtRWdejbmDZ8hqsW+XaB0JH4wJSXGMIjnmuU0QAjVBHXY2XO03BFSOlK59cjcbw7Dq/OXj8IO4F5g14l+EUTNiu0kpuS8oEi2u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(38070700005)(86362001)(83380400001)(38100700002)(33656002)(66476007)(64756008)(8676002)(122000001)(66556008)(66946007)(316002)(4326008)(55016003)(66446008)(54906003)(76116006)(8936002)(52536014)(4744005)(6506007)(26005)(9686003)(7696005)(53546011)(5660300002)(2906002)(55236004)(110136005)(186003)(41300700001)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JAlsgedWk+nleKehAljHegT+bPuoQPq+9FcwikXtRp20mANj+zepQUkVIWyC?=
 =?us-ascii?Q?CoOfoYWYNxGzAbCV+EFTy1At9kdm1cGk0wE3LcRvyhW4f9t+3CT4HVog1W+R?=
 =?us-ascii?Q?FUoNzmPv8gTwA9Na/BwjsJGQFGe93EC5vsJXE4YHxhCZYojBD0XETsrmD/l6?=
 =?us-ascii?Q?2Vz1ScuXkb6VSxCsFCpuC4YYROGG5RUWnwq9ihf72idIZxOU2ignmTCpBl3c?=
 =?us-ascii?Q?2+9PBiY4qo78XRiyCNpuP7ymXw9uqTbGWwktY6z4rTQIqu4aXudbKijq07iT?=
 =?us-ascii?Q?kq81sDVgkIZ8XM2zCb3Ztpi5prFMqeHXk2X2NIb3tkw72mihNzZMXaTSg9OQ?=
 =?us-ascii?Q?b3PbMjxFU2P2mfZrd6aOdfnJYX4Mj5C8BTPkMiP1jhdyM50SbWXoU2i8VWye?=
 =?us-ascii?Q?P2HjBi9Hekjbkp0REdYdISvBFt0qsXK6reE58VisgcwCgXPSF1anrjWMcBN/?=
 =?us-ascii?Q?ZPmSRsWa5Ca0irnjcCTs2sNNKnzwEirpI0IgZLoRr2h+8orJQqw7HZghA3VP?=
 =?us-ascii?Q?8ZFTyZa+VEg/ZlC+YfIBQWXW/9jI6YnyVHHiBQz1KYGhJgf2IgIPvYsUgnF3?=
 =?us-ascii?Q?7y/UhKspBDCJJkdEQNT/nKpw8+sHwetdXfvhs2Ywjdtb9gZXTonln9AfuThX?=
 =?us-ascii?Q?VJlsdxTuMVUDLr3AC0DyHbJ9Q4Q8n2QrecxmC37hKXPOQEuvylZ4nbA3Sy2a?=
 =?us-ascii?Q?soNexxEkWDQjNSFnxea+aGa5D7YJ3ajzk4tDELVVIEVWRkpEvGmApLpJPKVx?=
 =?us-ascii?Q?YXTdrHCjFGbKXYvqbNp1i3955how04rvwkByzantqnkpo1VL6duUnQ/GSNfv?=
 =?us-ascii?Q?Ehmi/2LpeqS7yCrvtTYrBj5LIx5SGhJJN3ch0PR+lhsYX/uEbWN4VtvgzkNF?=
 =?us-ascii?Q?ypivqI2jpK0oFBJDx1J2Jilpk2HTWmjOeZtD5dMstu1ZS7ae2ei713d+fjVH?=
 =?us-ascii?Q?ha6EGyp959rho9ifySAcesh7MvsD9Cm3nHr3mTNhZHqj8Xso8loWT5bCZA3w?=
 =?us-ascii?Q?UJseBzvUCXn9DjAGkV1vw/2y7MyVTVbQPZu0qQNyETCcloWGxyNo++B7DRpU?=
 =?us-ascii?Q?XyR+Dkjmb+uMd2g42xQXkXftV9Zw9E8DQYMl8WpOP8Ia/d983PCEo11NtuKI?=
 =?us-ascii?Q?HAU194h3W94WsCVSMiVABzcADTv+nmvc6b0HbtUbjhc10t9Hn3L/YdY7p0yJ?=
 =?us-ascii?Q?XgDwlv6GBQd7WlzG/5xF2kWCS5DM/r4tgb6ThU43HijdzF8nL3NK36wzLWFR?=
 =?us-ascii?Q?qF6K/KlCg0uq4f1QPEGizfAUnOGrdFhyRQVwLIjp91IEtFdw8NshBCGJGyhV?=
 =?us-ascii?Q?IiXmNmjwr7kGbJE6PcOW9GbhzN8VFceatxx54f2KRmIBlKO/paI0nsurk+sQ?=
 =?us-ascii?Q?PwAndLF2Q/8Uj62pOaFlXV4KWb2YM4bmYl12Ryvh8HVvg+N+ac2neX4GDbM+?=
 =?us-ascii?Q?1ZB1ViCTWpavPHzHZ7XExdD5lnDm8fKHr8V8piWnOqmCwEZRxYnN/mhp+Riq?=
 =?us-ascii?Q?/bFU2Ei+onQlrzv6pwDEMulGs+pfqzQIUZdSohBtvzLxMSWKmM5a2oQU3IMo?=
 =?us-ascii?Q?U+GWoz+tcFZq+c1qew+w4C19bi9yzu704Mw9W4me?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8dddef-9ce9-44a2-ae34-08da6b18a90f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 12:58:08.5798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MNr9zpQdhQBLlJUk8ESNmIADqYNbNAHiRPBDPYrZH2QPy6kBExxctKIlgW96oNUiy8fcDuOM68W29xrB/+K7aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6671
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
> Subject: [PATCH net-next v3 23/47] net: fman: Export/rename some
> common functions
>=20
> In preparation for moving each of the initialization functions to their
> own file, export some common functions so they can be re-used. This adds
> an fman prefix to set_multi to make it a bit less genericly-named.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

