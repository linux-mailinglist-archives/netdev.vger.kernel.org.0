Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81BD15AF68
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBLSIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:08:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgBLSIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:08:18 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CI6jnU003452;
        Wed, 12 Feb 2020 10:07:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MPLbRckCaYwEizaE4Q7cpIhkXuTMlf9q1OKhCcUYf24=;
 b=ZZ1oV7fknd9p4ojFQPs8n413hAD435tW56x8jHh10gPucwhEq0ch3C58ApdHckpWXxno
 8cPQzpGtCTBQwCXwgVgZuozqy3rhbg9QQyo77qERmtcg2UfjPSwPZddS+bUHwHG/Rwj7
 MtV1kkqGNdVrAZ/ibVu27ZYhswanZ664qnA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y4gq7svkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Feb 2020 10:07:17 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 12 Feb 2020 09:56:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NS6Lx6LiF4eATG4HjfENmYV3jqCWuDdVuCVwZER8mJP+XD013nRQROEEv3AZ17QfqZ1Co5x02pr4c9FlJiZ1Z35IedwoOanqXadV4jSEAPNDADBFKA7qHCDBYyfrCiTCuzvCgLwLF6Xivy+/yJEa7Q02/troEN9s2Uzj/2MliV1CGwJLQ9guvfGfTmxlKYUK0pN/y7hNb606ZvWCWQ+P8+dY9Ico4INxvz4OjMg2yURjuSnD8BceSiMdMT8bdrIotSfknlzRm5zup7HzhIt6n0MTycLe7GvnPtaIeRQFLjp+yqmRw2pkzhAzWHqXa6cnhlfDIiVbGqBxEigfqnLzHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPLbRckCaYwEizaE4Q7cpIhkXuTMlf9q1OKhCcUYf24=;
 b=MBqAOc0AWbEXqJ8KIZzV0O/hI+oZpXYtJ/HzSWXfvV02ATXVR83NKPCRYXnOZnC53Vudk4SyRsSwpTmJKXsMWFhIpS2Ef6+a1ipQ8DMILA37e6fAQ9LuyRmSOCdylTe5qX/UxaiKJOHddBwDJpvBVlI2E7V4rCbcM27JCBsKx7wlUI8xba8F8U9noFhRS5yM40bugyLS+FSHPuy4cWKgbezx5ZcbwsUAKAN64BJEPolDlr0GUeh+XcIad4ilwwUZK5Zzr1v11U6BT3hrfBN61Elhp2Um0lM0AQe4AlQlKVoqp4GtNQzh2pNpC51pHNr/MxGDceSjT4RGzVotlzMBFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPLbRckCaYwEizaE4Q7cpIhkXuTMlf9q1OKhCcUYf24=;
 b=djymgGJtpclGA2gJ2npglACNOo4Yr2kPFe5CHN5KVzy5VctLulgyoaY/CimMo4+8Fpw8MHFTRunfvOh38xuWBawpoDGRUH4IpjmKf5NKJCcMLUy5E8huvsfLplN3M2YKhKNYS9fa9rLPmuoBeH8k3fTytRS1b8oEozlkjAPvTw0=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com (52.132.153.155) by
 MW2PR1501MB2107.namprd15.prod.outlook.com (52.132.153.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 17:56:29 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 17:56:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach
 target
Thread-Topic: [PATCH bpf-next] libbpf: Add support for dynamic program attach
 target
Thread-Index: AQHV4aBmkuDy8vU+NUWdt8DKhmBCX6gX0g0AgAAGM4A=
Date:   Wed, 12 Feb 2020 17:56:29 +0000
Message-ID: <628E972C-1156-46F8-AC61-DB0D38C34C81@fb.com>
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
 <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com>
In-Reply-To: <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f48e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c219fb5-16fd-4e8d-ba87-08d7afe4e374
x-ms-traffictypediagnostic: MW2PR1501MB2107:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2107D364EE0BD079E776FACDB31B0@MW2PR1501MB2107.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(2906002)(76116006)(4326008)(66556008)(8676002)(81166006)(64756008)(66446008)(66946007)(66476007)(6486002)(6916009)(498600001)(81156014)(54906003)(8936002)(2616005)(71200400001)(6512007)(33656002)(5660300002)(36756003)(6506007)(53546011)(86362001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2107;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OPxDwwuSjVy/8FKkbh+A3LqbkQobhN2IEpCDxT/G4YV+fXlcuCRWhC1ijz1V0D+T7/Ys8/UkgO5tZPiPdTPqfP+BiOCHKIOFNVw28AaiYd+cRUZhEbbjzXJUCRQE4rm91fdc+xdbCyhJd617oFNdbuZphRDgC3CFl6V4LdwQbykdoz1FVYx5ha2P38b0uK0qoYE7MmBspXOdlukXLwC9S0BnUgvjvsjKeVP4Dg4obkbCck1Mv5bl5nSsh+uWGk0j8VYZaDCKdSp34xkQHP7cCLeG6EHED87Et6iRKKlQSDnCJzra4GJO7x235OCswWBMgGTPe1T4y+545bUmbUeilHmjn7YPdqTu21nueZV7O4OlvgLKDY2paP5MI5uvwYx0SfbYfiE5lnGZfkU3hFOO8CFF/aGz7Q6qtn1I8i+HuB4AOQKzrl7sVrugZz2Vq8ul
x-ms-exchange-antispam-messagedata: xg0169nJQMjFiS7+9eHbMjvc0h6k1lJ3bQlbPTROLdInCS/+LpI3MT2dmXcKm457dXTEDm2eIa6PJGLPJN8slX2AJ5TAYeMzrFoY+I/VBd/juZ3IAOZPP/QSP+pPj6z7FzyqdrB1YeaDZkHQqIRaayniFZ8KDvqK+o3eArU1L49DW+YIYU+W8BVPGO+EDlue
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <E076DF190D24EA4E88E25A33B55FA9AA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c219fb5-16fd-4e8d-ba87-08d7afe4e374
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 17:56:29.8047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TshWmRQHFugPmasMBvfm4MbRKHqrNgeF5mhnn/fnEzkvtUzWWPB5kfFYQB4TSFuzSTXoa7aKfoNELo13iCCT9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2107
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_08:2020-02-12,2020-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 mlxscore=0 clxscore=1011 malwarescore=0 adultscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002120132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 12, 2020, at 9:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Wed, Feb 12, 2020 at 4:32 AM Eelco Chaudron <echaudro@redhat.com> wrot=
e:
>>=20
>> Currently when you want to attach a trace program to a bpf program
>> the section name needs to match the tracepoint/function semantics.
>>=20
>> However the addition of the bpf_program__set_attach_target() API
>> allows you to specify the tracepoint/function dynamically.
>>=20
>> The call flow would look something like this:
>>=20
>>  xdp_fd =3D bpf_prog_get_fd_by_id(id);
>>  trace_obj =3D bpf_object__open_file("func.o", NULL);
>>  prog =3D bpf_object__find_program_by_title(trace_obj,
>>                                           "fentry/myfunc");
>>  bpf_program__set_attach_target(prog, xdp_fd,
>>                                 "fentry/xdpfilt_blk_all");
>>  bpf_object__load(trace_obj)
>>=20
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>


I am trying to solve the same problem with slightly different approach.=20

It works as the following (with skeleton):

	obj =3D myobject_bpf__open_opts(&opts);
	bpf_object__for_each_program(prog, obj->obj)
		bpf_program__overwrite_section_name(prog, new_names[id++]);
	err =3D myobject_bpf__load(obj);

I don't have very strong preference. But I think my approach is simpler?=20

Thanks,
Song


diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..4c29a7181d57 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -238,6 +238,8 @@ struct bpf_program {
        __u32 line_info_rec_size;
        __u32 line_info_cnt;
        __u32 prog_flags;
+
+       char *overwritten_section_name;
 };

 struct bpf_struct_ops {
@@ -442,6 +444,7 @@ static void bpf_program__exit(struct bpf_program *prog)
        zfree(&prog->pin_name);
        zfree(&prog->insns);
        zfree(&prog->reloc_desc);
+       zfree(&prog->overwritten_section_name);

        prog->nr_reloc =3D 0;
        prog->insns_cnt =3D 0;
@@ -6637,7 +6640,7 @@ static int libbpf_find_attach_btf_id(struct bpf_progr=
am *prog)
 {
        enum bpf_attach_type attach_type =3D prog->expected_attach_type;
        __u32 attach_prog_fd =3D prog->attach_prog_fd;
-       const char *name =3D prog->section_name;
+       const char *name =3D prog->overwritten_section_name ? : prog->secti=
on_name;
        int i, err;

        if (!name)
@@ -8396,3 +8399,11 @@ void bpf_object__destroy_skeleton(struct bpf_object_=
skeleton *s)
        free(s->progs);
        free(s);
 }
+
+char *bpf_program__overwrite_section_name(struct bpf_program *prog,
+                                         const char *sec_name)
+{
+       prog->overwritten_section_name =3D strdup(sec_name);
+
+       return prog->overwritten_section_name;
+}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3fe12c9d1f92..02f0d8b57cc4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -595,6 +595,10 @@ bpf_program__bpil_addr_to_offs(struct bpf_prog_info_li=
near *info_linear);
 LIBBPF_API void
 bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);

+LIBBPF_API char *
+bpf_program__overwrite_section_name(struct bpf_program *prog,
+                                   const char *sec_name);
+
 /*
  * A helper function to get the number of possible CPUs before looking up
  * per-CPU maps. Negative errno is returned on failure.
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b035122142bb..ed26c20729db 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -235,3 +235,8 @@ LIBBPF_0.0.7 {
                btf__align_of;
                libbpf_find_kernel_btf;
 } LIBBPF_0.0.6;
+
+LIBBPF_0.0.8 {
+       global:
+               bpf_program__overwrite_section_name;
+} LIBBPF_0.0.7;=
