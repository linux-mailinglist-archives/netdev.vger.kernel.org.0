Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441F51D7038
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 07:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgERFOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 01:14:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34246 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726040AbgERFOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 01:14:55 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04I5DTP8012320;
        Sun, 17 May 2020 22:14:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RnC/deM9CCs4cLlaDBrX0nGz+HalYpnUCUvwwdowN1A=;
 b=WbzwRs8rIeA5n4Vm+0oYY6QJxcsd6G9RanSQxuMuppZc9qth9FeKzuGs/IfRj8E1ZQ+K
 M0A/+HHoqHqcsJ8xnkGZb1MQhMIDOdQsDnZFcbC6RAD3hDRQ94XymJVkfq0ZI4qENjmU
 AgD4d2dJmZs47RmVoCtQ2ScQ/oYlJBU1xoI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31305rg2gn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 17 May 2020 22:14:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 17 May 2020 22:14:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqn31GSYyLOPx+evijDVGE6Z2XrS2GgOTHuKd+p+QAwcMAoe/8+UQG8XQVHs9CLm1jkZNbVKiMy9EnFvrjQsZsfdcrVhamyu9OLvwXb4U4ug62Kf7Jw8akeMuzvPNZLIBZnKMbfmp8f1cOefzjtuQLUn6dNAkroQuoBT/riZ9TXO3q4QAYRKRywwZcIGH/499O7ZbApuQhOBh/1YFkzD2oyBA1Z3ZXHO5ICflj0/1G2xDS6HJtIYFEGI2raYHucZVuQGECi586JESX+rLZyO8fWRWlfTG0SJxTCUex3jTTRkGihBpDb8iPHjNQvOjU1f985fJp9h5xnOeoXN26NSUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnC/deM9CCs4cLlaDBrX0nGz+HalYpnUCUvwwdowN1A=;
 b=oKFycMFtgwVej2dS+gAG6bWTgQV2ISlqawtF9PcdB8FoClJKkfGuHHstBG0ous1KZ79zT5ywlpIblKh1tBSogf8yHSUSXScsURYGvxRdHneCV2MEar54C5eI2TGm4TH8CElwK0dQsTvC9pYDYyXO31DpHfLBDYfhpuuyDhRTbn0MpmKYGh4+/PkyfBetz54PgGq3Y8fHdw8sF+YTie4gln7Ve+F2kc6QtYs9xTLzhEfBgmHOxePXjFI66WU9B94PMbyznwPcxYEwL8b4vXLHtuH1cvL1Op77O6klVMXXokmnFLW5JMu+HUGousc5m63vS6n81nadGDTNPDMWnlVxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnC/deM9CCs4cLlaDBrX0nGz+HalYpnUCUvwwdowN1A=;
 b=d/MdnoeoabZNKh3z/t9vHfu4ZwckWXh8UZDc1zYTwoghxM0kp54/hnKLyhdiozjEvv8beCI10TjDhTy6Mh0+puWMdavA18I2++2lVdAHmySE6zhtEkdyeSUP0kXIZn1duW0cUyRvu+O4Oo1bktS2ZowzRHHptg0smUqQGnTzC5I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Mon, 18 May
 2020 05:13:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 05:13:54 +0000
Subject: Re: [bpf-next PATCH v2 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
 <158958037715.12532.12473092995203096801.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4a309ec7-4885-5634-4b2e-3c775890c7d7@fb.com>
Date:   Sun, 17 May 2020 22:13:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158958037715.12532.12473092995203096801.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:39c9) by BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 05:13:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:39c9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ba20435-3468-4563-f8c1-08d7faea424b
X-MS-TrafficTypeDiagnostic: BYAPR15MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR15MB40861F66E8A1B71ABD0C15D6D3B80@BYAPR15MB4086.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8zp+iomLx6VqtgDgSTyMGOLYYFJB7Ln7FQdIEc0xHgwAdmzX9md1P0Mu+vuOlT4XxDFyGL9SiwURhBMlvBXqoV9UcSwkcZ4U5k/xLGfdakwsruvLV0Q8Z7+UeBTSnYBh/H43/y+v0GHlK4Y6abUky3QLXeM6LuIhWKqVpY/XYM693jBpc80gFvTyp34a1OgGtQjDQ5VzKKx3Cu6HeRirqGtS1ogh9NXLzu/RQfbAL32VSis/KAQJhmNseje54J/BzB/0r9KvFmBhkAL0kIom4aabjpFnQVNL50cryd6h6XKp7aUKgueMRqGubnDt3L+nsxZFK0YG0f6G/l/lNTpgos8viaY6jZGiJ526ZafMbblBVk6+P0+DRlBB/pOSeP5WOh8XVoo1FXt26FqendrhH/POwSsBAeRcByYXnOyroDS8qbfrAcic7lLjFTgs8NN3OqEbtpLNIQk9aNPRhDEPjtNyl/Z6eckOSPPIrqN5cCaRReXobl1orv9mmyfAdou
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(2616005)(6486002)(66476007)(66556008)(5660300002)(31686004)(8936002)(66946007)(6506007)(16526019)(316002)(186003)(478600001)(4744005)(8676002)(36756003)(6512007)(86362001)(4326008)(53546011)(2906002)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kT2QWDkmB5FsQ20XQXChQ2fGvmeAeGxQ8TKD1AUo4ZNObakFNy1z2S6CWT5LngudP+kwmRgp6l/iYky6FdGkIPpY6ZgLgj93eTJW91oDLiASWPwpz3ineuE9DEUQAKkTCaZe9KRb4vSeT+wZ4bH8FUKGAITGsZuMmvWHBxOSwtd05B2WVWjJQnUPQqOUeV05+Nff49l+1yTLrqHIMatgtHZ8C4Buh83CMSwnLkoJPfsFPlaZQ73clgxmdVtcs2r56ozT9Dc85Z+HpgnNXLn69tbsaDPwuRqulMrGXr5CjvSnEH3aPXfujX10oTsa+JQbQowT3qR97d7r8KFHjxvT7GR9bc4KFIZCFpCDfNI2CUFolzxMoqcXamV38c82soW7F13hLjn/xevo1GcseIDfFjwJCakQeij/eSJNt4R9RSWxoYzM8BN9ECgZt/3/LLj47QE+nJ3kfZ9UfhU2kXL6Op9xvU/ll5o+qLiRJDDiwR+qSkaK5xkJesenq8VpuWfsG13Lw8OiEM69m5hmBDUKQQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba20435-3468-4563-f8c1-08d7faea424b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 05:13:54.0309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9AYOIfHlgCapq0laZ46OaFaq98BUZfRMSnf2N6LqntJbfYWurO5xeLK7R8jB/1gp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_01:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/20 3:06 PM, John Fastabend wrote:
> Often it is useful when applying policy to know something about the
> task. If the administrator has CAP_SYS_ADMIN rights then they can
> use kprobe + networking hook and link the two programs together to
> accomplish this. However, this is a bit clunky and also means we have
> to call both the network program and kprobe program when we could just
> use a single program and avoid passing metadata through sk_msg/skb->cb,
> socket, maps, etc.
> 
> To accomplish this add probe_* helpers to bpf_base_func_proto programs
> guarded by a perfmon_capable() check. New supported helpers are the
> following,
> 
>   BPF_FUNC_get_current_task
>   BPF_FUNC_current_task_under_cgroup
>   BPF_FUNC_probe_read_user
>   BPF_FUNC_probe_read_kernel
>   BPF_FUNC_probe_read_user_str
>   BPF_FUNC_probe_read_kernel_str
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
