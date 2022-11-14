Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2968062837E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbiKNPGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbiKNPGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:06:08 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6463B1FCE4;
        Mon, 14 Nov 2022 07:06:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUZB0t5EnqUzV7URNgoMedbOoZhPBFaMsjWm/CE4TwJydqYCJiJvsnfv9e3IexNUjaPELW73OsVzzTMp57bw8DaCv2LibrQ+zbMHZu5JC/nBVyLENL2Cmk9wfUVWzunlCijS8K8KP2OgNmqk87tNciO65nNPAODGecl4+JYiA/4YPXAJIdfl7UAgqOeQYOiNMoa4hgOPzGAO2lo9ADzLwJOnWs0pdAnZptFagYkR+UgcwZpGVfnCiYqhAom2W8zyjzNYBLKO2VvUlbg0LYlTZBATMjDOXz+vCQOHkcAOp/cMm6vF/4w3XA92CKPsnuhu/VfeUQM3dIvCV7mRnhnm+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRpLIB45CoXyuGe3xvvwy2ivaU7/1yAMZD8p4879Jkk=;
 b=Pr0YgMEQxZ/NSxIIEYyeNrm/MQvCG4er4+ui8ZubYrbxZFnJ/araIv23P2CExyWWh6ya1Uz44VS28vQM8o5Yt4nH5A7c9DDohEFR5+ZyDI8naVLlPP8MyqaFD5Ihu4gL/9XEsv12kMgD1cJUuFWtl8rLn6Vujy11/kUM6sQ+GBlhabV+Kqyja1c6ImXHbs4S6UoOuw3PHhHYYk7W7/7LwD9aiMN2AZh1uQzrzxugUHm7FbFcP57podWcuLvqYVJzXf1BF7XMandp5HOAOPjvfBvg4M5Oty6jtcajtxSdvkr+02tr9oHvpIiOc3RRoMXBt0Zmr687Dn0hLyuwpDA8lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRpLIB45CoXyuGe3xvvwy2ivaU7/1yAMZD8p4879Jkk=;
 b=PULAtHk/mvzzK6ghCXMQ0jumOKRzmLgz21//uniVgkn4xNp7FgbBNrNRV2ouP9DoseEMjicRLKfb1GDjUrMHLJBBlw9qB7GyE8S2koh+tHHsU2uAKI91IxZck35C0SADmxgyv5q73yhsgpiDyr2GhU8+2I2acJo+NWsbPjweWMI=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8704.eurprd04.prod.outlook.com (2603:10a6:102:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 15:06:04 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:06:04 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY9eM2DcCGX+tMv0uN92sufUZdVq4+cwAAgAAGTYCAAA76UA==
Date:   Mon, 14 Nov 2022 15:06:04 +0000
Message-ID: <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
 <20221114134542.697174-1-alexandr.lobakin@intel.com>
 <Y3JLz1niXbdVbRH9@lunn.ch>
