Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64C72E10B0
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 01:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLVX7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 18:59:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbgLVX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 18:59:37 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BMNwhoh014961;
        Tue, 22 Dec 2020 15:58:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wBsDHyXWrpm8coFt4wZWN66P3Vb+ryjWFPlrNgTJpf8=;
 b=ZHaM6hP77yd9eY1joxNy3fp2Vh64l1ieKO+FC/SClQv8UWwL1RB+ogQ8I7Fupx/KcrRw
 cOstXLAaAZ8a6NyENhHyxpDSdVPW6EHGA5wAe7m4Y6DnDRoXT/32RqyT9WroOi10JyH7
 AfboWLV/eC2Wl0L79vbjjE9waZUN/fgNA7Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35k0d7f4et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Dec 2020 15:58:42 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Dec 2020 15:58:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FR8W8k5rLrzZn78mRE5HcwgfZf9fTkKlipuih8KOQ+UBIvuiLWXZeJXtDF3USBi33HIiAmblDXIevyaKQRTBAovevsyw7Ovl0oY3abOYATo8RUaCG9ew1MPDH5N30YBpU1V0T90s5q9Z2+iLqcTMxGzl9QmrP8tJ2AUU588VChMqez8Sl4NwtwVFSeWE6J0PnZcKYIpL+gDdt//laAvwB64+nWpOneMNU0HBAr5qrx3MSIT4Xfz9tkA7dcvtp1KB9F2IhVzqvUklkzIByDzo6rlRHXZhhVV69zGmSvms1DhIQ4+hrcxCiS/3YO3yGADDmBuepUKpY8d5h3J1U0YHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBsDHyXWrpm8coFt4wZWN66P3Vb+ryjWFPlrNgTJpf8=;
 b=goaXygxIE4haKylMoCrIk0GcFvdDfJXEtw7tSVM9f7t2WIQ33EcxMGbkZfPfVRoNUCYMUWfdelZ9o9l5XrgzTJlumhFCJbYqDPLpTdJkPl7YTpcVrPfL49Ivq2E5hv0Fg2wlkB3GFya/AJZ1vMnDopa0ToiIWihfu+1Koz1teUnv8Z4DHautsZZfvwCKaKkIn2EDHRFson8amCBo06HVCKtmrLVs6E5CEqmDKjmBJv7RNnvHlxsWe2uzc3xCxUOadNimtC18oWyYpaO2+eobb+bziexZjy8ohc0X1tZhun0jbRstNjbS1aUpeHflcw1v3A+MdNgpkahjr3pP1oNByw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBsDHyXWrpm8coFt4wZWN66P3Vb+ryjWFPlrNgTJpf8=;
 b=J1ry7qX2OqAOEEbUeudfqF6L6aDvyVpEZMHJIDOy0844ECyQ7rW4sR/9eX9zkeIwg2PvSn1dhjO5wJFPiv1ZbU9EwUB56klufAuN+XxSPXbOjjN7OOYau5Uu1aNdib0nkMBXXTcDmpOZ9b/ATKH/SYO/gtsGvgXuIAO23G5dEGI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2262.namprd15.prod.outlook.com (2603:10b6:a02:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Tue, 22 Dec
 2020 23:58:31 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3676.030; Tue, 22 Dec 2020
 23:58:31 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] selftests/bpf: work-around EBUSY errors from hashmap
 update/delete
Thread-Topic: [PATCH bpf] selftests/bpf: work-around EBUSY errors from hashmap
 update/delete
