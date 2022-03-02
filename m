Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9A04CAAC9
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243540AbiCBQv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiCBQvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:51:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB67CF3BC;
        Wed,  2 Mar 2022 08:50:42 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222Eq6Pv010113;
        Wed, 2 Mar 2022 16:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5qG95uJWjcmBS17C6q23GyBcJheihhlIqlTAx1boPUY=;
 b=g1UoC+Bz7Y3R1eWDcjt5oqCWB6IEM2djEeJ9KDQRNVybB11cPqz293lVc7HkLfAUy5Pq
 sGbZzgmPDkUC969uZtD4AkRCb6yI8vSsryw52MRrI/Y6oWLVBL6517TKMx5hYxLTBOS/
 IPWiR3JgFpGBccTQXRHjr8ByzTV/K1kr00Xv88t3aYI08w7C2ueAERcj013JwKPALUXU
 dIvPl3ECuHH0Ye0O8Y+b7ST8Tu3y3rx5MX6H53LfF3v7sFEf6SBiCKwKQHc/fkWkd7A9
 uFXO2NKOKomFfH+TnKqVSRYFga6AHv+J8hXyvTNswpM8BycjnXdG9k5uxdc86wjfuevi 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehbk9cy0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 16:49:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222GfMhR100778;
        Wed, 2 Mar 2022 16:49:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3030.oracle.com with ESMTP id 3efa8gcjxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 16:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0z7NdCR5KW30zE1uOH2Tk0XcNEgeGB7zII+NdEC4e8BHUOM00lnaQeAWiNPZzWRNIcpKrB9JipF09czNxvYfl/6Np2CNoQYEn/3pAyU1NeitW5iC9ysUatnX6dgCPAexHsqJXNIvsqNexZFa2Q8yAdLtC7rCyQih+0NEBCS/8tnsfzELzRgi8e310j8DAhjnM4SFjZYXR6qC4qQi4gKD0oK6ZMumb0R7A81VM//nUk2ThSqN/9HljD7WPaySYr6YmPqMdfnI9GF0lPSHN3mqj3ASmNaZHQawgiKRzI9Ymt/gU9EIYw9f6qVANXl665mrsddF1U7NuCyN3Lw2yjjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qG95uJWjcmBS17C6q23GyBcJheihhlIqlTAx1boPUY=;
 b=hDw0s7Sa4efbwTNbU3hlrPIUFOvG2wA3jg1VZ144gohloICuGfzXS/dz0L698UVlmSYJ7/WkG3DVVYs27unzJFbYUAWCaKKnEQ3Hy/xLLOBhgkUFLT0OWaI4A1DEx+6Qux4bcRv1T6XgxOJgnmCp/hWjgBxg4HSeA69UjE0fuS238Qi9cDqLlWronQlf1tjsbIOdUekBGTTzndrchYcKDxOT5Kaul7KBgtT/GIHo8F5wg6eYy9/ExWHNmFdGMvkeKoyeVnvGiA5LCWO5ZrV4C9t67RrbTDwnd3yM9jMN5EtTMhyCXFZm9SzI8IRk8CfYRu8AwDzhdqLE3IO4WVOtvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qG95uJWjcmBS17C6q23GyBcJheihhlIqlTAx1boPUY=;
 b=NPVwzNg0yJWrUYhL3r2W+Qzwwr6xhfO1SdDamlv7q6brSrdBOUf3F5Xyck5Oon1LySXE2sNlimlstNKdRl5e4gBG+QJuxSzKmwYyS0BRTXE1eLdsBQ/TsW7pA4RbXpmbhgIFrV7bslrFKOKCQSXieCBC+3Tajn7r+R4FY626dx0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN6PR10MB1490.namprd10.prod.outlook.com (2603:10b6:404:45::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 16:49:43 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 16:49:43 +0000
Subject: Re: [PATCH net-next v4 1/4] skbuff: introduce kfree_skb_list_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-2-dongli.zhang@oracle.com>
 <20220301183454.4813d022@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <1bce4d36-8032-d6c9-541c-858a38ba2596@oracle.com>
Date:   Wed, 2 Mar 2022 08:49:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220301183454.4813d022@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48b5ff91-0310-4818-baf0-08d9fc6ca68e
X-MS-TrafficTypeDiagnostic: BN6PR10MB1490:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1490D47AC53D2C149A7B81E8F0039@BN6PR10MB1490.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIGVamZ5huvsjmTnyBfKeVW+EREknmp2xciDb7fUuiy0vmc8avd9vvJgz1nfxwWJXLPZRF/voxnoyRabQy6RcxraSAoIQjC2gE5IRYUcQWUuNNAg4xcm98ds22vgV4CLRCCIiY51ZlBPnp82jRIk6WrnPo/SxCRjsNYYKrxYAWCioAHuyD5zPq8j6koB192LR0LD4nK52mgkHZFGzD7CkvXh2ra/MM4VMH09GnlN/Jb8SJrlO6BYDr6X9G7ZcWKakqSJ7xh2kJBSHnRVfzb+fdUAHCfZnrtf/ES66skhzHwIuBf7sysHZQZLcOQaNP/hEDkkWPI25HmPZlwsHqcyo6dE4COwzYMXuyDSyCtpO2YkkAUSOzudy0CmDBTdh2xfiq17VILI4cHRDI67xNpj1n7TMXBHc+jxMycX42DFKKqPcHdK/f6P+hDU4WaCRe+m3d73HLstfICogeU2CH5rj0ws7EKhFrchIjcszWzKm5vGuHR7raAw8SMtWhGTaeGXDKod5icUM/vjZ4kEqrMeEuzCIfzowEK2Xv5NPa+AoIT8xkd8dsWRn9znAiKBFHA1NsK+MrIa1zjH0goDDtIIUWRcQxX013oUri11b+Uupm0l/66t9LNLsuD9q+5asTTxbPnILwYshvsBhVBJUH3nw9a9e2lWfP9BZ0vajsSU+PhwABlWMSbdU4P4d15UoA+wMfQ0n7tlpjdCEcrPOzp3no7lhYXrTYRU3Bgucv998ASI0lLJclFgT77XfYYx4I1u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(6666004)(36756003)(6486002)(53546011)(508600001)(6916009)(8676002)(316002)(31686004)(66946007)(66476007)(66556008)(4326008)(5660300002)(31696002)(8936002)(2906002)(86362001)(186003)(4744005)(44832011)(2616005)(38100700002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3BqUjFXS2RoUnNHdzFkdFRpVmVjUjk2TzVyWllkOUFhRVpWeDlrUnYzSFhQ?=
 =?utf-8?B?Rnd1MEVDbHI1WFc0VjdPdWIwTXFzazBhaEhoNWVFZXBiSSt0QnFPNWMxR2JK?=
 =?utf-8?B?WWNaRmoxWGZDRVY4SWp2VEQwS1JGWXNNVFcwMU8raVdqc0V0azRHa2lPVHly?=
 =?utf-8?B?ekhhUzArNDJCSkM1VEVsN3ZDbTFHZXJrRlNzTHlLM1drajZHYXkrVjVnZjRR?=
 =?utf-8?B?OEg4eFJrbVJhc1lCeVlaVE13QnkwZzlZOHYzTDVNWk4zNm8zdUMyTGY2S2dr?=
 =?utf-8?B?WlREZ29KemcyUTVJaFdVUkdIOS9GcFk0MTRTSHdaNkRCbHZJcXZxV2c3ZGJ4?=
 =?utf-8?B?ejhraHZSZjZvYW5ZZFBaMlJOcEovY0pRbVl1VXlUKzZLdDZjUnhwTksyT3dC?=
 =?utf-8?B?aVdWRldNcWN6T0hSWk0yOHdDWHVUbm95eHg5RWdmbDIzNHM2OWpCWG0xMFFW?=
 =?utf-8?B?QzNYREtvNEN3L2FUWll3bzZPaGltNUdmSmxtTlp0OXNEYlJQVFUzM3dNOHRy?=
 =?utf-8?B?eEx6RS9JSU0yaDE0eWlBcHZaVGlqZHpkbGFXQ2RVNjQwZnRYMzBBZi9ESXZY?=
 =?utf-8?B?NytTdTRQcUdhMWluSUkvNTFrNnkzRjUwTUpnZXpuTWM3eGJpdkZOWmtrbXV5?=
 =?utf-8?B?cHVDdkd0ejJHNzR0elh5UUlObXdDMHhRNS9abytnL2N3TkxvalJpak1xUU5H?=
 =?utf-8?B?NUpTYnNQamJvUEF4QjRaME1tc0grTE93amt5cXlOakNONHZMYlNYeXJEVEZX?=
 =?utf-8?B?bHQwalVjSkZmVUpMYWMxY1NsdTd0Nkh2bkl1SktUZGt2ZTJRcWRmS0FJVEdR?=
 =?utf-8?B?RXBNOTk3MCsrWXczcUxQRFRZUGJWNFRBeXh4WVVTZVczenpJVEhJOHhMQks3?=
 =?utf-8?B?a1FmNXRlQkcrOElJWlNWRDR5UXhDNlJKeG16WXRSRTFsNmt6bnpSZ1ZlUzFR?=
 =?utf-8?B?N1VSV3lxSTltcmNsbEhmdCthaUpicFpXRVE1V2p0aVNtQm5jSVhiQjFOU2tI?=
 =?utf-8?B?VnEyamprY0l6ay9FSnh6dGZKdW1NaFZKOVBFYXZETi8vSUxpelZwcEYrVG44?=
 =?utf-8?B?bXpEMXNsL0ZLUjdPUmU0ZU45UnRhNFJFNUFDbUUvang5OW4zSG9OdGw1dkR1?=
 =?utf-8?B?aWJLZmJRd1pXaUpwRjdGSzd3Y0pHVHpXUjlZR1BWMXptSmE3eFRGblJpblhj?=
 =?utf-8?B?am1tK2Z1NGdnNkt4aXdBSk1KZHZJVDBQOExTcG8yOG9KWHBQb3ZWMlRWMkV4?=
 =?utf-8?B?ZmtCUGtxbGIvS1Y4V2J0eXZtTTNKdTkyb0FOWW1lejhJSUxId3h3K2txNjRh?=
 =?utf-8?B?SGRSR2lqM1FGNHdKb05DeW1iOG9JZGhoaXBSaXA0eFFFVmVjRktKNnZtN2U3?=
 =?utf-8?B?WFdKaCtjeWRGMEJZSjV3TzVIS1VueUZIcm9nOUhiUlRRbmpjNkNsbTdJUFRV?=
 =?utf-8?B?blZ3ZTZJWUxzdkJuT1lpMW5CdEFtdktsTVhPRGtUNnZ4YkZFUUZxMVBIRVF4?=
 =?utf-8?B?V1NNaFJ5MURkUCtFWTVTMXMxamtZdGtaTXYzS3A4QWV2NEkxWlRiMFhLQWxK?=
 =?utf-8?B?c1ZtRHNOUTAxcFI5Q2Uzc1RqTFQ2VlpDdG5vazh3dFZDeURiZmZaWmNCODJ0?=
 =?utf-8?B?NmhQd2JwaVh1RFlvVE1TVUNiVDB1V29WWU55R01zbjdkam1VL1pFZEtnemth?=
 =?utf-8?B?bjVFM01ZNEVxazVISUJOcEZ4R2tyTmdBNHZCRTNwSVNyWkVIWThrcXAweGM4?=
 =?utf-8?B?cHJCYnJWQ3VXZkROTC9hbnZEWTczM2txeE45eFlackZJOFFRbW5ndkZuTnJO?=
 =?utf-8?B?d0JyV2U0eUlPektUeDJIUzdaUWVtcVdHdVVOVzNmYy90VUpOV2E0cWN3dE5s?=
 =?utf-8?B?NldpSFNIMGRkdisxZnN0QTIya2ZnQ2RlU1J2TjZacHl5c25XOUgrUU9NdGFM?=
 =?utf-8?B?elVsOFBMSDkxZ3hXWHhzUk1IUTJQUUMxekNoT2NFY2xUNmRvZ3hoSjRKdjAy?=
 =?utf-8?B?eXNaV3B5MGVwSTNYLyszZDd1cUxZS00ySDlFc1crbmQyMVAvRDE1anZRNjM5?=
 =?utf-8?B?eXo2NzBPMmlueUxQdlBVR0lWRUtZd29sWnhHUFlmNWZiWGl5Uy9yUTlFYWQ1?=
 =?utf-8?B?ZFVhc0Y0ajE1VGR4aTh2ZGFReTNZbEZrSGt5NUt1ZmEzb0xHbzBTYVRQRWdY?=
 =?utf-8?B?YXpTb1FKdUNBbUFMVjJoMUZ1U3B1NWpuSWxxUzJ3QzJzKzRvcjFNTUI2RFdo?=
 =?utf-8?B?NFJPVzRtMFR4T1VCVXorZFpxdFlnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b5ff91-0310-4818-baf0-08d9fc6ca68e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:49:43.2237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHmQiEWo+JIy3sykWB5udJDVoaW0+YME3dRIzgPO1GeHqkwdd7yWbeAmt9lULpxrVxGKW6jtBx1T0sOQXgLhUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1490
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020074
X-Proofpoint-GUID: vI1SzAyaYZQmjNhUmFJKorPcXis668bn
X-Proofpoint-ORIG-GUID: vI1SzAyaYZQmjNhUmFJKorPcXis668bn
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

On 3/1/22 6:34 PM, Jakub Kicinski wrote:
> On Sat, 26 Feb 2022 00:49:26 -0800 Dongli Zhang wrote:
>> +void kfree_skb_list(struct sk_buff *segs)
>> +{
>> +	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
>> +}
>>  EXPORT_SYMBOL(kfree_skb_list);
> 
> Why not make it a static inline now, like we did with kfree_skb()?
> 

I will move kfree_skb_list() to include/linux/skbuff.h as static inline.

Thank you very much!

Dongli Zhang
