Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CCD34E15E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhC3GlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:41:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57352 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230077AbhC3Gkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:40:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12U6e2fB005766;
        Mon, 29 Mar 2021 23:40:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=h8NAfFqtCUEyni+vDEfh8SM7zeglyMO/vNKux9NMw6c=;
 b=p4ymxEG2rZYLczsDMAelp+mAthFwVaxV+Od1Xg8Xu8zsPkDbZ34wv6TxjZHE8bFBEoG2
 GF5V/rcBvCZ+8/zQQ88dRzUthgOxMzDcqTJ0+yYEtzXUm+QUiV2gydNO6lw2FPjHne7g
 1VtZx8nxpoldCe9sxc+p89yr7ZNri2aY+wQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37kuvm0rsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 23:40:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:40:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIl+vlqcziz6I1UYWEneonPeb348WxhkMykMD7BQU0PzhbmSGlVM50tG021ZuMobiQ0tN+AJRVoPHhxsAzyqarHNdaVrSvnkEJAiy2Tdr3aaHOYbBJwh9Qda8RToKTF9zOONhHbse1fDqDtZVTRbF3IyiKyTdjQxYW9ZNg3bk3mz5uzjLKVKGlBp/N6wssNyASsyMv10/MszKmMC2OZB2eR1wWLBfOw8NstGS+vqzq6WOpMvCgeWATpi+72gDpIklj5OPbpbkGhAn+97pVMWlxpi5dalzdeYislQcOpY2C5wWspSDjdKbJocsGBceug6gB77ic0n1ayQp67hhFrIOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8NAfFqtCUEyni+vDEfh8SM7zeglyMO/vNKux9NMw6c=;
 b=DPVY8ah6u9clTMwp/FQGn2uKhnoDMIbwmwHbHJ/ay7b2JYCEDw3aYyqP4hNfWYMj9++a2dENdz5QVKCJaP3LHjhreyDEq8lKD5FquV6/qzECD8ZWgaMFAMybj1wmpk9onhQItqRqidymTie/Mdoy99JP096RYz4PmA1stFLxL8wbk8LrR+/bT778aIsfbmX/4CiK6LjBexQ3Pk71jwchyBbLlp30a5tUerot6qJUv3470ThOPN3Bu+cL7mluQZQZR3po6ZjHzQWFlwSF9ci8RrCy4R3AvMHfgLeuZ/VEZb4Of7bYS/NhllPqmmQk1KCFy+pV/1W9SkKPPuvYgR3paA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4679.namprd15.prod.outlook.com (2603:10b6:a03:37c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 06:40:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 06:40:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/2] bpf: Update bpf_design_QA.rst to clarify the
 kfunc call is not ABI
Thread-Topic: [PATCH bpf-next 1/2] bpf: Update bpf_design_QA.rst to clarify
 the kfunc call is not ABI
Thread-Index: AQHXJSds/Y13nqbcI0mxWNoTsSG/jaqcFNmA
Date:   Tue, 30 Mar 2021 06:40:31 +0000
Message-ID: <67001148-0774-4C70-8AB5-EC0DF90525E0@fb.com>
References: <20210330054143.2932947-1-kafai@fb.com>
 <20210330054150.2933542-1-kafai@fb.com>
