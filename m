Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F914C4B55
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbiBYQu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiBYQuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:50:55 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A7121EBBD;
        Fri, 25 Feb 2022 08:50:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PEkTGl013166;
        Fri, 25 Feb 2022 16:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=d8OO7etRW+3VErEQZAhRyXGr+8jpugwwtWHuPrVJdbM=;
 b=WdmM1VUo7mYqvRCYaw86BRM7FoEiTD50kBRcPedsbkb8DOQBl3njY1JKM5dCJuvOSG9i
 BmK3NjRVGkWLZjSUd0/UGNSbw/vAxNzycJNlcPthaXk4espVmLJ8GHz6wQje52/dE009
 +tXn1SLygci1eMLHNT2N7m5SGjvMIfxWwMDsROaCBRV97P6DBxVCbG3oyvvJ3HSo8AfS
 GjHAtaPFyWrXOg+xvQZjjJtDlzIm4aWMg1rdxCEQp94VqOH4iC4cQ+U+heLLwOSAslUi
 z6d14PCK4kXmPeZquWBYKaXVmMLoHtufnKeq1FXMZ3owr9rmf84s8tHobKIKS52xsv1c 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eexj89jaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 16:49:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21PGahlU113442;
        Fri, 25 Feb 2022 16:49:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3020.oracle.com with ESMTP id 3eb485125s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 16:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czqnB2YhFvqPNcAkpZ+Vf+3Y/lTWC0l7JxTqM4nJJwDS60YueQNDKBSj2Zttp0fWSTluwlsxGLjlCUKgD9YHRCt7kGw3tA85QyWqkWp87LOv9dZjEteU7hYu6ntZX5Ftte2XmTv6mlNnt8aA/Ne6sMUpN163jbdEtj/Wma9P8LVGixPE00DRyblUjg9PlfcFASEJml0jM5ustxffUeLBpruUggINltIIpPDYx8K84lhX3lzuiGcmxbUOkCHakfI8Z5cuYjQFzKbvDxh4XkWOnFHdZzkPrU7aJ+f1enQ1alncOZgsANKo71Hn9DCSvX6IDX5v8EFL31we8Pv03e+t8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8OO7etRW+3VErEQZAhRyXGr+8jpugwwtWHuPrVJdbM=;
 b=VYSTIlLTTYRzziYaWi+H0JaKWDORwEjm8QcvBznjLRrsQnw35OQLZ8178V5RKqu05Hms3v2FEMUNObfJxvIqUCLYqIxEkQJuFoSR7jOSlVYHMEGWhXe8qoMM4HS1LdjnobmN4EhTtTa1F9XNb7cLhF2DjoStLgIN3dSk9dMU1mmVujuBU8XlJvoSY+pyDGc8zQJ8j8LD9OZe8pvcWwzBRt3tAwXpADl99Vv6DbBjlGgZ16FE0g98WSTG99OVhtrT30QOqzPnGCZe16gwd2N6H0crgXYKo71ouKX8FH3QRXS+SIqhvhZDt04Sh2NbecdA58doAj/7RlOZwxu3myZwlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8OO7etRW+3VErEQZAhRyXGr+8jpugwwtWHuPrVJdbM=;
 b=c8vOv4kYMClq0IYWKFiwcwyo/hrH4yTbo2jwayQTuqqfyPrnfm2Zjb8QYSMCflIvDWkhdW36K/RhuTO5HoSm36dq1HNUCbjH3dEHeqrLH23Gc/9ZoEgKiZ09w6xdwyZMSK1VR8rIg9JKGfIZntJ51fNk1DLWF1IpoL2AoQnXnMM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB3860.namprd10.prod.outlook.com (2603:10b6:a03:1fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 16:49:15 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Fri, 25 Feb 2022
 16:49:14 +0000
Subject: Re: [PATCH net-next v3 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>,
        Menglong Dong <menglong8.dong@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rostedt@goodmis.org
References: <edddb6f9-70d1-4fcf-5630-cbdfe175e8ee@oracle.com>
 <20220225055732.1830237-1-imagedong@tencent.com>
 <41d055e3-9d88-bc43-cb3b-bd67ab071e11@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <ce8e438b-b077-6cbb-358a-3ffa5cdeb574@oracle.com>
Date:   Fri, 25 Feb 2022 08:49:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <41d055e3-9d88-bc43-cb3b-bd67ab071e11@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0090.namprd05.prod.outlook.com
 (2603:10b6:803:22::28) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7fe082-abc7-4714-7fc0-08d9f87ec18f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3860:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3860F6BEF92E784F2B72F8EEF03E9@BY5PR10MB3860.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ao3qxSkLdD75lzoUtAzCdToEqXx1KlsHrefHwoOIDV3GV5exH8f8y2MADMpMDstkCKk9HtiYhDwERMbYXTBGVELm0D/kLoPHVqmo0xHuDY3qVfWHF9Ys3rWb5T7JREdyrS5ei3/Mi+1csvQPkNXBESVRtMCLLCSV+WbJ4H71JYfVjdmXuyq3qidwLizt+RhpLS81/eByk/N6k6kgAzYzw+3+jxoNVg0d0Nf15LUeG+zFEdiVx07WbVETMZHQR80loXAUzWoMb7U76U05GwXYVdzTPx03z9Cm55WU55Cvy1fLsCsN/9VIVyc2VmAjcrg76+stCa5LzQjOByUge55/ryWjKumIIk9B4myyDsf3gIFVQsygMHv5U+aF3mrlNpbSGFfg+q3XtPqGvhzO6FUArISLtvKrABxu3YrT1kp5nD1yGis5ImtsRoasovdTk/fKlTURG5vzmBGL6SZRrrzPJ0WL/Ao18Wb4iHg47qaYRH5ryN7iGHDt2/YGWRwD3GMsByU1BsUVCgdPs/F6CrpQtGeMy0JF31E4aXA/sC7KWcW6chac++ZxYZEpu0JnWcEqZTtOMUhz8wIS8SeukFm51XeCxYR4FMZjVQf87ejzNhE3wRSVyMfcYPmvyBAfJFcHpLUlXtfObq2n/UaZTtA9ibSaxaYAeNrlKku6S9+krm56hw89ItlI2wAH8UEcJi9GVHufx/svYx4SMbb1IqPE41RHFfF03H4mSXcJucbwH5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(7416002)(83380400001)(6666004)(8936002)(6506007)(6512007)(110136005)(186003)(6486002)(36756003)(5660300002)(53546011)(86362001)(44832011)(8676002)(2616005)(4326008)(31686004)(508600001)(38100700002)(31696002)(66556008)(66476007)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blVxTHpzbSs0MHdvVzhQaGFKODM1YjFmQVBjQnJNTFl4ODRtdDM1SkpoUi9v?=
 =?utf-8?B?VWsxR3VDV0pUSUpCemgyaGFOS0cyRXpwV2lWRkNnc29YQjc5SnhtZnUyVTZl?=
 =?utf-8?B?bEJXZEJIcG9Mb2dpcXlQNlEvRSt4WXlYOEJVMEtoc1d4a0ppYkc4VzRxMzlt?=
 =?utf-8?B?bEUxWlV2QXhiWE95YkF2S3pSNHJMYXI4MUgvaXdEUFFXbmpTejVoMWpqZHJS?=
 =?utf-8?B?ektVeEhDT2IyRWNzcUljU1VNYmdrY1h0a0FhWUU4OU5DblB3TndZMVFPbFN5?=
 =?utf-8?B?aXJaQ0ppUmhkc01EZS9OVHliaDZaRVJCdXNYOEliOG9zcW9rT25pb1ppYlVr?=
 =?utf-8?B?YzBTeEV5cFdxV3QxY2dMZXowMG42MVBVeFRNd3ZWSTVSSGN1dVV1OXNHUzlH?=
 =?utf-8?B?aHFUVVl0ZXhnTU5OeXlwUVRRdThKZXdTejRBYzlBOUZwcUFkcU1zUGdjOVl4?=
 =?utf-8?B?OTVZc3R6ckxhOHlNOFJzQjhza29iNlZINkN2QXIvNHBQczlBcHN4SlhMdWtp?=
 =?utf-8?B?RVNqelNhSENtdmtGeHRCaWlYN1lyempvQXNtSzVJMGtuZTVSTFdXc2FnWEtx?=
 =?utf-8?B?WjJjWnpndUJtK1o2M001bi9Ta2Y3VGRBWkd0MlQzWXNrMndUalZOMmZGVnFi?=
 =?utf-8?B?NGtzWTM0RHdHb1NUQXpPNm9sTmkzTk1RdW1oVU02eSt3bVBhSjc4VUVpcmpq?=
 =?utf-8?B?YS9RUkJUUFp6UllXVEFJdmhhWmkrRVg3Sm9HTGRsSFpoYmx2UUFRZWNnc2Fk?=
 =?utf-8?B?UlhVb005K1ZpWEZ3emQ5WFk0c0lNZUl2UmovbG4vb2xOMkw3amZXN1J4UUo1?=
 =?utf-8?B?cXlaeTVZRTR5VDN5Y2gyZ2t6M0dsMnlTTWhjRXFncUcxWFhuTGtCZmFuQXow?=
 =?utf-8?B?MFdRT3c2TTEyVUtrWDJ6RDJvTUpTckw5eTZLa2x5empicGtDSXBsMGNiK2Mv?=
 =?utf-8?B?dmg3WHlNbjFPRVpYRVNxckJOdzYyRHY3WkdXcG1sTzJkczEwamx0WXp1Z2ZV?=
 =?utf-8?B?b09DWHZBeDNkcG9NRlF5NUdIeEVjRkV5aFNLdmR1N0hNWWhMQ083dG8yYlVM?=
 =?utf-8?B?Y2pQOEpseDExelhTM0cxczRLT2JINjlLVDg2N014cWJCSW1zYjRScFdJbzNG?=
 =?utf-8?B?WkVDMDkxUnh3aHVzRE53MmxxSXNzT1NuQTBIakJiSktxQUYxMjIzQUZwK3pn?=
 =?utf-8?B?clVSYUF0L0pnMkkzK1EzS3NGRHpsZTFiNDFqdEM4TlVwbHNiSldsMjZra3p3?=
 =?utf-8?B?SmptQXBwSnFNMmFuM0p5SHZTdnhQT1cwUHppUFZoMjcraS8zSE1TS1owblk3?=
 =?utf-8?B?cy9aaGx6VHRiVmtoKzczOW1qWHNnZVdOOTdCM1FHM0xDNElnbURPd0gwak55?=
 =?utf-8?B?a0VtUFJRbkliSGZRQnJEQ29aRUlKT2M2RGVVTVR5b3E2djZKNEszbm9mbWov?=
 =?utf-8?B?eHR2SkhKdDNHL01taVRlR1lLQjBXOVFKVGlaN28xeFhORzQ4NmJ2Q2xyb1I4?=
 =?utf-8?B?cS9uVW0vMnhtdXVscS9ZT3VHaEtyVEt5S3dEM2VhSUJyNjZ0UFhRd2pJditw?=
 =?utf-8?B?T3RSMjIvNVl2UXJFVzdhUVVwR2ZaME1WUnpBVDdCM3Q1UnR5djY1anY5SmxF?=
 =?utf-8?B?VlNTaWZkWVh3cXFBaldUb25TTXRBdDZhbE9xQi9NTmtLSVNPK3NSRnVnQS8x?=
 =?utf-8?B?RytydjI3YTB2d1pnZ3NySmUzN2cxM1V5bkJwdkUvOXhuNVhaUld2Z2lGMmFv?=
 =?utf-8?B?bHY4UElZdDBlMkRNZlFHRlp5T3RQL3o1eHRmWG0zbnAzWmx6TGp3bmpSMGZx?=
 =?utf-8?B?b3JPQW5hMlpjZEZmQ0llbUFPU2NjTVhIR3R0cXAyRFJvWUtjaTZoWUVOQW9G?=
 =?utf-8?B?enRnT0l1Y0I0cDlJclFaWXM2eTZZRlp6MWFLQzFjZ1Vub1UyVzlla0FBdmhY?=
 =?utf-8?B?Rk52RDdpTEdhalQ4QXJUYnRCamNrVUhlNCtPTVJVVXl3YlJ5Z2o5eFJaeVBN?=
 =?utf-8?B?bHpELzVEbzhXMTlaTlZ2NUlHbGRVN29RTzRqc0sxbzVLdm9yakc1bFYxV1d3?=
 =?utf-8?B?MHRQU0RiY0tOS3E3WXh0TlJ6ZzRWY3dKNVByUDcyOW0zWDA5S3Q5VHk3RGtp?=
 =?utf-8?B?MEtPZTJZVHlMcVdUN1U1Y20vbUg2QzZtZE1XWllkWTRycE9vdVkwUUZMRUdh?=
 =?utf-8?Q?Got9bs1hfnjky8rB/TLQtBeVJSUXaenVlQncty8y2oqR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7fe082-abc7-4714-7fc0-08d9f87ec18f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 16:49:14.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZimnXxq2Papc6RacGKWS/ZSEprHLBK5BzW1YJQnuzyl4x5xI3kwaQdnxbdIQRgw8kSOuXoCs+1iRFQ+usc3mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3860
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250097
X-Proofpoint-GUID: qMLfC5ldTTNw3uQA6q5ooA8HnpSp4HHU
X-Proofpoint-ORIG-GUID: qMLfC5ldTTNw3uQA6q5ooA8HnpSp4HHU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David and Menglong,

On 2/25/22 7:48 AM, David Ahern wrote:
> On 2/24/22 10:57 PM, Menglong Dong wrote:
>>>>
>>>> For tun unique filters, how about using a shortened version of the ioctl
>>>> name used to set the filter.
>>>>
>>>
>>> Although TUN is widely used in virtualization environment, it is only one of
>>> many drivers. I prefer to not introduce a reason that can be used only by a
>>> specific driver.
>>>
>>> In order to make it more generic and more re-usable (e.g., perhaps people may
>>> add ebpf filter to TAP driver as well), how about we create below reasons.
>>>
>>> SKB_DROP_REASON_DEV_FILTER,     /* dropped by filter attached to
>>> 				 * or directly implemented by a
>>> 				 * specific driver
>>> 				 */
>>> SKB_DROP_REASON_BPF_DEV,	/* dropped by bpf directly
>>> 				 * attached to a specific device,
>>> 				 * e.g., via TUNSETFILTEREBPF
>>> 				 */
>>
>> Aren't DEV_FILTER and BPF_DEV too generic? eBPF atached to netdev can
>> be many kinds, such as XDP, TC, etc.
> 
> yes.
> 
>>
>> I think that use TAP_TXFILTER instaed of DEV_FILTER maybe better?
>> and TAP_FILTER->BPF_DEV. Make them similar to the name in
>> __tun_chr_ioctl() may be easier for user to understand.
>>
> 
> in this case given the unique attach points and API tap in the name
> seems more appropriate
> 

Thank you very much for the suggestions.

I will add below in the next version.

SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented at
				 * tun/tap, e.g., check_filter()
				 */
SKB_DROP_REASON_TAP_FILTER,	/* dropped by (ebpf) filter directly
				 * attached to tun/tap, e.g., via
				 * TUNSETFILTEREBPF
				 */

Dongli Zhang
