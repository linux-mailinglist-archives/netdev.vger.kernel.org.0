Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4C619BC1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiKDPeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiKDPeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:34:01 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150081.outbound.protection.outlook.com [40.107.15.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AB52E5
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT+4GvFVciSH/icF/wnS5Isjxo3Q6340wds3SYW6YfiEh4dXr/FNJhcG+q1elYkyF9AXg2U6K4XS+MMAmXt9EwhowPODUZalF9uWrmvfuXFZzjMFpLCy6/soD30h8OcWyn/D/Z4/wvHlhp/s/HZypDVFLmR5Gq0qlSMAhKgszBk4yf80V9G0nmfIpRmYmh+RKd8bl+21GxHy1nAAYSZa1x4OXE2VP55rOoExk9n//hxRqRd4uHv1+W4pLX+f0j9qH42bj5ubeCmJY0UIT9EmO4GDLdvMddT0cmmQ6JYmUsoq8EHtsjl0qrFWffK7fLQqyk08RoDZlHOEANeGL4OFWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjhVXfoI/aBPwz0w7rfXP3R874OL+2GVH8tM/hVhX1o=;
 b=eXCRxQgJi8kMOhWSYE7ifehKjoi7hOf21L1+bdJWNHF09CPn7mR5+B6mqc+inJCNJ5XGKilDYurPmZI1G3Ik0+0rGPgHxZNtn0QyB7+8qq9nteqily2ieCxZ+zdvaq5KY8Y8Pl7kATuGpCahTL80sm3ZDqzPJ1WkUOFYMcLdc93F4xxEcrFvKFqOOS7d5CW6mJMhPFIUhCAmuEALUyuISG4Ch6cfT0hK4Z79F3+fDVIAOCtiUFNJlxrGaHyYm7XfoMVf/txLeRM7OyoQh/SczLdJldZDZkGKGbaCv35xJKF0wVmKTYh6yO/H/ZPL/ynJ5pjkAOz+2C9ktzMFtQzPww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjhVXfoI/aBPwz0w7rfXP3R874OL+2GVH8tM/hVhX1o=;
 b=TGvZdoAX7PBzrp6vFGlyMCDhHg74knwS16KhsSNeXyXnfm8t07n7Q3WGSCOGlhSM57RB179TM/BHUb873xKSIgHsxaWtKDeOvLjblDsMMqWWLHhSLaAtrai6E7tdl3r2IZuqVFyiu3XrpUxsr5Ln1HUelhdi7tUyR3CVucEZUaQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9116.eurprd04.prod.outlook.com (2603:10a6:10:2f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 4 Nov
 2022 15:33:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 15:33:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Topic: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Index: AQHY7efc5i1n/1Oz0kGxX/wEp9VJma4upEMAgAAC6ACAACDfgIAAB/SAgAAG3YCAAAZAgIAADL0A
Date:   Fri, 4 Nov 2022 15:33:46 +0000
Message-ID: <20221104153346.776wommuamwawvwr@skbuf>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
 <20221104133247.4cfzt4wcm6oei563@skbuf>
 <Y2UbK8/LLJwIZ3st@shell.armlinux.org.uk>
 <20221104142549.gdgolb6uljq3b7kc@skbuf>
 <Y2UmK/z92VEUaMd9@shell.armlinux.org.uk>
In-Reply-To: <Y2UmK/z92VEUaMd9@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB9116:EE_
x-ms-office365-filtering-correlation-id: 65d5ab08-253b-4cf6-c248-08dabe79f6cf
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wtG+YnIbiEFDq0uKFobbRSqB54hQpmoRui8BQU8Pp08s861ojSqku//oU1vmpq7t+9OxxDRTAK+Jsoqk5SxCxgDrn5dKKEDTEscEPYuejJ7ksK+zk9p/KBJ1a7BzckRoofTbEJgrE45xSmjXmg4iXN7Sv3TWuel6tK7FXWs4AFTqAyGOpxj4SCQvtdGYIc2JG4Q2sG/CxBW1ykcdlMAnw/P7umrCGKzJtwS/DAo/zaG5B3PweY8WeBPMpYBl8hGj/FxQhCjjuH6b3eaveh1c+zUpD/vg+6b+HC6Wx/EwwPtKJ5TRPVHE+fLODEPUCRz+jCtiBwt85rmXFw/7S5q+DYMIfTBUnf9dvlxrU8b5ab6mwLCaDNnp9C9AUDZScjZnqkjrkTy2IOHas8YK/CeTT4hDioeiDs26Ifdbygc4frGLApZQ2nP1jMiTBiPJjqO/yMVwmzlPdGpjoU4oJ5l7KC3kC4IhIG93wVA12F6D8Z+9ZvFTfKvujlSYe/xLZlClJEUJ3Uq7ogaPz68bb/ck+R7jBd5aqTPrD/0kIj6D4HostdQdVaOA29TXSqGQBc2+eUqZBObpkEU0Aiu5qJLxAWjou0yjpR/Kh1XT5T2NaMwK4q1HZFlq1lgvv8PkDaYQb4sKWCZfmgFn7P91UIb7Pc9NDMoAehiQzHa+Vk8slgCrZFLvWpCtPH2WJeZDmszQQT79gEnSClz3bM/PmO9FEyTzEQSf1tARQGR5Q4t9ZYkK4QBQWIZoIHaM/G8uOs6xfxeuFNRzxOCfqs+T50Mw1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199015)(38070700005)(122000001)(66446008)(64756008)(44832011)(66476007)(2906002)(6506007)(33716001)(38100700002)(316002)(6916009)(54906003)(4326008)(83380400001)(76116006)(91956017)(66556008)(186003)(66946007)(8676002)(1076003)(86362001)(26005)(8936002)(6486002)(6512007)(478600001)(41300700001)(9686003)(5660300002)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OyXYObjjEuA5OvcQuP4XECB3cdMTUXpFNBSO0wtGWTjpi3UA0ppaLnJHHNZj?=
 =?us-ascii?Q?yMqpQk+/de39NgpbDgaOb9QSRM11SWcm/0cDMUeMTbwHwbWfIergBPTUUKrM?=
 =?us-ascii?Q?kMxMVQDnE2JdKh+gkJ0XkpNk5AAk20C3mGhHGyehpRILxCdq05s2Cw6sE8Ty?=
 =?us-ascii?Q?41hmSzGuXtk1iUClpg91q14B5UJOEBvoJKWL9XEGJahzmQ2i3+ZXMkkNmaXD?=
 =?us-ascii?Q?u+rHXQDsWQkF4dyAVOq4mwPbl651E/Mm67OZ8voAa6uVsaNqv1vQy1U2Ds+A?=
 =?us-ascii?Q?CIyKuEO2Nx6PfYvb6PRQ3bHs/omcKFf5dfjevVeRjgthozYbCoS2MiM2y9XF?=
 =?us-ascii?Q?MKjhfS9ikL+x+UDSCFWVVVkq2zaS0U8WYl0Nh02AZMCb1DsCFbViIv8v+n+i?=
 =?us-ascii?Q?43Z05s/9DaHIJDImiOcQ4wT9V8sGTrJupUi2kgHcNv3bB7G/sUY1vbWMaBM9?=
 =?us-ascii?Q?xrvosW6jkvTsuwYNeKxyzsjB5KqOa+5lmNtsfnrRWmQLtwDJ6NTlp6k3SLbF?=
 =?us-ascii?Q?3RhOAwNfBHUCoJEGl1F7oubWgmqTtv/8V0c3rK8gLy+6tBun2eKbtbYW84NC?=
 =?us-ascii?Q?K6bZ7UpbgU5cbVrBanOYW3SFrOaZLz/REBVFFCnX8+Qve7Blj7QMzKoIRN99?=
 =?us-ascii?Q?edSNKqYu8wgZenq/yDto9t6eVnmqS8hZrqICDu2SE0hB12S9g9nQxNR6cd05?=
 =?us-ascii?Q?nScyDZLtqkaKBjGmUyvlKSre6aRWiFV/qOheZDRqX6AX14ta9NERVVpLbkCu?=
 =?us-ascii?Q?nDslMlAWLqGlfBtQHqOhpor2EsNOTkTIbb4vKaVWtF4+AeSnKB/wPi0Ft30f?=
 =?us-ascii?Q?W+i1tv62SIXVNPRgKYmX34Clyv8X1k9TNFePfQLk+mh/qPW7QGrHl4/lBEqB?=
 =?us-ascii?Q?fJjIfPWlqr/Sk1yB0kfAdw4uIlVPJst2xbyRdeHJdSkNEi0CVL3qY+/L7uzL?=
 =?us-ascii?Q?iQOMXDzq5CZ3oZkVeYKqq+Z/P7eoMWY+h7xhhrYtOmsq4QuqX98QcMgCKtES?=
 =?us-ascii?Q?KLjzDFLjPpexHQ7rLjBsZfEyoVjyIeCcYLnDNx3FDq0Wzb4S9FkLZvEOXKf3?=
 =?us-ascii?Q?RQll9n++o/kgmK0/olNyir3U/ihOODaMCpRx4IhGi/LeaZ2jG3XH9x5EYXU6?=
 =?us-ascii?Q?RQP50RC4q0+q9h+44buppJh2GTXfSvGLXEgHad1+GypIjggZWPChp4supiLf?=
 =?us-ascii?Q?3iAbOrVsdmdVzOCeqDcJs7dULv/OUYqr3QAsw4W88mk7ifDjmNV4IivekPJ7?=
 =?us-ascii?Q?xjJxUd9wFhqTNPjS3AH3K5V0FcHYFnTqgOF+Bg54COSQg6Mrjlny1GJT7yAP?=
 =?us-ascii?Q?aBubPTol+JEQ2o8U8YfaYj61rd+UxD5q2rA6Uh5W58Kmhm0cvVp18InU1glX?=
 =?us-ascii?Q?GKRA3BqZYb0V8I5wsu5C07YiY1DTqj8pcd580PgzBAmgS0QVLvTl7LzU18ji?=
 =?us-ascii?Q?jmePBN6iSoUhKH5qd2/tVapDdLJoC5y3VFWLkYlgF/3wPGZHeeXqli1Q4HLd?=
 =?us-ascii?Q?uTFSn4DJPdXN8P0wgHCrk1dLw2WxKcM6kNQpKX9I1QYZqwc3kcX5CdJXY1nE?=
 =?us-ascii?Q?KpJQkpbG6zbiymrv91jrVi/9mP2nSWu9CAqTu+jrO6azBuFfykn+JObMP9va?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <180D4CC7768F8F4D8EB052B2795FD8DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d5ab08-253b-4cf6-c248-08dabe79f6cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 15:33:46.7477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /KUyKPiEzFpErxDq6S14su1enSGtE1QWcCZTyhIEmMEThzFg6+sqd0zC7nfTnt4KgmiPHEafQL41kcDW5ysxBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9116
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 02:48:11PM +0000, Russell King (Oracle) wrote:
> > > > However, I don't exactly understand your choice of fixing this
> > > > inconsistency (by providing a phylink_validate method). Why don't y=
ou
> > > > simply set MAC_ASYM_PAUSE | MAC_SYM_PAUSE in config->mac_capabiliti=
es
> > > > from within bcm_sf2_sw_get_caps(), only if we know this is an xMII =
port
> > > > (and not for MoCA and internal PHYs)? Then, phylink_generic_validat=
e()
> > > > would know to exclude the "pause" link modes, right?
> > >=20
> > > bcm_sf2_sw_get_caps() doesn't have visibility of which interface mode
> > > will be used.
> >=20
> > Update your tree, commit 4d2f6dde4daa ("net: dsa: bcm_sf2: Have PHYLINK
> > configure CPU/IMP port(s)") has appeared in net-next and now the check
> > in mac_link_up() is for phy_interface_is_rgmii().
>=20
> Great, one less fixme. Still a couple remaining open.

True.

However, do you agree that phylink_validate() is no longer a contention
point, and that now you can rework your fixup to be localized to
bcm_sf2_sw_get_caps(), which frees up the possibility for me to remove
ds->ops->phylink_validate()?=
