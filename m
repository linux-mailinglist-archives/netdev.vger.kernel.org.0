Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F547366EC
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFEVmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:42:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfFEVmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:42:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55LYuJv016342;
        Wed, 5 Jun 2019 14:41:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uU4ONEj0jRpJKBFdL6KMfr98KICyd4KOCywBdEfL3yg=;
 b=p/qS0PdJbkcBsBXvPCBHZXTZcMhtP7/iLoVmJyJwIylVfz9y2WWYO2+HJFbaNEXJq0cv
 a04qDHAdGuaQkOLn4vRbuVj02aUXNm8VSlEGu+nYQvfL3m/UAhpZixcUznG8pYf2N6qo
 xkThc3cXT+IucpimaXPwDP+mHJAApVE/9xg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxf95hkv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 05 Jun 2019 14:41:42 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 5 Jun 2019 14:41:41 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 5 Jun 2019 14:41:41 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 5 Jun 2019 14:41:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uU4ONEj0jRpJKBFdL6KMfr98KICyd4KOCywBdEfL3yg=;
 b=sdMSFXNi82LJybWX8s0t6Odu9COGIgiKWpnmSipgYgx67FQfvxtFRVUaBJmypygckJLU3kqEuZJQdJ5n0K65/uO9TPOn2U8jYXjLRM9k+AdtqjTMK0egKxy8Li5FKuO6MWVexUvWA+kUtYMwSIkgnZWT4HrrTw7Xkep5C/61YzE=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1551.namprd15.prod.outlook.com (10.173.228.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 21:41:39 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Wed, 5 Jun 2019
 21:41:39 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/7] bpf: implement getsockopt and setsockopt
 hooks
Thread-Topic: [PATCH bpf-next 1/7] bpf: implement getsockopt and setsockopt
 hooks
Thread-Index: AQHVGx19SfxwwAhgHkeR2xLiLz94MaaNZ/8AgAAIYgCAABobAIAABysAgAAHBAA=
Date:   Wed, 5 Jun 2019 21:41:39 +0000
Message-ID: <20190605214136.ovquhthuzqpyvjoy@kafai-mbp.dhcp.thefacebook.com>
References: <20190604213524.76347-1-sdf@google.com>
 <20190604213524.76347-2-sdf@google.com>
 <20190605184724.5lscowtgud5jbkos@kafai-mbp.dhcp.thefacebook.com>
 <20190605191724.GB17053@mini-arch>
 <20190605205050.fj2s5cc5vqwvt53l@kafai-mbp.dhcp.thefacebook.com>
 <20190605211630.GA9660@mini-arch>
