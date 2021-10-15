Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49742E988
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbhJOHAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:00:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235820AbhJOHAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:00:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19F6Ya0U021479;
        Thu, 14 Oct 2021 23:58:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OyezbOIPWu4ek57KNvuFZPx7t7Hzw7EWLB4W7bN8HUk=;
 b=rrf/IegEPuXcWbQLWp0E72ABCaeRfkdftMm913CvDLxjIykSLvST/RVcVMcZrvoUTHnG
 J2kwPljVPGmFbIbM+BhK577wj4h9ODV9ZUSXju7XgHrQLKzlP8l3KKyuE8zDvmWDo3tl
 vidzy99lJapRV5lGixiIj3gjrr3bAlnEhlg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bq46ur5m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 23:58:07 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 23:52:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRX6IHkQ+cTviMla7EbzW4x0AH8CUEt4f0Ffj2yU2jiJKz/h+OIVXC396nyMo36o3WF98T4oHQV+fmMwDZP3+/ejF23AVRT/pXOYApsLgXhmDpp83U9f19xAn7/8w6dSO9ZbJycxb2ZzfGWnyR/9KJFgnklualIA8d9TaT0TC/P+58Z7+seKrRbU9bwkoJcECqaFbJZPeovshMMrMItszouQ0MDZRmQLpWqrce3AU9PIcPxeaKiFWpDtdROLKIAVl028MPc5F0hFH9XjWTtqTP4Ju00sZcf0WNRK/bJXiNLUDYun0tJSUyf2yV2ECwNqtHryfEHpfUzuh2xQyivzpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyezbOIPWu4ek57KNvuFZPx7t7Hzw7EWLB4W7bN8HUk=;
 b=iDhkq8eTkGRQlF8TP72Dx9hb8bTIpGOa3DA5MdEkO9R5q5/wWHTV6V9D46Op5pLgAQzxKQqSnb385rzmLAkBKq6dpZytir6cyp2IYGA1qwdEWtnQ/cXbLs1dytvZIuiOoqyP0XecYY36+H+GBr1oz6/rjfkVrqnLNJIqzpnk3QZwVkRm/S0TMgT8/J4rcQtGnDcPTyjAMQ0HfxiPKdYvNDrHzx+QmLe9gy89RjI0vOR5UiahlCC+1rRBQNGNPGZICyROvG+xJhkDqLo8K2YGOYy342GmKY41j3jc1nrAWHQZXSluPRNkMOYra/5VsyMTcNKjyR0dXf+uh99u+nkU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5186.namprd15.prod.outlook.com (2603:10b6:806:236::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 15 Oct
 2021 06:52:31 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 06:52:31 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 5/8] libbpf: Use O_CLOEXEC uniformly when
 opening fds
Thread-Topic: [PATCH bpf-next v3 5/8] libbpf: Use O_CLOEXEC uniformly when
 opening fds
Thread-Index: AQHXwT4TnlWTfFENiUijXf5QLLhC+KvTn/aA
Date:   Fri, 15 Oct 2021 06:52:31 +0000
Message-ID: <6A78B53D-19AB-4880-95C3-3322F3AAAC9B@fb.com>
References: <20211014205644.1837280-1-memxor@gmail.com>
 <20211014205644.1837280-6-memxor@gmail.com>
