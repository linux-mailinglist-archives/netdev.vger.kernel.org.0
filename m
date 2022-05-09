Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FCD51F96B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiEIKNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbiEIKM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:12:58 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE56023516D;
        Mon,  9 May 2022 03:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJ0bDUhL0bjOQZ1ZsaWaltKbEv6bG6utDTPFCWHYD9UmSxINya4q4FwTHnp3II6qL2UhVVQzH1TxvJs7tlZvM91LxHjFVnwk4JJBWpVC78iTg7IyNcKZES00Q1PmgYAf2n1PZuaUfagIlbgqsFK+zPGLBf+NzL6xzUq2uY6sWIfy8uY6TicjMyJW5t1z6ISby/v0K/116K+HRyzJwCx+dHXPpQJLxUUPRqihdgV64jEZXvZIM2aPSOebp5+O56i+nKADnXxzjCxumIPOGe+XAzC8U0Bp3BfhJ2p2DIzpJGmu96yG0ENloL5vv89x/t/7R6IcMt0e2d46pO0eHlBF0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPYd3dKKkSb6+aZ6jzdk9RZQX/grnR5Wr9H5cY/+oqw=;
 b=AzeOekzkjLAMcSf0gY0Ms5dzSXobr8ZcgDd2jNZ7MI+EjuEZTra7lXCZyPFPCDJLXv7lyyFxX+TUB8eUwR2JUx4wOYSOF2XpOYwhDZu8dOgUSGVTksjTGO5HX34Z09MY92UKBd/6Iyn5CiiZISSt3RRI/xjWChKGlXcINOrwwrKkP3ARrgKAzhmoAgHLyFh4lHPzj0JXJ/z2J/ZoGE62Vdxh1W/cszxW7IHW0sY55PGaUHaW6S7PB7TY5CP7vGLQ7fkkJeth4TugpVkZZ0Ei3/ZUXSCffzbhZbW46lqULDQakumoObeNqoKcmt23v/rUz8gAr2wLp6dB5sk04NlZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPYd3dKKkSb6+aZ6jzdk9RZQX/grnR5Wr9H5cY/+oqw=;
 b=YhEn6vR5a8h81FPumM5hzlkCJei2JgKVCJImesrmXEDplDohgMqDVxTR2F2w5bsJk/VgTynDuCcDXV5IvRr9zljXFMmA7u+d2QurmBslp1aCwAh8m2QGXwwCrtGRmLcxKzOnCamOYvIeVbZmVCHZWfncYCjnwsF2imd1g6Cu3io=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8066.eurprd04.prod.outlook.com (2603:10a6:20b:3eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 10:05:48 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 10:05:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 02/16] pinctrl: microchip-sgpio: allow sgpio
 driver to be used as a module
Thread-Topic: [RFC v8 net-next 02/16] pinctrl: microchip-sgpio: allow sgpio
 driver to be used as a module
