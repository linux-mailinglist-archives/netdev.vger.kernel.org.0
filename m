Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECBECC2C5
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 20:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJDSiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 14:38:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53634 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfJDSiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 14:38:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94IYapB021869;
        Fri, 4 Oct 2019 11:37:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3Sm0sE6BL60rUz7JRxLGTDjtRuyl6HyK+8eCk20wv04=;
 b=Tj1+IF3e5a5VX5420ym+7DufvdDxw5H0xrflvzcPPBcIglaS+P4jGbO6gsd/72APbZr9
 oIe4si8QaFtO3Ov9BFa1idlEhm2SM5vZRiVZTGpo5Im2g9vCEuiZDa9pkqyFHKbYI5aR
 OgkpBa7UpKU0cTUlhTRNxQ83978y65C2F7M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ve5489tbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Oct 2019 11:37:46 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 11:37:46 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Oct 2019 11:37:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYkXeKtWnpd5R96OsOMP6+GIa8InJ/balvVtSWn4inlU6G8Aeuc7gNrK0HpAzVppHiTIcLbW50wlQkVNkqCDkkUn15gkxcEBLP7M31hHdAZfHpyoS+l8bA9GL8fHVRCnyw2fA5dxoFg5KEaxPuk03/TQRouxajSAVmuWyQqSEWdUnI30M/M+ryG0gwpWG15AV5D4zQJqCNZDPzBB0tAj+e4isb9NxPpXRxFtKUKEkucD9NpEqsTiG6g9PwU2GT4GuwWP2G16DBRB9TwJdnc3OlCH+VE6rlMXs5z4Axh6m8WEb/0ojBBq2GDUXl4u+3JVn9D2irtOf5B1z4PNrTc6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Sm0sE6BL60rUz7JRxLGTDjtRuyl6HyK+8eCk20wv04=;
 b=W+UFMpvLDjSsMtCCN3j4WJFMS6T/1GhuSDMEdQuDi611VENKTtriSqzveC9Renmzmu7tWA3g9OoDlQvLij2Hx+LKuxO7FrVSg1HDHTonJFRHx3vJBoaFnQu8cRZqdzqq04dFD8ZTrR43ht8Tj5A/2SIHsF8VmmRCAVaWRvBuoeiJJjMH4jKDMsraD30K+Pvgvkx8KNgZOHtvC80PQqkTzccxcftiSKXOxC088efP+WMJM8GTz/kka7bMG+PgvcDb/xo5dZ2LOToMwip3AA5bPpsEYKVidgVRvSUFxCPdaCbQSCub05Nioy05UyriVqfjuekGyFSdbSuwhPQTwbLTiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Sm0sE6BL60rUz7JRxLGTDjtRuyl6HyK+8eCk20wv04=;
 b=cqPpW/4mHJKhEH0uFYqbKD0wSf5TzGOc0fCpJCcJURWNvQ84GyEop/8mmPog7fADSxMrNss6RLCHfVm78CXsDfSJMwzjNApmuHVeJiHWRh+UqVGGwbbPouDSpUN14JPOxUodk7H22mTfOatOmr/SuRwz5Jw5p1VsJ80ppbfgkjg=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2472.namprd15.prod.outlook.com (52.135.197.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 4 Oct 2019 18:37:45 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::7576:ddf9:dad2:1027]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::7576:ddf9:dad2:1027%7]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 18:37:45 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Thread-Topic: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Thread-Index: AQHVesKhAbMxtLCgLUqdW7FMTeGou6dKmxQAgAAErwCAAAR2AIAAKdYAgAACB4A=
