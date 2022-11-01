Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E70614AED
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiKAMkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiKAMkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:40:40 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2078.outbound.protection.outlook.com [40.107.247.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3859A1A3A2
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:40:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6b4cATwxWIyWy3XXmTC9v7YAk8JevnvOo5wzsgnc44WSndOauwKgIM2rK5DMRpiiqaeoZ4jv3GNQQsKNewv6RNjWXM/eew1K6GDShu0blst+DuTBgQN7uZoIlB+LGy/szceSurA8RfbAkq9ekeAJlXyz+UjN715ddEBnvJrnT8osXuxMjgCpv0jZCjlgsFHBxaU39BWNiOP3a/smpAGKeuSv7P8KKQ5rNuD19lP50d35pMATFXZLuLXOWH6GxyF3REztnRgnaFEBNOuQnd/qZ+L1RfoHzWPFpZIl4dVU/lv4jemqoLWsJq+vtqS3gfIO7JBSulMXSAT9RVUh6douA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogy+DLXLYa/fP0cBtkCxVzae5PL4RdMDKC4AYAJmpjA=;
 b=a2nuAfuqTGYv+Cbi9FKI/rKRsaQF0Ml6xzjS/lHo8GRSV47G6Fk6Nr4Cg9wsM+5KfNuJXtPApMwLwQwOqjypMmrVeA3L36NLv/ugdd4JRaCDpHc3w7zFZMvPIpYQLOWe1DvoifUp+jO6zh6KanodHyMoYOdSqoiWfqJtue0y5P0EC2/5ozEyIWHTsKHRDhxpEzul51tiRxPkI8EqLSn2AYDN+ot71u68BFPS4nSyBQd7Br6/TS4kRktAIns3pBZqT718p0QkyS596Z4d+4q30mKOVJMzk27KoUdThKIgAdVfG/FPn2AzCjMjJP4+R5w8jv1yDQWl0u9r06QHptzxaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ogy+DLXLYa/fP0cBtkCxVzae5PL4RdMDKC4AYAJmpjA=;
 b=racUYGRcqZ2iaASmmaOXhp2eL079d2lcM3RibTBdesslGTVIcWWNgM0fHOsxLJL+2meGB0A319oFWMg5+U7z+skocjiGmA+cP6kXdQDohNqEz1FG55Or26NxaT+KvmgK+o+RytYCmpArKCis410pnfCnnZwD6TsomW6BwkBkRbM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9480.eurprd04.prod.outlook.com (2603:10a6:20b:4d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Tue, 1 Nov
 2022 12:40:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 12:40:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Topic: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Index: AQHY7efc5i1n/1Oz0kGxX/wEp9VJma4p940AgAAK6YA=
Date:   Tue, 1 Nov 2022 12:40:36 +0000
Message-ID: <20221101124035.tqlmxvyrqpaqn63h@skbuf>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2EKnLt2SyhjvcNI@shell.armlinux.org.uk>
In-Reply-To: <Y2EKnLt2SyhjvcNI@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS1PR04MB9480:EE_
x-ms-office365-filtering-correlation-id: 8143a7fa-9218-4be4-ed74-08dabc064695
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnlZM2zF48FROG6o0tETnZ7Vf9XToVy2p+/usN8/KZXX1dqNOna9+3umfPtGUKJI2rZXrZI0vqulLGq3LGIFBTglTDcpZGrlwqrXn30J9chb9pnXZY24DpIHB153AfDgoVdm1KJjYehzSuMvFBXg3OcClvWdIkjX4wo/8f5uhYiLNSWiABKKw2Q1hzj+TdYXVhZH2irJEymxUt0eQhLEshGU56fAgVNXgZ4ctq16ak0Xfdo2KCL9UFbjNOx6XLGvJUm76JfhcP/2cB5idds+2Srbw2npZFHxO5ORSnEi0HuY3sX85Xr+A712nlvjibSweTkGibhRjn0ElcqpOgPOR+LJqSB7wElDbAo42WH1oGCOfVNuAbyTDydtf6KDw4gwyStd3NXvAMhFgGAQRUvGqLfclsnG3hQWNhkRaJdAMaAf+7Gx0mUpveZ0Z49E1IYVpYN4O/rUlral8WlEl1wmrl/27ZPaLoZJoS6lXc1cGwNLn49Hm2OmCfZ0Ucb11pV9MdQ+V2dSNmrKVp4BwiXShl2s08FQEWDAkw2ygPN+faEfsoySVpjcP0O1LC0DYi/NYRbAbiGhwt0ogwOrxN7JHdlBYyxXZXQlSA97yqtfqwJ067Djzk1wvvYsEQQ2gKzLSXVJ+hhjW7JiYCZpPXLdTrpfwg2/68+CnEUYLquR/9vgz3xliMXvQ/qddNkXY/Sbq9SVmvom41Rb+lPpECwCh+F/nLC8qytfelBsSu9jCXrkEQXLZreBrfndr0HKDT+/yWnsmnqLxcJ/S3gtLbXB0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199015)(44832011)(1076003)(6486002)(186003)(7416002)(71200400001)(478600001)(38070700005)(316002)(64756008)(6916009)(54906003)(83380400001)(66476007)(66946007)(8676002)(8936002)(4326008)(6512007)(122000001)(66446008)(6506007)(91956017)(2906002)(33716001)(26005)(66556008)(86362001)(5660300002)(9686003)(76116006)(38100700002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xwRj3kw4jnm7Yknr83jx6puq+U1GjVEXRobuTNWX8/hrKpHGhYO+PLRW/Zmi?=
 =?us-ascii?Q?Nyt5QOVZ7vGVdaoQpOl3dvUrSlC2Fh4cGEsWQeG0KmNuLR5R809f8xpSjm5s?=
 =?us-ascii?Q?QwKir6mmLZwikVS4UlbHBF2kE+f8L8u+whRFgng4LHc5t5GXZMSSdtu42VRT?=
 =?us-ascii?Q?1aMnISRqxDyIJCAY5b6OCy6f/2ijFiZRPDyE1B17tOrsaBl5+V5GylXzLCfT?=
 =?us-ascii?Q?7MLf0PiOQj9MLCJtwePFrzJp1i6fs+qyoj0aznvOgUTDNOs4V3+1TyxNT2OV?=
 =?us-ascii?Q?IJaVUXaeEQHEuQX0oX3gz/xC/eb5Jugip/kVP96ZUzq065VOE7PYYRYYcVCi?=
 =?us-ascii?Q?JynBDg1AIoqaAua6KPmF2nIIxxhi+YI+2PjB9ADTGjfcIm4ucFM+muv/hfV6?=
 =?us-ascii?Q?MBiLr/GRnpUIrDja76IGDkXxu1R07uFtVF2yiL4qRkaheWeaI5J6Q+hyFmj1?=
 =?us-ascii?Q?nUem92wzFcuWOmiS8tAmJxuKpzLDg+45Kg68gVLP6T7ryT52QDMCMUPlx1WI?=
 =?us-ascii?Q?Xdq45I4I7ihtFDrey4pFgJ7/5sZBVeGh0zoSzak9BfZ5T2/lYWgUbO7dYcra?=
 =?us-ascii?Q?y6UPF45g5GIBvzh6zkIwxnslM/qOuD80cmXfNsVBPbY3ByY4rVTIUvyBpKRZ?=
 =?us-ascii?Q?4tvaqjUmHpQaG+EANSYyjV04TykL4jIg7uNILt1JayGRyRIKaszndTplzFfA?=
 =?us-ascii?Q?foktyPzBBktha3Vxxl5y8VLqPp+rcoqCQannVaZbrq7ZZc4idxvSeNXs1gx5?=
 =?us-ascii?Q?aLpgLwUfK+zsRgxI+pIbQMQqoNz9fmlGUPVdhF1R6yaBDNSE11eK+Pz2mxOG?=
 =?us-ascii?Q?NfW2ZfzIp+nLb0aSB5mhgigUDR8iXlQDtKZw1JTvpovf1xFHwyffSgik/xEB?=
 =?us-ascii?Q?eSaB+fDKtUqn1PGR1JmZZ9S4/o6Xhn3uGhHdWgKcJO70WbeSpd5T+8uOt4Fs?=
 =?us-ascii?Q?0TFRvu/u5p/BFWitL+yReZfVdoqG64RogcfzTTfKpjTRIrjgA/r+VNpy/05E?=
 =?us-ascii?Q?dkWFKt0wfEVZLQ1K/PZZfE3Fk2rfVwNYI0anXnh75tEXxelObC0SjwamPnx7?=
 =?us-ascii?Q?Na4hxPZ79lj7YZ9cKrIK2u7hV6E1BkK6t96tkWdTbyr8oKJfGqZm0i6iJ0tL?=
 =?us-ascii?Q?T5iTOBaFKrDXy2zwwHdii4nb6tSC39+vZkoI8wEb906hYYSCAV6EvcsC95dL?=
 =?us-ascii?Q?psFEHTdTE8WmIRYsti/eIajlS5ALsxu6G8WB6vvyYhR7cdyqMWrNI+G4F/w9?=
 =?us-ascii?Q?13Qvfg4pqzqAc9cD72ZDvvUD5O093zIu5euqU3sbAWR4CsRKlfHeTnfxZzXE?=
 =?us-ascii?Q?bGxhtBePSjrHaJzBMrxSirYA577YCMrCGVX7hNwYAbbsCT6py+Ggs/r3r2OP?=
 =?us-ascii?Q?xZlQwDgR3SSNVXENNbfZEMH//ACONm354s9a7mR+8hwlZZb/1cOo794GZPtG?=
 =?us-ascii?Q?yjaoXPV0cFwVXJ+ThoNZoR/prrKXUh2lHallRhN4pl0JUAYxM6BnUIQQx3Kv?=
 =?us-ascii?Q?LakZbMlz/Y6/H5pIJ1pxMG3mW7lS8kYPFa9zJN5Rg4TrVmMCiEZuDoC6EXa5?=
 =?us-ascii?Q?isnRw8bokozd6JX4eFakHrzP0vLci08ENb6O9ls9CpUZQNrR6it91uXh+4hP?=
 =?us-ascii?Q?cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21ED1B8A662ABC4C85004F2C011F0BA3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8143a7fa-9218-4be4-ed74-08dabc064695
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 12:40:36.6090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ZqW42LPJpCsl8sZnfW5sXsTJMHz//Z0I100ZrDuXwE5C73Cj/od00LejhvbQi1I9OqOtp8HljaNpdTz4MDxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:01:32PM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
> > Not all DSA drivers provide config->mac_capabilities, for example
> > mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
> > those drivers on recent kernels and no one reported that they fail to
> > establish a link, so I'm guessing that they work (somehow). But I must
> > admit I don't understand why phylink_generic_validate() works when
> > mac_capabilities=3D0. Anyway, these drivers did not provide a
> > phylink_validate() method before and do not provide one now, so nothing
> > changes for them.
>=20
> There is a specific exception:
>=20
> When config->mac_capabilities is zero, and there is no phylink_validate()
> function, dsa_port_phylink_validate() becomes a no-op, and the no-op
> case basically means "everything is allowed", which is how things worked
> before the generic validation was added, as you will see from commit
> 5938bce4b6e2 ("net: dsa: support use of phylink_generic_validate()").
>=20
> Changing this as you propose below will likely break these drivers.
>=20
> A safer change would be to elimate ds->ops->phylink_validate, leaving
> the call to phylink_generic_validate() conditional on mac_capabilities
> having been filled in - which will save breaking these older drivers.

Yes, this is correct, thanks; our emails crossed.

Between keeping a no-op phylink_validate() for these drivers and filling
in mac_capabilities for them, to remove this extra code path in DSA,
what would be preferred?

The 3 drivers I mentioned could all get a blanket MAC_10 | MAC_100 |
MAC1000FD | MAC_ASYM_PAUSE | MAC_SYM_PAUSE to keep advertising what they
did, even if this may or may not be 100% correct (lan9303 and mv88e6060
are not gigabit, and I don't know if they do flow control properly), but
these issues are not new.=
