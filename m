Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A4C36389
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFESsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:48:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbfFESsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:48:00 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55IiB6d003407;
        Wed, 5 Jun 2019 11:47:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=93a7wUxlTtOUUKCdu0bNvaY+3ZMpGlrccP91zXZkWhw=;
 b=kxjSPrl0N1yBi6UQtCnPk7DGfVLY/+ZuuCboCkDY6Wlrd8T3kR3ayd+yZTWDAb+dKmkT
 IOpIZizmHyEVbC1FR+qvlS1mAVTEgohT6jORbR9fDwvkpVFM/aQhk3FAq3dNAdqroDHr
 e6RV7MLvjDEA3XiwPQKzao/PJIb5D8ddArc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sx6ac2dn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 05 Jun 2019 11:47:30 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 5 Jun 2019 11:47:29 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 5 Jun 2019 11:47:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93a7wUxlTtOUUKCdu0bNvaY+3ZMpGlrccP91zXZkWhw=;
 b=tDtEpAnKAB/Dh6XUfbqsyl+m3TaI9QlnykNdv+ZFObe9YSLs9KIBY85NMjQYwVgnv5DdfAH/67GFFs7ZRICOdk0jI4WJ7AJiVbKS4F/SZ85qPU8gpDVS7FI0XYOgjboZr5DarCUvWCrWs9urfFHv5R8JlfW0OIZ9delvcM58Tmg=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1197.namprd15.prod.outlook.com (10.175.2.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 18:47:27 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Wed, 5 Jun 2019
 18:47:27 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/7] bpf: implement getsockopt and setsockopt
 hooks
Thread-Topic: [PATCH bpf-next 1/7] bpf: implement getsockopt and setsockopt
 hooks
Thread-Index: AQHVGx19SfxwwAhgHkeR2xLiLz94MaaNZ/8A
Date:   Wed, 5 Jun 2019 18:47:27 +0000
Message-ID: <20190605184724.5lscowtgud5jbkos@kafai-mbp.dhcp.thefacebook.com>
References: <20190604213524.76347-1-sdf@google.com>
 <20190604213524.76347-2-sdf@google.com>
