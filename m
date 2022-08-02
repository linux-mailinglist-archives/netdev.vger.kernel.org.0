Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3181588047
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiHBQag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbiHBQad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:30:33 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50058.outbound.protection.outlook.com [40.107.5.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2301582B
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 09:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDcrzM+6x1iSQW8l22JZ6otPxbiZlySiuuQ2zc7Ih7hLiqe2zpQLgztTnTgKzGIJiw6qLaZqrSeLA92RR76kilXvyATjP4m7XN+aU1/WL3V2EGFkqBA5Vg9jvCNqLIQSERAW/pF9nACYg+/GaBFFeBZYM1sF2Ywbf75nh3Bvn4QqoiSBkIlZuCzS4qMwBAqBSBuDLSJvKWlEl7Gcp0+fCrHcZ1pMIoCW7criWjYo3csqsmecf8RYKHO+8DX7SVG61btwwmA/SeFSHF1usuClV66QzF2z8MqVZL82Hie8264MzF8+qaUJBrzd3Dvl9XJN3pawvC64vsqimvx78b2SWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NTFpLT9XvdydQISmJoc/3fyO+cpwkJU9EAPM5RoyjY=;
 b=N9lpnztMkMJJe7PGrD2hGj5o0NrSouGdQOfMmvAqUD0hykpwK3NutQ/b0cdJMbbGq5sZyfhTd0alZ0pCt4Iwze3nv1xbCS8Na5MpwiCrUAJJ1li4pJRVQS/y7wspf3eXmwPo0IQzzdBTlQLZx8YuMb3IZ/rUmLUmpqmKBtcbkKdcEghGpvnmhLgPy01mCNP9APcMCi2WAl8LrB/IohtTTrv3yzfugiNBOzguYiNX12mSdgulrYFUMXnh/52v0H1OCzlmfDrC2Xil2wI/gb31kKlflhXueWpDvHAuAC/H6vbmQ6MpL8ipOKsY40pqox+SVq74CQtqOYZWeNdkiQQPvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NTFpLT9XvdydQISmJoc/3fyO+cpwkJU9EAPM5RoyjY=;
 b=Zm/HraBra07K3r0XFT7WARm/DF4QJjDg38CVB7ww9NjqpRe9iOwSq+ZXB0oZzJpNulNNpA7QF2Xb9vA5ulq2Gsz5roPn2UxHV61IqWB1995AnUsy4dcvIlfewBGzjTuGGFBTfIy+IZdTmCZh/4lhjUl+mbqodgBYYNudW1jGjUI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3605.eurprd04.prod.outlook.com (2603:10a6:209:3::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.13; Tue, 2 Aug
 2022 16:30:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 16:30:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHYpNrWi6m59GuIdkGFbFAEw5L52q2Y1A6AgAAFdYCAAfSIgIAAC3KAgAB6x4CAAHb7AIAABWOA
Date:   Tue, 2 Aug 2022 16:30:28 +0000
Message-ID: <20220802163027.z4hjr5en2vcjaek5@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
 <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine>
 <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine>
 <20220802014553.rtyzpkdvwnqje44l@skbuf>
 <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
 <20220802091110.036d40dd@kernel.org>
In-Reply-To: <20220802091110.036d40dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5ce7def-71a3-4404-bc74-08da74a44f63
x-ms-traffictypediagnostic: AM6PR0402MB3605:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O9/Cp+JIEuY06Y46zcM1lppe34dndYtKEZqPUqLxsZHWT2wnShfPoumlnEGsFW5pEwDf7yaBDRTo9TmdXIIet4iZ511CclLcNDalifI8dALx7IuOBc2LApwy1qMjmpgL6MGzEWePxHQ8UNw7KCTH7koYk2IMJaS7z62IK4ixJKXYr1bvJyIPYBbuPH3fc/IOm3/AQa30eWDlYZ3Dzehy9sVe14s2LBb00VVkyiaGrgPPK+AoIlNZ4PSQnGqiggVz7mS6wYC0SsM5vKrsuKZxDpA/GHFledwymeCjBacdJJbYdYtCJ6OxqI3p8TW+rbKLv+ztehq/oLRn/iJHZca9M8kLFvI4Ka0Pmzc6QHqTTqN2FgoFZLplvzT4rl9VL3iPuthbOWCao8PP8aeBYe3lo/dd2OWMLMva9ry17PaZEgKBufMrciOnWP/BfwWnOKlRuDVye8IyQJfIq/bdufFdHHunj7kEVuxJoavtq+IbFSyCm5ATchJCHT2Dp7G2HZuf52I2k3uXAWPfr5F5GOE1/CDKHaq6Tcu6yPQ/Nfv7Kzk5ukdqBv0cLARCMw8QMLmnAm+fR+GfAF0cFVweJt8y3nffNxqdC7FGmXRzXmObgB/HkCSwt7evQ119lJ09TSI5aTwhgIM35WLAHCfmHN7YlfL9ipqcz8hfr3MH53Ta4xH3ZPSk+kyGP5TFjS4sVI39az9AWI3D3EP0MkR2XmYD1IaejX2mOjX5AmxfjJB461QEjVfmUCMILi7dSxKsnDnnMqTO5vVM0Xjwc4cpwn9xH3+WAfHLOljRGSoRgui/lDtg2nI3PedYv8U2MdV583qF259bDpo0M1SXV2OdHXcuZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(38070700005)(86362001)(38100700002)(122000001)(66446008)(76116006)(64756008)(66476007)(66946007)(66556008)(8676002)(4326008)(316002)(91956017)(2906002)(33716001)(8936002)(5660300002)(7416002)(1076003)(26005)(44832011)(9686003)(186003)(6512007)(83380400001)(71200400001)(6916009)(54906003)(41300700001)(6506007)(478600001)(6486002)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G1/xCSEzhsrS6WJIkPeIWUy5RbEbDn21B0M/zcPCX8eSggoZtT6VziU2GkSU?=
 =?us-ascii?Q?umKghCWKoa+xGafnsR9gJcQheSOudPNcdo+OfUuoeIgZlQjjS3rHk3hQZ/5O?=
 =?us-ascii?Q?DyzIxacO8cqc6PI5+0Eica1lYQKObsUHKC+8SElVXsWexCRkjXJxZyklul3y?=
 =?us-ascii?Q?2ic2AoB9EGt9Nbyp/YkicPNsEJpgCRY1n4v53aIozgZVDKBMo9cvHK4Miqfo?=
 =?us-ascii?Q?1kuJbcQtA17MWmLuUGLeVRsiiUn8bsU7jQXQnOGCtSG42QPeqHLIMJabv2oE?=
 =?us-ascii?Q?bn9XRn2+yUyasuh1aV1mAxWgYAauVesfwzfTKOAsAeQuzZKnpCAZiNAoF0NR?=
 =?us-ascii?Q?TVvKJpuZL+zOqgWf1mtzS4MsRWk/SGRTbrCw2pCjRKCgt3FyENiykOWHbO3m?=
 =?us-ascii?Q?NYV1o3HZ8T80PIkpXN8wdYxoHahE0WCtEfrOa1l3CCYuyMf/qnauucttCPzU?=
 =?us-ascii?Q?zS6uoD6CTl4YLtR7zL2KTp9lRl0HMuqCOBJiaua3orR+2oUwwRHyjnmRhQFx?=
 =?us-ascii?Q?sNYvgQe2M0HjOaBOEzdrXz97/blSNlH/zUSZ99yFU4Qt4zzzJBuhZ0SrvRtc?=
 =?us-ascii?Q?g9FZaz1qrJG4IPHmwvVjMGLTYDMApmvSoIaxpFVIx3vFSgekiFWp3+hcrR+d?=
 =?us-ascii?Q?j072WThc0rOcYxU57L3qyPlfXuMxyb72aQZNzNQQ6fO7l4veARgVET3G2iOy?=
 =?us-ascii?Q?TiHj9ryRB89sIi27hvSiGicZ1mNEL+dnBL+GZDmODkEiePXhM+KPEFbiO1vx?=
 =?us-ascii?Q?3JmubGIbVOycwGDQ5VEqE7fyNRi+LcwKEqNmMouVWHxPJ7Z6eMhXVoHeT6+F?=
 =?us-ascii?Q?5BSrX3heBVVmosgZzTyEw0YrcXcNKCLJUXkd5X+sJuCI+RepsmKJpXKywI5x?=
 =?us-ascii?Q?kz2ESJOlQcMpEvZsHprKyaffv8+YME5nMqw0XGzLH/eNDX8g+ISqXG0BnLlX?=
 =?us-ascii?Q?MUYJ/wePCET2ZOdW5jdtYGWUTy7uHO6cQEB11quZladNjiFSkekRekelBP2i?=
 =?us-ascii?Q?JnJEbdxnd0KSqirZ16KU6sb2MM1RLSg85qkni70rK0zBfp6WQ25a6u70kZAm?=
 =?us-ascii?Q?jgoun441usz90H+t+TOJOjMOr3hTiLqS1d3BCM9n/BqEf704i+4H/ZNsiQ/X?=
 =?us-ascii?Q?VdxRBgPHjxivkE76BYKrDwA+8WsRWlftpEXDG4QbtDaKJV0KHjtXvIiqbL9O?=
 =?us-ascii?Q?ERggtfEfxIXfFlIX+w/riXEeaz2zIMKzIN//6/Xd57JVlmJLWfIqiXgoLfad?=
 =?us-ascii?Q?9LLp1tFYV7zraq6vI8rlReeGrTR7TlhpDcadwdAqUed8KjN45APvTG5vjfqN?=
 =?us-ascii?Q?Cx5j9pb4VKEmQkgKYlRdkpZ0f/Q4wUzZ4a9nM3pbwdngX7mp+XVP5vt+luBT?=
 =?us-ascii?Q?p3CrbcC8YQbLoO/TNXhHCdu9anaKh1y1Pb5GSZWkggUWYmR7YnhNfRaGZ4j+?=
 =?us-ascii?Q?1LqEz9HqG4VaFm18oBg1jxmCS5nl3VGWJ/sYiathxJVOVNTIMOCt+pRAZdlK?=
 =?us-ascii?Q?HYyDOoQWEAwYVYsv8xtrZzv1LinX5DWfxPe0uVgDysPU5R/8aMPdlThIGMmH?=
 =?us-ascii?Q?BcVgsdnHZMTCSupUBg0Vc3Lqjn6ATAODzHTP2Y3zR6BJTbd38BJ9xGGCTbRI?=
 =?us-ascii?Q?jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93AF961523A46B47A3C746EA6908BCB9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ce7def-71a3-4404-bc74-08da74a44f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 16:30:28.1585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fShumKblMhtOy2TasV3KjN0j7+We/H8jR+pEl9gIkMiXSHkxLkCuuTTT/LWQnT67zvgFOkF+tmlTOAzL75mbcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3605
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 09:11:10AM -0700, Jakub Kicinski wrote:
> On Tue, 02 Aug 2022 11:05:19 +0200 Paolo Abeni wrote:
> > In any case, this looks like a significative rework, do you mind
> > consider it for the net-next, when it re-open?
>=20
> It does seem like it could be a lot for stable.
>=20
> Perhaps we could take:
>=20
> https://lore.kernel.org/all/20220727152000.3616086-1-vladimir.oltean@nxp.=
com/
>=20
> as is, without the extra work Stephen asked for (since it's gonna be
> reverted in net-next, anyway)? How do you feel about that option?

The patch you've linked to doesn't really do something sane. Deferring the
dev_trans_start() call to the lower device means, in the context of DSA,
retrieving the trans_start of the master's TX queues. But the same DSA
master (host port) services more than 1 DSA interface, so if you have
swp0 and swp1 in a bond0 with ARP monitoring, and swp2 is running an
iperf3 session, bond0 will happily interpret that as meaning that ARP
packets are continuously being sent.

Does it work, in the sense that the link comes up when it should, and
doesn't when it shouldn't? Yeah, but this proves to me that most of the
handling around the ARP monitor is just random gibberish/snake oil that
could have simply not been written in the first place, or I'm missing
some of the finer points. (happy to be proven wrong and see Cunningham's
law work its magic)

How about applying this to the "net" tree when it starts tracking the
5.20 release candidates (effectively a continuation of today's net-next),
and I can send backport patches after a month or so of some more testing?
I can prepare a backported version of this for 5.10 that Brian could
keep in his system during this time, and we could watch that for further
strange behavior.=
