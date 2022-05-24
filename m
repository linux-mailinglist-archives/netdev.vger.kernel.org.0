Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74126532A5D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbiEXM3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbiEXM3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:29:10 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20071.outbound.protection.outlook.com [40.107.2.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2EF93991
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9j4yh2Ain+gir/5jlgZDBEUotXec+k4pTVB1C9BVfhdZahr5ulm4R2/Fz0EEikB30Dc/Spopb7T+uVuvj20XzV6gGYLOIOD67JbQJHrA14ARhoG8a+Uj+WSkPbozTp+WrNkFfY1nRXQggdDGNoraIVTbNGkt1Qzk1ezUmgPwvzHrIs97oZ+syM6BUs92L1O8hMGr+BSCEIwN95ex/JLziqkQO1lUs57SDXytgqxDF/r/C/20qZJQScf5r3n+tOF/u7AZhW1mFUChD9LFPqvwFbgLN3dDfyt1C6jwJhcTNOCVRyYgnIQefkEXdYoA2uA6aZIW2K9yVoCl1fQM6kZaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+lf8unNArAqEPGEU4EzHydBZ69y1lRFHoZ5Sg2fTjc=;
 b=MlhEXPeBJxwkfpCmV43RsjF4YQrumgQskkyXUZgNDWh6+JuY6wMgUprgO9QSKJBbGKy3ej3KoTWj+OGO7EeIROtViH8bBlcP9tctfPxRb65EUHdDoL2abB8Qi5BwhFqcrzMieBPrVjQ49OOmK2cGoAJ2JBrEwFG0JB9ThaoPSh3XIucjvtjHI0nbv4TqsB+DAR7XHHp6qU6is1ln5ZguHH6SNrdJD5pTiHzJSyg/JTDQJFdJBgYf7K/SKy2OWD12Kc4GJmBiRwcSBxhrlRVa1dOL+UV7pgFZ2EtXEbB1V0Me35jD6wtLXB/MULg1a1J4w/2vpfpGqAIQMUj0Ogf/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+lf8unNArAqEPGEU4EzHydBZ69y1lRFHoZ5Sg2fTjc=;
 b=MiVabATtXIgAlasWPe+pg+TTC2Dl0AD/VzhvHT2KTnbHHhOju+x3bVesbxJc9CSMCRiyKw4O7KgaREJfWDz8T0RO5YInv4G2Bdux4GP95tq87+Z5A2E0LQd6JNzCiCM4kxYP4zZ33ix5k4LwBzWNix6ak37U7tpdPLq4z3FquXE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB9016.eurprd04.prod.outlook.com (2603:10a6:20b:40a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 12:29:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Tue, 24 May 2022
 12:29:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
Thread-Topic: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
Thread-Index: AQHYbpHhcTgY7maLhUesX4/147l5la0t7xiAgAAHeoA=
Date:   Tue, 24 May 2022 12:29:06 +0000
Message-ID: <20220524122905.4y5kbpdjwvb6ee4p@skbuf>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <628cc94d.1c69fb81.15b0d.422d@mx.google.com>
In-Reply-To: <628cc94d.1c69fb81.15b0d.422d@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f142b0da-ab22-4e18-1fdb-08da3d80fec3
x-ms-traffictypediagnostic: AM9PR04MB9016:EE_
x-microsoft-antispam-prvs: <AM9PR04MB90167A50C55791C5A84317A7E0D79@AM9PR04MB9016.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wgLWqmVa/6DcOlaJ0I8BWajF1MTQenxSv7x7KZn/4jHMazDa9McL7PB5PpYS1EL5AfsPduJLeN/sIFTqDf+5F+tg6j3rP5eFF9k31t62ygbGZV71cY4h78bdqNctMngBPY70hX65WJyWYsy35ebrhRPQEtubGtkozCjyzYPK+01Edpt/9q6SP8sfGpqeRpcDESCX3vWSt3cSiWeoFHkz4cJQ2Wnif4lIzQx61S8QbDWUtUXeJ97lmb4ys1wU+eSveYNxUKAqG6ik6LfYBdLrcaO7L9nVpCvUr86+SE4qP+NB/MNa63j/lM07mrfTjUMhr2gLsjApl9grCmIa50zVSNy9yHfBgnV+xMwPbnieu6PoZAD/q2+7tWRcL3rExWYBnWtxC3m/laA10uoj2wXQle/8XjRN3w8OonAnnmkKU+A6+qeFlrhHMAaNkqYUBRo1A8Xxyox16Wc2i/RZnSiR0HpiBhbDPujbooxAJRqFivze9q+ygoE/bcEDEtjX3K2odyJweWyIJSMCwEQZMJqXywRycBk19Yv4E9vk82QPGALu9++txOen+x9KWx7O3+48nR+eZsobZX0w0ZJxeqUCBcjZHwryl1xuarGEl8wkQEtbu/m6aq+opE0ZtGCckgdsjGpv6fn1E4tqM8PYjJn9q4uVr8hYEfmDcnw+SvFsmiVG5xSbIdWAraXpy6n0GF0frETtEAD+yQEu+O7X42j0rA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(86362001)(6486002)(7416002)(5660300002)(91956017)(186003)(76116006)(66446008)(83380400001)(8936002)(64756008)(4326008)(66946007)(316002)(8676002)(66476007)(66556008)(6916009)(9686003)(122000001)(6512007)(33716001)(54906003)(44832011)(1076003)(6506007)(2906002)(38070700005)(26005)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?CieSpfeoaEbe6pZRpa0nrxhMLjC3O+0k84kVwhWBDbEOP4hj4OGP/h5H?=
 =?Windows-1252?Q?IqnNjf30PWkuNtx7ML1InECqSWDf4+AA6ERNuxW6y3CKsNeGsh29nmBL?=
 =?Windows-1252?Q?oIVkJi4Gcsy6NhKH+4N/mHHRKpfsSwfH0b9yTpf0NOZyfwsPp9xxLCpj?=
 =?Windows-1252?Q?6+An/Ii2RYfNVizFYApzd7HMM2A4ZKN/x6H0ZZXmUzz06l34/RQVi2fW?=
 =?Windows-1252?Q?8ihSwIb58YFZw+HGZGUyISZLlOf+bSSUUkVjoD1oJzXDTjK3i1ffT/OQ?=
 =?Windows-1252?Q?NYj53KLUSJI+JB+9KvWm1wd9cRRDR0et1G0hof8NMuJaBNqYJL1UQZkt?=
 =?Windows-1252?Q?hPiUmj7wsJmBgc07Tw9t1lJuP1sNGVIa4OyAoOyeSK0QA1XrVZDZgbmr?=
 =?Windows-1252?Q?dS15xgoS2OPFUzbA+kTx4qKRHcPnRp+PjNgN3C8cLb6mpPBtR8PZUcwy?=
 =?Windows-1252?Q?2v8yq6pvU5wO4Lg4vSgacUJcZDdHx6KA+zKVBOzbkkFneLXgINTYz24r?=
 =?Windows-1252?Q?coirP40CtUA01u4BnGoU5mCqMmf0bpcnw6U8R8jduDFlJhghdG8r2bdj?=
 =?Windows-1252?Q?c8X9CSX/4w26QJrJcO0Ni5duUTTwDUPuiC22Vl/nwda47BTDYHQYKxbt?=
 =?Windows-1252?Q?P2Py4SlvMdIbUPdtA0DpA7gN2K9eXGIEoFibDxIdJ2q2Lqv2idmLEOY4?=
 =?Windows-1252?Q?p+Tw9d8KHAVvglXV4B2gdgzoj+E3Fqf+0aesYwHR2tpPGXFlfoo8BPBa?=
 =?Windows-1252?Q?xjiDyQWLIpcWiFMf9LmHZBI5EJVKncaSp+4ieGFzoWb5jUy4TuWjSNwG?=
 =?Windows-1252?Q?38x/BxpCTsnLyZFqthNuyHk4LoA2bx2G6g3va+0XrEAVXg88XVipDgzu?=
 =?Windows-1252?Q?5PbWgqdjF66MBjOlv+z35Irw9xNGEXSodU7TYHnM2Lzk68S/T6UIVzSr?=
 =?Windows-1252?Q?+qAmnfPD4fk9J7atPsULj7BG6IFBWmTypYd2/e1eZT1V5FKN4Q7HCnmW?=
 =?Windows-1252?Q?CTyuMUk7NGWRtKo2hADanm+GwyKiWnAqK7wcncTYjMTpLQ0SqVbYpJ5N?=
 =?Windows-1252?Q?oIwjajf7z+yMQP9szFFyQXNfvi1/WdptvbeEpqVh1fhEsdxjB/ghZDXT?=
 =?Windows-1252?Q?I4Kn6H62Z+UkmVnFbWETWKNHSzrHeUSNYYD4EVdnhCAVre51TeWOF/IN?=
 =?Windows-1252?Q?U2nF6i3bWJeXM42xEN64myg5pGw67DzNvXdSqz+moLkerABSUJPHDNf6?=
 =?Windows-1252?Q?Eh+nY65yz09sLrdwL+UJMXODEle7kDgJk4hnriFXs+QBhRujnsah4EHT?=
 =?Windows-1252?Q?+uhLOhOAKmBnbxgMaciew3iXUlgxvuxE/uF09H3RcZwpumlnJNKpK4dE?=
 =?Windows-1252?Q?0Gu/5M6Hyny9Hbg2FhxE3P186UKAxCgQ4YR7e7hwSUyp1iyrpt+aXkXe?=
 =?Windows-1252?Q?ToXJn5hvJ8rVqssHz0wvjS8VjTmoneJE9PUTsSI/Gh+TRKXM4a/KC8Ui?=
 =?Windows-1252?Q?E1qnhTtwL4zBTOD94CGkrT2gKEZgxEqVmdEuGkuAkmL6kIj+vKbEGHaN?=
 =?Windows-1252?Q?mjbkS5K10HqOoXMSeaH+aaPywXa7ii3UHk17IqxpVO4Vi3BvSajsmCbu?=
 =?Windows-1252?Q?ybzs08fuMDucTrW/eYGmt1ppvkCMEsC24vV6N87Zx3XvfL9Q9Vf7m1FX?=
 =?Windows-1252?Q?3qt9MW9pH2iFjsTusSetj2uwLTpzp+0Qtk6ggNvQnD9ILkT7YWiwM3N7?=
 =?Windows-1252?Q?VAHHNx+y2xUagJt3KVCdQc/0FfU0msDMk2xzyu5ZjNbhGrkmpl9Gr/yl?=
 =?Windows-1252?Q?O+oVC16bv2WMaWhzJXfQbqz65Be6JlBjOAhzEbs+EzhqkGNhAal4psGx?=
 =?Windows-1252?Q?rIMgU6yDhXI021Ye9E8S7QuitN1TW/vHFkY=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4E2CE6D8278075419400F5FD50EB0853@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f142b0da-ab22-4e18-1fdb-08da3d80fec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 12:29:06.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cFAugjpSm716DczKFgaWn9UwnWjVxA9m2zxloULcCaiNKgj+vCqts+6nBcOFSuGqH+azAUJkXytFPuGMeZyGWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB9016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 02:02:19PM +0200, Ansuel Smith wrote:
> Probably offtopic but I wonder if the use of a LAG as master can
> cause some problem with configuration where the switch use a mgmt port
> to send settings. Wonder if with this change we will have to introduce
> an additional value to declare a management port that will be used since
> master can now be set to various values. Or just the driver will have to
> handle this with its priv struct (think this is the correct solution)
>=20
> I still have to find time to test this with qca8k.

Not offtopic, this is a good point. dsa_tree_master_admin_state_change()
and dsa_tree_master_oper_state_change() set various flags in cpu_dp =3D
master->dsa_ptr. It's unclear if the cpu_dp we assign to a LAG should
track the admin/oper state of the LAG itself or of the physical port.
Especially since the lag->dsa_ptr is the same as one of the master->dsa_ptr=
.
It's clear that the same structure can't track both states. I'm thinking
we should suppress the NETDEV_CHANGE and NETDEV_UP monitoring from slave.c
on LAG DSA masters, and track only the physical ones. In any case,
management traffic does not really benefit from being sent/received over
a LAG, and I'm thinking we should just use the physical port.
Your qca8k_master_change() function explicitly only checks for CPU port
0, which in retrospect was a very wise decision in terms of forward
compatibility with device trees with multiple CPU ports.=
