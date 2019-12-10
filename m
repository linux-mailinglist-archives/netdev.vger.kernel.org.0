Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9268D118F67
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfLJR7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:59:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727621AbfLJR7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:59:36 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBAHwX0a002439;
        Tue, 10 Dec 2019 09:59:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zorBJGWG668atPyeKqXErh0ofzt2AkMhpWlOsGLOfuk=;
 b=ORhPR4U9lav33wzr39WJqT8Pio4YjvaL3SEUB1mDNy2cXc7+ITaTSsc/oOmqbYZ/kpxs
 k46F2dnJNzpv0lesw+cYSPo4SrI/6hbJ/Nr9+3e2IhS+4+HlAUOkiNzUyeNtZVv/DV+8
 7c8dKqbxd5fkKdZlyXptXBXpy1UOsXfj6cs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2wrbemq8ts-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 09:59:20 -0800
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Dec 2019 09:59:19 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Dec 2019 09:59:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Dec 2019 09:59:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZLutvl8OyJGrdjafzXdU77XeMfRfnWykAx3Jt9efXMJfdBmB6sAr+SH9Yrj1bZyXZS8nxpxls5Na+C5C7QZEs6DKMoTEANipii4bczlqoKCDtEVgpj36D5rdVdxq2vP/zvphT/BriUCTQA1An16vO67ADra4v5PPtwu0TRcJljgKO/twcFrBufWsqgZ7+ptL6tuKiWPOMOTHMrSCsV/Z9589cLJI1dj7lX8sYtbG7iM5pby375wVDFsSZfnDqCnElafHPekMMuE9SO9FEnB6ATsVWrZHGu/kJr2Pi21f0OqTqQy0n7TJiZDlOPrcy5Qp5M7SjAEeUF2D0RuJ9VQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zorBJGWG668atPyeKqXErh0ofzt2AkMhpWlOsGLOfuk=;
 b=IxzKcUGTc7vKvqy4mvE+hwIYbVpVuuOHXp/FCe0C6jWn4OZH4Xa02cdZoC4P8z+Gunxo3aKFz1OEkpWi1yKzw3OsgfKja0MOwQCuLjdOB0sYI0TknZZmc+MW228BWBENu0kRI/u47rdRVh9z1NLjnPXdbtVvJgsBFjKv54arTwX2rp4mc7CXe2gexonlL7fhaVv0Hz6NKB70NzZRT0/oZZneHmtKc68vtMhszxxYTCM3q4t0cuDL3WXya40/62AhnupVTLV/T+0QG7YjWRBIa5bwG9DRVmvX0kSZEXtj1yBXjbdxWDHi4ay1K/jdQ4oF1athgS7205zITMU6tp6cXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zorBJGWG668atPyeKqXErh0ofzt2AkMhpWlOsGLOfuk=;
 b=L0t+u37EhWaMj99noKh7atMsXKk4+fP82i2q3MIsobgMdg6P8tRmLpAlou5snJObDhgYm1aejiPUVe6vp6g4S7UjjbXLcx1EqXyvwvfKKI3os8iiv5xBU1KSB1omfDuhBeyGLYuBbJLkSQeie3KFKHA7vvMY3jxVv9EB0NSJ2fs=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2863.namprd15.prod.outlook.com (20.178.251.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Tue, 10 Dec 2019 17:59:18 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 17:59:18 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] bpftool: Don't crash on missing jited insns or ksyms
Thread-Topic: [PATCH bpf] bpftool: Don't crash on missing jited insns or ksyms
Thread-Index: AQHVr2Z8gkLcxSYflkOO1ZvZLvptRaezqESA
Date:   Tue, 10 Dec 2019 17:59:18 +0000
Message-ID: <20191210175915.wh7njnvt2xk64ski@kafai-mbp>
References: <20191210143047.142347-1-toke@redhat.com>
In-Reply-To: <20191210143047.142347-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0083.namprd17.prod.outlook.com
 (2603:10b6:300:c2::21) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:85a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f92e4b45-02f3-4870-fb42-08d77d9aad0b
