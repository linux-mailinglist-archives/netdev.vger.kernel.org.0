Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782CA4BF0FD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiBVEd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 23:33:58 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiBVEdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 23:33:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D983BC00;
        Mon, 21 Feb 2022 20:33:22 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M2B0F0012279;
        Tue, 22 Feb 2022 04:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oon+9iKmY53J+jVqaNklL/CmO7vKHfDKq6CXeWIHs1Y=;
 b=ptqlNOSfop/ppZQjrWU0ItdAK8F3qn99bx7VN6tDZQPjGjvPuKDJ55eLpSlnRz6rWcUJ
 5qs/sxz8v9aBhjk/HZ1C7Yj4EBIDe1Fxfu6hinxnt0hV0QY0u+6SGeisxj2pNkDVZio4
 DUZr40h7IOJYgamgoM/6DciWZnaxTmXzedI2mcocS7XMYX+7XVVjQWmJ2cTGZPSluFCU
 9efVYaKhvs4xgMTsxRbo/972UIBCdKiqd+ms4XwPasUeAQH3iYBkh/fb/cJ8uKkNrJpU
 wthqwxUxmQZjAU3R9gOUCs0QetZxc7SM6KAJpB5I0VGhvOgZfaB04CBtM4XfXTuPXETJ xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ear5t5wec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 04:32:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21M4UcPn161125;
        Tue, 22 Feb 2022 04:31:59 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by userp3020.oracle.com with ESMTP id 3eat0m8e6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 04:31:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPOMBI2uSsSMU0G/grArN48kok8t6synDA6j+HSCo4Hj4lG7coJcpQcDlD0kBtR5kkZFXQgzeNLVY88zBDkGboPJ+fX+W7Du1RBoCQZUEBPZcCD/Cz/bB5MdeHQ5JsfzkQ6+u4I/ybLvgXUAKo/JnZFU26Xvwfi0u/bYKpO6FWXOYoxVhBizMYIoip56aUGjvYLknK1G8Sf0y7OoCuUuHTUACLmZn4Gcr9LhfJSZRMeTmCwqJQH9tx6wWrhX700fOZvGzPP/cV4TnC9gIDHO7qoLU7T2hlpOYqy3CZUSIHN6b/QZKf+nnf4nehmzAKg5nUiVKABfFb9z29n16/aXOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oon+9iKmY53J+jVqaNklL/CmO7vKHfDKq6CXeWIHs1Y=;
 b=jgk5h2OB5+cpVxe54Cl7cX8iDVOKkPT6iXf5yICftS0LyHc7zD/OgAsRLXivR45sWXawcrGnBAAeDZ1aleLubuiCU/Umaf78m0cvkjOl4ykG2GsMo4AX9Ky4L0TKcMIrLBaPQshx1WNJcvQk9PJ6Tuamdwl4pQkBUJEVonSzZmqDe9uOYfDFpHsErSFyJLKVF/9UuhxHXQ8ygubpC7ZEy/xfFWZ0Vx3z82utEogcdwQxhMyHKtgrYRlmOdItnQK+u2OlA3wzC+fAFN2hsFfvWqjl+yyW8nlN9/EpZBATN/UEYBkxSEPTMIFTxpiVoNvkFdWUwQBGDJmMkX9raJZn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oon+9iKmY53J+jVqaNklL/CmO7vKHfDKq6CXeWIHs1Y=;
 b=dPlQ9NrpLIhrnfzQr0NeLbLsAFHaKXhdYgAckKM1LnGKYMqliBzl6Tw9JUJcEouDUFbawJAQQwmR1L+vTFjb63d87aR/nXvi5CdgTXL42Yg3MEJTPwVt73nm45UR7yBN0Y4YgTDu4U/FPgNgJAbdHb2CH4Qmyqra5bc2QfYOWcc=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4541.namprd10.prod.outlook.com (2603:10b6:a03:2db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 04:31:57 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 04:31:57 +0000
Subject: Re: [PATCH net-next v3 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-3-dongli.zhang@oracle.com>
 <cac945fa-ec67-4bbf-8893-323adf0836d8@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <235632dd-ca7c-0a08-3313-1c9603807d93@oracle.com>
Date:   Mon, 21 Feb 2022 20:31:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <cac945fa-ec67-4bbf-8893-323adf0836d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:806:126::22) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2903c857-be17-4db3-f023-08d9f5bc42b0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4541:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45419D3A8B98C5D6EFA20342F03B9@SJ0PR10MB4541.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cudh6uPbHFYMhVGPVM6HcafWOaQJaTNScsy8MOWISXDeqsJDSpP+uwSTExH/iHlMZksEfFXeLavHosmgD/xt93a4FJinTA7OlCJ6ykaXeh8v6MxHT6/kq/zgIo0y7cYcUMHh5hTU8kvnEK4M6HOhieQr+OqH49r+BhHFJclxOF0OisMXyfGLL/aYukUnRSi3MoJ6S682qXyTrd91dBtaFXhLQVD+rJzvTCivZkQASxgKMfuutp3UuO+kUQOq49TVoUpDuinz1ttNIhENGLEVZSDNMLpT4safEgEGo3TG9J7qEciuKHap+pWTRoykD73mqK50bhPZF7BNtJ5U7jp5/tnZQh0nHlxTF38qL5pHN/A1HWywj8QG5wh+Et7Ngn3rpOdBVlsTfHkZAtor+uSquBacjjOqygerxS+HB77BJ6kypGUt1+d/pQ2xsxRyukhB7Irs82OHeA+YIFB+UgxA4pg4GxFQXzaiU5tbWahT5xu5zmhIs+yxQeZF/oBzBorrpbKyh2MMbM0s8VDyYKvbkLSbyPo9Jn1wn4eOGlOLz1rbnbpW2aE17aEocRQ26z4FTPRd/vTx4fpoNA4fkUF7jbv5ilrkE6GKxKGdV7wiv+EeU1FDXYSPZJsVYi9O2sZEHr8jlU0JbV/1bQK7YL+gFlm2YNZdp1Zxy6F4ud08ElNrhqUMpqZf1UNcSINg7b6EJnfDl2xGkB+JBwFtIbkF8sXcyRTZ9ZJLdnwjID9/Nvo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(7416002)(44832011)(83380400001)(36756003)(5660300002)(2906002)(31686004)(8936002)(6506007)(53546011)(6486002)(66476007)(186003)(2616005)(66556008)(66946007)(6512007)(508600001)(6666004)(31696002)(86362001)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWlvOFFSOXVrWGhEcXJpaFFRWk9GYmpGL1RTWXV5MWl6UFc4Qk0rMFV4Q2o4?=
 =?utf-8?B?UEVUdlZlL3JEeE5jVlRZekM5TUNWb09SMmwyeUtMMklxSGxEVVc5RkMrMnNl?=
 =?utf-8?B?eEVsd3hPTXFwdE5KQVZpem5KQUZSajZIYk9wd3JqRnFSbFdnaUNxSE9RVjhL?=
 =?utf-8?B?eVNhZDZEVFJpMlNwMFNiNmNWYkxQZytuMjRrUGwvNldJVHp2MFlEdzdRTGJS?=
 =?utf-8?B?LzEwQXJoRjkvdFJBcUs0bUNxY3A4MFgycEgxMEZkRDdIY3R0bSt1bCt5VC82?=
 =?utf-8?B?Ny9DVXoxbFdUdW1jdFZmNGFnT0dyc2lvQTVxTnpPV2FzTXlXanVZT3VqNTJ5?=
 =?utf-8?B?bkRoNU1xOWRpZ1ZsZ0lXa0J5cnptQThjL21OQWlqbzhhbUVaMzg5WlQwaUJX?=
 =?utf-8?B?amwwWEJya3NzeWs0NG1qOXg1akVuYUl1REh0MFdaZkZHVTN6c2hibG14WldN?=
 =?utf-8?B?cmFCUml4ckJTTmdzUHBoWVJ6YjY1NkVVWnI3bjd0ZW1pMm9ibC9RM2RiRmta?=
 =?utf-8?B?VjM2NHNTZnllcWE2WWxMOXBOSnFENTBHSzRHYTlkM3Ezam9PY3BNdU9PMDZC?=
 =?utf-8?B?b29hb29BSlpieExjOGl0MkJRblpDWGgvTFUyelNMdE9zWlJUS3VQeUhFRGJR?=
 =?utf-8?B?VXhVSWxUTzlmQU1jb0NSSFVrOVM1QWNQeWF5L2VIZWttdWRCc3ZHaU16QnJy?=
 =?utf-8?B?bUxxVEVxZmNycVRIZXRIUHIrZEQ5UTNZaHFzUzFHcTIweEdqL2IxNlI2N2RZ?=
 =?utf-8?B?R1I1cmNmNlQ3Z3daTzZvcThhQ2xLVmR0emRYdm9iZTdvSTBYcm14K2t4U0k4?=
 =?utf-8?B?cUgvWTZ6bE1rektDQmVZK3AwV3FuTzFzOEMrU2Z6R3daMzFSOE1xaXB1QWhY?=
 =?utf-8?B?dTFnaXgvY21OVngySFgwOFJ4bWR6SmxDNTZ2VHNzWjVRb280UXBXVm4wdE1D?=
 =?utf-8?B?NjVGeTl2QkpLSk5xa2dCUVMrT050RmcwZVdSNklhZVg1NnVGVGsxbnhVaEVi?=
 =?utf-8?B?c1BReWNJTzE2UEU0bXdsbW9pdlA2RTRUZUpmZm9jOWs2cmthV3pKS1VmMzdJ?=
 =?utf-8?B?WFZHVGlVWElvckl5TXlNcnJFZWxMTVhjR1U3UlRKMU9PbVhwVVpQcnlGbnM3?=
 =?utf-8?B?V3Y3aXJBOERxVDN6a2paaW1tSHV6SXcweTV0cUVkVU91c3pOdHljbGRnc0ta?=
 =?utf-8?B?T3dObHlCZDJlS0V6QTBmRW1SZWptM0RiWUY3QnNQWjQ2NEtvNnZtOWFjNURB?=
 =?utf-8?B?L3VEdFovSVJOZ3FjQ08wcE1UWmxrclBUSVVBK1N4VHBOWXFaVjNxY2ZncmF4?=
 =?utf-8?B?OW14Tk8zSUZVTzJsV2FQM09CcVduczZMclFGN0xhS0FqVW1sc1lJd3JYYTU2?=
 =?utf-8?B?QXZNSXplNThqMEFTNFdWdG1LdjhyRG9odnN0eG0yY2N3bFN3ald3T1pWRHBR?=
 =?utf-8?B?VGlWdEFSR0hiSmtMMU9naWJTQjZ0ZUFLT2dZQjdQVVBFUml2V1BVVkNKeUZF?=
 =?utf-8?B?MGRSbjB4eUtBSzllSThxSm9tT1NzVXg3UFkwcEtlRDU5TkRvWVlwNW1TTU4x?=
 =?utf-8?B?ZGhpVW93VzY1K2ZNYXZaS2xFUkhQZm5EMzdlQ3R0YXJaRnd1SloyTEE4dVJN?=
 =?utf-8?B?L3JJSEhvWk9wbmIzWTJaZjVJbWsyNnpySDE4UU8yeHhUdWZ1SXhRYythYmF0?=
 =?utf-8?B?TnUwMXRDRDZJRUtWYVduMFFmcGM5RHF5NS9Ub1E5bE93Ui93NVM2S1VLeXZZ?=
 =?utf-8?B?MTNDSG9vTFpuU3pTSzc0Yk9uRlFqOTRtbElValF6VDRmUjdGeUZ6OXRQT1pi?=
 =?utf-8?B?WFpuUHpIcEU5RGhNTFlXb3B5UXRTYTFoU2JaYndiZStUWVd1cUEvdHhiS0Mr?=
 =?utf-8?B?RDl2aXE5YXBFekU3YjZlb2l4OXZwRno4R0h5dTRPT251bjNxb3M5elRuT1Ex?=
 =?utf-8?B?MjFXS0U1aDVrZjgwUTczZ1paY3dFaW56dFgyR3NsZlRoVVlKZDBlREdOcjBw?=
 =?utf-8?B?NStTYjJlYllmWmMzcUZuQUYweDlMQkZBMWdxS3RZUUx2YmZheS9WbWZiNWlv?=
 =?utf-8?B?Nnh1TEJoRXBxMThEZUkzZUtPNjBvWm8zNUZTYjlPS1g3Z0gra25iNDI5N2pt?=
 =?utf-8?B?M3VRekVTYmlTeHFtc1o1dGRQRHdKcGtJd0dVd0ZFM2ZsQ1dVVG02REUxT1Fk?=
 =?utf-8?Q?HOl6shfuw1KHmZi4/KhfdwNRJmiSWvvp4fGpygBGNh85?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2903c857-be17-4db3-f023-08d9f5bc42b0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 04:31:57.8371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KE6W9RJcg4Bh/XNfMnMwVf7KYUdlGTVhQr0PWKBo+dkJxr0oJH4CAdZI3kBPwRZWkXj2tG1i0SAvcWGVju/vyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220026
X-Proofpoint-GUID: AkqMjV-qDgSzmCjG2_Oq3dnkfET-U0tR
X-Proofpoint-ORIG-GUID: AkqMjV-qDgSzmCjG2_Oq3dnkfET-U0tR
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

On 2/21/22 7:24 PM, David Ahern wrote:
> On 2/20/22 10:34 PM, Dongli Zhang wrote:
>> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
>> the interface to forward the skb from TAP to vhost-net/virtio-net.
>>
>> However, there are many "goto drop" in the TAP driver. Therefore, the
>> kfree_skb_reason() is involved at each "goto drop" to help userspace
>> ftrace/ebpf to track the reason for the loss of packets.
>>
>> The below reasons are introduced:
>>
>> - SKB_DROP_REASON_SKB_CSUM
>> - SKB_DROP_REASON_SKB_COPY_DATA
>> - SKB_DROP_REASON_SKB_GSO_SEG
>> - SKB_DROP_REASON_DEV_HDR
>> - SKB_DROP_REASON_FULL_RING
>>
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>> Changed since v1:
>>   - revise the reason name
>> Changed since v2:
>>   - declare drop_reason as type "enum skb_drop_reason"
>>   - handle the drop in skb_list_walk_safe() case
>>
>>  drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
>>  include/linux/skbuff.h     |  9 +++++++++
>>  include/trace/events/skb.h |  5 +++++
>>  3 files changed, 39 insertions(+), 10 deletions(-)
>>
> 
> couple of places where the new reason should be in reverse xmas order;
> logic wise:
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> 

I will re-order the reasons in the same patch and re-send with your Reviewed-by
in the next version.

Thank you very much!

Dongli Zhang
