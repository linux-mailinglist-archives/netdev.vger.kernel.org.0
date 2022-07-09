Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E5B56CB2D
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 20:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGIS7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 14:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIS7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 14:59:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CE5639A;
        Sat,  9 Jul 2022 11:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1UY7lXqm6JDVKfKjKp/fDC1V+CzCm60XWwxUkDc0o8djQ3y4deiQl//8RtbRCqor3A0xmRk5iZMGzKgPLgSgegSywl+dYaWxiv5dnaXpleitNUsLmcA1Zky31BbC2UI2NaSLUSLOyyUScT713Xpv5DMx+ZwjZw+ajORMa/HmWYcjZn3ZcWbpZ0RBYlsDlRK8X8q8tiB+pwHZg/jOIjeM4beaVO3hYS4Vhd58QmjqnRgHwCOfZxHrWuLyjkfcYzAmDNG8aD1CDdWCeqKwYaczNUy5cH3lvjB+ie7yjDmYbIIzmpOKVRhLAUfxNnoKJ75iVPhR4cH1qwNjNLVBNr40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hp/jgv4/HTA3qt/sVoVb3YCSSFM6/5W/v071Xh1u6tM=;
 b=bv186pUMAuRAn/OFh/g9z6r803qkGaxS4VxeAKFNjEFqx0hpvyoj+R9jPBGxz+m+0PzbGEUEMRiOWY1DC9Kd15Q1Wlo+FBzCgx8gcpzu2VEzGXxxqht0nLsYE7B4OIhKLxlNHLqXwTtB6aJaQlLeAM1hMxEnwVodAHtez89RLr7f3JMDnpvH4kzp50iMhd0I+/0sAgZ/93yOtfdiTYsaEEOqJ/fKVO/FW1ekplFzo1zJESIe8wsoOT3uXeV8Kz8Bi4zwg5Ymo/bx5/ltLPDuKoAXrK9HN2gu5JM4laYkNpPDMWW+3R7ZHL3+/92x5P/71XszEI+eSUfr5sI6/kq7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp/jgv4/HTA3qt/sVoVb3YCSSFM6/5W/v071Xh1u6tM=;
 b=XPWDtPUgA45puPyEZ+a89Kmkb0qIn5GUk/tgV4YFo2FhCsjDPFxKvOSb+ZyaQ+NXTPnZJF5HW34wPXVzHpw8HzCfEV5iWyRMOsLpHpZvIj6dbAtW6Zvh/N3tYS1ITUv/g+zIOFdn01j/F0RB8afK8azRGvHvA/wXviEbFP2NGJs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9462.eurprd04.prod.outlook.com (2603:10a6:102:2aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Sat, 9 Jul
 2022 18:59:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.020; Sat, 9 Jul 2022
 18:59:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 4/9] pinctrl: ocelot: add ability to be used
 in a non-mmio configuration
Thread-Topic: [PATCH v13 net-next 4/9] pinctrl: ocelot: add ability to be used
 in a non-mmio configuration
