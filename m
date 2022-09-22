Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153E55E579A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIVAqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiIVAqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:46:38 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2096.outbound.protection.outlook.com [40.107.113.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6493A8CE0;
        Wed, 21 Sep 2022 17:46:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTIffDbNity0Xh3M55PpS7PG7w1IaRX0YwSf5q5mRwtPWpvG/5rB0JRY2zTCEcF3Ds7FNBQI7b4fptAyuOOYDvjf7KwhrnA08+J9EeqTBM2YIhHfRAbAwmFk5JDvUaSi2sl2e9uoZZMhyQyU6kwu8FQiBMbS0C2LutctX/FhJWW0oGOCAkUC7FaOsf5bYRiqvFFdTXbPUiQkT/E9wwpnQFqfdfadUPAA0qsHXhJvlvqHrbMfkrBxEmUlLyV07OLZng4efwgcf6hbb7aFvUN+rexJ7StjyiWQQcQVr/Rx6BgOmsQ0DTlQnvGooC05fvyd4fzA8RMec93OGDAwIHIFgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbXw4I3TzUH5j8nhJswJe5j9cDya2Q34Jqdr4KHV0Uo=;
 b=SFJe4IKIJ88AmTxlU+xeGZ2gE3x5G40UwokIhUKY0yEuP01iz3BYLYq0F5Nfk6GM32warCeRLLcQ2ceVxBsK2P/2v+DnCfEHZJ43GSE3sVlQnWybz+oQnrjMNzGf8XZHRyIOc0zHaIW7hUz7+JZy+maiQav6Z18WWX/2Pizf0xl2olAt5UKD38APR4aymPZcpOJP3pxCCdoIlQ90uEvcfyFA8TUImWNrOJntlu9Ko6pUP3aBwaBWqYtSORmQp1sXEDfHnBidyVsxAhi1ssH5THj+3g9LCth1UY7DWPGfMe1M6mmOTUjmhcMT7/k9XVFlbTTfnn6e4dNpyvqqKvOe+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbXw4I3TzUH5j8nhJswJe5j9cDya2Q34Jqdr4KHV0Uo=;
 b=VFLjzru1uxPdZW9O0ww7jIrVV2UFldi/QpiP0H0ynSzibn3ILdmDX735KZfyjRsDTt6NCFIsdBoCn3LfdpawQRewBOt5mtkP53zyVhyB2jZxM54O+U3n0Ldji3CmL4ks090yctQ1XDR0JcqjHkUbZfLIFE5vGjcwxUQamvl9Pzc=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB8777.jpnprd01.prod.outlook.com
 (2603:1096:604:153::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 00:46:34 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 00:46:34 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Topic: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Thread-Index: AQHYzZbyqTwrMjeNqkC6dNbQ2PLk4a3p9OQAgACfZDA=
Date:   Thu, 22 Sep 2022 00:46:34 +0000
Message-ID: <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921074004.43a933fe@kernel.org>
In-Reply-To: <20220921074004.43a933fe@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB8777:EE_
x-ms-office365-filtering-correlation-id: cdb7041c-3a1c-41c4-e09d-08da9c33e658
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Gi9rM0BCP42kVnmcUd/quAg6XLlzEuHlNFczUAG1jlO3EyTRhlcGxJf2i3ej/FKR79HY7T+FxyqCSsc8+5fO1zCUrSgG7lxryWyGqp9cFeq8hTTtQcVfxxsTb02MAmXnwWas8fDkQGc8WdhV9oX3Q77/dkgT9g8qNxOlJi84PBwhpuDVPSxUQ19nEE7uzWHGy6jYT0rfzJ7upIfk+t0aqAPMoRjrs/qI+32EjeMCQVSxhl1r+BVQRR5dpIKOxhBWPHUU7VXxVtCaUTcr9y5awu20hxc8f/Au5HgKBBMGYruQi3loDAWwh5PgfdEBiDVUCeWLlZAa3r0h37JeyT4c9b1+CiqeJBVqncE11ESsmIrE7/K3wbd3jTQGcDjORQ7yc4zCqAXi9FHC8IY0N00+tECzIjfAO0yrh4WMpAwdpWFehLvjHlTyjP02jJI0LirXYWS8M1Blao5vyJP4P/WhDr+DhhAf8YjjqxTuOyeWNnzO91nefTjR6+WUr/Hpf3i7hV9/TOw0LsTdN6U79ZEp3cSGpZQN0EmNhguHMhfAWiHwZEQdkhxvb3ZC9y1pYATn4sXAYf1LkZARqi+/GUJvvSA5lcb4Jl4cXPuoNpaK1g2Suc6ZbwXEDkGeCe8mZ9SFgx/hqVillcBY0z1sTKY8OcT0c02002Qqu9jv8GzzrtNIkMxgkK7c3+nL6KLDvLhNuBxNpJzmkJvGgmwmEaNf7kgoZarh7z2Z6yL7WfS84aTUocmGipyNIZFEV2vHNE+wAQ2Ga4nEcJu679aC40tCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199015)(186003)(86362001)(2906002)(478600001)(5660300002)(8936002)(52536014)(7416002)(38100700002)(122000001)(55016003)(4744005)(33656002)(38070700005)(6506007)(9686003)(7696005)(41300700001)(54906003)(316002)(6916009)(4326008)(8676002)(66946007)(64756008)(66556008)(66476007)(66446008)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hdXeAVpzkIp6inGWukpXZfbdYjfS+GNI1jJQQSVqDCRPhyJaJtqx74wAsYlv?=
 =?us-ascii?Q?1d1TQiGhLDL5w2nV03nRGWLGxDUUO8bpzWae2hB6x1eaHcDhy3oRAEKcl7HX?=
 =?us-ascii?Q?T7et+BtVcSA5E9Y4ldX/0yRuUSVPI9zht6UtL5HSX5+31sKZeguM1IuTa9Cm?=
 =?us-ascii?Q?D+vGzWdA4VAJ6v0zxu9rakmvfGvWv66memjQrrMvZ3NLdYf7HdlJVsfHl/6R?=
 =?us-ascii?Q?ZgxfrW4d8nrS8K6Izkipz+68xdNz/qs1uQWdNZdidi30pTOc6laSXdR5vPuf?=
 =?us-ascii?Q?qbP10w6FOAsNtgBax2D5e3nOzcDywSnoD8947Th0FoHGktd5cszAP936kOBZ?=
 =?us-ascii?Q?twBucA3YoX/On8ivw1hNE00/9ZEXPjQVdjNThbf48UriVSPCrzfyRqgl63/W?=
 =?us-ascii?Q?Y5RC969CzdPkORe7NIUBt3Tr+CvLYqRr/8pVAWOgIpBTK6UQt1i7Jh5WsPYI?=
 =?us-ascii?Q?KjAEZtrw0Roh15a8ihAhPgkKpEm6YJNkUEZn81+m8VbeGC0V6SaYT0SkOpaO?=
 =?us-ascii?Q?cs5zDaouecUdMkDR+r1WxvSa+O+gGj3q0SqcKIRzqaeH4plR7p7/RHJtm4aX?=
 =?us-ascii?Q?20pIXPho4FtR9LQuC2qTDTazLrvuYIME0gHpDVaiXbQ5ZjSHzbkWLslp6bHz?=
 =?us-ascii?Q?jWqlHEqdd14x6CRcMKXTF54t7Gas1Tzt5s52udC/ivA/384XAmba1SRNbtzu?=
 =?us-ascii?Q?CfvyFIzMh0Lghw08plH20y5VQ57AXVCeKMehqkgoEtOe1/EAlRoh2nggEzno?=
 =?us-ascii?Q?82jz9oQMwdgI3gfXte/6Q6UD5vh8Ue5Yr/9RFuXxwEjORSu3dqMOD8uZM8Qu?=
 =?us-ascii?Q?We4Hv6ZQxlbsCfE0wx/SOB/pjltYcFJQvVsOI4Fzj5sGC4t3ygEFLTgBW7be?=
 =?us-ascii?Q?83ch3fxuXVJ7mfInJb8itSNboOkGzpV0K3i/XFNY1gXCILA4fHv74Wo8pop1?=
 =?us-ascii?Q?OdXxDbscGsFTUkA2FcJIKJjuPqzE+7t3yO1mq5bYuSy4Q+oWRe66Zz19Acl1?=
 =?us-ascii?Q?twvdkZFegJLbYVGTo/G8f0P/bMIPaUUXnnYAmcfee79GLojdbknXuHxhFNn1?=
 =?us-ascii?Q?Gowb8odPnjNDC4KUIUjs8+fz6LIwkkIURzRZw9N5t0ycRhr/pJ81RuMts6TH?=
 =?us-ascii?Q?5ieHCjvqbkKKhEV6CcJA7TG+Fbvd+Y11taU9Y3BvTxHN704yrjkjo+/KAMEn?=
 =?us-ascii?Q?KxT8ROYU4UEAGkU0t1lipuKAJH4zHRwMzoYbRabxYm9dMjFaHLns6YEjIX85?=
 =?us-ascii?Q?tQ4w26l6D9pA+K5k6kK+0rMoZP7ZJlKAY3V7OJu4WC+0V6dEbQEUai5tQQ6n?=
 =?us-ascii?Q?1/l8HeH0JDQmvF2XRmp7veupVdbSgxkbwnrSpr6CDhETZ5pRMfbpB5U9VqYD?=
 =?us-ascii?Q?sDDU+embTu2abs8nGkDqVThku82JAA7E4queXlbMCcTjuxy15w6BPrdKFq/Q?=
 =?us-ascii?Q?wf0Bq2he5ISnNAPBZQwv7+a7+p9Hu8kEkS8Xhjw1RT3FP9Vnb1wVs4elm9oh?=
 =?us-ascii?Q?lRPwmootpBH5o9M1Uzz0wf31kdua3u+DD8E7NlLcgVnQ8PfOPMTzumQaGIpn?=
 =?us-ascii?Q?AVyX1+tWfm+MjPMicH6mwS1nSMNUnQFqcsqr0mcnis7ODj6q5t3ksiWqSOHE?=
 =?us-ascii?Q?yJvD7PhJjTUQT6PvOR4L5+S1dSL1ciJhKpvc3g59eTA6QpdI0S83h8zcxBwL?=
 =?us-ascii?Q?LTac0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb7041c-3a1c-41c4-e09d-08da9c33e658
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 00:46:34.7727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WczwpGz8sNaTAlXGuLD4QB8Yc9KA4HDlFJrNbEcaOFjWTY9n70qpjGGcAZrbC4zuIfSXEdLW0p65Ehge9t+K0wJ/2OBXI2QpJHgLJd8S2MR9bdtx+bCKVaBHVrop9fQZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for your comment!

> From: Jakub Kicinski, Sent: Wednesday, September 21, 2022 11:40 PM
>=20
> On Wed, 21 Sep 2022 17:47:37 +0900 Yoshihiro Shimoda wrote:
> > Subject: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch suppor=
t
>=20
> I think you may be slightly confused about the use of the treewide
> prefix. Perhaps Geert or one of the upstream-savvy contractors could
> help you navigate targeting the correct trees?

I thought we have 2 types about the use of the treewide:
1) Completely depends on multiple subsystems and/or
   change multiple subsystems in a patch.
2) Convenient for review.

This patch series type is the 2) above. However, should I use
treewide for the 1) only?

Best regards,
Yoshihiro Shimoda

