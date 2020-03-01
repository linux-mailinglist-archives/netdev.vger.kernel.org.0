Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B0217509C
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgCAWhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 17:37:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6748 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbgCAWhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 17:37:22 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 021MYEBZ012192;
        Sun, 1 Mar 2020 14:37:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=L2DqkoUGsjMxBFQpu7SQfxSPRyZzhphnDqYoLl9z1Pk=;
 b=q1LgQoL7a5FgBL+IjaYIVGWDyHTZnurC3oLJKBWOspFEElshgpRZ1/boggPtPum2hsFd
 1eDLFzrgZ0OXDmyDZVVCE5OVo6tkPyWWV6f9ipUI00E4FrAkC1keEuijwgpYeWpTrlZt
 JTr9JiIdZNqFxLDpSr9GsKJOFjvZSJYxjT8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8kw9yp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 01 Mar 2020 14:37:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 14:37:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7SY+tByfIm2Frcxl99U6KXJpAZepF5kAdgpauXYEHaRsxrpZgiwgi/z3e/pR19C7ANRlnpk/T8taRxwHWKM9KnRv0L9YUYvHpK8MSMDkLEds94gCtDtRVK2aFQmZV3Jhq+Dba8J0McnlZDfaTsHkqDHuCiPoH1bGfHBzDPQsWw+ZdVgv0H8IucFHkpa3gjHFvTLADycdH1YKsVKgxSfBAXhsKitf9NFiVtVuY1sjc45A0HOdzhjWlU6rKdyNiKWoKc2aLScPpiXKD3f045nU7sRs9tguFwD6naCG8b5E1LL4eRepGlAK/2oRhRLe+BbkaV7543oVYoDiDI7CyElzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2DqkoUGsjMxBFQpu7SQfxSPRyZzhphnDqYoLl9z1Pk=;
 b=CwDQtD1ER7rrNmzcFgYRDpuMsf1dfCWIlx1OfhrF5QgBDpfqfg0I+3F0rnTMhlBZb9bkVGQ6PtCVZQa4+8cdjKUp0NceuDitzQxL+GqyWm9TsemlwY9f9SCzvzas87W9+QrrGaNDLAux8Px63SYUCXODXdiuma4ew3CRw7dJT30HfzNsPICQKiR/BUUl0M78+tLQJo8R4vfVJ2spDaedpN7SCFMMh4fI3KbgrOGoG8YeIA2A1P3GPMXx9KN/4smgc1H4jlbVS80fFDe3Kgoh/3nhK9FoOYWMiWM33DbkC8+EVOeUAUuMynXWCEBT2kU+13H4oly3OFhfz/T2Ka5M3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2DqkoUGsjMxBFQpu7SQfxSPRyZzhphnDqYoLl9z1Pk=;
 b=HXff7YBoOhSeMFFpLjofjYMco97/JGBaTs316XXrdkndYS2szGxTAIlp+IrvPPSxQ72H9CJc/nWP4q+6FWexcPO552TrpOYrsXkFDHTiEcr5LgdvAcC2bai7EkFv+lvF8fAC51NdZf02WA5eoNcv68N4Fg9S2qTIIQf9qZw14TY=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Sun, 1 Mar
 2020 22:37:06 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 22:37:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
Thread-Topic: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile"
 command
Thread-Index: AQHV7pCRwZ1HBc6vtU2QEGEJ7IlYy6gzHKIAgAE6GwA=
Date:   Sun, 1 Mar 2020 22:37:06 +0000
Message-ID: <2FFDA2FF-55D3-41EC-8D6C-34A7D1C93025@fb.com>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
 <07478dd7-99e2-3399-3c75-db83a283e754@fb.com>
