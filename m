Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0631FD132
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 23:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfKNWz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 17:55:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17080 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfKNWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 17:55:56 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEMrDGE004516;
        Thu, 14 Nov 2019 14:55:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J42is4jtvayQyerE9SFIzEB9I5cakeuV4r82SdRIqY0=;
 b=NCar1fBandWEYl5Aa9IRjt+hGZWkcC2Aawn3I8Lh7K61arX6pWEHyM5QYrxAkTo+rc3P
 Z1SzS4laLS/LV37oZJ/7DC1u8BiAM884iEhMnOEwERvVF0ef5Yi3ldi7qRx4z5PihxBV
 u+02i5PMQWVx9CzPOIdA0W54MqNawF3vvi8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8tnf8gbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Nov 2019 14:55:40 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 14:55:39 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 14:55:39 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Nov 2019 14:55:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHbc1EgUdKHLDjt8vNHOlRdftNzpkTavIJDSMVb1tVQHFzzIPY9qwKbAjYzJZGnfwOXZNbIi1gAPRbF0l2G2phylZgjyefAkfZfvv/61nlMdO7NiTDUdJypCPSjI9rT0iEdUZBKW42eTJ3eYlGp3UodXTmbwFH/oaym7glkcLNQFpcEPyitguGgQlOgQsmH7Fk8SDmr81dSKeg1eAYHDdzEKNeLWQ4W3ajThKC6tvdM4XO1ct/ldnUKcSSQFklyv/+mK4UMXxt0jJwX2y0igCoQHa70POK4RqhIf2Nqbx+bk7cndNZjLfQVvxrPkl7exjO3hCCsfOtOPneLRvJl+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J42is4jtvayQyerE9SFIzEB9I5cakeuV4r82SdRIqY0=;
 b=oEQ1t0QSSmGcaV7D9nyQExHRC0iR9pNPoe3gfd5ff4y547fNY8upcnFwPO9jsgVtbMcfVbCrj1kMPQzPjVT6pa8uYiw/KV65QtSJR3J7nPBFDuChy6OPGwv1rjcLuqAKOE8irE6ZrSGJ38NCwtJF2pmbXQoZ1GnOH5AruZ2hMT7QoUQH203pw0XTSni2OfCkwTd9+DLKj8XFeI0qmhTtCTY9Vber8eMmQ3qwk+BOlR6iS7BJjVFCG5KwBhgz8sILt7FdeMCKZSK9Y8mDbzRXIYSVS+IKLq+qYx+u0oUmXOYAFYnvGWxWU+M9xUwLFwfw9Ofa+WHlbPhwTnN8E0FCbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J42is4jtvayQyerE9SFIzEB9I5cakeuV4r82SdRIqY0=;
 b=apLvhwEckPF6txyIxOA/31yYK3zrdldGpeJVIOKA2IggnZ18xnzh/EJdbb4P+ooI+5ItDICA5h/xuqo81AA6EdtfnLTE8FAyoKfaHk+dmC6FrXMCqKlv+cKwNRenHmzN3qlbEoZnIoVM3sbdeEaVCaU0mZWjzuueLZtoUTeg1y4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1310.namprd15.prod.outlook.com (10.175.2.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 14 Nov 2019 22:55:38 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9%4]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 22:55:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Thread-Topic: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Thread-Index: AQHVmx12SNoDMBP720G92P3g3yLwPaeLRweA
Date:   Thu, 14 Nov 2019 22:55:37 +0000
Message-ID: <7092A2D7-BE2A-431F-B6A4-55BA963C36BF@fb.com>
References: <20191114185720.1641606-1-ast@kernel.org>
 <20191114185720.1641606-16-ast@kernel.org>
In-Reply-To: <20191114185720.1641606-16-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:e9ac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b98a227d-c6e6-416c-3739-08d76955c431
x-ms-traffictypediagnostic: MWHPR15MB1310:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB13105039DB860BD8A47C29BEB3710@MWHPR15MB1310.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(396003)(136003)(346002)(189003)(199004)(6116002)(66946007)(66476007)(66556008)(64756008)(66446008)(476003)(86362001)(486006)(8676002)(2906002)(2616005)(25786009)(50226002)(6246003)(6486002)(229853002)(6916009)(76116006)(8936002)(81166006)(81156014)(6512007)(6436002)(186003)(5660300002)(102836004)(11346002)(446003)(53546011)(6506007)(14454004)(305945005)(46003)(7736002)(4326008)(76176011)(478600001)(14444005)(36756003)(33656002)(316002)(71200400001)(71190400001)(99286004)(256004)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1310;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fEoAMjTiRrfdEyoyiKbAhKEPbgR+AbUh+HmHzpdVxaf4hbJkic7ovY/QBlCEH/nsgkKTDfIQ6nbtW4r3UuI+PeHgpqBkO48dxCFsTlk++KeG3NYae23q70D/Ua2iRm61Ghc4HaPyk3DnO3VDuh3yhOEhZGxo0/aFsCpbWKsZlWAM9iIlRbC+itiAA+0nkVQiXk3Srw4BTCneLxce5I9dtCbRUP4BxtsFXhsHV2YNrRl4WVZ1xTb+pxOcf6BDehvzCe298acdyLJxonEkQRcK1yd1rt9OoL76aQXZ1VQAdWaq7/xgVQRfdj5vph1if+ncQ9gxjKsifZsdDvCRZ+2m7oRvm3vXc2/8DMcaVYQfveDoOSkKF8jT6/96Af5ld510ClVEKMdPYi+Fh35tw6y5tbrREWDajo+pejH/UGUkMJtncX8CZ3EEqOhLSSkK9P+/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8063377CAF41D548AEB27963F3033E28@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b98a227d-c6e6-416c-3739-08d76955c431
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 22:55:37.9011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BQZvuqw7v/FgL+/vPLuhV9SdoljM341Oi/31P1+wXGg+fN7WuoIxNsxuhs7lKPcXl6aX4wZiW6gkeAHtTikLUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1310
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=967
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 14, 2019, at 10:57 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Annotate BPF program context types with program-side type and kernel-side=
 type.
> This type information is used by the verifier. btf_get_prog_ctx_type() is
> used in the later patches to verify that BTF type of ctx in BPF program m=
atches to
> kernel expected ctx type. For example, the XDP program type is:
> BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp, struct xdp_md, struct xdp_buff)
> That means that XDP program should be written as:
> int xdp_prog(struct xdp_md *ctx) { ... }
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20

[...]

> +	/* only compare that prog's ctx type name is the same as
> +	 * kernel expects. No need to compare field by field.
> +	 * It's ok for bpf prog to do:
> +	 * struct __sk_buff {};
> +	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
> +	 * { // no fields of skb are ever used }
> +	 */
> +	if (strcmp(ctx_tname, tname))
> +		return NULL;

Do we need to check size of the two struct? I guess we should not=20
allow something like

	struct __sk_buff {
		char data[REALLY_BIG_NUM];=20
	};
	int socket_filter_bpf_prog(struct __sk_buff *skb)
	{ /* access end of skb */ }

Or did I miss the size check?=20

Thanks,
Song=
