Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272763BC65
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388921AbfFJTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:03:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37282 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387674AbfFJTD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:03:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5AIvnPr023217;
        Mon, 10 Jun 2019 12:03:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HeszAf+abCTjQRfbdLV+Gxczhp/7i8AzrXUt2tQfOKM=;
 b=UUwa2YX20GCiOrDMZe/k+OiJbqeMJNYVh0hvN+NBinySGTpwArX7dUZrvyzLKd3PVtJ+
 rLGqLfsMhHFXVbvbiLrbkgJgo8LGStyAfv0ovInr4TZW/Xy86HV2zw2W0N7nRMs4Mqh0
 l/hD7qff3PBPoYkD4GHTNDi37zmSU2iaq8w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1njwj12b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 10 Jun 2019 12:03:30 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 10 Jun 2019 12:03:29 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 12:03:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeszAf+abCTjQRfbdLV+Gxczhp/7i8AzrXUt2tQfOKM=;
 b=b2/M3X9UDWSS4XEsbJqj15i8Z4cfRiAOLQm7jH4oIRTNbt/Hz1pFjAYABV+xljt2CMxxwvQpxzy7lOnoIUbwHf13+pfcQZrVC77oOSGHPoVWvS1cqsXCnOtrJpqZmnUhwpOwZ0xYrl9iQdlEYsWzVik4fdn3nFP3i3OYnDpjfOQ=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1278.namprd15.prod.outlook.com (10.175.3.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 19:03:27 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 19:03:27 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v4 1/8] bpf: implement getsockopt and setsockopt
 hooks
Thread-Topic: [PATCH bpf-next v4 1/8] bpf: implement getsockopt and setsockopt
 hooks
Thread-Index: AQHVH6phv0cNvtbMOkadJ65qcv5FT6aVPwKA
Date:   Mon, 10 Jun 2019 19:03:26 +0000
Message-ID: <20190610190257.z75nsmbf2u7sdgv5@kafai-mbp.dhcp.thefacebook.com>
References: <20190610163421.208126-1-sdf@google.com>
 <20190610163421.208126-2-sdf@google.com>
