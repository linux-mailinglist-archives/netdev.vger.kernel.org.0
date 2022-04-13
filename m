Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD250004F
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiDMU4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiDMU4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:56:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2059.outbound.protection.outlook.com [40.107.21.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24B65DA4B;
        Wed, 13 Apr 2022 13:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwrQTNV0kR+eSZex5t2khhwdkwZhmv2RcCue19F92W1FASqM3RLzVe8EJq+Iwe4c8BLbge+yVwhLe4kfT6+N1D1BVW9de/r5XCFGiBc6MsbJzljbU/LXRPqVKRwLVJVq2/c4zmgkZ0pJ+HtmzONCjiFBUMtcFqxp3/ZPjW9gGnAU552RqcVKJaEh12JUtv1VIb/baspCjKDZzQehAqZHXJSF9edamsLAG8+si48pC2wOsErrf5PW6yABOq7tyYzhoZ2I+0YQtxcNgr24J/8jxv/cScYNZC9utWmB9SgKbv1VzlmKH1Uot5Dc4xH24YRtVB6bZDkvKk9uQznilk8f/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdaorSxddEWAe8AqvkxzV18dzWWjsVHYpsUmcISovQg=;
 b=GalRKfPOGvzlBT2es+l3YDy88fgr7TcVMogIB1wPo5gxyCoK7NYc5VS2Hf1QZ73U31wX7XmPGNp4TST8Z8Ss0zdK4LG2QYUQYPCUq7nkCV/9lGJYNSeHOyKEREfboPdf9jueZThm32mbeqYvWOeGg827qlXicuhBh22/UeHhzZwam8gqM3Feyoi0eVGJhMg/udKfFQoPdtcI4J+OX65dYul2brh0Zserw6nWPY8KdE4z6l9EA/+GzdrPP6gehU7LYtR9YgR1REHVePjRn5ELWFOHh5YUTlzDBmDmNSXd9UOcDYx+jUXoRcNXm9gTOxKODcpWReXIa2Ex9BVzaPrKcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdaorSxddEWAe8AqvkxzV18dzWWjsVHYpsUmcISovQg=;
 b=IPTaiFJ9WJ7F9usRRY95y5FuNUTLNajQI8jOYXnhA5Goz+/Z52dp6pEvV5KWMWUGQhadPOcw63SpSBlkb2/J99Hff1mm/FNouL3lc5qtUOYDgeC+R1ucHIg1/PP+Ka2adWMLRF5bPlPLko/iAA3X6WWgpsY7e3bgkRWi/dsVeeE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7248.eurprd04.prod.outlook.com (2603:10a6:800:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 20:53:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 20:53:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Thread-Index: AQHYTfheCzBrufjauEu7NwJglkZ/ZKzuSJmAgAALg4CAAAEaAA==
Date:   Wed, 13 Apr 2022 20:53:51 +0000
Message-ID: <20220413205350.3jhtm7u6cusc7kh3@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf> <Ylc3ca1k1IZUhFxZ@lunn.ch>
In-Reply-To: <Ylc3ca1k1IZUhFxZ@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efdaecfc-a5ef-451d-509a-08da1d8fb6e6
x-ms-traffictypediagnostic: VE1PR04MB7248:EE_
x-microsoft-antispam-prvs: <VE1PR04MB7248D9BA5ACB287F3EFF413AE0EC9@VE1PR04MB7248.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YnSFV0fwBWQrMLiXYqJxxko9XWEKFG88mHqHclCppkR/AXTXiEzoK3CowV4Hjixu3a15uhjmeY7pLLjYiWPsHBI+d/Z/FzaP6GNzziHSjGcIdnfdQ5+OvKJSEqxmP31u4cP+w0Fmc2wsZYjtjcVjxFi5cFHIiFCBwlJqjGsBUGvfVMdYiItOySLYodT+P1w1g+LruYI1/cOZyvBwqQwzWW/w4VjPOa/3TTJapavP8oeQpNV8AIFEbwdTsX3s2BbTCE81NJtguWUpwVVbzqoClaje/6s1M8GATR8X8ydEpEXc6idvNbk4DsOUAeEdtZS/H/bNxlOHgGYGmNqj9SsU248B2AkKCFVM2tFGTrxUBeAJ00f0TCS/KmXcwNpZqIs1iv8GNH1cMnHMfT6eawikAszNhMRX4r4ZmtPXeA4cjZodIqCEWE3TmdKM4y9S9/stCKyNRDT1yC3a5tIESHqcbEaxvIiiHRlTJMNe0jHw5Dt7b5sqr54lw0VFV5daTkBichruBvW1jO5IWaVilTcuoVg7kxx/de3X8VfMGEkx1z5VbMsUNB7bAknJnH3ERsLtpaHIhi9HB8DNgjd+rj3dwdFu7gtEuKiBl0T0CoqiLJCQ6/oa/0sHDzviURsLchNrdVlst0m9cvESGchGZTsOGC8X2f0ihGKM1cgP7pVyexRtqWof3qIPYIHj/BksYOu5q5aUqnAor+20KrR3ilTvRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6512007)(316002)(91956017)(86362001)(1076003)(9686003)(2906002)(33716001)(8676002)(66476007)(66556008)(71200400001)(4326008)(66946007)(76116006)(66446008)(64756008)(54906003)(6916009)(6486002)(7416002)(6506007)(38100700002)(5660300002)(8936002)(508600001)(44832011)(38070700005)(83380400001)(26005)(186003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XLTXmA+rI8TY99C8teZnG/Nb0vw4EB32cPfyLPwbRDwyGKhJtlmaIISssozC?=
 =?us-ascii?Q?n5OqiDnxODyZjvGvdswZCNKNHpEds589D0Rb8IgXCi6SgDw3Mtxzhw4GSXcn?=
 =?us-ascii?Q?IY80aowRZVK0b3VvuH1KSFhCDSL4tBKNXdrzIu1qNd7py3BkGn7Pw3NOzlbm?=
 =?us-ascii?Q?WaZwwBjwYV3M9ypX/p+NVDIF2PLx10Oo42IgyYHgqPXTGraI9P+/BYDsaPlV?=
 =?us-ascii?Q?Sf3n2v8pFvy9T5IsYBRvB0vtMy3BlhWh77iei+t7p1Q6t7nIi3YGBFHWN3hb?=
 =?us-ascii?Q?MisfRNn+hzi7iSQG+U+9dPglyj1aV2Xo5UgKrAtRhpvaOULEYEy6tOrEbQPO?=
 =?us-ascii?Q?PllZ4RwUbjY7Mm9JrvO/jC5pmg3tFi732u4VOkKnZ/+NGpqZkqYqed37CHny?=
 =?us-ascii?Q?IPZnFk9GZcDrvUAKqDyp+sykQO6OVb53sMkp2L1TyucZdzzHjMoewGUmvf6T?=
 =?us-ascii?Q?HKcCOcy9VTJjqOD+vXQAJ9Nlm03E+lfzl/h7UYQxBoEO5TGoQaXzXP1cUQbG?=
 =?us-ascii?Q?rW8UZRZhcjtkIVT0pv1v7c4fYeEiWub59EojAju0ur5z50GadeON1XTvaWpO?=
 =?us-ascii?Q?4wu8GSobyZPJwyyPp4cZ4lFMURGhvSTK4Nzig/fukWoUkw6ygSAmeEOdSX4o?=
 =?us-ascii?Q?PH2piZqL0MK5pADBkpV1upGTZUlvf2R5P2xhBFcjXMwbTARCwYDnpbtNy+7/?=
 =?us-ascii?Q?u83M2q/xOCYNTExjswtZBsiLJbO3CS7L9342BSM0y8ZtuYz/cYo6dJWCExVp?=
 =?us-ascii?Q?5bghix7sgQY/QfskBWx1yZeWTNHoKB3tSsgT5xsYL4ucr2B/1L/3P8D3gIbu?=
 =?us-ascii?Q?PC6sZGwgX2bGZhATnKu89G+cXkNU8wO0XBcp/8a8Gy3vpbhGT7K+h1ljsVKy?=
 =?us-ascii?Q?shFgzf9rpDol0ec/lRZYOaZ3rtpjxdfNE2uulgc2BhhI88UmbDLaG134FV4N?=
 =?us-ascii?Q?VuLD3I8WuUCfcq2i0s9pOQ9i1BsOcOR8LZwMdjdl/pW5cjbU0wgJKn/SDv9I?=
 =?us-ascii?Q?DVjw1w60OvSiQAlNR1LBU+LMHrnAvPljGbE297zlrDh1kTRLwmCG9QCAS2i5?=
 =?us-ascii?Q?w7Oxm7HUA+urPt28qcsCY3ah3lr6/TBOkiwqfJSIPTvaE4XRjeS4AH5Wktgo?=
 =?us-ascii?Q?w+TTfMWjrzhLKLHjwUv5ClLdh4kS0svockaJLuFQLXtMLd9AHwTAZ4EWpS9U?=
 =?us-ascii?Q?ykfXJdgO7l6g0wU1P9oF0+zdAlyXXtMhD0tgDUy0oE1x7VX5T2VG2omax31z?=
 =?us-ascii?Q?CnPOX1IMP8PQM8Kr5KOegJTxaS3yRflqRXnwhv1UZ/pCtDrkouxbK97pFza0?=
 =?us-ascii?Q?Xj08xbcnZLp8f9BERgAMEcmM+UV/JnzTB21trUdnEAW8mRlM/w9HoXkj4FuL?=
 =?us-ascii?Q?CD0eNgLFfZR8WKLHztBeEFLmuTpFTJss4kha8IwqbBhRtknNbveMUflpq/3d?=
 =?us-ascii?Q?2QGm3kaCC5nQq7a49LZvjh2plQ/VDJ/luLoDWdYyoht1kFBiwF8esKRY7Civ?=
 =?us-ascii?Q?qIVOSZ08i6scOq3VR1AJalKtcLnu5JY1jppvktKngDqMvlJaA07Aez4R7s3e?=
 =?us-ascii?Q?eOt09i5L1Sz9Ak/0Cf+4aCrLciiTy1KrzQbuhqm9PT9wZJ+cBYTNnONcBoxD?=
 =?us-ascii?Q?JM/EAe++08Mp4HHD0DsRSJiPRrMe5gJNRk7StWFebz9/q9KJY1A8dxekWVWO?=
 =?us-ascii?Q?J7fJ47IinHIX79CyUa8SU/nkh9HXa7xLv7KS+0ehI6bkkZHOIIAq9ztl7er9?=
 =?us-ascii?Q?zNee9qKuQqggFM+Hwf++0f3Ex1f2W+g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1614A8A74C06F4D8918DC91472FDE32@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efdaecfc-a5ef-451d-509a-08da1d8fb6e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 20:53:51.1016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+RJ8msVgZMBT02ZR2zoZSafK1xAW0InR0V0MRKKYnEyMtq60IuQ94wXy2/Z3z6/3EBOZo3ecaGcqqOZd2xSiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 10:49:53PM +0200, Andrew Lunn wrote:
> On Wed, Apr 13, 2022 at 08:08:41PM +0000, Vladimir Oltean wrote:
> > I've copied a bunch of new people to this email.
> >=20
> > TL;DR: Kurt/George/Andrew, on your systems with hellcreek/xrs700x/mv88e=
6060,
> > does the DSA master declare any of the following features as "on"?
> >=20
> > ethtool -k eth0 | grep tx-checksum-ip
>=20
> Zii-devel-c, which uses a FEC as master:
>=20
> root@zii-devel-c:~# ethtool -k eth1 | grep tx-checksum-ip
> 	tx-checksum-ipv4: off [fixed]
> 	tx-checksum-ip-generic: off [fixed]
> 	tx-checksum-ipv6: off [fixed]
>=20
> 370RD is a Marvell reference design, using mvneta as the master
>=20
> andrew@370rd:~$ /usr/sbin/ethtool -k eth1 | grep tx-checksum-ip
> 	tx-checksum-ipv4: on
> 	tx-checksum-ip-generic: off [fixed]
> 	tx-checksum-ipv6: on
>=20
> WRT1900AC is a WiFi access point, also mvneta
>=20
> root@wrt1900ac:~# ethtool -k eth0 | grep tx-checksum-ip
>         tx-checksum-ipv4: on
>         tx-checksum-ip-generic: off [fixed]
>         tx-checksum-ipv6: on
>=20
> I have one more system i can check, using a Marvell Kirkwood SoC using
> the mv643xx as master. I need to blow the dust off it first, i've not
> booted it in years.
>=20
>     Andrew

I meant to ask about the actual mv88e6060 driver, the one that uses
tag_trailer.c, not mv88e6xxx.=
