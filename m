Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C113F4A89AB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352682AbiBCRPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:15:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16294 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352755AbiBCRPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:15:07 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213H5CNh028542;
        Thu, 3 Feb 2022 17:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=J7b6tNhNVTaGE0rpAa49P1gFTW7UhrqGVtE/LqzkbmE=;
 b=fRozKMbEcqV3GMCwcxeTwt8rumLMXIo7rTbrt06FDUe/asPDlokLuPBwbOmog89yyMTt
 vP9t8g73jNPyxm2pKXsZEP0NxyfU8YfWiU95RK5XrWlTaXa5RU1wJaY9234QGplOH6D4
 oTH/SIHIS5x5SgYnJeFRgD1A87LzOgIW2BlOEGEUa/CzYIUlZR9xT1FbzZjs6fNm86GC
 NocPQOpvtw0NhlbanCLx4co8Znq/iAQ6dS7wWkDFJgzEzfiLB6DUrIL0O7sxqDKWyb2S
 p0MQf2WYwziD/27cv7ZDYp77xtKj58c5/OYpAIKjwYkvqpyeXK+/8Tb3Z0AdGhGbyet5 QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0het8dae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 17:14:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213H5S35124383;
        Thu, 3 Feb 2022 17:13:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 3dvy1ve6bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 17:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFUsmbPKfMorLbsuC2QWTM1Z3QRUYlk1gspy4fWFNn8J/6aVYTs/5mQpeAdsSCBb+TaOe4CZIdAWo7YAs0/vEvSkPpH2uhALkWklbGCwa5PXVfSi0k7z1S+m20IcoQn0ZLLdJpGLuopPRoUzzzzMcLpaBH9+Il2OKttU+ZFtbywePs4h6GCodSirTM45N0ANPT4l7atQ5P8FS+rKbZsqMglKxVqoZn0eL6rb63Usx5mmtWJdN3Hxb7nNaX+VZJdXqrrIBM6XzOzqAkaST9XOtjjNdlUtsAPkGDB5JziZpFJiQ/Jm6p8EzHd2wVJg6KAZfFbnCx0UF0BPwdmFjs8zpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7b6tNhNVTaGE0rpAa49P1gFTW7UhrqGVtE/LqzkbmE=;
 b=m76XsmD69Uqp3xThY7bAI/hq/1KIbrjZ7kc5pyzs/8dPuHurrdEghhMe5URqYpjoas8Zn0arHUqKPVQjGSarm/MvdjJGvNmoP32SoEnU6T4l8U280KHI+oJSxLgdKtMbEY1gO34y3Ojyn5ZAwbmVeXc7kaq0gWsjxbFzy1+/HbouKmkWH1BfHfUSHB8NOS5y4Q3Yrk8VjqDf9BV7KUZBWb7rVDkHlHYp8LzyOR5B7GlAK5JlGJNFjQCx5udvTe2NjunX+0CRnIfDHEgKZi3DPMHsBI+u93afrTSKyP2dR3Ot9DjrxQVM/aT/pGjaj24F3md2YMq1Tdp+M9X8w3LY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7b6tNhNVTaGE0rpAa49P1gFTW7UhrqGVtE/LqzkbmE=;
 b=M84RKTZb4XuNb9mTKtcX+XqZs3Clwi8p3WSw6KOGtRrV92a6l/tlXQ+QXehaCm2TTwLdrFtokAgcU0Xl8rBhMSus825WqJg40RGmErFlbbqe895kOEoCl2VsS6gaflvyad9ffoFPVN8btQSIgxGnYI/wWIUEvhGWDfr/AKDzQ2A=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB3132.namprd10.prod.outlook.com (2603:10b6:5:1af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Thu, 3 Feb
 2022 17:13:56 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef%7]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 17:13:56 +0000
Subject: Re: [PATCH RFC 1/4] net: skb: use line number to trace dropped skb
To:     David Ahern <dsahern@gmail.com>
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
 <20220203153731.8992-2-dongli.zhang@oracle.com>
 <e34e03db-9764-4728-9f6a-df85659c5089@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <79e4d4d4-b87a-e8ad-af24-b95a02d5ec76@oracle.com>
Date:   Thu, 3 Feb 2022 09:13:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <e34e03db-9764-4728-9f6a-df85659c5089@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0109.namprd11.prod.outlook.com
 (2603:10b6:806:d1::24) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 253142be-d5bb-4285-403c-08d9e7388f60
