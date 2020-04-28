Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA261BCF7B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 00:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgD1WJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 18:09:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726272AbgD1WJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 18:09:47 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SM5ne5008732;
        Tue, 28 Apr 2020 15:09:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8QR9aO0xxBO9AZ7Xp36Wyu1fsOEZYmRHj769DW0/iPY=;
 b=nHFJHaG1aRV8QdmBQnmwQUB23njRvmZPsPK6YHGDhM+xIcbDdIgaBUfJ38M5d+hdSq2p
 s6yLlWARBO6Ft8iHo+ba+q6WAOZTrTAUQ0OCWgP3mZ4stGka1LLLws64yJhChCMVqFGT
 au8w6VNASpSseD859xLtmRTPlcsIJqxvB+A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxa17r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 15:09:33 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 15:09:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FF6qX2dnnPpKuZ8/afCHBgrYLNjaurIq9bXnr5aUUd4ACPGIXpZSIXR+MN8lP0Tjq0tmot8cXJfkG3cDYDkx37IPTfIp9SrW1GU0goOrUIZHI//Bf8kKs6npZTFL+iTLf8oscJHLbcMUjJL5QvgbTmwowdmohrRlJ21tSufoxZtd2EVXJjXlbbmpApCUw8sP1aOr760fKfWsv7Yt7rB3SVNfCoFhINDMWMUbetNlIKATQREXzuener/E3TCZfe7kL/qmjLDXSJpZN1AdSZSqqM5n83i0ty1iAIVSHeH2G9tQEe0o8PeRVstJxgjyXoihF4iXSeAlN5XW+sNdS/SPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QR9aO0xxBO9AZ7Xp36Wyu1fsOEZYmRHj769DW0/iPY=;
 b=MnENzow6EfEQo2zfsLGtJ3MYiIZA/vCvakpzhMHvkAlXyV05KKvsFYLDKN8q10Tnpn/6ZsFAAwCyeI8N2b60bbnAxagTHR6d9SDEaS2I6UgQH3bKuKpmFGGvCGw7C8tVRraXTERB9aIlG3sL8+/35qzNMp6BbuCRV3aJsKpHb1mfsgRs9aVEgk4ThysnNANWjpj0WurxiMJSCxjSZMWhAkekxXPbb2uCJHdwHqafEqYLv7pPtkLEZsTgxngG0TBtfc1sB6VQ4ugUqvIf2zcHHcUxpumnfuYIu+RZ7a+AQm5qBJCmLg/E7p/X22ty+RCUFhFFouUFz59Wz03XxD8bFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QR9aO0xxBO9AZ7Xp36Wyu1fsOEZYmRHj769DW0/iPY=;
 b=Oh1KY7JHR7dchH8/9akKrwk+v2eRyOwVkR7spqa70XscBLLx7PgcN/+VAjjuP/VEdCPOWSfWSIvDcyzuYEKSLJKAWWhyuMMPVu7Jnt0kesytMgAUDN624yYnQnonBmLB1d26azhrl77z5ypqxZ3DLo3VYGG3oBgMZ3R1bi1sl5w=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3031.namprd15.prod.outlook.com (2603:10b6:a03:b4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 22:09:31 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2937.026; Tue, 28 Apr 2020
 22:09:31 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Topic: [PATCH v5 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Index: AQHWHO37tXOkok1r6UuP3FH9Wc6nFKiOC+OAgAENoQA=
Date:   Tue, 28 Apr 2020 22:09:31 +0000
Message-ID: <76D70217-F09E-46EA-AA1B-33B883C96EB0@fb.com>
References: <20200427234423.998085-1-songliubraving@fb.com>
 <20200427234423.998085-4-songliubraving@fb.com>
 <09720b42-9858-0e2f-babf-f3cd27f648e6@fb.com>
In-Reply-To: <09720b42-9858-0e2f-babf-f3cd27f648e6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:50c1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ef87340-2356-420c-cb44-08d7ebc0d396
x-ms-traffictypediagnostic: BYAPR15MB3031:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3031335643FB57D2F46D81EAB3AC0@BYAPR15MB3031.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39860400002)(136003)(396003)(376002)(186003)(6636002)(4326008)(54906003)(37006003)(6862004)(36756003)(33656002)(2906002)(8936002)(5660300002)(53546011)(6506007)(66556008)(71200400001)(66946007)(2616005)(6486002)(91956017)(478600001)(6512007)(86362001)(64756008)(76116006)(66476007)(66446008)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oGXD/uqjyqSL3lR6PXUbnAdyX6RRt8rcrWh6I3ZNpm0hzF076nxV/pDl31gvmPLIStzd6Qm23/mzn5/hZv9nOew7gwnOmMKoW9dX6Az5cYoc9OBqEmRoiiR1OuZrcEe4aXIYASu3gl8KtERvUhxH2SV4KFr9stNYu9/KGfkburYzaEluuCifrw9N7ysph5zSwzUkTxPFA1twFrjMT5mB3JSUlqLwEo3DE4ElUapM1DDgZAeQ1euFgyQZbLxMmrsDIR7EsPC0qTXnxLI1MYylSD9M12yqaKoaCv5Y1enTG2QT496tuONreNkqNw5H+k1uBo64FU18RqNqV3wf1eknw1/zS6VHUgGFN86RvzLgvf9V4bvFZfPXPUrFvA1knNO9+fc3+1/M9korc0Szc1GmdvXrEpUxAg8p53VIY3PB1e8DVkL718UJegFl3oV6iO9+
x-ms-exchange-antispam-messagedata: fIsgAMNTuSRNv2hHtnGvlIXK9yBeoVoWpHQtzKLqve+PzaFOiDJ6BoOb+6WQESXXP6TsSm7IhaCnmsXfh9tFvwQAhqMkTEP4H/hAawPL8qyg0+4R1cRw6bmXE2Ze8rXJHxsOA2n8nGv4HzQr2sUmexRcgDY90y7OQpbGUDq/cDNkjhOTPms+VXXnYHFcgguVOvCWtJ6Vpq8epn+uEuqPW6mn4Ijix5Sa5P+CholXL4mnGr9wurMIipXQzfU2UqVkVFPyp+nzF3HHKa8wuntPEhpGz6w11E0N7qTLlu5bjQpoLumrvpRtbmtBj1feoxwu75qDwrRWaMhU9JG+3t1CqedgJGB7wNPevUS+njPeFtDIthawqueHdkv5adVXAc18Z5fWu/xbFz9fusBhhG1PIMQsZY8KCoWxDD+yR1vIvwICMNKkIq01VicBWnzrOTYgugx28kivWxw4UlKWoKhiADPYRnIulxeOEovjC7+f75qMn+KS02mKCXrq94hOd11jaY99R5nYFtXiqkVJj5bCmCnGIp5Jm3lWW4hsoOy8Vf0L9lFyqtalruVq+/OLcW25Qfa3/qpz/BvvY4RSqOHsi8tXtpudTAcb22ozvSdlaT6uLp6bjSVN/HVYGe+lsl2n5jE7gyhpKYLz71wgtq4E6fsfYMIhmJQesP0y898GkGKNSJONzlqw+9ThOkTjhdmQu7D354LXbprnwzfDKBNHKPnOUSk4SjtDNkWpFRoFFrL58Vmt3HnYTFSBxyHXR8i1vsrwfGBzNoPdY7KfJQA3zfuCDPexVclj8EZSo9ve39IkyzF24eqbUoINvDtBARy37bECCFZDrfyHIXZetGuGKw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97983FBC84C83A45BF51944FBE5FD31C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef87340-2356-420c-cb44-08d7ebc0d396
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 22:09:31.1927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XJzTMOoJLZwdzg0UpgMVjecanL55+ckU6eG+NOl6zVB4J4gKNiP2oYLQuFdONefoX6ad3J2+UYV6ZN3HC9Eg8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3031
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_14:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 27, 2020, at 11:04 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 4/27/20 4:44 PM, Song Liu wrote:
>> Add test for  BPF_ENABLE_STATS, which should enable run_time_ns stats.
>> ~/selftests/bpf# ./test_progs -t enable_stats  -v
>> test_enable_stats:PASS:skel_open_and_load 0 nsec
>> test_enable_stats:PASS:get_stats_fd 0 nsec
>> test_enable_stats:PASS:attach_raw_tp 0 nsec
>> test_enable_stats:PASS:get_prog_info 0 nsec
>> test_enable_stats:PASS:check_stats_enabled 0 nsec
>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++++
>>  .../selftests/bpf/progs/test_enable_stats.c   | 28 ++++++++++++
>>  2 files changed, 73 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.=
c
>>  create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.=
c
>> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/too=
ls/testing/selftests/bpf/prog_tests/enable_stats.c
>> new file mode 100644
>> index 000000000000..987fc743ab75
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
>> @@ -0,0 +1,45 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <test_progs.h>
>> +#include <sys/mman.h>
>> +#include "test_enable_stats.skel.h"
>> +
>> +void test_enable_stats(void)
>> +{
>> +	struct test_enable_stats *skel;
>> +	struct bpf_prog_info info =3D {};
>> +	__u32 info_len =3D sizeof(info);
>> +	int stats_fd, err, prog_fd;
>> +	int duration =3D 0;
>> +
>> +	skel =3D test_enable_stats__open_and_load();
>> +
>> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
>> +		return;
>> +
>> +	stats_fd =3D bpf_enable_stats(BPF_STATS_RUNTIME_CNT);
>> +
>> +	if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno))
>> +		goto cleanup;
>> +
>> +	err =3D test_enable_stats__attach(skel);
>> +
>> +	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
>> +		goto cleanup;
>> +
>> +	usleep(1000);
>> +
>> +	prog_fd =3D bpf_program__fd(skel->progs.test_enable_stats);
>> +	err =3D bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
>> +
>> +	if (CHECK(err, "get_prog_info",
>> +		  "failed to get bpf_prog_info for fd %d\n", prog_fd))
>> +		goto cleanup;
>> +
>> +	CHECK(info.run_time_ns =3D=3D 0, "check_stats_enabled",
>> +	      "failed to enable run_time_ns stats\n");
>> +
>> +cleanup:
>> +	test_enable_stats__destroy(skel);
>> +	if (stats_fd >=3D 0)
>> +		close(stats_fd);
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/test_enable_stats.c b/too=
ls/testing/selftests/bpf/progs/test_enable_stats.c
>> new file mode 100644
>> index 000000000000..f95ac0c94639
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_enable_stats.c
>> @@ -0,0 +1,28 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright (c) 2020 Facebook
>> +
>> +#include <linux/bpf.h>
>> +#include <stdint.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +char _license[] SEC("license") =3D "GPL";
>> +
>> +struct {
>> +	__uint(type, BPF_MAP_TYPE_ARRAY);
>> +	__uint(max_entries, 1);
>> +	__type(key, __u32);
>> +	__type(value, __u64);
>> +} count SEC(".maps");
>=20
> Looks like a global variable can be used here?

We can use global variable. But it doesn't really matter for this test.
Any BPF program will work here. Do we really need a v6 for this change?=20

Thanks,
Song

