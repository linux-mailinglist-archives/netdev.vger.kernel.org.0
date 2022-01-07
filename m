Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98FC487AC4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348360AbiAGQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:55:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33588 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240137AbiAGQzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:55:14 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207DswIg014686;
        Fri, 7 Jan 2022 16:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=h+x3fYIFmmCy1DZJl1g+VUIFxBml2+dgbUfmAdj0T3s=;
 b=Or6XOy7zQt/zYdIMieDJ0j2r5DnnabOUzeaj6acF95k7SSEWHcfIQ5ogNcU+kT+DZ2Eh
 tDYs31B/JWkPYykamHjei1Ur8gI4nl2ezIjbUQni/GLzA1+nTgNy6AePqdRk73i1iwZY
 7URc5ZLKrPK4M9XRUKDT7soVGBxgEY2Rmlneo5KRjIJS3eA55NBICk6mxe8pe7vutPUL
 BQYz50SbfXyu0rOkfZxQoWckDk7QxopvxY4iHExCUz462lEz2lyE9ePQyEUiHWpASdqw
 M15PyK2VKA4gAAG72UE0hH8pNpuryl/2Z8NaX+Gj7zTfIG1yY+9e3syMIDf0Tnwpk3vJ XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v8jh7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:55:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207GVPSM181467;
        Fri, 7 Jan 2022 16:55:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3de4vnxr8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:55:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLzm/LmMF3S/x0mSyr6tp+wZM2jFNbSx8J4oEx2xW1qaa6+0XfpMvU+X2r0DaKpgRyoUB0vJMXkO15Pz7PeAym0farrYZPAJqyxMUVn7Flcx3EqEs7Hj+rpi+erLT9e12LZRoZEL23cnpVTYjaL8KyRs0vuT+cJtaMKXWHO1lBDt20zpaodYnxD7TFeU/n0/vYOeoOFER1MzJC6iWqef1FdGonDpv2EVIS0QX+6zx6ySUzorD0bZyHwwKE3uBYgpPMDXKxMdos4CMv+qn6XAq65I+v7ka8eRPTEHxuWmlpDYDak7cOECmispnLqxfO5MrlV3wderX0zbtC9uHXUE5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+x3fYIFmmCy1DZJl1g+VUIFxBml2+dgbUfmAdj0T3s=;
 b=RPfq1CQ5EQYBW+m7ozry7ClkUBqAn29SPbM3UPvZ/heX9k3agUI+PIXddOBGNZj/qHwPYuVkwZx2h6t64XsJ3u59rmhDrG+x7jlwZi6Y7bvWHlEwB4uKTTQlSXvmMMXJRDQBqjQMkO7AYXdZon3XAGOzD0U79+1MvBD6cBPK4zTF5eEq5mIBvQuISgs4PgJ1AQWZeHxx1PmrXZ/6tKG1tXPrj+VkRK76IpjOeNd/Vex2sySuTBeSnt83LIhtTze4Jfr1HKieK7WKFwYIgEJqfeXXQKDH4tcKvIe58MyuQVQYgmu5Cz3BNjM2lTZbaVyXbmHJAXv84yI+2gRxL4RrMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+x3fYIFmmCy1DZJl1g+VUIFxBml2+dgbUfmAdj0T3s=;
 b=Wg5J8wYsUoVtioQfudWB8Rin7XUZFfpm02F6Ov+JJLi4uavLX3BGAkzCbWjpQr3qUFl3zhfvUAPwgvLQJc6Uc7zEf7zYGRz2AI45+34TfFq5RcLynSox5JHnJjehTwjN7sHxcBK907k/Nz0RPvuy7BuBmSu0+/3ULMIHm1r8pLY=
