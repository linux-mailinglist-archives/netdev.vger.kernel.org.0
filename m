Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11510B577
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfK0ST6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:19:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727138AbfK0ST6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:19:58 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xARIBqJf013044;
        Wed, 27 Nov 2019 10:19:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8fdu0p47rqP7dDvjhsiL3CYCd2E8g0DrnX2hEvjoOMc=;
 b=VI5oeXxBD5Rv/AvaY+VStULzERs7sARV74yWn2m6yWYpMI2+OMAQCThBK1NNm+BOds95
 gQtFg7qVJtK2jl1uhwOVUfS/aQ/+jFNye67iw5DnWaOl0GMYp/aFKlSh1r76SY+UBiiI
 pSyccTs702DavjP7wBZR9foK5cEvZnE3jZ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2whcxpntve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Nov 2019 10:19:44 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Nov 2019 10:19:44 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 27 Nov 2019 10:19:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8w0kjZVouQrDMHWVQ+0rR9Exfx2wrCPAl1hjJpUawCj6njX7cv2/9eOnADEGNICC3MdHnRkZOW23VCgN2m0bFt9SrjdKiafZ9iHzP9ob8zKa1Jg82brbWJGVmIWWqDgVtQyhOR+vsnDL5vAXrBAJfsajVV+b3xB0xpsAE6IqBzK43JxH9CaElbdO1cVezGPLWsbd7ZDSmmnf6Ud9VH1wgcfY8gECPzUocMlCkykHNdrXGYjW8JH+xC8Jd6S8fypdudmyNVjmbSLc6tOZ6CC1WSHuzzPBhm7tKPR7kKPr7tUXtiXubXTHDF++y0k0PTwb5AqBqXL5clAcNQWAP158g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fdu0p47rqP7dDvjhsiL3CYCd2E8g0DrnX2hEvjoOMc=;
 b=YjDiEluHcpEBRZaXdtKtm/z2Po2S4AczDhttuULIHvFyIJW8wuWKWsiDZlwWwedMIGG/3eBuIAuQj3392b6dXy3h8n/8klj+Y004L8uhbEq4Aq4+3nnIrFpoDXjEHEfpUe1m9fIPF2dzp8wfZvCSbAxz0iTt0bc6LodnQ5sMsgLSJQIaQLvdU3MojNbZDak4d+KG1bE6CrUAGDLgZc8FQ9XtanmxgOhiAK8GNfiS9vyXD6qiQjnNHgnpnLeyUpvLTY+ZMwZpQroDMbl9Nh8Luu1f1QAL0i8fbhXfESRdf9gXatIwec/ITPfR6PvlT+YJDPAyX6gqUOfmHMWB5647UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fdu0p47rqP7dDvjhsiL3CYCd2E8g0DrnX2hEvjoOMc=;
 b=SHM7UICLOlLKAlijRXwPGe4fKFlrlfny2+Low6jjq0OYYYwO5KYSYGIiAu4AKMGwwbfMckVmIr/OpWp9jOpx1x2R8HVv5zkN+XxnmSH07sa/jGlmJzELilIq1QuKrfYQAj54IBs6XNZQ7VtrKfK9WeTnIQ2WvCGAe9+UAgIu+3Q=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2520.namprd15.prod.outlook.com (20.179.154.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Wed, 27 Nov 2019 18:19:42 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 18:19:42 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] libbpf: fix global variable relocation
