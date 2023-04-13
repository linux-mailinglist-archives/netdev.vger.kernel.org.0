Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861326E1782
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjDMWfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjDMWfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:35:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA56AAF0B;
        Thu, 13 Apr 2023 15:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au8SX1Mcz/6krOU8igSAjGEuHS4Gc6a+sGfGwOtnLvG156f38zUTrvjAD8TGq4QIKtvtpgzu8awD35W+MCUlHFNz82K1sWrVCJG8CTEAfFqklvaqcbqNRb9stZb/8muyHGLgt7WLZzO3dHLGprR0/c3f7LguJQESLLG4PLyhNqgizesQcIbpa2EyE+gQtr+ZZviJ9p6LIm+edusogulQdq5kEKG2rb9hsRk8UxbXv0C7PoTElxrIz2SU3ExO6RKOQVa2bx/5YlBlntH0yBT9sqIZ2AwWXcCCoamGcnsBZnAvdMPINuXJS8/DBT5FVC9gp7/dANb/kC5DvJ+g3m9RFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZKmZkVyW2VrdFyKqB/BLqOAWaAjnH4mqalYW2nHPJQ=;
 b=GVfIeZBEqTuPhZ91SMlW73FgO5fcfiqK2IJTruY98KgNoj4gT+KlkE4MZibg/qQJUEpEb+rOLWhBcIdNsR7pAc72yyPcVuPHzUg+VHHUcRZhR5k/HQ7PUpPEGrBaojNP0CdQQf60bkB3KlnXLkk0Rep4cb5NXucGopDq8E+6P/Nl+oYrqa46CzAorkGwleJ+3mA13afJ6VnB4dJvFLYhc88t+vyCTjCuAgilcSQDXb87lpCEJ/Ym2btplXa19H7oUI3EfdfOqMY2ZQpzNAJ/r+t8iKHOe2zIZZumIaZ42g/aW0sl7C96m2mBVKc3u5GOCCl1p84Vh2S2t19sWpgTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZKmZkVyW2VrdFyKqB/BLqOAWaAjnH4mqalYW2nHPJQ=;
 b=LCf3N+TdLdxiLJyrBXb1M55re7l8gsUkpv4Nz+QawJ68LGpAKLIv9jywGQ6RQshyyhHyuo6RWaQQYYbKuOVEGf9IXHtZ6d2lSxC9v7iOrmp77M1W/Tmdw2BbzL5p5Jzt+OpMBp2+qQ5cVpysjTl/VZeLPRnh38RdpoC7lGpABO0q9q/9XY+hXE1Zaa0gt3cWJYrIeXzAiljSdOvTufxxm4OxRrBCFp+0snusilgs7iPj6hY+DWJLOkB4w8QbFMeiZDw6xQqK467aV4SxaaGI7YzTB42PS2TylCqQ//g4GsJiwx51UBN6lZMQb1C5AuzyT96u6cTmIn1ydRQM7S7KCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 MN0PR12MB5954.namprd12.prod.outlook.com (2603:10b6:208:37d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 22:34:23 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78%8]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 22:34:23 +0000
Date:   Thu, 13 Apr 2023 15:34:21 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <ZDiDbQL5ksMwaMeB@x130>
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130>
 <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
 <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal>
 <20230413075421.044d7046@kernel.org>
 <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
 <ZDhwUYpMFvCRf1EC@x130>
 <20230413152150.4b54d6f4@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413152150.4b54d6f4@kernel.org>
