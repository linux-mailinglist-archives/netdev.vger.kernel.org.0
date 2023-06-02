Return-Path: <netdev+bounces-7338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AEC471FBEA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAA622816A2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9644D305;
	Fri,  2 Jun 2023 08:26:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2BC8EC;
	Fri,  2 Jun 2023 08:26:14 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A201810EA;
	Fri,  2 Jun 2023 01:26:07 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3528KFNL020378;
	Fri, 2 Jun 2023 08:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=h70zp1YYaP1c1Q4jhojCWUhiXW7/bbCQSBpBuQKrsYk=;
 b=ZKyyijq2+gSB5mUvHaIAzKgdcWKc2+rZlJuNdUZpp3i+1AxDzso6gNVr8elp5mQBwyih
 OomIUR6D+vNcDkWXO5+Q8gKdQX61v9mU+n8ATTEZhsSMyquxL/gqeLAJVBZk7YCnr/NO
 oU3ylEgDHq41p/+ZeyZAwRAfxpD0pixDUa2+b1z2jjwXH41RE8pHgGKimHI7dxewQMFK
 qG/JI5n4fZ1NsEA8f4Op1Ufyi82NHOm2pflAmpf68/ChszyMGIyROFT+MmhirOJG7UnJ
 fuAPZUf5T/OOaHvM8O1b1iGg+XcC0wMi87WWJDZYZk5Z7j/3GjZOBUP/bp5wvYDBJwQo Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycts82hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 08:24:47 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3528KdJf021011;
	Fri, 2 Jun 2023 08:24:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycts82gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 08:24:46 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3524PFwY029727;
	Fri, 2 Jun 2023 08:24:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qu9g52etr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 08:24:44 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3528OgO620841096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Jun 2023 08:24:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECF0E20043;
	Fri,  2 Jun 2023 08:24:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFDAA20040;
	Fri,  2 Jun 2023 08:24:39 +0000 (GMT)
Received: from [9.171.86.130] (unknown [9.171.86.130])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Jun 2023 08:24:39 +0000 (GMT)
Message-ID: <69103b6f490309c381432cae5fdabf02d80a4397.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: add testcase for
 FENTRY/FEXIT with 6+ arguments
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: menglong8.dong@gmail.com, olsajiri@gmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, benbjiang@tencent.com,
        imagedong@tencent.com, xukuohai@huawei.com, chantr4@gmail.com,
        zwisler@google.com, eddyz87@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Date: Fri, 02 Jun 2023 10:24:39 +0200
In-Reply-To: <20230602065958.2869555-6-imagedong@tencent.com>
References: <20230602065958.2869555-1-imagedong@tencent.com>
	 <20230602065958.2869555-6-imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OZyo1V2gEqpo0OuYbksRCJYMsJID6uEH
X-Proofpoint-GUID: 2OlGBRXo8-YeGGwoA2SUDD3sHjlaOaZ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_05,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-06-02 at 14:59 +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
>=20
> Add test7/test12/test14 in fexit_test.c and fentry_test.c to test the
> fentry and fexit whose target function have 7/12/14 arguments.
>=20
> And the testcases passed:
>=20
> ./test_progs -t fexit
> $71=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fentry_fexit:OK
> $73/1=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/target_no_callees:OK
> $73/2=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/target_yes_callees:OK
> $73/3=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/func_replace:OK
> $73/4=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/func_replace_verify:OK
> $73/5=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/func_sockmap_update:OK
> $73/6=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/func_replace_return_code:OK
> $73/7=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/func_map_prog_compatibility:OK
> $73/8=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/func_replace_multi:OK
> $73/9=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf/fmod_ret_freplace:OK
> $73/10=C2=A0=C2=A0 fexit_bpf2bpf/func_replace_global_func:OK
> $73/11=C2=A0=C2=A0 fexit_bpf2bpf/fentry_to_cgroup_bpf:OK
> $73/12=C2=A0=C2=A0 fexit_bpf2bpf/func_replace_progmap:OK
> $73=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fexit_bpf2bpf:OK
> $74=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fexit_sleep:OK
> $75=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fexit_stress:OK
> $76=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fexit_test:OK
> Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED
>=20
> ./test_progs -t fentry
> $71=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fentry_fexit:OK
> $72=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fentry_test:OK
> $140=C2=A0=C2=A0=C2=A0=C2=A0 module_fentry_shadow:OK
> Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED
>=20
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> =C2=A0net/bpf/test_run.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 30 +++++++++++++++-
> =C2=A0.../testing/selftests/bpf/progs/fentry_test.c | 34
> ++++++++++++++++++
> =C2=A0.../testing/selftests/bpf/progs/fexit_test.c=C2=A0 | 35
> +++++++++++++++++++
> =C2=A03 files changed, 98 insertions(+), 1 deletion(-)

Don't you also need

--- a/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
+++ b/tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
@@ -34,7 +34,7 @@ void test_fentry_fexit(void)
        fentry_res =3D (__u64 *)fentry_skel->bss;
        fexit_res =3D (__u64 *)fexit_skel->bss;
        printf("%lld\n", fentry_skel->bss->test1_result);
-       for (i =3D 0; i < 8; i++) {
+       for (i =3D 0; i < 11; i++) {
                ASSERT_EQ(fentry_res[i], 1, "fentry result");
                ASSERT_EQ(fexit_res[i], 1, "fexit result");
        }

to verify the results of the new tests?

