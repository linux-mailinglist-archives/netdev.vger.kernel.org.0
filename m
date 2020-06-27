Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E84820C4DC
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 01:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgF0XnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 19:43:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48088 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbgF0XnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 19:43:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05RNZYK1001811;
        Sat, 27 Jun 2020 16:41:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=ZKS+hsJrVqb7+I/CNrubrhG8f322swpDXNldZIDX1RE=;
 b=XqvOYZ+8xhWjO7iM1NwU6lrefROZckkMAPHrsv+miv5/nFd9fEQYlbaNMdLtx1k06kny
 gKLMXZ4MSVqpZYqyYUKtdhk31x6mW8TsN4Cn9kZxKbyeP+iTmtl/Keks8HFDQlVg1CEz
 wKGF6wfyn9qstkITkPaJKk8Qq/8Zl1OaQNI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3up9s3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 27 Jun 2020 16:41:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 27 Jun 2020 16:41:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFnyxm/fc6NMbkUhHHDVrl0QDZvpIyXMmU/8kcnL8uTy1B22JziTqsiRI09cqrCxeot81Ex18v3PKnO32XIbTi4lNHeKRjY1Rod5ZL490PL81cktrUP2Qgz9RMieXIEmJ6tKhQc1zSdZqv+nCvTixIBTKSrC30pNKav+acPR9GdmKC3sLQLGHN9V4mUORd7yjdyAagWzNZxaVX5pE4T0+BhbtDGcOlHi97VjMYz1bo8m0LxGA1vWtcSr35eUoVfXVquPhj6yK+ao6bwt7QfGWQTfLMUjUH2/qW0BaxTTohkMo2n5XPvkEGbaI8eZk82X5gnzQslw7N4CxlNAkb6ZAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTc0AXai3NNwKYJXZP70rq+kWhFZkgZemkGxu+Ic8tM=;
 b=UJ2q3qNbr4q3CqjpC7az4pD1zGsFkjm+L73RbD332AhOPCZR8GkBXO6zP7r8+2Ac+KHBP8emmaySsxdX954Nb/R7tEf1XKNTq9/PMTWoR5QPnJ3J82nTuramrtYFYhSEKsvOZZ9cuQbBpKPdtEBslWs4W2qkkGJLjUB7ZccS7eoN7VzNYc844lpoZBpvsDHZQWZWF60jSlI2zkGfTLI5sB/g2oyV3CxiWIKed0JpAQkNUfwgUUvSYpiG+uURo1UItf8yaZb5Gwky6sa2XZmSCK9agpzMITqCLkXHcpHv20w9kV/Qrwed1wT6mQ67lsvTi1rBVgRv0wr0nlRI80iMzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTc0AXai3NNwKYJXZP70rq+kWhFZkgZemkGxu+Ic8tM=;
 b=bQPRweDiq8MfD5MHNsVM2oKlFJ4snLqiVXiIePvUfsK6+nm93pivk6/HWjLY6uWHqjJ/rAVPaRHRrIKwAGor3+ynUgp+TVKJ3k5CCAllFqbUaSBHJRaM5VJVc9KsFjr7yQaLLOiB6ydLP28+KMvKAa92M2VEZEVpiiSCwk4p9vw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3287.namprd15.prod.outlook.com (2603:10b6:a03:109::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sat, 27 Jun
 2020 23:41:30 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3131.020; Sat, 27 Jun 2020
 23:41:30 +0000
Date:   Sat, 27 Jun 2020 16:41:27 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Cameron Berkenpas <cam@neo-zeon.de>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
References: <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:74::26) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:7944) by BYAPR05CA0049.namprd05.prod.outlook.com (2603:10b6:a03:74::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.11 via Frontend Transport; Sat, 27 Jun 2020 23:41:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:7944]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85265ed4-373e-4fe7-6f89-08d81af39de0
X-MS-TrafficTypeDiagnostic: BYAPR15MB3287:
X-Microsoft-Antispam-PRVS: <BYAPR15MB32875AFD494FF71CD71EB588BE900@BYAPR15MB3287.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSfc9GeJpR2GxqfNduvTWXqZEWG02J5qKhQpbFGK91rLqMvN47GpN62tLe6fpZj6jAaKmF9uJqhBmt3vbXF4O0dX1aC+KnyDcs4wss867JejPg0G6w8+FStzW7F+E0T6BdhE3rVh+rmwzJZNNpY8P1GTJfMQ64kZphrXwaBXkb4ekRNQjm25X9nstJRX6MYhxhj+2AIi1uawTWsAClMje4nsBW/zh5eNCucUrJfj+RrgKg1bHNXUOQpOM6H6xsHEWxyJQ0N71MOJ5PfIVXB0xQuCJHVCAwQtIJ3oxcRjnzVPKMCvWwcnPpop+uPeZx3yNDODmK/AZsqUUqz37rYqkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(366004)(396003)(39860400002)(376002)(54906003)(4326008)(6916009)(1076003)(316002)(86362001)(66556008)(66476007)(66946007)(55016002)(9686003)(186003)(53546011)(7696005)(6506007)(66574015)(33656002)(8936002)(2906002)(8676002)(83380400001)(478600001)(16526019)(5660300002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HD59fpVBVHbwZK4EgYSXJ8JHlm0DFKGInbnqYjqFKHLX3yeyjXZRGPZw1yCJYGGRQa41IBzQJZ38clLD4P45WWmbOK7u/K5LRpcdbSQvAMOGLjOtuU1v0s6moYHSV17wXGTVEGb3Fz5yMPPpvwYcpkFS758Xs7+AWcYcljwlLIWJZ4lnaJYf8/R2FrQeIO+r5TLvAQFV6RfmFLt6+T/fjJ/oCs7teGOlf1NAQLdn0aX84GgIfwsUC1cf9ppxrPzKj3eQbQ6m2vzo9Iwg3OVZBOtgUAFHQTmz4HWkB/dlW+bns2nlLzYV/v+GdCR1yo5aE7dVyTThUG0rJRRsGaPvEpir0hjXGB9F7tA32MOEiMA8cExrCIKUSwTaG8dF7XanymEL6xjHBs9Toumg2sjlsssHVACUjkxrKYUq0H33MTKqmoMXKNB/Vr8LHHYuQmJ0RQRXfhkMtYsGlnklkwwyVOPPM6zWGeqERnwjg7lcVLQxEGtzIwzNxM63lfXO92URYM59ilt4umBhFB2VsDsO+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 85265ed4-373e-4fe7-6f89-08d81af39de0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 23:41:30.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BQ93Rma7Z3AwiH7PCY1W7Jiy1mugonLjKQJBRiUJZvN8sjKkci6CM/LHMPClwWa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3287
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-27_10:2020-06-26,2020-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 cotscore=-2147483648
 suspectscore=5 mlxscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:58:14AM -0700, Cong Wang wrote:
> On Thu, Jun 25, 2020 at 10:23 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
> >
> > Hello,
> >
> > Somewhere along the way I got the impression that it generally takes
> > those affected hours before their systems lock up. I'm (generally) able
> > to reproduce this issue much faster than that. Regardless, I can help test.
> >
> > Are there any patches that need testing or is this all still pending
> > discussion around the  best way to resolve the issue?
> 
> Yes. I come up with a (hopefully) much better patch in the attachment.
> Can you help to test it? You need to unapply the previous patch before
> applying this one.
> 
> (Just in case of any confusion: I still believe we should check NULL on
> top of this refcnt fix. But it should be a separate patch.)
> 
> Thank you!

Not opposing the patch, but the Fixes tag is still confusing me.
Do we have an explanation for what's wrong with 4bfc0bb2c60e?

It looks like we have cgroup_bpf_get()/put() exactly where we have
cgroup_get()/put(), so it would be nice to understand what's different
if the problem is bpf-related.

Thanks!

> commit 259150604c0b77c717fdaab057da5722e2dfd922
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Sat Jun 13 12:34:40 2020 -0700
> 
>     cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
>     
>     When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
>     copied, so the cgroup refcnt must be taken too. And, unlike the
>     sk_alloc() path, sock_update_netprioidx() is not called here.
>     Therefore, it is safe and necessary to grab the cgroup refcnt
>     even when cgroup_sk_alloc is disabled.
>     
>     sk_clone_lock() is in BH context anyway, the in_interrupt()
>     would terminate this function if called there. And for sk_alloc()
>     skcd->val is always zero. So it's safe to factor out the code
>     to make it more readable.
>     
>     Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
>     Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
>     Reported-by: Peter Geis <pgwipeout@gmail.com>
>     Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>     Reported-by: Daniël Sonck <dsonck92@gmail.com>
>     Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
>     Cc: Daniel Borkmann <daniel@iogearbox.net>
>     Cc: Zefan Li <lizefan@huawei.com>
>     Cc: Tejun Heo <tj@kernel.org>
>     Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 52661155f85f..4f1cd0edc57d 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -790,7 +790,8 @@ struct sock_cgroup_data {
>  	union {
>  #ifdef __LITTLE_ENDIAN
>  		struct {
> -			u8	is_data;
> +			u8	is_data : 1;
> +			u8	no_refcnt : 1;
>  			u8	padding;
>  			u16	prioidx;
>  			u32	classid;
> @@ -800,7 +801,8 @@ struct sock_cgroup_data {
>  			u32	classid;
>  			u16	prioidx;
>  			u8	padding;
> -			u8	is_data;
> +			u8	no_refcnt : 1;
> +			u8	is_data : 1;
>  		} __packed;
>  #endif
>  		u64		val;
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 4598e4da6b1b..618838c48313 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -822,6 +822,7 @@ extern spinlock_t cgroup_sk_update_lock;
>  
>  void cgroup_sk_alloc_disable(void);
>  void cgroup_sk_alloc(struct sock_cgroup_data *skcd);
> +void cgroup_sk_clone(struct sock_cgroup_data *skcd);
>  void cgroup_sk_free(struct sock_cgroup_data *skcd);
>  
>  static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
> @@ -835,7 +836,7 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
>  	 */
>  	v = READ_ONCE(skcd->val);
>  
> -	if (v & 1)
> +	if (v & 3)
>  		return &cgrp_dfl_root.cgrp;
>  
>  	return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
> @@ -847,6 +848,7 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
>  #else	/* CONFIG_CGROUP_DATA */
>  
>  static inline void cgroup_sk_alloc(struct sock_cgroup_data *skcd) {}
> +static inline void cgroup_sk_clone(struct sock_cgroup_data *skcd) {}
>  static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
>  
>  #endif	/* CONFIG_CGROUP_DATA */
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1ea181a58465..dd247747ec14 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6439,18 +6439,8 @@ void cgroup_sk_alloc_disable(void)
>  
>  void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
>  {
> -	if (cgroup_sk_alloc_disabled)
> -		return;
> -
> -	/* Socket clone path */
> -	if (skcd->val) {
> -		/*
> -		 * We might be cloning a socket which is left in an empty
> -		 * cgroup and the cgroup might have already been rmdir'd.
> -		 * Don't use cgroup_get_live().
> -		 */
> -		cgroup_get(sock_cgroup_ptr(skcd));
> -		cgroup_bpf_get(sock_cgroup_ptr(skcd));
> +	if (cgroup_sk_alloc_disabled) {
> +		skcd->no_refcnt = 1;
>  		return;
>  	}
>  
> @@ -6475,10 +6465,27 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
>  	rcu_read_unlock();
>  }
>  
> +void cgroup_sk_clone(struct sock_cgroup_data *skcd)
> +{
> +	if (skcd->val) {
> +		if (skcd->no_refcnt)
> +			return;
> +		/*
> +		 * We might be cloning a socket which is left in an empty
> +		 * cgroup and the cgroup might have already been rmdir'd.
> +		 * Don't use cgroup_get_live().
> +		 */
> +		cgroup_get(sock_cgroup_ptr(skcd));
> +		cgroup_bpf_get(sock_cgroup_ptr(skcd));
> +	}
> +}
> +
>  void cgroup_sk_free(struct sock_cgroup_data *skcd)
>  {
>  	struct cgroup *cgrp = sock_cgroup_ptr(skcd);
>  
> +	if (skcd->no_refcnt)
> +		return;
>  	cgroup_bpf_put(cgrp);
>  	cgroup_put(cgrp);
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index d832c650287c..2e5b7870e5d3 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1926,7 +1926,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>  		/* sk->sk_memcg will be populated at accept() time */
>  		newsk->sk_memcg = NULL;
>  
> -		cgroup_sk_alloc(&newsk->sk_cgrp_data);
> +		cgroup_sk_clone(&newsk->sk_cgrp_data);
>  
>  		rcu_read_lock();
>  		filter = rcu_dereference(sk->sk_filter);

