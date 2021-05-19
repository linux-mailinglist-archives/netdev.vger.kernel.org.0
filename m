Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C75389480
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 19:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355574AbhESRPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 13:15:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53944 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242386AbhESRP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 13:15:28 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JH4TH8031916;
        Wed, 19 May 2021 10:13:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=y17zd+ph7PVPqLZlcuMS0mI5Efs5OPzNRSJy+ybtuZM=;
 b=ahSKG60ZUH0tmsvxW2r1GDTA8cVNSMOvuCB/uyjKYvuZ3OByDw6iH2Ws/XcjhPpAeMN5
 6wiLrt86SKzSjg9dOySNNZsQbkxglwMq4/BCs/K5SmvN03EivcN7RHfBkK6fsUxbYTdL
 QXZY7vVQaaqATRdn5XCtyjuQJinnrWrpwFw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38mynbtkdh-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 10:13:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 10:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6tj+kArtr593DBZ9M2Gj+R9iNsr1qDimk1VAQrKP46ZhlY1oZK0D7+JUd7J7IG8Fxmxpln2QTQ9beEqYEZnvY1m/QiP0FgwfhhP292Y/vjpTHdV3/8t0x+UB7nLWwVVvMuvpN5Xl2SOXKELiKP5wtfbDdkLXivc7fVewCxtgTo9z1w8kaaPXSep9XNhER2NEkOBOiOh0tKEbIwkr+0wZ0eOyNGHNDOwtmek1aeSJyYe0rWZfpuquXNNCdBWbj4ZC/pKMT/zFfAbpzDpA/sYFgfGwyglyAXr4PIPXeddiTNvxDz6esELGcSjs8Zctz5uScjCsRS1Y2Zb3aW2LsjDEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y17zd+ph7PVPqLZlcuMS0mI5Efs5OPzNRSJy+ybtuZM=;
 b=CWqYc41Vc1itkq23skEc/bE2Gq3k3tQr5MpMnq72Ly/VYUB13G3j+QI63zkWQ/UCH4XjziSj32nkvUShbdBMnTKvFNAfqsECf8vbd3jQyuXYoBcYS9cXcPVHDsZGonROrYlxu9seCnDW0ScMHIyuikXGwBKDs7TEHH3crDJvv17LaOfSkbvRy2EwXNL6Opvm7iO0+3pAtyekFIlWVUjus5h1irCW0iQx2rOv59+Nl0SCGBxP2yqq7e+HzOiGcMWacoUXCQmTVkw8I+955glOI0LALH/gBcoQoqr/czfeQ5SOQfSVORZw1gWNMu/oRrEEyc2kYiFCL6Q1DQQKvO/gSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3665.namprd15.prod.outlook.com (2603:10b6:a03:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 17:13:42 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 17:13:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pu Lehui <pulehui@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Make some symbols static
Thread-Topic: [PATCH bpf-next] bpf: Make some symbols static
Thread-Index: AQHXTKHfLfKX5VY/BkGohBXM265fJarrC12A
Date:   Wed, 19 May 2021 17:13:42 +0000
Message-ID: <10D9E2CC-1EF1-4F67-A5FC-735D1A1F1E40@fb.com>
References: <20210519064116.240536-1-pulehui@huawei.com>
In-Reply-To: <20210519064116.240536-1-pulehui@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94ba53ed-bcc2-4432-8700-08d91ae973eb
x-ms-traffictypediagnostic: BY5PR15MB3665:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB36657DB01A13BC254FF0907CB32B9@BY5PR15MB3665.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wdc+rvfJE3P70gh291EmqBoMDLpHpG4g1mVSDJxIhTUStsa2GXtQnPNwYlvHcXdGD0M+ER3cifhfBLlMi+U/jsbSltHDIxh8JCStEAMKWQm5Wng7SNgEAjC0P3kDCUoEq0yrFgDHmBPU0mLnLEmhBoonZaASR1jWWQhgAhp+tJbmVQe0JmPpxgIAAvK9t2QZvZgucwJhfv/Q+GGdgd8ELtpUmSs0XNGeQSy3wEKCFHNc5eJZN9cSniipE/z2JFyRSx2DD8psKVCa+i0tANRRjndnqDgM9WeavFZLEu4/OE0NsblaADM3Lztw6LjKbq7Q6AEzcqkzqEEVGwZYBnrWXm4yYEHMtdUM766uMFB3Lvz6y1NFcxFuxAQMdhcMt9I5JJuqcfnh93LgrG//t+fbC7gypMVsAQ6+xY0jA+coG2HNtZDCv8Vfa4/wUUsS7ceGLHS0nuL4ClITJrrCkYSjNOdUa1/lQg525hmiq9KNO1QHh/5P+Bc+tAzHKyK5WvmXOFwuIohw7W+7recepadUyr2w56WjK278DEvOnki+nO+kY4KMVeF5tozjzBg2ttSUFH8CB7ly8z/02R1XiqYXdc4rDyuUhbTgLrmjhiyUhqdrMIruvB+X0d0B5rG+jFaCOhMruDAitcY+J8rdMZZhWNqCjJ+J9cmnqERz6S6XWoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(8676002)(6916009)(53546011)(6512007)(6506007)(66476007)(66556008)(33656002)(64756008)(66946007)(186003)(76116006)(91956017)(66446008)(122000001)(316002)(38100700002)(54906003)(8936002)(2906002)(6486002)(4326008)(71200400001)(5660300002)(2616005)(83380400001)(36756003)(86362001)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?N91Mkmf56VcuPO3BuVAwaIhX2Gob933gr8Y/jEXnSx0AZZFRynx4JjlzPaDQ?=
 =?us-ascii?Q?oFeXtv+bPeIPw2JBny5Lj6x6H1dk5Jd5/1JiYVqr2hbwqRm5/hdEwXC81sA/?=
 =?us-ascii?Q?XzB1esn1XS1e2Ox/zcADAuuxMuzL7Vm8Dak2BkM/SA1AhMvjK4f1eIozHoUi?=
 =?us-ascii?Q?8uwv967OCCNYkaqOOG4Z22fH63eFbllMa9N067n/uY3Q0d8Rs1ymH9QUiclo?=
 =?us-ascii?Q?S3j0S2zv56F88fcOly5sc3udoaDgdpKeK+qN6pvK68bRsTVfcUqwx4cBRLmH?=
 =?us-ascii?Q?M8L+Wk5aObF9lFLC84JinxQRADcCaRvhwvImUNmrsoNSR17pC/+lolkxSFh2?=
 =?us-ascii?Q?lWzv2ZhkW09hRLUDoqyPQjV0ElVd+jWRVwf9rUYRr68ujFU2+gQFMCIlnpsX?=
 =?us-ascii?Q?MIxjqmOBNZ/KJMaymbIxchLLA4XX5N+aDYGzmrT746w01Jyb9OdbyOFjb66O?=
 =?us-ascii?Q?9sOhbF5wFNbe66vEGkzckbW2adOi8s2X6EFs0VGwEJgCzOLF+S3JsQ2WzFSp?=
 =?us-ascii?Q?B8et7N4iMh4YvhGGRaK/1IGQRDCMYAHhoLF0Fb9A55OXSJkWi11HjMZdPliF?=
 =?us-ascii?Q?/OoE8LmU13ZKKIJrbSw6GYe19FBjgWljovXmidZZZ/KffIvbSDCll6Lj4pOy?=
 =?us-ascii?Q?qF+L6DnBm0QV4zV0mG67aZAoADWpoMVS9KX8GHHIfFa0SsRNVHCC2JdUqgzY?=
 =?us-ascii?Q?oSUw1d2UrGFgm8RfO+TeJOMWWvHH2rGB00drPufHCwfF2uoZ5lT64C5xxu3y?=
 =?us-ascii?Q?YnW8bbGgoRcvVuiLgODxs6dhrmMKF6y/5O1oS+zvItfDboZkSdgP1Ebic8lx?=
 =?us-ascii?Q?iNQ2XlDkBM/1tsykcHNjQLPuT0vv4FgLacGWXdn61kip/1Inm6CZlcz208Lw?=
 =?us-ascii?Q?ZhCfYutt2anmo5nlEZSYAYhw+pxRefiS34fJHAAb33sY8OQnnT3CYQ1MqCbi?=
 =?us-ascii?Q?0O3WAgNWqfk8UOfpmLMuB3AJfJ7kimtPls6JmehdFrl4WUFj/o5MEZfZYMnT?=
 =?us-ascii?Q?b5ryVwf1XF360bhV0QV7pEPI6z/hWLBHcz4VoDl/9T9XDq5h2tGtUV83sqKc?=
 =?us-ascii?Q?kCij+XjC7VSU1ex96wC0xnOfUvBD95I64X/zD2KueMDHnQgtOn8lcvR/nYQY?=
 =?us-ascii?Q?NEItozdLfZB9+gT0M7X4RHRsmmBXT60epF65QRUdsNT5EA3P8LP47tp8L8ME?=
 =?us-ascii?Q?UhCm6Xjbq6JLHf1J90ZebnC4jFXgClGwnKC3R9sxqI3mbHb7sdlCRCvKUHZ+?=
 =?us-ascii?Q?AwQMoloNaqACkVNwXWvz0KE11VSjfkbwGIEjDGPyHoU8HILlPfjfI1DJUxGo?=
 =?us-ascii?Q?wek42bbf2bOHrut0CxVd5VvGkhOliTDaiHPL/tVZ8cDN5WH+8id/MO8xc2Gj?=
 =?us-ascii?Q?Lih8BXY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F743EFACE5294847AF31F59C624E7C65@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ba53ed-bcc2-4432-8700-08d91ae973eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 17:13:42.1834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fD1HSMT+wXKT2zRUzBEZZBz12zUrWGQTzAhD/mJNFP2edulwwUyhW0QtI0WxQAcsyZ9/Z4Srhb009T0SGUdLYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3665
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 68TC0cep8kGNCNBY-mqoJAqsQOiOgFSO
X-Proofpoint-ORIG-GUID: 68TC0cep8kGNCNBY-mqoJAqsQOiOgFSO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_09:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 18, 2021, at 11:41 PM, Pu Lehui <pulehui@huawei.com> wrote:
>=20
> The sparse tool complains as follows:
>=20
> kernel/bpf/syscall.c:4567:29: warning:
> symbol 'bpf_sys_bpf_proto' was not declared. Should it be static?
> kernel/bpf/syscall.c:4592:29: warning:
> symbol 'bpf_sys_close_proto' was not declared. Should it be static?
>=20
> This symbol is not used outside of syscall.c, so marks it static.
>=20
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> kernel/bpf/syscall.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2361d97e2c67..73d15bc62d8c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -4564,7 +4564,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32=
, attr_size)
> 	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size);
> }
>=20
> -const struct bpf_func_proto bpf_sys_bpf_proto =3D {
> +static const struct bpf_func_proto bpf_sys_bpf_proto =3D {
> 	.func		=3D bpf_sys_bpf,
> 	.gpl_only	=3D false,
> 	.ret_type	=3D RET_INTEGER,
> @@ -4589,7 +4589,7 @@ BPF_CALL_1(bpf_sys_close, u32, fd)
> 	return close_fd(fd);
> }
>=20
> -const struct bpf_func_proto bpf_sys_close_proto =3D {
> +static const struct bpf_func_proto bpf_sys_close_proto =3D {
> 	.func		=3D bpf_sys_close,
> 	.gpl_only	=3D false,
> 	.ret_type	=3D RET_INTEGER,
> --=20
> 2.17.1
>=20

