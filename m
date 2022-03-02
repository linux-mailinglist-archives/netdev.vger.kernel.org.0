Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AEF4CB18A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbiCBVqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiCBVqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:46:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F32EB563E;
        Wed,  2 Mar 2022 13:45:34 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222Ix99T032664;
        Wed, 2 Mar 2022 21:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bdDAdPYQ8OYJiMAFlRcVRtj8tRbAoXfzDL6O9tyiS20=;
 b=hf1AULuj+rHLFueh1wMnXduMtmm2rGE/Q5MO2cyGfpwSNKRYbZmbAuKYfqQSGJd7pIru
 J4CiCr6pCO307xZxYSDT1iOP52Go9QkOwxO5XKK+dGbUqGGFol9UQb9f10qQRF5UcEIX
 9yUPqAxlk5A+ueeCfZLhPyaK9s1CF7890swpzJqh0DMpNVGDkjQ+SGQ4gLLpm2V+Qyzh
 iGM/c4NfURRVE7fP0hYuhT+i65LXFDEEhHU+J7Z/qbpSedAQHs07KhE2/r2DW8Q7U/Wv
 Y9sfxWOJdBgKCx2SRd1u66eQ1ShxImeuYQWFToofV1BCqFGzbVpNfa6z1Xdw00f4lrUC jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehdaywfaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 21:44:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222La4Yg110163;
        Wed, 2 Mar 2022 21:44:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3030.oracle.com with ESMTP id 3ef9b1tqxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 21:44:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBV+tSyWlASTt2P3ONtOcanST+/Y3iZWBvCgs8Fg4U7RO6LGVHdv/51qqU61n1IvzARLjWkOpc2F8SFdI/eFzqKqoRofJgwdXv0tKHyWAK1gvLMKCLmDJxYQ20EF2/K9bMUL1dEeC2KG5NJ7J+Yc0t3BIQIXxzdZHRkbNuq1qyPT0mZGnKfMBuToMG/TADAQCpVAVXHRjcIsJlGMm6jEWuYtvEcHpyRzDvivXUgy2MxTtKCQVtOvjlqk8b9Wz8442EIx6GlEYASMdtI0rtarXzpSucjHtBXWqwfzetbFX9VfzUux8zKnG3KY82DzVTFbxrVW3J+f4cz+kAu5ZVkPAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdDAdPYQ8OYJiMAFlRcVRtj8tRbAoXfzDL6O9tyiS20=;
 b=SGzT1rcxaZ+CzPJdNbSknEjG4v3/KPVc4sK7u/77Nv9AhTgWUP+rIARQYrGoeTNOj0xsFhzWBgWFk8MnvZOf9lUleoxflt4dZ896m3pLDqnUNfVRZlpUzSwIwBWkAdBgEGMvXcMaCb2xW09bV9xlLPrM9EDdeabjQI0Ar0iuUvLL7BNheH3LCyUYmlIoGn5Hw1c48W4IuPGhip+Nqn0pun04IeUebnCmEiktoIz1q94lyFD97dg5iA3A9E0qNtoPKKtiJYq1RImifa4aiu2mY2saqNWIfd+frUJd0Lb9Z8O8apfOgDaBIm5Nt/ZAAtppDNqvDtQHCTjd9z1r+pUYbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdDAdPYQ8OYJiMAFlRcVRtj8tRbAoXfzDL6O9tyiS20=;
 b=cG5B0xchNKjULkZUw0N+EiejzBBA5cy/N3QxhwpL/xwTvYrTf5QzAICcqrhBd82WG+FlBFzT9U4926Xj4Mjd7+OOzqMXZF2XoXoREolu3pfj0IgIK37ev6xwJRRQy3SmxGejI+bxLhqUynxU12OgW2FXsgKYbKpLqi3lrJENEa0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR10MB1677.namprd10.prod.outlook.com (2603:10b6:301:a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 21:44:24 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 21:44:24 +0000
Subject: Re: [PATCH net-next v4 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-3-dongli.zhang@oracle.com>
 <20220301184209.1f11b350@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0556b706-cb4d-b0b6-ef29-443123afd71d@oracle.com>
 <20220302110300.1ac78804@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <92322369-abb6-be0e-ab52-1d1ebbe38a9c@oracle.com>
Date:   Wed, 2 Mar 2022 13:44:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220302110300.1ac78804@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0072.namprd05.prod.outlook.com
 (2603:10b6:803:41::49) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58d1841d-9440-4df0-34ce-08d9fc95d154
X-MS-TrafficTypeDiagnostic: MWHPR10MB1677:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1677D67B9A80F5E1C863B1E8F0039@MWHPR10MB1677.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5lIRByXw6cWc9XrGiFcOQ1eTY3Vrpyf5WqDIVAwzdj1KesnIMJekn9IjHdAZRF2TysK4VtVtA5fEM8nSNeI5k7pUBZGPkp8PM3xSGBEH/Nc3MQEGKzvk1tiZX4GDFf0zA4yGeDVOuKRhQTOk//v8CdWKpSX5aTVy/Sudq2bSe/N9oKhZn5PzOIXHFkXLiA6gq1WSfMDoV8IncxoGEIvJyeN1kUUYF8eAC7oW7NRDbLHXtAIouGcAMBVxm70xU59JUYxZi0svuckA9EzgJP9MtWjb6+eZd4mb2bWgOYOBI+nOklvhxrQUGdVOo7O55scCzHo2Y30BOBsHeHguIPJpk43nzjkezXPlu9yliGBPgwX1YfL9ipwE7Sa4pQfkK5jnpccCQFj3TSnjOJBOXVTNYNsvU2tI6UZZw7JkDsUmdPaWDpr7pNry+O0mNdRLVpCD10S2avcCOH565+Prum+6bEhio/el3K+s6XkbmzKqqTEhp8sTZ/aCwW+QEoFqtHDIQ5F9umze9qnsR6bnYWYyikpiVzG9/IdClUNaI+qI+gQTikoa8YMTYQT8vyuCTOxA9VNbnB3Bnn9bfM6A07K0dAsPPvwGsGnlFIB8RM0fLML8hzQCIB62vtPkYAMfA8RUcwUH9Xj6/ybW98iEwtxtIJi4uLpcUbwQDpeMAohVQcZDGXxexz+Plx6vqYWB1aGne6XhIZQQEaFOkBeDRtc6R9Z5hPFY4Bu8ShICwoyfco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(38100700002)(44832011)(53546011)(2616005)(6506007)(6666004)(2906002)(31696002)(86362001)(6512007)(83380400001)(4326008)(316002)(8676002)(66476007)(66556008)(66946007)(5660300002)(186003)(8936002)(6916009)(508600001)(36756003)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVd1UFQxemdRaFUybkdZY1FmUjl4M1dJWjhjU1BWNG5kWkc5TXk3T3paNEY5?=
 =?utf-8?B?U0llVVY5elIrQjg0bFo0ZTFpR1pFcHljbnhHc1RXMVhkK21FMTVVS2d2MlVY?=
 =?utf-8?B?YnA1NUU2ZnV3YlM5dU8xRDRYWDlSUDFPNkxxWmVCVm4vR3J1OUtTc1VsdUF3?=
 =?utf-8?B?dXRRZGxaeEc1cHpoNU0yNTBUTE1Rb3ZOcWVuVjg3b0xOTzZYMFUxOVI3aTZP?=
 =?utf-8?B?YXZiNmdJTzJ2WkN2T0drcTRZcUd1OVpRR205NHNMb2hLQjBBQjIxZmxZYXV2?=
 =?utf-8?B?Skg0L1ByNnh2YUV4TDJWL0JNNGpmSkZoNmhMRjFGeG04S29CSDJIaFlBZHd0?=
 =?utf-8?B?WFM2YWtUcVIvTWxIcXIzSkNVVThSWTlnNThoTHJ1L2M3azhMWDg5WmtXM2FE?=
 =?utf-8?B?ZU5NcjZHblljY1lDbFNldWE3YmNrdFN1QnRwUHV4a1NvYjl0ajQzSWFpcGdP?=
 =?utf-8?B?eWlTZWJ4aERFeWUwQW9KWDF4RDZJR0lGbXlUQzhiMWxNVG5XeElMcUlnUUFh?=
 =?utf-8?B?UHFWVGVyNXRKODZSYmcyMnJJWkRvT3pjT25YQzFUNnF0Slk5d1RONmRMRHRU?=
 =?utf-8?B?U3VVSFU2bVViaE1oR3lIOVJMd3lUSHllMDRabWZGb1dIV2NmSHFnb0lqNUdF?=
 =?utf-8?B?VlU1TEd5WmdhOCt3VVZkRlExMkpqcnRkUTlsTm42ZUQ0U0lvOXFWaW8xNXU2?=
 =?utf-8?B?alF2bndhajI4ZC92QVJjalRTTVMrakJXaFd3WFBCaUFvM3lPQk9wY3hKTW9Z?=
 =?utf-8?B?Nm9DQ2VUdElLdCttbEU4YVZDTEIzQmRMVFpydnU4ZWI2R3lqclhZTkpWTUxh?=
 =?utf-8?B?SUtFMEVEd1BPN21adVk1bkpQWTdWd3VHdjhDZElZRkFUWXcxNzk2MFFOQ05z?=
 =?utf-8?B?OVZyRGh1STlVSXA3MnJ0M0pBdk5tQ01LakJqSFlNbVREcmxjQkVhQkwyYXR1?=
 =?utf-8?B?OGRWS25jckF2SXRQUzdQcWw3bWR6eGxsRFVIT1pRVy9UbzRad0M1TWpoK01p?=
 =?utf-8?B?cm5kbVNhRUpmNHY1MmY2endORVVJdWZLRTBDWEg3NjEzaUNIQTZYZDk1WXFr?=
 =?utf-8?B?VnFHNGlEeGU4dFpINmh5Y3Q2R25IV2NsbThKMjdINWhBTGUrME8wSEdWei8z?=
 =?utf-8?B?TGMzdUY3YzIyR2E1UEsyR0NERmhVT1F5b05nTUlCK2R2TXkya1pJRUpVZU5t?=
 =?utf-8?B?UGRUYytvTmhXS21Wclc5Qjc1NWxrWkI2djFvb2lyQU51RmlqUm5DVWtIZGpy?=
 =?utf-8?B?TFF4eUcraHJkYUthNUNydHRyaGc4elQ1QklZNVNIRDdPSlJpd1Bqd2RPMXdY?=
 =?utf-8?B?MkNxYVR1SzYySDV3dzQ1R2dIY3JmYXBzQ3FEamt6Tjh0U0pLNVlLd3M3Wll6?=
 =?utf-8?B?L1Z6Y2o4aktyNlZnVE5EdzhlMDJYTzc3anhkQ3ZqN1d3OXUyMm9IK2VWdjQz?=
 =?utf-8?B?TjhmMGNucU1WMXpiRDBsQTlodGZLTzRmV3FGZjVZc0ovc1FNZUpjVGJjb29V?=
 =?utf-8?B?RXBCcnhVMXBIazhUY2k4ai9xTkxWckpmeTUrRnNldU4wck5pYjA4VEtkUFlZ?=
 =?utf-8?B?TGVVUmovYUU3eTJsRFpTTVpXdWdPVkV5UlRSbVdFWXYxc0ZZWjA1RjlRbS93?=
 =?utf-8?B?dE4xbGFFbm1Sck9EM1J4OUNOWE9WeFlMZ1BnZmVobkRhMXdRc1VzVzZ5dzVu?=
 =?utf-8?B?bFpNVDUydEJaOE9NZFhqbCtJVzJ3MG1Yc2VTV0lDN2ZJbGVlalQ1cTJMRm1o?=
 =?utf-8?B?VXgxTFg4S0RYRkdtL1lzYVAyQlJtUmp6aEpqdlpibDhMaVl4UHJGcWtraEEx?=
 =?utf-8?B?K1BSRmF6aW14NFlLZWY3cXVEa043STdBcHZtWk1TZlByVUFSU21WdkE5UVFs?=
 =?utf-8?B?d3JpZnF2QWxyQi9MS2YwUDFLYThLeUNnS2FTeTV3YkxrSGJEODZjZTVBQ2xD?=
 =?utf-8?B?L09hTHdOTWhxSVdhaDRCWEFRRXM1VjlTeWo1ZEk1a25CVG9mOG15QnY4elEz?=
 =?utf-8?B?ZVh5Rjl1MHN1Z0dVUjM0bzNQTXhndVhWYy9RUko5S3RtQXVaMmVOc2xMYVB1?=
 =?utf-8?B?WCt2YVR0KzJGS1lQbDdVeGRXNWNRYkp3Z1d6MVdIWXo2SG14OWYvZDIwOGxQ?=
 =?utf-8?B?RVhoL3d5c0JaWDdmMTE3V2ZXOE1JWXVFS3NBQVVSaUJXME5xSUZqSmliOUQr?=
 =?utf-8?Q?XuIFcOez49sn4MDFnInKvdOius26nDlMMDbBoHTf7bRI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d1841d-9440-4df0-34ce-08d9fc95d154
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 21:44:24.4262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsmwEv2EYhGlg74b38nRMrZKphjfQBN190wX6pfGNU3WcHcDREv457d572yUnyLqoFw16axI92PBwIwjg01Nrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020090
X-Proofpoint-GUID: P4-3B6yEJLPD5CJT7V1HLy7y-zs8_jM8
X-Proofpoint-ORIG-GUID: P4-3B6yEJLPD5CJT7V1HLy7y-zs8_jM8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 3/2/22 11:03 AM, Jakub Kicinski wrote:
> On Wed, 2 Mar 2022 09:43:29 -0800 Dongli Zhang wrote:
>> On 3/1/22 6:42 PM, Jakub Kicinski wrote:
>>> On Sat, 26 Feb 2022 00:49:27 -0800 Dongli Zhang wrote:  
>>>> +	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum error */  
>>>
>>> Can we spell it out a little more? It sounds like the checksum was
>>> incorrect. Will it be clear that computing the checksum failed, rather
>>> than checksum validation failed?  
>>
>> I am just trying to make the reasons as generic as possible so that:
>>
>> 1. We may minimize the number of reasons.
>>
>> 2. People may re-use the same reason for all CSUM related issue.
> 
> The generic nature is fine, my concern is to clearly differentiate
> errors in _validating_ the checksum from errors in _generating_ them.
> "sk_buff checksum error" does not explain which one had taken place.

This is for skb_checksum_help() and it is for csum computation.

Therefore, I will keep SKB_DROP_REASON_SKB_CSUM and add 'computation' or
'generating' to the comments.

> 
>>>> +	SKB_DROP_REASON_SKB_COPY_DATA,	/* failed to copy data from or to
>>>> +					 * sk_buff
>>>> +					 */  
>>>
>>> Here should we specify that it's copying from user space?  
>>
>> Same as above. I am minimizing the number of reasons so that any memory copy for
>> sk_buff may re-use this reason.
> 
> IIUC this failure is equivalent to user passing an invalid buffer. 
> I mean something like:
> 
> 	send(fd, (void *)random(), 1000, 0);
> 
> I'd be tempted to call the reason something link SKB_UCOPY_FAULT.
> To indicate it's a problem copying from user space. EFAULT is the
> typical errno for that. WDYT?
> 

So far the reason is used for below functions' return value:

- tap_get_user() -> zerocopy_sg_from_iter()
- tap_get_user() -> skb_copy_datagram_from_iter()
- tun_net_xmit() -> skb_orphan_frags_rx() -> skb_copy_ubufs()

I will switch to SKB_UCOPY_FAULT.

Thank you very much!

Dongli Zhang