In-Reply-To: <20190604213524.76347-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:300:ed::17) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:4110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1539e8c3-5e02-49ce-310f-08d6e9e64102
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1197;
x-ms-traffictypediagnostic: MWHPR15MB1197:
x-microsoft-antispam-prvs: <MWHPR15MB1197E042B54A3E7DEA7064DDD5160@MWHPR15MB1197.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(136003)(39860400002)(189003)(199004)(14444005)(256004)(316002)(5024004)(53946003)(6246003)(229853002)(9686003)(66946007)(25786009)(14454004)(66476007)(66446008)(73956011)(30864003)(68736007)(71200400001)(71190400001)(6512007)(1076003)(4326008)(53936002)(81156014)(6486002)(66556008)(76176011)(8676002)(478600001)(6436002)(81166006)(8936002)(64756008)(86362001)(446003)(99286004)(46003)(6506007)(52116002)(6916009)(305945005)(476003)(386003)(102836004)(486006)(2906002)(7736002)(5660300002)(186003)(54906003)(6116002)(11346002)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1197;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UorrN3FzZyzVquTrTxLWSMwGrKbseTDtw71+jkbcEM/qV5mbsqgq/5EPc73g/lVTcaDwFbR0qBJzs44t5+mjIf0V647WlP0JY8KlMcolRy608FnG/MNEyptnlF9isz8WSTwsybDxTEz1KzkjfAdFFRksWONhVKmIvPV/g+WAYc6gT+yBQgN50TfPd8Xd55CZq+v6lPHB5dKMKTDzvffYXGvmAZyX6fj3jHWCXGyf+0r4VrkDwxzVLV5+XziHzCPwttvy3a2cM4BYJe9DT68peYLD49gYY6Kb/5C4JAo2YY0zOOYy6KwyWXatpqVqbT9x+n/qdFqNam+S/zoqaAh+l8LF55kuuKokdiSsdN0ioxMKmhU8SQ6muTY5kgY2kHzp+zvV+oKE5GGpViUBCLpxpjmbb0nXqxWWfom0n67w0Z0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74FD860FF18FB243AEF1AD6D718889D8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1539e8c3-5e02-49ce-310f-08d6e9e64102
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 18:47:27.6138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 02:35:18PM -0700, Stanislav Fomichev wrote:
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
> __cgroup_bpf_has_prog_array that exits early if there is nothing
> attached to a cgroup. Note, however, that there is a race between
> __cgroup_bpf_has_prog_array and BPF_PROG_RUN_ARRAY where cgroup
> program layout might have changed; this should not be a problem
> because in general there is a race between multiple calls to
> {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
>=20
> By default, kernel code path is executed after the hook (to let
> BPF handle only a subset of the options). There is new
> bpf_sockopt_handled handler that returns control to the userspace
> instead (bypassing the kernel handling).
>=20
> The return code is either 1 (success) or 0 (EPERM).
>=20
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup.h |  29 ++++
>  include/linux/bpf.h        |   2 +
>  include/linux/bpf_types.h  |   1 +
>  include/linux/filter.h     |  19 +++
>  include/uapi/linux/bpf.h   |  17 ++-
>  kernel/bpf/cgroup.c        | 288 +++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c       |  19 +++
>  kernel/bpf/verifier.c      |  12 ++
>  net/core/filter.c          |   4 +-
>  net/socket.c               |  18 +++
>  10 files changed, 406 insertions(+), 3 deletions(-)
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
> index e5a309e6a400..fb4e6ef5a971 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1054,6 +1054,8 @@ extern const struct bpf_func_proto bpf_spin_unlock_=
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
> index 43b45d6db36d..7a07fd2e14d3 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1199,4 +1199,23 @@ struct bpf_sysctl_kern {
>  	u64 tmp_reg;
>  };
> =20
> +struct bpf_sockopt_kern {
> +	struct sock	*sk;
> +	s32		level;
> +	s32		optname;
> +	u32		optlen;
It seems there is hole.

> +	u8		*optval;
> +	u8		*optval_end;
> +
> +	/* If true, BPF program had consumed the sockopt request.
> +	 * Control is returned to the userspace (i.e. kernel doesn't
> +	 * handle this option).
> +	 */
> +	bool		handled;
> +
> +	/* Small on-stack optval buffer to avoid small allocations.
> +	 */
> +	u8 buf[64];
Is it better to align to 8 bytes?

> +};
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7c6aef253173..b6c3891241ef 100644
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
> @@ -2815,7 +2818,8 @@ union bpf_attr {
>  	FN(strtoul),			\
>  	FN(sk_storage_get),		\
>  	FN(sk_storage_delete),		\
> -	FN(send_signal),
> +	FN(send_signal),		\
> +	FN(sockopt_handled),
Document.

> =20
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>   * function eBPF program intends to call
> @@ -3533,4 +3537,15 @@ struct bpf_sysctl {
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
> +};
> +
>  #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 1b65ab0df457..4ec99ea97023 100644
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
> +static bool __cgroup_bpf_has_prog_array(struct cgroup *cgrp,
> +					enum bpf_attach_type attach_type)
> +{
> +	struct bpf_prog_array *prog_array;
> +	int nr;
> +
> +	rcu_read_lock();
> +	prog_array =3D rcu_dereference(cgrp->bpf.effective[attach_type]);
> +	nr =3D bpf_prog_array_length(prog_array);
Nit. It seems unnecessary to loop through the whole
array if the only signal needed is non-zero.

> +	rcu_read_unlock();
> +
> +	return nr > 0;
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
> +	if (!__cgroup_bpf_has_prog_array(cgrp, BPF_CGROUP_SETSOCKOPT))
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
> +	ret =3D BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_SETSOCKOPT],
> +				 &ctx, BPF_PROG_RUN);
I think the check_return_code() in verifier.c has to be
adjusted also.

> +	release_sock(sk);
> +
> +	sockopt_free_buf(&ctx);
> +
> +	if (!ret)
> +		return -EPERM;
> +
> +	return ctx.handled ? 1 : 0;
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
> +	char buf[64];
hmm... where is it used?

> +	int ret;
> +
> +	/* Opportunistic check to see whether we have any BPF program
> +	 * attached to the hook so we don't waste time allocating
> +	 * memory and locking the socket.
> +	 */
> +	if (!__cgroup_bpf_has_prog_array(cgrp, BPF_CGROUP_GETSOCKOPT))
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
> +	ret =3D BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
> +				 &ctx, BPF_PROG_RUN);
> +	release_sock(sk);
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
> +	if (!ret)
> +		return -EPERM;
> +
> +	return ctx.handled ? 1 : 0;
> +}
> +EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
> +
>  static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
>  			      size_t *lenp)
>  {
> @@ -1184,3 +1321,154 @@ const struct bpf_verifier_ops cg_sysctl_verifier_=
ops =3D {
> =20
>  const struct bpf_prog_ops cg_sysctl_prog_ops =3D {
>  };
> +
> +BPF_CALL_1(bpf_sockopt_handled, struct bpf_sockopt_kern *, ctx)
> +{
> +	ctx->handled =3D true;
> +	return 1;
RET_VOID?

> +}
> +
> +static const struct bpf_func_proto bpf_sockopt_handled_proto =3D {
> +	.func		=3D bpf_sockopt_handled,
> +	.gpl_only	=3D false,
> +	.arg1_type      =3D ARG_PTR_TO_CTX,
> +	.ret_type	=3D RET_INTEGER,
> +};
> +
> +static const struct bpf_func_proto *
> +cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *p=
rog)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_sockopt_handled:
> +		return &bpf_sockopt_handled_proto;
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
> +		info->reg_type =3D PTR_TO_SOCK_COMMON_OR_NULL;
sk cannot be NULL, so the OR_NULL part is not needed.

I think it should also be PTR_TO_SOCKET instead.

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
> +		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sockopt_kern, sk),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern, sk));
> +		break;
> +	case offsetof(struct bpf_sockopt, level):
> +		*insn++ =3D BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      bpf_target_off(struct bpf_sockopt_kern,
> +						     level, 4, target_size));
bpf_target_off() is not needed since there is no narrow load.