Received: from CO1PR10MB4532.namprd10.prod.outlook.com (2603:10b6:303:6d::17)
 by MWHPR1001MB2080.namprd10.prod.outlook.com (2603:10b6:301:35::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 16:55:05 +0000
Received: from CO1PR10MB4532.namprd10.prod.outlook.com
 ([fe80::39d5:4686:22ac:da3b]) by CO1PR10MB4532.namprd10.prod.outlook.com
 ([fe80::39d5:4686:22ac:da3b%7]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 16:55:05 +0000
Message-ID: <baa2a339-2917-fc6b-6cc5-c4174c20f533@oracle.com>
Date:   Fri, 7 Jan 2022 22:24:53 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [External] : Re: [PATCH 4.14] phonet: refcount leak in
 pep_sock_accep
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220107105332.61347-1-aayush.a.agarwal@oracle.com>
 <Ydgi0qF/7GwoCh96@kroah.com>
From:   aayush.a.agarwal@oracle.com
In-Reply-To: <Ydgi0qF/7GwoCh96@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR0601CA0003.apcprd06.prod.outlook.com (2603:1096:3::13)
 To CO1PR10MB4532.namprd10.prod.outlook.com (2603:10b6:303:6d::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19527ad8-2dd7-4794-69ad-08d9d1fe7427
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2080:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20800E27E01862035AEACB64BA4D9@MWHPR1001MB2080.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WgPc1cQr2rbLa27ftNC04IOA2VHSf8/Hyg6u6+mhQHDN51IP7Z6rhKMSMaKrgccRrLYQiLGLkAasWXHP4tIGSGvi2/B5gOQbZ64zC/czXhxYoMdTGhKugar9ru0uPl7nEXO3qo1rMlQH9gp9+jtmMU6f7qr7kDqV1mcprOlS1T1B1UlAuP1vLHgbsZDChIkfKBPqqeu91ZFAubhOG2R80dwufSNBUdMKpcvdSv43VBGGMijd+DjMEw/arCMrrJR893Tlpzdrzu4bXMz/YpoqOb8wXINSFQp2M8uxQg9l8MDxPCvnUNmyj63CLjCkNDAnYbW9+CigYN4ItkLe/nV0nDI0pVy1od0IN4D4wOTgvtbLNS2YDtdC/uJVcT16pgatlg+GGmZjpKQvjHRLOaNNeUEL/QOXpxtsDsXBp6HWV3lKeMWBmkws5FL8V8U3HVDBS1QVzzuQXEIhc/ublVcO0zrYOFFElW9l5gS4xIHsiJzm/ZoiQywdsqLpjbm5MtwT8Tp15ksJBeUotrunfHejESJN/a/X86Ux/1IouoxHZPJTn0Rp51WAn3OMvc4hdqENKEYJ7Ji7Ikjn2pwUFfrg/wLuOgPObRSIMewbeVHuUO0QrlUvvWhKHAAdm0b4rUuSd6pOFA5jayq0AB1YNkUGho4jY18xEjpUv9l/s1hu2gdha6tMdEWO8f5ccPP/dQXXBtU1/2GV50oQXpl6zZcU2tQ2fzOWPiySKRw+8gikcmkQopKiXL8+c09ElV3SoeUJkr2sDaEk0xCJTZ0aDEBrZIIDuICqwp4h6T+f4hqj6/E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4532.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(2616005)(6916009)(53546011)(36756003)(38100700002)(6666004)(508600001)(2906002)(86362001)(966005)(31696002)(9686003)(6512007)(5660300002)(6506007)(26005)(6486002)(66556008)(31686004)(66476007)(186003)(316002)(54906003)(4326008)(83380400001)(8936002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG02TmZMK0dPaFhNaWF6d3lNdUFQQnpoOEs2eXMvdzlEcmxwNVpwVkYyQ0JW?=
 =?utf-8?B?ZTRuc0ZHanFYUXY2MG1XYVQwYm82bk8zbUVKVjZFUWMzd0puNGZKVzIxR2pS?=
 =?utf-8?B?OG0yS3pZemdRNnhFdE14QU1TYXg5ZmMxRFFSR2pNSmZRQ0l2MEhzSDRZWFJr?=
 =?utf-8?B?Wjh5Y2RreC9IQXJ4RDVUVXRpbW9sSWN2MXpLdnlsc1AyOGQ4UzhNKy9NelhU?=
 =?utf-8?B?T1orSkE2ME82L2ZiT2tIVXplVWxXQUNMVnNhb2JGSzYyblFQNXF5VUMxZE1l?=
 =?utf-8?B?Yk1saWZtVTJrNUtUdkpuVExXZ2dRb3pDSkhwWG5wVVBvZGo2NU5PODJ4ZDVX?=
 =?utf-8?B?cUZDWDE3RGpLV3pkOVJJTUlaOUo0TFRWZTBqM1lwdS8rRm45QjgrcDU1M2xY?=
 =?utf-8?B?c2NSSU9uZUJmN2laUG5DZWlBK1loMjMwaElhKzlPL2NBTkFzNWd1b2EwZXEw?=
 =?utf-8?B?T0NiSFZkOHp1aXZxYmNKZUFBbjlsbzk3bFJNMGI0ODA3VmNrRzZKL3Q4Z1F4?=
 =?utf-8?B?NFk5K0FXc2RnL2V1Z0pDdVJzVXNYQU9zbXp6VG5Ma2dsRlF5cDhIK0cwTFd5?=
 =?utf-8?B?UjJpcnNLN3lLYk5SMDFvU1UxbDFneVc0YUJhOXA4Qmw4YWpoOG1Od0t2TUhX?=
 =?utf-8?B?Z1BBS2pYVGNjQ0d3SXA1RWthTnUyVU5OMTU2QUpmaGdvOE9xR2YwdUQvQi9S?=
 =?utf-8?B?V3RwSERPWnBXWFZ0d3hRbVZoTXY2aUZqMjR4OFZDZitlR3pCN0VDMTlNcWpD?=
 =?utf-8?B?WEpWL3RGWFBDaWhUYi9EdW92VW8vR1ZpUC84M2FRL3ZHZU5KcTYyYnpyenVq?=
 =?utf-8?B?WlRlM0pvMHh6UGdEc3RRTUtocGpaYlRyR2poOTZKak9Ybi9Ec1BsT0hORkpB?=
 =?utf-8?B?Zmx0dUJkempHQ3BsSXJLa2xRYUdla3RWTS94UFYxbmUyQjFrdkdra2hqejdt?=
 =?utf-8?B?Z2RoZzRsZFpxMDlhbE9qckF3RHBvc0dtdTMwbi9CdWZ0WjZCTm1FOSsxZHN0?=
 =?utf-8?B?eWJaMGdQT3hBNUhuOHgzbDdhVGtZL3Qzd2Z0Z1Y4SDR2b0xqeHN0RGMrUURN?=
 =?utf-8?B?U0V6UGtKeXFvVUtFUnpyWmR4VDFOUkRqNXBraXNadUdmZVhNMHhvZEh2Yjlj?=
 =?utf-8?B?cjZQc2ord2kxWEQ2YVlSSHhEQnhIRmpxMTIrOHUwejd1T2R5UlphVndkNy83?=
 =?utf-8?B?c0RJSXNOc0VCU1JxMEYwaVhoQWQ1TjVhNHJBbnp2S0ZkZ1ROUW45RTFuK3R4?=
 =?utf-8?B?NzIxaVBWQXpyaEx3UnF1dEZuSGlhSm96TkpZb0M2VmZjMXNGK01ZV2Q2Zklo?=
 =?utf-8?B?MUZQS3puS1BTOTBNU0p6WXprUjh4RzR2Y1JBd1RvaXpWbkdRakJLMGdFK1pE?=
 =?utf-8?B?NXkyLzBSUHRROTJSVjBlWXBERnM4dk4xUTJMbjh6WEp2b09ZYnAyYlNVVkJa?=
 =?utf-8?B?eWlDQXg1dDJEbHFFWVlGVXB0UDdKY2Vhb2FsUjROOFdJWGJTOEZlazJxRjdJ?=
 =?utf-8?B?OWk5Ui9aUlNtb1FEV1VNZHdkc09sWHNXcG5KZ0NraVFMdmhiZ1h0R0JyZHEr?=
 =?utf-8?B?b1h6WjB0RVpSZFZkdmVVT05YSlhpRkdWak1IKzV6R3FqYURCRWRWYXU5clRu?=
 =?utf-8?B?SGxtNVhtazBGcVB3dzNFTXl2em5KdFY5aDY2d3FwcDZPcEUrMzBzTTMrRlJR?=
 =?utf-8?B?TWwvNk1iMEFDSVdNcTUzL0ljYVVXR0FaYVYzZmVUQ25wMDkrSE5kaW9MS1Vt?=
 =?utf-8?B?eFFGL2tRaUJScnJZNHhmbElGbTQwcjJBb0ltZUdzdTQyOUR0aFVSM1liclRn?=
 =?utf-8?B?NFRmdlZpV0tPbTNOR3ZEMWhNTndNVWlJckdoVzRKdVViUit6VXEzdGFRWlgr?=
 =?utf-8?B?QU8rRGNVRHBQcUNpK3RQYjlVYmRIUmhOcitERVI4cUNVd2xhaC9mWEx5WlVr?=
 =?utf-8?B?ZzkrSHl1NW16WGNSblozZWxRRm9XUjdWcVNPRTQycHYyZG01SFhtS2hSZDJW?=
 =?utf-8?B?NmJISkxFUEdPOGFZeHZpS1NpamJpUlYrZFhnd0ZDTlFWRkk3TGFldTQ3Tmcw?=
 =?utf-8?B?dSs4SEdTTW5oSmt3RmVTZ255dDgwRCtZcUkveFB6NWlDRmVKRllyeTJGQjgv?=
 =?utf-8?B?OGZDUmZXWTg3VGNlY1M0cXVhZFFYdDlteU9QcTJYcTdLSjhHOEZyZFBlNEE3?=
 =?utf-8?B?Q1J3TDNpK0xSWHUzYy9YaGp1dnpSYlhueWFPR3RmS3QwRWFZdFV0dU9uaXpz?=
 =?utf-8?B?WDFXK0E5N1JjNGdidzJuMExsZG93PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19527ad8-2dd7-4794-69ad-08d9d1fe7427
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4532.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 16:55:05.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlWB4jrh1122SEXA85T/tBhGlYdRz11OhXPpM4/IhD7d/zXjAziyJ1VFpzl14xNFHiSnTOv1b7DpC/aUIVh9+3hfGw9tcdzrD7GovobsDHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2080
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10220 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070112
X-Proofpoint-ORIG-GUID: jQjaWlJqbDErfpFRdPo7MYkVEBa1ySg-
X-Proofpoint-GUID: jQjaWlJqbDErfpFRdPo7MYkVEBa1ySg-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/01/22 4:54 pm, Greg KH wrote:
> On Fri, Jan 07, 2022 at 02:53:32AM -0800, Aayush Agarwal wrote:
>> From: Hangyu Hua <hbh25y@gmail.com>
>>
>> commit bcd0f9335332 ("phonet: refcount leak in pep_sock_accep")
>> upstream.
>>
>> sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
>> invoked in subsequent failure branches(pep_accept_conn() != 0).
>>
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com__;!!ACWV5N9M2RV99hQ!Znc0Oy9gtZZ18UDMwcZiYrfjj4GUibhEq5WJZ44m6azDWCC1hrZpkFh9AmGOqqS94cqz-A$
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
>> ---
>>   net/phonet/pep.c | 1 +
>>   1 file changed, 1 insertion(+)
> What about releases 5.15.y, 5.10.y, 5.4.y, and 4.19.y?  Is this also
> relevant for those trees?
>
> thanks,
>
> greg k-h

It's relevant for all currently supported stable releases: 4.4.y, 4.9.y, 
4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y . I missed adding the tag "Cc: 
stable@viger.kernel.org #4.4+". Should I send the patch again?


