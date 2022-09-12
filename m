Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7D5B5D8C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiILPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiILPnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:43:06 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20040.outbound.protection.outlook.com [40.107.2.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3343BC6C
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:42:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiJMFVXMVS/e70GDlLHgE35lJJPks6t3TOMhP7ozFm2Kd1JC+Oxow2Qm+s2Bnwywq7PXonHp2hkdgmLA6LTKcrjVEGVAtBcj1FcYvZheMlpjGjQvxF8CbCKyqz6eVLHbRZ73GPYebMg4mbK2uIRXeOboeaRgTfNZHeO6RuzVlFt/7X4G0C9O2LQIEkykjHzpGkQPKjq8ljlo8NnzjTx9+1WpCGBC43J4rhW78XAajOcZoVxYBbDsnRBQ0O4esGLlNZgIwbCyGinWmJQNIc3pDAV83oLD47t8fAhcDZlx9baDC6Eua/ctJla1rlBjgL1xB1e5sj356xwRlfXAvP5EmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxShohWDCFKGjkOnxro84Wqo2A6TUOAt3pq+CBhUKOU=;
 b=XJav+PkEa2MRqITMnag/NRiFlzJ0Qy8hx0enSVWntOc7gnJCRNcdj4Rw7D4lwFDmn4MEriR8H6vOCxe31X2E4rfcT8IFlLVR7QN+YQizk/iM4keWke70/unJGQsDIygahQmMUwsjD0Uh1Bi+I2I6ECK5PUJ8OD7uEYpIgC0Io35y/KC7FOfcLtxNnvY+FuTIEQ8EdBsiRANxkC3UvVO4kC7jaiq9IgE+iDkWbRjYAutVWO4cRtK11P789Jpq8n2GRuMhfAua4unpjqPQmBLjDUy7ZcxSakToqM+R0bJUzAHi6eQVEIa9fQHDoYwHA58rzBneVCzgMPvPHWnYEgldXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxShohWDCFKGjkOnxro84Wqo2A6TUOAt3pq+CBhUKOU=;
 b=DVol/1kffwX1XSKSP+s/aTaGQQ2ruiwkpUOMQKo9zAJxdVTskWOAePF8fu6EawA4/ouIm3Qm3ltd7BOHtbzC+FZVoCCXqOwYEJQLIqZsnvXn5y5aiG0LYgLsig8oci1NV2xil6Ohfsv/VKZ1ralMiobPBuQFLVN02i6RiUOtYpI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6774.eurprd04.prod.outlook.com (2603:10a6:20b:104::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 15:42:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:42:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8AgADAlYCAACQfAIAArH+AgAiqFACAAEpcAIABMN2AgABlhQCABKhugIAAHr0AgAx97gCAACSfAIBLUNgAgAADegA=
Date:   Mon, 12 Sep 2022 15:42:45 +0000
Message-ID: <20220912154244.azn3roke3rxyqdcb@skbuf>
References: <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
 <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
 <20220714151210.himfkljfrho57v6e@skbuf>
 <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
 <20220715152640.srkhncx3cqfcn2vc@skbuf>
 <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
 <20220718162434.72fqamkv4v274tny@skbuf>
 <5b5d8034f0fe7f95b04087ea01fc43acec2db942.camel@microchip.com>
 <20220726172128.tvxibakadwnf76cq@skbuf>
 <262ef822025a205b1b4975c967cc5e5bd07faa16.camel@microchip.com>
In-Reply-To: <262ef822025a205b1b4975c967cc5e5bd07faa16.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM7PR04MB6774:EE_
x-ms-office365-filtering-correlation-id: d33cde9a-c479-4d86-a008-08da94d56ffe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QxkR2o/2zhDOAB0Z+7Nmy39FTgM5ZdDbu81uBLxuaP4mWFQLY0CCZWBIQDkZzHmWCZle0N/ylY22xkDm2gP81VxldGYsKMCY9JpDbAq5EqPkXct6X68Z4xYRLMfnOuBM4lWMB7daoelLhp2PJxAWIrM6nc2cZzYOWQbRI6cYbIpWaXQqnVWrjJ7EMAMP5ThmdKPWwENFnqs39PELOed2llk20JnIwe7pfSOzSlVk3OxI3DSaiQSGqY4GnXJQNUN8RQOnE8K0gS73B6tORvvG5CQx1Tq7o9lBskW+yB4mTGU5Eo6iJsP1FJG55ds5qcl2QQZrE+t7PaJPtvsOeEmI8mcoX6NXXnp9PWzEbXXiQ6rtotPGgqsm2++a4NFdPKIzor1EFkIY/irxdC4jQhmuiD30LMucWW6EivlWVIa66ucQM2yLJqEeF71UFEZ0fc8Ytr8TVtYOWSV5sKyb3uifXIteakVkDXY419IN3jCQhOO5TmcQ6sPuhHr4GDh+E7Fb3EBWHwHXmCy4loJOicxpKN3Xy7Nadi8ZtiJq1sZ/Nx+mTU+/+qePmZYJtahmojr3yVfHn70zE4N6Jv8NYfRYEWJotJkHrhBt+Rqqwt3vsF/3Fvl9/0HAbxF7Z3motoB8WxOVkr4NjNUl1Yk+C8n8NHSIRtIDzR5R5c5oIRzKparf1IZS8SDAspNyyHS7Eis6k3s65cm/1D8Kt6Qz+DJ96dZQ8AE7zcUC/LrBgJ+45M70NcWPcHm0MnxPP01PJJ0mKln1R/q8KAWiZxuhNpSzOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(26005)(478600001)(9686003)(1076003)(186003)(6512007)(41300700001)(83380400001)(66574015)(6486002)(6506007)(71200400001)(5660300002)(2906002)(7416002)(38070700005)(6916009)(86362001)(54906003)(316002)(38100700002)(76116006)(122000001)(44832011)(33716001)(4326008)(66946007)(91956017)(66476007)(8676002)(64756008)(66446008)(66556008)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MUqgGEgPdvDivwax9NX3lD0plVlECu3285dQWmtOJCPELM356ybBXMzKnvsF?=
 =?us-ascii?Q?CeB1d812ogGG0RLJRjHwAhB+nBn7A2cF/gRoLFp7SPfziYmLidvUaxn6RWDt?=
 =?us-ascii?Q?DxnyP22UX07DyWAg8Y55qe789QxC2esdht8irXTiBl5lINOd9YMOghaNJuDH?=
 =?us-ascii?Q?ZTVeSQWQxoZF/3aRDu/pzPdUFoVx2IwOs6s0p+dZ6i8qqs0AkcmInfQafJ+k?=
 =?us-ascii?Q?8o9WrsWB/fk+9kwu0QZB2kLjdGqSU2zu/cNzaGdsMPzpkx9ZUXSotuA+npQP?=
 =?us-ascii?Q?x8E3iCHSWIFh5qOPb8CouiBYfRVYkQuxE2I/Xqa3kVBZb4CWOf1DJr/LqRKp?=
 =?us-ascii?Q?En6Ez4q79kKOpPedwEgucIZyfoVkGRFAa0VmhawOcivIZBwEti01rlgz7ykj?=
 =?us-ascii?Q?7bwbgbiKyS4mxRa8XefR5txNUSkDMKU/Vpilz87e9Akki9AeSwCBnSN9+s07?=
 =?us-ascii?Q?QH6wOkLnTmQ6LfSGsEr/74m1hWMivdqior67bmouHI1NkCtHmPMUmVCs+ymL?=
 =?us-ascii?Q?PqYa/oYJnrcRRAU+rSlKbhWyO2i+3geBbMT30TLW9pvTykZrlm0Az6iWyhHw?=
 =?us-ascii?Q?d0pzICHRkxNAJilqn+loPm295Y0LXJkuXvoRvwy1Favdb6f281VW2jzhTOp4?=
 =?us-ascii?Q?N7Q4ouTVI4CS7HnrhR4tAqXWADBTjyN+2Zevhxq3aZy+FVKYsUQeItKyttCR?=
 =?us-ascii?Q?P8mD6PP69Qm0F1lDuPPWweafce+2aqVXtvaVUXyTKxcrPJr5RcBff8c6381q?=
 =?us-ascii?Q?iZpRGjTUtUqtsD92E8ddpdHJfZzfzfVRAK7Y/eL0j8jjLCf0dDb/qy8s5+Zu?=
 =?us-ascii?Q?Oqxq34hSiLHwxMQ8/Sx6l0qbORABvrbWcvv74E339BAoJpOWyNVVobQpl0He?=
 =?us-ascii?Q?sgR1GNv+0yh1At+4/cdcCx2l2aYLW47w1hPyXmhXXI214HCkCczwE3kLtwa6?=
 =?us-ascii?Q?NEDYL6cUBmvShSUmYJSwGF8Kn5JU8VjG72vJ+DWcM9ORiKjX/pUxy1ozarTG?=
 =?us-ascii?Q?1R/tw2WzRggaM1rxsh6Boymd+mJT1EAL85WTfZNwtPcZnwTgwCFFqJvwDBwH?=
 =?us-ascii?Q?fT5l8aBpGw2/iZO3vqOn8ArpDlsG1HkifzfjTg/ekNO1h38GdUTeFQQ35kA2?=
 =?us-ascii?Q?KMC2h6nXvGLA6dm11083XaKanP49WX1g9EKAbH38ZX/I+tBRC3mYvh53dGgJ?=
 =?us-ascii?Q?yE4SHQhBMTPRiGhPgRrdmz9pEcmf6uDze0VWnxUGWZHGXnSmqFBC/4RFZDKn?=
 =?us-ascii?Q?2zwx1h0pExE7mUbhp/2GrPWDlEGXbXokxfvHwqTEIjkkAcQzgBs/ZM45A1JF?=
 =?us-ascii?Q?yWrQ/hcq7elINGh3A2rz25ihIYGG/hIyxYjYZxdiMY2SYU1CZp7H0Dx6UTsJ?=
 =?us-ascii?Q?hib2C64GEwNU31ZegHD8mm24Rxt9BR+z9Hveje4IBLDm6ExxgfseNxPi5JyD?=
 =?us-ascii?Q?g5yoxtT5bxALpsDp5gKMH7xWNxDFLRc70qgrtVytCJsGPmIrX+ehoCAeEREl?=
 =?us-ascii?Q?2ulR2X26vg5ZCH3XWSqQW+Pp7Crbqf2a5xW8q7ZbQmLneBAArsHmLVslKRq2?=
 =?us-ascii?Q?TENImqrNwfEVgLc1MX8iPt8P7/FiHWS26OxGouhvnZs9KLxW4JBwbnBZawao?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A306D49707A7CE4AB2918E25BF256ECC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33cde9a-c479-4d86-a008-08da94d56ffe
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 15:42:45.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7axnAcNab7QS5ixXZxiAFJbt550cb3aSyezUOWfsn+V8jbdyh1f0n4M0gUK9NtUnL6qUslK52rjREME52lmHLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6774
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 03:30:18PM +0000, Arun.Ramadoss@microchip.com wrote=
:
> On Tue, 2022-07-26 at 17:21 +0000, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> Hi Vladimir,
> I am trying to bringup the kselftest for bridge_vlan_aware.sh, in that
> I am facing problem during the ping test and all the tests are failing.
>=20
> #ip vrf exec vlan1 ping 192.0.2.2
> Cannot open network namespace: No such file or directory
> Failed to get name of network namespace: No such file or directory
>=20
> Is there any configurations need to be enabled in the linux kernel, can
> you suggest/help me out in resolving it.
>=20
> --
> Arun

Yes, quite a few, in fact.
Note that I'm not quite sure why it says "cannot open network namespace"
when the command accesses a VRF instead.

Try these:

CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_NET_L3_MASTER_DEV=3Dy
CONFIG_IPV6_MULTIPLE_TABLES=3Dy
CONFIG_NET_VRF=3Dy
CONFIG_BPF_SYSCALL=3Dy
CONFIG_CGROUP_BPF=3Dy=
