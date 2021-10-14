Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CDF42DFC5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhJNQ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:58:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12974 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232428AbhJNQ6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:58:05 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EGnsS5022266;
        Thu, 14 Oct 2021 09:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=l0V3SyDCzslCy/UCO7iVuaVWXRwukXVOnxahbUC5MnA=;
 b=bY49YZyxzW/iilfphNLGj744WNchRmb7yLMel7NarWm6NsKhpWiYg7e5KhiUN0+5/IfE
 ygr9cqd5DLF0pwo4SOmPzNAiyyD94qTNVyAXIwjUxcO09UDisGOS8u3urgR84+h4c+eO
 GDgXQ/IZbJnwud/d8JvCMI5DqNnPl2E1+es= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bprdn01gd-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 09:55:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 09:55:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlE/EpP45HwgRLTLiOKzUQ24NLKD2Gh273DrCwIJYckDzfVeeR/XrY6homGu4b01DiI+vFZDV6AD3yQX8KloDdSwfiTYUs61ipGWz8dIFmQJ8rDa5f+YgSS83p/UDmxiKyaP/lYIZiNICfgRPoZ18xii1e3esQR99VZINoQFEwWpeGnyyHR6IfN1gfPSbscy93BYV73n8ZiE4bKrfPiQ0E+e5tB4oQS8U/ePDrBJ/t1qrJbFeaeQvfFFwWN/8tj5ZEVQUKKXliIvbNj53AcQvKEmvU6ilxvVZ8GPPvtei9VPJqWEihtYqhT4W0fNd/mZcDErFuaipxlsmqBRTSoBCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0V3SyDCzslCy/UCO7iVuaVWXRwukXVOnxahbUC5MnA=;
 b=ZwBuajWOWnp7+QhKcb9kuYvxdnjybdyr09aDxOlKayC+ugqkYA9iIkVhzmzpjEGkR/7rAsS8cJPp3NaquQJZJsWPfmb6T9xOYj8XW7wpSsAytFEFamheLKK+b4vPmXsfOg99Gf+fNAX8M7haTQO8TnShxlxXArBzDsdPbO9LQrNCH1Rqm0mlwNqSGHyIMx0MGYA8IVmqkWIxHDub24acTQFzEpZLUA/1+h72kGsZlpbZYUevJsEf8Xu8WvfdxwQVp49ifpCv6XZgBsFH8fXS+pn2zDD849OaYT2u77vZLpITRx52cbSkeqzLQRR81GDnBfY56b1s52+SgTHJtqhgTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5140.namprd15.prod.outlook.com (2603:10b6:806:234::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 16:55:54 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 16:55:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/8] libbpf: Ensure that BPF syscall fds are
 never 0, 1, or 2
Thread-Topic: [PATCH bpf-next v2 4/8] libbpf: Ensure that BPF syscall fds are
 never 0, 1, or 2
Thread-Index: AQHXwAS4LHKn7TU/q0qCfzTTWRTxUqvSuKoA
Date:   Thu, 14 Oct 2021 16:55:54 +0000
Message-ID: <01653735-42DA-4047-A956-FC8225D3BD28@fb.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
 <20211013073348.1611155-5-memxor@gmail.com>
