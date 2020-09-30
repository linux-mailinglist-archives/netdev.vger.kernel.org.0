Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE3027F418
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgI3VUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:20:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgI3VUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:20:41 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ULBpM9009662;
        Wed, 30 Sep 2020 14:20:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OQahsW2aLQWqcgBou73NMpuRntm3IrN1xsRamGreVgE=;
 b=ezN3O7GiJe2MkgwUzdqMubKkUwmd5zGwwpH1B39JksWz/7ZSYhMYSm6xShjOcSH7g6MK
 YoDUi7K2mQEoBr37Yvi/bG5VefPoIFpWkKBYLa1J6hgJeAML3+E4aRqArUN3AfLnvlZM
 DrujzQp+QHrlEn2x1z3u8wr7g3F+oFEZrPk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33vwu39k8g-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 14:20:24 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 14:20:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoCcNf/xIDWMMHUzZJYW2I7MnFzfeNjzRWHv4Rj0VSk47/rmXu3n4v1hHDwDhdz/syxmsJHdpJrNfExDRldWfoBm1vrURo7QiAXyYS9szWj6cAaB/auYYXBzweWVrMnv1n9KMS3L6NbAcEfC6O6iftcEGjGoJFXBdZ7JWg2Ztb2ZSePE8WHBpXpUw4OOxAixGUlUtjcOVAuJd6jg7OzEsMEDn4s+wpv5xVH2zXs3/W0hpy91lZWZchyIY1l1rWEROP4P0Gjf6Js63UEH6zg0+viQhshcuWdwrrTDux9lXXnNr5a3iLs6yEokSQCWtwZqXweUNkGDwm3w34wv31w0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQahsW2aLQWqcgBou73NMpuRntm3IrN1xsRamGreVgE=;
 b=cHGhrvmmrPFR7dE+bqjiXrIy9s5PoGcQXgdcfOupi1yq/EacfMxMd4Mh9q1kw+CXXGWESQHZYsTO/MoHs090yGVCnMRn/zqD3LZXmxd2Eg4NeRl3MtPfZrOobFEnzDNf1EVk5f4GpU3NQwFxLLd39kH4+JFJdOtXniDQ9iohg1/JqXLyEAhk/1+RHqxl55AhdyeYkVIC7Bq2O1U/oBrUBTTLqVgqnFG4fy2Pry4VlZ1ULSmGsLNZ7nUtQU8K2zjsoE/WBCLkyBg33XZhL0PXNqPEVWG0150LA7SWZgoI4MHGLH79iEJN3UYnF26hl7uxuaB6G8XZl5Ozdv1Wwad3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQahsW2aLQWqcgBou73NMpuRntm3IrN1xsRamGreVgE=;
 b=XkJ77x0neHq0w4TSuq1abvWBlJvSG/pDypxGfGiK/++poq5me8CH/l4KjmPCCS3KadSpaFkcp2DwChNm1mJR8KBdEbQZ1e72iSX7i+0NAy9o2TcxBLVIjsNMLYu++gtRiaF+kVWO6dDzA39OoAVMsgicWLSFD4z5/+46SpUTOEA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3368.namprd15.prod.outlook.com (2603:10b6:a03:102::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 21:20:14 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 21:20:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v3 bpf-next 2/2] selftests/bpf: add tests for
 BPF_F_PRESERVE_ELEMS
Thread-Topic: [PATCH v3 bpf-next 2/2] selftests/bpf: add tests for
 BPF_F_PRESERVE_ELEMS
Thread-Index: AQHWlz1ez86GRFR30UOBjUSQxnLPaamBkMuAgAAfsAA=
Date:   Wed, 30 Sep 2020 21:20:14 +0000
Message-ID: <B592DCBD-56EF-4420-BBC7-AC5A05077D8A@fb.com>
References: <20200930152058.167985-1-songliubraving@fb.com>
 <20200930152058.167985-3-songliubraving@fb.com>
 <20200930192647.mgunvnxzb5mmxae7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200930192647.mgunvnxzb5mmxae7@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1d2083a-9e65-4c12-97e5-08d865869f5a
