Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1EB7B50E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfG3VeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:34:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbfG3VeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:34:18 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ULVopV028663;
        Tue, 30 Jul 2019 14:33:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=c7fW76zsJDRgIUYUVInZsgOFpu165fw3z8wmfA60isA=;
 b=lXCr5FcJq+ggWObAOok1x+hQ8veZ8+ffJ857/1+ov/4yAwI098wWbu/Xz3Fsg4rlHWlj
 Ir6lb9dQyx9+SEEpO2aLJFt1ItDlZ8gUmlS4I25wtU2rM5jL7kQSNddDawKxeVlvXvxK
 oKS8DfXs6jP/oCRa95nIr3RKX4+ESiaAapE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u2uy0rdvu-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 14:33:58 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 14:33:17 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 14:33:16 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 14:33:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W64m2H4emBiD9XHsReV6s9VexPJjcjmoUOeig50l/ypE+gfvhoQEzJTOky+2bE/qj4dp/sCleGqYFAOwkYmeAaZkcs8WH5MYEGUXhV9iuDhskFVD6a5KElARGKw6p0pdOFFHyn+cMn29jCxPGRdso8ZBqQugAYDBfIji8SLu8hH14qtnnWjeyGt/4LCP2nQSa7MrF/pL3bfff1WIzb6fBgQXQjJr841Po/5PlaqT4o4TmPR1CBGsdvGXNDZVg+IiHwupROlO1zjSuO8XA0oKqPiEYTsyxG5zMbOjOIyl9fiZ8nt2YzhPD/DfLkLGqogU7DUB/8FEmLSXC0Z5eHRJlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7fW76zsJDRgIUYUVInZsgOFpu165fw3z8wmfA60isA=;
 b=OnRECaOkWUaNsmp8bgm1+Alixacw0MDOARbzqMJGKuuXuKhn07B/vsbPnF80LTzEOLGaspGiCGE5PDcZ6dELdCdqhT/CbJ2FmdMA9Bh99+NDt1P62jTWwqOwhsbl4RPla0irXPtO+hnVPOOSJT1AYJ6FUTYiUSN/y7jVDScWmZnDUlMU8AJPKRblAghDlgviS1CZbXIqUa9i0nn6ZgzIIgklX+nmgf9UbiENeOVhOBojUBS4B2fGlUUsCvBf99zmO7v8rfSkIIjlGiqOCgtouDv0g/l4R/ALBAM3/C+sm7eCDp1VpXc2U3IW++ff82vyXUqVA5lFyp6Mpbm61NdCDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7fW76zsJDRgIUYUVInZsgOFpu165fw3z8wmfA60isA=;
 b=FZ3fbUH7rp1EPfzCnP+ccsKmsDIMx/z8+qQN/tj/lfCIw8pKO2+UEDsPF5MnkjJowgbUamvQUm9uOdDiBrkctcjEeo/wSbDsK/se5iCsejA49+iAZ93rzFhIAJmRxsPR27jpYw7Nc7A1IYP4SQFAVBZ5epGap5oAwAG3pkZ/wm4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1840.namprd15.prod.outlook.com (10.174.99.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.11; Tue, 30 Jul 2019 21:33:15 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 21:33:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/12] selftests/bpf: add BPF_CORE_READ
 relocatable read macro
Thread-Topic: [PATCH v2 bpf-next 03/12] selftests/bpf: add BPF_CORE_READ
 relocatable read macro
Thread-Index: AQHVRxC5ijGhYs8+0EOSm0twzvUWnKbjrD4AgAAAcACAAAH6gA==
Date:   Tue, 30 Jul 2019 21:33:15 +0000
Message-ID: <505D545B-4BAF-4278-A36F-92F455A169D1@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-4-andriin@fb.com>
 <87422673-525B-461B-B487-EB16386CAB25@fb.com>
 <CAEf4BzakowCqkCkBdGPJCZNU3MpDf1yBhzOXL2pos1tPiUH0mQ@mail.gmail.com>
