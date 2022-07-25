Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291B45806FA
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiGYVxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiGYVxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:53:23 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130055.outbound.protection.outlook.com [40.107.13.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734BDCC1
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 14:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YM7aEKKFhkme2cM75EWtcNugkIK7+sBHupPiZdZ3JApdJVGL5c/Y4AXmXLSHxStmSkMGZqrQ81QD4ts/LY9WR2nryZh5O0Jz2YZmcEOIWBBibRdftcuuvF4MgvJV1yBOkPYC3z+wQ3SpyFMjTo38VJkk+prmhpaft4XaHIh0n458MsHBjrmb5wNWj7+Ece0WsJOpsdDiLqfllC9R7bVPNap77xni6ZOnsviEbVjhy5dIYFkbeGY3QLqa5bcHznWr48F84LavNpVoMuEMokDKua8P0qqRHwIvHh8X37wlWZR27RJB1hjWMWvV1phu6deDEqSkwFLZzZC3YnAxHtj4Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uGihBT8RwaZVjROKVDPcR6VOpOZN2X71CByqXoG5hI=;
 b=e9j3VE+JyGmNvSkqrDwv6kvgVjFE7YM6RqUsyE00Uq32HN33EspRVq6b5MV+RCgN4wqTJiqU6RnvmKcEPLFyS0cEP0mvjGODRoE7v4dMBoKcHhBGUSNKu1UMvROHXHjrKuLBYNdXvs6Bepoi2VqJ88KL9s0YkcWbz58OohxQHPKm9FWG+SkvLFP4cT/L1tU0Wcu9eEGrv4BLIHINcESP4U9hmSjk2R3q7E4jsUxEWoevuFVt+NPRuCt8oOJzc+S9D1/Yceovh/z2EmaVHzIMgbp6jMf9l/Xi2Mcprw0TSPUfAV0GD9vNsQRnbQe0XrvaZjkwbJbElPKd+0zEwMdxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uGihBT8RwaZVjROKVDPcR6VOpOZN2X71CByqXoG5hI=;
 b=HP2t1FuJ553qkEL1pS/8Io6ytOMZULjbBaOROWh2wxSMkltAFyJr8nQ/iEV0MBLN2PIQrgK3wdBeKt8DMbWmuLzwNvKGZwFCzcvAEa5ia92Knn/0jvxGR2ZC9j24xphG2QYaCorF1SYrV4kqgi2a8Y9stUHJ3LHCEbBs84jeLo0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3847.eurprd04.prod.outlook.com (2603:10a6:209:1a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 21:53:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Mon, 25 Jul 2022
 21:53:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Thread-Topic: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Thread-Index: AQHYmKJbDVvU92lcVkqDHlTGpm7yu62AHOkAgAAD6oCAAAF5gIAAAb0AgAAIHwCAANLpgIAAqJ0AgA3yEoCAABMJgIAAA9gA
Date:   Mon, 25 Jul 2022 21:53:19 +0000
Message-ID: <20220725215318.rc7ip2npzl4g6chq@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
 <20220715170042.4e6e2a32@kernel.org> <20220716001443.aooyf5kpbpfjzqgn@skbuf>
 <20220715171959.22e118d7@kernel.org> <20220716002612.rd6ir65njzc2g3cc@skbuf>
 <20220715175516.6770c863@kernel.org> <20220716133009.eaqthcfyz4bcbjbd@skbuf>
 <20220716163338.189738a4@kernel.org> <20220725203125.kaxokkhyrb4aerp5@skbuf>
 <24e1144d-2dcc-6b33-eec0-f668d51c7a80@redhat.com>
In-Reply-To: <24e1144d-2dcc-6b33-eec0-f668d51c7a80@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9cfab3f-f0ec-46db-1b1d-08da6e881656
x-ms-traffictypediagnostic: AM6PR0402MB3847:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GZBbxn2YnHCnFkrFX9iMzOvg6bQy0Cl2Td3yPUHvCOKcYENiRVVzuK1Ciqd4ltAgSVdZ8z6MNpPP8CD4HKQ8X10qTv+ny12Bs1UnwjzAf+09hOwieCZBfPQjBOAM7rmvgjpP0JEyP8CZ1fXRrrKatmEd1h1HLrJ+vR+I0BUAv3Sg0IdKX8ghap5xq90qclicBGL30M8sVhYi+LlyNerz6X3jy/bWwfUQS1OTAp0fHVJOwY+P9sgF40pUXpCNExM23wKQyzQQkEujfzX1hJPTfyIp5jPaaDStPjJgCrL/ty/67qIlZlajKhREsBfN+qrulVhKSpPRs1o5RP/4LuUgHZMnYow/6k8mVtJN6dwdkOhXZguUyAACuTB9PgVoAWHs3sQeGCXglEWW70GRxLRV3aASzGtUYpUhNU9hacqglsQEsRuxNhxp/XsRQs3oGlmx0wvvrlnTfa+dfGKDCbV85Zpo+HGwMv+1M2shs5hpnP56IW7E91VybCJIZeb0pHvuoknAvUS6GtCdPzn6VYn4RaLR7FCedpafAyOHu3u6UgQilfl2pQ9okiVyTs58yMCDFoKN+hugsWM1JU4Zh3Cnt7+KHOcPB3BFb5Pd5cyqrPaM6/ooO7N0KGngl3KglS5J3nOipRXwTMfDKO6Oh16P06rYMJB6mel9pq4gprc3V/a5E464RDf4ED05HA+zvY71jqFcnViESTBBrfuO0KnBfNT68tyrq/ffU3a7y5EJvwpGhD7Ueff54rhooIPwfTw+a4xkSQ3Y+yZwJ+KPVFDT21y1rVhUY9wsgP9XTDfRzBY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(396003)(376002)(366004)(346002)(38070700005)(86362001)(38100700002)(4326008)(76116006)(122000001)(66946007)(316002)(8676002)(66446008)(6916009)(54906003)(64756008)(66476007)(66556008)(91956017)(2906002)(8936002)(33716001)(5660300002)(44832011)(1076003)(186003)(9686003)(6512007)(83380400001)(26005)(7416002)(6486002)(71200400001)(6506007)(41300700001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GFGVzQjT+VIJLy3eIam5t8/kDahboaHwXC/Pa3WLp8hqNmXai/QWgXGivZS9?=
 =?us-ascii?Q?ZqaEp2ePtjdrHhl+6demqJuFZW2yW3JFDrxqO4fc/rRJdDL5CRkeAZDDdoRW?=
 =?us-ascii?Q?GJvE8Da/MARvTyYEk6pwUTG3oJkiP9ejKgIX041Mnr+mpW+lxo2GdQShIluJ?=
 =?us-ascii?Q?rupxwBxXsxBAqY5Q761QaI7JI8+Yz1m5rp+srcrvWpygLqQ5MEeXdShU/ikL?=
 =?us-ascii?Q?dmrmSMB8DdCM2X9B0yYK1EXx2HQEXLsIrd0961oTfYKAZOytW/PJdhSaC7eJ?=
 =?us-ascii?Q?4ZihDlqDChj6yYWaN/Ci6L2zGmhqHtEQuxsvJ8dQ6GNxbeWInemwdi7k/Kr5?=
 =?us-ascii?Q?uE191iFeQwLY/GvZ8s2fxeDi7xYtckfj+zc2PkRfTRIFa6gDOIsz++u1G1Pe?=
 =?us-ascii?Q?agjdDNweHNIKZ1ZZbA2EXyZ+ClG2eHlbLdw1+NIkn33fDeVkd9TVI+oRNWdY?=
 =?us-ascii?Q?bOyoFzn4WJ6z7NpdjJ6RotRvISwjiCEvf2//Kpy4NCKaUrTBaTAP+eFpX8ZL?=
 =?us-ascii?Q?gjzUvkbw7STQKAVpbGmcEJZRPOGXkI0JeWOI9ePaEDH+DDUmq4vFcXHEh1q8?=
 =?us-ascii?Q?WokC1t0+xbVblCoUDBxH04BsB7Knj+6bVrmA6ZSfihkZm3unsxrm0tkFrZXP?=
 =?us-ascii?Q?sjrOQE6Pn6p/cCslJMY/miJENvWl+B/RWEWZwWdhuEzNC4aX0kbrMf2eMdNE?=
 =?us-ascii?Q?MW5uSf8Uup0KEgNvcWaB8y/Jh78yaZ3RYkNnPr6FTR5UwPkGB6QbltB4F7vD?=
 =?us-ascii?Q?z8j7nFn6L/D2Z6pM9HAKCLwjVBZF2d8LmLedW9VftfOBz5OIVFDo+BIXpDlY?=
 =?us-ascii?Q?GjtYQGZD5AXvjVUQDTkWJBtS7XB6kx30luKNS8YZDFtnbYfx5MLRvnSNxnaU?=
 =?us-ascii?Q?5q44Ny68Ym/vTAiqiSfJ3WsFzXe06eAhHne0ITQ38F6N8xCUAS3P3G9y+7iH?=
 =?us-ascii?Q?pCH5VETWIoCgY7rg1MlpiySSgNSfmmdkDaxCGyCM3l6xaXAQm7MnxceKeLsB?=
 =?us-ascii?Q?q6CfJBu/PDer4O5TzHkDUqARnt48JA/j1wlxXC0GRzw0pytvvo3Oq3C7IUXd?=
 =?us-ascii?Q?Akv+xCvVYRWDuG+g9AU3KatgrMzzKcJJgHQxzf4rtsGLof04j6HrNvF2BxDB?=
 =?us-ascii?Q?X96Q7Td9hkt4QpZCrDBYZL78y4Tp4zLsmhImZ09pFkncy5ciExgLPz4T+yFz?=
 =?us-ascii?Q?Z4NSn4wMeE9SdlbfzXb0AYJ8S1Gyj5SqHCY5kFymcc+AGPzfst3H535bQ0Qn?=
 =?us-ascii?Q?RUWl15GYHHfbV0zYHT9EB90c0k86M5nk+7bwB32HleGLivQkMuhvEhh7oiXg?=
 =?us-ascii?Q?q1oUZT5944MLjr6TMve3nDpP2hAb+X4wIHz0NPNa78bXn1XjmfoK/CoTxS1p?=
 =?us-ascii?Q?YRSugDZe+NdHicw4rx22duvLj+3NDgTCmfqO8XS1Cs0vZJoom5Yj11N1u16u?=
 =?us-ascii?Q?5Vrg/zCemUPNGDQtNWTt/XtvapUlpusBnIpdS067n9waZe/AGATznslmgOtk?=
 =?us-ascii?Q?Dmd20w9GT34DtQljmUAlvXMd7y9Pd8tRkk5rM5r8jrVFxQseF45RklaJk25j?=
 =?us-ascii?Q?IoHucuAyuDGMQOptqTtbipMH+ld6g5ESVHLjKXIQfbqnEvzwr4fEvkCb6h8n?=
 =?us-ascii?Q?hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D39B132FE19054AA5911A55BFFE58BB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9cfab3f-f0ec-46db-1b1d-08da6e881656
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 21:53:19.5383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MwAt/DACpXw4fxIFXPaUaUpdPRjfrwYvS326c6TS/3CLBrJVxJk4r6Kh0by4QEmSxnayJn8eG0EEvlQFvuN9SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3847
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 05:39:33PM -0400, Jonathan Toppins wrote:
> > +	/* Stacked network interfaces usually have NETIF_F_LLTX so
> > +	 * netdev_start_xmit() -> txq_trans_update() fails to do anything,
> > +	 * because they don't lock the TX queue. However, layers such as the
> > +	 * bonding arp monitor may still use dev_trans_start() on slave
> > +	 * interfaces such as vlan, macvlan, DSA (or potentially stacked
> > +	 * combinations of the above). In this case, walk the adjacency lists
> > +	 * all the way down, hoping that the lower-most device won't have
> > +	 * NETIF_F_LLTX.
> > +	 */
>=20
> I am not sure this assumption holds for virtual devices like veth unless =
the
> virtual interfaces are updated to modify trans_start, see
> e66e257a5d83 ("veth: Add updating of trans_start")
>=20
> And not all the virtual interfaces update trans_start iirc.

Agree this hack won't give callers of dev_trans_start() something to chew
in all cases when "dev" is a virtual interface, that's why I said 'stacked'
and not 'virtual'.=
