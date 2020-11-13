Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47D92B234C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgKMSFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:05:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47090 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgKMSFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:05:24 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI520E013457;
        Fri, 13 Nov 2020 10:05:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=G+E46iBjyaX3OMUaP77ygHA3R/fd5M6lgRFAcyiByro=;
 b=SC420hsmSW/xriftGC/+rDoIBIj8GCOpK60jDXgcwwMbt+cr2s78t34LEPMXWhJW6C5e
 +gQ7io3PX/O2dVq3myZEC6MW977sj+Mawtj9Nmc2ohSKq9PJNwF+eiy68gcnqv9n+1Sl
 7GigXq7b5ScgOd9Gt05lMj40riUaN7X07nE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34seqpcevp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 10:05:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 10:05:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcWVUqM5KoZnARXRlJvnl8m1IO8EKgbawDRWIpTQN+2csf4c5RqNDOtqcHbPhpm4WqhmzDfrETpzKg/ozR8vbH+TrwQ0aNDc1ADvr1Otw/AmasQWjdEYvyIni+MAXzSXlx0COYwI7v/BXzbX7HpXIwJFQv/4OviuW4ygLoc1AYOxJyEmjI5UkygtlJkjpKfZbr7AL6LBCNXilkcB4zbN1jpmjOqb/BwFmHeMoRUYUtbXRp6YCcbBjmxcW+t9oFJvhdxT3jDzXcSqt1IrdJn0qbHB1gPrEfIhFUTlAWFxZCZoCe0MLCojdkqmr7YEaLIkYCK2SP8T+b0U2rVpB4kLew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+E46iBjyaX3OMUaP77ygHA3R/fd5M6lgRFAcyiByro=;
 b=KygmRb/VelSt9Ved5OzRKfFolSnfZCzwaByE73pk8DjZtc/WgnkjYBY+QDJVxkjkY4snoaBjTtb+iF4HcKOk/Axm0Qu/3j2CfvgW0NJw8gHHnTvVm6gYNz7ljT417LI3BmAkjYSNV6AUXVzXyFn/YSZw0qdgjVJgdDTi2cfuEuj+4fZnqL/QIkRJN3tkKyO8+suALT3tq92EVfsWWpBavGq+PJ+JuC+TlgRDTueN2cCidny0Qx1/oNPn90smpZz6qPMQJXb/4oJu+6sqzKBC5/T3U9mBzLFdGnIb8Ix2OzBW9rdJbQ44HEPI62X6NsMy3Dx5fpitvjbafekYLWwPwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+E46iBjyaX3OMUaP77ygHA3R/fd5M6lgRFAcyiByro=;
 b=MoxFa3WUBy98T6H4rx8fpzO3M+57y7M9TaKmabFEkLzlPvXacfrKvjV/DdzLx2Byofi5u0xZ7pm7S7ON9ntDaLbj9edCnIZH5V6ePhbLaRIx4Yur1Hb9a3KdfliJKWuevzvBByueXU0wjanuzbUXC4O7nulilMea+pZzrsz0yb8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3190.namprd15.prod.outlook.com (2603:10b6:a03:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Fri, 13 Nov
 2020 18:04:57 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 18:04:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 07/34] bpf: memcg-based memory accounting for
 bpf maps
Thread-Topic: [PATCH bpf-next v5 07/34] bpf: memcg-based memory accounting for
 bpf maps
