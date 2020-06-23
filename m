Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CBB2067B8
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgFWWyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:54:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54876 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387656AbgFWWyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:54:12 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NMn4wF030165;
        Tue, 23 Jun 2020 15:53:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ssfuOkTftakwRXLmK/K9W+cJYvjdQhvmbcG5WZiL88I=;
 b=hRbV37Pa6tExxKXVDgMhsfMbpUJ4GMrmvlohTGlgXPqObvVNlPvXkpjNvj4m+NRrnZBo
 s8FQF/zp0rd6aQgaKXtXm0YM+ZMjkQJBJg8ggAophiAyDv9BBMRUBd5nbfNmhGHorEnB
 G4NDnLNLfbF8SBO3BRw9V9slMyUmYUqzl8I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31utqsr1rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 15:53:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 15:53:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/3uyrMvmYg3CmFpiNtO1XM50uU+/MH+VUKThHjc9TqLGJvqzSkeHyDVaxQ9uCvMwzaTFoO9yhR0RbRAvaQ7W+DQv6j2c/ceihl9QP2qXxpZkJFXtHWnUlALfAlhmWQ00sAjHaqjhx2XGxO3AvjGUB55IgiZkq+9CAvQ1NAZdIYUKZfBTUu5RbmBsX/3nzDhq7Me1XgJL4SKDbhEBhBf0rp/tlyJ/x98M9B19mWslcHJtzlB0OQ5Z43eoUNVH5V63+K3uUwyhpxrnr1Y/zw/95BKAja4PdBSKEuu68c22Ejat37P9V1e+xyqPKR2qBdr8gukTtPb9IiNuZpTagyIGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssfuOkTftakwRXLmK/K9W+cJYvjdQhvmbcG5WZiL88I=;
 b=kUn00bxWiTZk2zYI/kE3aP0I/f4Yrtuyj9D0cna6WTcv28BRGbVxF0vrt+SWhUpkj5pbl0G8JO5JTGLvBnp7OyuAuYcTsJPoVcGnOOM5yULTrOMLQ7QIFEIeFNJ7c3bDT5CIDD3Qs1nwrmYxa0y9dhOfv898hklZUkJ3yXW6cDVid+/3IdaDVyl5WJaEVfQLlilDIisS7kSv3uXlJ5F3nNF3K72YGrJ65fjV9kMjKNfLkA4ykoBg8Alc59+DYI7P/NDO+KNYCHMkJZIxssBslMPR7tYDvMFlGAQomHJCAdNPMi4CHaJ0JOhDbLzT8Ciod5RzkmWBmJmrzTaumKOBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssfuOkTftakwRXLmK/K9W+cJYvjdQhvmbcG5WZiL88I=;
 b=SZKzfFUE6kOtMRwFU0oMTryoMAq36ScO6nXVL+P9d5/zhG2xBqJ96STgtfcZ5oEF1HpmeXkYfPc5fm0bwKRzLIcApaT3qz5HAEiayZOldLOeSKaoi2eih4rQ6N9HJbUY7G0c8jS5/8rPwNP/IAQld+YMmYG5OrIMIExOhMpo21g=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2694.namprd15.prod.outlook.com (2603:10b6:a03:158::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 22:53:54 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 22:53:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
Thread-Topic: [PATCH bpf-next 1/3] bpf: introduce helper
 bpf_get_task_stack_trace()
Thread-Index: AQHWSS0VOUl6AqeRSEG9pyL6IiSf06jmiq8AgABFTIA=
Date:   Tue, 23 Jun 2020 22:53:54 +0000
Message-ID: <A91D5293-AA57-4C7B-AC71-472BD966D17B@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-2-songliubraving@fb.com>
 <CAEf4Bzb3_oAyOKKEQ8+Ub5H6aaYQPh15NqyAdQQ+BXjur2Yswg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb3_oAyOKKEQ8+Ub5H6aaYQPh15NqyAdQQ+BXjur2Yswg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:5ffc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0987de5a-d8f4-4af3-baed-08d817c84e37
x-ms-traffictypediagnostic: BYAPR15MB2694:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2694E701B9945E749F67D9D1B3940@BYAPR15MB2694.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aMXjjW4A1rqdKoYNd6nQj1fdykt1yAruXAr8l3al0AMSemtrXLzHWDCRQ6GZY48cQSGyuey4FZpFEN+Nex/U+0fR2TcQCEwgw9n7LYgLp2STiNJnO6mHYUUVut3cTdTxLI3wBVYsG4hYB3KwHCwNEM0VvYQ2K1683T5M2n/8R8iIVV9cfAMDu2ah9/AmhUmZYkCxFA8EcuEpttz2jprg8YMqvGgHN9BIaGkmTKUzh6uMfO86T9BXn591bbTcD7ze6QwRAg/uDWuwFCPXoQeozoWpNDpl1txHfE5frQoY5t4dGsw1Fqxe24+gkaUy3Sqg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(346002)(39860400002)(376002)(316002)(54906003)(71200400001)(83380400001)(2616005)(6486002)(6916009)(478600001)(33656002)(66446008)(66556008)(8936002)(64756008)(66476007)(66946007)(6506007)(6512007)(53546011)(5660300002)(186003)(86362001)(8676002)(4326008)(36756003)(76116006)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MnxLJnBrQpahE/s9eB8hBLWz+BCi3Y5NE5Dt7OQA1CyFfxcHddd2ioOQ2FHJmc61ySH4HJnt8a0TX6PA7ZLIpLA5gYMwuycFvKb49CHd5hIuWJNoawwnypxiET7H0AN2mTUrDVKtdNSXpZa7bdbepOc+uuM8et7zwdQGjQ5MKoeSmtUAn/IQkiNdFLkS9nT7ki5HpFxJ6E81g+HxcgOYxz3bTVs60vUDw0hofbs12LXgHN8Gt9hMBirH7EDGcQSSPK/QtZVhyAr4RUeiMHyyO4d5oM+xKACV0YRf9Gn0V22s4Ge8NfpxHO04lZiAMgmvYMGiaFk6wGc0/z/v4sz6yWQuJLyjasowsUJD7ZEm3q9c48RyJrPkCPHjNJKjdNR9iRaQYO9L0mfn5S6aeMMGsHe4tlHPisTWCclLyhNADSrcIbVxtmblOglCbF/OXhJPj1semupiqdulb2z5CVq6iN8n39/HIQwViZ39dAa20wIe1k9R1f97dAON8+MHldzqCM2KQAOpbq6tXVJE6Q3HMA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14A6284F03FA2F42B9F5D79EBDC357F1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0987de5a-d8f4-4af3-baed-08d817c84e37
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 22:53:54.4199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMUTFdmxt4KZ/2W1T/x0s4TnnMcjtprVnTMHdVibfG9BgVNYya6qj6CRPWXdMGzaegClPG2qoHmbok6OvwNhYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 cotscore=-2147483648 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 11:45 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Tue, Jun 23, 2020 at 12:08 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This helper can be used with bpf_iter__task to dump all /proc/*/stack to
>> a seq_file.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> include/uapi/linux/bpf.h       | 10 +++++++++-
>> kernel/trace/bpf_trace.c       | 21 +++++++++++++++++++++
>> scripts/bpf_helpers_doc.py     |  2 ++
>> tools/include/uapi/linux/bpf.h | 10 +++++++++-
>> 4 files changed, 41 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 19684813faaed..a30416b822fe3 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3252,6 +3252,13 @@ union bpf_attr {
>>  *             case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_l=
evel
>>  *             is returned or the error code -EACCES in case the skb is =
not
>>  *             subject to CHECKSUM_UNNECESSARY.
>> + *
>> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries=
, u32 size)
>> + *     Description
>> + *             Save a task stack trace into array *entries*. This is a =
wrapper
>> + *             over stack_trace_save_tsk().
>> + *     Return
>> + *             Number of trace entries stored.
>>  */
>> #define __BPF_FUNC_MAPPER(FN)          \
>>        FN(unspec),                     \
>> @@ -3389,7 +3396,8 @@ union bpf_attr {
>>        FN(ringbuf_submit),             \
>>        FN(ringbuf_discard),            \
>>        FN(ringbuf_query),              \
>> -       FN(csum_level),
>> +       FN(csum_level),                 \
>> +       FN(get_task_stack_trace),
>=20
> We have get_stackid and get_stack, I think to stay consistent it
> should be named get_task_stack
>=20
>>=20
>> /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>>  * function eBPF program intends to call
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index e729c9e587a07..2c13bcb5c2bce 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -1488,6 +1488,23 @@ static const struct bpf_func_proto bpf_get_stack_=
proto_raw_tp =3D {
>>        .arg4_type      =3D ARG_ANYTHING,
>> };
>>=20
>> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
>> +          void *, entries, u32, size)
>=20
> See get_stack definition, this one needs to support flags as well. And
> we should probably support BPF_F_USER_BUILD_ID as well. And
> BPF_F_USER_STACK is also a good idea, I presume?

This will be a different direction that is similar to stackmap implementati=
on.
Current version follows the implementation behind /proc/<pid>/stack . Let m=
e=20
check which of them is better.=20

Thanks,
Song

