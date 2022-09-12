Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3965B5971
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiILLlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiILLlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:41:24 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00074.outbound.protection.outlook.com [40.107.0.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCAD3BC7F;
        Mon, 12 Sep 2022 04:41:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqgHnzQWcWr+6wLD2E+9nxbjJuvbBUw3Ri1FcSVN/m6UTRdni6fHyOGDcJzmbfqEJ3WeW61gcDuZqFyCh3XrlgoRTMIEsAyXahgW61PNfBogKcjvEPvdg26CXUH+O4xf8MP2wEk0FGlmKq/Z/LsoyGY/eqA6jNUj8jhkFST8KE6i7xNUUp+uxj8KFczkEh7bVSCI42rMJMukJiCeEYJO/cO22j2oZ2F/eusI5HJC2hEKgzPgI8a9rcDNsdbWbgbYe6Y3w266t5UNGfiOyegj4e2TwHDE+C9C0Ez2/VzAPX9xhj02HcxzIVW37Obi90UmX+Z+jUHh6PdZaF/5XshWIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFLSf0FLFFgA0AQLcCf9iSZh/bFjf3OvCbbjmzJeKXA=;
 b=KCskD5PV+ODGQDpjSEbY3oJNz49cHLaBUImYXIGuKl/6MA9APZGdQj9eMyd2adfP3FjRjl4EAeEyFa7pdULRQutQjObkABbezV9Rb/NBtWX+wOdDEucvzhbNU1m0GWy4c2fV4vfsLec5nTnA/hckrwsytKQGlrX68xCGbFEAhPafFQimbtsdZcv75HDoT+fo5yy/yvXu3nVMiueG+YTarMf/Bl9NShcpHb+rhuZynmzlheRmqxSpgKolFTqxR3JWP+MRSBJ7JymkDoK/m7GHgsyHHoixvJ5fHE+zMN+pdSYc93St4jar+0X1pRPcspnsmM93rCQ8oIksXIEC6ykqjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFLSf0FLFFgA0AQLcCf9iSZh/bFjf3OvCbbjmzJeKXA=;
 b=W3w+cetG7SNtga14eXev57LpxQIjuO9MvbNhHJcRUgsb4ejzGTBXqAShY3HZXFQPOj9Wnv2odl54Nfj1SU26ESsIedD1dJLAg8Pd5r9172Y4EEGBQe1henrYh6omWZBwbWSZ5mbg5DDzuEbA5Cafy6QnY27Vbps/t4lTjCVJ2yM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6835.eurprd04.prod.outlook.com (2603:10a6:208:180::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 11:41:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 11:41:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Thread-Topic: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Thread-Index: AQHYxhmBz++3+4sxbkG2gbfVifdN+a3bfLEAgAAYhICAABe7gA==
Date:   Mon, 12 Sep 2022 11:41:18 +0000
Message-ID: <20220912114117.l2ufqv5forkpehif@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
 <20220912101621.ttnsxmjmaor2cd7d@skbuf>
In-Reply-To: <20220912101621.ttnsxmjmaor2cd7d@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM0PR04MB6835:EE_
x-ms-office365-filtering-correlation-id: 185ac9d7-51ca-489f-3f97-08da94b3b515
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UGQ3x+9Sfy3lsq27AJ8nH3Lw771PW3YghqcM83IaDKERGKHJARZLo0CJuEhhbhDipGx9uo/+HeAkbAcGRgA9pi2lVXBSlI9+tHB2TJ1oope+vmicxcXN8bqtPMGe3Elqrg3CXQGXMp/k5L029KsgC1HprzMDFGDzFuvSkP1V62u2F4VJzDXuPQ7AQ1iMC/NG4P2XKc8Lxc4NpMTSayUjWx2ihDMVadJRaS9wRIuNCHzB80a6wLKOb8M4/I5EA+Hdjd7oQP3B6105TFPHDbDm/xcfiBmfLctlcaKY4gqz4Crr1pU8CRmpZMXVVJJlnQ1u0NBK6qj2pF5VU9acIcQmD6ufaNsmwLASqDvUAXyG6GS5m6cr/UkRDz1zMlM3/lomQryE556Wv66PVWr9qLVntDM9Uf3DR01zNXBHXJuesSabGMznv2Twl5fUb2Mc2UnbWfADBTtVmjoX4BgjViWiM7gymKfwVechUjlguUVinOzepqO4PObMFQzjrinMjqDw/5VSnp13GKtSFuUiSMDbKXHQu9B1tXALKl7ue8eSKWSadHWjxuWXM7lGIIy9XeMGg1tD4dwF5NLGWENcwFlVhfc6G5OrLmtrSdzHS4grsQx41742HWjbZQfJeGJH4MEmcCwMIjO0TE0OyCBP4e82fk3+lyuApOoklPvXG5J1k9gZmsXyBprAjhPQSJwe298ASL2rT0jGrkbtDr3esJesTsJkze1tC77cY6v6uHJeMTybq9lHyC549USJ/z1e2MbYffInNS7NBJJ64M6NCD2zVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(346002)(396003)(376002)(366004)(6512007)(38070700005)(26005)(54906003)(41300700001)(86362001)(6916009)(9686003)(6506007)(6486002)(122000001)(478600001)(186003)(1076003)(83380400001)(91956017)(71200400001)(8936002)(44832011)(4744005)(7416002)(5660300002)(38100700002)(33716001)(66556008)(2906002)(64756008)(66446008)(8676002)(66476007)(66946007)(4326008)(76116006)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XFyw82Vfrir9IzLrS5rqC0oS5mN6X91tnBHYJBwTuCr7psja+mkraMUB8cEs?=
 =?us-ascii?Q?dUkNoMEyG5i3XdsWB2MyeDB4Qt8hjtZpgNAFAxJwWP4OAN11I15eWDUkMLd+?=
 =?us-ascii?Q?BV5w0BLMqq5qw/vA7XrAtyX9gau03szoXYEXMswDWt8RMdPmU3/OL+Q7U7eb?=
 =?us-ascii?Q?2o/JZfp+pI5FmfmqO+BRQx0joWusH29eK+9UfhQfW1EF11YnQsgElNE84mAX?=
 =?us-ascii?Q?BRpnYQQFidGMDM9sF77Mgs7nO3Z8ugzyHqvZ89kK7+8abeY21STg5Zz75Yv4?=
 =?us-ascii?Q?N6kwAUEXQQIlwLd+yY6GkYjAbeWXGUHNikTiJFEoWD90yPMwuHSrliMH/qHz?=
 =?us-ascii?Q?tCXhRGNiTdX8qXWsk1B5PMOxj4kKLlehPWmagme7R0amp1WdRWMFCIIkigx+?=
 =?us-ascii?Q?z1VSdd+kK+XAO90gnVAh3jmpTybY/lhJ2EyFfHWnL3egEGgL0KPP6fxDanLA?=
 =?us-ascii?Q?O+oe28UB5PYbMFQGXEQYe+Y7NRj5QA8F8pvP2Ma5XttaU8z+Yv+PDSoU7yLb?=
 =?us-ascii?Q?h7KI6sDOxdnrA/s6Ti5NE+2gKi+bZhbUEiA0hSFGkwN5kZO9J/Cz0bOi+8Jg?=
 =?us-ascii?Q?9ofysyMuoiHrbcmRcmOthvgZOczE49ftGe5baEozCOze+jls8ak+piSWbFpH?=
 =?us-ascii?Q?+KcE3i2NnUo0h5hyiwZcyh7zSmzqqwABrJkO29R4umcAsi7rJahHZADJnHMh?=
 =?us-ascii?Q?qCrjtTEaVOM2NnkJN8cLWmyDeaUf0SWUlpdpXwTmaky1s9KGenvBvMmZci0C?=
 =?us-ascii?Q?cjBOBIiEk4W0GRNKT5aGagvlK+I45zX2GSqlZt9KbmzJ8GRp+i2VQDXl7NQm?=
 =?us-ascii?Q?QU5NQ+T7wwhbQfsSWoBtNMbi33GxPBFOnDDw71keUAXA5338Pg8sNI85okP8?=
 =?us-ascii?Q?6yYOgq+95YVQBdh4L8ZljBCGiCuBmTmEM/IYx7XckcaxWLyDdGaHxEfS87wu?=
 =?us-ascii?Q?5dX3EEaQ9INL+bAFK6rvqHKfL8BnJrbFbNkQ+w8j9v7olf7tg4vxqqbZIvdZ?=
 =?us-ascii?Q?pfYl7aNHyok+2BxYMf5W/mfJAqfhW6p8lUzE4zhw1t8JHBTx8t4zDn59VDb+?=
 =?us-ascii?Q?OrLmbLkiZKI2f6oWfaCq9yJcJfjQ3oRooeEP0sGqNGPXD3KdZkegCWS2nqso?=
 =?us-ascii?Q?c4wtIMxPrT7NIp/7jFrT3/dTNVTM1sxtZJ/L8AA716aBJ1IUMiSWizuIPsQ6?=
 =?us-ascii?Q?rUlxRFMyvkqSdO3zV/7hPPsjlLFKdETGUw8DZaty3aTWE4YV0k4ByeubPQjR?=
 =?us-ascii?Q?qgVZFyqmqzuVFJqP1amc0huH36Irqk82nYNicI9bEod9OR03bmmcqKJ9kjcO?=
 =?us-ascii?Q?rdo18L2F+OO6krn7Xgetom3slORTl5xifm/BNL/PTnMT5QInsVr3ZfxdNLgI?=
 =?us-ascii?Q?FRxlNTfHB6DKzD/9yzgCFOfIs+hMfMSkTmwHAvXhtvWaKq2UBQPMDnwKSsma?=
 =?us-ascii?Q?7PjJ0QcYVld54pyoWISjbrs8Hsriiw5dU05bAiplbM1vTJH6OfZz7XH7G+Ei?=
 =?us-ascii?Q?yHdhgrkDJ+xgin4JY7jsDrxEfo88GcZO5cb95f6UnUA8flcZTlavMzyqNbNX?=
 =?us-ascii?Q?8DpzJ08ffrX5nNVKZmAio5gjP69T4rPf2SzdO7+BAAwsFc2ouwYyeuP6m8wz?=
 =?us-ascii?Q?3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1EACA26619F8334BA830D3B3F53A99A5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185ac9d7-51ca-489f-3f97-08da94b3b515
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 11:41:18.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4FwKOr+xlMHpp9ldODlGL9zm7ITEkGjg9fjaomFIS2LR8Dy+P51dTRl+pa74GwAy5c6qSArnaxbg//cm+xw7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6835
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 01:16:21PM +0300, Vladimir Oltean wrote:
> > Therefore, I think you can drop this patch from your series and
> > you won't see any functional change.
>=20
> This is true. I am also a bit surprised at Colin's choices to
> (b) split the work he submitted such that he populates mac_capabilities
>     but does not make any use of it (not call phylink_generic_validate
>     from anywhere). We try as much as possible to not leave dead code
>     behind in the mainline tree, even if future work is intended to
>     bring it to life. I do understand that this is an RFC so the patches
>     weren't intended to be applied as is, but it is still confusing to
>     review a change which, as you've correctly pointed out, has no
>     effect to the git tree as it stands.

Ah, I retract this comment; after actually looking at all the patches, I
do see that in patch 8/8, Colin does call phylink_generic_validate().=
