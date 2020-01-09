Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051ED136347
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgAIWgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:36:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45980 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728435AbgAIWgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 17:36:09 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009MZhod004104;
        Thu, 9 Jan 2020 14:35:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BCY7AntPGC/6KEn+e5e1999mTaXG8RPVT60sP/qtdWc=;
 b=HZrgGfdvt75cTjvnfoaOa7k0ErjajVnrCHe4FL65Wll/CbR8m8fk9evlkLm8wAvLDl1s
 xV36VZZdEMlebxs2hnE8MdVpr/iBvNnCMFW1yjbXdl0LKmj6lCUxu1ErkDLUDT+hQ2/x
 UiytgFkWoDiV7c+6uPu4khps7lw6es70lg0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xec3hgbu0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Jan 2020 14:35:50 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 9 Jan 2020 14:35:49 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 9 Jan 2020 14:35:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afPjzTqnZaUO/p167qBCaCMVa/XvIovXyxueP/sJz4rEDjyUJF4GDyRCGdxLQLVFluh7t+aWRveCN+8voFck76y0vqqsSD8jh7Y6B24ceR61AbvYCNwwbH2d0zbrh9i7ybcRWwfuWevKlmwSwuYjXxjDkQD+AKu5liCvQ7LiMD4cuBqge+ICqwxJLDusQgf6tLoCWHbQyi23trDL5x1Xz7v99b7u56pYmCUNwEiF5skVIqdc3THwYalDBLhWWDZLW/wO6eD9g4/clV3g6Egv3cRghR24LG/NzLb1TLODyQKxf6n0VD39HabzNiQNJpVsHnZDagQf22t4bdaECsozaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCY7AntPGC/6KEn+e5e1999mTaXG8RPVT60sP/qtdWc=;
 b=Fl2OicMdnhUvm/LtiF00POzRISW1h+0rEP1Gvi1F7guri979PwcfuXmhz0BDEdL/DeyLjga5X7yqt2E2XcEbyWKW7EdmiWlPJYZuZtVPN9Rp9+joNbbiUWlO8E4lXzU4wf2QVQUPcErTvYbRrdyAh+wyxRHyhmg2MrpNFK4pa0Z75zex84wbuhXdcxzWMeTRdAIKlsqQwo9IzUoiDSfXZF4Nx1LvN5vI0w+an63IqoDK9dMbFRBpXa79lOosUVX705a4X9cqrYWh92BO7lxQXjAzI0h5cy6WV1avQ1iZJpVX/Bk4xPUvEDo8kdBYtGSAUV7p9OKewGNSArcJuwfenQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCY7AntPGC/6KEn+e5e1999mTaXG8RPVT60sP/qtdWc=;
 b=fUcnH78tIScwNu5tBwX+P/tcHWziu5oOOPvozpYG/zH82Vq151QptGLiPKGRnRwcW4U3gEImXLYw6tRW7pdpX05PKxH3+81/UgGiJ+XeOF2wlBDxdZs9YP2E1g4hB5iyXThYIp4y6+iu46CCgWyUSeW4JJ4hi3KXhunLx83pysU=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3480.namprd15.prod.outlook.com (20.179.60.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Thu, 9 Jan 2020 22:35:48 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Thu, 9 Jan 2020
 22:35:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 7/7] selftests/bpf: Add unit tests for global
 functions
Thread-Topic: [PATCH v2 bpf-next 7/7] selftests/bpf: Add unit tests for global
 functions
Thread-Index: AQHVxrdi37M1YQvCDUm7i8XFOR3xrafilrAAgABO14CAAAdRAA==
Date:   Thu, 9 Jan 2020 22:35:48 +0000
Message-ID: <BFAEDD51-ECBA-4DEB-884E-D3DC9205A0A8@fb.com>
References: <20200109063745.3154913-1-ast@kernel.org>
 <20200109063745.3154913-8-ast@kernel.org>
 <CAPhsuW67HfWZ7JLMWtXSURc97SSP4MOT7d65F+r075qGqpW9Cg@mail.gmail.com>
 <20200109220935.iyabjybd5bsesszy@ast-mbp>
