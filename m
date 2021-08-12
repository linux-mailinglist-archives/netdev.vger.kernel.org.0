Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C133EA87B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHLQYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:24:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4516 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232410AbhHLQYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:24:14 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CGBTUq008084;
        Thu, 12 Aug 2021 16:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IWj5Fg9fJNE8bXiShHEKE3R+aWmVSslbflkZkH4CxoY=;
 b=gMpTK1HGYhLLWkZ6bbHORudfHTlKh7zZUBtwcAauUtlaTWwNUyzyBMFXzWSFTKNc+UHf
 7/1rr4dqM5IGJal86z4eA8wopjK0NYjuAPldVTWutyouSiK85oaTwYv++Yko2z1CtkuD
 BeffMn0ZJw9b3yshJYuZQTdw0GYuRSuC8zSmh7LxH/oS3DzoOvNE1h9pgAXZixVCLETK
 CnVuRydhtFYIki6nkpAeVnEoBSPlpTY6OtjzfrRNKxzLsjTmg35RfPCYl65Jt57wTfqK
 xyM6yC/v2tNsIZXdREQlSXW/rqV96jnOPb+3l9H2NGJkYPtysEzQSFCA+qqY9O1WP8zA gQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IWj5Fg9fJNE8bXiShHEKE3R+aWmVSslbflkZkH4CxoY=;
 b=YzWrVJa4880DHryf7fGCY0x7U5Xsi382vBOn83wid7Vrf/aFovJSrZlD7Fdgkw4fHCGs
 tzbcDN0Uigk8Mxv3mHWy8Y/HuYbl7B2AQzwYpwMh+Wd351ik0DC3Wnl9IKC4M1ktCbgj
 aqDx5Kr30UZHVP/WMUedgo9LRSHbrqwr1wfRtgBy73xqdS9ghU2LSClKFasKkeLtmLbV
 rhSFFhxtxWCXyY6b+V+o5rY8fzMcRKY6meBKhLoeaYYTYQKa76QAAR1SofOiZLYZmccQ
 IyRjg6nuiskCZ/4cBqqcQ356e1fOKWUfJUVWNLgFftjG1ziDQWaGjUzWwUjqmdxF4FO9 OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad13v8wwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 16:23:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17CGASqj115380;
        Thu, 12 Aug 2021 16:23:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3aa3xxn2q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 16:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7VmgNE8IS/sV2pPbuDbwM8GUCPRiVOR8ktN923yX5//mh9baJ+mBBBt9m7JyjgYgQKHtgr0/HfCnXRXTr4vnCtJFRXE0Pii83PNlpRc5QKsMj9I3HidjBlgijSH/Fm5IrdATpqhfqgC/T5cR0PTrpp3jnRKIY7Ik1xGHqg2tF0qyN69Fi2DlhqriOS+CrDWQjwQlq9p0fIfBoZwiOXQUIo4BvwnNEXLoceDifWT1K+oaDCebIic9ayldtpr8Ch5jq9GVkMPk9cpZ1LVk++e5dnIlyf/RVCshZz/oQ6cdIt0MUdWX67xtoM7RKeWOxyTvxnHWZ7OcEMukI9StfWHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWj5Fg9fJNE8bXiShHEKE3R+aWmVSslbflkZkH4CxoY=;
 b=CW9pE2ea4rICktjFZ4g+gpu9lWRLDgt9tqp1QMfjGZ1Yq7CsxnPZtxQRyWStv0LWs+9NFNCi/SqGxyoK+iGNvjcImNmb/lTngwO4i2TJfpNXTXYyrVieci7bwx+UAaiRSLJITOd4OdkEtS2Syh75ygLT4+rB1dunI4y9iZRXRtRGo62JuA7AWbmDJpLPTIow8cUdfZWP9jfMzjkvk6zl03//fWnIWUtyfmiDJvdjtIAWtYnWXJ0xuMgk/8fWwMNlxL94dBuNxZyHemzufKJetmThH5G7OCKots1viVdPLCkUGsFo8ymTwI0idC0achRRn6yGgimSwfVKpFVknz4a5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWj5Fg9fJNE8bXiShHEKE3R+aWmVSslbflkZkH4CxoY=;
 b=tC0poihT41b3oUoJEETJfi8/Kv95eCEL2/2VfiaXP7mR3GYW0UGWrjWqbcZ08euf3IbuKM/ja3KAi0ptur9LUy+kVooq4/l8Lp/+eDtjTWLzBKoQKHYwBOYcVbpBd36LRoc/UYVyyUgW4I5r3R168bmMPt4Sd7uNOkHSapqmGEY=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none
 header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Thu, 12 Aug
 2021 16:23:37 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 16:23:37 +0000
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
 <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <faeb0704-b495-36ef-3138-6223d28d5eab@oracle.com>
