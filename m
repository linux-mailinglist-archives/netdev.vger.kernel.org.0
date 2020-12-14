Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911462DA1D6
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503474AbgLNUmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:42:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502716AbgLNUl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:41:58 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEKdfPj001839;
        Mon, 14 Dec 2020 12:41:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Bm2A1jqwQooKDrVavKjRFF2G2lgckB1F9i76QxoQAa4=;
 b=ORcGvZCs7F1c9jEFoqODAvSchRAwTXuRvgjSIf4wNs+yoTHPDHIa0qb/7zT1EQH9fRiP
 4dgM2zCPZIqwlpn254pGMMYVJnzNHfgGwhewEmGADybTNYhK04pY51+D+EeZ9wc4NtVH
 X7c5LN4f3kaUhOeeCmEKJus87e6fGcjHe9w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35desceyv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Dec 2020 12:41:00 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Dec 2020 12:40:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfxUceCxclUSSgtQG52MubnxiXG/vEDHeE52wDg56sjRzJAI5/BuPIeCxlocJ2WZMbVdR81YI0QvNc9jg9qTLFsLtvmvGj2KHDltmYLuFSPvKGLz/QgmLSX9l0JhUp8SLknMaezzx+NeWbdmAnxkke3Ke/hBn1206jE0yBZzIbEOpJu8SX7WLBFpGe5NzTv+Fs2+5l8YcOxYAggX00CzUFF4Eev5LdREnP6witnkDailjjGEdYPvUaEzzgjon21AtjlKpYJFBRr+jX9QD+7UkX5WTGC2k5QigMwdIC7j+NlYtLjekufYnI3IJpR9L1BuVnl2rNRdh7j92lA2yuBEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm2A1jqwQooKDrVavKjRFF2G2lgckB1F9i76QxoQAa4=;
 b=gayxxNmEYm984MKgZoXCFLEc8OJ02gMHaU5pK9GMLjbgau95o1dkA69MP2LdUaxofc4wLxl6BM21YYZYFUtJsTDusfUcrm/vJbHAjinkYVfB6HcMS4x1qE+nXgcMMoD+qMHgZDumgQBBj6Yl5Tyl9QbFghdQdDc0SOeuPFe7HK+vq81Xtk1BWPoNguqw9iIl4hm/MioLAouTtzmlmW/WxLRVLZ3WcyvblmTrj/6ZK39KFVX0UCIOJY2upxTRm6ddy34iNOA9d5ijmne+T45HCryI5He0fQG/8fI4hZbk8nBTpycCrSbfgLuFx7z+c6KaMHcYd+oITLJVEBw2R0rSMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm2A1jqwQooKDrVavKjRFF2G2lgckB1F9i76QxoQAa4=;
 b=IrtwfHU95/6IL2mH0uzIb445YGFabARFeqVECU3fTPna8STr7O/kkizphBxIj8gmitCDg2bNPDrDMFjn7nbIIUl4p9qlOXaaO2C+nBe5k50C1T2qYAtiVdl9fM6Oon7avxKNxgMsJTfi9MYlEtQtN7tsp9AK7DtALRFItx4EJsY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 20:40:57 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 20:40:57 +0000
Date:   Mon, 14 Dec 2020 12:40:52 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: Re: [Patch bpf-next v2 3/5] selftests/bpf: update elem_size check in
 map ptr test
