Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C85A64F95
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfGKAhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 20:37:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbfGKAhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 20:37:16 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6B0W8gp018518;
        Wed, 10 Jul 2019 17:36:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TjZGCnodWjgnXR1ZQDzyNaKTiHTW//DSfuyANWnyGzg=;
 b=lrtx3p1MhYpOziQQPg2of/x8LhNtmLFlP80j/VrJBs6FbPqV31/9ccJxiAhj8fGc2t86
 auofECM+/28idZ44dzwXE2h1Qt0n3pRhPyWYsl6ppXZDVpMZho70EteewatH+gRCbQ+z
 UUiAb5s5eTuaC5LFUwjv88wvdMXNVrWlabE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2tmxrb5y8n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 17:36:54 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 10 Jul 2019 17:36:52 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 10 Jul 2019 17:36:52 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 10 Jul 2019 17:36:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjZGCnodWjgnXR1ZQDzyNaKTiHTW//DSfuyANWnyGzg=;
 b=D19kxCQErEC6u4fQ0OHHI2RhvnKiwa2Hf/6iNPx+BPxRxSM79arg+2CDjTk3cHrPrTuSuFNPN6rbvrzA/ncCdiSG0JZXL5ajCjS8+FS0rdYc0o8ZdnvzUNa49nBksvLdB8dCGkRvOBiEcD91EZklNiFOfBPPrfLiqnvYQri9wRM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2855.namprd15.prod.outlook.com (20.178.206.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 11 Jul 2019 00:36:36 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Thu, 11 Jul 2019
 00:36:35 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Thread-Topic: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Thread-Index: AQHVNvb9OTRSXZV6J0yyn1q3qDFOw6bEGJAAgAB44wCAAAH/gA==
Date:   Thu, 11 Jul 2019 00:36:35 +0000
Message-ID: <304d8535-5043-836d-2933-1a5efb7aec72@fb.com>
References: <20190710080840.2613160-1-andriin@fb.com>
 <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
 <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com>
In-Reply-To: <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0022.namprd16.prod.outlook.com (2603:10b6:907::35)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e95c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1d84ca0-043d-49f2-5a0c-08d70597d451
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2855;
x-ms-traffictypediagnostic: BYAPR15MB2855:
x-microsoft-antispam-prvs: <BYAPR15MB2855A3D1FF7462BF3EBB9EE4D3F30@BYAPR15MB2855.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(396003)(136003)(346002)(376002)(199004)(189003)(81166006)(66946007)(99286004)(81156014)(316002)(31696002)(7736002)(54906003)(86362001)(8936002)(14444005)(102836004)(446003)(8676002)(6436002)(186003)(386003)(305945005)(52116002)(76176011)(66446008)(64756008)(66556008)(66476007)(14454004)(6506007)(53546011)(2906002)(68736007)(6512007)(6916009)(25786009)(53936002)(6486002)(256004)(486006)(4326008)(6116002)(36756003)(46003)(6246003)(11346002)(476003)(229853002)(2616005)(478600001)(71190400001)(71200400001)(5660300002)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2855;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cJJH44yUJFTotH1txrn+b7Jfhe3vPqtXfiZrWwUHTwZ77yTJ9d6jWDf9V/UM/tSrqA1W4A67gLyEFSSFN4RSsBEFwReTwA6PqztDCyam6qspPqHIc/yq5noIMEPNuKqesyRs3pkoq5BAyuPTuBtINXeSWGEnS+p0dBgv8ELclWOoCLn/nT1qR57L0gK50LE0sMDg/IJSR3XkdjrnI+jSGKn6IZzxlS6hSZZV7TBaga4VSX88/QOWcLCYO6yRGwzXcDDD04nl+PHDUPaIRuigoH2S0kTBV7e2cyVfuVCmZTIvP1Xkjwyhp5+ImDCxO32LazHg5xd3g80clFN7D35ia4rtbbeyCx0wx2fpCEv+D+1qyHoZTANy0JpWh53s7uYSfVseDmOrI7pjP/4Fq2IQ0OMiWQyqpFUPz+rl9snvExQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C019581B6C66747B4309DA4FF93BB6B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d84ca0-043d-49f2-5a0c-08d70597d451
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 00:36:35.8645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2855
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=795 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTAvMTkgNToyOSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBXZWQs
IEp1bCAxMCwgMjAxOSBhdCA1OjE2IFBNIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdyb3Rl
Og0KPj4NCj4+DQo+Pg0KPj4gT24gNy8xMC8xOSAxOjA4IEFNLCBBbmRyaWkgTmFrcnlpa28gd3Jv
dGU6DQo+Pj4gQlRGIHZlcmlmaWVyIGhhcyBEaWZmZXJlbnQgbG9naWMgZGVwZW5kaW5nIG9uIHdo
ZXRoZXIgd2UgYXJlIGZvbGxvd2luZw0KPj4+IGEgUFRSIG9yIFNUUlVDVC9BUlJBWSAob3Igc29t
ZXRoaW5nIGVsc2UpLiBUaGlzIGlzIGFuIG9wdGltaXphdGlvbiB0bw0KPj4+IHN0b3AgZWFybHkg
aW4gREZTIHRyYXZlcnNhbCB3aGlsZSByZXNvbHZpbmcgQlRGIHR5cGVzLiBCdXQgaXQgYWxzbw0K
Pj4+IHJlc3VsdHMgaW4gYSBzaXplIHJlc29sdXRpb24gYnVnLCB3aGVuIHRoZXJlIGlzIGEgY2hh
aW4sIGUuZy4sIG9mIFBUUiAtPg0KPj4+IFRZUEVERUYgLT4gQVJSQVksIGluIHdoaWNoIGNhc2Ug
ZHVlIHRvIGJlaW5nIGluIHBvaW50ZXIgY29udGV4dCBBUlJBWQ0KPj4+IHNpemUgd29uJ3QgYmUg
cmVzb2x2ZWQsIGFzIGl0IGlzIGNvbnNpZGVyZWQgdG8gYmUgYSBzaW5rIGZvciBwb2ludGVyLA0K
Pj4+IGxlYWRpbmcgdG8gVFlQRURFRiBiZWluZyBpbiBSRVNPTFZFRCBzdGF0ZSB3aXRoIHplcm8g
c2l6ZSwgd2hpY2ggaXMNCj4+PiBjb21wbGV0ZWx5IHdyb25nLg0KPj4+DQo+Pj4gT3B0aW1pemF0
aW9uIGlzIGRvdWJ0ZnVsLCB0aG91Z2gsIGFzIGJ0Zl9jaGVja19hbGxfdHlwZXMoKSB3aWxsIGl0
ZXJhdGUNCj4+PiBvdmVyIGFsbCBCVEYgdHlwZXMgYW55d2F5cywgc28gdGhlIG9ubHkgc2F2aW5n
IGlzIGEgcG90ZW50aWFsbHkgc2xpZ2h0bHkNCj4+PiBzaG9ydGVyIHN0YWNrLiBCdXQgY29ycmVj
dG5lc3MgaXMgbW9yZSBpbXBvcnRhbnQgdGhhdCB0aW55IHNhdmluZ3MuDQo+Pj4NCj4+PiBUaGlz
IGJ1ZyBtYW5pZmVzdHMgaXRzZWxmIGluIHJlamVjdGluZyBCVEYtZGVmaW5lZCBtYXBzIHRoYXQg
dXNlIGFycmF5DQo+Pj4gdHlwZWRlZiBhcyBhIHZhbHVlIHR5cGU6DQo+Pj4NCj4+PiB0eXBlZGVm
IGludCBhcnJheV90WzE2XTsNCj4+Pg0KPj4+IHN0cnVjdCB7DQo+Pj4gICAgICAgIF9fdWludCh0
eXBlLCBCUEZfTUFQX1RZUEVfQVJSQVkpOw0KPj4+ICAgICAgICBfX3R5cGUodmFsdWUsIGFycmF5
X3QpOyAvKiBpLmUuLCBhcnJheV90ICp2YWx1ZTsgKi8NCj4+PiB9IHRlc3RfbWFwIFNFQygiLm1h
cHMiKTsNCj4+Pg0KPj4+IEZpeGVzOiBlYjNmNTk1ZGFiNDAgKCJicGY6IGJ0ZjogVmFsaWRhdGUg
dHlwZSByZWZlcmVuY2UiKQ0KPj4+IENjOiBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+
DQo+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+
DQo+PiBUaGUgY2hhbmdlIHNlZW1zIG9rYXkgdG8gbWUuIEN1cnJlbnRseSwgbG9va3MgbGlrZSBp
bnRlcm1lZGlhdGUNCj4+IG1vZGlmaWVyIHR5cGUgd2lsbCBjYXJyeSBzaXplID0gMCAoaW4gdGhl
IGludGVybmFsIGRhdGEgc3RydWN0dXJlKS4NCj4gDQo+IFllcywgd2hpY2ggaXMgdG90YWxseSB3
cm9uZywgZXNwZWNpYWxseSB0aGF0IHdlIHVzZSB0aGF0IHNpemUgaW4gc29tZQ0KPiBjYXNlcyB0
byByZWplY3QgbWFwIHdpdGggc3BlY2lmaWVkIEJURi4NCj4gDQo+Pg0KPj4gSWYgd2UgcmVtb3Zl
IFJFU09MVkUgbG9naWMsIHdlIHByb2JhYmx5IHdhbnQgdG8gZG91YmxlIGNoZWNrDQo+PiB3aGV0
aGVyIHdlIGhhbmRsZSBjaXJjdWxhciB0eXBlcyBjb3JyZWN0bHkgb3Igbm90LiBNYXliZSB3ZSB3
aWxsDQo+PiBiZSBva2F5IGlmIGFsbCBzZWxmIHRlc3RzIHBhc3MuDQo+IA0KPiBJIGNoZWNrZWQs
IGl0IGRvZXMuIFdlJ2xsIGF0dGVtcHQgdG8gYWRkIHJlZmVyZW5jZWQgdHlwZSB1bmxlc3MgaXQn
cyBhDQo+ICJyZXNvbHZlIHNpbmsiICh3aGVyZSBzaXplIGlzIGltbWVkaWF0ZWx5IGtub3duKSBv
ciBpcyBhbHJlYWR5DQo+IHJlc29sdmVkIChpdCdzIHN0YXRlIGlzIFJFU09MVkVEKS4gSW4gb3Ro
ZXIgY2FzZXMsIHdlJ2xsIGF0dGVtcHQgdG8NCj4gZW52X3N0YWNrX3B1c2goKSwgd2hpY2ggY2hl
Y2sgdGhhdCB0aGUgc3RhdGUgb2YgdGhhdCB0eXBlIGlzDQo+IE5PVF9WSVNJVEVELiBJZiBpdCdz
IFJFU09MVkVEIG9yIFZJU0lURUQsIGl0IHJldHVybnMgLUVFWElTVFMuIFdoZW4NCj4gdHlwZSBp
cyBhZGRlZCBpbnRvIHRoZSBzdGFjaywgaXQncyByZXNvbHZlIHN0YXRlIGdvZXMgZnJvbSBOT1Rf
VklTSVRFRA0KPiB0byBWSVNJVEVELg0KPiANCj4gU28sIGlmIHRoZXJlIGlzIGEgbG9vcCwgdGhl
biB3ZSdsbCBkZXRlY3QgaXQgYXMgc29vbiBhcyB3ZSdsbCBhdHRlbXB0DQo+IHRvIGFkZCB0aGUg
c2FtZSB0eXBlIG9udG8gdGhlIHN0YWNrIHNlY29uZCB0aW1lLg0KPiANCj4+DQo+PiBJIG1heSBz
dGlsbCBiZSB3b3J0aHdoaWxlIHRvIHF1YWxpZnkgdGhlIFJFU09MVkUgb3B0aW1pemF0aW9uIGJl
bmVmaXQNCj4+IGJlZm9yZSByZW1vdmluZyBpdC4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhlcmUg
aXMgYW55LCBiZWNhdXNlIGV2ZXJ5IHR5cGUgd2lsbCBiZSB2aXNpdGVkIGV4YWN0bHkNCj4gb25j
ZSwgZHVlIHRvIERGUyBuYXR1cmUgb2YgYWxnb3JpdGhtLiBUaGUgb25seSBkaWZmZXJlbmNlIGlz
IHRoYXQgaWYNCj4gd2UgaGF2ZSBhIGxvbmcgY2hhaW4gb2YgbW9kaWZpZXJzLCB3ZSBjYW4gdGVj
aG5pY2FsbHkgcmVhY2ggdGhlIG1heA0KPiBsaW1pdCBhbmQgZmFpbC4gQnV0IGF0IDMyIEkgdGhp
bmsgaXQncyBwcmV0dHkgdW5yZWFsaXN0aWMgdG8gaGF2ZSBzdWNoDQo+IGEgbG9uZyBjaGFpbiBv
ZiBQVFIvVFlQRURFRi9DT05TVC9WT0xBVElMRS9SRVNUUklDVHMgOikNCj4gDQo+Pg0KPj4gQW5v
dGhlciBwb3NzaWJsZSBjaGFuZ2UgaXMsIGZvciBleHRlcm5hbCB1c2FnZSwgcmVtb3ZpbmcNCj4+
IG1vZGlmaWVycywgYmVmb3JlIGNoZWNraW5nIHRoZSBzaXplLCBzb21ldGhpbmcgbGlrZSBiZWxv
dy4NCj4+IE5vdGUgdGhhdCBJIGFtIG5vdCBzdHJvbmdseSBhZHZvY2F0aW5nIG15IGJlbG93IHBh
dGNoIGFzDQo+PiBpdCBoYXMgdGhlIHNhbWUgc2hvcnRjb21pbmcgdGhhdCBtYWludGFpbmVkIG1v
ZGlmaWVyIHR5cGUNCj4+IHNpemUgbWF5IG5vdCBiZSBjb3JyZWN0Lg0KPiANCj4gSSBkb24ndCB0
aGluayB5b3VyIHBhdGNoIGhlbHBzLCBpdCBjYW4gYWN0dWFsbHkgY29uZnVzZSB0aGluZ3MgZXZl
bg0KPiBtb3JlLiBJdCBza2lwcyBtb2RpZmllcnMgdW50aWwgdW5kZXJseWluZyB0eXBlIGlzIGZv
dW5kLCBidXQgeW91IHN0aWxsDQo+IGRvbid0IGd1YXJhbnRlZSB0aGF0IGF0IHRoYXQgdGltZSB0
aGF0IHVuZGVybHlpbmcgdHlwZSB3aWxsIGhhdmUgaXRzDQo+IHNpemUgcmVzb2x2ZWQuDQoNCkl0
IGFjdHVhbGx5IGRvZXMgaGVscC4gSXQgZG9lcyBub3QgY2hhbmdlIHRoZSBpbnRlcm5hbCBidGYg
dHlwZQ0KdHJhdmVyc2FsIGFsZ29yaXRobXMuIEl0IG9ubHkgY2hhbmdlIHRoZSBpbXBsZW1lbnRh
dGlvbiBvZg0KYW4gZXh0ZXJuYWwgQVBJIGJ0Zl90eXBlX2lkX3NpemUoKS4gUHJldmlvdXNseSwg
dGhpcyBmdW5jdGlvbg0KaXMgdXNlZCBieSBleHRlcm5hbHMgYW5kIGludGVybmFsIGJ0Zi5jLiBJ
IGJyb2tlIGl0IGludG8gdHdvLA0Kb25lIGludGVybmFsIF9fYnRmX3R5cGVfaWRfc2l6ZSgpLCBh
bmQgYW5vdGhlciBleHRlcm5hbA0KYnRmX3R5cGVfaWRfc2l6ZSgpLiBUaGUgZXh0ZXJuYWwgb25l
IHJlbW92ZXMgbW9kaWZpZXIgYmVmb3JlDQpmaW5kaW5nIHR5cGUgc2l6ZS4gVGhlIGV4dGVybmFs
IG9uZSBpcyB0eXBpY2FsbHkgdXNlZCBvbmx5DQphZnRlciBidGYgaXMgdmFsaWRhdGVkLg0KDQpX
aWxsIGdvIHRocm91Z2ggeW91ciBvdGhlciBjb21tZW50cyBsYXRlci4NCg0KPiANCj4+DQo+PiBk
aWZmIC0tZ2l0IGEva2VybmVsL2JwZi9idGYuYyBiL2tlcm5lbC9icGYvYnRmLmMNCj4+IGluZGV4
IDU0NmViZWUzOWUyYS4uNmY5MjdjM2UwYTg5IDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL2JwZi9i
dGYuYw0KPj4gKysrIGIva2VybmVsL2JwZi9idGYuYw0KPj4gQEAgLTYyMCw2ICs2MjAsNTQgQEAg
c3RhdGljIGJvb2wgYnRmX3R5cGVfaW50X2lzX3JlZ3VsYXIoY29uc3Qgc3RydWN0DQo+PiBidGZf
dHlwZSAqdCkNCj4+ICAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4+ICAgIH0NCj4+DQo+PiArc3Rh
dGljIGNvbnN0IHN0cnVjdCBidGZfdHlwZSAqX19idGZfdHlwZV9pZF9zaXplKGNvbnN0IHN0cnVj
dCBidGYgKmJ0ZiwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB1MzIgKnR5cGVfaWQsIHUzMg0KPj4gKnJldF9zaXplLA0KPj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvb2wgc2tpcF9tb2RpZmllcikN
Cj4+ICt7DQo+PiArICAgICAgIGNvbnN0IHN0cnVjdCBidGZfdHlwZSAqc2l6ZV90eXBlOw0KPj4g
KyAgICAgICB1MzIgc2l6ZV90eXBlX2lkID0gKnR5cGVfaWQ7DQo+PiArICAgICAgIHUzMiBzaXpl
ID0gMDsNCj4+ICsNCj4+ICsgICAgICAgc2l6ZV90eXBlID0gYnRmX3R5cGVfYnlfaWQoYnRmLCBz
aXplX3R5cGVfaWQpOw0KPj4gKyAgICAgICBpZiAoc2l6ZV90eXBlICYmIHNraXBfbW9kaWZpZXIp
IHsNCj4+ICsgICAgICAgICAgICAgICB3aGlsZSAoYnRmX3R5cGVfaXNfbW9kaWZpZXIoc2l6ZV90
eXBlKSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHNpemVfdHlwZSA9IGJ0Zl90eXBlX2J5
X2lkKGJ0Ziwgc2l6ZV90eXBlLT50eXBlKTsNCj4+ICsgICAgICAgfQ0KPj4gKw0KPj4gKyAgICAg
ICBpZiAoYnRmX3R5cGVfbm9zaXplX29yX251bGwoc2l6ZV90eXBlKSkNCj4+ICsgICAgICAgICAg
ICAgICByZXR1cm4gTlVMTDsNCj4+ICsNCj4+ICsgICAgICAgaWYgKGJ0Zl90eXBlX2hhc19zaXpl
KHNpemVfdHlwZSkpIHsNCj4+ICsgICAgICAgICAgICAgICBzaXplID0gc2l6ZV90eXBlLT5zaXpl
Ow0KPj4gKyAgICAgICB9IGVsc2UgaWYgKGJ0Zl90eXBlX2lzX2FycmF5KHNpemVfdHlwZSkpIHsN
Cj4+ICsgICAgICAgICAgICAgICBzaXplID0gYnRmLT5yZXNvbHZlZF9zaXplc1tzaXplX3R5cGVf
aWRdOw0KPj4gKyAgICAgICB9IGVsc2UgaWYgKGJ0Zl90eXBlX2lzX3B0cihzaXplX3R5cGUpKSB7
DQo+PiArICAgICAgICAgICAgICAgc2l6ZSA9IHNpemVvZih2b2lkICopOw0KPj4gKyAgICAgICB9
IGVsc2Ugew0KPj4gKyAgICAgICAgICAgICAgIGlmIChXQVJOX09OX09OQ0UoIWJ0Zl90eXBlX2lz
X21vZGlmaWVyKHNpemVfdHlwZSkgJiYNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICFidGZfdHlwZV9pc192YXIoc2l6ZV90eXBlKSkpDQo+PiArICAgICAgICAgICAgICAgICAg
ICAgICByZXR1cm4gTlVMTDsNCj4+ICsNCj4+ICsgICAgICAgICAgICAgICBzaXplID0gYnRmLT5y
ZXNvbHZlZF9zaXplc1tzaXplX3R5cGVfaWRdOw0KPj4gKyAgICAgICAgICAgICAgIHNpemVfdHlw
ZV9pZCA9IGJ0Zi0+cmVzb2x2ZWRfaWRzW3NpemVfdHlwZV9pZF07DQo+PiArICAgICAgICAgICAg
ICAgc2l6ZV90eXBlID0gYnRmX3R5cGVfYnlfaWQoYnRmLCBzaXplX3R5cGVfaWQpOw0KPj4gKyAg
ICAgICAgICAgICAgIGlmIChidGZfdHlwZV9ub3NpemVfb3JfbnVsbChzaXplX3R5cGUpKQ0KPj4g
KyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+PiArICAgICAgIH0NCj4+ICsN
Cj4+ICsgICAgICAgKnR5cGVfaWQgPSBzaXplX3R5cGVfaWQ7DQo+PiArICAgICAgIGlmIChyZXRf
c2l6ZSkNCj4+ICsgICAgICAgICAgICAgICAqcmV0X3NpemUgPSBzaXplOw0KPj4gKw0KPj4gKyAg
ICAgICByZXR1cm4gc2l6ZV90eXBlOw0KPj4gK30NCj4+ICsNClsuLi5dDQo=
