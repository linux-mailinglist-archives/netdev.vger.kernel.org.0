Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AB560F1E8
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiJ0IKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiJ0IKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:10:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BFB3056B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:10:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCAh+FV3/2PIVglxryFVAo2ySVTNqn7+oEidWAVW0tUuGtpBWKLsi580y2CQcIZg56+PPsDW4liu71J7U+pgOMBwrrc8Qc9P9WYow1YUb4HXd6CklsK9W+T/G2CPqVMwCHO8HXBz5V2G7uqqON5BQO6TmJ5DLQ9QZ7xcf4X+AjzOTKZbyK6i9JpvSdNlWuco6QQYoMFFTaeMMaqPLyp0Gzn7zgDYZ9a5kn+JfT56u5lvEWGkGptBBzCWAKtKUJRWCxeTF5HHCs1TVb5dIBc1Pmxoqnzil91XILYMRycsDFKNlkKdRHoFm+J0HHV95TPRyZExlm2qogduolNWP/29Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omJJ2QO2OsJJtstYuZjeehfWh/iT8mF1HJ5moXi1KBk=;
 b=UVC4kI3t2ZJ5UGvr3WKqGiACgotcva/J1BFL2CLgEleOWP0HzXQTcyrqSRLVvu0znyspD98X1OzVycBeH0n/vd/89ZRM/NrvX0ODNxZNAPXZf/yQ4MpmW7R+4R8mJ7YlvwYJ8TXhzHFXMbXSL+QTY/EzRjP7T13oOnyf3jMOba0n7Njb3ux8DVGJMa4NDM/HbGn0r5kje9We4YuLrcOkokmINhGmiCGeQTa8GVJbpxYryE2esjmikJ5F9doJyEuNskgQAgrpZLsJ0sMuEqAcH3F/82eA7BT5ZviRiSq6YuZ1GjmoWXmSOeCRjSkOcDPHR9FhYjBOtid00213Lqn/Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omJJ2QO2OsJJtstYuZjeehfWh/iT8mF1HJ5moXi1KBk=;
 b=Kf8sw37IeovhuWTFdHAt3Nf8bP//jOZW4GMGlwfHgLvvjI9+04WXjfftQrneF62QxQ2qXBghgCH6x9cGvodq1uS+X3JxBDxZflWb7+iDfgIItSEnEhOp1o69Jn0Lqb/Lug3T2JFb83K13GnPx8YARyilmnr4rzrLeqgzjuRMW7n7t1DF2YKc6Ct9tQFXqny1DIzGUDN+ryySikSyFgvMP9TOxorMo4Dd9coJ85WcT7boPlMSx8FK5AIhkmampVI9RHyjXuhV4OYR1EbQ0kI79OEHMr6PDY9BosyllGO+3pRo/H4I+58Kh8Jyv79mbkXJbNmC9CzXer0Eo79JU3v1fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by IA1PR12MB6649.namprd12.prod.outlook.com (2603:10b6:208:3a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 08:10:30 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::ede1:d11d:180e:4743]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::ede1:d11d:180e:4743%8]) with mapi id 15.20.5769.014; Thu, 27 Oct 2022
 08:10:30 +0000
Message-ID: <43d8bfd6-09e8-5e18-03cf-979c518d99c0@nvidia.com>
Date:   Thu, 27 Oct 2022 11:10:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [net-next PATCH v3 1/3] act_skbedit: skbedit queue mapping for
 receive queue
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
 <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
 <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
 <20221026091738.57a72c85@kernel.org>
 <56977d26-5aca-1340-baba-5ba0cdbb9701@nvidia.com>
