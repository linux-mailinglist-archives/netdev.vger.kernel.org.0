Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF316B29A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgBXVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:34:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43998 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728018AbgBXVeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:34:19 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OLUuX9030648;
        Mon, 24 Feb 2020 13:34:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/tGeAFuloxvy0TimeDm8jtIMR+M0H/M/w5ztL/MVRbU=;
 b=b+H37FToHM8/C31wz/r9N+mQDR2MhqplEUG7+ILqYSaNSQVHpStwfqQTI+8Q3bG5Dxd7
 x7vTlVH7S3FLzBc22vVpWb177FUNphzA/I8x11HyjP5nzCgjDG2SsTGH+ZO1/iiA36Lg
 ctAifwmM/9Q5N1lOCu+/Jznm5R9EhvdcRAI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ybmvkfde6-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Feb 2020 13:34:06 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 24 Feb 2020 13:34:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2GGwArZw6tt8BwGpAczxKC5xnd/sxrZ9jlMV2bkJhtZlaSNTXRepx9T0r0HhDoGAQdl00SK1ILISFdHX4W1J49pHffLFO+Ip4FVeCh+iyQ3NjNFyGcFNQsFXdrrwn91hIv2qDneqPsWieyirTt/371rRbdDDVioZ1JDuaeISz0leZMZi43jPuwYoIU0+AXKtDVH5yv05g2HTe2Y/A3K90o/yOEusf/CxbiO0VSrRFQjQmbW/QMGiM4nS4K+rdBg7ONlx9SPbNuRB1pTJ+wSFcMjBpJJjMZTzgZIhcTffb8f5mlnVi8m23vlCMEnFRidQmfDnQdb2mjSN5elNiHXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tGeAFuloxvy0TimeDm8jtIMR+M0H/M/w5ztL/MVRbU=;
 b=PrcSV9K6EIEyAXEcurybAgDTLa60YSzbghVLdDFI+mHq7P8HG9VRQuxIjhPxt9dOph9LKzGAoiXopzu2HVJAjDhIoZRgBzw5xVtOIqcJyuKrGBdEzwoo/IorLtjsEFsk/768JBqpeVOsN2uas8OYkD/iCCkNuwsJ9BxqO3265iZFJD4m2qLh+ElWWL6psTsKNzM8UrZdrQoRIrU9r8xrV3q8ohuhH9f29K+2ofPyGP9MI4WEtW4BCO0lD3LwjN7YlpQ5n4uCnSMRgYH9/uHHIXrgQoM2o23Jzh9rm/NKlUylqH+PFjVZzQF5zQ6/5aSbPXZR+geREdb8y/EP6mVUTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tGeAFuloxvy0TimeDm8jtIMR+M0H/M/w5ztL/MVRbU=;
 b=ccyHUkbb7Eic4FYpIc3jnvFqJdQbEVXgc/BXZapXB7niF26RCBV9qF+lacVrZbYJ4GOr0uMb1OTr+atFxBIUea9Z0YhbiTn+ius3qanc4f/rz0dlJv+tuVICWJbQcfj8fcFWozW53HSD70N2tcKaQfw3hufKI5RJkHRNUl0ioIs=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2138.namprd15.prod.outlook.com
 (2603:10b6:302:d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Mon, 24 Feb
 2020 21:33:58 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2729.033; Mon, 24 Feb 2020
 21:33:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: print backtrace on SIGSEGV in
 test_progs
Thread-Topic: [PATCH bpf-next] selftests/bpf: print backtrace on SIGSEGV in
 test_progs
Thread-Index: AQHV6gwwiyPrdK6CkESBdsyCJDQtXKgq4CSA
Date:   Mon, 24 Feb 2020 21:33:58 +0000
Message-ID: <0614970B-8A37-470F-82F3-2F4C36E873C0@fb.com>
References: <20200223054320.2006995-1-andriin@fb.com>
In-Reply-To: <20200223054320.2006995-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:cee2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d816872-8dd6-4b08-822b-08d7b97141ee
x-ms-traffictypediagnostic: MW2PR1501MB2138:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2138F97662F585A63A73DF50B3EC0@MW2PR1501MB2138.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(2616005)(4326008)(33656002)(71200400001)(81166006)(8936002)(2906002)(81156014)(8676002)(53546011)(498600001)(6512007)(6506007)(6862004)(64756008)(6636002)(6486002)(36756003)(66946007)(186003)(76116006)(5660300002)(37006003)(86362001)(66476007)(66556008)(54906003)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2138;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3MdRoLCmoqv68iCr4F8MXNNxIgGZ/QC/f6/TdxNjPZld+W1WBTC3ZSahfGeYT+L8HBpdqq7DWbzWnqndg+pTJ84I97wHEaKgDGCmO6VbcXgLCChm91FloRwbapQbXMcckEBAMnFbaohvqW/6ExhxnqG83QuEhR3ais3Z91FiBditX7MbSO4iwW25v7agdf3GG20n+JMDg+f1p8TipCqKsJpzPk9C87Lp77cOxloDhPegbDNBw4BUImv7SqRlPSMEdrn9BgfQ/WoyS9gVl8mSV2L67DnLh3He+M/QfGrLXeZgZRDrNr3vM5CzRmi0lEJus+HPvhat1tvpTxcrE1/eBgY1nKN6kiIQ3abIaPFDEPEq5ma8an1CNYHWC44QBKFgH8ocCARsww/tcdnXVud+wj2b5T2DhTVzRALbQa7b7sP8UYF94utYSd2esT5gJdIH
x-ms-exchange-antispam-messagedata: gKXpf6a9S0B/BoLvLRTNlBIYA33X9HIgci8TkMZMDVdNhtJGc7fPWJGEcrACZxFMot6UwjOqyxJ7welsZ+BdRNz5C9yKPW8bcXbNDmIoUvHphLktxtmeKIyasV/WosfObk2ugpgWEuim6l5MSGyp1j21Woeqffl3hVx/aBm5KWPn8d4QHxjKDpKWJOVIk2Hy
Content-Type: text/plain; charset="us-ascii"
Content-ID: <39109CCC212F554EBA50698566194DBA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d816872-8dd6-4b08-822b-08d7b97141ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 21:33:58.3078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yl2xlCWg/Vw3uxCo+L2OepdhKvkf8DJxcLLRw5jQtmlHR1IYXc+3nCndHuf7w2dGHPJhdYg48P43bzZOM8LasQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2138
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_11:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002240158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 22, 2020, at 9:43 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Due to various bugs in test clean up code (usually), if host system is
> misconfigured, it happens that test_progs will just crash in the middle o=
f
> running a test with little to no indication of where and why the crash
> happened. For cases where coredump is not readily available (e.g., inside
> a CI), it's very helpful to have a stack trace, which lead to crash, to b=
e
> printed out. This change adds a signal handler that will capture and prin=
t out
> symbolized backtrace:
>=20
>  $ sudo ./test_progs -t mmap
>  test_mmap:PASS:skel_open_and_load 0 nsec
>  test_mmap:PASS:bss_mmap 0 nsec
>  test_mmap:PASS:data_mmap 0 nsec
>  Caught signal #11!
>  Stack trace:
>  ./test_progs(crash_handler+0x18)[0x42a888]
>  /lib64/libpthread.so.0(+0xf5d0)[0x7f2aab5175d0]
>  ./test_progs(test_mmap+0x3c0)[0x41f0a0]
>  ./test_progs(main+0x160)[0x407d10]
>  /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2aab15d3d5]
>  ./test_progs[0x407ebc]
>  [1]    1988412 segmentation fault (core dumped)  sudo ./test_progs -t mm=
ap
>=20
> Unfortunately, glibc's symbolization support is unable to symbolize stati=
c
> functions, only global ones will be present in stack trace. But it's stil=
l a
> step forward without adding extra libraries to get a better symbolization=
.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/testing/selftests/bpf/Makefile     |  2 +-
> tools/testing/selftests/bpf/test_progs.c | 26 ++++++++++++++++++++++++
> 2 files changed, 27 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 2a583196fa51..50c63c21e6fd 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -20,7 +20,7 @@ CLANG		?=3D clang
> LLC		?=3D llc
> LLVM_OBJCOPY	?=3D llvm-objcopy
> BPF_GCC		?=3D $(shell command -v bpf-gcc;)
> -CFLAGS +=3D -g -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)		\
> +CFLAGS +=3D -g -rdynamic -Wall -O2 $(GENFLAGS) -I$(CURDIR) -I$(APIDIR)	\
> 	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR)	\
> 	  -Dbpf_prog_load=3Dbpf_prog_test_load				\
> 	  -Dbpf_load_program=3Dbpf_test_load_program
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/sel=
ftests/bpf/test_progs.c
> index bab1e6f1d8f1..531ab3e7e5e5 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -6,6 +6,8 @@
> #include "bpf_rlimit.h"
> #include <argp.h>
> #include <string.h>
> +#include <signal.h>
> +#include <execinfo.h> /* backtrace */
>=20
> /* defined in test_progs.h */
> struct test_env env =3D {};
> @@ -617,6 +619,22 @@ int cd_flavor_subdir(const char *exec_name)
> 	return chdir(flavor);
> }
>=20
> +#define MAX_BACKTRACE_SZ 128
> +void crash_handler(int signum)
> +{
> +	void *bt[MAX_BACKTRACE_SZ];
> +	size_t sz;
> +
> +	sz =3D backtrace(bt, ARRAY_SIZE(bt));
> +
> +	if (env.test)
> +		dump_test_log(env.test, true);
> +	stdio_restore();
> +
> +	fprintf(stderr, "Caught signal #%d!\nStack trace:\n", signum);
> +	backtrace_symbols_fd(bt, sz, STDERR_FILENO);
> +}
> +
> int main(int argc, char **argv)
> {
> 	static const struct argp argp =3D {
> @@ -624,8 +642,16 @@ int main(int argc, char **argv)
> 		.parser =3D parse_arg,
> 		.doc =3D argp_program_doc,
> 	};
> +	struct sigaction sigact =3D {
> +		.sa_handler =3D crash_handler,
> +		.sa_flags =3D SA_RESETHAND,
> +	};
> 	int err, i;
>=20
> +	env.stdout =3D stdout;
> +	env.stderr =3D stderr;

We have the same code in stdio_hijack(). Maybe remove those in=20
stdio_hijack()?=20

> +	sigaction(SIGSEGV, &sigact, NULL);
> +
> 	err =3D argp_parse(&argp, argc, argv, 0, NULL, &env);
> 	if (err)
> 		return err;
> --=20
> 2.17.1
>=20

