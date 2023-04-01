Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855AC6D335E
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjDATMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDATM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:12:28 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F941207D
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXMPN3GSv2dTYdplYseavusNDoB8gtEQFOwL5R2uFBFMXSqcrYNasuvRh4kp+DSWJWVg9usqp+HcFwjxzzGuchbHQUUKI89i+8SxtfKTq4dDfl7ghPu1yOGTghAr8lDN4lIDWASd5HZUg6gTIqX3Ntsl83C3BL90u0UPDiR5zoOk40dd0MhPenI9dRW2ohTUqHRlYbuBpUknzw1CdHhSJ5fcs3/0DFNEuLfPvJepI3uWJHH/VaeX0gD+KIqDYihZ0eJToqb0rC4matUlvLt8neQoJRXBOYhtDVaIJh72FUr+Y74sjFnobNZW+eRJEAxpuWstbliUHkfUdSdhE2QLAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nAWpxW2pjBe6PBldoKCEe6lZPm2dfPU3h/eztMgKi0=;
 b=LO27fON6cQwLW2HhpY4ZyKcVeveqMoLCEmJ+ksQwNoW9/hOpHhPdwCOT12FewYi2byryxIBq/MqI0Y9ra7HJLLQJswQUOdjdT7GK/3NsxFjApSPTm+NLJgi8Kq152qa4wZGZO2zhNamECrV2hb18aZ3owX2l3jmwIcP4KiHNPod43/UYNamTiqxWdPmB0WFTWwLUHG7+80SHbIEtT+V3+E7PdFIcxmIpc3X6BDyFEvMaAgS2MTx/NUoWP5cXQGlK13EOmEtLZeLcuWHL3fpqRuWwen4qR8kPy+++j8XN8omaG5zEKQMZNKSn4wkX9j+IEcrson2To+NcTSJLA3e3vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nAWpxW2pjBe6PBldoKCEe6lZPm2dfPU3h/eztMgKi0=;
 b=If1t8zGXmKkg9j7Dm7EFpFLacl8l9YUlJ6bM8tG4FzofhLHstILvKy6PJ8jzsiGEI/uQGiCjanull0NYJYnBQMRlxty3O1imaQzi99JScPiL44zN2x2ZBntJDqicF0lciZFLhyHq5N7U7Wb35lWhaSevRGNn292JuY8Df+kBEms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8149.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sat, 1 Apr
 2023 19:12:21 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 19:12:18 +0000