X-MS-TrafficTypeDiagnostic: DM6PR10MB3132:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3132526F4C97E47068083BC7F0289@DM6PR10MB3132.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jQ2UMOfWloo89hvb1FC4dyfrTNpzzz0WoJ6LpfeI6mXULJ/B/iYxy9KVxBrRyi9nmDCoO9t2Xb7sTmz/rfB4JcP32SVGQ08jxKQtg+0AAb/Pz+Tak8zC9w6FzhU+BkVuatHj675upqmgmXI9QzSGHz6AZoE3oouD4R+edJNmzGG6VAQrjgv2htFJtj6ItTFDm+D4leq9zVT8a8/z0HsecblBiV9TokQQfYtPcpHHkEWgAY9ywUmXQkfJndxs+4HZBoJjeoIxzS+t4VF3JmWYPTZ4JwaOw2fB9W3ntaNIKbdkF4eg0io6aAVBheCs3j4ky9RivP05Vy84xQzNDhpvXIcWGK7T1dkDpx3Dyn2kzgp1aLQ+RNTJg97kimkLs7xBMyeyZ6fv+iWX7vAvqSAh5jw8dOSs9GeLNYIGztirB2JlhXhzq9izm1p6h1ruylN5XDvyb/+EfnWPB0rfwDyQXcBkLTON/R9rGQCN5anyVuCrtB/VL7b1ATfh7SuqQHftxOBpUHPtJe/8eC3Z+q4n2I2Bi9nTDRCsh7WBqmIAEOfCvO7s6BBT95xdSJM7JO/+ygwNLqEuQW7JYsbtDJSNpzJ3NZcVDq5dL4jduqmoXDjuBjOWYzIhOiPNUYs9UTBnl8HrR/TrgwT9eFt2OeqmID20K8W7PdnlEN9IK0AxLAyywDbF1ZM192cn1Z2iD9nIq5Rk4Olo1C+sjygGLfAsJ6IHAmAKUFi8AmkFCOYKgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6916009)(508600001)(38100700002)(7416002)(186003)(2906002)(316002)(31696002)(83380400001)(36756003)(6486002)(5660300002)(66946007)(66476007)(44832011)(4326008)(31686004)(6506007)(8676002)(6512007)(66556008)(53546011)(86362001)(8936002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0dLYytMUUpQVnYxanpwSkI1cFVRYzJpNzNtOGRjYm1mdkhCQTlqQ0tsWC80?=
 =?utf-8?B?RUtIajNVTlFRZGFEQThFWnpvSTRBeU5DaWFGTVNwUUFSSWlJWndPeG9GNmc5?=
 =?utf-8?B?WFI4c0syVDVYcUR1RVdybWl6bWJiWEswTHpNWVplZ1lRTTcrVVN6RzhoM042?=
 =?utf-8?B?MnkvU3BQRlk0TFFqV0JKVllKb3oxWVdEL1lETnVvMUVmYUtCRVYwN1g0cTdx?=
 =?utf-8?B?T3piWEwzSVA2UUw3OUdhYzBFWkZQbjUyeVN4QUtJMllnWUkxWThmcTJndXZW?=
 =?utf-8?B?RHFxN0JjbVNSUzJwck9XS1VZRFN4ZGJSNFFLRzU3Q2VWbTh4cklSVVZwVDBF?=
 =?utf-8?B?amU1alJVZ0tjZXNTSjZHQU5jbWNxSkpvN2tXalQxWUc2MGhGQlNQRU1kZUV2?=
 =?utf-8?B?VWVCYmkvMm5TbitLN2tueDFKRkZUVG9vL3NOaXFjTTRHcVExbGNhMnNIVEQ3?=
 =?utf-8?B?UGlqQkt1V1Rad1pmNVRDNWdWSTU3ZGdVNXg4RkpmaXpqWC9CQWRCVlMybG5j?=
 =?utf-8?B?STcwUzlzQjRxK0ROTTB0UmxObU9lSlhoSXJGSldoNmVQWlZ1NGxGSGFqaVRh?=
 =?utf-8?B?aDVRNTJhL3dCaWZ4cVA3RDBSYkxraG1XMFFoQko5TEFGd3RPdFkrbHBsUWtp?=
 =?utf-8?B?cU11MkdqQlFjZndNRllTWGhLVTBObEFTS2RiUUt5VXZjUERjMk52Q0FSN3l5?=
 =?utf-8?B?b05RNGFBaHZFQklXN0hMK3FoeGR1NzZMc2VjWTQ2bUZ1SVJiZk5GNTRXNXVI?=
 =?utf-8?B?L3ltQlZlMGtoV1RONklwcjFNSXVCTzlhTXV0d203czMvSVg0OENubGlaQjhR?=
 =?utf-8?B?OXVvM0pWTkwzc01yZjQ3Q3dsZkZTdWhRMkw1NC80VFlZbzBwZ2xXeWxJSWRi?=
 =?utf-8?B?SytBN2pGS3FKYjlRd1pjTHd0SU1mQmJzeC85TXhhZk0wYndMS0pQZERZZmRE?=
 =?utf-8?B?YzNoMGF2S0JYRHB1NTI5VlRvazZZVkRFWDFld3hvVUp2bGVQdGdZQ3h4aE5v?=
 =?utf-8?B?NFY3Y2hNOTNQV3dTb3F2WHFtNy8vb0xYSEVtWDNUaVkrU2ZZNG81NWtZYkRo?=
 =?utf-8?B?VmNURnN4dDZLakVtMEVWM29iVTJFNGlqSmNBYzNLbmZ0YUk5R0Q5bjVpV2V6?=
 =?utf-8?B?TGp2SnRzT1VZSzdhU3BkM1BsQ1Q4OHJ4R2xzcEIrbmpteDQ3RHBXOW1CL2Jz?=
 =?utf-8?B?azRQSldhTGtaeTZoSnRuR0FJRHJxMklSTnVzNkZCalRyaG5ndVIwUHk3SHlJ?=
 =?utf-8?B?M2o2T21IWWFBLytJZVlHQXFrSENsbktmQVVzak1aZGJ0Z2ErLzM3MFdsZVc0?=
 =?utf-8?B?WnZtWFJTMzQ1V3BKN2llcUlseUVCSkZOQkpzclYrRkR5bkNoMHUwMUtMS2cw?=
 =?utf-8?B?YnhDSVgvT0M2TlVyaEh1VWtFd3lrUVlQWWIyeVhIcGdLbEllc2QwZ1BGV3FF?=
 =?utf-8?B?NWllMmQwSjlLcnRiVTB6VCtqazFYejRPRDZqUkhlTDlsYktBd2Jqb0psUXRH?=
 =?utf-8?B?ZEg3V0lsSDB6RFh3TDNCVndtMHpPVFJTSmhhdy8zVEtldE4vZy90OGZBcENI?=
 =?utf-8?B?b3R2WjgvN25ENmNYeDdnL2dXN1hMbmFqMTU4NElrMlprL05vMm4rM09Vb1JE?=
 =?utf-8?B?MHhOd0FydlpZM0ZkcWtROTZkUG1WTU9jNEdCMUpEOFc3M3NRa3U3RDhzeXdY?=
 =?utf-8?B?YzR0VmM5K3hyNGdDUzBvU2s4TS8yVXdUNzFsVnB5UjlZZmJSUm0yb2xnRFBv?=
 =?utf-8?B?MFZTQklHdDBuR1Jxa2diMDRxaG1rZ0tQWU4rSjVWUHhwUXR4cUdxZzhHbThz?=
 =?utf-8?B?Y1VpNUNwdk5yMStTaGpFM2E0UHAyRUJ1SDBya2VnRkNIN21COGZpRlN0bkxT?=
 =?utf-8?B?emJ4UHExZlcwcktMRkNHbDBzYjZKS3BwWE9rYTdYeE5QbWRIODAzaUFCVy9E?=
 =?utf-8?B?Nk9FYndzYUYxRUw5NGovS2lHTk5DZjlOLzZxSVYyK0NLRGs0MmZsL25tQWpq?=
 =?utf-8?B?L2p6Zk1WOTVvQytGSGs1QW4vempBTEI5T3FHbU5rNWI5MGVVamluSXM0bUNT?=
 =?utf-8?B?Mys0aVRrVXVseHNZck9ibUNCeWJTaDNSRWhiV1EzTVVoSk5DVkI4a3RYT0xw?=
 =?utf-8?B?bE53MTF1QVpJNjZvdlVDTkdHNTRBb1NzN1VVa2NOTnA3eFFScUFaUzYvYmI1?=
 =?utf-8?Q?5Rfq//BwxEYwQM8SiIdX6iY8GhzWbMi+zMY18GuKKHAH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253142be-d5bb-4285-403c-08d9e7388f60
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 17:13:56.0832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7cDzgEsanzAEyp1FM9xBIx1JrjC8mPvJ20e6s/Sr0Fhn/COwV7secsFAcDSvVoCNFCq/iWt45o6CV4/KIYs5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202030104
X-Proofpoint-ORIG-GUID: MPQtt-uhDoJoqXC0_Eh42Gh2eUbA-b6P
X-Proofpoint-GUID: MPQtt-uhDoJoqXC0_Eh42Gh2eUbA-b6P
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi David,

On 2/3/22 7:48 AM, David Ahern wrote:
> On 2/3/22 8:37 AM, Dongli Zhang wrote:
>> Sometimes the kernel may not directly call kfree_skb() to drop the sk_buff.
>> Instead, it "goto drop" and call kfree_skb() at 'drop'. This make it
>> difficult to track the reason that the sk_buff is dropped.
>>
>> The commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()") has
>> introduced the kfree_skb_reason() to help track the reason. However, we may
>> need to define many reasons for each driver/subsystem.
>>
>> To avoid introducing so many new reasons, this is to use line number
>> ("__LINE__") to trace where the sk_buff is dropped. As a result, the reason
>> will be generated automatically.
>>
> 
> I don't agree with this approach. It is only marginally better than the
> old kfree_skb that only gave the instruction pointer. That tells you the
> function that dropped the packet, but not why the packet is dropped.
> Adding the line number only makes users have to consult the source code.
> 
> When I watch drop monitor for kfree_skb I want to know *why* the packet
> was dropped, not the line number in the source code. e.g., dropmon
> showing OTHERHOST means too many packets are sent to this host (e.g.,
> hypervisor) that do not belong to the host or the VMs running on it, or
> packets have invalid checksum (IP, TCP, UDP). Usable information by
> everyone, not just someone with access to the source code for that
> specific kernel.
> 
Thank you very much for the suggestion!

I will not follow this approach. I will introduce new reasons to TUN and TAP
drivers.

Dongli Zhang
