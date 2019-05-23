Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94F7283A4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfEWQaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:30:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50336 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730790AbfEWQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:30:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NGRxgK024113;
        Thu, 23 May 2019 09:29:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xO2mwKOmlyrP1fP0qcAu1xvNsFDP4VSCePIsj86ojvg=;
 b=rS5XgedXJ01uV8+rv5kNInECNW/SqJGwHIWv+1DxcKNUqnVF/mIVxMI+CsPKw8fDFLXT
 yc5yzDdXuHGWeLCDtUz08zoS3uYz1j914RKmt1zAZi7I4nONJIed+l9W6t0KRTp012aH
 YOT9lGh+jDGfnBrc4h/B7tR8N4gepSHFcvY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2snx7s8795-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 May 2019 09:29:51 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 23 May 2019 09:29:49 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 09:29:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO2mwKOmlyrP1fP0qcAu1xvNsFDP4VSCePIsj86ojvg=;
 b=anBWHHUeSx2ot/WoADMTrxJ+dI1AQqwK4z10jbH1WqCEHtBmQhttf5pROvvonblAtZZOFGvKj9SeJ9AdxFLD/twFAp0LhbFG3e6n98pvJK4DHMyFgRGlqa9iYf/0DvPIlJl/2tLPZI9CXUxyTSoKoT4ueKYXHZYWwPQvAktjoUw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3381.namprd15.prod.outlook.com (20.179.59.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Thu, 23 May 2019 16:29:47 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 16:29:47 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
Thread-Topic: [PATCH bpf-next v2 2/3] libbpf: add bpf_object__load_xattr() API
 function to pass log_level
Thread-Index: AQHVEVX0x9CZVTZqdk+w+vMT57iUPKZ45AAAgAACyQA=
Date:   Thu, 23 May 2019 16:29:47 +0000
Message-ID: <1d6ec594-5564-3b35-f134-055d8ff4eb0f@fb.com>
References: <20190523105426.3938-1-quentin.monnet@netronome.com>
 <20190523105426.3938-3-quentin.monnet@netronome.com>
 <d9d1d907-9f0d-7fc0-3f2d-dde5081e8bd3@fb.com>
In-Reply-To: <d9d1d907-9f0d-7fc0-3f2d-dde5081e8bd3@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:300:d4::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30f8c80a-4f51-4c41-87b2-08d6df9bdeea
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3381;
x-ms-traffictypediagnostic: BYAPR15MB3381:
x-microsoft-antispam-prvs: <BYAPR15MB3381ED92AED6AD3D03DE5D7ED3010@BYAPR15MB3381.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(189003)(199004)(4326008)(6246003)(36756003)(2906002)(6116002)(86362001)(71200400001)(71190400001)(6436002)(6486002)(229853002)(31696002)(25786009)(14454004)(316002)(5660300002)(7736002)(256004)(14444005)(31686004)(53936002)(305945005)(476003)(2616005)(54906003)(102836004)(386003)(6506007)(53546011)(99286004)(76176011)(52116002)(186003)(486006)(110136005)(478600001)(46003)(8676002)(6512007)(68736007)(81166006)(81156014)(446003)(11346002)(73956011)(8936002)(66446008)(64756008)(66946007)(66556008)(66476007)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3381;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R6C9UCezE0GmZbWXEY/C0gbYpqBgE2AE+pyoSWImCghFQwe6OdiOZMXf1l/YLo0Gf2RmXMvUxGO/p4KoOEvgXnirV1DaPP4Kiar3HD0e58jwSEcqZ7InxyT3BtoE0nAF+dnajwuBTeA8c6Q/igKQ45RFZ5I7AxDX95HUFrXsrTDALgnmjhsDVPwY0iTgRuU2kUVMSSxVelDCMUazto2RBhEB31iwCRzNth42SoxHLFfWe6QiTQqCewLTvLrWxu069KmCrZsADbbaH3tc7xCH8KG7/UCg2NtQQh7vqzs7YC9Sl58l3djSBcdIbsjXcXzoqX4GkfIA4eB7pUnr8n+qqDQyPJVzLldzMgMixIRHUJp9e6JtD/bSBj5vwdeFGZ1eZKBQyvftts23Y+FjVuC3e3CQtfE7nJcAMjsAqCCxwRs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19DD895B63DFE34CBC451CA9E756E52A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f8c80a-4f51-4c41-87b2-08d6df9bdeea
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 16:29:47.4959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3381
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230112
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgOToxOSBBTSwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4gDQo+IA0KPiBP
biA1LzIzLzE5IDM6NTQgQU0sIFF1ZW50aW4gTW9ubmV0IHdyb3RlOg0KPj4gbGliYnBmIHdhcyBy
ZWNlbnRseSBtYWRlIGF3YXJlIG9mIHRoZSBsb2dfbGV2ZWwgYXR0cmlidXRlIGZvciBwcm9ncmFt
cywNCj4+IHVzZWQgdG8gc3BlY2lmeSB0aGUgbGV2ZWwgb2YgaW5mb3JtYXRpb24gZXhwZWN0ZWQg
dG8gYmUgZHVtcGVkIGJ5IHRoZQ0KPj4gdmVyaWZpZXIuDQo+Pg0KPj4gQ3JlYXRlIGFuIEFQSSBm
dW5jdGlvbiB0byBwYXNzIGFkZGl0aW9uYWwgYXR0cmlidXRlcyB3aGVuIGxvYWRpbmcgYQ0KPj4g
YnBmX29iamVjdCwgc28gd2UgY2FuIHNldCB0aGlzIGxvZ19sZXZlbCB2YWx1ZSBpbiBwcm9ncmFt
cyB3aGVuIGxvYWRpbmcNCj4+IHRoZW0sIGFuZCBzbyB0aGF0IHNvIHRoYXQgYXBwbGljYXRpb25z
IHJlbHlpbmcgb24gbGliYnBmIGJ1dCBub3QgY2FsbGluZw0KPiAic28gdGhhdCBzbyB0aGF0IiA9
PiAic28gdGhhdCINCj4+IGJwZl9wcm9nX2xvYWRfeGF0dHIoKSBjYW4gYWxzbyB1c2UgdGhhdCBm
ZWF0dXJlLg0KPiANCj4gRG8gbm90IGZ1bGx5IHVuZGVyc3RhbmQgdGhlIGFib3ZlIHN0YXRlbWVu
dC4gRnJvbSB0aGUgY29kZSBiZWxvdywNCj4gSSBkaWQgbm90IHNlZSBob3cgdGhlIG5vbi16ZXJv
IGxvZ19sZXZlbCBjYW4gYmUgc2V0IGZvciBicGZfcHJvZ3JhbQ0KPiB3aXRob3V0IGJwZl9wcm9n
X2xvYWRfeGF0dHIoKS4gTWF5YmUgSSBtaXNzIHNvbWV0aGluZz8NCg0KTG9va3MgbGlrZSBuZXh0
IHBhdGNoIHVzZXMgaXQgd2hlbiAtZCBpcyBzcGVjaWZpZWQuDQpQcm9iYWJseSBjb21taXQgbWVz
c2FnZSBjYW4gYmUgbWFkZSBtb3JlIGNsZWFyLg0KDQo+IA0KPj4NCj4+IHYyOg0KPj4gLSBXZSBh
cmUgaW4gYSBuZXcgY3ljbGUsIGJ1bXAgbGliYnBmIGV4dHJhdmVyc2lvbiBudW1iZXIuDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogUXVlbnRpbiBNb25uZXQgPHF1ZW50aW4ubW9ubmV0QG5ldHJvbm9t
ZS5jb20+DQo+PiBSZXZpZXdlZC1ieTogSmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5l
dHJvbm9tZS5jb20+DQo+PiAtLS0NCj4+IMKgIHRvb2xzL2xpYi9icGYvTWFrZWZpbGXCoMKgIHzC
oCAyICstDQo+PiDCoCB0b29scy9saWIvYnBmL2xpYmJwZi5jwqDCoCB8IDIwICsrKysrKysrKysr
KysrKysrLS0tDQo+PiDCoCB0b29scy9saWIvYnBmL2xpYmJwZi5owqDCoCB8wqAgNiArKysrKysN
Cj4+IMKgIHRvb2xzL2xpYi9icGYvbGliYnBmLm1hcCB8wqAgNSArKysrKw0KPj4gwqAgNCBmaWxl
cyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYg
LS1naXQgYS90b29scy9saWIvYnBmL01ha2VmaWxlIGIvdG9vbHMvbGliL2JwZi9NYWtlZmlsZQ0K
Pj4gaW5kZXggYTJhY2VhZGY2OGRiLi45MzEyMDY2YTFhZTMgMTAwNjQ0DQo+PiAtLS0gYS90b29s
cy9saWIvYnBmL01ha2VmaWxlDQo+PiArKysgYi90b29scy9saWIvYnBmL01ha2VmaWxlDQo+PiBA
QCAtMyw3ICszLDcgQEANCj4+IMKgIEJQRl9WRVJTSU9OID0gMA0KPj4gwqAgQlBGX1BBVENITEVW
RUwgPSAwDQo+PiAtQlBGX0VYVFJBVkVSU0lPTiA9IDMNCj4+ICtCUEZfRVhUUkFWRVJTSU9OID0g
NA0KPj4gwqAgTUFLRUZMQUdTICs9IC0tbm8tcHJpbnQtZGlyZWN0b3J5DQo+PiBkaWZmIC0tZ2l0
IGEvdG9vbHMvbGliL2JwZi9saWJicGYuYyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4+IGlu
ZGV4IDE5N2I1NzQ0MDZiMy4uMWM2ZmI3YTMyMDFlIDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvbGli
L2JwZi9saWJicGYuYw0KPj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYuYw0KPj4gQEAgLTIy
MjIsNyArMjIyMiw3IEBAIHN0YXRpYyBib29sIA0KPj4gYnBmX3Byb2dyYW1fX2lzX2Z1bmN0aW9u
X3N0b3JhZ2Uoc3RydWN0IGJwZl9wcm9ncmFtICpwcm9nLA0KPj4gwqAgfQ0KPj4gwqAgc3RhdGlj
IGludA0KPj4gLWJwZl9vYmplY3RfX2xvYWRfcHJvZ3Moc3RydWN0IGJwZl9vYmplY3QgKm9iaikN
Cj4+ICticGZfb2JqZWN0X19sb2FkX3Byb2dzKHN0cnVjdCBicGZfb2JqZWN0ICpvYmosIGludCBs
b2dfbGV2ZWwpDQo+PiDCoCB7DQo+PiDCoMKgwqDCoMKgIHNpemVfdCBpOw0KPj4gwqDCoMKgwqDC
oCBpbnQgZXJyOw0KPj4gQEAgLTIyMzAsNiArMjIzMCw3IEBAIGJwZl9vYmplY3RfX2xvYWRfcHJv
Z3Moc3RydWN0IGJwZl9vYmplY3QgKm9iaikNCj4+IMKgwqDCoMKgwqAgZm9yIChpID0gMDsgaSA8
IG9iai0+bnJfcHJvZ3JhbXM7IGkrKykgew0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChicGZf
cHJvZ3JhbV9faXNfZnVuY3Rpb25fc3RvcmFnZSgmb2JqLT5wcm9ncmFtc1tpXSwgb2JqKSkNCj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOw0KPj4gK8KgwqDCoMKgwqDCoMKg
IG9iai0+cHJvZ3JhbXNbaV0ubG9nX2xldmVsID0gbG9nX2xldmVsOw0KPj4gwqDCoMKgwqDCoMKg
wqDCoMKgIGVyciA9IGJwZl9wcm9ncmFtX19sb2FkKCZvYmotPnByb2dyYW1zW2ldLA0KPj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9iai0+bGljZW5zZSwNCj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvYmotPmtlcm5fdmVy
c2lvbik7DQo+PiBAQCAtMjM4MSwxMCArMjM4MiwxNCBAQCBpbnQgYnBmX29iamVjdF9fdW5sb2Fk
KHN0cnVjdCBicGZfb2JqZWN0ICpvYmopDQo+PiDCoMKgwqDCoMKgIHJldHVybiAwOw0KPj4gwqAg
fQ0KPj4gLWludCBicGZfb2JqZWN0X19sb2FkKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopDQo+PiAr
aW50IGJwZl9vYmplY3RfX2xvYWRfeGF0dHIoc3RydWN0IGJwZl9vYmplY3RfbG9hZF9hdHRyICph
dHRyKQ0KPj4gwqAgew0KPj4gK8KgwqDCoCBzdHJ1Y3QgYnBmX29iamVjdCAqb2JqOw0KPj4gwqDC
oMKgwqDCoCBpbnQgZXJyOw0KPj4gK8KgwqDCoCBpZiAoIWF0dHIpDQo+PiArwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIC1FSU5WQUw7DQo+PiArwqDCoMKgIG9iaiA9IGF0dHItPm9iajsNCj4+IMKgwqDC
oMKgwqAgaWYgKCFvYmopDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7DQo+
PiBAQCAtMjM5Nyw3ICsyNDAyLDcgQEAgaW50IGJwZl9vYmplY3RfX2xvYWQoc3RydWN0IGJwZl9v
YmplY3QgKm9iaikNCj4+IMKgwqDCoMKgwqAgQ0hFQ0tfRVJSKGJwZl9vYmplY3RfX2NyZWF0ZV9t
YXBzKG9iaiksIGVyciwgb3V0KTsNCj4+IMKgwqDCoMKgwqAgQ0hFQ0tfRVJSKGJwZl9vYmplY3Rf
X3JlbG9jYXRlKG9iaiksIGVyciwgb3V0KTsNCj4+IC3CoMKgwqAgQ0hFQ0tfRVJSKGJwZl9vYmpl
Y3RfX2xvYWRfcHJvZ3Mob2JqKSwgZXJyLCBvdXQpOw0KPj4gK8KgwqDCoCBDSEVDS19FUlIoYnBm
X29iamVjdF9fbG9hZF9wcm9ncyhvYmosIGF0dHItPmxvZ19sZXZlbCksIGVyciwgb3V0KTsNCj4+
IMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+PiDCoCBvdXQ6DQo+PiBAQCAtMjQwNiw2ICsyNDExLDE1
IEBAIGludCBicGZfb2JqZWN0X19sb2FkKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopDQo+PiDCoMKg
wqDCoMKgIHJldHVybiBlcnI7DQo+PiDCoCB9DQo+PiAraW50IGJwZl9vYmplY3RfX2xvYWQoc3Ry
dWN0IGJwZl9vYmplY3QgKm9iaikNCj4+ICt7DQo+PiArwqDCoMKgIHN0cnVjdCBicGZfb2JqZWN0
X2xvYWRfYXR0ciBhdHRyID0gew0KPj4gK8KgwqDCoMKgwqDCoMKgIC5vYmogPSBvYmosDQo+PiAr
wqDCoMKgIH07DQo+PiArDQo+PiArwqDCoMKgIHJldHVybiBicGZfb2JqZWN0X19sb2FkX3hhdHRy
KCZhdHRyKTsNCj4+ICt9DQo+PiArDQo+PiDCoCBzdGF0aWMgaW50IGNoZWNrX3BhdGgoY29uc3Qg
Y2hhciAqcGF0aCkNCj4+IMKgIHsNCj4+IMKgwqDCoMKgwqAgY2hhciAqY3AsIGVycm1zZ1tTVFJF
UlJfQlVGU0laRV07DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuaCBiL3Rv
b2xzL2xpYi9icGYvbGliYnBmLmgNCj4+IGluZGV4IGM1ZmYwMDUxNWNlNy4uZTFjNzQ4ZGI0NGY2
IDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPj4gKysrIGIvdG9vbHMv
bGliL2JwZi9saWJicGYuaA0KPj4gQEAgLTg5LDggKzg5LDE0IEBAIExJQkJQRl9BUEkgaW50IGJw
Zl9vYmplY3RfX3VucGluX3Byb2dyYW1zKHN0cnVjdCANCj4+IGJwZl9vYmplY3QgKm9iaiwNCj4+
IMKgIExJQkJQRl9BUEkgaW50IGJwZl9vYmplY3RfX3BpbihzdHJ1Y3QgYnBmX29iamVjdCAqb2Jq
ZWN0LCBjb25zdCBjaGFyIA0KPj4gKnBhdGgpOw0KPj4gwqAgTElCQlBGX0FQSSB2b2lkIGJwZl9v
YmplY3RfX2Nsb3NlKHN0cnVjdCBicGZfb2JqZWN0ICpvYmplY3QpOw0KPj4gK3N0cnVjdCBicGZf
b2JqZWN0X2xvYWRfYXR0ciB7DQo+PiArwqDCoMKgIHN0cnVjdCBicGZfb2JqZWN0ICpvYmo7DQo+
PiArwqDCoMKgIGludCBsb2dfbGV2ZWw7DQo+PiArfTsNCj4+ICsNCj4+IMKgIC8qIExvYWQvdW5s
b2FkIG9iamVjdCBpbnRvL2Zyb20ga2VybmVsICovDQo+PiDCoCBMSUJCUEZfQVBJIGludCBicGZf
b2JqZWN0X19sb2FkKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopOw0KPj4gK0xJQkJQRl9BUEkgaW50
IGJwZl9vYmplY3RfX2xvYWRfeGF0dHIoc3RydWN0IGJwZl9vYmplY3RfbG9hZF9hdHRyIA0KPj4g
KmF0dHIpOw0KPj4gwqAgTElCQlBGX0FQSSBpbnQgYnBmX29iamVjdF9fdW5sb2FkKHN0cnVjdCBi
cGZfb2JqZWN0ICpvYmopOw0KPj4gwqAgTElCQlBGX0FQSSBjb25zdCBjaGFyICpicGZfb2JqZWN0
X19uYW1lKHN0cnVjdCBicGZfb2JqZWN0ICpvYmopOw0KPj4gwqAgTElCQlBGX0FQSSB1bnNpZ25l
ZCBpbnQgYnBmX29iamVjdF9fa3ZlcnNpb24oc3RydWN0IGJwZl9vYmplY3QgKm9iaik7DQo+PiBk
aWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJi
cGYubWFwDQo+PiBpbmRleCA2NzMwMDE3ODdjYmEuLjZjZTYxZmEwYmFmMyAxMDA2NDQNCj4+IC0t
LSBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcA0KPj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJi
cGYubWFwDQo+PiBAQCAtMTY0LDMgKzE2NCw4IEBAIExJQkJQRl8wLjAuMyB7DQo+PiDCoMKgwqDC
oMKgwqDCoMKgwqAgYnBmX21hcF9mcmVlemU7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnRmX19m
aW5hbGl6ZV9kYXRhOw0KPj4gwqAgfSBMSUJCUEZfMC4wLjI7DQo+PiArDQo+PiArTElCQlBGXzAu
MC40IHsNCj4+ICvCoMKgwqAgZ2xvYmFsOg0KPj4gK8KgwqDCoMKgwqDCoMKgIGJwZl9vYmplY3Rf
X2xvYWRfeGF0dHI7DQo+PiArfSBMSUJCUEZfMC4wLjM7DQo+Pg0K
