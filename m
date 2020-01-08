Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB051347EA
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgAHQZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:25:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23604 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbgAHQZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:25:44 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008GPOYW005999;
        Wed, 8 Jan 2020 08:25:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=v5VLppGo5FIhQTusEyd4yVK26LSumloHhTWK5hvUtd0=;
 b=n5sCDPoY2+8fW17p0GqSWiGsMCVWj/+oc8ZB+qUiI94atKJwyB7Ct3CCR7WtoZL8orNp
 mpqYkQiKL25w8l6HyJV99F6JaQUGd6hY0lI/drod8OsB0xeroyKo1csYZy/Szv/Pltc+
 e0hxhRFMpgEl9EgMCL3luiXdH5AWZ6P9CXA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdg1n8v2d-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 08:25:27 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 08:25:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2JHCZrBZbxsYLFjCtnJsXNiUg2qH//9NkptI2OU8ClJM5Q1VMEd7wQhziyZ6DRSXBQ5uXozdF4jJEaZ2r4lrTE1zJUt3uMjHOLE2ZcRItaPS0OqULxxG3idpq9/e7CoNsP96dlkw/fkxlHbCUEXMDCgOItj9nPBTu2iHutfolvSUdm/4Byvszo6BsN+zl4AdInxOvVsHdsJ6C3rNSZxSt42YzavxHIMsvWl6A67wBNIR5ipacNvUY7qEH95tT1vxhC71ymgMi7XkROnn11n3WNAM/eDI3kzB2dyv2cE3+DUb+74K23UzJRLGcV14EzlIxG4nJV6AHA7Ec9m+FzpEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5VLppGo5FIhQTusEyd4yVK26LSumloHhTWK5hvUtd0=;
 b=CJGSLSHdalF6ogCvN69l4iw3WX50faljA9KkkPAbqdgiNottY2ziu6WWvfTpeaMLLbReNVVaTp6l5Cnl60LVlis0TSLKH+pUKSPnulq5jS1P81WV0JSJf8XWE5+gBqdZvgyCdA7W9jQTqbbVYvIvCQIkHaMWloXNMiCtRqeyI/b6LWUFUEFGyfL950MuKS2hzjbT0QQ6Geox3Fe52YOyqtMJrV//mC1T6YJYpwtYAGFjijKcbOpfuPz6Bna+hROxSHQhUEr2GdsFxecMi/nQFazdHXtFvgmGh3xf3uBDQFialxr+Xkg5A5rFFUfO9JfVT9xwXtxKx2eouN7nUhrm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5VLppGo5FIhQTusEyd4yVK26LSumloHhTWK5hvUtd0=;
 b=dNbQZjeL5GM6psOnrJ5Ad1W4PpqIIsYcCmoKNQ8yVU7iwvCb7AGUaimBgnu7iJDOmSiYckq0azQ2R8nFwwpwTlDzb3VKvwgKnE0b4AiafG9y4ss0VIKPlDpklJE9/HR9J+DrkHST7HifRm2B5zw858cys4mykqWBVPL1Bb2gIIk=