In-Reply-To: <20211013073348.1611155-5-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1afb67f-bf19-4e04-46a6-08d98f337c90
x-ms-traffictypediagnostic: SA1PR15MB5140:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB514054755DC1B6A791446739B3B89@SA1PR15MB5140.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: srzo0IVLvmn5CaFlGpbEKB4Sff/q0LOfFjLU2Dj9LeI9IQo9cGrNPnx9vpfFyOcEr4RJAu9r2l72P1XvW/aE5B32b1BQs4nxJCpaWCTNHyWXbPoB1c7ZH3k01TMW9TMRmJ8veGpPknirvCS5k5DfLVYlC6DTv1dR502zW729KwOO48WiyQ3PdaU4ePf9Hxd5qn1XOdWkizIQ6m9hvYIzE8BimWbTwJVfDgnBicb/r1VPcbqeZb7bnYK0Uvavn57bxhYTJ8T3e6vndhxv4WAwRIFki6MRwFclVsz3wNcMYyWpfeLPeWLhFR0EUQBIO7xOfXNDnsqoqZMGbRKhWdNI1TUYhTkecS6/36/dYKRjengAxbJZwM0UPXETpmfhRJ9fHgsCSDhdP+lhpQtVUapgKKw87WTbOXLIYSRxFIScTN5fu4yS2dW0ZHrlf6NJ/yiWeR8m2Vm8GOhltxH2ky7C+6fNtAjWTjx/fkRIOH2SnaudQGTgCo8skEnDX/Mc57TNALxL3f7CQmaMlSa+yIVlOYNXEFaH0wKtU3nAsmUOIdCC15nqwj6Ki7sMyzRRhsFYvEf8X6jipoNi1gu7j+nudmIEn5v2DCF4ysEjViMS9yB8beX/6NS937RrQG1SIT2XeHW5hI79+HM6BTsCcMbsmN30hTVh547m/P8eY6S73qEnI3YUrRWbl6oLA/o3FfJlOL1N3WM+hf7XRHh9rDbumadyE4xcNDQ6fbqXb14N6o0gC9XqrlC+ioQ/oaE9mqGJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(36756003)(2906002)(6486002)(6506007)(6512007)(71200400001)(186003)(53546011)(38070700005)(508600001)(83380400001)(2616005)(91956017)(66946007)(66446008)(76116006)(66556008)(4326008)(66476007)(64756008)(8676002)(8936002)(54906003)(86362001)(33656002)(5660300002)(6916009)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?6C6mZae4riMsRx0OppMhsLYdIJB1LeMacr4nro1h8Pds/+K9Vi6WPWG5hf?=
 =?iso-8859-1?Q?UF2tvfEkSxrOwDMDp8EPTS1yA9UEyQ0QUtSV+Quo46Y+lZdyMueyO+MeXB?=
 =?iso-8859-1?Q?DWWTD3iqe6DuW9vrUKKLODTFU5FgqKBymd/iY8zzEkTCawI7SBNWcX5H1a?=
 =?iso-8859-1?Q?mKhNwQpZVPNKmuu7qW5JPFR+L4kDWqvNuexNSQm9JuvnQ7FxqveZZ9PZlg?=
 =?iso-8859-1?Q?QQ2rjh4R3UJmG1Z+CkhIz+Z31YwtPzE2AZxlQ5T+oA/Stiuqb/AYOcnEXB?=
 =?iso-8859-1?Q?xensEDETlxYyVfDXEjTA8iJWBZcJp5oieiMwOIgyO26OshQK7sVjC/ll+D?=
 =?iso-8859-1?Q?6yloT0PcyyfzAREfV4iNmecC9KmjqvvXs9SvlzZ9IkwcF4nRoxnpTlmPEO?=
 =?iso-8859-1?Q?XK+EGYW+MSqGo75jUIyhsvg3Jq5Rzu2P45evomag2CaZWaHCKHHuIKnsAN?=
 =?iso-8859-1?Q?LpaPM2pY+lN+NU7TsOG9mFDeUgB+4bdsxmZMICR6Xx1dUTg+uI55HVmyfV?=
 =?iso-8859-1?Q?t1RU+cvPL9hWhwUmq9E9aSrbMs7hX62trhR/vXI3ChjX0NgGuRc98VudiB?=
 =?iso-8859-1?Q?IKehjFzFv2ZGm+TYYnIXTNpc7TmuIe2+3Kxg0sV5sw+DJEwAJzeAj0uZFU?=
 =?iso-8859-1?Q?n/h0ZWykJCAt+Yo4qV1obD98QJWZLcWJOcrfI1/kd7jkBKeKNRsb5hUsUI?=
 =?iso-8859-1?Q?R4HXyFPbnV8MKLH8AHRjWYgPAnJ6/etK0at4AAbIMKwtgvFxAxlF2Y7iH/?=
 =?iso-8859-1?Q?kBleFWpr1nxsNQ/AQ90Cd9MLbKTPiJe/c6wwf5BJMsyVrijfkouEPhH27r?=
 =?iso-8859-1?Q?vnIAMdwGzNxqKsxdF+n9xVh+h1jlncsRrzTWjO/zerMOQ8JNZf25rN0w0/?=
 =?iso-8859-1?Q?xqOkAGMO4zaiYHv1aqU+SL7/qecNqqxrOxtm0MGAUbc4s3r8favCg9080R?=
 =?iso-8859-1?Q?wJFwzC1u6L/GYanCSQFhQW1k57hr9MHn+MSvxmQbMPg9qBYCJbvBY/9JFq?=
 =?iso-8859-1?Q?zw5bjYh/F7k3Cg9gGMc3AYlClGPtflKrRmkmlJrq05TXAWaEQRv+kleuFg?=
 =?iso-8859-1?Q?qw5leiGUyoNVwJpSprZpM192yghDaaLS9VH66TD4XeYAzqkZQLH+ZIdI0Q?=
 =?iso-8859-1?Q?2MLb5DzW1ccILf7ixbPAWqEAXbLfYa/KI4G313t7NdG31b4gddV4nYQtAG?=
 =?iso-8859-1?Q?JEyHatWmOhw/5txqSePJ6ShHyuBA7shp7zIjh1VwjPO6mUpECvs9SjWA6j?=
 =?iso-8859-1?Q?IpakMmx73OmXmXUaeHBLLFi6oOxpjFJJRML/LJD1IZxaZ2ISxHVzlwWzH7?=
 =?iso-8859-1?Q?YQ8WV8716i9oWKf5IjMdWyqny7OR2d+Wr4zLy7YOSOwNnA1xx9gGxFCRbV?=
 =?iso-8859-1?Q?oTQZvlqQ76zy8Q1Oc4qoddjFFlJTdBB5llV/Af1tn58TZf3UYJBXg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FABEE445C7956F429A3751167C3F70BF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1afb67f-bf19-4e04-46a6-08d98f337c90
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 16:55:54.4469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5piV2/8KEthR3bzSCZcq3Ss7Pt9nK3ZfK5531kQWEccuwyMpiTD6ckL+pbVbyhcGIbyPAy1YYV1tXYd69unZAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5140
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: lsXuFCkTt9Rzf0FYN8Re5EbvrdYbWA25
X-Proofpoint-ORIG-GUID: lsXuFCkTt9Rzf0FYN8Re5EbvrdYbWA25
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=927 bulkscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110140096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 13, 2021, at 12:33 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> =
wrote:
>=20
> Add a simple wrapper for passing an fd and getting a new one >=3D 3 if it
> is one of 0, 1, or 2. There are two primary reasons to make this change:
> First, libbpf relies on the assumption a certain BPF fd is never 0 (e.g.
> most recently noticed in [0]). Second, Alexei pointed out in [1] that
> some environments reset stdin, stdout, and stderr if they notice an
> invalid fd at these numbers. To protect against both these cases, switch
> all internal BPF syscall wrappers in libbpf to always return an fd >=3D 3=
.
> We only need to modify the syscall wrappers and not other code that
> assumes a valid fd by doing >=3D 0, to avoid pointless churn, and because
> it is still a valid assumption. The cost paid is two additional syscalls
> if fd is in range [0, 2].