Date:   Fri, 4 Oct 2019 18:37:44 +0000
Message-ID: <62b1bc6b-8c8a-b766-6bfc-2fb16017d591@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
 <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
 <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
 <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
 <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
 <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0052.namprd14.prod.outlook.com
 (2603:10b6:300:81::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d04c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d74ab596-43e7-420c-e9fd-08d748f9f23d
x-ms-traffictypediagnostic: BYAPR15MB2472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB24726BDEA0D7768A144CA2F7D39E0@BYAPR15MB2472.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(189003)(199004)(4326008)(256004)(316002)(486006)(2616005)(31686004)(6512007)(71200400001)(6436002)(6246003)(476003)(6486002)(25786009)(229853002)(11346002)(71190400001)(76176011)(52116002)(54906003)(110136005)(2906002)(8676002)(81156014)(81166006)(14444005)(102836004)(386003)(6506007)(53546011)(66556008)(66476007)(64756008)(6116002)(7736002)(99286004)(8936002)(446003)(46003)(66446008)(66946007)(305945005)(186003)(86362001)(14454004)(36756003)(5660300002)(31696002)(478600001)(21314003)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2472;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dx2XEhShJgzBfiyOaURzk0QLoLfv0gb5Eaw0xi6DquOxF0pOLqBZu5OWRqjhNdYR5EJgvr+KZnz2czMe36+eP3oMzhBCl9+wZGeBlb7xUySkRke5OWzd/eL/lsIsgRHh0Q2H5NtUNdHP+pdEpfHDQkgFAeU9TCJzRvxEtJu1hgbyuk+te1nOGskjKbdjW5TMzsmtzOprM5gVdUz7XaRzbiWsYrRvS3nGOSprW8/RaKvnnhJfk0kMSj8DRPmI914m6JoFDFkOoTuY/Py04gqnxfqeihcoce830bZp9yFsBV6tiGVhlPXUJYhjQHlklAE170ovR+7gZ6Ey7/fwet+N5vYdjVmNBCyn9CV/GEA0PxR0rheqXAQlGH4jXkyLDka2HuSuivvOnmn9FRPixKUPpgcF7DqPOApRtsaEEDEXE60=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4E990FEFF3B5149A08DA4AC42DAB592@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d74ab596-43e7-420c-e9fd-08d748f9f23d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 18:37:44.8762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XiawRKba7x1y1fzReq7dlqXPUIPzg1xmi4fv9L9S1GaTkfg2zFIwyJHxAk0aHzWQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2472
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_11:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzQvMTkgMTE6MzAgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBGcmks
IDQgT2N0IDIwMTkgMDk6MDA6NDIgLTA3MDAsIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4+IE9u
IEZyaSwgT2N0IDQsIDIwMTkgYXQgODo0NCBBTSBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFpbC5j
b20+IHdyb3RlOg0KPj4+PiBJJ20gbm90IGZvbGxvd2luZyB5b3U7IG15IGludGVycHJldGF0aW9u
IG9mIHlvdXIgY29tbWVudCBzZWVtcyBsaWtlIHlvdQ0KPj4+IGFyZSBtYWtpbmcgaHVnZSBhc3N1
bXB0aW9ucy4NCj4+Pg0KPj4+IEkgYnVpbGQgYnBmIHByb2dyYW1zIGZvciBzcGVjaWZpYyBrZXJu
ZWwgdmVyc2lvbnMgdXNpbmcgdGhlIGRldmVsDQo+Pj4gcGFja2FnZXMgZm9yIHRoZSBzcGVjaWZp
YyBrZXJuZWwgb2YgaW50ZXJlc3QuDQo+Pg0KPj4gU3VyZSwgYW5kIHlvdSBjYW4ga2VlcCBkb2lu
ZyB0aGF0LCBqdXN0IGRvbid0IGluY2x1ZGUgYnBmX2hlbHBlcnMuaD8NCj4+DQo+PiBXaGF0IEkg
d2FzIHNheWluZywgdGhvdWdoLCBlc3BlY2lhbGx5IGhhdmluZyBpbiBtaW5kIHRyYWNpbmcgQlBG
DQo+PiBwcm9ncmFtcyB0aGF0IG5lZWQgdG8gaW5zcGVjdCBrZXJuZWwgc3RydWN0dXJlcywgaXMg
dGhhdCBpdCdzIHF1aXRlDQo+PiBpbXByYWN0aWNhbCB0byBoYXZlIHRvIGJ1aWxkIG1hbnkgZGlm
ZmVyZW50IHZlcnNpb25zIG9mIEJQRiBwcm9ncmFtcw0KPj4gZm9yIGVhY2ggc3VwcG9ydGVkIGtl
cm5lbCB2ZXJzaW9uIGFuZCBkaXN0cmlidXRlIHRoZW0gaW4gYmluYXJ5IGZvcm0uDQo+PiBTbyBw
ZW9wbGUgdXN1YWxseSB1c2UgQkNDIGFuZCBkbyBjb21waWxhdGlvbiBvbi10aGUtZmx5IHVzaW5n
IEJDQydzDQo+PiBlbWJlZGRlZCBDbGFuZy4NCj4+DQo+PiBCUEYgQ08tUkUgaXMgcHJvdmlkaW5n
IGFuIGFsdGVybmF0aXZlLCB3aGljaCB3aWxsIGFsbG93IHRvIHByZS1jb21waWxlDQo+PiB5b3Vy
IHByb2dyYW0gb25jZSBmb3IgbWFueSBkaWZmZXJlbnQga2VybmVscyB5b3UgbWlnaHQgYmUgcnVu
bmluZyB5b3VyDQo+PiBwcm9ncmFtIG9uLiBUaGVyZSBpcyB0b29saW5nIHRoYXQgZWxpbWluYXRl
cyB0aGUgbmVlZCBmb3Igc3lzdGVtDQo+PiBoZWFkZXJzLiBJbnN0ZWFkIHdlIHByZS1nZW5lcmF0
ZSBhIHNpbmdsZSB2bWxpbnV4LmggaGVhZGVyIHdpdGggYWxsDQo+PiB0aGUgdHlwZXMvZW51bXMv
ZXRjLCB0aGF0IGFyZSB0aGVuIHVzZWQgdy8gQlBGIENPLVJFIHRvIGJ1aWxkIHBvcnRhYmxlDQo+
PiBCUEYgcHJvZ3JhbXMgY2FwYWJsZSBvZiB3b3JraW5nIG9uIG11bHRpcGxlIGtlcm5lbCB2ZXJz
aW9ucy4NCj4+DQo+PiBTbyB3aGF0IEkgd2FzIHBvaW50aW5nIG91dCB0aGVyZSB3YXMgdGhhdCB0
aGlzIHZtbGludXguaCB3b3VsZCBiZQ0KPj4gaWRlYWxseSBnZW5lcmF0ZWQgZnJvbSBsYXRlc3Qg
a2VybmVsIGFuZCBub3QgaGF2aW5nIGxhdGVzdA0KPj4gQlBGX0ZVTkNfeHh4IHNob3VsZG4ndCBi
ZSBhIHByb2JsZW0uIEJ1dCBzZWUgYmVsb3cgYWJvdXQgc2l0dWF0aW9uDQo+PiBiZWluZyB3b3Jz
ZS4NCj4gDQo+IFN1cmVseSBmb3IgZGlzdHJvZXMgdGhvIC0gdGhleSB3b3VsZCBoYXZlIGtlcm5l
bCBoZWFkZXJzIG1hdGNoaW5nIHRoZQ0KPiBrZXJuZWwgcmVsZWFzZSB0aGV5IHNoaXAuIElmIHBh
cnRzIG9mIGxpYmJwZiBmcm9tIEdIIG9ubHkgd29yayB3aXRoDQo+IHRoZSBsYXRlc3Qga2VybmVs
LCBkaXN0cm9lcyBzaG91bGQgc2hpcCBsaWJicGYgZnJvbSB0aGUga2VybmVsIHNvdXJjZSwNCj4g
cmF0aGVyIHRoYW4gR0guDQo+IA0KPj4+PiBOZXZlcnRoZWxlc3MsIGl0IGlzIGEgcHJvYmxlbSBh
bmQgdGhhbmtzIGZvciBicmluZ2luZyBpdCB1cCEgSSdkIHNheQ0KPj4+PiBmb3Igbm93IHdlIHNo
b3VsZCBzdGlsbCBnbyBhaGVhZCB3aXRoIHRoaXMgbW92ZSBhbmQgdHJ5IHRvIHNvbHZlIHdpdGgN
Cj4+Pj4gaXNzdWUgb25jZSBicGZfaGVscGVycy5oIGlzIGluIGxpYmJwZi4gSWYgYnBmX2hlbHBl
cnMuaCBkb2Vzbid0IHdvcmsNCj4+Pj4gZm9yIHNvbWVvbmUsIGl0J3Mgbm8gd29yc2UgdGhhbiBp
dCBpcyB0b2RheSB3aGVuIHVzZXJzIGRvbid0IGhhdmUNCj4+Pj4gYnBmX2hlbHBlcnMuaCBhdCBh
bGwuDQo+Pj4+ICAgDQo+Pj4NCj4+PiBJZiB0aGlzIHN5bmNzIHRvIHRoZSBnaXRodWIgbGliYnBm
LCBpdCB3aWxsIGJlIHdvcnNlIHRoYW4gdG9kYXkgaW4gdGhlDQo+Pj4gc2Vuc2Ugb2YgY29tcGls
ZSBmYWlsdXJlcyBpZiBzb21lb25lJ3MgaGVhZGVyIGZpbGUgb3JkZXJpbmcgcGlja3MNCj4+PiBs
aWJicGYncyBicGZfaGVscGVycy5oIG92ZXIgd2hhdGV2ZXIgdGhleSBhcmUgdXNpbmcgdG9kYXku
DQo+Pg0KPj4gVG9kYXkgYnBmX2hlbHBlcnMuaCBkb24ndCBleGlzdCBmb3IgdXNlcnMgb3IgYW0g
SSBtaXNzaW5nIHNvbWV0aGluZz8NCj4+IGJwZl9oZWxwZXJzLmggcmlnaHQgbm93IGFyZSBwdXJl
bHkgZm9yIHNlbGZ0ZXN0cy4gQnV0IHRoZXkgYXJlIHJlYWxseQ0KPj4gdXNlZnVsIG91dHNpZGUg
dGhhdCBjb250ZXh0LCBzbyBJJ20gbWFraW5nIGl0IGF2YWlsYWJsZSBmb3IgZXZlcnlvbmUNCj4+
IGJ5IGRpc3RyaWJ1dGluZyB3aXRoIGxpYmJwZiBzb3VyY2VzLiBJZiBicGZfaGVscGVycy5oIGRv
ZXNuJ3Qgd29yayBmb3INCj4+IHNvbWUgc3BlY2lmaWMgdXNlIGNhc2UsIGp1c3QgZG9uJ3QgdXNl
IGl0ICh5ZXQ/KS4NCj4+DQo+PiBJJ20gc3RpbGwgZmFpbGluZyB0byBzZWUgaG93IGl0J3Mgd29y
c2UgdGhhbiBzaXR1YXRpb24gdG9kYXkuDQo+IA0KPiBIYXZpbmcgYSBoZWFkZXIgd2hpY2ggd29y
a3MgdG9kYXksIGJ1dCBtYXkgbm90IHdvcmsgdG9tb3Jyb3cgaXMgZ29pbmcNCj4gdG8gYmUgcHJl
dHR5IGJhZCB1c2VyIGV4cGVyaWVuY2UgOiggTm8gbWF0dGVyIGhvdyBtYW55IHdhcm5pbmdzIHlv
dSBwdXQNCj4gaW4gdGhlIHNvdXJjZSBwZW9wbGUgd2lsbCBnZXQgY2F1Z2h0IG9mZiBndWFyZCBi
eSB0aGlzIDooDQo+IA0KPiBJZiB5b3UgZGVmaW5lIHRoZSBjdXJyZW50IHN0YXRlIGFzICJ1c2Vy
cyBjYW4gdXNlIGFsbCBmZWF0dXJlcyBvZg0KPiBsaWJicGYgYW5kIG5vdGhpbmcgc2hvdWxkIGJy
ZWFrIG9uIGxpYmJwZiB1cGRhdGUiICh3aGljaCBpcyBpbiBteQ0KPiB1bmRlcnN0YW5kaW5nIGEg
Z29hbCBvZiB0aGUgcHJvamVjdCwgd2UgYmVudCBvdmVyIGJhY2t3YXJkcyB0cnlpbmcNCj4gdG8g
bm90IGJyZWFrIHRoaW5ncykgdGhlbiBhZGRpbmcgdGhpcyBoZWFkZXIgd2lsbCBpbiBmYWN0IG1h
a2UgdGhpbmdzDQo+IHdvcnNlLiBUaGUgc3RhdGVtZW50IGluIHF1b3RlcyB3b3VsZCBubyBsb25n
ZXIgYmUgdHJ1ZSwgbm8/DQoNCmRpc3RybyBjYW4gcGFja2FnZSBicGYvYnRmIHVhcGkgaGVhZGVy
cyBpbnRvIGxpYmJwZiBwYWNrYWdlLg0KVXNlcnMgbGlua2luZyB3aXRoIGxpYmJwZi5hL2xpYmJw
Zi5zbyBjYW4gdXNlIGJwZi9idGYuaCB3aXRoIGluY2x1ZGUNCnBhdGggcG9pbnRpbmcgdG8gbGli
YnBmIGRldiBwYWNrYWdlIGluY2x1ZGUgZGlyZWN0b3J5Lg0KQ291bGQgdGhpcyB3b3JrPw0K