Thread-Index: AQHYkLCOA/idErNiz0iNd5dWqpXCu612apUA
Date:   Sat, 9 Jul 2022 18:59:15 +0000
Message-ID: <20220709185914.6aqlhg4j6thq2sl7@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-5-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-5-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb5e72be-a27b-479a-eebd-08da61dd1e94
x-ms-traffictypediagnostic: PA4PR04MB9462:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fzIptBm/kTONowFLCMg+1O6q8jv9LgRRSnKscY2KY7/hvJLpHyGXzAPB6ho2YrZB1iwpNkcCqQ4brwlgQMK6Twn3b/60/vvYaKEIK4y3QVGoE0R9VJp4ZyLM9YOvKblRcLDDMwHEhgdr7O161b7jLYGge0y7hYtM5AgvgYw5FJGxX+buMo8PoqbKIB14Zk7IikxlVhp8UoVb/hMiax6jnzr/ggtlL8/HBrtUbRTb1YSmMwdvdKh4VR1HRnsHXdP7wQgWYWAPBU/iLi3MqQXf65NuJ9ghb6Wl4zebe9107URNGYug/T4LJZaScrYWvE6bhwpXLIVO9ek+I2Sf4gd06FVHrUNMYRmCJdA/HaHHrT6cEwOsg7TIsmrf45KhGWig+V6OanQwnTQq3itduS+nRXFymmzbttiKahqx7Dj+cxFY3xk6fEGSA4s5AjTkbAyHl54uf75BfRGA0ZV7ePMzHkW2SlTBi2+IgWKBet62aGmhWW8jzmaZiLTPO7pPPef29u4oscCD6Umj8R93QZeQfh1gxDX0NNsb8KAQgVoSkZ8WUsHN0LVM059Y4oLeOZ7ePsLJ9A7m9KgsmLLMRPMGV4GORZzbPW0xAJyIOwCQjOurEaV42q2I7afU8X2mFuyg5lPByonvtBhSlwo2XPZtY/YsNt00y0AYWPbH+H/UNgtgl+mi/Vorp7fRuJIz2zNNLlW2o6t3urAyDF24GtJSSje7EJiu1Gg8minsrQBTg2pkG0tF01dinNRlVcSJBDjKZHDH32w53oqKThgM5qwOSKoujbQTHxKvSFnno3q2qhuKzPznJuDbv4fa3+8RNZoU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(41300700001)(71200400001)(186003)(33716001)(2906002)(91956017)(1076003)(6916009)(54906003)(316002)(26005)(86362001)(122000001)(38100700002)(38070700005)(6512007)(9686003)(478600001)(7416002)(66476007)(66446008)(5660300002)(8676002)(4326008)(8936002)(64756008)(66556008)(66946007)(44832011)(4744005)(6486002)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3zJsC3el66dZoN4ITqgY20eHYZEM1fJEzRrgmEZ5tpab6y9xlavwswxfvt9l?=
 =?us-ascii?Q?nTDF6NViNEJWGr9Pb9ZUj1bMjTfoJp0aEgo9q0mMXUlyfd7/khseR4HrmHGc?=
 =?us-ascii?Q?3cP2M8Fy2Gy8Syzat+lPlruMVdQZvUQdTPjql5UPY+CEv5LDjLbMxqXFKe/F?=
 =?us-ascii?Q?B7rh2tT40K8M0KMphekis6rOc7tWl3InPER4p1Onw/bjafNb0gCZpJYAM2Hf?=
 =?us-ascii?Q?FFd4F1ktBfCIlixQtAbeQuaDz2YjHgOl2MxSnnAClbc6dYMwI3B0SrmCmNT2?=
 =?us-ascii?Q?rTV8jYmRI7gAqpwkVg5onSLZotRDCMi9zkgFNQi1WAi2CtlzitTmOZXwtdmH?=
 =?us-ascii?Q?O/7yHERoVcoZi+FrZkxvC/Zgd5N1wWRYL2X5vwBZ6S3H/cuxn4v86SVmFFKQ?=
 =?us-ascii?Q?fuXL9OcJfW7Zfuam/z+GMNCwxnQqFHuqcwo9hT5CotjY9TBUE2wQAYKYqrjh?=
 =?us-ascii?Q?+ISm0KPGRYAnAJ2UfZVGMb4g7dtfRCt8m34879A1+tcb0Xk4YWyNVybuG4bW?=
 =?us-ascii?Q?LqSKIYivHMKdfT+ER6STOtMmaS8Gva/3XGUEi9P3bccl6MRdVyRZbCoOjWpv?=
 =?us-ascii?Q?IKh0SCPn3Yt+PPFncRfIYe43DI/iKrJkJwT+HvCvRndlBw0mMHkmhl+/6tG7?=
 =?us-ascii?Q?B2JWvvvTQZ1Wt4bjsEY9JkBONv5W9E22iC1xIgUGW0a2w46SknGqQRHqjK/s?=
 =?us-ascii?Q?cVuNfU2tx1KVMAc0v8zLR4dAKNONB6nMehOQgXq2GaVFhkXzadxqnHGy2TaT?=
 =?us-ascii?Q?/apuu5UD74RodYWMwCDg+UNkZb4GjGmhqALjPVKoU9vqxzEPf05C89jn4bpv?=
 =?us-ascii?Q?L5Bn+B+AdGmjXkIe7e0LXEVxeZn/xaSnoSyXUlqThroiOb7jBKkpQMRaViJU?=
 =?us-ascii?Q?gje2ZUdU4jIuUlMWsSLqVV3em8gzkBK9P2Cm8dZjBRj6rCh/yGbVVcEcibiS?=
 =?us-ascii?Q?SWH/riL7/P5COLSFpPA56VbXfkvhRB8OC98SVHJCV5Bnzoz0j8k3eqzX8AfY?=
 =?us-ascii?Q?ItllwN3YP0jJdrjLGz99cWOPOq5b/NYuDPix73FiqmGd9beDTeb99PgET3kR?=
 =?us-ascii?Q?ZoR7G48pEJ22DsRZbK0rSvvMmuP7egrvFFRogiTBMJfYA71rAzvtulYWcaYh?=
 =?us-ascii?Q?CnmVnaCv4ix0MQZDHA02O0GkG4Rn80Ql9bKfYNnaQvOEDQMi0WZ8TM52rtE8?=
 =?us-ascii?Q?QJG64ZC66VA7i3xqYFPqBo9rmK+mKdLQl914KXFjzeTETwZ8HpmBMgn3YSZH?=
 =?us-ascii?Q?z6HMQhww+QQSk99Uvd8QNFAguCEV88tXfv+b+1BAsqd77teJ0CNUD0Vf9knM?=
 =?us-ascii?Q?y0eaPuOYnU2HwQPB19iKu/pCN5Im0Nzw4BstBW0tJ9o/up8PImbMaF2btmKc?=
 =?us-ascii?Q?R3Z2qg0s5Sd7Q4aNwZDdX8c7KH0EfZBAHzN/uhdQpoaMsjEWG1LByKX2MCy0?=
 =?us-ascii?Q?vC20bmOWjaYPu+J6FUjS6IqnBsqR3gZAVWdqhSNfJZoJVnPzmLYrvajA4Plr?=
 =?us-ascii?Q?mqrhHpPD45SLdmtCKgCavH4HZRaG3uUDM3SG5OMFKEGcNslL8o7TKFIYGzAt?=
 =?us-ascii?Q?g9XXRz9geJX48BDAKHFNCOjdUZ7844HKStbnSmkb8il1BMtuG65y6nMegICG?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <37540200E523EB4AB94C45C34B4C2BC2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5e72be-a27b-479a-eebd-08da61dd1e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 18:59:15.4777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/IKcYthqKqmWkEGxPHqI8XFPdIsUJLIgNR4NYMHQlk/tXvNAFsUAQ4zAJ6qI9g4VlbGXfXgoTFnnHwXMY5nHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:47:38PM -0700, Colin Foster wrote:
> There are a few Ocelot chips that contain pinctrl logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>=20
> Add support for these non-memory-mapped configurations.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
