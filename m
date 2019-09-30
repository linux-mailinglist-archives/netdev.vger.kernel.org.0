Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32DEC296B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfI3WWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:22:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50946 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726590AbfI3WWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:22:55 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UMJRIP015685;
        Mon, 30 Sep 2019 15:22:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kFSpx+Adg2oeFoQZ0p+W3B/dRNVQknriZ0JlxyXujcg=;
 b=ldPhxb0UIGcBSAMlIedAGS290nAMcJ73WA0iHUUC5D5v7U1upOJdN2mD5jLa3NNi26XO
 RJOHq503k+hh2xte+l3uL54DcvtGRBK7Zrqrn8ZD/wXR1/78WoPhr7OBdcnzAmjOLriu
 V4L9Ms4EkVnJ/+2mTpGD3q7LbXamJYrID3c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vbq6g8war-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Sep 2019 15:22:40 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 15:22:08 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 15:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxWGe//JZM3sfgXMgGSGafgkQcpP9axZo8czm5DObm7IyHq9clnH+zRM7HhGOrjYuinJEABo31PvhvqFEsf7oHQCgezT8aWVnQLc3vVomWdHLteqEF6bZfRIE0eE3jOJjkdUmb0XuGnok7WnUKf5sGYizufdOudHOi5tMEUULyGgDUojLYq3nhNdDgyuQ0rNdRn7BfHVi6rUht6B30YuVxwo1KvMf8nqWAJYkm98El2MCrafNwZ5bDmASgaBWMNlM0DPcG+4ESW0xsL4Zj/lvczGCJpvJ8EEtSJpj2MqXXZVgYzIKRrzOzJ+NzS2r56SW4q8Q5Ef2j76XsI916vr1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFSpx+Adg2oeFoQZ0p+W3B/dRNVQknriZ0JlxyXujcg=;
 b=VunuKRxkDbUzk6iitfaO7MbcJN0WOY7YKJKAGEygXRzSUnWvC4tJW3ieTVz36wBHvPIVVDs8wzvhouKayvfWgQxTJmqHxtKYC0pwydQRAxHuuw+si/jYtp7ak6IyIVGBModal2BoAyMLz40SRYyZfo5h41TrD3VCqsaD67GwM1HaCzKTKONe9PvSRulz9XJeFxZd0iOBcni97fC8dkLH1ok/Jaegn/A+m58FRWOYCcG/Al1nOYDeYnBbW3yf8eZrgAXeoj14LYCsVE+6p3tQGjmxfBceOpXA6Wnp9hYP6ZQyi6umMLglmU1OePFNpmftDg3fQ1d0shw5QKmVITGDeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFSpx+Adg2oeFoQZ0p+W3B/dRNVQknriZ0JlxyXujcg=;
 b=lQz6KQfrzjWgk6Sf8hfsm6VwLC+/p2vk3rwUs1xte2QOAc43Lj/uxCYPXV7670tbZfEpUXBYRkfbXz1m9sOANa5Mo0Ln/3OhYkkQ8xaaPpOWOpS3J6IKXanzlwBqS6KjwJQhcVUKCz1d5kI9vF4AJtoZ3deVAkVr7KF/3II6yYk=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1374.namprd15.prod.outlook.com (10.173.234.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 22:22:05 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 22:22:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: dump current version to v0.0.6
Thread-Topic: [PATCH bpf-next] libbpf: dump current version to v0.0.6
Thread-Index: AQHVd9y3RAZVbQGXX0Cc+y5UvkrrhqdEyz8A
Date:   Mon, 30 Sep 2019 22:22:05 +0000
Message-ID: <E24A08DB-FAF5-4FB9-BB96-4B76E8CCF807@fb.com>
References: <20190930221604.491942-1-andriin@fb.com>
In-Reply-To: <20190930221604.491942-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:c67b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18835588-9aec-400b-1d10-08d745f4a026
x-ms-traffictypediagnostic: MWHPR15MB1374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1374521A7F98F9F59EA9189EB3820@MWHPR15MB1374.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(346002)(376002)(396003)(199004)(189003)(6436002)(6512007)(478600001)(6862004)(4326008)(36756003)(6246003)(25786009)(7736002)(2906002)(33656002)(305945005)(14454004)(50226002)(6636002)(8676002)(81156014)(81166006)(8936002)(6116002)(316002)(54906003)(446003)(476003)(2616005)(486006)(11346002)(76176011)(5660300002)(186003)(37006003)(256004)(46003)(71190400001)(71200400001)(76116006)(64756008)(66556008)(229853002)(66476007)(6486002)(102836004)(53546011)(6506007)(4744005)(66946007)(66446008)(86362001)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1374;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d2cbC4xlL3Y3V2M+snXHCcuduPAqh2Hh1cPQpbOk/grA6lHqRRaE0GLr3upKJI8r3MA5hcZfQOeqWc0g3Z9X2izvcbbbvFUhQNjTXnYOwEVQCUVa6fco4xQUjJkdtKTnaEOFPsRML/P9xYMHk/rY5nA6V7uE+KjB2QRiyJC8yZLoCbiuOjsTytJygL+iYPdOHjHi2MwAk13GQtkHIB+Sazlup04k6omJI1D80bm0jiXMajsETw8LsrLrYtaSo/9vwuo4z6X/0Kr41WIOxB9fQ0LK2GFEUgA26c3LOicSQnoqqaGdHtoT1fTB+0Z6mZiJ8UUB21eiUqyJp4nN7FVq3bSnXRgRe2lvBcp/s+SRHpUksUJYL59mTZy0egcfAIZqAJf5zPjOT1P8xFFT7qnx6JwjEKk1bEK0nMxYoRdjP5Q=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B9DD59736F8934AA81B9021BA604F58@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 18835588-9aec-400b-1d10-08d745f4a026
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 22:22:05.4834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ldCJXcXAtC/IcHa/A2XTutliaGNByHyeT8qnnOCn2oREhV8sH+SBTutpWZoZRH3cC319CiPqjLN3Vksfr5mJ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1374
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_12:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 mlxlogscore=960
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 3:16 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> New release cycle started, let's bump to v0.0.6 proactively.

nit: Typo "dump" in subject.=20

Acked-by: Song Liu <songliubraving@fb.com>

>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/libbpf.map | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index d04c7cb623ed..8d10ca03d78d 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -190,3 +190,6 @@ LIBBPF_0.0.5 {
> 	global:
> 		bpf_btf_get_next_id;
> } LIBBPF_0.0.4;
> +
> +LIBBPF_0.0.6 {
> +} LIBBPF_0.0.5;
> --=20
> 2.17.1
>=20

