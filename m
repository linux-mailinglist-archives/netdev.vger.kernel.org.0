Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7916643E314
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhJ1OKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:10:11 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:57790
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230508AbhJ1OKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:10:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ht3XV2kQjgXxw7yQkdLOTR8skdBsSVlWOpKDAoa4UlImlTGU8jlwdT4VXeA2PJKOJIKhQ2zqq4/KpMqytchhkF+P+G07yTr5scoLLaDruwyQfqsom7oEJhhCS9n0aPmQ+c4M3Wy9Yre82c7Mteg6dfYbxadnxYKLRrPKFWcBq+lIEhaH9B25+mbKMpXeNdieZQjvBKPv+1dV5zZpUv5kkzVlBJTuE5rLG/iNAfBFbDuUONIwSD27pmiRVrDp5kUstkHlR9CqaJCU5haLS2KOMaO+DX/5V7mqMt488AgAlvk/bya8ISWCTw+lNDmoOmepocFZ+wgVVxQEPOrsgi+lrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ffrj3gQwq27OQ1aIcs0GCByNKwfFbJlgjIwfaMmeMo=;
 b=fsHRMg4I6/gIWD4zm9HDjY9DfcersrPIQyFj3i7X2E2/AbRK4N3BPy02sTVvyExrcJXS7U7zdzr2BKPv6WBhcOhKDAu7FdqzZqwOsljNCMeVnKqLVNKft6CEIt7D1Xl1DuZRn7rTTap9duJsmgintKCgvEMHC6CoCUbf8CCCS9QncY5+b5Uy+G/7sWnKJIRAkwJIjHDtGRm8P7Xxdeb8zZDMfpX/C5CwM8mWuO1CcPxTWB7DxMFRK02orZK9W3S6hnjnZa7isT07sxtRN/j0L/Hs95+diyLJJOpjp3+fzRELP5ICdBLi0JyacU13lEYAFiGcheZZpGobLQfz6kFt4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ffrj3gQwq27OQ1aIcs0GCByNKwfFbJlgjIwfaMmeMo=;
 b=Hitfe5dhT0JDFi31rT0rbtR7/Z0Rql7Lq1hTNOvRpKGA78pxT0SNn/R+4Y5nYkFQ+fCXLxcx0QTZtD19MqP8mIQFnXTgLWtXtKzY0sj2uYsTTlinRRFLYizIqU3/K8OFGPvvbS9uUKLoB2g2LXAVXWh9avNxzmtMvV/ZFOK3Koc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 14:07:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 14:07:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add FDMA support on ocelot switch driver
