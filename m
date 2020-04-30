Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57971BF0CD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD3HFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 03:05:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12318 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgD3HFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 03:05:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U74720031480;
        Thu, 30 Apr 2020 00:05:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KyLgUGPHR2RFljmdvoABe8Xu/oRB9tDxRhsx4plBj7Q=;
 b=YN+tmo3rQwRPg19gVdontUz2WgOai856sI4eEhws+YdrIr7Yhqdozyt33lj7fAwVC6Z1
 mU0sZotq/S6IAxeBYW0DWCx9ClJbRPkkgMwKpCCKOTqoNaDjv4n9fjdJFPfXQEgwm1m3
 LMqWiQ2BBA9IffkyHVumAeoo5QHJAktg8YE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30qd20m5mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Apr 2020 00:05:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 30 Apr 2020 00:05:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx+g4f1V/NLxQDyzPSo+Qfj0vK7YBZvGgy6OuW4vKFhjgVZjJYYAkJqyUPrItA4hgYxfcCpfNIRlutY6A4z8FibJFoE5Lk/F3VLvXSM9cstACnrwO2L/VD/qD0igGhkc4KWx0kI/mfttTPximTQ75ishtQoC+FXZYTSQXYzB35LCkBSPIxOGOiWIaN6sVtN/1BHvVuBwdAoNVmrjZXlCX1ojzvcErbvGO3N7nglf8sBh4yMNJVOdFzaWGktqfLFojE/ZVtTn6VfPwrPxwXaKcvESHW5lwQhvMkN2Pb/9w144794XYlFWEeCy3S/VkR7q457vpx3czln42j4mBAdDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyLgUGPHR2RFljmdvoABe8Xu/oRB9tDxRhsx4plBj7Q=;
 b=i0K2UtGPN4CMj+Eh4uY48OSiPVu5oaRrcqcu/UNqmRCfaFJQMcEPSwDf6D1OwsUrqtcq76biY4rKnLSBNc96vURuGLLs9xlRulbF2AHiKAHGsweq0jkZzXFTJQYyILcKhRNTPNm9s2i5/kFAwg6fgKVQi0k3BKBY7kX4PFW+t2OuBiRD9rfmtidemIgvWcuEjyiP4q2ub4NAf+k29vt29KuIQkGghyT0UDP4ult/EBipP4RMpv6P93CNyROesvj6oWvBf2u7P+oNC9iN7z2adbzNH/0vrP4pSepfiY4FWKuQVF7JGh9It2UXOF9ZKRhwY/36RmkZOmsZJxZkfm4Hkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyLgUGPHR2RFljmdvoABe8Xu/oRB9tDxRhsx4plBj7Q=;
 b=aYqcqhEbKa/8PUSnOMHfHEkZ5XFgxU26AnuOjlxyli199yu6Wp2vv3ofXKj07vz3CjG50jHRO76+fk1ha175jIYMOwY9DIzJu69fTEYvRTJ9Key8Ahwq1+NAUxtqNOVv03KDGuqEZ4HH0ZZPb2DIXznvpDFs/KQZHQHqUrmJNAY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3160.namprd15.prod.outlook.com (2603:10b6:a03:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 07:05:34 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 07:05:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Topic: [PATCH v8 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Index: AQHWHfHXX0bY47IdGEmyZ33wIke0UqiQ8LMAgAAvRACAAB6xgIAAAO+A
Date:   Thu, 30 Apr 2020 07:05:33 +0000
Message-ID: <B7D5E149-4B31-4808-BFEF-9C7C48FB8A0D@fb.com>
References: <20200429064543.634465-1-songliubraving@fb.com>
 <20200429064543.634465-4-songliubraving@fb.com>
 <CAEf4BzZNbBhfS0Hxmn6Fu5+-SzxObS0w9KhMSrLz23inWVSuYQ@mail.gmail.com>
 <C9DC5EF9-0DEE-4952-B7CA-64153C8D8850@fb.com>
 <222fc0f5-2073-2f2d-2079-b564f12287b8@fb.com>
In-Reply-To: <222fc0f5-2073-2f2d-2079-b564f12287b8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:67b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3b2739b-5fed-4aaa-4979-08d7ecd4e090
x-ms-traffictypediagnostic: BYAPR15MB3160:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB31604D30652CA5B0D24058C9B3AA0@BYAPR15MB3160.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E3kFaVAaWdUfDAG97LnOntv2A3hdBsvLbDM9HB5q5SWt+ikVW14O83ZJPw/CyGVwde2UIHYC7FCg8i+6jg2bw3/WmkNC7Wbk1sRCU0p6YDpFq0hcsyBrnA+SSDHa8j5427b8JQFugXGyDbx4dY7mKC3wOwwmWxnVCSejWW3ewgZSDoLR7SDe7NpGqgwFuMvwXSeo3QA8Wxe2GfGU8UETNfcAG5A4+aUgAYndVFrJodS7rLdvuJp+uQDHVtJjTfFucbpej6fOwSrZniy5PDraU7wYXNh1kbrFlhHrb1llgaKK2213Eanh31yaLj61b3iEIlgJX2VfiFWqn3fIcTtp7GI9Pc2iVkOyGg52ogmcLFcjmXQ7yfjTcjM7uzJCj7/bKltAm3Jgb38YJUP48h4Y0fcflNXQnOou54vE1bXElXgRMYmpJ3wlVpaKkl5AhzTl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(37006003)(316002)(66556008)(6636002)(64756008)(76116006)(66946007)(66446008)(186003)(66476007)(4326008)(6862004)(91956017)(6486002)(33656002)(71200400001)(6506007)(2906002)(8676002)(478600001)(5660300002)(2616005)(8936002)(54906003)(53546011)(36756003)(86362001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7mmEWaRm/Sc+i1Mnda4HlO3Am2rdZ7PWdno4FvBYg5od79YB7nhRcYxH/g/MLvwIwAyMuADryrrhtwCunlEHVmL/ApaZyzT35dKlZ+UgPKwSnu5lu9IMF+Np6ixBsBCJzxR69LBN64CCx8Ru2TRZaCH9zbux5jxlEg5KRPx4HY+N2a8PJREG5whcP+y8CAwQCjayGNB2dEJmUc3wiM/fshqVfObZKDJCY5ih6rXEJrhXdw1k5eqRWEnl3ZnKCO4k6bDHNCvB9HVwMjQtdlpB3lWyUSPfAghaXTTJHYST8wdHF0S5h9SCmRjVlraPo+2dAflEdO9VkeqwaT4hFhQwHHsPzA5fuG4x+Pt7LGpyw3HJMZiDM6nR6BtzL/YcIiWdaOzib8YFDC2SCNCthlXr8/XTteEeWdQhrslqW/U3yONPQmBxyFIwysmNCXYuGy8Mol5o+oEBvSyhtqpxvKVK0Jh2P8pnJ8AVZHTehy4aWUUSsBNdUDEEgMFWJoTsGPO1/E4Evy7CYuJABATKc3d8AGu2b1nstAS/RWsNjJxPti9Uh6iVfQgI7YLWNtZJrORkAfnaYJPPv1vMdy8aeF/pKZCpuPKXPD+cOzWV7j6lUKhvDWn4IMrJVho3/w4TCxoBQk1PeVWuY4gQ7AsVdBGXus9m2UajjHhm9EgIH2UqyXCb/YvuVuSpkjXLFWm8X3Fnn5ri98htQwrdcVp0H5Hha+TZQNPmK4zmeMOxEt/pTm4lkIL4snPksE0g0cYwEE9SjfGFn82iPBBsF/S4OGilk7+3EpIf/YW70Qr4m9vBAyVGF3A7fkHRVv8WnwJLVmMZ+Kq0Q8r1hzZv7DRDNIskYg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DFAC98321DA7994184988C11DB9B2571@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b2739b-5fed-4aaa-4979-08d7ecd4e090
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 07:05:33.9419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WPiSRPHW2T1Onln5FkU7Tzy4Pz9inyGSG8nh7brvqRjP66G+rFaMYDImSAjOx0xfBvHB/U93Qf+U/B16g3F2IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3160
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 30, 2020, at 12:02 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 4/29/20 10:12 PM, Song Liu wrote:
>>> On Apr 29, 2020, at 7:23 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Tue, Apr 28, 2020 at 11:47 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>> Add test for BPF_ENABLE_STATS, which should enable run_time_ns stats.
>>>>=20
>>>> ~/selftests/bpf# ./test_progs -t enable_stats  -v
>>>> test_enable_stats:PASS:skel_open_and_load 0 nsec
>>>> test_enable_stats:PASS:get_stats_fd 0 nsec
>>>> test_enable_stats:PASS:attach_raw_tp 0 nsec
>>>> test_enable_stats:PASS:get_prog_info 0 nsec
>>>> test_enable_stats:PASS:check_stats_enabled 0 nsec
>>>> test_enable_stats:PASS:check_run_cnt_valid 0 nsec
>>>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>>>=20
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>> .../selftests/bpf/prog_tests/enable_stats.c   | 46 +++++++++++++++++++
>>>> .../selftests/bpf/progs/test_enable_stats.c   | 18 ++++++++
>>>> 2 files changed, 64 insertions(+)
>>>> create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats=
.c
>>>> create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats=
.c
>>>>=20
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/t=
ools/testing/selftests/bpf/prog_tests/enable_stats.c
>>>> new file mode 100644
>>>> index 000000000000..cb5e34dcfd42
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
>>>> @@ -0,0 +1,46 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +#include <test_progs.h>
>>>> +#include <sys/mman.h>
>>>=20
>>> is this header used for anything?
>> Not really, will remove it.
>>>=20
>>>> +#include "test_enable_stats.skel.h"
>>>> +
>>>> +void test_enable_stats(void)
>>>> +{
>>>=20
>>> [...]
>>>=20
>>>> +
>>>> +char _license[] SEC("license") =3D "GPL";
>>>> +
>>>> +static __u64 count;
>>>=20
>>> this is actually very unreliable, because compiler might decide to
>>> just remove this variable. It should be either `static volatile`, or
>>> better use zero-initialized global variable:
>>>=20
>>> __u64 count =3D 0;
>> Why would compile remove it? Is it because "static" or "no initialized?
>> Would "__u64 count;" work?
>=20
> It is because of "static". This static variable has file scope and the
> compiler COULD remove count+=3D1 since it does not have any other effect
> other than incrementting itself and nobody uses it.
>=20
>> For "__u64 count =3D 0;", checkpatch.pl generates an error:
>> ERROR: do not initialise globals to 0
>> #92: FILE: tools/testing/selftests/bpf/progs/test_enable_stats.c:11:
>> +__u64 count =3D 0;
>=20
> I think this is okay.
>=20
> For llvm10, you have to use `__u64 count =3D 0`.
> For llvm11, you can use "__u64 count", the compiler changed global "commo=
n" variable treatment default from as a "common" var
> to as a "bss" var.
>=20
> In selftest, we have numerous cases for `__u64 count =3D 0` style
> definitions and I recommend to use it as well since probably
> quite some people uses llvm10 to compile/run selftests.

Thanks for the explanation. Will send fixed version shortly.

Song