In-Reply-To: <56977d26-5aca-1340-baba-5ba0cdbb9701@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::9) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|IA1PR12MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: a3b45f1b-623e-4af2-5d45-08dab7f2b6af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WckmKRr+Ut4abPj1YRiLKElCI0wvbHnuTyqWH8pGqqXC7QniCqgWLMS7fQSnpu4oP6VKcpU7plQ4UB9rO151I2qzneNO1MoYyN57K+QbgPJrdVZ3WG6ulPJbgnb7OobAAucxBnu/QNja7khxsPaDARM3V6KTZen9ykwDIybgJjcnnW9olGl/mFrsJhutWA0EfAKygr2pMXKa8O/k48P2xN8Jit2c45HYCLHlPddcQWUOCEyCiaVW06aXBULsrG1Ze9daE49K5Ee23sVt5E/JVjxAZZT/SAnMddkaNHONHgikrmjDt9mhdnMwXc8UzHly57jHFiS2mLlg54frUlwca5/jcTR9Eh1uQa3xPXDTxm2bNX/mMMFigL6jCbTGnh1cYxxa4X4vormb56x3cicp0RhDAk9EgZ/EXOFxirJ+sPpiWBfMK2uzjHJPp0f1kxaPJ0veQr6EYxGu+Knm3m3oY0ISvKbPVldvTfUmLsBxFhe0BcjjhVbZE/SWcihWfsHPaFC9UOH7U0tH/aQwz8evucBy5AztUu8KfLRR8yvWV95s81926pox0TB/T2fgs4+aUX/TQ3o+AgtE6Pv/c9RtcANPL5/m6sI7xh8vi2hQp5GVjqrvRW/9w0wIJexZdoZgbmMh0r4gnj0tC+rwnzLzTGLXc7Zqg41Al9EQgGcZayvH/qjylKZDMTbRzizkyqx6eIYnjb1RyXKdAgFi3qhohSEKslOBVwcMvYhcQLzFU9cUIHbOlZ6uu0PAly4PNfw+ceaewR9CdZ7jiS1SBVyszgtTwLIE1Z76t1jl0Mrzhpk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(66476007)(41300700001)(8676002)(7416002)(4326008)(54906003)(6916009)(38100700002)(6512007)(316002)(66946007)(8936002)(5660300002)(66556008)(6486002)(53546011)(86362001)(31696002)(478600001)(6666004)(186003)(83380400001)(26005)(6506007)(2616005)(2906002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFAzd0RDT3NzWVMvR3FqazhoY294N0FFdFNIWi9LVEZELzhvRXlJdjNXSFM5?=
 =?utf-8?B?a3JueUwzMENnSVVDTHhRYU9xODRhbDBLZXorNUdEb3NGMGdlVnB1SVZrK044?=
 =?utf-8?B?a2RCZnhRUUVEQ2w0WXpjY3ovaXJneHN4bUVOZVB5bVNjdE1XbjFwNTRGM2xy?=
 =?utf-8?B?WEhmak1UQzJ4dFdDV1NLVFJsVmhHb0xwa3pxRGtqTks1LytyOVdBa3RBVTk1?=
 =?utf-8?B?Z3JlM2dGa054RlFCN2JYeU43Q1dBWjNaczlSZFE5RkRyM1JBTmRVVUh2T2tz?=
 =?utf-8?B?ZitEbjlRNE15amdjWjhqRG5sUVhHaDYvdjZnMDJOQjY5blBBcG9NNWtJVE4x?=
 =?utf-8?B?ZElZR2YwZVhicGk3bndTRGord2xDaGNXOWtCMGw1c1lyV0ROOGR1b3dNTG1E?=
 =?utf-8?B?ek9jV3BZZ1RTSEcvKytvbkx1TzBNMFBVSnZBZksyV0ZERGlNa0tMdmVja3RU?=
 =?utf-8?B?eHc2UzJjNzl2YWNBU2UveWk4U0ZpRUxKWk5hc1dtcG1pc2YySEF5QjRscVNN?=
 =?utf-8?B?bVlZdU5Uem9Md0lOdU9zQjM3ak9MU1VYY2tNMllTb0xNaVE4dXFJbm9RSVQw?=
 =?utf-8?B?QlZaR2d0NlM5OGNJcDFpSDAzSHQ1dC9Qa1dGSmg4OEZaQ3FCRFQ3cTIvK0pn?=
 =?utf-8?B?L3FlR2VxVzBKekFaQVk3QVhKTmRWR1kxQzU0dnFyR0hzZGJOcHVraWswK0dy?=
 =?utf-8?B?S2NSU1R6MXVCdFBaZUN5YlM1RldRRmY5R2FWa0I3QjdJMXRLTklkNGMvSGpq?=
 =?utf-8?B?Q1VVbzZ4aHcvVDNLR3EyYkc1eGxEcVFHQWRRRVBIT1d6SGZpcERKbGRtUkpG?=
 =?utf-8?B?SzlPM3Y2R2xIeVYyV2drZ25haDhHL09QbGQ5aUtYRlNDSndhZk9WSElNbzRS?=
 =?utf-8?B?TjA0SVlHZnhWV04xZUdzd1JsdmhWRlNuME5lcTlITENiUTBpKytZbW1kbEtj?=
 =?utf-8?B?M3MyNlRVVTZSS2NtZ3JhU2hCaGQyQlFJZlFaRVM3NDBoVC8rTTRoMmxiVHV4?=
 =?utf-8?B?b1R3ZGdiZTlOZmtqVzdaMkoySG5ZcnBBcERSc253cFh6ZEhMQmRBYzZhZDE3?=
 =?utf-8?B?cStUZjVXbVVpV0RTZmt1T3doTEFaaWNXdGpLT3FEbXFXdXUrYndINUUySDA2?=
 =?utf-8?B?Vnk4WGJrS3RaeVBtQ29Gb2pGeUVKU0EzZVgrU0tOYzNKTUk4dXdUbG1uV3Zz?=
 =?utf-8?B?UjJ3VXpEcXVTRjFvN3JxQlBLS2VpT09zMy9ubXNVU2hGWUV5S1ZKNUZXVzVq?=
 =?utf-8?B?akFLUG8yMjF5cE9wRkF1VjFVcExMUkVFL2dLaGR1T0VMcmYxb1B2VHNLOXcy?=
 =?utf-8?B?VS9OWWdVajVKKzRCZVFjVnFHa1BIcXRTL1ZZVFdNM0pOMDgwSGlQbEVLbHN1?=
 =?utf-8?B?TzU0VDdTR0tpR0tCNTVLTVlVM3h6QXMyKzZ0YjJSYlV6cG5lamd0WWI3M2dp?=
 =?utf-8?B?aGNiZmpiQjhUVEpMYThNSUF0OVg5bzg1QndDWkRzQkxSSUpjNVRlckRGckQ5?=
 =?utf-8?B?ZitMT00raFNhdmxpdmpGeFc1cFJDL1hQRGt1OVZBVytxckp0c055dTNOZ0l2?=
 =?utf-8?B?aEhXK2lDQXJVUVduMzZrMUxWcEhFeXFaNERJRXNBQjVJZHZXcGNGTVpXOEp2?=
 =?utf-8?B?U0Mwak1OSkVJVlFqRnVXcGF4NWRPUm9qMUxXUVVCZE02WUdQLy9VUHR4LzFJ?=
 =?utf-8?B?WkRzM2NzcmhVcnlPNW14eWxwa1Y3c1haT01JdzQ5QnF1ZjVYeXFPWVFKK0Jq?=
 =?utf-8?B?NWllaTE0aXIzVTdyaktjSW1QK1pxSnU3Rzk0ampkbE1zZ3owdnFYQkptMU9K?=
 =?utf-8?B?dnB2YVkxSUdhbTJyOGU5bk5SVGRPSGhRNHY3Zk50VkQzamRLZC9pL1czMElm?=
 =?utf-8?B?aVZMTkZEMXNlM2xKYkpoMElRK095aTJVUFhJb0FtQWhocStheUxyd0djZVZN?=
 =?utf-8?B?ejE1WTRtVGhJbHRzUDdWWlJDcURvLzc4azZMbzRqQVF5Q1o2Vlg1akw1M0dw?=
 =?utf-8?B?ZW9KN1VjT1oyMnBzR0t5QmpGZWdjdmoxdWx5a3ZYQk5POEFCM0F6cEFXckxP?=
 =?utf-8?B?RDMzSi9wbUs2amYvTy82N1dRQUZhUVpNdzFESXFWblFCRkhaRXd2b2MwNkZu?=
 =?utf-8?Q?B76OKaORKWHFbHe8AnvNNsoNa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b45f1b-623e-4af2-5d45-08dab7f2b6af
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:10:30.4385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u2uLwMhyr1NW2PYXoZONBcmoK8c9vUDW0xn6hau/uB1AxQGvmqDWN979o/MLLFj1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6649
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/10/2022 10:12, Roi Dayan wrote:
> 
> 
> On 26/10/2022 19:17, Jakub Kicinski wrote:
>> On Wed, 26 Oct 2022 14:40:39 +0300 Roi Dayan wrote:
>>> This patch broke mlx5_core TC offloads.
>>> We have a generic code part going over the enum values and have a list
>>> of action pointers to handle parsing each action without knowing the action.
>>> The list of actions depends on being aligned with the values order of
>>> the enum which I think usually new values should go to the end of the list.
>>> I'm not sure if other code parts are broken from this change but at
>>> least one part is.
>>> New values were always inserted at the end.
>>>
>>> Can you make a fixup patch to move FLOW_ACTION_RX_QUEUE_MAPPING to
>>> the end of the enum list?
>>> i.e. right before NUM_FLOW_ACTIONS.
>>
>> Odd, can you point us to the exact code that got broken?
>> There are no guarantees on ordering of kernel-internal enum
>> and I think it's a bad idea to make such precedent.
> 
> 
> ok. I were in the thought order is kept.
> 
> You can see our usage in drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> in function parse_tc_actions().
> we loop over the actions and get a struct with function pointers
> that represent the flow action and we use those function pointers
> to parse whats needed without parse_tc_actions() knowing the action.
> 
> the function pointers are in drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
> see static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS].
> each function handling code is in a different file under that sub folder.
> 
> if order is not important i guess i'll do a function to return the ops i need
> per enum value.
> please let me know if to continue this road.
> thanks

Hi,

going to do this change, which I didn't remember to do from the start.

static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {                                       
        [FLOW_ACTION_ACCEPT] = &mlx5e_tc_act_accept,                                                
        [FLOW_ACTION_DROP] = &mlx5e_tc_act_drop,                                                    
        [FLOW_ACTION_TRAP] = &mlx5e_tc_act_trap,                                                    
        [FLOW_ACTION_GOTO] = &mlx5e_tc_act_goto,                 
.
.
.


then the ordering is not important.

Thanks,
Roi