Message-ID: <X9fN1K2Qzn9vcjjd@rdna-mbp.dhcp.thefacebook.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-4-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214201118.148126-4-xiyou.wangcong@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:f622]
X-ClientProxiedBy: MW4PR04CA0206.namprd04.prod.outlook.com
 (2603:10b6:303:86::31) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:f622) by MW4PR04CA0206.namprd04.prod.outlook.com (2603:10b6:303:86::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 20:40:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0917d37e-a017-45f6-39c2-08d8a0708f8c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:
X-Microsoft-Antispam-PRVS: <BYAPR15MB26937479E17E390A73DBFB79A8C70@BYAPR15MB2693.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyavOD0pqcY3zqLJaS6xj+kK5GW5fTDgYVo1NfcOmRrVWa1uaPG1TVt7DEo2dnJgrDGJvHV74SBUVdQm6qz0ZAbf2jusipmkjvOq3k8hetImjCIA6aPgEdhEsLCYkCvBHCfUNg2RqXdmpNQvIQqwjFDAJL2BpJq3r7SnzKZOLr5LvwawKM3j3B0RGEILmOOUAifHyB+vN1Bb0cyyY3XZfn+ssDAM8KgRk9P5xikmLiUA5SsJGziCrhke/vGUnSo0S2cvoBz8sWTVSHPuReBDsTQnsaM+SkqFdS/2Md5YzWOepBQN4oxKhqYjVoWUxq4yNjdG1DhdeOn1PAYS9aCNJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(4326008)(8936002)(66476007)(8676002)(54906003)(6916009)(9686003)(6496006)(4001150100001)(15650500001)(2906002)(52116002)(6486002)(16526019)(186003)(86362001)(66556008)(6666004)(83380400001)(5660300002)(66946007)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHZXWFVKQk5VdTdCeDNVQWNVcEpGNFlqYkZ6KzZlTVV5ZWVRSzR6V0JSMEpO?=
 =?utf-8?B?YU1DT2VCTm56RWhLbmt5WGMzQmRzOWs5djEvYmdTWmxEQjRxOWovbkFlUFh6?=
 =?utf-8?B?RTJKaElnaEhNOGtCUStWakxuMEZxWWtRd0tSK2VadlVmdG5xcEtmclR2cHh0?=
 =?utf-8?B?bHNhbGptQVlHK3lNenpFSVpZZkJCbjhyL3pYSmxRanczTE9SQmhPeWhJY25X?=
 =?utf-8?B?aU1VcW1tNDFBTWFxelk4V0M0S2lVYXpPcDRoS1UzMlFNaEdiSnluNFZrczFG?=
 =?utf-8?B?bENkZWYvVTREeEhQenFSaFVaS0RucGJ3T1ZHejlsL0pRUjNTK1FuU2hRUFpN?=
 =?utf-8?B?NkdYUDk2ZzNiWUE2K3lGblFONXluYWFFOGt4WUo2cGtTdFZsUFBOZXExdEF0?=
 =?utf-8?B?c3E5Y3M4WXpxdjZPNzZqRGNaR09qOFBza0JJNlpDWEFWZmVjbUY5ZWtFK0pv?=
 =?utf-8?B?cWRUV05tbTVjaUQ0d3ZNdjcxRDNKOEsvSGpaRkpWaHNMM2hnTWJuMmxCQzNW?=
 =?utf-8?B?Z1c2UTZsNS9zUWtwRjJCTGhyazNmU051RnZ1a0FpdzJySUczdUlXbWFhc2hR?=
 =?utf-8?B?RkxoR3JDQU1GbmhxUEZ0cG5vdHdacUs0OGNuUTI0RWdCMHB3bUVxd0taK2tH?=
 =?utf-8?B?b3VHeFJNNjg3WHA3WlJjY2hQSG9VYU1Oem8zbEpjSllQdGllSURNYUxjL3F1?=
 =?utf-8?B?VzQ0eWZBOFViZFB3RmluRnk5WURGWEdHaThiU2tud0x6SWJIWjBXRmpFVkxx?=
 =?utf-8?B?anNIWUk0K3c3ZDAzUFZtbFA3cmNqMjhDTnhQZWZtbVYxNFhZMlVON2R0NGt4?=
 =?utf-8?B?M2M1OEpxb2taN0g3OElKNi92dENkTHdSVGtLL0taU0JnZmhjV1ZJMU9vTlIv?=
 =?utf-8?B?M2hHNnR2R1FZc3NNZDR0U0dEbStZRElYVXVVOGgwRVhwcm51T0JPNGk3dXJq?=
 =?utf-8?B?TWpTTVhRb2l2WG1hc1U5NEk1clhvSlNRVFlnZzE2b1hKTThUWGJlNlgvT2xY?=
 =?utf-8?B?ZTdycFVDcVFVd3VmNTl1RnpPK29HVnlrYjQxZGV4NXZYZ1V1c2tYT0dwdS83?=
 =?utf-8?B?R0QvZ0MvM083VmFsNExvb1NmVTlvSEUxeHVBVktzSk83NzRUeHRwdXZvNVVw?=
 =?utf-8?B?aGpJVGpRcSt5dWtmeHVGeFlIRUtRMWpCT01ENzNPNWdwNEVrOWZOTXN2QW1M?=
 =?utf-8?B?MTZTMVlmcVRHQUNxWm4wQ3FCbktVeTZHb0o2V2hpcnNNcjR6QWpuVVhNMjVC?=
 =?utf-8?B?Q0d4bU5HUmJuYWF0dzErTk1iZHFqY3FTT1BsQ2lHUFVrZ1loM25xN0pBZVlh?=
 =?utf-8?B?Wis3MzFiMWhhcFJWR0VPeTNoSDdZbnhrTm9DUXpRQTYrSTB0Uk0yOVlrcmRE?=
 =?utf-8?B?Sm9XQmwwOVhlTUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 20:40:57.7548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 0917d37e-a017-45f6-39c2-08d8a0708f8c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INC63qq35owieyrMbzRsIfe4Ho6nIO0HahTK7BcHoMJUltpusvpPGgchRBJ+UUdu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_11:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 clxscore=1011
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> [Mon, 2020-12-14 12:11 -0800]:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> In map ptr test, a hard-coded 64 is used to check hash element size.
> Increase it to 72 as we increase the size of struct htab_elem. It
> seems struct htab_elem is not visible here.
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Acked-by: Andrey Ignatov <rdna@fb.com>

> ---
>  tools/testing/selftests/bpf/progs/map_ptr_kern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> index d8850bc6a9f1..34f9880a1903 100644
> --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> @@ -111,7 +111,7 @@ static inline int check_hash(void)
>  	VERIFY(check_default_noinline(&hash->map, map));
>  
>  	VERIFY(hash->n_buckets == MAX_ENTRIES);
> -	VERIFY(hash->elem_size == 64);
> +	VERIFY(hash->elem_size == 72);
>  
>  	VERIFY(hash->count.counter == 0);
>  	for (i = 0; i < HALF_ENTRIES; ++i) {
> -- 
> 2.25.1
> 

-- 
Andrey Ignatov
