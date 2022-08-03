Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A73E588A2B
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 12:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiHCKMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiHCKMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 06:12:51 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5C41EAF0
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 03:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRvFVPyYpyLWKGQRSN/PrYcueEbMOpbU2GSvhio0Za1OBbI7V0a0YfJzQaK8nsSx2W6+RrNCZ56Vrt+8w86NSjDXL62VmGDkMq6o2gTVVUlSB8JSj9oMIr5TYC/Q4MZlFkXG18LXPggRgj9Fd0UBuWls0oivc3JGQhL0GWqchrDnzABY6X7CftEq9rrWskjN3Z/G0IJnmj7Bj8s+s7lMY9dKLX34+TD6wBmjEqqirTa9r4xnRru7Jw3J/0Pd7DcK+9gsPOurlMPTm9Fqk8vG8qpBKpy4VWKa43zqBHqmfyzyHbibhCFRplIvrSqZLtT/jvK7En7Hu3UtNUpU+yJ5gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBAgOwZ8Ayv1mYu+wI0b9b5zo6jFQOXFV5HT8kCPmvY=;
 b=cWzD3dX6NVtgPYLixHp2+2UgyKI63snuY+SmVEz+JCc9KCa//PaScnYePh6lEYr4XteWJ7hPBMueE0YU2HawYYeRCHAxhiZxx8VY6mDf0y8NfSdGI6kzbKU0Z/ka3R73gmzQTppMDJMeJRkUG4wxheuyEWSKJh3t9hF9LX2IOZAHAL+rLnGX7J6rtas3DKyjGHm4X/KPLM4B+irJh+JOvq9MMNkVvcAOFqp7JVcERVp9xYEk1ghneaYW3m3h+MnP4SvalxVy6lyMVZ7oHMnQm9JyEoDTZ7d0QFyxhOo6YT31DchIn9II6YaY9mwtMxPFL/XKOoiVGjJ/pvxlqxJa+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBAgOwZ8Ayv1mYu+wI0b9b5zo6jFQOXFV5HT8kCPmvY=;
 b=uebMPHkX5YkeZIcNs6E4Om77n5Ta69AP/W1yUs1Z4Pra4H6DhyxwggBylyiqIAkhS4foNZUNcUPsFHSogEmbYSBPjDNmHFacgGAiFc5LkmdR2Ox2G2oqQS+NWSzYQjY563Igm1yUOr/AuEaXdI+w2SGHT0WMp6JuGTSy4B51no+eu3kZlX2SpRRf0jR+tXkj/2H94RoWYREfBJMefJw4ORpLYVSdtP4VWwtOzhLyC72TXIO97vA/yk7xgLHy3nqiCTjvRPT/jl7/bgLG90imraEBP1MAag6cLMotwOKf27bi2VBkrRG7Ca1r2iM0mK2tnQyj4DuQZaUlmuW9NiSMOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by DM6PR12MB2618.namprd12.prod.outlook.com (2603:10b6:5:49::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Wed, 3 Aug
 2022 10:12:48 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09%5]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 10:12:48 +0000
Date:   Wed, 3 Aug 2022 12:12:45 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org, kuba@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH iproute2-next v5 2/2] devlink: add support for running
 selftests
Message-ID: <YupKHSDx+7Q4K4Qj@nanopsycho>
References: <20220803091025.30800-1-vikas.gupta@broadcom.com>
 <20220803091025.30800-3-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803091025.30800-3-vikas.gupta@broadcom.com>
