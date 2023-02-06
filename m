Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4F68BD85
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjBFNKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBFNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:10:15 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBB715579
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:10:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLNKWfw1I1H1wGDMZrKvnKYb01qu3AgQIA3TOSM1i5o/HjWPyjdodgcggApQWm2oHXKn1I1peewRCtVzkbBZWtmmtg28Wvg7ZHVeJX5VlXVOmSL795PsbBfm3wYWjna+4YQCNlPed470g6Qytcxipq9azohvhPyTyaOC4yG+jEQAVAXu2a16BE3uX8czgy+wRlr+V1lErhkJzMbamkNiCnFnw5JAVA6sKNySAiBEArDNggxcC0ePB0K2CTjCQWBKgtdArs+70XRWnfm+gFMfDg7zEZtlMYvbAbEhqBmMNuDqGRaHBd6T+BsG8fF25knKET8bSLPI74yfrAd3JFL13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wn5k2DPwspzD7O4qcEXo7gixHv0iJnmZZ6E8m05d800=;
 b=NgCd2NZeRjyo/t7+qSzT3kI/Cf4VPhihgDBMoylK4Q9TtWT74vSkvmR8PVUe/FmiIL18tGcDrnvmj9bTT5ssmhbdxxzCVRQrP4dRptyyT5c1tGC8+vYiY/bd4DsJb7Kt1LDYTdvlI/OWS4vQR3yceYuw938NoVkjD1CWh1U7oT+8p/Xuogr72YrSIYPY4wdqmuYjIUAZo6COkD7JLcZc7Y26N/iYbWTPEOdDOWPTmf/4hChlxgF2YbZmhKzCmsNkYOV/FdfPsRS1U4LklxNbPmNuQLwKJY5FXDjq8NTaTlNBPXdNuQMHK0RRkgSBYloTeGcygzYPsBUR0bcmZKyVgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn5k2DPwspzD7O4qcEXo7gixHv0iJnmZZ6E8m05d800=;
 b=p+jhkVo4R35h6f7i9KW3jvDAAUyI7OHBkCCakU7wVoOthQhnpC14z1xan3F1dCKzTP/9KS78CbpTdGZaSAjcilduVU1/Kz72V76Fn2XOuNjYPX3YmqyMBeyf3HASOIrseVeWYNd9no4soUzfCWs38umu6yi0VK0KdiaeFxwUlVC+ZTaIvPJGQKuwx/DuFhchd7/hCIwgtGHbH5uCPSFlVsxTSbqJNjs3ANpvRzVkMv7bA0tdUO+1HoqKUzOjlCeAmEhkkisgOv9PNz3brjMxaEt2/g/7VMrJyTiCsvqvy2tUYVbtEfda5sIQOInk6lksjgLTQG7LXHHc2FArhXpsAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 13:10:10 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec%3]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 13:10:10 +0000
Message-ID: <f769cbc4-0d13-d951-9a6d-ff792300a1aa@nvidia.com>
Date:   Mon, 6 Feb 2023 15:10:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101
 Thunderbird/110.0
