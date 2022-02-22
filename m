Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C01F4BF19A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiBVFlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:41:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiBVFlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:41:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAACA278D;
        Mon, 21 Feb 2022 21:41:20 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M2G5UE019030;
        Tue, 22 Feb 2022 04:45:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=alrK+LS8O1XJPoQ/z3Bbsiij9D1JoU4QLOEu1MZaVRk=;
 b=EOT+4c+br3rQVnud9j5Do5Zxus3sf+7msF7ypGoPZiTod85AItaZfB6FTJCfZ7QFWoFW
 FmD1avap/QEoN7gvv2eLPbexoX+WXCg7twa5A4usqLfPMU4u7xrYRY5zBtpkZRjSM84M
 Fe5sn4WhtZS8Kt5Uw6qR02pkkJnFZQCOHvpFEFJlNywu1DKCTkf4ZdbgUyu65NVrmtJG
 jIvV1y5dzMPcrvuDAWSy0mUMzNdTlkPFfE8ONkxQ4jHYQ7k3+14NyL2LDc0cX5Re4Gjg
 XvISsS71eiEDd1nk7R8lwYsRxfdQ2nQIqPx+NWTt9YrsRJo7ynHISiRF2cA/iY5c/8k5 ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v615p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 04:45:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21M4eo2e035975;
        Tue, 22 Feb 2022 04:45:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 3eapkfbwqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 04:45:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mn8fNVt5mfxykRHHuetUsH/HeKOpbRuOly09ZWUfwVEWXVoi2gI9DU6ebcVtoVDYvN5Rj69ZQhGcWLX3FZ56fxjhFxImb29p/xXTLWck1L/lV6b2SbNCTGF73RZSVbpsOZqZwRRZLd5Jf1TFaAZubo2z1H6sU2SkDmXGdl6gH/V0GIzo0k/aTy4fPdn2CHR+ACABMw2NxwM1x9jyP9qGcrmjC7ouLLAUBWeX9D+vo6rNi/+lbZXgsF8L3B5H21NUtVa7epBRUCQKjRsaMF0zS6FiLjFryJ6Cb0ugDBMI/wWz+SlPlOn1nwiPquSZE7J3b3j6ZihJs/5N87vCG5BzHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alrK+LS8O1XJPoQ/z3Bbsiij9D1JoU4QLOEu1MZaVRk=;
 b=jasqt74mf5PQrsGgsVVtzcUyrlQHtITJNko1+1athdgVVSwn5vYQY7CHjKKZzD5N6QcNX2S3yHwcJf7Py9FrjaDb8az8LDiFQDsmJP0R4z2wNO1oTlySqi8Fpk72rcnIkUYX2SG/xQ3BuRGk0WQi1IrcRKeaoTeOv5/x35qCLdgjfJdq1yeMoAj9JWoEStzd2gSIivFbcSkUeZ/ibH14DdQcZ7/F0IYc1HwVTxRqqij9icNprhC01tsJ0+TNGVDKos+xqDXvkmWohrWCxy03xSv+wg0O0y0KRrbNpOLd+4XgYJZePDJ4Nq15Sql06VCI7XuCn5SsyczQpiwsrqRkMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alrK+LS8O1XJPoQ/z3Bbsiij9D1JoU4QLOEu1MZaVRk=;
 b=PaDBrUnhfWbfetHcSOnJ//vKcw63fJxZgdf4ISFgNTN8K13rdQIa8HAi4FNRlc0WOgjuPNwgrKFE8opqwqEUS9tct2+DcR+Xm5o0+P614/NTPZcwJZ5usl80Tvy4WXR6J8z4+rheENbMcP+rlkjjkk8D0f9/4BjfcKGFregoI6U=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH2PR10MB4197.namprd10.prod.outlook.com (2603:10b6:610:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 04:45:53 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 04:45:53 +0000
