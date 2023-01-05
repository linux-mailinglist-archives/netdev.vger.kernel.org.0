Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BFB65EA4D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjAEMCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjAEMCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:02:11 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2113.outbound.protection.outlook.com [40.107.243.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434EC559CA;
        Thu,  5 Jan 2023 04:02:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1FGe/l/7ISr2/7zQMAEcZZek6V5tQyRxH41jNxLW092nffmm4p7tA8nj/tnrR9AJyw1iO7CrLbIuc4Urn8yMyctmESvodU4GMWMxhSaRfeOYzWu+h55liz8sLgn+UHR5VKyfQmyCMnxfRH4pIIarOZ+mA20QZOr22xlLc8veOXa3pMgSVE0F+Hw2iMn360VUj2ioxO2Ne9/YXKDbiK1XqWYMShY3botbPVKra7j8cHFE+fyB6slTac+RosVrZX8r/I30Nj5N/uoywkQ9lBnSQcpDvoXxmWW1Df/d7j6oPfxngHFx6upvSE+rZv5PR5I/PlPSNsh/VcgZTjXQCV8rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0u8AGfw1luMnkIJZhnEOh6KdICin9MAZ9lNMgS5ylTE=;
 b=l2VA8gmDC0F8cyhKAkWyH8GuaJpGtpyQmrLxT6MMcWAadUEf4RjFGf/vVrRXbnC6deQY1/bC8UjK+pvuPViY7T1i0HivJ4eAhgnesxTAWDN5FFBRyfSGCvl0QdMfVsMPzbnLrmnxEfiskyRd56sgSmOq5KasW2AfQ73vbyGq6AsaR1cY/fO7bkjiBpwbAE1srXdBbex0P7WjANrhXyd586GOB+oF4flhVYzZLQ0ZS5ziIvTR6hlm2T+O1q2ahZB3dFFyfirqY56rJi12Q3XmlwsG5Jz1uUy1G7sLQTr+0i/KEHt56X7XbO8MdsrxJbDUFkF9+T0KntnWTmkYtzpB4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0u8AGfw1luMnkIJZhnEOh6KdICin9MAZ9lNMgS5ylTE=;
 b=Dl9BItK2vL7sM9qfi/NR+LozCjZsF+N2FIgaUXRzeahTp6psuNdxPTV2Ozy/44qUpGtxiigiVVA4TR1XCTd9U/tF3A8dM+eLDVzJ6zoSB7nzSGcMkohDvBkU6zBAUJh1brOxNFWzLX6COP4K510tltWq/hO1e+Hd3T5itcmS1Ks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4969.namprd13.prod.outlook.com (2603:10b6:510:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 12:02:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 12:02:09 +0000
Date:   Thu, 5 Jan 2023 13:02:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Xuezhi Zhang <zhangxuezhi3@gmail.com>, zhangxuezhi1@coolpad.com,
        wintera@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/qeth: convert sysfs snprintf to sysfs_emit
Message-ID: <Y7a8OaOnQtRmGLIu@corigine.com>
References: <20221227110352.1436120-1-zhangxuezhi3@gmail.com>
 <167223001583.30539.3371420401703338150.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167223001583.30539.3371420401703338150.git-patchwork-notify@kernel.org>
X-ClientProxiedBy: AM9P250CA0010.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4969:EE_
X-MS-Office365-Filtering-Correlation-Id: d7b59cd5-b979-4e07-7006-08daef14abf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syZM1ezfOA6wu4Zm5C5rUpNpg0ub0MDgCrik9gG4j1e0tn7K/QvRQ1wnHFiUzN4RVfh39J1WnAYN3hRIiW1iwK3vq24EU02l+REwIzfz+fCHEhIa5fZvqwg8dMul5dGCrSh+ZG+r4FMjK2GA7+o06BoV9RYH8xsEK8SQBMrgrlSqKdQB5zl8ZUi8bpzMlzCm9BUgOemWR4glUhHp4O0gP3N6lf4t/I7uKNhI+3glZwHd5E6ueBIUuFpx95PMR4rCZJNM2Gdci11J9QKRNiYPdDEDczgUS08Sp6UANt3I/tBbDAi1S0aXFeo67adv2AzfxNuX8lht7RyqYiXs8KPnd3zYXoO6EABtVRTe40wgqXsV09E7hu/dKNdvyLDWiNP9KlODrnOCtWUnlj2iWgy7omFMfBCc4/SnYFWX4IEvBb0wy0wqcbZ+U9kp4iEb3Vws4YMiOEr/bdsoGD0YvO1Ek3Srgm3apWXvQTX2D0a7SOKoX6VIIuII+4mNPSjEOfcEeEiz6NszKnS2jhABv5YXKH/hMF5/0L+b54fcr8gd0QjxvNEm61Ow7lOyVlMeyZ6372BYCzoO0TAg6R2xfO7qA4y5NzXp68c+zbeo0Wb+dQLRpsPPQbJtAm8grD3u7UsvVvZ6XcB0YU23gRmLzZnBNpDgfOmW0MIiWyqxrHC3FrS71Ov1VG2xV52fKwRlQ87/Z431mP99e1Yh9jYPwkHaLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(451199015)(8676002)(36756003)(4744005)(44832011)(5660300002)(8936002)(2906002)(7416002)(38100700002)(41300700001)(83380400001)(86362001)(6486002)(966005)(66946007)(66556008)(478600001)(6506007)(6666004)(6512007)(4326008)(186003)(2616005)(316002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3KeFHtthyyVlPjq2xkP1ZNH01cIkPgnc16iOVB3tmtK94yd/++lQl6Mqitii?=
 =?us-ascii?Q?d4ximrQ6d3Ebq/ZXCeQB+OQXyJ+4kdCgsRhTgDzFTlsVDpexpsBvy/v+LM0s?=
 =?us-ascii?Q?bAo3XgBoifijAeVJUbAYVQrKKUmL1EKhaLqqJ50GsM+up/aQKKgN/zi774fk?=
 =?us-ascii?Q?vNA/Oi3uEys7SIM0kWcC2VK+iiBPcwThxVjQFYSkJUvGonxiysHYCz8eRJC2?=
 =?us-ascii?Q?0vcCez3de9vQKhdTH3zClwYwoYqpRiSn4xdWRd2LwdjdXfjf/WSmmDtLwrU5?=
 =?us-ascii?Q?+vlYHANOQHGTlrJV570nyy9OyW5nRqnT5aJKUWEJ+bboYptGUkso0dNWLSBd?=
 =?us-ascii?Q?Q3f38FNXGIuw0VniV0AZsdOD7ZTBvI7fPnVO1KnF7t7zWlQWWDn4gCMSLs3D?=
 =?us-ascii?Q?FMphaQ7aTNzRTxV5bTtPPkMkq7aaTF3h4m/hCCo5vLmpNDi0ekdiMLSQPVn9?=
 =?us-ascii?Q?fDRjWKpr7pF77NwQH1cbKDZmMoCIYl1eHgp8ztSwhHKkyRi8GpmCkmbnZ1Bt?=
 =?us-ascii?Q?MG9BCLZHnK2tTDo87TMA8OuO3B4A5Vkd/AhNKMfR/a3i+8hDmykTxv2LI2eZ?=
 =?us-ascii?Q?xhRApLkRGuocLAPgKejdo6G5wlW2WYsNIM0YMicTwxU0rRauNt5x7H8V8Zwj?=
 =?us-ascii?Q?WznpmapAetWvpSIG+E4io52lh326TSTu3RF7SVGOsOkqGPvfU+iXC2rCm4mp?=
 =?us-ascii?Q?6biuRifmVWL2zukSeKUvCaSyfbrOwaFao94/Mw3b8HiUFWoJ3tZcO7Uy95q6?=
 =?us-ascii?Q?F52H1LHkqoXrK7aivwaThjA3ram8CtHfCNs3KbyxQDiAYmP7mj8gq78e7k/9?=
 =?us-ascii?Q?CxkKfupQRnkfIpbQKgoNvkKyvsmZvpcthO7gEUR8QlgLldxQ/Hjpyj/9mXoX?=
 =?us-ascii?Q?TlX1rLaqJxNiGoL6eu1y47UE5oWuRF8xsJRg6GMQJytdGJrna0O03yBOOB9t?=
 =?us-ascii?Q?hRBHhmJHM6dwlLGZboGaCs1fQ85B4wbKTc4akEjHYSmfqa9DLZ/1OpAgjKd/?=
 =?us-ascii?Q?0sew+bOw+6t/jzP7H2fF6Sx+Mu2ULEaNe6207IU4ySqRBx+HGiFDSTNQ3kAX?=
 =?us-ascii?Q?7bgFVgcfiC2r1rDg+BM9EnMKYllVEQD/DiGKG4OzU8qi59zkQKQ70WeQVY+D?=
 =?us-ascii?Q?BAEw6UW0fK7Rppff0ma88L56/ItyEZGyRIzKxka9lZNh5aprxTFmuqc2JWzU?=
 =?us-ascii?Q?d4X382/+Egf3Yq5S/yqsWocxBh4LgrDrJInTk/fTKqEmjuxgCpWFUmF6ionT?=
 =?us-ascii?Q?2rmEHrWhhtmYdl30bxxWBNQce2ODmNxTi+7ui0wRWBlATOs+Cy6I03r5hNQJ?=
 =?us-ascii?Q?4yMTc2dPSeyaqdbn7r4NUagbmplmM4oELcZ87KG8/foH5xH7iNxNYRqL0xFA?=
 =?us-ascii?Q?ErANrghjzh+agyYF7TWnpwuPk8oVecFBDXwNirAkipsFwlOY+fpk6FvycQDE?=
 =?us-ascii?Q?xyfgS7pkuc9+4YBjr7LpTngGt2nFNShItS1yP02bYxhgs4rzr9TvqUw4CCjn?=
 =?us-ascii?Q?x/0LKF4sFvV89NFcjboYaiL+ZIuX/NvHzhobfiUon+UGKlDLHTX57QfwmPwW?=
 =?us-ascii?Q?wLsScD7Ex587MIfGPSFZStQYgi8NVeLAFd7t8WaPLNQixuhLC3pUCwutV92Y?=
 =?us-ascii?Q?1LxgiFTvf6aHJrOdJ/4iAbmO8CcXOA02uZ96edBiwRRE6niBu/dfq1GLpokw?=
 =?us-ascii?Q?AZX37g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b59cd5-b979-4e07-7006-08daef14abf4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 12:02:09.1060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yo9uBCJr/vMSUqkkuYFra2Md4MuXAY16TGQYMaJJsw1s/BB3R63EfTKh7T+T03PAnYoLpdCngP5GO/hk32wpKkZcvv27RrALC6O0J7yfNUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4969
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 12:20:15PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Tue, 27 Dec 2022 19:03:52 +0800 you wrote:
> > From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> > 
> > Follow the advice of the Documentation/filesystems/sysfs.rst
> > and show() should only use sysfs_emit() or sysfs_emit_at()
> > when formatting the value to be returned to user space.
> > 
> > Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> > 
> > [...]
> 
> Here is the summary with links:
>   - s390/qeth: convert sysfs snprintf to sysfs_emit
>     https://git.kernel.org/netdev/net/c/c2052189f19b

I'm a little late to the party here, but should the use of sprintf() in
show functions elsewhere in the qeth_core_sys.c also be updated?

