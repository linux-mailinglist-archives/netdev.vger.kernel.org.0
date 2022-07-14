Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A4F57479E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbiGNI4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiGNI4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:56:31 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2090.outbound.protection.outlook.com [40.107.22.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3103E40BC0;
        Thu, 14 Jul 2022 01:56:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEf9vEt4NWsOua2Ank4Gc4/HlMia/S67//HX878MoJ3YGlJ4J7+LHuELieRtPNw6bX9xtm5npT20cp+8tvzAFNdlsRyWWJp8Ii+OIw06h02gbHSgOuM+m7sV4/IxbgVsDbK5vFBd9ZOv/N6cS2f0tx959I/uFEneRZxl9mT5Atsb3u+In6l3M82Er+MXjfD2ggXcIo7p+vVJpFBmfKFtv8xQPW17iXrXqcz557aEvm1tSCAlle2rl8PcaT5Y3Hzda5PC9Op0Sxx9id9CcYwi5SPRc3Lp+B2NozgAoA9/5yk0g88mPFNfk7bi89eC/8q3836pEISAmot3cUfB/RAfUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a00DWVyga604T49/a0NXD7TOvkTOqNUQhbX/MnIlqD0=;
 b=i3MzuvjsWk6NelT6wtkTVhBczS2K5tp0iGUNYnTqDkHrCwWCNppz8Icr1Mxm/ZIuw3D7dlrt9Qw/BUllDDonJyRXweloY+ZBUm9I3867P/ZcUyKcUWvP9wXwZOwl3/kyKlS5CUUr5HJUCnWJZfiHQM291O53VtX2UisJOZhiUk9N3HLc2fZlOPANlj+XZVZoI07gBXLYPS4zvNAOOdCtzDIRTAs73HeOoJxWR4WWQz8oyRGWfsrvWOdYsKHcEL7T7yhKbl57j/78tz/Yjdd/OFpa0W6UTBhq7v6DBOboc5DcjkVXygcTxXCicFTmqJn2ckP/lg3geZPC9LiEXkAdTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a00DWVyga604T49/a0NXD7TOvkTOqNUQhbX/MnIlqD0=;
 b=WMOzOXzbXBy1aVcoL6EU2gtC5pnWGfjBi9Sw+NVzyWvge23q4PWusX6W7Dvq9msLFEvsoFmDlMI56mYtvhTz2sIX/PVOxA4ZmYFrhvrvJRujEYXaYkGwq+8XgS0cURIbsEFcEOlHUN9u0PzBtHCU84m6xyHUgaMl90+oBJtihY0=
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by PA4P190MB1168.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:be::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 08:56:26 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.023; Thu, 14 Jul 2022
 08:56:26 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Thread-Topic: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Thread-Index: AQHYltzgx1x7mtWY70C8ofiTDPrM6618ugmAgAAd/YCAALk4SA==
Date:   Thu, 14 Jul 2022 08:56:26 +0000
Message-ID: <GV1P190MB2019C2CFF4AB6934E8752A32E4889@GV1P190MB2019.EURP190.PROD.OUTLOOK.COM>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
 <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk> <Ys8+qT6ED4dty+3i@lunn.ch>
In-Reply-To: <Ys8+qT6ED4dty+3i@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 2c0156a6-7033-8cce-c250-eebdb192d472
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7e2754f-e3b8-4b4e-b7b4-08da6576bc61
x-ms-traffictypediagnostic: PA4P190MB1168:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MK07YH9xn0Xfyk40LZwnLH9XDBRntabQb0zFrA+31XYDpvWulwXkZMoxsbtDpIIdnbKhiRBxt4tomcmInGqjn7gKLFix5ckzviZSAnuHcuflrLAQPLFmg2mdD6GRFgOb9RJfxc5sLH5UumsD4+zXdXE/JhfdYH3u265GusHlJt735MqkvPhetvhT29MgMYqPqz6Re0I8K5Z8oKZXlW838aT46zozze+ArHQb2nJ5Y2kqaEu/UK4OM4y6inH7M4O2Sk5u9NYik6ErDUWoYty8fnLyxloYjA1i7kFuisNOgvhTDqKOhln1JuyhNgaujjtLq0EYj3uevGyWu48KX6a7V2uuefikZaDdh2G2ZIQH2abNYaz3fytxHt7VSTp1Tp2vER0+Hacv9b6ZLnBuAqt0CGEjm8MEmAVW4nxWHnvyas2SH3hE0h9p9gf01LPZ3SdxTIesCZ4y8AhChkPKV7s7AXRhqbKLRuedU+WypzWIrz0d7H+D7nlg3HWVLqVpkqpuZx4+n/80rAKz5e0FDgeY9GiWLg4ABmltICxtb76dbxb5w36EOzY4WZQQ4g/16HsT9j0vKLkFNe4jxWAAwNiONBZDKHvCVR+YexNERMdne7Rga2oTy+D1H4BT2EmSVS2o9B+SQQ/1fipwtz7k2XzuoKTF8pyRgheVRaWcPuRPmbB0TvX67/e6XCGBGrqjf4AGREn9lZUw3Dr5bNp4hlI13fKKB4QdkcFzFZCdutA7XrJWN5sx9xSLYLFAyUQM72tTiEQoiKRm1hFMbwpseI0WGuJkvbuNAm9TEVqsz1qV4O45hpjwWt3hfNf/bwWMYVc3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(376002)(396003)(39830400003)(9686003)(26005)(107886003)(186003)(41300700001)(55016003)(38100700002)(6506007)(2906002)(7696005)(38070700005)(44832011)(110136005)(122000001)(54906003)(4744005)(8936002)(5660300002)(52536014)(478600001)(76116006)(71200400001)(66446008)(8676002)(4326008)(64756008)(66556008)(66476007)(66946007)(33656002)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?vsMlqcXw+KjMHRHUmzXvghVE8cnIm4lWg6QHNSfIG668xBKb5s08FyB0Qs?=
 =?iso-8859-1?Q?X45k6fGlMen70fxvvn58Ujb64a2A/Z3FgTs26WhC8S2lEzIb0afsRgOH/f?=
 =?iso-8859-1?Q?bxu+IOx2xaCHMjaz+SLl8VidRLnb5CzIkXcvv+zLZ9tbiVJtBfps47XhHV?=
 =?iso-8859-1?Q?7jQ2xOAV8h+/JltJSCtAlGEhBTJgH6BDXBpbIKrlpXnLKqcKiFTkoF1AHq?=
 =?iso-8859-1?Q?yntxRHAo6V0vncDiR2+4aJn+5d5vMtD6o5cNtfNhT9BFaVU6x7MHi2KXYY?=
 =?iso-8859-1?Q?zQ72C9/T67msyhJND7a/b81elY/q8bZ8ItyRrr4LRjHX42hNHTvux+E6se?=
 =?iso-8859-1?Q?6W74MGvaHEM4gyBem4DXfGs5nQtZOu7V6jbysUoz/83R6bmSzt1U2/pT94?=
 =?iso-8859-1?Q?HqioKQRnnwwwpCLLhw0vGTJJSqeg2B5qn+tjhQdAC8Rj1CXj1dN+3Qp/Mf?=
 =?iso-8859-1?Q?F7OGY18kPennXBI44aTzUVfXO9kts1pu71bdD4P28biKJS/lEWaee6w7J/?=
 =?iso-8859-1?Q?EKhH0UuUZcZh1tFEIagN6xWA5jqyWV4cTnDsyTG4QG8tGZYAtloniFycYj?=
 =?iso-8859-1?Q?EHK+dF9ERrUU6lK1fctTvE/l3VqF4elYyi2ca0i7abe+PQFaBOY1kaCrEi?=
 =?iso-8859-1?Q?wBphiYsaLdgA0A6HwQcUiyO35d8ahXt2KrfXW25IhTGFvHRB3VFbbPtFxn?=
 =?iso-8859-1?Q?wYYoLkYX4lIn/Ivp+gM1lEkujuMjd0m7MQSfnBiSkE/7gC1ItY+23B79VJ?=
 =?iso-8859-1?Q?yJjCUsbL3yrj7Vlv1izloCevPUn0i6u1KK+plzS9a2eVVgmeaNoqDRrz0z?=
 =?iso-8859-1?Q?LXIkg2qUUH3I5t6+9WJRmku71GqsaFSOvNq31Ox9o9KCgjs5yzvvupnEb5?=
 =?iso-8859-1?Q?dy15Zz+OlhCThqAxTT3RCY+Tz8aVgKfl7nMyhnp4GF0rRG/6YK1Nby1I3V?=
 =?iso-8859-1?Q?gw1sNBJU9a4vxrvBXADtN8RsMRTKIiVlr/+qS8z9jz/1BWTLhdU4lP1rWi?=
 =?iso-8859-1?Q?OLshMt+nXHZO6eZOXkc7eaPOadldnN206Fpq6/9Ye3f9bek4YkaU8qRwFa?=
 =?iso-8859-1?Q?W1oR0WT5VmQTgp2dZy3xOcXtvpVW4rLZRza0l9G4mnWUWSwMtgG8rach+c?=
 =?iso-8859-1?Q?0Qt+4txB59K81TsHUWA55QdBl3zqJy2Vr+vR/hEQDVzPep+FPwy3n9VGKT?=
 =?iso-8859-1?Q?nyxVthdbEylXS0oT9v9601ZRCOOVVNqFyRX1XwbR95OaNe2inqP5uqKtID?=
 =?iso-8859-1?Q?LYcOaCpw2KhacBVFblTL9g22/s34czDs1bdLJQ3Tt2h6Xo4SzY9+Zhuamp?=
 =?iso-8859-1?Q?rjjZjGPXPI2qFo/iHT8403pVpgzY1E53Th7oHbbxsx3EqwPTVYw287YK6a?=
 =?iso-8859-1?Q?/LAngkAVyPrLDMRh0hViwYQVi/FNDeQHmNoZbmBcR18AZV0TK0Ixelngg3?=
 =?iso-8859-1?Q?LVQjU+wuuwE9a7nf3kFgpoFdM9+PiTqEZZL2HKjPcg9cD0H5N8DQgmUk2i?=
 =?iso-8859-1?Q?uhiQzWynJaDC2B/9cE0dAkHgh4kHP1j49kWLUyXXWO+e3SMIMLlsaX0FoA?=
 =?iso-8859-1?Q?g/2j2wj7omGY6aIim+eJaLqebB+EpEfIF4Ywo7v8PQcjDH1wz8lBGn+PGh?=
 =?iso-8859-1?Q?JTRhZDSsPhE6B7XSIRU+NjsGJNPsUzhGA5GnaWzf4soU/BujtOpQJhOg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e2754f-e3b8-4b4e-b7b4-08da6576bc61
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 08:56:26.6944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SUYv9lm9Fe1CCI7A8RuvFbzPrQMDs9jC3NMseXAPE95OJVFLHWnwI9L1l5hnOp7IA99/YnzLwB80rT4wEmbL3NuYo+rqT/IHbmZdlKptCYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew, Russel,=0A=
Thanks for the input and sorry for the inconviniences.=0A=
=0A=
>First question which applies to everything in this patch is - why make=0A=
>phylink conditional for this driver?=0A=
=0A=
1. As for the phylink ifdefs:=0A=
The original idea was to support mac config on devices (DB boards) that don=
't have full sfp support on board, however we scrapped out=0A=
this idea as we could simply use fixed-link DTS configs; also due to this s=
olution being non-upstream-friendly.=0A=
Please note that V2 holds no phylink ifdefs;=0A=
=0A=
>In SGMII mode, it is normal for the advertising=0A=
>mask to indicate the media modes on the PHY to advertise=0A=
2. As for the SGMII mode, yes, Russel, you're right; V3 will hold a fix for=
 this, and keep the inband enabled for SGMII.=0A=
=0A=
>No way to restart 1000base-X autoneg?=0A=
3. As for AN restart, no, it's not yet supported by our FW as of now.=0A=
=0A=
>I think you should be calling phylink_mac_change() here, rather than=0A=
>below.=0A=
=0A=
4. V3 is gonna fix this, thanks for the input.=
