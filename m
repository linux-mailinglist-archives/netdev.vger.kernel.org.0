Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F4A3CD71F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbhGSOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:06:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31898 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240298AbhGSOGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 10:06:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16JEbufN004923;
        Mon, 19 Jul 2021 07:47:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XaW9Fapwa1zpzRUJO4e7HhFn7daxgytSZiVnCi/wmKY=;
 b=ezM0dsu0YRKUOUuMsK/WTI+wKemXh7UChhF6O3slr7CAJugiSF1+Eecz9WyQBablU6IL
 5eL6h4H1BgtxNS414E89iF1Yk9f1zfwuijqyBb/QnO8CPLFS9NgFPzYiDGMpXiTWBgkt
 iBRXEeYZzQ+bS6WnQ0KyRD4aPlUi72arFSs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 39w004k4cm-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Jul 2021 07:47:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 07:47:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjVjx9OKJCdACg/Ese1HlsTuF9ZnpplBAZyMRxiobMxP1iGHQx5mpIion+yLxtUws59LNLhsrLzCvbaDst/3arauw6trqRTHWf92JWwP1S/bDD2+ib/ogd5F3XBBtq4Zs7zlXYyrDoesu3x04ftI0lat8dGjG6DgLbGDgUfpePrd55/qvbGKOTCqwbNS4VdSQYTe71vSHozo6D4arV8LoniG3v8DiklCEBFIFyVn0C7e0QKVFnPMMVGYFXPODzdapEgkrMz4e0IhrJe5AYbbGFih8Z92/pRn7msYxqZYIapvQm2Ince9fbt8QvgnKB/lC7EW0RElOgQom1hjfHmXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaW9Fapwa1zpzRUJO4e7HhFn7daxgytSZiVnCi/wmKY=;
 b=fxILeZIJzrZXp9M1IDGC7eT7ezkTW6tr3qH/QVSqWNliNInApfXMsSX3VHUin3R3Y4EEV2kngk+uHTUM6PvgnqBt7MMeBfI5r6R6UP8aJ6FNfJ/fH4aJcA4W8YD0cZGXtdhfIINBD++sbm46PkRRlC71F65dPaIm6vPQ9PgRKgz0D+6A0IyOm6uDLc+y7I8lhTLKJgAmRxqU96A5t4RsRPPgXxZah4cESoOHDE3o5gPSpt6Vbj/0BvbFo50+x90ceSJmrrHsveQhuVcvMbBI+fmcTIkb5LCvZDr0cw+trZyL1IH5jijrDiFqoG49rqPwmmCa8dWOZDeBElILAb9wuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5030.namprd15.prod.outlook.com (2603:10b6:806:1d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Mon, 19 Jul
 2021 14:47:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 14:47:18 +0000
Subject: Re: [PATCH] netlink: Deal with ESRCH error in nlmsg_notify()
To:     Yajun Deng <yajun.deng@linux.dev>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210719051816.11762-1-yajun.deng@linux.dev>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0ada4233-6c9d-82f5-f33f-55805bfbe37d@fb.com>
Date:   Mon, 19 Jul 2021 07:47:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210719051816.11762-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1290] (2620:10d:c090:400::5:17d7) by BYAPR08CA0019.namprd08.prod.outlook.com (2603:10b6:a03:100::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 14:47:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0099ada-28c9-4441-c44b-08d94ac41b57
X-MS-TrafficTypeDiagnostic: SA1PR15MB5030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB50300FA3B9B409097B560CFED3E19@SA1PR15MB5030.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1rBdfyJpsNfR4GDFj40FXMa+jmh2Bk/6U6H344Grm3d3AkZs/JVP11snZyBadhHWjQHZ4/DQLlUznHn+Oi3TlSHYPwrTp8epLtWCwZzmaGbFc/IOnU0D0hNRRQMOBBKQmeXEhHdXTu1PV+jixlCLd0lkHzHvBGyO/x1cv4sOQ1qC7j2JLCzHNrFFdGxcTP8vCLrciN4vQSiBaq1PApqE2Z6FymrJRaYLeGuTaUlSvGwz7jAcvTnBBdRpSnQHfyq4MLyN3ZjSisAyxtzABXlkpo8siVKCR9lIZnO5dYm30Lxz3ryXTeXet/uxshh56F9q4X3z2qeX/sCCstCFfkTtv0OOUlzLWBa+QJ+SfIYtyGApCgCOQlZQhmsyi+yUL56qUnN4GPUpTqJ1KSrpnnWds+8qx9ya89rLRgjDaJyht6sjnH2BO1Y5ZDau49JZgbiJFyMMoVdAp64OAUW9MoIHe6vQJD38NQUtKv/Llj9VQ27zMXwtQiRqBvUxBzfore50riprd+oUKeWToJiu8RJj7PW3zEEJ+KADJMWCRB3Z8xmqCU1/mjFN2IQyZyKTFdOqg9c9vuKpTNuGhJPYAlkIdMKMja4iZiRmALzomWne3ztl9eje2JYpXnn4iA7XpDImgISIeMvBfnt+3qgTO77cyH6r6LACLiUCFwBpu5hqff6Lep/gj/3H3W8jOtgpI08ZVKYnvaX6o622oDq+EkJVyX5Y4cEdGx3uPljkkU0jq20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(31696002)(83380400001)(86362001)(8676002)(5660300002)(6486002)(478600001)(38100700002)(53546011)(2906002)(31686004)(36756003)(8936002)(316002)(66946007)(52116002)(2616005)(4326008)(186003)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cytxQ2N3eU1BYzRzRm0rUDlSZmM2K3lLeWppWW9IZk00cnc4UGlOVDdyNlVh?=
 =?utf-8?B?dFBoMkxQeVlJanUvMEtUM2Fxbnp6MmJib2ZUQVBSc212anJHWDFKek93UTFK?=
 =?utf-8?B?UGtJVXozMTNybEV2clpXZldyUzNQMVZsMjEzdXU5NzJnQzhJZ01hWmhwVStZ?=
 =?utf-8?B?OCtTdG9VSmVwUXBMUHJNdVg0YitrTDJ5OFI4R3JWVjl6bXFwSnZBZFJpeTBo?=
 =?utf-8?B?Q2NtWTdUcW1VVGRQbDFFc1pRaHd0aTErZGY5TzRzMWt0d1h6ZzhvN3pLb0x4?=
 =?utf-8?B?Z0R3RmZyNTh5eGt0N2pFdlBFVng4USsxaUlwQ0ZQek01MWtFNFRISmxVYk93?=
 =?utf-8?B?NWNTRmt2QXc4S2w4OHhFTm9ZWFp1K0RLTm50WmVXOVdVWUxmZWNjS1U3OEU1?=
 =?utf-8?B?ZlBPZFAyRjZaeFZpK3BtVHMwMmxKZ1VOMFZvdVE2SmZMUnc3UjlUN2FDUC8w?=
 =?utf-8?B?OHpmQlZIL0NqUmJLQU92TkZZc244V0NMN1ZKeFJVSXpkdmdNSmdQa3JnWnps?=
 =?utf-8?B?ZTRJU1lZYjBnUDRKWDhaWTY5ZWNyaStKZVVSZFRZM0U2cTFCby8wOFAzZmlE?=
 =?utf-8?B?RkpTTnBDTkQzNHFjS1pvaTREcUJEQW03QTMwajlOb2txb0JremIrWmw2V1Y3?=
 =?utf-8?B?Ulh2VlFuMFc3QUFMKzFQUmFCUEk5QnBrdGhGeDg1S0IvRStVdDF5YXppZXY5?=
 =?utf-8?B?Mjc1UndobWZLVU5RWG52L2FZMjMwelBwY0ZpM3NWSGFNNlBsU25kM1FuclpD?=
 =?utf-8?B?azZBWVlOSU1VOG9CNFdsRXY0djBuRCtsZWdhUlp6bFpTWHVubURGalZkeDFJ?=
 =?utf-8?B?eFc5OFFqYVFFdWd4Z0tQcVFFdDhONU5xa1hZRXFYU2dHUGhobTRSUUZQK0JD?=
 =?utf-8?B?L0RodHQzVWhsRUdsZHNXM1lPbk0wMUxUVVh6bDdzOVJnR2JET0lOZ1dsZElF?=
 =?utf-8?B?U2VCZWRDNUgrWVltUjVZVE1EWXJpOHFJK2g4ay9Ud1ZZM1hGc2pCQitQZVYy?=
 =?utf-8?B?TmNyKytIRHpPcU1nRVU2NUluOGRMNWhaTVUvaW81dXhuc01RNjBaK1pVcjVx?=
 =?utf-8?B?UFN5MXNLVWZlR09PbnpuNDRpQTA5aWRONldVNkVTYTNkbmlxb0t3L2JhT0c4?=
 =?utf-8?B?SWo2aHptcU5pbW9yN3lGdkxtR1lTT3h1NlhkWVFXcW9IYVlGL29panF3cjIr?=
 =?utf-8?B?Zm95bW5Mc2NhNkpVcG1qK1FKMXR4NFByaGZWN3BKRTZWZ1pISGNQSEJmYk9C?=
 =?utf-8?B?UVFiZ1V1YUQzQjZpTXYyMmh3RVVaTU9iT05BTURwYUlMVE5PZTBPcUMzUmJp?=
 =?utf-8?B?clVuMytHMG5FWGR3U3Jwd0ZXUGNseUFQQmN0enphYkZPN0ZNQU9pZDArZi80?=
 =?utf-8?B?eXo1RCs5ZkNaVEJtUjlJSlpUMEc2SjRUa0RzbnhwTjZONkVGcndyT1JoS2k4?=
 =?utf-8?B?UmNrdm5PM1dlSUdQQkRSMFFWVDM2RUh1dUVNMmZTQkovNjZkaC8zZC9KcHQ3?=
 =?utf-8?B?b1BjYW9VYk9DM05jQTV3VVBNNDIwV3V6NVg0VTZ6dWVNcldjQlV2akhKWTdH?=
 =?utf-8?B?VkNKU3gxS1krV1J3R211ZW12VVg3K1JIYnFUT0hCUThTMWhCWDBVaVE2aTg0?=
 =?utf-8?B?ZXlueXp5VmlJbkNUaHFJcDhUSHVpNFUzUDFpekczMk5nU1NYVXZ2N1J1Q0Jo?=
 =?utf-8?B?L1BvYjhuS1ZVSHRVamRMeFRYNTdyZkZHOGwzeHFWcFZxQks5Um9YdnN2R3VO?=
 =?utf-8?B?a1AxeU5mRFR1MjlnVzlhbFhneGJvK2ZJa2g4VTlMZ0hGMisrN3hYaGJHcmVp?=
 =?utf-8?B?d2xybGl0YVpRaWtLNlBXUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0099ada-28c9-4441-c44b-08d94ac41b57
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 14:47:18.3887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1x864E13b6LgILoMaqq5aELfpzPuHH3wkh25N9NQ9U5vPmEfegjRfVYZY7giaAvN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5030
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 4JJa0k4opJ_aDoEc4y6eqi6qCuhf_oiN
X-Proofpoint-GUID: 4JJa0k4opJ_aDoEc4y6eqi6qCuhf_oiN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_05:2021-07-19,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190085
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/21 10:18 PM, Yajun Deng wrote:
> Yonghong Song report:
> The bpf selftest tc_bpf failed with latest bpf-next.
> The following is the command to run and the result:
> $ ./test_progs -n 132
> [   40.947571] bpf_testmod: loading out-of-tree module taints kernel.
> test_tc_bpf:PASS:test_tc_bpf__open_and_load 0 nsec
> test_tc_bpf:PASS:bpf_tc_hook_create(BPF_TC_INGRESS) 0 nsec
> test_tc_bpf:PASS:bpf_tc_hook_create invalid hook.attach_point 0 nsec
> test_tc_bpf_basic:PASS:bpf_obj_get_info_by_fd 0 nsec
> test_tc_bpf_basic:PASS:bpf_tc_attach 0 nsec
> test_tc_bpf_basic:PASS:handle set 0 nsec
> test_tc_bpf_basic:PASS:priority set 0 nsec
> test_tc_bpf_basic:PASS:prog_id set 0 nsec
> test_tc_bpf_basic:PASS:bpf_tc_attach replace mode 0 nsec
> test_tc_bpf_basic:PASS:bpf_tc_query 0 nsec
> test_tc_bpf_basic:PASS:handle set 0 nsec
> test_tc_bpf_basic:PASS:priority set 0 nsec
> test_tc_bpf_basic:PASS:prog_id set 0 nsec
> libbpf: Kernel error message: Failed to send filter delete notification
> test_tc_bpf_basic:FAIL:bpf_tc_detach unexpected error: -3 (errno 3)
> test_tc_bpf:FAIL:test_tc_internal ingress unexpected error: -3 (errno 3)
> 
> The failure seems due to the commit
>      cfdf0d9ae75b ("rtnetlink: use nlmsg_notify() in rtnetlink_send()")
> 
> Deal with ESRCH error in nlmsg_notify() even the report variable is zero.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

Thanks for quick fix. This does fix the bpf selftest issu.
But does this change have negative impacts  on other
nlmsg_notify() callers, below 1-3 items?

0 net/core/rtnetlink.c      rtnetlink_send  714 return 
nlmsg_notify(rtnl, skb, pid, group, echo, GFP_KERNEL);

1 net/core/rtnetlink.c      rtnl_notify     734 nlmsg_notify(rtnl, skb, 
pid, group, report, flags);

2 net/netfilter/nfnetlink.c nfnetlink_send  176 return 
nlmsg_notify(nfnlnet->nfnl, skb, portid, group, echo, flags);

3 net/netlink/genetlink.c   genl_notify    1506 nlmsg_notify(sk, skb, 
info->snd_portid, group, report, flags);

> ---
>   net/netlink/af_netlink.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 380f95aacdec..24b7cf447bc5 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2545,13 +2545,15 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
>   		/* errors reported via destination sk->sk_err, but propagate
>   		 * delivery errors if NETLINK_BROADCAST_ERROR flag is set */
>   		err = nlmsg_multicast(sk, skb, exclude_portid, group, flags);
> +		if (err == -ESRCH)
> +			err = 0;
>   	}
>   
>   	if (report) {
>   		int err2;
>   
>   		err2 = nlmsg_unicast(sk, skb, portid);
> -		if (!err || err == -ESRCH)
> +		if (!err)
>   			err = err2;
>   	}
>   
> 
