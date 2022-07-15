Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD1575EA2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiGOJd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiGOJd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:33:56 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150094.outbound.protection.outlook.com [40.107.15.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919711B7AB;
        Fri, 15 Jul 2022 02:33:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEmvF+lLjt4vEoLcarGh3pZ+2OSTNFN7UkeBJgv2ajglQICxTZi6XyFHTt04+tjH6kF4lQ9wGBQws5ffY+O326tyDttIsEf7PBT9SNtIEDmC1n3DAKj7lpwLbQ9Juf+l3XKAyr3zf0yW3hdEKQfpMeI6DMds5KaSJ/gFJYqA64uaHy2c+KwiU/xSEwq3ksLcAMHa720Qnq1TiNKa2yxDY0AWqQj+yo3zJhNsGZ1zhHyu7d8SKqCixR3jHDO2G6dXkz3IRwnnPgcknQP1sqD9UkloTi7PpToSsW+bW8wvjv2ib3kyJ6wmCZIURcBBpqGXz7LiBvJ3UFHn6M/gLxGaYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tj0mqenN0WoWaRnhXQTO35EwlijIV/ygrGe7XyLl8Jw=;
 b=PmXTtg7K+9NqNDnljAKCrlf0pNMwOcQI6GEa0sW2JyntXiucL5QDgLrdeQonuttjE/Cr6zkIbnPzt6qqT2jn+qq4rdESdjoyiY6LvxIJKJNblcGnRvR+e6lBWXKExIhM6p0xmJJik5dpF7hBy24OZPo91rD/kE5ZwyxzXkBXXnym88J/kwRCy61Z7h23cMO4W/uRJpHYF8oi80JadQKtbTKd0d2OHOfRNK0I0/4moz+kyksOE/ZG9joSvv/mNp+zFvFNn+nA5JPrncDQjYmvTk3m4IcdAIoPz3A9KBKLFza5TxN/0sufwuHuIZGEzLFNQQOm6Qii3PxtCW1QMR2GCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tj0mqenN0WoWaRnhXQTO35EwlijIV/ygrGe7XyLl8Jw=;
 b=TMS1vid4y1I61oiyIGm2+btwLdHcWpLj73lWK57K9m5h45Bq6+Fr359ykYoFOAjMKxpCNdUi0bZX5pLHV5BuVtbNjQf5e0rqAmanGRLcUE0fVBsf82aQ0Ma3jLqqQFE9n+QY1fGNxstDKrfPASgIyjgW/dc5/82YWZFUmuNBMts=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DB9P190MB1794.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:33c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 09:33:53 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9917:4436:3c90:ebaf]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::9917:4436:3c90:ebaf%6]) with mapi id 15.20.5438.017; Fri, 15 Jul 2022
 09:33:52 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Thread-Topic: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Thread-Index: AQHYltzgx1x7mtWY70C8ofiTDPrM6618ugmAgAAd/YCAALk4SIAAPmoAgAFdkgA=
Date:   Fri, 15 Jul 2022 09:33:52 +0000
Message-ID: <GV1P190MB20195294C842E926C5684FA1E48B9@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
 <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk> <Ys8+qT6ED4dty+3i@lunn.ch>
 <GV1P190MB2019C2CFF4AB6934E8752A32E4889@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
 <YtAOZGLR1a74FnoQ@shell.armlinux.org.uk>