In-Reply-To: <20190610163421.208126-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:102:1::31) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:7d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5b309e6-e99d-491e-aac3-08d6edd65157
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1278;
x-ms-traffictypediagnostic: MWHPR15MB1278:
x-microsoft-antispam-prvs: <MWHPR15MB1278260A444A5C285BAEBC11D5130@MWHPR15MB1278.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(39860400002)(346002)(136003)(189003)(199004)(81166006)(81156014)(305945005)(478600001)(486006)(476003)(46003)(99286004)(11346002)(52116002)(186003)(8936002)(54906003)(4326008)(446003)(5024004)(14444005)(14454004)(71200400001)(71190400001)(256004)(7736002)(25786009)(30864003)(8676002)(66946007)(73956011)(66446008)(64756008)(66556008)(66476007)(5660300002)(86362001)(2906002)(6512007)(9686003)(386003)(6116002)(53936002)(6246003)(68736007)(6916009)(102836004)(6506007)(316002)(76176011)(6436002)(1076003)(229853002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1278;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 13l52VI2QZDxvnPkG44SzcFkmWrvefzBQXTPtCP55nersZEn7Z5a1ADfWE0x6ifbJ2DmroCeKfupq0sIAiAYcMPIArv5KLSMbiNRqHHZKcrnnt5yRBT8O8weFT64gjD1Ufaz+UComdZKqs19GRehGRslGXExdSlCBAkiDhr6YvI5hrJOyXYyMjGss+zKOre5p6fr7Z+XqGPrfiRF2bGVB3o3NoyB9TTzwpxKWwGEf0zclX7RI5YUTUvmud1lkZtrVTlt9yaZCh3WHrvV8k5w0msELARUiBuG9Em24FLs2NfLEV5qO/Qu37kJEqiuCaPK2nAkNyHekvmiy9dG/fTbKlyGG7H9eM5FjiGSHL3ebzhgTrnEz12XslDd3L9pl6G4mHeS5x/qh2j94/iIlUEzBLUAj33LiH66fAzBSYS3f5w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14FBBC08ABB84D41A9820EE79B1C7898@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b309e6-e99d-491e-aac3-08d6edd65157
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 19:03:26.7842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1278
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100128
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 09:34:14AM -0700, Stanislav Fomichev wrote:
> Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
>=20
> BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
>=20
> The buffer memory is pre-allocated (because I don't think there is
> a precedent for working with __user memory from bpf). This might be
> slow to do for each {s,g}etsockopt call, that's why I've added
> __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> attached to a cgroup. Note, however, that there is a race between
> __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> program layout might have changed; this should not be a problem
> because in general there is a race between multiple calls to
> {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
>=20
> The return code of the BPF program is handled as follows:
> * 0: EPERM
> * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
>      prog exits
>=20
> v4:
> * don't export bpf_sk_fullsock helper (Martin Lau)
> * size !=3D sizeof(__u64) for uapi pointers (Martin Lau)
> * offsetof instead of bpf_ctx_range when checking ctx access (Martin Lau)
>=20
> v3:
> * typos in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY comments (Andrii Nakryiko)
> * reverse christmas tree in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY (Andrii
>   Nakryiko)
> * use __bpf_md_ptr instead of __u32 for optval{,_end} (Martin Lau)
> * use BPF_FIELD_SIZEOF() for consistency (Martin Lau)
> * new CG_SOCKOPT_ACCESS macro to wrap repeated parts
>=20
> v2:
> * moved bpf_sockopt_kern fields around to remove a hole (Martin Lau)
> * aligned bpf_sockopt_kern->buf to 8 bytes (Martin Lau)
> * bpf_prog_array_is_empty instead of bpf_prog_array_length (Martin Lau)
> * added [0,2] return code check to verifier (Martin Lau)
> * dropped unused buf[64] from the stack (Martin Lau)
> * use PTR_TO_SOCKET for bpf_sockopt->sk (Martin Lau)
> * dropped bpf_target_off from ctx rewrites (Martin Lau)
> * use return code for kernel bypass (Martin Lau & Andrii Nakryiko)
>=20
> Cc: Martin Lau <kafai@fb.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h |  29 ++++
>  include/linux/bpf.h        |  45 +++++++
>  include/linux/bpf_types.h  |   1 +
>  include/linux/filter.h     |  13 ++
>  include/uapi/linux/bpf.h   |  13 ++
>  kernel/bpf/cgroup.c        | 262 +++++++++++++++++++++++++++++++++++++
>  kernel/bpf/core.c          |   9 ++
>  kernel/bpf/syscall.c       |  19 +++
>  kernel/bpf/verifier.c      |  15 +++
>  net/core/filter.c          |   2 +-
>  net/socket.c               |  18 +++
>  11 files changed, 425 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index b631ee75762d..406f1ba82531 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -124,6 +124,13 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_=
header *head,
>  				   loff_t *ppos, void **new_buf,
>  				   enum bpf_attach_type type);
> =20
> +int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int level,
> +				       int optname, char __user *optval,
> +				       unsigned int optlen);
> +int __cgroup_bpf_run_filter_getsockopt(struct sock *sock, int level,
> +				       int optname, char __user *optval,
> +				       int __user *optlen);
> +
>  static inline enum bpf_cgroup_storage_type cgroup_storage_type(
>  	struct bpf_map *map)
>  {
> @@ -280,6 +287,26 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map =
*map, void *key,
>  	__ret;								       \
>  })
> =20
> +#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, opt=
len)   \
> +({									       \
> +	int __ret =3D 0;							       \
> +	if (cgroup_bpf_enabled)						       \
> +		__ret =3D __cgroup_bpf_run_filter_setsockopt(sock, level,	       \
> +							   optname, optval,    \
> +							   optlen);	       \
> +	__ret;								       \
> +})
> +
> +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, opt=
len)   \
> +({									       \
> +	int __ret =3D 0;							       \
> +	if (cgroup_bpf_enabled)						       \
> +		__ret =3D __cgroup_bpf_run_filter_getsockopt(sock, level,	       \
> +							   optname, optval,    \
> +							   optlen);	       \
> +	__ret;								       \
> +})
> +
>  int cgroup_bpf_prog_attach(const union bpf_attr *attr,
>  			   enum bpf_prog_type ptype, struct bpf_prog *prog);
>  int cgroup_bpf_prog_detach(const union bpf_attr *attr,
> @@ -349,6 +376,8 @@ static inline int bpf_percpu_cgroup_storage_update(st=
ruct bpf_map *map,
>  #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type,major,minor,access) ({ 0;=
 })
