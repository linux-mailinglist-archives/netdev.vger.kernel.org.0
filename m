Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1237DF587C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfKHUYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:24:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6804 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727148AbfKHUYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:24:38 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8IsKjR003938;
        Fri, 8 Nov 2019 10:58:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i1ZMfPXB3rnnMpX/JK1ZDfbqjvciksSg9zSqfdQvJNY=;
 b=Afqn2f9pCJpqgKnNuyVW3lhGyJc6UGQ332ETZBgzD4NWNrdks5w7hc7RGe935fd6PfT3
 v4yIpUSruE05+FRhgel+Sc2dpk65oe5kHHb3Qy6DtNW90JN3PNsizB5woyaVlxhyOZ+0
 2m1xcxc8ff/n1fsPlaAk20ztsqfOEYD8ZJ0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w59shhkrq-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 10:58:04 -0800
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 10:57:42 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 10:57:42 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 10:57:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbbNQwcLWH5nf3C4S2+pC21mUmIdrHahNEpk2CKdHHdh3rDcWeucVUZ5OkaU4xt6GkG1IRDU659Px5GK4DlVeQQWjqcFx1qBSFhd1RYi+TsZnpR/eytGGOLcFwp+2R37S9VUXnXzjC77Sdjdb5VX5t8JDuxOQiFBSS6ZxaUc9aCei4RIP9I1BnpbK38b0DcMVnVBhnISP3hqn40hMlq8fY/bGtWihLsKRn9sxKKd8sKRTRKowgyMa0oi9UX8/PAvRVsrXWHa91ywZJdfEkB9DcNFiqg7mkz0LoZALxZL4nw7SupOZ1jcx6/AM/dLFyUFhyWVMPEqQe04iiAmVqJRQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1ZMfPXB3rnnMpX/JK1ZDfbqjvciksSg9zSqfdQvJNY=;
 b=VT65GH2IGHEpuzrw2QeR8KS2RWyZ+JPc7cmPaR7t/xu2UtqfVCvb/tMGYNt82fBbC4rGWNuijjV1026r0RdeXeSnP0OTIE97N/mxgzN+asvhEa5PpxuKme4Hjj/zF+/Y1IIJ0etTsbjMdf6XHwnhdTFfXWa5UPXUaMnnrOWvOxXaDVmfvd2JzEH7fv9sXXgJJJzr8a5NElUOMyg09ma0pMsE49pTN3JPzRigZJE80CbOKfTXvfnGseKCDUsIxMcP2pD01m/IM6j20n3QnqhSSeuEScY9EFixdErC87KyHs6l9MxkRTDv4SwrEalj+bPUI8aDfB3er7uJp/G8ChkdLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1ZMfPXB3rnnMpX/JK1ZDfbqjvciksSg9zSqfdQvJNY=;
 b=JaHk6tIGTrsHTLZPYTTECXTTxFqGjAzodMBCSapTHxOoe1KfL2aNjBf1nQGKyiaMP1DjJlxc2M/5sJt7pxZwT++bd13qlZF990FkRvpZRUWBh92sZSqCxL3hgxGq1Mfml7rF96z3o15dr76EpL/kvipVzYZn+s/zJ9UwryrkBpM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1119.namprd15.prod.outlook.com (10.175.8.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 18:57:41 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:57:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Topic: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Index: AQHVlf+YwwRq5FosuE2y6hpnfHhzDqeBoMoA
Date:   Fri, 8 Nov 2019 18:57:41 +0000
Message-ID: <88611E3B-DD55-4D33-AA15-73DE58F8D44D@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-17-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-17-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77e5b1d0-5697-43bb-c404-08d7647d8816
x-ms-traffictypediagnostic: MWHPR15MB1119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1119C0D93E6764F60F7CA6C8B37B0@MWHPR15MB1119.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(136003)(346002)(366004)(199004)(189003)(33656002)(8936002)(4326008)(66446008)(8676002)(305945005)(5660300002)(36756003)(6116002)(86362001)(71200400001)(76116006)(54906003)(229853002)(46003)(66556008)(64756008)(316002)(66476007)(66946007)(6512007)(50226002)(5024004)(446003)(486006)(81156014)(71190400001)(6246003)(14454004)(81166006)(99286004)(11346002)(2616005)(476003)(186003)(6436002)(6506007)(25786009)(102836004)(478600001)(256004)(53546011)(6486002)(2906002)(6916009)(7736002)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1119;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hku1Fq7u76MieiKMvy7uc0CfVtwuE/E5GvHA6PW5a5G0B3Rtc35IybLvClcyhnAtS4DQ6wpa7On0rS7o7tTyHXRXelLICcTbbFp78PeqV1af/FhEuCubKy9a6/mXskbvJ9OQDOQjP30BXeKtUEe8HbvsGC7qn7re57dyF1R4goYEFuQRrhu0faA+UtLiDmX5FsC2Ir0oSLVTXeVpLqz8ukiHgKXCFsvQbYiGlK0shF0BridsnMb7GxPGEUVug8xUn+Hitw6YwZXYdoxQqDl0ixAO0z0rQaGn2Tk8rfPijzIs8dWE4d/QBC+6kSkYG2GdUlnmhfY31M3nhT6BMEk/vLPQoZjjc3bEuzmvnowkypr60pSH6X8/UUmQFd4sDUDdj7XP1QeRGpTno9UvHLGZXTvHF2LrZJVzUggBsZ8eZ9B0NOkOPGDY0/NNaQ8UvLdU
Content-Type: text/plain; charset="us-ascii"
Content-ID: <310EED5D7FE37C4EA448E5E54451A67D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e5b1d0-5697-43bb-c404-08d7647d8816
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:57:41.1588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HBhqITCBuiGgb/mXR2tjBYfq7RtDYEqAj/2gKs1ATEbv15NubCKOpMATmNjs7dh0rjQ8B31i7mlC3yyTPVkE8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 mlxlogscore=960 spamscore=0
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Extend libbpf api to pass attach_prog_fd into bpf_object__open.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

[...]

> +static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_f=
d)
> +{
> +	struct bpf_prog_info_linear *info_linear;
> +	struct bpf_prog_info *info;
> +	struct btf *btf =3D NULL;
> +	int err =3D -EINVAL;
> +
> +	info_linear =3D bpf_program__get_prog_info_linear(attach_prog_fd, 0);
> +	if (IS_ERR_OR_NULL(info_linear)) {
> +		pr_warn("failed get_prog_info_linear for FD %d\n",
> +			attach_prog_fd);
> +		return -EINVAL;
> +	}
> +	info =3D &info_linear->info;
> +	if (!info->btf_id) {
> +		pr_warn("The target program doesn't have BTF\n");
> +		goto out;
> +	}
> +	if (btf__get_from_id(info->btf_id, &btf)) {
> +		pr_warn("Failed to get BTF of the program\n");
> +		goto out;
> +	}
> +	err =3D btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
> +	btf__free(btf);
> +	if (err <=3D 0) {
> +		pr_warn("%s is not found in prog's BTF\n", name);
> +		goto out;
		^^^ This goto doesn't really do much.=20
> +	}
> +out:
> +	free(info_linear);
> +	return err;
> +}

Otherwise

Acked-by: Song Liu <songliubraving@fb.com>