In-Reply-To: <20210330054150.2933542-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
x-originating-ip: [2620:10d:c090:400::5:6e51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbd7d027-2bc2-4636-6d21-08d8f346b739
x-ms-traffictypediagnostic: SJ0PR15MB4679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB467963BAD86892D2E6681A8CB37D9@SJ0PR15MB4679.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qXedsrE+W1762VkUWYGDbVPXIYcrw32B5bxpHEHDXo7OP1umuI2nD7Qn7YMXIyHbN+zyugSd1iAoG0bu6IwJh6p7IIsGV5nlVwoz3iXUzpfo4PBvDKElFMa2PTyXsjnYl4SPJ393YKeyU78SpjhJQMgGUhyLz97zNi3rm4AYerOvlJ3iCh2vbrC5uMqpq80XILkc0HxKXvt22MH7tlUOl+XGTdTd904+vlClPaocC1FLlZjFMZ1sJGaBXTx22nk+Nn+lfXk9XQbaCEygFcVoPFakIQbCyIZUEAmi138jg227nbz7hOXWy3udYMErqRsnnr+LyRywhEgXzlnlXZ/GC43DbJOSai1hHZeZpb6no5Mtx+HoONJAULWPpeNwIeF6YtG/I/xiOtO7Kmvvi0/ZNZh+aBd7hwXHund1EOOh7IBpVPOSVf42Di5w2zJU4+/larKhUoZ5Q03Xm2pl/kSC0ikrUd215rxmhWVGdKiCM4XEJOohUmp49gGQuUmkPph2znZJIHuoKg89oFNcswZwwXwbVhiy3toJ51TmbPFP4M6UrhYr3QKTPmzAAx6nd0DfNVqpAXLjRke0nM3+si6Q8y7YKWejO1WEnQHKzEWpi0jU5y8ArTVpHID9ydma3jx2pUWJaLBYsPI4GcqueMttXcr+kZT1igHbhHWfNLU0FvKfRMrN3l5bYM4G0lNfJhit
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(8936002)(8676002)(53546011)(6486002)(91956017)(15650500001)(316002)(33656002)(76116006)(71200400001)(2616005)(66946007)(6506007)(86362001)(66556008)(54906003)(66476007)(558084003)(37006003)(64756008)(6512007)(186003)(478600001)(38100700001)(6636002)(4326008)(66446008)(5660300002)(83380400001)(2906002)(6862004)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oJJSpHtBxT/oq3tGmrC7tTwGw9u01Kp2lIj6WHA1o2xt5DTkB4+Le+VfCnnf?=
 =?us-ascii?Q?iTdfwyxnCpKIozZosD9EQ0WzzlaDnTdy5cDozGLN5lpn1Nz3VUAIKQ31npDA?=
 =?us-ascii?Q?SEHl7H5vOx07yGUJDGl75IVgDCcq2HsOH/iPhBpFLPFQmq5psIaJlkm57CBC?=
 =?us-ascii?Q?dFdAaLhX2Fayjs94dd2iwivhf3J3oCcCNXxF9ePjLqmrGqDBi4+ofn+LYR66?=
 =?us-ascii?Q?19BLdWF14CpElqRW+bHWeIw1GkT3nrBvCVnW1M4aHeoOsW4ITCQ2io1fxg8v?=
 =?us-ascii?Q?Jpae0utoaoJMwQA4QG0uaRkgLFRnIEawVhs6ylHcTtZ4+YZRxeXf+QU4CdP/?=
 =?us-ascii?Q?kmhDA08ofrJTtpUHKJgknOWqBEsSCsV3SKAhSoVhZ4ilLlqFgfRK+fhULJQA?=
 =?us-ascii?Q?6aqqjKZmVtD6Iafrwb1s2WVkeqA2wHWzog0zjHvFBIiiWeH7+EUQgv9BIiRw?=
 =?us-ascii?Q?WV9VcnKbrZ1FzqzQ1PB/zibk33jQ8TnZRcONmqOoZc0K9p3rL5XJJG0J58W1?=
 =?us-ascii?Q?O3BGtboI2Ta/+d619rj/btu0E1HjFJ0Xxufvah/3x5Uko8fxptqDCSNOjTAC?=
 =?us-ascii?Q?85y0b1siSUKakSUPaD5HwqZvsUSAtHhYFcnZuMk9BcMhzkXpsolU8Sa926ER?=
 =?us-ascii?Q?kJWBmWsLUiQ4lvRTXEkCbP4fJerA5jR9BxLkwwRMDj9qAUhiC4Brp/to6QsG?=
 =?us-ascii?Q?mzjX8suvk6FnT3axk1sAwsU+eex5hjQmJOFqLhEcc1VKxklGOcsDOwKKeKVB?=
 =?us-ascii?Q?qpFMYnz51zDRcWupt8c7Yt4ZLfE0T4eHRwu3GYbzjhAuJ3Qhf5Z4JdUgJZ5b?=
 =?us-ascii?Q?fhuV36fXDCU9UuAah7l4UjiN4X7yLnRWyiJ8WlFyQp5PCJZ8m1jPQPBU1Akp?=
 =?us-ascii?Q?onO1SsDkSJPKXNLrB32y5j9RTyTQ0+mL9i8/UTN6r2vuHhsUA3pc5aTWqsbw?=
 =?us-ascii?Q?pna60/Tltzx6kCfDKnu0kynMVtwn1GwX3aHijU8S55ryia/Bu4vOOJEZte9M?=
 =?us-ascii?Q?XM9F1V0klsNWOx1Wz4yQbfroYT79BgE15AW0q7zMtqbAMDV6nKqtUEtI/tW0?=
 =?us-ascii?Q?uODJ7zK79ww9IWvETBAU14UcRlptpIzLgvFLWzN6W0uZbgKvzadu+ZWSMxZc?=
 =?us-ascii?Q?qYFhSnvhhdIAKYcI+PWqo6vD0Ui74lI+PSIowhLSjC8AmcQSnBx65Dh19pGR?=
 =?us-ascii?Q?Dx/i1eFRIfd6i9iEfjlbc816PmeXlOCqXVNnGGjQoRQYMdq4crmJRG/xPnHz?=
 =?us-ascii?Q?kAbq+hDJEGFKMbszspmDt3LW2V1c5YvZyHtag+SfgpN6oINbOASyQ5nuT5hu?=
 =?us-ascii?Q?P1X69mBvzda+kRLZmXzQDEY77pqoEhVkoBVa/IDvcc9qNn/UIh5JNCph6+gZ?=
 =?us-ascii?Q?poYrqrg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <648ACC19D1F2C2458D2C4A0F4B5299EF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd7d027-2bc2-4636-6d21-08d8f346b739
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 06:40:31.9070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4oBsr5YnZmM+px9rAMUsVMdyt4qUsjTSePev6oL+EK0YyYbjmPrlvrNBfzvL0ZrAQD26ztz74MlELe5Xc83POA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4679
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: zM9VaxkDfywDBb7WQSIPDELsHX2W90XD
X-Proofpoint-ORIG-GUID: zM9VaxkDfywDBb7WQSIPDELsHX2W90XD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_02:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=888
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2021, at 10:41 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> This patch updates bpf_design_QA.rst to clarify that the kernel
> function callable by bpf program is not an ABI.
>=20
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

