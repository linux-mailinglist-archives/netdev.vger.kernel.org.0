Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286A157CB16
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiGUNB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiGUNBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:01:21 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5815761731;
        Thu, 21 Jul 2022 06:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXPdY0ki9G9elQ5P2TSP9RlOkByYRj2cDy+o++Huv8tD6ugt5KSGB2MMTgTHQoZBD572Hve9uerb6SKs3mnv3Ihz08eK+LsBcGnSqFz214TyZrXTYv66y6zb/bV5S5+5X9+Ktf29+z9xHecrGGIU2vO7Rr5IJ7/eiMZd/4cV9Ccq5mV5XqRv4ARnCd6orJVsx3jMOU48aq7nfJYlnu2t0yyLIyKpAYGEuUVT+o3uoYtwa45HP/ewzVOPzsKL1rObtKooZH858UheqGy+JTnscnhVVVxXPqisSPbZ9Rs0Sw3IgYM5Q8mG+VV+yusoLtfFSumC5viFBodvAjF7Ba8e7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxJTEDhyypAxg6zzEHqREA+rA09qYPgFc+dBsxBKbYU=;
 b=mRgnGzIOeNFVvE/MKKc8R9vMUAgLcuLkyn9wrKatq74XBaqCt6qzLjDk1H4oiwGXwHHoDdsdfVnxXicKZKXy8SRF3dTF04Rzv1BaMJsTTDBm59RZ/geeCS1UifrF642at9+FlCUfkUFkg945wtLTu8aGXC7zdNDywkRPyCYLse0EU5SaYYIF5Z9Ja2s4tddy9DueT++3gUSPYoX1aLT91A8l86Byl1bbvmkpZbtTuuR5t2ofPvZb7ukO3Ut9ukaMgzJ3wcWW1j/QgVA+2sAPI+/CnfXuKR3PCD/Za2VppnLtQG35/tMxtGke8DuMe7YtiRnmET0ON6UBLNkE6Vk2Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxJTEDhyypAxg6zzEHqREA+rA09qYPgFc+dBsxBKbYU=;
 b=K5RSCG7y00X1uMC2ik8S1Angtjzp4JX8IhoR1cRMANJpnJWn1SVYC2DyOdeioz4XKZgd7kY975n8ucVtlwEW6Ow7GZ7n54RedGMIKkEZuuQlQaBEh3FxYpCkGxcErPvsvyW5XMiWpOozmS61+NW5afJNcNN+5zKTNe+rCjeCCB0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6814.eurprd04.prod.outlook.com (2603:10a6:803:138::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:01:17 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:01:17 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 27/47] net: fman: Inline several functions
 into initialization
Thread-Topic: [PATCH net-next v3 27/47] net: fman: Inline several functions
 into initialization
