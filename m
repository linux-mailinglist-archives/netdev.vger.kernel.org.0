Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B1F38406
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 08:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfFGGB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 02:01:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726538AbfFGGB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 02:01:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x575mKlk015340;
        Thu, 6 Jun 2019 23:00:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nsWfjqWwnQpwQqbP1Ia+veDrQ5QGwObNRoPx6eSRvbg=;
 b=n9lLSnueS+eJxrpNc3ygSJ42CXlxSm514EMe6Zhlyv9CLRQKeT8+WtcplCoEnVmB4Dec
 Qbssg0au8XimZbbtIRqkLMT+11gHW3RNPVEw8+WyG3uycM3kCWiyDOuUQl1RN7zss9n+
 vqPUTDhp5b5/nuLskb/Sb6V0xDpFRnRusAU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy7yasykp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jun 2019 23:00:58 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 23:00:57 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 23:00:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsWfjqWwnQpwQqbP1Ia+veDrQ5QGwObNRoPx6eSRvbg=;
 b=MbCn4zm1TYEQDwqmkYLTMntWZb8/ZsQA22uW3MBzyQBIGoTZvlRreWSxB6Ne15VLW7AaVHwuIIj4mnoQO3mSQ0AKY01lLF+xVN9MjYG0cezm8xO2JZUtO+BtFg9xrJj1UZMbjOHdk+zktGh/ipIBJAK2hqSZl+4VTr+1QkXsRzg=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1710.namprd15.prod.outlook.com (10.174.96.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Fri, 7 Jun 2019 06:00:55 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Fri, 7 Jun 2019
 06:00:55 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v2 1/8] bpf: implement getsockopt and setsockopt
 hooks
Thread-Topic: [PATCH bpf-next v2 1/8] bpf: implement getsockopt and setsockopt
 hooks
Thread-Index: AQHVHJCYojTQg+lnJkm8yxvA38O+DqaPs5UA
Date:   Fri, 7 Jun 2019 06:00:54 +0000
Message-ID: <20190607060050.uqyg2gsolwjjjhz7@kafai-mbp.dhcp.thefacebook.com>
References: <20190606175146.205269-1-sdf@google.com>
 <20190606175146.205269-2-sdf@google.com>
