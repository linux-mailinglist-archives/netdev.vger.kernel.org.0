Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AF630577
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfE3X3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:29:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726029AbfE3X3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:29:10 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4UNReEf013030;
        Thu, 30 May 2019 16:28:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/exG9gJ65fB0Jr1FLHODrwnHMba5ynKZomi0UkycQBU=;
 b=jg2TocgFMM2DB2yrlk4KrLCH/uRxR6unq1bfV93u7Tpc/ZEXeZ0eVFnhUgN4dl+OE6kM
 q8g2cvHyiA6EI1R/o1c7L8mJt7xjfdjtOK21zhjngetM/2gv7uJGhtc7yGAhGgemYK7O
 rJ236cLbyc5XaLYUmQNsb8jONCok+cqKokI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2stnvh0jxt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 16:28:21 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 30 May 2019 16:28:20 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 30 May 2019 16:28:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/exG9gJ65fB0Jr1FLHODrwnHMba5ynKZomi0UkycQBU=;
 b=aynsbyQg4bPYut5fKABC2GK7BeJ6myukUr9hIOSvmEJ6AJiPBgseZ2Yp80DhnMBLvePhhwF0gS4VrjmLgwykkorkC0W1t1kh4tjQEo/huectifdJIVS1rkj/F3iKoRamXZLDiMb+ASJoPEsj61bsHvDiGFN+sEzEZFZfsi1SCeI=
Received: from BN6PR15MB1154.namprd15.prod.outlook.com (10.172.208.137) by
 BN6PR15MB1249.namprd15.prod.outlook.com (10.172.206.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 23:28:15 +0000
Received: from BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd]) by BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd%2]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 23:28:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Matt Mullins <mmullins@fb.com>
CC:     Andrew Hall <hall@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH bpf] bpf: preallocate a perf_sample_data per event fd
Thread-Topic: [PATCH bpf] bpf: preallocate a perf_sample_data per event fd
Thread-Index: AQHVFzrpDfHJAGsBvUevK1n6XjMoWqaEUD4A
Date:   Thu, 30 May 2019 23:28:14 +0000
Message-ID: <E5BC8108-4E9A-416C-B12C-945091E31B0A@fb.com>
References: <20190530225549.23014-1-mmullins@fb.com>
In-Reply-To: <20190530225549.23014-1-mmullins@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:956d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd96e88-9e32-45a8-ff36-08d6e5567d30
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR15MB1249;
x-ms-traffictypediagnostic: BN6PR15MB1249:
x-microsoft-antispam-prvs: <BN6PR15MB1249BA40D55122DF5F4005AAB3180@BN6PR15MB1249.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(376002)(39860400002)(199004)(189003)(186003)(2906002)(6116002)(53936002)(83716004)(99286004)(46003)(14454004)(11346002)(5660300002)(71200400001)(71190400001)(478600001)(53546011)(25786009)(305945005)(446003)(6636002)(6506007)(33656002)(476003)(7736002)(6246003)(486006)(36756003)(37006003)(57306001)(66556008)(6862004)(66946007)(64756008)(66446008)(102836004)(6486002)(82746002)(229853002)(14444005)(5024004)(316002)(91956017)(2616005)(68736007)(50226002)(54906003)(86362001)(8936002)(76116006)(76176011)(6512007)(8676002)(66476007)(4326008)(81166006)(81156014)(6436002)(256004)(73956011);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1249;H:BN6PR15MB1154.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LZ2K4LUsMEKT+Bb4E9+47HNgLBGcoPOO7x25p3rRCGRjtEUpkIUC0th/5yt+i7rNrq59LoD8OHOkbTBsaJk9IV+Y2yZFI0yjirmOZNWU0FE9yE4111m2PS/0+R6KT1/z1q6HdYAKSt+9rBHXeYYt5G0nBAH6WpiMZsKNclgiWnB/nE6B61OsZ4b7eDrplQFNo1XS1gXoXH6Ru1MwCEGSag1tba6gKWwYHbXPTFJXxqrs/f1PpF4weQv3fyu4mWNvO9+pftBMfxCSIlZC3YNL83EVDHzfAmQNynWH3ROALVKaJFXOdwdYCGG/cBloLNGw6oh9QdMjbGJFimob6yc8yBBGsmlk/iZ/SnQqmFZf2PqXtbkMWUXVkYca1Mkiegr7wXP5+N9Z6DHYxFRimTUpDLDFMJ5UZ+QQsr5jxLv05EU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E2A4F5C3651F6468403F3F902F39FAE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd96e88-9e32-45a8-ff36-08d6e5567d30
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 23:28:14.7773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1249
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 30, 2019, at 3:55 PM, Matt Mullins <mmullins@fb.com> wrote:
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
> ---
> It felt a bit overkill, but I had to split bpf_event_entry into its own
> header file to break an include cycle from perf_event.h -> cgroup.h ->
> cgroup-defs.h -> bpf-cgroup.h -> bpf.h -> (potentially) perf_event.h.
>=20
> include/linux/bpf.h       |  7 -------
> include/linux/bpf_event.h | 20 ++++++++++++++++++++
> kernel/bpf/arraymap.c     |  2 ++
> kernel/trace/bpf_trace.c  | 30 +++++++++++++++++-------------
> 4 files changed, 39 insertions(+), 20 deletions(-)
> create mode 100644 include/linux/bpf_event.h
>=20
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4fb3aa2dc975..13b253a36402 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -467,13 +467,6 @@ static inline bool bpf_map_flags_access_ok(u32 acces=
s_flags)
> 	       (BPF_F_RDONLY_PROG | BPF_F_WRONLY_PROG);
> }
>=20