In-Reply-To: <20190605211630.GA9660@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:907::34)
 To MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:b7bf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 983aaa6d-28a8-4393-2a01-08d6e9fe9771
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1551;
x-ms-traffictypediagnostic: MWHPR15MB1551:
x-microsoft-antispam-prvs: <MWHPR15MB15515FCB7AB5DB69F2BD42D5D5160@MWHPR15MB1551.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(76176011)(86362001)(14444005)(3716004)(102836004)(386003)(6506007)(99286004)(1076003)(256004)(446003)(30864003)(5660300002)(9686003)(5024004)(186003)(6486002)(71200400001)(6246003)(52116002)(6116002)(53936002)(316002)(6916009)(71190400001)(54906003)(229853002)(6512007)(66446008)(11346002)(6436002)(8936002)(4326008)(478600001)(8676002)(68736007)(81166006)(81156014)(476003)(66946007)(66556008)(14454004)(66476007)(2906002)(7736002)(486006)(73956011)(305945005)(46003)(64756008)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1551;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VOSbCqaZIJfDpM9Fm1zVdNb6WZw8tjY0TsaVz1jmse1EyeTuxvBpwFCCTYV1patoHayvAQmfFm7X7B33y8OvTm2U5nH54IrqnLXGGeEs1rG0aMDLCdP9Vafd+hB7mScPpkod1NRXN/ikL1uVLF9PWoG4XZW7qc6H2cVHim0jevyVUpYMgw3xdydmx93M+QbElP9H/g3x0oyOhnH7eTuollEvbfSHlCL8yy2NPOeBKG3Us/BKuSNAKsdD7AoGvBAy+IqcH3R6IXceiUsQ3H6OJL5nf9ytUGG/Me903VVxP8kD0yUe1hU4p8J6FnyXebYJorszKgBWy3dYMlCztPBcA/YuurouY6HRtFoTMWe82oP8rX1t6j1eDHoHNYSDKW9bZRrTnXlj/cUUKDqizwQgg216GabDx4DjW+Xxt+XekEA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A50B6E1D8A822468BF839D0B4C51220@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 983aaa6d-28a8-4393-2a01-08d6e9fe9771
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 21:41:39.6669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1551
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:16:30PM -0700, Stanislav Fomichev wrote:
> On 06/05, Martin Lau wrote:
> > On Wed, Jun 05, 2019 at 12:17:24PM -0700, Stanislav Fomichev wrote:
> > > On 06/05, Martin Lau wrote:
> > > > On Tue, Jun 04, 2019 at 02:35:18PM -0700, Stanislav Fomichev wrote:
> > > > > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > > > > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > > > >=20
> > > > > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt argu=
ments.
> > > > > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > > > > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > > > >=20
> > > > > The buffer memory is pre-allocated (because I don't think there i=
s
> > > > > a precedent for working with __user memory from bpf). This might =
be
> > > > > slow to do for each {s,g}etsockopt call, that's why I've added
> > > > > __cgroup_bpf_has_prog_array that exits early if there is nothing
> > > > > attached to a cgroup. Note, however, that there is a race between
> > > > > __cgroup_bpf_has_prog_array and BPF_PROG_RUN_ARRAY where cgroup
> > > > > program layout might have changed; this should not be a problem
> > > > > because in general there is a race between multiple calls to
> > > > > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > > > >=20
> > > > > By default, kernel code path is executed after the hook (to let
> > > > > BPF handle only a subset of the options). There is new
> > > > > bpf_sockopt_handled handler that returns control to the userspace
> > > > > instead (bypassing the kernel handling).
> > > > >=20
> > > > > The return code is either 1 (success) or 0 (EPERM).
> > > > >=20
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  include/linux/bpf-cgroup.h |  29 ++++
> > > > >  include/linux/bpf.h        |   2 +
> > > > >  include/linux/bpf_types.h  |   1 +
> > > > >  include/linux/filter.h     |  19 +++
> > > > >  include/uapi/linux/bpf.h   |  17 ++-
> > > > >  kernel/bpf/cgroup.c        | 288 +++++++++++++++++++++++++++++++=
++++++
> > > > >  kernel/bpf/syscall.c       |  19 +++
> > > > >  kernel/bpf/verifier.c      |  12 ++
> > > > >  net/core/filter.c          |   4 +-
> > > > >  net/socket.c               |  18 +++
> > > > >  10 files changed, 406 insertions(+), 3 deletions(-)
> > > > >=20
> > > > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgrou=
p.h
> > > > > index b631ee75762d..406f1ba82531 100644
> > > > > --- a/include/linux/bpf-cgroup.h
> > > > > +++ b/include/linux/bpf-cgroup.h
> > > > > @@ -124,6 +124,13 @@ int __cgroup_bpf_run_filter_sysctl(struct ct=
l_table_header *head,
> > > > >  				   loff_t *ppos, void **new_buf,
> > > > >  				   enum bpf_attach_type type);
> > > > > =20
> > > > > +int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int le=
vel,
> > > > > +				       int optname, char __user *optval,
> > > > > +				       unsigned int optlen);
> > > > > +int __cgroup_bpf_run_filter_getsockopt(struct sock *sock, int le=
vel,
> > > > > +				       int optname, char __user *optval,
> > > > > +				       int __user *optlen);
> > > > > +
> > > > >  static inline enum bpf_cgroup_storage_type cgroup_storage_type(
> > > > >  	struct bpf_map *map)
> > > > >  {
> > > > > @@ -280,6 +287,26 @@ int bpf_percpu_cgroup_storage_update(struct =
bpf_map *map, void *key,
> > > > >  	__ret;								       \
> > > > >  })
> > > > > =20
> > > > > +#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, opt=
val, optlen)   \
> > > > > +({									       \
> > > > > +	int __ret =3D 0;							       \
> > > > > +	if (cgroup_bpf_enabled)						       \
> > > > > +		__ret =3D __cgroup_bpf_run_filter_setsockopt(sock, level,	    =
   \
> > > > > +							   optname, optval,    \
> > > > > +							   optlen);	       \
> > > > > +	__ret;								       \
> > > > > +})
> > > > > +
> > > > > +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, opt=
val, optlen)   \
> > > > > +({									       \
> > > > > +	int __ret =3D 0;							       \
> > > > > +	if (cgroup_bpf_enabled)						       \
> > > > > +		__ret =3D __cgroup_bpf_run_filter_getsockopt(sock, level,	    =
   \
> > > > > +							   optname, optval,    \
> > > > > +							   optlen);	       \
> > > > > +	__ret;								       \
> > > > > +})
> > > > > +
> > > > >  int cgroup_bpf_prog_attach(const union bpf_attr *attr,
> > > > >  			   enum bpf_prog_type ptype, struct bpf_prog *prog);
> > > > >  int cgroup_bpf_prog_detach(const union bpf_attr *attr,
> > > > > @@ -349,6 +376,8 @@ static inline int bpf_percpu_cgroup_storage_u=
pdate(struct bpf_map *map,
> > > > >  #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
> > > > >  #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type,major,minor,acces=
s) ({ 0; })
> > > > >  #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,po=
s,nbuf) ({ 0; })
> > > > > +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, opt=
val, optlen) ({ 0; })
> > > > > +#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, opt=
val, optlen) ({ 0; })
> > > > > =20
> > > > >  #define for_each_cgroup_storage_type(stype) for (; false; )
> > > > > =20
> > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > index e5a309e6a400..fb4e6ef5a971 100644
> > > > > --- a/include/linux/bpf.h
> > > > > +++ b/include/linux/bpf.h
> > > > > @@ -1054,6 +1054,8 @@ extern const struct bpf_func_proto bpf_spin=
_unlock_proto;
> > > > >  extern const struct bpf_func_proto bpf_get_local_storage_proto;
> > > > >  extern const struct bpf_func_proto bpf_strtol_proto;
> > > > >  extern const struct bpf_func_proto bpf_strtoul_proto;
> > > > > +extern const struct bpf_func_proto bpf_sk_fullsock_proto;
> > > > > +extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > > > > =20
> > > > >  /* Shared helpers among cBPF and eBPF. */
> > > > >  void bpf_user_rnd_init_once(void);
> > > > > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.=
h
> > > > > index 5a9975678d6f..eec5aeeeaf92 100644
> > > > > --- a/include/linux/bpf_types.h
> > > > > +++ b/include/linux/bpf_types.h
> > > > > @@ -30,6 +30,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRIT=
ABLE, raw_tracepoint_writable)
> > > > >  #ifdef CONFIG_CGROUP_BPF
> > > > >  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
> > > > >  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl)
> > > > > +BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt)
> > > > >  #endif
> > > > >  #ifdef CONFIG_BPF_LIRC_MODE2
> > > > >  BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
> > > > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > > > index 43b45d6db36d..7a07fd2e14d3 100644
> > > > > --- a/include/linux/filter.h
> > > > > +++ b/include/linux/filter.h
> > > > > @@ -1199,4 +1199,23 @@ struct bpf_sysctl_kern {
> > > > >  	u64 tmp_reg;
> > > > >  };
> > > > > =20
> > > > > +struct bpf_sockopt_kern {
> > > > > +	struct sock	*sk;
> > > > > +	s32		level;
> > > > > +	s32		optname;
> > > > > +	u32		optlen;
> > > > It seems there is hole.
> > > Ack, will move the pointers up.
> > >=20
> > > > > +	u8		*optval;
> > > > > +	u8		*optval_end;
> > > > > +
> > > > > +	/* If true, BPF program had consumed the sockopt request.
> > > > > +	 * Control is returned to the userspace (i.e. kernel doesn't
> > > > > +	 * handle this option).
> > > > > +	 */
> > > > > +	bool		handled;
> > > > > +
> > > > > +	/* Small on-stack optval buffer to avoid small allocations.
> > > > > +	 */
> > > > > +	u8 buf[64];
> > > > Is it better to align to 8 bytes?
> > > Do you mean manually set size to be 64 + x where x is a remainder
> > > to align to 8 bytes? Is there some macro to help with that maybe?
> > I think __attribute__((aligned(8))) should do.
> Ah, you meant to align the buffer itself to avoid unaligned
> access from the bpf progs. Got it, will do.
>=20
> > >=20
> > > > > +};
> > > > > +
> > > > >  #endif /* __LINUX_FILTER_H__ */
> > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > index 7c6aef253173..b6c3891241ef 100644
> > > > > --- a/include/uapi/linux/bpf.h
> > > > > +++ b/include/uapi/linux/bpf.h
> > > > > @@ -170,6 +170,7 @@ enum bpf_prog_type {
> > > > >  	BPF_PROG_TYPE_FLOW_DISSECTOR,
> > > > >  	BPF_PROG_TYPE_CGROUP_SYSCTL,
> > > > >  	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
> > > > > +	BPF_PROG_TYPE_CGROUP_SOCKOPT,
> > > > >  };
> > > > > =20
> > > > >  enum bpf_attach_type {
> > > > > @@ -192,6 +193,8 @@ enum bpf_attach_type {
> > > > >  	BPF_LIRC_MODE2,
> > > > >  	BPF_FLOW_DISSECTOR,
> > > > >  	BPF_CGROUP_SYSCTL,
> > > > > +	BPF_CGROUP_GETSOCKOPT,
> > > > > +	BPF_CGROUP_SETSOCKOPT,
> > > > >  	__MAX_BPF_ATTACH_TYPE
> > > > >  };
> > > > > =20
> > > > > @@ -2815,7 +2818,8 @@ union bpf_attr {
> > > > >  	FN(strtoul),			\
> > > > >  	FN(sk_storage_get),		\
> > > > >  	FN(sk_storage_delete),		\
> > > > > -	FN(send_signal),
> > > > > +	FN(send_signal),		\
> > > > > +	FN(sockopt_handled),
> > > > Document.
> > > Ah, totally forgot about that, sure, will do!
> > >=20
> > > > > =20
> > > > >  /* integer value in 'imm' field of BPF_CALL instruction selects =
which helper
> > > > >   * function eBPF program intends to call
> > > > > @@ -3533,4 +3537,15 @@ struct bpf_sysctl {
> > > > >  				 */
> > > > >  };
> > > > > =20
> > > > > +struct bpf_sockopt {
> > > > > +	__bpf_md_ptr(struct bpf_sock *, sk);
> > > > > +
> > > > > +	__s32	level;
> > > > > +	__s32	optname;
> > > > > +
> > > > > +	__u32	optlen;
> > > > > +	__u32	optval;
> > > > > +	__u32	optval_end;
> > > > > +};
> > > > > +
> > > > >  #endif /* _UAPI__LINUX_BPF_H__ */
> > > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > > index 1b65ab0df457..4ec99ea97023 100644
> > > > > --- a/kernel/bpf/cgroup.c
> > > > > +++ b/kernel/bpf/cgroup.c
> > > > > @@ -18,6 +18,7 @@
> > > > >  #include <linux/bpf.h>
> > > > >  #include <linux/bpf-cgroup.h>
> > > > >  #include <net/sock.h>
> > > > > +#include <net/bpf_sk_storage.h>
> > > > > =20
> > > > >  DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
> > > > >  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> > > > > @@ -924,6 +925,142 @@ int __cgroup_bpf_run_filter_sysctl(struct c=
tl_table_header *head,
> > > > >  }
> > > > >  EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
> > > > > =20
> > > > > +static bool __cgroup_bpf_has_prog_array(struct cgroup *cgrp,
> > > > > +					enum bpf_attach_type attach_type)
> > > > > +{
> > > > > +	struct bpf_prog_array *prog_array;
> > > > > +	int nr;
> > > > > +
> > > > > +	rcu_read_lock();
> > > > > +	prog_array =3D rcu_dereference(cgrp->bpf.effective[attach_type]=
);
> > > > > +	nr =3D bpf_prog_array_length(prog_array);
> > > > Nit. It seems unnecessary to loop through the whole
> > > > array if the only signal needed is non-zero.
> > > Oh, good point. I guess I'd have to add another helper like
> > > bpf_prog_array_is_empty() and return early. Any other suggestions?
> > I was thinking to check empty_prog_array on top but it is
> > too overkilled, so didn't mention it.  I think just return
> > early is good enough.
> [..]
> > I think this non-zero check is good to have before doing lock_sock().
> And not before the allocation? I was trying to optimize for both kmalloc
> and lock_sock (since, I guess, the majority of the cgroups would not
> have any sockopt progs, so there is no point in paying the kmalloc
> cost as well).
+1
