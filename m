Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39802D44FD
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfJKQHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:07:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50700 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfJKQHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:07:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BG3K8K030690;
        Fri, 11 Oct 2019 09:06:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Wr+OFFEcIjqXQxPujqrK5chcVTDj+ubNJxuHdxXQk14=;
 b=gA6+4JLUFaL5+M/OH4cxh3E8K6m4qohOznKjg6bpxVrJ2crGhxYBNIJv07A/9+wBtgzF
 Hm8B1Wp+6c2HVUmuT+Qc4JrBWFhnw7Wi3TkGxybBdow0E8ksaEBycG6bor7CP1z2iFbx
 lDqwp0bF+Sq0oaQ9R0Daj8gAyf23sdn0tVA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjtsugqga-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Oct 2019 09:06:46 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Oct 2019 09:06:45 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 09:06:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2/i+EV6GDag2Ys6DMfmeaTXc32TsTS03p/nQGnGct7QcugDf89R1jfDGmBx00QjCi/8fUpZ6qAlYAPsaKfp4Inutb46/NGXg7kPxQwa7xD24QyXs5GH07pw0vXok0yBDsevy20/N077n/l+OGAvLhSV6Mehvg8grDhN7wosoGlREJ6H+ohY3W1JRleeU1qU9x47xqRTYKdV+fLUBampAh8yZMaaxDwnaB88Wm1o5TCVJvveuDyYgKXCojFCHjNoYondrUpBKc5JyHOa7bRaEBu4XZbWZr9u1mcLINcFRtdlN5sTL3chqEoz+2sv+fAAI872jwo7zLZRoQJlxLK9SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wr+OFFEcIjqXQxPujqrK5chcVTDj+ubNJxuHdxXQk14=;
 b=AyLs1ihuJ7szy55kBKL2tCHk9LAhM7tm8FosaXjGvaUsGgtIBtb+MVXvG0mwMf3h9fOmzrAYsXy/9UoZV0nRupBKp0+prUh7NxRufN7TGv89saWM45mobgYKociVNhm6HrOo0zzdbQdGNUdX27+zttnyoAKd277UOid2RXeXj7xlCiAjSulDUG8sFIYYZZtG71MsS2uLuzhXVXoFdkPxgMht1/jh7Cw13jx/7/0aPRLLCcEsQFHiGr92WMtoJ9jrPFAZH5+vKio1Gp6+350r2Uv75v1b29l9pCbfu/TqalkJ/DTUIHlATXRzlJv93gy4EC3iVQnvi/UE2hySVQYGig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wr+OFFEcIjqXQxPujqrK5chcVTDj+ubNJxuHdxXQk14=;
 b=DMVvF78RgEEbjz3k/lQpGINAIvUNQ//NFz430HQ1RHwy4rJdyxLMnDWHHAU7wmm/w01wOiq6eKLZiKtv2BtcOd9T2yzt1XRXIt2jIAcmoYWN0VTZL57ZSuaT5HVXHRnjllbkCXkWeGdWw4Mdwim0/ad7wy5zDM3kzbdRTYhJpsE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3086.namprd15.prod.outlook.com (20.178.252.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Fri, 11 Oct 2019 16:06:44 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 16:06:43 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: handle invalid typedef emitted by old
 GCC
Thread-Topic: [PATCH bpf-next] libbpf: handle invalid typedef emitted by old
 GCC
Thread-Index: AQHVf+QVzxwBEedph0qBKgb7eCyB7KdVm/MA
Date:   Fri, 11 Oct 2019 16:06:43 +0000
Message-ID: <20191011160640.5uqpeilcs3qhlk2g@kafai-mbp.dhcp.thefacebook.com>
References: <20191011032901.452042-1-andriin@fb.com>
In-Reply-To: <20191011032901.452042-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0117.namprd04.prod.outlook.com
 (2603:10b6:104:7::19) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e08f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0b80141-1f1c-4eea-7c57-08d74e650269
x-ms-traffictypediagnostic: MN2PR15MB3086:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3086CFCB43D6BA3C7B0C39BAD5970@MN2PR15MB3086.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(396003)(136003)(39860400002)(189003)(199004)(558084003)(316002)(66946007)(66446008)(64756008)(66556008)(66476007)(6246003)(54906003)(14454004)(6862004)(6436002)(25786009)(6512007)(9686003)(6486002)(478600001)(7736002)(4326008)(71190400001)(2906002)(305945005)(6506007)(386003)(6116002)(71200400001)(11346002)(6636002)(186003)(476003)(486006)(256004)(229853002)(446003)(99286004)(81166006)(8676002)(76176011)(81156014)(8936002)(86362001)(1076003)(52116002)(102836004)(46003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3086;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b2GHgEObz2+eBV9yJfIz5qma7+YUyiD3RLGAYxk+is3tqfsTqvNhc9XurkiNxQJ+ZrE3Pl0cYwDXNWgiv5mC+4qs24feOEPVlwLpglpzrY5hgq1/Jup+Og7pm3IhWIPv5q17ia3x/ICm1GGG//ULs6IMWepHoh4f1xerHdtLcVQTznhMa54XKvVeTzT/dNfmN3hcIbFXOrHl328S99Idxg8ZOApPGbxN5XHx1CGWR8W1NvT4Y7BXIvST3iBSlMemGPcQ1LavML+d7zTSZEB9G87xfKAR5g3VfzZBlkvu9UYmfZ0l6dG4CcovBtIkcUlZ4PrW6iYtGaPxvuyyCjbrItiT1Z3dIrl0fijPmyu8ATOgHVEJLOvteABQwQc36mbxx8M4E5iG5AxwJ3Yveb1zG2AeOGT/DUiNjgC8gsCi7D8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <082A324EEE52EB49B718B78EB9ADF49E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b80141-1f1c-4eea-7c57-08d74e650269
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 16:06:43.7264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbvfvJlEi4xij32V42mDlKa7j4Dv6XFmKHTvVqx2LyALU06Z59NBZZ0ty1rqj25S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3086
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_09:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=525 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:29:01PM -0700, Andrii Nakryiko wrote:
> Old GCC versions are producing invalid typedef for __gnuc_va_list
> pointing to void. Special-case this and emit valid:
>=20
> typedef __builtin_va_list __gnuc_va_list;
Acked-by: Martin KaFai Lau <kafai@fb.com>