In-Reply-To: <CAEf4BzakowCqkCkBdGPJCZNU3MpDf1yBhzOXL2pos1tPiUH0mQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:5cb8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 025be03b-12d1-47aa-608a-08d71535883c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1840;
x-ms-traffictypediagnostic: MWHPR15MB1840:
x-microsoft-antispam-prvs: <MWHPR15MB1840165CE64978A18CF25FA8B3DC0@MWHPR15MB1840.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(366004)(136003)(396003)(199004)(189003)(66476007)(81156014)(476003)(25786009)(81166006)(64756008)(102836004)(6512007)(76116006)(66446008)(8676002)(8936002)(6246003)(66946007)(2906002)(4326008)(14454004)(446003)(53936002)(256004)(66556008)(99286004)(6916009)(14444005)(76176011)(36756003)(71190400001)(11346002)(46003)(486006)(57306001)(86362001)(186003)(2616005)(68736007)(6116002)(71200400001)(50226002)(316002)(7736002)(305945005)(6506007)(6486002)(53546011)(5660300002)(54906003)(6436002)(33656002)(229853002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1840;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tNwrICLPxcxPnxOI3N2jjeg0pmeHjX9u94KmX7oh4o6E2PpIvrB8wV5PuKW/mqzBC14nwHW1oXKDBIZdhxz5zmjQkHBFRqMILc5wqC5dbMDOktgLazAOQkRVhRGZB1zEk6p6B2ZkaWDpsxRJMQL5WKORZbWGAop/oP0umuEngaq2FyhfQOpnMnQ1/suYDgWJDFcpYte1kNEhGgOtXJCpD02uiOaBZ5SPAtDkwcBc+q34uod3Ojz4mRVk6fgR/h4H7Rou0AXim00uDj+s2GyODHN7M7AeLYeCFztMT2BFHwVb6Nh79aGN0ud2+Ap1uFVRB8+ijzLMQMubonncwQq50ZlSXFCfFTUgGWpeedI5lqqiL7m+pmTl7HPesceW/mDSzv6tWn73JNxxrORVMtH79rZ/XirluqhDyWDjwXGUkeI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E9DB73162339A4680782CBF2F653BCE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 025be03b-12d1-47aa-608a-08d71535883c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 21:33:15.6620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 2:26 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Jul 30, 2019 at 2:24 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Add BPF_CORE_READ macro used in tests to do bpf_core_read(), which
>>> automatically captures offset relocation.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> tools/testing/selftests/bpf/bpf_helpers.h | 19 +++++++++++++++++++
>>> 1 file changed, 19 insertions(+)
>>>=20
>>> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/=
selftests/bpf/bpf_helpers.h
>>> index f804f210244e..81bc51293d11 100644
>>> --- a/tools/testing/selftests/bpf/bpf_helpers.h
>>> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
>>> @@ -501,4 +501,23 @@ struct pt_regs;
>>>                              (void *)(PT_REGS_FP(ctx) + sizeof(ip))); }=
)
>>> #endif
>>>=20
>>> +/*
>>> + * BPF_CORE_READ abstracts away bpf_probe_read() call and captures off=
set
>>> + * relocation for source address using __builtin_preserve_access_index=
()
>>> + * built-in, provided by Clang.
>>> + *
>>> + * __builtin_preserve_access_index() takes as an argument an expressio=
n of
>>> + * taking an address of a field within struct/union. It makes compiler=
 emit
>>> + * a relocation, which records BTF type ID describing root struct/unio=
n and an
>>> + * accessor string which describes exact embedded field that was used =
to take
>>> + * an address. See detailed description of this relocation format and
>>> + * semantics in comments to struct bpf_offset_reloc in libbpf_internal=
.h.
>>> + *
>>> + * This relocation allows libbpf to adjust BPF instruction to use corr=
ect
>>> + * actual field offset, based on target kernel BTF type that matches o=
riginal
>>> + * (local) BTF, used to record relocation.
>>> + */
>>> +#define BPF_CORE_READ(dst, src) \
>>> +     bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index=
(src))
>>=20
>> We should use "sizeof(*(src))"
>>=20
>=20
> Good point. Also (dst) instead of just (dst). Will update.

I think dst as-is is fine. "," is the very last in precedence list.=20

