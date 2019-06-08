Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF0C39B7A
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 09:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfFHHJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 03:09:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52862 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbfFHHJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 03:09:10 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5878Nog020718;
        Sat, 8 Jun 2019 00:08:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jtY6UEax00JfBTwSuTsSRuXrYRn1eVzDHu9iEntf1DU=;
 b=OSRUrGZ2lCA/Bm/HCnDlcQyWS5nGVR8vFBrqD1OKALBlvX8Ubi5N/Qrg4g/W4n+9kzTE
 whinOR3D4LZ/4tL/B+Hfrke7AoMg8+zIjmmDQITVN24T7748gCXfMd9k6NmXuqqbvQ3C
 4UeHRcLvyqgHUDX7YxWP1mtz7xr7ErWkTt4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sywsmsjq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 08 Jun 2019 00:08:45 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 8 Jun 2019 00:08:44 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 8 Jun 2019 00:08:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtY6UEax00JfBTwSuTsSRuXrYRn1eVzDHu9iEntf1DU=;
 b=Y47j8i4AYAgV1KpnLyuujV95wmxbDwCm4X627hXfFqHjcIKDHK7M7g71W/vRa8XlrPr/S1bwExpTdGrXzhl/kJzGhXjRCRHH0oRABuvXog0qkOJZWRBDDmoF2lJd3YKZByK4syFVyCUcpsibqLLpwd6nzcB2KIMICtlQ7Ff2esg=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHSPR00MB05.namprd15.prod.outlook.com (10.175.142.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Sat, 8 Jun 2019 07:08:42 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Sat, 8 Jun 2019
 07:08:42 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 1/8] bpf: implement getsockopt and setsockopt
 hooks
Thread-Topic: [PATCH bpf-next v3 1/8] bpf: implement getsockopt and setsockopt
 hooks
Thread-Index: AQHVHU484Mlm6IDY2kuK+Ji3uF7VuqaRV2AA
Date:   Sat, 8 Jun 2019 07:08:41 +0000
Message-ID: <20190608070838.4vhwss4anyibju53@kafai-mbp.dhcp.thefacebook.com>
References: <20190607162920.24546-1-sdf@google.com>
 <20190607162920.24546-2-sdf@google.com>
In-Reply-To: <20190607162920.24546-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0073.namprd07.prod.outlook.com (2603:10b6:100::41)
 To MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:14ab]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2368bee7-2d57-4ece-b52c-08d6ebe022fa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHSPR00MB05;
x-ms-traffictypediagnostic: MWHSPR00MB05:
x-microsoft-antispam-prvs: <MWHSPR00MB052D26AFBFD225A29BF61ED5110@MWHSPR00MB05.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:175;
x-forefront-prvs: 0062BDD52C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(39860400002)(376002)(396003)(199004)(189003)(66946007)(73956011)(229853002)(6436002)(64756008)(66476007)(66446008)(66556008)(6486002)(102836004)(256004)(5024004)(86362001)(7736002)(14444005)(5660300002)(6916009)(14454004)(6116002)(478600001)(4326008)(25786009)(6512007)(6246003)(9686003)(53936002)(1076003)(2906002)(6506007)(486006)(446003)(386003)(76176011)(316002)(8676002)(54906003)(52116002)(46003)(68736007)(8936002)(99286004)(81166006)(81156014)(476003)(71200400001)(71190400001)(11346002)(305945005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHSPR00MB05;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U3Ja/OlnK1Kv9mP8ZL9R73Ukfx+rLhpcsIcCep16Zxg4/QTPvJNXfwRD9EH0Q7mXXr0PMS9gkiG/DBsjdSV5WxoQbwFmvdcHetJHGQtBacg7EwuHtU8FwP9B+DDITDggVAJFooUjgJazH1MhuQfHIs6pAC7UkA5IpOfMltqWsDLjLEaH1TP+Q/glt1VHf/n3ysCXaUzdIOR3J1svxkYNytwCQ/wxHBRdsTlRZU0pGfo426VmA0+/8hie1DX9Ww+FgP764RQHMAizMLfV8AJd0GOJpWpAcBd8RJdVFH4va+Rckf1yyqB9otFPFopRGxxWq5L+jMhDob0gJpKlxaXAAALig3iBrUAg8DoZSKkacFbm3KJOqKLebO2s2VcfIVVMdNA8bjGVrN5EzuMf/mi+XwSTM+Qb5aFCYcaQOoAuTco=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AEFF13EA65976A49B744F16E01D8B9C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2368bee7-2d57-4ece-b52c-08d6ebe022fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2019 07:08:41.7696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB05
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 09:29:13AM -0700, Stanislav Fomichev wrote:
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

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 1b65ab0df457..4fc8429af6fc 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c

[ ... ]

> +static const struct bpf_func_proto *
> +cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *p=
rog)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_sk_fullsock:
> +		return &bpf_sk_fullsock_proto;
May be my v2 comment has been missed.

sk here (i.e. PTR_TO_SOCKET) must be a fullsock.
bpf_sk_fullsock() will be a no-op.  Hence, there is
no need to expose bpf_sk_fullsock_proto.

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
> +		if (size !=3D sizeof(struct bpf_sock *))
Based on my understanding in commit b7df9ada9a77 ("bpf: fix pointer offsets=
 in context for 32 bit"),
I think it should be 'size !=3D sizeof(__u64)'

Same for the optval and optval_end below.

> +			return false;
> +		info->reg_type =3D PTR_TO_SOCKET;
> +		break;
> +	case bpf_ctx_range(struct bpf_sockopt, optval):
offsetof(struct bpf_sockopt, optval)

> +		if (size !=3D sizeof(void *))
> +			return false;
> +		info->reg_type =3D PTR_TO_PACKET;
> +		break;
> +	case bpf_ctx_range(struct bpf_sockopt, optval_end):
offsetof(struct bpf_sockopt, optval_end)

> +		if (size !=3D sizeof(void *))
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
As mentioned above, this change is also not needed.

Others LGTM.

>  	.func		=3D bpf_sk_fullsock,
>  	.gpl_only	=3D false,
>  	.ret_type	=3D RET_PTR_TO_SOCKET_OR_NULL,
> @@ -5636,7 +5636,7 @@ BPF_CALL_1(bpf_tcp_sock, struct sock *, sk)
>  	return (unsigned long)NULL;
>  }
> =20
