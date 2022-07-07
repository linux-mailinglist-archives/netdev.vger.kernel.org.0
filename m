Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441D7569A93
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 08:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiGGGgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 02:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiGGGgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 02:36:10 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140135.outbound.protection.outlook.com [40.107.14.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BA826567
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:36:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRxI8Q8v6C8iAP/FejzQvvGOH8RoZvRyHDjVBGMeMycNSzTM90BCbjot5pDz8RrkEmC0nwDNqS+Z+W/kRaBv9nCDuzlPzOQDCIlGRR8bTL6K6oCDJA4CKhXuswoxSRAxZfwoTokfpxsFfgeYgVXLhY7dkC/V63bkwaAY8xHUApvjnT/twvmLNO3LLoX+uWp1lAhukynCSMwrv3SuZfwN1Jo9//nEu30vmCSsxS/rHRp4Ool/WZomCWneA4S9f06q5L7FodO/xOG7NJpCLieDlsu7kur/rs78/W2bP44rpZg9SkJJc+l1vg+4YtSiX5ySaAZIg7C9xJLi+BZTd25XZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1ogVjF6fLJcLNgo0djHIo3M/CUN+0SAMZyzQqdm/g4=;
 b=QgRmoRyJnSuaIB4OOU6n6IX0NwGlgELZU4dpj0a1FSSpxzBeEbavQs9u1Q5D2Ma9Uk/WtqICcnuxnnsuPcNOlusHHHtJL4Mj/5Vzc48lhwxcntpjBbXclfbkukMZSiPV4q4ncTc7NKFJb6AlBeu/GqsnGnG/LEoWPiFWau4E+ZgtTdXzmRkRMeD+1FYup/O1I1wf1ExUnkwxnFPEEeKiEFNlBDUHxG8Nom14lx4emWIRxGdMnXhWreqFKMeraA85GY0bPC2BXJ4hFO43aaMq7Vh+kVI57dqTdvMyCg3IVxEMMrSJuDudjytYe6C7hvulZkYh+/oz/uY2lZ+u3O0vcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ogVjF6fLJcLNgo0djHIo3M/CUN+0SAMZyzQqdm/g4=;
 b=A9uy7w77TAEsC5RMixi+ANtYVgNY6+Z7VimfRBRt6Xgq8MxLNjrIElwhblRCuM4WnErDnOloss8Pmen3ALqULFsfoNt7StLJGomRWBZ7qDCKSVE3pukmT6U5CI4SGBcFHg/+gkRa0Q9T7itbB9m0JRbpPNHgG6ip2XQsfGUXQt4=
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
 by PAXPR05MB8095.eurprd05.prod.outlook.com (2603:10a6:102:154::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 06:36:03 +0000
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8]) by DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8%6]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 06:36:03 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com" 
        <syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com>
Subject: RE: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Thread-Topic: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Thread-Index: AQHYkOsyB50XojkGrUyN5uJd+Qbw6a1xzXwAgAA+B7CAAAvGAIAAXfgA
Date:   Thu, 7 Jul 2022 06:36:03 +0000
Message-ID: <DB9PR05MB76416C4378B860BAC10CB333F1839@DB9PR05MB7641.eurprd05.prod.outlook.com>
References: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
        <20220706133334.0a6acab5@kernel.org>
        <DB9PR05MB7641A853BC76A3DBBF2187BFF1839@DB9PR05MB7641.eurprd05.prod.outlook.com>
 <20220706175742.4d40a173@kernel.org>
