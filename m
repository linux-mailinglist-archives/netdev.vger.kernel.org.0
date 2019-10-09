Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637FFD1A1A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbfJIUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:52:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6646 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729535AbfJIUwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:52:37 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99KltSo015159;
        Wed, 9 Oct 2019 13:52:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IF/Rn6Od3Qm4vg9ZFXEgSZ8J2wIdGcXLLau3N248QbU=;
 b=HJhcCVmVOwEUVnvDAC0oPEtGXL99mXIhdBEHhPFyXvTo2bFCp6VwtGcj76TA7hNklAI7
 Gx4vI9ei62og/7xPjRavmkOKcfdCudrH8hfaqzzEupNsFLcAVkUqJYLPhBcLfJILxnsK
 3ds4OOM61xMCtESz2/A3r/FLzvSywcCdUvs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhfsdtcy2-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Oct 2019 13:52:21 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 9 Oct 2019 13:52:10 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 9 Oct 2019 13:51:58 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 13:51:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtOr5++d+1wuL2kA3Vxt4RaddCpfGgF/ezZxrutkHRL37ckBI0EHMZZRoVq10ZaqgUvXJia7dp0U3xUkCcbKrpAvrOlR/S0FugUYx6lQU4puhmh1+RnMSDE/eTstkVVKrstcEyiP74NwUGt9J6KUxG0Hwyst+kRMILY4u/4p8lpHaS/ynXDbjiheRk7NcTjLpEG0HQ6jPRv12E5QJbkot5FhEe+nHR3B1DcuqDwljl6Ni1nihIIBNZQVEammM2h9Clh9M7P2stYbFUkeQi+LlbxbRvrss4+Tki6yxErfMsgn8min+NPMO6sF29SKT4J3xum77wNEUx0feO/Y3wBEAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF/Rn6Od3Qm4vg9ZFXEgSZ8J2wIdGcXLLau3N248QbU=;
 b=cULa+r6sGrPj9lcqIr33OhI6VhgaPOLHvnRMRL8q10iaiXyVBXgdhO/Uy/1LLnxSweA3JbnnYZiQVKCxZGV4IEo7mcqt1HrFzBquopdD4awm5CqD9xdf0hkLb/l2IahAjm1613lbj68x9xEIROqaIK1pPqVKuZmbYwGAkS+PsUED6V9/C6bN+VLxRRbaRvfZ1Pueg5ioNRlU6SJ6PAWXqOSTjNjOoimd8kvMNlrcoAaiH1xFcUQIoR1WEBmHriO7GU+wtLUyMHBPAEGvdQfCiBqhnKie1bcXuBgis5ViabRVuFS0uUdoClwReqJtnsY1H0SxFY/fs9bl5kh00Na26A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF/Rn6Od3Qm4vg9ZFXEgSZ8J2wIdGcXLLau3N248QbU=;
 b=Uo0ngTcv7+Fr8YPvmpMIbFX4NDIlFKzt/x62dlN5ZrwkNd/N3hsA8agL381dF4mXqhgRPU41e8KMnuabov3t8iagolbI1nI10hkcxCVytpgaoYjS2CNnBBJ6N4IqIqHfSJeqaa4HsPTaDIBNBdpU2fhKjZMeju9ilKcEamofrwc=
