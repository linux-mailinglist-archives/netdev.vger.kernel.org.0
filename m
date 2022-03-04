Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387784CCA9D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 01:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiCDAOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 19:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiCDAOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 19:14:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2150A9E37;
        Thu,  3 Mar 2022 16:13:28 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223KEiHX017342;
        Fri, 4 Mar 2022 00:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gpeL/9BCaJ8iak3QumyKauwW3HFbrjwgAtT7oFKTvAk=;
 b=u9zSR0mvXJ9Mn/ykVZdqCMxJVfmo4ydmBf+Ba0mL4CZXZ0bjgwG/QAfi0hpkLTjqxQKU
 /fRNsX9uJdwtCMm4cfc9K6SCvwyAtkyQYmj5dv/Az0Flqd+RtJtsL0WV0s25P6IrWZ+l
 qY/kT8jkN2RvrCj6x3TzMoV2rZMsDF1eldb4lGTayG6Eblcv+QtGxOp+s9zOU0uLYoLU
 D5iLJqorG/2MbMLO0aU3/y2O83BgHXzBFD5Sz0dB4kBo32fapld7106d3pgMy3h6hCYZ
 TPpHK9gA1Ykwl8lDmzbZWMk2WhW50fjE81c2xb5pr1ka9oRQxLoAH8mLtXcdnR70vMTC ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hvge3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 00:12:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22401RRK161767;
        Fri, 4 Mar 2022 00:12:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3020.oracle.com with ESMTP id 3ek4jfsc43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 00:12:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWKNgzM2c1uWSVfaEfWmhA5ehMMY6EGwlWVMwPzWf/DTSHj9qMg5E/pKWolGrr0SrXMTllgWL6SkP0swohfRt+jXMO8sjKZGHmH4J/wnWDM0FvMmyIwLBpa3DjpocNu5i9xKRUDojU8XsalILzBqriDuWtlixGDIVoBm/HCoNKlNSsKEBVwmHrE82+oTIw0+0ELFy4Sj9D4tOxmSP5jVWy17ziTwvdlX+hW+PAf0Vjbe9kB2XnWXhkfXdKUKTi5QWTr5qkneiC1bNtmI/IuDMlDlWwwGgD5xWaO6cuh1oKI1K1JjzUCSj3UznLAieQTae8Y226Wg3z02LYv0FEu8xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpeL/9BCaJ8iak3QumyKauwW3HFbrjwgAtT7oFKTvAk=;
 b=Y5n6ywQ40f0rCWYrK5/kUdfH5TRFNpGcn10O1q+45wk5Sj+2t0wJwx2Bg58ntXiHRqYYxF7rRPDg8ad650K9uPqCPlZSw18Yq/2TM8ftW0KoAA1QRvKso22tbMi8NeGEdGcmgUemHSjUoTMcApbLqE1YfggDouq+lXgHFVqDplOpJyPaeckdsMb/FQn64h83n1Fc0c5yx8ZZDV2yt+B90RrNDDDiMS/nByT3sLCc6ojts9xJLmlHtpF9Q8j6TyiHBNcY0vP76mb9JwJBWeuB6/GpgIhwOuj7gSMoJ8xSTS4jlF548K9hmsjsfBluOl0hxy4Pw/rHA8il+/G+01iMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpeL/9BCaJ8iak3QumyKauwW3HFbrjwgAtT7oFKTvAk=;
 b=IQLFz7OH3E9/UL/v3go4OlvLmGFUYJQYLISkDtDvUavxK/crF5dGO6somNAgvOvr+eK7hl8EnRR7B36W8mypvnxkzkX8+aKZmsrCYNyfwOz95kAgXLfWMqY/HVlufPrkCj0psb76MXOwuz5sOGl1DffPBFYyXWJr4mGMAcc/Xwk=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 00:12:12 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Fri, 4 Mar 2022
 00:12:12 +0000