Thread-Index: AQHWuUL1QHcLwweVIEG+lvLkOmktc6nGXHYA
Date:   Fri, 13 Nov 2020 18:04:57 +0000
Message-ID: <426320FC-8A8F-4857-9E05-32E4EA24922B@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-8-guro@fb.com>
In-Reply-To: <20201112221543.3621014-8-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cacf981c-58c2-4e9f-108b-08d887fea1b2
x-ms-traffictypediagnostic: BYAPR15MB3190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3190522A66C8836A54DA0AEBB3E60@BYAPR15MB3190.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T9jR9vnhLlzJafjNGyTvCueL+ivgb9kN0Bdl8/eQc1pJ+vwRHRQ9zOa1LeLhaE2yeJxWXkkR4wQZ4swVmkFChXQQgMcm34pRlioQXPN9ijsNdd1QfUuRqgC9WwNXllYiSnrhQINuyhASJsZgdBWBGv1YGbPbEDKQnUPLN6AYRZy+5JlIhxT7FN+iP/C3f7874239ASw3BAU2BeUHQqKAAf8fv5QDBV7cee0OpMDUo7rIGiF4UMRY4a/4yEPwEUz5SB04WMHJDLVMxxC0dOPBAmcTgSjGpq/Hmcocdt4Tsnu5Gu3lPsGD+fMYelN4tP2TTZVBhtHzGkNBO3SVhtSowA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(136003)(39860400002)(4744005)(53546011)(316002)(54906003)(6486002)(6636002)(66556008)(83380400001)(37006003)(66446008)(91956017)(76116006)(6862004)(8676002)(6512007)(186003)(4326008)(6506007)(33656002)(2616005)(66476007)(8936002)(64756008)(2906002)(71200400001)(5660300002)(86362001)(478600001)(66946007)(36756003)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: O8cJ29RGTwfaRlVlhPGZ1DTqO/ih3k86pt5bATwBkhAiKdoU1s+Y7E2rpS9/+UhNC/I/6bq2TT7WxtauRix7P4/+qTUwT5sBe8s/GMmgEov2OTXefJZJL4tU+F7pDTCrxzzfFkRtV5mm4IPSUP8oAOnXCH2Phw1XeFoDsbDLTXy5cNFzNyhgvFBGBD6JLa9Rou0OY7fe0htl1CfHNAnYa3zdbf+dXeNiLr8WMUxe4a6oxtBrissVgeefQC+a4URllv51KSxHQ3PjK0NT3Nc1zfSVIAQDcWIJvxehbdWErMcW+6pCdfNeKE26gedoh7KEILZ1piQpT8CfDzoDxqkXM3jUwdAH7OCm4flDXG1c4W0YTexHUc5va4ortW0SWc5LUAKhVmbz7iiYJustTQOLplAjv00/nmhK+nLvk0IxmdntrZsOnztLBtktlmcXFKK1mJHMXgRrlsoDkNi8j+B54KqPM7fXHL9oNPwfHWgqD1hM0SD186mlqKlhYe/lJihEScX5NC1W8OhCZ+uN1vXv/Q3IKzWe9whYcQzyG+TF/ijSi8W/+9jIM5Cyf2bTwRmqRm6tSi7PpxROBZ7ENBnouH5OjGqgg54+YAhYva8dZlb4mowJ97VVwaq3GLgc4XRvCMvAKHsZefohK3AspUMQRZCD5LZoLHypOj7Cx5vp7uCWEum4i0HM36572EZnf126VL6/WFE/PX5/UfDK6Zc6kS3cA74btRkL4ketogBQdGAAZTH0BO5GlZzDLMDIPjcO6G3IbddWTX1JBuPzFkm6WhdiEhWuCUx7BQ8p81FGJXSU4YdGr9jd15LpzlQhKIcK4aZN17EBTmXoRw8xu5xBMTteZ/TtzjlD8YORwtus/w0an+YaMg2IdVsPtqMACCiRkUhBhACdgdsitg7EAPtchBGRFQLupGf3u1S0UIJKGjc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C21BA32C06155E4FBCB9E6558F59D484@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cacf981c-58c2-4e9f-108b-08d887fea1b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 18:04:57.5800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECudu45Fn8JRYZMSSFkjjDx/OjNFvby/8q+FrMIBP5mX6BKiVIyYtuvDGSyyG4FPAOPMdK9R6P2LhR3l8wowVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3190
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_10:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>=20
> This patch enables memcg-based memory accounting for memory allocated
> by __bpf_map_area_alloc(), which is used by many types of bpf maps for
> large memory allocations.
>=20
> Following patches in the series will refine the accounting for
> some of the map types.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> kernel/bpf/syscall.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2d77fc2496da..fcadf953989f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -280,7 +280,7 @@ static void *__bpf_map_area_alloc(u64 size, int numa_=
node, bool mmapable)
> 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
> 	 */
>=20
> -	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO;
> +	const gfp_t gfp =3D __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
> 	unsigned int flags =3D 0;
> 	unsigned long align =3D 1;
> 	void *area;
> --=20
> 2.26.2
>=20