Subject: Re: [PATCH net-next v2 9/9] net/sched: TC, support per action stats
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
 <20230205135525.27760-10-ozsh@nvidia.com> <Y+DehoC/fE9LA0uI@corigine.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <Y+DehoC/fE9LA0uI@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0144.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::23) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: d254df55-489b-440a-8df8-08db08437997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8PfZH/TuRUN24/fMRgieX6at3E+Nz2st6QZri1+Ctv6DgKL/Ddkj58miyhZi98cg/vHXU6Ap6iV76b99rZrg+I+AYiFVP7VXhg7+dJdH7Lgd1r3NLOwF80WujSQ4tAMqvsb5UPQbdA+oh+VQGIdgRosbvCM1q+ydVnqOUaw8ZMY+ENByXatOqNk2XUUfVZ33QEe+6ezN1y0HtxVl7/Fo5Eh6LUM7QNta+MxOeMvwTmLd9abxV3nhw609pnzm5tEnYmBiUdIE48qL4Zx1Lm+gEwQf7psXb1AxUBZ4gyQNurdr2uEU7l6kevdSjodkYGPzgmmqNjlfiFDH027xYsXSL3EUksMvJqztd/oUyAR/Am93zFVdas9T+AYfv/jrqVyQDGytMp8GH3kFDPQTijkKWBT+ojFDbEVyAIhOPbPAkYat4nZLO4B+OVXmx4txvZIfNxzn1x2kke9+m8+8gl8OVNAs9h3JyxfayQUV88KeEMDPFYtXS6aAm8sjnf0/OjntIn1+VUtXwz2dcc3lNHLE6llfksmFhYEM1QwZ4rONw3XnNPWCnjdB2T3ulhHv4IPHQJEcAlqT8ldAHgWJdJLxvto+nrh9JQHyRnDIO7apmJ9x2cYSfU/7cLh0S84fA7b//ziW5Acm5/jzDeR2DPj2BvCIwzl/2rQ0BYeJXImQK1jOBQMxd4SF90qDAswKiblXXbX4dAONbMnCu/BGD9F/1FxvCYnyx3g9e9V2f7UkpBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199018)(36756003)(316002)(110136005)(54906003)(6636002)(26005)(186003)(6512007)(31696002)(86362001)(31686004)(66946007)(66556008)(2906002)(8676002)(5660300002)(4326008)(41300700001)(66476007)(478600001)(6666004)(6486002)(6506007)(2616005)(8936002)(53546011)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V211R1YvdTd0UTZHZmNlVzd3a2FtY0E2cDROMXBvNXBhZDFrempleVUwTU1N?=
 =?utf-8?B?RnV5L0c2TE5rNVdvblpYSUQ2cVJhSU9Vb0UyQ1FQazVud0N4WFM0dXFxalNC?=
 =?utf-8?B?YXhFN3kza1lvdzFmNStXMXlXZkM1ZXFyYzMrL3JFSXh5R2h6L0k1a09uU3ZV?=
 =?utf-8?B?bEZqMzNyMlFkVG9jWmVNTW5rUmRSMUM0WElELzRnSnZIY0NBS3BLTlBidENt?=
 =?utf-8?B?S0hGSTNRcW92cUgzQjlZSnlkb2ZFbXF2NlpKUElZbXpBdDBBKzcvRy9OSjQ3?=
 =?utf-8?B?M2tJQ1BvbXdXUjVabVlrczBTd2RDeXhrVERsL1JPdFluVWVlUW5OYnI2MkZY?=
 =?utf-8?B?MGdOUTRXdnVQbnl1R25lWWpyVnljKzBJK0tHMWN1NUUzbGFpSW9XNisxZ0VH?=
 =?utf-8?B?bGJSK09QTXNBWjB0N3JaNTlTckp3bHZYb2lmTUFodEltSW03aEZHTW1PWjg0?=
 =?utf-8?B?YUd6MDVWOC9hUVMvNTg2QWxrc0lJVzQvKzBDYmpPazJyazAwVHF0YktqVCtI?=
 =?utf-8?B?UElwS1dqOUFadU51eTdqS3FsQXpmN3Y4a0pzYUtHUG02U2tLajJCUHc0elk2?=
 =?utf-8?B?b0kvWjgzQ3RtblNDVHAvQnUwdkVadEtiWEgrTXdUUTVDVWFleVZqYlhPd291?=
 =?utf-8?B?WlpJMzMyUmFwa2hSUFNTVmtaWXl4d1NWdmNxaHdXUktxQkkvcy8rTXIvRGRI?=
 =?utf-8?B?aDE2aTBYWS92NThZelpzRDRCTGNGQlFvcDA2czNjdWNZYVFlSWlNNjhqcy9V?=
 =?utf-8?B?ZjluMVQ0cFpSNVlEdXEvcUZVSVR5WTd0Wm0vVTg3cVQ4UDBzOElJV3JHME45?=
 =?utf-8?B?U2ZNSlowS1JTRy9zaWVURTdqQk5vTnFoNWIvR2UrZ2RXOHlMNU5NZXlveVdj?=
 =?utf-8?B?ZC9JM0dmWk5IT2FnVEpnWkpRZkJQRUxsQTFBOFFhM3BjNXRGZWpqK1IxQmxt?=
 =?utf-8?B?d3M4d29iR21RSkI5cjZQMXhma0ttZVgyVHBSQVVVaGlPUjVnSVU4MGJidXpy?=
 =?utf-8?B?amdjYjdPM3dibjUrQUo3Z05QbjFlV2pxZjVsaHZ2T3MyR0NVNlVlbWFEQWsv?=
 =?utf-8?B?Q0dOU29kb1pTOUZocy9aRllsVmxNQUhNV0FxREMyaXFsWTFnMHZ0VklXWFYw?=
 =?utf-8?B?akdQQnpVcGo3R0MranU3cWdyY09LdHZCV29hejhjejVRL2V2Q0dMbEhodzJT?=
 =?utf-8?B?QzBhdlFsS0J6Z1F1bUVCV1J2R3hNbW1XY3V2ZFhYU3pUWXRLOHdHTXljVXVp?=
 =?utf-8?B?K2g4Z2ZkakxGL0hPSDBCdWs0eUh4Uno2QXgwOGtRMDhBTC90U1BlR1N3a2Ja?=
 =?utf-8?B?T3lHOWNEZnZQazhMK3lsSTAzMmZVbVllL210Vk1vYTdvU2xuMTNvUlVvM0pz?=
 =?utf-8?B?UUdHakZDNU1hZkFjank0TUk2bHFtTFQzVjVmSmNodHJyejJ5SER5aCt3VjlL?=
 =?utf-8?B?VUxmUkJLL2pDbmVtVHFTVDlKQVVDbU55bnVMREZmQnA5Vy9MNlEvektCUXRU?=
 =?utf-8?B?NHlTNEw0ZVFFUUZIeDRkYkNwR0E3WmYxRjR1eU42Z1Vpcng4RXZlRWt1WnRw?=
 =?utf-8?B?cFNkWmhuMmJzaXRSZkZCUHYvNlVrLzg4dVZLRzJjVi9IRnozeVBpRUxKT3JL?=
 =?utf-8?B?b2dJcm5OUks5blhSUWJHSitqb2loM1Z1Yzdvd2pSaS9IdVNuWkUwVFJEL3BT?=
 =?utf-8?B?NzhHbm9tSnN5a1FHcUFscUZrcExHWlhGZ21iK01OU1ZmRHFjb1l1Q1VWd3M5?=
 =?utf-8?B?eDAyOVFuMXlBRHdGaFlFVGRxbDZYQjRNSWxIU2grTmIwcWFqL0Q0Q00wVnNU?=
 =?utf-8?B?eDdmV2tDc1lZTDl5WkRJUWxJNVBPdlEwZ0xobTNIRU9YVU5JOG8wRENUZDM0?=
 =?utf-8?B?eXh0MTFveTZmMkJlT21Oais3ME40MElMUWNkUmdySnJCZTU0WllKSlhwK2ZR?=
 =?utf-8?B?NktVMGRVZWVXa0lleCtSYm53QVRQQjlpZkl0dG5jbWt6NXN5cUxmMHp6RFA4?=
 =?utf-8?B?OXNjTG9RdE1rQ3B3alFEN1kyalFRczFmWENFRCt6ck11THB4OStqTWw4bzRP?=
 =?utf-8?B?RFFVem16UHQxMmYzUVJhOGJQM1FRc3Fsa2hzWWtHZHUyQVJSNkduMzJwUUZo?=
 =?utf-8?Q?EFNGPWJWeU1tYHMauPcfcENls?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d254df55-489b-440a-8df8-08db08437997
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 13:10:10.1207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0vMZCC5LvwEuDfqfbAZjiMfmz/Yatz47qunnHAszr4DFBhc/FTT5+gtGib81Pz3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/02/2023 13:03, Simon Horman wrote:
> On Sun, Feb 05, 2023 at 03:55:25PM +0200, Oz Shlomo wrote:
>> Extend the action stats callback implementation to update stats for actions
>> that are associated with hw counters.
>> Note that the callback may be called from tc action utility or from tc
>> flower. Both apis expect the driver to return the stats difference from
>> the last update. As such, query the raw counter value and maintain
>> the diff from the last api call in the tc layer, instead of the fs_core
>> layer.
>>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
> 
> nit: I think the prefix for this patch should be 'net/mlx5e'

it should. missed it i guess. also prev patch 8/9 ".. TC, support per action stats".
thanks

> 
>> ---
>>  .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  2 +-
>>  .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  | 44 ++++++++++++++++++++++
>>  .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |  4 ++
>>  .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  1 +
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 39 +++++++++++++------
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  2 +
>>  .../net/ethernet/mellanox/mlx5/core/fs_counters.c  | 10 +++++
>>  include/linux/mlx5/fs.h                            |  2 +
>>  8 files changed, 91 insertions(+), 13 deletions(-)
> 
> ...

