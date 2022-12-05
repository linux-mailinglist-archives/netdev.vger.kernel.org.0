Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A669F6430DC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiLESz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiLESzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:55:43 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B674922524
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:55:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuQ4shKHR8OZY/WlKmp1IQJfC6GWqRhOnAB1qN9XZXbT2ZmzPfyAle+UYpoWPJwdgxFmq49bcBDQ3Tk8PR0Q0yGb3nfrstRZgNWRIZiB1f2v8Ws3oFKWZGmjiOVDFWJO47AKbOcqNnjogRwsgAhhbSCTKaXydC8opI0GG81bHWfnkJCBMEW5H04RNmeRk0qLZcq86VLJiuJSJR1vvaFW+ww9uzXr/FEESqe4yIKkKQv6B6NHi/z+izjRz7+Oxq81AAjKzIlcLlwN9MUrUHauclEtyULzdWzJtgVx/Kf8k89VbnIrzxt1dATlvFSFah+gbUro+FC5M9CI4yBKWGt63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXDFTLsB+9NPi7jEFkJKfBZpjsCrIdf9SNtHXLXWTNY=;
 b=DXSqxR/xMNmS9rpvD8ZTDJoqIdM/HrcogHqiwXvwa63KhWQAdHYqFGxEHIEGPZCzysMgwNsQolUwyV6al4X6bKkfp2T89YobwG0mXINqSIunESm4TtMWNifaEikcaYnWT33bJoPi/Z8GQhBg7TjtpsgRQvxGGCNuna7c0Rj6s4Udvk/R2YtfCThxzO77Ns8Tj/dMRkGusSXwyW8hekUSUZ5HUmevplrlrGg50jFWMSpl2iltldWC1qKlPGUqAQuTyqwVFZCy/lLcSTorX+cFRbTxIZtE0KSD9pk1vIHP4K1XqBa/rQg3zdXiwMPRS1uy1LgD3887/+WBJ7+L7/NjtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXDFTLsB+9NPi7jEFkJKfBZpjsCrIdf9SNtHXLXWTNY=;
 b=tKeC6hjkHxf16JuoqJdc+yX1OjXa3V/JTtD2ChTIAwACR3Ee1TUCEzDyjGxzhp6FNIcCFwjfgdeq4napXfFgqWSnOpRy5fA6wZVh/u3RRwsch8d6Ljz4tsGeZn9JyUCs0RyjsAFeF6UndMizNsZaDqwV/3D5HxikqJ6dfprIpNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB5911.namprd12.prod.outlook.com (2603:10b6:8:7c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13; Mon, 5 Dec 2022 18:55:18 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 18:55:18 +0000
Message-ID: <13ce5067-6e6b-8469-a20f-9e83793b2022@amd.com>
Date:   Mon, 5 Dec 2022 10:55:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 0/2] devlink: add params FW_BANK and
 ENABLE_MIGRATION
To:     Leon Romanovsky <leon@kernel.org>,
        Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <Y4424LOnXn+JXtiS@unreal>
