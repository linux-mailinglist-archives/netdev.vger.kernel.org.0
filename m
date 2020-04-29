Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D301BD419
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD2FkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:40:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725861AbgD2FkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:40:18 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T5cBKh028655;
        Tue, 28 Apr 2020 22:40:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1FZ3fbgcr52S/G2y1xwh8ycn/F4+pDdkTF6jyvk2Mm4=;
 b=dTbOq4vwXEpC/N/7B1Y51lPTqs5UP+GdImgnZXpylM3VA0xM/3MhIGKwKAd8Nbv0yzET
 EgAz4Q/2nswtLvdb7jWMla3CYPl6QmCnuQ5ZE60fkaDb/d2JiRLVHCW+QxNj2H2gIY4t
 KzHerRuQih9JojpqgPWclrguAm0QgltFkLA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30mgvnsj0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 22:40:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 22:40:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijs+xJV2QtPqq36Sh6sBPVC62oEaUDwDANPqyt6IkKlUxO82TI/MKQwLQ4ghw5WzU9tCD0B24A8i0wZN0Lyj93ja00hm2abPFamYqq/pQU4MwhA0coDnYEDKh57QmQ9MyhUJyXvQ0wuqR8L87mij/0xeSO8bw2AslKZQV3Q0GZJaOMsfwyJA8ETbhocBxMmGxil5x0J1/F7tymJUaRPEHZZFQHg4fOjjA6cI16GYt/xtaYaB9O3BSD3miN4rpyGQoCs52/OnHnAiUVr+vecYrEdn5p/MpwKTcVmwMiPGH+XxSar00M9k2O0aySzWioYqwjq8z3DKzGc44OpOIIFNjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FZ3fbgcr52S/G2y1xwh8ycn/F4+pDdkTF6jyvk2Mm4=;
 b=T7Z2Hc+LPIIRFj/Gnz71zN3518eJr8u75HYBWKver3B4/LdcDwNBdlJo8z4gJbelexT/xAo6Hhu1JEa3R0W+bnCHzbTES1qqfDfCX2Ce9cxNszPBWVRJHaC9Q5FgIFBMDWdSZckTHBaVtCNGwVg4yvBs732sfYpspr9Ve+sYfEYYghcU6rl3kdt8t83mqPG/k/eAiZvOn9tRHRStxEHHgtqRyHdo3HufgF78uGWJDs+Mcpa4p6fZuIIwZvBwomz7rkD4b3IYtaK+mXYCgxpQL+mCg4+hvkptPHxXYGd6S9n+fjGjPhNgE4ogo+Kc81ZlCE6ilqKFXCXO2opSeqVDPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FZ3fbgcr52S/G2y1xwh8ycn/F4+pDdkTF6jyvk2Mm4=;
 b=eo1bkDwDcPRXyjFDWH1nBjVshVIGfgYsUDoO+27dedB1+cEIBWP5zb4EfSrXLtBo2rzonixOluCuVTawnmGqvdGrouD8OobRFn5lU0VSNHH+7cXe7h7DN425koPauATEsNlRi9PXxYDxtPaRD/X+qAEu2iw2fhNM2R+gqFi5rq8=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3818.namprd15.prod.outlook.com (2603:10b6:303:47::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 05:39:50 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 05:39:50 +0000
Date:   Tue, 28 Apr 2020 22:39:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
Message-ID: <20200429053948.gmyxmh57t7v6nayg@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201242.2995160-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427201242.2995160-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:301:4c::26) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1f77) by MWHPR15CA0064.namprd15.prod.outlook.com (2603:10b6:301:4c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 05:39:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:1f77]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ea05681-a2ed-4d88-09af-08d7ebffbbf2
X-MS-TrafficTypeDiagnostic: MW3PR15MB3818:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38187F875C0DCC9034EF4688D5AD0@MW3PR15MB3818.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(396003)(366004)(136003)(346002)(376002)(186003)(16526019)(52116002)(66556008)(66946007)(66476007)(6496006)(54906003)(316002)(8676002)(8936002)(9686003)(4326008)(55016002)(6862004)(478600001)(86362001)(33716001)(6636002)(2906002)(5660300002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v5VttMsg0yjOSP8t6asMFzWjv4wXM4gnsBEPUru8JARPJ3u9uOAUJ8s7npxeIZCh7nMdvFRwj1IMe85yuLKIAXMucOaxdYSAq710BN+l7SkpFMQ7hbXaZlggxzzQqWJAFYzItzj7SYX0XiyTPFyCMxGKAGEHTiBBo4aGLG3rVpEGZN2Y7sT132kciW3nCmavNuHn9JlzwPVXYwMnvD+cRL2rFUrEjKm7Vm+11eYLGCZELZfPPexowo7FaWR/HoY2ZFIggtqP9BfSOq3OqhyCB9QPB0LyDSJRqaW2bDgLgmvUjBKsCp3LnLW3d1z5LNH4PuiKPENkCTAJ98WvW8Ui7GE8eSgxBHY0EHvYfNEg3iS2dGr/1mkJ0kIJEIXTn7niQGNFgWBYVh6/+OXBTrS7KnYbGn6lNyNIibJtn8mQhMgfYKXZOCdsenP8qYlt90gL
X-MS-Exchange-AntiSpam-MessageData: Ir617xH2Cy1WO+JOVjUNm9nH5RDDdL8PSKxTG+Jj00DKbkjNOeya3+SREmdBcyLCYOa5sGdmymfFxW6pV/1lSlfINP3+/ZNHBooxApq0708PhszhJ5LpDiO9jVP+6bXObfkcge+qIknzUwDgMfrtcN0H2Vep7VbjasJRebR9Ljx9SV595TbUJpk7GlVP57IFbbvQqaaKrBjDqaemM8SskhM7z0qtvSid3r/iApdJHegEjOpYMIzD76KhyIqBfFjX2PU5N7j47CpC+Sh+x3sQViwwkF5hiM7u8gZM5ZDUdHS+UeNT7OA7ufCRS+Q58dEyF2c0SzBe2+e+lnITPJGFGOA689iMZ/tKFB1mL583PbMEDnMpPZIuYxuioyKLFch/2ltz0SSQ4iKEM0jnG4s0x6DgUx4GSpZeCBF104i7c0O6pzI5o0fvekcRpvyurzoRxk+88Wf03HuD0el1fuV+Anxh6tcn0fJdibTnNzWpa239k96Be79KhwmBZew7N1Rd6bMTu2W3GPIVv5ykFk5RY6nq6kniKMkaP/gELzw4s7wmP1rk8dpXF7XYcpAmQUlL7qO5es36UtklGLOHMMdnbDzLjIDBUuS2UZCHjNmpV55EolJosxcWkU8u5EkrdTHgLkqQMwsVldrY2TKDaVMjAik2j5n10I2uCGGcvPRdYqy0f/CWu2yEvGmf/+MeTBYVW0yjS634qhlHa0MEJtdxw5dU0TldRFc0Gaej/0k6ddsTMTd9k8BnJALDWAYM2mcUvkd4Ak0L7ag+bDa680lLju0+BuuCarLpWXOrshzudVKdARJbpNKmZLFiqP69asdJ0JHgtQI5ikTS6D1Bgx/SIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea05681-a2ed-4d88-09af-08d7ebffbbf2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 05:39:50.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nLW1nMCvdIBEMprEn5VN11UkWG/EUeUHyFg5sfM6TmKxWFfKBUC9yjS7LzjcJPQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3818
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:12:42PM -0700, Yonghong Song wrote:
> A new bpf command BPF_ITER_CREATE is added.
> 
> The anonymous bpf iterator is seq_file based.
> The seq_file private data are referenced by targets.
> The bpf_iter infrastructure allocated additional space
> at seq_file->private after the space used by targets
> to store some meta data, e.g.,
>   prog:       prog to run
>   session_id: an unique id for each opened seq_file
>   seq_num:    how many times bpf programs are queried in this session
>   has_last:   indicate whether or not bpf_prog has been called after
>               all valid objects have been processed
> 
> A map between file and prog/link is established to help
> fops->release(). When fops->release() is called, just based on
> inode and file, bpf program cannot be located since target
> seq_priv_size not available. This map helps retrieve the prog
> whose reference count needs to be decremented.
How about putting "struct extra_priv_data" at the beginning of
the seq_file's private store instead since its size is known.
seq->private can point to an aligned byte after
+sizeof(struct extra_priv_data).

[ ... ]

> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index fc1ce5ee5c3f..1f4e778d1814 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c

[ ... ]

> @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
>  /* protect bpf_iter_link.link->prog upddate */
>  static struct mutex bpf_iter_mutex;
>  
> +/* Since at anon seq_file release function, the prog cannot
> + * be retrieved since target seq_priv_size is not available.
> + * Keep a list of <anon_file, prog> mapping, so that
> + * at file release stage, the prog can be released properly.
> + */
> +static struct list_head anon_iter_info;
> +static struct mutex anon_iter_info_mutex;
> +
> +/* incremented on every opened seq_file */
> +static atomic64_t session_id;
> +
> +static u32 get_total_priv_dsize(u32 old_size)
> +{
> +	return roundup(old_size, 8) + sizeof(struct extra_priv_data);
> +}
> +
> +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
> +{
> +	return old_ptr + roundup(old_size, 8);
> +}
> +
> +static int anon_iter_release(struct inode *inode, struct file *file)
> +{
> +	struct anon_file_prog_assoc *finfo;
> +
> +	mutex_lock(&anon_iter_info_mutex);
> +	list_for_each_entry(finfo, &anon_iter_info, list) {
> +		if (finfo->file == file) {
> +			bpf_prog_put(finfo->prog);
> +			list_del(&finfo->list);
> +			kfree(finfo);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&anon_iter_info_mutex);
> +
> +	return seq_release_private(inode, file);
> +}
> +
> +static const struct file_operations anon_bpf_iter_fops = {
> +	.read		= seq_read,
> +	.release	= anon_iter_release,
> +};
> +
>  int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>  {
>  	struct bpf_iter_target_info *tinfo;

[ ... ]

> @@ -150,3 +223,90 @@ int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>  	mutex_unlock(&bpf_iter_mutex);
>  	return ret;
>  }
> +
> +static void init_seq_file(void *priv_data, struct bpf_iter_target_info *tinfo,
> +			  struct bpf_prog *prog)
> +{
> +	struct extra_priv_data *extra_data;
> +
> +	if (tinfo->target_feature & BPF_DUMP_SEQ_NET_PRIVATE)
> +		set_seq_net_private((struct seq_net_private *)priv_data,
> +				    current->nsproxy->net_ns);
> +
> +	extra_data = get_extra_priv_dptr(priv_data, tinfo->seq_priv_size);
> +	extra_data->session_id = atomic64_add_return(1, &session_id);
> +	extra_data->prog = prog;
> +	extra_data->seq_num = 0;
> +	extra_data->has_last = false;
> +}
> +
> +static int prepare_seq_file(struct file *file, struct bpf_iter_link *link)
> +{
> +	struct anon_file_prog_assoc *finfo;
> +	struct bpf_iter_target_info *tinfo;
> +	struct bpf_prog *prog;
> +	u32 total_priv_dsize;
> +	void *priv_data;
> +
> +	finfo = kmalloc(sizeof(*finfo), GFP_USER | __GFP_NOWARN);
> +	if (!finfo)
> +		return -ENOMEM;
> +
> +	mutex_lock(&bpf_iter_mutex);
> +	prog = link->link.prog;
> +	bpf_prog_inc(prog);
> +	mutex_unlock(&bpf_iter_mutex);
> +
> +	tinfo = link->tinfo;
> +	total_priv_dsize = get_total_priv_dsize(tinfo->seq_priv_size);
> +	priv_data = __seq_open_private(file, tinfo->seq_ops, total_priv_dsize);
> +	if (!priv_data) {
> +		bpf_prog_sub(prog, 1);
Could prog's refcnt go 0 here?  If yes, bpf_prog_put() should be used.

> +		kfree(finfo);
> +		return -ENOMEM;
> +	}
> +
> +	init_seq_file(priv_data, tinfo, prog);
> +
> +	finfo->file = file;
> +	finfo->prog = prog;
> +
> +	mutex_lock(&anon_iter_info_mutex);
> +	list_add(&finfo->list, &anon_iter_info);
> +	mutex_unlock(&anon_iter_info_mutex);
> +	return 0;
> +}
> +
