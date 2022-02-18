Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0AE4BB701
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiBRKio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:38:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiBRKin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:38:43 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2118.outbound.protection.outlook.com [40.107.244.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1757B5BD2C;
        Fri, 18 Feb 2022 02:38:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkXascRZuhRTvXJm7Kx2CSTWPLkqtGy2hVQXB4sofENVXrou2LhBfH7OMxJCq41T2aI49UwtyOqzJmoyTDX4p0+rkFTLXSakQEaXUaEmhLKJpmkp1pDqjadD4w2AAb69pvGfaQxYdUA7cwqqUcPmP5dNZZMEEm3jII9ONBPZCILxeaIFu7olOk0DWO9jKYlHcU2VswPocLBYjbgqbUqQa9eLiDQ5ZDIMWoheN3E5wKTpt4a6AE3dc3+3227IIVVfoDoOwUyd6z4VjcGw+glqgobchd6or9L5X4mquCzIDJ0QoMdQCaToCvX5II8E+RkT0pWjbjJZXg/8bDt6VmrQRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUK9Cn4fEZFJr9zFNAHPMFXMneWYgz8q1w324ceHEsA=;
 b=Re67wzvX3Dn6iizrIKr7X7uH8R8Y3KuIMpGYEALasFdNZWfmCSg7RFfs89xc6hCu1XfRhdVwaabiNYuZQIRfsq8VpV0MWB+UbqNyL3UyDD2Qp0i+RQheFthZ3d1jBdlJ6WtIbLmDm8/raBePSVrywpl2gfAHeZWdVqqSLbNJ+InPqbyIoGwsrkRS/yVc7lf6B1xxoT3+WpNPbBqDujDEHxei/RQrI1Kgceuy+MDVbTAhRvh7qVA8H2+5yBRceCzpgmmwyXeBr5MkT/d0I2Ol5G+DptJrwxpj88m9IxUT25pdS0IioEma6XKKqx8B76ZYdkXQqbZ7FFdii1ydFKZitw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUK9Cn4fEZFJr9zFNAHPMFXMneWYgz8q1w324ceHEsA=;
 b=agAxWj2CjT6nFBzrAU85JX7iKzrZ20fVwjkMOoa2pVnfAbHOAnD1yS5aUZHaZT/h3+3zwQPvwDhEIyBOOAKJ2jZ0WENwCAkYynRLgb+9ZBBqJdXVBhsTeRAyw7eijnuB/zRvLqarYjghpsS9zI3e5u8kIy4qcJoQO3cIRmSNhxo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1248.namprd13.prod.outlook.com (2603:10b6:300:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 18 Feb
 2022 10:38:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 10:38:24 +0000
Date:   Fri, 18 Feb 2022 11:38:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@idosch.org>
Cc:     Jianbo Liu <jianbol@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com, claudiu.manoil@nxp.com, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        saeedm@nvidia.com, leon@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com
Subject: Re: [PATCH net-next v2 0/2] flow_offload: add tc police parameters
Message-ID: <20220218103813.GA29654@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg44A/JcKmsTU6N4@shredder>
 <5e9a4e05-8501-4d21-c8b9-91c992c109f0@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR01CA0086.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d2ebf7a-2d28-4795-1c08-08d9f2caca07
X-MS-TrafficTypeDiagnostic: MWHPR13MB1248:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1248A4C3C9668A5B7F6B26D7E8379@MWHPR13MB1248.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8s20xrk/Df+G9SuNSm8W3SkAbzY8CyumFkAc0wDq0QkLZJLonq+gwbIJtoBS8l6KeVv0AZynTjhkc1UIsUGFv9fwzCU9TWjDkMF9jIiUw6DgdUaJco+gY1zFz+i9BdGd5SxSc5Eyrd2LN4hAwzDWf6dykBZGN732JLEIIcc97wGrvDQuFzdYpNbKnfwLjGklYEsw/FVDmBFaO7X11ORHF6O7TLNPpYgFGcss2d5R/2uWtvbW/3anqFO9rPUwtAN9mYpPWcMxv2y2S10hLjcNQkEeqB8wNTY2wwR/Kym0KH9b/oAE5l9lDVeEG+GByfTViA+xsrX0OjKIvHcqCvXVURGmrYZRRKkzlF+trXl2oCOuQQBAXUm8/dPUsXm/5IVlcCs4AJPPcQJYjC/MPg+YHTfQwIpH4QhfJeynTl8NKdLOQvzke7NNQOKsEUPeNYqfZXjuNqlQBAm+0jvli5xQjiiah9hX2JuNlNmV5zlc2mA44ToiD4YeQSPpw+p0TKj9+Q0d3XSFuAPrXu4wFKaltL3IBSpM27AoHKTMg6wFT4N8J+lsvG4XVht3Hevg57tNyIDKRhjvrLALrRfiOu3zdxdRG4mv8bc8oeb2rMUD36tDKQQVcjHPDBp0mylEFIOo80WfEbOeiqIgIjoErW82g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(376002)(396003)(346002)(39830400003)(6666004)(53546011)(52116002)(6506007)(8936002)(38100700002)(66476007)(4326008)(6486002)(33656002)(508600001)(316002)(8676002)(66556008)(66946007)(110136005)(1076003)(186003)(2616005)(107886003)(2906002)(83380400001)(5660300002)(86362001)(7416002)(6512007)(44832011)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aZUN1vKQmeYFRe8qGRkfN9t5UVVFLN0gO9LRORCgACSsmtfiwE1mLSmZPF2M?=
 =?us-ascii?Q?pOAByH2O8+vNbeTUqWgGVD1yU8HBaHWY4j1ezMHX1DJEGD8ToWGVkBUJrXcf?=
 =?us-ascii?Q?CyupHK/k/GDMGyWpAm/ltYF8vrJ03Rq9vUwcP0iWNC//8KleUrgUFBb8Vpvb?=
 =?us-ascii?Q?t7zUhQcYUau+oiftmwYAfbdEt5bDLn9+qDJiZlpddf12rNbOCFR3T16VBKN8?=
 =?us-ascii?Q?XkcG4SPfCg6QNyhGu03qiaHNMP2bf0oB/oTNLy5H+Vw+EejJanIh5WPK3s79?=
 =?us-ascii?Q?+XvIwIDlT6NW3eqAGGv1JgU3rfmiuzNhuJz/SEWsLIORSIa4c7NRSLCq/oLw?=
 =?us-ascii?Q?FI2jFeLAS3sw2E9EoZnb2ODJJBIeA4wK+tgMawU/6eQIL42RUj/OMMx57sFY?=
 =?us-ascii?Q?q3EAqCdc1dfL4Y/MQOKkHImfg6qVoFGxHjiEuu6klaqlF0j5sTC3AU+GkGmu?=
 =?us-ascii?Q?o8ueWomOsBTCcNyrcx7oNK3f1MwbbR1ska+r0mUGns8Ljn2Ig2KeyLOOJo/9?=
 =?us-ascii?Q?vKkGWsiwAl9xgFz9AGWt8D3l0yMG+xfmhrmwbeKK80uN0vB+FoMR5elQycB1?=
 =?us-ascii?Q?/okfNj4sUAW5EDwozlo5Fbu+2xJUW3C0hAeH6v6tlUmHRGtRqk47RZIFDiU8?=
 =?us-ascii?Q?uWVF5fXj63qftPELzoiDHOOOC2eGQrVISvTPDdbWmM+0JrTzBldbS1bUwTb6?=
 =?us-ascii?Q?zvnkArFFas7s0FOEg0fknkFR/RmGErkWI7wOYqwZ7PSmASBwXQcN0Jb5Hp9a?=
 =?us-ascii?Q?4kLIpu+Al82e5uLeWGgRja4QZ9lVswHIS6Hwb93gps6FqXwKTrcRTl+zUXkz?=
 =?us-ascii?Q?zeqousfdjIH+ZbKPCDwg9SuXo6ZiralvziU4z4ZBMcNdiGnFwhXY4zH5/nW6?=
 =?us-ascii?Q?5oAgJlFehdlZTKC+C4r8t9/XcPTVKQ5h2om1nT6NjVCtaVlFbUgN05TC+UmT?=
 =?us-ascii?Q?lK4RJyHVTjhI6evjsGOS+1R4M+l9sS5Cxzx10ytCvOI2g/BS2LOhvoEyBXHT?=
 =?us-ascii?Q?HMKxPSghlLmqjcxCFqAMShJqIiWEWXBwdgKH5mcfabJz6jT0YZABhW48RaD6?=
 =?us-ascii?Q?+FYWom1UVOQwChiGxG9vfbO8grQ199GTW9M9PwIyf9QXvlSuwtAqzVZXFxAe?=
 =?us-ascii?Q?c3f44UxkG/mJ5UHVbFmwy2m6h1025PZMH6MiRGct9+hmDlFuraB+5SXS/pOO?=
 =?us-ascii?Q?/paZHbATT0RhAhNbU1bTGgFKHbVbTPsF0r2EcNAjhygVn4xi5lR2QhwyilTO?=
 =?us-ascii?Q?UnEi4DvR7AMCFN7We8hnofKcPRfX+2oCisTnFtbPqoJbH6UAl14ZjfNZi3fy?=
 =?us-ascii?Q?RFjyoTXBALYk6Stsl97Bmf2kl2sfi/PHyEI0KBSTAtWxS8gQFVPKfCWXqdV4?=
 =?us-ascii?Q?IK3xoib7+H1kFUm38Of4GjFMHUKRofCsHknadi1lxR3MUyYGK6TS5s9vK3Vs?=
 =?us-ascii?Q?a4QPq+j3wr1UUz0i96cB8qpCIIX5AMieJtT+sncUwZSfd6uJTQLyT2L6y4Zc?=
 =?us-ascii?Q?QVKEmMwpRHUK3kAZwA9XwfY5r7MGbskdk7sSZ50kixlC7BhpP/x0LKXVLkh9?=
 =?us-ascii?Q?7eyPjoZeMiFDAfeBFyE5oLbGaZ73ig5bO7Q6Yc9RONCQE1iMIIaJ3j0RXmIo?=
 =?us-ascii?Q?7Ym53aKjjinwanm+SS1OMas93+/8grDi7W7GEy/YRLGk2e1GS4WqTjhr4joD?=
 =?us-ascii?Q?EtPIfSgu3cPF2Ot2YgM/MZC3LP/YV5QcDlKFWCZzkLssYetc7cBNvn+n35cT?=
 =?us-ascii?Q?5Qnd/+C+zGaUL7kjCHny8pFNJGGhxRk=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2ebf7a-2d28-4795-1c08-08d9f2caca07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 10:38:23.9851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLSMo26Q9sOK8XOqJDGHF6qCmNyMyQ+KtCQWApG0mtuWAcHmYNzPvG9hufDsN5VzAlf8lnu67CRaHSV1rukVJVB79WPZFMbWHsx80POCWIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1248
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_C,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 01:52:47PM +0200, Roi Dayan wrote:
> On 2022-02-17 1:34 PM, Simon Horman wrote:
> > On Thu, Feb 17, 2022 at 08:28:01AM +0000, Jianbo Liu wrote:
> > > As a preparation for more advanced police offload in mlx5 (e.g.,
> > > jumping to another chain when bandwidth is not exceeded), extend the
> > > flow offload API with more tc-police parameters. Adjust existing
> > > drivers to reject unsupported configurations.
> > 
> > Hi,
> > 
> > I have a concern that
> > a) patch 1 introduces a facility that may break existing drivers; and
> > b) patch 2 then fixes this
> > 
> > I'd slightly prefer if the series was rearranged to avoid this problem.
> > 
> > ...
> 
> Hi Simon,
> 
> It can't be rearranged as patch 2 can't compile without patch 1.
> Patch 1 only adds more information passing to the driver.
> 
> The drivers functionality doesn't change. drivers today ignore
> police information, like actions, and still being ignored after patch 1.
> 
> patch 2 updates the drivers to use that information instead of
> ignoring it. so it fixes the drivers that without patch 1 can't be
> fixed.

I think it would be possible, but...

On Thu, Feb 17, 2022 at 01:56:51PM +0200, Ido Schimmel wrote:

...

> Not sure what you mean by the above. Patch #1 extends the flow offload
> API with tc-police parameters that weren't communicated to drivers until
> now. Drivers still ignore the new parameters after this patch. It is
> only in patch #2 that these drivers reject configurations where the
> parameters are set.
> 
> Therefore, the only breakage I see is the one that can happen after
> patch #2: unaware user space that was installing actions that weren't
> fully reflected to hardware.
> 
> If we want to be on the safe side, it is possible to remove the errors,
> but keep the extack messages so that user space is at least somewhat
> aware.

Yes, I see what you mean.
I'm now comfortable with the way this patchset is arranged.