>  #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,pos,nbuf) =
({ 0; })
> +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, opt=
len) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, opt=
len) ({ 0; })
> =20
>  #define for_each_cgroup_storage_type(stype) for (; false; )
> =20
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index e5a309e6a400..194a47ca622f 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -520,6 +520,7 @@ struct bpf_prog_array {
>  struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
>  void bpf_prog_array_free(struct bpf_prog_array *progs);
>  int bpf_prog_array_length(struct bpf_prog_array *progs);
> +bool bpf_prog_array_is_empty(struct bpf_prog_array *array);
>  int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
>  				__u32 __user *prog_ids, u32 cnt);
> =20
> @@ -606,6 +607,49 @@ _out:							\
>  		_ret;					\
>  	})
> =20
> +/* To be used by BPF_PROG_TYPE_CGROUP_SOCKOPT program type.
> + *
> + * Expected BPF program return values are:
> + *   0: return -EPERM to the userspace
> + *   1: sockopt was not handled by BPF, kernel should do it
> + *   2: sockopt was handled by BPF, kernel should _not_ do it and return
> + *      to the userspace instead
> + *
> + * Note, that return '0' takes precedence over everything else. In other
> + * words, if any single program in the prog array has returned 0,
> + * the userspace will get -EPERM (regardless of what other programs
> + * return).
> + *
> + * The macro itself returns:
> + *        0: sockopt was not handled by BPF, kernel should do it
> + *        1: sockopt was handled by BPF, kernel should _not_ do it
> + *   -EPERM: return error back to userspace
> + */
> +#define BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(array, ctx, func)		\
> +	({								\
> +		struct bpf_prog_array_item *_item;			\
> +		struct bpf_prog_array *_array;				\
> +		struct bpf_prog *_prog;					\
> +		u32 _success =3D 1;					\
> +		u32 _bypass =3D 0;					\
> +		u32 ret;						\
> +		preempt_disable();					\
> +		rcu_read_lock();					\
> +		_array =3D rcu_dereference(array);			\
> +		_item =3D &_array->items[0];				\
> +		while ((_prog =3D READ_ONCE(_item->prog))) {		\
> +			bpf_cgroup_storage_set(_item->cgroup_storage);	\
> +			ret =3D func(_prog, ctx);				\
> +			_success &=3D (ret > 0);				\
> +			_bypass |=3D (ret =3D=3D 2);				\
> +			_item++;					\
> +		}							\
> +		rcu_read_unlock();					\
> +		preempt_enable();					\
> +		ret =3D _success ? _bypass : -EPERM;			\
> +		ret;							\
> +	})
> +
>  #define BPF_PROG_RUN_ARRAY(array, ctx, func)		\
>  	__BPF_PROG_RUN_ARRAY(array, ctx, func, false)
> =20
> @@ -1054,6 +1098,7 @@ extern const struct bpf_func_proto bpf_spin_unlock_=
proto;
>  extern const struct bpf_func_proto bpf_get_local_storage_proto;
>  extern const struct bpf_func_proto bpf_strtol_proto;
>  extern const struct bpf_func_proto bpf_strtoul_proto;
> +extern const struct bpf_func_proto bpf_tcp_sock_proto;
> =20
>  /* Shared helpers among cBPF and eBPF. */
>  void bpf_user_rnd_init_once(void);
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 5a9975678d6f..eec5aeeeaf92 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -30,6 +30,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, ra=
w_tracepoint_writable)
>  #ifdef CONFIG_CGROUP_BPF
>  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
>  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl)
> +BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt)
>  #endif
>  #ifdef CONFIG_BPF_LIRC_MODE2
>  BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 43b45d6db36d..6e64d01e4e36 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1199,4 +1199,17 @@ struct bpf_sysctl_kern {
>  	u64 tmp_reg;
>  };
> =20
> +struct bpf_sockopt_kern {
> +	struct sock	*sk;
> +	u8		*optval;
> +	u8		*optval_end;
> +	s32		level;
> +	s32		optname;
> +	u32		optlen;
> +
> +	/* Small on-stack optval buffer to avoid small allocations.
> +	 */
> +	u8 buf[64] __aligned(8);
> +};
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7c6aef253173..afaa7e28d1e4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -170,6 +170,7 @@ enum bpf_prog_type {
>  	BPF_PROG_TYPE_FLOW_DISSECTOR,
>  	BPF_PROG_TYPE_CGROUP_SYSCTL,
>  	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
> +	BPF_PROG_TYPE_CGROUP_SOCKOPT,
>  };
> =20
>  enum bpf_attach_type {
> @@ -192,6 +193,8 @@ enum bpf_attach_type {
>  	BPF_LIRC_MODE2,
>  	BPF_FLOW_DISSECTOR,
>  	BPF_CGROUP_SYSCTL,
> +	BPF_CGROUP_GETSOCKOPT,
> +	BPF_CGROUP_SETSOCKOPT,
>  	__MAX_BPF_ATTACH_TYPE
>  };
> =20
> @@ -3533,4 +3536,14 @@ struct bpf_sysctl {
>  				 */
>  };
> =20
> +struct bpf_sockopt {
> +	__bpf_md_ptr(struct bpf_sock *, sk);
> +	__bpf_md_ptr(void *, optval);
> +	__bpf_md_ptr(void *, optval_end);
> +
> +	__s32	level;
> +	__s32	optname;
> +	__u32	optlen;
> +};
> +
>  #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 1b65ab0df457..dcc06edaad7b 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -18,6 +18,7 @@
>  #include <linux/bpf.h>
>  #include <linux/bpf-cgroup.h>
>  #include <net/sock.h>
> +#include <net/bpf_sk_storage.h>
> =20
>  DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
>  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> @@ -924,6 +925,142 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table=
_header *head,
>  }
>  EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
> =20
> +static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> +					     enum bpf_attach_type attach_type)
> +{
> +	struct bpf_prog_array *prog_array;
> +	bool empty;
> +
> +	rcu_read_lock();
> +	prog_array =3D rcu_dereference(cgrp->bpf.effective[attach_type]);
> +	empty =3D bpf_prog_array_is_empty(prog_array);
> +	rcu_read_unlock();
> +
> +	return empty;
> +}
> +
> +static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optle=
n)
> +{
> +	if (unlikely(max_optlen > PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (likely(max_optlen <=3D sizeof(ctx->buf))) {
> +		ctx->optval =3D ctx->buf;
> +	} else {
> +		ctx->optval =3D kzalloc(max_optlen, GFP_USER);
> +		if (!ctx->optval)
> +			return -ENOMEM;
> +	}
> +
> +	ctx->optval_end =3D ctx->optval + max_optlen;
> +	ctx->optlen =3D max_optlen;
> +
> +	return 0;
> +}
> +
> +static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> +{
> +	if (unlikely(ctx->optval !=3D ctx->buf))
> +		kfree(ctx->optval);
> +}
> +
> +int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int level,
> +				       int optname, char __user *optval,
> +				       unsigned int optlen)
> +{
> +	struct cgroup *cgrp =3D sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	struct bpf_sockopt_kern ctx =3D {
> +		.sk =3D sk,
> +		.level =3D level,
> +		.optname =3D optname,
> +	};
> +	int ret;
> +
> +	/* Opportunistic check to see whether we have any BPF program
> +	 * attached to the hook so we don't waste time allocating
> +	 * memory and locking the socket.
> +	 */
> +	if (__cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_SETSOCKOPT))
> +		return 0;
> +
> +	ret =3D sockopt_alloc_buf(&ctx, optlen);
> +	if (ret)
> +		return ret;
> +
> +	if (copy_from_user(ctx.optval, optval, optlen) !=3D 0) {
> +		sockopt_free_buf(&ctx);
> +		return -EFAULT;
> +	}
> +
> +	lock_sock(sk);
> +	ret =3D BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(
> +		cgrp->bpf.effective[BPF_CGROUP_SETSOCKOPT],
> +		&ctx, BPF_PROG_RUN);
> +	release_sock(sk);
> +
> +	sockopt_free_buf(&ctx);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(__cgroup_bpf_run_filter_setsockopt);
> +
> +int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
> +				       int optname, char __user *optval,
> +				       int __user *optlen)
> +{
> +	struct cgroup *cgrp =3D sock_cgroup_ptr(&sk->sk_cgrp_data);
> +	struct bpf_sockopt_kern ctx =3D {
> +		.sk =3D sk,
> +		.level =3D level,
> +		.optname =3D optname,
> +	};
> +	int max_optlen;
> +	int ret;
> +
> +	/* Opportunistic check to see whether we have any BPF program
> +	 * attached to the hook so we don't waste time allocating
> +	 * memory and locking the socket.
> +	 */
> +	if (__cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_GETSOCKOPT))
> +		return 0;
> +
> +	if (get_user(max_optlen, optlen))
> +		return -EFAULT;
> +
> +	ret =3D sockopt_alloc_buf(&ctx, max_optlen);
> +	if (ret)
> +		return ret;
> +
> +	lock_sock(sk);
> +	ret =3D BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(
> +		cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
> +		&ctx, BPF_PROG_RUN);
> +	release_sock(sk);
> +
> +	if (ret < 0) {
> +		sockopt_free_buf(&ctx);
> +		return ret;
> +	}
> +
> +	if (ctx.optlen > max_optlen) {
v4 looks very good.

One minor question here, what may be the use case if the bpf_prog makes
ctx.optlen < max_optlen(=3D=3Duser's input) but sets ret =3D=3D 0 (i.e. ker=
nel should
continue to handle it)?

> +		sockopt_free_buf(&ctx);
> +		return -EFAULT;
> +	}
> +
> +	if (copy_to_user(optval, ctx.optval, ctx.optlen) !=3D 0) {
> +		sockopt_free_buf(&ctx);
> +		return -EFAULT;
> +	}
> +
> +	sockopt_free_buf(&ctx);
> +
> +	if (put_user(ctx.optlen, optlen))
> +		return -EFAULT;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
> +
