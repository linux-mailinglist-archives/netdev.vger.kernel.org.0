Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593C723B231
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgHDBSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:18:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbgHDBSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:18:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0741GC62022014;
        Mon, 3 Aug 2020 18:18:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vVPUf2eLCJAhMVvObJsKJbMgRrsYaJpZ6oPfEhClreE=;
 b=lqCl7QgfdiZWo7p9qt2g336Z3tj+osLY8VprK+dX+PrWKeTLAtfQ1q57NKRkSRukiitB
 Mej/6ir7NhORej2I15jjiPcAjoCOaIV6R+F5lTSpYmHrSEzp+/yNPMUqezZBvIonb7Nd
 njnRgB82ScV/trkad7gQCM5pbzQY3JgQvok= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nr82fn7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Aug 2020 18:18:22 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 18:18:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/aY9WN21zb4Pn9VZscTt2yPscVh2V+f8wgJmXgGxqFK/DPxktoOO1bqnoYmNS7F81Ajd4/7WFf6fO03xhBLcmM5kK7mUcIbckYdcs4ogQNbMVrRDiJ36ieyJ/s6w8OR0pEXi8ADGbwHJGXMnU1VXWAydS7qTuk1SXYFfL/0c0UWlreLjIyUioChONOOsOnamlWpqEIeM96gMhCz2ghRvsntZ/QYIpUK/dyikwIQDB28OOMoaJ9i5Ty3+eviff6JuK8fnx3Bv3xMirzZF3QA4rNWDykM8o211/j1dZOb/tAUItlXEWMevQ5eHMEKVzUqnzo+zvqRTpxBBaP69XKK/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVPUf2eLCJAhMVvObJsKJbMgRrsYaJpZ6oPfEhClreE=;
 b=eUjfed4hB9ygxoePaT7HbivEC9i4+GNrgM3WlgWhw8YiyZPfPUTIa8oZK3XX4/svoTVfXrTPBsO09PImQTRzlkWIoFSZWJCfmpxoFyRS1ZsP1mD2F7B7+a7ScmLTHnWkW6k5LaUgeUsq6JZacq1L7sfIbIaK9EryXVfmv6FJkB5+I79RzxWlCrlu9fIZpDL0Fg3Des8tUjI04IuLlQ1Mir/gmfgCo9LvgipIraAgVxxDFWh70KFe/voyXxtNaaUKGGvBtDDi9ELTq6czhP2sKG1o1QKB2xlrH8Vro+zAgVhjX/hDY6MMBMEL6BiHpzKNMoqzkNA9GOS/TqCHfQQVxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVPUf2eLCJAhMVvObJsKJbMgRrsYaJpZ6oPfEhClreE=;
 b=KhyDEYwQKtsBQCsL9louC1kKabOfCBtCy/mQqdxH4Wepeft+PeLNjCp8b7UQ3B+VYIXjcP2X9RLi6enCyTnplYiSeU0cycoov6/9O1PATbVetCU++FIz26YXkj/EHsctFtns0thNIjhuWVDQwy6fgkXKhv1Dl6eUUoXS4D/qn34=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Tue, 4 Aug
 2020 01:18:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.021; Tue, 4 Aug 2020
 01:18:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
