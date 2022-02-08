Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB844ADED4
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383646AbiBHRCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiBHRCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:02:35 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2044.outbound.protection.outlook.com [40.107.21.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DA3C061576;
        Tue,  8 Feb 2022 09:02:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4Y289Nc/UxBX3N6SqTYxZ/bH0LLURG5K3Be/qI4JBcm98vhIFCYdlnPWy5IJJlYGQoPPEpzmOLPWfbifYltjepWgtNJ+y50U2R4h5Wf2FB+odFDSZp1RGhaToNV85IkEfjxPV2jXd2h9J/aLXHlFfwmrooIEEKP20wWwG/eLJxus1DVH0KoYc3vaCvtWgy6rg8b+kW0OfO5z/UASj6wX8yjf/bPAeEzEEyqIyUCa3bKQo22/z+eXIq8YVOgROR5XbZLZBlfDqd5cf/lbhhr08f4ssHVgRQ4ir91SjVtS7dhvK5HzPGR0UE0sUnQNwSHbnvR+2ACKAmVl1T+qsE++Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTmige3/t7lh/QmFERqwI+tpCzSnNFVLtHURfuvkTrA=;
 b=D+Do8AIQTjyEzLrMamR3qfECr4AIJK7of5T+MQAdCKY7oN+V+SEhgRtzfu6S07q6OX2j9Yp6glX1ACrbLAnN7rpyogXuZ4uMMwYiP1gRymk5HHcgi8Wsch9/tD6W22AXkzGhTUu6O39OE9BIuIK/PTW2m9DvtFDH7xyHEkaWuCMMni5K+3/X1UuHZJqqJxejpGfzfAn0IMW0vVDkcmnnG64OWXNVwwyuJq0KcLo21R6mu8KOXQU0pzyoDLATDnXsLPy8ORsG4VWdxMmK8X33MSAqVbNVTctZ4vZKSS0UjjGeHFraGMmziesblCQkDtly2u9DTRMnfwOAvGXBQ4f4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTmige3/t7lh/QmFERqwI+tpCzSnNFVLtHURfuvkTrA=;
 b=GdO4gRMtxSfR15gQVJXDeNBxFKhcKqJBbjJ/+mwAb3XjyT5lnDoejtdgzEpsG0f/4MakeP1GVaIT05SjnxI4W9hTmZDvhx1Wawk5Yu0Ft+8h1zydkHs4JcNGtKzO4/WAMH2u7hFyVcpu3ElvhWDkUGSOiQb1+thev9ZurM8rR+Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4820.eurprd04.prod.outlook.com (2603:10a6:208:ce::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 17:02:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 17:02:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHKbq8GXukjoutEaxquFuvaFzqayJwKKAgAAK3QCAAADugIAAEg0AgAADh4A=
Date:   Tue, 8 Feb 2022 17:02:30 +0000
Message-ID: <20220208170229.6taqduofrldbonu3@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf> <20220208153913.GA4785@euler>
 <20220208154515.poeg7uartqkae26r@skbuf>
 <20220208164952.GA238@COLIN-DESKTOP1.localdomain>
In-Reply-To: <20220208164952.GA238@COLIN-DESKTOP1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a738c6fd-69c4-46f1-4d87-08d9eb24caf1
x-ms-traffictypediagnostic: AM0PR04MB4820:EE_
x-microsoft-antispam-prvs: <AM0PR04MB482060102A29EA56EF68626BE02D9@AM0PR04MB4820.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IeTfxn0imxYBIkcq4ARPtVNCihiSvyJMIfHwt6AUDu7xLkmOBn1krCNMe4VMg2mku3ozAvowf1AVipaheG4fF1/a9UoiYDB1JQubJBqsFLP3ehWu1rxNgLn9ZjIJDeEgnX/Pm0/X31d5w7arZ4uHnrjjDx7+iujrKayc+1hfhld3PQqRYREqgpWyVP73k7WELULfHFuSu4WrpM/MDsfHKFVCPmsjabmTFKHCQjIGftNCrsNGPX76p3JCo3yI+iwn37UmSdoVqn9EwPjhjbhqgdxocZLbsa0Vo+qqd7qv/cGt6LkkRRN11SPAbGe8Y1nzu1WJNFPNTCZRG+cefKx9N0tEnZDzLczdhBLLgBwbwCsrKtfadNsKywuzboK6hOTWHBGDxp19EF2fC+JpUNdu1BCT+iK3dDdUY9R7q5r5HFgUZQWHprt9EkICUcH2f0NJQlztQ+Verxdai5FTYU3tAdMe43aL9J83X5v2DWrVTRSRDEResaKhaVNhkKglTVcGi/nIPNo7e3tMN2PuMCEDmh7ZovDGopG4znCWdEZe/Wzxxs8LE+mAM7O/j2k04G1GJJ4nT63rqwUKYCsw3R3UTBF1UR+pCY6LMMaCEt/efleeT4fjFXi3F6+ZNcAyemXz1+kDZNhdo/q42SDLVwwvnKabIyfPpwd18Jd18d/FQbVksdhcZFd3wH05p4d46Esqstbgqr84Ve9i9T1JM1fBnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(71200400001)(26005)(186003)(1076003)(83380400001)(316002)(44832011)(33716001)(66446008)(4326008)(8936002)(64756008)(8676002)(66556008)(54906003)(2906002)(508600001)(6512007)(6486002)(6506007)(9686003)(6916009)(86362001)(66946007)(76116006)(38100700002)(122000001)(38070700005)(66476007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0STakeO9ob+jjHqd8PzPR7Jm3lWR2cIEiUeRXiY0ndKSur9CnHOoKx/em2FG?=
 =?us-ascii?Q?5a8LyvQzE/LXmQ/Q4dJJZ83ZJ94nFlU9VTwKPh/NMgG/Ifae+8aMiiON+V6B?=
 =?us-ascii?Q?0+11r/j5JLKRiQ2kzT5IKPyj2vBBL/uInOIluJ1w0rjFj0Pv24LmblPjxL1R?=
 =?us-ascii?Q?bgFINRO9clPsz2G+P2F6S8BKUtkGbyJLZ5iDjQIzF5GvOAKaev6ZUyuyM/Aq?=
 =?us-ascii?Q?865FH/dcjwylVasgWy4V6xJda8sZECj7P33/y4eZYBvGboM9VH+yWnD9RHe0?=
 =?us-ascii?Q?js/hrAjUSRakXzFb8xDqQgPrYgfyqsAg2EeyCmSsR3L2Kls7H6sonq7+0br2?=
 =?us-ascii?Q?1hrj4e3PLEoEg3MKNPy3lePEEf79EIl31LX4pKFT1y/21HdPF6Q1ZA6Wj6PK?=
 =?us-ascii?Q?f1nzjNU/vR7d1UGDoM4h+LYVHNc+aLfM5cduzsmqWJhO48sp56NixC5PpMFo?=
 =?us-ascii?Q?zsAFsV1VAWTrLyqnKVg/x9j8yPO+HW8iw1m4H0JNYDcgUZjFW5BMx6DGWMWL?=
 =?us-ascii?Q?dUZ9tsQnyy4S4UCMUxI89FK3YVNieFflK+qp15GVINm2XnBOYZ7CR6Xqr/AK?=
 =?us-ascii?Q?/tTyD6yMsAzgMYUv4opq5OlD0aP8gGmDxdqf2xcUhNybWUJgbuEdztat57tF?=
 =?us-ascii?Q?1p8NiZJKbAx5yQDvTl5prYXm8l61atvh9ePPja+soEi9zmh8EsztrCgbHvev?=
 =?us-ascii?Q?K8g0K7h0QxKMUlPUEpXl5j5jJPLfdZ2hYa9Zk9WZeI4C4HzzE/ah8cewItdo?=
 =?us-ascii?Q?gf4+NGN7Rr0rAEeSmk/hfa/1+EQ4s2C3F17K8Mwb3u9O8wNNs8H6yInLjPcg?=
 =?us-ascii?Q?BdBP4sI+q8IeJntoVcPCZpp335aHH0f4wjvnOK9x2JbEYae5oFfwoCAHQLur?=
 =?us-ascii?Q?3Ub/1YDbxRE/lQLwkIRL/h/mnTyIykva7P7PUd3wKUWzeYsv9B1Uei4wNwTu?=
 =?us-ascii?Q?51B/25qiWh/stgcxHYLCkyzpmUB4SpWehrH5sYk/6ICRQEbc7/d+GGHuBpF6?=
 =?us-ascii?Q?3LgjxQ8rfXoPOtSbaoY3UMYNdLdu4lYO88zbneqoXZz2P1lOYmav0bgLn3b6?=
 =?us-ascii?Q?3PlNu+z1N+i1cXl2GuNC3QqEpS2LIst39jxpel0osrR+UeR1uUJxT8Dxsj6y?=
 =?us-ascii?Q?b6hgwv6/3tDyOvbbBXerPeEKRwSSGiYSLfD+uaReCwoVKcOUJm0ktv666DBe?=
 =?us-ascii?Q?iHeXGhsSIZmgSTT15HHYVVH3qtdT/9mtqRIWQE1AVEV3Wd09M1WXjxuVHYzH?=
 =?us-ascii?Q?r+B/3yDFWmyDOe3aDttgQfU6OsgVSD6NyBOiGEwKwH5seoYMquVU6noEqA99?=
 =?us-ascii?Q?WkJdwDiVudbPclNJ95CkaFinj7gU4hobg37caYby7WObDKYNX0j8U7TTDLHE?=
 =?us-ascii?Q?+wa9fypVmP8hA/9w35da1ecfxiCKwUBcDoK5l0lxyEM5YkdBJsUeZrxIRkSE?=
 =?us-ascii?Q?X883kbQ/nNg1Buf6uW1dSOHaj7JN2bgVDN/gvz1dpHK4OQ0m0jA+a2o0thyh?=
 =?us-ascii?Q?V9HbrN7DN746+SgrObtxa8kCXQVjg4OLNtJG1Y7CrHNTEGyIfgIGCyCN3A55?=
 =?us-ascii?Q?dKDSLmT2KhgdrGaFkmn1cjjsEExkAi3/fN54w1o8i9uiRkz7GAimjCawvZf3?=
 =?us-ascii?Q?Irh9CuLeRJzo8tbNCyIRRJDN03MJyi8wQGytec1+5c+n?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D29EC18A1DA334FAE144F58E27B7AF8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a738c6fd-69c4-46f1-4d87-08d9eb24caf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 17:02:30.4547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lUmU4vYU8Ar7grW3vXcNOA8oij8aNbu3i0bUWvXivR/AJM+W+h+S7DrM8yStodOpevef9CcBSMi3uXO2Hc1Ayg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4820
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 08:49:52AM -0800, Colin Foster wrote:
> On Tue, Feb 08, 2022 at 03:45:15PM +0000, Vladimir Oltean wrote:
> > On Tue, Feb 08, 2022 at 07:41:56AM -0800, Colin Foster wrote:
> > > I see that now. It is confusing and I'll clear it up. I never caught
> > > this because I'm testing in a setup where port 0 is the CPU port, so =
I
> > > can't get ethtool stats. Thanks!
> >=20
> > You can retrieve the stats on the CPU port, as they are appended to the
> > ethtool stats of the DSA master, prefixed with "p%02d_", cpu_dp->index.
> >=20
> > ethtool -S eth0 | grep -v ': 0' # where eth0 is the DSA master
>=20
> Thanks for this hint. I didn't even think to go looking for it since the
> DSA Documenation mentions an "inability to fetch CPU port statistics
> counters using ethtool." I see now that this bullet point is from 2015,
> and probably should be removed entirely.

Yes, that paragraph did not age well, although it is still true in some
sense, just not in that phrasing. You still cannot collect ethtool
statistics for cascade (DSA) ports. Maybe it should be updated.=
