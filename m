Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8527FC92A1
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfJBTte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 15:49:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20520 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbfJBTte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 15:49:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92JhrWF009977;
        Wed, 2 Oct 2019 12:49:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ao6FeFib/TpDd8iviU0fhroK1lY0YJEO4EMX6zG5qnE=;
 b=WyLv51mWKq/YHiGKGmCTw9ljXaqVv9EVzbERV8dvQWtV7BhOcV0MYKCO9Cdzwnwuv/1d
 gQ8I7TGM8u15LOvbPYYmaNBJRc/Fj41Fd+d0goLJb86C379gTyu1g1uO2cznsSPudDAQ
 D9dFFag9UC8/XrAawWU4v6paQb5GEqCn4yM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vce9355ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Oct 2019 12:49:10 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 2 Oct 2019 12:49:09 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 2 Oct 2019 12:49:09 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 12:49:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFS/JvwDA6zbcYoYXUL5lMCwOrxOVpZYbSSmowKuFsdNLI9s00Ev5Bp0/hxTc3Y9XtTDtbq7XDY6jetTLqh51z1s8cPqJzb7ZBCWWP+MZQw5CpDWjWxsAQHCeAL4XRDp7CeqoIdfCKFErMJsd0kSyTmrqdUMHcTZs22Pystb1dx93pPZxisaPDX9tlab5SO6lhjRaWOPsRpN05Mlj8e+Y8d1F+KCdJ3vlfC+6Nr8+1i1ey2Aex2NKI0FUwZWg7/zMKODJdZU/2oX2VcVoJZeZGZ/7bR/GDO5DVKxPKzq8tDVZqlQhlt6y3qznll12nHjpk0EnIHOk4z0UfIfeEPsrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao6FeFib/TpDd8iviU0fhroK1lY0YJEO4EMX6zG5qnE=;
 b=Bn0CbwuvPuci3QKf/sm0WeKl/LSpgQljHs1onECR+MNMVVlbBZoVPtIz4XNVw2yjj42Dls14YyO+tX9E1iFu+xUPcOG5jgIsrTKxSAT7dDJAPs4MfcsOqL4YZLz0iQUTjsISRYYI299i9jVTjFPFMUkOFdCzK4nbLrcndZjOABMCdcO3r9/7salhhlz7v/idH13s1oczAudrRIW3yGJJZOG/GttgK/B9mP4yZkaCUavQrREtxKWI06WMY6FJMh1xbk3Be4hCJ8ag8g+RlPS5buTwXesMRlxk9XMZxiYInB0qd7w3GRjFU49E+0D7/iMKXvmvo3gC09jVgYQnJQeqNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao6FeFib/TpDd8iviU0fhroK1lY0YJEO4EMX6zG5qnE=;
 b=KPdJaiktY6FAqZQiuN4kUoq/s1eLg+/8CMzclTgVz8Lwq7PdsEoAhH9pvBjV3c/1+EQkxKzajoBzktU/IOuQ80qvbCCYMxXnRUFrzCmfdHlHkGDBtuXnMzX8qfi8Dc4ifEd3Hfje8kLMtFxYx3DGwkc7B6LnXfI6vZR98EkBEbA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1232.namprd15.prod.outlook.com (10.175.4.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 19:49:08 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 19:49:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Thread-Topic: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Thread-Index: AQHVeSWTQAdoySCg4UqxsTtsFl4XrqdHrwIAgAAMT4CAAAdKgA==
Date:   Wed, 2 Oct 2019 19:49:07 +0000
Message-ID: <B1372BF2-E0A2-4D01-B012-181B108CF994@fb.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <87tv8rq7e2.fsf@toke.dk>
In-Reply-To: <87tv8rq7e2.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::2338]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0903753d-bd89-448e-b147-08d7477196a4
x-ms-traffictypediagnostic: MWHPR15MB1232:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB123260C9BB7E2A7A6237F2B5B39C0@MWHPR15MB1232.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(366004)(346002)(39860400002)(199004)(189003)(966005)(33656002)(6506007)(229853002)(102836004)(53546011)(36756003)(478600001)(5660300002)(66574012)(305945005)(7736002)(6436002)(6306002)(6512007)(6486002)(76176011)(6916009)(54906003)(46003)(86362001)(2616005)(486006)(446003)(11346002)(186003)(6116002)(14454004)(316002)(476003)(25786009)(50226002)(8936002)(81166006)(8676002)(2906002)(256004)(14444005)(81156014)(71190400001)(71200400001)(4326008)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(6246003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1232;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XXvjW6Ak6msVInWf+0I67K5wD4y4F3ZIiN7hwz2X32WcmDw2eXgNoa6Y05ajSbkCn9BubiLnKm0y8gpPyrNGJn9GCStsHzJfuqzqECYwhwiTQNWzx3WeO0NyaD5q0MeTzZceG5pSKUospF2arkJGQbj9Byj4vZLg4JilLCh729kOFe5Mu/DAYFr2ZMVDoQ4fSPDexnKzTpYJt5wzt3mf483krumyCTRFnz6ue2el7ZJ83s8zLXCKAl/ajStVg/GwPAsc9Ugc1zABmpYK50G8NFfRICVnB/WoyJHcU4kYNnzenAou6YboFDYYxPZf6dSWWVOykfeWQg2K5vNz/1A1HPPypaQPJOdJT8hPkLnqK+wNmRH23IAShsP7XkpgJT8gCuu1sAanQVWZFROLQAww9SvsUiIA4sp6sisBS0qFyQC7/oiQzYuZQIUqLI/J5xUadrRgTSQ9CDJNR6yJjDKWzg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0A7B3637015524DBCE8F910715E3093@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0903753d-bd89-448e-b147-08d7477196a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 19:49:07.8667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/4NuQjvgHj+TbKVOVpWGJHQ0d1Ofgn3XVZT4PiTjO+MuQPruBx2f3u5tlqmyHN/n15YwBaXT6urr0TS1c5V7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1232
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_08:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910020154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gT2N0IDIsIDIwMTksIGF0IDEyOjIzIFBNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5z
ZW4gPHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBTb25nIExpdSA8c29uZ2xpdWJyYXZp
bmdAZmIuY29tPiB3cml0ZXM6DQo+IA0KPj4+IE9uIE9jdCAyLCAyMDE5LCBhdCA2OjMwIEFNLCBU
b2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gPHRva2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4gDQo+
Pj4gVGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBleGVjdXRpbmcgbXVsdGlwbGUgWERQIHBy
b2dyYW1zIG9uIGEgc2luZ2xlDQo+Pj4gaW50ZXJmYWNlIGluIHNlcXVlbmNlLCB0aHJvdWdoIHRo
ZSB1c2Ugb2YgY2hhaW4gY2FsbHMsIGFzIGRpc2N1c3NlZCBhdCB0aGUgTGludXgNCj4+PiBQbHVt
YmVycyBDb25mZXJlbmNlIGxhc3QgbW9udGg6DQo+Pj4gDQo+Pj4gaHR0cHM6Ly91cmxkZWZlbnNl
LnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19saW51eHBsdW1iZXJzY29uZi5vcmdf
ZXZlbnRfNF9jb250cmlidXRpb25zXzQ2MF8mZD1Ed0lEYVEmYz01VkQwUlR0TmxUaDN5Y2Q0MWIz
TVV3JnI9ZFI4NjkycTBfdWFpenkwamtyQkpRTTVrMmhmbTRDaUZ4WVQ4S2F5c0ZyZyZtPVlYcXFI
VEM1MXpYQnZpUEJFazU1eS1mUWpGUXdjWFdGbEgwSW9PcW0yS1Umcz1ORjR3M2VTUG1OaFNwSnIx
LTBGTHFxbHFmZ0VWOGdzQ1FiOVlxV1E5cC1rJmU9IA0KPj4+IA0KPj4+ICMgSElHSC1MRVZFTCBJ
REVBDQo+Pj4gDQo+Pj4gVGhlIGJhc2ljIGlkZWEgaXMgdG8gZXhwcmVzcyB0aGUgY2hhaW4gY2Fs
bCBzZXF1ZW5jZSB0aHJvdWdoIGEgc3BlY2lhbCBtYXAgdHlwZSwNCj4+PiB3aGljaCBjb250YWlu
cyBhIG1hcHBpbmcgZnJvbSBhIChwcm9ncmFtLCByZXR1cm4gY29kZSkgdHVwbGUgdG8gYW5vdGhl
ciBwcm9ncmFtDQo+Pj4gdG8gcnVuIGluIG5leHQgaW4gdGhlIHNlcXVlbmNlLiBVc2Vyc3BhY2Ug
Y2FuIHBvcHVsYXRlIHRoaXMgbWFwIHRvIGV4cHJlc3MNCj4+PiBhcmJpdHJhcnkgY2FsbCBzZXF1
ZW5jZXMsIGFuZCB1cGRhdGUgdGhlIHNlcXVlbmNlIGJ5IHVwZGF0aW5nIG9yIHJlcGxhY2luZyB0
aGUNCj4+PiBtYXAuDQo+Pj4gDQo+Pj4gVGhlIGFjdHVhbCBleGVjdXRpb24gb2YgdGhlIHByb2dy
YW0gc2VxdWVuY2UgaXMgZG9uZSBpbiBicGZfcHJvZ19ydW5feGRwKCksDQo+Pj4gd2hpY2ggd2ls
bCBsb29rdXAgdGhlIGNoYWluIHNlcXVlbmNlIG1hcCwgYW5kIGlmIGZvdW5kLCB3aWxsIGxvb3Ag
dGhyb3VnaCBjYWxscw0KPj4+IHRvIEJQRl9QUk9HX1JVTiwgbG9va2luZyB1cCB0aGUgbmV4dCBY
RFAgcHJvZ3JhbSBpbiB0aGUgc2VxdWVuY2UgYmFzZWQgb24gdGhlDQo+Pj4gcHJldmlvdXMgcHJv
Z3JhbSBJRCBhbmQgcmV0dXJuIGNvZGUuDQo+Pj4gDQo+Pj4gQW4gWERQIGNoYWluIGNhbGwgbWFw
IGNhbiBiZSBpbnN0YWxsZWQgb24gYW4gaW50ZXJmYWNlIGJ5IG1lYW5zIG9mIGEgbmV3IG5ldGxp
bmsNCj4+PiBhdHRyaWJ1dGUgY29udGFpbmluZyBhbiBmZCBwb2ludGluZyB0byBhIGNoYWluIGNh
bGwgbWFwLiBUaGlzIGNhbiBiZSBzdXBwbGllZA0KPj4+IGFsb25nIHdpdGggdGhlIFhEUCBwcm9n
IGZkLCBzbyB0aGF0IGEgY2hhaW4gbWFwIGlzIGFsd2F5cyBpbnN0YWxsZWQgdG9nZXRoZXINCj4+
PiB3aXRoIGFuIFhEUCBwcm9ncmFtLg0KPj4gDQo+PiBJbnRlcmVzdGluZyB3b3JrIQ0KPj4gDQo+
PiBRdWljayBxdWVzdGlvbjogY2FuIHdlIGFjaGlldmUgdGhlIHNhbWUgYnkgYWRkaW5nIGEgInJl
dHZhbCB0bw0KPj4gY2FsbF90YWlsX25leHQiIG1hcCB0byBlYWNoIHByb2dyYW0/DQo+IA0KPiBI
bW0sIHRoYXQncyBhbiBpbnRlcmVzdGluZyBpZGVhOyBJIGhhZG4ndCB0aG91Z2h0IG9mIHRoYXQu
IEFzIGxvbmcgYXMNCj4gdGhhdCBtYXAgY2FuIGJlIG1hbmlwdWxhdGVkIG91dHNpZGUgb2YgdGhl
IHByb2dyYW0gaXRzZWxmLCBpdCBtYXkgd29yay4NCj4gSSB3b25kZXIgaG93IGNvbXBsZXggaXQg
Z2V0cyB0byBtb2RpZnkgdGhlIGNhbGwgc2VxdWVuY2UsIHRob3VnaDsgc2F5DQo+IHlvdSB3YW50
IHRvIGNoYW5nZSBBLT5CLT5DIHRvIEEtPkMtPkIgLSBob3cgZG8geW91IGRvIHRoYXQgd2l0aG91
dA0KPiBpbnRlcnJ1cHRpbmcgdGhlIHNlcXVlbmNlIHdoaWxlIHlvdSdyZSBtb2RpZnlpbmcgdGhp
bmdzPyBPciBpcyBpdCBPSyBpZg0KPiB0aGF0IGlzIG5vdCBwb3NzaWJsZT8NCg0KV2UgY2FuIGFs
d2F5cyBsb2FkIGFub3RoZXIgY29weSBvZiBCIGFuZCBDLCBzYXkgRCA9PSBCLCBhbmQgRSA9PSBD
LiBBbmQgDQptYWtlIGl0IEEtPkUtPkQuIA0KDQoNCg==
