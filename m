Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E016B33D73
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDDTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:19:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33812 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbfFDDTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 23:19:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5433WKk026120;
        Mon, 3 Jun 2019 20:18:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rHZe7wGq167I5230zrFuH5BowpWX2wWxoQ4MVGeBVfM=;
 b=gbYQHCWTQMGhC/WcnRTWx9h7R7GoyQfOL2lbnL+4wQnqCmourmFy3NCXrl7Cita796OR
 xLqyycbuf+34s/vcyvuzEt2wuCde/TCqQJS5jc6ZXR/88wU4Lcus7ZRYsgpYD5/3ozh8
 8CmLNkL/LvKzvzY3ORlljJovJi2hWhGK5lE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2swaeu14rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Jun 2019 20:18:02 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 3 Jun 2019 20:18:01 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Jun 2019 20:18:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHZe7wGq167I5230zrFuH5BowpWX2wWxoQ4MVGeBVfM=;
 b=Q34LNTlspaz+fb047dVrW1a4JwGCAaUgR2lmrRZr0Il9nrGaM94P5NCkuJwP9BxAZDT//a2Cz7+HT1nxa5/cnJIAZDDGpDJsLFtTMX3IFNCUMNUbpbBSPiZmZ9sH5zlVtz5hA8kG2xviroif5hkN29civkZbFtDkZSVdisKdY2I=
Received: from MWHPR15MB1262.namprd15.prod.outlook.com (10.175.3.141) by
 MWHPR15MB1296.namprd15.prod.outlook.com (10.175.2.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.20; Tue, 4 Jun 2019 03:17:58 +0000
Received: from MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc]) by MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc%8]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 03:17:58 +0000
From:   Matt Mullins <mmullins@fb.com>
To:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
CC:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Andrew Hall <hall@fb.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Thread-Topic: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Thread-Index: AQHVGAF59w/lvxC2rk6cErnZnaX1kaaJ6uwAgAADyACAAKCpAIAACGqAgAAF2ACAAAGYAIAADfYAgAAquYA=
Date:   Tue, 4 Jun 2019 03:17:58 +0000
Message-ID: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com>
References: <20190531223735.4998-1-mmullins@fb.com>
         <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
         <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net>
         <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
         <CAADnVQKAPTao3nE1AC5dvYtCKFhDHu9VeCnVE04TLjGpY6yANw@mail.gmail.com>
         <70b9a1b2-c960-b810-96f9-1fb5f4a4061b@iogearbox.net>
         <CAADnVQKfZj5hDhyP6A=2tWAGJ2u7Fyx5d_rOTZ-ZyH1xBXtB3w@mail.gmail.com>
         <71c96268-7779-6e34-3078-5532d9f8fa55@iogearbox.net>
