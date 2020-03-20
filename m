Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C33118DC2C
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCTXqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:46:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58522 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726738AbgCTXqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 19:46:52 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02KNccol003650;
        Fri, 20 Mar 2020 16:46:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gZrveeCrBVUqM+Mh/B1m2RCIzNB3vxGp6yrl9Ekd3/Y=;
 b=QPfwyKYLeHOW29tOrb0/qiGc96td7tyH5LPP7ceaMLt7zxG4x4WtrazN67gxHXW/JsFK
 A5UPYawAR1jDT20JIOfZOSlW0+e9D7Z+Rudc57vFQxNb38lryqWg/N9wXxhgB5U1VtbG
 RaaEuBfIN2bW5bFDgE2IpvX7GVPHpDYJ9aM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yu7yp141s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Mar 2020 16:46:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 16:46:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aael07/qVFvGucyl0B3aTs8B5Yo+oy1n3H01xax4BhxjiAQwGIi0NV1jCkY14d8OCDgRozjxtKqNOeqBt2V0x7Oz13Vt4CWgyWe0zYYs1rwRz54pYDbDePKz91oqL6HGMp26CxYsDzT0LQL1ZKOrDENMpFX17rEUnjbjLpwQMKEImcYVbENhdbScN6RVjYe+DytW8AqwJ4C+6OOphZmOtRTLXuSd01OTwoyaGtlJOCmMZkX3gOZ8DD97iblNsTXEoXx+1jMJzkV8e3kt5ODSC70XPKEzIgDf04h+cgtW0yq/8XJgpegad0pKc2MRjyFWcYBLsltprcbmet7/UURn2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZrveeCrBVUqM+Mh/B1m2RCIzNB3vxGp6yrl9Ekd3/Y=;
 b=YTEQxmJcleKlme9UYzQcj9L1DK+V8JFcDfWn3IqnQyt2UF5m4SXrTcXe1lq1MNFKNVUhsJZnZabTCFoWlgUJa7snM7sv32BpNU3GcGZCRwJteENdYpXQO2FNkSYANMfCSIGVX0Cir+4TVDADgESrYlWKBblryTLl60a/oJHISO7dFFAKrHrXgKjI6urliAZS1aIUsOUlgeTYXSI/Ruz/SKfThHDh633nYCKA+jXxb2U3pUM/GnfrEG3xVtZLR0vywkvmSuOvvsxL9raUNCCLGdyBVTxKCwImYs9MkfN8AqJWBhiQyrkCA2wC0xBOo49zVc87n5rrArayuf2PVR8S9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZrveeCrBVUqM+Mh/B1m2RCIzNB3vxGp6yrl9Ekd3/Y=;
 b=AzlEb0iUpR0+0IJD2zqBTfyLFNoF4U0QGmuoNoSvtPvesPT8LsxHJtc/+dvlqH9WgvxN00nJmGdRcXvLXokg0GrGpGsgo8tK4yGNd3BE4h9C+eDgpgVHqr+RH91A+aOv2KIOAzAeSv7ooGHZ0DX8jfu3SGHEjOsc+QSPwJjEERo=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2806.namprd15.prod.outlook.com (2603:10b6:a03:15c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Fri, 20 Mar
 2020 23:46:32 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 23:46:32 +0000
Date:   Fri, 20 Mar 2020 16:46:28 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 3/6] bpf: implement
 bpf_link-based cgroup BPF program attachment
