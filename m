Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA38E146FA1
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAWR1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:27:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59550 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgAWR1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:27:01 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NHQ374010702;
        Thu, 23 Jan 2020 09:26:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=w2I/EfgPe4A752+qeGgsLz/FPeYHuUVEhtLy86+W9Ug=;
 b=fjdvtLTljw1eRjoGuv27nXD5ok6Z/YCbHFaE5s+tMfNfigOYWtXAwiAoFgGr7I1yTrbo
 cAccFvu6OzNMcMYFbD01vifsYI/3pYmGiK4ScOefkor73x9jtB0/Iq7Jbd0yu9VH6FRX
 NdDdrLVJfC9QVYbtrJZpxJMSKKn+JJzCqWc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xqemegdpx-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 09:26:46 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 09:26:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hj3ism0YksLuE4quC7t1gJUJCj+cWKoi/xBjyDQA8AlrXnbt0JpnlrtI3mk94drr7u6jmnhsnV0H2kgKL+fKpkz2vf1RGPvRa5MIsAIsMX8GzOM9AgK4rTtw4n32gLiCpQFU0RpdBZBNeOm887AfjI+EKE2c6CZCFG0udVFFvAsa/XTK5EuBPdh95ptArKUmyHoUB4bn4hriJ4NQF5LPQsF7n8FEj4crsrdrhuH5Tk5PaBw5CSitcmRx8Xrxf/CPQ+nU8sOPhtJ2YM/taSDTpbT9QiZVpxOtLqZqWIMjpDqJTYsJ7tSpT72fq3CJVkvcZKKGPq3UunG5D3CF01uBUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2I/EfgPe4A752+qeGgsLz/FPeYHuUVEhtLy86+W9Ug=;
 b=Hp6o8Jl0L/FMHw1P60wKOVxAjtLuFh8chvBdKXns7anxpHN1fe2kJDYZUumY/KsjN855a0lOCy4nlkt/UFYr1ZQEDt7IiovMDITyBpkbzEeZxD80Ql26LUa80z66wSfYZni1uLCLQmK0XhYWdFlNttlGgOQ31YLHA07fMM9g0AVJOvigjlj7fT8KvxPeMtjzdbZpoPM+YMeA+1Isbft+oGUWzuxJlkv53kC3VCJa8wdkQPyLUfdlDAq9zscOSXm/0wax3Mbyn6EZOg7R98erNwy+U4s6S1U0YZrHHQcnDOdlRe9kI52bjbQzc4C0c91YzLc3xQovKpuqH5JkMeAKHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2I/EfgPe4A752+qeGgsLz/FPeYHuUVEhtLy86+W9Ug=;
 b=fkm+ZNPeYjgl15y+x2sYuJthAQ65PKazp7z/uUnC61fmweUammQUkEX1xR23WveiZMGe5hauu7rYVhhFCSBwhVfjetWf2neJTSUtiHA8i2qahlJgVjpFtn1mjONSFa3IaxED5BsBAnfyErOsfrO07bSKw9d9/gnGX5kQ+vYNYR0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2672.namprd15.prod.outlook.com (20.179.145.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Thu, 23 Jan 2020 17:26:44 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 17:26:44 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:d66d) by MWHPR15CA0027.namprd15.prod.outlook.com (2603:10b6:300:ad::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 23 Jan 2020 17:25:48 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf 3/4] selftests: bpf: make reuseport test output more
 legible
Thread-Topic: [PATCH bpf 3/4] selftests: bpf: make reuseport test output more
 legible
Thread-Index: AQHV0g6ItLyq7O8stEG8xWfq7jPWB6f4gCsA
Date:   Thu, 23 Jan 2020 17:26:44 +0000
Message-ID: <20200123172544.xjbcgtmaj5g3p6qp@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-4-lmb@cloudflare.com>
In-Reply-To: <20200123165934.9584-4-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0027.namprd15.prod.outlook.com
 (2603:10b6:300:ad::13) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d66d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 627b6c0e-a40c-4f6e-71ae-08d7a0294a71