Date:   Sat, 1 Apr 2023 22:12:15 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Max Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401191215.tvveoi3lkawgg6g4@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331111041.0dc5327c@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331111041.0dc5327c@kernel.org>
X-ClientProxiedBy: VI1P190CA0040.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f004227-b906-4ee2-38f4-08db32e50318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmGVKibzl7YgB4WNYet1deHXjEYSjcR77J52B8XfhfhjrI1Oz0RrFIWbJfylge3L1/SE0DYSH4ts9uJk5P4NMC0VQrtEOtWOtFlk07ctXzoIF4fmpq4BbxJJGlR9yDmMmKYbrG0PwbOQHkhGcVZjxzVAgYj0UAKlkE785AnhtiRdUuw4unTNocuLmdSPwRPOcqmyHj2/ERvv/52EV+OGGcfPoLXjirFEhKmCuEoQJPWSwMhr/uurbJP9f1gLIs586jZkW0i4M9Bg9bqN37WkhqyRC7mIKifo0AHcDTuuog2xkbzjIIL+BefL8zc07T0EolOTMIWkQ4lfQVBt4TrKYnctinsv1zjCld0jBZXmf35JT6moBJfQm0FgdcAi7WUAcnxylcuShcdaFQLhwSwpEY4oqqwUnZQxX9dsB2v4GaU1sl5A9j+BxrJ7rWmut9MBqUx0HJQl/a3eWtfg8yOo1BkfbhxUGqUvMQSz3as/M0+fcUCn9WH4rfz3g5583FAZS2jdqgRJlpzjEhH7JOOjfYssv6ky0YVs+HenluPWPOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(4326008)(8676002)(6916009)(6486002)(66556008)(966005)(66476007)(66946007)(316002)(478600001)(5660300002)(33716001)(8936002)(41300700001)(44832011)(2906002)(86362001)(38100700002)(186003)(26005)(6506007)(6666004)(6512007)(9686003)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pu9ic8RPoFWduFik27Mj2adjwy0ZeR0ztJIZf2yR6QyUjUbdgg2CeItoGDTI?=
 =?us-ascii?Q?WOpBZvpta1oBXWDhsLlSslUnlHPmUIsWJdkbatLOUo5AJ+kIaEotBpm+GoCt?=
 =?us-ascii?Q?qD/Kgo9jNddYfwyxCzFesad7WBIYzMb7jZ3h2vZU/TDZZ3BPFiQNpOzwBc8e?=
 =?us-ascii?Q?1oWNEEIqDUmXMDGgFPODeLkH/WH8mfUHDrMacrWlV7bObwQdneDZr46PpDpT?=
 =?us-ascii?Q?InqManUkt0nJfJIQkRcrz1gkepz6LsVRTQJAuLdaMnrTYvYw/4ue6eHmgvx8?=
 =?us-ascii?Q?LoY4SubJYhcAUH3p5jVVb3TLUNwsX78QtzZk8scLm1H1WPdmf1+KI0WwaZCO?=
 =?us-ascii?Q?KIC22n9gQlw9BBrTVcXmdAOFtQenIgijLjvyvifeFzX8T7S/Vtq4k6YQ8mQr?=
 =?us-ascii?Q?7bqq5WGeHixljnfQDZLyW/l1TvFsUabSRgZNpY8PoWprfrX8Yg5ci3wr6Ww+?=
 =?us-ascii?Q?VSVDEdC8ZDAeCZrWJXKJmybmig/3l1Zs2iiCEfvz7vHjV6kBlaQpKWl23Boz?=
 =?us-ascii?Q?k/15Cttee0TrIxtBxrja/ZKRSqPD3XgvqNl0nKsGYg95lq/lJ9q19DeGGR4+?=
 =?us-ascii?Q?tuH+2gp7q6lvvtFmQiDnc6Esj/Vxf+dUMDYxEcAcvj5OoPJQAQHXWTKLOnKc?=
 =?us-ascii?Q?KEjaFedAW4XzjEbhOQjVFA8R+ZYOP8OvIJZuybkemGVdS6oYuqQDOTla6AE3?=
 =?us-ascii?Q?GsiuKFp8VDIgMIEujnv2Ml5lCXfNS5zA7oobx7oPrjXy7/iiH0HygxFDFjcT?=
 =?us-ascii?Q?ZPpl8tKRb2topBVyVf0GyjGwipsqJh0SeDW2Dxw0dN1CPC3ifzsplUk2jkPg?=
 =?us-ascii?Q?/0c8jaB97WCvqiVo6UiDevbgln9G1uFf1qOYvgarr+ULKKlqzvNs28FhtoeM?=
 =?us-ascii?Q?qG1OjVZhn80mrhyNbQUNZ2HbeKP0RBu0Inpyf7wFXHAdIvQ40LxQE1xgTzyO?=
 =?us-ascii?Q?v0xvceWzmtk+hv+9xtWQCLgGnRYjAwIPq/eYOMuIsCGbaNUM54fw7pvpswC3?=
 =?us-ascii?Q?07nJYjXWEKL6qpLszEf7XWiliioYkCLa3Gb6b7vCOB7+sgx9K6G2GYqbkQWV?=
 =?us-ascii?Q?ZUDyQl2HBJN7Sl1eWhZYotxcxarVJYAyPkf9N5O0O7UApwiYmCFyhv7JSikk?=
 =?us-ascii?Q?uwoGAuCmbiV4E/8I6r8t1ZgIRyjT0kjVNO2Jv/NQZeICuN03gsBnyx7O4ppf?=
 =?us-ascii?Q?F2aP6Ye2psBAtUyF/xBF4aFD5RtSaekLVuWaI84NxE2oNkdqARMnLY+IMfhB?=
 =?us-ascii?Q?i3iTDVKi2CYsESUqfe9kQ1mGr+XGkqmyGCzpk/99/AUfvDKiHMm0tqyS2EH0?=
 =?us-ascii?Q?3nGykaOzs9CfP2nBj+ZEtDXn735a7hZ2kl+uiRSHE9oid/Y7CMNbwf/t2liU?=
 =?us-ascii?Q?zIvnCi69BjhGnQns24mgWCBBMp3ZQKOXdEwOfJbZgWbgZaf/GirrBY7y6P88?=
 =?us-ascii?Q?B2ZA5m0hRHbmIZC90JYDo7RGe+9GAMkqaThdMXQ+0ika4E1iGNLcsF2kOnKL?=
 =?us-ascii?Q?ivlV+cDeWXl0JRt574IU8FCPqPHuZ1LJTwK8UAShGAAUdXlGWGlE4sWdewxy?=
 =?us-ascii?Q?yXZw7StOM1l0Hqh0QD2EaOg1rbZj0gmussDYV7hDeJgMLYnHVvn6vmfkQwij?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f004227-b906-4ee2-38f4-08db32e50318
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 19:12:18.6105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7QL7z37ImmlUFiW5EMQGpdzOq215gEFojfD/LrmdljSaD50hnqdnSZLeuga4HLau+uoOcSpUqU5BN1i66g6TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8149
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 11:10:41AM -0700, Jakub Kicinski wrote:
> > We still will need a version of net_hwtstamp_validate(struct ifreq *ifr)
> > to do validation for drivers not implementing ndo_hwtstamp_set().
> > Also we'll need to implement validation for dsa_ndo_eth_ioctl() which
> > usually has an empty implementation, but can do something
> > meaningful depending on kernel configuration if I understand
> > it correctly. I'm not sure where to insert the validation code for
> > the DSA code path, would greatly appreciate some advice here.
> 
> You can copy from user space onto stack at the start of the new
> dev_set_hwtstamp(), make validation run on the already-copied
> version, and then either proceed to call the NDO with the on-stack
> config which was validated or the legacy and DSA path with ifr.