X-ClientProxiedBy: BY3PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::31) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|MN0PR12MB5954:EE_
X-MS-Office365-Filtering-Correlation-Id: 10e9c7bc-cc19-41dc-3096-08db3c6f3ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fV1vbK6gIhl+pyOs2MD07y3MFe5HJoZTlNVM3Y2M4IsDCZO7bfhars1zOJMDwui87Dga9x1u7EIrA3OsYOjyTQjPHuJVNv6d8GmY8CM5AuBTG9SqcovA5uByN7N0uD5BF2txCMre4wmwL5vAYRVvyp13njcyvJIJkjgzfERCyxdFyQnWs5vAxRFM+5qjxxJjnA7E6rtV21cj9UN9T/tjpQFOxBDeJ/5MngxKOL8L5eZb3cCSZ3DbEocB434Wq0glX9TdBVLOJJ9PEIPfAarpEdo0NhLE/GJn+CFWY3x+h5cX8s3j1+yPV8NMuqREhGIUlCIcKzUXVtcceLmR21ectWxzeMNXH/jX4EmfZyoQ3RgF5Svp+ntB01vDzP0/ow9JDg8CgilMq7Qs1L1eAL71rjDBYsCzA0zv+2Z6jSdLSmlFG3f3JZ1dEXr5Fky4XtW8/w6jY3e0F1vF7Ukv2d3V9szo8S7uQIwTImwnOQ5fXofl+hjPLjLzZg366b2DatoBUj9mDOd5wTwroMYnpyU+GLQeapezopq0gvE9t5IeU7QodEOCwKcc7fz7TLyu40yo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199021)(478600001)(107886003)(54906003)(6486002)(8936002)(8676002)(86362001)(26005)(9686003)(6506007)(33716001)(6512007)(38100700002)(316002)(66946007)(186003)(41300700001)(66556008)(4326008)(6916009)(66476007)(5660300002)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vTPZ6gc9taB+kSW1RvC1ADPvgNfVCyXaBWdh2QkF8gmCNKQ2yjWMNDVNZPf1?=
 =?us-ascii?Q?vFkiphCSkaO7po/4L+6IW/kU9Wt/76X99MOZMS+AO3KIZ9Klf4PoDHlrXi7K?=
 =?us-ascii?Q?esfESDS2d5HC10JiQMCdXUk4waj6rTR8gd9jrd/XpOTtBgLh2VYulcokLNRs?=
 =?us-ascii?Q?Ig4Ff7nAc/22fD3PpgF7aO+hKKdIqHck2bnz4pirmgOImEyfvWoXI2pxPE8z?=
 =?us-ascii?Q?CBcHysUBnPYeS0yAj8tsQBHyVWNidwVmomuxErlZCWuBqPU/gFppao4iD1il?=
 =?us-ascii?Q?AIZyRzOzoZw9zjWw4UT3h2dqX8h1Hy/hZ3uH9NKHENXEuM3zouxySenYrboE?=
 =?us-ascii?Q?aBSxHQm+oGrcnETwb8iIe1Jelb4ZoTthjbfPfV/Z/2kMU96Chu61yitVP95c?=
 =?us-ascii?Q?Ul2By7+b2teFskcREjIr10WcmSfeWXHjZCU0dG3OmxDYsBO0MCuBs6ywiD2x?=
 =?us-ascii?Q?XNPHoQfBrlzpOvFndq994HatafMwRtEzU2rB+2/Is6pHX/jEeGRqlUviNq9T?=
 =?us-ascii?Q?WHYiN1OO+6lP2CTx/rEM3IR7zy33LGSkeNQEJb4raMyEDegxCEeQmcXpr8bq?=
 =?us-ascii?Q?dZAMm0zLPzGDK6L8JQQv5swNZFq8Lp5MKEHM/U98+ijRqcLffy7AhLamAhm9?=
 =?us-ascii?Q?rdmK35hq3y2pebdZCQDQl3fUvZK/z1Y5TV10CjrhDVttQsH+N4DBJkXHnHKC?=
 =?us-ascii?Q?VOL29Ya8uQVS2ayT5/P878zGd941S1cTJUfJiX44UF9QYsoD9aNdXzm0N5Gz?=
 =?us-ascii?Q?O3v1BLCjDPVOChLM35vGYxTzstC9QTKe5dsMB1odA4g511HX+lSM0eNXBOGG?=
 =?us-ascii?Q?lmA9T1h1UiLAGbZHHObDExx/ZJH3RkhuDg0paXUfnNcigpG6ez/jSz6yk0bh?=
 =?us-ascii?Q?nsprlr1viDPj1JRf8vWGsynYdAngL3ps3V0BlfP89l2a5nvx/qLC57CK+QeN?=
 =?us-ascii?Q?qMknZGXaTLSm/EfuAIPXzjkLShMxaPBZO3S4VOr9CFDEGkxZvuMn3codKBzI?=
 =?us-ascii?Q?RneoT6ImfUqR/ZcVdmVl/wtZ8AdMCjefLWayX9MNidDt8BZCLBw81vTQQnKM?=
 =?us-ascii?Q?xwSO1jdFZTVti9qPWOvsP/Uu/tX5YhFtnu6GxYhmcNLChecxk5MMgiEkJWMw?=
 =?us-ascii?Q?EWtPxAwqo9bB3clHDBeHaAg2zYIC4iKxBSNyGg1sMVrcpk4YHAygbiA8mf6V?=
 =?us-ascii?Q?9Ap7TrHmQDRDLMQ+HfiLGBvk7dR7MDrSavevXQKH5RrsKH4piCRe8Q4zv5xH?=
 =?us-ascii?Q?gyVh6fzRqJps7znjL/lilEz//lDrsgGeyT6+5XXCgj+ZW0HzSWJHCRBbFjv5?=
 =?us-ascii?Q?G+EZItw5TWBrlXRVkJP4l04hON4WnW98q7b1o9PUxOe8MvTFN2v3TQKN2RW1?=
 =?us-ascii?Q?B7vHC/QEEyUp2qKwyrN4T71bGxL+5/M9McoX6gRoHGmUKPOl8KtX29ShQlg/?=
 =?us-ascii?Q?tcCo8SAylDjqkzcHXGOwARZNTv9RziBiCvO6z7QKx2FO9PaVDvPhcGWUN7Yt?=
 =?us-ascii?Q?E5DhdFosPDXkIo+cfSk7OvIghUGcp/K7GHT4xd0g+XlgRKsCnL76NE/qc8nB?=
 =?us-ascii?Q?qvx8oO/DBVmWob++Twp/eh9RH61YwhL50wxxnsOM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e9c7bc-cc19-41dc-3096-08db3c6f3ab2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 22:34:22.8937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmkJqn1IZGYgnDTjBIhLWoaY2yD0nv0xG5m+dc8UPf5Y5NOX4ZShstwj/nle0xiGW831caudomkI3Qm3DbJGqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5954
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Apr 15:21, Jakub Kicinski wrote:
>On Thu, 13 Apr 2023 14:12:49 -0700 Saeed Mahameed wrote:
>> This is a high priority and we are working on this, unfortunately for mlx5
>> we don't check FW versions since we support more than 6 different devices
>> already, with different FW production lines.
>>
>> So we believe that this bug is very hard to solve without breaking backward
>> compatibility with the currently supported working FWs, the issue exists only
>> on very old firmwares and we will recommend a firmware upgrade to resolve this
>> issue.
>
>On a closer read I don't like what this patch is doing at all.
>I'm not sure we have precedent for "management connection" functions.
>This requires a larger discussion. And after looking up the patch set

But this management connection function has the same architecture as other
"Normal" mlx5 functions, from the driver pov. The same way mlx5 
doesn't care if the underlaying function is CX4/5/6 we don't care if it was
a "management function".

We are currently working on enabling a subset of netdev functionality using
the same mlx5 constructs and current mlx5e code to load up a mlx5e netdev
on it.. 

>it went in, it seems to have been one of the hastily merged ones.
>I'm sending a revert.

But let's discuss what's wrong with it, and what are your thoughts ? 
the fact that it breaks a 6 years OLD FW, doesn't make it so horrible.

The patchset is a bug fix where previous mlx5 load on such function failed 
with some nasty kernel log messages, so the patchset only provides a fix to
make mlx5 load on such function go smooth and avoid loading any interface
on that function until we provide the patches for that which is a WIP right
now.


