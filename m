Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD526DC4B
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 15:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgIQNAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 09:00:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbgIQMw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 08:52:58 -0400
X-Greylist: delayed 2272 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 08:52:54 EDT
Received: from pps.filterd (m0042983.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HCB4gd026086;
        Thu, 17 Sep 2020 05:14:44 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5pejmh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 05:14:44 -0700
Received: from pps.reinject (m0042983.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HCE9Cs010240;
        Thu, 17 Sep 2020 05:14:43 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33k5p850ys-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Sep 2020 10:56:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Sep 2020 10:56:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl5hYFcGYkXq5qLWgfbmpEZqAQsOdmdYjgFoTXlKZQtHzGLEQIazraZh9Uitcu2ls4n/HPK2xtaRCiDl6YkjXJgBzHdjg+KjvXaBP4wV655RVhsjHSX7tuVa4eLOk2/7m2msOFJ9OK714Nf34xCFt2Qt2GKdsfBrmtax17XrUsd04+Dz+qLickwRdA7IQe2c7lohd3t458sSmFWpltN1nZer2UJleKU6CyjAmeLY7hIulFdNdX3Fq8Tk4PAkT6pF3ct1oiBaQgeF+/25+Rjm5szy7dQqeIiDo9/19AdZH+nFNBKMlWPD/D+OM+a6A/xh+PCl36+vWsP63/l58X/2OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQf1yIQ5ic9r7G2x0AuPh4/fLuzBqcQM4p7AR5kYVtI=;
 b=PoeaKVRQ7QJhlpakWbYNEIMADjc5hUayzJy0eqpeiNhYmR+7X7ZB9khUmD6kheJ4ZV9JltUct9w20bjta/fPJA1Cj3XcOVLjJ6Yci2WpDVBKI6EYPyQ2vBqoKWD8z3L3DXwO08ikpvaFR+b+B9wzfZfFockDBY1lJgMgYkT54xGkTqiwulIX7RdI4XG6e6qgkD7fhWqOQYPCtMC3hSNRlLUrsJ+pngV8E97tswDi5AQLpSa+UKLn0Isw+mMmm+zdKss96JcXOKzqK/rgETZg9w92ud440jOi35sBIxiyBStX5WqxbWi7xqUM2XFkN9GokqQaJ6AlazKgW1MSctAYrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQf1yIQ5ic9r7G2x0AuPh4/fLuzBqcQM4p7AR5kYVtI=;
 b=ad65BC6ez5t5AEdS5luDfUkO9XBEEM+KPEaUHFOzu6KcD7/RnVNdGD4GD8M7QNUyl6th4dq6rB8vAQybI2k3AEth9BIhvL4dY/IiDrQLUCl3LCObhTLrlzSKWFWLFPsH3rjRm/qGPBxg7LN7hUdnsHVLx81ohEMCEYQBBEWz3ws=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 17:56:01 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 17:56:01 +0000
Date:   Wed, 16 Sep 2020 10:55:53 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Message-ID: <20200916175553.4fevmxgcv2r6nhiu@kafai-mbp>
References: <20200916061649.1437414-1-yhs@fb.com>
In-Reply-To: <20200916061649.1437414-1-yhs@fb.com>
X-ClientProxiedBy: MWHPR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:300:d4::14) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2074) by MWHPR19CA0004.namprd19.prod.outlook.com (2603:10b6:300:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 17:56:00 +0000
X-Originating-IP: [2620:10d:c090:400::5:2074]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cf2b198-a64c-4b73-744c-08d85a69c5f6
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB357004D108CE7D0FE1C53CBFD5210@BY5PR15MB3570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syAbxq6ew28isSFxDPxn4DR5iUaoYXCh0bLZYe9ZTZqZkbbRHgi+ZCvZSo9FgJtRCFBrNPAuMaM7gsooIFdrHdqt0WIfmM+tY5EGPRn/mRzgXCuyizO+c6shtRg+R/o4I/zzBsCKzQtiGy7CqaQrAGymB1EOGnAbIKxCPJXNBHWnA4CxWVgMCHOM/hIMFnYW1XBGAG+K91A2u879jQEsoDEUDZ9JEq2/jiZFNhYNyVwn90ARoaF30fg9TXXQC1I4SldurNRZXwfiJ/Q/JruonL1SGZ6+Sgc/a1Qr6JUBpFqv8dtIJNSmLVXUtXIrn6I+8OGMbIcyEpan8h+qXJk/Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(376002)(366004)(186003)(66556008)(16526019)(55016002)(86362001)(54906003)(316002)(8936002)(478600001)(9686003)(6666004)(52116002)(33716001)(1076003)(6496006)(66476007)(6636002)(4326008)(8676002)(83380400001)(2906002)(5660300002)(6862004)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cgDiJhWyWUCNPzj+pYpddVUVCVD/JJGtR8Dl+gFhe3vGgQJQQNlsbPWpwKaD+r1xM622YktFAxxePAyu27Xz5BW1aw1ucEmE1XNMIs0kTdqG4zDVGwBh/30MSADUkRGqr4OjqeujduoliXFOWG47djmmYplEAKzG4vl7nTlnNBbGRy3EaJbdQazI5g7A5zw/ioFMJvsJopr7tdK8ZSclzVy2pUM+7fdv+FRZu/VdbmN5tvMM43LWMsMjNwdjVO4p5ZrP8/lDz/k7QFBZ6f7rEt++MYz1DihDHOKnTm9DvjOHVvMsPSzDuRUdlJMEmLvrVDGMGdUz+ztkh20i4lA9wtiEd3scgTfs0W/5mSONZyYyvNiLRI0kVLtkZu9SMHskukaKQf6EjI2Tw3Xd3Qdfbd+bYiNzZvfo81dLxwKhAtaPLhBGld9CWsaXDxAwnbOanBIJ8LckvcTo0ou2LC7xGZXce36kWL3NxuVuuEUbpc9DorvrFTXKb1CmV6FUzq4T5W3phdtFlKtvROoI8Y0JLBcDLacrRaa5wq9M5BChTtdLlqsKltUBWjN6wuZUQoQhMqUskuKqD3L52msB77hadP+DXjARJ9sF/0nurftpeVtVGCJaScq0FCH6xG5/QZV8Lif4zI4aNHZnFyNZpBiCZHnYwMAVGi/aHSp0QMBrSIk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf2b198-a64c-4b73-744c-08d85a69c5f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 17:56:01.4842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDZgQeIYR2WG0IfhtkDKeNoEmOW16E2fB9TuVqZbQLJBA71gTYfGWcoOFFtVsjpl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_11:2020-09-16,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=2 mlxscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009160127
X-FB-Internal: deliver
subject: Re: [PATCH bpf-next v3] bpf: using rcu_read_lock for bpf_sk_storage_map iterator
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 11:16:49PM -0700, Yonghong Song wrote:
[ ... ]

> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 4a86ea34f29e..d43c3d6d0693 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -678,6 +678,7 @@ struct bpf_iter_seq_sk_storage_map_info {
>  static struct bpf_local_storage_elem *
>  bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>  				 struct bpf_local_storage_elem *prev_selem)
> +	__acquires(RCU) __releases(RCU)
>  {
>  	struct bpf_local_storage *sk_storage;
>  	struct bpf_local_storage_elem *selem;
In the while loop earlier in this function, if I read it correctly,
it is sort of continuing the earlier hlist_for_each_entry_rcu() for the
same bucket, so the hlist_entry_safe() needs to be changed also.
Something like this (uncompiled code):

        while (selem) {
-               selem = hlist_entry_safe(selem->map_node.next,
+               selem = hlist_entry_safe(rcu_dereference(hlist_next_rcu(&selem->map_node)),
                                         struct bpf_local_storage_elem, map_node);
                if (!selem) {
                        /* not found, unlock and go to the next bucket */

> @@ -701,11 +702,11 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>  		if (!selem) {
>  			/* not found, unlock and go to the next bucket */
>  			b = &smap->buckets[bucket_id++];
> -			raw_spin_unlock_bh(&b->lock);
> +			rcu_read_unlock();
>  			skip_elems = 0;
>  			break;
>  		}
> -		sk_storage = rcu_dereference_raw(selem->local_storage);
> +		sk_storage = rcu_dereference(selem->local_storage);
>  		if (sk_storage) {
>  			info->skip_elems = skip_elems + count;
>  			return selem;