In-Reply-To: <71c96268-7779-6e34-3078-5532d9f8fa55@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [2620:10d:c090:200::2:6bd5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33229433-9033-46e3-78ee-08d6e89b3e87
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1296;
x-ms-traffictypediagnostic: MWHPR15MB1296:
x-microsoft-antispam-prvs: <MWHPR15MB12969791C03800ACEB8D24F8B0150@MWHPR15MB1296.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(39860400002)(366004)(51444003)(199004)(189003)(64756008)(486006)(186003)(71190400001)(53546011)(2906002)(66446008)(71200400001)(6486002)(476003)(46003)(76176011)(11346002)(2616005)(229853002)(6436002)(86362001)(6506007)(99286004)(76116006)(4326008)(25786009)(66556008)(7736002)(73956011)(6512007)(446003)(102836004)(66946007)(305945005)(66476007)(81156014)(81166006)(8676002)(316002)(6246003)(50226002)(8936002)(118296001)(53936002)(54906003)(110136005)(36756003)(6116002)(68736007)(478600001)(5660300002)(14444005)(256004)(14454004)(2501003)(5024004)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1296;H:MWHPR15MB1262.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BmOzgplW94t2K/p+95JYA+Hb2dHwgzkGv1LZvd782K1PZWUJXx5ggg/QkyIEO1QagzsOkk9vrNSlB7kI/FSEOzeeaNdDWixW7nAtwFppgCg7g2gN+dEfisnHSZIc+v2rBmnUKsndyi0GHfdD2YD+bXNYe5pA48xmYaE0kMD89/ynZc063FnN2DsOpQ7l+MtsNXBwt5qlL5noyeh5NBRTlk7zJRCgwC5gHA+yR0Buw3VO4owHfCJmb0I7TT+XZ+3d0xDNPlgQAzvc/1KB8FMxVkOuQqckoeCo/259H0zQMCa2Sl5sAGDaVNnxgIQv3IZcriyTSBqtZPxbYX65rz+TC4jVvms1TV0qiYM4aYpnVGWPY9rIJ4y68+ZxARBT89xgOQ43TPr+GXOkWs/7tBLtxoA/XMqWD3DFONnwHbGwTA0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4EA5C679940E346B7A892435E3287D0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33229433-9033-46e3-78ee-08d6e89b3e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 03:17:58.3782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmullins@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1296
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTA0IGF0IDAyOjQzICswMjAwLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6
DQo+IE9uIDA2LzA0LzIwMTkgMDE6NTQgQU0sIEFsZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToNCj4g
PiBPbiBNb24sIEp1biAzLCAyMDE5IGF0IDQ6NDggUE0gRGFuaWVsIEJvcmttYW5uIDxkYW5pZWxA
aW9nZWFyYm94Lm5ldD4gd3JvdGU6DQo+ID4gPiBPbiAwNi8wNC8yMDE5IDAxOjI3IEFNLCBBbGV4
ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+ID4gPiA+IE9uIE1vbiwgSnVuIDMsIDIwMTkgYXQgMzo1
OSBQTSBNYXR0IE11bGxpbnMgPG1tdWxsaW5zQGZiLmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gSWYgdGhlc2UgYXJlIGludmFyaWFibHkgbm9uLW5lc3RlZCwgSSBjYW4gZWFzaWx5
IGtlZXAgYnBmX21pc2Nfc2Qgd2hlbg0KPiA+ID4gPiA+IEkgcmVzdWJtaXQuICBUaGVyZSB3YXMg
bm8gdGVjaG5pY2FsIHJlYXNvbiBvdGhlciB0aGFuIGtlZXBpbmcgdGhlIHR3bw0KPiA+ID4gPiA+
IGNvZGVwYXRocyBhcyBzaW1pbGFyIGFzIHBvc3NpYmxlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
IFdoYXQgcmVzb3VyY2UgZ2l2ZXMgeW91IHdvcnJ5IGFib3V0IGRvaW5nIHRoaXMgZm9yIHRoZSBu
ZXR3b3JraW5nDQo+ID4gPiA+ID4gY29kZXBhdGg/DQo+ID4gPiA+IA0KPiA+ID4gPiBteSBwcmVm
ZXJlbmNlIHdvdWxkIGJlIHRvIGtlZXAgdHJhY2luZyBhbmQgbmV0d29ya2luZyB0aGUgc2FtZS4N
Cj4gPiA+ID4gdGhlcmUgaXMgYWxyZWFkeSBtaW5pbWFsIG5lc3RpbmcgaW4gbmV0d29ya2luZyBh
bmQgcHJvYmFibHkgd2Ugc2VlDQo+ID4gPiA+IG1vcmUgd2hlbiByZXVzZXBvcnQgcHJvZ3Mgd2ls
bCBzdGFydCBydW5uaW5nIGZyb20geGRwIGFuZCBjbHNicGYNCj4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBBc2lkZSBmcm9tIHRoYXQgaXQncyBhbHNvIHJlYWxseSBiYWQgdG8gbWlzcyBldmVudHMgbGlr
ZSB0aGlzIGFzIGV4cG9ydGluZw0KPiA+ID4gPiA+ID4gdGhyb3VnaCByYiBpcyBjcml0aWNhbC4g
V2h5IGNhbid0IHlvdSBoYXZlIGEgcGVyLUNQVSBjb3VudGVyIHRoYXQgc2VsZWN0cyBhDQo+ID4g
PiA+ID4gPiBzYW1wbGUgZGF0YSBjb250ZXh0IGJhc2VkIG9uIG5lc3RpbmcgbGV2ZWwgaW4gdHJh
Y2luZz8gKEkgZG9uJ3Qgc2VlIGEgZGlzY3Vzc2lvbg0KPiA+ID4gPiA+ID4gb2YgdGhpcyBpbiB5
b3VyIGNvbW1pdCBtZXNzYWdlLikNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBUaGlzIGNoYW5nZSB3
b3VsZCBvbmx5IGRyb3AgbWVzc2FnZXMgaWYgdGhlIHNhbWUgcGVyZl9ldmVudCBpcw0KPiA+ID4g
PiA+IGF0dGVtcHRlZCB0byBiZSB1c2VkIHJlY3Vyc2l2ZWx5IChpLmUuIHRoZSBzYW1lIENQVSBv
biB0aGUgc2FtZQ0KPiA+ID4gPiA+IFBFUkZfRVZFTlRfQVJSQVkgbWFwLCBhcyBJIGhhdmVuJ3Qg
b2JzZXJ2ZWQgYW55dGhpbmcgdXNlIGluZGV4ICE9DQo+ID4gPiA+ID4gQlBGX0ZfQ1VSUkVOVF9D
UFUgaW4gdGVzdGluZykuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSdsbCB0cnkgdG8gYWNjb21w
bGlzaCB0aGUgc2FtZSB3aXRoIGEgcGVyY3B1IG5lc3RpbmcgbGV2ZWwgYW5kDQo+ID4gPiA+ID4g
YWxsb2NhdGluZyAyIG9yIDMgcGVyZl9zYW1wbGVfZGF0YSBwZXIgY3B1LiAgSSB0aGluayB0aGF0
J2xsIHNvbHZlIHRoZQ0KPiA+ID4gPiA+IHNhbWUgcHJvYmxlbSAtLSBhIGxvY2FsIHBhdGNoIGtl
ZXBpbmcgdHJhY2sgb2YgdGhlIG5lc3RpbmcgbGV2ZWwgaXMgaG93DQo+ID4gPiA+ID4gSSBnb3Qg
dGhlIGFib3ZlIHN0YWNrIHRyYWNlLCB0b28uDQo+ID4gPiA+IA0KPiA+ID4gPiBJIGRvbid0IHRo
aW5rIGNvdW50ZXIgYXBwcm9hY2ggd29ya3MuIFRoZSBhbW91bnQgb2YgbmVzdGluZyBpcyB1bmtu
b3duLg0KPiA+ID4gPiBpbW8gdGhlIGFwcHJvYWNoIHRha2VuIGluIHRoaXMgcGF0Y2ggaXMgZ29v
ZC4NCj4gPiA+ID4gSSBkb24ndCBzZWUgYW55IGlzc3VlIHdoZW4gZXZlbnRfb3V0cHV0cyB3aWxs
IGJlIGRyb3BwZWQgZm9yIHZhbGlkIHByb2dzLg0KPiA+ID4gPiBPbmx5IHdoZW4gdXNlciBjYWxs
ZWQgdGhlIGhlbHBlciBpbmNvcnJlY3RseSB3aXRob3V0IEJQRl9GX0NVUlJFTlRfQ1BVLg0KPiA+
ID4gPiBCdXQgdGhhdCdzIGFuIGVycm9yIGFueXdheS4NCj4gPiA+IA0KPiA+ID4gTXkgbWFpbiB3
b3JyeSB3aXRoIHRoaXMgeGNoZygpIHRyaWNrIGlzIHRoYXQgd2UnbGwgbWlzcyB0byBleHBvcnQg
Y3J1Y2lhbA0KPiA+ID4gZGF0YSB3aXRoIHRoZSBFQlVTWSBiYWlsaW5nIG91dCBlc3BlY2lhbGx5
IGdpdmVuIG5lc3RpbmcgY291bGQgaW5jcmVhc2UgaW4NCj4gPiA+IGZ1dHVyZSBhcyB5b3Ugc3Rh
dGUsIHNvIHVzZXJzIG1pZ2h0IGhhdmUgYSBoYXJkIHRpbWUgZGVidWdnaW5nIHRoaXMga2luZCBv
Zg0KPiA+ID4gaXNzdWUgaWYgdGhleSBzaGFyZSB0aGUgc2FtZSBwZXJmIGV2ZW50IG1hcCBhbW9u
ZyB0aGVzZSBwcm9ncmFtcywgYW5kIG5vDQo+ID4gPiBvcHRpb24gdG8gZ2V0IHRvIHRoaXMgZGF0
YSBvdGhlcndpc2UuIFN1cHBvcnRpbmcgbmVzdGluZyB1cCB0byBhIGNlcnRhaW4NCj4gPiA+IGxl
dmVsIHdvdWxkIHN0aWxsIGJlIGJldHRlciB0aGFuIGEgbG9zdCBldmVudCB3aGljaCBpcyBhbHNv
IG5vdCByZXBvcnRlZA0KPiA+ID4gdGhyb3VnaCB0aGUgdXN1YWwgd2F5IGFrYSBwZXJmIHJiLg0K
DQpUcmFjaW5nIGNhbiBhbHJlYWR5IGJlIGxvc3N5OiB0cmFjZV9jYWxsX2JwZigpIHNpbGVudGx5
IHNpbXBseSBkb2Vzbid0DQpjYWxsIHRoZSBwcm9nIGFuZCBpbnN0ZWFkIHJldHVybnMgemVybyBp
ZiBicGZfcHJvZ19hY3RpdmUgIT0gMS4NCg0KPiA+IA0KPiA+IEkgc2ltcGx5IGRvbid0IHNlZSB0
aGlzICdtaXNzIHRvIGV4cG9ydCBkYXRhJyBpbiBhbGwgYnV0IGNvbnRyaXZlZCBjb25kaXRpb25z
Lg0KPiA+IFNheSB0d28gcHJvZ3Mgc2hhcmUgdGhlIHNhbWUgcGVyZiBldmVudCBhcnJheS4NCj4g
PiBPbmUgcHJvZyBjYWxscyBldmVudF9vdXRwdXQgYW5kIHdoaWxlIHJiIGxvZ2ljIGlzIHdvcmtp
bmcNCj4gPiBhbm90aGVyIHByb2cgbmVlZHMgdG8gc3RhcnQgZXhlY3V0aW5nIGFuZCB1c2UgdGhl
IHNhbWUgZXZlbnQgYXJyYXkNCj4gDQo+IENvcnJlY3QuDQo+IA0KPiA+IHNsb3QuIFRvZGF5IGl0
J3Mgb25seSBwb3NzaWJsZSBmb3IgdHJhY2luZyBwcm9nIGNvbWJpbmVkIHdpdGggbmV0d29ya2lu
ZywNCj4gPiBidXQgaGF2aW5nIHR3byBwcm9ncyB1c2UgdGhlIHNhbWUgZXZlbnQgb3V0cHV0IGFy
cmF5IGlzIHByZXR0eSBtdWNoDQo+ID4gYSB1c2VyIGJ1Zy4gSnVzdCBsaWtlIG5vdCBwYXNzaW5n
IEJQRl9GX0NVUlJFTlRfQ1BVLg0KPiANCj4gSSBkb24ndCBzZWUgdGhlIHVzZXIgYnVnIHBhcnQs
IHdoeSBzaG91bGQgdGhhdCBiZSBhIHVzZXIgYnVnPyBJdCdzIHRoZSBzYW1lDQo+IGFzIGlmIHdl
IHdvdWxkIHNheSB0aGF0IHNoYXJpbmcgYSBCUEYgaGFzaCBtYXAgYmV0d2VlbiBuZXR3b3JraW5n
IHByb2dyYW1zDQo+IGF0dGFjaGVkIHRvIGRpZmZlcmVudCBob29rcyBvciBuZXR3b3JraW5nIGFu
ZCB0cmFjaW5nIHdvdWxkIGJlIGEgdXNlciBidWcNCj4gd2hpY2ggaXQgaXMgbm90LiBPbmUgY29u
Y3JldGUgZXhhbXBsZSB3b3VsZCBiZSBjaWxpdW0gbW9uaXRvciB3aGVyZSB3ZQ0KPiBjdXJyZW50
bHkgZXhwb3NlIHNrYiB0cmFjZSBhbmQgZHJvcCBldmVudHMgYSB3ZWxsIGFzIGRlYnVnIGRhdGEg
dGhyb3VnaA0KPiB0aGUgc2FtZSByYi4gVGhpcyBzaG91bGQgYmUgdXNhYmxlIGZyb20gYW55IHR5
cGUgdGhhdCBoYXMgcGVyZl9ldmVudF9vdXRwdXQNCj4gaGVscGVyIGVuYWJsZWQgKGUuZy4gWERQ
IGFuZCB0Yy9CUEYpIHcvbyByZXF1aXJpbmcgdG8gd2FsayB5ZXQgYW5vdGhlciBwZXINCj4gY3B1
IG1tYXAgcmIgZnJvbSB1c2VyIHNwYWNlLg0KDQpOZWl0aGVyIG9mIHRoZXNlIHNvbHV0aW9ucyB3
b3VsZCBhZmZlY3QgdGhlIGJlaGF2aW9yIG9mIHNoYXJpbmcgdGhlDQpwZXJmIGFycmF5IGJldHdl
ZW4gbmV0d29ya2luZyBwcm9ncmFtcyAtLSBzaW5jZSB0aGV5J3JlIG5ldmVyIGNhbGxlZCBpbg0K
YSBuZXN0ZWQgZmFzaGlvbiwgdGhlbiB5b3UnbGwgbmV2ZXIgaGl0IHRoZSAieGNoZygpIHJldHVy
bmVkIE5VTEwiIGF0DQphbGwuDQoNClRoYXQgc2FpZCwgSSB0aGluayBJIGNhbiBsb2dpY2FsbHkg
bGltaXQgbmVzdGluZyBpbiB0cmFjaW5nIHRvIDMNCmxldmVsczoNCiAgLSBhIGtwcm9iZSBvciBy
YXcgdHAgb3IgcGVyZiBldmVudCwNCiAgLSBhbm90aGVyIG9uZSBvZiB0aGUgYWJvdmUgdGhhdCBp
cnEgY29udGV4dCBoYXBwZW5zIHRvIHJ1biwgYW5kDQogIC0gaWYgd2UncmUgcmVhbGx5IHVubHVj
a3ksIHRoZSBzYW1lIGluIG5taQ0KYXQgbW9zdCBvbmUgb2Ygd2hpY2ggY2FuIGJlIGEga3Byb2Jl
IG9yIHBlcmYgZXZlbnQuDQoNClRoZXJlIGlzIGFsc28gYSBjb21tZW50DQoNCi8qDQogKiBicGZf
cmF3X3RwX3JlZ3MgYXJlIHNlcGFyYXRlIGZyb20gYnBmX3B0X3JlZ3MgdXNlZCBmcm9tIHNrYi94
ZHANCiAqIHRvIGF2b2lkIHBvdGVudGlhbCByZWN1cnNpdmUgcmV1c2UgaXNzdWUgd2hlbi9pZiB0
cmFjZXBvaW50cyBhcmUgYWRkZWQNCiAqIGluc2lkZSBicGZfKl9ldmVudF9vdXRwdXQsIGJwZl9n
ZXRfc3RhY2tpZCBhbmQvb3IgYnBmX2dldF9zdGFjaw0KICovDQoNCnRoYXQgc3VnZ2VzdHMgdGhh
dCBvbmUgZGF5IGJwZl9wZXJmX2V2ZW50X291dHB1dCBtaWdodCBncm93IGEgc3RhdGljDQp0cmFj
ZXBvaW50LiAgSG93ZXZlciwgaWYgdGhlIHByb2dyYW0gYXR0YWNoZWQgdG8gc3VjaCBhIGh5cG90
aGV0aWNhbA0KdHJhY2Vwb2ludCB3ZXJlIHRvIGNhbGwgYnBmX3BlcmZfZXZlbnRfb3V0cHV0LCB0
aGF0IHdvdWxkIGluZmluaXRlbHkNCnJlY3Vyc2UgLi4uIGl0IHNlZW1zIGZpbmUgdG8gbGV0IHRo
YXQgY2FzZSByZXR1cm4gLUVCVVNZIGFzIHdlbGwuICBJdA0KZG9lcyBtYWtlIG1lIHdvbmRlciBp
ZiBJIHNob3VsZCBkbyB0aGUgc2FtZSBuZXN0aW5nIGZvciB0aGUgcHRfcmVncy4NCg0KSSd2ZSBu
b3cgZ290IGFuIGV4cGVyaW1lbnQgcnVubmluZyB3aXRoIHRoZSBjb3VudGVyIGFwcHJvYWNoLCBh
bmQgdGhlDQp3b3JrbG9hZCB0aGF0IEkgaGl0IHRoZSBvcmlnaW5hbCBjcmFzaCB3aXRoIHNlZW1z
IHRvIGJlIGZpbmUgd2l0aCAyDQpsYXllcnMnIHdvcnRoIC0tIHRob3VnaCBpZiB3ZSBkZWNpZGUg
dGhhdCdzIHRoZSBvbmUgSSBzaG91bGQgbW92ZQ0KZm9yd2FyZCB3aXRoLCBJJ2xsIHByb2JhYmx5
IGJ1bXAgaXQgdG8gYSB0aGlyZCB0byBiZSBzYWZlIGZvciBhbiBOTUkuDQo=
