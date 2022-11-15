Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8059862A086
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiKORjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiKORjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:39:47 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2040.outbound.protection.outlook.com [40.107.22.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DA1A459;
        Tue, 15 Nov 2022 09:39:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gedLVFmNptMSyqsnllPhCFFw6Z1RJ91EUJI56yny0QsTPNc5foQczciABV1Y5DxwQw9S4H9XNniZnMr+apTAhtCXKdDqWZcgrz3l3LXW9refaGd9Bc8YGS+l57BaSRPeMJlMKfBAYZV/bTcEe7rmo0xgRiqnT02U94WTHXTbcOMCSsxfdZKCuaR3hctHG5At1vxvtgrG2+Hj/+DZypbBhoM+nm19XAdIvLKb8AjDAxEVNABwNSFaebaua19PLcn/os+VAvRSsYz/vC89i4UzG8Ar8STLZoMO4xlM1fXkg4vNLi59Djf+XgwrCsDeAthF4s4bquI7mrnsb5jPhHp/5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95OWDjopJVKg/HGRtmdbY6lRC/vM+qiHxGN+Bs7UvIg=;
 b=DLC6W49VGHdN+7wXcUyTAi6hhFTpdTN8YXtZMFoy+DbebtWYemTiP6subTnXBg/WhtgFIq8xAxrU6vxaN/MRF96fx/A0BNWxC7nSQQNDZHPEmiBVuCM9oCfnZ5Sqitofn6Nz730OOukXmAkW2JM9Sx9zKp4l6MdXq5IEMGXbtWcGzf6qAscbmasFIXXJzXuzdM/WC0r4E2Gj5/kDCIZyNlMZdefwcvYZefyieMlkF2hsRNIxdA3VaXCChKdRI6usWa/+7/9xVUKX7qG/7bvpmw17ryqJScDhEMG5cAa30RmsJ/hbKp3bAbWDIyT5E1x56OB5o8YqLaMSM1/CmyvM5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95OWDjopJVKg/HGRtmdbY6lRC/vM+qiHxGN+Bs7UvIg=;
 b=VfB8fIbjWzltXv041sI8S6Wl8bfE2n2B2YNlQi1rhQmFOvLzrQ49/9TBr/G8apsHzWsj+M23GBgmB5sib51TvuAow7hebZS2gj+ce5b/ICkj/s8gUz7cG8HpgaW/F2fCAZ/O+2CbdAYBHxoc+b881X9TkTcVGJgGsmL6QruVN20=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8599.eurprd04.prod.outlook.com (2603:10a6:10:2da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 17:39:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 17:39:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Thread-Topic: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Thread-Index: AQHY9g8iL4WNmd41D0+zI2HGRNCF864+i8WAgADRDACAANAcgIAAEWiAgAAICQA=
Date:   Tue, 15 Nov 2022 17:39:43 +0000
Message-ID: <20221115173942.mdn2r3i6joehhohu@skbuf>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-2-colin.foster@in-advantage.com>
 <20221114151535.k7rknwmy3erslfwo@skbuf> <Y3MK9PCz0JQSQNiQ@euler>
 <20221115160839.rgyoa23yabrklpxd@skbuf> <Y3PIIQeGD9LUs2np@colin-ia-desktop>
In-Reply-To: <Y3PIIQeGD9LUs2np@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB8599:EE_
x-ms-office365-filtering-correlation-id: 6a10bd2f-20f9-40b8-d706-08dac7306195
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 83oHA3GpQj3hzndryFs6QMxG4UMymsUnPlqVGe6kv0cceN1eWCjEp89FPI7ExUZz+GD4z8h/2z0t3Jq4LGxApDrkXjT4pP1poG2wV1jgDA09UkLf8JjfY+3XAjV19U1xGhAaVtquFLBgO8+oRi/EwU5Kcg+Y5rnSE5f/FLjjV1CnN+Q9G6OL4RiOL0vVeoZHVz5/UVgPtuGOHleJSDxWuL5nz+VwVrOqRDA/9xd4sfeAnJJ/o/ug1Q0+5Vlr5dno81dt9ZdNW+g7W5H+I+WzUKOiTojQzaUVTbA+X6iHzSPVGHW+pExcWHSQCiD4xOlqlhLsgJH37Ssj5KptPlkBHJSSYW6XDpkiCUqDlUpbfcgb4RVwbiz013EpovnOdhdo4B5kACCzlNmKIokgdsOvf604VyKPocJoaIVFBra6Fh4cLgQ6st0WlVPZzV5y+zi02VMHI4Uhn2sHv4xSGYNd4kp4TtXLagIZTFiGW4F74UkMCVb9/e+SYJD+Sb30/Jlv21NeiVH42LEyZbvchVCP8DYifz37Yca9qJqQXa7eRRLAFjkPAFPZ0d3rg45VzzrmonyAirYOonF8jMmwXuVvOWH59lPdmeyJS3EC1sdn/pM0qPH7qXmbEqFVCRPiKgxkvR9cntSB+bnMtNySKaNtVscc7RKFK9fvjStz5zbnAKnzCsLK/oBF2uvWfhwLmXBPeUmDVmFKVpwJwNnW2PxmO8Q9WqtpJFJj+K5e9wSiIznK5Ii1gAdY8XwGOgt9HPGS6He6uk+mhIFqdbkSMX8sxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199015)(71200400001)(478600001)(38070700005)(54906003)(6916009)(6506007)(6486002)(33716001)(316002)(26005)(6512007)(9686003)(7416002)(2906002)(91956017)(4326008)(64756008)(66446008)(66556008)(41300700001)(5660300002)(66946007)(66476007)(76116006)(8936002)(1076003)(8676002)(186003)(4744005)(44832011)(86362001)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pRt2KdG+v0WLAyfn1rV12TT/XUmdJot/aBWzKTYEXb3RrCnd5kF5NBAagks2?=
 =?us-ascii?Q?5fLQuhnNAA/ef2qUThfzRtaQBTWUS5fnf0a4zTCBcTLxceSKTA8WrZPcfMJy?=
 =?us-ascii?Q?mTWgMCCVE2/5qruiDocOLwwDEclmt/1JsNRXlz8XhxOho1MnlE2NZwdOEA8a?=
 =?us-ascii?Q?Q/9/PPQdmGd/z62QesaJWAxGLtEK7Uo0nU4jhc4NFJgyiUYuAPPlHO+AqzRb?=
 =?us-ascii?Q?m4cfkaYqmyVtpBO5pBDFbR4C3JXrP4bpeeVnJp3DP0yj5rZ4iNZ6xpO877QD?=
 =?us-ascii?Q?FF5TX7morCRN5ZxadLbWpRafnWujes6qN1Hr0KH5ercv8kRBdtYx+MNVWut1?=
 =?us-ascii?Q?ovt1oSbtGexL+2kaxmmt2toPfY8hO87grq/Tvgce9YC3Yf7VNVvYo64koBK6?=
 =?us-ascii?Q?32H4rR2qdEZBgTTiQ9DZJqDmAHO5o2ns4QORytgV08IIZczfP64YclLj0aAN?=
 =?us-ascii?Q?lcyfiCgwKbEW1CgzvOclXE0AbweDs+1qnx7GOTOEHxHo0tdtGuULeo5E5lpw?=
 =?us-ascii?Q?Cv/CpWoWv+ugFKdMWzrEJuEx8eLs/oYp3knz7Uhhi1FQZzKNEQEU+zbzzgev?=
 =?us-ascii?Q?RRkKmlrQ34vJpBZKLgmIa+G0Urxh4hs8s/ByehCU2fv3wcMHL1KUGotpUdOF?=
 =?us-ascii?Q?vZW4HJYFV4EDn89jIq2gpE6FppJdalX/iSPeT0kpVoYHOKJ6MD5qhYiQtY7m?=
 =?us-ascii?Q?dJe3wzMUL54JR67uEaq3qtURUr+V/nhWWTDutfT2swurM7MdYx72FrIVOkG8?=
 =?us-ascii?Q?HDuY+PV/dJ1NeXxPs9cXCYzC8I1AjjywP4Yw2BFJ7e12naotQq5DnwY7A3Zj?=
 =?us-ascii?Q?O6WW4UG9/Hp9RZ1WfYYIXS5TKikK+8HWl2YTvCH5esLj7P2ae1HLhHm6eXOy?=
 =?us-ascii?Q?ccCnYvNRhzcjTCdrtUE1y0xk4YozxzugWBA4THvo2bIrXo522A2ZRNdBWmT4?=
 =?us-ascii?Q?8j80vZagx7Yro78kbcP7lyQ/le8VaBAvXrUJh7boK+PAHPDK1NurmIrtx3xJ?=
 =?us-ascii?Q?v0wK7mR/TjmGlTAqJTrtmB0nC3Vjd6pY9pI4E/9NazNZJ55W4IO3itXAghpQ?=
 =?us-ascii?Q?nQCooYxi8AynF6HhZGYbNVhptLNhCIf1nJf0gspUEeZdY2CZn90AeJNTc8Lb?=
 =?us-ascii?Q?L1bSD4yueoB9Z5sxmxBscvWxYGgRpLA2rF/ppTFCUzlDnFHIi0B/FWZg/s2F?=
 =?us-ascii?Q?QKGazk4SZXuahkXyjrf+J2wc725TsEUexTuV0Tr+rYkYGi9/wIwEPQwbRL7O?=
 =?us-ascii?Q?atoMi0Y50znV99dsiEwJvkBOoAX0FKPmnsDPHfDA9p2LsaTHg0wcjhcJ9LDF?=
 =?us-ascii?Q?fzEgX21HvgDQAsRdrAewlKiPBQjEJl8JW4aJ2Z/E2aWHhHtHEtDRimc+FUQe?=
 =?us-ascii?Q?kOkKt8r8XPv7r8/Dy61DEJ7yCzuwKoh0JfVKkRA7O3DzEAgwGoVm6WzXg9wy?=
 =?us-ascii?Q?Wl2BLaHMFVCMTR4da0sj5MoGHoqRH8ZKiCnMP56sMUgo9hfR3/yLn/mmuG2j?=
 =?us-ascii?Q?nZ95TI5Gvpl2dn69IEDEd3P1NWmW0RMCwTITCntg/fG5YJtj6KifuOxNcRU1?=
 =?us-ascii?Q?Fp52xeT7p7Wq1qvGtaoj6jXsoGhIoZLOUNnUqV1uMLTlRgSz/bdsIRlirrCC?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B12A55FBFCF7694E94D7B6A2713808B8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a10bd2f-20f9-40b8-d706-08dac7306195
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 17:39:43.5757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dLZT9lBvlR4CKHCK+QEcerBmBEWaCS0Dk4zF5ulOYOsyaDhJKEiOnIGa6W2ckKpqFCNsJwQ828wKoW6m9ZuRAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8599
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 09:10:57AM -0800, Colin Foster wrote:
> That should work. If there end up being 10 different struct
> ocelot_stat_layout[]s, we might reconsider... but in the foreseeable
> future there will only be two.
>=20
> So this applies to patch 2 of my set, which means I'll pretty much keep
> it as-is. The get_stats_layout and the ocelot_mm_stats_layout can be
> added when the 9959 stuff gets applied.

Sounds good.=