x-ms-traffictypediagnostic: MN2PR15MB2672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2672D94609714551B47314BED50F0@MN2PR15MB2672.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(366004)(396003)(136003)(189003)(199004)(66946007)(8936002)(16526019)(9686003)(66446008)(66556008)(64756008)(6666004)(186003)(1076003)(66476007)(478600001)(4326008)(2906002)(5660300002)(7696005)(52116002)(55016002)(81156014)(81166006)(8676002)(6916009)(71200400001)(86362001)(54906003)(316002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2672;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MsPbm+IDPJcVkqqF3e+tuc2OLWKfZkUBH9SqURkRnnMedc9WYODOouxiAEh+A4IOI6WwzGHWDVDFEHGnvDAawZXneR+eIurMVuU1plPqg3G2WEAeRvqO5wSkGC8su0lYq94lw8KKurWitPPtr6JRmL0DNsBaxRtFA9OrwabdssGk3VhzDzh+hX5B4o56VLhOPXG6AAzcKEys9pGvEXQ3foES+MEcoZQrZEEpZUePLfebI0qjUGPLNIWwL1BHfOEkScYU46Pi1dhkyZJoigbsHpEQtNqFqa/nqP8FeZQRSJafis0wnIw/tg5mL9WaHlc+AP8cUu4Wu+Ri+tSlT2ZrewY1rG+vCTNjFsLjQ4Hb3DfFn6JR5t2G2oo7jq0k+Yo63SG5LrFOBwY9bczD41nztBqFRYZHuT1mBoMNV6XiRk7mwqXjLlqi0GkTHyeRPK8R
Content-Type: text/plain; charset="us-ascii"
Content-ID: <578FEA970865F14B857C8A40DA8A6E20@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 627b6c0e-a40c-4f6e-71ae-08d7a0294a71
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 17:26:44.1168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Op+g3/03CrlMIP0EycOteCN7QC5dQXTMHvZN4/0iynUFiquKDnh0W0hDqIa7RzTR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2672
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_10:2020-01-23,2020-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 04:59:32PM +0000, Lorenz Bauer wrote:
> Include the name of the mismatching result in human readable format
> when reporting an error. The new output looks like the following:
>=20
>   unexpected result
>    result: [1, 0, 0, 0, 0, 0]
>   expected: [0, 0, 0, 0, 0, 0]
>   mismatch on DROP_ERR_INNER_MAP (bpf_prog_linum:153)
>   check_results:FAIL:382
>=20
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../bpf/prog_tests/select_reuseport.c         | 30 ++++++++++++++++---
>  1 file changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/=
tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> index 2c37ae7dc214..09a536af139a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> +++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> @@ -316,6 +316,28 @@ static void check_data(int type, sa_family_t family,=
 const struct cmd *cmd,
>  		       expected.len, result.len, get_linum());
>  }
> =20
> +static const char *result_to_str(enum result res)
> +{
> +	switch (res) {
> +	case DROP_ERR_INNER_MAP:
> +		return "DROP_ERR_INNER_MAP";
> +	case DROP_ERR_SKB_DATA:
> +		return "DROP_ERR_SKB_DATA";
> +	case DROP_ERR_SK_SELECT_REUSEPORT:
> +		return "DROP_ERR_SK_SELECT_REUSEPORT";
> +	case DROP_MISC:
> +		return "DROP_MISC";
> +	case PASS:
> +		return "PASS";
> +	case PASS_ERR_SK_SELECT_REUSEPORT:
> +		return "PASS_ERR_SK_SELECT_REUSEPORT";
> +	case NR_RESULTS:
This should return "UNKNOWN" also.

> +		return "NR_RESULTS";
> +	default:
> +		return "UNKNOWN";
> +	}
> +}
> +
