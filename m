Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC105BB464
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiIPWbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIPWbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:31:51 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2365195ACA;
        Fri, 16 Sep 2022 15:31:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7MOK5xJFjuxNWtP1bnEVkaB8jrmzlhqMwfVPEr5OJZf1N7HySRb8tx3dyJLg7cmekY87YMdzAVJ1l8GMXRBz0AqBgCMiZbtkjsQ9oZJEfi7aG2R3JO3Cy3f7vKkNwEfW+G6QdnKXqe9e0oWFlZnS//9Aqsi2nG7sIYr7rzc1ac74AI8A4D8PhUFiyZd9Yke1RlQA+ey7tI5x/+2AnUBwwvMILt8Y85gT/QsoB0UYHsvmZkeOw1hl+nXasL9pI8JN2Ar5cLldzLveg0xYb/zTrG5dYuLURDb1keDjK/7RZvhuNM/lzTxXEQdQlprKZt2dFaL8W8Ci9OcWQgqDYendw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dTGCt0DWlzmEXVVAbHr/n2lZBuOAoJU67Gs4syG9N8=;
 b=g3ReHSmj+fHV1e5oJ/5qjLW45u7rwSyrTPgQja/qmPzuWEjxLUYNkMqn0fQBr8K3/b2qVPR5fpAAV/4i+qb/1QFDWW7YWYmLryTTnZLvJY0QDFi39bF83Z7FPFktlNSrpnOXaU2M4A8f7gQVQfOX4KAPSDW3NmDUOZgEkojCbatP2UfMOVUygXrJDz5QxZeau6GUZevMcpgqIx4uK16C4301YFRiQ4nexZ2A1BgJq/eIVGk1EFKxu4//yH06NAxmfCzjxXeHgJ6JzO1Vch3KHiVJmFhimzYj4IqUygoAjzybkrwyda/4FVYZf5nqMxIIbgioWAW1LbjD/XFSElvJuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dTGCt0DWlzmEXVVAbHr/n2lZBuOAoJU67Gs4syG9N8=;
 b=Xo+zZDjo1rdAWX9iOx52JyGxPQ5qgivgC1XmnpghPSNuF2WyhIa6fsuFwqUCSm48oBPxU41dtzzXobVHtj6DrzsfQrB1Wg5FQg1sgpy2UkiZASb3KGIw7Ui/gvjFWIgZwu2GknszH0X+Ug9Jp17qFDLksA+Q+TtIdpbMoqgswkU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9340.eurprd04.prod.outlook.com (2603:10a6:20b:4e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 22:31:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 22:31:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Thread-Topic: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Thread-Index: AQHYxhmB6n7Dh7/720qmqJ9m50DC1a3iTiyAgABd1gA=
Date:   Fri, 16 Sep 2022 22:31:47 +0000
Message-ID: <20220916223146.a5djbyvwlh6jekw6@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220912172109.ezilo6su5w6dihrk@skbuf> <YySqm8t0pbH4cqR/@euler>
In-Reply-To: <YySqm8t0pbH4cqR/@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9340:EE_
x-ms-office365-filtering-correlation-id: f26a3036-d29a-407e-d1e2-08da98333db6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v8wd8OJXZkm3pn+za6lSoOmM50omCw3RH9RlHMZdaxxkpuxb1eT2MQLnIqLbQPHRtmtcZfHdbQz11vDmfhYACEwxge5+ncKfEUpcRRp/kU5rXpe5vnnuXRTTdIImn9bj5pwlgVrsGVCuX1LJP7fIilT/xJEby4vfhUhK8JJldn6LfArCeQXWZ4C8RFsJHyr7beauIAAdPgAU1fBqGZdrJhUR0PtXZK7wPcsSdrpE+F1tLxwcdrnuxiKRwdhxMqePrYLNcZbk86AAHMRyYGo4NGP5ygopf30Y34oopD8FWPR9NYJxRh/5mU7QcOqx8d+uuDhsm2sCzRpi4PekzSemufYV0EKaW/tqY2fSJOSQhLLerMB32rzj/1tL01fesTwE6X/aBBMX7sf4toy8N6uh340QsHw2cfDXL1tv4/YI8dNzs/UKtXNwgwtHKLcmiwNJvhjRfoltjxw+0MmYDwmmYU0QtdE1mQokrXpP/w9BfTNptMpEXFX3xeDKzvCH5djRLEiavoKcQZAJYDYsCeSx825VIj2qQWbU07qe+IqFWoTiyrd4yhGRYGbpJJIPPoq0IPrSlRv/ZWZG5pogdbPganwXa48aps4clpRz+hYeS4lnpxeaFSzWhlAfJ47he+24k2+QtI5ZuJuY4gIelEJzuChPW5SbsWa+uMYKMGe+2mtj3Rnw5cjMCm08ZRsXlhcY3B0djcGRZPqp19GnZvWenFNH2VvrAZlbA2dYKgtaJrVftmfoXYYj75uz7aaBIzsYF0TiXoYPPZRFcoBpn9o7tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199015)(4326008)(44832011)(66446008)(8676002)(64756008)(2906002)(76116006)(66946007)(66556008)(6506007)(5660300002)(6512007)(33716001)(7416002)(66476007)(86362001)(8936002)(9686003)(26005)(38100700002)(122000001)(186003)(1076003)(41300700001)(91956017)(83380400001)(38070700005)(6916009)(478600001)(54906003)(71200400001)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nxtHxJklYlBjtq5qy2+G8ZfEpmcRV1LDN3lbEqm7nNS9B3v5TRAO6i8M7/ik?=
 =?us-ascii?Q?zx7NrHFQ2lWvGQ9cOgRvLZ+r+XUmA839b3zdkxoqQrdxBEZPLYOt2YRJF6WS?=
 =?us-ascii?Q?VJf8wAUyrU3wwNc318jj4yDP0QhFvIgDPhLK4ciJNAwOrLdYR94rLQ00+blD?=
 =?us-ascii?Q?9ipRWTtADfIXFFR8mN974A0VoVkGYFbRgiAttFMfz3dcEyxMUHyGoYLuh7Uz?=
 =?us-ascii?Q?EeQtKr+vdVokMGvjh87fDPWRzz5jNrZiW1tmke+vftr/kn3FyEBWtYlU1l5P?=
 =?us-ascii?Q?uux5pfOYyedoDLWrLFXElpA4k1XmSuF3pUwuyyaJyL7HZJ+kKyU0Eo8H6iBZ?=
 =?us-ascii?Q?ky57WNA3qWUEkFV34pnmwjrbiHM6SUdS84NNlBk2vIsvRDcgJUCsb/TLjYrq?=
 =?us-ascii?Q?kyc5uG+IPQBVirfJflWdUsycAzRj68w5WCcgPZD2UwMFpxtcMzu6FfsxTVWY?=
 =?us-ascii?Q?nH6ZyPthcwQblZzjHEETq42K7jZBBM4A2iQ0dMEaODsch/O4zHC8/jZDUewX?=
 =?us-ascii?Q?3YUXLCswzK/gLYcMAffQPnMQnAex5Nhiq4YENv5Dl+b/zJ2F/vcZN8NA9eXp?=
 =?us-ascii?Q?tYhHNvBJ1h8BNhwQc/u0ptFHP2YTNDobdat2jghIrYHmW7C4u368gc8cMZ6h?=
 =?us-ascii?Q?y51ApGbgj5SCS709dAVrsUp2xT78aL+Vnw1KY3oJdNpLgUqYYdU5vAZby8en?=
 =?us-ascii?Q?1qOwtE89EH2KqYP4qrAkmh4k29iwR6GG8rDHxWV75+JTTJtdY64kLe4g11ct?=
 =?us-ascii?Q?smMAzTj9EIjPZf3GfO5BqtJ5pDDnodacPNb2eVbqfdvgCx8yrDR7vXTB0can?=
 =?us-ascii?Q?v6oztZzoa0gC1D8h+8iifqgnFP/KT3XxGKylzPgyKhmGSjciDVE0RBgaZo9F?=
 =?us-ascii?Q?WkCG2+fmNhApA064jE90xXTafJrGomAYwpMYcOFUVwHDOQNorodui9E8rqd2?=
 =?us-ascii?Q?wceixa/H6dpX7nHhZVXu6IDQf9eh7Qa/PEjMT0rbsKhhGI2jB+8M1zd7W2cK?=
 =?us-ascii?Q?joWJPySpuSEH9dulfk8lsd/2nI1WUdEueMgts2gYxrWD2OmhP+p9QVoWiSWv?=
 =?us-ascii?Q?ZHZKCjwZEs3jN/XV7761RkbaHYg8wQTX8hbgPXnFOkc1VHQPmyyvm7XtR49c?=
 =?us-ascii?Q?9RUPf/+nd3YoIGT7CQQoXZM1oFCZSouaqY5p3by4xERUxALFXpvGLKKFcLLc?=
 =?us-ascii?Q?PIFym6IPHv7N8cO1M5FLy2OAC72sK01aBSORml2Ss2MkqH7ii8/paevJjIdi?=
 =?us-ascii?Q?AVpXN5WkLFMwXjNpHq3NKp48859wrwhZry0dVFdUA2hc/jUOAu6r8LqWZgt1?=
 =?us-ascii?Q?z98Lf+MzUOkgS1rxY4WwK6mFJEYn+73OuTkpnn5QjwXgLaF1BaPd9oQqkR0Z?=
 =?us-ascii?Q?ctuqD8UciwAekBJJXsElelFK9sFDq094xYMMjOhvywdLMhkqFLtKdgjkKHNd?=
 =?us-ascii?Q?S/bLGGlXsBH0fQ5oj2pGKWRivWRMjsm96Y0YKo9p9aXz/BHzEwF/pJ9aLTPl?=
 =?us-ascii?Q?TUA1cHU821Ie+E/y1YPSYBp+76xa7FQ3sH8HvcbV9PFhdDCa36TVIy8bmZu+?=
 =?us-ascii?Q?bOzsewdhWWbunwVOduA+qq0jIqpRlhgQl13fsevWFbtwIZOIU8bL6OcxdwwU?=
 =?us-ascii?Q?FA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6479A617D2A961489D2D086E85601EE8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f26a3036-d29a-407e-d1e2-08da98333db6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 22:31:47.2023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wk+lbeq6eHg6Tm2uUB/JiTLDKMIQeZrfwX8korF1+SlEsO/17ERAToUYPAo3zcTEXnY7HLcKbbBxp9SXyucR5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9340
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 09:55:55AM -0700, Colin Foster wrote:
> I'm looking into these changes now. I was using "ocelot_ext_" not
> necessarily as an indication as "this only matters when it is controlled
> externally" but rather "this is a function within ocelot_ext.c"
>=20
> So there's a weird line between what constitutes "external control" vs
> "generic"
>=20
> There are only two things that really matter for external control:
> 1. The regmaps are set up in a specific way by ocelot-mfd
> 2. The existence of a DSA CPU port
>=20
> Going by 1 only - there's basically nothing in
> drivers/net/dsa/ocelot/ocelot_ext.c that is inherently "external only".
> And that's kindof the point. The only thing that can be done externally
> that isn't done internally would be a whole chip reset.
>=20
> Going by 2 only - the simple fact that it is in drivers/net/dsa/ means
> that there is a CPU port, and therefore everything in the file requires
> that it is externally controlled.
>=20
>=20
>=20
> Unless you're going another way, and you're not actually talking about
> "function names" but instead "should this actually live in ocelot_lib"
>=20
> While I don't think that's what you were directly suggesting - I like
> this! ocelot_ext_reset() shouldn't exist - I should move, update, and
> utilize ocelot_reset() from drivers/net/ethernet/mscc/ocelot_vsc7514.c.
>=20
> The ocelot_ext function list will dwindle down to:
> *_probe
> *_remove
> *_shutdown
> *_regmap_init
> *_phylink_validate

Yes, please use as much as possible from the ocelot switch library,
after all you are driving pretty much the same hardware. I'm glad for
your revelation and sorry that I didn't think of expressing it this way
sooner. I think the reset procedure used to be slightly different in the
times when the ocelot_ext DSA driver also took care of setting up what
is now the responsibility of the ocelot-mfd driver. Between then and
now, some time has passed (years if I'm not mistaken) and I forgot what
was and what wasn't said, I even forgot most of my own thoughts.=