x-ms-traffictypediagnostic: MN2PR15MB2863:
x-microsoft-antispam-prvs: <MN2PR15MB286314CF5AB1B85EDED6C2DBD55B0@MN2PR15MB2863.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(199004)(189003)(81166006)(81156014)(4326008)(8676002)(6486002)(66476007)(6512007)(66946007)(54906003)(5660300002)(9686003)(66556008)(64756008)(6916009)(71200400001)(66446008)(33716001)(8936002)(86362001)(2906002)(6506007)(52116002)(498600001)(1076003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2863;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PDt47IKQtn0z3pr/4bPQOAxn5rFkZy8h+06XEacUMcVE7Y30XHSymaV/m4WTyc08hSpvhBlmfVg0Zkzxj5j4op2lAKlfjeF+iA+hctZ+t0a5aqyaNjf7s2tCnqTbkW1I1ylMQHiBph8XWvLYjmRj5ZJYLJNp/DzvDPBM+eLDyR9YWir3KyGGq38W1SoxfFOrwAhB1+QUdT7cf6pjy9MzGmYGO/x84f1YI2I1rFVlRFH9e61+y2jxAbSKgYQibeMVInSwKdBgenX8r2ABAyOktqB2ahS1EuEwQR7NH+7HA+p86TqXleTIcuZmb0HOAbum2VhnDp8kd2ymnObpsaJhkrV4u/oX8dLAXkNxuLqesmR834Quqe75wpmgrpPUfTP1eoGBfeaABNZIb+MqTXpt5tPH/eBne+ypsfW63wLMnU1Yw6eubnG62RFpst/VMLks
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <E0D461AFA89D374F931568939DF0D7FE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f92e4b45-02f3-4870-fb42-08d77d9aad0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 17:59:18.1311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8O2V6lsUFhs5QCztFe9uFHoQDxBrcn4P6XJwd98VmPZSWY3uxnmks24Ez0ArrgpN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2863
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_05:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=846 priorityscore=1501 clxscore=1015
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 03:30:47PM +0100, Toke H=F8iland-J=F8rgensen wrote:
> When JIT hardening is turned on, the kernel can fail to return jited_ksym=
s
JIT hardening means net.core.bpf_jit_harden?
From the code, it happens on the bpf_dump_raw_ok() check which is
actually "kernel.kptr_restrict" instead?

> or jited_prog_insns, but still have positive values in nr_jited_ksyms and
> jited_prog_len. This causes bpftool to crash when trying to dump the
> program because it only checks the len fields not the actual pointers to
> the instructions and ksyms.
>=20
> Fix this by adding the missing checks.
Changes look good.

>=20
> Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> ---
>  tools/bpf/bpftool/prog.c          | 2 +-
>  tools/bpf/bpftool/xlated_dumper.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 4535c863d2cd..2ce9c5ba1934 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -493,7 +493,7 @@ static int do_dump(int argc, char **argv)
> =20
>  	info =3D &info_linear->info;
>  	if (mode =3D=3D DUMP_JITED) {
> -		if (info->jited_prog_len =3D=3D 0) {
> +		if (info->jited_prog_len =3D=3D 0 || !info->jited_prog_insns) {
>  			p_info("no instructions returned");
>  			goto err_free;
>  		}
> diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated=
_dumper.c
> index 494d7ae3614d..5b91ee65a080 100644
> --- a/tools/bpf/bpftool/xlated_dumper.c
> +++ b/tools/bpf/bpftool/xlated_dumper.c
> @@ -174,7 +174,7 @@ static const char *print_call(void *private_data,
>  	struct kernel_sym *sym;
> =20
>  	if (insn->src_reg =3D=3D BPF_PSEUDO_CALL &&
> -	    (__u32) insn->imm < dd->nr_jited_ksyms)
> +	    (__u32) insn->imm < dd->nr_jited_ksyms && dd->jited_ksyms)
>  		address =3D dd->jited_ksyms[insn->imm];
> =20
>  	sym =3D kernel_syms_search(dd, address);
> --=20
> 2.24.0
>=20
