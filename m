Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00F5587522
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 03:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiHBBqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 21:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiHBBp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 21:45:58 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30068.outbound.protection.outlook.com [40.107.3.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D6913E92
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 18:45:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LniqWTlgrOtJ7b6KJ2+YH8oZuRcF4wE3MDX7xPd9XygnOMuAulEYiTmk9J999QE3qV3v9gAVuu7PMQVb1Ocy6cM+tNKNB7A6DFddMZ/00ZBynCB8FHOGZUg+6FSvd0q6kuUIKtyvp2GlKhWOKWxVE3dyKdqf+ko/GJ2gpXgz7eabPDEmoNDKMn6/Wqxz5qsb3y+BsZMbIiWN60EVgYDGxI9tNd7kbEn34uI1UqUeXJ3+knGVoP0S0f+TMAUeRAM8CbObkC5ooDMXzS7stROsqFV1qEGmvOAGBKiCpQEzzcfUK2xCVaY/7QDBtlGe1RneodqbQNkfa4+vWRuQd8BrzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgtQikZRUVPhU/1mi9DG88RDdr1+dxpZl6IBmW/gvEQ=;
 b=lyOHFsZT1ijSyg80e/pHIsXDL+z/hPhZq596rJCti5BiRbH1enMWcHpQu2BmmUxmcKA6b0VXdcakT8FAGG/Z3nyF1iwDmk6kqjh71WFlTQNIDPw+Rq2rmbEe0YqCMEiNjFC0sOdRGt7qjLZQOH7VZJ7Y6sJka9Wv9uEQk1R3Ubns5+3A5V1PDAr50T8yLiCzMDsjFd2+tldVWvlOPwQYbJJJOM4f2z0NeLkjIHxeI/QVLzcxnW4UwhZifXNAuNL0JI2Sgcsfw8fpjNpl6GdFX216LIqSIxwME038VCsjWQdZvBryvQjCF67iYUnwGOKhAq34AWLSMgmXYg9FA7VaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgtQikZRUVPhU/1mi9DG88RDdr1+dxpZl6IBmW/gvEQ=;
 b=KcS+WL1FY0PbtKeHoY2zLp5HWoZZiCA/h4obniAItAi/ht5IxBYwJ5sfsbXunaRrlPBKwfLCIKM63wevc/Frat5cK/lFngoRPChyCePixGo8i2ErtDc9jPc+EtJr+2tEpTdAqH9lmyESYXp3dNoJeqlmwutH83u1Q3RG4KamESA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7666.eurprd04.prod.outlook.com (2603:10a6:20b:287::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Tue, 2 Aug
 2022 01:45:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 01:45:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
Thread-Topic: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
Thread-Index: AQHYpNrWi6m59GuIdkGFbFAEw5L52q2Y1A6AgAAFdYCAAfSIgIAAC3KA
Date:   Tue, 2 Aug 2022 01:45:54 +0000
Message-ID: <20220802014553.rtyzpkdvwnqje44l@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
 <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine>
 <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine>
In-Reply-To: <5679.1659402295@famine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f67d332-6423-486a-e7d7-08da7428bcc5
x-ms-traffictypediagnostic: AM9PR04MB7666:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MWV5cu0dYAPkVA+WJz+3j9zGt0bo3YJ5cFXuW2Y9wmot94o+LxklDEX6vZK7St3f1UR5ARralxxpTtGh+nwSx1qf2h6XDxaGNxqDdUuzbGlFb6i0jvLO1ZDotZUh//CZJD7yNn47RbEPPc+sRwmBxzuyEDfI69QmiV8Z7QWe5ZmYjJ0Hz/yYsBLWk3N8y/zCkLJLsx6Qjw/NzPSsiVosH6D4JSb74G5urt0HSwrCx1VqE1kfczR26fMbr1Li5J4o7Spyhqlx6lMUgNtgQeLM7WN77tiS5eRaZrGRwVFeU6PDXnRXP12gInoIs/WGCt4XCVsOy8MsFPtEwb9iIKKl59BCDl/ATUwJUKqWxTyTI7UnS7mQLQ9gYkukPWQrw0qgQ3A/8cy7NEt8LTLdiJsZFTEBqY6o9s+5bR+QSPJrAr2fjGacELCT8dDUBIlaVutN1c9hCNHaqmuCAp3rAOfRaCc3cRDRiSoUhJ27sIJrG9xzjpE048l+7db5ZnoyuddlTXfr/3jV5w222ldtPIHtD2baOxqhEdrtVDlqL2SHaY2OkflwxDpdX+wxFLd8AgjthdQQj3b2JTEU0IhJ6vr21iEO7otEB6nRaxSoqplXpxfLeENyhhzXbWACiNn+nc6UUXPNMxwLqks8vzgyj5nsXcSyi6xwSN0cOH1FOdRdrO/wIG4pyAqjC8qycIkfe4BpBMbrsZNDCLi0zwadH9J4UGAvSPs/apRXptVlIfyemag3ENuBxwIBq9ndjJjTAgQNZY952VMIoin0ClPQ3sqdI34mkekgsccT8nN9PPi6/+0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(1076003)(6916009)(44832011)(186003)(33716001)(54906003)(83380400001)(2906002)(316002)(122000001)(6506007)(38100700002)(5660300002)(71200400001)(6512007)(9686003)(26005)(38070700005)(478600001)(66446008)(64756008)(6486002)(66946007)(8936002)(66476007)(4326008)(66556008)(8676002)(86362001)(91956017)(7416002)(76116006)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cP94z7NN74EWNJQIxk8eKUHfLAJpXOpaQuunDcvvOOcMqfrxcSlbqdsz/obP?=
 =?us-ascii?Q?tUNvomaFAxh7UwrYQfq2y2pBQmFqHaPHalM7k6gUUJ/BmY/N7NJg7K/8cdkE?=
 =?us-ascii?Q?+p/DubTncK8rIX9obpVYVz7SHRM2dZ//p2sJxDGct802UqeDW7Tzu8W/WSFk?=
 =?us-ascii?Q?5d0s3TNSElg51wOQm9mbZLhOdk11GHdBNFcllky67vUvxCE73njSwWd56fyI?=
 =?us-ascii?Q?Lx1rEuCbb7n6MHx0AZoUqe4CkR+4Z+vjdmQAEUX7+93OAYcn+QhT5bYagwKR?=
 =?us-ascii?Q?3eMJOF2SlNLlRQir/BkggmuS2OEIEunSa8XM0kGGH3rPQMTXQpLcQZfUFDWv?=
 =?us-ascii?Q?NXUD5HLv3Yg6M4ON2AP7SgEjH2qekbbzvNTdVtdQdwUJGqTWTBe3TR1XDZKg?=
 =?us-ascii?Q?Q3KUf4ejCn1XBdsNie83QJvM7a8L8fQz8tqA7bRfyRld3loVBSJgytNtyZI0?=
 =?us-ascii?Q?qwbwCSZRsWnH7baMDAKzyMY98NijZXZfQ/eVSJ04tBmW5pnHvBwRMCSfDO9+?=
 =?us-ascii?Q?LuXOtospQqL0ww/wo3u1T0+J2xnvEXQsh/QSh/qcFuyZR/AivS9cEcfcZAjh?=
 =?us-ascii?Q?KC3mFrjEHc/kJJ7QuSAfiHpv+buU/T7iKaFWskgGz0SkxYhz4mSeon9qHrI9?=
 =?us-ascii?Q?m+XMmh9bGLAWKyPzr2KvJOK7MTD5sTciurTXt5mLjdGlpVsoophVkWflLsZb?=
 =?us-ascii?Q?QsKH2K4k4vq2EQE37Abkkdj0+bRqT3dZbDYnGiRWh6JYjkQzUZsfufVwM+Up?=
 =?us-ascii?Q?NLkLE+K7/E5HssltjzO2h/Nm5YIwM0+5Ci/tzc5UBxAQFXACGGpVpDwVcAD0?=
 =?us-ascii?Q?Vw59SUZWZTv98zSaKZ5iY6/LE4XHlQwyV0oWc7hFvmWFCg4UGpp5W9S/1KIX?=
 =?us-ascii?Q?HnfPXK+0ImuI+3TGpo6qMPUznSezxl2mSxxm4vCpyFHldYDk3XbziNosnJ6L?=
 =?us-ascii?Q?bU/sFJLMk8OOUC0lOeZULPpj4qpPVtWGJ44VVY1dpazh1KEOq6Wods2Adw2N?=
 =?us-ascii?Q?v6iixHIjkHQ1KvvVdJWRvB6mb2P0IiADAquUOhtDhYNGqPJJqOOUbVnkSwP+?=
 =?us-ascii?Q?SQr0PR2mLBhgtP2geIyAwdeBLaqVrqunBpXARkbmbGiEIjdV7eq9KLtN0oto?=
 =?us-ascii?Q?AT7et4DOlo13aoFtLSH6c3p7aKN0I6nzCXtbRlreMknBHg6OmFSSyE4rg1P4?=
 =?us-ascii?Q?IjiIV62xjuRMenWxdmRlJzbMlS12MbGUTmzNo4wvJ3i7xc93RABQo0aoJSXB?=
 =?us-ascii?Q?yz5TIxdW71AzG/b9Ga1wPhWzkiLw6K9x8ZV39CL4a+l93046WKUb9QtYGkFC?=
 =?us-ascii?Q?oWfbhOdQsdAIM4+BIFprxtb2bboS8gIunQ8iwH2ekvPSKd92GXOH0srULq0W?=
 =?us-ascii?Q?fo221YLGz8Krndm8DoYHZF0Q3soj15njdxNtljbc7ea2CBQkpfzmygiUFUhn?=
 =?us-ascii?Q?RlGZWE0kZcLFQDIwP5QFCud5AyTHLZFHgki+2oLM5FAONzgzuTES/3c7I6lF?=
 =?us-ascii?Q?WFNeU0MZXYE99dCez5rHKgB9TGRKTLvSJ5s3wU57T/qsPdqm2q++Yh+CG8OZ?=
 =?us-ascii?Q?BLrwckrluvvuvll7HkHLzhREelxu4yc8KEpEMbS/8gDG3QpQK5dMEdkt/2RJ?=
 =?us-ascii?Q?Vg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <83AE2B0FA1541F4FAE8B2DE4F103CCF1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f67d332-6423-486a-e7d7-08da7428bcc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 01:45:54.0634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AO/1qKKxmBqaEST0oFo5P0Qs8muD+2EllObBc1GKgLFgasgt4HDigDy/i49nhFaeCWon/t1PaDqEwEN6USKfKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7666
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 06:04:55PM -0700, Jay Vosburgh wrote:
> 	The ARP monitor in general is pretty easy to fool (which was
> part of the impetus for adding the "arp_validate" logic).  Ultimately it
> was simpler to have the ARP monitor logic be "interface sent something
> AND received an appropriate ARP" since the "sent something" came for
> free from ->trans_start (which over time became less useful for this
> purpose).
>=20
> 	And, I'm not saying your patch isn't better, rather that what I
> was intending to do is minimize the change in behavior.  My concern is
> that some change in semantics will break existing configurations that
> rely on the old behavior.  Then, the question becomes whether the broken
> configuration was reasonable or not.
>=20
> 	I haven't thought of anything that seems reasonable thus far;
> the major change looks to be that the new logic in your patch presumes
> that arp_xmit cannot fail, so if some device was discarding all TX
> packets, the new logic would update "last_rx" regardless.

I don't see why it matters that my logic presumes that arp_xmit cannot fail=
.
The bonding driver's logic doesn't put an equality sign anywhere between
"arp_xmit succeeded" and "the packet actually reached the target".
If it would, it would have a very broken understanding of Ethernet networks=
.
For all practical purposes, updating last_tx in the bonding driver
rather than letting the qdisc do it should make no perceivable
difference at all, even if the driver was to drop all TX packets as you
say.

> >The problem with dev_get_stats() is that it will contain hardware
> >statistics, which may be completely unrelated to the number of packets
> >software has sent. DSA can offload the Linux bridge and the bonding
> >driver as a bridge port, so dev_get_stats() on a physical port will
> >return the total number of packets that egressed that port, even without
> >CPU intervention. Again, even easier to fool if "have we sent an ARP"
> >is what the bonding driver actually wants to know.
>=20
> 	I'm not well versed in how DSA works, but if a physical port is,
> well, discrete from the system to a degree, why would it be part of a
> bond running on the host?
>=20
> 	Put another way, what sort of topology / plumbing makes sense
> for DSA in conjunction with bonding?

I won't insist on the details because it's going to be a never ending
story otherwise. The point with DSA and switchdev in general is that,
even though we're talking about network accelerating chips that are
"discrete from the system to a degree", they are integrated to the
network stack such that a user wouldn't know that they're running on
dedicated switching hardware rather than plain old software forwarding
between any other physical Ethernet cards. The deployment scripts would
look more or less the same, they would just work faster and with less
CPU involvement.

If you want to enable autonomous forwarding between 2 switch ports,
those 2 have net devices, which you put under the same plain old bridge
device. If you want to add one more logical port to the bridging domain
which is comprised of 2 physical ports in a LAG, you create a bonding
interface and put the net devices of those 2 other physical ports under
the bond, then you put the bond under the bridge. The DSA or switchdev
driver monitors the netdev adjacency events that take place and takes
note, in a "transparent offload" manner.

When a physical port is (directly or indirectly) under a bridge device,
traffic towards it will be a mix between traffic originated by the host
and traffic originated by other ports in the same bridge/VLAN that must
reach there.

The same overall goal of "transparent offload" is what makes it
desirable for DSA and switchdev drivers to report to dev_get_stats()
that their port counters are actually the mix of autonomously forwarded
flows and host terminated flows.

The conclusion is that using dev_get_stats() is just about as
inconclusive as dropping the last_tx time of ARP altogether, since with
offloading drivers, the hardware counters will be as far a metric from
the answer as you can get (you can have tens of millions of packets per
second forwarded without software intervention, and the bonding driver
would think: oh, how many ARPs!).=