x-ms-traffictypediagnostic: BYAPR15MB3368:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33684090AE1F8B3B833519FEB3330@BYAPR15MB3368.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9pNd+E25znocEQ7AxnppGflI6rEaFlyZnHpWt6ZtPacvDT4UgONRhrGNmvVWRB2mAWlRWOBXgxANrRU7AILRGPnhjdVjkI+HVD3dxF1wIMK6xG799vlcxEAE3H2NV7Cu2hYtALlAJH4ZOSj41ifpY/HzmalHfqM2BQbrjLenp1+HnS8tXwa8L1STNmRtGgLEoBOo9ecHKSAv9Tpa8If9m9ctRueqGZba4/KSnImRU08WgYyt/i8IpYvmaJlh01cBRlevwj6niaF1sFvdDxsV5iDJvhSrDQX9JHCsiAcQmJvuDwO4VH+3+0pQlSdPjt0/cHoQVwfqyGUd7TI6VKLIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(2906002)(76116006)(186003)(66946007)(91956017)(6486002)(66556008)(8676002)(5660300002)(2616005)(6512007)(64756008)(66476007)(66446008)(33656002)(6916009)(53546011)(6506007)(86362001)(8936002)(478600001)(54906003)(71200400001)(316002)(36756003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9pUKGltgLXlH7egxhCR8LuqegZa0bItecJLi+Qz4wFJJjfhHz4J00558uemcOThKjMWVRhI/f43Gbb1eA2y42hSHQl2qU4mYYFnX4xFZKk4ffA6KicVNICX/qNBYFj2BnesYbBU9l5JC4IFWKVpHUksC4nGQcxbcc2zgdDasX7WelEs650Zu1z48GSVe+kZxBmxwxqrtKtaN9dCowr1vNqipnfVAZo73KSn8YmrNg+QgctsYuziOLGE+RMJV0P4ODYlxoZELByEU8h/Dwr4oO+YvrzRYEhxu91+Q1pDOsL0RUGZ81e/k1CR2HisapaSXYS5MLB27ptBf9+8A0Qcd9IcYWC3xZbo1XBtzDypoFSvm9uX0HuWmewrmb1MOfq8eotnia6KfZNdJQw0HsyxoKmCnC+qiC5DpRIGHqs/MZhpkV+L3dMPjFUavnvQwEl5s7Fps8RDE/dqys0VOOSIHzsikAJotwbvIoY9csaHinyFlte3sFk/G6Mm+yUmrOkpjBfpgyZs8KGimNBI+6OJ8Nbg6PthnG5s9beUzpGgXy9YsHsxS9vF8ydTRHeAYdp/oEtC13VaqAfM0GyE6RSPF/hFeuGHlqi+zn4sx4/14AwqmkzJ6sSHqQMCpOnciT/Mz6yaNVQeT15SP2yF3HvaUTDt1WqnkyabZ39XzQHLFwDHd9wSFyDNeftaHwmwIkHzF
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01BDAE393D100B448A308A61D40BE4DD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d2083a-9e65-4c12-97e5-08d865869f5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 21:20:14.4773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gA7CyA91UhrWI9rcTjgMyEXheuuC5ZErLFcydSq/oy7Kz6ymwn4FVDpzhmhh1xl9bdkPjWyIZCGC4CjAPOuv0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300173
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2020, at 12:26 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>=20
> On Wed, Sep 30, 2020 at 08:20:58AM -0700, Song Liu wrote:
>> diff --git a/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c =
b/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
>> new file mode 100644
>> index 0000000000000..dc77e406de41f
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright (c) 2020 Facebook
>> +#include "vmlinux.h"
>=20
> Does it actually need vmlinux.h ?
> Just checking to make sure it compiles on older kernels.

We can include linux/bpf.h instead.=20

[...]

>> +	long ret;
>> +
>> +	ret =3D bpf_perf_event_read_value(&array_2, 0, &val, sizeof(val));
>> +	bpf_printk("read_array_2 returns %ld", ret);
>=20
> Please remove printk from the tests. It only spams the trace_pipe.
>=20
>> +	return ret;
>=20
> The return code is already checked as far as I can see.
> That's enough to pass/fail the test, right?

Yes, we can remove the bpf_printk() here. Fixing this in v4.

Thanks,
Song

