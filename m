Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EB76B190C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCICIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCICIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:08:52 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E01B93E04
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 18:08:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoHws79t1S5s3hK8AcIyJae9w/mybXdgvBiQU1R/uEY85oQTIVb7n3yvnP5s3B/c0dq9t1KX354peSHC/ECJ6li4qMxaBCgrs/GTUwgNydkMtRS6nWA8f5u8s8DXc3Y9zl5INzk79ynEemhWYkTYS4NKFFGZquW7t6pv6rg1fvkypihhyqwj34+ahVadlZhIxnrMp1UwLr9pbUcmicRGojz+d7sl+h4QvsEgH8yXhTc+Qmc5zq7nQiqXD3w3fG1pqPZoCFw53dVc71OrVzB4hhOm0iGG4bLkr47SwnBsU/VqB47K4drNTcH0FaLxOvOISEH6qI2XQA86hQBtVBDEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUYbVkXFV4UypsLoelvtOxz4aDF33G0aUOnJkYOLF9I=;
 b=BVzZ2wXNK0zQzihRk0ubMOpoemwY1gRiNKaOiw0AnXWlqXe4OCqcMwe+o5OFmLAtDWpp1c0AiQc8qNdhTJZAQf00hM9L1QfCxvDVLKzYcXK9m4hG4rgMs1Q0hzHT3X5LOgpuoKi65jnJ6jKrRwUVzrQJWTQfYtpnxNQtYNx3sR8+UJ69zv6jjbmsS40NpGVozROYd5VCxTyQRg3wWfBgIxgsFAY/Z5GeVqaJKHO/ZPvI73P3fKsb+Msz3SI5m0CLZzWNqduy1kdk1Q/m+SIRYnh4rj+Y9ff2CmH2KyU149U2aiJGPn1Qe8NXp+lrLVwbozdmvc65LrigBHH14ChmhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUYbVkXFV4UypsLoelvtOxz4aDF33G0aUOnJkYOLF9I=;
 b=fJi42Lo1WxFAZREMquATzTCxCuInIXRxdpIzs+IwKk7aRskgYdOrfM4knleEpk//WoxtLyKIhrn1yQiAlDYCP64mv8yAbKFkv/1BdGEmvmUn5UwBciDnN0Qd0zt4LwoM9hL6XjyaI/6j33P5udjZBtDokrlmbPqfilKIQaR7mwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB7794.namprd12.prod.outlook.com (2603:10b6:510:276::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:08:48 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6156.029; Thu, 9 Mar 2023
 02:08:48 +0000
