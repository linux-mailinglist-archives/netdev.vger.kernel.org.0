Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5B75FF3F2
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiJNTMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 15:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJNTMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 15:12:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2FF190E77;
        Fri, 14 Oct 2022 12:12:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EIiJjS024218;
        Fri, 14 Oct 2022 19:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=03fAbckcn3VZ2oELkL935NfqiI3T/5Jt8EkzFzfqf9I=;
 b=NFaXiChZ0XeYZhx82b4bm72nnAasLJnBzb2cyV38iGWm/fxWKpwvHwBT5wEQOhuLeIZq
 1JdBmQGa18l7MEgMI3qO91pugm1D/AoAAJ+TWoNI9CTgjEiaeBiq5N4AgcDVqmnMAnz9
 JwpIFVEYa+mRX+TDjZPw0HDZbJFl6k2tNDrD1ILsjiaqAX0NoRzCRZcHj0jMdhn+ncL+
 jdaYc4iTxSQvVVhPF0w1cs7s3Hm7c/8XUzOGGBIMPRUOMbkSGwiAB4yNlGtKNyKFhI95
 MDqKOh4Zsawplmq9uL3mNq8VAeIQ48khWl9lNWiO2iFsCQnxEU+11HtA50K7BDV2TU9M Nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7acvgj8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 19:12:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29EGNk09003890;
        Fri, 14 Oct 2022 19:12:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yne3srj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 19:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yg97rONIQmErgquobN370Lj4JeXP6CZ22KnfXugQ+tcQHvSqodrbXGaI/wz2btoa01qeXSf9chISJY8r3TOSihJyYpKSGqTZJWj02TNbO9vlmfhBvRV32wTUTwa5loJaOsT+MH3bPQhV3BhDRdwtLPwqVRxlsVUAPSMlDA8YtfwnG2FVYtux1A81ercY8RtVXLV3EOVMkgjgXRFl/d/kbT+vD2Y5Dbym2J1tF5YJPQFj3SXFBZnCUnt2OY4uK2fuxW8M0I5aXW8HhRHYTrF4t0WefrFy204JcFgF7zBF/OzOALywHOnaznZEfppZpxwHWadNFpdqwKExjnFWLqNciA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03fAbckcn3VZ2oELkL935NfqiI3T/5Jt8EkzFzfqf9I=;
 b=TOH1kPR1uxHftelZpDrEl+AAmFoDzsC1meAuyfPiHMaSFZH7oDB0GoapbVyRW2FKkj8KeaVqNyh+do6fE33pHWj7z4pz4EtX4nWj+Tz7MEmOQLu7d8TkiBTfmltAkrTy9d88SospUKBMhmx05Fpgde3SMFQoc8Nelq/TJUEmM/qcy006Q5B8OsXVUfj3GfA206E3mimb/nZvytC2eOZ9sVmaBGXfLeVGTYnOqXdj0tcnRYQkQPTiHvRf/wdLJkf6HULTLTB0ZwiJPQuhglf2ZKVY+RuC6ZPEcM3cucz59LluklFvsu3RLlOgdvwgsvOxhh4TmUd3ayp2jG2PsSYdZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03fAbckcn3VZ2oELkL935NfqiI3T/5Jt8EkzFzfqf9I=;
 b=lcbkgaWZj6Y6fpVadL3AXwtc2cKDgUl9e6+SgJx0/t+PgmgaTsIUUbML80BPJ1fUkxh6kYME6hI74ooExkbvaiOtelrFn/iSBxRyhZjBDkeUQNiYLJq4Uti3aIOaDTHERx+Qv//whY/02N6ynLxt15afar27c9VKy4AZk2aL3s0=
