Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CA2318E3
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 03:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfFAB2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 21:28:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58744 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbfFAB2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 21:28:23 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x511Ji8v015846;
        Fri, 31 May 2019 18:27:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QH9Ls4QnXX3WJz6s4GS5x2eBqiVoVK/KSrofik2YrF4=;
 b=XEN6qd6maIi3XQT07tpyYPnyOhOZVVnwimKS8OufEHHcyq8LvS4kio7z+tTlhma/iP3c
 vL2Rh3VoQJIPw3Cw0QEMmwS3WPSOa0YHQyo1q5qq5wPFJaJd/S7FECTCWmSvOgOe/g7v
 QrcWOH/1IbjMLkEpo9uEBr72S3PLqi6ZONE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2subm50sv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 18:27:32 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 31 May 2019 18:27:31 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 31 May 2019 18:27:30 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 31 May 2019 18:27:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QH9Ls4QnXX3WJz6s4GS5x2eBqiVoVK/KSrofik2YrF4=;
 b=csKgfzYsrrp2T5/RC9l2QKyBVnCZSQhIWSpMYZ7C9N+pozriLJxBA+yw/uDqD5tcRQ7QGF3Ovmdyh3OmtU/ssrtwWVYORTtiqzJyt5feQi7+djzbLLBMguZEbqTqB1mZXgw+JIxlZlZGpAUfjWNzRC68W+2Ko5ueKaREsthidQ8=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1562.namprd15.prod.outlook.com (10.173.221.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Sat, 1 Jun 2019 01:27:29 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661%4]) with mapi id 15.20.1943.016; Sat, 1 Jun 2019
 01:27:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Matt Mullins <mmullins@fb.com>