Message-ID: <64d72af6-66f5-ff68-f7b3-1fffba61422b@amd.com>
Date:   Wed, 8 Mar 2023 18:08:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH RFC v4 net-next 03/13] pds_core: health timer and
 workqueue
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-4-shannon.nelson@amd.com> <ZAhXycSgSiNFwpNl@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZAhXycSgSiNFwpNl@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0157.namprd03.prod.outlook.com
 (2603:10b6:a03:338::12) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: 10c5dc36-776f-4996-a4cb-08db2043382d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7Owaqdg0yNuJ6j7IInND3Z3bCHq2TC1x1G+6sFUvN5ltFVrg4Qi1R/8muVZm6fEtnslxMvj06enah6g2d5bV3trYlCnw8X2EJvUzjt0EWPDGzkQg4YIOfiZtQFgHtaCWRkTxVodC6LnHMTVJ5mqzCGukKmJtSz55xK6SRKbhATq3lt8AMMhk5+zM34Z2iw0V/LxsmcgUnh/N8iL5LNQpuhKdxyNl7eEfRDB84tViiw4UxWagN1H9e71/Npwo0uP0T5wdzV7XOziK5RXpCKeKAGpiHn01hhka3RL6FiKBqU4smsS0bQWkwOlfLdrF1Pv5a4hIrX6V86y4wRX0jT2Uv1WQNkXLGUNLRihE5jqBmRukIqdFyDHb3aH/6kdHIjmDE46dObH6uM1/6EnnIQAJSiriRtrjgnK94W7tvm/SZ/u2bAjjfzHiajjqgDyQ9mQvFcorthPtYRFKrms66Mxz754NSPQlTfBTy9dTsqpE05xqqPzRvAX2EqC/KcheHIuGBzIrWYxeoN7q0rlMutkHAq7JyCmahMSvwET9BgiE8b2KIr3Nl50gqKd1LmI0sHlb8rIU+rxWmwqLWJBG6im7IPLIad6WqJ5dAnDqv9fATmXOhXElLMIwVAhoVq4k4hsR3W9EBcxRVLu663BjFS85jtSBb3AGo4Ki+rqzqfSRWvphkqDTiDyBJkTvvE7LVAXsBdXqZm0e1Tol1FGUSM6tXnU+uU83Vxx8y99wE44nxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199018)(36756003)(478600001)(6486002)(5660300002)(316002)(2906002)(44832011)(66946007)(8676002)(4744005)(66556008)(66476007)(4326008)(6916009)(8936002)(41300700001)(38100700002)(86362001)(31696002)(26005)(186003)(6666004)(2616005)(53546011)(6512007)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGxxM2FBRS9Fb3A1UEEvSTJxd2l5MFladGNicEk0OUpsbVNSejFmaFRVYXVG?=
 =?utf-8?B?Q0FHaktudmRjeDhxV2JEZzR6ZlRNcHYzd1doa0FqN0RDK2lic09yZjlOa05H?=
 =?utf-8?B?ZitBakF6ZnFJZkRObXFLU01GNGpqTHlFWmpRanRpUG5Ta1grT1QxV2NvSzVt?=
 =?utf-8?B?L1g0VkNiTGtCQml2U042SEY3KytTUDFmWUp1OWpuOWhxclRRcmY5MFV0Z1dK?=
 =?utf-8?B?RitSWFIxU2ZrdE5iZTFiYW0xajBjWmVjVDBWdldINENwWEZnQWhiRG92Qk4v?=
 =?utf-8?B?MlpqSHRXN1NpbDBrS25qVWEyajBDQXdhTllMY0M1SStsdlRUNUFacGdPK25L?=
 =?utf-8?B?RDV6WnBxQ3VDY3B0Mk8vbkVKblRNZ0MzWGMydUdmT0hyZVl2SnNGSEhzU1N6?=
 =?utf-8?B?UnpROFgyRmJFU3lHRDNjZFJNYlVoOVBpQzRpN3p6QmIrdmNXS2M5R1FIcWh1?=
 =?utf-8?B?c242UlJkaWdYUThFcWxLKy9FMDlYOGphMmdPbnU5UEoyZHJ1dHhtR1FzVmY2?=
 =?utf-8?B?RzVXeEZQZXRNOE9TZzdydnUyOXpWZVRObmxjYzE4UDBYUEVqS005WFVOMlE0?=
 =?utf-8?B?Mlg0VE9lVmQvSXFEUE1oL2hLNFVHb1U1NzhSWkhCQnp5eUo0K1MrNzJYYnFh?=
 =?utf-8?B?UFBKN2lWMkJuQVJwVDlyOGRwdFhQNnpMK2pjQWNJYVVTSGc5RU9SMUF2L3Bk?=
 =?utf-8?B?dlZaL0hSSzdKeVZKbHRPWGRJVjFIcnhCM3lDd0ZSWTNtRFN2clNhVnYyaG90?=
 =?utf-8?B?NndhM3IreC9oYkZqNTREMExyRWJPU2d3eWR4S0lMZEM2RUhYVmZ3M1JETlF4?=
 =?utf-8?B?Y1ZwcXdBSzE0WkZKaERUWDhLMmQ2L0VIVEN0RDMyd0JEa3J2VHBkbkwrR2Rw?=
 =?utf-8?B?TDltQVNGZ2Fwb3A4NHBHV2trWFRzZUI3eVVHL1BiUUVpUlR1V1V5V3dSNFp4?=
 =?utf-8?B?d3QzakR6djNSTjQ2Q01zN0hMeXNPeEc5Z3VLNmVVRG5GZVptc2dUYUFGS3Y2?=
 =?utf-8?B?RDg3Vm5QdEJOMmVCZVVpWm9jNllocEhJWWRTejZGOGVaRi9kN0IxZ3hZdTVo?=
 =?utf-8?B?S1UzQW1TV0RTc0VvdDFtVVg3KzNQVExLUmQwL015NFQxUEV5VC9wR1NSYzMw?=
 =?utf-8?B?Zk8wZUxmNW1SaTROWjc4cGFkcWtaeFZMaUdIbEhnZWlpTHRUc3VHWGZ2NW5M?=
 =?utf-8?B?MG9UWTJndlh5a1FLZHczeDRSc3NBTDZvNWR3anhxcVFKZ0JUZS9IVHZ3Tmlw?=
 =?utf-8?B?TXQ3N2xJQ0NrTy9wYUFGSk1WVFpVRjZURUdQMFJDeVR4dzB3SjhQMlM2M3lK?=
 =?utf-8?B?eFgyUVNSQzRTK0V1K3RMUlltYlBtb3g5L1Z0ZTBjYmk3RlltNXhqNDZER054?=
 =?utf-8?B?MjN6aWZiaGZ0bzc1UEFLdDQ0WEdGRFRTczN5MDJyVTcwMkVML2JORXNIczVB?=
 =?utf-8?B?MUtEZjJ5RVNFWTc2SmRtTSt0eElOZko4a3NFT252Z2N5c0psVndMZlFMMGhQ?=
 =?utf-8?B?UTQxWEs3aThRNktsaHZ4SWRDWE56dGE5cXJmZjU0aTVwa0lKODk5YXpEeU0v?=
 =?utf-8?B?S1ZFdmNIODhBNUxabE4yUXNGeWF6WkIyYUc2Ui9SenRQZHRPRUo0ZVFPRHp6?=
 =?utf-8?B?bVFlais0MGZ1VGZiSXRSbUUvVUNyNFFLNnNva1c2OWdlZ1dpaFh1Zm9kUDVr?=
 =?utf-8?B?TERGSUh6dmpxck0wK2JUeTNGSlZ0NmRHTXZkbUYyZXJacG5iUWszSVFIdEZL?=
 =?utf-8?B?OWxCekRiQm9Tdzc4WmYvOVQ2eU1RMXRqaHhkTloxTnFvVjNoTXl2RDJPcXFq?=
 =?utf-8?B?NXRzODM0NXVpZ0h1QWM0Z1F4bjd0cGYxUEwxcHhNN24rWDFtYjFmMUFseUxE?=
 =?utf-8?B?RTVXaHZaUDFueGcyS0txNnJ0L2pXTjk2TTM3aEpsYUl1dXFKMTVMajRaQUl5?=
 =?utf-8?B?QWxuVHFKelpPRDF3VFNCa2pqblRoVFRmNFgrby9UQmErS1hxV05Rb0swaCtz?=
 =?utf-8?B?VkJIZUZQWkVSbjFuZGREbC9UbXpYL1BVWS9xMXUxNkxhZHJ0RmtKcUtDbnZ3?=
 =?utf-8?B?Y240RjE4cE50L0ZzdFIzY0NjaVRWTXRhajBaRXlJUVRWNnJocHNDNFA1ekhv?=
 =?utf-8?Q?mIj2ORB4Q5a4fu12DjdfKAWjp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c5dc36-776f-4996-a4cb-08db2043382d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:08:48.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZMQ0f4iKf7M+uh2OXYIxpFDmov9aRh7ulnwrLOYydhuhoTNyiP3fjaMGrHoegYrdGiMQ/layWFjlSknnquwSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7794
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/23 1:39 AM, Jiri Pirko wrote:
> Wed, Mar 08, 2023 at 06:13:00AM CET, shannon.nelson@amd.com wrote:
>> Add in the periodic health check and the related workqueue,
>> as well as the handlers for when a FW reset is seen.
> 
> Why don't you use devlink health to let the user know that something odd
> happened with HW?

Just haven't gotten to that yet.
sln