In-Reply-To: <20190606175146.205269-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:300:12b::11) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:8283]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48c0c9db-c8ed-4790-ddff-08d6eb0d803e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1710;
x-ms-traffictypediagnostic: MWHPR15MB1710:
x-microsoft-antispam-prvs: <MWHPR15MB17102E0FAAA339EAD804F55AD5100@MWHPR15MB1710.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(366004)(396003)(136003)(199004)(189003)(81166006)(86362001)(81156014)(5660300002)(14454004)(52116002)(14444005)(54906003)(5024004)(8676002)(316002)(30864003)(256004)(2906002)(8936002)(6916009)(1076003)(386003)(102836004)(6506007)(99286004)(186003)(76176011)(476003)(11346002)(446003)(478600001)(7736002)(46003)(71190400001)(71200400001)(66946007)(66556008)(6116002)(66476007)(25786009)(73956011)(4326008)(486006)(64756008)(66446008)(6512007)(53946003)(6436002)(53936002)(9686003)(6246003)(229853002)(6486002)(68736007)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1710;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v63itEmISWZvxVYJfkR4KLk0n/n2mBrJ4/MOqgm5f1Y206SmCyvBWSFqWglLOCi/hWifuTThkT+cJHnIh+optF/fnlK0JlfHuqF+2gP0m1e+BTjJjCcldk6VMBGRPWkWdfz0ccxPRhdY72lebIFPlVtJ39N+c8iN1uwT3xTgtLKM5fAFr0EDXtxcwo8DTv8v6oFFUpRqsEHu7SU0qC3XZ+yrvkh202c00Tdkp9FWpl7pht/s9HTwvyB6lkGU3co0Ap8Y8MIbaayyyq39tnr+66FxPmPHsztpuPPGzSSVa0doDTCL+rMsoU1qjGJvZYpl1i4d9DpRSg+bGWdcNpn6XsVS2VjQauKiC1jwGKELH/I9DOacFIKMmFIMHJyGRN+PasHYsuCI3s0yMk+jZWDnTQhSs9TZCJP3pNtjeJEnGQQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1BF79D8C9507F14CAF796DFC231F2459@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c0c9db-c8ed-4790-ddff-08d6eb0d803e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 06:00:55.0419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1710
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:51:39AM -0700, Stanislav Fomichev wrote:
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
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h |  29 ++++
>  include/linux/bpf.h        |  46 ++++++
>  include/linux/bpf_types.h  |   1 +
>  include/linux/filter.h     |  13 ++
>  include/uapi/linux/bpf.h   |  14 ++
>  kernel/bpf/cgroup.c        | 277 +++++++++++++++++++++++++++++++++++++
>  kernel/bpf/core.c          |   9 ++
>  kernel/bpf/syscall.c       |  19 +++
>  kernel/bpf/verifier.c      |  15 ++
>  net/core/filter.c          |   4 +-
>  net/socket.c               |  18 +++
>  11 files changed, 443 insertions(+), 2 deletions(-)
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
> index e5a309e6a400..883a190bc0b8 100644
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
> + *   2: sockopt was handled by BPF, kernel not should do it and return
> + *      to the userspace instead
> + *
> + * Note, that return '0' takes precedence over everything else. In other
> + * words, if any single program in the prog array has returned 0,
> + * the userspace will get -EPERM (regardless of what other programs
> + * return).
> + *
> + * The macro itself returns:
> + *        0: sockopt was not handled by BPF, kernel should do it
> + *        1: sockopt was handled by BPF, kernel snot hould do it
> + *   -EPERM: return error back to userspace
> + */
> +#define BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(array, ctx, func)		\
> +	({								\
> +		struct bpf_prog_array_item *_item;			\
> +		struct bpf_prog *_prog;					\
> +		struct bpf_prog_array *_array;				\
> +		u32 ret;						\
> +		u32 _success =3D 1;					\
> +		u32 _bypass =3D 0;					\
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
> @@ -1054,6 +1098,8 @@ extern const struct bpf_func_proto bpf_spin_unlock_=
proto;
>  extern const struct bpf_func_proto bpf_get_local_storage_proto;
>  extern const struct bpf_func_proto bpf_strtol_proto;
>  extern const struct bpf_func_proto bpf_strtoul_proto;
> +extern const struct bpf_func_proto bpf_sk_fullsock_proto;
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
> index 7c6aef253173..310b6bbfded8 100644
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
> @@ -3533,4 +3536,15 @@ struct bpf_sysctl {
>  				 */
>  };
> =20
> +struct bpf_sockopt {
> +	__bpf_md_ptr(struct bpf_sock *, sk);
> +
> +	__s32	level;
> +	__s32	optname;
> +
> +	__u32	optlen;
> +	__u32	optval;
> +	__u32	optval_end;
After looking at patch 6, I think optval and optval_end should be changed
to __bpf_md_ptr(void *, optval) and __bpf_md_ptr(void *, optval_end).
That should avoid the (__u8 *)(long) casting in the bpf_prog.

They need to be moved to the top of this struct.
The is_valid_access() also needs to be adjusted on the size check.

"struct sk_msg_md" and "struct sk_reuseport_md" could be
used as the examples.

> +};
> +
>  #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 1b65ab0df457..04bc1a09464e 100644
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
>  static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
>  			      size_t *lenp)
>  {
> @@ -1184,3 +1321,143 @@ const struct bpf_verifier_ops cg_sysctl_verifier_=
ops =3D {
> =20
>  const struct bpf_prog_ops cg_sysctl_prog_ops =3D {
>  };
> +
> +static const struct bpf_func_proto *
> +cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *p=
rog)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_sk_fullsock:
> +		return &bpf_sk_fullsock_proto;
> +	case BPF_FUNC_sk_storage_get:
> +		return &bpf_sk_storage_get_proto;
> +	case BPF_FUNC_sk_storage_delete:
> +		return &bpf_sk_storage_delete_proto;
> +#ifdef CONFIG_INET
> +	case BPF_FUNC_tcp_sock:
> +		return &bpf_tcp_sock_proto;
> +#endif
> +	default:
> +		return cgroup_base_func_proto(func_id, prog);
> +	}
> +}
> +
> +static bool cg_sockopt_is_valid_access(int off, int size,
> +				       enum bpf_access_type type,
> +				       const struct bpf_prog *prog,
> +				       struct bpf_insn_access_aux *info)
> +{
> +	const int size_default =3D sizeof(__u32);
> +
> +	if (off < 0 || off >=3D sizeof(struct bpf_sockopt))
> +		return false;
> +
> +	if (off % size !=3D 0)
> +		return false;
> +
> +	if (type =3D=3D BPF_WRITE) {
> +		switch (off) {
> +		case offsetof(struct bpf_sockopt, optlen):
> +			if (size !=3D size_default)
> +				return false;
> +			return prog->expected_attach_type =3D=3D
> +				BPF_CGROUP_GETSOCKOPT;
> +		default:
> +			return false;
> +		}
> +	}
> +
> +	switch (off) {
> +	case offsetof(struct bpf_sockopt, sk):
> +		if (size !=3D sizeof(__u64))
> +			return false;
> +		info->reg_type =3D PTR_TO_SOCKET;
> +		break;
> +	case bpf_ctx_range(struct bpf_sockopt, optval):
> +		if (size !=3D size_default)
> +			return false;
> +		info->reg_type =3D PTR_TO_PACKET;
> +		break;
> +	case bpf_ctx_range(struct bpf_sockopt, optval_end):
> +		if (size !=3D size_default)
> +			return false;
> +		info->reg_type =3D PTR_TO_PACKET_END;
> +		break;
> +	default:
> +		if (size !=3D size_default)
> +			return false;
> +		break;
> +	}
> +	return true;
> +}
> +
> +static u32 cg_sockopt_convert_ctx_access(enum bpf_access_type type,
> +					 const struct bpf_insn *si,
> +					 struct bpf_insn *insn_buf,
> +					 struct bpf_prog *prog,
> +					 u32 *target_size)
> +{
> +	struct bpf_insn *insn =3D insn_buf;
> +
> +	switch (si->off) {
> +	case offsetof(struct bpf_sockopt, sk):
> +		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct
> +						       bpf_sockopt_kern, sk),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern, sk));
> +		break;
> +	case offsetof(struct bpf_sockopt, level):
> +		*insn++ =3D BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern, level));
> +		break;
> +	case offsetof(struct bpf_sockopt, optname):
> +		*insn++ =3D BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
Nit.
May be also use BPF_FIELD_SIZEOF() for consistency.
Same for a few BPF_W below.

