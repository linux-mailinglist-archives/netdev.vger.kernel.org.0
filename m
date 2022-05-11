Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE765237AA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343917AbiEKPsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiEKPso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:48:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033416A43C
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:48:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ug9h5rsGSsNBcLQQnQqb5Fk7VY5I0hIl1iyTeG5tKxbL+M0eh4QalBv30j+pxC4RmwBUkaoSLZv1O4q10l3sKjxU8vB39KdcJrST4kFxoWVwTBI5NYqNvbpVh4mstG1hpbuXPb7EPGqPOznqaRBOLD7fROjJt+74mVQBxAAWWgR+n5GE8SdtaG/bxF2+erPJVt/o+HTsZCQAMFvBsMdk5dOL2xz6kTA3D5Fc9jFgCBxCzD3EKNyhEOu1vMgLQIyNIePQYdJvXSgPQQrxCy9bY5Po2vKiyLU3GHhXFeXfUASfYmz58mrLPSxQVNOSNWvcjc0qVAtrNdTEsw9O0SpQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/JpEgVm7CFimbl7kWi+U9GSPkbIHqT8xiX0wch6+XM=;
 b=I24gnZ0WJXF/Bta9ery1RKzZEcBTjllOJ1TunuKVgM00kl//Rr4Pum4iQzUOcIYzlNPA+6coiZ7ZPpU/pbd+Q9YA7rF/Tg4/oU+bmEDX7Gz6RQwkufRaUIKPrBQ/TH57c+dJTetycA/HIoRxpZhvFZN4QN3VlXnLmUI2YlhIHtdYl1EMpQGG/kCPPu0+rlAhCQ+MKVC9vLGyhkHXEc3sqPDXK77A52hieinMdjmZ4R3flFDbSfHIf/OnOAQLhFH1NWX4/NduFVIdR+KuT/f+tHvfgSQNe2ZTceM1iARy0zdOOEJvpQsEaqWxCatrNL2CkV+SRZ3Tox59rnr1f1DhPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/JpEgVm7CFimbl7kWi+U9GSPkbIHqT8xiX0wch6+XM=;
 b=LM+pSmt1oM5u9PXxdDylGL7tiq25zIsO7aitc4797XtByblOHyl9rU05b499LihRCVTF2AfD/qd1umtt4delf8fjCa6Z7tafGFBkGZCy/k7Mcj9Qb97dIRzRSLvVarQ4hm958YbHb6CYzQ++yKyG2gWmG7nvJz+7VrualoKzUXE=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DB8PR04MB6380.eurprd04.prod.outlook.com (2603:10a6:10:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 15:48:40 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%6]) with mapi id 15.20.5186.021; Wed, 11 May 2022
 15:48:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Josua Mayer <josua@solid-run.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Thread-Topic: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Thread-Index: AQHYY6DnAmQzgFUDN0Gk/Ykea5Hhha0Wf1OAgAFQ/ACAAgWYAA==
Date:   Wed, 11 May 2022 15:48:39 +0000
Message-ID: <20220511154838.7ia7up6uys55nc2t@skbuf>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
 <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