Actually, and here is the problem, DSA will want to see the timestamping
request with the new code path too, not just with the legacy one.
But, in this form, the dsa_ndo_eth_ioctl() -> dsa_master_ioctl() code
path wants to do one of two things: it either denies the configuration,
or passes it further, unchanged, to the master's netdev_ops->ndo_eth_ioctl().

By being written around the legacy ndo_eth_ioctl(), dsa_ndo_eth_ioctl()
places a requirement which conflicts with any attempt to convert any
kernel driver to the new API, because basically any net device can serve
as a DSA master, and simply put, DSA wants to see timestamping requests
to the DSA master, old or new API.

The only "useful" piece of logic from dsa_master_ioctl() is to deny the
hwtstamp_set operation in some cases, so it's clear that it's useless
for dsa_master_ioctl() to have to call the master's netdev_ops->ndo_eth_ioctl()
when dev_eth_ioctl() already would have done it anyway.

I can make dsa_ndo_eth_ioctl() disappear and replace it with a netdev
notifier as per this patch:
https://lore.kernel.org/netdev/20220317225035.3475538-1-vladimir.oltean@nxp.com/

My understanding of Jakub's objection is that the scope of the
NETDEV_ETH_IOCTL is too wide, and as such, it would need to change to
something like NETDEV_HWTSTAMP_SET. I can make that change if that is
the only objection, and resubmit that as preparation work for the
ndo_hwtstamp_set() effort.
