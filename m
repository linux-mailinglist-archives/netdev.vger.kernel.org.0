Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BE1F5467
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbfKHS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:59:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388926AbfKHS7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:59:25 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8ItHeG028052;
        Fri, 8 Nov 2019 10:59:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4eIWGw34L2CIx8RX7ujYwaAEN15gDd1guczX8fgQkLA=;
 b=ojNqerImKUBpJ37QNelDhpm/3VR4uZGx+ZgUm9j7De5IGSOjRtcgS/PNov4xrG2VDsq1
 H/L5yLfUBaeq5/Fif+iI1o1JwNZG3r4BIFIRBFVIEeIf1iXbvHulKF5r0b5+VJ/blymv
 GRU+GA3TbdaKwma9WKpXLaXQeQKjBildBww= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5brygur6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 10:59:10 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 10:59:10 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 10:59:10 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 10:59:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXDO0tOBqbqme3oh1sLiDN36sJYhMN2EJXh0za2CVcKoVesb1+D8MIuOWWgcz9S5NZ0LbRKdjSCxzDhpTZaB5eAR3Q+Iki4c9JozGQFUFETByzPPFfvKbYxiIfbrXWhrC5esK/wZe9asFMGuQibGYdxkueKi5I9Asqj9eGPwNtl0gZj6Nbr5GXjs9wsL+E7zWvFfUmraOOvYzXH6Z2t1py5xXqMZ1sVNytN7dSNvDheAn3OCQtPttk1J+OsSN7g9KwccTLfKOcV2DEzPwaLiAn/E1a3BZrj8352CHqYIxH+6JssTa8J+0uiJxjao0hjUlWiAab+NHARWFkDsjogqnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eIWGw34L2CIx8RX7ujYwaAEN15gDd1guczX8fgQkLA=;
 b=KU6wUj8/TxTGK/Q6R5Y3mcHzSA+4k7ROpzzdey18qIVogr8QbwhVWezG+A2g/1dCMR3JNNe02HwVF0Hyw8S3PLJWayjl66LpNIGPfz/Z4CFU2PhblOK5W0xfZAJNWe3BK84DdrXU+qwCMZ99mt7AR3OlKPUNruliY+XrToYFPaSRE+lxvxUEcbSq4cnB9rAT4lxw4Dv/gtpkrzDA4VFBO/UnNMRzSmY+dGyt+MdPo2J+UdsQNgQG+190qc7YJkdarfdTMb7uEpXNRewZtgXl4ycjMp1Rq8tRLaRkEM7iK8OA49aODugw0+7RGJNOAEarlCO1CJMFqdrofQCfK1Pnxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eIWGw34L2CIx8RX7ujYwaAEN15gDd1guczX8fgQkLA=;
 b=FIMqyNy4Jm4RxIdEbxdri2dyHltat0T3j4uKaqtafCwEfDDAtKaNUmtlaAd77osuDONr9IkrRCQVbJuSn9NMGvqWx1833mv3ZB7sc2wD2Y+b7i91rhH6Vill0JIFoKMGExvqyozSou5gMVQ+231eDyCdIkHgKjv2N+H5C0qBY+k=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2741.namprd15.prod.outlook.com (20.179.155.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 18:59:06 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:59:06 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Topic: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Index: AQHVlf+nZDPDBM5wGU2+HMUND7lGDKeBnneAgAACtoA=
Date:   Fri, 8 Nov 2019 18:59:06 +0000
Message-ID: <5a0caec2-c406-c2b5-b4a8-0412800a6e43@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-16-ast@kernel.org>
 <34A3894D-C928-4332-BD82-9B7C1459A8D1@fb.com>
In-Reply-To: <34A3894D-C928-4332-BD82-9B7C1459A8D1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:300:94::25) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79eba64d-be9b-43f7-1909-08d7647dba8b
x-ms-traffictypediagnostic: BYAPR15MB2741:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2741B9140676C44DAE5783FCD77B0@BYAPR15MB2741.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(366004)(376002)(189003)(199004)(102836004)(14444005)(36756003)(386003)(5024004)(31686004)(66476007)(53546011)(6246003)(76176011)(52116002)(316002)(6436002)(54906003)(25786009)(6506007)(14454004)(2906002)(110136005)(6116002)(99286004)(6512007)(5660300002)(7736002)(86362001)(256004)(64756008)(66446008)(66556008)(4326008)(31696002)(186003)(305945005)(6486002)(8936002)(476003)(478600001)(2616005)(71200400001)(71190400001)(8676002)(81156014)(446003)(81166006)(486006)(46003)(11346002)(66946007)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2741;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aWWALE/ZWN+DcJey2fJCjoyByea4fIMIFTyVJADPcdDncYJXdHTGDjHRQPQ6ZzIQT9iWHgwyU3qwOsqKV927zMhC1eNWomWtCmZfj96V2J0aeMgZjiW6jIHSZ+HMasaDrDJoBxqk3UFF+/z7IS+UnL8Xedxdv9AGzv90CaxdcIh//UaGmSnqJgtV9xfkgkv1SkfD62K4Fyb/i2BO7qyW/qwWznHjP/Hz5nhMnvm1cZTpFGJ0x+vQqXl7Onu3uaOZeqLXTGj85HY9Vdzew5fh/hZWE7ONXMMrKHdM4e48okCgbDawXl1vhhN3z2SMep35SdlABbTof1TcXSwCjiPUbPVgo9tgY4h3hV2KFkVwabbsJsDoYQFQAlnGDDfEngR5PEqkrSwmjvkNbPKXLuiW+oomRgIbvrPkm+Z9MrtVMu/1yZ+7MU+lkm3u7jmyNJiq
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CCB0774FFE8044CA401A5516D46044A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 79eba64d-be9b-43f7-1909-08d7647dba8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:59:06.1770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjDWnpbT6F4hXOm11BnOkT606iJPmFPlsVFpRSM/MExYbP9hG62GMmgFAnzSZDCf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2741
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=788 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvOC8xOSAxMDo0OSBBTSwgU29uZyBMaXUgd3JvdGU6DQo+IA0KPiANCj4+IE9uIE5vdiA3
LCAyMDE5LCBhdCAxMDo0MCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pg0KPj4gQWxsb3cgRkVOVFJZL0ZFWElUIEJQRiBwcm9ncmFtcyB0byBhdHRhY2gg
dG8gb3RoZXIgQlBGIHByb2dyYW1zIG9mIGFueSB0eXBlDQo+PiBpbmNsdWRpbmcgdGhlaXIgc3Vi
cHJvZ3JhbXMuIFRoaXMgZmVhdHVyZSBhbGxvd3Mgc25vb3Bpbmcgb24gaW5wdXQgYW5kIG91dHB1
dA0KPj4gcGFja2V0cyBpbiBYRFAsIFRDIHByb2dyYW1zIGluY2x1ZGluZyB0aGVpciByZXR1cm4g
dmFsdWVzLiBJbiBvcmRlciB0byBkbyB0aGF0DQo+PiB0aGUgdmVyaWZpZXIgbmVlZHMgdG8gdHJh
Y2sgdHlwZXMgbm90IG9ubHkgb2Ygdm1saW51eCwgYnV0IHR5cGVzIG9mIG90aGVyIEJQRg0KPj4g
cHJvZ3JhbXMgYXMgd2VsbC4gVGhlIHZlcmlmaWVyIGFsc28gbmVlZHMgdG8gdHJhbnNsYXRlIHVh
cGkvbGludXgvYnBmLmggdHlwZXMNCj4+IHVzZWQgYnkgbmV0d29ya2luZyBwcm9ncmFtcyBpbnRv
IGtlcm5lbCBpbnRlcm5hbCBCVEYgdHlwZXMgdXNlZCBieSBGRU5UUlkvRkVYSVQNCj4+IEJQRiBw
cm9ncmFtcy4gSW4gc29tZSBjYXNlcyBMTFZNIG9wdGltaXphdGlvbnMgY2FuIHJlbW92ZSBhcmd1
bWVudHMgZnJvbSBCUEYNCj4+IHN1YnByb2dyYW1zIHdpdGhvdXQgYWRqdXN0aW5nIEJURiBpbmZv
IHRoYXQgTExWTSBiYWNrZW5kIGtub3dzLiBXaGVuIEJURiBpbmZvDQo+PiBkaXNhZ3JlZXMgd2l0
aCBhY3R1YWwgdHlwZXMgdGhhdCB0aGUgdmVyaWZpZXJzIHNlZXMgdGhlIEJQRiB0cmFtcG9saW5l
IGhhcyB0bw0KPj4gZmFsbGJhY2sgdG8gY29uc2VydmF0aXZlIGFuZCB0cmVhdCBhbGwgYXJndW1l
bnRzIGFzIHU2NC4gVGhlIEZFTlRSWS9GRVhJVA0KPj4gcHJvZ3JhbSBjYW4gc3RpbGwgYXR0YWNo
IHRvIHN1Y2ggc3VicHJvZ3JhbXMsIGJ1dCB3b24ndCBiZSBhYmxlIHRvIHJlY29nbml6ZQ0KPj4g
cG9pbnRlciB0eXBlcyBsaWtlICdzdHJ1Y3Qgc2tfYnVmZiAqJyBpbnRvIHdvbid0IGJlIGFibGUg
dG8gcGFzcyB0aGVtIHRvDQo+IAkJCQkJXl5eXl4gdGhlc2UgZmV3IHdvcmRzIGFyZSBjb25mdXNp
bmcNCg0KeWVwLiB3aWxsIGZpeC4NCg0KPj4gYnBmX3NrYl9vdXRwdXQoKSBmb3IgZHVtcGluZyB0
byB1c2VyIHNwYWNlLg0KPj4NCj4+IFRoZSBCUEZfUFJPR19MT0FEIGNvbW1hbmQgaXMgZXh0ZW5k
ZWQgd2l0aCBhdHRhY2hfcHJvZ19mZCBmaWVsZC4gV2hlbiBpdCdzIHNldA0KPj4gdG8gemVybyB0
aGUgYXR0YWNoX2J0Zl9pZCBpcyBvbmUgdm1saW51eCBCVEYgdHlwZSBpZHMuIFdoZW4gYXR0YWNo
X3Byb2dfZmQNCj4+IHBvaW50cyB0byBwcmV2aW91c2x5IGxvYWRlZCBCUEYgcHJvZ3JhbSB0aGUg
YXR0YWNoX2J0Zl9pZCBpcyBCVEYgdHlwZSBpZCBvZg0KPj4gbWFpbiBmdW5jdGlvbiBvciBvbmUg
b2YgaXRzIHN1YnByb2dyYW1zLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFyb3Zv
aXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+Pg0KPiANCj4gWy4uLl0NCj4gDQo+PiBkaWZmIC0tZ2l0
IGEva2VybmVsL2JwZi92ZXJpZmllci5jIGIva2VybmVsL2JwZi92ZXJpZmllci5jDQo+PiBpbmRl
eCBjZDlhOTM5NWM0YjUuLmYzODVjNDA0MzU5NCAxMDA2NDQNCj4+IC0tLSBhL2tlcm5lbC9icGYv
dmVyaWZpZXIuYw0KPj4gKysrIGIva2VybmVsL2JwZi92ZXJpZmllci5jDQo+PiBAQCAtOTM5MCwx
MyArOTM5MCwxNyBAQCBzdGF0aWMgdm9pZCBwcmludF92ZXJpZmljYXRpb25fc3RhdHMoc3RydWN0
IGJwZl92ZXJpZmllcl9lbnYgKmVudikNCj4+IHN0YXRpYyBpbnQgY2hlY2tfYXR0YWNoX2J0Zl9p
ZChzdHJ1Y3QgYnBmX3ZlcmlmaWVyX2VudiAqZW52KQ0KPj4gew0KPj4gCXN0cnVjdCBicGZfcHJv
ZyAqcHJvZyA9IGVudi0+cHJvZzsNCj4+ICsJc3RydWN0IGJwZl9wcm9nICp0Z3RfcHJvZyA9IHBy
b2ctPmF1eC0+bGlua2VkX3Byb2c7DQo+PiAJdTMyIGJ0Zl9pZCA9IHByb2ctPmF1eC0+YXR0YWNo
X2J0Zl9pZDsNCj4+IAljb25zdCBjaGFyIHByZWZpeFtdID0gImJ0Zl90cmFjZV8iOw0KPj4gCXN0
cnVjdCBicGZfdHJhbXBvbGluZSAqdHI7DQo+PiAJY29uc3Qgc3RydWN0IGJ0Zl90eXBlICp0Ow0K
Pj4gKwlpbnQgcmV0LCBzdWJwcm9nID0gLTEsIGk7DQo+PiArCWJvb2wgY29uc2VydmF0aXZlID0g
dHJ1ZTsNCj4+IAljb25zdCBjaGFyICp0bmFtZTsNCj4+ICsJc3RydWN0IGJ0ZiAqYnRmOw0KPj4g
CWxvbmcgYWRkcjsNCj4+IC0JaW50IHJldDsNCj4+ICsJdTY0IGtleTsNCj4+DQo+PiAJaWYgKHBy
b2ctPnR5cGUgIT0gQlBGX1BST0dfVFlQRV9UUkFDSU5HKQ0KPj4gCQlyZXR1cm4gMDsNCj4+IEBA
IC05NDA1LDE5ICs5NDA5LDQyIEBAIHN0YXRpYyBpbnQgY2hlY2tfYXR0YWNoX2J0Zl9pZChzdHJ1
Y3QgYnBmX3ZlcmlmaWVyX2VudiAqZW52KQ0KPj4gCQl2ZXJib3NlKGVudiwgIlRyYWNpbmcgcHJv
Z3JhbXMgbXVzdCBwcm92aWRlIGJ0Zl9pZFxuIik7DQo+PiAJCXJldHVybiAtRUlOVkFMOw0KPj4g
CX0NCj4+IC0JdCA9IGJ0Zl90eXBlX2J5X2lkKGJ0Zl92bWxpbnV4LCBidGZfaWQpOw0KPj4gKwli
dGYgPSBicGZfcHJvZ19nZXRfdGFyZ2V0X2J0Zihwcm9nKTsNCj4gDQo+IGJ0ZiBjb3VsZCBiZSBO
VUxMIGhlcmUsIHNvIHdlIG5lZWQgdG8gY2hlY2sgaXQ/DQoNCnllcC4gd2lsbCBmaXguDQo=