I think we can avoid the include cycle as:

+struct perf_sample_data *sd;
struct bpf_event_entry {
	struct perf_event *event;
	struct file *perf_file;
	struct file *map_file;
	struct rcu_head rcu;
+	struct perf_sample_data *sd;
};

> -struct bpf_event_entry {
> -	struct perf_event *event;
> -	struct file *perf_file;
> -	struct file *map_file;
> -	struct rcu_head rcu;
> -};
> -
> bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_=
prog *fp);
> int bpf_prog_calc_tag(struct bpf_prog *fp);
>=20
> diff --git a/include/linux/bpf_event.h b/include/linux/bpf_event.h
> new file mode 100644
> index 000000000000..9f415990f921
> --- /dev/null
> +++ b/include/linux/bpf_event.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_BPF_EVENT_H
> +#define _LINUX_BPF_EVENT_H
> +
> +#include <linux/perf_event.h>
> +#include <linux/types.h>
> +
> +struct file;
> +
> +struct bpf_event_entry {
> +	struct perf_event *event;
> +	struct file *perf_file;
> +	struct file *map_file;
> +	struct rcu_head rcu;
> +	struct perf_sample_data sd;
> +	atomic_t in_use;
> +};
> +
> +#endif /* _LINUX_BPF_EVENT_H */
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 584636c9e2eb..08e5e486d563 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -11,6 +11,7 @@
>  * General Public License for more details.
>  */
> #include <linux/bpf.h>
> +#include <linux/bpf_event.h>
> #include <linux/btf.h>
> #include <linux/err.h>
> #include <linux/slab.h>
> @@ -659,6 +660,7 @@ static struct bpf_event_entry *bpf_event_entry_gen(st=
ruct file *perf_file,
> 		ee->event =3D perf_file->private_data;
> 		ee->perf_file =3D perf_file;
> 		ee->map_file =3D map_file;

And do the kzalloc() or some other trick here.=20

> +		atomic_set(&ee->in_use, 0);
> 	}
>=20
> 	return ee;
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f92d6ad5e080..a03e29957698 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -6,6 +6,7 @@
> #include <linux/types.h>
> #include <linux/slab.h>
> #include <linux/bpf.h>
> +#include <linux/bpf_event.h>
> #include <linux/bpf_perf_event.h>
> #include <linux/filter.h>
> #include <linux/uaccess.h>
> @@ -410,17 +411,17 @@ static const struct bpf_func_proto bpf_perf_event_r=
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
> @@ -439,13 +440,22 @@ __bpf_perf_event_output(struct pt_regs *regs, struc=
t bpf_map *map,
> 	if (unlikely(event->oncpu !=3D cpu))
> 		return -EOPNOTSUPP;
>=20
> -	return perf_event_output(event, sd, regs);
> +	if (atomic_cmpxchg(&ee->in_use, 0, 1) !=3D 0)
> +		return -EBUSY;

And we only need xchg() here, so we can eliminate in_use.=20

Does this make sense?

Thanks,
Song

> +
> +	sd =3D &ee->sd;
> +	perf_sample_data_init(sd, 0, 0);
> +	sd->raw =3D raw;
> +
> +	ret =3D perf_event_output(event, sd, regs);
> +
> +	atomic_set(&ee->in_use, 0);
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
> @@ -456,10 +466,8 @@ BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, =
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
> @@ -474,12 +482,10 @@ static const struct bpf_func_proto bpf_perf_event_o=
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
> @@ -497,10 +503,8 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags,=
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

