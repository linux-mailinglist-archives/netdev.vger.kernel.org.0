Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E069550BF35
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiDVSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiDVR7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:59:23 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2067.outbound.protection.outlook.com [40.107.212.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F61FADB2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqCK7n8ko4HKl+skYRX2Qq6y0XJ7TbbSS6TqpMsqYXyPq6FTyzX32Fz4CRu8uA7KRusfevN5bNViyDRIqRqeKJQcupfzc1GrWXMTJpCTYNcgpQuBcgooaF+fV9SIyyBbsgLddMJJQh/9P9WqPWt7Tb5Q3gGZ4B1IHc3Xn2w4aoIJjjVx1BtTiYoiv9GHQ475nWaSxtSpK2kkMeSK2pVOFo2ipTauhFoPkndNnbSjL/hn4KGRGL5Q6J+ze5uXFyGF0wLAKjfdfZaH/ogV6GkCfyczK9pijERxk10tCH//UJXkgoAR3j83VdRswSNKStDvQJPZTF+JkRZA+n0mPsXcKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OGzgbyOf+yD/KKvN3DTgKgAeuR09Y60yegqSfgS90JI=;
 b=mFN7A9Uodb7AVMZhuWH6lkluXjShKtgmCGCuL/4wcifib3HjrFi3fKNm28CWgKcnm+PBI7MI3R7VFKpQRL/M/ecksCnChLnzB8nHnCcKLUfZ2jNyJFxNHQaSVFdeTa4M7tg6QZxRLFcR8HcW8pw9YOoKOVqnIR2tVWLYrwrV2oJ3ieq2i+Ftc5xVaIhLOHv7R37wcdkUkonZ+1V569miAaj4P2KW+Ow4s5/v9XK7yyPPslAv2vzmuscM1IVXWsnLTxiMcYiZNs31Ps/pONGOvvs7PP0FsnaUGLYsFn2eYhZMDkKNIfGm+jWu5geYl1H5AOBzA/t7QRa0LdDLzSn3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGzgbyOf+yD/KKvN3DTgKgAeuR09Y60yegqSfgS90JI=;
 b=Bhbi3GGzeY1Tht7y/Ql59cH5Py5xeIvvnWcg372DG7GFQ6Efkmi+lnOcuaYhZ63v+x6ofXY6Lx3gXivO8h6bYJGTpjCucMZEbjdC4xEnPqgNS0Ev3SmUFHy1j/Wo2kCVHcpndPWIvh1Bj49CzkdIbZzWZFKkSwmSq5grkcu6vF/Tzo3nWuxvTTQsvcxpCQbrPNI/tYrLUOYhvjKn/Z8Tx0cdJFVMI4sAga0qFgezSN04hYUFcr+pPY+0DGMmcWluHBXG3GVcHgsA8ummQMJrBYQPhaxjlOSiBi3Pe0jObSNitWMOkY3V94hR5spEMd6erYzIORCmsHj7Ka3dJEThrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB3582.namprd12.prod.outlook.com (2603:10b6:208:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 17:55:54 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 17:55:53 +0000
Date:   Fri, 22 Apr 2022 10:55:52 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 00/17] Extra IPsec cleanup
Message-ID: <20220422175552.iyqdmpgjfrfjm7qj@sx1>
References: <cover.1650363043.git.leonro@nvidia.com>
 <YmLqpn6v/HIipias@unreal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YmLqpn6v/HIipias@unreal>
X-ClientProxiedBy: BYAPR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:a03:117::33) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c8ca306-a930-495b-0cba-08da2489584d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3582:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3582C07506976B6EA46373FAB3F79@MN2PR12MB3582.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qz7gsBRxbVtqRXdOD1RS9tN9UwzJ2psnDAIbo0AaQ/WX1khmmuBK+KfNZ+j03xRaruhuur1T5r9Z8D5iKPWcgo961zR7w4Js0hJHNTJN29AZCP17iZz44+ZsXNt2PPg6EslZ7TQzN8XnqB6ihqZnqz1oeT+IvgPbLeiSQ9IEOAT8Gqgo12Y0gCdiW86YTU/WlHSbCjr0u5SX+nf9w6JF486rVra05klDzcQQME3rwqasc+eKOq97c/+qeES3k3BQIENVSdCgpt17nFOxp+IImUF/w+GR+WEIOXL6HrUkNfmhBZRpqBhV94mPtgb6Xi+HGsFKrtz7WiVLh/SzmloPb9S41JbwnmFCQmV4l8e/elFyFI8RvBcvWmvWD2EpnhvVK6lJsbKpHageMfyNlJJgv+T4xCfg7s4Yp2wyJmhwksYPm9c56dJkGV256DGZZ9K36XJaCUT4JoqDSyE8N458Q8nrsVycK1MoOkX1c4LDLhpwX/oOF40DoEEb4zDqNo+GDr3fBcoJrgBDgwUEcwi7dtgZV/dN7CrShgIcGukOcs1MDbVVn1aSnOcJOVXqK8bTnGbMUlofVKSToP9UildlShFfIN3ecBmjgJoXCO7H0kc/LfcAuJR8g+wntehbxWbXExwjlh3j5nW9+4cuX8mDaYqHJ4tEdw9S89NMPmKprXFYxTsRqkswqA3z9X1RbAd2i1+n05sffOk4tiCUxqinrsAPqxAX3CVBBya4hPiqCfM1f4mRq1T0QjIHpkPBByyivi5+lLXnQCTzglUjkYWN4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66946007)(66476007)(38100700002)(186003)(6636002)(8676002)(4326008)(6862004)(508600001)(66556008)(33716001)(83380400001)(86362001)(107886003)(1076003)(316002)(5660300002)(2906002)(6512007)(9686003)(966005)(6486002)(54906003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uW70dt3D4sf3G1OmT2jUzw447Sb/rH+AbsttDVHMgm5OqIbZoJfC3m767xoV?=
 =?us-ascii?Q?aIZrW3tcUBuK2fQpVZtO5TJo0QUC6+LXe/RxnL5pAlm36qVWIEcq/ls1Njl/?=
 =?us-ascii?Q?wrnftlsW/+qY0Hoe7AlWXWTxnbKIoLbhTrCNsWzbPUluWgMD6zHuR0kKeKne?=
 =?us-ascii?Q?zm5lJI0IULOp9wJvmri5+Iz8qonowMTkS+B8butNG7tDleKrfdocT6dEWtb4?=
 =?us-ascii?Q?BuONH9i3bZX7jfUdwNf8d46s7K/VbW7tF4gYBXyI/OlSbGR4JN1+UUs0Mib2?=
 =?us-ascii?Q?afBnP5+as38/hVbm5ClplUPh8dLgOtpzCTOI7EzUe4sBZ1UKD28MJM4RNwn7?=
 =?us-ascii?Q?REAPyBzwUD1/MbTv931t9ze6bO+NtGP3QEaxIeHXVzsng6Tlk3gByzo6ZBr5?=
 =?us-ascii?Q?MsavkDse4TOjOCrabcYde6doQuuJURGMiYVd5CRPdNhueriGaOIMmtEDLV2p?=
 =?us-ascii?Q?P2D9Z3h3H/5u1xNDrHj8drYuGlLrJTrIsuR1gIZ83um2ynRSNzPtPNzTSW5Y?=
 =?us-ascii?Q?Z+wfQ6P8TQWIA8G6tjlolj7oJFYcUhwnQV289Ckb1/UCDQ905JgDtLtiJmRC?=
 =?us-ascii?Q?ifwzAkS/G6wz6UR9gPhGtbsbrItqsMA2JRjh04HQ6I9D4fOSAMX+tiOHkK6h?=
 =?us-ascii?Q?A521ixsgj3NZv3a3q03YRAz3LcC9l1TeIJ4S0HsYcJsth4vVJJNZuY8dbcU+?=
 =?us-ascii?Q?RHcu2ieVHpsOiRux6XVn1Gs4lEsvyFJo4WyqmokjO0qtNT8qMeNgLbZj7vtu?=
 =?us-ascii?Q?yF4TOGgDTpL3u6HWTRtWRQwt06bvV9TsJ+c8wS9Rlyb9gLqHa5IY+gaVoD4F?=
 =?us-ascii?Q?lFtWVrXK6Az+eMfWEjRHSHvtA32HrTDPZ3G9YLe/1b2cfXvySV9W1faaygWk?=
 =?us-ascii?Q?s8U/RsQXHTWClrb/9GCBTn684ybI4cVH1IIwA4yc/hmVkUE0DNILcLpQXL69?=
 =?us-ascii?Q?BK7tQeT2GhCuDOf1r5NwJCI1cF/xY5xnxxzA64Qo4LvOgOlQJoy17zVaJHta?=
 =?us-ascii?Q?6FWkL7B63zRUvzk9USoHzaMvLM9mbcnCqTQJsy4wkdTImeX0h3fXc9RrELLo?=
 =?us-ascii?Q?WaaXubqBu0ktFdTKAxBkvERabezmjaFwJFMPOWet77lu5mRR0lGKnhlwKWQA?=
 =?us-ascii?Q?RF2EClJqqJVK0NzDwuNIHbmtCs0+ObCN5zbXHIdVgv3tN4w23jOzuHGlXK6z?=
 =?us-ascii?Q?aAyEaZolSrZGif+hw+tpzlWVtRN5iVM+0UNVVPvBmip64MDUI2oJCSYTVm2n?=
 =?us-ascii?Q?rjlthGg9UNAKYyVbyxo5KG3nLmjM1fOyg7T+CNwGA100vpBgKhkNtoYtZQOg?=
 =?us-ascii?Q?FRGlxn8fNHQhyvWldKYzfQIqUH/docGhIvwHGlvSCBvZ6E+0VFZOA7qBfL+X?=
 =?us-ascii?Q?6Yws7HBTprOrbcEnQGdegMdUOL6ZPjRoR8Gd13jhPzfidQxPgXqLrhiF/F2G?=
 =?us-ascii?Q?QVfKc1zU/+pH0tKznDk4q66fszbgXQgBaVNTgWHRGdogdpZjNg5gxiz+8Gyv?=
 =?us-ascii?Q?hpoZ+VbzwI/8hniB+KqDd1VuAYR0vM4ISzeR62Bzy0mf0UUyG3PxrqAg0GRX?=
 =?us-ascii?Q?1rD9G5ZBjiPdwuIdgmNlnmUM+84U1UKXuATTJHPh/yRq5BPPCq/Jfr4P23FW?=
 =?us-ascii?Q?TQ973drU8YZBSPTQ+bDvJqCEB+q2hbv5/7RSnKKQAcbxvWkXlfQKUeN4Drh3?=
 =?us-ascii?Q?loiTwjP9KCp1umDdJEmnmtIKX5PpxvG6pXQxauCr/KoTRU0nC3sSlFbignDR?=
 =?us-ascii?Q?rsfJDQ/E5HfIv/KeQWTUn0KUKagmRFg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8ca306-a930-495b-0cba-08da2489584d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:55:53.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agUUo7M2gB0dmXCTnEMUXOHd44UDQ39z7c9DSvsBAKrvDCBMhg8YLGFrdUL454CLIMjMhrAMTZ0cIo659PG/sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3582
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Apr 20:49, Leon Romanovsky wrote:
>On Tue, Apr 19, 2022 at 01:13:36PM +0300, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> Changelog:
>> v1:
>>  * changed target from mlx5-next to net-next.
>>  * Improved commit message in patch #1
>>  * Left function names intact, with _accel_ word in it.
>> v0: https://lore.kernel.org/all/cover.1649578827.git.leonro@nvidia.com
>>
>> --------------------
>> After FPGA IPsec removal, we can go further and make sure that flow
>> steering logic is aligned to mlx5_core standard together with deep
>> cleaning of whole IPsec path.
>>
>> Thanks
>
>Hi,
>
>I see that this series is marked as "Awaiting Upstream" in patchworks.
>https://patchwork.kernel.org/project/netdevbpf/list/?series=633295&state=*
>What does it mean? Can you please apply it directly to the netdev tree?

It's waiting for me to apply to net-next-mlx5, Please give me a chance to
review and apply, i just got back from a long time off and i have a long
backlog, i will provide feedback/apply by end of day.

Thanks,
Saeed.