X-ClientProxiedBy: FR3P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::12) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5eb1242d-a01a-4193-e167-08da7538b7a7
X-MS-TrafficTypeDiagnostic: DM6PR12MB2618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSSR8xuLSR+Qi+KUJhSaw54EF4R4GHkAd0KpT+Kk+v1jEdw7Z2omteSi44G6VeBILgM3sJV0Qwg7HXEmNel29C+j2GFYrqgw7Tz5WfNDlxJQaRJHchL4xz+dZm0OCIA02keD3irrA6qPDN4sDCWBGzQRELTfRbr/Qg5IBfv8Rb43oTMw/KVHhP/Y1v3+/PqX3ntTg7t1qDRDVGo2dZiS3JC79FAj9GV8sAYlGYo5RgC+gp0XypxRiayf18Xp323IjrZA/ZYKgkXLlRqWM7rwzi0j1NdOxbCM3BMw1OHhYi7SVo4HJKTHFQuyJjHFj7jo6POwvl6ZJECGe7ouWPBugS+/hAvCWlj6NcHnGgkzKfVO+bVAQP5041gVb1xYXd6g5FXxh8tz0ASXgfqaXjpmr2893J425IX5js4ajOn3+YcV5EbWM1Sj8erFoU6UeY6dOORn8bVeVzv/yCJuCEZlIWllsqA2Xfx7Gtjm5BEChiB2ugPDLWaxvGHRUR4d3x+AdW1valNjIQb4+0Nfkl47Tu3IXn/1EOImsRjWr7ArvkE1+qaUd8HM0Je0kt64OcXSedwuupMcSLAku+Qt3SOJFVA9LL66AMa12B7T0Vi2CvgVZiOU71659rMAjJyptJLTkqC+EZtBR6OlUp7anSoo2PN/rgljoDaYGOqTJNl2cZdojO3mXV7rf6Cp9iUPJuRy0OnTO7UFzqkgTZb+rTbvedQ4FCUu7pIXxWBArHtrb0LWczyIjQBdBFAGgN9Jh6hlNL9devKJ/tgv5Iq7VmHZob+sNKjjig3ZZWXAgEiA1xU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(4744005)(5660300002)(8936002)(2906002)(66476007)(66556008)(8676002)(4326008)(86362001)(38100700002)(66946007)(478600001)(83380400001)(6486002)(6666004)(41300700001)(26005)(6506007)(9686003)(6512007)(316002)(6916009)(33716001)(186003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NIXezZzaHfz7WjKMqT3OcS1XynynscqIoN06AwWrqnEJkC9B5Ovz4/9kNZAa?=
 =?us-ascii?Q?rcsZUSNQbGH4y0cDWFJrG77yTivJ/nz4gCbxR3SDPysSpTCrLwtfzlLBmdE3?=
 =?us-ascii?Q?dDZvKZcyTBvx4d6TQU5fGx7JqX98DvSKqt55T/BHBGd74T/OS3k/8jpEdA/M?=
 =?us-ascii?Q?Or0NyjoGbp/m2pEOtjcV56yJnD9hmBLsDbxDp99bf3Eaal0IATB4JjCBaYL3?=
 =?us-ascii?Q?QdOunKZA5yprNtOqu/3/SFCOXWDCGs8OM+QEDM+E7/ffDlSNZH+/RgzVhJVx?=
 =?us-ascii?Q?65/mNjK40FTEDVo9JMu/VAQSvorNqn/YwJrndXNYKO0aUeYghBVExNKuFGwk?=
 =?us-ascii?Q?O+5fGVNvQKbIB2AR8Xbs1THYmNAFTX1c9EvvhGOdf+yhrEf/+fPJeq7m0t0x?=
 =?us-ascii?Q?3mRqNnsrmZReCfQvjj1T4AWVWT5VVGHCT1a51I82DBZa7o3CB7BQG+ZXx9Er?=
 =?us-ascii?Q?vsxrHszdGj8gq610fqUWPYxyMy0bKx2LUVFGIqmeMvkC8/Mtn2pR3FGSOuUr?=
 =?us-ascii?Q?Qp+F7U6DHRlPKIxG3LqE4kkyfo5lnfg3Ql9nMtoQwzYiv7MP7usUZ/6EVfwq?=
 =?us-ascii?Q?94NOnMRJzyNv4RZsfjEbeZ6bxONN6XcrBlyoeXz/krh3IFXXeCggJAOJBHGK?=
 =?us-ascii?Q?gE1ZaUGh1Om57vDas2xlLmrOKXtRiPsZ/bXrz4UEWP2+hqZRSzHmD2CGK8SB?=
 =?us-ascii?Q?Ms6+zs00SYJyWfmB38L2tNXUkdtIMAIs3hMonlrmW1n/nyk+mvkEIzzpxAsp?=
 =?us-ascii?Q?v2jYb2BdFK9DDsHLnb2N6immp7iDn4s9KLIM2DvIqDT6TpSqOOTUFDAfRm7P?=
 =?us-ascii?Q?4t4aWOMA2xChyoSo8qlB3QKYqsaYweuacep5gNUYPP6HvsO2vEjJU0aSrYZk?=
 =?us-ascii?Q?SVtJPm/etldGgFsVexLgO8mFBmcnahOLMfMjOiHs3uw9ro+TEG3xdlkw9/R6?=
 =?us-ascii?Q?3W69ANTKSp/FDxwNmiOvXp/glsxysyN8LNubZZnsmMM2O1GExfAFGZqdlDPa?=
 =?us-ascii?Q?PESbdayU0L4AamY/k45tOCHs1jEzsOsHaF8KN+ybTC48bB5tIdJY4+qIkMu+?=
 =?us-ascii?Q?K7oS62XVMXd6Z1RVvt/y8RrOgalaB/pz778IJIrci+oM9gXa1N74hpDB8eSM?=
 =?us-ascii?Q?/kgF34C8fgvQWgWQP60EsDnMSRz+JBYsbmW8Bs97CWOSM4qet8CyDy0TMXr9?=
 =?us-ascii?Q?iEsJw/j2U/SzgrK9m0hkDoG3qb6pdra4Te01xjBfXR1dXPwlL72wMCKa6UHt?=
 =?us-ascii?Q?bbfTMmS9LxhOn1h3QHqybw4H4jCqglJp37nbQQuZwY4EF0eNRKUyDpBvLL0p?=
 =?us-ascii?Q?fBhuQFj2QPdDB6yDqd1h+ValS3WlNzYLFQ7y+cveRKJnTIuF/pmkeB03k8O7?=
 =?us-ascii?Q?z+woCHBPW2xU9GGczmiJO8hp5bdg6lr56iHIEygmpmnZ6ZHpnuJmY76VrSnW?=
 =?us-ascii?Q?4H4WJAdakYjgwzLi1V9xnueQWdrsAAHcd18H9yCozy56Je/cV6dVf8j5pCX3?=
 =?us-ascii?Q?dUW3G3UinEs012G9W7Yrw7cAKWlA0UCm8EJqiMa/9f8fodYOnPVLWfJQUGGQ?=
 =?us-ascii?Q?wFjfKaF3e5PMD7VHk40=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb1242d-a01a-4193-e167-08da7538b7a7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 10:12:48.7603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyxC2y7QNP4q/UpESzonzGfwGuStBrDYCVceHxz4EeLnrhkhf1k+X61cscnVS0TE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2618
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 03, 2022 at 11:10:25AM CEST, vikas.gupta@broadcom.com wrote:
>Add commands and helper APIs to run selftests.
>Include a selftest id for a non volatile memory i.e. flash.
>Also, update the man page and bash-completion for selftests
>commands.
>
>Examples:
>$ devlink dev selftests run pci/0000:03:00.0 id flash
>pci/0000:03:00.0:
>    flash:
>      status passed
>
>$ devlink dev selftests show pci/0000:03:00.0
>pci/0000:03:00.0
>      flash
>
>$ devlink dev selftests show pci/0000:03:00.0 -j
>{"selftests":{"pci/0000:03:00.0":["flash"]}}
>
>$ devlink dev selftests run pci/0000:03:00.0 id flash -j
>{"selftests":{"pci/0000:03:00.0":{"flash":{"status":"passed"}}}}
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>


Reviewed-by: Jiri Pirko <jiri@nvidia.com>