Received: from BYAPR10MB3575.namprd10.prod.outlook.com (2603:10b6:a03:11f::10)
 by SN4PR10MB5544.namprd10.prod.outlook.com (2603:10b6:806:1eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 14 Oct
 2022 19:12:37 +0000
Received: from BYAPR10MB3575.namprd10.prod.outlook.com
 ([fe80::7dff:790a:4cda:901a]) by BYAPR10MB3575.namprd10.prod.outlook.com
 ([fe80::7dff:790a:4cda:901a%7]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 19:12:37 +0000
Message-ID: <a7fad299-6df5-e79b-960a-c85c7ea4235a@oracle.com>
Date:   Fri, 14 Oct 2022 12:12:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 1/1] net/mlx5: add dynamic logging for mlx5_dump_err_cqe
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        manjunath.b.patil@oracle.com, rama.nichanamatlu@oracle.com
References: <1665618772-11048-1-git-send-email-aru.kolappan@oracle.com>
 <Y0frx6g/iadBBYgQ@unreal>
From:   Aru <aru.kolappan@oracle.com>
In-Reply-To: <Y0frx6g/iadBBYgQ@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::25) To BYAPR10MB3575.namprd10.prod.outlook.com
 (2603:10b6:a03:11f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3575:EE_|SN4PR10MB5544:EE_
X-MS-Office365-Filtering-Correlation-Id: 03325b28-75a3-4567-6879-08daae180ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fYInD38RawCGgAtPg5Jt7U99witkbln/+NF4u7DToG3DNesZ7LvYy7J95uXNn0INXIgE0x1D00yiLtfJxMJ9NdAl+0c8YqB1zSyIAIq4YF8ZJ2LHKlq1OiVDTlJpV9tCaUBeHI7Qf6nbFPHxd0mcrmgEyypxH27Lvjrt0Vxwh3y5JT8gEU2GhP42/RZxX+gWLAmPTysthjlR4ggsKFage7+5W/aUq+D7/xdsR0UfSR7wBkCEyBCEzynW55a2AJqgS4iGlWTfr4NADUXEDKGC/QeCVxS5vcw31brE60wsfo+flv3mSgqUu7QgPD5BsRvmoGV1f2S/X5dZV2s5mzytAEGeY3QsJ27Pjl4cqzCc0e7d7BVCdHu0rYsk/mFnfYPzrfLsiy9bt5PUsKTpoXTriUw7TBPrRcY3rTeyyjZp2tfvUFCPJ8TnaOwWMt9pw06t/sHw0B4fTosythu4FMdBZGuiYnU7oco8V/Udl+Y+QypThms1eRL6EgsQnNlfqaRT2UB/O9wh2Hn2cv7u1TpNv1mR8g8aF5xlp4w4SkizyrfU0VwOUpf51jptLC3f/y1DpVUF0tl6H2VGT0uwbIgSeqNzNp2HhdeMKg25iHuoJNtZ3A5NUln/TyHYfRjKj2md5tMx5UoXhZk4p10JlxQdUgdSHUm68zVfqWrhxsElkbKNe8nDfPSa1ODeb2H0kxk+jZJrhKS5EFBUf8ZX0Gqlmmpo60qqBxI314UkEr0quDBRAgkCj7nY1YiFNUAD2T59NXDMou742nNBCizk2JyrDT1ruk0mlCZaz9VvarrgesA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3575.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(6512007)(86362001)(8676002)(31696002)(107886003)(478600001)(41300700001)(6506007)(53546011)(8936002)(5660300002)(4326008)(2906002)(6916009)(6486002)(316002)(66476007)(186003)(66556008)(36756003)(2616005)(66946007)(38100700002)(26005)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFZVeHNPakFTcWQ1ckowOXVzT3k0VjNiczFSa3Q1ZlVPSHl1b2RLbFBIdWhs?=
 =?utf-8?B?QStzTldGQVJZalVkMmpQSGgzeVBZQWJoazlOMmVZcitUaFZEVnhLUGtXd1JW?=
 =?utf-8?B?OG50S0xVa0NyS3g3aFVQNGo1NHQ5aEJwYW5nZWFuM0VUZXJXMk5BRFpGRnNw?=
 =?utf-8?B?SFZxcjFTOHR6NC9QSVhodVBUR2NVWGFkYkNCVG5KUDB3ZnR2RzAya2ZWU1FZ?=
 =?utf-8?B?aTlzZHJoR1dDcG5ZUC9zRHJTREhsVEJ3Q1g2Y3JJTFozdG9qS0g4bHhUZ1Jr?=
 =?utf-8?B?Y3VwMGUvVVVCN3hsWkRKWmtVajJVQW9uR1RJeDdKWVNLVytpOHgzd3FNMm9C?=
 =?utf-8?B?dDUzWGY0dkN0OXNmUzI2SmhVeEtJVjhOc1RyMlhHRHROenlPZDRVS2pHMmVy?=
 =?utf-8?B?UFIzNGVpSllSTVpuUHE4OU1HaDl0eTIvMkM2akg5TFBhMStYZEVTWS9YdEs4?=
 =?utf-8?B?Ry9FOHNuSUh5NFl4Wk9LNkZ6Y2hqR2hvMi9VVjE4WDNNWGZRdytaN09tVnd0?=
 =?utf-8?B?Q1RkM2p4MEYyQ1pQdlorSE5ITVNRcHJSUGZhWUdsV2d5Wm02cEE4eWwvdC9D?=
 =?utf-8?B?VExMQ2VkaTJyM2tCR3R2S2N4U1lob3hIZGNqd2VmT2N0OHRXK0J6M1RiZ285?=
 =?utf-8?B?a0VUWGlxTlA4OUU0U3pFNmJiaCtBN0lPRVFPbTQwUncrandlYlg5Z1FOT3VK?=
 =?utf-8?B?M1ZRbFloSkZQVDRNTG9XSFE2L1hPNHRsK0sybkpZNTVmajFSUDZ6R1VPdHBK?=
 =?utf-8?B?S3BBUSttN3FTb05BTFhCTlVKZ0ZZeGJ2K0xMSjZJZ2ZUQkpHekJ0R1IzZUg5?=
 =?utf-8?B?eUtxRWgvQm9sdTNLckdYMWlFRVcrbnY4amxyRloyd2dmeERmZnY0WDhjc1RK?=
 =?utf-8?B?OE42TlJ0a3lNZmsrcStwNUFvNUV3TjBaaDUzY1UrWVNWSzZkMVlLays3bEkx?=
 =?utf-8?B?T25HTHpsdTdHaVlkbUI1NUlQaU9DVFkySVJDaW5DbjJ2dlV5QjlHVXFCQU5I?=
 =?utf-8?B?dWhFbTBRWFFEUmNkYlAwbVpYNXQ1UG1WVitoOWs5eVNVNElJalBlSGw3RE5Y?=
 =?utf-8?B?SmxmcXBaUGJwQmlGZVVOQlhOcDBaUlg1dnhqZXZIbXpPWDE3TjhKM3RmZVBy?=
 =?utf-8?B?Y0I4L014ZUxIam5zUFl3MXdWVDN6K2hMSitBczYvVzRxSVJYRWlkVGZMWVJV?=
 =?utf-8?B?OVhqSXdheDBVWSt0RkVaZ2d4TGJIZlFDMFFUdlBvWlFMaE45S0ZGUllWTG1z?=
 =?utf-8?B?L2MxTUxuZ2E0VVBEaVBmdllmaFV6QnhZNUlrSTBOTlRpZHFCMFZIMHN6cEdD?=
 =?utf-8?B?b3UzTk42SDlZc280bDdZbkhTS2JVT1czaFpvM09CQkJvYkU2eStIRU9ibjFs?=
 =?utf-8?B?VTdScGRNeTNnVXpYQnFYUlVKbDhla3lrcklLTUhobzFVcmYvQkVRWE9CQjlq?=
 =?utf-8?B?YXA2cEpDdmNiZG5GOEdCd2JNWWxPLzFtSmNpMHphbzhKVzFCZjlrRWNSS3Mz?=
 =?utf-8?B?cTl1VjhncXYzVkVYaU50RDFScjBQL1B3K1NZRnBjT1puVVF5WW9OcUxqYnFS?=
 =?utf-8?B?dmN1bjZJYXoycStXOFpLQ0gvdlNnUkZSejBZR3RRQ1o4cHB2T3c4dmFOdk0w?=
 =?utf-8?B?MlRIWXNkQ0w0SmVZaHp1OUE0d1JxN1YyZFEvVFdLN0tybGduL1hRWHl1SFEv?=
 =?utf-8?B?cG1xQmdPbVRCZ2Z1YWJrYUJ4bnVLbzNiYnFXdXNNZmVMRU05MVkvMzFCVE84?=
 =?utf-8?B?MlpmbzA2MmVCN2dhRDVMNFhlT1JPVEFPbDlGZGN4RXRLT3pYeGdOUlNVV2sy?=
 =?utf-8?B?ZGpmUUN6WHFJYXVhTVArL3haemllT1lFVnJKYVRNUnNFVHNHcFVreEQxSEtW?=
 =?utf-8?B?QmlkNFdFd3U1cTE0QndRcmxaQ2pwVEFLV29pVDhLdHVLamd3TkcxUXV2aXdZ?=
 =?utf-8?B?K3I5clJUTTM4OG5GNzZFdENtNndjRjRmTnNTQ2p6ZmROM2NUbDNvYUpIQndy?=
 =?utf-8?B?bHJiTEhndjJHdVVoMDBsa3doRUxPUWNRMXM2aXJ2M21NcjN3S05wSTFtT0tQ?=
 =?utf-8?B?MnFNc3FYWllGamNKNlF2YTdiU0E0NlFEak1SdGNhYVNQOFFaTzN6WlJyUUhu?=
 =?utf-8?Q?xJWUmvHjegt+OlNdCx8iTfMKY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03325b28-75a3-4567-6879-08daae180ead
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3575.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 19:12:37.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JseOTHE0E++4IYPtJf2fPZDVRjWrlkMYQy9Jqw86310Vwj5UFlJsHpheZR3SfeX9jmhofmkB9lOq4CCjcxoDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_09,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140105
X-Proofpoint-GUID: NjjC64cakt_dk-ErGKD4JW41vJDAY6Hd
X-Proofpoint-ORIG-GUID: NjjC64cakt_dk-ErGKD4JW41vJDAY6Hd
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

Thank you for reviewing the patch.

The method you mentioned disables the dump permanently for the kernel.
We thought vendor might have enabled it for their consumption when needed.
Hence we made it dynamic, so that it can be enabled/disabled at run time.

Especially, in a production environment, having the option to turn this 
log on/off
at runtime will be helpful.

Feel free to share your thoughts.

Thanks,
Aru

On 10/13/22 3:43 AM, Leon Romanovsky wrote:
> On Wed, Oct 12, 2022 at 04:52:52PM -0700, Aru Kolappan wrote:
>> From: Arumugam Kolappan <aru.kolappan@oracle.com>
>>
>> Presently, mlx5 driver dumps error CQE by default for few syndromes. Some
>> syndromes are expected due to application behavior[Ex: REMOTE_ACCESS_ERR
>> for revoking rkey before RDMA operation is completed]. There is no option
>> to disable the log if the application decided to do so. This patch
>> converts the log into dynamic print and by default, this debug print is
>> disabled. Users can enable/disable this logging at runtime if needed.
>>
>> Suggested-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>> Signed-off-by: Arumugam Kolappan <aru.kolappan@oracle.com>
>> ---
>>   drivers/infiniband/hw/mlx5/cq.c | 2 +-
>>   include/linux/mlx5/cq.h         | 4 ++--
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index be189e0..890cdc3 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -269,7 +269,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
>>   
>>   static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
>>   {
>> -	mlx5_ib_warn(dev, "dump error cqe\n");
>> +	mlx5_ib_dbg(dev, "dump error cqe\n");
> This path should be handled in switch<->case of mlx5_handle_error_cqe()
> by skipping dump_cqe for MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR.
>
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index be189e0525de..2d75c3071a1e 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -306,6 +306,7 @@ static void mlx5_handle_error_cqe(struct mlx5_ib_dev *dev,
>                  wc->status = IB_WC_REM_INV_REQ_ERR;
>                  break;
>          case MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR:
> +               dump = 0;
>                  wc->status = IB_WC_REM_ACCESS_ERR;
>                  break;
>          case MLX5_CQE_SYNDROME_REMOTE_OP_ERR:
>
> Thanks
