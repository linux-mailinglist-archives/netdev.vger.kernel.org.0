Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8341334D535
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhC2QeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:34:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20400 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231134AbhC2Qdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:33:36 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TGPLOG025504;
        Mon, 29 Mar 2021 09:28:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XiXjkavEul61MVJ/8hyeE+4L+cvRmfekiUQZc4/FDqY=;
 b=VQttJDZHNTM1+DGVCVdp0r1wy1mL0C/QV8qsSAHudVX6HszwAGKX/uiVkmA4WUWAvIBD
 neQFq5UUlc4AoxbhZ5KAmqw2pgtoR+bliGGGELhcLbyM6x3aPgG4mgaCVPTyfrDrmefw
 iCHNWpN3QD3FQ+P5Qtj0IPuqs+8MlDUbUIo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37kdyt1h4f-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 09:28:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 09:28:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnA+8QSKooKa2xWT01CVlQ3K2SV50rteuPi1MknZp0dXsDMflPIo/PrRq8vFNq8G8WYD7Hh/Xx/62BHhg3oRHM6R2K3IyCk0ivouN5MEqyT9OPrXGecmrThi8rk/s0XqdsOGp1Vtp63vEdN/SLbXUGbuesR0Hmos9OK30Db7tHxdCE/GDhSA5huuqUdVzYXUTOp8XhvqjzDAq+GwiElXdYKDTRFZ8de5PwpYpENolhBCbz5apn+i6dtkUvDz8p40CaRRUXysQW6ZolN9/Pk5vnno4/3jyN3pzlwdqLjK9eUE2pjZWWOgSdAXSJcDk+BdfsM8GtM+RS1ne9oVmGr9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiXjkavEul61MVJ/8hyeE+4L+cvRmfekiUQZc4/FDqY=;
 b=m6aW2uY44N8MPJYaxDiE5/UmLcvlqOMDjjarpBDYzM9kdWRnrmQp6/p6airmq5en5G7dGlnDVd3R0it+S8/jm4Kf4U8cqZJ34x3AhL50KslbytVVGkdIAeP1ixEgBMs4NffFuGGlsiU9b8ioddnFmr1SpWemehKY7egy4Vb4NcbmpOmPL26pJ8o8xQoAu+937MMxaSlIfrKC30pUqEV2wsoWgrIq7CvhDv38VyrCzQhoNkzlG6Ovd3FN92iqpT7wIYf000V08PBcXbA7vvJgi5OArQgObZU1jmtVpLx7+Vegj65Vj1CDcz/EbrtJpFG8wARM4l58fFEy968+zslyGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4680.namprd15.prod.outlook.com (2603:10b6:a03:37d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 16:28:18 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Mon, 29 Mar 2021
 16:28:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Add '_wait()' and '_nowait()' macros for
 'bpf_ring_buffer__poll()'
Thread-Topic: [PATCH bpf-next] libbpf: Add '_wait()' and '_nowait()' macros
 for 'bpf_ring_buffer__poll()'
Thread-Index: AQHXI+03ORNntXupUk6L4u8Dfh+Z4qqbKTIA
Date:   Mon, 29 Mar 2021 16:28:18 +0000
Message-ID: <BCF68ADA-5114-4E61-87DE-D5E5C946BC6F@fb.com>
References: <20210328161055.257504-1-pctammela@mojatatu.com>
 <20210328161055.257504-3-pctammela@mojatatu.com>
In-Reply-To: <20210328161055.257504-3-pctammela@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:876e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c796a977-2139-4a57-a461-08d8f2cfa96a
x-ms-traffictypediagnostic: SJ0PR15MB4680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4680D46769D2E87DAC26CF69B37E9@SJ0PR15MB4680.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r1YupgcawPwb/kGQbKJL7eNXbmsFU6c2zutI9TKasNR6ZxTyQGAiwDDjgMy53bGi63deMl8qC100wN7Eitcf28WYVsx/8H6d0WbQfKE2duu0nmtKJ1XU8Mk/CVkpjYgzfGAPMOYyxc0fYJU8/4C3JoZpciNjMbiMeYXsUb2fbODDcxygFvTtzmjGkZZW6zEJm1Nn7VehqCRwc8IuE7bdQscr9D/Di8JS8R2sYj8y1a173ny4ufSMdzc1ASsMyiwaxn3UuBFE2NtHxPuwZTucniNqDNFXIxD3fFdDqcblSMfVS7lD3U8xXxjMACmeqtuh7eUMhMQKeD+t6Sj41KN8VTEOCscaY4FTI2tLkQ0AsJ0lMi/oL6W1EMT+fVcZcvNLVmpy48N2xsYj0TyBBPMWh0YQOrHoYB2OlpsydGhMiSUugjs8jKB+Y1Qc6PjiBmJI1IsOwYFcB71eBYcV7gq99feRTm8OIW5R+dSyruefVmvQc83P8s9LbxVswQpcTsVZkd5TtIjUXmcdKO4as9LscY/yr/Jkzrlyz7Sy3PTFT/jA6w9H6LUkj+stVbiZh5kOS+MgS1a97RiWCPpqvqa3jjlYGdG7RJWVKMiTu8zvsju/1Xc0rvskH2YnhqkwNdcyp0RgM9uS3dPqni0A2hBLNhq/EqQDKZuz4gWM3BPCg0fMOsfpr+1AiOW3k1wsaN6XkjlSSwvMHi83VCDzSBj1vEZxJ/zrd5F7TiRo41+s9cA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(346002)(396003)(33656002)(54906003)(316002)(5660300002)(66946007)(2616005)(4326008)(6916009)(71200400001)(186003)(6486002)(478600001)(83380400001)(7416002)(6512007)(38100700001)(86362001)(8936002)(66556008)(2906002)(66476007)(6506007)(64756008)(66446008)(53546011)(76116006)(8676002)(36756003)(101420200003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eFMOLdSIUdrwCegIF9c6gkMVt//TTgrNFJIiUwc5D66F+FRosnDGCtUMSy52?=
 =?us-ascii?Q?AHQdiZbggwW783AIM171+UP2x45Kp7c11oo4TL+sTw7pdrFTIfo8GWRz/tzb?=
 =?us-ascii?Q?gUirXJbab0OwDbYqeKgAYXU0vM4WLMOrJxuxq92lMTIoyZu5YlmaDusvt0DR?=
 =?us-ascii?Q?KdtCONtgIpED8gfebmekyYfjn2dMyaKU/LU0CvIojQ0nEvTh2UXdOtsNoIJP?=
 =?us-ascii?Q?imo9iKvvPZ8Ds2hE7qbkFdON4L/G2SfjOz7nIZi2ukMGRL86KpiixVB/w/+6?=
 =?us-ascii?Q?6YQkPsSVL0qpRh262Zm+GQV3C4OKZECuQtmQZj59gvE1M9nTbXIS8dHRZVZ2?=
 =?us-ascii?Q?eFagh+k0r9nrNsJ++BUqSaOS9IFn+b59DLJ/PXTT2YaKOSlYhoX1EBCtYQaI?=
 =?us-ascii?Q?REmScKruhgCHBUB+/F+rS63GkYUd6SOypRgl0NHRxXeRjIeHgkGJ+8RFKu/h?=
 =?us-ascii?Q?+GxtvKztYm6nSCWlDbvQ3s+28CiwY2n5xNXYU/ZgOTc6ZeBZlxsXE31zh1if?=
 =?us-ascii?Q?hQNaZ/1Lgl3yW7vbSIu+pvhb2J+9PNVx+MBWSc4g/JMUK3yhlUugpk1h1FFH?=
 =?us-ascii?Q?y76zhVFeI7EIe6jZbhTRiZKrQwHNtke7sUybQGofcRXOuiFVsw7Bv0rOeLDg?=
 =?us-ascii?Q?dAg7mMVY1kvWEvKFQlhIRU5FG9AQyob9p4jFRyhO2fPDLDNCvWNYR3sNCgzi?=
 =?us-ascii?Q?04Xp/j4t+ELeR63tmrdvZCj82hK11NDm//F3yyarQFFThV8QFNmH5xsfLlbN?=
 =?us-ascii?Q?DUlSHn6+RiQFD2soPMcrZ6wQmTEz4SpkGadabkjTb3ClC5fCFPBi9E1DS38Y?=
 =?us-ascii?Q?NS0ZqrPAkCJw/GSvHeeWUS6uEh5IzmxJD29QvkHD06WOMg3H3j/BXtO2dUVe?=
 =?us-ascii?Q?ZA9d/f9pmhKw2LcebpMogtgtGLbb2LchcL1zg+zu2mU4PtkfCdfBiCYKHkSJ?=
 =?us-ascii?Q?bMfZjfOo1kl2vN9c/tzLn/QYGBgqjk1maWkbeDGm1ywGP5RB6ZzZv7mOwa0d?=
 =?us-ascii?Q?pmojX65s0GBJWMvI9daWCdRANCE77j3XxZKpagDrSM4JPlxAViDHVjjaeVuV?=
 =?us-ascii?Q?Pf8MPfmqEa22R2XJf/g/DMebWsmTcZp0YQAwlqSxbCJO8j9GaLtAM3FbhknG?=
 =?us-ascii?Q?3P8aC6nnJvNI/hoWLWz4LFNrFOMHAECqytjroA/ELYnG9aTaMM7horsTnDdD?=
 =?us-ascii?Q?lRg6EhmJbw/Y4Rfevr9rH12rZgeERDMqg86bmcc/2dl7DST7eIYW3jJm84Tp?=
 =?us-ascii?Q?NJF+Xw+ZukmOSthtm/lsy5AZLfTJROOP5TU/kyxWEagG4rXjSwF6RpCfW2i5?=
 =?us-ascii?Q?GEJHUK06idw+PyfqDcJXfb/yCBKnw3++A/sRrcuM74SS/Lnmmn/JA4E57MY4?=
 =?us-ascii?Q?O8X968k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C97E86928BA2049A6E95A74BA4ECA8F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c796a977-2139-4a57-a461-08d8f2cfa96a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 16:28:18.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eEMzW4hXWG99WAQrlLnbkmR5XjLlraYFXkQoY/h75b49zSChEGm4aVOcSKnWPY46iALNqLvMYXOtoC3+g+tZzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4680
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: x7958uYfxtXFtYJg_IYqIzE1DFTdvEBD
X-Proofpoint-ORIG-GUID: x7958uYfxtXFtYJg_IYqIzE1DFTdvEBD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_10:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103290121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2021, at 9:10 AM, Pedro Tammela <pctammela@gmail.com> wrote:
>=20
> 'bpf_ring_buffer__poll()' abstracts the polling method, so abstract the
> constants that make the implementation don't wait or wait indefinetly
> for data.
>=20
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
> tools/lib/bpf/libbpf.h                                 | 3 +++
> tools/testing/selftests/bpf/benchs/bench_ringbufs.c    | 2 +-
> tools/testing/selftests/bpf/prog_tests/ringbuf.c       | 6 +++---
> tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c | 4 ++--
> 4 files changed, 9 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index f500621d28e5..3817d84f91c6 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -540,6 +540,9 @@ LIBBPF_API int ring_buffer__poll(struct ring_buffer *=
rb, int timeout_ms);
> LIBBPF_API int ring_buffer__consume(struct ring_buffer *rb);
> LIBBPF_API int ring_buffer__epoll_fd(const struct ring_buffer *rb);
>=20
> +#define ring_buffer__poll_wait(rb) ring_buffer__poll(rb, -1)
> +#define ring_buffer__poll_nowait(rb) ring_buffer__poll(rb, 0)

I think we don't need ring_buffer__poll_wait() as ring_buffer__poll() alrea=
dy=20
means "wait for timeout_ms".=20

Actually, I think ring_buffer__poll() is enough. ring_buffer__poll_nowait()=
=20
is not that useful either.=20

Thanks,
Song

