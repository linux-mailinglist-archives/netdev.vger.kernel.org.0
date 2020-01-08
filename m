Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E02B134B07
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgAHS5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:57:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgAHS5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:57:33 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008Iq3P8009951;
        Wed, 8 Jan 2020 10:57:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WOxbgSHTKspLDJvPX08d0zUb7qGUJNnuXte2uA0Z6wQ=;
 b=Q9B+xVYoGYstXHMp3KI1AwBmxYsnzcKfmgzWMTB7iHVQ0AUOljR1+ov2fraStnpdl9gO
 VY5zpWy709iMWaqRA33XEJe/JP95lDn7tjVi5uXgdvA7UymC0mDL+C9mPcRQYmTpKc2G
 KUvlelYlYJ3FRWkoJxCdkb3fOEwWizxX+aY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd3ep4wx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 10:57:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 10:57:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTmMD+LA6+AowoHY62pzjtgFHEdfBGFuub9nqo5R+K3/6UcrnGzX1wYUPWlJJFlAkPEWo3TB/aXwLx0tB+Czyj9jBYjAvQ822dMqpHhCWbIY4kiMO5IxtDH5vYJhMScfFhjMuub86ijVbYtveAqYaNmPST29JHkwkv+b4CavxFl5/EFrqFiQQxGf9TMZDLiFjBBrY5FH4LnnufIPiG/DspSb6WuSGY9Eqe9AJ/ApE+OT59qBSEXqmYG5d/GUoG81TvNhX05VU/wMsH663Cj/wdbDWurJYn9xAOMSMFBcJg29mkgNxcY0uVBbZ4K13McsaG0P9W4lmK1Of4EvwIv1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOxbgSHTKspLDJvPX08d0zUb7qGUJNnuXte2uA0Z6wQ=;
 b=noVBb7JE74R3k3ab+1sjtoQvqlOZ93R6VqK1tsMIHCixA7ub1usobkPny7LmPT11QbtvgHEbvYym/PoW2bvgnvQklsIdzw242Z67c4aOyBHL6a+oyo5ap2Yz8KEa6Ca7qeP80yIYJVuHErflRzWtF/OQKC67MDWJVVuaRtERTezU1kjFEw8lPbjXxh3Yz1hOZHHkXHj8Lhdo4Ni5EniaZfnSViilznpGInSW83W6tEMUDvC2oHOFNzlYYNYBZw02rHu9OzhkIbjLH2q8fo1SVYoRKPWOkinKiIA14sLPvslbrQWQOa+3ydFe28/2kJvrqf7PzX+EzA1TBKAg6xRLYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOxbgSHTKspLDJvPX08d0zUb7qGUJNnuXte2uA0Z6wQ=;
 b=YIyp5aKw3il+dIxNP9A84L04Vy8UQxOjKSiah6r9bDaVSNTW9H8ht/vX1QpY9FDFu0fX3VZJrycNZf52uMETdwf7s3RDzYrWHKYpOlAFwyMRsdxg326+0Pz6/UnpjGLZHGLJBKZcnqQ/uQ4L/D10sneKxTjf1lX0LOUtIE1+yGI=
Received: from MWHPR15MB1677.namprd15.prod.outlook.com (10.175.135.150) by
 MWHPR15MB1632.namprd15.prod.outlook.com (10.175.140.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 18:57:18 +0000
Received: from MWHPR15MB1677.namprd15.prod.outlook.com
 ([fe80::45e0:16f7:c6ee:d50d]) by MWHPR15MB1677.namprd15.prod.outlook.com
 ([fe80::45e0:16f7:c6ee:d50d%3]) with mapi id 15.20.2623.008; Wed, 8 Jan 2020
 18:57:18 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::3:f9d7) by CO2PR05CA0096.namprd05.prod.outlook.com (2603:10b6:104:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.6 via Frontend Transport; Wed, 8 Jan 2020 18:57:18 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/6] libbpf: Sanitize BTF_KIND_FUNC linkage