Received: from MWHPR15MB1677.namprd15.prod.outlook.com (10.175.135.150) by
 MWHPR15MB1711.namprd15.prod.outlook.com (10.174.254.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Wed, 8 Jan 2020 16:25:09 +0000
Received: from MWHPR15MB1677.namprd15.prod.outlook.com
 ([fe80::45e0:16f7:c6ee:d50d]) by MWHPR15MB1677.namprd15.prod.outlook.com
 ([fe80::45e0:16f7:c6ee:d50d%3]) with mapi id 15.20.2623.008; Wed, 8 Jan 2020
 16:25:09 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::3:f9d7) by MWHPR1701CA0012.namprd17.prod.outlook.com (2603:10b6:301:14::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.12 via Frontend Transport; Wed, 8 Jan 2020 16:25:08 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about
 functions
Thread-Topic: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about
 functions
Thread-Index: AQHVxfThszPOGHsuq0qPknpvt8aEv6fgj9sAgABkmgA=
Date:   Wed, 8 Jan 2020 16:25:09 +0000
Message-ID: <89249a19-5fb9-86e3-925b-dbb03427f718@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-3-ast@kernel.org> <871rsai6td.fsf@toke.dk>
In-Reply-To: <871rsai6td.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0012.namprd17.prod.outlook.com
 (2603:10b6:301:14::22) To MWHPR15MB1677.namprd15.prod.outlook.com
 (2603:10b6:300:11b::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f9d7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24f481aa-8f4b-4ac0-0eb8-08d794575408
x-ms-traffictypediagnostic: MWHPR15MB1711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB17110CAAE100DC49D3B27AE2D33E0@MWHPR15MB1711.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(39860400002)(376002)(189003)(199004)(66946007)(186003)(64756008)(66446008)(316002)(6512007)(54906003)(8936002)(8676002)(6486002)(4326008)(966005)(81166006)(66556008)(110136005)(81156014)(66476007)(478600001)(52116002)(53546011)(6506007)(4744005)(36756003)(66574012)(16526019)(31696002)(86362001)(2616005)(2906002)(5660300002)(71200400001)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1711;H:MWHPR15MB1677.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FPlIyyRIppfn19JM3swJISkO5lGa4ZlpCPIuz857Ecdswm5DjzO5AagQdWD3FEpSoNl6kp68A929AonxEpgMmIdESB1RsHHwvw+xDnVw142sztedpjAypoJDfhwl3IiyQfpuIHuan5iJNKNCdQvO/DCDhq5ss3z4w/X3JMEosz+vb3i10E7l6Wzz4Suet2wpsMta1iEXXUInSd7ikKYRDoqmPZ/JaE00Nz433hn3nbCcKc/WGoIdIcU4ssOwrx0yHgNlCnsfFlL42XomlzJdS98VCg2/RhDpHie3RJdN/qDtgmlI1pbqIARlB5Yc52ws/6g+7CKe5yPbdBvIiVbnbkgeJdafVQDEkgVFgUA2d5UJZJ8iq4iRUUYumBW6u2LI9LklTdnN9h4npiBrKhh4XwxSqTNcHqFNwB6bbZu9Q6gsxEfdy7ww1GIkE0GY0Cq1g9Kq+OuMIFecxOIuiTIu+LfB4LvzadELRHvOt7u18eI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC8E446BFF453B47895FB4B24E1B9667@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f481aa-8f4b-4ac0-0eb8-08d794575408
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 16:25:09.3612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 335mcVPS02hhg/h29FooxV5rFmNcc3SZ2oGolPMLSm+qqpLgwiDMcPtl+yoxLFLq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1711
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_04:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=860 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvOC8yMCAyOjI1IEFNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gd3JvdGU6DQo+
IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+IHdyaXRlczoNCj4gDQo+PiBDb2xs
ZWN0IHN0YXRpYyB2cyBnbG9iYWwgaW5mb3JtYXRpb24gYWJvdXQgQlBGIGZ1bmN0aW9ucyBmcm9t
IEVMRiBmaWxlIGFuZA0KPj4gaW1wcm92ZSBCVEYgd2l0aCB0aGlzIGFkZGl0aW9uYWwgaW5mbyBp
ZiBsbHZtIGlzIHRvbyBvbGQgYW5kIGRvZXNuJ3QgZW1pdCBpdCBvbg0KPj4gaXRzIG93bi4NCj4g
DQo+IEhhcyB0aGUgc3VwcG9ydCBmb3IgdGhpcyBhY3R1YWxseSBsYW5kZWQgaW4gTExWTSB5ZXQ/
IEkgdHJpZWQgZ3JlcCdpbmcNCj4gaW4gdGhlIGNvbW1pdCBsb2cgYW5kIGNvdWxkbid0IGZpbmQg
YW55dGhpbmcuLi4NCg0KSXQgaGFzIG5vdCBsYW5kZWQgeWV0LiBUaGUgY29tbWl0IGxpbmsgaXM6
DQogICAgaHR0cHM6Ly9yZXZpZXdzLmxsdm0ub3JnL0Q3MTYzOA0KDQpJIHdpbGwgdHJ5IHRvIGxh
bmQgdGhlIHBhdGNoIGluIHRoZSBuZXh0IGNvdXBsZSBvZiBkYXlzIG9uY2UgdGhpcyBzZXJpZXMN
Cm9mIHBhdGNoIGlzIG1lcmdlZCBvciB0aGUgcHJpbmNpcGxlIG9mIHRoZSBwYXRjaCBpcyBhY2Nl
cHRlZC4NCg0KPiANCj4gWy4uLl0NCj4+IEBAIC0zMTMsNiArMzIxLDcgQEAgc3RydWN0IGJwZl9v
YmplY3Qgew0KPj4gICAJYm9vbCBsb2FkZWQ7DQo+PiAgIAlib29sIGhhc19wc2V1ZG9fY2FsbHM7
DQo+PiAgIAlib29sIHJlbGF4ZWRfY29yZV9yZWxvY3M7DQo+PiArCWJvb2wgbGx2bV9lbWl0c19m
dW5jX2xpbmthZ2U7DQo+IA0KPiBOaXQ6IHMvbGx2bS9jb21waWxlci8/IFByZXN1bWFibHkgR0ND
IHdpbGwgYWxzbyBzdXBwb3J0IHRoaXMgYXQgc29tZQ0KPiBwb2ludD8NCj4gDQo+IC1Ub2tlDQo+
IA0K