Thread-Index: AQHYmJcSk1B+JJ4ArUCiVDPSiXDKIa2I0nuQ
Date:   Thu, 21 Jul 2022 13:01:17 +0000
Message-ID: <VI1PR04MB580732B9CE46E1099C56B2A9F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-28-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-28-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67adb849-1473-4921-8e6d-08da6b1919c5
x-ms-traffictypediagnostic: VI1PR04MB6814:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QrPSu6uYRsAcyh/DOz80AFDTshlrn3ZRwMZbDvi1WZFqDsCO1P9P48ihWfGlHtmCrndFpUkQ912KBB/x5O3rcpb6Q/7kjqj0taG/z7qAjzXaS3KLnMjPM/iYKXa6yHpOxigmLvR+UqAGIY43G1LJ/JwFPDWWCexYYKpfwW8Sq7lDZyS7ipt7UD6EmmabopjaXSINZacMVS0D+rJ+A/OogmhGKrwaJMtNMHcQF0xUdHrfIdCg+/gjsiq8pckk811qDeD/0m3E58DDiZsTeF4dmgWzliLgM1z4BgPvpvA9E9jixelMbzxwaaMrnMkPnyZVn2uhg18rUj3/o/q33vOLmpZqPJbRdPbM41VoxXIkOduMF2qnkG4ZWqTZdP6m03PXJbtbHAF1pHhKMopeUVHDEc2HMj/+7gmLaDPUJa0dZzl/LbiavHDsuCMlKs2Of9rEbN1I9VFljwiz0zCXc9AiXMGkDzK50t7UEeJ07bhf/TqijbKFl15Ec4Ph5a6iFPqv/mpSrIbi/pytigVpFM+G6lVvsFH5xlynDhuf1JH+qDPI7k3iqFbBohGMWIs6aGj5gMVdFJtIFs+TI8VdznX+3dwStjD0Knw3mMy92G0ATNQdiLyU9BQrUQ0l61u3K48JtQ63/UgxHaiITV8k6QZa3AloiA9K7sPEvDsr0Jrtijx6DFL29VR5M9CRyjmT6cnoGhisgaEeLoOnvAeyiHGXc500h/1gaLFMa8C2jD1ErqiGZI0rcf84zWmS1saWrdnIgbIRK6m6AD230wcSH7gqhKG2dkicnjWcNZd9L4kodeQiXUc1OabZT04mcwKYgDTQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(71200400001)(6506007)(7696005)(41300700001)(8676002)(4326008)(2906002)(55016003)(64756008)(478600001)(66446008)(66556008)(66476007)(33656002)(316002)(54906003)(66946007)(110136005)(76116006)(38070700005)(86362001)(186003)(122000001)(53546011)(83380400001)(26005)(55236004)(9686003)(4744005)(52536014)(5660300002)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MgG5QU0oHKdDDi2+qIyK+6gBuM9tqVuA671LaZUQw0hZDGWLkvyXsJhbY7c9?=
 =?us-ascii?Q?K9JVpCZItL1FhPpiaaq3ZrAyAn2uqWCJs+f5z/DygZ2PP2nYfIbp5/sUwOMt?=
 =?us-ascii?Q?NEK/2RDe2HKwCwNB0HwO9CPP04mI8tZysBmEJ2i6R84iZpfiPKZershhsL3O?=
 =?us-ascii?Q?ClMD479EEtxZRLayXfKVp9BqhjNEsh+RChEauL3Ax5QbNLCZ0Jr7I5JiEh/e?=
 =?us-ascii?Q?qhIAxfnsu/vx/LAfGv9Dz/x5zTDozxDeLI7P0xd8hSWmWfzL4+ooVONTfQ55?=
 =?us-ascii?Q?Lb1xw0+Edunjab/wivTMVaU59Vd/9Kq+lh+6jlNkWll5EQYbXqgxGigAUfl7?=
 =?us-ascii?Q?1j2WtXq11Cs+p2FUddxoleENI7kmh7AmohW/ChGLTUsMqhr8hCGYJhmNOc9a?=
 =?us-ascii?Q?sYxpJl5YcLtHbwS/n9SO6neUkBPDqV/FoWlIHyUZgittc6d7CeHrRllJZc7G?=
 =?us-ascii?Q?e0yw3kQcSGLasodmEOqPn9wFY3XGU873DVtaecwuK5ywaoHA8I+v/ctDTMKb?=
 =?us-ascii?Q?GViNZpmLYRtgRyMKSaLHNqrfftXVKxQ5OUy4IIeR7ckxKAGpEm+sdSmd3RBH?=
 =?us-ascii?Q?QRe9A8AwWOWguTEMxL74Qc25+IVcxGdz72gcFeS3K7npN2hNj7lM4sa+im5Z?=
 =?us-ascii?Q?kbh7CRzg7pqBJYn4g+GwCIEliw7N7nDx/6UDD4wvcEZDpgXqF3ekzKP6Xq2c?=
 =?us-ascii?Q?eyEtxdWKYr02fhBhbZqixrqRCbioGQ9VyBaPhlizk3gpQuqny8Wgfm5GJfY+?=
 =?us-ascii?Q?ha9/pvo5vjgj7PD8kXEoWuAc7shPk3jP/nd/rY/Pzk8BWorgaeZOyYv4/rh0?=
 =?us-ascii?Q?JNumKYfpqoW3KifC2H6llvXCxGoDVxxspO4D6867uL+zvICKoooXMX8onfmk?=
 =?us-ascii?Q?22aI9W9KlogrkX9cPhHkOTqYQndSlWQCILH3pFH6KYzKv18P79dUD/37WQrF?=
 =?us-ascii?Q?9YQ3V+Ce6dQTtf4qw9tSYHM3KHSeqYLR410XU9C7mP6llhSD3xSmcK6sL4n0?=
 =?us-ascii?Q?KRwbGwm4K2khviPZF9VjFPSD7WiwhyoJ9en2KWQlhmTXJZ8GUM87uoGgYFwd?=
 =?us-ascii?Q?p0aNs7V7HW9MwUJsytjKrM47RVXzMFw1YWIuYShkMuizg8hLdps+bqvRmvt5?=
 =?us-ascii?Q?uZueeo4GO6oIqyHFDE7n3NakwamjhAkbc0joh4TfhOXhjGe536CZV3Iw2Zq4?=
 =?us-ascii?Q?os493Wv0d7g7Zle+LjiWjpk8QeCn7ZpKUq4GcWJEUroBUaRbaqtTmLxe735o?=
 =?us-ascii?Q?IbCPFdtnlGADes0zBF+ea/LBjWIUWjNn2fyr8t+S3TYQ7iKumE+e0Cz2z8ZG?=
 =?us-ascii?Q?QVL+ommhuCJTVot26p7IOnGGK2odFLOmIbSOm8L9SErNJSLquu1FG/lwo7qE?=
 =?us-ascii?Q?1z5SpF3AN2TN8vUlaK1RDE4MA26Dvwsf3+o2hvgDiyhM07I1x2cIV24jOQYT?=
 =?us-ascii?Q?M9K8O0dHa504oXHT8SGiClxFxchVSWX6uLnuLPbfFveYvHUOsdcvCEFdpe+V?=
 =?us-ascii?Q?8o6QZlG0lWj739gKBJgHlXZ99IM5Iooq2Ke6RUSUYkw7Ncal1taMeMcgslJa?=
 =?us-ascii?Q?w17ZB8n/eFSo+Fn0A0P2UbtB7ivMX3Y1cQwvHSkY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67adb849-1473-4921-8e6d-08da6b1919c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:01:17.6609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IEc3Wxlw6Ec1wnI0r8LSrK08gvfK2ARHXIUXXRLwR8x0CVkCw2NsmRxjM2CqDW2KFgle+YPfH04YxpAp2NSZnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6814
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 27/47] net: fman: Inline several functions in=
to
> initialization
>=20
> There are several small functions which weer only necessary because the

*were* typo.

> initialization functions didn't have access to the mac private data. Now
> that they do, just do things directly.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

