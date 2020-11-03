Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAAE2A380B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKCAvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:51:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbgKCAvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:51:54 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A30iBq2028292;
        Mon, 2 Nov 2020 16:51:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=31EkLIJGs/nGyWKZptMR1D0EuOQwLGKwLqE3pXm8Ymw=;
 b=FYjgwMd2VU49lnx2gZhjm5g/fwxq8yRp9BmMFsUbLufL4s1VONXWo6RfucsjWSdApCiX
 UbVuEoqu0SGH7Z9IoKnYQ2ObbfbfJF04hw/fTBfmxTOEZnpogyOnVfR/uWSYUsBSjvL9
 w5QkCN2Rryyq/bxZNGy7oS1jKn7Xx7BrEFI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr6p0a9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 16:51:41 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 16:51:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOFYox/7CeRpKmU3bui7XSEfG8KJeUx35itikkZaGc3kG8rZ+fy9xRfojdHcchSV6PKnsiRcdLtvfIIXN+sJeoc92eXuvJRUBFqLpvDRkXUquLvpFc6AeMmoJLfAnyw9Kny1YmWCJhlWZVuuPFXn2ssYHhukj85nPvqhVBZvXUEaOgmsfzJGcpPy970wifT9C2Z+LqeK8OMfpBFVQMj7TmawSvGBMeoUju/Odv2YBVZ5ruJEgYujlQKVarIWRC8uBnof70n/0IDmmLN7HHJjCKpsBU0rTIIHP86+KXYnqrTHZJ01N4OYwHofK4t+uT6/DJ0aREfoOwQ+oS1cBEFMZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31EkLIJGs/nGyWKZptMR1D0EuOQwLGKwLqE3pXm8Ymw=;
 b=LmKDwOvHgFtQJxvfAoamw2udcG5FGZCruUxAvrXbbZ83m7MxbYSEbLf/QSmUAy1LfGczbThR02BZsFlap54AyqDA2/HdM7HMlYGeeq6ZIKIJpBguPs/lwxUGJWxsrXaVqsCwyr3Mi7yuwoVj734m0zLjnAX5KKtXaqvxSj/fy/AlrmMKb/t6VL+RcVcqb0Eqn0PF0WN2JExR2h0FAqJ1/vJdftYH9y9Ef2p1eD6MdeywPb8jos5+mOv2r2SVCLPq9u6WE0tl4TO0P7vNXOJASWsV0RJSf5U13RF0PYXMcTez8kc81djEGC9yYojTqQKLl9IMTxSaNHgdsPS45by5iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31EkLIJGs/nGyWKZptMR1D0EuOQwLGKwLqE3pXm8Ymw=;
 b=SzezOZvr5oFPPCMsZa9OLtUduVUmmc4lwv8RQN5/8t4vbqsxRgX/w/bUiEfCiLsMMQtD1iEZGGBpLJtHTlQo0uPN+fyHT4e9xeUR1vnnlrdtp0aYo2LNUNBvGqUCzVbBuVUB2VWck6tj60z9iRnhJuku4hs/gyohASECwEeQnqw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2567.namprd15.prod.outlook.com (2603:10b6:a03:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 00:51:36 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 00:51:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 07/11] libbpf: fix BTF data layout checks and
 allow empty BTF
Thread-Topic: [PATCH bpf-next 07/11] libbpf: fix BTF data layout checks and
 allow empty BTF
