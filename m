Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070B55E6D1C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIVUhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIVUhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:37:03 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2045.outbound.protection.outlook.com [40.107.21.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C831FE046
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOcpF6V+MVhVvWRj4sokVVoXAVwXF7v7aTZ4MhfrWsoFfC0Ahacu1stsS2cqypKVfuX+fwHLSH0UzWXScbBuwImkpaZxO0rGzMQv8nz9wuu+p0MH/KDrPWcTZ71YFHS2polufYEU/l/rYB09O86EwmhJnW9gARo56lHAY9Hfr1q3E2NQwlkFJ1rR0LmSpNkQR2jHOYz8VUtTQoW/Vx8PTfQKkZxRS8vKFTcfeoO1F5eFSheXPwek+knausw9BSMs6nQAXeTPRIv2us2V2EUY9UdGr9Df9SgJBHVihNzSa2Huxe9OsNMBzqn279ul2gxp7KgUqTdBQguwLMdL+J0DPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pToLNf1PwVasGhyY9OsPoQy2QbwvJ2IzUVRgg8/05tI=;
 b=cQFKcxlDi66X0eLwq+ubBnpoqcNgC7zbztIbTD4US18hIAXg8Sgd81RavL9/BkmxqsgFtYtRn0XV9/7mds31SyAY0up1ZPfmluTr4qCmGGdx3CfQF+sBtqQoXcdB45cXcC2/JhKPxmJhyZl3OndvPVYL2TIsaD8itgiRTnIsc2UYPXrmrFsuITvQg9COyFYcsf/+IRnwg8qB4IsO7AdpnEggDusPBWe8SCjAhOHL7GrgcKE/NOzoJpMFY3SkSxKTQwY89f62tLWOZVZxyF+PO1Ij7Lm6Vol558xK5YXtyhLL+n5w5XLfGuBxAtY1pgiaeKrTq9QvC7d/n4f3zwdGCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pToLNf1PwVasGhyY9OsPoQy2QbwvJ2IzUVRgg8/05tI=;
 b=IeI1FCpcsWhVBaylj4YwOPJehH4CcUtKTnz3RQzJARlWIqHOZZgLHvHFvuC78GEssQ41e7HMb/qv7k3qapt0Mt5s8mIyLLYSB6gPy81mMBRm3YLZrP6GtRqWB0XqhRebGsqoFJcEkGwTSREn1m2wyNhI5HkQFSGbn1xnq2++Ht4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7399.eurprd04.prod.outlook.com (2603:10a6:10:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 20:36:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 20:36:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEPNgIAAL2KAgADHUICAAE1UgIAAGQmAgAAL+oCAAAQtAIAAAm8A
Date:   Thu, 22 Sep 2022 20:36:59 +0000
Message-ID: <20220922203658.6y2busc4p3mjfp4f@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921154107.61399763@hermes.local> <Yyu6w8Ovq2/aqzBc@lunn.ch>
 <20220922062405.15837cfe@kernel.org> <20220922180051.qo6swrvz2gqwgtlp@skbuf>
 <20220922123027.74abaaa9@kernel.org> <20220922201319.5b6clcxthiqqnt7j@skbuf>
 <20220922132816.64e057e7@hermes.local>
In-Reply-To: <20220922132816.64e057e7@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBAPR04MB7399:EE_
x-ms-office365-filtering-correlation-id: 3de8666d-16da-4dbc-0546-08da9cda32a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YHljvfi+HtI/iqt8GqosEW9IiaF6OMl7xA/Ea18pE2sEJUhzO9vTtPwdbfA4m1IflfhHZvA7HqzzVWCfjJZBSyW70ebKdYiifNznwEcLFJ0ZoopuLnG8NrBfaGxRJ2znVHfxBtR6p/UbBzZe0iQAFFkcUX/Ua9/Rf7xdSPvgQIPfIjj5AjmT10ocNze8SMcmPwLrLwhM3O1hj9ISf/VHrDd+96IvPiF4RcqAzzrF4EZKz9WVttoVv/+dWQmAoYwz6bJJocWt7k8+SnlDqc+bW3ckvHJoYitc4tGLQjy51jvLpurh74iLSqfM/Xx9p83LIThssFNyEhek+8d/JBkKyDeV9HYxf+NRMnANB+wJI0hCyZcUb/w16IzrhtNNGVAPKaOitXtQ7iJJ2GmeRRK3XMUl9P8nfHIq86PRxjm2uXXhs9ujhkHkKOtPav52pQieO9JjmZCKUI9mncqF5YG4JlyWlz9Mv6X+VPT3aEaxH0TTDJuue1E2FyieYKm9yLvqv9EShyOMVG5QBW39jUD80UuDuh3QTYBtVm67j3O/nK6couhHEqt/cUasD7VpB1hJbdPFjCj0J/sstXCWNZ9AfhESWP5OcQpH4gNk0GaQWF5jBRGVcAV0YOxTXaZivcT0NADDCTipqt+dECcJle7MvpyB6/nMC5YhNU7FOcF260+YK7MUIVuPZFF8G7Tb3Ji1mbuu3MPDS0eVfhEW8H//v1fsSTFdYMRsIXekqzTJGm1estIDaHZjuKdYnQXpTPH/bmWrcgQTczVFQlTLt5oTug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(5660300002)(478600001)(54906003)(33716001)(38070700005)(316002)(71200400001)(26005)(8936002)(41300700001)(9686003)(6506007)(8676002)(6512007)(6486002)(4744005)(122000001)(6916009)(186003)(1076003)(44832011)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(4326008)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R7c1TSFfAO1tQNuKZlEHitZCxSfuULzEz/U2d9PKTp2ulySv7ZFkOVexb9Uk?=
 =?us-ascii?Q?HcRl3xvoGcheERVLNjfqxYn0Ge/wd7ssckBNjtL0FSZvDwxKezIbWwabo1U2?=
 =?us-ascii?Q?BUdaaX+lcuSxuKzR4nCgDVq7mW7Mwy0bbJIff7JyVI0c8qMQ6szVSeZm94ux?=
 =?us-ascii?Q?IFGR3SZPkWeDf5maqKDHl17TafmDYR/D0uxxTheBfOuZSe/8TVV7OqPXuuZd?=
 =?us-ascii?Q?BuCdC7rzNn569Pth1efuXOb5owoEI9SrqjGa3ICRNfIKuiECnpvfsV4hwAgm?=
 =?us-ascii?Q?3jaqPhVsOykQTCLyNVQ4DlFYpZnKb0Z9tu9vLjCyQAjM0qI07OGLlLNfxwgy?=
 =?us-ascii?Q?j7lGaaQiZJPzwtBp2RfBHqOvkq0yBowYKFq26UCCQQdlzl5WmwFwQJdhKmM5?=
 =?us-ascii?Q?TAuBgwqHxgNgfHjVSl8Wl71t8B/KCoLH0xvBYts2oN5+KzobNcsx9AD2BWPr?=
 =?us-ascii?Q?23C9NtNwn9alfYF+zIna4ZTs/w3m3DC3gMciqYYIPKXLGJW/bt4I1COWCN6Q?=
 =?us-ascii?Q?FcqlFVtUh7x/jhjIgESQu64KuNZEQttoKMBYNFWlLt3wAOYZLP4A9wizNmZs?=
 =?us-ascii?Q?CP6o1Z8xPq5fNmZ6SwiOCGXkDGzfvLdgfDoAKvWfvG1LkyDJfUxkj+Pfqdoo?=
 =?us-ascii?Q?2+A9WXNFBx6F2N3OlyE/VPXWTB5a7k6FS3wYvErcCg/GR7jBKP0lD4Lw979A?=
 =?us-ascii?Q?xr2pRH8VJjuJC8Vx4PoUPvvX6o6QqM5AmEyYj2VRejKnq85iJOkXFHdX3RxU?=
 =?us-ascii?Q?SkKXGS5DO+SIZsnXvGE61fcbdhRiJCmgBzuT1IUlxvSExOeSz6AKXfqTJpVL?=
 =?us-ascii?Q?m3mLRUmE6iC4SBZXfQlr9bSpcwZ79SGnlkSCHkEzo2Mlvr9eY9MwttHNIf6r?=
 =?us-ascii?Q?fiS0yCyBz+AhPN2JQ4plBCgXhveiF3n5vZOmyxD9zmlgS/zyeh122eUHH9tR?=
 =?us-ascii?Q?vRLmEHfggVdRjOaKlFuz8rbrcp8Ehu2C3OfxN/mPFR9PI300d/Lpf8JhW2p+?=
 =?us-ascii?Q?1s9NlMwzKjqWoM4FWSIUohQjKRCTXRWRJvZW2hi3mY4XwKzpRxQeR0EQLfuu?=
 =?us-ascii?Q?bdQRtaSMPQLo5FbYuwKPKBTnFmowWKHxkSKbdcfNS/G3xFVm94QEvHS/K9od?=
 =?us-ascii?Q?fPkqC2AvL1+IGM1Jok6KtlT0F75rRNLxipDb9uc7K40wMVnilu4gyh5cfUUB?=
 =?us-ascii?Q?rwRIHzGFJyG2+PO2CYyLgDL35WbIL+WpuZPm0/5hD2FsPzuRVj/yHE2BJY7s?=
 =?us-ascii?Q?1W77cXJnzHqtWUMSTQwFgNFme5c+G/TQpJXCdbMdnL947DNxVo7SUhuzfXej?=
 =?us-ascii?Q?JNZBblsVrExMjwihq4/K9DJXzHtDRLqGVSqKVcn3ACsCqCpJdsb+flIjeCpK?=
 =?us-ascii?Q?G9H3HLafchEvVMOW8INorkqU3d1eN41eUS6b4zPiy4kjq9Hrm7gi8J7K5vjl?=
 =?us-ascii?Q?bsPb6T6CPeNJ4zvo2t22ofTbdevVbEMssl+C8xqIwn/yT1B56IBNKcEe9Y5p?=
 =?us-ascii?Q?too4U6GT0WEfBQJ8ysd8IDlaWyCP/Q5g82niTzvNVb50m3FR0GILNlokpxIb?=
 =?us-ascii?Q?oB7IX7Bm8ReO71Gt/L0RVjLPDGxOE2npDhxzSCE/trrNtzzDRsGmQqlyEzgF?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <667D647D9690934B92ED0EB9E77E169B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de8666d-16da-4dbc-0546-08da9cda32a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 20:36:59.2291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TuU2Bvrt4P1KT0bVL23vTeAhJ4wmJ/eUwQdlPNAO4Syq+6Q/6IKcYUVEUoCZ2+TkhEyIrwd27Cd7lkF1HDSUlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 01:28:16PM -0700, Stephen Hemminger wrote:
> Not sure where choice of "via" came from.  Other network os's use "next-h=
op"
> or just skip having a keyword.

Jakub was saying:

$ ip link set dev swp0 type dsa via eth0

meaning: "make the locally terminated traffic of swp0 go via (through) eth0=
".
No direct relationship with IP nexthops.

It avoids saying that eth0 is a DSA master.=