Thread-Topic: [PATCH 0/3] Add FDMA support on ocelot switch driver
Thread-Index: AQHXzALgdbtnb6IpB0+/l+K5J3/uHavock0A
Date:   Thu, 28 Oct 2021 14:07:39 +0000
Message-ID: <20211028140738.4mozxpgltezu6zsm@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
In-Reply-To: <20211028134932.658167-1-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1243867-8fb5-4636-885f-08d99a1c4d3a
x-ms-traffictypediagnostic: VI1PR04MB6269:
x-microsoft-antispam-prvs: <VI1PR04MB6269549CE8B3C80E3B174B7AE0869@VI1PR04MB6269.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Zj6fLdNnQtbZlnEfrTdkNcvL2Q0xpNFjTPGn9o5tfzrBKKHY8ICA3lwYY7ZubrP2spu4K52ckcBzQykqDOs59Uh9g95GNZZ3plBvzKBSnwjp3XoK858EUMGZhlqZI+3xFZ272R0ql9n/fq7AWPHIz+zO77cQ3i0ZiCayosHy1PzTNRnWDSfR5VlBM+s/wqft+hsXWSwY7R9lZcf/bKkm3x5jOc8OqWYd18Bq7oZV85QIXx9b0Bg1xwH+15UeJDg4PUUHYz2gWQwsElbb3yx86xXDv7v/XhnBpWZUir46jt+8fbex9N5pNO3jDzP0SAhEnDX9PamXlf2EbmnRh2rly4+qsUPjNuvBqqzabqSgBEuigrcA7/2qkxGloO0b69XI9/gvnSVRa5JFA9S0oxwN5ozEPrDzHk2OFqQ+lzpt+9o3ee/2eOEivK3zeXxIMbbR+MtTJMO1XKXKPLmcjbKqWwcNkFa33jl7v/J5lS74tYBV3rG6vLXq7NchVbl78Ol2F29NiI0YucaLGDvg+X++kxVPAunyRhN8IgjVmL+TyPzTdQYf68GtFX3o6Fd+x8u0UEkJGplcDqgF6cFr397K3saQJ6pYuIqNbcAtgqxqQ3bDLpT51hh8fi+CBf7ENa9o1i87aWKlKMH+8o0/W8ylzuXAjOkdKorb7xCpd5lXWvrtE5oY6dkpEM8PQLUKWJMAAXrpXI50xAYX1x8m94iDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(6486002)(83380400001)(66946007)(6916009)(38070700005)(66476007)(66556008)(1076003)(8936002)(76116006)(38100700002)(6506007)(66446008)(9686003)(7416002)(2906002)(8676002)(44832011)(66574015)(5660300002)(86362001)(6512007)(91956017)(316002)(71200400001)(26005)(122000001)(186003)(33716001)(508600001)(64756008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?9cw3q2FGLpJwldTWspLEoda6/li4z8Z8b7Kp3brI4wNuvmN6AO1j35WR39?=
 =?iso-8859-1?Q?0CXD/DC5w/vxJzap6bW+ELB0A3zSvdJ1KfXZykZOeuyH/xqPKI0y7TzsX5?=
 =?iso-8859-1?Q?+StNqv3R0bIYmHTrcPrhMYhooAUvAfSDgWing/WYADlpFKi5co7QMoQWwp?=
 =?iso-8859-1?Q?oHcr+jr4HZeMm5k65ScTWWHWfcwNrC8HaAErERC8IcP/ajQoNRB5bJzPU0?=
 =?iso-8859-1?Q?8dnmEHYapG73Wsem7cLd0PtFmlxTLPKH/tgYGLUet8rBqew47/FtbYinmw?=
 =?iso-8859-1?Q?A4bpuJMjoUndRh9bdlnO7Bov3KBtx/dpOZegbGGrW/z6wl93DPKaTJIgh9?=
 =?iso-8859-1?Q?MPx82jR692302xn+spXKgLpwaUshwDOdtZRD4UZTQQ6Gzwvb9Z8uGuce8m?=
 =?iso-8859-1?Q?vs7V9L32TvipLgRH9eKzc9Fe0wXG1dNWXyCvK25fecDjv6cwXWIr8GHLQf?=
 =?iso-8859-1?Q?n0t3Y2hlDYInOb9NrxE7b2w7TKOjbucU+3Z0n90JziCmZ4W1OdIsy3gpV0?=
 =?iso-8859-1?Q?vBYoZfGf32IRuRvzRT2dcQcCP8wQez0RqG8fnOgA8Xe9SvIK3WYG25TOUP?=
 =?iso-8859-1?Q?2lJq312o+ehsGmmbrkld2n9Vn9K8GOSUhNaomGpC55l3jOxIbnJhxkvXgS?=
 =?iso-8859-1?Q?2nTwSZDRhAwxW8cpEA5CRmPtuG5vhMXKbRQKFescis5SQxwcQK8FIu/El7?=
 =?iso-8859-1?Q?6zEYpTYTR/ggFuRYoJdWd2eKqzPiMdJ6K3M5BucTg2aaRViu2MHetAjNws?=
 =?iso-8859-1?Q?a6jPZHResVrBEphiPr6pjbKDdpPb1rF8baqeWiydcvikgMVmk4+PTp/HIy?=
 =?iso-8859-1?Q?PY1iMWSKI/O3jSetbtq40xX7IgnB7LzAe0R37Q+QySok8uUb8wsILM0NRZ?=
 =?iso-8859-1?Q?tb+6V9cBo6iTmzLLn1egftX/m9B34PlpMidUtxUcTd4zS3OzrDIH1c4tzI?=
 =?iso-8859-1?Q?ef3dOzCSOTMaAQIGjYMi4ftY8+aOWX5VZB1FbXc+9fSZRRmkP+rJWEDzxJ?=
 =?iso-8859-1?Q?QJ1ZgTv50EloRJvF+VjrZZJ//HD9KakIeIRvwzTFtwG5ZZNajk53qBV1Ja?=
 =?iso-8859-1?Q?BCoSuWSeLRKVJp5knJxDUdV3NotuS0W8RsqpabMhKGD22a/NtnI4F3X39Z?=
 =?iso-8859-1?Q?1yYbQs6o586tDT3Mv7efX1pgmszV0X2T/S+ANvS2WR86S7Wct3VwpCEFPr?=
 =?iso-8859-1?Q?Rhl5/lXgaqOrwznPoTJ0y4jSxaUQ6B8T924xRf2R1aqrKs/5UNM3sUz9sh?=
 =?iso-8859-1?Q?HAF/IxEQ2scBUF0HSwZgxV/mDuir1m0Pp74aNeZ3SqDwBxL91bdDy4gpbQ?=
 =?iso-8859-1?Q?FF5RK0nDSI/Up/lNPEh7wTL079hAYZSq1tUKj0j8tke8vXpQzW+a++CVlu?=
 =?iso-8859-1?Q?4P+qoe4+6otAPpcnXWoNQ/GqXADp/tynyszYj9PLUKZPujr9NrVFfQWgGM?=
 =?iso-8859-1?Q?U6TNsi5qSK5OosSJ+ebZXkLSFaDnFAufnile/fZRLBSXkILy6BAIjO3dak?=
 =?iso-8859-1?Q?oPQdSquIboGN1HrQb7sDDoYSdaeYIYS3rgd7lhuxlwlvy3uY9HFeX1GV8m?=
 =?iso-8859-1?Q?8Ynb4KYgH8XJhcW2zcUdOPRbNGnEYUPxLnMEzFAh2u/bux0EHRbiW7XWI2?=
 =?iso-8859-1?Q?kcGU/NMJth/njykBtIqJ4INrvAQ7dTRgPQnnDC0GbWA+fiUn3OmFsPAkO5?=
 =?iso-8859-1?Q?0rKh2h60V0Cq9+OPwNiUVg/ngeAEzk0mfIMs/YRw?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <88A767420C47B14E89C26F16EF23F283@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1243867-8fb5-4636-885f-08d99a1c4d3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 14:07:39.3460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IeUJ2fdeRio/I4rh6KEwje3BShyQsJqw4veeNHSrDeJpqhd7Y8GLcLGbu3QyyG7itEdm1DR/2MSkix76VSCeNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 03:49:29PM +0200, Cl=E9ment L=E9ger wrote:
> This series adds support for the Frame DMA present on the VSC7514
> switch. The FDMA is able to extract and inject packets on the various
> ethernet interfaces present on the switch.
>=20
> While adding FDMA support, bindings were switched from .txt to .yaml
> and mac address read from device-tree was added to allow be set instead
> of using random mac address.
>=20
> Cl=E9ment L=E9ger (3):
>   net: ocelot: add support to get mac from device-tree
>   dt-bindings: net: convert mscc,vsc7514-switch bindings to yaml
>   net: ocelot: add FDMA support
>=20
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 183 ++++
>  .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --
>  drivers/net/ethernet/mscc/Makefile            |   1 +
>  drivers/net/ethernet/mscc/ocelot.h            |   2 +
>  drivers/net/ethernet/mscc/ocelot_fdma.c       | 811 ++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_fdma.h       |  60 ++
>  drivers/net/ethernet/mscc/ocelot_net.c        |  30 +-
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  20 +-
>  include/linux/dsa/ocelot.h                    |  40 +-
>  include/soc/mscc/ocelot.h                     |   2 +
>  10 files changed, 1140 insertions(+), 92 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-sw=
itch.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h
>=20
> --=20
> 2.33.0
>

Oh yes, finally some care and attention for the ocelot switchdev driver.
I'll review this soon, but I can't today.
Will you be keeping the hardware for some extended period of time, and
do you have some other changes planned as well?=
