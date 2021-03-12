Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319B033832F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 02:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCLB1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:27:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5232 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230159AbhCLB1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 20:27:41 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12C1Iv8w018328;
        Thu, 11 Mar 2021 17:27:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=thW0Ispcug6v4seX1pr94s+5/YXEG9/4lO2qjfYtGtM=;
 b=PUBUW8jFBtLSSU9QYg7XKofFj1H+ph2us0eqe932rxA176SYhQpv9vkYPyBxD1mpT6t7
 e+Ah7IudmwBOmI1Q8SWQrxnlKntX2l1RK+VmGGSyPImXaMuExYG3LHoBOyuqihWKDHlI
 DoXjhDzsjObie9X/elNswXi9nb0GdqVBZmY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 377q93jpd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 11 Mar 2021 17:27:15 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 17:27:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBTmH+maKKQOhJOq8LF5ma1Yt3pHn9QL+ORpu13he5/vv8AUWCvuE6Xo+D+ZWDcBhzgDaP04IecwcSCvXhNMrVd7t7K10ngmIUpdwK4njNzcKBA8v4iAyJJYqBUzX0lZP44ZZhGJdbp+MFVSCUeBpnFTtmp8MZB/NXE7mlzcy5QR14GWY/Gq6smfVqfOTEit6Y9dhvDb8ar0bmnXNY49eyYy3OGQVVMeyJQzg0rSbjbFdja0tzqzF5+rD3ZIzH6BFuwzTqhpuPT33GsF2J3/aI5etdI4IL6iNwag6oZ8CggrVShJM86IMrasNXYImid9W5unWgEAGX8yw8qNWkIBjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thW0Ispcug6v4seX1pr94s+5/YXEG9/4lO2qjfYtGtM=;
 b=nchI+c5/JQchsTVUJObeIuZP/Lfp5kE8Bf/mTgvcSUIJBvNKcsFmMMCcm008ZJzv27x7liznB5zHiTJ5djFsVPp3HAP8tzZ8xoJemv7Oyi8E/3rhNy9FjBprraoZH+P4sCCvYs3LcfQ9B9Q6ckYNe50MAvSTKs8z0vFL6R6ZJ8HxlISe8Cd5Gw3O/7gQvQ+gpA+SfxbQ8lxl8pb0IVKv2GeXNgkAfUF11jcobHYjKmUpvNNNPvmUsuPozi7pUVDuBC3/LHr/k8tA8E9p/hYu8xjcxuBkFTqnm/43b+FFMH6UwWGAENLTS6ISb/GgmjwTYOW87wjh4DldxRA4bsfiXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 01:27:10 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3912.028; Fri, 12 Mar 2021
 01:27:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     'Wei Yongjun <weiyongjun1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Christian Brauner" <christian@brauner.io>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: Re: [PATCH bpf-next] bpf: Make symbol 'bpf_task_storage_busy' static