Thread-Topic: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
Thread-Index: AQHWZ+C4tQwFkmvi20aNhPcONSrEz6klnl6AgAGMFwA=
Date:   Tue, 4 Aug 2020 01:18:07 +0000
Message-ID: <9C1285C1-ECD6-46BD-BA95-3E9E81C00EF0@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com>
 <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9865b02e-8027-4843-ce25-08d838143e79
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2693E7F51223C682F2458B4FB34A0@BYAPR15MB2693.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/YGbkSe2zc4VVqw0r4jf1pRJ1qBt0Iba80mCQB7+u0MSOAMno7XyzXylPfxf2FR2RYyOdn7W3aZnYlqmrsiBdvfPQhDYlTbOykWXU7mPD173HAs9ZIchmf3aL3pFSDS30GRErk4s1gFoDWi+wH7VwpN5Sj3XFP9wpsJoWMkMOGygKHaifrKe7iFBE+QsheNXeC4MkpY+E0U4Bw5OZcHyWAZqsU9maJCkfOtXqB9TCBZlaW2DQZ4iXXDIhckFnZNHLuYpnbdwZ1QEYxKAnvazFAxSXDnPcR/vROVa6fwmgSgq66uTwQ/0TUckAe/j3+JQEBOiG6OaNfM+PgxhcvHpsjcrXHLogx/Romixomras2TnUgrrI6CD7xOUHUfoIDl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(366004)(376002)(346002)(39860400002)(4326008)(66556008)(66446008)(186003)(64756008)(66476007)(66946007)(76116006)(6506007)(53546011)(6512007)(83380400001)(8936002)(2616005)(71200400001)(33656002)(316002)(36756003)(8676002)(86362001)(478600001)(2906002)(54906003)(6486002)(6916009)(5660300002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iNhmAAjKeyw4jYIFtDzqKeeiF/dwPxWqlX+awvIB/3LeB0N6tsrjl7ql2Ncqu8nwqHNW8Xde/b8uta/8BsfVmqJMLNbfMM6A9eGjKPPx03MYp2qPNSJ6myfQbGjL7w6/4R/+LaRwYRSOpSXOfRX5hfOE8ux32wL3NKzL9oy+LgL9EvvkZ1lIeGMPXgtIaCS7A9rcprgGWWSLQB814xftkaXqHte4xXzlSv7H4wt1D/N/MKXvcOM9cA7nzjtWP7ioY+pqTX0BF0DbDZAgmwJAoHbW0Y0rmKsAR5Xs3Qjg959Uaa7q4ff+lb3+rUwhcOa2WDsEiTc5i4HZ80BhBpPYuKV1WMDeDtSxEo/l6TFy5lhm6ONDsnedrnUFHHirDQKRqtyfGjlx8vIiIFCsKppnGOYOw7S6IiAOdyQH+wAX5vr7rpWrGZCk1dN6XDm9LEhXnZmDxRzrjihRg07PwCUTZbLnVm5jxTXw++0pUQLQnOzDRNB0ms0nvYUNeRxVYW47X+nrUAAaSU/ylasHyPrfTjRt34DoS68NIMNPmrsoPK1v7zn6g8wzbR2U5Mi69Yg0teYGpujYV68MOGaW4m2ISFYwQOzPmGdTJ375ap4QEj22YMFD1a2YA2IdNYQ5wFzxUefPTti1L6iIVnRJXwSP/Iyxh6xdbVUNKZoYmk9a44A=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <315A3851BDFF80449BCB9484B9D7176D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9865b02e-8027-4843-ce25-08d838143e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 01:18:07.0197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbvif2SbYOzQCVsPrZxv9bL9T0BWqSNMfKWLYcG2eQ2D2CJocPHaIfB6O8skWMj8JepdFI9ZdExa9CIrVhhytw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008040007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>>=20

[...]

>=20
>> };
>>=20
>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *te=
st_attr);
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index b9f11f854985b..9ce175a486214 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] =3D=
 {
>>        BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
>>        BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
>>        BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOC=
AL),
>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
>=20
> let's do "user/" for consistency with most other prog types (and nice
> separation between prog type and custom user name)

About "user" vs. "user/", I still think "user" is better.=20

Unlike kprobe and tracepoint, user prog doesn't use the part after "/".=20
This is similar to "perf_event" for BPF_PROG_TYPE_PERF_EVENT, "xdl" for=20
BPF_PROG_TYPE_XDP, etc. If we specify "user" here, "user/" and "user/xxx"=20
would also work. However, if we specify "user/" here, programs that used=20
"user" by accident will fail to load, with a message like:

	libbpf: failed to load program 'user'

which is confusing.=20

Thanks,
Song

[...]