Thread-Index: AQHWrY7NHg7l4OivSECIeWatLilZlqm1m9eA
Date:   Tue, 3 Nov 2020 00:51:36 +0000
Message-ID: <DC33E827-1A58-4AFF-A91B-138FBC8728A6@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-8-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-8-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 914af852-190f-4ff9-b07e-08d87f929e1f
x-ms-traffictypediagnostic: BYAPR15MB2567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25675A02940B4444CB022308B3110@BYAPR15MB2567.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EeuYwEc+Db1hGTD04JJdmzKsFlkvRSv36rLbSG5jAyyMxasIpsEHdVid3KAevP5m0AXx34BpQdeJTB6bxnUJXUe1Au9RTXZ3/XtDEj8a/msEz3zeVcjYh0kW3V5+NA4bVzx+ImgpD6KfB7MmgTxKl5qhXRfQcV7ekq1FesMJwMCGT+DDZrbfoFcNUQuHum3klL1Jn54kUplNaLMdA5mcdCUYuUmxwy1aFI0rH5YCk2VB1VRu78Cy8njL5cgkVZDb6xCb+iBdSlf64hA8Dof0YAvxsHwRrrEy8XChz30OVCspDDkqVMsttHdFQt9N71RZSXwbqZ5WPBlaGznj34ZH5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(54906003)(316002)(8676002)(4326008)(36756003)(6916009)(186003)(86362001)(2906002)(6512007)(6486002)(478600001)(6506007)(8936002)(33656002)(2616005)(66946007)(53546011)(76116006)(91956017)(71200400001)(5660300002)(83380400001)(64756008)(66446008)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Uf1nTTdH4FH40O62hIhcdMWky3qJpZyR5kaHgvLlNbVUyiFj8MTuTuRxLwB0LHF3EoownXdUexL8lhPKXHNrikY3B/xIow1D0wYUEz+o6oQMwHLEFswL26rOdRR/jCbG+Vo1YeoGbJ3d9wsslIcVTLBuwC1zIn3GiCSB5MkqYpiNmMbvFf6Tb/iO5Cj+Uju+kj4ET8MJMRbZRl3Alz2s8cyS/BqYMCFcaNhEkyHG3ThC4IvpBVefwRoO4/aCDUMMvOOZA0Z2SgVg59JuzFwpIKchZpkRy60Xl/vHlnLWCCT/0xoqrEB1ZFUpKXymjreagVTMYxBBhDTv5IRqwqer8OK6HZIG5fAEjC8W6k9P+aawDspEYopKQ4J96hlTQD0y3rZANAa2oTTAlQNKgNU0mychCeuQdlZaj1nsSPcv3svwca07JqX4ys4zLDiuJ5xhzMorICAsnFa1NEX77DL1VYvj87Igyr4JhMLWVVpnPjwN/Ow3WOLKpCIu3DVvq58lktrsVLHDKaHF4tIfR2+8EOGFzgZyIucmmtc+bBu/A+Sboy3H3F8ikqFEWF75SBDU7Kd/PgsOTErSH0MZZ8BkhmyqPnK6oXyb9WE1wIJXf8tSmxtCapTj/wms2rLsvzkZs6iF18+KwJAdslVjopF3X9Bn3z7qgRBPbvpDtgLfvCPOZrlcT3I9v3K/PaReN9KV
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F4FCF1427A4C984A847D5204EF858082@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914af852-190f-4ff9-b07e-08d87f929e1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 00:51:36.6415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7Pg8uw6orCNYeMYQVKmBMMWUXarU0MtDH0HkbGIurTf0hhREJwCH7jGXnrd0Ev7yDc0Dyu27unS+HD3qinHzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Make data section layout checks stricter, disallowing overlap of types an=
d
> strings data.
>=20
> Additionally, allow BTFs with no type data. There is nothing inherently w=
rong
> with having BTF with no types (put potentially with some strings). This c=
ould
> be a situation with kernel module BTFs, if module doesn't introduce any n=
ew
> type information.
>=20
> Also fix invalid offset alignment check for btf->hdr->type_off.
>=20
> Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
> tools/lib/bpf/btf.c | 16 ++++++----------
> 1 file changed, 6 insertions(+), 10 deletions(-)
>=20
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 20c64a8441a8..9b0ef71a03d0 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -245,22 +245,18 @@ static int btf_parse_hdr(struct btf *btf)
> 		return -EINVAL;
> 	}
>=20
> -	if (meta_left < hdr->type_off) {
> -		pr_debug("Invalid BTF type section offset:%u\n", hdr->type_off);
> +	if (meta_left < hdr->str_off + hdr->str_len) {
> +		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
> 		return -EINVAL;
> 	}

Can we make this one as=20
	if (meta_left !=3D hdr->str_off + hdr->str_len) {

>=20
> -	if (meta_left < hdr->str_off) {
> -		pr_debug("Invalid BTF string section offset:%u\n", hdr->str_off);
> +	if (hdr->type_off + hdr->type_len > hdr->str_off) {
> +		pr_debug("Invalid BTF data sections layout: type data at %u + %u, stri=
ngs data at %u + %u\n",
> +			 hdr->type_off, hdr->type_len, hdr->str_off, hdr->str_len);
> 		return -EINVAL;
> 	}

And this one=20
	if (hdr->type_off + hdr->type_len !=3D hdr->str_off) {

?

[...]=
