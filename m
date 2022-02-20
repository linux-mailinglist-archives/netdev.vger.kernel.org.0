Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADBD4BCC87
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 06:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiBTFmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 00:42:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiBTFmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 00:42:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E8863D8;
        Sat, 19 Feb 2022 21:42:11 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21K5WHXJ024949;
        Sun, 20 Feb 2022 05:40:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pAVnhX4U/WuHcquZv9yx77+9Y519j7+DPA35tox98z8=;
 b=giql4TCcRWbAlc81lT88Xu/EKfMFHbRNxtvQR4S25K84CAHpK85yjt8KZ6hubnNTPdQa
 HxkLqpsyACgz9hHNfpExq7YbL13345K/a5RxqxrCdRr+s1yyGj+zrKVgdc+AhTZ5wheo
 q4KgDUAkruLkKU4VPKFTzOQ9ihMa6EvBCRTacC/2xhmVLIx9OZ7LICB5xabBYySl6rtp
 YLwNGmJOt8HAzPpsHORjcIdu9urXXVmvN27oHwjhkSeH/td3+QgZsZCO0aTNyyeM9CsW
 SxN4W+GTOufud/RzcZRSoWr29q7CvwfmRFzWG2x9dDK0J6JqSYJK2vCKduzGSeK/9M0t /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eaqb39j1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Feb 2022 05:40:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21K5e2M3141052;
        Sun, 20 Feb 2022 05:40:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3eat0j20cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Feb 2022 05:40:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaKZYx8RQf3Rn307xx0u1e2sMYPBeFO3wk7vbMm4FOz7O+ksYdQZKotVaBgUo1gUlSL1QSmWZKYPE803cCt1VgBFnF1HU1HRt/W4tdxaqdbdB7VDIKMLOH8PAcvpPXjWtyQbhRdzMjP3KjHettG/9fJxTawAA49zXEyEoPB82Fa/br8Kf/afKqZ0fObup3uku78uUdxWJV8Sru0VTDvx2e6BG7UPWDQbx003Vn2uxkeCc4sKQ6dW1Y+2FKv4/vE7XrDD85gYe6ZFT0EIrowlreNsyp2d13LkYWpKFzhL6+cA/k+AGsPnsQpXAp1BnlRgd2o+9Wj052TQV0zityJkyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAVnhX4U/WuHcquZv9yx77+9Y519j7+DPA35tox98z8=;
 b=TBaMU91LVNdq++QNUUPaXnRhkO/VlLj4U2jludvoONyR20WgAz64nbIpYuxVowpZZqbK0vCI+kt0ZU3tDTd4PwtSX1ZSNFm6qmH3+Z/EHaDV3/uon8tcGht6q6+DnJOdz1EJASRu1dnkjAaJtrYWjCYpXRR4fnHEApQhKlfDZiC+UXZbVDJsgkrzjpz1/yL2qV1L5ycLuEm1LLZWQj5mWo3OYUR2OaafVThEoKTGSGJv14E9bDsOUpHZphfFDWh8QrqwgrYOdfybPd88hNWGlBs1WqrsJWI1+MHm5x1IVFqzhYEtSgjRmi3epiqV8UgsJqWYJot2cql7th6wlmCOkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAVnhX4U/WuHcquZv9yx77+9Y519j7+DPA35tox98z8=;
 b=MSqUF6bd+5ToS66KslmvHzWLWwm7wwz5fXckgSy5og/RyoynqYkAkAqPn1FsIVsEvXu04Q6BipZOGWFt1l21rNxis/uoBBtwS5+aVz87VKJvi5kJX1j7EmS06vphhFnJWZAGmkN/UiOqokf3cGaiNYBFLgHX892XW1vmzcScUJA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH2PR10MB4136.namprd10.prod.outlook.com (2603:10b6:610:7f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sun, 20 Feb
 2022 05:40:44 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 05:40:44 +0000
Subject: Re: [PATCH v2 3/3] net: tun: track dropped skb via kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
 <20220219191246.4749-4-dongli.zhang@oracle.com>
 <29ff2768-ca3f-6a09-1df8-d703f85ecfac@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <bc0e5a09-e139-0753-26f8-5bc5634a020d@oracle.com>
Date:   Sat, 19 Feb 2022 21:40:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <29ff2768-ca3f-6a09-1df8-d703f85ecfac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0147.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::32) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8868ef8-44e2-4830-da05-08d9f4338a03
X-MS-TrafficTypeDiagnostic: CH2PR10MB4136:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4136E687B4B6611736AD5F2CF0399@CH2PR10MB4136.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ihx2n8LKw6ZeVMO5QlEsm17nPC3PrKPm3JExyj2JlT4UlPAIxkjCWLHWC3nFrJejKHm2egBicoDst3uFVuWMxB/ynyZxPNnEze0eGfZbA13c29Ya4N3f3kI/TQ/vU6G9wBgGWi+1h0pg0c0tM2RVldd7r0kpnX1VBAoKhD0ewDRQwXaoeFYxKTZBwzq6di3screhDRx4WJK5LoLHsVOG2ztGBWQlF/6BiQN/L976tNgTOHY5KsHBhLEUyr5G1yKk8VndXCP4bdvMZ99k35P7Q6RoKLclM9DttOPR4L48wLVqjZ2DBPMaAOCDj9YjdXDpP7R9ZQC9ERTK9TmJglZF803DsYFqEduYy2vHOsPyXEh+is9qXZkcescaJPPmAqhp0OEp13wlYjkiaf6s13rZufUHGTPLu8jBD7ak8COb23dzqig7DH5nq7IL0r4Jtu0LTrEYcquYHFgiGAahwfWe7SO5EJqRz+GZ97QfxJbaFQQJcgBOhVcp+BFAYOv/o3NQ9tyC+jV4zjR14X3Jq0zEJiYoxrSgEWm5LrkUTpQSh0xy6wn3xA4/R63fKpJgRnEWaPw/hLMbl37zBqYaUa161iqfhYpjuLAC3oZ3KN9JnIn98iSBeL6sYY1ypTiLYBEVG/J9AYFedBf7WsZYCOqhEL8xYhImGKhP0+WhapHwY1dYiuJrAdsk6NJA96JuQMkJ2SLyQLOZhCrsoz4UqGZgq8903Tf13MwuHc48yVHLqfk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(38100700002)(86362001)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(5660300002)(44832011)(4744005)(7416002)(2906002)(186003)(2616005)(6486002)(498600001)(6512007)(6506007)(53546011)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkE1MkJPOWNPR3JDUFdPcVE3Zkc1OXJmYUhocFZlQjVndkY3SGtlUXR5V1R1?=
 =?utf-8?B?RU9rRnIvSTJMN0lsc2JGR09jdHZNNkg1Y3VXeWtsNWFkcHJ6UStKVkFIOExV?=
 =?utf-8?B?aXlZUWltMzJPS3ZPTVVMMkZubmc0NXFQWTJhcGNCOC9rb3VJS2hQdVduQTd3?=
 =?utf-8?B?bFFydytsbHNKTDU2UVFGcWxZd0g3TzJDdTQraTNWQ2tnb05VRzl6c2M5WFl2?=
 =?utf-8?B?OVFKcVFDVUpRcGVMVU1HZWl5V20xZDdiMkU2RHdZaGNEZCt0eVNVVXBvbXpL?=
 =?utf-8?B?NFNtY29adkhMSTRZaGp4UlVTS0VQZkpVQVN3Nk9WcWdEK0dMOUMzcWZob0JV?=
 =?utf-8?B?ZjduMVZ4YStobk9zdE5ZMEYyRlh1SE5raTIvRmZJa2JOZDd5NmhwWVpRaHg5?=
 =?utf-8?B?RkhMVWlzZGRoelg4dDc1MmJ4N3U4ODg3Mzh1QjlSVFhNcENRakhob0grR0FT?=
 =?utf-8?B?RFhEYjlFbG9GN2hFeXFNSk5oUS9oVG41OE5uREFyYUxMTmxVRlVxMTdyYWFH?=
 =?utf-8?B?UXU5dkFSUUFhM01VSGtaU1BYMVFDZWRyQ0N0Z2ZUcUNja3FlRk1vWTAzeFNx?=
 =?utf-8?B?aFRXL09hNnJTOC9mSXVnakErWjZ5cm9GTmZjQ0VPM2hyVyswcmk5Y3VQQndj?=
 =?utf-8?B?ZWsrdGh5bWxRTFYxbG10b0E3TnBtYmFyeklWYUxBSWcvbkM4MElOWmdGdTY0?=
 =?utf-8?B?akRDdEkxVENwSWtReGFzL3BiV01Lb3RXL1VXSm9YU3VuQ0w2WitrWmtBdHNo?=
 =?utf-8?B?TjdGRFNZaUNVZUdZV2w1QTNVczkwVUtjZlRrUkx1YXI3NXdQcVN2aWRmRFZi?=
 =?utf-8?B?RGdaR3BZQWNJSGNCamE0MVY4UjU5WVRvRUNtNUp2b0pvczBBT1hzODZYaWlR?=
 =?utf-8?B?Q0lUTWdIQnBqSXZVQmFWai9ZRUhNUkRIdlhPZkpaSDBLSk1ZWFEzemtqaFFF?=
 =?utf-8?B?clhCZERiZUg3dGhvMnBBV3RGNUhMWEtzUFAwTWZKSm5LbU1vdzlpQ1pFMkJS?=
 =?utf-8?B?L1ErMlduNlhxVCtNL2tqZjZEUk5HbWRqWVRmSldER09tdUF5Wm10bTJja3pI?=
 =?utf-8?B?ZlZ5R0ttT2pYbVBBTjQ2SVJuSlB2bTdJZ0p3MFZ3Ni94WWMzR0lsWnRyRE9H?=
 =?utf-8?B?RU9DbXZ6RmdvQ1VLZnUvNjloSGdnTHprMUdLbHE0ZXVwQ1VkOVR4MUd6MCta?=
 =?utf-8?B?T0NVM0ZISURtVUJQVzVFRFVySFlyaWVnY09NRUFQcktRdUZ5QjVidDFZbDdM?=
 =?utf-8?B?NnExN25PT2ZjeXZMNWNGR1l3RDRGeGwrcGc2OFVkUzhvWnk2dk1xL1JPNkJH?=
 =?utf-8?B?Z1o2TzJPVjh4dkJBREdNczhXYlpnazZvWEtRVGVEUXJCVy90eFcrMVhmak41?=
 =?utf-8?B?ajEwUTVLSXhpT0F0YVNBZGJ0OEppZ2hVOVFuNE1UZ2NlSzNiNjh2VUtVLzJV?=
 =?utf-8?B?RzR0aG9URnEwS1lPeTA0NEh3OHhrbUczYkIxLy9xblpIVitGZ25remQ1ZHVa?=
 =?utf-8?B?enRkRUFrZVZaejFpZ1ROTVpCRTBVbGE5WkZTSGdCbWxWTXZ6c3IxWEJKaTBi?=
 =?utf-8?B?N0F4YkJsaE9tM2RWOWxxUk4wRGN6bS8renkvVDRoeXY1NEVzd2dkQ3ZEMHpR?=
 =?utf-8?B?dVlvUkR6RW5TcnJlaGx1MjcxVERFSzNwbDVjWHhVckNWbTVCb2RHUXVjcllm?=
 =?utf-8?B?cERsUXJwTHMvQXRsM0NiNTJucVo1akRHUC9wamRFUDNLVVFMVGlHVXdZZUp4?=
 =?utf-8?B?SXVDQXRISzVKQjM2R1g3cUE0UXFJL284RS91U0FZZFdNUW9MUmptN0RtSHRw?=
 =?utf-8?B?bjB2QjVZK0dEZThjZ1VUNFF0SFhIMXFSdEZ2dCthYzVWNHU2OGZFb0hQb2VE?=
 =?utf-8?B?aVF6ejV5a1FaS1JvZ3NiVGJKSHNTVGtONE0zNG1tQWRTQnQ4N0pLdnBFaUVj?=
 =?utf-8?B?RXJhQlFhYWxaNzlGUXpxbDFvRHhIWndmZnF0WW0ya2RSRG94UUtHMnpWQzdY?=
 =?utf-8?B?V2R2K0k2NHhIMXhMaWFha09kVGV2bVM4MGJNRFBlc1VzelNoSkNPQjBVT1p2?=
 =?utf-8?B?MFdYN29xVjFpbkhIN1F3UXhzSUZqendOMmhBQzEvWm9HOGpMcU9EQU9BNFZo?=
 =?utf-8?B?bTlTQlNwbFkxakdEZnNQZXE5VDZ2VldXQlhYZ25BejRSRkcyVThmTVN3a0Zp?=
 =?utf-8?Q?NFi3/OPmvU66S5IcWBcVvUoPewzA4OI5wT761Ex9wN95?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8868ef8-44e2-4830-da05-08d9f4338a03
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 05:40:44.7372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHHaxeUNMcVA0270eC+aLvpiXYW8ezjwJLjaM5WCCJXjSCLJAqxOgfFMSFXUf5rZt2l8ViZE7zWc/W9C1T3scw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4136
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202200037
X-Proofpoint-ORIG-GUID: vtFxWzf1YWjcGsUlMJgg4qyHa7LutTt6
X-Proofpoint-GUID: vtFxWzf1YWjcGsUlMJgg4qyHa7LutTt6
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

On 2/19/22 2:54 PM, David Ahern wrote:
> On 2/19/22 12:12 PM, Dongli Zhang wrote:
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index aa27268edc5f..ab47a66deb7f 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	struct netdev_queue *queue;
>>  	struct tun_file *tfile;
>>  	int len = skb->len;
>> +	int drop_reason;
> 
> enum skb_drop_reason
> 

As mentioned in previous email ...

According to cscope, so far all 'drop_reason' are declared in type 'int' (e.g.,
ip_rcv_finish_core()).

I will change above to enum.

Thank you very much!

Dongli Zhang