Thread-Index: AQHYYwzrNs4aifVBdkSP+G8ZOCg1C60WUpkA
Date:   Mon, 9 May 2022 10:05:48 +0000
Message-ID: <20220509100546.aq26ztokjgg46xvq@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-3-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 169583e1-11c1-4af8-ec74-08da31a37d9d
x-ms-traffictypediagnostic: AM9PR04MB8066:EE_
x-microsoft-antispam-prvs: <AM9PR04MB8066E4AC740ABD3BE7416898E0C69@AM9PR04MB8066.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khjy1HIQc1OJtx0UOVRwg4t5kLsG5deoqPA6bWscIhvQEvsf5YMTYJ0pMzVp8SW4h1FdY99lKqukzndIZK48mmfltdig55b3il6Ju0adNjhwHfK0PtW2HQgB3rlUn/XJLjXqLU8mbiKNnHWYyfW972mq5a0RLfGqgA8Or67ZItGxadtlHnkJXHqNbs4ZM8HA0hIve+OHK2YBKZKDMd3C3C0NPwjkNBUVFKAeKjy9yXbmgezRwkSOZKfJnK85ES3Kc6YVJ99D4SD2m/YUxj/pwCyQW734NLOoq6FXDvsSXiaG4APpGQ1OyZ07dMv5UnAPzIplX/WPmzfXN1SwhA3qqyu8wIt3YaAsCDzuBkRg2d7iX7Xf3Cdbqpw/TGnJPIGZPowyixnjnfRXpyMiOD7/W5D22p9zbT9dgaE8FwKGxa5YtgnWY2Nhe3KMvwyM61Pj5i2vwgRCCYi+hF7vrY6TLk2KV5RXITDuqCyC7FVfeBgULucqVkvqH9XkQq9AxS8fwouoFGmK3R/r7h1nr4svsfvyAuhEx3fjV01JMjpm8dvdvjodLz8g4dfVmnlC2TMdAyQknwLJm4DU3DrYMNFvz2kjVMzG0zVxJLr7qZ7kcDwDRm2YQaaeOO2coX5nYGewEMOWLGqjg31yMBlppJSNtvOTi2KC2JCBqpAXegSTj3LZ3TsJGwvOVI/CKjq79yt99b4kzXzO5DrlLqaSmCARnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(4326008)(8676002)(66446008)(8936002)(6916009)(54906003)(66946007)(66476007)(64756008)(66556008)(76116006)(1076003)(91956017)(316002)(86362001)(122000001)(6512007)(9686003)(6506007)(26005)(71200400001)(508600001)(38070700005)(2906002)(6486002)(33716001)(83380400001)(5660300002)(44832011)(186003)(7416002)(4744005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iaFHSAUm7GzlETnYbh9EqHIzKMz0Ht/9RJNgybOGaKE+/64Fb/oOZ315Ym03?=
 =?us-ascii?Q?2s89czwbBUJwAvQBGyZYyDTiwzNe06W7rcsnMBJl8FXAF3h88TroLvRVcd/C?=
 =?us-ascii?Q?X25jgF0+r2zLgU3pd+ALcnw9X4estsSM3h1mbJtTYaRYS87vBkCpSfKPzbHD?=
 =?us-ascii?Q?N0/w4FP+WvlX/u4r26OCRQ/baRMxeqVUIQ4iXMfsScPGn0pbKywj4hkMjrVJ?=
 =?us-ascii?Q?Q/cTCrohIjJeEQXqp0ZpIBgDVm6pvYWAFL53Epf2lHAN451qra3EJQjMeB++?=
 =?us-ascii?Q?CaUxuOveLwkyCLBIAH3pVj+NrXtGrbx9Oje3KjIs1gfkV6k1D62M40ElpBxD?=
 =?us-ascii?Q?6hiOYZW3GGfR+A6/XEgquLQNx8w3QN5PiXOC06EbkpOIv0F9ZZV/NScN5sCh?=
 =?us-ascii?Q?VfvuNumJxN/1ev7duEtJpu4Cl++pbqJmxCpPcnaY6mfr/SzCcEyjq384h1ka?=
 =?us-ascii?Q?0kmAttLtVRJWyVBaHv8CWp6w21B/QZeV281r5/A8Js+Fnqc5gxP8Dk70F76g?=
 =?us-ascii?Q?fhUTAdF08cN4quqgP9CAwc8WNCAZY2T8fAVx0gPgBJH2LGpXKlM7yocfjCh+?=
 =?us-ascii?Q?Oz/8SdJypT68VkOGx+ghfbo/PY91yBCg6c090GVqbHk+JSYGwiVGoimL2oH3?=
 =?us-ascii?Q?OXR/ioSPuMoXbdWtfji+I7HaonIiMjp0RHMtu+0wxBx+0q6oAiiAL89bsHNn?=
 =?us-ascii?Q?CJTVasxdSmNZ9dfsGNG/1TOKsvsAEz943Xu6usqjOIg2kwVtGBn7BNdaBdNh?=
 =?us-ascii?Q?efPO1IUBP59pex0ktUno2UUG5F9fRaXZMaubMXtd68VV5AwDReaAROFom7MG?=
 =?us-ascii?Q?jYRPeE05TgloNq/mGdm9kg44YyR0gZFV7iSpNPOg/O8lke24X77gHj+wtbsy?=
 =?us-ascii?Q?GEKYczgMxAYcG+GGP1R6WmPOk1G/vZcawXxadC5QeAuINYd1W6bWwfakwcVS?=
 =?us-ascii?Q?kCd1ZWqHDqjcBNK9Ty7VCXJTxLX2n9yMOyp7auxcTylOzlBBG5BvgVKro2iy?=
 =?us-ascii?Q?hCa2QM8WtGg5pjuDFxLx6bW17RClUdlDRDkvidV1JiWpf0nh5eGwSu7ZqxEY?=
 =?us-ascii?Q?DzXCE0bUuXucqDVxdTzxE1f/IGt2+DMDNfwIhVpLzLeZPnhkOaHuca8xd1iG?=
 =?us-ascii?Q?dcpVdmFv9lLsXgNe+deVK0+czCEhYfg5BThFAFtN058Y6t8tgzbline1lNe8?=
 =?us-ascii?Q?cAXYliOWVLmKKMTYzoCur+59Xm8d9cyj6JslaQL7dFPEwomFIEpRT/8j0v5s?=
 =?us-ascii?Q?PRFzjEuttRLuQDysrCSMlxclNkQ/dZ09IykzcWhfXXrq23iBT2Wag/iBUwTS?=
 =?us-ascii?Q?GaaHb/al6Th/cVdonkBiWoj7wh4F1Y/osrK68MZcsFj7yEht+s5g7YIeo12b?=
 =?us-ascii?Q?lE7KSR7E7GPVoiJwQgo2tjGZ8GQTKrzWbh3tIShUS+P8W6fiZkggq70LL9y+?=
 =?us-ascii?Q?HwxDn8ECuNoLNeUr+fZVQK+BAhOlPhHwu3vobXTErdOty0GoDKh++RJpATsI?=
 =?us-ascii?Q?YKSBIArJEPs2EAWIqBVakdl12Mn3zmjRk3LeAPrksH5ZKWbSYpvyJc2QgOaE?=
 =?us-ascii?Q?yRZUFIVu/ggwXikOMvZOQuGksEJCzGypIup7rGoYEJy1D/Fqo8DNVbjHuwkl?=
 =?us-ascii?Q?O55++9G1tr6EePPyuulg0/BLD4Qf9drp6a9jomv6BT++GCidhXbAVyttB2bm?=
 =?us-ascii?Q?3Teifv7pm95c/42tT8cpPpchHjdCtW12Olb97AvjHG6jjhndsT8VAMuS3xdS?=
 =?us-ascii?Q?ZG0fYk7edeoRSWVi2lwEzs2eWrcpt8c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E1CF5F87E594B40B8FDCE0DDDC28540@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169583e1-11c1-4af8-ec74-08da31a37d9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 10:05:48.2965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uYvYYiaMqXZdZi5GagNnSRMQfXN51vfSL9Jft29aLz67ki3x6EjPLPP6oIaAMNKE/dq0hMVORvIP0A/hQWU35Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8066
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 11:52:59AM -0700, Colin Foster wrote:
> As the commit message suggests, this simply adds the ability to select
> SGPIO pinctrl as a module. This becomes more practical when the SGPIO
> hardware exists on an external chip, controlled indirectly by I2C or SPI.
> This commit enables that level of control.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