Thread-Index: AQHW2JwqVoBgVPXGeEy1o90po8jmTKoDy3kA
Date:   Tue, 22 Dec 2020 23:58:31 +0000
Message-ID: <11956701-DB1D-49E9-BD47-A9AC1E26F487@fb.com>
References: <20201222195337.2175297-1-andrii@kernel.org>
In-Reply-To: <20201222195337.2175297-1-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:7b59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 479cd1fb-f0c9-4f99-89d9-08d8a6d57c37
x-ms-traffictypediagnostic: BYAPR15MB2262:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB226287B0B893506F2608F5C4B3DF0@BYAPR15MB2262.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2gJFy8zZlfAeoqk1UqoPCUKyMykGx6ehMNXNlryVko/TLyOm7NIuHBN+pvwm4re9d+qo+kqjPl9y7gTGRnCSQUqVzb6rN5OcHbZwjyL4SrnMsuNmWnO51dQYRs/1kBB9or3cFCIZ3/TiVX+JKiUJFBA+NvYxQSd4/zmGW4nrQcgYcQ0L2mO6iWTsUJYHS3lvh21wZxqDcyuXY2PA8PUmloO8r0/VMxp6nhI9KF7ru558Nb+fqb6pa2cZw0UHrqOzof8nHb8RpbSX8+q2uuAa5NqK8kI0yiembDlwYPuLSop5KRvqdzgLwYzoZYyCwTuOfmx4sCPTjsm8Zc/xFS8rSmjQmftrXbYffapAaP1Y3PC00Pldp3U6BtZR/Pz3F0Ok417jvbcS3mh/fjFl96znuUJSQduXxaN1ookIiLoG06FJiowb/U0mLsqX6z2JAM+C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(186003)(71200400001)(4326008)(478600001)(36756003)(6486002)(6916009)(53546011)(6506007)(316002)(83380400001)(2616005)(33656002)(2906002)(66446008)(66556008)(5660300002)(64756008)(6512007)(8936002)(86362001)(8676002)(91956017)(66476007)(66946007)(76116006)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HIoW6qaa1rPgbDMU+06AjsqS86uTTWIXUZyhdkZRwuyyFsw4Dq0lxuBg8nKF?=
 =?us-ascii?Q?HWzH7JZGys/Er2dKsxk7hIXWCw3mNSlUAGuwAqIrYpJ6ujAenZOxCkIfUSpU?=
 =?us-ascii?Q?ua0o1nqpTP98LV1JisGH5GHHXHP2CpRSwM2PGdDsNjq1K392qYR/VFPWWOgF?=
 =?us-ascii?Q?+pKIlbsejqdnS+Up53YOjIF26CZ1+HbyPs9jKOP+zrn3QOY/1KNkSnqarNBR?=
 =?us-ascii?Q?1X1jAfEpPZF9ySlxXKx9RHJydEKLe5iu74eGdexGkQ0Njrd9EAmlxwc2uwHo?=
 =?us-ascii?Q?1kHn0M125tmBYVastnvnqGkRXvTyFBhiwlxdZtlF86QV+51z108wzYBt1o5j?=
 =?us-ascii?Q?qUlu8JD++/brbStwWNZ6AzgEFZFp5WV1EgAZAYYbtM94SvF22kYs27VSVpO5?=
 =?us-ascii?Q?Fwrc7mSbwRNkiwQDOQs9C46Zq5hOIodfZeteclZyWrdGFEs02B9HkE3UqJSD?=
 =?us-ascii?Q?PXjrDvoy6/6EG1Z68ubUGSEqLpHX78CifiOXz6hgtyFgintwIBYFQ9AnpQXf?=
 =?us-ascii?Q?zUgX7UElZRLZg+xngNfLcR1jhB6c2uomRWCjailr2o4pheC1IKvzaMRrxN2w?=
 =?us-ascii?Q?00VwuSzb8OpyyWYiecRhBl0AQkD3b4Ha3ugHxWSuifAKF8bySpiH6ra1IGfs?=
 =?us-ascii?Q?ST/6hDWhz6rplKcVRC4IRv+NTT+N2hqoWG1cUvk+lDb3sug5WQIJzrJP+wsB?=
 =?us-ascii?Q?HPUb18CzW70Jimd4Bhg7PbwBDkJG8anNAdbGkHSXq5hPVoVMgKZX9GG+fsX+?=
 =?us-ascii?Q?KXJoVPIrOF+5ARFDNQQSLSbq7RHtj7dvBKEUaIwGR/Ji1uUNkxCodFIJLM5P?=
 =?us-ascii?Q?kajyxQiuHMcos4aDQaGP1G5ZSSFJkXhThEwbhYLVnrr/teI391jgCR0cxWEZ?=
 =?us-ascii?Q?/zkbckB+qSQ8PDQyihNmS5G+lownAOhDgvvrDywXK6CnJeCwYoWpbdKSpWJL?=
 =?us-ascii?Q?hgPb5zdBmv1aOBZFSvgIv8cl54RSl6IBvHL+F1Sl3qkB216JAjnUVncZGLr2?=
 =?us-ascii?Q?D8NTpbrGHNt7EFK1Hmum6dScOB+S5poTjKkRVQvHt8w2yHU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F3F32C7145F8A7428BCDCBD7267C33D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479cd1fb-f0c9-4f99-89d9-08d8a6d57c37
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2020 23:58:31.4035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkrmqI2TdV/MUHPDiLBGZK9/lsgV3C8I9rxY0qHMl1JClbtcrqywJuhtxEWoxcMNdkANtNVXtVz56U6bwcTh3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2262
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-22_13:2020-12-21,2020-12-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012220174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 22, 2020, at 11:53 AM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked") introduced
> a possibility of getting EBUSY error on lock contention, which seems to h=
appen
> very deterministically in test_maps when running 1024 threads on low-CPU
> machine. In libbpf CI case, it's a 2 CPU VM and it's hitting this 100% of=
 the
> time. Work around by retrying on EBUSY (and EAGAIN, while we are at it) a=
fter
> a small sleep. sched_yield() is too agressive and fails even after 20 ret=
ries,
> so I went with usleep(1) for backoff.
>=20
> Also log actual error returned to make it easier to see what's going on.
>=20
> Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Thanks for the fix!

Acked-by: Song Liu <songliubraving@fb.com>

With one minor nitpick below

> ---
> tools/testing/selftests/bpf/test_maps.c | 46 +++++++++++++++++++++----
> 1 file changed, 40 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/self=
tests/bpf/test_maps.c
> index 0ad3e6305ff0..809004f4995f 100644
> --- a/tools/testing/selftests/bpf/test_maps.c
> +++ b/tools/testing/selftests/bpf/test_maps.c
> @@ -1312,22 +1312,56 @@ static void test_map_stress(void)
> #define DO_UPDATE 1
> #define DO_DELETE 0

[...]

> +				printf("error %d %d\n", err, errno);
> +			assert(err =3D=3D 0);
> +			err =3D map_update_retriable(fd, &key, &value, BPF_EXIST, 20);
> +			if (err)
> +				printf("error %d %d\n", err, errno);
> +			assert(err =3D=3D 0);
> 		} else {
> -			assert(bpf_map_delete_elem(fd, &key) =3D=3D 0);
> +			err =3D map_delete_retriable(fd, &key, 5);

nit: Why 5 here vs. 20 above?

> +			if (err)
> +				printf("error %d %d\n", err, errno);
> +			assert(err =3D=3D 0);
> 		}
> 	}
> }
> --=20
> 2.24.1
>=20

