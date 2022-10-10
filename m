Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EF85F9E22
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiJJL5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiJJL50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:57:26 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2078.outbound.protection.outlook.com [40.107.105.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFF02F396;
        Mon, 10 Oct 2022 04:57:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfJ3NT0srbb5M1k4mf+pIRtRxbq15SnM6xRfiuObv5WfK6tzoArk0t6l0hYfArYDRh9pq1eRmn++RaS5nyAx5HGlDojMyDikdx4xEYrqydOryYCFIIqDDzWDOsJvHpREyBS4RAbRv4qDjmqQR6kMHyf6xVwcOlLXByEyAFXElJd4VgYjFQkDnvuDWxrs6jrUrx3Svhcsmw/t+Dj9erNRkqqIB/2iNU+5w+SG/qrYBpx3APTDDKQM6yB8elrZd7lTBw/Md6Ga5+HB3gIXkyudX0FfjR7TcRdcUAl2NEOzSTt++i5WjhiLPuWtVaWhoIwHCRNVYyredsqlgrLPNWxoKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voXItwTA1gopVyicJthC5A/EAhHFFmfAy942bTkfMKA=;
 b=arvDAnO2WZnLspZOQrmgU+4ayhHd5Awt6Zx/i85QKP1z7o6kaql66F4mEoQ2YhfAHKQ9kcLQe4NixQk2gbINsFrdlvl7oa+Q1VnPxobMnFvk+CTNsvXBv1n+ARWbTvrX7TeNVa8YsQDeG/bzswl6tHjPkjz/YouVaooSYdT+V0LITCX8latb54L+I5B3SJswExaPvi5QcuAIb8BBe90LDVl7e6NQ/1YG7QQW/PqOAS2ENaIKs1B7iHFfj7tZastfdOHw73x2H1yBW7lLH+N/P/aKTbKa5UgLsWRzLLBQfS7YAfjVG1UtMeHy7nBuPeMARstCgNuGUFQB6Bgah6cPUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voXItwTA1gopVyicJthC5A/EAhHFFmfAy942bTkfMKA=;
 b=rGmamnOyb5pt72EK4cru+B6sBTgN6SxoIGxA65re5/vgQKXFkS5ktmSSVyK8pRr44hkXo4VidoHvJAtSo9R3jFGjAdzvHTVNYGlBtKlL/ascSB/l7prm+rRKCu0BFkG888gBXJJccB4iAIjGivie2y+5BilFA/3C5iaGyyKfV1c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8282.eurprd04.prod.outlook.com (2603:10a6:10:24a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 11:57:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 11:57:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.0 37/77] net: mscc: ocelot: report FIFO drop
 counters through stats->rx_dropped
Thread-Topic: [PATCH AUTOSEL 6.0 37/77] net: mscc: ocelot: report FIFO drop
 counters through stats->rx_dropped
Thread-Index: AQHY3CwA3dRF1Ay270ureL3kpCuWxa4HhouA
Date:   Mon, 10 Oct 2022 11:57:18 +0000
Message-ID: <20221010115717.opjh4nachlx53ded@skbuf>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-37-sashal@kernel.org>
In-Reply-To: <20221009220754.1214186-37-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8282:EE_
x-ms-office365-filtering-correlation-id: 5e63ced7-b13c-4fde-4336-08daaab694aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kz0/QOsJ9KUktGwLSOCkFliFUimQMsXqq39AArxmncsiZpFvox10rQFEauCXVOCLOd2c4AS/usMsAF85z39QPxlbMzzElp4JTiZT7o1SZiO7P8NhVIYSHc4wYk1n2orSOfFNTZTvkSfjMxvoJacgif75XThpqVp1wnxPVB1wE4oKu/k5aXmf5QreG59+VsVhTC4ow0AyreY0hLSIM3cnKmZ2OPgttBR6dX/K/EdPBgPoABnnu00aS326ryb3vo3ZFQzQdc5+hHRRxe8/61qHmJ9u1KMpGBpa33vC8FyND12GZGIjCDz1yX+Zu1YzxN/NtGknoaEUUWuXJ2A4fkjfHLoG16tsdihaSIFWwqEg+x4m3hmIjms4oGAbFUZiAbLKRM0RTsblUfDS/EOCm5k0R9vWkNebvy3M7ApXPdXAU0tuenPOkZUCdVUmZ8JtMgMqFZM1ew3v6copeqmNHSKffm+wNLgw7TGMvHP3DjflmpDWEj6DBmLPUPwkMqMamVbBS5thevyC2ntrHFmt2LH74c8/xx7dRebiLws+7BczWBkgUuay5qllLm4Z9wU3BLJSKvQE8VTldSrgk4zo0crISi6cJeBqfWGc4sGSCS+3UGOo7HcwPUvMDZLhjvpf1UMa67CeMrb8ofc9IB+fugxYxuralkRawCEbO7dOTPRsYdAWz4DIFq5b6ZDgQiXCbITGDw7n9x1VwpitIiY39kR600S/sb9BNrY/6ccnCr7lYeX+F/C6E1UOfDqSROLR0tVNfa690E9E2DhjqoF1Umm/yg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(76116006)(66476007)(316002)(66946007)(64756008)(86362001)(66556008)(66446008)(44832011)(33716001)(6916009)(54906003)(7416002)(2906002)(8936002)(4326008)(5660300002)(41300700001)(1076003)(186003)(38100700002)(6506007)(478600001)(122000001)(6512007)(71200400001)(8676002)(6486002)(9686003)(38070700005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6r5OBHeYEYcDxIa48o5A7W7+zOUA5Z/VND9XxLC+C6e6emeFQgqZgqQFoqBf?=
 =?us-ascii?Q?Rvai1jnBM2sf9VXDJYtcBMSUbFyw0EFzyNDpR/ZLGjvcV2N2zr9Xg6al/jn1?=
 =?us-ascii?Q?DsyF0xvw40kM5S+eMCc7YfzL11QK02/NtIjaMuxdURZ+tszMg6Wgin3Avt0/?=
 =?us-ascii?Q?JU3n1toAEquObEZ8SdKk5zqnkV6jfbB510OMQSa+bpfrpoZ9mD0VenJXLJN9?=
 =?us-ascii?Q?IWH59R4VR4Jugdb3n/tjM162mvdEIxvSXGqrzAz+O4iep+tRsuIwjLqi78Ge?=
 =?us-ascii?Q?7OK2xKsTEDPcdr6hrK794Vr5Emfuu89AhTDM3+g8tUbKzaJ9WpUC8AY92+HJ?=
 =?us-ascii?Q?Bvy7B999GPjo2i2ePgYaOaOtbMkd6LnkIxHx1DCramLh2cTosriMBDYfR9w6?=
 =?us-ascii?Q?dQjON6UGKWN0nHPXbOkzWuWecKf1dmYIbooY1LVLnc0uzY/D7148FPrja0th?=
 =?us-ascii?Q?QLvhBsZoe5NHW4Nxw2grbe2Mjk/7Gxo2jtGmV9ADvTHc+/ZeW3jaPIFAeerv?=
 =?us-ascii?Q?+FvrRb9wIdd3TJEtImIWcaRrf0//NBnbrSnb/yTeDzkNlY+reQGn5KbhDbw+?=
 =?us-ascii?Q?ZH8bNE2PfvMlK33+WwpVdHiT+GDSwDAxHF0QeVICMc/MQg2/qI8YQVKfMTwe?=
 =?us-ascii?Q?59NRS88LrY83h3LuMtOHUDifuBB0JvCCKHt9hqzhFNApXSVZTejtAlEfniW9?=
 =?us-ascii?Q?4FFFPP8W51DoA4bGie6jK2LPXVTUuM6beKJlIOFsY+k/feSog3/WvxzQ+QEU?=
 =?us-ascii?Q?ybeklcvaww7hdhwbYzXlrs7Zen+DxUk3z6S0P5ajegzQplbfkIPs3CqzF6Jj?=
 =?us-ascii?Q?+i/URxkOo6C2IfXyeeLsoeblmJMK2KNV9aXIbouNhswNdVIaQm4o27lis365?=
 =?us-ascii?Q?l3r68G5P7SfcM7n/n6HzEnOygO5RDiu5z1oY+1Stv4rwurGwoWxO+Pw7+qhC?=
 =?us-ascii?Q?I30pgyorttDm+sLmz1GPPHT4BCc1Kw6mCle8dSHeB35YpCt2ojbmvw13acXN?=
 =?us-ascii?Q?ypBvip/N5Slb2iIzTd5hH7yLL/OKdfLRqmp1N0PA19lfjaLGC+33ja+PMG0p?=
 =?us-ascii?Q?R+JSnv24uyl3Js+vKhSKFAvkBnKzmuACWZp85BLc+TTL82/ugLBoIQaw3lmC?=
 =?us-ascii?Q?EUrXlyJRoHfjH5xb+voqrJxMuQl1dhB/DoKcBBi5UvxfmO6pfgNq7hRDiZcw?=
 =?us-ascii?Q?jI8DqGrtT1R4C4zsPv9bKu3X5qVrSyBEHGfZ7hP+4evhWx94ShCc4nm08b3+?=
 =?us-ascii?Q?zB11GET8Om/DpqxV6uVW/v7Gy4Pr4jopF3DjhX6ACVlWVWV7+4AbT0GyyKo5?=
 =?us-ascii?Q?KCgIHTLGNPKPkR6+8QbBakRzzvdpV6zmvt/gVfK3DnXq+r7Y0gcuzZafmGJr?=
 =?us-ascii?Q?9zGbwzXtBt9+7CEB310oZxGZViIwNQjKz+t9S561vZU3u4VrM3YY1JBKT597?=
 =?us-ascii?Q?/kX56veWX38zCt3ZunszXms/ted8BQg5q94EM6xNVjAdMEHDt3ftAoyriR/y?=
 =?us-ascii?Q?XYgirqDTkv+6etsIy25ozIa1g/7fSWiC5XBHFLrtmDhMi5TUM2ORR3Bp1MoS?=
 =?us-ascii?Q?ynIqy5pPHkNk5Pj0sptgDL5++8MPDW7B54YgRALKDzQeGiZN52Gy8XJAy8i/?=
 =?us-ascii?Q?Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A798329DD60634098DEEFD6ABD4B2C6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e63ced7-b13c-4fde-4336-08daaab694aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 11:57:18.0833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +2Fp7nCvw1PJt9M7Pcos2LyTIpvf6fNNEW4PegsNAzOQF6XuWcGLms53UR2wnJPyr9pG2ABWbHbzQ2dHPPnsNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:07:14PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit cc160fc29a264726b2bfbc2f551081430db3df03 ]
>=20
> if_link.h says:
>=20
>  * @rx_dropped: Number of packets received but not processed,
>  *   e.g. due to lack of resources or unsupported protocol.
>  *   For hardware interfaces this counter may include packets discarded
>  *   due to L2 address filtering but should not include packets dropped
>  *   by the device due to buffer exhaustion which are counted separately =
in
>  *   @rx_missed_errors (since procfs folds those two counters together).
>=20
> Currently we report "stats->rx_dropped =3D dev->stats.rx_dropped", the
> latter being incremented by various entities in the stack. This is not
> wrong, but we'd like to move ocelot_get_stats64() in the common ocelot
> switch lib which is independent of struct net_device.
>=20
> To do that, report the hardware RX drop counters instead. These drops
> are due to policer action, or due to no destinations. When we have no
> memory in the queue system, report this through rx_missed_errors, as
> instructed.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