In-Reply-To: <07478dd7-99e2-3399-3c75-db83a283e754@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c091:480::1:fe2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a9571cb-22fd-41de-25e8-08d7be311269
x-ms-traffictypediagnostic: MW3PR15MB3980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3980EA15AD13BA8A5CB78348B3E60@MW3PR15MB3980.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(136003)(39860400002)(376002)(199004)(189003)(2906002)(66946007)(6512007)(186003)(8936002)(86362001)(33656002)(478600001)(36756003)(66556008)(6636002)(71200400001)(6506007)(66476007)(81156014)(53546011)(8676002)(81166006)(37006003)(54906003)(316002)(6862004)(6486002)(4326008)(5660300002)(76116006)(64756008)(66446008)(91956017)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3980;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 52V5OvdK1qvDhnedo7wpeMneGOGoFN3ova1HKL32ek5xb588rNSJATsuy6Q2vvBN53NMvcLqHsbJqLbR1YIPFBjpj7M+w+BXOvm7199WvXMSJvfSq8uHWmF9YtNIrwmVfFxG55jeI/yLP8wcEm9dGP/9mOWChnaCubUbuhY6cyeyf2cIAWl4Dn3JId829zFLG3YcWjo9UgMuwMTgArT0DxypUwjHfH6F8GOq3zVvrFPOFJ4F5shpeOPeRkiOwHeQmSqVTYqQq1hC7S1Wdlny70TSj2aCnJr/kU3reo+PmLFlS7ecIjr6+O5F9OLW86r/gXil++/d68iQSYn5eQMtp+3gZahM9Db9lJ67e+s1KIDXCw9KePNx+J9BExDBT7terup2JpS7R02ucjmxMySoq19kfVKzVjYYanV4NIJOfaSRUXVZR/nMLCfKgTnYqBLZ
x-ms-exchange-antispam-messagedata: oVdAKRq/q33Ci7hzdmtZhiAO7QmjX1ZtvMQZHmkQBD7Nr/8BpOFJ3Pz40bbRInqArEo0CNQavszLzjtlWsWtOtNZ1CJ1CWRG39Xiq3BHfhawb1P4cmDw19bjVYYWlMalak5uKN+9fwIy1LAV2G/RQYieuv0A3U/OXWNjovhV9AWtScpDDqMdxQPZxXIwgdz/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9448B294FF8E7043BB383C7AF67C5A77@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9571cb-22fd-41de-25e8-08d7be311269
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2020 22:37:06.6087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /JlvJwvODOugOBgRQh4722pGBvm0O9kNlsClV0RBCBoLqIiRPTO6+PVG90Hcw+Fqffh2S54qLZ/FGVQBC+PbIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3980
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_08:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 29, 2020, at 7:52 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 2/28/20 3:40 PM, Song Liu wrote:
>> With fentry/fexit programs, it is possible to profile BPF program with
>> hardware counters. Introduce bpftool "prog profile", which measures key
>> metrics of a BPF program.
>> bpftool prog profile command creates per-cpu perf events. Then it attach=
es
>> fentry/fexit programs to the target BPF program. The fentry program save=
s
>> perf event value to a map. The fexit program reads the perf event again,
>> and calculates the difference, which is the instructions/cycles used by
>> the target program.
>> Example input and output:
>>   ./bpftool prog profile 3 id 337 cycles instructions llc_misses
>>         4228 run_cnt
>>      3403698 cycles                                              (84.08%=
)
>>      3525294 instructions   #  1.04 insn per cycle               (84.05%=
)
>>           13 llc_misses     #  3.69 LLC misses per million isns  (83.50%=
)
>> This command measures cycles and instructions for BPF program with id
>> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
>> output is similar to perf-stat. In this example, the counters were only
>> counting ~84% of the time because of time multiplexing of perf counters.
>> Note that, this approach measures cycles and instructions in very small
>> increments. So the fentry/fexit programs introduce noticeable errors to
>> the measurement results.
>> The fentry/fexit programs are generated with BPF skeletons. Therefore, w=
e
>> build bpftool twice. The first time _bpftool is built without skeletons.
>> Then, _bpftool is used to generate the skeletons. The second time, bpfto=
ol
>> is built with skeletons.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  tools/bpf/bpftool/Makefile                |  18 +
>>  tools/bpf/bpftool/prog.c                  | 428 +++++++++++++++++++++-
>>  tools/bpf/bpftool/skeleton/profiler.bpf.c | 171 +++++++++
>>  tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
>>  tools/scripts/Makefile.include            |   1 +
>>  5 files changed, 664 insertions(+), 1 deletion(-)
>>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>>  create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>> index c4e810335810..c035fc107027 100644
>> --- a/tools/bpf/bpftool/Makefile
>> +++ b/tools/bpf/bpftool/Makefile
>> @@ -59,6 +59,7 @@ LIBS =3D $(LIBBPF) -lelf -lz
>>    INSTALL ?=3D install
>>  RM ?=3D rm -f
>> +CLANG ?=3D clang
>>    FEATURE_USER =3D .bpftool
>>  FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zlib
>> @@ -110,6 +111,22 @@ SRCS +=3D $(BFD_SRCS)
>>  endif
>>    OBJS =3D $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
>> +_OBJS =3D $(filter-out $(OUTPUT)prog.o,$(OBJS)) $(OUTPUT)_prog.o
>> +
>> +$(OUTPUT)_prog.o: prog.c
>> +	$(QUIET_CC)$(COMPILE.c) -MMD -DBPFTOOL_WITHOUT_SKELETONS -o $@ $<
>> +
>> +$(OUTPUT)_bpftool: $(_OBJS) $(LIBBPF)
>> +	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(_OBJS) $(LIBS)
>> +
>> +skeleton/profiler.bpf.o: skeleton/profiler.bpf.c
>> +	$(QUIET_CLANG)$(CLANG) -g -O2 -target bpf -c $< -o $@
>=20
> With a fresh checkout, applying this patch and just selftests like
>  make -C tools/testing/selftests/bpf
>=20
> I got the following build error:
>=20
> make[2]: Leaving directory `/data/users/yhs/work/net-next/tools/lib/bpf'
> clang -g -O2 -target bpf -c skeleton/profiler.bpf.c -o skeleton/profiler.=
bpf.o
> skeleton/profiler.bpf.c:5:10: fatal error: 'bpf/bpf_helpers.h' file not f=
ound
> #include <bpf/bpf_helpers.h>
>         ^~~~~~~~~~~~~~~~~~~
> 1 error generated.
> make[1]: *** [skeleton/profiler.bpf.o] Error 1
>=20
> I think Makefile should be tweaked to avoid selftest failure.

Hmm... I am not seeing this error. The build succeeded in the test.=20

Thanks,
Song=