Message-ID: <20200320234628.GA11775@rdna-mbp>
References: <20200320203615.1519013-1-andriin@fb.com>
 <20200320203615.1519013-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320203615.1519013-4-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR18CA0038.namprd18.prod.outlook.com
 (2603:10b6:320:31::24) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:156f) by MWHPR18CA0038.namprd18.prod.outlook.com (2603:10b6:320:31::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 23:46:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:156f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f12e188-606e-4459-1695-08d7cd28ea64
X-MS-TrafficTypeDiagnostic: BYAPR15MB2806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2806251FBEC254D949BAF95CA8F50@BYAPR15MB2806.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(376002)(39860400002)(346002)(366004)(136003)(199004)(316002)(52116002)(66556008)(186003)(33656002)(16526019)(33716001)(5660300002)(66946007)(66476007)(2906002)(6496006)(9686003)(30864003)(1076003)(6486002)(81166006)(81156014)(8676002)(8936002)(86362001)(478600001)(6636002)(6862004)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2806;H:BYAPR15MB4119.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KX9UeKk1pSW7tZYhx7XV32ot2+diapl/CUOdu6bteQgAxlNlsqJAXF5uYL47uGZ2DVn9IYtXsCArXhthc9w8DzGLXuvQocwjEX09qevNpx57kqAmITFfR2pF149YVrGkGawfl5nsxxyqilxs6xVdFwhtkTHOjHk/ZAlKnifUWgVJiFIMGspEeL7E8zDg97jVgmYs3mg7fX3bdvwIDxkRtRovckRZuOOzrivYwKsTiDa9AFjxlgeud4RTBb2a9kYUSOxwHNktAF3fVdqNgWLy14CWOV2YLLYlOpB+NtNICR25ZkKK2eGtNteM/4rjkcl+Ot5c7BOOTMKU/MuXCZPAxcO4otRMCz+pcknbc1RpcTtIk3rX9+liktAKfrC3Wolcj24nJ7xSan9I8kfYU0v6FNB0O9f8ORzDmd0NNo6UHMI3twS4qSU+MvhovbrK69wy
X-MS-Exchange-AntiSpam-MessageData: hLpM89RBGhPFTZVEtshzsyBtlmT2qvfcvkr0MuCv19If9Iq7nfkJGLGAU/Bm9Mb+LKOnqwNLRashXuKHlbvLne1fsTSijlyDsSh/lbmUVFJBBCKuZ0tgfXmprGDAaim73FgEHFz8CVvMgBCWlgLAFnQOzJDylAsuaFYevWY0Hf77XSCvrzN6FKAR3FTgOREZ
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f12e188-606e-4459-1695-08d7cd28ea64
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 23:46:31.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1XoTgpMghkuC5KDRlMLQaKxsvvvUuzR7xTREjHS4pu7OsOulpI47N6sGAsEHQ/q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2806
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_08:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=2 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200092
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> [Fri, 2020-03-20 13:37 -0700]:
> Implement new sub-command to attach cgroup BPF programs and return FD-based
> bpf_link back on success. bpf_link, once attached to cgroup, cannot be
> replaced, except by owner having its FD. cgroup bpf_link has semantics of
> BPF_F_ALLOW_MULTI BPF program attachments and can co-exist with

Hi Andrii,

Is there any reason to limit it to only BPF_F_ALLOW_MULTI?

The thing is BPF_F_ALLOW_MULTI not only allows to attach multiple
programs to specified cgroup but also controls what programs can later
be attached to a sub-cgroup, and in BPF_F_ALLOW_MULTI case both
sub-cgroup programs and specified cgroup programs will be executed (in
this order).

There many use-cases though when it's desired to either completely
disallow attaching programs to a sub-cgroup or override parent cgroup's
program behavior in sub-cgroup. If bpf_link covers only
BPF_F_ALLOW_MULTI, those scenarios won't be able to leverage it.

This double-purpose of BPF_F_ALLOW_MULTI is a pain ... For example if
one wants to attach multiple programs to a cgroup but disallow attaching
programs to a sub-cgroup it's currently impossible (well, w/o additional
cgroup level just for this).

