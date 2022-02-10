Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3AC4B11A7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243576AbiBJP1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:27:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiBJP1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:27:16 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ED7137;
        Thu, 10 Feb 2022 07:27:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoH8Za5fDiV49yHZUwXSdlRnmeL7ol09oiBUGDWjyVYuUi8VfKzCc1N6ONYGPrYvrjutqFBk0P7OuOxtTI9bkKysygjuZ8M6uoubINdCU1diSostvb4f2sM0nd7aLTWldKkXWmQiGKmc2S9CHBXACFm0laTLfQSRAoX1+SX0mZmHXkcZZaPYUkUZ+7KafZ7AzDyXbzOnTOKwQNQWJleJijfy/U+jh93jI71t7wzwv/AKNOie5loLtOF/KtTU2BG+x6DAYOgK2AIybfIfNZnHoSs0Xmkmt7Yeg+Ijk2Y6P9nPxapOiMnn+dQ4EcNk5tyrfvdMReXpzDcMMzwopevyLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXEgtZMJSY5CPFBVEFCs6L6h7nOn/rKu4ZESElxL7wo=;
 b=S7P6LkwiGcIYDEawQCuaXEHQd5TNx2OoyS4/oqyc9Ww326faTK7xzM1/1GjzDwJPArL9w2BKN+rKg/UiMnLmzZeki9PmkVbPtAX+0badFGy/vUSXEXoDURtOMKx90oIy1SAYC5SuazrhL0PpqIPMByS6w8nBiIx1jncXqSbDA2MtjrzQbRVIOxIcebMjvtkpC3f3YHfvNYSMQ0w66yFSrHI1M9kk758kQooCW/Ta3Z59pLw7uHpwfyuOUrKXk44le3uk2Su2bjZ5UYDvWKuSQuiYVCWdV39wuqCxI6qk0yo9Beu3xO/RWf+dpU990BlPkTw6/LSfVu1FuBYS/jCgdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXEgtZMJSY5CPFBVEFCs6L6h7nOn/rKu4ZESElxL7wo=;
 b=jG/cqmnjdUNv4+e57OPqkP0bS7Ew8Pmkt+R/Tmfw7RSUZy0gg6iP0a2wx048OR91E53LS2aX6p5bl5SmR89SEb9OhRzbZMICJ7JXWT9/OlDTDCJDphTq8YImGbYtVu/FEHofxfz2aAuunBo3K0LAC3RPZnb/MIeT4581FO6nB0M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4730.eurprd04.prod.outlook.com (2603:10a6:10:1c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Thu, 10 Feb
 2022 15:27:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 15:27:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHjTfHymZJxNNSUWpsn5mKney/KyMl74AgABPeYCAAAG4AA==
Date:   Thu, 10 Feb 2022 15:27:13 +0000
Message-ID: <20220210152712.jchztf34gf3pgsyf@skbuf>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-6-colin.foster@in-advantage.com>
 <20220210103636.gtkky2l2q7jyn7y5@skbuf> <20220210152103.GB354478@euler>
In-Reply-To: <20220210152103.GB354478@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d6d6293-33a0-4211-5904-08d9eca9d012
x-ms-traffictypediagnostic: DB7PR04MB4730:EE_
x-microsoft-antispam-prvs: <DB7PR04MB473021B311F1ADD0AF3A4637E02F9@DB7PR04MB4730.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q3Zf8HW8TIrWq+BapLf5JSfKPNfF1MtT/+JcYWmT5QhZ8WtP3BIxgnK0SQrufawwdfXRKfGAe41prNSEVFhdHWuLe86hLcOqFVKX2T1CRgMfipTk8FYTzJZ22FhSbkBgRIvsegaNmJ3Z0NWWDvUypIHHO/8XlW9kXoZhvLaajJWAM4x7772uVy1JXKA+Htr+dh3v89QBD+PIqWcG2BeBqHFwf6av4UxbaGrJn9d+4ZgAkKjg0z8H/0jmGkt3Acwx/TuXmUL07NFKF+b090zIJkgVHmzJN2gw820vmeffBHWaDqOzz4Z9k8mLtmnTcUWDcfDsxVymQdcC0NRlHQNnTzBiKQppDKyEseJT6tfYZXqcyPSf3iHAM36sdELaPlBZgsxrrwoNWHr82NgeYkf3jaUxPB6bQpSEUeWYrh8qgE3Z+3rlDxpPO2cZ6K3vm8zYBWV+X8vkZTfAXbllX9yCWl3l7Cep6vdnyd8gLnp8GVSO8yIWm3xdwidKrpJIfqNieoHcw4ut07xMzj4v57Ujt8CtyGg3wwNrRKqAehxeFLsu32YRAzizE72SbX0wYyvxK0Q3VfpwjB9SpS0PWyReRi0ilQtRsCDxXzkQC+yDtP1Kn5H9qx6wUoHPLoP8JF0ymlmC/2o1036H/4445/J32ww9OYptQvxEke8uO6dRozEu8xW4osKeTSpkHB68M+qqC0918EEJvryFEg3ZDYAViQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(71200400001)(54906003)(316002)(91956017)(186003)(2906002)(6916009)(4744005)(26005)(1076003)(38070700005)(64756008)(66446008)(76116006)(66946007)(4326008)(8676002)(66556008)(66476007)(508600001)(9686003)(83380400001)(6512007)(8936002)(44832011)(33716001)(6486002)(38100700002)(6506007)(86362001)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iyYSZ0GOT2XBlaxwgilkIxm3R/rdhJQZ0Ievd6xAJWSyFDNeoYBqbyNwst9F?=
 =?us-ascii?Q?uzVj77nCOWSz1g8kpbCtEKZja17KvhM0rSrP7fBBBlPR8DSVpnBs+DUs94qx?=
 =?us-ascii?Q?fMWTcXVMY2t/mkvHCSdf+ZTXUjP4yTEjhO9N4grZfUGQHEju+cf9mRH37O2W?=
 =?us-ascii?Q?zJBwsw0YtklK5EEWwruLJx2aKmSUI2Kq7jA1nYHI4pzwYkaOI/yzS9E1ObQG?=
 =?us-ascii?Q?174VvYgc8o5ns1pqUH4MdiEaZtWenFtbXYZP1pGGJa2HvwnwQoegFZkAAs+E?=
 =?us-ascii?Q?DxoAZO2SKnspZA+1vw1O13WDDpPczk21fRjyb6UoNQFOXhvFHTMl21fDtU+U?=
 =?us-ascii?Q?8sSoWWFzursZoPnHzP6xjxyGJw+QxbznhRFdaL08g/iiqKm6RkuCj1SZMvF+?=
 =?us-ascii?Q?aCzfRkO18GVC/elU++o4lO3awqn0qwIflgCvFDAhhOFyOiP5/c35k1IeQlya?=
 =?us-ascii?Q?RlGhQVcdiphEkXh56so2NpNQ6xdAYNajjv2+qHYRoGYI9vCi4cKFjQBgANNi?=
 =?us-ascii?Q?LceaDo+n1jz8HXUTPaufKoFTlhjT0LLZbsSbC1VsbIKTBP6c6+eUYfI1HHeR?=
 =?us-ascii?Q?F9dDeHESrAHCKTuuNroOR2GCyp/Y5QT0QZEayytrr6akU741vjPkhepI8VRK?=
 =?us-ascii?Q?b9J5XFUh6A4uOBmljHZhJacCD2LcWGIrC8cmpa70WN3qZTNqW41RBYXJijEh?=
 =?us-ascii?Q?aA31yGR7Mp1x3P4KSEpwPjDAcxV5Ge5KIDwaZpsv3WfdirtsMV57fp52oZ8V?=
 =?us-ascii?Q?ZCpg+Si5aZ0vw2sMsQPvUFb58BCgZ26XysEo8MHyB5uGlCwF94QrgUK4FYvb?=
 =?us-ascii?Q?XCNWF6jzCihnJJkqx/3ecob9XdPDtnuSyQfFnn01IQ4RADKmmCC5mAzo2PG/?=
 =?us-ascii?Q?G+1IlJeVZs+Rdc7qyCAF909RLuMXQlG4ynVj3YC+ywiS28Y8xEb95YrBOgmS?=
 =?us-ascii?Q?Yt3Ryfe3P2LKj2sCHO+kx7mTe081Kh9aBGCSmlN9FJLnZ9RIUvLA2zgegPHy?=
 =?us-ascii?Q?v6qtMgS29uF1bjTG22DcLZadzYTpNpLhAAqnY51cq0eokZN5IsRmdQ6mJmQe?=
 =?us-ascii?Q?7XiEZhS+MoVL5on1XRH5jXdSBBuciYu0AKoCw3bw1T+8/R/8vrrrU/xA38gy?=
 =?us-ascii?Q?7pNcTvYOj92jBtqp9j8y9Vc4gRHThct6u43InGoO9Xocl13i5pgH9X+7NWdZ?=
 =?us-ascii?Q?bfNzUpX0eLNfPg/bWJH3H2N8Ov7y+I3+3I/XIgNf9XXpLsFF/86//Y6Yl49T?=
 =?us-ascii?Q?fY/tR9Mne1p4xhJ0P579yZw5qbVwIX7BpVoQP9aFXcliGlgEELKaGXmKeP6J?=
 =?us-ascii?Q?Z18mS36gS7mSJ3B20VZv4T/runCLSENA0U+NBILsh62wJmBy3osCryDvRLY0?=
 =?us-ascii?Q?yMzEWMNJjDrYiTCWO1oRBU2p4AWuAcpOb2UXTjGXG5xxzRLFY+WYL18OPfRM?=
 =?us-ascii?Q?LzpcmopHhe6NP9QQ4l8/L8enpNBqGg3vXxgJWoEh2iIa0CzTY2LcZaDtISLN?=
 =?us-ascii?Q?Y98OKc/HB/fEsFRnuq35dZqkb+IQIHvrHPQbZVXASIhaNAVtY9z5YP7BmXgo?=
 =?us-ascii?Q?rFg0xh4cj/ySH+FjS+zakk5JKhIJD3nnfM8SKokIQ8XoSUZ4qqxFFX9tfvoG?=
 =?us-ascii?Q?8I0yWSE/bSrvKm7WAh8Jt63sXcYbDqGrKTU7SNcm0ySX?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1D8F08F6FD55C4C93ECB7AB6154E32B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6d6293-33a0-4211-5904-08d9eca9d012
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 15:27:13.3033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1jeVoBiVqy7NVOAYhl2rTH2yEPSQir063AoSa/ta1ez6Uv722nqHMhI1MHEUqg/hFVkpYAiUIuH1N/518RLmEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 07:21:03AM -0800, Colin Foster wrote:
> > ocelot_check_stats_work() should also check for errors.
>=20
> Another change I'm catching: I assume calling dev_err while holding a
> mutex is frowned upon, so I'm moving this err check after the counter
> copy / mutex unlock. I'll submit that fix after patch 1 gets merged into
> net / mainline.

Where did you read that? Doing work that doesn't need to be under a lock
while that work is held isn't preferable, of course, but what is special
about dev_err?=