In-Reply-To: <20200109220935.iyabjybd5bsesszy@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:200::455d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eebc2f81-f58d-4f04-67c0-08d795544666
x-ms-traffictypediagnostic: BYAPR15MB3480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34801AFC545BD771CE768FD5B3390@BYAPR15MB3480.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(136003)(376002)(366004)(189003)(199004)(66476007)(76116006)(81166006)(66556008)(64756008)(81156014)(66946007)(6916009)(91956017)(186003)(6512007)(53546011)(66446008)(6486002)(71200400001)(86362001)(478600001)(2616005)(6506007)(316002)(36756003)(2906002)(8676002)(54906003)(5660300002)(4326008)(33656002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3480;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CyI25bg3cJ+Bdz9RLh091K3C50jCWa19XXnofAbliwl8gNy4C6dSnF3lhTnj7JnCRmIAiFoAF4hARYnuhAgG/2Zr5U+iEPnJiKVki9JzUSZkf5hdhWaQ4hy4MfaKQvMVD4hjbZj365qozw7ZKXGULmXAOYWqWtjuwt9cg9B4x/dzIsUpAQaRSyVVe+/fb7boNy+T+1LwTgubaZElDLqq/3ks1NL3bHpYopDRdO5zdIpZqOzgWVv7j3GCm3o+GGT6UYAxTSPnG37brft/+pXuu+CxhvCXZX0B0ScnqHeYH279ziTm/4z21kQfCjUdyfBhqj5TqRnHp0G7vwajLIdVdVLkbhDE+VtjOOohFLc91MmWCTT5HRYgGuKvH7VksVOR/qQgPimUULc9GbpV3gzMmOTvHR9qZ2RJ45DmSeCTA2d0OZ6C9fP2lHuaHHDLh4DJ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11F00CA031EAF24A9D559A2B874EA972@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eebc2f81-f58d-4f04-67c0-08d795544666
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 22:35:48.5613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GzCfFAC5BEcCF9bJ3j9qbsxxR34aV+CjTubH/XqKJlGG0Tye+0nCr+1QsyM7lfosdJhDlPzVvMIyzWt38Md1+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3480
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_05:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 9, 2020, at 2:09 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Jan 09, 2020 at 09:27:26AM -0800, Song Liu wrote:
>> On Wed, Jan 8, 2020 at 10:39 PM Alexei Starovoitov <ast@kernel.org> wrot=
e:
>>>=20
>>> test_global_func[12] - check 512 stack limit.
>>> test_global_func[34] - check 8 frame call chain limit.
>>> test_global_func5    - check that non-ctx pointer cannot be passed into
>>>                       a function that expects context.
>>> test_global_func6    - check that ctx pointer is unmodified.
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>>> ---
>>> .../bpf/prog_tests/test_global_funcs.c        | 81 +++++++++++++++++++
>>> .../selftests/bpf/progs/test_global_func1.c   | 45 +++++++++++
>>> .../selftests/bpf/progs/test_global_func2.c   |  4 +
>>> .../selftests/bpf/progs/test_global_func3.c   | 65 +++++++++++++++
>>> .../selftests/bpf/progs/test_global_func4.c   |  4 +
>>> .../selftests/bpf/progs/test_global_func5.c   | 31 +++++++
>>> .../selftests/bpf/progs/test_global_func6.c   | 31 +++++++
>>> 7 files changed, 261 insertions(+)
>>> create mode 100644 tools/testing/selftests/bpf/prog_tests/test_global_f=
uncs.c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_global_func1.=
c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_global_func2.=
c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_global_func3.=
c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_global_func4.=
c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_global_func5.=
c
>>> create mode 100644 tools/testing/selftests/bpf/progs/test_global_func6.=
c
>>>=20
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c=
 b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
>>> new file mode 100644
>>> index 000000000000..bc588fa87d65
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
>>> @@ -0,0 +1,81 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2020 Facebook */
>>> +#include <test_progs.h>
>>> +
>>> +const char *err_str;
>>> +bool found;
>>> +
>>> +static int libbpf_debug_print(enum libbpf_print_level level,
>>> +                             const char *format, va_list args)
>>> +{
>>> +       char *log_buf;
>>> +
>>> +       if (level !=3D LIBBPF_WARN ||
>>> +           strcmp(format, "libbpf: \n%s\n")) {
>>> +               vprintf(format, args);
>>> +               return 0;
>>> +       }
>>> +
>>> +       log_buf =3D va_arg(args, char *);
>>> +       if (!log_buf)
>>> +               goto out;
>>> +       if (strstr(log_buf, err_str) =3D=3D 0)
>>> +               found =3D true;
>>> +out:
>>> +       printf(format, log_buf);
>>> +       return 0;
>>> +}
>>=20
>> libbpf_debug_print() looks very useful. Maybe we can move it to some
>> header files?
>=20
> I think it's hack that goes deep into libbpf internals that should be
> discouraged. It's clearly very useful for selftests, but imo libbpf's log=
_buf
> api should be redesigned instead. It's imo the worst part of the library.

Yeah, those global variables don't look good.=20

Song