In-Reply-To: <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e32bd77d-5c48-47a2-dfda-08da3365b7cd
x-ms-traffictypediagnostic: DB8PR04MB6380:EE_
x-microsoft-antispam-prvs: <DB8PR04MB63803776873841313B0B2574E0C89@DB8PR04MB6380.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6uSQYrItFbYfUvPSpfujMqRIRpszUSfUjhKOdxfh19rOpHvdATMRFKW9osZWZRyoWSIivn545m4cVrmdotWXZWWAhVS8fDmBZ1AWoca3vBuPooJKJGmk5LCzE+FsIQ98WuffqceQfzsfHnXH7tqWJDkfhT/tKe9mKGvW95k+WlPbEJuxmyIhiMjRoQ4F1QN/T9wdIpv9wi0GKReP/RNO/ENpyIOrtrJ//wVD9ZRFv5QOUvA5Z3Fh6Ph2eCJLkuYX3Bab52N0wzdOPOKbdl+qNuNr6Z/35oR8SKiDVpcJs0NscbWBIie0zdkJ4mPrYDZamGgA2tuY0oBRej4Q4Xe7NvjsUrUVYAYIEP6iYQa9u70/5DmyGbUlbp7aa05geNxQTtCH8aWNo3GrQYhG9DCCcIEYIPkHWUv5a/pSvxEliHOMRlZsScfhvEsDqj8iHba5uCtRGyV2x2REfwZAc2+NJC/wGpZK20RWRuvvY+ZQOOW+HbiPbBaLGfSBnFR+61dPtAstRlb3lmm0F90Jrswl8llOZi+eChI6vNoBSnio5w4j7YoDnlVYAGAZYNxayf7kQC6b0Oy1F7fEJQNaQwW0Be4NWj5r1ULDPwR0PeyXgvs3uKOtpV3ft/+B/G9HiRg99lR0FyJJ5XNsGvridJh8FRqaAfTGNFtDCbm/zFzw8KRZ6IwPYzJRCqFsVPtgTBkepmNbE728HzY5SBuKntJNKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(91956017)(122000001)(6486002)(186003)(71200400001)(6506007)(1076003)(76116006)(54906003)(66556008)(64756008)(33716001)(508600001)(8676002)(66476007)(66446008)(4326008)(66946007)(26005)(86362001)(9686003)(6512007)(44832011)(8936002)(38100700002)(6916009)(38070700005)(4744005)(316002)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?90beLeIWpxRHgnWEUFwJc8ydSfGqUGzRJ9yQ0RHk52JoXd+AJNca11hFP1lG?=
 =?us-ascii?Q?hQNlKhlibtpW8ULSAAw/x78ZDA7NUG05cayiGGNk92tpd2VkgDk/PS/rM9HY?=
 =?us-ascii?Q?J6D2/D72/hyqagvu0O3hutOm5uTi4b6w3cu6zCqvW1bH4Uv6uwEssouIgNzU?=
 =?us-ascii?Q?9qrG4QF4ONYDTOPSKkZW5xTrhapFKa16u7FcbYRhxBP8mmhCvhr0tlOkAKf3?=
 =?us-ascii?Q?7/K0v7rQnlh14dXA2G5wM/8KxoHl71KStM4pwefXr25Vk9ymFrv//fM8otuc?=
 =?us-ascii?Q?l645/GXjeflGBtQXo+IPKM8t3fyk0CgWukImXItHONoS2fEwVRT2Iggu0HRY?=
 =?us-ascii?Q?iXuEPWPtIhrhtPq+5MYyKVn9wgpt4Css2wmXTNnSS5elcCKGUkyfLmiAijwM?=
 =?us-ascii?Q?MMVdWNplycy+l7cKOhF0cQ1P24f3McYvvlyQ4b67hRC89HrUQFZovUbAn5RI?=
 =?us-ascii?Q?r71jYolHUbpwUqMdOa65XTys6/JaP11He1JwtQE70bbeHRI+/h4CvjJKdeZo?=
 =?us-ascii?Q?D+y5yWGwRzcKsEak3nSC+hc2Dii0u8/GqTtpkxDI/OAX/KIp41+3buuCwoGi?=
 =?us-ascii?Q?VUDeztQ3r9eVbK5llItKv3ruX3WAsPN6n+G6OpE9+dr9n6mEdN4i+I6wpsN1?=
 =?us-ascii?Q?drJkHuHEY5WWk95izbTvZVCS7ZAAwkWn0cWjwGnCmgMudEwIoT4mIP+hiLCb?=
 =?us-ascii?Q?VKoej8ciXjgro9vJaycC2+UUfL/kAJ6FhAF9wzE21yvuysIsXwVhUcu1OuMu?=
 =?us-ascii?Q?LXjKeNzanM1xoZgp6NknO7TqDCDBMZH4NbLKwV32bGKl0HOqGlkm4oW9cI0/?=
 =?us-ascii?Q?pMUE2u1tFdhcgSh3Bp5irsPBmZOEAwONL19gbjjN1hnr3hPg/6DlsP7pHB0g?=
 =?us-ascii?Q?2kdE67gm0vFcoWwTdpjqs2LAzwmMXG5b53f1Eqnhl9yfh+70sLMjL7mBDqP+?=
 =?us-ascii?Q?qfPR7u2aCEgcKDb302gTeQZ5jHlbSDHJlIDRbbK+BBGD8K+M8MTFvPBiIM4V?=
 =?us-ascii?Q?Vgn7sXEMI/x7Y6h8TLRKA0bFXSw6twgM/fcDmOSSgMpiz5IiagMWFZ4bZSMU?=
 =?us-ascii?Q?2xqzB1YhujYy2/SJnL9yw91mhXiWUYC+PTG/8jw/svWqYzN9XpGnKCVLje7V?=
 =?us-ascii?Q?dGuBSFHVcJB2zG8urwOdvG+sjKWl0v74SDbo3ZtE9aQ7c7yW8gUZO4y7HS+M?=
 =?us-ascii?Q?gHBdblAwSytmnD4i8UY1IOZOKxnvV/pShAPTun5n+Ldeoftcj2sxxXOiWBda?=
 =?us-ascii?Q?hjOrPXugX7ajWoKiDYWViSngHq5y79Ly0MI67gm6iq/MQ8aPQxYDedVHoViC?=
 =?us-ascii?Q?6r0fKf88wB2WnkTqlIXVXd8BYBfVn+4mCDmA6jwWJwuVEMO0587KXDjT01oU?=
 =?us-ascii?Q?zVgrTJxuZlB6kcrRA+eTyUVTUJsZ/SfP0pzHIh3j4VajPzZWSGiNrWrqzKw8?=
 =?us-ascii?Q?Rf9zvVPjXwpf9dJE5jAWNpd2AS3ErExrH/eJI5yJpWDzTSZQzD09oYrP5dCv?=
 =?us-ascii?Q?WTuRrxX5pQq+WXljMf6C5f1FYP8e3v5W5wARcLr71iiPsKRszx6KDhie19da?=
 =?us-ascii?Q?VMQuY6GUC7a7rvmlDVk/Pwg679zLRHzNSQF0r9+z0lqJkbGfokVL/F1mUllq?=
 =?us-ascii?Q?swMD1Fhmt/jAntV7f/yATTfh1DuKJmbO8iu3/VAzYJGOwdOzey6JxUkPEvr0?=
 =?us-ascii?Q?5O18M17kTlqzG134r4Krh1r3qbh6jBFzBVXo8I0otXBvXBRPrz2s1GPnZxc1?=
 =?us-ascii?Q?m1mzVrRfskpr0zmfOzqLaGP38iR6dAo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0DA56883649CE44B62D50B6926A1A47@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32bd77d-5c48-47a2-dfda-08da3365b7cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 15:48:39.4157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VqglmtOw5O/h84ESVxeDKufYZJPHgHSvM95jQypQ976brdrNCLGQnx53etIDeV0XEg53ww/KRvWj6CH4XAGUjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:56:06AM +0300, Josua Mayer wrote:
>=20

Hi Josua,

> > > On the Layerscape platform in particular these devices are created dy=
namically
> > > by the networkign coprocessor, which supports complex functions such =
as
> > > creating one network interface that spans multiple ports.

Are you sure that by multiple ports you do not mean multiple SerDes
lanes? Otherwise, I do not understand what you are referring to.

The dpaa2-eth driver will register one netdev for each DPNI object
(network interface) and will control/configure one DPMAC (MAC).
There is a 1-1 relationship between these two.

Ioana