Acked-by: Song Liu <songliubraving@fb.com>

With on nitpick below.=20

[...]

> +static inline int skel_reserve_bad_fds(struct bpf_load_and_run_opts *opt=
s, int *fds)
> +{
> +	int fd, err, i;
> +
> +	for (i =3D 0; i < 3; i++) {
> +		fd =3D open("/dev/null", O_RDONLY | O_CLOEXEC);
> +		if (fd < 0) {
> +			opts->errstr =3D "failed to reserve fd 0, 1, and 2";
> +			err =3D -errno;
> +			return err;
> +		}
> +		if (fd >=3D 3)
> +			close(fd);

nit: Maybe likely(fd >=3D 3) and break here?=20

> +		else
> +			fds[i] =3D fd;
> +	}
> +	return 0;
> +}
> +
> static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
> {
> -	int map_fd =3D -1, prog_fd =3D -1, key =3D 0, err;
> +	int map_fd =3D -1, prog_fd =3D -1, key =3D 0, err, i;
> +	int res_fds[3] =3D { -1, -1, -1 };
> 	union bpf_attr attr;
>=20
> +	/* ensures that we don't open fd 0, 1, or 2 from here on out */
> +	err =3D skel_reserve_bad_fds(opts, res_fds);
> +	if (err < 0) {
> +		errno =3D -err;
> +		goto out;
> +	}
> +
> 	map_fd =3D bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
> 				     opts->data_sz, 1, 0);
> 	if (map_fd < 0) {
> @@ -115,6 +143,10 @@ static inline int bpf_load_and_run(struct bpf_load_a=
nd_run_opts *opts)
> 	}
> 	err =3D 0;
> out:
> +	for (i =3D 0; i < 3; i++) {
> +		if (res_fds[i] >=3D 0)
> +			close(res_fds[i]);
> +	}
> 	if (map_fd >=3D 0)
> 		close(map_fd);
> 	if (prog_fd >=3D 0)
> --=20
> 2.33.0
>=20