In-Reply-To: <Y3JLz1niXbdVbRH9@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB8704:EE_
x-ms-office365-filtering-correlation-id: f305c456-fe63-48ce-b27d-08dac651bff8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5mq/mNlF2jbRzarIPBV13DpPjj6oxGAUm3VGGrxDe0XdKAuUia7EzYpySvQFTtbu04eEMRG/uuNzKkp07/TrCbKB6Y0/8Ek8IayqlZKipSteoU3gTcpLmveOxnGe1eaKOZP/A714X98pO06CQiMPhtA/N6xE+07VW60I2atgXUeDggTR+oTqfE94cKYGxV9iv55692a7BwlJOoCSMOHZ8nAmVuGMsSygxKQ5GW0wSghnas+P4ziS5lzNWmgc1rOOM/4O3BIUQNiySeXa/VPJ3yXf87fklG1LsNmMa1TSmcjCOp8LMXvxnoOUPLZZ1058ncqFiFfc8Ok/jY5vXI0i+lvBh7uMUZdiHFipPdsbO0hzeD0BeJcYxhmoKQV22xFGutZAnQvKwJoimwkA28vh2Jrk2Zop+H8biUvOd9PdGevZ6YZkmYaeqnowlxGxedoFNl5guB3ZMgoc0XIwrgsaki+NGPscLK98PpP1W6GqoS692VFu7n2EZ8U44k6wbXISgUNwRiGX5VTDucDTVqeFEA3o/zfXAAS2zIeOELblK1ZH9pBzGwI3d7OMWRfdEESlAiu4/9dCnX3TkETN4k4Rqf+/0UuFnJko6T8x5Tuy8jRWMy8eqE4PLfI3qfvWT/q3xCs6HiwmRKq7zPhsghW6akIlvqGapQFzRom9LFT332MU3ZDDVV6E0rR7eOKAR+ST1m5/+Y9CDW8a4MgdA2EJ5KWg7t0lvDkx4a6NJDRLHgvncBvywqvCtdolN0dCJ3c4EVim8aa7QaFWz5+wMmeodw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(38100700002)(122000001)(26005)(9686003)(6506007)(55236004)(53546011)(2906002)(110136005)(54906003)(7696005)(86362001)(76116006)(38070700005)(316002)(478600001)(33656002)(66946007)(55016003)(66476007)(66446008)(66556008)(64756008)(8676002)(4326008)(71200400001)(52536014)(83380400001)(186003)(44832011)(41300700001)(7416002)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sChELhNk8O7aXdATag6LB2+AjIft5m0L3EwYiwqa0jP8zSWNIfM9TSDz/q1Q?=
 =?us-ascii?Q?w7121sg5rNZU6bt9R/HtR44QbEMLVCGnMhKh0w4Zf4HYSGItiiAc6z0gVpll?=
 =?us-ascii?Q?pY3qgYwyCM1/4+bbTifjsPSXcYKfj7rj0fXcfEggShI57F6HzgEUS+Zh/nu2?=
 =?us-ascii?Q?iLxgpNcKME1kHUAJBosCEIwFyoHpRAXdcZdIy6VesPce7MuB1QU7grZEJ+aD?=
 =?us-ascii?Q?B8VXdUR7Y6BYS9ofbfB7RGuOdVpiQ+/ipsrx9aGST8ByD4ChOH9zgiP/2mqY?=
 =?us-ascii?Q?nBLeXyBjvIDI1uVCxcAampLETFr+fJ/cUG7khqJY8WKVQR8FhxYUDuz0R6l+?=
 =?us-ascii?Q?tTuhWywJpp/p06aTruLxJ/p0NT625uDoNPeNfruyn0MuxykgHJ9GL5q7Epjz?=
 =?us-ascii?Q?EFoeQ/1MOPzTLkvRfldZ1XB5Ut41FEZoi3FXR/iLLXRuoT95Gix3hxGY8V9/?=
 =?us-ascii?Q?NkWA3zNdRHmlegaydQhSxcHLvwzfSVH3nH4hUVQefTd3M3WO7iBv3w88xbJ8?=
 =?us-ascii?Q?Kl4FPA1GjYyXAf2eyCMOMmv5OQiWHLlAQacY4F31lMNtoumKKklU6d0V9UGz?=
 =?us-ascii?Q?HguXnQUXrhxpWijUDQtxevuqyKqMcJ4BktbSQeR2cDRrb19o1q5CYja3ZH7Y?=
 =?us-ascii?Q?XhH8IK9cmUNnUqzFDhDBcP4vNN3q4EZFozTiZuvyMywk5WNdpQoCKxLvp7U8?=
 =?us-ascii?Q?LTnZzrwEGcGMX43AVjRNm3sO8cZ3WxxDUvT8O17wjqYr47iwH++/47BxmkEm?=
 =?us-ascii?Q?nyPDD+owaTw1TxUiLvh6fD+/c0FM0q0seZJ7LmdEcyyfg63Fs1VsvifPCJQ0?=
 =?us-ascii?Q?z2if8dC5Dvv9Jq/kZXwsfPtcQ7cbHxFI/QmD42boCy9Ja5h7ctCpvPIpx8KZ?=
 =?us-ascii?Q?Ei9FMfUx53Btnh6lEIp2AJSwtxRL0STVopCKt8zvxNZwhrWG8OGmqfN3CD0y?=
 =?us-ascii?Q?BGQG+TITmTfA9l5bB/gB4l0UeRKrZTaFmzRjPaGt19e5uawTpcUiqwYVaCiy?=
 =?us-ascii?Q?pCoZuz+JCwOdBXpAuphr8JAR4+/21s8PPPJCdPX6rH8k0qDL/KdlwElRPP+M?=
 =?us-ascii?Q?kHczuSd1JoBXQhFtqBRQWwSpaCsfHi3Li0EMT1ay7lbPn3Ah0/exteFX4T0T?=
 =?us-ascii?Q?xDXA4uycecnFZQamAuX7wQkMXPCE04JI3AUAic/6X0cMJDjz3KAdYXNJy1G0?=
 =?us-ascii?Q?IvIIhNwc1jFAX8QU5YghnthUUNZbPs8ubwIKGwnx4ErrkdvHyYsaRZuDCoIt?=
 =?us-ascii?Q?5ok3tUguYbxKsT9qoc/D3YyaKFqvD8epaqrh+tMIhDWMaDJLQf9q7IsPtwGe?=
 =?us-ascii?Q?LN++bbES6AKtsp6rsBNMEgkpwBdN49Z5KQgKBMxkvJgVXi4Bejkcb6JHb252?=
 =?us-ascii?Q?5DhUmwcZxbiV1iQaeiLPw1baktlHkCvetVpNPPIL0p8LhTLPikqC8qYmPulS?=
 =?us-ascii?Q?iGQctz3deUrF9xyNTHTB/bBDIk3/WOZlcTWzlDMUMWn5TGfa9t1cWUITeOXH?=
 =?us-ascii?Q?fWGqRVl96P8PSWCbqj5BXodug7naMZIkwNe7sKUieWHQQuYgm0xXPERgPGNY?=
 =?us-ascii?Q?Wbal0wEeZFWrumHcfHu07OH79+fmCin4IH0w+p9V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f305c456-fe63-48ce-b27d-08dac651bff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 15:06:04.1587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J7NYUAYag4KvFR92HHwtcRmsNxyO8bS71TPgzli3pOe976bLCUvYCbPOJlcHDI3BUwRTdrgODZ4CqnFgiPcKcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8704
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
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, November 14, 2022 8:08 AM
> To: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Shenwei Wang <shenwei.wang@nxp.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev=
;
> kernel test robot <lkp@intel.com>
> Subject: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool statist=
ics
>=20
> Caution: EXT Email
>=20
> > Drivers should never select PAGE_POOL_STATS. This Kconfig option was
> > made to allow user to choose whether he wants stats or better
> > performance on slower systems. It's pure user choice, if something
> > doesn't build or link, it must be guarded with
> > IS_ENABLED(CONFIG_PAGE_POOL_STATS).
>=20
> Given how simple the API is, and the stubs for when CONFIG_PAGE_POOL_STAT=
S
> is disabled, i doubt there is any need for the driver to do anything.
>=20
> > >     struct page_pool *page_pool;
> > >     struct xdp_rxq_info xdp_rxq;
> > > +   u32 stats[XDP_STATS_TOTAL];
> >
> > Still not convinced it is okay to deliberately provoke overflows here,
> > maybe we need some more reviewers to help us agree on what is better?
>=20
> You will find that many embedded drivers only have 32 bit hardware stats =
and do
> wrap around. And the hardware does not have atomic read and clear so you =
can
> accumulate into a u64. The FEC is from the times of MIB 2 ifTable, which =
only
> requires 32 bit counters. ifXtable is modern compared to the FEC.
>=20
> Software counters like this are a different matter. The overhead of a
> u64 on a 32 bit system is probably in the noise, so i think there is stro=
ng
> argument for using u64.

If it is required to support u64 counters, the code logic need to change to=
 record=20
the counter locally per packet, and then update the counters for the fec in=
stance
when the napi receive loop is complete. In this way we can reduce the perfo=
rmance
overhead.

Thanks,
Shenwei

>=20
>        Andrew