Subject: Re: [PATCH net-next 2/7] net: skb: introduce the function
 kfree_skb_list_reason()
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220303174707.40431-1-imagedong@tencent.com>
 <20220303174707.40431-3-imagedong@tencent.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <40f63798-2b85-c31c-9722-ee24d55093a8@oracle.com>
Date:   Thu, 3 Mar 2022 16:12:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220303174707.40431-3-imagedong@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:5:54::35) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4760f09d-47d7-4b43-3f53-08d9fd73a13a
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2496F40910BCFDEF75E0D164F0059@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z4/4H2uJ+Ojq3Fmmewdt1OH3qOdDZxgX+dE8tzSNOs+AM72SsbxE+XffOWzAxGgcLPtdHYY1xFQ58BNaS1TKSf9vp7DNEczDrsvSgYvn0lhTFKwyU2VkMFdL8ao/6yByAmyKiEDaPDbnpyxCi3/5CFZaCoRAIjNBjqCQ/uhBNXs990WH/EyQdse/N5U+k6PouYeRKVu9iZi2fZ8aB5xiT2W0Ms31bDVPragFam60csua4O1lZahVQ//fWvHYbp9Sj11PSQ75kYx2bpxsvJ8Wfc6O/Shtn36jRxDxqLvJOLcAWj8LEPsqR2kULYCAaB9Pte9+GEJeTlNXqJOhady8jUibr3tLPfyNmJXxN3IwwOkzl6IkPNQL1aqA6lDIbswQ7pYCnDQ9R7K3RCR49XJu8voGBE3hksFl192JO6eS7/d4Wj6gAIJK905TTBTQObTAl2T1WaCfleAaSn/WYRgCl4yh74HC1RlZCZ9LLPXOvzn4aX+r+89olERWcx+s1hqHBw29al+BkCgMRNBSFv2fiBiV/WI9t68RZGLuBJIeqFgGbq4P7fhqTiL9FmDs8yfJrfcM+S1oESTh1IBEKTfZSGfRkwkPUeg7+YVvHydvtAOW8JEpLnDHZRUy/y9esUtzw3Cr595qtWMSlTgtzRbkDuymzML6pMAu+hF68yKMRx2RwxizHtoewH1rCkXx/dqeIJhvk9TqP42UnZmnTaxyYt6PfJ+5KuaBtIURV9s6NNojrOImyS3xxvGejePFm2h+XuJkO55BnRtQNnJ4zHvPV/MySk4FhhM4n3MnttjQJMgqHKQhE1fVBwTOc7MoN9Uf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(86362001)(53546011)(31696002)(2906002)(66556008)(8936002)(6666004)(66946007)(44832011)(66476007)(5660300002)(8676002)(7416002)(4326008)(2616005)(186003)(966005)(6486002)(31686004)(38100700002)(6512007)(316002)(36756003)(83380400001)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TngvVW5RN1p3SmthQkVHWDRrUG9ZdUFtbTErWENRR01mb1B1ODQrWXc3SWNC?=
 =?utf-8?B?WE9jbFhNZnY2dmpMZWpmYTVTRkdmcVFRMnFkbjgrVkJvbXlRQ0NhT1VOMlBI?=
 =?utf-8?B?d3JmYm5MSW5lYWxqVjlEL3Q3QkFIMnRObFlsMXNtTlZrMU8xY1pQU1pQU3pm?=
 =?utf-8?B?a1IyNVovUVVocW1BU2dHVGhNVnRYRzNXeDRGOW9URXFJeURBWDVOVEV5blR0?=
 =?utf-8?B?eTQxOHlLbFJnNXNZcnJZdysyYWhqWlZZU1ZMQjZCeWwxVEFMdUx5WkhFdmps?=
 =?utf-8?B?Q1JGQzNlSlZBalJYUWNaTVpmRGJ5MVVRWGNlaFJPL2Z3eFZrWDRlMGUydGxI?=
 =?utf-8?B?L0lUN1ZpVlEzeXpaMHVETUpNbHE2WmI5OUxEaGdqV0JJai8zdmQraUpOSHQv?=
 =?utf-8?B?cjJ0TmV4SmpUdFBZd3E4WjhwMWVUd20xQ3E1c0xSZ252QTBZQnBCc3pQYUtG?=
 =?utf-8?B?cEEwTSsvN0cwRHpEQ1ZSTzBLd0R5elVoVTlyeWRTZmZnNkVYSXJVVWIxWWYy?=
 =?utf-8?B?UExWZVpZUXZMdzBJdk16cHVTUnNjSTBtb2xsRWhTUXJibU5mU1RaNmJFb2pa?=
 =?utf-8?B?SXlxVEFQU1dCRDU1YUZIRlZFeWQxcnBlUldmOUNiMlFtQXRpclVNcW1OQ2pw?=
 =?utf-8?B?c0cwMUxjeUVwUWZOSmwyYndCa1AvY3R3dE5ZclREc05DOEFVYU5iMjNkcEEx?=
 =?utf-8?B?aHFGd0tubnZnRkJLVHkwd2RoRGNueWV5NExlK1pCME96azJ3UG16SVhscXFl?=
 =?utf-8?B?SzFZNnc5V002dHRPRnN4a3c2MERSZXJvUWNiZngvSHJRa0FmSFFyTHV4dTNV?=
 =?utf-8?B?eUlORjI3aVdBZHFDQlZLL0ZzeHprVk10c255RTlCNGlEdjdrenpGTDU5THNR?=
 =?utf-8?B?QTVrbm5OL2RHNVp1RTJiNEVySlY3TU5GWmlRSm9qR0lUWlFEWmFocTZxcy9V?=
 =?utf-8?B?OWtISmJHa3NJVlZCWWxVQUpVNmxtUEtBNDRleXRibkRwTlg3VUZrRHpDQ09k?=
 =?utf-8?B?eEtodVdpcmN2RjhlZTFzeG1sdlNoaGJiRFlOeG9jZ1JKT1ovN09CQm9tWldi?=
 =?utf-8?B?ZUtabTlDOEN2VG93QXJnaVkrS1J0RmtvNGhMamErcVowWm9aZTlNbTZRNk9o?=
 =?utf-8?B?UWRQM05MWVBNSEpEdWxlU2VjcG5Bc0NTRUgvVFZoS2J1SERyeE56MTljS05O?=
 =?utf-8?B?R2M0S0dDdTk5S3FFWk1QalZ2Z2p0YXFRUnRCdXUxVlh0ZmFZTVd4T1p6VmZz?=
 =?utf-8?B?bHFOQUp3TldwaG1ia1FRWG5uTWZxRHZxTzUvUll0c2MvaWtxaXUzeXBITmFN?=
 =?utf-8?B?Y0QxaWMxUkphbEpaT1FFaFV4RHVFMVdEMS9IdHV4bVovbmFnTmlRSjJoNFQ1?=
 =?utf-8?B?UXBLd2FEY3JLQnczMllrZjE3ZzRZSzdNUHF1ZElsdEZ2ZDhqOFlqVFBpbGlW?=
 =?utf-8?B?b25QSll4dS9Ld29YcWx6elFjajNHRWdPVldQTWt6WU05YVlUQVN1OE83djls?=
 =?utf-8?B?K21uSW12aVJNaEhEVjdCYUgrWDRCYzJhaUpka0QxeFJvSkJ5bk10OEZMbDV1?=
 =?utf-8?B?RVc4RVlKNUJsa1NVYXZud3B0V1BZTTFrS3N2cEpXMk16NTFlcUFIMFRFdGF1?=
 =?utf-8?B?U1VYeENJOExYc3cxNlNpUE52R1BSTlBTZ3BxR0xubnRISUN2dEV5dDRZZkZI?=
 =?utf-8?B?RG90ZEFDMW9mSEpRa01Tc1VBSitNNFI2YnQwTG0yb3QwOGl4a0lXVmlSMmtC?=
 =?utf-8?B?Ry9BZVkveUJjK290UDNIaHpqbWdaVFNORm90ZHlmTkxyK0tYQVdXMGc1YVVz?=
 =?utf-8?B?LytOd2h4OXc5VG81ZFJZcFIxYU1Dd2xXejV1OGdpcHl6enV2V2xIRkl1bmtx?=
 =?utf-8?B?SjJpQTJMZWpvdHBrdEh3d1FFN2lVVjZSSThrb0JFQllCdkhqVnF0RXl1R25z?=
 =?utf-8?B?TEtpa3JFZFVuekYvVXlrSzE5bTVZME42SlZ5eTJWQTdBbktmUERjcTVPYldO?=
 =?utf-8?B?bENYUERSL2EyclIvODhjVW5ScE4ybXRwVkZ6Y0tMaVZvSGg2RHlnZFFSbkpN?=
 =?utf-8?B?enFyejN1S2NiWk9iYWE5NmVJcnBBdUMweTZNUUJDYmZzNW1ZRU80MGIxS3A1?=
 =?utf-8?B?T1R5Sk9VSnAra041eTRWNDJ5dGRmdnlOWGhYYkgwQWc2UlRyQU03WFo1UjQ5?=
 =?utf-8?Q?WPFd+JzOXBqHu7ucYWDQHxmes/RCvpmCvEGLcALYQJzo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4760f09d-47d7-4b43-3f53-08d9fd73a13a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 00:12:11.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lmj2ApXpnhumn2dgudHySBFGZM9pSnBCDEUiklED/kqgzHfKfLjp8hYlbPKAxfi9DMaoT/RrfntS7IKSyDS86w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203030110