In-Reply-To: <20220706175742.4d40a173@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fe5c859-4665-4a24-c179-08da5fe2f70a
x-ms-traffictypediagnostic: PAXPR05MB8095:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 61APxbd9T2bQHN772jm4G95DMuKKWWvPc2r+fk/XtlJHfMwasm9iyIMSUKgjWdk5hcwwNdF9Op4mOBzTN9LMZM2oMy38EJhkVvjoDiiOee6J1y+wn5LQlmyhzKZjSjBM0e5mwKXBY+VaPBC5SZEIr5nvMIpRkzC32zti9QJt6ARtLV+SCSYuUw/pOZ1d8PtNCW2VzhwQWSm/sVyv0vPVHjirzc3mXxdILMAJtRAIxLrfcJpS7TskamkA7Tt8C82luWfhoC3tyQV/4h2Sh/7L7GzTKXY9jio7Fw+TWF6c0S5sihQavC9qLxkXo1jmyvy4kiDdjMpW0R/tR04D7rLmJXGV/ugNdh6DJpmfM+BX5ZzC8uUNCGPYf8rSHnpl8kmYPkAsJbNI6RKuyWOQla42pu6B7F5FTZ3Lo7Ls5YTl1NEz5lPQSFPy7DCI5GTnrQ04ykzP4H3uHrhqto9rV2R6ILnGgr3dYvMjxL1vnQDDE+9fXKwn0K5Ik58qf2+yeDS2jEujiMZEh2vOO+GzuM7bNWfV8359d8Xp0colCllC7H16BbITfrVr+3oMauQ5TLsgx3ewnStWGv91z/03Cifx+xwPuUAwDIHTqco8iQRIdnbu2/U6oSyK1wha5xMQBe9HfB2XaYx1c1ppLsVJhJKdT/M8O4yTh8rqOUAQCLvX4Yl4fHhaeowoDIaCM5QdfYqJopcGpWPWxgUYoaHSC6bI3CHgWeiiGC9h+SmwKuJOD+ZnyviVUXe7T9YwDqmCppf+FvmqrMlv+6eiSdu/dqz5iQ0zvodrj9xw9AtCovDyNtd09hEBFROi1Lc0hAJMZaKA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7641.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39840400004)(136003)(376002)(346002)(41300700001)(55236004)(316002)(33656002)(71200400001)(38070700005)(26005)(9686003)(6506007)(83380400001)(53546011)(6916009)(54906003)(7696005)(38100700002)(52536014)(8936002)(2906002)(5660300002)(478600001)(8676002)(66446008)(86362001)(4326008)(122000001)(186003)(66556008)(66476007)(64756008)(76116006)(66946007)(55016003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6jbC6gyH/8N4WxaaC3Ucu4jhyBb5lMapK2xdbJdm8JXBywFqfnQabh5vjMMa?=
 =?us-ascii?Q?GSUHu5HeAmP00hMNyPrUOJUlkkPja0/y0agP12gte60h96h/aNJfBWr76wMi?=
 =?us-ascii?Q?QZkh+wrxfdAEqQgafc6Al892NCjvkRTKUwWRf2QLbe2Z5qVA35D6Wm5v31xM?=
 =?us-ascii?Q?RB46vSIQdcnwwfwaKbnHABYvHTNGSG9MBlATUlXhgNTSiABwYBicWmBdvhbC?=
 =?us-ascii?Q?J1wX/56rM03TtFPgAubiZS0EH8fyh9s3fcp1IhgbDGxfm/W4FZTFy52HKH/h?=
 =?us-ascii?Q?QeXWt8waiZfwb5fIGP9aQO9Y7QS0IfdPiNztdOqdM0hBFYxTO+5LZU9gCa83?=
 =?us-ascii?Q?uNsV668SzhFVl6GAsRA+crFRkp1gVe7w39U3AbKAxQmkm+9GnxUMZUwWcLzD?=
 =?us-ascii?Q?HizupDitoC/C6ogS/ul/govfs5Z6IqbT79DXsgx/MT7+2D2+tjSGNEpon4IS?=
 =?us-ascii?Q?zHLJKPW2Py19HjP5LcqeGzJjd5unHgNrL8KMHyryYnCkEUdsEam757AKLBcM?=
 =?us-ascii?Q?wObyfdP3svlX7MpPr9mLG3PKfCn+wHFUG4RpO4oWlnACeG+7O2+h1WkOEhC7?=
 =?us-ascii?Q?478zxDicOAUoghvL4U53aSRdZwLqe6VN8C1bO676/Xbx+jqQ9B9sNC+TA+cd?=
 =?us-ascii?Q?cR3dfuFap99GI4p9jUAl/s4RORzFELb4qqZMw2T7qOV+NRe+IyA8BMQlhtDX?=
 =?us-ascii?Q?9rS1VJOpLFrvpBuB2lRAU82mzJ5eXMaDI+0unYHSWbAGTKfAFs8IAVNgzfNU?=
 =?us-ascii?Q?fpv7h+HKvXfLm2wAYz7SLEDQv0a7mq44UQ56tHWcvYJ0ZeqtcJC81jImPPc4?=
 =?us-ascii?Q?guix8LdqXpkzAs+pDVLjjRI8+lk3mZT5ibqEh/nPhFPP4nW0+QkQ8CY7hzQl?=
 =?us-ascii?Q?r+WplOck0Rc5yZYvppNwregZh+tVsKMA+kQZsJS5tWT76YhJs8tsPDdPyC8H?=
 =?us-ascii?Q?N/Tn2eIkU9jLdJu1RhK7f9p7u/xUjdYHpRhfRBqKPikECluS+QODStkqoAmx?=
 =?us-ascii?Q?aueHlplRo/HQsPPoPDZGssRTBCXvyLfNOtjWXMwgAVh+mn5Q++DjUsBY05+k?=
 =?us-ascii?Q?I79z1qkF0xkl0KV3QdORhaEYI2ShYoYGWu5dvXHUvZJUKq+pF2yCFrTu2fnO?=
 =?us-ascii?Q?hl1N0olzU4iqfcqHeqWlp0+6N45p4UDpCZVo/r4c+7m9tL1OkWIdFvdp5tFQ?=
 =?us-ascii?Q?WYXEAyZszIU2X8eNaz3I/7EqCHnu1YGlBnJE5Nxv/yC27KihdYPQp6HHP3AY?=
 =?us-ascii?Q?Jgyb6D4XBBbUsji3KIJER8Jkwpwr7atE7d/b0LeEfGqld6DQIasMcKQ86cTf?=
 =?us-ascii?Q?NpYVYIwjRWP70ydHdspHirzQPa2YVC0x3yQJ8jMqIYjrIBv9vAszZ13U58Mq?=
 =?us-ascii?Q?Y0lA1ySKugoKP+np5XUan/ceI4OeErFOQalLwP2oXO0pgmGwfmE27AqhIgB1?=
 =?us-ascii?Q?WfgONjy2MFE69dpxFf7pbRdwOEB/LfhB5JnbE2Nbow7vvill2bvd804pATca?=
 =?us-ascii?Q?AJf2pdcYZUmj8STaS3oJrFTqA5YblMuGt9GWFqhbo6mJtza7b0PXajNCkQ+A?=
 =?us-ascii?Q?3QTPDqpPPUa9ydcrJmESZ0aS/4x17BYbbBgsGqwq+gElKz2Lva2SuRbdEj8x?=
 =?us-ascii?Q?bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7641.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe5c859-4665-4a24-c179-08da5fe2f70a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 06:36:03.8115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uDwBWj5s8Wt/Lo2EwVlTOlsOJ3PgHvOVIDUb4JnsoQ9pzm3gX9dLIbGijnmIe9A+UK+lQPLEv/zLgKqVfEiCGruB1XmLPfRQULaZLgT0Cas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8095
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, July 7, 2022 7:58 AM
> To: Hoang Huu Le <hoang.h.le@dektech.com.au>
> Cc: jmaloy@redhat.com; maloy@donjonn.com; ying.xue@windriver.com; Tung Qu=
ang Nguyen <tung.q.nguyen@dektech.com.au>;
> pabeni@redhat.com; edumazet@google.com; tipc-discussion@lists.sourceforge=
.net; netdev@vger.kernel.org;
> davem@davemloft.net; syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.co=
m
> Subject: Re: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stat=
s
>=20
> On Thu, 7 Jul 2022 00:22:06 +0000 Hoang Huu Le wrote:
> > > The bug you're fixing is that the string is not null-terminated,
> > > so strcmp() can read past the end of the attribute.
> > >
> > No, I'm trying to fix below issues:
> >
> > BUG: KMSAN: uninit-value in strlen lib/string.c:495 [inline]
> > BUG: KMSAN: uninit-value in strstr+0xb4/0x2e0 lib/string.c:840
> >  strlen lib/string.c:495 [inline]
> >  strstr+0xb4/0x2e0 lib/string.c:840
> >  tipc_nl_node_reset_link_stats+0x41e/0xba0 net/tipc/node.c:2582
> >
> > I assume the link name attribute is empty as root cause.
> > So, just checking length is enough for fixing this issue.
>=20
> I pointed you to the code that does NLA_STRING validation and that
> already checks:
>=20
> 	if (attrlen < 1)
>=20
> what am I missing?
You're correct! I will post v3 when I find out a better solution to solve t=
he problem.
