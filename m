Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7A589173
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 19:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiHCRbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbiHCRb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 13:31:29 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652CC1DA75;
        Wed,  3 Aug 2022 10:31:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pq8iYSdVn7IytTaNd16iDPNar6yUb/F5zAis2uBCFhhLtOZm8A+4uZPvs4w1EKsnNg/Lq+FgRC/BWNWAQjC0iENdTGrM/LDAZsYyptr106zQujTYehuYeUdTw2JxcJbtuYIngnjFM8+6BUzRToJMfEHzug76ju9mkTJUxTnYH3OyHd/X3szPO/PGtXSVqUInUWmJ8tMyz/kMlnR4eADU+S8Jn1yIFMC3JqPpRZD793JhXiV3y8tTNkDiCwlwVRZ/8wz1q3Uj3SulFPxq1So3MF+hJF8/TLAQvwbmPQ4pahxoAYFSy/9DVuIen580lPcr4Cpi/S09CxsbePLRSQS95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/AmrvWeBfQs10/angywLzKSfd0QbDP/e3Gw5qh1WrE=;
 b=N4cG8DgkFqt9bII65JFna65et+WoqNchgi7v/CtAMKiodhl9nl2udkFyO1RWhhoaQAoFzJjwUK5hfMRzVPl6voAqmdSfIpYuA66MrLhgU39MtBsl3zRxa+sYDwmRBZXcVoVlMN69pW9SMOzBReKiLLKc3pNNqCa8cAbXM/k2ZGgAGCXXjjCDyn5MfGGDkaeRZTm3b9i4mgfVhctqC4dF7rg/Ea85/jlPPxHlvF9FpY6JBVZ3NH1QSW7gDtfgWKCxJalK1jNi4Zo9C0ngYU6ZbCqXkfeB+wXdMU3n3Z6C1ypla0QQmUtIJgNNYMYhfEZr9jCxo1BYzsbkadk8XqYSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/AmrvWeBfQs10/angywLzKSfd0QbDP/e3Gw5qh1WrE=;
 b=gHutPJXKX/IWb8KgScyQrfwQLJC4woQ6tW+NrFkCwNxOi+hO5g0rYsJEbFpsQoR1GdEEXlnQ0d4kzaQ62Bh/7wGDWvWiIdGAEkKHtd0PKCOf2/2Hy4y0IujwRVOVq58b/iEm6c4DQ3k8LU2RFQjGSIFTrLtdlP/TwQRt96MO6XQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6332.namprd10.prod.outlook.com
 (2603:10b6:806:270::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Wed, 3 Aug
 2022 17:31:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 17:31:24 +0000
Date:   Wed, 3 Aug 2022 10:31:19 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <Yuqw5+lLh65flC4D@euler>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com>
 <CAHp75Vc30VW_dYGodyw4mrMwFgTVyDFaMP2ZJXQEB2nFOB2RWw@mail.gmail.com>
 <YuqarB067s+rqFKe@euler>
 <CAHp75VeXtuR=CYyPE9VEE0+QoQ3hgVYCoSu4Yb8EycvChi86BQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeXtuR=CYyPE9VEE0+QoQ3hgVYCoSu4Yb8EycvChi86BQ@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9972c216-27d9-4b57-1190-08da7575fca5
X-MS-TrafficTypeDiagnostic: SN7PR10MB6332:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rbNqBUBCUSAaP9gNElER6AjchXGtx3XAeT5YiHQ2hHd8Ja/Skrzedpm1n2c8GCVbfQ+3ijUrz2TtTVUq4fbDhm1nrYC4Ck/v1Klaph1SRd9oubFEwMaXu+4hju8N/xvE6WrgYfI9O2F6JOkcl1OlBzG8ok0QP20+4Pz8N2nKw56+q9XWxJwSjslPlLlqMMcij0LU3EGHAIeShPYOXVz2sgsCmJhiQTOM1A6/hoyj6gRPctVnzim9kwVQ92UIe+JXlYd8BcNb+z6jL1THfpGKPLmuZ0NyHbRM6JQOjXHzcEyvba50VN/JxH/zFPUNfK6WcEBqgHPPWPQelKr8mSIY72F8Kwf5x3rA24hUKR0Rbz619DEnUs4Yp5DLVstZvenL0onnD5B5CZNsRunbtOypQsGPT2Re7ueJte6eo1LdTjVkGIXX5SrPgPub9qhMeX0Zya+OOXQY+1vIN7LDGHmTrriUnAx1rkYdpyblPA4HWsfSSgkYCZpy+waks8LdKmHGKpsBm7LG390EJC4hWa8sKAp6zvvgGkzJ70LAHmCyXhGjyZOiFhOd/34Er6H6RS+THnJYLLR3OBKsxYkQVveWksMQQ5KsMfmL5y9A6Q2qWAPwVDo0Sz6UwGbzHSebBu4fevVnRuavkziA/klppdvkurh/SvzDI4hmMJ4nUaVD7g5vS2rbIirdzNXzR0B6xWiJW30yUJDQ5jO5pfLuTII/VaOnRd5O5DMwXTMpx8Hn1lbtlflyYy3ERuKNkbphRbG1GjmMoxJ4OaT50A7d+yOiHKNn2AAzTUXqjAZog364SBY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(376002)(136003)(346002)(396003)(39830400003)(2906002)(6916009)(8676002)(33716001)(44832011)(5660300002)(107886003)(66556008)(66946007)(4326008)(66476007)(86362001)(7416002)(38100700002)(6512007)(9686003)(316002)(478600001)(26005)(8936002)(41300700001)(6506007)(53546011)(54906003)(6486002)(186003)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h7ul9oZna8jTRma/Q6Ly1pyoMQm7uPGYQ16sfPqf/PjumOS+0ujDq+pgmMxV?=
 =?us-ascii?Q?Th7M7cKqGP8IC1wR8GKtUQjUnYdUtoEcTTo7G5bQ3jO/HNQuAi3Z4kalG3Eq?=
 =?us-ascii?Q?5vTYygYgyJA0W9h70YD5yl0PpVwMEz8Yf4IhtqIdFTU4b/658QEBEUGwVKFX?=
 =?us-ascii?Q?cVjlkSgd8njVdzJkSvYlF3mi0faBq5mtM180VE9HKHa96ZuGM6lAz4kM69hQ?=
 =?us-ascii?Q?vi2+J5dnsBVzWy3Se/HAdB4Mkt4sHN3GT1yv4TLdJIF/ZHKvpBvhWYsDvDK4?=
 =?us-ascii?Q?zO1pW1Jwx2b6RKdpxvfHI3dhHrzRA7CWtsnHnM/8cJfw9rZncP1zP7/s9ntk?=
 =?us-ascii?Q?Pz0XrFeebM3hEEy+24ocZHrgxXy4uKryzC0zImb48xEAoH/i4Ay1NOJuWHk8?=
 =?us-ascii?Q?EX6V+EdzEHfBmypenvcOV6QSN6N7P97Mp7VRB+ZaO2sIyAiA6R5Hc8CbjFM9?=
 =?us-ascii?Q?ojdhbKj2ePLTwmqrLRhJuFkphhyKeivHTH0uJLGz1kOY1ecqGyrdqqV4aniJ?=
 =?us-ascii?Q?GMsCShIttvLmk5lWT2ZUVc1L2Gj+Dn1bVFzKAH20Zvi2mpMMItr51pXDB355?=
 =?us-ascii?Q?ywzOlbi0ZmmiszltZebrESON727aTxWj8IGl5wM+bN61Dn/ssXuVa7SE2OYy?=
 =?us-ascii?Q?J6qGe57XKXf9BSlj2LFahwz0FCgENG5H/kQuFhDFAh6JDv9QmWy72qdTNmgU?=
 =?us-ascii?Q?Bw4kKHFpzvPe2UmKGVrtPOVhlbriCg6R99aXY78Dos8jEUPJsUuoj1lLAw4E?=
 =?us-ascii?Q?BDdsAg8xKJDdEjC9FPzF3wHWdXmOERPEsV4+Oj7eyBkGzVNR0zaOln1Pzvbc?=
 =?us-ascii?Q?AVtvfI8Ug/nT6cM5FkwmF/u8/wTrgbFbXV06TTp7SjbQmYkMCvU2krWWSbzr?=
 =?us-ascii?Q?JsvllQ1xAljDBQXyzahsPSV5kf5wkqOF0qabCTbt0n88moTaD3SMuH/3EamP?=
 =?us-ascii?Q?ioIdSRAEhM8hQ6AHO1Na38Zxwcf6ElyQyha78r0W/EBOBGW0HTf2dRd0GfzL?=
 =?us-ascii?Q?zlORwpE6XHMM80HdxnRJpynQlBD/oHnv/CxuuCkYflPwEng10FYpRzyQvLWR?=
 =?us-ascii?Q?7mp/ZkDciNfOnVsPHFwzxA6GTuir21lGZhvIerQx1qQIajYJ7FsF2npB5wJC?=
 =?us-ascii?Q?Cf3dSlMnV5B5Mz/3BfZJFgtPOP20it3GhfxMg7Zl/84UVyGrD2zy9hxBPggH?=
 =?us-ascii?Q?vi7LILI5J0GyceFTQGJZZzJoYJ8QGtQZPiD6vIkpU/LtR0jZ9qKp65jw/MWN?=
 =?us-ascii?Q?ze0zbeo95iTD63ggGI3sQoS+h8fqQWR9pRxyiv8A6/7f1dRYeqCTSpYBynAL?=
 =?us-ascii?Q?Taw7iTVJ+uss1UzXyDCPef0FD5/Cghaf1Fs6nYPYKKTQ3WcatKeeOUjX9Zm3?=
 =?us-ascii?Q?hM1IEK9zX+v8Jki9A2ihJZrzrjxMTm3+RQW7O7lhmRKuCrKujrSUE6flypD2?=
 =?us-ascii?Q?2E/OG61+eO/Dv3TmawUMU7210GIMpboWpWvrjRUKJEzeYMziAvOtbYFUgFzE?=
 =?us-ascii?Q?psgLRkSwt5EIJxFEvSvg4NiGci/qOhMXSpIAJFunva6Bd+ws46ukGCDy5tT+?=
 =?us-ascii?Q?jKYR/5LF6CvQuP+35l1OZ7rKDcseIsJVpk6qJqrNx70ilWQOUBo/Z5gGo7Wx?=
 =?us-ascii?Q?4nAo/yItDobMdkjugDHWgAU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9972c216-27d9-4b57-1190-08da7575fca5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 17:31:23.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l14Axbbc/glFgDpiNs/v7m5D59Z0drVCRRdo2SDOcarJQMfFG9vO20XvWgAiAr6T670sLoOCx5TvfHYNYi5fyM4I6gPxiZLsMhrJIkMPGEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6332
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 07:10:38PM +0200, Andy Shevchenko wrote:
> On Wed, Aug 3, 2022 at 5:56 PM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> > On Wed, Aug 03, 2022 at 01:45:04PM +0200, Andy Shevchenko wrote:
> > > On Wed, Aug 3, 2022 at 7:48 AM Colin Foster
> > > <colin.foster@in-advantage.com> wrote:
> 
> ...
> 
> > > > +       regmap_config.max_register = res->end - res->start;
> > >
> > > Hmm... First of all, resource_size() is for that (with - 1 to the
> > > result). But don't you need to use stride in the calculations?
> >
> > DEFINE_RES_NAMED populates the resource .end with (_start) + (_size) - 1
> > so I don't think resource_size is correct to use here.
> 
> Have you read what I put in parentheses? Basically it becomes very
> well the same as a result, but in a cleaner manner (you calculate
> resource size - 1 which will be exactly the last byte offset of the
> register file), no?

Ahh... I see your point. I agree with your suggestion and will clean it
up.

> 
> > reg_stride gets handled at the top of regmap_read(), so I don't think
> > that's really needed either.
> 
> Okay.
> 
> > For reference:
> >
> > #define VSC7512_DEVCPU_ORG_RES_START    0x71000000
> > #define VSC7512_DEVCPU_ORG_RES_SIZE     0x38
> 
> Right, for 0x38 you supply 0x37, which is exactly resource_size() - 1.
> 
> > # cat range
> > 0-34
> 
> -- 
> With Best Regards,
> Andy Shevchenko
