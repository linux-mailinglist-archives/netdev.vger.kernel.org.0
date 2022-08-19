Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64D659A33F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354590AbiHSRdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354596AbiHSRcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:32:51 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED549107AEF;
        Fri, 19 Aug 2022 09:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emTjlhPW5eGCoHOnJ7y0QnBZVwsfOwEMEB9T1BkOozIm+0pZMFNmiR9x3GaYgamqgtfvc52mNoZkWc0xoH5H2/13IdvHL+E/26zUIeWRexS1tp8W+6t/FMNlMKQh9b0JSYd3mLe3RekdacGyO4eVoQifa3zsKqybqwPTyw/40VU132dnqa9EEqWKcd6iXXf48uvEqCDjY8SwASLYLj55/8ePiy8bzrTDkeaVmOjZcqvnTJyLqQXZh5/rvoD1ml8l9OwAFiGttRFdItfPm96kwgT/kHCQz9b0tBBbG/CcZzMpumKvdUFWar8SkAZQYBciUmBD28T8mkbsKqM5vsLsEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEwXiUMQDEJNcJCh7pf7BsdNBVbLSdO3pvpsamSg7CU=;
 b=MKZ0rRJQbkj9TXxAAiMn6zJHLh2QPnVifHnuVpE2g9zbzPlFIHYumYodjsBQA6vKicmZxYvzN8DvEV6uAA+BwrtrvURNU0URaKA07muSJkCghRTgadSwIG1Wh+ojKu2hDKXiwt8r3ZSh8nwXSm7pfWabvOiLZ6w2t9mR7Ybpzwtlbzbr6f5VKaW06GmqbTnjwRc0d3vtPBt83y0tWx1zmIaW6WnnvLLL0VnBjMJzrta36JN0LvkQWcSpsMCjPtvkU4jwLYg4UrZldPnLXxEWa3HIujO3prLfHoaUZZ8faeLFOBNLH1K643w3LI5uiazFJ8CTUuggEtpv85nzC5E9hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eEwXiUMQDEJNcJCh7pf7BsdNBVbLSdO3pvpsamSg7CU=;
 b=F6nqU11mM5LpX1cHu7NLYw11k7cFC5uUvquY2zmf0QCRz1Oxc0aR7n+2smDXIDQLgvxrZLae4EF76sbIdJB3AU/9PTkbihgllGAWmf/WsvpWeI4PS2eFVpVLzWklzPYOfuTwB2opuRB4sA97yX9YkzLb8ZsKwHXSV8UrF+1zjbY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9583.eurprd04.prod.outlook.com (2603:10a6:20b:472::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 16:50:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 16:50:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
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
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Topic: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Index: AQHYYwz1YnOGgXOqGkauFg8TINDh2q0WQPoAgKDQgAA=
Date:   Fri, 19 Aug 2022 16:50:31 +0000
Message-ID: <20220819165030.up4w6c3iqon3guqg@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <CAHp75VdnFSP9-D=O3h5L80O19xK7ct6ax6kXGfHEiKe9niktYA@mail.gmail.com>
In-Reply-To: <CAHp75VdnFSP9-D=O3h5L80O19xK7ct6ax6kXGfHEiKe9niktYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 076dcb5c-100f-4b73-1bc0-08da8202ed97
x-ms-traffictypediagnostic: AS1PR04MB9583:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YLfiWSt/FZbXh807RdLk4U4tVVxISfu+GEFqHlmVVnja/2gAakdOgluyKiIquTCWYMZs3MmfPZ6JOb6NEbgm9cbSogGMydkIJJgahBjxxQbzPHtH57hwdupWgS/I+jGHQWFY31kyjQZomiKZL849qz/E5OfOJru+zM7Kmu+HCOU98jzwWrVq61HYEouWwXkDeQvDh+CXtRmyrDAxE7/m69rHSDDuF7PfypxvAmb3Vazl/ZfDlgp6gBlTj4r1X/xw7NKgT2y38nb+wDCIzgsTPG4JjFfx9/kFsaOYK0C400AvJcRTGJVQix9585xEnyZHw2693BPITO4j7QMOuEKmnY8nOdDZdt30aa8Bjq8T2Ha6OJoF2E0XwiojtlZfM5F2n2yhw5JA5KU6SiwcSAEdSUhRNbJUe7qWfvHNdUNnJhsIlriQoIhgtOzgWeUFyWzmxW/rJyePcl5CbiMstOIUBmcRrLe3Qve9iHY88D9wq8DJrVoSuKo/AKOfvNti4KAQZkzp+AoFwwbccnUefsmvCLKJqhyvvBlAQVgKNinUP5rgiKF14FSsyKOs5BeqWHuX9Kc4cd1s7AOnEZ0k2ekGlU2y1rLKC92udeaJlm8dXdXD1PwnZNmSA2vv+WnBIAYqYBpOhXG9IDGWc0JC2n4b0ltM1mDAgo6jJ807KUFAWu2JEq7l3M+4l9/qcpcm7itLNqKk+v//RcxiCQgzklHy9uC1y4o+673WXj4RWwMaiqznIyuMXb9eXN0rv18sDibvrDy7+d6aBfDoXCa9wX2tGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(366004)(136003)(346002)(39860400002)(396003)(1076003)(38070700005)(38100700002)(122000001)(186003)(83380400001)(8936002)(7416002)(5660300002)(91956017)(64756008)(4326008)(76116006)(66446008)(66556008)(8676002)(66476007)(66946007)(33716001)(44832011)(4744005)(41300700001)(2906002)(6506007)(9686003)(26005)(54906003)(6916009)(86362001)(6486002)(6512007)(316002)(71200400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GvQfk2dv07Y2Hn3IwZqg1bhasnq9YeaIns5Nu4BuC1uB9j3SymgSaHYTThZt?=
 =?us-ascii?Q?SbmShPr2gL7BC21BOKx7XLXydYUNpoqxpauq6gsaIPag7ys9KeGT20Bp3wXK?=
 =?us-ascii?Q?TEwPT//pCkR3dnUV+3NaL/cO2Y5SkXLR7vGAQdX/N/IJLR2Im6YQ85romRBo?=
 =?us-ascii?Q?BGqcVJlx6hDPs7J7pj7LY3QB0Pj/KrNB9qYtAgpwgAaEbz74Kc7sEM1f1R9R?=
 =?us-ascii?Q?8wtU5Uyvd9oxi+wyXPQlmbK+jaQxGXMH8UKNE3iQ0ywGftZ2g/Pg1WkdJfWG?=
 =?us-ascii?Q?hSajAD0v5gzbnidFH+BmPqATubq1Jt00TaYii0GbSDTfZi0MsIpjJq4mMLCZ?=
 =?us-ascii?Q?F21RFeLyzS9aM45udWbt67EdgwiTmSGdo6bw4d8guzWGe9QAGM457PyQQRl5?=
 =?us-ascii?Q?1L8yE9FnVfhx5e3qzcdA9dF6lMK1bzx73Zg1DuSmVgoWzTIeGbJqqa+QJ9xs?=
 =?us-ascii?Q?VNg8Ef1wdLsuqD1szmObD7B+J9DeBeQ9swkVGY3dxrNOqU7EB4U1qxrekvUV?=
 =?us-ascii?Q?3BbdRIzAs7X5CkxYclueALeXkTwPfazh+JJ7cFsSnlAx1CeOUivKtrBHGC7R?=
 =?us-ascii?Q?erRKzlxAF0UgDqNVPOeE8CK3kjHlufbumvAoKw4peft7MaQVKc+q4B7K24+9?=
 =?us-ascii?Q?DDOsR2N1UcMSxDvtDEAHJjgCvjdxetpahSIRyfnI332E6dMnKB0zx8paD3xI?=
 =?us-ascii?Q?ov/lfxUpN9/28aMpq7LeB1/RMjzzBQ3t7J6KcUuzhgdF6ZwF3L6BENrfpCud?=
 =?us-ascii?Q?zTGEJIdkLMtzXTXHVNMPROyMgKdEgtweSRUNBDQqWlbDOEFwcSQE66Dc2Nf8?=
 =?us-ascii?Q?mqDRq+S8CnwzAsGh3k1fWWrZDBdm1mrVwjRW3E7W5YGDVwLif9NutLt/l2r5?=
 =?us-ascii?Q?qhUBCxMPlwHmJQ8vNk52BuQLBSsO2Vzo+vWFzeXlbGkekvPS5Ao1j9IE1Si3?=
 =?us-ascii?Q?loyurVCZVz5aNIxoE5GRxHsX4dsXT0ypa2wJhq8u4FgefVyta+J2y5sxj1Fv?=
 =?us-ascii?Q?+oTQFu5pgTyrD2ie8ndGZxtv1gtO5YTDt7+0UJCcBijmhDJ2t71/XTCYtkqs?=
 =?us-ascii?Q?Wwf/gdUYj2F/YX0T+BOR/C8HOXhHGe8nX//vL2leGCr6efCBxjpoxpgSQ5kp?=
 =?us-ascii?Q?I//oydvW3Q1vPUAuQisVT8qUAkAu/FbZcVlZ7G7UQ4xD5d1x+toQ0CQV0qw/?=
 =?us-ascii?Q?J3AYKxUB0baXj14yUQH0YMbYpaz5ezwCpMVV4vkydfdKYLlnfniW0qmqIDWU?=
 =?us-ascii?Q?GUwE8iPy6N9qc0kj1kY8mByVmqBZlLxlzqirI0FwLc6av5/viREca9PTno3o?=
 =?us-ascii?Q?YIlPLTt6yEid/TyLPjfjMpMyLgtGnnjU/ZqjXU8VYE+MnePvJT4NqKeG4IiO?=
 =?us-ascii?Q?t2+lShL264fxauAPKIBcIBKiTS7hHDGgypQztu2MQPhprRPrlbnQL4tBWej4?=
 =?us-ascii?Q?fm1WbYgY2a9/1vmWh4BNNCkVWQnnp2mzeULZcYDVL7AQx+EPp5lvo5olpxFJ?=
 =?us-ascii?Q?wmTwu5axqD5AMFiXaJFBpM65UE/htu9sr5lN0p7a/h5ZtHc6QZ1SS3QT10zw?=
 =?us-ascii?Q?kgcYqVldU6/kkhSqRacigb9nlSSlH8i5DRsKG2FetV2lmHEc5AzXzyzzSXjI?=
 =?us-ascii?Q?NA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C976E9D7C63474B9A86422BD3156ABB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076dcb5c-100f-4b73-1bc0-08da8202ed97
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 16:50:31.3838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w1nHRqxHpE+B3eK61G7+eoHTYfztVxnDrsczpddf47651NgxoMkhWdl/bhy5L9c96g5e7bK34/RDllBUCYLGug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9583
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Mon, May 09, 2022 at 11:02:42AM +0200, Andy Shevchenko wrote:
> > +EXPORT_SYMBOL(ocelot_chip_reset);
>=20
> Please, switch to the namespace (_NS) variant of the exported-imported
> symbols for these drivers.

This was recently brought to my attention by Colin. Could you please
explain what are the benefits of using symbol namespaces in this case?=
