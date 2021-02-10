Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932A3315F37
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 07:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhBJGA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 01:00:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhBJGA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 01:00:26 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A5xfIf030442;
        Tue, 9 Feb 2021 22:00:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nFWFNp2+QMBgClT821wqSjqxFn3zBhUtEsUTkE1x57c=;
 b=WxncM+w2cQlmRjFYEGBCilV5D3Fx7A9zPFOuzqxkWZ694tAgGHlDadn+G9haWY/sxdE1
 lw4DXpRZ88IBDfkUOC/7Uwq0l8mKg9mRepWdCLt7UUbEPgblIHXSzdVKRplY5m8eUgRx
 3a+KcRlQDYwNWgaRMC+h8Ii1M8nn1S1loLM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36jc1uqtq2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Feb 2021 22:00:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 22:00:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRuDpDq7WscqobbInnM9m8IRBPqmwxiypjflhzx58aJgfIqs84rAdZPRAEqPNOHL33Ufjb6osC07B+yGZqCYojAheN9KNOt2YmIo8FifrSf120yWOSA2V6tGxD1jqng/0+XJpEAHJn+XOVHrI9TVw5rAZ+SDTiWC2W1n86S9aZiBBJo4SrikwhBCDxro/l/f6WJcNl6CCZFssANueRaQ+vZus0vsanFeeTkbhm+bYw5vsmlldeRoXkN/4kQKJw3dMgrAcE51izMel1jZjtQRwnqQF1YTTvHCAb8Oy+/Hi+vjGZZF1SbCoWvzzjjP068UzVysYlyAsJvQ5Jsu0p+F+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPdBySH6IPKKLeGlGmTXShVuMnCHnkfEAWsWkdnXND0=;
 b=S/T3iFGcMsdySV8b9FulZIpcFAE9Y3QCofEFYMzp/liAZuh65kOYtA8+HDD5qskKeRDLXbsyrx2MhbYzJgJP3sFwoNPKC6rxA+fE2GoJxcDtiMmaqGZWCFcrE2zdMS2Sj2VP0BDYx4b90Pm4Ap4SqNFeaVJ6KhJg72MnIZgCbG9Me+WOcKYeppgMs/tCu32DR2J6YGMACilvUGR45An0PrjctQbpJyVkYNWuWCCaoS5FbjrRkzUGBQMo1c+TbcZzp1c1Kn1mgsBZeoawAFOWNW6iaQFxeGrnV9+XJXAP12AcezIIq16dmJyizygxsBclo1JFTDsi0DBQH3ltDv+qOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPdBySH6IPKKLeGlGmTXShVuMnCHnkfEAWsWkdnXND0=;
 b=jKZ6QGij86UtloGu1XgO+6pSY6WMfElSKVu9Eg43Y2Y0UCTdleU7V8aD77bnUXF7XgzdTpFGa1e1BJYPZdo4DUhCGn/90jPZ4TELXROOICFuxJsIGbljVowTLnMEdKIvxw8DULyjTNLaFNBVwxVWRjvvNQsVHsUABaYi2Pcktdo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Wed, 10 Feb
 2021 06:00:03 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 06:00:03 +0000
Date:   Tue, 9 Feb 2021 21:59:55 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Marco Elver <elver@google.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kasan-dev@googlegroups.com>, <paulmck@kernel.org>,
        <dvyukov@google.com>,
        <syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com>,
        <syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com>
Subject: Re: [PATCH] bpf_lru_list: Read double-checked variable once without
 lock