Thread-Topic: [PATCH bpf-next 1/6] libbpf: Sanitize BTF_KIND_FUNC linkage
Thread-Index: AQHVxfTmu39PjjS/206/gtE5ycEqYqfhHvkA
Date:   Wed, 8 Jan 2020 18:57:18 +0000
Message-ID: <d2fab68b-cd03-7a15-e353-c614f6079b89@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-2-ast@kernel.org>
In-Reply-To: <20200108072538.3359838-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:104:1::22) To MWHPR15MB1677.namprd15.prod.outlook.com
 (2603:10b6:300:11b::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f9d7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ca60120-81a9-438b-6edd-08d7946c959c
x-ms-traffictypediagnostic: MWHPR15MB1632:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16322C4FA63FECCAC7E176F9D33E0@MWHPR15MB1632.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(346002)(136003)(39860400002)(199004)(189003)(6486002)(186003)(16526019)(6506007)(54906003)(81156014)(52116002)(66446008)(66946007)(64756008)(66556008)(66476007)(53546011)(6512007)(2906002)(2616005)(110136005)(316002)(36756003)(71200400001)(31686004)(4326008)(8936002)(86362001)(31696002)(478600001)(81166006)(8676002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1632;H:MWHPR15MB1677.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WEflbbEo/Rrcr8IzXjqMInWhBhUKR5dneAJ3B7pz9T7qRIpVAzj9uR1coO10dZTH3HSc5RRbKKI9ucgawdhUfLIQGd4Ix3t5wTGhQ/+DTby+qupnfHxoHNnqVInOXvglJ8sRYj+GnZJu4bkzpvEs/IMVTn+vD4oydtCGO7rgWMa/2/bwxMftrN5ar5XOPyISQoUai6TaliuUPP9evDoMu/SY/Z0SQdhLD454iGAvK4TO+RaUDk1evX7uTsFCoaq1rd1R860j3lFsVXzEmzbC+1IXD5hK/6EJRmIcFU5KBA9M+/yFKz+4330HYNHdy2gplm+5M5Muxjfjr8ZUVw0NN6BGb+FGbDX/+XZIkfIfPSw2j8ILYF69VxTF69T3dhJI4kcA1xdri2aRYCOY3O1OSvGIVYeoLrb4N0yaqPOKvSoutZsLOqiiCoiasabdy7eh
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE1B2C78BA19C34B8647E057BB40F90A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca60120-81a9-438b-6edd-08d7946c959c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 18:57:18.5829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8UQ/MoB/6s+8MROHDSvDkqB8utWAWiZMjOWQ1KDjnjt/EJaR/UcLbz13Tz9KUEc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1632
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvNy8yMCAxMToyNSBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBJbiBj
YXNlIGtlcm5lbCBkb2Vzbid0IHN1cHBvcnQgc3RhdGljL2dsb2JhbC9leHRlcm4gbGlrbmFnZSBv
ZiBCVEZfS0lORF9GVU5DDQo+IHNhbml0aXplIEJURiBwcm9kdWNlZCBieSBsbHZtLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4NCj4gLS0t
DQo+ICAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2J0Zi5oIHwgIDYgKysrKysrDQo+ICAgdG9v
bHMvbGliL2JwZi9saWJicGYuYyAgICAgICAgIHwgMzUgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9idGYu
aCBiL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9idGYuaA0KPiBpbmRleCAxYTI4OThjNDgyZWUu
LjVhNjY3MTA3YWQyYyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2J0
Zi5oDQo+ICsrKyBiL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9idGYuaA0KPiBAQCAtMTQ2LDYg
KzE0NiwxMiBAQCBlbnVtIHsNCj4gICAJQlRGX1ZBUl9HTE9CQUxfRVhURVJOID0gMiwNCj4gICB9
Ow0KPiAgIA0KPiArZW51bSBidGZfZnVuY19saW5rYWdlIHsNCj4gKwlCVEZfRlVOQ19TVEFUSUMg
PSAwLA0KPiArCUJURl9GVU5DX0dMT0JBTCA9IDEsDQo+ICsJQlRGX0ZVTkNfRVhURVJOID0gMiwN
Cj4gK307DQo+ICsNCj4gICAvKiBCVEZfS0lORF9WQVIgaXMgZm9sbG93ZWQgYnkgYSBzaW5nbGUg
InN0cnVjdCBidGZfdmFyIiB0byBkZXNjcmliZQ0KPiAgICAqIGFkZGl0aW9uYWwgaW5mb3JtYXRp
b24gcmVsYXRlZCB0byB0aGUgdmFyaWFibGUgc3VjaCBhcyBpdHMgbGlua2FnZS4NCj4gICAgKi8N
Cj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xp
YmJwZi5jDQo+IGluZGV4IDc1MTMxNjViMTA0Zi4uZjcyYjNlZDZjMzRiIDEwMDY0NA0KPiAtLS0g
YS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMN
Cj4gQEAgLTE2Niw2ICsxNjYsOCBAQCBzdHJ1Y3QgYnBmX2NhcGFiaWxpdGllcyB7DQo+ICAgCV9f
dTMyIGJ0Zl9kYXRhc2VjOjE7DQo+ICAgCS8qIEJQRl9GX01NQVBBQkxFIGlzIHN1cHBvcnRlZCBm
b3IgYXJyYXlzICovDQo+ICAgCV9fdTMyIGFycmF5X21tYXA6MTsNCj4gKwkvKiBzdGF0aWMvZ2xv
YmFsL2V4dGVybiBpcyBzdXBwb3J0ZWQgZm9yIEJURl9LSU5EX0ZVTkMgKi8NCj4gKwlfX3UzMiBi
dGZfZnVuY19saW5rYWdlOjE7DQo+ICAgfTsNCj4gICANCj4gICBlbnVtIHJlbG9jX3R5cGUgew0K
PiBAQCAtMTgxNywxMyArMTgxOSwxNCBAQCBzdGF0aWMgYm9vbCBzZWN0aW9uX2hhdmVfZXhlY2lu
c3RyKHN0cnVjdCBicGZfb2JqZWN0ICpvYmosIGludCBpZHgpDQo+ICAgDQo+ICAgc3RhdGljIHZv
aWQgYnBmX29iamVjdF9fc2FuaXRpemVfYnRmKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopDQo+ICAg
ew0KPiArCWJvb2wgaGFzX2Z1bmNfbGlua2FnZSA9IG9iai0+Y2Fwcy5idGZfZnVuY19saW5rYWdl
Ow0KPiAgIAlib29sIGhhc19kYXRhc2VjID0gb2JqLT5jYXBzLmJ0Zl9kYXRhc2VjOw0KPiAgIAli
b29sIGhhc19mdW5jID0gb2JqLT5jYXBzLmJ0Zl9mdW5jOw0KPiAgIAlzdHJ1Y3QgYnRmICpidGYg
PSBvYmotPmJ0ZjsNCj4gICAJc3RydWN0IGJ0Zl90eXBlICp0Ow0KPiAgIAlpbnQgaSwgaiwgdmxl
bjsNCj4gICANCj4gLQlpZiAoIW9iai0+YnRmIHx8IChoYXNfZnVuYyAmJiBoYXNfZGF0YXNlYykp
DQo+ICsJaWYgKCFvYmotPmJ0ZiB8fCAoaGFzX2Z1bmMgJiYgaGFzX2RhdGFzZWMgJiYgaGFzX2Z1
bmNfbGlua2FnZSkpDQo+ICAgCQlyZXR1cm47DQo+ICAgDQo+ICAgCWZvciAoaSA9IDE7IGkgPD0g
YnRmX19nZXRfbnJfdHlwZXMoYnRmKTsgaSsrKSB7DQo+IEBAIC0xODcxLDYgKzE4NzQsOSBAQCBz
dGF0aWMgdm9pZCBicGZfb2JqZWN0X19zYW5pdGl6ZV9idGYoc3RydWN0IGJwZl9vYmplY3QgKm9i
aikNCj4gICAJCX0gZWxzZSBpZiAoIWhhc19mdW5jICYmIGJ0Zl9pc19mdW5jKHQpKSB7DQo+ICAg
CQkJLyogcmVwbGFjZSBGVU5DIHdpdGggVFlQRURFRiAqLw0KPiAgIAkJCXQtPmluZm8gPSBCVEZf
SU5GT19FTkMoQlRGX0tJTkRfVFlQRURFRiwgMCwgMCk7DQo+ICsJCX0gZWxzZSBpZiAoIWhhc19m
dW5jX2xpbmthZ2UgJiYgYnRmX2lzX2Z1bmModCkpIHsNCj4gKwkJCS8qIHJlcGxhY2UgQlRGX0ZV
TkNfR0xPQkFMIHdpdGggQlRGX0ZVTkNfU1RBVElDICovDQo+ICsJCQl0LT5pbmZvID0gQlRGX0lO
Rk9fRU5DKEJURl9LSU5EX0ZVTkMsIDAsIDApOw0KDQpUaGUgY29tbWVudCBzYXlzIHdlIG9ubHkg
c2FuaXRpemUgQlRGX0ZVTkNfR0xPQkFMIGhlcmUuDQpBY3R1YWxseSwgaXQgYWxzbyBzYW5pdGl6
ZSBCVEZfRlVOQ19FWFRFUk4uDQoNCkN1cnJlbnRseSwgaW4ga2VybmVsL2JwZi9idGYuYywgd2Ug
aGF2ZQ0Kc3RhdGljIGludCBidGZfY2hlY2tfYWxsX3R5cGVzKHN0cnVjdCBidGZfdmVyaWZpZXJf
ZW52ICplbnYpDQp7DQoJCS4uLg0KICAgICAgICAgICAgICAgICBpZiAoYnRmX3R5cGVfaXNfZnVu
Yyh0KSkgew0KICAgICAgICAgICAgICAgICAgICAgICAgIGVyciA9IGJ0Zl9mdW5jX2NoZWNrKGVu
diwgdCk7DQogICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGVycikNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiBlcnI7DQogICAgICAgICAgICAgICAgIH0NCgkJLi4u
DQp9DQoNCmJ0Zl9mdW5jX2NoZWNrKCkgd2lsbCBlbnN1cmUgZnVuYyBidGZfdHlwZS0+dHlwZSBp
cyBhIGZ1bmNfcHJvdG8NCmFuZCBhbGwgYXJndW1lbnRzIG9mIGZ1bmNfcHJvdG8gaGFzIGEgbmFt
ZSBleGNlcHQgdm9pZCB3aGljaCBpcw0KY29uc2lkZXJlZCBhcyB2YXJnLg0KDQpGb3IgZXh0ZXJu
IGZ1bmN0aW9uLCB0aGUgYXJndW1lbnQgbmFtZSBpcyBsb3N0IGluIGxsdm0vY2xhbmcuDQoNCi1i
YXNoLTQuNCQgY2F0IHRlc3QuYyANCg0KZXh0ZXJuIGludCBmb28oaW50IGEpOw0KaW50IHRlc3Qo
KSB7IHJldHVybiBmb28oNSk7IH0NCi1iYXNoLTQuNCQNCi1iYXNoLTQuNCQgY2xhbmcgLXRhcmdl
dCBicGYgLU8yIC1nIC1TIC1lbWl0LWxsdm0gdGVzdC5jDQoNCiEyID0gIXt9DQohNCA9ICFESVN1
YnByb2dyYW0obmFtZTogImZvbyIsIHNjb3BlOiAhMSwgZmlsZTogITEsIGxpbmU6IDEsIHR5cGU6
ICE1LCANCmZsYWdzOiBESUZsYWdQcm90b3R5cGVkLCBzcEZsYWdzOiBESVNQRmxhZ09wdGltaXpl
ZCwgcmV0YWluZWROb2RlczogITIpDQohNSA9ICFESVN1YnJvdXRpbmVUeXBlKHR5cGVzOiAhNikN
CiE2ID0gIXshNywgITd9DQohNyA9ICFESUJhc2ljVHlwZShuYW1lOiAiaW50Iiwgc2l6ZTogMzIs
IGVuY29kaW5nOiBEV19BVEVfc2lnbmVkKQ0KDQpUbyBhdm9pZCBrZXJuZWwgY29tcGxhaW50cywg
d2UgbmVlZCB0byBzYW5pdGl6ZSBpbiBhIGRpZmZlcmVudCB3YXkuDQpGb3IgZXhhbXBsZSBleHRl
cm4gQlRGX0tJTkRfRlVOQyBjb3VsZCBiZSByZXdyaXR0ZW4gdG8gYQ0KQlRGX0tJTkRfUFRSIHRv
IHZvaWQuDQoNCj4gICAJCX0NCj4gICAJfQ0KPiAgIH0NCj4gQEAgLTI4MDQsNiArMjgxMCwzMiBA
QCBzdGF0aWMgaW50IGJwZl9vYmplY3RfX3Byb2JlX2J0Zl9mdW5jKHN0cnVjdCBicGZfb2JqZWN0
ICpvYmopDQo+ICAgCXJldHVybiAwOw0KPiAgIH0NCj4gICANCj4gK3N0YXRpYyBpbnQgYnBmX29i
amVjdF9fcHJvYmVfYnRmX2Z1bmNfbGlua2FnZShzdHJ1Y3QgYnBmX29iamVjdCAqb2JqKQ0KPiAr
ew0KPiArCXN0YXRpYyBjb25zdCBjaGFyIHN0cnNbXSA9ICJcMGludFwweFwwYSI7DQo+ICsJLyog
c3RhdGljIHZvaWQgeChpbnQgYSkge30gKi8NCj4gKwlfX3UzMiB0eXBlc1tdID0gew0KPiArCQkv
KiBpbnQgKi8NCj4gKwkJQlRGX1RZUEVfSU5UX0VOQygxLCBCVEZfSU5UX1NJR05FRCwgMCwgMzIs
IDQpLCAgLyogWzFdICovDQo+ICsJCS8qIEZVTkNfUFJPVE8gKi8gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIC8qIFsyXSAqLw0KPiArCQlCVEZfVFlQRV9FTkMoMCwgQlRGX0lORk9fRU5D
KEJURl9LSU5EX0ZVTkNfUFJPVE8sIDAsIDEpLCAwKSwNCj4gKwkJQlRGX1BBUkFNX0VOQyg3LCAx
KSwNCj4gKwkJLyogRlVOQyB4IEJURl9GVU5DX0dMT0JBTCAqLyAgICAgICAgICAgICAgICAgICAg
LyogWzNdICovDQo+ICsJCUJURl9UWVBFX0VOQyg1LCBCVEZfSU5GT19FTkMoQlRGX0tJTkRfRlVO
QywgMCwgMSksIDIpLA0KPiArCX07DQo+ICsJaW50IGJ0Zl9mZDsNCj4gKw0KPiArCWJ0Zl9mZCA9
IGxpYmJwZl9fbG9hZF9yYXdfYnRmKChjaGFyICopdHlwZXMsIHNpemVvZih0eXBlcyksDQo+ICsJ
CQkJICAgICAgc3Rycywgc2l6ZW9mKHN0cnMpKTsNCj4gKwlpZiAoYnRmX2ZkID49IDApIHsNCj4g
KwkJb2JqLT5jYXBzLmJ0Zl9mdW5jX2xpbmthZ2UgPSAxOw0KPiArCQljbG9zZShidGZfZmQpOw0K
PiArCQlyZXR1cm4gMTsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiAg
IHN0YXRpYyBpbnQgYnBmX29iamVjdF9fcHJvYmVfYnRmX2RhdGFzZWMoc3RydWN0IGJwZl9vYmpl
Y3QgKm9iaikNCj4gICB7DQo+ICAgCXN0YXRpYyBjb25zdCBjaGFyIHN0cnNbXSA9ICJcMHhcMC5k
YXRhIjsNCj4gQEAgLTI4NTksNiArMjg5MSw3IEBAIGJwZl9vYmplY3RfX3Byb2JlX2NhcHMoc3Ry
dWN0IGJwZl9vYmplY3QgKm9iaikNCj4gICAJCWJwZl9vYmplY3RfX3Byb2JlX25hbWUsDQo+ICAg
CQlicGZfb2JqZWN0X19wcm9iZV9nbG9iYWxfZGF0YSwNCj4gICAJCWJwZl9vYmplY3RfX3Byb2Jl
X2J0Zl9mdW5jLA0KPiArCQlicGZfb2JqZWN0X19wcm9iZV9idGZfZnVuY19saW5rYWdlLA0KPiAg
IAkJYnBmX29iamVjdF9fcHJvYmVfYnRmX2RhdGFzZWMsDQo+ICAgCQlicGZfb2JqZWN0X19wcm9i
ZV9hcnJheV9tbWFwLA0KPiAgIAl9Ow0KPiANCg==