Thread-Topic: [PATCH bpf] libbpf: fix global variable relocation
Thread-Index: AQHVpU889oyq8lqTNEeiMzfeRPaWaQ==
Date:   Wed, 27 Nov 2019 18:19:42 +0000
Message-ID: <ce16b691-8afa-2e0c-6a99-ec509a125115@fb.com>
References: <20191127060144.3066500-1-andriin@fb.com>
In-Reply-To: <20191127060144.3066500-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:300:95::12) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0671365-677c-4744-c328-08d773665f4e
x-ms-traffictypediagnostic: BYAPR15MB2520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25209F3CF8162F5039B91772D3440@BYAPR15MB2520.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(86362001)(66946007)(25786009)(7736002)(305945005)(46003)(2616005)(36756003)(14454004)(14444005)(54906003)(256004)(446003)(8676002)(81156014)(8936002)(81166006)(6116002)(2906002)(66556008)(64756008)(66446008)(11346002)(5660300002)(498600001)(2201001)(2501003)(76176011)(31696002)(99286004)(52116002)(102836004)(6512007)(71200400001)(4326008)(71190400001)(6506007)(386003)(229853002)(31686004)(6246003)(6486002)(110136005)(66476007)(53546011)(186003)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2520;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3TCQ9e2IPLvoXU9ZdcLsOk4bH/vUnKx4p7rB4hh9bP47ULExD2zgBc7Aqy1UFFoTUFzPtX/vW7RBWxs3h5FpSykrOImbPKV709Q5p7XyHLWiYEv7S9y6MyAEM93tYhhotw1lAdE8bT7FGKpX3ei8qlbrC/gWZUBurhxIXSNsSAG/0DfpOX1ixXLsHizuV5ZQZ74xwzT4VAE14fGKGzzVjVLzRN5GUMTE0gZGJ25d8wId8Lct7fr69JEePbKHA3vno3ibg9wA6Xcy0v9pZfyvEgG4YPtcgF7HBzq6vGUzT2JJf2bGggG7mX0gd8RpkS77ps7zEimIEOroUSFrqWDV2b8YdQAFoPLyMoZyJpzM+lOqjyqUaGU90P+Xv9/lPhHRLuPhAyFxmhDrpRerFmUd9k0oYdkEtV49N1y9y8YCpuc/v8jLwBXqp8WEyxiDjeyq
Content-Type: text/plain; charset="utf-8"
Content-ID: <5033A762ACDDD94E86D993DAD33F6E1A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f0671365-677c-4744-c328-08d773665f4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 18:19:42.3487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mCvb1LYr+eFTNPkpkmRFToepjwnmTrt47gAm4j95rh1WNxOTASj3hqQX4KqNMQPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2520
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzI2LzE5IDEwOjAxIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IFNpbWls
YXJseSB0byBhMGQ3ZGEyNmNlODYgKCJsaWJicGY6IEZpeCBjYWxsIHJlbG9jYXRpb24gb2Zmc2V0
IGNhbGN1bGF0aW9uDQo+IGJ1ZyIpLCByZWxvY2F0aW9ucyBhZ2FpbnN0IGdsb2JhbCB2YXJpYWJs
ZXMgbmVlZCB0byB0YWtlIGludG8gYWNjb3VudA0KPiByZWZlcmVuY2VkIHN5bWJvbCdzIHN0X3Zh
bHVlLCB3aGljaCBob2xkcyBvZmZzZXQgaW50byBhIGNvcnJlc3BvbmRpbmcgZGF0YQ0KPiBzZWN0
aW9uIChhbmQsIHN1YnNlcXVlbnRseSwgb2Zmc2V0IGludG8gaW50ZXJuYWwgYmFja2luZyBtYXAp
LiBGb3Igc3RhdGljDQo+IHZhcmlhYmxlcyB0aGlzIG9mZnNldCBpcyBhbHdheXMgemVybyBhbmQg
ZGF0YSBvZmZzZXQgaXMgY29tcGxldGVseSBkZXNjcmliZWQNCj4gYnkgcmVzcGVjdGl2ZSBpbnN0
cnVjdGlvbidzIGltbSBmaWVsZC4NCj4gDQo+IENvbnZlcnQgYSBidW5jaCBvZiBzZWxmdGVzdHMg
dG8gZ2xvYmFsIHZhcmlhYmxlcy4gUHJldmlvdXNseSB0aGV5IHdlcmUgcmVseWluZw0KPiBvbiBg
c3RhdGljIHZvbGF0aWxlYCB0cmljayB0byBlbnN1cmUgQ2xhbmcgZG9lc24ndCBpbmxpbmUgc3Rh
dGljIHZhcmlhYmxlcywNCj4gd2hpY2ggd2l0aCBnbG9iYWwgdmFyaWFibGVzIGlzIG5vdCBuZWNl
c3NhcnkgYW55bW9yZS4NCj4gDQo+IEZpeGVzOiAzOTNjZGZiZWU4MDkgKCJsaWJicGY6IFN1cHBv
cnQgaW5pdGlhbGl6ZWQgZ2xvYmFsIHZhcmlhYmxlcyIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJp
aSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoNCkxHVE0gd2l0aCBhIGZldyBuaXRzIGJlbG93
Lg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0KPiAtLS0NCj4gICB0
b29scy9saWIvYnBmL2xpYmJwZi5jICAgICAgICAgICAgICAgICAgICAgICAgfCA0MCArKysrKysr
KystLS0tLS0tLS0tDQo+ICAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9mZW50cnlf
dGVzdC5jIHwgMTIgKysrLS0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvZmV4aXRfYnBm
MmJwZi5jICAgICAgIHwgIDYgKy0tDQo+ICAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9mZXhpdF90ZXN0LmMgIHwgMTIgKysrLS0tDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL3Byb2dzL3Rlc3RfbW1hcC5jIHwgIDQgKy0NCj4gICA1IGZpbGVzIGNoYW5nZWQsIDM1IGlu
c2VydGlvbnMoKyksIDM5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xp
Yi9icGYvbGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4IGIyMGY4MmU1
ODk4OS4uNDIwOWI1YTIzYTUzIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5j
DQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4gQEAgLTE3MSwxMCArMTcxLDggQEAg
c3RydWN0IGJwZl9wcm9ncmFtIHsNCj4gICAJCQlSRUxPX0RBVEEsDQo+ICAgCQl9IHR5cGU7DQo+
ICAgCQlpbnQgaW5zbl9pZHg7DQo+IC0JCXVuaW9uIHsNCj4gLQkJCWludCBtYXBfaWR4Ow0KPiAt
CQkJaW50IHRleHRfb2ZmOw0KPiAtCQl9Ow0KPiArCQlpbnQgbWFwX2lkeDsNCj4gKwkJaW50IHN5
bV9vZmY7DQo+ICAgCX0gKnJlbG9jX2Rlc2M7DQo+ICAgCWludCBucl9yZWxvYzsNCj4gICAJaW50
IGxvZ19sZXZlbDsNClsuLi5dDQo+IEBAIC0zNjIyLDMxICszNjIyLDI3IEBAIGJwZl9wcm9ncmFt
X19yZWxvY2F0ZShzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2csIHN0cnVjdCBicGZfb2JqZWN0ICpv
YmopDQo+ICAgCQlyZXR1cm4gMDsNCj4gICANCj4gICAJZm9yIChpID0gMDsgaSA8IHByb2ctPm5y
X3JlbG9jOyBpKyspIHsNCj4gKwkJc3RydWN0IHJlbG9jX2Rlc2MgKnJlbG8gPSAmcHJvZy0+cmVs
b2NfZGVzY1tpXTsNCj4gKw0KPiAgIAkJaWYgKHByb2ctPnJlbG9jX2Rlc2NbaV0udHlwZSA9PSBS
RUxPX0xENjQgfHwNCj4gICAJCSAgICBwcm9nLT5yZWxvY19kZXNjW2ldLnR5cGUgPT0gUkVMT19E
QVRBKSB7DQoNClVzaW5nIHJlbG8tPnR5cGUgPT0gUkVMT19MRDY0IG9yIFJFTE9fREFUQT8NCg0K
PiAtCQkJYm9vbCByZWxvX2RhdGEgPSBwcm9nLT5yZWxvY19kZXNjW2ldLnR5cGUgPT0gUkVMT19E
QVRBOw0KPiAtCQkJc3RydWN0IGJwZl9pbnNuICppbnNucyA9IHByb2ctPmluc25zOw0KPiAtCQkJ
aW50IGluc25faWR4LCBtYXBfaWR4Ow0KPiAtDQo+IC0JCQlpbnNuX2lkeCA9IHByb2ctPnJlbG9j
X2Rlc2NbaV0uaW5zbl9pZHg7DQo+IC0JCQltYXBfaWR4ID0gcHJvZy0+cmVsb2NfZGVzY1tpXS5t
YXBfaWR4Ow0KPiArCQkJc3RydWN0IGJwZl9pbnNuICppbnNuID0gJnByb2ctPmluc25zW3JlbG8t
Pmluc25faWR4XTsNCj4gICANCj4gLQkJCWlmIChpbnNuX2lkeCArIDEgPj0gKGludClwcm9nLT5p
bnNuc19jbnQpIHsNCj4gKwkJCWlmIChyZWxvLT5pbnNuX2lkeCArIDEgPj0gKGludClwcm9nLT5p
bnNuc19jbnQpIHsNCj4gICAJCQkJcHJfd2FybigicmVsb2NhdGlvbiBvdXQgb2YgcmFuZ2U6ICcl
cydcbiIsDQo+ICAgCQkJCQlwcm9nLT5zZWN0aW9uX25hbWUpOw0KPiAgIAkJCQlyZXR1cm4gLUxJ
QkJQRl9FUlJOT19fUkVMT0M7DQo+ICAgCQkJfQ0KPiAgIA0KPiAtCQkJaWYgKCFyZWxvX2RhdGEp
IHsNCj4gLQkJCQlpbnNuc1tpbnNuX2lkeF0uc3JjX3JlZyA9IEJQRl9QU0VVRE9fTUFQX0ZEOw0K
PiArCQkJaWYgKHJlbG8tPnR5cGUgIT0gUkVMT19EQVRBKSB7DQo+ICsJCQkJaW5zblswXS5zcmNf
cmVnID0gQlBGX1BTRVVET19NQVBfRkQ7DQo+ICAgCQkJfSBlbHNlIHsNCj4gLQkJCQlpbnNuc1tp
bnNuX2lkeF0uc3JjX3JlZyA9IEJQRl9QU0VVRE9fTUFQX1ZBTFVFOw0KPiAtCQkJCWluc25zW2lu
c25faWR4ICsgMV0uaW1tID0gaW5zbnNbaW5zbl9pZHhdLmltbTsNCj4gKwkJCQlpbnNuWzBdLnNy
Y19yZWcgPSBCUEZfUFNFVURPX01BUF9WQUxVRTsNCj4gKwkJCQlpbnNuWzFdLmltbSA9IGluc25b
MF0uaW1tICsgcmVsby0+c3ltX29mZjsNCj4gICAJCQl9DQo+IC0JCQlpbnNuc1tpbnNuX2lkeF0u
aW1tID0gb2JqLT5tYXBzW21hcF9pZHhdLmZkOw0KPiArCQkJaW5zblswXS5pbW0gPSBvYmotPm1h
cHNbcmVsby0+bWFwX2lkeF0uZmQ7DQo+ICAgCQl9IGVsc2UgaWYgKHByb2ctPnJlbG9jX2Rlc2Nb
aV0udHlwZSA9PSBSRUxPX0NBTEwpIHsNCg0KVXNpbmcgcmVsby0+dHlwZSA9PSBSRUxPX0NBTEw/
DQoNCj4gLQkJCWVyciA9IGJwZl9wcm9ncmFtX19yZWxvY190ZXh0KHByb2csIG9iaiwNCj4gLQkJ
CQkJCSAgICAgICZwcm9nLT5yZWxvY19kZXNjW2ldKTsNCj4gKwkJCWVyciA9IGJwZl9wcm9ncmFt
X19yZWxvY190ZXh0KHByb2csIG9iaiwgcmVsbyk7DQo+ICAgCQkJaWYgKGVycikNCj4gICAJCQkJ
cmV0dXJuIGVycjsNCj4gICAJCX0NCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9ncy9mZW50cnlfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Byb2dzL2ZlbnRyeV90ZXN0LmMNCj4gaW5kZXggZDJhZjlmMDM5ZGY1Li42MTVmN2M2YmNhNzcg
MTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9mZW50cnlf
dGVzdC5jDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9mZW50cnlf
dGVzdC5jDQo+IEBAIC02LDI4ICs2LDI4IEBADQpbLi4uXQ0K