Subject: Re: [PATCH net-next v3 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-5-dongli.zhang@oracle.com>
 <877dfc5d-c3a1-463f-3abc-15e5827cfdb6@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <6eab223b-028d-c822-01ad-47e5869e0fe8@oracle.com>
Date:   Mon, 21 Feb 2022 20:45:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <877dfc5d-c3a1-463f-3abc-15e5827cfdb6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a34877ab-f744-451f-fb4b-08d9f5be352e
X-MS-TrafficTypeDiagnostic: CH2PR10MB4197:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4197064C23FD50C5907AD2BBF03B9@CH2PR10MB4197.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERmDWzhSUkfKV0cnAKGNEiOxOTJ011xgtvyehsvg/yrmZK0btp4C5o2HU3hQYoPZZJE7H3vhYIHxSR5qfrj1dHPSIRogTKc73tGB+GKMLhQfhZsEt+8Asky2ibCCWUrzUn81OrIwx/vP0KKB8LXSApA1urNFboJebGnwj06fq5a8L1w3xOwY/cUjpIZ6BE7bv40aGEwz7YL+SfZBSvi8KVZnb06A22UOVMrM+tZ200a6pWEeR5gC3Re+zg/yfudJZTc+kwBYRw4nypOQIMScH76+R5qv/tfZCG0UiUpyZE8WRQMH6fEjCbHTtB1B7b6eG8gI/F/XQj9mpsPdM725Sd/4LYlx8AKaueiYBmMEU7x9Prwa0nvA5xpLp+HWBjc4Sy0oL9bMjTd9ZOJUvFeNfnH6wZyjBf/6qM/ZYHwE6Tb8lvMEycQ2b8+U/NNzeiL7AkTlMtMk+6SXdu0TZmuTWm7JZlbzCUemugst/a858ndB/kTQQE+msJvBamH/7iKog1iILx8QCh9V0OLht0oo+sNF6HDmKZVuAI5WagVuAgEX3Q+OdpslnPqqNAuYKiL4GIE7yHL9Mulvn9nXIePT4uHSokH27SCImWNqja+FMYH63P9nNO83+ozIqvuXpJ6Zkch8M/uYmiBozamFB9N7S0iSeBkJC+cXbRPbFJzHz/Hk9N+uOGS8PXcKWesc0DUl6GoW6MctRA4laGbZKnVux9FPBO3KSKgGgMBBk0L6XkA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(31696002)(86362001)(2906002)(508600001)(6512007)(66556008)(8936002)(66946007)(6486002)(6506007)(38100700002)(53546011)(6666004)(186003)(4326008)(2616005)(83380400001)(8676002)(44832011)(5660300002)(66476007)(31686004)(36756003)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTNWV25PQy9EVVZMK0NPK2VHQnFLbFhsdE1iay9xTldQRTlIOVpKdlJrZWNs?=
 =?utf-8?B?R25ObGpjNTlIdEpzblRsY0RwblZmbHdIUXduVVBYR0JwajZJbXhXTkZMS3Fx?=
 =?utf-8?B?UkdBeWpKajdwYUdIZUpnRjQybFNpRE44V0xaNUwvcXgvK0R6Sm9nNWtZNXA2?=
 =?utf-8?B?NTc3ZGFqRGZIN3NxTS9jQndLSE1BeUhFWGJIZlR5NXFXSms5UlhsMDRWaGR5?=
 =?utf-8?B?allobFV4b2hkNVEzVjg2enVuU1BORUVZdDkza2RWUiswYWFRcUZ6eEpQb0JD?=
 =?utf-8?B?NWlkQkRiSkcvQ0lLTCtkSXdLWnJCZkc2UjFPQ0d5eUphZ2FGd0FIL3lPVlcv?=
 =?utf-8?B?YmNRNFZhUlRJaVdHcUZ3N0dNaUZhaEJ1d25tTjNxVERXVUNkRlVIMWhzSERk?=
 =?utf-8?B?K3VnYjZoT2FOeDJSZU0zYjE5V1J2b1dyS0dNN1gyT1hSaDQyc1ZJeDk0bFhB?=
 =?utf-8?B?Rm1uSTBsc2VQbmJjSlFiNEpJMjluaUYrRXhlQU4rdFNweFNLc2UrVmNGUkx2?=
 =?utf-8?B?V1UxY0RYSVRwamwxdTlxQUFPMDBKZ3VkNElFUTMrdWN5bDJidXhYSGxZMjQz?=
 =?utf-8?B?V2poNmg1L0Q4NnBFYnN6ek9XeUd1bnRlbkNiWEV2SFdUQ3dHdktJcVRaZEtm?=
 =?utf-8?B?UDh0bDZSb1d0dU0xby9PZ0s0UEVseGdYNzB6V0FLVkpUL0ZjMi9naEp0UDV5?=
 =?utf-8?B?V2hJZmxGU0c5eXkvSGk2N0dNc2VYWjZUNjhVNC9hd0gzMlNUbXlNWFVJTnFQ?=
 =?utf-8?B?TG0rUW1oQ2N5b3haR3IyWVduYnVqdVhRdzdiRFhZQTQvZDhuL0FMWlY5NDVK?=
 =?utf-8?B?NERXUEpDdVYzN2IzcVBsVUR6K096bVd5RzBzTGIyZ1JMUjdKUFlUWXpiVUFP?=
 =?utf-8?B?MEM3NGFDU1J3NW5mTzMrMG4yMjFiRDJjbWNRV0RhR3Z1K3V0bHpmcVp2YUJQ?=
 =?utf-8?B?ODJ5eVZ6K1RmSm92UmptQy9hbEJGQkpqZDEvazZ2b0thWmV4SnJJOVU5OXZK?=
 =?utf-8?B?RzRYQXhiTVhIa2JsYktmUTc5Y2NtTzR0dE1QYWRuRG9UM1FZR1JEdVh3V2tR?=
 =?utf-8?B?Q3lOcWVlamtxa1Z3MTVtQlI3SzloLzNsdjZTS2pJazViVFk3WHBKMFN6em5v?=
 =?utf-8?B?YjhJSWtwL05Fc1VFcU1zcnlra1FMUlpHcEgrSGJ6VVB0R3ptOU5xeEQyUk9H?=
 =?utf-8?B?NU5uZ0JKRERQeVRUaVJqb2FNSGx2VHBCMEJFclExTFB0aVVzaDhJbEFGSDdR?=
 =?utf-8?B?UkltZ2xuN1I1T2hmQ0hXTnpHRDFQMmRYVHdlZngrbERCRjBIRTFGS3FMZTJY?=
 =?utf-8?B?OGZ3MmY5NktYcjhuOXFEaHFmUVZMZUQ0a0xyMGdTMmpZbHZwZ1E4NFZwelJP?=
 =?utf-8?B?VGFOU2paT2FTbG1PZWlNQlQ1dnVOcWxRN216SW1HY1N6bFBRQlpJUWg1WVJ4?=
 =?utf-8?B?TjBwQitHeDQzYWRwUVZoTVJCUnBXN2VZOC9USlpXVnVIVm5GbEZHOTI5d3F1?=
 =?utf-8?B?S1N0V0ZNRmlrWG13eFhvSTZGQU9jeEVNUnBJYmVpMFpKZlhQdStGU256NzUy?=
 =?utf-8?B?Yk1zZDVHUmxNZkE4TVFkRi9tU2VEN3BDcWNQcmZiYUlXSlZYQWFzNmtiS0Ey?=
 =?utf-8?B?YUN5Q2tKQ0ttNDl5dzl4a3VIU0VKbHVtWndPYmRaOW5VNk9BSUJTNWFRU0hG?=
 =?utf-8?B?N0laOGM4VHdkSVJ4UTBMTERQdWtFYjQ2TjVqTDV5UXJXSnhUV2pSZDVCUmlp?=
 =?utf-8?B?NGlSRnhWTm1JWFdrRFNxYmdzNXhxNzVjbmdIQXZnckxqRmZXSG5CYk12MVBN?=
 =?utf-8?B?VkRRSlZyRDQ5azZ0WWpINnVsTFk5YnVNR2VFZW1qbEVrSm4yVFZxUmpIUkdQ?=
 =?utf-8?B?MjVwcGlCMS9ZclRIVlNLYjhtdlpXdmpSZ0tWMlFHZG5GWlRrVk5DVzV6QmxW?=
 =?utf-8?B?b1JaOE5mMWdYTEE3OTNYOVR4Z2lJd0o1cmVmTG56bTN6Y3BXUVBrWmg4UzVD?=
 =?utf-8?B?N3RNa2lSeVdjV3VpTk5sSjNXUUNGejMzbWxyWjdHZFVEeGJCazIyazRlb2VQ?=
 =?utf-8?B?Tkxuc2lSa0Zudk1Hc25ZWDJwallBamZkb1MvcDlPY2NPRFFCK0NSbnNxbDZw?=
 =?utf-8?B?RTkvcVp4OFJ4Qzl2YWJNeGJQdllXWVZUOWVNTUdaaEdEQ1Z5Y05WUVRRdDBN?=
 =?utf-8?Q?58rdqVI50i33gy8b+GQRyLv0QOW2kCYAJg1XqXIXwcz9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34877ab-f744-451f-fb4b-08d9f5be352e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 04:45:53.5592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75DARnHQhhGODX1o/Aj130zdFXIPOINJuZ+MGjyRMhNUAY0De03Pta+T9I9rXFPDIm1/7+RTjgXF4FMLcuPckQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4197
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220027
X-Proofpoint-GUID: 1DuVxg98C_MLC_K3WqCL4w3LkL7ylSA5
X-Proofpoint-ORIG-GUID: 1DuVxg98C_MLC_K3WqCL4w3LkL7ylSA5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 2/21/22 7:28 PM, David Ahern wrote:
> On 2/20/22 10:34 PM, Dongli Zhang wrote:
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index aa27268..bf7d8cd 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	struct netdev_queue *queue;
>>  	struct tun_file *tfile;
>>  	int len = skb->len;
>> +	enum skb_drop_reason drop_reason;
> 
> this function is already honoring reverse xmas tree style, so this needs
> to be moved up.

I will move this up to before "int txq = skb->queue_mapping;".

> 
>>  
>>  	rcu_read_lock();
>>  	tfile = rcu_dereference(tun->tfiles[txq]);
>>  
>>  	/* Drop packet if interface is not attached */
>> -	if (!tfile)
>> +	if (!tfile) {
>> +		drop_reason = SKB_DROP_REASON_DEV_READY;
>>  		goto drop;
>> +	}
>>  
>>  	if (!rcu_dereference(tun->steering_prog))
>>  		tun_automq_xmit(tun, skb);
>> @@ -1078,22 +1081,32 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	/* Drop if the filter does not like it.
>>  	 * This is a noop if the filter is disabled.
>>  	 * Filter can be enabled only for the TAP devices. */
>> -	if (!check_filter(&tun->txflt, skb))
>> +	if (!check_filter(&tun->txflt, skb)) {
>> +		drop_reason = SKB_DROP_REASON_DEV_FILTER;
>>  		goto drop;
>> +	}
>>  
>>  	if (tfile->socket.sk->sk_filter &&
>> -	    sk_filter(tfile->socket.sk, skb))
>> +	    sk_filter(tfile->socket.sk, skb)) {
>> +		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
>>  		goto drop;
>> +	}
>>  
>>  	len = run_ebpf_filter(tun, skb, len);
>> -	if (len == 0)
>> +	if (len == 0) {
>> +		drop_reason = SKB_DROP_REASON_BPF_FILTER;
> 
> how does this bpf filter differ from SKB_DROP_REASON_SOCKET_FILTER? I
> think the reason code needs to be a little clearer on the distinction.
> 


While there is a diff between BPF_FILTER (here) and SOCKET_FILTER ...

... indeed the issue is: there is NO diff between BPF_FILTER (here) and
DEV_FILTER (introduced by the patch).


The run_ebpf_filter() is to run the bpf filter attached to the TUN device (not
socket). This is similar to DEV_FILTER, which is to run a device specific filter.

Initially, I would use DEV_FILTER at both locations. This makes trouble to me as
there would be two places with same reason=DEV_FILTER. I will not be able to
tell where the skb is dropped.


I was thinking about to introduce a SKB_DROP_REASON_DEV_BPF. While I have
limited experience in device specific bpf, the TUN is the only device I know
that has a device specific ebpf filter (by commit aff3d70a07ff ("tun: allow to
attach ebpf socket filter")). The SKB_DROP_REASON_DEV_BPF is not generic enough
to be re-used by other drivers.


Would you mind sharing your suggestion if I would re-use (1)
SKB_DROP_REASON_DEV_FILTER or (2) introduce a new SKB_DROP_REASON_DEV_BPF, which
is for sk_buff dropped by ebpf attached to device (not socket).


To answer your question, the SOCKET_FILTER is for filter attached to socket, the
BPF_FILTER was supposed for ebpf filter attached to device (tun->filter_prog).


Thank you very much!

Dongli Zhang