CC:     Andrew Hall <hall@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Thread-Topic: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Thread-Index: AQHVGAF5Ri5mkc0O1EinvOYIiQfGfqaGAlYA
Date:   Sat, 1 Jun 2019 01:27:29 +0000
Message-ID: <B719E003-E100-463E-A921-E59189572181@fb.com>
References: <20190531223735.4998-1-mmullins@fb.com>
In-Reply-To: <20190531223735.4998-1-mmullins@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::4b5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 108295b9-dcbc-4a3c-e02c-08d6e6304ffb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1562;
x-ms-traffictypediagnostic: DM5PR15MB1562:
x-microsoft-antispam-prvs: <DM5PR15MB15620D0EBE5B48D2AE8598BAB31A0@DM5PR15MB1562.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(396003)(366004)(376002)(199004)(189003)(51914003)(25786009)(54906003)(99286004)(76176011)(14454004)(76116006)(91956017)(6636002)(37006003)(256004)(14444005)(66476007)(66946007)(5024004)(66446008)(66556008)(64756008)(446003)(73956011)(6862004)(2616005)(68736007)(86362001)(46003)(53936002)(11346002)(476003)(6246003)(486006)(36756003)(478600001)(6512007)(102836004)(316002)(71200400001)(2906002)(4326008)(81156014)(81166006)(71190400001)(186003)(50226002)(82746002)(8676002)(8936002)(6116002)(6506007)(7736002)(5660300002)(6486002)(83716004)(229853002)(6436002)(53546011)(33656002)(57306001)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1562;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EODrS++LOpqxRlq/bzqYAUEanJmW9ZsMRMGASrSqXFkmpSVG1HI/6dGACSu2nriEc+Z1bZ8xvpeph4wrhkySwUpp7lsBjSUDQid3DcIPgiiMq7aMxaKW1cUGiFLXlEQGgbxDd2KAV28O6bnbckHVGZnXJhOqPvwuZC78PGRYWQXVKZe6prsrD9ncnqQKg+KRwbWJl9vGUnOHWFHLkegGuGGt++sUnGZLnMjwWsIbJrTCcNUeSI2lPPdEFn5g4wMFMJYkK1ij5PFKLuwIDczPvpakpsk4Xw0PgZg/pqtBtiq5sA6nsw7D3YpyQIP3LQ8/oZMSaKEipmeF+ZXPOQmlNXiVSqkxM+v5mO7qMeghSUG39yNbX5Ty7rLpXdS7LivrJcXJNVynINPKZfV2lyAh0gPNJ6u/yIGLvJNrCBkzWQY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4D1213DC839D614D89889BC474182A7C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 108295b9-dcbc-4a3c-e02c-08d6e6304ffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 01:27:29.2448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1562
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906010009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 31, 2019, at 3:37 PM, Matt Mullins <mmullins@fb.com> wrote:
>=20
> It is possible that a BPF program can be called while another BPF
> program is executing bpf_perf_event_output.  This has been observed with
> I/O completion occurring as a result of an interrupt:
>=20
> 	bpf_prog_247fd1341cddaea4_trace_req_end+0x8d7/0x1000
> 	? trace_call_bpf+0x82/0x100
> 	? sch_direct_xmit+0xe2/0x230
> 	? blk_mq_end_request+0x1/0x100
> 	? blk_mq_end_request+0x5/0x100
> 	? kprobe_perf_func+0x19b/0x240
> 	? __qdisc_run+0x86/0x520
> 	? blk_mq_end_request+0x1/0x100
> 	? blk_mq_end_request+0x5/0x100
> 	? kprobe_ftrace_handler+0x90/0xf0
> 	? ftrace_ops_assist_func+0x6e/0xe0
> 	? ip6_input_finish+0xbf/0x460
> 	? 0xffffffffa01e80bf
> 	? nbd_dbg_flags_show+0xc0/0xc0 [nbd]
> 	? blkdev_issue_zeroout+0x200/0x200
> 	? blk_mq_end_request+0x1/0x100
> 	? blk_mq_end_request+0x5/0x100
> 	? flush_smp_call_function_queue+0x6c/0xe0
> 	? smp_call_function_single_interrupt+0x32/0xc0
> 	? call_function_single_interrupt+0xf/0x20
> 	? call_function_single_interrupt+0xa/0x20
> 	? swiotlb_map_page+0x140/0x140
> 	? refcount_sub_and_test+0x1a/0x50
> 	? tcp_wfree+0x20/0xf0
> 	? skb_release_head_state+0x62/0xc0
> 	? skb_release_all+0xe/0x30
> 	? napi_consume_skb+0xb5/0x100
> 	? mlx5e_poll_tx_cq+0x1df/0x4e0
> 	? mlx5e_poll_tx_cq+0x38c/0x4e0
> 	? mlx5e_napi_poll+0x58/0xc30
> 	? mlx5e_napi_poll+0x232/0xc30
> 	? net_rx_action+0x128/0x340
> 	? __do_softirq+0xd4/0x2ad
> 	? irq_exit+0xa5/0xb0
> 	? do_IRQ+0x7d/0xc0
> 	? common_interrupt+0xf/0xf
> 	</IRQ>
> 	? __rb_free_aux+0xf0/0xf0
> 	? perf_output_sample+0x28/0x7b0
> 	? perf_prepare_sample+0x54/0x4a0
> 	? perf_event_output+0x43/0x60
> 	? bpf_perf_event_output_raw_tp+0x15f/0x180
> 	? blk_mq_start_request+0x1/0x120
> 	? bpf_prog_411a64a706fc6044_should_trace+0xad4/0x1000
> 	? bpf_trace_run3+0x2c/0x80
> 	? nbd_send_cmd+0x4c2/0x690 [nbd]
>=20
> This also cannot be alleviated by further splitting the per-cpu
> perf_sample_data structs (as in commit 283ca526a9bd ("bpf: fix
> corruption on concurrent perf_event_output calls")), as a raw_tp could
> be attached to the block:block_rq_complete tracepoint and execute during
> another raw_tp.  Instead, keep a pre-allocated perf_sample_data
> structure per perf_event_array element and fail a bpf_perf_event_output
> if that element is concurrently being used.
>=20
> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_da=
ta")
> Signed-off-by: Matt Mullins <mmullins@fb.com>

This looks great. Thanks for the fix.=20

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> v1->v2:
> 	keep a pointer to the struct perf_sample_data rather than directly
> 	embedding it in the structure, avoiding the circular include and
> 	removing the need for in_use.  Suggested by Song.
>=20
> include/linux/bpf.h      |  1 +
> kernel/bpf/arraymap.c    |  3 ++-
> kernel/trace/bpf_trace.c | 29 ++++++++++++++++-------------
> 3 files changed, 19 insertions(+), 14 deletions(-)
>=20
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4fb3aa2dc975..47fd85cfbbaf 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -472,6 +472,7 @@ struct bpf_event_entry {
> 	struct file *perf_file;
> 	struct file *map_file;
> 	struct rcu_head rcu;
> +	struct perf_sample_data *sd;
> };
>=20
> bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_=
prog *fp);
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 584636c9e2eb..c7f5d593e04f 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -654,11 +654,12 @@ static struct bpf_event_entry *bpf_event_entry_gen(=
struct file *perf_file,
> {
> 	struct bpf_event_entry *ee;
>=20
> -	ee =3D kzalloc(sizeof(*ee), GFP_ATOMIC);
> +	ee =3D kzalloc(sizeof(*ee) + sizeof(struct perf_sample_data), GFP_ATOMI=
C);
> 	if (ee) {
> 		ee->event =3D perf_file->private_data;
> 		ee->perf_file =3D perf_file;
> 		ee->map_file =3D map_file;
> +		ee->sd =3D (void *)ee + sizeof(*ee);
> 	}
>=20
> 	return ee;
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f92d6ad5e080..076f8e987355 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -410,17 +410,17 @@ static const struct bpf_func_proto bpf_perf_event_r=
ead_value_proto =3D {
> 	.arg4_type	=3D ARG_CONST_SIZE,
> };
>=20
> -static DEFINE_PER_CPU(struct perf_sample_data, bpf_trace_sd);
> -
> static __always_inline u64
> __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
> -			u64 flags, struct perf_sample_data *sd)
> +			u64 flags, struct perf_raw_record *raw)
> {
> 	struct bpf_array *array =3D container_of(map, struct bpf_array, map);
> 	unsigned int cpu =3D smp_processor_id();
> 	u64 index =3D flags & BPF_F_INDEX_MASK;
> 	struct bpf_event_entry *ee;
> 	struct perf_event *event;
> +	struct perf_sample_data *sd;
> +	u64 ret;
>=20
> 	if (index =3D=3D BPF_F_CURRENT_CPU)
> 		index =3D cpu;
> @@ -439,13 +439,22 @@ __bpf_perf_event_output(struct pt_regs *regs, struc=
t bpf_map *map,
> 	if (unlikely(event->oncpu !=3D cpu))
> 		return -EOPNOTSUPP;
>=20
> -	return perf_event_output(event, sd, regs);
> +	sd =3D xchg(&ee->sd, NULL);
> +	if (!sd)
> +		return -EBUSY;
> +
> +	perf_sample_data_init(sd, 0, 0);
> +	sd->raw =3D raw;
> +
> +	ret =3D perf_event_output(event, sd, regs);
> +
> +	xchg(&ee->sd, sd);
> +	return ret;
> }
>=20
> BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map =
*, map,
> 	   u64, flags, void *, data, u64, size)
> {
> -	struct perf_sample_data *sd =3D this_cpu_ptr(&bpf_trace_sd);
> 	struct perf_raw_record raw =3D {
> 		.frag =3D {
> 			.size =3D size,
> @@ -456,10 +465,8 @@ BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, =
regs, struct bpf_map *, map,
> 	if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
> 		return -EINVAL;
>=20
> -	perf_sample_data_init(sd, 0, 0);
> -	sd->raw =3D &raw;
>=20
> -	return __bpf_perf_event_output(regs, map, flags, sd);
> +	return __bpf_perf_event_output(regs, map, flags, &raw);
> }
>=20
> static const struct bpf_func_proto bpf_perf_event_output_proto =3D {
> @@ -474,12 +481,10 @@ static const struct bpf_func_proto bpf_perf_event_o=
utput_proto =3D {
> };
>=20
> static DEFINE_PER_CPU(struct pt_regs, bpf_pt_regs);
> -static DEFINE_PER_CPU(struct perf_sample_data, bpf_misc_sd);
>=20
> u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta=
_size,
> 		     void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
> {
> -	struct perf_sample_data *sd =3D this_cpu_ptr(&bpf_misc_sd);
> 	struct pt_regs *regs =3D this_cpu_ptr(&bpf_pt_regs);
> 	struct perf_raw_frag frag =3D {
> 		.copy		=3D ctx_copy,
> @@ -497,10 +502,8 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags,=
 void *meta, u64 meta_size,
> 	};
>=20
> 	perf_fetch_caller_regs(regs);
> -	perf_sample_data_init(sd, 0, 0);
> -	sd->raw =3D &raw;
>=20
> -	return __bpf_perf_event_output(regs, map, flags, sd);
> +	return __bpf_perf_event_output(regs, map, flags, &raw);
> }
>=20
> BPF_CALL_0(bpf_get_current_task)
> --=20
> 2.17.1
>=20