Message-ID: <20210210055937.4c2gfs5utfeytoeg@kafai-mbp.dhcp.thefacebook.com>
References: <20210209112701.3341724-1-elver@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209112701.3341724-1-elver@google.com>
X-Originating-IP: [2620:10d:c090:400::5:2a38]
X-ClientProxiedBy: MW4PR04CA0428.namprd04.prod.outlook.com
 (2603:10b6:303:8b::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2a38) by MW4PR04CA0428.namprd04.prod.outlook.com (2603:10b6:303:8b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 06:00:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd2f31ff-0b39-46de-4a7f-08d8cd891b6d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB325633FA99D7AE8EF6EA3F10D58D9@BYAPR15MB3256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xBA4ykiZO/kfCPWcKxW8ldz52ODmKjpInY8XPLCFzL1/chpCVArFxIdfo6XoFElwuB1X8ZvTCerhZaCrhka2S0swIint69R/+qQemV1++Sz25YTa/fV00fd+iwmhtcigjrv1+hk3Jj9GJ76fe+RNeUlbZfpUBQvu64A48vQ+iFsnEh/f1eK2hoOdqLsGo/eS6VDYe2Gzh9OmsALIDHSHMaIEQd2ktCI6sfqTLjsW+s0Utc09ytnRBwwLthEg9oxIf3/t326nsEbLXnaY1TZjDL7AtZwYxhjSBrx1092SpBd9L/PFe3VXJa69zkHCh7a4QJ1kn4J2WqwCIgnxHVb9Q6N/h5Anhv0lFRHDIOARcCJ+2NWlqNW0zw6i3MikeAnJdHgcjBpW3OejXoq/KIMVWo7cR/DqUJSPQgMmsh9m50ldt9jqFCvcK/RJGv4wDnBjSwhxoPlkoA2UHcP8XuafTz7nLEpLGpBXQJ7femTEGEkszuQM6gYEKQyKOZIJ4N8kEfVGOb6kbceiLRS5jZmLhOIBY/7CLDsZw3iVTgyD6fC7d+3OTfdGUqDKUttLYJr2yIVroEDChHk28wByO2a/A5skk7nJIIAsFUqAgDcW+6k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(39860400002)(136003)(316002)(966005)(6666004)(86362001)(2906002)(8676002)(52116002)(83380400001)(4326008)(478600001)(7416002)(9686003)(6506007)(186003)(8936002)(7696005)(1076003)(16526019)(66476007)(66556008)(66946007)(6916009)(55016002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ay12w9z6tqxDyB4Lh7E/CWY5K8D3KwiD9SOQu3V+TmaVtJRRFFhaVkb8LN5x?=
 =?us-ascii?Q?BPdNOH/NhOlSLkawX7vgR4D8aSlzKDAGA2tOnClqVcqK5zpQWllpl/5qGoFt?=
 =?us-ascii?Q?eoiOhulAmnETlJTsxk8gUGsoxStK1QZEigUTZF5fTpO3grPhN3Mp5+MdCXwM?=
 =?us-ascii?Q?1puf6G4ttdLJ62+4hy3BxP6fYsFEMQZMlYJRV/V52YLa6u4RkMsrRwoaGUsM?=
 =?us-ascii?Q?3jVSx30+4jX1IrcRKUNrwqDYpZl93ElI8w5tqoV7oyaCATQL1xi1ms+/EMRi?=
 =?us-ascii?Q?K92WPAe0J2zUYZL8Fq4G7rxznzVhBju+jZwL586wYBp3lqRgiET76AYuzFCW?=
 =?us-ascii?Q?/5hDr+9ikmTcZJ9kZktL0lgU43dRwunPtrPaUjFltiw2sN2+WXsXlLmpn4PP?=
 =?us-ascii?Q?yG/LO3X+6DiayqAhqH0UdL+dF0iQYlNFUFfpRTEetO+ghj2ic3f1R5KnExTR?=
 =?us-ascii?Q?KQA5LbJOxXhBjeKrUGL9CFLGN9j6s/PnIqy/XzwFu0NiCs3Oa9LePVs1u22l?=
 =?us-ascii?Q?app5l+JEBIi78Zh2ZBT+GiiqfrXvIm3joP0C4oe4iX0v0YflYmrfLxBu0IoM?=
 =?us-ascii?Q?7XTksZ6II0Mf+LhS6vrl5HZDkYKw1QDoIWBTEfHXnTeAalWlYiROmLhYZn6r?=
 =?us-ascii?Q?0NBxrtf6za6Seol8bw3HRqKBzW2n4LqByvkTPhJI3Sz4q0VxbWX366Ky5Fs/?=
 =?us-ascii?Q?0PCnM3TXbyon0w9+SKXrr9YVgLkwwUlbGxmW6toP1y2/AJeSt1PcY7vs7rDj?=
 =?us-ascii?Q?3qpotjWUN3oC2Bx7LedCzLo7Z57s3IYsoYJi8wZPCg6S2gFGr/fFmTmtKUM/?=
 =?us-ascii?Q?jSOP4MtoKbR5XiKk2Z8AYdMufzXDaafxZhZfYYsCXfgLJQcm9d/wJ9hxLtas?=
 =?us-ascii?Q?2HZ2BG1wEG7sCCVEiBch18r+okG6wU0tTlFUx9H04yJ/B0BVEc1lxnCH+Jxq?=
 =?us-ascii?Q?7l3QvmpgyuCeHmjtORUhK7joErf1IUPttBDwqmTwfiFhLbTa5U77QWeSupug?=
 =?us-ascii?Q?CEUb0shOQGeJ5UxbyD3GSwjoNLcAe4QUEfT0vv2OORMQWeUskmXtw4DiOxU0?=
 =?us-ascii?Q?L9oP7FWc/gqSrKkDs/UltNfaL9OSZxB5ibEUebGyubx/C2ft8XGp9XxH8EqY?=
 =?us-ascii?Q?GhndIR0u9PXeCWAbHqzKz+MlbsYD7tRmOY3PTLA0/mFNpGFS21+HmYVpvorc?=
 =?us-ascii?Q?n+M/UTuXUfCUYIz62U49srUaxNinK4dikoxZLZPqz0XLfCZxne55KTahM1e8?=
 =?us-ascii?Q?fuDOxrssffGGTmixTAv+b9V9ygvFkdWeW9+9FXSJF8SRPANR0+WOeLbw9KG/?=
 =?us-ascii?Q?pJQWS8KCa603SgMBDGQITPqdsAvhspJvvxCFFBbCGXpeuA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2f31ff-0b39-46de-4a7f-08d8cd891b6d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 06:00:03.2603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrXSgPfI46OGAUZ1jHsekihzz+YDhjUaKzLDGcrVvMOYnpHCERtBIUunKl3rStVg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_01:2021-02-09,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1011 mlxlogscore=979
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100061
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 12:27:01PM +0100, Marco Elver wrote:
> For double-checked locking in bpf_common_lru_push_free(), node->type is
> read outside the critical section and then re-checked under the lock.
> However, concurrent writes to node->type result in data races.
> 
> For example, the following concurrent access was observed by KCSAN:
> 
>   write to 0xffff88801521bc22 of 1 bytes by task 10038 on cpu 1:
>    __bpf_lru_node_move_in        kernel/bpf/bpf_lru_list.c:91
>    __local_list_flush            kernel/bpf/bpf_lru_list.c:298
>    ...
>   read to 0xffff88801521bc22 of 1 bytes by task 10043 on cpu 0:
>    bpf_common_lru_push_free      kernel/bpf/bpf_lru_list.c:507
>    bpf_lru_push_free             kernel/bpf/bpf_lru_list.c:555
>    ...
> 
> Fix the data races where node->type is read outside the critical section
> (for double-checked locking) by marking the access with READ_ONCE() as
> well as ensuring the variable is only accessed once.
> 
> Reported-by: syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com
> Reported-by: syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com
> Signed-off-by: Marco Elver <elver@google.com>
> ---
> Detailed reports:
> 	https://groups.google.com/g/syzkaller-upstream-moderation/c/PwsoQ7bfi8k/m/NH9Ni2WxAQAJ 
> 	https://groups.google.com/g/syzkaller-upstream-moderation/c/-fXQO9ehxSM/m/RmQEcI2oAQAJ 
> ---
>  kernel/bpf/bpf_lru_list.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> index 1b6b9349cb85..d99e89f113c4 100644
> --- a/kernel/bpf/bpf_lru_list.c
> +++ b/kernel/bpf/bpf_lru_list.c
> @@ -502,13 +502,14 @@ struct bpf_lru_node *bpf_lru_pop_free(struct bpf_lru *lru, u32 hash)
>  static void bpf_common_lru_push_free(struct bpf_lru *lru,
>  				     struct bpf_lru_node *node)
>  {
> +	u8 node_type = READ_ONCE(node->type);
>  	unsigned long flags;
>  
> -	if (WARN_ON_ONCE(node->type == BPF_LRU_LIST_T_FREE) ||
> -	    WARN_ON_ONCE(node->type == BPF_LRU_LOCAL_LIST_T_FREE))
> +	if (WARN_ON_ONCE(node_type == BPF_LRU_LIST_T_FREE) ||
> +	    WARN_ON_ONCE(node_type == BPF_LRU_LOCAL_LIST_T_FREE))
>  		return;
>  
> -	if (node->type == BPF_LRU_LOCAL_LIST_T_PENDING) {
> +	if (node_type == BPF_LRU_LOCAL_LIST_T_PENDING) {
I think this can be bpf-next.

Acked-by: Martin KaFai Lau <kafai@fb.com>