In-Reply-To: <20211014205644.1837280-6-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46bcf66a-8242-4ba5-b68c-08d98fa85c66
x-ms-traffictypediagnostic: SA1PR15MB5186:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5186E9C9A4109E32839D0721B3B99@SA1PR15MB5186.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:318;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S6nz4WvELasO32x8VcAMyd/uDtwmwpWXU7izyoRn0AXb4woTX4MYjcCpSjFi2qSaXzuWKRZ0slIH0ItYUALj89wPE/cOlTASIDcY0QC5KJMhw4wQ0XBsbTHZhGg+gNTLYL2Vwg6X/fKqj27YJQ2NpDOKEyYduP4zcSQEMNRpS4RTjJAOB8rPZqueh505CKyDgFBiHEKGkFJK7AhitU+vXZQvmX/O1I5W3SMQY4t6f56ysT25BJXsXskHTP+WTOCPDLuS5aB9EQiTMFYQ/5tdGxfniQblD/tMXN1Rkz4nbquTItzA2ulRCpGLx7HKqmIAlu7oM9pdtOkdlOmab+SRkt/2LSc+qwN6LsT87rJ77vPBrCmn9GQ0J+xmUgxq8RO8y6HddKCa06oKyh/uqtuBbDeIjOa+cJx/23Q2kOwTts/bkAXgWv/52LryTC9apZtVf7Vn2De7UUR7PIRIuQ6Ks9fTVYxbEgelYXGWcbFuq1W5k74p2+AZdMHTffTGNyvoAao0o2ycZeZPOx3vj6Os1oyIeiz5nCeOMW0mLReuzD8rlBrDiyqV1n9ZloS9AWE8oQpivRciOUAztIAR+R3qnE7vuSnntutcb6hvODM2h/CxWoLVRCJ7DSKgbKoD0cch6aNIZF0SIn8H5u37AnY/qjDITaeG10Gtfe4ytD/oFSVWqDh1PCaOxYJiaSf62GNlt9rhXu+MSc4OeXxxSILe818ID2gUGKhvfh7gydFGGfEIAqpQwwxp2HiYGzVu9sNz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(86362001)(186003)(4744005)(33656002)(66446008)(66556008)(53546011)(6916009)(66946007)(2906002)(91956017)(122000001)(38100700002)(6486002)(71200400001)(64756008)(8936002)(316002)(6512007)(508600001)(76116006)(8676002)(36756003)(2616005)(54906003)(6506007)(38070700005)(4326008)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NnQ7/lTqFb7dQD1FfgcaHSOiEqbCmS18bBFtBWORJUjnuU4rVBsM6HL/bi?=
 =?iso-8859-1?Q?7ntY15djLcxoA/o5cDvm4zMcIi8y7ix9erfU+ZzhdyCjW6mF3Qptzi0BPZ?=
 =?iso-8859-1?Q?nV75FUNpHQ1bp3jKrqZ1aISqSLopbSeKqohC+c5XLOh4ZMLViL+eM4Mnui?=
 =?iso-8859-1?Q?NT+0wjilT3sUCkiLWiRZKyHKc2RFnS2rKB4jZs40ihFc2FO4Z2BTEZXqIV?=
 =?iso-8859-1?Q?9SbxnT4iyHEcvukJ0vXhwbX8ThgoBWzwOAyMqcR0ubLsp47wrGvXtz2eTm?=
 =?iso-8859-1?Q?7/NNJ7k2tpWWS6TchQ9ZlLI7HBsxzGVn5ci5q2oSDUlCSWUGJNjWp0+l6p?=
 =?iso-8859-1?Q?WAIzDbV76/KR+GpkLkhYCnRmsv+q4xEJFLN5tLv35wm3agCoVF0lmIaMJL?=
 =?iso-8859-1?Q?VEtAeLKHZSgk0aZhYBMS9T2RSHnnJp/6THoxxjZbwLOq/luUW4m/HTGUFp?=
 =?iso-8859-1?Q?8qOaV1k+Ya8QbvQQx7t3zZ1f/jaapfz6qS9kMZg17ecxMzerIJ78bgpo47?=
 =?iso-8859-1?Q?vDlLYIiZ+8W95HdtAJ4pjvc+nMjBGGuyO+wUM+spRme7I6g4+vF7bJQqRr?=
 =?iso-8859-1?Q?x3uTclamdgejHTkP9zNbpufQQsY/Kcfobb6u68BMdlcbypNA0t9+UynHpA?=
 =?iso-8859-1?Q?jBv+sgGTaIxJ3Io0vLxgfyvvtOmLnip89RSMxRr4KKIkS1pJJFajLnp678?=
 =?iso-8859-1?Q?Q3FgKGei61Dqx2D2e1lDNIl0w2yNGLnPNkt9Y3DRdfe+F25Kvx9dvrG+gw?=
 =?iso-8859-1?Q?tudbJSpoQeWgypjk2FIWDebc4sd3NRYJRRXurBm2hmVcOP6doGsAzp//aj?=
 =?iso-8859-1?Q?CT0vPUJ3ceQByospDC3YPIcqhJlo22v5Erri0o1MBrAzNRkwUjowJJ4aUm?=
 =?iso-8859-1?Q?JLFrzgJ26m4GY9Ms6PNBx12Z5LCzv6QrwXGZHXVVUS6E8DlUxtG8kiHhED?=
 =?iso-8859-1?Q?PIabATlt78InpswxMJxVku5x9DQu5dXSWLOeQelacGY4WPkJ93EHBQCEJ+?=
 =?iso-8859-1?Q?v8/jIYuGe7y6U0CsFZ59ilR2otvSr9vxtVkITzQRJtA60o7cj9XiysKgbj?=
 =?iso-8859-1?Q?6ONYoZzxElOJx0Q0C2lhEyTh337WUgW3ppoT2LoC5DPmZ2N4p4hYpZtOBY?=
 =?iso-8859-1?Q?WYdDV1Z443M7ce5ynla8DJUUZFv0owMm9T0naw7o0UzXZ1LBsDs687isLc?=
 =?iso-8859-1?Q?zviBSJNd8DwH5qgUhHmoGZwfBSZJWz8tXfmlLf++gJCoJ+9JRo74RVBRbZ?=
 =?iso-8859-1?Q?qrPXwiwaOfreJ+6qzdIDU3U4f90NYcyyIpZFXb4YG4rsSyFeEqidAm+2/x?=
 =?iso-8859-1?Q?R3vDVd1lL7bJGohEIO2YdA8E+KkLxl9OvAEV3oUyiDa5SYNWHXvjH0AGSn?=
 =?iso-8859-1?Q?Je7cEvioSEHkZz+2EtWSisfbwd9EWVeO+MWjkPgI0vJT7tP2a64d8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <144428C69EA8AF48B9A7336C1A6C07BE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bcf66a-8242-4ba5-b68c-08d98fa85c66
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 06:52:31.5715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wIh/eidK33NRZnpo8s/Dh/8Zo0PTRZhiXYCLg+e57Z5X9e2Z+D3FeNpoZCw1MxDLzZikIWZKoUh2SreQPq0LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5186
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: zGJHOkXkquFFNLZCY37Ul5BFj420QDhm
X-Proofpoint-GUID: zGJHOkXkquFFNLZCY37Ul5BFj420QDhm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_02,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=706 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110150043
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 14, 2021, at 1:56 PM, Kumar Kartikeya Dwivedi <memxor@gmail.com> w=
rote:
>=20
> There are some instances where we don't use O_CLOEXEC when opening an
> fd, fix these up. Otherwise, it is possible that a parallel fork causes
> these fds to leak into a child process on execve.
>=20
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