Date:   Thu, 12 Aug 2021 09:23:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0701CA0001.namprd07.prod.outlook.com
 (2603:10b6:803:28::11) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::7a3] (2606:b400:8301:1010::16aa) by SN4PR0701CA0001.namprd07.prod.outlook.com (2603:10b6:803:28::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 16:23:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 634a09b1-c65e-49fa-fb8b-08d95dad89ee
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5567:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5567FA725E69E55BD53348A1EFF99@SJ0PR10MB5567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DaToa+BF96BOiu7bZV4zakSN90s0AjcsWasZb/2dAo1EvKEfKn9UIbhgaiLu+XZleB8o57CZDQjiwmBEMsqLQFE97JUCK35RyNddkzOMeeSyHgT447u6/ePVoBH71xyEk2qlWbXX3aWQMCSqZe+rvTMCQvOQ+R6+Qq+mBMiRsVafxAWJQ7N0e+XcDdf1KP3IBclDsaobV7C0JBU6p4J5fU8t1ulkQzI1AVJoVGmImXSDErZTGAa1eJRnpqh/qImg6KjcLez6NmdpT3y3QCDPzkFmF3Qy2Vne585uP77lLztTHVfF2VGdX2HY91HPe1dzjXoOp67UjKFeXrYe8UYKgbW870VfNaqGWhLyyb+ggrc8keIvgyH0VioV5m2UbnBqs2oVdJwpCSXelwfJB2hhisLxuUgFCC6kqTA5qVlwfQYzNY3whNoyyexJEHEyuOiyd/NNzi6MLe99eSMZYX5F1twBmfB9ySWKjPWt4ejB74rM1BW7q1qklGCEFR32PNbeSlojziMYIhCZ6ok66+0A1dIdTzOaRlaFnw7iCu6kmssOmYEY5o6f+2l+0A5WcY0A3x/KEs6uUGZ5DOWPbqhe+NcQ2QQjCqPai0ZgJ61R4CTOXXDwsfhDMsMNRHICLegjuZzwQcR6bNxiNZsN9So/9JKujKY8H90RfQ5xGGZxa6uWVpzCnMA21Dy/wsVAStyjQnpKP6BW8+Gz4hyIr7KiCGr19rjejfec+nb6FtdTkGM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(346002)(376002)(39860400002)(31686004)(8676002)(4326008)(66476007)(53546011)(186003)(66556008)(5660300002)(2906002)(36756003)(8936002)(2616005)(478600001)(6916009)(316002)(6486002)(31696002)(83380400001)(54906003)(86362001)(66946007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzRtNlNtNWhrVEpvaXNXcUlyWkJCSmNNQUtsZXA1b2dTWnlNY0xOeWk2OXBi?=
 =?utf-8?B?L0t0RDVRTUFTNmxZNFNnbHdHUHZYZDQvbXNRSGt6SXlVK2h6UE13MUFhcU5I?=
 =?utf-8?B?R2I1UzluVjRKRjg2Vms4ZCt3UE5IVjc5clBBdzMzUEM3TG9LSzdyK0xpRE9n?=
 =?utf-8?B?U21HK2dvL3I1L2ZZdnEvYytjdWRaQ3pjditlSEVwZjFvRU1EaHdweUVqU3J4?=
 =?utf-8?B?YzhNczBWZFJyMjdPc2FmVjcvQkoxYmdNYXpjV2JFTGhZL3MvcFNoNmlpYmNp?=
 =?utf-8?B?V2NUa3VJbjBxQ1Iza0g3ZlV4ZEhqSzZrOVZkVGNTU1F2eUxwR014ZW1wLzc5?=
 =?utf-8?B?QnY3dGZIaGhnU2ZzVzlGSVpsNkNWRVFUTS9lTzhSOUs5L1NoMUlXSzBTRk13?=
 =?utf-8?B?czlGSmQ5ODlScmFvV3B5aVFUOWJrb0dMRnJ3LzRYcDEvK0JIWEpDaTQ5MStX?=
 =?utf-8?B?clgyanNRcUs1eFJkeWtaYXVIYXYwOFB2eXNmWEZTK1huc3hoZW4rbU5sdUM4?=
 =?utf-8?B?MlpIN1Riak9ETHdIbnUza3cxZ3ZBaHJlemkxQVUzbFA3ZWVCclVSRVd3WFND?=
 =?utf-8?B?L1NTNlozSzNFVjB3VldFSXVBUk5YczVzRjgwanlYVlZrTXBnWHQ3cWhBa2xu?=
 =?utf-8?B?eERlV2NrWjVBSTNtWHczRnkraHlOTENPTmZWclBsUk5sQmxPSGQwSDFsMHdt?=
 =?utf-8?B?SFJ5UWg0bmVuNXNmVElTOXJHTEk0T1pBcEx2U1V1S0JIYXBraFh6MHZKV3ov?=
 =?utf-8?B?MG9pRUpTNngyTDd0aUZZWDNCdG91ZTVuUE5yelZ6enpXMXBRVWdlQlN6RXFh?=
 =?utf-8?B?eTZaenJoZUFhczNvSlB6SDBDRVErOHNFWEI2NTk0Vk5uVEdURWRTTWpCTElD?=
 =?utf-8?B?NkxRa29rRTJvVUJOaHBrWDhjU3JPUXRtbjc3SEhmYlNINXRQM2JDeVUwNDhP?=
 =?utf-8?B?eUc0RDcxTUo1Z1R0TzFtQVlGZnoxVzdYYXl1bmZzVFpic0I4WTEwN1hhaHR2?=
 =?utf-8?B?YldHRVF6QnFVU0QyUkIzZk85cWVYSjBoSFIxdWhOazdVL3JMbXMweHVXYm15?=
 =?utf-8?B?Q1pMY2hWbTdPOUQwc1BDM3RPQk53NjQvMlROdlFpV055UHNPQWc5Zjh3M0tu?=
 =?utf-8?B?enFGRmR0Y0tMZHVqeUhRWDZob1drZWk0YVJmOFVPSXl6RzBCSVRvb3RtaTRX?=
 =?utf-8?B?UDdjTHE1RGY1UnRkWC82MCtFa1BqOWNQQWc5U1hSbE5GU1RqbTJGVlpRRlg4?=
 =?utf-8?B?ZjhzLzRiSHkwUC82UUQwbGJkR1lpYnQrM0hoSVZraHZXZWttN2ZvYzFJcjVm?=
 =?utf-8?B?SlhnNmdFSHhkSDNzeTZ5OXVOZ2pXZTJOVXlRODQzemNUdzF4VWlzRlpvQkt3?=
 =?utf-8?B?eG1TdzQ4WnBPZXl4cENYZmwwdGxwVlUzYzB3QTdOY1dpbGdFOGE2b09vblgr?=
 =?utf-8?B?NnpyS040L3lvVmt0c0JoZkdCVE5SNEl2eVMzWTdWZ1dPaDVKWTBhaDVVTzZW?=
 =?utf-8?B?WkdiOEZVeEVoMG4wOURzaXhCYTM5cENzdWFzUnVyai9yc0FFMFhHK3RTU0lk?=
 =?utf-8?B?eUtQZjdHWDhQcEFUR1JaUzBDYk9nWjNXTjQ2azJqWW12d1JIZmZ0Zk1YWENB?=
 =?utf-8?B?MGV4SDdaVHdnVXBhOEx4OG1YTnhRQmtQMmNPREQxRzV5ZmFrdmZLSDFKZjBG?=
 =?utf-8?B?Y0hMTFlTTUZuKy9SRDdxdnlYUU1wU2wwVGdEci9mZTNmNm9od0xBaDBERC8v?=
 =?utf-8?B?VHZhcnJTNzRUOXRuMmNwcm5vTnBDU2JjSGpDY2J5dWZJYTNLeWhGeUluN1or?=
 =?utf-8?Q?rRTR9jiNk3mbl3DpMyTLF7vHNGbu0+8AkWu0k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634a09b1-c65e-49fa-fb8b-08d95dad89ee
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 16:23:37.5786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhfggkN1mc8vgB+YaDRgJsU8Vz0rwZcwdUKvZw2Y3WERakZDFPYtvlzuVZRo7MMf12Ulpf71RxDpqBf22mQIDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120105
X-Proofpoint-ORIG-GUID: 5LiZuYjVvgrByaulg18Evl_IfnAFiNFl
X-Proofpoint-GUID: 5LiZuYjVvgrByaulg18Evl_IfnAFiNFl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for your review I will take care of the comments.

Shoaib

On 8/12/21 12:53 AM, Eric Dumazet wrote:
> On Thu, Aug 12, 2021 at 12:07 AM Rao Shoaib <Rao.Shoaib@oracle.com> wrote:
>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>
>> syzkaller found that OOB code was holding spinlock
>> while calling a function in which it could sleep.
>>
>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>>
>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>
>> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
>> ---
> Please do not add these empty lines.
>
> Fixes: ...
> Reported-by: ...
> Signed-off-by: ...
> Also you might take a look at queue_oob()
>
> 1)  Setting skb->len tp 1 should not be needed, skb_put() already does that
> 2) After unix_state_lock(other); we probably need to check status of
> the other socket.
> 3) Some skb_free() calls should have been consume_skb()
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index ec02e70a549b42f6c102253508c48426a13f7bc4..0c27e2976f9d234ca3bb131731375bc51a056846
> 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1908,7 +1908,6 @@ static int queue_oob(struct socket *sock, struct
> msghdr *msg, struct sock *other
>                  return err;
>
>          skb_put(skb, 1);
> -       skb->len = 1;
>          err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
>
>          if (err) {
> @@ -1917,11 +1916,17 @@ static int queue_oob(struct socket *sock,
> struct msghdr *msg, struct sock *other
>          }
>
>          unix_state_lock(other);
> +       if (sock_flag(other, SOCK_DEAD) ||
> +           (other->sk_shutdown & RCV_SHUTDOWN)) {
> +               unix_state_unlock(other);
> +               kfree_skb(skb);
> +               return -EPIPE;
> +       }
>          maybe_add_creds(skb, sock, other);
>          skb_get(skb);
>
>          if (ousk->oob_skb)
> -               kfree_skb(ousk->oob_skb);
> +               consume_skb(ousk->oob_skb);
>
>          ousk->oob_skb = skb;
