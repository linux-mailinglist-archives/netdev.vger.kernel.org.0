Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA328E15
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbfEWXyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:54:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49902 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388232AbfEWXyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:54:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NNmCcf018247;
        Thu, 23 May 2019 16:54:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=enU7X23RI4GHxroSRqJoIDEFzLKvA+CjnQqusu0kdpE=;
 b=UUECZT72rdvVZpwJAUArod2PpVFjf5aunkRH8yMyIKkYvWCMgloULVsE0Xol0RuSCrrq
 CRnXwr1F3Jf3xoui+0r5bgj+o7uX2Kwgrh95G/vfKkwdZKlQ89SABnu3Zh+KZKrcQxrC
 Y852XlTEd2rVMFGYL55Aamvltlb9t0a5Fk4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2snx7s9n2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 May 2019 16:54:06 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 23 May 2019 16:54:05 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 16:54:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enU7X23RI4GHxroSRqJoIDEFzLKvA+CjnQqusu0kdpE=;
 b=ABu7pRtzg+oKj2Q7mFde6O90Hwq5GOiXlS0UBG6I972Vfk4fX8lX3kX9gtMADZ3GjnxeqXGhiuBecq7ziFYbNV1eW55njd7dWWxHytlO1Q4C+j1Yq+iwacD4qRv/A1xXOZzVQDkhXxclTGTmGTjQzEwBDjFFSwjwkTVv2s85Kyk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2774.namprd15.prod.outlook.com (20.179.158.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 23 May 2019 23:54:02 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 23:54:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
Thread-Topic: [PATCH bpf-next v2 1/3] bpf: implement bpf_send_signal() helper
Thread-Index: AQHVEGCw/a92LjZUiEmjMwkqdycEvaZ42yyA//+PhoCAAH2pAIAATdwA//+RRACAAJCOgIAADMmA
Date:   Thu, 23 May 2019 23:54:02 +0000
Message-ID: <99fb7b8f-e2b0-4601-bc3c-3fa8e250c15d@fb.com>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522053900.1663537-1-yhs@fb.com>
 <2c07890b-9da5-b4e8-dc94-35def14470ad@iogearbox.net>
 <6041511a-1628-868f-b4b1-e567c234a4a5@fb.com>
 <d863ad02-5151-3e3c-a276-404c9dc957b2@iogearbox.net>
 <bc855846-450f-bc0f-34e3-7219c95fb620@fb.com>
 <86aacfb6-614b-55cb-7fe8-9f2c5c63c126@fb.com>
 <5384a86c-94a4-f60f-2414-b8c68d152f57@iogearbox.net>
In-Reply-To: <5384a86c-94a4-f60f-2414-b8c68d152f57@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:104:5::34) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d011]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0da32995-9d35-4849-9946-08d6dfd9ee77
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2774;
x-ms-traffictypediagnostic: BYAPR15MB2774:
x-microsoft-antispam-prvs: <BYAPR15MB2774D06E2FECA2AD88527DBFD3010@BYAPR15MB2774.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(366004)(376002)(136003)(189003)(199004)(316002)(186003)(8676002)(2201001)(54906003)(110136005)(102836004)(53546011)(99286004)(53936002)(486006)(386003)(76176011)(46003)(36756003)(86362001)(31696002)(14454004)(476003)(6506007)(52116002)(2616005)(446003)(11346002)(478600001)(6246003)(4326008)(229853002)(6486002)(2906002)(68736007)(6116002)(25786009)(6436002)(31686004)(6512007)(73956011)(71190400001)(71200400001)(66946007)(66446008)(66556008)(66476007)(64756008)(5660300002)(81156014)(81166006)(14444005)(7736002)(256004)(305945005)(8936002)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2774;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uwe/XMTR8tCH07XZnJnvQIh94YyPIJfvae1NzWT1j/zUFs8wyvLWnbvlzIL5AYCB2rH7cczCGlgpSuYr3Oyjg/CVEynA6lGfG9G6q0ICQqohFLgtwADhLbjlar3ZWg2aZSKtRs5D7I/RGHTuVO+47vs8NCrKn9x8h8RS63Vk5OJYIrms+liPu0ajKvfFYTuSnTlIWaKtbTvS3nwZ/+90H84tjx1Vl6VljkVu/MEJngff+V2T36RtMKMYsda8j82UAV0jTBog2ie7ZbE65kUSOGjrbZJ6xUMk3OG04VLoouppM5gSLEk/dMzk6S7vKTS+ySuZ03nE82Wv1fAoSsrJgwFi04P2mfaiIKwf2XWZdi1MKQW5YWPmpL0SHpIDLMaBHLhFrabF6YYtpYhxxrnXGR7cQ7NFqBYuXfNt/N5yWW8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF36EB37EF8A0C4899028F620451DC7C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da32995-9d35-4849-9946-08d6dfd9ee77
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 23:54:02.4854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_18:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjMvMTkgNDowOCBQTSwgRGFuaWVsIEJvcmttYW5uIHdyb3RlOg0KPiBPbiAwNS8y
My8yMDE5IDExOjMwIFBNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4gT24gNS8yMy8xOSAyOjA3
IFBNLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4+IE9uIDUvMjMvMTkgOToyOCBBTSwgRGFuaWVs
IEJvcmttYW5uIHdyb3RlOg0KPj4+PiBPbiAwNS8yMy8yMDE5IDA1OjU4IFBNLCBZb25naG9uZyBT
b25nIHdyb3RlOg0KPj4+Pj4gT24gNS8yMy8xOSA4OjQxIEFNLCBEYW5pZWwgQm9ya21hbm4gd3Jv
dGU6DQo+Pj4+Pj4gT24gMDUvMjIvMjAxOSAwNzozOSBBTSwgWW9uZ2hvbmcgU29uZyB3cm90ZToN
Cj4+Pj4+Pj4gVGhpcyBwYXRjaCB0cmllcyB0byBzb2x2ZSB0aGUgZm9sbG93aW5nIHNwZWNpZmlj
IHVzZSBjYXNlLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBDdXJyZW50bHksIGJwZiBwcm9ncmFtIGNhbiBh
bHJlYWR5IGNvbGxlY3Qgc3RhY2sgdHJhY2VzDQo+Pj4+Pj4+IHRocm91Z2gga2VybmVsIGZ1bmN0
aW9uIGdldF9wZXJmX2NhbGxjaGFpbigpDQo+Pj4+Pj4+IHdoZW4gY2VydGFpbiBldmVudHMgaGFw
cGVucyAoZS5nLiwgY2FjaGUgbWlzcyBjb3VudGVyIG9yDQo+Pj4+Pj4+IGNwdSBjbG9jayBjb3Vu
dGVyIG92ZXJmbG93cykuIEJ1dCBzdWNoIHN0YWNrIHRyYWNlcyBhcmUNCj4+Pj4+Pj4gbm90IGVu
b3VnaCBmb3Igaml0dGVkIHByb2dyYW1zLCBlLmcuLCBoaHZtIChqaXRlZCBwaHApLg0KPj4+Pj4+
PiBUbyBnZXQgcmVhbCBzdGFjayB0cmFjZSwgaml0IGVuZ2luZSBpbnRlcm5hbCBkYXRhIHN0cnVj
dHVyZXMNCj4+Pj4+Pj4gbmVlZCB0byBiZSB0cmF2ZXJzZWQgaW4gb3JkZXIgdG8gZ2V0IHRoZSBy
ZWFsIHVzZXIgZnVuY3Rpb25zLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBicGYgcHJvZ3JhbSBpdHNlbGYg
bWF5IG5vdCBiZSB0aGUgYmVzdCBwbGFjZSB0byB0cmF2ZXJzZQ0KPj4+Pj4+PiB0aGUgaml0IGVu
Z2luZSBhcyB0aGUgdHJhdmVyc2luZyBsb2dpYyBjb3VsZCBiZSBjb21wbGV4IGFuZA0KPj4+Pj4+
PiBpdCBpcyBub3QgYSBzdGFibGUgaW50ZXJmYWNlIGVpdGhlci4NCj4+Pj4+Pj4NCj4+Pj4+Pj4g
SW5zdGVhZCwgaGh2bSBpbXBsZW1lbnRzIGEgc2lnbmFsIGhhbmRsZXIsDQo+Pj4+Pj4+IGUuZy4g
Zm9yIFNJR0FMQVJNLCBhbmQgYSBzZXQgb2YgcHJvZ3JhbSBsb2NhdGlvbnMgd2hpY2gNCj4+Pj4+
Pj4gaXQgY2FuIGR1bXAgc3RhY2sgdHJhY2VzLiBXaGVuIGl0IHJlY2VpdmVzIGEgc2lnbmFsLCBp
dCB3aWxsDQo+Pj4+Pj4+IGR1bXAgdGhlIHN0YWNrIGluIG5leHQgc3VjaCBwcm9ncmFtIGxvY2F0
aW9uLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBTdWNoIGEgbWVjaGFuaXNtIGNhbiBiZSBpbXBsZW1lbnRl
ZCBpbiB0aGUgZm9sbG93aW5nIHdheToNCj4+Pj4+Pj4gICAgICAgLiBhIHBlcmYgcmluZyBidWZm
ZXIgaXMgY3JlYXRlZCBiZXR3ZWVuIGJwZiBwcm9ncmFtDQo+Pj4+Pj4+ICAgICAgICAgYW5kIHRy
YWNpbmcgYXBwLg0KPj4+Pj4+PiAgICAgICAuIG9uY2UgYSBwYXJ0aWN1bGFyIGV2ZW50IGhhcHBl
bnMsIGJwZiBwcm9ncmFtIHdyaXRlcw0KPj4+Pj4+PiAgICAgICAgIHRvIHRoZSByaW5nIGJ1ZmZl
ciBhbmQgdGhlIHRyYWNpbmcgYXBwIGdldHMgbm90aWZpZWQuDQo+Pj4+Pj4+ICAgICAgIC4gdGhl
IHRyYWNpbmcgYXBwIHNlbmRzIGEgc2lnbmFsIFNJR0FMQVJNIHRvIHRoZSBoaHZtLg0KPj4+Pj4+
Pg0KPj4+Pj4+PiBCdXQgdGhpcyBtZXRob2QgY291bGQgaGF2ZSBsYXJnZSBkZWxheXMgYW5kIGNh
dXNpbmcgcHJvZmlsaW5nDQo+Pj4+Pj4+IHJlc3VsdHMgc2tld2VkLg0KPj4+Pj4+Pg0KPj4+Pj4+
PiBUaGlzIHBhdGNoIGltcGxlbWVudHMgYnBmX3NlbmRfc2lnbmFsKCkgaGVscGVyIHRvIHNlbmQN
Cj4+Pj4+Pj4gYSBzaWduYWwgdG8gaGh2bSBpbiByZWFsIHRpbWUsIHJlc3VsdGluZyBpbiBpbnRl
bmRlZCBzdGFjayB0cmFjZXMuDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFlvbmdo
b25nIFNvbmcgPHloc0BmYi5jb20+DQo+Pj4+Pj4+IC0tLQ0KPj4+Pj4+PiAgICAgIGluY2x1ZGUv
dWFwaS9saW51eC9icGYuaCB8IDE3ICsrKysrKysrKy0NCj4+Pj4+Pj4gICAgICBrZXJuZWwvdHJh
Y2UvYnBmX3RyYWNlLmMgfCA2NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+Pj4+Pj4+ICAgICAgMiBmaWxlcyBjaGFuZ2VkLCA4MyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+Pj4+Pj4+DQo+Pj4+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+Pj4+Pj4gaW5kZXggNjNlMGNm
NjZmMDFhLi42OGQ0NDcwNTIzYTAgMTAwNjQ0DQo+Pj4+Pj4+IC0tLSBhL2luY2x1ZGUvdWFwaS9s
aW51eC9icGYuaA0KPj4+Pj4+PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+Pj4+
Pj4gQEAgLTI2NzIsNiArMjY3MiwyMCBAQCB1bmlvbiBicGZfYXR0ciB7DQo+Pj4+Pj4+ICAgICAg
ICoJCTAgb24gc3VjY2Vzcy4NCj4+Pj4+Pj4gICAgICAgKg0KPj4+Pj4+PiAgICAgICAqCQkqKi1F
Tk9FTlQqKiBpZiB0aGUgYnBmLWxvY2FsLXN0b3JhZ2UgY2Fubm90IGJlIGZvdW5kLg0KPj4+Pj4+
PiArICoNCj4+Pj4+Pj4gKyAqIGludCBicGZfc2VuZF9zaWduYWwodTMyIHNpZykNCj4+Pj4+Pj4g
KyAqCURlc2NyaXB0aW9uDQo+Pj4+Pj4+ICsgKgkJU2VuZCBzaWduYWwgKnNpZyogdG8gdGhlIGN1
cnJlbnQgdGFzay4NCj4+Pj4+Pj4gKyAqCVJldHVybg0KPj4+Pj4+PiArICoJCTAgb24gc3VjY2Vz
cyBvciBzdWNjZXNzZnVsbHkgcXVldWVkLg0KPj4+Pj4+PiArICoNCj4+Pj4+Pj4gKyAqCQkqKi1F
QlVTWSoqIGlmIHdvcmsgcXVldWUgdW5kZXIgbm1pIGlzIGZ1bGwuDQo+Pj4+Pj4+ICsgKg0KPj4+
Pj4+PiArICoJCSoqLUVJTlZBTCoqIGlmICpzaWcqIGlzIGludmFsaWQuDQo+Pj4+Pj4+ICsgKg0K
Pj4+Pj4+PiArICoJCSoqLUVQRVJNKiogaWYgbm8gcGVybWlzc2lvbiB0byBzZW5kIHRoZSAqc2ln
Ki4NCj4+Pj4+Pj4gKyAqDQo+Pj4+Pj4+ICsgKgkJKiotRUFHQUlOKiogaWYgYnBmIHByb2dyYW0g
Y2FuIHRyeSBhZ2Fpbi4NCj4+Pj4+Pj4gICAgICAgKi8NCj4+Pj4+Pj4gICAgICAjZGVmaW5lIF9f
QlBGX0ZVTkNfTUFQUEVSKEZOKQkJXA0KPj4+Pj4+PiAgICAgIAlGTih1bnNwZWMpLAkJCVwNCj4+
Pj4+Pj4gQEAgLTI3ODIsNyArMjc5Niw4IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4+Pj4+Pj4gICAg
ICAJRk4oc3RydG9sKSwJCQlcDQo+Pj4+Pj4+ICAgICAgCUZOKHN0cnRvdWwpLAkJCVwNCj4+Pj4+
Pj4gICAgICAJRk4oc2tfc3RvcmFnZV9nZXQpLAkJXA0KPj4+Pj4+PiAtCUZOKHNrX3N0b3JhZ2Vf
ZGVsZXRlKSwNCj4+Pj4+Pj4gKwlGTihza19zdG9yYWdlX2RlbGV0ZSksCQlcDQo+Pj4+Pj4+ICsJ
Rk4oc2VuZF9zaWduYWwpLA0KPj4+Pj4+PiAgICAgIA0KPj4+Pj4+PiAgICAgIC8qIGludGVnZXIg
dmFsdWUgaW4gJ2ltbScgZmllbGQgb2YgQlBGX0NBTEwgaW5zdHJ1Y3Rpb24gc2VsZWN0cyB3aGlj
aCBoZWxwZXINCj4+Pj4+Pj4gICAgICAgKiBmdW5jdGlvbiBlQlBGIHByb2dyYW0gaW50ZW5kcyB0
byBjYWxsDQo+Pj4+Pj4+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgYi9r
ZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+Pj4+Pj4gaW5kZXggZjkyZDZhZDVlMDgwLi5mOGNk
MGRiNzI4OWYgMTAwNjQ0DQo+Pj4+Pj4+IC0tLSBhL2tlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0K
Pj4+Pj4+PiArKysgYi9rZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4+Pj4+Pj4gQEAgLTU2Nyw2
ICs1NjcsNTggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfcHJvYmVf
cmVhZF9zdHJfcHJvdG8gPSB7DQo+Pj4+Pj4+ICAgICAgCS5hcmczX3R5cGUJPSBBUkdfQU5ZVEhJ
TkcsDQo+Pj4+Pj4+ICAgICAgfTsNCj4+Pj4+Pj4gICAgICANCj4+Pj4+Pj4gK3N0cnVjdCBzZW5k
X3NpZ25hbF9pcnFfd29yayB7DQo+Pj4+Pj4+ICsJc3RydWN0IGlycV93b3JrIGlycV93b3JrOw0K
Pj4+Pj4+PiArCXUzMiBzaWc7DQo+Pj4+Pj4+ICt9Ow0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICtzdGF0
aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrLCBzZW5kX3NpZ25h
bF93b3JrKTsNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArc3RhdGljIHZvaWQgZG9fYnBmX3NlbmRfc2ln
bmFsKHN0cnVjdCBpcnFfd29yayAqZW50cnkpDQo+Pj4+Pj4+ICt7DQo+Pj4+Pj4+ICsJc3RydWN0
IHNlbmRfc2lnbmFsX2lycV93b3JrICp3b3JrOw0KPj4+Pj4+PiArDQo+Pj4+Pj4+ICsJd29yayA9
IGNvbnRhaW5lcl9vZihlbnRyeSwgc3RydWN0IHNlbmRfc2lnbmFsX2lycV93b3JrLCBpcnFfd29y
ayk7DQo+Pj4+Pj4+ICsJZ3JvdXBfc2VuZF9zaWdfaW5mbyh3b3JrLT5zaWcsIFNFTkRfU0lHX1BS
SVYsIGN1cnJlbnQsIFBJRFRZUEVfVEdJRCk7DQo+Pj4+Pj4+ICt9DQo+Pj4+Pj4+ICsNCj4+Pj4+
Pj4gK0JQRl9DQUxMXzEoYnBmX3NlbmRfc2lnbmFsLCB1MzIsIHNpZykNCj4+Pj4+Pj4gK3sNCj4+
Pj4+Pj4gKwlzdHJ1Y3Qgc2VuZF9zaWduYWxfaXJxX3dvcmsgKndvcmsgPSBOVUxMOw0KPj4+Pj4+
PiArDQo+Pj4+Pj4+ICsJLyogU2ltaWxhciB0byBicGZfcHJvYmVfd3JpdGVfdXNlciwgdGFzayBu
ZWVkcyB0byBiZQ0KPj4+Pj4+PiArCSAqIGluIGEgc291bmQgY29uZGl0aW9uIGFuZCBrZXJuZWwg
bWVtb3J5IGFjY2VzcyBiZQ0KPj4+Pj4+PiArCSAqIHBlcm1pdHRlZCBpbiBvcmRlciB0byBzZW5k
IHNpZ25hbCB0byB0aGUgY3VycmVudA0KPj4+Pj4+PiArCSAqIHRhc2suDQo+Pj4+Pj4+ICsJICov
DQo+Pj4+Pj4+ICsJaWYgKHVubGlrZWx5KGN1cnJlbnQtPmZsYWdzICYgKFBGX0tUSFJFQUQgfCBQ
Rl9FWElUSU5HKSkpDQo+Pj4+Pj4+ICsJCXJldHVybiAtRVBFUk07DQo+Pj4+Pj4+ICsJaWYgKHVu
bGlrZWx5KHVhY2Nlc3Nfa2VybmVsKCkpKQ0KPj4+Pj4+PiArCQlyZXR1cm4gLUVQRVJNOw0KPj4+
Pj4+PiArCWlmICh1bmxpa2VseSghbm1pX3VhY2Nlc3Nfb2theSgpKSkNCj4+Pj4+Pj4gKwkJcmV0
dXJuIC1FUEVSTTsNCj4+Pj4+Pj4gKw0KPj4+Pj4+PiArCWlmIChpbl9ubWkoKSkgew0KPj4+Pj4+
DQo+Pj4+Pj4gSG0sIGJpdCBjb25mdXNlZCwgY2FuJ3QgdGhpcyBvbmx5IGJlIGRvbmUgb3V0IG9m
IHByb2Nlc3MgY29udGV4dCBpbg0KPj4+Pj4+IGdlbmVyYWwgc2luY2Ugb25seSB0aGVyZSBjdXJy
ZW50IHBvaW50cyB0byBlLmcuIGhodm0/IEknbSBwcm9iYWJseQ0KPj4+Pj4+IG1pc3Npbmcgc29t
ZXRoaW5nLiBDb3VsZCB5b3UgZWxhYm9yYXRlPw0KPj4+Pj4NCj4+Pj4+IFRoYXQgaXMgdHJ1ZS4g
SWYgaW4gbm1pLCBpdCBpcyBvdXQgb2YgcHJvY2VzcyBjb250ZXh0IGFuZCBpbiBubWkNCj4+Pj4+
IGNvbnRleHQsIHdlIHVzZSBhbiBpcnFfd29yayBoZXJlIHNpbmNlIGdyb3VwX3NlbmRfc2lnX2lu
Zm8oKSBoYXMNCj4+Pj4+IHNwaW5sb2NrIGluc2lkZS4gVGhlIGJwZiBwcm9ncmFtIChlLmcuLCBh
IHBlcmZfZXZlbnQgcHJvZ3JhbSkgbmVlZHMgdG8NCj4+Pj4+IGNoZWNrIGl0IGlzIHdpdGggcmln
aHQgY3VycmVudCAoZS5nLiwgYnkgcGlkKSBiZWZvcmUgY2FsbGluZw0KPj4+Pj4gdGhpcyBoZWxw
ZXIuDQo+Pj4+Pg0KPj4+Pj4gRG9lcyB0aGlzIGFkZHJlc3MgeW91ciBxdWVzdGlvbj8NCj4+Pg0K
Pj4+IFRoYW5rcywgRGFuaWVsLiBUaGUgYmVsb3cgYXJlIHJlYWxseSBnb29kIHF1ZXN0aW9ucyB3
aGljaCBJIGRpZCBub3QNCj4+PiByZWFsbHkgdGhpbmsgdGhyb3VnaCB3aXRoIGlycV93b3JrLg0K
Pj4+DQo+Pj4+IEhtLCBidXQgaG93IGlzIGl0IGd1YXJhbnRlZWQgdGhhdCAnY3VycmVudCcgaW5z
aWRlIHRoZSBjYWxsYmFjayBpcyBzdGlsbA0KPj4+PiB0aGUgdmVyeSBzYW1lIHlvdSBpbnRlbmQg
dG8gc2VuZCB0aGUgc2lnbmFsIHRvPw0KPj4+DQo+Pj4gSSB3ZW50IHRocm91Z2ggaXJxX3dvcmsg
aW5mcmFzdHJ1Y3R1cmUuIEl0IGxvb2tzIHRoYXQgImN1cnJlbnQiIG1heQ0KPj4+IGNoYW5nZS4g
aXJxX3dvcmsgaXMgcmVnaXN0ZXJlZCBhcyBhbiBpbnRlcnJ1cHQgb24geDg2Lg0KPj4+IEFmdGVy
IG5taSwgc29tZSBsb3dlciBwcmlvcml0eQ0KPj4+IGludGVycnVwdHMgZ2V0IGNoYW5jZXMgdG8g
ZXhlY3V0ZSBpbmNsdWRpbmcgaXJxX3dvcmsuIEJ1dCB0aGVyZSBhcmUgc29tZQ0KPj4+IG90aGVy
IGludGVycnVwdHMgbGlrZSB0aW1lcl9pbnRlcnJ1cHQgYW5kIHJlc2NoZWR1bGVfaW50ZXJydXB0
IG1heQ0KPj4+IGNoYW5nZSAiY3VycmVudCIuIEJ1dCBzaW5jZSB3ZSBhcmUgc3RpbGwgaW4gaW50
ZXJydXB0IGNvbnRleHQsIHRhc2sNCj4+PiBzaG91bGQgbm90IGJlIGRlc3Ryb3llZCwgc28gdGhl
IHRhc2sgc3RydWN0dXJlIHBvaW50ZXIgaXMgc3RpbGwgdmFsaWQuDQo+Pj4NCj4+PiBJIHdpbGwg
cGFzcyAiY3VycmVudCIgdGFzayBzdHJ1Y3QgcG9pbnRlciB0byBpcnFfd29yayBhcyB3ZWxsLiBU
aGlzDQo+Pj4gaXMgc2ltaWxhciB0byB3aGF0IHdlIGRpZCBpbiBzdGFja21hcC5jOg0KPj4+ICAg
ICAgd29yay0+c2VtID0gJmN1cnJlbnQtPm1tLT5tbWFwX3NlbTsNCj4+PiAgICAgIGlycV93b3Jr
X3F1ZXVlKCZ3b3JrLT5pcnFfd29yayk7DQo+Pj4gQXQgaXJxX3dvcmtfcnVuKCkgdGltZSwgdGhl
IHByZXZpb3VzICJjdXJyZW50IiBpbiBubWkgc2hvdWxkIHN0aWxsIGJlDQo+Pj4gdmFsaWQuDQo+
Pj4NCj4+Pj4gV2hhdCBoYXBwZW5zIGlmIHlvdSdyZSBpbiBzb2Z0aXJxIGFuZCBzZW5kIFNJR0tJ
TEwgdG8geW91cnNlbGY/IElzIHRoaXMNCj4+Pj4gaWdub3JlZC9oYW5kbGVkIGdyYWNlZnVsbHkg
aW4gc3VjaCBjYXNlPw0KPj4+DQo+Pj4gSXQgaXMgbm90IGlnbm9yZWQuIEl0IGhhbmRsZWQgZ3Jh
Y2VmdWxseSBpbiB0aGlzIGNhc2UuIEkgdHJpZWQgbXkNCj4+PiBleGFtcGxlIHRvIHNlbmQgU0lH
S0lMTC4gVGhlIGNhbGwgc3RhY2sgbG9va3MgYmVsb3cuDQo+Pj4NCj4+PiBbICAgMjQuMjExOTQz
XSAgYnBmX3NlbmRfc2lnbmFsKzB4OS8weGIwDQo+Pj4gWyAgIDI0LjIxMjQyN10gIGJwZl9wcm9n
X2ZlYzZlN2NjNjY0ZDViOTFfYnBmX3NlbmRfc2lnbmFsX3Rlc3QrMHgyMjgvMHgxMDAwDQo+Pj4g
WyAgIDI0LjIxMzI0OV0gID8gYnBmX292ZXJmbG93X2hhbmRsZXIrMHhiNy8weDE4MA0KPj4+IFsg
ICAyNC4yMTM4NTNdICA/IF9fcGVyZl9ldmVudF9vdmVyZmxvdysweDUxLzB4ZTANCj4+PiBbICAg
MjQuMjE0Mzg1XSAgPyBwZXJmX3N3ZXZlbnRfaHJ0aW1lcisweDEwYS8weDE2MA0KPj4+IFsgICAy
NC4yMTQ5NjVdICA/IF9fdXBkYXRlX2xvYWRfYXZnX2Nmc19ycSsweDFhOS8weDFjMA0KPj4+IFsg
ICAyNC4yMTU2MDldICA/IHRhc2tfdGlja19mYWlyKzB4NTAvMHg2OTANCj4+PiBbICAgMjQuMjE2
MTA0XSAgPyBydW5fdGltZXJfc29mdGlycSsweDIwOC8weDQ5MA0KPj4+IFsgICAyNC4yMTY2Mzdd
ICA/IHRpbWVycXVldWVfZGVsKzB4MWUvMHg0MA0KPj4+IFsgICAyNC4yMTcxMTFdICA/IHRhc2tf
Y2xvY2tfZXZlbnRfZGVsKzB4MTAvMHgxMA0KPj4+IFsgICAyNC4yMTc2NThdICA/IF9faHJ0aW1l
cl9ydW5fcXVldWVzKzB4MTBkLzB4MmMwDQo+Pj4gWyAgIDI0LjIxODIxN10gID8gaHJ0aW1lcl9p
bnRlcnJ1cHQrMHgxMjIvMHgyNzANCj4+PiBbICAgMjQuMjE4NzY1XSAgPyByY3VfaXJxX2VudGVy
KzB4MzEvMHgxMTANCj4+PiBbICAgMjQuMjE5MjIzXSAgPyBzbXBfYXBpY190aW1lcl9pbnRlcnJ1
cHQrMHg2Ny8weDE2MA0KPj4+IFsgICAyNC4yMTk4NDJdICA/IGFwaWNfdGltZXJfaW50ZXJydXB0
KzB4Zi8weDIwDQo+Pj4gWyAgIDI0LjIyMDM4M10gIDwvSVJRPg0KPj4+IFsgICAyNC4yMjA2NTVd
ICA/IGV2ZW50X3NjaGVkX291dC5pc3JhLjEwOCsweDE1MC8weDE1MA0KPj4+IFsgICAyNC4yMjEy
NzFdICA/IHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweGRjLzB4MTAwDQo+Pj4gWyAgIDI0LjIy
MTg5OF0gID8gcGVyZl9ldmVudF9zeXNmc19zaG93KzB4MjAvMHgyMA0KPj4+IFsgICAyNC4yMjI0
NjldICA/IGNwdV9mdW5jdGlvbl9jYWxsKzB4NDIvMHg2MA0KPj4+IFsgICAyNC4yMjI5ODJdICA/
IGNwdV9jbG9ja19ldmVudF9yZWFkKzB4MTAvMHgxMA0KPj4+IFsgICAyNC4yMjM1MjVdICA/IGV2
ZW50X2Z1bmN0aW9uX2NhbGwrMHhlNi8weGYwDQo+Pj4gWyAgIDI0LjIyNDA1M10gID8gZXZlbnRf
c2NoZWRfb3V0LmlzcmEuMTA4KzB4MTUwLzB4MTUwDQo+Pj4gWyAgIDI0LjIyNDY1N10gID8gcGVy
Zl9yZW1vdmVfZnJvbV9jb250ZXh0KzB4MjAvMHg3MA0KPj4+IFsgICAyNC4yMjUyNjJdICA/IHBl
cmZfZXZlbnRfcmVsZWFzZV9rZXJuZWwrMHgxMDYvMHgyZTANCj4+PiBbICAgMjQuMjI1ODk2XSAg
PyBwZXJmX3JlbGVhc2UrMHhjLzB4MTANCj4+PiBbICAgMjQuMjI2MzQ3XSAgPyBfX2ZwdXQrMHhj
OS8weDIzMA0KPj4+IFsgICAyNC4yMjY3NjddICA/IHRhc2tfd29ya19ydW4rMHg4My8weGIwDQo+
Pj4gWyAgIDI0LjIyNzI0M10gID8gZG9fZXhpdCsweDMwMC8weGM1MA0KPj4+IFsgICAyNC4yMjc2
NzRdICA/IHN5c2NhbGxfdHJhY2VfZW50ZXIrMHgxYzkvMHgyZDANCj4+PiBbICAgMjQuMjI4MjIz
XSAgPyBkb19ncm91cF9leGl0KzB4MzkvMHhiMA0KPj4+IFsgICAyNC4yMjg2OTVdICA/IF9feDY0
X3N5c19leGl0X2dyb3VwKzB4MTQvMHgyMA0KPj4+IFsgICAyNC4yMjkyNzBdICA/IGRvX3N5c2Nh
bGxfNjQrMHg0OS8weDEzMA0KPj4+IFsgICAyNC4yMjk3NjJdICA/IGVudHJ5X1NZU0NBTExfNjRf
YWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkNCj4+Pg0KPj4+IEkgc2VlIHRoZSB0YXNrIGlzIGtpbGxl
ZCBhbmQgb3RoZXIgcHJvY2VzcyBpcyBub3QgaW1wYWN0ZWQgYW5kDQo+Pj4gbm8ga2VybmVsIGNy
YXNoL3dhcm5pbmcuDQo+IA0KPiBIbSwgYnV0IEkgcmF0aGVyIG1lYW50IHdoZW4geW91IGhhdmUg
dGhlIGNhc2UgdGhhdCB3ZSdyZSBpbl9zZXJ2aW5nX3NvZnRpcnEoKQ0KPiBlLmcuIHdoZW4gcHJv
Y2Vzc2luZyBwYWNrZXRzIG9uIHJ4IGFuZCB5b3Ugc2VuZCBhIHNpZ25hbCB0byB5b3Vyc2VsZi4g
U2hvdWxkbid0DQo+IHdlIGJhaWwgb3V0IGZyb20gdGhlIGhlbHBlciBpbiBzdWNoIHNpdHVhdGlv
biBhcyB3ZWxsPw0KDQpKdXN0IHdhbnQgdG8gY2xhcmlmeS4gQXJlIHlvdSBjb25jZXJuZWQgd2l0
aCBzYWZldHkgb3IgY29ycmVjdG5lc3M/DQoNCkZvciBzYWZldHksIGlmIHdlIGRvIHNlbmQgc2ln
bmFsIGhlcmUsIHdlIG1heSB3cmVjayB0aGUgc3lzdGVtPw0KDQpGb3IgY29ycmVjdG5lc3MsIHlv
dSBtZWFuIHRoZSBpbmZvcm1hdGlvbiB3ZSBnb3QgdG8gc2VuZCBhIHNpZ25hbA0KdG8gcHJvY2Vz
cyBpcyBub3QgcXVpdGUgcmlnaHQgaWYgaW5fc2VydmluZ19zb2Z0aXJxKCk/IEYuZSwNCnRoZSBw
ZXJmb3JtYW5jZSBjb3VudGVyIG92ZXJmbG93IG1heSBiZSBjYXVzZWQgYnkgc29mdGlycSByYXRo
ZXINCnRoZSBwcm9jZXNzIGl0c2VsZj8gU28gaW4gdGhpcyBjYXNlLCB3ZSBzaG91bGQgb25seSBz
ZW5kIHNpZ25hbA0KdG8gcHJvY2VzcyB3aGVuIGluIHByb2Nlc3MgY29udGV4dCwgYW5kIGluIG5t
aSAobm90IHNlcnZpbmcgc29mdGlycSk/DQoNCklmIGZvciBjb3JyZWN0bmVzcywgZG8geW91IHRo
aW5rIHdlIHNob3VsZCBhZGQgYSAiZmxhZ3MiIHBhcmFtZXRlcg0KdG8gdGhlIGJwZl9zZW5kX3Np
Z25hbCgpIGhlbHBlciBzdWNoIHRoYXQ6DQogICAgLiBkZWZhdWx0IG5vdCBjaGVja2luZyBpc19z
ZXJ2aW5nX3NvZnRpcnEoKQ0KICAgIC4gYml0MDogaWYgc2V0LCBiYWlsIG91dCBpZiBpc19zZXJ2
aW5nX3NvZnRpcnEoKQ0KICAgIC4gb3RoZXIgYml0czogcmVzZXJ2ZWQNCg0KPiANCj4gVGhhbmtz
LA0KPiBEYW5pZWwNCj4gDQo=