> +				      offsetof(struct bpf_sockopt_kern,
> +					       optname));
> +		break;
> +	case offsetof(struct bpf_sockopt, optlen):
> +		if (type =3D=3D BPF_WRITE)
> +			*insn++ =3D BPF_STX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +					      offsetof(struct bpf_sockopt_kern,
> +						       optlen));
> +		else
> +			*insn++ =3D BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +					      offsetof(struct bpf_sockopt_kern,
> +						       optlen));
> +		break;
> +	case offsetof(struct bpf_sockopt, optval):
> +		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sockopt_kern,
> +						       optval),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern,
> +					       optval));
> +		break;
> +	case offsetof(struct bpf_sockopt, optval_end):
> +		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sockopt_kern,
> +						       optval_end),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern,
> +					       optval_end));
> +		break;
> +	}
> +
> +	return insn - insn_buf;
> +}
> +
> +static int cg_sockopt_get_prologue(struct bpf_insn *insn_buf,
> +				   bool direct_write,
> +				   const struct bpf_prog *prog)
> +{
> +	/* Nothing to do for sockopt argument. The data is kzalloc'ated.
> +	 */
> +	return 0;
> +}
> +
> +const struct bpf_verifier_ops cg_sockopt_verifier_ops =3D {
> +	.get_func_proto		=3D cg_sockopt_func_proto,
> +	.is_valid_access	=3D cg_sockopt_is_valid_access,
> +	.convert_ctx_access	=3D cg_sockopt_convert_ctx_access,
> +	.gen_prologue		=3D cg_sockopt_get_prologue,
> +};
> +
> +const struct bpf_prog_ops cg_sockopt_prog_ops =3D {
> +};

[ ... ]

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..4652c0a005ca 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1835,7 +1835,7 @@ BPF_CALL_1(bpf_sk_fullsock, struct sock *, sk)
>  	return sk_fullsock(sk) ? (unsigned long)sk : (unsigned long)NULL;
>  }
> =20
> -static const struct bpf_func_proto bpf_sk_fullsock_proto =3D {
> +const struct bpf_func_proto bpf_sk_fullsock_proto =3D {
Exposing this is no longer needed.  PTR_TO_SOCKET is already a fullsock.

>  	.func		=3D bpf_sk_fullsock,
>  	.gpl_only	=3D false,
>  	.ret_type	=3D RET_PTR_TO_SOCKET_OR_NULL,
> @@ -5636,7 +5636,7 @@ BPF_CALL_1(bpf_tcp_sock, struct sock *, sk)
>  	return (unsigned long)NULL;
>  }
>
