Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC31BD196
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgD2BR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:17:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34686 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgD2BR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:17:29 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1E8D0019627;
        Tue, 28 Apr 2020 18:17:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WS4NwveU0M08DVn0z+6e71hek9whFU1eJzOV444qwKI=;
 b=qUd6F3W3F4+UNPnC6IIWVYdEApBFwjztiJniI/ZVpSZ81UgsB4ytq/YhOdJXWeVzprAh
 RXXOhqE2KSh4aqs+ae5Tl1gtcSEqW/BHLC+XP2BKnzAYQcmDzqhde9Ct3Jl5oc8kAr4v
 zaBHRvOp+9NE2lS9/BGFfpZEobmX6rRZmwQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57pka6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 18:17:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:17:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4UimEarEPeWmIHV6WLgFZC7wTAz23eKpYDS0SgAkL4p3WZpWImkXHfGP5c/s/Ii59ch0caNVrSkG+kjYj4cMWqLBfkKLlDY1Nn6v+AyJ/8oEkFXvYZTQyl6SN+r77JhzrNG//cyyhNn0LOzDy1gWGLq3AAyg9frpW5OAmlEiAFRwW3008BL+jgEDs5cZi5iaetvLBqpyKYKxJMeEuepNvN0ISLem06ZUxgxk0KLS32/qQb/z4za9tChUm1j9MXWaIQJD2cq+FtdLgOOfexHJa4gfG/vRYEDAgTq/6MtjK7yNRE1wIVGWl3YkwPmMoAJRWoLpLLGDYroQ3mZnLhJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS4NwveU0M08DVn0z+6e71hek9whFU1eJzOV444qwKI=;
 b=bpcl9IveBoa6D2HDZ6HNyx/j5kjqxXxipGNCLNzJ1xFH6fU383/lWQR7jufFJFf54ZnC5YWv9nlYRrG9WgH06FlM/Glg6nqUwWlJgDIcbqPAZ82XR3LMb7LRom4vLW3QpcD6okTdh4Hx+tm/jM3yP+ahOpvfo9ooAu9SJRxqtrR4y9AnH7Wx5lyyVjwD0k2uhTC/fDKGsQRicTtTZ1XvrTLqwX550MxrfxGZ0ELoL7tfUO45F7ChgAUjh6E7DpIoFiGgAlwVL6j9UZgvVVrY8o+GZXZolxHXSegIPgJdHqZfianzCnOmzRdbRQE3b0ug9gR4r6JTt2sv/1J//0rnHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS4NwveU0M08DVn0z+6e71hek9whFU1eJzOV444qwKI=;
 b=LJRGJZ6PBsVHS49nRSU+cr7Z0K2fwg2LUAO5swIfdo1XHWCTI2UXmRsMVQbTaBsUMs573Nll54g9B+TI1LgRr0xTNjwWaulAsCqacbBVhS91/ndXxv0q4Nwng3inkjeiLX385iebhqDjAKMPSAcr9SLRL9b/tukdkxebahIE4/E=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (20.181.50.216) by
 MW3PR15MB3833.namprd15.prod.outlook.com (20.181.50.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Wed, 29 Apr 2020 01:17:13 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 01:17:14 +0000
Date:   Tue, 28 Apr 2020 18:17:11 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next v1 05/19] bpf: support bpf
 tracing/iter programs for BPF_LINK_CREATE