Thread-Topic: [PATCH bpf-next] bpf: Make symbol 'bpf_task_storage_busy' static
Thread-Index: AQHXFndsSu0n8D7mh0KB73BNk34KkKp/kLSA
Date:   Fri, 12 Mar 2021 01:27:10 +0000
Message-ID: <194DC51E-6208-4756-A84A-6D317FF0F77E@fb.com>
References: <20210311131505.1901509-1-weiyongjun1@huawei.com>
In-Reply-To: <20210311131505.1901509-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:9718]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5df9a307-3ee5-42b9-52a4-08d8e4f5f531
x-ms-traffictypediagnostic: BYAPR15MB2886:
x-microsoft-antispam-prvs: <BYAPR15MB2886C6A7A409004CE38C4984B36F9@BYAPR15MB2886.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:422;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nn+aJuUyvEsPq12fjpfBL+0drU9XePUEGnYaGuC4ensWa11yn2K3WleH9hKo0kAkcIiTsF2rZCWaXjE+Rhyqwa7iShUmAB6dKND0/FK4C/juRaUHnxJkKKNksZgP9aekLiABKkR1CStcf50K9uFbzd3m4GY/VNGxSOnpWvDG0W7YecGC5+tNt/OaphE06zVMFh4/tUQLqbROHUW5Esx+v4moVhSJE97u5I08dlblPTDuBlKh5Aai9J8nswS2Ai4igXkNRoES+YLcC6D3O7TpymCwcrtnUl+QY0OPfNMTztJAWL28y7F2q1arVoWjt+CZmalhM6DC2hPxpbcVMGFgwl8pc7BwaKQGnQJuwzYOWxaC+9p5MCd1oKCEqJTlDo0VGQ/7FavYWY5X4scisbsgUKjOx2bLOIBGCfecqi3xPfXCQv/0jDhDTSBUSEFvcvf99SMFzsBplruRDKklezuMEr/w7PPPnqeWFmcPZP3KR5hk/yhNSTOJh2XicG85drm94EKezANc0H+uFFYtFiizouFnCVXvmJuzs8FbMVwh4nL7AMnmcSONslLgaxYn5uznTALf6DBdL2OmRggRpDWWFxwJxi0Cvtda1ROxl4O5SNxXA4VBYGQVS9LgSZSqozLW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(36756003)(2906002)(2616005)(86362001)(83380400001)(6486002)(33656002)(8676002)(71200400001)(316002)(5660300002)(8936002)(6916009)(91956017)(66446008)(66556008)(186003)(76116006)(478600001)(6512007)(4326008)(53546011)(6506007)(54906003)(64756008)(66946007)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kIiLU/cpSXJRm6vmVsd4RKHOgR31t5xYD3CEC9c5teYoyG4w3gBUaVKEq+el?=
 =?us-ascii?Q?NP8gy5CbWCVF00pPSU99VIG5sWQwDDC0c5joryBvflyGDTPPjf30/NzbuCXh?=
 =?us-ascii?Q?tNYDYK4esohkWdgXvfgC6irV0ouw2Em1jtocGvl72q7AoGMk5nPbK1VLJyrj?=
 =?us-ascii?Q?Ow6zkuDdd0U1O+v2/kWzbjqyzoG0UUhPG7GZz9OM/f4d1TNsyEFQFC5TlX+x?=
 =?us-ascii?Q?5KfoD33lc4YEgvwPI7OTQwt7B+Mf6yF4qG0Js50zimKNOlZdjHw21ypViOSs?=
 =?us-ascii?Q?MZI+kv897XAQotkPPuaRaQbiDLhpsggbjK6/mbosEZCuGxjSpkWTQpyjToOB?=
 =?us-ascii?Q?0QYvxPgfdF7NA+iSvpoMeKxvVJKB7gyRLAqrSHXINZjNGJsTOOqX2z22pLRE?=
 =?us-ascii?Q?XnGqyuQbm33CFu7/eZ/FB0/yq0t3tUa9SHfBmFBqN7wdPP41zjoRoXIWpGlG?=
 =?us-ascii?Q?8T15X2uU4yYOkXj92/1FxZUOgRnMIYLQHzOTwLJJrkJN31XYz3OzxK8hd2oM?=
 =?us-ascii?Q?Jhc8ICLEIr2JiTHNVmv3pUMdagZlmylekZMiAniOMP06f2k3AQYrJ20q6/9h?=
 =?us-ascii?Q?m17cNaFn91dlRbvf3stky9Fu7vOkiNzehdUhZNvvv/4iLt0sOfTms868BIBR?=
 =?us-ascii?Q?ghmGG7z4ika3HGeBPKoDkaGpJIKeb7wfE+Cw7eqd3admvo/HvdxbSuzl28pj?=
 =?us-ascii?Q?HC4XsMUJpmQ5zEcOLntqNlLLP3RvdTrJSFwOSrluYqXaOpgNyEgdc5JGuiqB?=
 =?us-ascii?Q?/qkRzrjlmtQj0ZWupxcENcIcRh8KqCoTq9+VA3SmmTkq93Ygr75B+l91TQAf?=
 =?us-ascii?Q?c2uoJL/3yl0/1FMnXGkrgaCOr4q24gVc78TECKKseVgEVHL4hXXTtEQ21cc6?=
 =?us-ascii?Q?mSywZyeVznMlm5dG+N1yZM1VF5+314QopENzbXCqS5z7eqmyQtIWNrhZZuHh?=
 =?us-ascii?Q?swr3qJM+qgcYL8nbLW0lJ9KmlE6zAJdzjWTZZb6fsJgSN+wDBuINnALTiKpN?=
 =?us-ascii?Q?ByV8YsQXKWiEnbBqaPPpJrOzc3OrjgpfrKt+S5cUIeZblOkSriOvbh/GTO3B?=
 =?us-ascii?Q?8gjV7Zj4JGeiUfNfvLDAIM5LWcWj0YdZT3uKj+ymW3Jwuj8nbdpo28E4kWhB?=
 =?us-ascii?Q?zEs+IvavoXn7kRU3ExToy4b04O4Jkbn8OznOMdSxHPksfoY6iFy3+eM2HIGO?=
 =?us-ascii?Q?Z0Q8VWWLlEsxnPtxfveC1x1aptrZ8puh8qM4qT4GKt0qxA88NLvw6RI2J5yF?=
 =?us-ascii?Q?+NU0McDIV1px6vdchMrVtweXobvrGOBRtfqF5SHJXSQZzW22vzrNBpeIXDKk?=
 =?us-ascii?Q?lyMODYkrdIB0hKXFOXXU9wauvOwUQomESaLO+8hCJw5ouGlo+1gGhL3O7jpC?=
 =?us-ascii?Q?k7jlKtE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4A4D763D8A8BB47938BAA3969679C4F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df9a307-3ee5-42b9-52a4-08d8e4f5f531
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 01:27:10.3176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GhEp6chK0wQP3yEDNW7voMUltT3kVNGF9JMGTeOfJ8MP+2xKiGJAO1E5HiNeebRbKiYOLrzEWH2J5INO6ILbxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_12:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 adultscore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 11, 2021, at 5:15 AM, 'Wei Yongjun <weiyongjun1@huawei.com> wrote:
>=20
> From: Wei Yongjun <weiyongjun1@huawei.com>
>=20
> The sparse tool complains as follows:
>=20
> kernel/bpf/bpf_task_storage.c:23:1: warning:
> symbol '__pcpu_scope_bpf_task_storage_busy' was not declared. Should it b=
e static?
>=20
> This symbol is not used outside of bpf_task_storage.c, so this
> commit marks it static.
>=20
> Fixes: bc235cdb423a ("bpf: Prevent deadlock from recursive bpf_task_stora=
ge_[get|delete]")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!

> ---
> kernel/bpf/bpf_task_storage.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.=
c
> index fd3c74ef608e..3ce75758d394 100644
> --- a/kernel/bpf/bpf_task_storage.c
> +++ b/kernel/bpf/bpf_task_storage.c
> @@ -20,7 +20,7 @@
>=20
> DEFINE_BPF_STORAGE_CACHE(task_cache);
>=20
> -DEFINE_PER_CPU(int, bpf_task_storage_busy);
> +static DEFINE_PER_CPU(int, bpf_task_storage_busy);
>=20
> static void bpf_task_storage_lock(void)
> {
>=20