Content-Language: en-US
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <Y4424LOnXn+JXtiS@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0044.namprd07.prod.outlook.com
 (2603:10b6:a03:60::21) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca56d85-8eb9-42d7-3410-08dad6f240da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kA7qHqI1Xkt2p2hbaHFf2w/JldWzkSPV0Q2xVAX9ALmtiE+nOrDJdTl936yy0QcXbCE22QxdD6sExJoYj3L3FXSM1dWYi4y+33tBPR+NsRdAyvuONuBA57O9d43TeWLILU2dmXfTLMzWjS96EXbU4Ltv4zll43E7IwOKVrNJdfSaSSlGM1bN5cmgmwVmnt6qz+Dpu/QjGOPSCcsHbPXGDq7jHBYRy3eQzt93fhMmiDKtlbY+BTPfVygjRS8ttYWJhXy5qJyxEHZ3z4fdBs3+aVs+Ck5WZ81BVbzlOFApoHejGqYempUcgvw/iY8w9WAzhNKNhgutM0V7ZRNwtHck1T/C/6ZDnpg4IUEJa7rgIhoAoGsdq3YcKQAoPGkrSa2sTEhpJXlUkNLchCRrZTsFojkhhwuYOQAGIJaoUApfGPJJFEu88JeFxOP6pHiBW9RLbC2AIX2ijGljjGyiPnYfGfdh3Uw4xwesnPcp/3aj7jNWfVN3iqaW6eutQqo1JDL2Tou9um351waEi2hVvHM6wyUeXXZ1kuNRPYUSELai6k6hdOWVMLhye0z5MHmWGjF4HXrhWVNmbXmD9jebJBRQ3JkmbmmvzpUhEH8DCF014H43dNaVJdRgx1riD8xwn5KuPS/EwyY+yzY0mUzJzCenkuzsKgKHEJ4128pgVHhKyJHylWRMWqMlttAKFIpCRzUT1iU3T6rRJ/R0N6+M7uXo5BF+53ozXU0bHf/Vo4bMZfFwmY9Y1URRJqSPovVMGqdYpAVKmu+CUugiy4ZAvDtH6HPoShyTtv+Rl+Mqna9lMoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(83380400001)(186003)(6512007)(41300700001)(8936002)(26005)(38100700002)(5660300002)(2616005)(110136005)(6636002)(36756003)(6506007)(966005)(4326008)(6486002)(2906002)(53546011)(316002)(478600001)(31686004)(31696002)(66946007)(66476007)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDNlRWl5M0NyTi9EeWNMQUFhbWtSYXdEMVpkbG9GMnZETC9aSlF1djZpWHY4?=
 =?utf-8?B?UEFIditPcG5UL3l1UFNyZ1JVOUVicm1DVEgrZHZ0V0RXYytrVmVZWW9DeWNv?=
 =?utf-8?B?bmpmdlVRalNOYXdlU0RqNHNMYUZQMFdWZnRsWGhqaGlMdjNlZEtpcWlwZnF1?=
 =?utf-8?B?eFF5S0U2RjZPWjUwejM2Nmo1V2ZqSEVsTW01Sm1WUnhFRDJHc2owODM5bDd4?=
 =?utf-8?B?V1p6NE9JbytNdnBMcll0Qlk4eGJUTlRYY1RBWjhiUmk0L0FIeFZuKzBXaWlq?=
 =?utf-8?B?Z3p6dmtUWFlzajNOOGpheWpyeWRIVkZneDlxUmNFeWJ3azBxdHYzQUh3ZHhw?=
 =?utf-8?B?NVFpQjJHS1R5TGRkY2tjTFdNV2tKVEF1NFNSL0pDUE1xT1k0aU5jMm9DNTg1?=
 =?utf-8?B?aXhnNWNkbGhkNEZZRk1VeWJ5cllsV205WmllVnpkSW9FbjI0cXRUaUJPTDJl?=
 =?utf-8?B?aWZiNFlKdThTZ1JMMjlTenZ4UXExbVF4clRKMHVROHVXVUxvMUV0empTYmhj?=
 =?utf-8?B?cHdOaXUzNWV1L2NFQXdmNXlIaWd4M09BSUU3WnU1WGNMWVZseUxwcXFaN2Q3?=
 =?utf-8?B?SzV4U1FDRnJzaG9kM0w2YVZxUUVjRS9TTEZlTWJFbGUvQzlySnlxdkRDckU4?=
 =?utf-8?B?MnhiMVhOVUduUkRmQzgyWmE1QlNIVzg4N3NlTTJFV09vRjlUTUx6TUhlb3Jm?=
 =?utf-8?B?Rk1jTnpSMGRUQnZCTk4ybDVIVzE0RzdLeGE3SnRQU0oyLzIrTk5mTkRMeE9J?=
 =?utf-8?B?K2hIMTFpVTM1NksvTTB5QVh0U09ObFYyTnJySXY5M1VKMVJKeFpMU0VCSnVI?=
 =?utf-8?B?RFVZZHNBb3hjV1l6cFcydjdPZ2xveW16N0NOMXZqNWYzUlhnN1ZEZEtadzFz?=
 =?utf-8?B?OEhTU3IzcmU2U0ZzZjVzbnV4ZldmWU5jRnZiSXhPQlkyVldlTCtJalRCNXdV?=
 =?utf-8?B?TGpVV1pVYmpUWWVpOHR0Z3ZtZmxReE5UTTNBVTdzaEc2U00vNlVleWJucmxY?=
 =?utf-8?B?L2F5LzBiZnkwZFRFZ0pmRWZmQzlkd2hBdGNkYnh1Q2ZtdTBsMi9xSngyMHpM?=
 =?utf-8?B?RkFmOVpEVy9BVE9rdFczeFBDZEtsdFNFekJ5MzV3VHcrTm1DM2RnV0RHM2dC?=
 =?utf-8?B?Z3IrUTI1bE8rZlhDdWNlZHZ0eldqdWhTQWFSUENYcmcrdVVqa1JBUDdGdTBS?=
 =?utf-8?B?KzZwNmVDTDlGTHZ3aWhGZkRWRFZyWTFSRG53QW5MYlhlR1dYeVZ2cmtGaXNm?=
 =?utf-8?B?eEw3dUNudVdDWDZ4TkJrc29iRkJuMHFXdXBXT0I1YjV2ZHpqUS80SGpYMXJ4?=
 =?utf-8?B?UUVaMllkUkxSemhvaWlUZHdlcllydDNKZ3VkdVNTMzdyTVNjM1prNTZWRlc5?=
 =?utf-8?B?NnJvM1ZRcitWM3pIa2NHU2ZVd1hOaUo5dXJkaVd6Rm8zTzJnYmZOQXlXb0li?=
 =?utf-8?B?T3lXNnRHS0pYL3FFZWlwSFA1ekI5SEZwWjFKYkFhMWtYTDlXSW9WTnA2OUwz?=
 =?utf-8?B?dUVKaCtMQTJ3VTQ4UmFMVE1KNWdsZzR0L0ZQUWNMSGM2OXhpTk45MFJqT1Iz?=
 =?utf-8?B?T3JFTEltb0hpMXd5Z050dlY4YmVTWmU5WkppaVNtd29DQVFodGJ6V2h2M3ZH?=
 =?utf-8?B?bmUyYXRVU1puZVZDQXFCTDBSOThkZSt2dWx0Rmc0ckQ2cHA3V2tabTlxb1Bz?=
 =?utf-8?B?SzVWWlM4bzMrV2FnQXdUWkhsT1Q1N0k5NkdJRDMyRkIyNkx2TDk0MUlWT0lS?=
 =?utf-8?B?RFZ4VnJZRWtTZjNIZDhpbk9XcVZ0R09nU251SEJYaEQxeVNHcFBoUy9OQUtI?=
 =?utf-8?B?RXVwcnVVV3VialJFK3c1NTlxbDRzak83ZllTTWN0dXNPenB5WXlGS21JUkJw?=
 =?utf-8?B?TGI5YnBQOGxVdVlrN0M5UnF0WmJjUTgxYnkydTN6WTJkTy9yMDY3ZXJlMVN3?=
 =?utf-8?B?RmMrMTA3T0pRemhYdjh6ZnVvSnJKMGl3MlNXZGVBb2wxajlyTElvODk4cW9v?=
 =?utf-8?B?VzhCWk5WZGlURlhzMTNVeHVYM005c292SVE4S0xNOGhqSGRrbGNRRFdYN1p6?=
 =?utf-8?B?K3g0QnhMbHpuZDBVOWdZMVhqTmhOQVdHQnhZMkp5VmZwSDBIQmx5Nk1RNW1K?=
 =?utf-8?Q?/kdA/i8o9KFzW4uspIw9Vve6+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca56d85-8eb9-42d7-3410-08dad6f240da
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 18:55:18.7161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7I3DQbueKoSo9sIHpo3jg7QVtuGSXW8HZFa/tZRLdgA6MjQD9Zrfc/vCqOuT0FqnSCEgj9CCRe6qte604dRvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5911
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 10:22 AM, Leon Romanovsky wrote:
> On Mon, Dec 05, 2022 at 09:26:25AM -0800, Shannon Nelson wrote:
>> Some discussions of a recent new driver RFC [1] suggested that these
>> new parameters would be a good addition to the generic devlink list.
>> If accepted, they will be used in the next version of the discussed
>> driver patchset.
>>
>> [1] https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/
>>
>> Shannon Nelson (2):
>>    devlink: add fw bank select parameter
>>    devlink: add enable_migration parameter
> 
> You was CCed on this more mature version, but didn't express any opinion.
> https://lore.kernel.org/netdev/20221204141632.201932-8-shayd@nvidia.com/

Yes, and thank you for that Cc.  I wanted to get my follow-up work done 
and sent before I finished thinking about that patch.  I expect to have 
a chance later today.

Basically, this follows the existing example for enabling a feature in 
the primary device, whether or not additional ports are involved, while 
Shay's patch enables a feature for a specific port.  I think there's 
room for both answers.

sln