Message-ID: <20200429011711.f3sbh4qdj7k2kapu@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201240.2994985-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201240.2994985-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR10CA0066.namprd10.prod.outlook.com
 (2603:10b6:300:2c::28) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:950c) by MWHPR10CA0066.namprd10.prod.outlook.com (2603:10b6:300:2c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 01:17:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:950c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3794287a-68ad-409e-bd56-08d7ebdb0c4b
X-MS-TrafficTypeDiagnostic: MW3PR15MB3833:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB383323D298F472C5DE3BC120D5AD0@MW3PR15MB3833.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(376002)(366004)(136003)(346002)(478600001)(2906002)(5660300002)(86362001)(186003)(316002)(9686003)(8676002)(1076003)(4326008)(55016002)(52116002)(33716001)(66476007)(8936002)(66556008)(66946007)(16526019)(6862004)(54906003)(6496006)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3Fwyqka14pQt9KQhwqBqrcObqWx5K8NrXqjThRUL1BwDoaekPGlq3+0YRDtZxZVTLvytiDXHhrqgpUyMSGKQQ+Ogr8g1gtzYLopHCN4vl/nueHgCSmGL6Hh6+1z+9WmNqg8FPOpL5pqjUyJhatfd6trKFq+qG+PbY36NIC2kGTBcLrhw+hlxeAXubCKsVU+Q/x12eua4AWl5CNuut4+JZafWIWyzV8ptD1BeD22qiFY5rO+kLj1Kw22ZZk45wR/e3IVyl/JlQ8hVbalCGlqtopBBxs2MH3pZqi/GGNvO0e4SkPbKmVrY+azFwi6XPBYoQ7TqhhVgafYHGZPhwzgB9DfhzU2RsjcFQ7qBBT+2z5ZiU4UQJ0T4w/xodzPjzvHn6a5B9o+5Od0Sn6MfsN5Wt8vyfv6M7f/1aHzmyl3i2oiYpXNnjDyG2wh8ZUH3ted
X-MS-Exchange-AntiSpam-MessageData: 4qEbpf3NbmPNB1sZse7xDMtBaMJAWfDEgpbjJ7rRwxNUcTWqlimPzFIi+MTaGCLHWU/EwglnioCqwvwmx49qDHGrxQJ2veA+101UvTbgdJs90/lwQB8kP0TwFUblzMhcVsFsXyOD2M2pUtBw8CCNxI6IGNvGbfGvskVfc85HnsEC9hCIs2Co3+k7NCAPTTC/fsYN1uwcAxgVQfw85AzX+KXHBSCKcjGRwTDQ5YF/TKotGWXictMMIICQ0lIL6aRuauWsaW9t7UhmakHm8hQFtxa9Gn+KLnyvDXrmXuFhRxzk7apZUumW94FVGkX6HU8jLFQgfPOugJQAsz6EW6IEDE7FKPNRUHNKwq1MV2ofk4IGYsjS4L7u7pnNbccub8j3BYQca0ksCVxlUl61n7E95rJQoTgvbk6fitdJYmToUUEwEPK4JYQMtz/SK5qQqVVo8Ony6Xu3kSKbAVEgwjFUS+LHDOh72OiBJVyXXxP725t17k4EJ4mUl4OLtMCVXAxFAGeZWDtFMIh6m8zGetLDhdPYvZLdGFIHrIlpDmW5F64mQGFL9Ww3ZH+9kg/hlhD6zhFs7YnCoXMuw8k4apOeIA5lnrT+6jo9iGei2S2AlKpNI37eWiH2lYlYclpk2ml0OxglSz4KtAGh2wpyqjhmEbeKaWuHbQZYHl7fpBB8qYbvhRqXXAHPAb06dgfgfZ0AH8EFfZBcLSKhBgrzpCa0M8gaNxBhPxbx9HVZvqxPvrem0KigPOkXuHvfREMg3oA1cpVUEiDVFbNw58nKjCqEnvO1sC5JIpGMi2I/snPVT+FCIIrvCJIAHUsNeVOHj9f6S5+UMZ1xA+I32X1LS/xgSg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3794287a-68ad-409e-bd56-08d7ebdb0c4b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 01:17:13.8335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TljnFAPQDghGgbqOvevxXFykH3IfyYziYM/bumJWqmYBUCkHu98ETII3cidKb1LB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3833
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=2 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:12:40PM -0700, Yonghong Song wrote:
> Given a bpf program, the step to create an anonymous bpf iterator is:
>   - create a bpf_iter_link, which combines bpf program and the target.
>     In the future, there could be more information recorded in the link.
>     A link_fd will be returned to the user space.
>   - create an anonymous bpf iterator with the given link_fd.
> 
> The anonymous bpf iterator (and its underlying bpf_link) will be
> used to create file based bpf iterator as well.
> 
> The benefit to use of bpf_iter_link:
>   - for file based bpf iterator, bpf_iter_link provides a standard
>     way to replace underlying bpf programs.
>   - for both anonymous and free based iterators, bpf link query
>     capability can be leveraged.
> 
> The patch added support of tracing/iter programs for  BPF_LINK_CREATE.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/bpf_iter.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c  | 15 ++++++++++++
>  3 files changed, 71 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4ac8d61f7c3e..60ecb73d8f6d 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1034,6 +1034,7 @@ extern const struct file_operations bpf_prog_fops;
>  extern const struct bpf_prog_ops bpf_offload_prog_ops;
>  extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
>  extern const struct bpf_verifier_ops xdp_analyzer_ops;
> +extern const struct bpf_link_ops bpf_iter_link_lops;
>  
>  struct bpf_prog *bpf_prog_get(u32 ufd);
>  struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
> @@ -1129,6 +1130,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
>  struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>  				   u64 *session_id, u64 *seq_num, bool is_last);
>  int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>  
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 284c95587803..9532e7bcb8e1 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -14,6 +14,11 @@ struct bpf_iter_target_info {
>  	u32 target_feature;
>  };
>  
> +struct bpf_iter_link {
> +	struct bpf_link link;
> +	struct bpf_iter_target_info *tinfo;
> +};
> +
>  static struct list_head targets;
>  static struct mutex targets_mutex;
>  static bool bpf_iter_inited = false;
> @@ -67,3 +72,52 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
>  
>  	return ret;
>  }
> +
> +static void bpf_iter_link_release(struct bpf_link *link)
> +{
> +}
> +
> +static void bpf_iter_link_dealloc(struct bpf_link *link)
> +{
> +}
> +
> +const struct bpf_link_ops bpf_iter_link_lops = {
> +	.release = bpf_iter_link_release,
> +	.dealloc = bpf_iter_link_dealloc,
> +};
> +
> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +	struct bpf_iter_target_info *tinfo;
> +	struct bpf_iter_link *link;
> +	const char *func_name;
> +	bool existed = false;
> +	int err;
> +
> +	if (attr->link_create.target_fd || attr->link_create.flags)
> +		return -EINVAL;
> +
> +	func_name = prog->aux->attach_func_name;
> +	mutex_lock(&targets_mutex);
> +	list_for_each_entry(tinfo, &targets, list) {
> +		if (!strcmp(tinfo->target_func_name, func_name)) {
This can be done in prog load time.

Also, is it better to store a btf_id at tinfo instead of doing strcmp here?

> +			existed = true;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&targets_mutex);
> +	if (!existed)
> +		return -ENOENT;
> +
> +	link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
> +	if (!link)
> +		return -ENOMEM;
> +
> +	bpf_link_init(&link->link, &bpf_iter_link_lops, prog);
> +	link->tinfo = tinfo;
> +
> +	err = bpf_link_new_fd(&link->link);
> +	if (err < 0)
> +		kfree(link);
> +	return err;
> +}
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 022187640943..8741b5e11c85 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2269,6 +2269,8 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
>  	else if (link->ops == &bpf_cgroup_link_lops)
>  		link_type = "cgroup";
>  #endif
> +	else if (link->ops == &bpf_iter_link_lops)
> +		link_type = "iter";
>  	else
>  		link_type = "unknown";
>  
> @@ -2597,6 +2599,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>  	case BPF_CGROUP_GETSOCKOPT:
>  	case BPF_CGROUP_SETSOCKOPT:
>  		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
> +	case BPF_TRACE_ITER:
> +		return BPF_PROG_TYPE_TRACING;
>  	default:
>  		return BPF_PROG_TYPE_UNSPEC;
>  	}
> @@ -3571,6 +3575,14 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
>  	return err;
>  }
>  
> +static int tracing_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +	if (attr->link_create.attach_type == BPF_TRACE_ITER)
Has prog->expected_attach_type been checked also?

> +		return bpf_iter_link_attach(attr, prog);
> +
> +	return -EINVAL;
> +}
> +
>  #define BPF_LINK_CREATE_LAST_FIELD link_create.flags
>  static int link_create(union bpf_attr *attr)
>  {
> @@ -3607,6 +3619,9 @@ static int link_create(union bpf_attr *attr)
>  	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>  		ret = cgroup_bpf_link_attach(attr, prog);
>  		break;
> +	case BPF_PROG_TYPE_TRACING:
> +		ret = tracing_bpf_link_attach(attr, prog);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> -- 
> 2.24.1
> 
