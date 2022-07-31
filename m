Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529DD5860B1
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiGaTNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiGaTNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:13:32 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2059.outbound.protection.outlook.com [40.107.20.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF82B65EB
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:13:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OphTEN/aKJAUTfo7KiQaSdsTwwjeNUj645x5GmXwfQ1ssNpRn0kBQ3T5f4Xv/1G8yFUBxtMEUASDli9UWuFDJruaLoZtMNrX3bdy54ydTiKN0kgDl/lFeWl27ejS8AKr1nPMyziCZ+P8eA68MnwqYaWNoRyxte4boCK9ai/I78wRWds52MUpoevWH+oV5E6d3beW6fOnIMvio4jF1wMVHS/51Nv1foUdHfZ4jz+xGxsY3DrmCS2ZLZM/92uXpOXRm8R/BPJtZOR9Xn+IXsGHOdK/FyzRqeNg4/4tIKKF68c11ZJmcK3B8Z1mpRESqoNnwKz2k3/ENTkf6NFASU1y3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCxSiiT12Dgw/Ie//5bKhoV4A2FguSxIWltmbKp2AEE=;
 b=D44338tpt5haQnAUaJtpZUYMQ7N3DfczsbFV9SMZRdF8wZ7y7PO74mxZivNaFmYvwhhiYYWSWEt1FbpSmR4RzizkoOgK3kIj77fP/TEJThA5vnGvLv7yAyAfNumNX1O80Tjn0+otfePmyx3k1XaM1N5+ndH4py3igv3igo9+gniM9IL3d9auD9IYrj/+Tme3P2K8JK4o0lZJZ6WY8YSgiSjCtMQHq4LN3GnIykdtc3J0UeZTu4foCsXLDkd5+toFHXoxydLr9RXfu5ik3GvBPb1GytjsHjOk+fAmJOc8gLnmXBh8G7w/1thbjhiGR3EyuSzUwyoMhZNng7E1b5hGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCxSiiT12Dgw/Ie//5bKhoV4A2FguSxIWltmbKp2AEE=;
 b=pwPuKRjQMdX083BGzg9jQRqVAcETRSrW4ajm6P4yJd3YGk3P+sBvQf+MmXG0A5JFcTTZ8xchCcLQD3Rgz4ktVkxGooUmOAUC+O7NB8YUCwz+JptaaZy7cwkWs6SK84NTYP8I+2sdCWaEb0z4KjWAYnRbfjrpvyygmnmzvg8Xvv0=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5327.eurprd04.prod.outlook.com (2603:10a6:803:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Sun, 31 Jul
 2022 19:13:28 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d56:7a8a:b972:ec20]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d56:7a8a:b972:ec20%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 19:13:28 +0000
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
Thread-Index: AQHYpNrWi6m59GuIdkGFbFAEw5L52q2Y1A6AgAAFdYA=
Date:   Sun, 31 Jul 2022 19:13:28 +0000
Message-ID: <20220731191327.cey4ziiez5tvcxpy@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
 <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine>
In-Reply-To: <1547.1659293635@famine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b454502c-f175-4034-d160-08da7328bff1
x-ms-traffictypediagnostic: VI1PR04MB5327:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DdwAmJe4kP9StsE73KfIUgDg3GB2qpxFLvFhFms0bmYzWOM5aO2jfh8SaJmDFG70nwEkreyxCRrZo7r7ot0KdOGHVanEGchSPq4Ua2Glw5Hhsy+i52HcpJ2NQBHn7XSeZu9oU8SWzURj04gK7Gu4p8Nn2+TBZ9x4G0+4hmyaODDO7waUFens612gIDmIU1OH+mAqmW0apgMHi5dut5j6My0472L4+g5nrHDnY9xl//N7Y0c2HvBXnbkwdM9ol1E1EGiWw34Cuh4fYK5f52vdQqUE7K2574BarbJbvrYsiHir1UwKs/Hr8BaZkAcwS8YYBQPUblS9n8VQaEi6ZvwR8zZhHnxU6QA54BCbyPcZhVov30VyRhctVjFr2dMxnJ9RqL/7Rcl/e4Yk3RLo274wpJmmhKnh5b1CnIElHAh4+tR8dJYp0h3sExIkFowWv//9DpPKrsFI2DVdkNG5W7vnFqqNZBrHdWbUCUqqnGJwD1FUhbO7vb4A4Lw4Le2f5sGJtlc4pViyIhw1bRyXR8pOdJge4t6fw5vLcx8jm3xh+PpZH0zl4iInJK/fOm6S+8supA2D6QOsYTMRMAI0k+iu2j+rI5veNGmEyGGv83vOsDfKuJbkkIeNMDda41Fd6E3Ar0v3trloN3fKfUhNFPUM0YWDPT1NkiXIojj9deJPN0/Z7pA/70ml1SewPafgMo1dF3A0TCV7CprA99mY0yhd93XRC6Q/0WJYR0v9ghTiwbbHiFw5qlOWwPCYEmOGsyl+R+bYbLvqggu6zHW77qXBn6ohCguF69a/uFwHXZPCqto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(346002)(376002)(366004)(39850400004)(6512007)(9686003)(41300700001)(33716001)(26005)(54906003)(6506007)(316002)(6916009)(86362001)(71200400001)(38070700005)(478600001)(122000001)(7416002)(1076003)(186003)(83380400001)(76116006)(38100700002)(8936002)(5660300002)(2906002)(6486002)(66556008)(64756008)(66446008)(66476007)(66946007)(44832011)(91956017)(8676002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uTtYtNowOF7N74CTw3yll6qeXspf+i/7akq/hjYjWa2yDGAC+VK/F1dHWJDQ?=
 =?us-ascii?Q?epxEXGMVxDeXqojk+PCzKQ6FhrmuuH/Yi6HC+Xs687F2sM+D2/HYNnzG4xGu?=
 =?us-ascii?Q?OgL5qo4MaZ2UyW2iZCqR646zoudm6Ql9O/DohIQnoiT9wJSgyiLPBqxlXeN4?=
 =?us-ascii?Q?diYlQtDicG/qnEzeEcriO1KNtNieKHvP4MpqCM4tS2MPSk2+Jqy5RuMqn02G?=
 =?us-ascii?Q?CV6kBLoY5Po/RRsS2hZKzdwzebAior1+ykyhGQZz5W2I9Hxlt8jRkiFdq61n?=
 =?us-ascii?Q?03dwkEedcPN5HAJ8s++D60uo41oHD4KzDCTItVyjieQ9f0lHZxfryFnqeVCI?=
 =?us-ascii?Q?I1rtwyVKuyVt5sL8+pDZ85reuJqvbw6H7ZtwRTyiuy/HlBj72B74redMDZY/?=
 =?us-ascii?Q?CzrhYxL2uc6qHoTQySIKMtSNGQ8ghKlirIEcqD1G0lp6/UAbng13/YXOqC67?=
 =?us-ascii?Q?S26lat9hCAEurgAzmJJPnri/mRcWMCNFYAKn1NER47A0/TvxJ6XApWCyD1V2?=
 =?us-ascii?Q?W1/+FA03UQj+2kPrE2JV2U2fGp6Us4yDgbg47RqnPgdk4c6y8tJYKJ79av4v?=
 =?us-ascii?Q?4/ws3eAL0DySWtPvUh+luQaFrdqoFyG16QEglUNWhSIYWyyyODChkcFXQhew?=
 =?us-ascii?Q?btqk7dNdOX+Z2UAtcaG/dahmxyiOtUw84ZXval4a/RKdDQV8LKXiLnqdWLcC?=
 =?us-ascii?Q?0ICne9NMkE8SdewW62hzYsojSKYa5HAhf3Jp1H+RdJBcVDKAsLIBp5hJUACT?=
 =?us-ascii?Q?1cHvlW0MRZQjYdSuV1tZXWl39g6VYxs0WSlaHYgAlwcCnPzRpk+6C3oMEK22?=
 =?us-ascii?Q?yg+mOSucT3Q5FVESQ1Az7bEvFe5NkDXerZ/J+CKtym1v7fAQx7BO6pBkFnGh?=
 =?us-ascii?Q?+iCREdD9bjKu5J1rer5mOYaDLRm5SibOOnvEd+VJQeQfAPNPH5JnQB0koCug?=
 =?us-ascii?Q?UClk+erReG1+tK5BjWjf+87KmtReRTJZUWQAWYWo9uQh1dPheQDsWFp2MVa0?=
 =?us-ascii?Q?tjRfjTBlJSAUw1fes7BWA0U3vgeFd7xNIv7dqzP+in6IuYTOKGGTAxZQVO3x?=
 =?us-ascii?Q?RCq+kBy1LPQp/QSPijW/zbSM0tOJhhtX31BWy8Q3ov/Tz93UqtcXxQ4Kx8D3?=
 =?us-ascii?Q?OOmO4q9MemU5J01p3/NB6x9uYyxVCOynIRwYqx7bBHe8GUvgZAix+h5HsWo2?=
 =?us-ascii?Q?Q5sxeyNOV7kHawfU7jrsXweWcKicFtRtEhTRoTYir3jQxnB+gJ6NG95lREkl?=
 =?us-ascii?Q?x73TIQrZQGUKa5/e8e2muvEEenhfhEN3x4mAJtz2d6fMvqMRSBZ+7IMIlpxC?=
 =?us-ascii?Q?M/rtV/J6/1VVzHFBpZgNLRk2B3wPYfimZos0jUP3SNQi+HdAFD5lq2NHvfsz?=
 =?us-ascii?Q?0U0B57c12wfUjb/ciPep59VnUk5ZN0tpE+AhQg6sbSjwogV51ldfa8huuiOz?=
 =?us-ascii?Q?7bdrxs7MW0ZLPuukdlBd504+SlnWAHc7SGeXJlwaIs7x9mMig/WMHx1MHluH?=
 =?us-ascii?Q?xP2OSDfkLyZd09Fc+w2lMzPLCZxRQtCO44ClRjxrOvN6PYkKAVWsIDnYPKvk?=
 =?us-ascii?Q?FRuc7Pq5I2OfwN3DORGsgJWAbJVQnTY4IqEyYnnCWbPurMbJgFFghLq0jJpS?=
 =?us-ascii?Q?dQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <51F9AF30D0DBB04EB7A9E5575FBE1D77@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b454502c-f175-4034-d160-08da7328bff1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2022 19:13:28.2216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/dnyLwW7f/mChrd4aUoGqDRRJjNmrbhVvQFmWpyCeTQ4Ius+mnLJjL/hOw651ObtGCJaJc65YYNbqLZXdZEgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5327
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jay,

On Sun, Jul 31, 2022 at 11:53:55AM -0700, Jay Vosburgh wrote:
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>=20
> >The bonding driver piggybacks on time stamps kept by the network stack
> >for the purpose of the netdev TX watchdog, and this is problematic
> >because it does not work with NETIF_F_LLTX devices.
> >
> >It is hard to say why the driver looks at dev_trans_start() of the
> >slave->dev, considering that this is updated even by non-ARP/NS probes
> >sent by us, and even by traffic not sent by us at all (for example PTP
> >on physical slave devices). ARP monitoring in active-backup mode appears
> >to still work even if we track only the last TX time of actual ARP
> >probes.
>=20
> 	Because it's the closest it can get to "have we sent an ARP," really.

Does it really track this? It seems pretty easy to fool to me.
I don't know why keeping a last_tx the way my patch does wouldn't be
better.

> The issue with LLTX is relatively new (the bonding driver has worked
> this way for longer than I've been involved, so I don't know what the
> original design decisions were).
>=20
> 	FWIW, I've been working with the following, which is closer in
> spirit to what Jakub and I discussed previously (i.e., inspecting the
> device stats for virtual devices, relying on dev_trans_start for
> physical devices with ndo_tx_timeout).
>=20
> 	This WIP includes one unrelated change: including the ifindex in
> the route lookup; that would be a separate patch if it ends up being
> submitted (it handles the edge case of a route on an interface other
> than the bond matching before the bond itself).

The problem with dev_get_stats() is that it will contain hardware
statistics, which may be completely unrelated to the number of packets
software has sent. DSA can offload the Linux bridge and the bonding
driver as a bridge port, so dev_get_stats() on a physical port will
return the total number of packets that egressed that port, even without
CPU intervention. Again, even easier to fool if "have we sent an ARP"
is what the bonding driver actually wants to know.=
