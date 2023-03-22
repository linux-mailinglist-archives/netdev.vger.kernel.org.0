Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7276C4DAC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjCVO3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjCVO3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:29:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2135.outbound.protection.outlook.com [40.107.93.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091005F527
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:29:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIaN/waJSNt5qgzkR5HfL7/uedc46hrVpoLunyVRqazA5nOFnN2SHy6gVS1g5FciwJVJMrL7XS35J7izQibLurhSrpRswoaPM9wcA9q25x56l01f3IKGl7Ic5GEX4Zdx0g7Q/7Mkh3IJU5VBnNRy7giYxag6xicHubrS5byIuVDQMlUjqchlSMiX5c9Fsq6X8C9UaAtpePrg76DyFW8tUeEhWBpWlWKQGozQhqmhA9SldPohpKfPYJJNBw6FJJmETW6tdi+mM6xmX87QPr/UE+41FRSLCK1Hj/O4ymy/CVJUkr7TB5cpCwyDWTRYbK4GrIDOy2jiNq40veDOU6IFEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7tXcoKsw4RGVRmdX/OZ/8RLKp/RxJ72WdUzNDeTBzo=;
 b=NjUQKDtPCFpQoJ9RVS4eKpcf0PpMwGLpeB93kW5thdHHMS3klgnxaEof7aEgumWoNQhIWR0hkDWMycWSu3GUDQHFbe3MZp7CspJTUIpC8pwm9VtO756fZyd+OkeYZrKHqrVGGgcasknaeXW4F+kwTA8tcIjRyvV/mxUeYzIccfD5/IG0Ir48KrbzPULLO5Ai2/TJUdJTfK9cb+Q4o7PM8H2NwfNwvPJKb8HB9boc5K7UHmwujaWFvK2Axr83IS8vRcHzoaamG5d0H58g5DxzyEQsmObOiSQEIkIhXzmcIpqiFjiVeU50mIRl6ZGCXFyjIs9jliaHuLFwm97maPG1ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7tXcoKsw4RGVRmdX/OZ/8RLKp/RxJ72WdUzNDeTBzo=;
 b=nMu7h8ICouD8YGwsB8Yi1mFTRcrElZP74eZPHGrH5IBhuCWM6AsM3GvpLeXM/7rpGCVEqxn/+z/qDpOsNUBqnBJ76o5uRu8yvQjyjeMfvo9Cl6KK+3uXXAyOshKUJfk0HgPgyyAtdaowE7T/cLHjWnCxPL2kIvbux0B1o63PxE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3738.namprd13.prod.outlook.com (2603:10b6:5:245::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 14:29:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 14:29:27 +0000
Date:   Wed, 22 Mar 2023 15:29:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Message-ID: <ZBsQwVODyLg+x96e@corigine.com>
References: <20230321133609.49591-1-nbd@nbd.name>
 <ZBsK46vmNtjxJZH6@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBsK46vmNtjxJZH6@corigine.com>
X-ClientProxiedBy: AM0P190CA0013.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3738:EE_
X-MS-Office365-Filtering-Correlation-Id: faf34868-2da9-4ab0-6743-08db2ae1d6f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BUn8/sC/D95jA/MgEnHCnob68xp6YxyBw+URS6/J9LiN/jwMb2Q4OtAndRyUB35RB6PpV7D/79GbvyOr9WGv21S6ePVUsMgaabg+GbtbkE7jTefRo2H/qHXjmDoEjEfNideL8JTTN0YzkLaujnB69HRJZSR+7UixzXm4vaSQ5Rb9iavwi8osR+tQBIkdsx4gkA1zjZzj6eTRa4YWQ396DVcHDN414pfRadekmP9uQOk3fK57DkJ8Gf5PhQbeBsJuN5+Jy9pxzzYnPakUeYbFUD4VlbowH0Z4Mi1h1EMtslH8jhnXSIget9kbBTk+kEtqwSNJ8dlWcp/n2ClDRamCCchuKqTSsvB7oY7/zvJAWeVUJ3xsHOimqOLj8i+fXaI9TqT85cPAom0W3eKWLRciLvNywtgfzNMaAmZEOt7g2Q+CUe1Z3tXf2c4J1ITFOiWFancFVnI6WsiK3Igbmu5XReIx3isa1L4jhOcBr1c+RNPggab/zTQ2Lw88W77ydnum0QfMMdZlpEpJBdgbfTy03U/e+JZYgWVcL/5AFLvsNhAf4XVBmZNnoBM/87DPliCvdmrWe139wBcnw9mB/j59CHsHZdN7NXH8L9Av/UfBDTwUy3d/ulI6ewwQdrcrbOvqXnJf5G21nweufOvh8BzB4gtIpuPdJbTqdL7sKFU2tvIXPQkZAS3WrdvesOZpBMv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(136003)(396003)(39840400004)(451199018)(44832011)(4744005)(5660300002)(41300700001)(4326008)(36756003)(86362001)(38100700002)(2906002)(8936002)(6512007)(83380400001)(6506007)(478600001)(6666004)(186003)(6486002)(66476007)(6916009)(66556008)(66946007)(8676002)(2616005)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1oL1IZqLqXFC6fWsOsQHCPo71Xhw5BcoVnUfpqmfEzIIDSdMDsq23tVDDKCI?=
 =?us-ascii?Q?pF25wV1ZoTmZPk5epSxY5RfHZu4j+TPF+TbEa7w0/OgNvJ9Gy25ayos54uuR?=
 =?us-ascii?Q?0KduvGo9z6Vk3KXUa7yv/sxNKYBxfJBdu1DLf7fCp5ZpUssyXht18y1I7e7i?=
 =?us-ascii?Q?vhNgzxcvpUzoxwAvRG+hJRkXqYe/C3O8prtzObdOMhohzxPQpiHK2aTvnggZ?=
 =?us-ascii?Q?0g2x2EeA6uNJaRBBbacKS0AmnldHjGod92D0tYOC+Ly+JkHHPDLmRplXftQ5?=
 =?us-ascii?Q?UIzFOxa79v59eWFQabED9TYSX9MKPzaJ9tqzRXay9f1T8s6cshvmwNqNDeaf?=
 =?us-ascii?Q?ztjuxaJuK9+N2MvV6YldBZiZkIrcIOJw/SCG48rXJUryOIFI9yN8r+bULgp4?=
 =?us-ascii?Q?LEEvzbqt/EY39+yfbhaLxJ0D3cFHbd5MhtyzzBgyfsudtHhe5t+SQevzJo8R?=
 =?us-ascii?Q?6ylJH0txyOJRG7sKMhMmV7JG8nIoIdzflEP0MUGe4UFNwTt5aTATvB/tZBFU?=
 =?us-ascii?Q?V+WC4az9MY2lXJgfv3QgczkNZ7x9wGJfgVsmqgCYZd2J5ObY3hbv+XA+gm8v?=
 =?us-ascii?Q?mjuhkzO9YddqbUFwxn5WE6flO4VJIs9G4+OCu582J9MHZllXfPhkKwdwFzsr?=
 =?us-ascii?Q?aJXzIveriJCs/oIOhvqIOzZ1R9aTYZ9lAuZ4D4LUAfZVRQD3b2DLOdBRIdfk?=
 =?us-ascii?Q?7Ev2sRsWGkPgm6AECKf2NnjJ38IYmpJGQ8bYG69SGN7Akj2l4zh6ciL3/sEU?=
 =?us-ascii?Q?vvbSk/rbsunTzcv91XNqHUNvJK/Ck9KbBA4UfYpL06zeV9fzaoYbGAMxEejX?=
 =?us-ascii?Q?OTGI88OA7aE4n69QMUn3dsKEBYK2RzqvFAWt8OObQtPrLT9rDvlN+uk71aUM?=
 =?us-ascii?Q?V3FTZ+WWTGSwcHkB+HfaC+CYIK/I0+HRE1Byi8Y6gq8qgETYlVppIaUJRj2A?=
 =?us-ascii?Q?lWdcLmM2sZhqcvgFMcuBHY+1BX8fJjVfbevX8uQOd05FjBdpWAKtxjC1qZHI?=
 =?us-ascii?Q?T1jcgJmA/FVnTosFpzvhihxg5tUvnX52z04TruYzYOmCa5R41g6uGjyDZxcX?=
 =?us-ascii?Q?Ja03dWlB1iTZD6kvL8PFzstu6MOPmzJN0KJj+N12neUgO0YVaIMCL2CRlAao?=
 =?us-ascii?Q?cen3Vpn4lrUc4607MfRdDmHq9l6j2otjA3+85/0UVKmQ/d7AxZizRbaWf4+w?=
 =?us-ascii?Q?mUhAxlcxfdxfBEhrtIrRHpHzqSRXJ/veuGSyu0hFkbdK30dc6PPJIJjcVynO?=
 =?us-ascii?Q?eTFwB9ha93g3ROc9yqA0UmSkX69jWMtJwOlpNJeMv4oscKVQckFxo/lq2m8d?=
 =?us-ascii?Q?6dZWh/NivlxR3Ve4ElT1yPVGS+mVM95/4jHMY1p8AlFclvahVVMDcaCckYZG?=
 =?us-ascii?Q?o+lAzhMuhQfRUnXEtp/hfaG+4A6z3dOszJ3QGgyRZzfIbfy9msLGdsr16S+X?=
 =?us-ascii?Q?WKEnl5Pf24YdmrWEGP6tJvdZE8vI0m4P0TRGUcm5qhkN1DvaB2dlQBPEGFDk?=
 =?us-ascii?Q?sZQQyupQ/eVRJe8jMAHrgTycYYg8eXUGTeKxnU/xprS4Yxu+wmvKuDEXEakN?=
 =?us-ascii?Q?/bxZOTDpYf7eGCgTdnbrclEuPfp0gbUM99kRQDCDpnTsnwpUVgKgeNNDCrHI?=
 =?us-ascii?Q?0gddo/ZWuwRQ+5blL+RZ0f1AgGKyhdcaorrOfRliiJ7hu7J59TAjHmYlRyMy?=
 =?us-ascii?Q?9tJuHw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf34868-2da9-4ab0-6743-08db2ae1d6f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 14:29:27.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JgdAb05Fvlfc8dZLk/XNUvmRE4iZGjQCLwbDLATAeTfYkwKsQDUipHs6qoImnKv3pUtKWYS6oaeLImwfhOi20Ds6iCFM7Y9NbV2N2bAT5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3738
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 03:04:19PM +0100, Simon Horman wrote:
> On Tue, Mar 21, 2023 at 02:36:08PM +0100, Felix Fietkau wrote:
> > WED version 2 (on MT7986 and later) can offload flows originating from wireless
> > devices. In order to make that work, ndo_setup_tc needs to be implemented on
> > the netdevs. This adds the required code to offload flows coming in from WED,
> > while keeping track of the incoming wed index used for selecting the correct
> > PPE device.
> >
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> Hi Felix,
> 
> A few nits from my side.
> 
> First, please reformat the patch description to have a maximum of 75 characters
> per line, as suggested by checkpatch.
> 
> ...

One more.

This seems to conflict with:

  [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block

So I guess this series needs to be rebased on that one one at some point.

