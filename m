Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9599D5B4F6F
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 16:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiIKOgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 10:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiIKOgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 10:36:00 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50060.outbound.protection.outlook.com [40.107.5.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAEE26552;
        Sun, 11 Sep 2022 07:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfd5wqk1UTZaoUgBm0X/FRjBvIJUpdqkcV0mxUk8MgCxAqEyuakU+0zCwdBrNg3GAVT0MXz4apdo4LZkIv7uNbs7A+rnDzHJBE6RoXlpamHbZHNsCdS1omPB22yCVgEXAs8Z/Pz0fDgQjOXTBq6FPkLxxatO02Qsb7oWoeoA4HTcLRJXArWseK0txlFetgZxTH+Qhh3eqrQXjTslGbVjpw+I8gLh9rXwehiAwBwNZ6HvTdQaQXKo0B4bWBAjLkhztkxPRqjjMLTSMb8gtG+Uok2arMTlVFfEIamCdMd3AtqPTA+On29EeefdeKRBaZ14k/E5g9po3Itn3MrAEAxy+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOeYnlqOJEYXKQyObYcaSrNP8qe5Gu9GSlBDFXoZAd4=;
 b=hWbH9Qiu1sBnJira8jz35mA03l/XfyW56ovmSrOwon09ltUZ1MoIxWz+KyWKXfKp33n0mANKslmV5YZEGZ2FzpXGy/o2llCDzqLfprvgzKfoq/lS421HfxV8bAks9qG7iQJ2aY02xL7osQvtWWQ2OKH874lKFStBhP0BLIg0xfgkLBK0iSF0P0F9+eqt5cgXr7+i+18RzoUpZ5SQbqXz5BNmGKnrShTBahv3pQjAcYg18407GpFeVM2wwdcDTmCoHUMd+Lqq69hXDcdMduIqjRBBvUM4UL86nSDbuxbTIcpiZHTuXXHQ3zTkjZUautIY0AVOVbbit8IkLfPlj3AhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOeYnlqOJEYXKQyObYcaSrNP8qe5Gu9GSlBDFXoZAd4=;
 b=MkMXCNQxn63cT8NRul4HsHuDwIUK6B26Tg8rBkn3ysRUR+uJne57a25KLSgKG7QIBavAgAu7fFEx7bTGKmTcC9RPFpSIKRujgdXAvDX2Ah7wpOd8QuUiX9gTCVZp08PxsK+hdN6NUxJ9NrW5JvLj43vEEoDkJmv99CONJPRknkU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9469.eurprd04.prod.outlook.com (2603:10a6:102:2b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 14:35:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Sun, 11 Sep 2022
 14:35:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v2 net-next 03/10] net: dsa: allow the DSA master to be
 seen and changed through rtnetlink
Thread-Topic: [PATCH v2 net-next 03/10] net: dsa: allow the DSA master to be
 seen and changed through rtnetlink
Thread-Index: AQHYxXrq7VKdgocdc0yXd/+v2/htAK3aTKIA
Date:   Sun, 11 Sep 2022 14:35:55 +0000
Message-ID: <20220911143554.tq4lf5eqs4novhtn@skbuf>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
 <20220911010706.2137967-4-vladimir.oltean@nxp.com>
In-Reply-To: <20220911010706.2137967-4-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB9469:EE_
x-ms-office365-filtering-correlation-id: 43bf5bd2-48ba-4f14-8f37-08da9402ef5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yDnbC6Q1EsDPcIbiWip3YAYMJfdeMVaBU7G2U+YAx5qkgpUy63KStdlYGVzKmRdnDQFcX5ro2EjHugqxit8Ie2di5T+OeY/B6cSvVU396s5LnsscFiVOm83q5FSQTr2BIDiadPTHiT73aQ14qtulYqmSHFWpp3Em0l+PEJR+UpbD3Q7F0V2AA7u7Z3YtTRSDtyQ2oLvqJPY4wENiOS8VtVgyzVB4Z10/jr408D/xIKSJ9dK3WqTz4zNmUta9xqSwcWD40n0XixZM0X73fG9Dcva1DXZOEnIY3rGgnnXIzsRHBliUMtIkVfas8P0jlmvoAFpa06WQT842xb26vY4XIXOqQVHEQnwDMqEfCsfCLKzaXwCDZHZvx20EyURlGon68WGbhQJTsE3mHs+WF1RCaTVMz4hhqTvAq1TWfyw3UPpDSbri2hcRm5c4T4v4YyE4NithnBOgmQJZpkb5lZi2SCgcK05iYQEzjVqLLlqqC1HQyLMtVp3C9MwspyPK8fBsq8NIIUCZTMLzdlo9LWkASzsPTxD/dZj8Wejdl+7SM+OxPRKuHbHm3LL2ue901QbDHBAwOeILlGwd3N12qdIGpsLlDXl99CwHw77aCcdBVGvdrd7IKozHlq2n9V1PQS/vf1p/6vCvcTACRlbMsxg/6AAnq3Otc5ESy8RpHUYWM5uywvQOdP1M9XaSYzpq3cRZpQUKykRTDedRZT/o2oglXrYp45VnOxWNCtuRqKytAPMia3CS5DuUDj1F9GhWWDLOiypRd27y6MjitzXn9WUV7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(38100700002)(38070700005)(122000001)(86362001)(4326008)(76116006)(66946007)(66476007)(66556008)(8676002)(66446008)(316002)(6916009)(2906002)(5660300002)(8936002)(7416002)(44832011)(4744005)(54906003)(71200400001)(41300700001)(478600001)(9686003)(6512007)(6506007)(26005)(64756008)(6486002)(33716001)(1076003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?WUW4L1obn7U3zzAqklFlQP/kM/dMUNGFRNyp1uTdd6fGPZGax1WX4ogy?=
 =?Windows-1252?Q?45pQiZauwGhu+xm0knzmXQPRHZ9uYBnAIVwW6tBG68VcEj8jSHT9Nwpp?=
 =?Windows-1252?Q?dYuBs9MlW6ky3m1LlU/131takM1KMF+cZvLpajjARurTEAilu49cbji3?=
 =?Windows-1252?Q?j+txjOTzn0y0xQKyVZ+rZxjwcLgUPB6jGiOXwAlP/YWEfK/ENvSF9OV+?=
 =?Windows-1252?Q?ncrlinTM41s9UEz6oGaiBY8g66y8WHUyQvs8ZzINrhuvMgTUrKdOTdm6?=
 =?Windows-1252?Q?9ka4b/9uFlpZVLKW1uDJJ9I5oMEbTxVYALUu73qhEx7XN39s3trDfH+j?=
 =?Windows-1252?Q?OEJOXEbzLSwVyTPAc+FvW0uf4et8VY2S1ES7fCjTD9guFHK2NMFGnS9n?=
 =?Windows-1252?Q?xtQnyXDRBl6K4HYS8ErKWLicXHIBv5jslIB58XoLlXp7oYxuKCB1ox/i?=
 =?Windows-1252?Q?Hm2k/Z6m3qgUJ7LBKHumGv54llEaUUsl8qIGAOojuupIjkGZjRR2V7wU?=
 =?Windows-1252?Q?+NCtcsJJmO7jcPgdh6UKlQO+6X5RPLZlrKUmyWcAOduexYGwIsqF9mo/?=
 =?Windows-1252?Q?H98Q2YG8xqSiWzJlnGMSo9LGxy/RDXmO3b+WQy9/XngJCNilh/MLDwlp?=
 =?Windows-1252?Q?QFBZ4svgiacUpOERw1yQIg7tAvyVz0qx+8ZunOt9x6XNaINYngJVFGek?=
 =?Windows-1252?Q?x1R2Tr+qgtc5TYRGiViNnmgh3KCl3ezMWZFeCvQgF2YhLmY4fn4thITR?=
 =?Windows-1252?Q?MwWk1hq1e+AXu4jWqfXzf/vNQfBegFVqvNh/dTtN3VTBuEneS7gPO80Z?=
 =?Windows-1252?Q?7RnGcpgpe57u5ytRuNoyzWMsgLKPEkkf9EOC3WsbaekBO59aOz8Eo+Vf?=
 =?Windows-1252?Q?pHG7B8i/ICmsnLvyjaj9Q5fqnu3ruAbxiRd5z3T75jfVdof0myHzmGv6?=
 =?Windows-1252?Q?RCR3Yop0fZs4R0W023/vtyjoRr0tHxViojAzbmP1XQAw9HPTN521YveL?=
 =?Windows-1252?Q?dc6x8zLSW356W9LscGYxw9oevYD2ALxZsHXEQj535NSWQh1uHzWrxCdk?=
 =?Windows-1252?Q?5UeYmqCwp0Z959caIYX8fAsgl2L5KOSnCFO4qt3nUjaVLhv8iTv3oBj/?=
 =?Windows-1252?Q?EGef1/VkR/I03tLs0sgq1RyBvsboZ03mysHzq09XkmaqTQaOwdPm5Xw+?=
 =?Windows-1252?Q?qhTzHFVgOHrFSSjcrcoOws4Iz115GRXP/OscqsnXobJD4qtDwavSC1UE?=
 =?Windows-1252?Q?YR3SnA0EliediSWaPmaqdCHZXGlYCl1swyxtmQ3MOAW1f16nLBFXLXYa?=
 =?Windows-1252?Q?Qk2n3kwZeWx7Bzrgix4e8h1UfSOCPgsi/7IhS9RH1YQYh6pQ6ZnihWbz?=
 =?Windows-1252?Q?WbyDw0uF8nbjfyktJOv67ZDmGxIOwbRVtV4K8TO2z13rQKq9DiZW5t2n?=
 =?Windows-1252?Q?SycxjJROFIl7/QCCBGC6U+GsiZSyczI+chCBT+77nCxBysUZQCDIZtSQ?=
 =?Windows-1252?Q?/Uq67CYeLIKv3nLnRyRX1zZkhcV2zZesaINvKR0vRcCpkr9LlygDweDv?=
 =?Windows-1252?Q?3O/FKss30xBKkMZfxxm+Vy/vdpen8Q977X6IK33tkukTrWPsViGNfdEV?=
 =?Windows-1252?Q?UKwpjgt70GwygsgzGN+guWcwT5DgsFWx9WWKmV+7jlY8skJgVP0jI06r?=
 =?Windows-1252?Q?ye7JHu88a/6K/L4U/Vi+ZLY0XReDt1+ELtB4iHZxdM0DMOUE1uwSaA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9B5649E68D886543BB48D83D41DC1FCD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bf5bd2-48ba-4f14-8f37-08da9402ef5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2022 14:35:55.2387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XFEu2WRAiYWlLKPJOenSoEI14kENdqipUIovgegq8gZrpCdkPnzR4EaBrtHWmKZcg5IvoU4hSBnO/mYOccpIrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9469
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 04:06:59AM +0300, Vladimir Oltean wrote:
> +struct rtnl_link_ops dsa_link_ops __read_mostly =3D {
> +	.kind			=3D "dsa",
> +	.priv_size		=3D sizeof(struct dsa_port),
> +	.maxtype		=3D IFLA_DSA_MAX,
> +	.policy			=3D dsa_policy,
> +	.changelink		=3D dsa_changelink,
> +	.get_size		=3D dsa_get_size,
> +	.fill_info		=3D dsa_fill_info,
> +};

I forgot to apply Jakub's suggestion to set netns_refund =3D true.
On the other hand, I think the patches are otherwise fine, and I
wouldn't resend them, especially without any feedback. If there is no
other feedback, can I fix this up through an incremental patch?=