Received: from BN8PR15MB3202.namprd15.prod.outlook.com (20.179.76.139) by
 BN8PR15MB2963.namprd15.prod.outlook.com (20.178.218.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 20:51:57 +0000
Received: from BN8PR15MB3202.namprd15.prod.outlook.com
 ([fe80::5016:da37:f569:9c04]) by BN8PR15MB3202.namprd15.prod.outlook.com
 ([fe80::5016:da37:f569:9c04%5]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 20:51:57 +0000
From:   Martin Lau <kafai@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
Thread-Topic: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
Thread-Index: AQHVezo6bMzQtZw9qkGd83P+8iu6oqdS0EwA
Date:   Wed, 9 Oct 2019 20:51:56 +0000
Message-ID: <20191009205152.kfdkm2pvbyiwfelf@kafai-mbp.dhcp.thefacebook.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-4-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-4-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:104:5::20) To BN8PR15MB3202.namprd15.prod.outlook.com
 (2603:10b6:408:aa::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::bba8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3757f3d9-a0d5-49ab-d23d-08d74cfa8592
x-ms-traffictypediagnostic: BN8PR15MB2963:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB29636316955631790D83647BD5950@BN8PR15MB2963.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:506;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(136003)(376002)(396003)(199004)(189003)(14454004)(54906003)(71200400001)(229853002)(6246003)(9686003)(6512007)(1076003)(25786009)(14444005)(256004)(71190400001)(5660300002)(2906002)(6486002)(6436002)(478600001)(66476007)(66446008)(6116002)(186003)(64756008)(8936002)(86362001)(7736002)(316002)(4326008)(66556008)(81166006)(46003)(305945005)(446003)(11346002)(476003)(486006)(76176011)(8676002)(52116002)(66946007)(6916009)(6506007)(99286004)(102836004)(81156014)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2963;H:BN8PR15MB3202.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jnpYhWiLJXJu2xrSUBWCojw2aDczhfJnr8xyEDQafkKoIwX2TImluoVrhKo4NTNk5rR8f1/rse6nKFxOxc5+EJUUotMAVNDJeYZHfRk4eT3xCT9L+8H4lV7a3hfWKmqikFssFGnlvn5C2yqwlP12z7RtDTxGyj3l1R+vCWAmkgSsFXvMJjc1FYlB6hzqr0NQQvbehrBpcXn1G+0aDmTa1g8wrOsQnKQ4360Bbrb/lRFx3aSLHp3Kik7CZfivVOs8HoNnFTI3Y6UkRySDoVHF+OP5cB9qHA/s+OJJZrjvSsPjGDsKGyr7JAcnjU/RMBz7GALdS0FQdrWpE+GX7mnfbQQUfQisxS4ta1yy8j7Ppu5F+Dq+Px+r8H6WkUeTYGGtO5wXwqLbXJnkBezfneevxBX8SrFwRWXBCabh+pMDHq4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4670F9BD1D07E84CA16065BCC7308FCA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3757f3d9-a0d5-49ab-d23d-08d74cfa8592
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 20:51:56.8078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vesuO7ph3VZeHy35CEOM/PZl62i90g4IlE9H6blZAoBVu31Jn8uExHxNTdB7cYX/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2963
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_09:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1011 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 10:03:07PM -0700, Alexei Starovoitov wrote:
> If in-kernel BTF exists parse it and prepare 'struct btf *btf_vmlinux'
> for further use by the verifier.
> In-kernel BTF is trusted just like kallsyms and other build artifacts
> embedded into vmlinux.
> Yet run this BTF image through BTF verifier to make sure
> that it is valid and it wasn't mangled during the build.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf_verifier.h |  4 ++-
>  include/linux/btf.h          |  1 +
>  kernel/bpf/btf.c             | 66 ++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c        | 18 ++++++++++
>  4 files changed, 88 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 26a6d58ca78c..432ba8977a0a 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -330,10 +330,12 @@ static inline bool bpf_verifier_log_full(const stru=
ct bpf_verifier_log *log)
>  #define BPF_LOG_STATS	4
>  #define BPF_LOG_LEVEL	(BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
>  #define BPF_LOG_MASK	(BPF_LOG_LEVEL | BPF_LOG_STATS)
> +#define BPF_LOG_KERNEL (BPF_LOG_MASK + 1)
> =20
>  static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log=
 *log)
>  {
> -	return log->level && log->ubuf && !bpf_verifier_log_full(log);
> +	return (log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
> +		log->level =3D=3D BPF_LOG_KERNEL;
>  }
> =20
>  #define BPF_MAX_SUBPROGS 256
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 64cdf2a23d42..55d43bc856be 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -56,6 +56,7 @@ bool btf_type_is_void(const struct btf_type *t);
>  #ifdef CONFIG_BPF_SYSCALL
>  const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id=
);
>  const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> +struct btf *btf_parse_vmlinux(void);
>  #else
>  static inline const struct btf_type *btf_type_by_id(const struct btf *bt=
f,
>  						    u32 type_id)
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 29c7c06c6bd6..848f9d4b9d7e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -698,6 +698,9 @@ __printf(4, 5) static void __btf_verifier_log_type(st=
ruct btf_verifier_env *env,
>  	if (!bpf_verifier_log_needed(log))
>  		return;
> =20
> +	if (log->level =3D=3D BPF_LOG_KERNEL && !fmt)
> +		return;
> +
>  	__btf_verifier_log(log, "[%u] %s %s%s",
>  			   env->log_type_id,
>  			   btf_kind_str[kind],
> @@ -735,6 +738,8 @@ static void btf_verifier_log_member(struct btf_verifi=
er_env *env,
>  	if (!bpf_verifier_log_needed(log))
>  		return;
> =20
> +	if (log->level =3D=3D BPF_LOG_KERNEL && !fmt)
> +		return;
>  	/* The CHECK_META phase already did a btf dump.
>  	 *
>  	 * If member is logged again, it must hit an error in
> @@ -777,6 +782,8 @@ static void btf_verifier_log_vsi(struct btf_verifier_=
env *env,
> =20
>  	if (!bpf_verifier_log_needed(log))
>  		return;
> +	if (log->level =3D=3D BPF_LOG_KERNEL && !fmt)
> +		return;
>  	if (env->phase !=3D CHECK_META)
>  		btf_verifier_log_type(env, datasec_type, NULL);
> =20
> @@ -802,6 +809,8 @@ static void btf_verifier_log_hdr(struct btf_verifier_=
env *env,
>  	if (!bpf_verifier_log_needed(log))
>  		return;
> =20
> +	if (log->level =3D=3D BPF_LOG_KERNEL)
> +		return;
>  	hdr =3D &btf->hdr;
>  	__btf_verifier_log(log, "magic: 0x%x\n", hdr->magic);
>  	__btf_verifier_log(log, "version: %u\n", hdr->version);
> @@ -2406,6 +2415,8 @@ static s32 btf_enum_check_meta(struct btf_verifier_=
env *env,
>  		}
> =20
> =20
> +		if (env->log.level =3D=3D BPF_LOG_KERNEL)
> +			continue;
>  		btf_verifier_log(env, "\t%s val=3D%d\n",
>  				 __btf_name_by_offset(btf, enums[i].name_off),
>  				 enums[i].val);
> @@ -3367,6 +3378,61 @@ static struct btf *btf_parse(void __user *btf_data=
, u32 btf_data_size,
>  	return ERR_PTR(err);
>  }
> =20
> +extern char __weak _binary__btf_vmlinux_bin_start[];
> +extern char __weak _binary__btf_vmlinux_bin_end[];
> +
> +struct btf *btf_parse_vmlinux(void)
> +{
> +	struct btf_verifier_env *env =3D NULL;
> +	struct bpf_verifier_log *log;
> +	struct btf *btf =3D NULL;
> +	int err;
> +
> +	env =3D kzalloc(sizeof(*env), GFP_KERNEL | __GFP_NOWARN);
> +	if (!env)
> +		return ERR_PTR(-ENOMEM);
> +
> +	log =3D &env->log;
> +	log->level =3D BPF_LOG_KERNEL;
> +
> +	btf =3D kzalloc(sizeof(*btf), GFP_KERNEL | __GFP_NOWARN);
> +	if (!btf) {
> +		err =3D -ENOMEM;
> +		goto errout;
> +	}
> +	env->btf =3D btf;
> +
> +	btf->data =3D _binary__btf_vmlinux_bin_start;
> +	btf->data_size =3D _binary__btf_vmlinux_bin_end -
> +		_binary__btf_vmlinux_bin_start;
> +
> +	err =3D btf_parse_hdr(env);
> +	if (err)
> +		goto errout;
> +
> +	btf->nohdr_data =3D btf->data + btf->hdr.hdr_len;
> +
> +	err =3D btf_parse_str_sec(env);
> +	if (err)
> +		goto errout;
> +
> +	err =3D btf_check_all_metas(env);
> +	if (err)
> +		goto errout;
> +
Considering btf_vmlinux is already safe, any concern in making an extra
call to btf_check_all_types()?

Having resolved_ids and resolved_sizes available will
be handy in my later patch.

> +	btf_verifier_env_free(env);
> +	refcount_set(&btf->refcnt, 1);
> +	return btf;
> +
> +errout:
> +	btf_verifier_env_free(env);
> +	if (btf) {
> +		kvfree(btf->types);
> +		kfree(btf);
> +	}
> +	return ERR_PTR(err);
> +}
> +