> +		break;
> +	case offsetof(struct bpf_sockopt, optname):
> +		*insn++ =3D BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +				      bpf_target_off(struct bpf_sockopt_kern,
> +						     optname, 4, target_size));
> +		break;
> +	case offsetof(struct bpf_sockopt, optlen):
> +		if (type =3D=3D BPF_WRITE)
> +			*insn++ =3D BPF_STX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +					      bpf_target_off(struct bpf_sockopt_kern,
> +							     optlen, 4, target_size));
> +		else
> +			*insn++ =3D BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
> +					      bpf_target_off(struct bpf_sockopt_kern,
> +							     optlen, 4, target_size));
> +		break;
> +	case offsetof(struct bpf_sockopt, optval):
> +		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sockopt_kern, optv=
al),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern, optval));
> +		break;
> +	case offsetof(struct bpf_sockopt, optval_end):
> +		*insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sockopt_kern, optv=
al_end),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct bpf_sockopt_kern, optval_end));
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
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4c53cbd3329d..4ad2b5f1905f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1596,6 +1596,14 @@ bpf_prog_load_check_attach_type(enum bpf_prog_type=
 prog_type,
>  		default:
>  			return -EINVAL;
>  		}
> +	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +		switch (expected_attach_type) {
> +		case BPF_CGROUP_SETSOCKOPT:
> +		case BPF_CGROUP_GETSOCKOPT:
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
>  	default:
>  		return 0;
>  	}
> @@ -1846,6 +1854,7 @@ static int bpf_prog_attach_check_attach_type(const =
struct bpf_prog *prog,
>  	switch (prog->type) {
>  	case BPF_PROG_TYPE_CGROUP_SOCK:
>  	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> +	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>  		return attach_type =3D=3D prog->expected_attach_type ? 0 : -EINVAL;
>  	case BPF_PROG_TYPE_CGROUP_SKB:
>  		return prog->enforce_expected_attach_type &&
> @@ -1916,6 +1925,10 @@ static int bpf_prog_attach(const union bpf_attr *a=
ttr)
>  	case BPF_CGROUP_SYSCTL:
>  		ptype =3D BPF_PROG_TYPE_CGROUP_SYSCTL;
>  		break;
> +	case BPF_CGROUP_GETSOCKOPT:
> +	case BPF_CGROUP_SETSOCKOPT:
> +		ptype =3D BPF_PROG_TYPE_CGROUP_SOCKOPT;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1997,6 +2010,10 @@ static int bpf_prog_detach(const union bpf_attr *a=
ttr)
>  	case BPF_CGROUP_SYSCTL:
>  		ptype =3D BPF_PROG_TYPE_CGROUP_SYSCTL;
>  		break;
> +	case BPF_CGROUP_GETSOCKOPT:
> +	case BPF_CGROUP_SETSOCKOPT:
> +		ptype =3D BPF_PROG_TYPE_CGROUP_SOCKOPT;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2031,6 +2048,8 @@ static int bpf_prog_query(const union bpf_attr *att=
r,
>  	case BPF_CGROUP_SOCK_OPS:
>  	case BPF_CGROUP_DEVICE:
>  	case BPF_CGROUP_SYSCTL:
> +	case BPF_CGROUP_GETSOCKOPT:
> +	case BPF_CGROUP_SETSOCKOPT:
>  		break;
>  	case BPF_LIRC_MODE2:
>  		return lirc_prog_query(attr, uattr);
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5c2cb5bd84ce..b91fde10e721 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1717,6 +1717,18 @@ static bool may_access_direct_pkt_data(struct bpf_=
verifier_env *env,
> =20
>  		env->seen_direct_write =3D true;
>  		return true;
> +
> +	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +		if (t =3D=3D BPF_WRITE) {
> +			if (env->prog->expected_attach_type =3D=3D
> +			    BPF_CGROUP_GETSOCKOPT) {
> +				env->seen_direct_write =3D true;
> +				return true;
> +			}
> +			return false;
> +		}
> +		return true;
> +
>  	default:
>  		return false;
>  	}
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
>  	.func		=3D bpf_sk_fullsock,
>  	.gpl_only	=3D false,
>  	.ret_type	=3D RET_PTR_TO_SOCKET_OR_NULL,
> @@ -5636,7 +5636,7 @@ BPF_CALL_1(bpf_tcp_sock, struct sock *, sk)
>  	return (unsigned long)NULL;
>  }
> =20
> -static const struct bpf_func_proto bpf_tcp_sock_proto =3D {
> +const struct bpf_func_proto bpf_tcp_sock_proto =3D {
>  	.func		=3D bpf_tcp_sock,
>  	.gpl_only	=3D false,
>  	.ret_type	=3D RET_PTR_TO_TCP_SOCK_OR_NULL,
> diff --git a/net/socket.c b/net/socket.c
> index 72372dc5dd70..e8654f1f70e6 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2069,6 +2069,15 @@ static int __sys_setsockopt(int fd, int level, int=
 optname,
>  		if (err)
>  			goto out_put;
> =20
> +		err =3D BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, level, optname,
> +						     optval, optlen);
> +		if (err < 0) {
> +			goto out_put;
> +		} else if (err > 0) {
> +			err =3D 0;
> +			goto out_put;
> +		}
> +
>  		if (level =3D=3D SOL_SOCKET)
>  			err =3D
>  			    sock_setsockopt(sock, level, optname, optval,
> @@ -2106,6 +2115,15 @@ static int __sys_getsockopt(int fd, int level, int=
 optname,
>  		if (err)
>  			goto out_put;
> =20
> +		err =3D BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
> +						     optval, optlen);
> +		if (err < 0) {
> +			goto out_put;
> +		} else if (err > 0) {
> +			err =3D 0;
> +			goto out_put;
> +		}
> +
>  		if (level =3D=3D SOL_SOCKET)
>  			err =3D
>  			    sock_getsockopt(sock, level, optname, optval,
> --=20
> 2.22.0.rc1.311.g5d7573a151-goog
>=20
