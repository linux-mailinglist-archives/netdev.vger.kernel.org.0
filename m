Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159654CB234
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 23:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiCBWXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 17:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiCBWX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 17:23:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6779C4C405;
        Wed,  2 Mar 2022 14:22:43 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222LxBhq007646;
        Wed, 2 Mar 2022 22:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KQmAGm3yHG3oicag1R7882w6bnwsD118xVWd5/B1TF4=;
 b=MsLMNUKPirqP37jPIdT4XZQvyvDTk1gQqAyqiVMaVaccwpRIpRjB7QqzBEcWo2uOcI7Y
 FaQmPXVudDgqO28O2TPW018hEmkA19mrWdNNK1GmyUQTtHeB3N4JOZALY743LvXuWklG
 i3xpFqauYBOwQSb9frkIx4oqksMlb4A42lcBSXjTFXaoQP/KZ/TVPeb009h++TunDtrh
 IeI5+VPfj8sMXZ8vhF+5euB8JPA9mpNqfa5FrM2RwyYFjxJTsFeAfCt54ZXuJ1fZbrWy
 nevIgxegGZUJ5OO1ozjDgWmb9cZHALrmldKDVnuoiFVunMqPTrjhzJpLinW28GRJ5zOm 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15apynn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 22:21:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222MC4Sw188380;
        Wed, 2 Mar 2022 22:21:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 3ef9b1uyyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 22:21:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYpnHfiApfnJ7I8n6AZgM+j5ki0N9D4YPT7H0ogb/ZDwhG7tagn8fGevuVl7n59PdKyboqkGY4zf7zrk66SLBUfkE/dHEtWQrQhmwr3kzKSFiDw4nF45EOyBg3ZX/NHAIGcdsSfWFOUYV50vzYqJX8j2qMqnyoJMBFTTHSMrEidvcToUFtIHZSFTQxzDIJ1gma4fGeJsuiQ7h9ftooV28Nh90S5f2DSBFgXfAPMy/mvL+SiMdIyym2yqxhglxtLOOGPmr/d6W4jbbHaoHV0Vdiz8c27goJVs3szxzVJyG8N0X+rAS5yLI6p9RbyWkAjo2vAOKro/JTMKSCkLZCERgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQmAGm3yHG3oicag1R7882w6bnwsD118xVWd5/B1TF4=;
 b=jOhC8PVxqAjDABzWgvPttPgAqLGehYxry33+7R02nfbpoIgJNtYW4Zpn7xOCj2TLZUyiPCRybgaeEolTVgZBCOCy5RwDL4OOKzwQ3MZEcpCScGjyGMw9kTFba5GrucTOV84K07woWfXiuRlbL/oAPGkc0TuMsrnOAnSv5d8dJGWoY66sAftM7EkcC8chpvPt9NvmOVEUz4aZNzzTsd06v7DZqOlB4+YdgqOB+olLiJR8bvgWYuSZEnHFiOuD5wrg9qTawntqXYITSzbE0yHHV1L3aJkY+BK6GUofdB/uvkihy/DLGbV6Pacz4Hb5fbDVKqVQQiP8ejIm9zX+Z7Q+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQmAGm3yHG3oicag1R7882w6bnwsD118xVWd5/B1TF4=;
 b=a9z9IYPwyltCvmI/7Iar6hXysgdZMQx03qf5SjZ1O7IgtCk3pfKF8GFjSQc+zdUDy1BD7hkYxCEusT2mGqNOXRemoTuGRhHTJCr6R96v+HHyCf5c5JZkKGE8qZ8JnieST+74ie7berlOtfRLAz8326B1d9EpGjXNnAlglaCKHFY=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO6PR10MB5441.namprd10.prod.outlook.com (2603:10b6:5:35a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 22:21:35 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 22:21:35 +0000
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
 <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <ca81687c-4943-6d58-34f9-fb0a858f6887@oracle.com>
 <20220302111731.00746020@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <e3bc5ac4-e1db-584c-7219-54a09192a001@oracle.com>
Date:   Wed, 2 Mar 2022 14:21:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220302111731.00746020@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::32) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7854e363-24e0-4cfe-9641-08d9fc9b034d
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB54415E131F487BAA0DA225E2F0039@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2icl/UftXbNmXU5137KoBz54jIpbDAx3h7LoXm1zb/2ype9cxlo6+u8161jNQdFddc+ZFs/h+ip4nPwIBYlTEQ5OtisjOZSFsSXO5c9bfdxKzQx4Pvq+2Vvqf5gCO/yCfQyfRkW2PQ2zhb+IQjJxa+8QodXFB/1Ce5RqAhdY9I4ThpbZOqhdJaQ1Cor/KQfR/9nRTzNc7+Q8SaiHovLjRP0vfNirrXb4pVhFIdHfGWVWtlKmfcNuk2jWMqYctAJkdnwvUsGt2bXn/AyPbx1Ncxg5fK0thkAa9tyaa8FKhS9x4HndXhXA9AzTs3vwocrMjMpkltse2OE4D7qNlDVvUvXWiIEXaEOTkDvBpyFK3QacAU3WOAZuTbu+Km+DXlryndWzoob7TU4wcBE+DvJ90aHQkMmxfdJq2cqR8XyvcfS+7Owsikt73p+yTUKsXHc3rJKbssQMo/jmUa44DgqgS2lLBLIAId+EFUewwUOP8zkty2T6DrS/S1usPp3BarJjVnLgU04FpaTmqRWkPpvKVPMzOejEbQKJF+FqdwyCLVp2EKPoqSB9A2Inxvr9rMxflCdfkXfy/maQmyU2oEFhlJ2NPZigySfuYVXHqvggVs26HtGMOaBqyTussZtmpz4G5VjyQlRJLgDy/edNR8HV4Ec3JvhJixcOssRjs8hjLjTlF63FjuRXydS6soRjI9xdjNpZQBLx3N7zMLFm9zr+6nnutAxZ9E5yUrsEEmYOtYllnZvNAK29cSqPCw8NaRK8lV3A2+U5jIzad9QYkZkHcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6512007)(6666004)(6486002)(36756003)(53546011)(508600001)(6916009)(8676002)(31686004)(316002)(83380400001)(66476007)(66556008)(66946007)(4326008)(5660300002)(31696002)(8936002)(2906002)(86362001)(186003)(44832011)(2616005)(38100700002)(7416002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnlNWVd6VGhTVjJrcFlZem1TRktHOWk0NzJ1eFJLNnVlVlZJWUdtUUJwYkFF?=
 =?utf-8?B?anp4WWpLZngwYlZqUGwzaU1VTXZZZ3kxSXNoZzI4eTk3T1N5aEpyL2t1YU1p?=
 =?utf-8?B?ckozRDFGOXpBS2JEQ0NaSWRsYWlmZ25jRjJTMWZCMHJCeVNZUUR4NEQyTzN0?=
 =?utf-8?B?d0ZVRHovZnRQbHYrTC8ralB1WkJYOWxMZ1hqU0hxOWhOUkR6Y3Jyak1kdklj?=
 =?utf-8?B?Q0FrRkdPcExjVldlNFhXWWZsQWl0QldjUjEvcDFJcGJ3bkMrajVnOS84Ukg1?=
 =?utf-8?B?LzhGS1RRUGlEREpHcERGRmI0bHA4R0ttN2VTNlQ4SkVXeHQveVd4Mmlpakdl?=
 =?utf-8?B?allHTEZYeHpsN1FzaXhiL2ZqVEdzUmxJcHk4YU9Ma3pNN0tSNm9MTHpESEF6?=
 =?utf-8?B?SjZWUGo5bFV2RnJaUndYSmphN3BrditPTlI1Z3hNMEFseitUUnR5ZHFSM28y?=
 =?utf-8?B?SDVmcGM2WmU2VVBuSHJiQmxQZFdmckp5eVk4N2FENHY4SDdQYVhuS2lzZFUw?=
 =?utf-8?B?dDZHQjY0M3FuWDFQdDc3dnZLM25UUzJIK0R4SkUvU3J5aGl2L2I2VHdtWFZU?=
 =?utf-8?B?bm1Jb2pqYTJHZFM3aWsxZHhuMFNYSmhBUmFySU5laEwwTk5xQ3piUy9GbmdR?=
 =?utf-8?B?ZEQ4Q1dmVUhqMmthdTlTZk5WZXVZNUJNZ3Y1dGdnbUZxV2VUenJWRlRPeVJy?=
 =?utf-8?B?dE9VNThibTRqbGxiVmhVL1QydU5aWGlVbkJleUdEVnlsMk10VDlpeXNoTUJS?=
 =?utf-8?B?MkJRVHBBY1hsanRWVzNldVo2UzBEUjcvWVY5YWg1T0VJeHlFeTI1dThUcDV5?=
 =?utf-8?B?RUFuWjN3TTJ2dkk1QWppRkxPcm92NE9YNzBzSllXT3V6U2FKUmM1dXBQeHZm?=
 =?utf-8?B?UXBYZkJIdVJ1TE1xZzJpQ21RVEJqM2M0T3FkQjVINVBYVXk0U2ZjU0lnUjBr?=
 =?utf-8?B?WTBDeEczS0Ewa2R1MWQ5MW10SkpZRmdoSDgwMXVpY1p6eHN2U29pcTc5VkRs?=
 =?utf-8?B?Zk9vdXZOZ1hyYllSZ1NrVHcxQ1pLVEFZTmV6eS90QmF0K1d3UFdEVk9ZRUNn?=
 =?utf-8?B?WlI5ZUNqRGtHcGFFVzVmUXphTW9YOVc0NlBXYVNuK3RFRFd1Tk94c0hYS2JY?=
 =?utf-8?B?TFR1Um1wZjAxeEp1SjdJNFdmcWNIYmxablJYeDQvZE15Zlk0ZkQ2am1Jblcz?=
 =?utf-8?B?eHVBMnpSY21mQWlEeVB0dC9lQjJhaVpkVzYrbFBiQVRWL0pzODlESmZIRVUw?=
 =?utf-8?B?YWh4VCtGUlF0c3JISFUvMWJwNmp6UWNoRGNWbURlM3ZGenRYRktPd3FNZDls?=
 =?utf-8?B?NHdNZG9OUm9SaUlBV2poSGVRSDJmM1BtOGZ3RmVETVZGQUU5elhsQytJR0VH?=
 =?utf-8?B?TTMwcTlSSzZFaHRyVTVLVTFwSmlrcEtYN1dNVnZ4bjU5dWk3eVVxRlJvQWh2?=
 =?utf-8?B?ajB2WmsrbTlsTE5lNjl2NVlWZkI4NDZPWFhDZ2h2TzZ3bDFGRVViV3VWOUxV?=
 =?utf-8?B?ZUdUV1Z1dnhwUXFXMXA1Yk5wK0dTS0YyUXRXdWQ2Q2F3dkNDc3hhWHVDT0R0?=
 =?utf-8?B?TXNjNkpZNjE1UDVKdWxSVDY3T2NSWkY0Z0hCNzdWbGlVeHBTOUdFYzJpaDd2?=
 =?utf-8?B?YWl0RXVQZHFMRGhHY3ZkY1BaRVQ5dzN4L1c0a2xlVEtsZkE1V0w4S3d1Tys4?=
 =?utf-8?B?MlhHeHZrOXBFVzdlV1hkN0JQa2ZsRjUyeTRZS08wa1Rpa1dLV2hJRmZ3bXAx?=
 =?utf-8?B?dEhKTDgraGVpY3E0YVZYTU92YnFodERzaGEyMTZQL1dPK21TODUxdDY1MTg5?=
 =?utf-8?B?VjFkQnlJdFlQSStqWm92Uk9NTjhFL1ZSWHNNVGxRRjg4U0xKYVRwVGcwazFU?=
 =?utf-8?B?ZVZzaEJGNTlRSy9CZ3lYUXdwNUptQkM2TEdpVW5oMGc5dUJPZmN2bzRUSlU4?=
 =?utf-8?B?TU14Y2xQZU95bnJQYk9xQ0w5Vy9BSTdyN094TnBzNm9obUxZR3J3MXJXV0Fp?=
 =?utf-8?B?a0RIVGZnU2V4NVpxTExCZDZWRXFpMTMzWjdNekozRG54YUc1MFhMdWdiRWNh?=
 =?utf-8?B?Z29Vc0FuQzgxa1FwMXBZbE1ZM0lYT0wvN1BDaVN4ZjBScEFaSS96NzlleTJF?=
 =?utf-8?B?eklHY2xEcjJzV054TXVhZUxWOU8wMU8rZk5YekJGc2JPY3ZLdXF6MSsyOUZY?=
 =?utf-8?Q?3SQ4kMuc2iICQNG+3DV8y4dxIiftS5eWHo5L0ULovtuB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7854e363-24e0-4cfe-9641-08d9fc9b034d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 22:21:35.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQLD8zzdfDR/OqVfryYmY8QaGHmZYAF9iWPZhWFhEOZ6dHYgDZAA8u84Lgbalm5Y8w3kAbLNTNXBnvxAZe2U+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020094
X-Proofpoint-ORIG-GUID: M9bnFMr2C6JacoQ_uBrsTqjvwSzd7_5U
X-Proofpoint-GUID: M9bnFMr2C6JacoQ_uBrsTqjvwSzd7_5U
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

On 3/2/22 11:17 AM, Jakub Kicinski wrote:
> On Wed, 2 Mar 2022 10:19:30 -0800 Dongli Zhang wrote:
>> On 3/1/22 6:50 PM, Jakub Kicinski wrote:
>>> On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:  
>>>> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
>>>> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */  
>>>
>>> IDK if these are not too low level and therefore lacking meaning.
>>>
>>> What are your thoughts David?
>>>
>>> Would it be better to up level the names a little bit and call SKB_PULL
>>> something like "HDR_TRUNC" or "HDR_INV" or "HDR_ERR" etc or maybe
>>> "L2_HDR_ERR" since in this case we seem to be pulling off ETH_HLEN?  
>>
>> This is for device driver and I think for most of cases the people understanding
>> source code will be involved. I think SKB_PULL is more meaningful to people
>> understanding source code.
>>
>> The functions to pull data to skb is commonly used with the same pattern, and
>> not only for ETH_HLEN. E.g., I randomly found below in kernel source code.
>>
>> 1071 static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
>> 1072 {
>> ... ...
>> 1102         pulled_sci = pskb_may_pull(skb, macsec_extra_len(true));
>> 1103         if (!pulled_sci) {
>> 1104                 if (!pskb_may_pull(skb, macsec_extra_len(false)))
>> 1105                         goto drop_direct;
>> 1106         }
>> ... ...
>> 1254 drop_direct:
>> 1255         kfree_skb(skb);
>> 1256         *pskb = NULL;
>> 1257         return RX_HANDLER_CONSUMED;
>>
>>
>> About 'L2_HDR_ERR', I am curious what the user/administrator may do as next
>> step, while the 'SKB_PULL' will be very clear to the developers which kernel
>> operation (e.g., to pull some protocol/hdr data to sk_buff data) is with the issue.
>>
>> I may use 'L2_HDR_ERR' if you prefer.
> 
> We don't have to break it out per layer if you prefer. Let's call it
> HDR_TRUNC.
> 
> I don't like SKB_PULL, people using these trace points are as likely 
> to be BPF developers as kernel developers and skb_pull will not be
> meaningful to them. Besides the code can check if header is not
> truncated in other ways than pskb_may_pull(). And calling things 
> by the name of the helper that failed is bad precedent.

I will switch to SKB_DROP_REASON_HDR_TRUNC.

> 
>>> For SKB_TRIM the error comes from allocation failures, there may be
>>> a whole bunch of skb helpers which will fail only under mem pressure,
>>> would it be better to identify them and return some ENOMEM related
>>> reason, since, most likely, those will be noise to whoever is tracking
>>> real errors?  
>>
>> The reasons I want to use SKB_TRIM:
>>
>> 1. To have SKB_PULL and SKB_TRIM (perhaps more SKB_XXX in the future in the same
>> set).
>>
>> 2. Although so that SKB_TRIM is always caused by ENOMEM, suppose if there is new
>> return values by pskb_trim(), the reason is not going to be valid any longer.
>>
>>
>> I may use SKB_DROP_REASON_NOMEM if you prefer.
>>
>> Another concern is that many functions may return -ENOMEM. It is more likely
>> that if there are two "goto drop" to return -ENOMEM, we will not be able to tell
>> from which function the sk_buff is dropped, e.g.,
>>
>> if (function_A()) {
>>     reason = -ENOMEM;
>>     goto drop;
>> }
>>
>> if (function_B()) {
>>     reason = -ENOMEM;
>>     goto drop;
>> }
> 
> Are you saying that you're intending to break out skb drop reasons 
> by what entity failed to allocate memory? I'd think "skb was dropped

Yes.

> because of OOM" is what should be reported. What we were trying to
> allocate is not very relevant (and can be gotten from the stack trace 
> if needed).

I think OOM is not enough. Although it may not be the case in this patchset,
sometimes the allocation is failed because we are allocating a large chunk of
physically continuous pages (kmalloc vs. vmalloc) while there is still plenty of
memory pages available.

As a kernel developer, it is very significant for me to identify the specific
line/function and specific data structure that cause the error. E.g, the bug
filer may be chasing which line is making trouble.

It is less likely to SKB_TRIM more than once in a driver function, compared to
ENOMEM.

I am the user of this patchset and I prefer to make my work easier in the future :)

> 
>>>>  	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
>>>>  					 * device driver specific header
>>>>  					 */
>>>> +	SKB_DROP_REASON_DEV_READY,	/* device is not ready */  
>>>
>>> What is ready? link is not up? peer not connected? can we expand?
>>
>> In this patchset, it is for either:
>>
>> - tun->tfiles[txq] is not set, or
>>
>> - !(tun->dev->flags & IFF_UP)
>>
>> I want to make it very generic so that the sk_buff dropped due to any device
>> level data structure that is not up/ready/initialized/allocated will use this
>> reason in the future.
> 
> Let's expand the documentation so someone reading thru the enum can
> feel confident if they are using this reason correctly.
> 
> Side note - you may want to switch to inline comments to make writing
> more verbose documentation, I mean:
> 
> 	/* This is the explanation of reason one which explains what
> 	 * reason ones means, and how it should be used. We can make
> 	 * use of full line width this way.
>          */
> 	SKB_DROP_REASON_ONE,
> 	/* And this is an explanation for reason two. */
> 	SKB_DROP_REASON_TWO,
> 

I will expand the comments.

Thank you very much!

Dongli Zhang
