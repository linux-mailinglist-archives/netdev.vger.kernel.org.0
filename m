Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC855986A6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343916AbiHRO4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343838AbiHRO4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:56:06 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00052.outbound.protection.outlook.com [40.107.0.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4285ABD0AE;
        Thu, 18 Aug 2022 07:56:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ds4Ht8iotL9q3FTGNYqVZ2iJWORqaF6cE4W4ZQ0lKjdEhBagTVb6g2hLiRllEsqHJm+Rm0qCp8C95ulJi3IRcD/NHZSM25LNyL3dlimpAq/aUOChvj+ztHflFJMNPh+lKb0nTo1wJjMoTv3u5Aw7p70prcyNHf4g8kf+9y1BblS3Q4PCocQWH/ZVdbg+7RtLqvCNZTlZSK8RhHHp3c09/9DldbfTIeJ8SDm+j2XbamV4pRF7/FTsrXfDXiFbAvFHXTwjmV2S8/jBy3Q5c9Ixao/9lW0krBQg9EHLCIV2HMUVwvx7IeRwig1Axly0yK5ifmoHKmnVseJlhpRzGxNpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UTK471G3eeHZ1Me91psx+04ZIaOQ3+QjuHMyf1N7Ls=;
 b=hg0ClJ+TOuhjIDdv2E4It8ZGgKuZxwyO4gFHjM4vTSu8GE/yaeZs8kNmt2HG+dV5X3TXzbFAd6v8b91tuwGFvqgADl0s5thcLFvDEX4K11erF8e929SuRDvt7n9vIhjKH+TNZHXix26Rf4uumWiQagTbDFGcJ/8q2LxVpK/xdyMnoNN1lVtXYG0ZhNLMJFlTOA42niBGUlf9W87doSslc8jNusPk39wY7Cfs8uA1pL0tWS7/qxJZvj74vGhiQc0x67bQuWoSDH1A777sGG+y2udft1+ycqqtx80yotvGgI3V5pmVjQIR5cHu1VC4lg5qeHX2Ozr6uU17mQ2zlwM/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UTK471G3eeHZ1Me91psx+04ZIaOQ3+QjuHMyf1N7Ls=;
 b=XIP8UqclNs7A9P8pinB6NVGcFmeMQKC7BrzFz5hX8BLN1hTzDjCcwxjT6oh035fYUFFvOyGlP0IEXBnSRRBUa+aJpVpJ/RhRR8C46AbGEJMuf9In87zff6y9xYtqpCIHzmBvN2ebYKsxkUTnbQXJuUbOH7eWHYgP2n+oKBnUzvE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB6028.eurprd04.prod.outlook.com (2603:10a6:10:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 14:55:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:55:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH devicetree 0/3] NXP LS1028A DT changes for multiple switch
 CPU ports
Thread-Topic: [PATCH devicetree 0/3] NXP LS1028A DT changes for multiple
 switch CPU ports
Thread-Index: AQHYswuXtd5xxkc2eU+YiP2v4JjeM620vXCAgAABtgA=
Date:   Thu, 18 Aug 2022 14:55:56 +0000
Message-ID: <20220818145556.ieg37btfny3o2i4q@skbuf>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <8d3d96cdede2f1e40ed9ae5742a0468d@walle.cc>
In-Reply-To: <8d3d96cdede2f1e40ed9ae5742a0468d@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d5b3f4e-d7c8-4ae5-cdd3-08da8129c17c
x-ms-traffictypediagnostic: DBBPR04MB6028:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pb2+l1u8jcmJ6egugtASBIgoLhhyzaAxVPJs+qzUqcm/fCLp9VQotQi3+9wZSlXucXD+/We4dVOCCnHYx/glNDInVlkuwgo5MJRMuK1dOAarxjfdE/CFo9ggjXHdFEkOyAxedhKnoussNSDjPtowHzKYTNEgrpIJTU+ywnXh2Gey9kOK2M5kqeYz6zsTHPA3vLKQyiojXVDYKKUuHn75vCu9zOTG93+RWuR8DrHyzurJw6Asqc+djJrS54rdXwbPAabBbIq0d8gRuld3jUzx432XyA1RuW0xhNo1Bw0RLZklGGPot3rivdhNXu4Nvl89DY9dlOyorCQG2Jw/74FEzqaUIBU5yQybZMdZy1fop1umOR2am7IAneCS9zXe/hJp1i2PwyL55L3l1sZyL0iXhF5ucq+RS0BhBL16N0icaxVaPSC9KlzT3kCYx7TfoIxIvEn88aiVqetSqOvBEMBJa+wBQ7SqlCJYKskt1B2Orzsf2vkfQElTBms7fVLdNZ9Feux1PusvmaX+B1HWTqxmVl5rVM86g7RptUZBuA6IwdpxwyBlysm9bZ/ir71OhOHR9RqSbhIGiRQPntoOrRLzsR29JYhUpSksBgk2D9cBrJ2Fs2QL3b7VuBXo/F3ruZmJgiSwwSsOVTNmqtj69xXM3aG6Y7pZNuNFmcvhOLFEYdaJl3qLy3E6W2BnOVjaRXB22rttzRYinmn5ozkxcsoQYCOf1j/iTXABNn6b8u9YiLctU7L4kSl0FBdJ8OLq4tYxgMticWGjhmtYkHdaBU/FVS2goJhJROGl7wEUlscM6bk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(376002)(346002)(366004)(39860400002)(396003)(91956017)(478600001)(71200400001)(6916009)(9686003)(41300700001)(54906003)(316002)(33716001)(66476007)(76116006)(64756008)(6486002)(38100700002)(44832011)(8676002)(66946007)(8936002)(966005)(5660300002)(66446008)(66556008)(4326008)(83380400001)(86362001)(2906002)(1076003)(26005)(186003)(6512007)(38070700005)(6506007)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0Du4K3v81bn6fsZk3QIMfNlD7DuvUBVIRknZA2e89so17QGmrrPlvqoG8CJx?=
 =?us-ascii?Q?s+5acmbmpTpKiWz8v/5aT0u10xEnDwy58l0EoV709T/ns+1I8AyHvmgn98eZ?=
 =?us-ascii?Q?2mba+LiZYvt6TrGjWTnSRtQagV57W0I904ACRo/1uGwmzOz/b9d2CWTJN9WA?=
 =?us-ascii?Q?/c20oewghlXQgfMU7ytsaiFiH73RY95iwch56U80wE6qW9aNC9yWi/wX+TsS?=
 =?us-ascii?Q?YkA+j7WfACxeHIGnZpKI9U+07RCgaPWJkvw4a7XpODEd3n3QIrlWKkJHf2of?=
 =?us-ascii?Q?IiJZTTba7a0kpNyZeTuL03ObGdRU1i6z+MtxTJ0ihMotip4RUNgSxbDF6P14?=
 =?us-ascii?Q?Cc/Ubj9OvsFqQJfBsfKnSXJ9O65n11LPbnYc8fk4ezMLIJpR2vn/dmBi18cc?=
 =?us-ascii?Q?JuYIAF3IzJrD7ImDKx7HYgNvHEQwOHzmfvWVXgOtULSmmmH7qQH/eaSf42yf?=
 =?us-ascii?Q?KPSZj0J+tNt43a0P08QGFa5cnq1SXg/O7uzbxrdKA5WINZ6qDmLWamX+O8WT?=
 =?us-ascii?Q?YAU1CLPistE7sax6LbD0Iwo6oJoD2/TNcLwdyR+2vdVo32RMHoYzV40lZEYu?=
 =?us-ascii?Q?ruqKhfZOeV9xlERjM9ghY4ACT2iPX2q/IvmFj10e99ZQhXJmWn9ukud+ilKg?=
 =?us-ascii?Q?jafpWMq2x8CwvLPFXI9+D9vZj7XmFac3xKVbJP7NFo8ClS2XvC2ImWkfO3Wg?=
 =?us-ascii?Q?6Sw8UrNIhUDITFniJ48XbmhDlC5kqdiH/wRwnEF1cQzAFEPJ2F9JhCQxaLcG?=
 =?us-ascii?Q?uTOB+ir+6ExhpDsZZUBR+A8BthTOnrvT3RVQUgq8KpyFb5KApFR3gMvm7vgb?=
 =?us-ascii?Q?313iH1rTmeqPdHzN+MNAaKxtRm21gwQ24vZ8rmrRNQY+aQB/zj2ZxlFOSuO6?=
 =?us-ascii?Q?g8lBlwxo5i/sQl8LFp+lq8edkrUCOJnjRF+RTXTTRORyJrWcdIUNoyVWdjK/?=
 =?us-ascii?Q?sTw9OKVXo+dARV4b9ixJX4jUsIzXTO3GTmwG4y2Pb/Z407sC3EO5EV3gQgA0?=
 =?us-ascii?Q?rrmrRDiQZtXzMTV9AtGPlgYFgbuQBfFCqCBvxHfM0K0tK9Z5BtSiOj76iDI3?=
 =?us-ascii?Q?Ye8sdmVpxkcgV2iO6c3NpkpAfrPa1nphtBw3UvMp6SQMpm4nIrJF8ejVt6+J?=
 =?us-ascii?Q?8bOZYhWDKrOYQsKR1vdMSF4gVnPFj8IClOD/dE7+a781f8HYTlQsxFFp99JJ?=
 =?us-ascii?Q?AKVuZaHsmPo5MoV22CSp+RTS6ECkaVktOYp5Mpv5lkDFOvNJIlyqvqT6q+hj?=
 =?us-ascii?Q?Md0wPHzAMMX01/w0ppncp424C9+spIptl54sI9mWNcbjwYefzBqPRzoocBk+?=
 =?us-ascii?Q?nPApjHy8VW8j2GvulTAmdFYNT7f8bO3hQwV8ZbMCbQZAsHIJ6XZwMK6io4H2?=
 =?us-ascii?Q?cowCXe/FAgvx1pFwC9i+Y02z7JpJ8Clqch2OLmzp6qRP3vWdm1aL62ns5Q8d?=
 =?us-ascii?Q?JtzQCdxaYbgckaFXBHu+cY5dchYpF/nL9Q3SBLPsOgwaUFoddZDvSEzLdHta?=
 =?us-ascii?Q?xKmiVnqZ4PCpK8/7at8rDBimav2+ITed4pq6tQN8o20KV5kNkt5TifcrD0m5?=
 =?us-ascii?Q?8qcL10B9OGvIWHtb1rqmWDiDHj9u6BTCPj7ShRnCD0CfTmbsMaDFpgwtyjTU?=
 =?us-ascii?Q?/g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62E4E7500C534240ABE3D0EF1365ED53@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5b3f4e-d7c8-4ae5-cdd3-08da8129c17c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 14:55:56.6014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4g1FmRiNaVDmux81gd/CNHlISpHZp8i239LuCJBvNR7VGKSgd88OHA1S8c3DIiw87CTDLb7l9miv8I1RJ3ahSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 04:49:49PM +0200, Michael Walle wrote:
> Is it used automatically or does the userspace has to configure something=
?

DSA doesn't yet support multiple CPU ports, but even when it will, the
second DSA master still won't be used automatically. If you want more
details about the proposed UAPI to use the second CPU port, see here:
https://patchwork.kernel.org/project/netdevbpf/cover/20220523104256.3556016=
-1-olteanv@gmail.com/

> > Care has been taken that this change does not produce regressions when
> > using updated device trees with old kernels that do not support multipl=
e
> > DSA CPU ports. The only difference for old kernels will be the
> > appearance of a new net device (for &enetc_port3) which will not be ver=
y
> > useful for much of anything.
>=20
> Mh, I don't understand. Does it now cause regressions or not? I mean
> besides that there is a new unused interface?

It didn't cause regressions until kernel 5.13 when commit adb3dccf090b
("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
happened, then commit 00fa91bc9cc2 ("net: dsa: felix: fix tagging
protocol changes with multiple CPU ports") fixed that regression and was
backported to the linux-5.15.y stable branch AFAIR. So at least kernels
5.15 and newer should work properly with the new device trees.

> I was just thinking of that systemready stuff where the u-boot might
> supply its (newer) device tree to an older kernel, i.e. an older debian
> or similar.
>=20
> -michael

Yeah, I hear you, I'm doing my best to make the driver work with a
one-size-fits-all device tree, both ways around.=
