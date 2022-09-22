Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93AA5E6CD7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIVUN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiIVUNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:13:25 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7391810E5D4
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:13:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvvz9lVpFqE1k06s7Qcy87RtCfNLWe8Sc1mwQajIfRSeGw56kJTLIMN/CSgPwyyyC018u2HSVHi+P0moku9lt5z6WxRR5mGu5UskRkkEZhrb8AQqABwbEpbfgYkRdWMpmiJTvZQhobosmJe3JPVUXr6jym0tPNGyxaOnFyEcpjcl9W5n66Ua85S7LFoGZEBxTn9Ls04MCAPDWVcwolYrhdlX6d0I7sAOQRrpt0RfLIiP2+IgOVUBEkC1TlUSr7WZ/smAb+a++bx4XrAGcgSm4NSxcjk97tWuH2cLPUz+7CXKG8nBqGd2eDNl+xZyjhVTURwv4tnALH6e7nB0qppD4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk+JX5rVGGvf1NuSsGbb6Nm5RTq8n7LFU7OxxcYUMTs=;
 b=JCW0ipj+miyNl/s2L1m/FITHwV5ZsZv6++GCUAGyHyMBREKHDpOwvK1IhmMN277/narjPo+TocrCKD4ASnJYWcROIAryAl3E9VrGk6htYBxvdBNANQdVOa8e9HlKIc6MsCEZZ9vmYO7m/x3U+F4U50I49yCEvC3UJ8VE1Ddf/QEuOyzPJGWhpWVhyjg+1GbBYF2UKpWkQUroBqb8t1KrKALSGqFQI0mcCJJpmfZho4LWgSCAV5ZUWwKbpHohr2IsCxyiVf9W1mC74Y34nsWkql1uZxjqbUIjshIbr71BWDytCDlWfz6pGffsSdl98/gHvonRAs2IPegGVdX7Fttylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xk+JX5rVGGvf1NuSsGbb6Nm5RTq8n7LFU7OxxcYUMTs=;
 b=G7qjjeZisFpKiN22SLOGbA0C4rMHSziSuHYWeNFeCR2WS+yCPpBaY9UsEHUSr6ywitxRA64XquvYpvTDciPpAgivwzl+eMxsYZHHTqve9B1dkBT0DPZQ20M+dNNXdrm8M5q/S/ChOSPw8gQRfkSFrvdNylra1KNjwmL4+KPWjNU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9131.eurprd04.prod.outlook.com (2603:10a6:10:2f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 20:13:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 20:13:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEPNgIAAL2KAgADHUICAAE1UgIAAGQmAgAAL+oA=
Date:   Thu, 22 Sep 2022 20:13:21 +0000
Message-ID: <20220922201319.5b6clcxthiqqnt7j@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921154107.61399763@hermes.local> <Yyu6w8Ovq2/aqzBc@lunn.ch>
 <20220922062405.15837cfe@kernel.org> <20220922180051.qo6swrvz2gqwgtlp@skbuf>
 <20220922123027.74abaaa9@kernel.org>
In-Reply-To: <20220922123027.74abaaa9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB9131:EE_
x-ms-office365-filtering-correlation-id: 7c268fa5-763b-4c0e-2c9b-08da9cd6e559
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JbxqlR4EswC820zqOVjXdCYL6nnBGPTfOZBnHL8Y9eIC5UCB7qAgwTV+mO/JOkt4CGEctT0hiZXmrfXSm/BSjDb04qIlLhsd5/QIZp5XGgvbFsVYAo106PQHZDwCNps0VndQEz2lPtqtU3MvOvbjuZvFcn0Q65GeKx8/1pm8JCHfUcKwqMpWIQ9CC77K7KQZqb9Aia4hlwSW93T4uLKycqKaY6Ok66sSDJT9RY1c9m+VYDHUF6ZSDiSlFCaAFArmbUga3kZ+HGzzXrmxKxgG4V1NdYzAGiRdJvX8oYlOvQ7qhSFv5jU5blN3Od1nIJwOqvYW99Cqi2t8ciffrd5V79M3TLALxEFnpOnulTkSzLCAmp6gnkJx167lj0v8jqBPP5HhPJG1HXuQZJuDc2S0n5mtUSEvwFoDl4CoWfNFMX0UIDBi5SFU6B+co5Y1Dh4ieuGk6yzpnpUD39mm0ibkGPrrgCEcGFD/jCgbGs7+veW0KLDd1ZU3/Y4Q2qD+OqUVvdxk56128ePPgHYR6s8QEr+r7LXSslxIUOG/amlNWs6pQgIrV4I0QVBFjOwCybgWRpy0R2KTVuHQvPXszynJHr/N/y34aPoCTQY2lh3krxc+fVJPSHiEeR4CPvYZro9LoxsR6Xh/by/eV68I9GOsLg2tIoPue6HcVu55BeyuUAmPvBF4QKgHa/H+pd9XCyHejdPNJqP+Z7Vnz+z8dNssOJDiWY7KTm2D/HrNXFK2ql3LxYGWONoy2BuZMxBb50l6ltCyfCnxLT1rWsPh9KhBTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(86362001)(2906002)(44832011)(4744005)(6916009)(8936002)(76116006)(91956017)(66556008)(66946007)(8676002)(316002)(54906003)(64756008)(66446008)(66476007)(6486002)(478600001)(71200400001)(41300700001)(5660300002)(33716001)(4326008)(186003)(6512007)(1076003)(6506007)(38070700005)(38100700002)(122000001)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WqvNCL9t2iXmBYg2tfaSSKpzhpWnB4sUiv+x1r9PP+jVnvbUZzKcg7/9MVMf?=
 =?us-ascii?Q?PvPmX8dfiR0Ocq1ZY65OZI9j2q31PL/tRG3W3Bq8FK320hshkEGYn0dlf90X?=
 =?us-ascii?Q?vZ7qHFXl8biKYu86NB2yuuAI6HmTSqJ4X1nZTHvsAjPDXl2RGdmEv//f8pi5?=
 =?us-ascii?Q?g6xDjA5X1pPn1RSG2B9foXzZYPf9AVSyh46hCR+nAJwuC3eO8UGprbop1K3/?=
 =?us-ascii?Q?8dLE3+Zw+beQU4zgf/IBsidyU+HocOkiNOTcI3fK6hRRD8amVU88AC0ujmCp?=
 =?us-ascii?Q?UdMO/ApkfDT8wwNGRIoEJ687Yu8LiMb/sz6rPalyfPYpY9jNKDM2ID7L5irh?=
 =?us-ascii?Q?nw0W2b/gZq/+NWNxY7iSnth/L6rcT9i372PCz2wm1pMMlfkeeeuibdYWwIK+?=
 =?us-ascii?Q?iJzJKY55JDQ+6BWnTV07ivt3pEd/09PLapsBJs8Lxgk8LNmVELrWEpcmyN4W?=
 =?us-ascii?Q?JTsoDSvune10yOvl+Q9Q5VhBMC15/0yUHD6yrK09IvFRfKBd4aIme7pLT9SO?=
 =?us-ascii?Q?fQXyv0Hj+igZ68eoL/6T3Pkq5yH9TRyqtHyPPDQ7d9pdMevKXUeIrhG6ZCyH?=
 =?us-ascii?Q?xFs+ZQYywZza2MKJp2KInSHJLJEPiRHQe3/dWHZnoRm12UUjNg5o70H83Y2R?=
 =?us-ascii?Q?bMPRxGyYDE60wpSLt3vGt+urubJq7YodIKNxwdITni7TY7wC8OesBMCdntiZ?=
 =?us-ascii?Q?sqwOYGEbaWowNhJ+W3zAmzzYDqnCTNIUjmeyd2Sd26cpuFhjbpY+d5/qLjny?=
 =?us-ascii?Q?iYLnATWciH1t2zLEskMSMfZ+/jm6/A+vz8H/0lU5tTLX9rK+hwB5CEvPCyPV?=
 =?us-ascii?Q?wNxM8MbKAg0Ycyzqnza5WEBn7S/AKoZTd5xrn/QYv1ZjIGuQyUz3jSf9eQ0t?=
 =?us-ascii?Q?M8Kb7xrNEGq51JDqiU8pL4Ujx/+1fNC4bQJ5h//jCDjnzmOw8WSlpCxwxwDu?=
 =?us-ascii?Q?PfyE6R3HZdimH9NvfzXvN+lz7lZjtMg8RtbOsdzKu5vTKBScE0b+TRgRv07G?=
 =?us-ascii?Q?ntu2YxuJKnh85UeGLMJeyhZ47AtaHV3Tn0xdsPscvzc5HexVJ2NlTLBrsP1D?=
 =?us-ascii?Q?3w/1iTECeJHORlYzNRlhS7WPAVilHgC7KUQWCsXC5fX9B90PCskqX2bYxUoi?=
 =?us-ascii?Q?YRzdrHfTG+FDYSMyGg2RFaBgPJaCePUQ6pi7GWXWQQj3IUg2bfLDRlWposLV?=
 =?us-ascii?Q?WQi/fdIYx6lTsUnx3XT1P+6R8ICBT7hUctg3JP0xwnWte1Lg+7Xp34AnWNhp?=
 =?us-ascii?Q?fj1uVM7uB63dWdVZsSjavHEIOAuxuUUy8NNfyOPbUhAkIAGE3nZcSecnS6P7?=
 =?us-ascii?Q?wBkYwUscxMwXn3DlwUWzMwqgmZl8FPf7Anz3gTErEWuS8pJ496O4tEWypHdY?=
 =?us-ascii?Q?BkVJXanV6YrVOwsrgJFjCpvjVEiIv0UzbDtVQsCrZD/NZ1w5R+O8id/PCWWY?=
 =?us-ascii?Q?/rbMy0UyeMdqUTuDMcFWnbDG7Xgl1qFX+yS00ETEcEkiL4Ew/UrQ2C4/Db6W?=
 =?us-ascii?Q?z4F9CI6niWZj5Y8GbqA931hOcikfPHsO5jL98PEgfAkBTmJRo46IS574FVFu?=
 =?us-ascii?Q?2Lc9Ycwu5/kMoWJB6wBfxsbA9XRF6sEUxyIDbaoz/t84DhQlmS6yNoz1Wpib?=
 =?us-ascii?Q?sA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1664593FC3E9834BB68674A5CB947455@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c268fa5-763b-4c0e-2c9b-08da9cd6e559
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 20:13:21.0951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xEpQ09bOyDX7O3WjzytiBPIBobeO3GwxNn9pCeB5bZLTmW/1Zo1KScdOGURXTjtpMG8eVF0bNGU78iTfGJVpxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 12:30:27PM -0700, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 18:00:52 +0000 Vladimir Oltean wrote:
> > As for via, I didn't even know that this had a serious use in English a=
s
> > a noun, other than the very specific term for PCB design. I find it
> > pretty hard to use in speech: "the via interface does this or that".
>=20
> Maybe it's a stretch but I meant it as a parallel to next-hops=20
> in routing.
>=20
>  ip route add 10.0.0.0/24 via 192.168.0.1 dev eth1
>                           ^^^

Ignoring the fact that a preposition can't be a synonim for a noun
(and therefore, if I use 'via' I can't use the alternate name 'master'),
I thought a bit more about this and I dislike it less than conduit.

I can avoid referring to the DSA master as such in the command, but the
man page will still have to describe it for what it is.

I think I'm going to give this a go.=