X-Proofpoint-ORIG-GUID: 4CQP12P_j2Fmdu3P-wlVPl92e9i2whE1
X-Proofpoint-GUID: 4CQP12P_j2Fmdu3P-wlVPl92e9i2whE1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Menglong,

I am going to send another v5 soon which introduces kfree_skb_list_reason() as well.

https://lore.kernel.org/all/20220226084929.6417-2-dongli.zhang@oracle.com/

I will need to make it inline as suggested by Jakub.

Not sure how to handle such scenario :)

Thank you very much!

Dongli Zhang

On 3/3/22 9:47 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> To report reasons of skb drops, introduce the function
> kfree_skb_list_reason() and make kfree_skb_list() an inline call to
> it. This function will be used in the next commit in
> __dev_xmit_skb().
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h | 8 +++++++-
>  net/core/skbuff.c      | 7 ++++---
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ebd18850b63e..e344603aecc4 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1194,10 +1194,16 @@ static inline void kfree_skb(struct sk_buff *skb)
>  }
>  
>  void skb_release_head_state(struct sk_buff *skb);
> -void kfree_skb_list(struct sk_buff *segs);
> +void kfree_skb_list_reason(struct sk_buff *segs,
> +			   enum skb_drop_reason reason);
>  void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
>  void skb_tx_error(struct sk_buff *skb);
>  
> +static inline void kfree_skb_list(struct sk_buff *segs)
> +{
> +	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
> +}
> +
>  #ifdef CONFIG_TRACEPOINTS
>  void consume_skb(struct sk_buff *skb);
>  #else
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index b32c5d782fe1..46d7dea78011 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -777,16 +777,17 @@ void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
>  }
>  EXPORT_SYMBOL(kfree_skb_reason);
>  
> -void kfree_skb_list(struct sk_buff *segs)
> +void kfree_skb_list_reason(struct sk_buff *segs,
> +			   enum skb_drop_reason reason)
>  {
>  	while (segs) {
>  		struct sk_buff *next = segs->next;
>  
> -		kfree_skb(segs);
> +		kfree_skb_reason(segs, reason);
>  		segs = next;
>  	}
>  }
> -EXPORT_SYMBOL(kfree_skb_list);
> +EXPORT_SYMBOL(kfree_skb_list_reason);
>  
>  /* Dump skb information and contents.
>   *
> 