In-Reply-To: <YtAOZGLR1a74FnoQ@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 24f179b9-0505-7216-7cfa-6af87da2548b
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d76fd07-359d-4173-f289-08da664521a3
x-ms-traffictypediagnostic: DB9P190MB1794:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gZO3TXbTu1R20KObJZveWLWfNF6IjRbodDbSvVf9D1gbRtRJ/6CnlyuL9JuYOL821IC56Ou+iv3q/O3HjEWC+NiJfMpMNKB0gsayy2E6GP/DwHekAFNb3Hdmtuf+jNZoOS/PZdFWeDbztKm+q1JRRB/r17qTDkQjPQ4bBmJf0FDaYTFKsRaad7pdP+34KuJKeCXtbIqiv7/ZSLzF5m47a0xTNsc/a+nVGs1qbSSDxp0qBOL0a8tBf0esTNsvkxmqUCnwq4+PsoYzTrMM3XyQ41HF7bVc/9aAQ6mVJPeRE0dS/liewF6zFyzfXJHGJQ/cJK4Si0VOiNNG1RHvKcLZqWcpTkVP1HNThe9fmDXE4frRFV8MUKffqRNSpdFngVEjLF/OvtruuByHiwcVzqAo/TsASYxmbpK7QF6AdmMnIkU9eCQB+ZPY/PyTicsjLNI+ulmG8M+b5yvbCRx3u4cR5aYWSPudKdQmsGsp0bmP8ku7mbWBozEoO9BznV8wR9A8ODXazqJzM/FauqbLy2lV3wcDTmfTxnCA444d0adX9lXp1YU617pzPLALqSSM+Yw15opH7VxECZtNA+UCJUtGV+gDVP59zl7XDxnn6/mogFRR7XpGtIxVfP293d4yxwe/bMQcocw8Zrh/+1pYPf+P1nIPF1ERNEVzSUOe+1Het1m4nxzAo03t6BW9ErjcnlQDYIx4lLR41ALRnVyqgn2jpq5xACHT/1Z1IC8MegU1afXQ45V8hrfoZADDesub7V/THCMlkS7MsMbsbv8YZJ1GqugTXxprM65xRaeETLppKVO7TfQdkZnmpPOROKZ5UdKE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(376002)(346002)(39830400003)(38100700002)(4326008)(38070700005)(66446008)(83380400001)(86362001)(44832011)(2906002)(316002)(186003)(54906003)(71200400001)(55016003)(8676002)(6916009)(76116006)(66556008)(66946007)(64756008)(66476007)(52536014)(107886003)(9686003)(7696005)(478600001)(122000001)(26005)(8936002)(5660300002)(6506007)(4744005)(41300700001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+NGNyV11W/LWg5eWrbqHKooXUl5YV4UbnjZAQ8VKb2Ch1mcPHMiXUO4E/j?=
 =?iso-8859-1?Q?J2FNstnfSxsZXxmmYE2AI+8uw2YJDKvql2sRkPfU3jj0TOgZALnEGvzGoq?=
 =?iso-8859-1?Q?U5sDiItF1BzsVNHKghQlOJaUYSpCgTGWFVailbw6QriFucNb/CIxGCK3Kv?=
 =?iso-8859-1?Q?uIWRXkse/hI50YVauK25+gAyRp5ET1WuoiqVLwouAn4k+RXZnwv1MNn9nM?=
 =?iso-8859-1?Q?uFek0kpewTdKJLgs1Kt1U/sJvU7HIdfn3DG9Fk33bns+/KvSjZnVOoNB6f?=
 =?iso-8859-1?Q?GC37AC6PorengGhfha9lGTIZ9+I0e0cGQskOVPzwEwCp+/EuHW/Mf/LLNr?=
 =?iso-8859-1?Q?ZDTC4vVuWX62vqcOoeT8eTuUQBIl4/9FaDogMdTShI+QUFrCMmpcpadq4U?=
 =?iso-8859-1?Q?zOIKGk8oSGKiBtkPdpEgUasdVteFTJquxLBAn9KCRKTWypzsTb3+qQKAIM?=
 =?iso-8859-1?Q?WuWtbUtJZdNnd6gNJ1PptsqLhl17BcaP/RcwabsDV0NKU4Yl3DRux5v9rt?=
 =?iso-8859-1?Q?+lKU/TkP7IkXBGBjhlCO1UPdhxCBmA0z+xXkB3sKBYjCoxIK3cIiRs1tcS?=
 =?iso-8859-1?Q?w6CDkerogjHftIBh7XSy4DtwVe/KXUvHvcXYMSVJlzyy8FBwxHourweSIO?=
 =?iso-8859-1?Q?AAXU74fSNONfDHO/cWVmqqydOlEm0hpIEU53D4zd623oAAv7NJVDILdScE?=
 =?iso-8859-1?Q?0kCQQnvNc51qZ4gJy28U0LhZDuQ3e43Cz2ZFpSm69RtsVDoA+4IH2KgmQ6?=
 =?iso-8859-1?Q?/J4Xvf1HtCj+u2IFW0k3fiSmIFbmGloo98dROCVIkYmPLM8pnNk3uXI5HA?=
 =?iso-8859-1?Q?Q5FipcN38dbBazS2lM59yKZGzIz9h8EkhPU4WxPbEXW3mVnNiLrOGZSzVW?=
 =?iso-8859-1?Q?7yjAb/Mi0b9JHhzrn0P3cTodfsVz0amac1k/J2DUw1UumSQ+Ic+3B/EhPR?=
 =?iso-8859-1?Q?9kObFv5t8ohkNM/Csmq8BWgspzIlqVNcNaK1AxDb17GsYshL4YrtHJ6GMC?=
 =?iso-8859-1?Q?6YAv9lMSrfzK50VBj6/eB2zw2rgviL9ZIsFLYfX+XW6/E3nk0BH5KyuXCX?=
 =?iso-8859-1?Q?YJemJbFDML6uVOw5/VGnUGiTM0+T3CtdTwd++uvnw1QNSuZ8voffpmEe4B?=
 =?iso-8859-1?Q?V6VbB7qh2LvW9snN8bx6Algakp7kGXguxCOA7MPKLnp7gFjh+jPQ/AwtY3?=
 =?iso-8859-1?Q?mfZFOsjGHV6o3wzzV1vLv2eOioeecAy00Sw+DnwkiWGNx4QXphsZpxv2PY?=
 =?iso-8859-1?Q?OiqDzUL96wYJcSy+UFRyYYXLIa3EDd9xbMo8Fs82r8xuzCnr7cXrszbxqs?=
 =?iso-8859-1?Q?gbpA3p2+X0VGU0DqwYSIQJz3LXbaCmstUaU4cnKawMmwhlq3TP9ZHZ7AeQ?=
 =?iso-8859-1?Q?nwJgm7iWSkG6bVSekqWlbBoiyVhxyEWbWxwm1M16n76nVpAt/sqUDRt+hZ?=
 =?iso-8859-1?Q?+GFPPxq4CHKeFUczkTXy6PWoC9w1kH+rMWN2TGhU1GqxmwFoSBucJ23Lrq?=
 =?iso-8859-1?Q?HqgkVtQ8PnKNFhUuO6/lBSu5KV8NCYXM7m/0xnjQFwwJSx3zlGcpwKhUtV?=
 =?iso-8859-1?Q?qN1IXx0dAmk1wP3XeWUPcJCrq//S9bc5rI8T3FTi0ARbelMr0yucv7lo8S?=
 =?iso-8859-1?Q?W8wg9wc6Bs0mM+TrMc+UZ64xyi2ptuFT4GLv526edEibQkV9V0uIgsVw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d76fd07-359d-4173-f289-08da664521a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 09:33:52.8890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MljgHa1i9aS0WHeo95cO4w5G+N+g9CAQrKBXREIK31AQkt3fakt5YEKyGkVwq//iqyy8UTzyOlbdr+gUt1tyE0BbcVEuYLlxsmKZxQXBN5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1794
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
Hello Russel,=0A=
=0A=
First of all - sorry for the inconveniences with the rush of new versioned-=
patches, my bad; won't happen again=0A=
=0A=
As for the comments:=0A=
=0A=
> I didn't specifically ask about the ifdefs - I asked the general=0A=
> question about "why make phylink conditional for this driver".=0A=
> Yes, v1 had ifdefs. v2 does not, but phylink is _still_ conditional.=0A=
> You are introduing lots of this pattern of code:=0A=
=0A=
Sorry i think i misunderstood your question of the <conditional> use of phy=
link driver.=0A=
The reason is the following: the current state of things with ports is that=
 PHY ports are controlled by FW,=0A=
and we're using phylink only for SFP ports. We don't have an PHY regs read/=
write invocation interfaces from driver right now,=0A=
and thus PHY ports control is limited to controlling them from FW side only=
, for now.=0A=
=0A=
> 3. As for AN restart, no, it's not yet supported by our FW as of now.=0A=
> Maybe put a comment in the code to that effect?=0A=
That would make sense, i will add a comment in the next patch version.=
