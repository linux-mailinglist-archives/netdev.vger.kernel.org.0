Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E9055EC90
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiF1SZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiF1SZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:25:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2094.outbound.protection.outlook.com [40.107.243.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2A621255;
        Tue, 28 Jun 2022 11:25:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP6v5VqworTZiCfA7R1eIhvoXgDqsTVDLkkySx7TuVDOuWp9470v/2w0sd5Pp0RdH8NAyN/2gr7vvlxGvPAWVWav0K0TcL6hxWYN4PIJau+0MqrV05XVgx+CYZZX3n6TBIxbV1/m1yVGZgCGbLwh4U/ptdyYuADGhk/HoKBohPoS1DhPKL3osCnyoR9QCavKbQntxwMSxF5CQDNGqJUnDf3/k6+q+JaTYkWW91M3WIeyZXS040Tf3qgGHn9NJLIEVf6DzRea9BbYDJ2cYUD/NBhX4ylaXPHruS3rOQ2M6g9fk0CjfPdjCD9Pt3OA3nOWfYSJWtXUwAEB462mRscwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqae2J7OweMNr4Uq7nLVRj3zRCqlzws5oh3MunKpBmI=;
 b=Sriv51u0BJkTfm85NrhUnDvRHlL4rW2XtFcariG63tSdX6l9pvdiRc2Vh0uy9vshib5Hber+j1iA8y6WD1qDM3yzI2/8C/6EpDOFs2cQ6EKL+uiETnaIoyA/d3TXTm2biyhYfeXeUBcIsoqVw+bDMSbXitK+oK5osCvfsLy4UitY71HAkK0fQptsnTvP7agQ7hmLo6Ok/T8XBVdU3nxCoeTmIWqkK4YobgHxb3r6AUWMESmKFYiJ1pLQgg/QSPT3TVQrDoq7G34GGjnXMg2xLL53+ke1thBbmVphKNzrKvBnRiF7LxTAmtZ5QG7YenCHVFkGOTDkyB+5tlWHjMkbMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqae2J7OweMNr4Uq7nLVRj3zRCqlzws5oh3MunKpBmI=;
 b=t5E0hs5THhiLY5QUnmZUVdpHRd8OVKPc+zn6dwFKluFns8cUFNtwRb6pRDX4Y/ityy8O4O92BsVMfpsDSUVB+wEnjvY6+yx+5JaW11njmUsIqTXpajM5s9KPhUA6bWYUyRnWzPVyf/oF5mOqcjlNOnfh6/DmZXwKEoQrJKp0U9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR1001MB2258.namprd10.prod.outlook.com
 (2603:10b6:405:2f::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 18:25:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 18:25:37 +0000
Date:   Tue, 28 Jun 2022 11:25:35 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v11 net-next 3/9] pinctrl: ocelot: allow pinctrl-ocelot
 to be loaded as a module
Message-ID: <20220628182535.GC855398@euler>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-4-colin.foster@in-advantage.com>
 <CAHp75Vcm=Zopv2CZZFWwqgxQ_g8XqNRZB6zEcX3F4BhmcPGxFA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vcm=Zopv2CZZFWwqgxQ_g8XqNRZB6zEcX3F4BhmcPGxFA@mail.gmail.com>
X-ClientProxiedBy: MWHPR17CA0066.namprd17.prod.outlook.com
 (2603:10b6:300:93::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 828fb0f3-1a82-4a9e-64e5-08da59339945
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2258:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DBhXp9D+kasynNZU4SKDyZYx8Tsjd+TNhBMUEusxS5yoFMsGjTXGXV12liUcQhoALreS520aZdR5jQMyAc0K7CM1ceRjBSm0YPQMOr4i3cL+/RxQRvGTXWC5i782PWppX46q1l7QS1IS/HzzAdzAgSzNgvWtGVUMPcIgPeKWpdqPyFbXCP1Aprt6mpVYMB5B6FbOKzjgOYxGV++VyQYCEkYtGl1OL/U0UW2EMkFjNqIJtDTOhGTxxeFzKb6S8ZtTFOjUPJDnU0GViClGYqdYZn2hyNneVNpyy4zu6KIZ4OaOWX5kiBARHK2krA0j0rkImuDXNomowaqgpkk4RkphSBnYVFQ9CvytjGBitl+m2QcU82eCIuJmZwCeH7Sk8sirqUeq7zoFDQ9pi5V4eQos/ud9BZfk968Pc2t5HSy1S4yr+7THzLnO5911j0mLvJcK9HEyYjJjfDcZQIieTbnF7/0sD5Lpfm1Hx5E0mmQZ3pGhWsiAcFpPw2zUECP5ezWDMW79YXQufwMgNF2AIfUBhoWZs+adEiCHIRcRvQgyF0W1jsAOodhQ+aPpqmgWn4RR7WM07HTNvcM2Vdbivv1P+vavu4Vr48D8ZpO9vf+qumKaNKEoJ+BGjwHGm01j/4/llt7340HBOI0AXKYTMgCq5qsySqsvf9oBRH4xR4i5eKeHjlN/23Q3Y4ayR45SP6yXb1mjabiKtGx1jRvUJC5LVFpKfyShHdEpOlAyHO+B3xwbMDnlud2+rsiEQ0ShwPSpktU/AgSOMUNrRTgV51kpds0Q4XREd883ej5q9QhFQyE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39830400003)(346002)(366004)(136003)(376002)(478600001)(2906002)(6486002)(33716001)(33656002)(4744005)(44832011)(7416002)(5660300002)(26005)(86362001)(8936002)(186003)(66476007)(6916009)(54906003)(66556008)(4326008)(8676002)(66946007)(53546011)(52116002)(6506007)(38350700002)(9686003)(41300700001)(6512007)(38100700002)(316002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OA8d5YqKpnVxWs1W5DBSBDyeV5oVffMjg0i7DOMYY0EhUeNzZ/YeEpZ+peiU?=
 =?us-ascii?Q?Ga7H2UEdaXhuUnlbD+YG7ufK0Bm3lnvXhKc0fnql5OG4G8L3FgE6iYNDBsSY?=
 =?us-ascii?Q?Z2GKJyXCjujbGim2Tv/nZQ7KlBD2Y+XFd535Z8LWXAT+SU2maXwI1KEk1dFk?=
 =?us-ascii?Q?8+MDNHIyaaUvAHl4k6xG1MCjNEMX36mC9Xu+ZpG6+0YU+Pt1Gn95Z+YrnYk3?=
 =?us-ascii?Q?UPkUgKqTnZ7BDYKoFFcTd3k5Rb520aXk+herIWlU+A3gcI5TU8H4FAInvm+K?=
 =?us-ascii?Q?gl4e0oPURszpwAJ79zbsV5bJZ1r7Nb72sXLMWvyFjY+UK/Q15EtxtA/9Tv5t?=
 =?us-ascii?Q?DnfwldIlXvqQ9I51i6oYURt/HU+RvloiF3/E0bV0sPjQqP3Qf44QD2DoKax1?=
 =?us-ascii?Q?YpyE85ZgvWONZWFXe5FdzpRd3QUo+c+tpo3j/F0OQguhokrs45azwWjicdPH?=
 =?us-ascii?Q?AhkvJj6lYKLHoKEytckXa8NiFTBmj/xmg6n1MpnmpDlzMnFlpOotIqsvJavv?=
 =?us-ascii?Q?8+cJmxclBeqBkqV+5bb+3MCKtVn3tMftJsgclAdxTtjgUxe6UfbYkGfAxCEa?=
 =?us-ascii?Q?Jz8RZUWn6NGCvW7M6KGcpYbkNroRL/OmD+/aKpgaxi4bfDjReXWUJG4iig4M?=
 =?us-ascii?Q?MdGHSUAXMGopb73dxPqcIUdO2kY79UxrF41fGMnl1ezFfQ7/CvRYkIw/bf56?=
 =?us-ascii?Q?0w0ArGW28mKDAyjLqh0+2xQT9fRNp3vCE9g8g7aBysk+4jnFmspQOVDPUlaX?=
 =?us-ascii?Q?BDznQOWE5U1yFKhJpBJtDgOd/lnvN8a7A5ZlllOV6p5+LUhjpRVjJ6B/HROk?=
 =?us-ascii?Q?5u82ySkX7oActCfAc0VsnbN7gRe1MOhJ/gfxXIzIpV+aURCWj81cjrOPpe67?=
 =?us-ascii?Q?/qtn15AXq1+ypzqBcLagaJbIILoG99Umwqu9Cb2mubW54RoDcyTOSg97oL2e?=
 =?us-ascii?Q?MEsYHNw+vx8LipUaoc5ZYdMShfwT1FC5yjIUOHXBOfhCwvOkXRxTE0O3shoT?=
 =?us-ascii?Q?Y5qth8ib8qnS5LcAygL81S3ePhzmjCLEY43rA0c81IK1BpTkH6nUQEi1JC2C?=
 =?us-ascii?Q?iyrSj1UG/eCOC2YjvRg8b5JV8oFYEw5hX3TioL9ovySYjsfD9o5Ny9AhWIko?=
 =?us-ascii?Q?E4seVglK7N2ucIMpl9+wCiLaFnBoZEvlKa6BL9jnVfHk54u0hrprg01mZvnV?=
 =?us-ascii?Q?IMIQ6PmUVi1LLhUwUQmSZYs8wHr57kAOPLvQL6lYONetzpsFudAyvmv0ylvX?=
 =?us-ascii?Q?/WSg8BCLWw03l8mfTMtucJ2MA23JoIZkK5gpOLpbql7qpTTh+YRJotSSkP3H?=
 =?us-ascii?Q?boQWBWMKlBtMJqj/aAJZ+KcgiznYSkLerem/CcaK+Lm2NPdTzp59A9NL8Sxw?=
 =?us-ascii?Q?7ihe81pJSI7IlJyEbQK8zF3ETm2TZo3zxSQHAF690RpSsEZJZuwL94lXUKEt?=
 =?us-ascii?Q?A1SJyIzIHKpvL8Cm/Cqt/9/ogMsyOSV0+PHihTStiqjY3PVwkcHZonOZUs9d?=
 =?us-ascii?Q?QAMkpjMZRwNYJbR8bAoHOvsuVUFDkWF9bEe/MekMkwYxMBJ3L3L5l4f/ukg7?=
 =?us-ascii?Q?XgQfgTEE5EOq/vYfdjqzauoXdRqEh6qzJMQRYb5QLaVjsKugFrTzmdFxSR49?=
 =?us-ascii?Q?bq1sowWT0TRRHJzBUfKEBfI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828fb0f3-1a82-4a9e-64e5-08da59339945
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 18:25:37.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Or4Wzx3GA/WlLFbi/i2bWS7hwFarxfuiWs53EmXw5YUdY2Z3StopjtfMsmq31WEEwiXUdrGp2FT23ckuPeOmPgR3W9YjBrNRAYqP1WeVH5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2258
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Tue, Jun 28, 2022 at 02:53:49PM +0200, Andy Shevchenko wrote:
> On Tue, Jun 28, 2022 at 10:17 AM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Work is being done to allow external control of Ocelot chips. When pinctrl
> > drivers are used internally, it wouldn't make much sense to allow them to
> > be loaded as modules. In the case where the Ocelot chip is controlled
> > externally, this scenario becomes practical.
> 
> ...
> 
> >  builtin_platform_driver(ocelot_pinctrl_driver);
> 
> This contradicts the logic behind this change. Perhaps you need to
> move to module_platform_driver(). (Yes, I think functionally it won't
> be any changes if ->remove() is not needed, but for the sake of
> logical correctness...)

I'll do this. Thanks.

Process question: If I make this change is it typical to remove all
Reviewed-By tags? I assume "yes"

> 
> -- 
> With Best Regards,
> Andy Shevchenko