> non-bpf_link-based BPF cgroup attachments.
> 
> To prevent bpf_cgroup_link from keeping cgroup alive past the point when no
> BPF program can be executed, implement auto-detachment of link. When
> cgroup_bpf_release() is called, all attached bpf_links are forced to release
> cgroup refcounts, but they leave bpf_link otherwise active and allocated, as
> well as still owning underlying bpf_prog. This is because user-space might
> still have FDs open and active, so bpf_link as a user-referenced object can't
> be freed yet. Once last active FD is closed, bpf_link will be freed and
> underlying bpf_prog refcount will be dropped. But cgroup refcount won't be
> touched, because cgroup is released already.
> 
> The inherent race between bpf_cgroup_link release (from closing last FD) and
> cgroup_bpf_release() is resolved by both operations taking cgroup_mutex. So
> the only additional check required is when bpf_cgroup_link attempts to detach
> itself from cgroup. At that time we need to check whether there is still
> cgroup associated with that link. And if not, exit with success, because
> bpf_cgroup_link was already successfully detached.
> 
> Acked-by: Roman Gushchin <guro@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf-cgroup.h     |  27 ++-
>  include/linux/bpf.h            |  10 +-
>  include/uapi/linux/bpf.h       |   9 +-
>  kernel/bpf/cgroup.c            | 313 +++++++++++++++++++++++++--------
>  kernel/bpf/syscall.c           |  62 +++++--
>  kernel/cgroup/cgroup.c         |  14 +-
>  tools/include/uapi/linux/bpf.h |   9 +-
>  7 files changed, 345 insertions(+), 99 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index a7cd5c7a2509..ab95824a1d99 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -51,9 +51,16 @@ struct bpf_cgroup_storage {
>  	struct rcu_head rcu;
>  };
>  
> +struct bpf_cgroup_link {
> +	struct bpf_link link;
> +	struct cgroup *cgroup;
> +	enum bpf_attach_type type;
> +};
> +
>  struct bpf_prog_list {
>  	struct list_head node;
>  	struct bpf_prog *prog;
> +	struct bpf_cgroup_link *link;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>  };
>  
> @@ -84,20 +91,23 @@ struct cgroup_bpf {
>  int cgroup_bpf_inherit(struct cgroup *cgrp);
>  void cgroup_bpf_offline(struct cgroup *cgrp);
>  
> -int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
> -			struct bpf_prog *replace_prog,
> +int __cgroup_bpf_attach(struct cgroup *cgrp,
> +			struct bpf_prog *prog, struct bpf_prog *replace_prog,
> +			struct bpf_cgroup_link *link,
>  			enum bpf_attach_type type, u32 flags);
>  int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> +			struct bpf_cgroup_link *link,
>  			enum bpf_attach_type type);
>  int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  		       union bpf_attr __user *uattr);
>  
>  /* Wrapper for __cgroup_bpf_*() protected by cgroup_mutex */
> -int cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
> -		      struct bpf_prog *replace_prog, enum bpf_attach_type type,
> +int cgroup_bpf_attach(struct cgroup *cgrp,
> +		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
> +		      struct bpf_cgroup_link *link, enum bpf_attach_type type,
>  		      u32 flags);
>  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> -		      enum bpf_attach_type type, u32 flags);
> +		      enum bpf_attach_type type);
>  int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  		     union bpf_attr __user *uattr);
>  
> @@ -332,6 +342,7 @@ int cgroup_bpf_prog_attach(const union bpf_attr *attr,
>  			   enum bpf_prog_type ptype, struct bpf_prog *prog);
>  int cgroup_bpf_prog_detach(const union bpf_attr *attr,
>  			   enum bpf_prog_type ptype);
> +int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  int cgroup_bpf_prog_query(const union bpf_attr *attr,
>  			  union bpf_attr __user *uattr);
>  #else
> @@ -354,6 +365,12 @@ static inline int cgroup_bpf_prog_detach(const union bpf_attr *attr,
>  	return -EINVAL;
>  }
>  
> +static inline int cgroup_bpf_link_attach(const union bpf_attr *attr,
> +					 struct bpf_prog *prog)
> +{
> +	return -EINVAL;
> +}
> +
>  static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
>  					union bpf_attr __user *uattr)
>  {
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index bdb981c204fa..0f7c2f48c734 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1081,15 +1081,23 @@ extern int sysctl_unprivileged_bpf_disabled;
>  int bpf_map_new_fd(struct bpf_map *map, int flags);
>  int bpf_prog_new_fd(struct bpf_prog *prog);
>  
> -struct bpf_link;
> +struct bpf_link {
> +	atomic64_t refcnt;
> +	const struct bpf_link_ops *ops;
> +	struct bpf_prog *prog;
> +	struct work_struct work;
> +};
>  
>  struct bpf_link_ops {
>  	void (*release)(struct bpf_link *link);
>  	void (*dealloc)(struct bpf_link *link);
> +
>  };
>  
>  void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
>  		   struct bpf_prog *prog);
> +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> +		      int link_fd);
>  void bpf_link_inc(struct bpf_link *link);
>  void bpf_link_put(struct bpf_link *link);
>  int bpf_link_new_fd(struct bpf_link *link);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 5d01c5c7e598..fad9f79bb8f1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -111,6 +111,7 @@ enum bpf_cmd {
>  	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
>  	BPF_MAP_UPDATE_BATCH,
>  	BPF_MAP_DELETE_BATCH,
> +	BPF_LINK_CREATE,
>  };
>  
>  enum bpf_map_type {
> @@ -539,7 +540,7 @@ union bpf_attr {
>  		__u32		prog_cnt;
>  	} query;
>  
> -	struct {
> +	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
>  		__u64 name;
>  		__u32 prog_fd;
>  	} raw_tracepoint;
> @@ -567,6 +568,12 @@ union bpf_attr {
>  		__u64		probe_offset;	/* output: probe_offset */
>  		__u64		probe_addr;	/* output: probe_addr */
>  	} task_fd_query;
> +
> +	struct { /* struct used by BPF_LINK_CREATE command */
> +		__u32		prog_fd;	/* eBPF program to attach */
> +		__u32		target_fd;	/* object to attach to */
> +		__u32		attach_type;	/* attach type */
> +	} link_create;
>  } __attribute__((aligned(8)));
>  
>  /* The description below is an attempt at providing documentation to eBPF
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 9c8472823a7f..b960e8633f23 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -80,6 +80,17 @@ static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
>  		bpf_cgroup_storage_unlink(storages[stype]);
>  }
>  
> +/* Called when bpf_cgroup_link is auto-detached from dying cgroup.
> + * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
> + * doesn't free link memory, which will eventually be done by bpf_link's
> + * release() callback, when its last FD is closed.
> + */
> +static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
> +{
> +	cgroup_put(link->cgroup);
> +	link->cgroup = NULL;
> +}
> +
>  /**
>   * cgroup_bpf_release() - put references of all bpf programs and
>   *                        release all cgroup bpf data
> @@ -100,7 +111,10 @@ static void cgroup_bpf_release(struct work_struct *work)
>  
>  		list_for_each_entry_safe(pl, tmp, progs, node) {
>  			list_del(&pl->node);
> -			bpf_prog_put(pl->prog);
> +			if (pl->prog)
> +				bpf_prog_put(pl->prog);
> +			if (pl->link)
> +				bpf_cgroup_link_auto_detach(pl->link);
>  			bpf_cgroup_storages_unlink(pl->storage);
>  			bpf_cgroup_storages_free(pl->storage);
>  			kfree(pl);
> @@ -134,6 +148,18 @@ static void cgroup_bpf_release_fn(struct percpu_ref *ref)
>  	queue_work(system_wq, &cgrp->bpf.release_work);
>  }
>  
> +/* Get underlying bpf_prog of bpf_prog_list entry, regardless if it's through
> + * link or direct prog.
> + */
> +static struct bpf_prog *prog_list_prog(struct bpf_prog_list *pl)
> +{
> +	if (pl->prog)
> +		return pl->prog;
> +	if (pl->link)
> +		return pl->link->link.prog;
> +	return NULL;
> +}
> +
>  /* count number of elements in the list.
>   * it's slow but the list cannot be long
>   */
> @@ -143,7 +169,7 @@ static u32 prog_list_length(struct list_head *head)
>  	u32 cnt = 0;
>  
>  	list_for_each_entry(pl, head, node) {
> -		if (!pl->prog)
> +		if (!prog_list_prog(pl))
>  			continue;
>  		cnt++;
>  	}
> @@ -212,11 +238,11 @@ static int compute_effective_progs(struct cgroup *cgrp,
>  			continue;
>  
>  		list_for_each_entry(pl, &p->bpf.progs[type], node) {
> -			if (!pl->prog)
> +			if (!prog_list_prog(pl))
>  				continue;
>  
>  			item = &progs->items[cnt];
> -			item->prog = pl->prog;
> +			item->prog = prog_list_prog(pl);
>  			bpf_cgroup_storages_assign(item->cgroup_storage,
>  						   pl->storage);
>  			cnt++;
> @@ -333,19 +359,62 @@ static int update_effective_progs(struct cgroup *cgrp,
>  
>  #define BPF_CGROUP_MAX_PROGS 64
>  
> +static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
> +					       struct bpf_prog *prog,
> +					       struct bpf_cgroup_link *link,
> +					       struct bpf_prog *replace_prog,
> +					       bool allow_multi)
> +{
> +	struct bpf_prog_list *pl;
> +
> +	/* legacy single-attach case */
> +	if (!allow_multi) {
> +		if (list_empty(progs))
> +			return NULL;
> +		return list_first_entry(progs, typeof(*pl), node);
> +	}
> +
> +	/* direct prog multi-attach case */
> +	if (prog) {
> +		list_for_each_entry(pl, progs, node) {
> +			if (pl->prog == prog)
> +				/* disallow attaching the same prog twice */
> +				return ERR_PTR(-EINVAL);
> +			if (replace_prog && pl->prog == replace_prog)
> +				/* a match found */
> +				return pl;
> +		}
> +		if (replace_prog)
> +			/* prog to replace not found for cgroup */
> +			return ERR_PTR(-ENOENT);
> +		return NULL;
> +	}
> +
> +	/* link (multi-attach) case */
> +	list_for_each_entry(pl, progs, node) {
> +		if (pl->link == link)
> +			/* disallow attaching the same link twice */
> +			return ERR_PTR(-EINVAL);
> +	}
> +	return NULL;
> +}
> +
>  /**
> - * __cgroup_bpf_attach() - Attach the program to a cgroup, and
> + * __cgroup_bpf_attach() - Attach the program or the link to a cgroup, and
>   *                         propagate the change to descendants
>   * @cgrp: The cgroup which descendants to traverse
>   * @prog: A program to attach
> + * @link: A link to attach
>   * @replace_prog: Previously attached program to replace if BPF_F_REPLACE is set
>   * @type: Type of attach operation
>   * @flags: Option flags
>   *
> + * Exactly one of @prog or @link can be non-null.
>   * Must be called with cgroup_mutex held.
>   */
> -int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
> -			struct bpf_prog *replace_prog,
> +int __cgroup_bpf_attach(struct cgroup *cgrp,
> +			struct bpf_prog *prog, struct bpf_prog *replace_prog,
> +			struct bpf_cgroup_link *link,
>  			enum bpf_attach_type type, u32 flags)
>  {
>  	u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
> @@ -353,13 +422,19 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	struct bpf_prog *old_prog = NULL;
>  	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
>  		*old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {NULL};
> -	struct bpf_prog_list *pl, *replace_pl = NULL;
> +	struct bpf_prog_list *pl;
>  	int err;
>  
>  	if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
>  	    ((flags & BPF_F_REPLACE) && !(flags & BPF_F_ALLOW_MULTI)))
>  		/* invalid combination */
>  		return -EINVAL;
> +	if (link && (prog || replace_prog))
> +		/* only either link or prog/replace_prog can be specified */
> +		return -EINVAL;
> +	if (!!replace_prog != !!(flags & BPF_F_REPLACE))
> +		/* replace_prog implies BPF_F_REPLACE, and vice versa */
> +		return -EINVAL;
>  
>  	if (!hierarchy_allows_attach(cgrp, type))
>  		return -EPERM;
> @@ -374,26 +449,16 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (prog_list_length(progs) >= BPF_CGROUP_MAX_PROGS)
>  		return -E2BIG;
>  
> -	if (flags & BPF_F_ALLOW_MULTI) {
> -		list_for_each_entry(pl, progs, node) {
> -			if (pl->prog == prog)
> -				/* disallow attaching the same prog twice */
> -				return -EINVAL;
> -			if (pl->prog == replace_prog)
> -				replace_pl = pl;
> -		}
> -		if ((flags & BPF_F_REPLACE) && !replace_pl)
> -			/* prog to replace not found for cgroup */
> -			return -ENOENT;
> -	} else if (!list_empty(progs)) {
> -		replace_pl = list_first_entry(progs, typeof(*pl), node);
> -	}
> +	pl = find_attach_entry(progs, prog, link, replace_prog,
> +			       flags & BPF_F_ALLOW_MULTI);
> +	if (IS_ERR(pl))
> +		return PTR_ERR(pl);
>  
> -	if (bpf_cgroup_storages_alloc(storage, prog))
> +	if (bpf_cgroup_storages_alloc(storage, prog ? : link->link.prog))
>  		return -ENOMEM;
>  
> -	if (replace_pl) {
> -		pl = replace_pl;
> +	if (pl) {
> +		/* only non-link case is possible */
>  		old_prog = pl->prog;
>  		bpf_cgroup_storages_unlink(pl->storage);
>  		bpf_cgroup_storages_assign(old_storage, pl->storage);
> @@ -407,6 +472,7 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	}
>  
>  	pl->prog = prog;
> +	pl->link = link;
>  	bpf_cgroup_storages_assign(pl->storage, storage);
>  	cgrp->bpf.flags[type] = saved_flags;
>  
> @@ -414,80 +480,91 @@ int __cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (err)
>  		goto cleanup;
>  
> -	static_branch_inc(&cgroup_bpf_enabled_key);
>  	bpf_cgroup_storages_free(old_storage);
> -	if (old_prog) {
> +	if (old_prog)
>  		bpf_prog_put(old_prog);
> -		static_branch_dec(&cgroup_bpf_enabled_key);
> -	}
> -	bpf_cgroup_storages_link(storage, cgrp, type);
> +	else
> +		static_branch_inc(&cgroup_bpf_enabled_key);
> +	bpf_cgroup_storages_link(pl->storage, cgrp, type);
>  	return 0;
>  
>  cleanup:
> -	/* and cleanup the prog list */
> -	pl->prog = old_prog;
> +	if (old_prog)
> +		pl->prog = old_prog;
>  	bpf_cgroup_storages_free(pl->storage);
>  	bpf_cgroup_storages_assign(pl->storage, old_storage);
>  	bpf_cgroup_storages_link(pl->storage, cgrp, type);
> -	if (!replace_pl) {
> +	if (!old_prog) {
>  		list_del(&pl->node);
>  		kfree(pl);
>  	}
>  	return err;
>  }
>  
> +static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
> +					       struct bpf_prog *prog,
> +					       struct bpf_cgroup_link *link,
> +					       bool allow_multi)
> +{
> +	struct bpf_prog_list *pl;
> +
> +	if (!allow_multi) {
> +		if (list_empty(progs))
> +			/* report error when trying to detach and nothing is attached */
> +			return ERR_PTR(-ENOENT);
> +
> +		/* to maintain backward compatibility NONE and OVERRIDE cgroups
> +		 * allow detaching with invalid FD (prog==NULL)
> +		 */
> +		return list_first_entry(progs, typeof(*pl), node);
> +	}
> +
> +	if (!prog && !link)
> +		/* to detach MULTI prog the user has to specify valid FD
> +		 * of the program to be detached
> +		 */
> +		return ERR_PTR(-EINVAL);
> +
> +	/* find the prog and detach it */
> +	list_for_each_entry(pl, progs, node) {
> +		if (pl->prog == prog && pl->link == link)
> +			return pl;
> +	}
> +	return ERR_PTR(-ENOENT);
> +}
> +
>  /**
> - * __cgroup_bpf_detach() - Detach the program from a cgroup, and
> + * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
>   *                         propagate the change to descendants
>   * @cgrp: The cgroup which descendants to traverse
>   * @prog: A program to detach or NULL
> + * @prog: A link to detach or NULL
>   * @type: Type of detach operation
>   *
> + * At most one of @prog or @link can be non-NULL.
>   * Must be called with cgroup_mutex held.
>   */
>  int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> -			enum bpf_attach_type type)
> +			struct bpf_cgroup_link *link, enum bpf_attach_type type)
>  {
>  	struct list_head *progs = &cgrp->bpf.progs[type];
>  	u32 flags = cgrp->bpf.flags[type];
> -	struct bpf_prog *old_prog = NULL;
>  	struct bpf_prog_list *pl;
> +	struct bpf_prog *old_prog;
>  	int err;
>  
> -	if (flags & BPF_F_ALLOW_MULTI) {
> -		if (!prog)
> -			/* to detach MULTI prog the user has to specify valid FD
> -			 * of the program to be detached
> -			 */
> -			return -EINVAL;
> -	} else {
> -		if (list_empty(progs))
> -			/* report error when trying to detach and nothing is attached */
> -			return -ENOENT;
> -	}
> +	if (prog && link)
> +		/* only one of prog or link can be specified */
> +		return -EINVAL;
>  
> -	if (flags & BPF_F_ALLOW_MULTI) {
> -		/* find the prog and detach it */
> -		list_for_each_entry(pl, progs, node) {
> -			if (pl->prog != prog)
> -				continue;
> -			old_prog = prog;
> -			/* mark it deleted, so it's ignored while
> -			 * recomputing effective
> -			 */
> -			pl->prog = NULL;
> -			break;
> -		}
> -		if (!old_prog)
> -			return -ENOENT;
> -	} else {
> -		/* to maintain backward compatibility NONE and OVERRIDE cgroups
> -		 * allow detaching with invalid FD (prog==NULL)
> -		 */
> -		pl = list_first_entry(progs, typeof(*pl), node);
> -		old_prog = pl->prog;
> -		pl->prog = NULL;
> -	}
> +	pl = find_detach_entry(progs, prog, link, flags & BPF_F_ALLOW_MULTI);
> +	if (IS_ERR(pl))
> +		return PTR_ERR(pl);
> +
> +	/* mark it deleted, so it's ignored while recomputing effective */
> +	old_prog = pl->prog;
> +	pl->prog = NULL;
> +	pl->link = NULL;
>  
>  	err = update_effective_progs(cgrp, type);
>  	if (err)
> @@ -501,14 +578,15 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>  	if (list_empty(progs))
>  		/* last program was detached, reset flags to zero */
>  		cgrp->bpf.flags[type] = 0;
> -
> -	bpf_prog_put(old_prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
>  	static_branch_dec(&cgroup_bpf_enabled_key);
>  	return 0;
>  
>  cleanup:
> -	/* and restore back old_prog */
> +	/* restore back prog or link */
>  	pl->prog = old_prog;
> +	pl->link = link;
>  	return err;
>  }
>  
> @@ -521,6 +599,7 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  	struct list_head *progs = &cgrp->bpf.progs[type];
>  	u32 flags = cgrp->bpf.flags[type];
>  	struct bpf_prog_array *effective;
> +	struct bpf_prog *prog;
>  	int cnt, ret = 0, i;
>  
>  	effective = rcu_dereference_protected(cgrp->bpf.effective[type],
> @@ -551,7 +630,8 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  
>  		i = 0;
>  		list_for_each_entry(pl, progs, node) {
> -			id = pl->prog->aux->id;
> +			prog = prog_list_prog(pl);
> +			id = prog->aux->id;
>  			if (copy_to_user(prog_ids + i, &id, sizeof(id)))
>  				return -EFAULT;
>  			if (++i == cnt)
> @@ -581,8 +661,8 @@ int cgroup_bpf_prog_attach(const union bpf_attr *attr,
>  		}
>  	}
>  
> -	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, attr->attach_type,
> -				attr->attach_flags);
> +	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, NULL,
> +				attr->attach_type, attr->attach_flags);
>  
>  	if (replace_prog)
>  		bpf_prog_put(replace_prog);
> @@ -604,7 +684,7 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
>  	if (IS_ERR(prog))
>  		prog = NULL;
>  
> -	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type, 0);
> +	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type);
>  	if (prog)
>  		bpf_prog_put(prog);
>  
> @@ -612,6 +692,87 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
>  	return ret;
>  }
>  
> +static void bpf_cgroup_link_release(struct bpf_link *link)
> +{
> +	struct bpf_cgroup_link *cg_link =
> +		container_of(link, struct bpf_cgroup_link, link);
> +
> +	/* link might have been auto-detached by dying cgroup already,
> +	 * in that case our work is done here
> +	 */
> +	if (!cg_link->cgroup)
> +		return;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	/* re-check cgroup under lock again */
> +	if (!cg_link->cgroup) {
> +		mutex_unlock(&cgroup_mutex);
> +		return;
> +	}
> +
> +	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> +				    cg_link->type));
> +
> +	mutex_unlock(&cgroup_mutex);
> +	cgroup_put(cg_link->cgroup);
> +}
> +
> +static void bpf_cgroup_link_dealloc(struct bpf_link *link)
> +{
> +	struct bpf_cgroup_link *cg_link =
> +		container_of(link, struct bpf_cgroup_link, link);
> +
> +	kfree(cg_link);
> +}
> +
> +const struct bpf_link_ops bpf_cgroup_link_lops = {
> +	.release = bpf_cgroup_link_release,
> +	.dealloc = bpf_cgroup_link_dealloc,
> +};
> +
> +int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +	struct bpf_cgroup_link *link;
> +	struct file *link_file;
> +	struct cgroup *cgrp;
> +	int err, link_fd;
> +
> +	cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
> +	if (IS_ERR(cgrp))
> +		return PTR_ERR(cgrp);
> +
> +	link = kzalloc(sizeof(*link), GFP_USER);
> +	if (!link) {
> +		err = -ENOMEM;
> +		goto out_put_cgroup;
> +	}
> +	bpf_link_init(&link->link, &bpf_cgroup_link_lops, prog);
> +	link->cgroup = cgrp;
> +	link->type = attr->link_create.attach_type;
> +
> +	link_file = bpf_link_new_file(&link->link, &link_fd);
> +	if (IS_ERR(link_file)) {
> +		kfree(link);
> +		err = PTR_ERR(link_file);
> +		goto out_put_cgroup;
> +	}
> +
> +	err = cgroup_bpf_attach(cgrp, NULL, NULL, link, link->type,
> +				BPF_F_ALLOW_MULTI);
> +	if (err) {
> +		bpf_link_cleanup(&link->link, link_file, link_fd);
> +		goto out_put_cgroup;
> +	}
> +
> +	fd_install(link_fd, link_file);
> +	return link_fd;
> +
> +out_put_cgroup:
> +	cgroup_put(cgrp);
> +	return err;
> +}
> +
>  int cgroup_bpf_prog_query(const union bpf_attr *attr,
>  			  union bpf_attr __user *uattr)
>  {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index fd4181939064..f6e7d32a2632 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2173,13 +2173,6 @@ static int bpf_obj_get(const union bpf_attr *attr)
>  				attr->file_flags);
>  }
>  
> -struct bpf_link {
> -	atomic64_t refcnt;
> -	const struct bpf_link_ops *ops;
> -	struct bpf_prog *prog;
> -	struct work_struct work;
> -};
> -
>  void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
>  		   struct bpf_prog *prog)
>  {
> @@ -2193,8 +2186,8 @@ void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
>   * anon_inode's release() call. This helper manages marking bpf_link as
>   * defunct, releases anon_inode file and puts reserved FD.
>   */
> -static void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> -			     int link_fd)
> +void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
> +		      int link_fd)
>  {
>  	link->prog = NULL;
>  	fput(link_file);
> @@ -2252,7 +2245,8 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
>  #ifdef CONFIG_PROC_FS
>  static const struct bpf_link_ops bpf_raw_tp_lops;
>  static const struct bpf_link_ops bpf_tracing_link_lops;
> -static const struct bpf_link_ops bpf_xdp_link_lops;
> +
> +extern const struct bpf_link_ops bpf_cgroup_link_lops;
>  
>  static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
>  {
> @@ -2265,6 +2259,8 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
>  		link_type = "raw_tracepoint";
>  	else if (link->ops == &bpf_tracing_link_lops)
>  		link_type = "tracing";
> +	else if (link->ops == &bpf_cgroup_link_lops)
> +		link_type = "cgroup";
>  	else
>  		link_type = "unknown";
>  
> @@ -3533,6 +3529,49 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
>  	return err;
>  }
>  
> +#define BPF_LINK_CREATE_LAST_FIELD link_create.attach_type
> +static int link_create(union bpf_attr *attr)
> +{
> +	enum bpf_prog_type ptype;
> +	struct bpf_prog *prog;
> +	int ret;
> +
> +	if (CHECK_ATTR(BPF_LINK_CREATE))
> +		return -EINVAL;
> +
> +	ptype = attach_type_to_prog_type(attr->link_create.attach_type);
> +	if (ptype == BPF_PROG_TYPE_UNSPEC)
> +		return -EINVAL;
> +
> +	prog = bpf_prog_get_type(attr->link_create.prog_fd, ptype);
> +	if (IS_ERR(prog))
> +		return PTR_ERR(prog);
> +
> +	ret = bpf_prog_attach_check_attach_type(prog,
> +						attr->link_create.attach_type);
> +	if (ret)
> +		goto err_out;
> +
> +	switch (ptype) {
> +	case BPF_PROG_TYPE_CGROUP_SKB:
> +	case BPF_PROG_TYPE_CGROUP_SOCK:
> +	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> +	case BPF_PROG_TYPE_SOCK_OPS:
> +	case BPF_PROG_TYPE_CGROUP_DEVICE:
> +	case BPF_PROG_TYPE_CGROUP_SYSCTL:
> +	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +		ret = cgroup_bpf_link_attach(attr, prog);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +err_out:
> +	if (ret < 0)
> +		bpf_prog_put(prog);
> +	return ret;
> +}
> +
>  SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
>  {
>  	union bpf_attr attr = {};
> @@ -3643,6 +3682,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>  	case BPF_MAP_DELETE_BATCH:
>  		err = bpf_map_do_batch(&attr, uattr, BPF_MAP_DELETE_BATCH);
>  		break;
> +	case BPF_LINK_CREATE:
> +		err = link_create(&attr);
> +		break;
>  	default:
>  		err = -EINVAL;
>  		break;
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 3dead0416b91..219624fba9ba 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6303,27 +6303,31 @@ void cgroup_sk_free(struct sock_cgroup_data *skcd)
>  #endif	/* CONFIG_SOCK_CGROUP_DATA */
>  
>  #ifdef CONFIG_CGROUP_BPF
> -int cgroup_bpf_attach(struct cgroup *cgrp, struct bpf_prog *prog,
> -		      struct bpf_prog *replace_prog, enum bpf_attach_type type,
> +int cgroup_bpf_attach(struct cgroup *cgrp,
> +		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
> +		      struct bpf_cgroup_link *link,
> +		      enum bpf_attach_type type,
>  		      u32 flags)
>  {
>  	int ret;
>  
>  	mutex_lock(&cgroup_mutex);
> -	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, type, flags);
> +	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags);
>  	mutex_unlock(&cgroup_mutex);
>  	return ret;
>  }
> +
>  int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> -		      enum bpf_attach_type type, u32 flags)
> +		      enum bpf_attach_type type)
>  {
>  	int ret;
>  
>  	mutex_lock(&cgroup_mutex);
> -	ret = __cgroup_bpf_detach(cgrp, prog, type);
> +	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type);
>  	mutex_unlock(&cgroup_mutex);
>  	return ret;
>  }
> +
>  int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
>  		     union bpf_attr __user *uattr)
>  {
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 5d01c5c7e598..fad9f79bb8f1 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -111,6 +111,7 @@ enum bpf_cmd {
>  	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
>  	BPF_MAP_UPDATE_BATCH,
>  	BPF_MAP_DELETE_BATCH,
> +	BPF_LINK_CREATE,
>  };
>  
>  enum bpf_map_type {
> @@ -539,7 +540,7 @@ union bpf_attr {
>  		__u32		prog_cnt;
>  	} query;
>  
> -	struct {
> +	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
>  		__u64 name;
>  		__u32 prog_fd;
>  	} raw_tracepoint;
> @@ -567,6 +568,12 @@ union bpf_attr {
>  		__u64		probe_offset;	/* output: probe_offset */
>  		__u64		probe_addr;	/* output: probe_addr */
>  	} task_fd_query;
> +
> +	struct { /* struct used by BPF_LINK_CREATE command */
> +		__u32		prog_fd;	/* eBPF program to attach */
> +		__u32		target_fd;	/* object to attach to */
> +		__u32		attach_type;	/* attach type */
> +	} link_create;
>  } __attribute__((aligned(8)));
>  
>  /* The description below is an attempt at providing documentation to eBPF
> -- 
> 2.17.1
> 

-- 
Andrey Ignatov
