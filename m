Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270FB6028F6
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJRKDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJRKD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:03:27 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2055.outbound.protection.outlook.com [40.107.105.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAB0B1B85;
        Tue, 18 Oct 2022 03:03:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDY9xnOQaSEPWAwSJv1U0rStnvQyzD6RZfTxdq2LuHDJtqbRvvw5tMkzktP18J+/4Vh3OoSKaIp8B9rv0y/x+dIV7xujkbOgDHBP6vQzENNXl69B4qYh1sPyzQe1ejEwAQ8xL0JTjZTf7HRYp51cz5oIxuEV7KZ+6Byjcx7W05TAkawxDSmAgdXX+5pnfaN//83AVJBRQMz5EkrRSzAK523lMUCl6g7B4ZO9JiIvcFFlEM7K5kVv5AVtC2e9um4ikc4WYUIVsI01JQW8v2RWQtnknHqksNdjlw2jggE2ICHyo4jQmbH2z+wTvie+umVYfTpvy36Gw51C6TR6TUEYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WL7bflt+m0olirv1vyJqfW6Ye9Y9fUswoAbbPVmxsE=;
 b=I/5gHdhVBzt+6hPVo3Qc0Aijre3XwNyhT9MQbtjcnauLxm2S5RyGLb7BYU+WOPCk587ECzOTgqjsAq/45W4ckdzbdBkrbt9qHCw7xbUrD5O+a0b5QUiV0XEB9vT5Uu68ccBn41V+diBt0tByA8q7zs296Ph16mNE1Cdb5KOVlvP530atBk9ETc0bjwwfKxCW66mCtpqCxniPxNXdaEO/IQKiI8p2FYQDaHXkQ6pSnl+vzxByWaHjmKwVLoJWn1ZpIYEAd2MdMlIA/wlqCx6SwQFJ+8TNDCFDUW/D1ZvoLSpJOxcNN8IvmTiG3oLWrkqSq22C1lPgZgfkNTYnzbFhCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WL7bflt+m0olirv1vyJqfW6Ye9Y9fUswoAbbPVmxsE=;
 b=DpwpD1vcDbW7sytTG23dlEG6bML3GtCec0slG0In/vc4zSzahw0M+7C6qCIAyXlhfdilynjXMb1ckdXJDIyKav+oWhQtg0Vz5nXKz20L1/CgxS08wudFMyChtmNy63SxoURPpZDQNcuYtNkXwmHTJcJncR0vFW0oi9wpTcUPzw4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8239.eurprd04.prod.outlook.com (2603:10a6:102:1c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 10:03:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5723.032; Tue, 18 Oct 2022
 10:03:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3C2kHrdjzthEi0WraLEdXdCgp64T9AOAgAAAvICAAAScgA==
Date:   Tue, 18 Oct 2022 10:03:23 +0000
Message-ID: <20221018100323.4cglkjn4xkdmzzai@skbuf>
References: <20221009222129.1218277-1-sashal@kernel.org>
 <20221009222129.1218277-22-sashal@kernel.org>
 <20221018094415.GF1264@duo.ucw.cz> <20221018094653.nt4sh67m2mjkcnkv@skbuf>
In-Reply-To: <20221018094653.nt4sh67m2mjkcnkv@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8239:EE_
x-ms-office365-filtering-correlation-id: 4d4f70ca-ade1-4047-8905-08dab0effe8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2+u1tJJzZQ7viMnqafUNsmA1rvYtHFNgkdEfN2EnRVpBh1BYNiU610AFzB03yvI7QTDzx5zyFc56TAWIbXKjhhkdiXQxCEiNGt41X4z/ACRHquqh3za5wRlVBv/OVFCMggW7jCP9iRbBh1wJLx0gnx+um0pFdyPlUCQVdw68Uc/5+kSlQRG7ZZorgPk61uCMHNM66/Gvy+uwDahN6W69SVjCvr8L1voPHGxrdcCPt0qgLH/yilJFntcEM4jLlR3UQsrkw0AT2Yn9/D6wfudughfIeEWPoaYVUEvp6qIbrqNaO6fgWxHnxxN4z0dkBCDsNgFras7Xnfdfn9cSVMvHlKQmP1DZOzdumFNacYDWxqwM80S3Mq1fh149WgqzdKOOw7VQw+0KFPi7UhLpJkyWUz04zRUSX51RBOg/uSOx0lf2wSfVMJM1fsRo/kkNC/VM374Plgcpj0HF0/Eey5Uo88PqUONXZEwjKutqReoJV1Uzc7tQ/gTa9ob7SHzLhSKuIGFSnU0cjE0uP1jGS/iIx6xIo/XYFBPPPvHhx1opJSrLghxyV/LzcsigemOR+lkasSrlHWsadI0HfIEEcXBTnazog+NEzcK7hYMTYOQZ7Be+ua6UgLNovLDEBEcVhOw5LilFHpFkyA5C/i9Bnf2zcAw6LNTOwW3kPq11WmOsK2yvfPjpoDH5/mQqceM9CQvYrKPErF/EdwzP+Ba6JY+eASu7wr2pZXlhnaMuniQ2Q5CjKBumRU1QDoXAKOzDpgx6l+xeQ6Hds9zRLCVOuSpN0YFm4I8qtsZoP1N7uKqaMRk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199015)(6506007)(478600001)(71200400001)(66476007)(64756008)(8676002)(76116006)(66946007)(38070700005)(4326008)(66556008)(91956017)(66446008)(6486002)(966005)(54906003)(6916009)(316002)(33716001)(1076003)(186003)(122000001)(6512007)(86362001)(26005)(9686003)(83380400001)(38100700002)(41300700001)(8936002)(44832011)(4744005)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GtbRI2t62b9jjlwyAw5XZrPg85ZXIbEpt2KdkEvXf2WQ5r6gAdZfGnhJGchm?=
 =?us-ascii?Q?KIjos9QzZWZECJfFHewnitXsRB/veXLN4bQlZldsWuxhM6ElfN6MI/50JEtV?=
 =?us-ascii?Q?pcUF07VOPs31Cj2efkknguUjv9mHe/tN0Fd6vSD38WpHs4+0d4yb9y6Ggk2d?=
 =?us-ascii?Q?Ri7RmReAfpDPouqrDaMnPfg8v4IjBa2SrGT2CQNfbPP73+YqfKMTH8WUJABd?=
 =?us-ascii?Q?joh3/oREbhYHg6kSxoUExTkbNUkqIeGNa9dWgW+fKviXv6+8cY11E1WCH8Zv?=
 =?us-ascii?Q?fOUQZiLpy+L/aTrhrCSvaaBw+ub9p7Kz6E17FafwwBLxyyiz5Xbd1fv0+UlU?=
 =?us-ascii?Q?LyfoZ7vJwG7Q4h1YRWPx9fBz/R3Zub1lqrWSKYZgpUMQpro68ekeUxjWnlDu?=
 =?us-ascii?Q?n3OSUgu7U/dy8xH4Vx7pFzxei1QXedMUXTuttbCuP9KsDf+JZe8A1K+HlSuj?=
 =?us-ascii?Q?zHFMHpxFGxneeQZrd+krLSqU1tF3rIBXG1yBtdqm+w9JGYmtQwYWRQZwP99u?=
 =?us-ascii?Q?EkeGf596PRKFWNCGJ7+nsA4ESgIZhrYlfhwxXfwjHw95KBpxaffFgqjP1zVY?=
 =?us-ascii?Q?JNI1aEj7cPmnJKhTV39knRlpVBKFappHU7br67Ez4b9ms8HH8q2GUH6AKHs8?=
 =?us-ascii?Q?jn1bq4+tOIK3siEu8OEYExMFDORFkdv39aRugbHb/340O8A42CXzhh+NmJWu?=
 =?us-ascii?Q?GB2w8xTneOOhtNa/y73p4AJZLwaXzjt8v4N+VSmBdvLuc1WRQ2uaxbwcFR8E?=
 =?us-ascii?Q?1oetf/Le0mXCm1kJQhNhYZ8e9U5MWpdNYGjL7eNYCN1lA9i5u4r7nNFJ3O08?=
 =?us-ascii?Q?WZqxGCAUCwK5u8T+TukI0XrTg++cHAukFhFaPN/R2X2yhicUu1XsoYL8er3c?=
 =?us-ascii?Q?02h7yCfVspb3rbguFyG82UuRdXUQTSXY0hHI3XyraRtQPTRJjaOYWrimEN2+?=
 =?us-ascii?Q?i2prxC8udiu4GcygxZQNbuaVEO30tHRiys1bzQQ5T4rwDIIvPdioYEdsN8hJ?=
 =?us-ascii?Q?v1QY/9XAWRiQK5jaq80NJ5aSbGY8z/yrhW5ywYGRSlMPOZBBGUQecyJCawKt?=
 =?us-ascii?Q?E2AKqEuWXHnSjCnHBSCzyJ5lT++EgkzOZ6xyvE1MhB1DM1MadlL2DO7whwsR?=
 =?us-ascii?Q?BU7/pOK5EuFbILTOjO36C58k61D+MdK332pqiJle2ri08PZHn+DGrj6V8RwV?=
 =?us-ascii?Q?U2ug6Fx4E6ZXInlCd4rpW+m7FV3DrGRaG/4u+8FC2j5bl7RVx/fUIVz1liVH?=
 =?us-ascii?Q?Ic1qNFokSLlfTKHv8y64PMLSyF3epCUNFFyGSDs5MJdEasjF3iTYCUncPHHo?=
 =?us-ascii?Q?JTLgV7I3Yc6iuGXGPQ0Q9l9wdOqleZ6GDYBzoVEnj7xS/psyREv1HW+KbGlH?=
 =?us-ascii?Q?//n5SDJhyTa9Iv5Zr2dUlKiAj+z45DPBba4LCCY8i7kyJ2VBVgvGUlPtFVE2?=
 =?us-ascii?Q?aENeDifjRq3pYHqFVZK7DRzvbQdmh47T4xZ9LIfdswFy5QeFD52Xz3+hG0OF?=
 =?us-ascii?Q?H/UPN1U+nofi/dXBVsoyn+TgExgtNCHcEMeEIlH78ys8+hIbAKDwReAJvqXX?=
 =?us-ascii?Q?qOvr1uGOyHvdWH1Ke8YUk3Q+13LllfG++tz6lEeLMoJOcgyHoqhwIH3ub2DZ?=
 =?us-ascii?Q?Aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A7EB5724616864A8DA8F40091D0ACE9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4f70ca-ade1-4047-8905-08dab0effe8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 10:03:23.9885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gz/h7ZWX58cXo6QB3a50LIDU4RpIU4KejGt0mtwhith0Xqw32uVdJnkkDRmJlye4ImQZrC6s8RYQ/TCsG0EjRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8239
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 12:46:53PM +0300, Vladimir Oltean wrote:
> On Tue, Oct 18, 2022 at 11:44:15AM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >=20
> > > [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
> > >=20
> > > Since the writer-side lock is taken here, we do not need to open an R=
CU
> > > read-side critical section, instead we can use rtnl_dereference() to
> > > tell lockdep we are serialized with concurrent writes.
> >=20
> > This is cleanup, not a bugfix. We should not have it in 5.10.
>=20
> Agreed, looks like I missed this one when replying to Sasha for all the o=
thers.

Ah, I do see that I did in fact respond to this already.
https://lore.kernel.org/lkml/20221010133337.4q75fsa6m2v5ttk7@skbuf/

Not sure how you put your eyes on this particular patch?=
