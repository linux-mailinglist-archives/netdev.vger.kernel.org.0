Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27971449D4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAVCdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:33:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10288 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgAVCdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:33:54 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00M2X9PR017417;
        Tue, 21 Jan 2020 18:33:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4TNixnkwGpZojz2/ONQuoQRSJwL3XR05Bl8wKeoXjr0=;
 b=gnC7OlNIKLOWrHGwkA8u2ujkGAAHP/A9Wr32s0eEOq/D3v+3kZSqi1kIwt7RPo0Ut5+K
 cAwztdgCUh5HENTP3j3M8YJ+Z/Qi2ki2YT2vMzbDo9Tmze5u9i+8zTtH7j5XjOKJPOAi
 l2eR4J9fT41XDkb2Dh2vJn//V7aR7Pz//0w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xp5vs263p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jan 2020 18:33:36 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 18:33:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQsTxiY0Ne7PrPUeEWWjwbrnKO/0w0yVmjMJMo2A7m6D3ZP/BljSroHTKyefRHQKmyeyza5qUQOD5fwI4G3tic5qrF0Etdi5Z3g9ZOfQ/4VJ6xxwA7z4nlc0KrPSArCVGMJtUWn1hQvtjaDstoTNIqUnq/eUWF68hIc1ObqWf/K7KpqZ8xFuzUZURBeINaAtEcBRo1usg4+Y5JJ1EXy2zYD9epwJmixsDo5m8sSAGFZXAkP2LVX1Nd/lB0Chxt0LdUUShzq/8K58lJgIKBu0vtU+nWrHXExxUYvvkqJCLILDL+PPeHPBmDKAr1sHY4QwXFswG6/jJH4PkRbtQ2Kawg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TNixnkwGpZojz2/ONQuoQRSJwL3XR05Bl8wKeoXjr0=;
 b=M3Qi0jsWTPClLIyc5gk/7+TBN5G4xwXNB0xUJ3xb0bgTiIM5FpzPK30njAz+n1FiJhvyuH8aHvRnmTozPgCVNto/zhuDXS2DMJ5K5vr/CiwXrmm5A3nNCexu4/gPkVUZtJz7tfp+IgPinwttIV1KOcYi0FwkscsD8+BDw8xDV9d9nJqEfqwiGKQbCu0aLqN2mx+/cE3JlVrLFG5603OLYSMQTNxc2E38vT9p75lJ6RnXOhEMX8UGES4qF0hZPG/rEnQh24Sa+9q9TpN7YhOCLTMoK0dE5WjSZEh+qvV54S95kso9zKPI6jbKa3sjb1W0Xcbzq0yKdE1aO/monuIDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TNixnkwGpZojz2/ONQuoQRSJwL3XR05Bl8wKeoXjr0=;
 b=Hy9Ajcl7c6hGY1vgQigFL303qDh8ndX8vjL1S3xeDgm5J/lZMPkqnYZfxbj1VyNxymNucS2bpTGZSjIHJ7vRuc0augCWJ3fkgqV/KTazml7TtzNNmWw1PNA23z/rzU3Rw0DWTKs3i0oGbpfYbccBX2YuhVCsA8E2WhIKEdpufuQ=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2730.namprd15.prod.outlook.com (20.179.164.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 22 Jan 2020 02:33:33 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 02:33:32 +0000
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:180::e4be) by MWHPR19CA0062.namprd19.prod.outlook.com (2603:10b6:300:94::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 22 Jan 2020 02:33:26 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Network Development" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Andrii Nakryiko" <andriin@fb.com>,
        Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
Thread-Topic: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
Thread-Index: AQHV0FMSFTeCn9jLiEyzGRfl2CvGYqf17DIAgAALywA=
Date:   Wed, 22 Jan 2020 02:33:32 +0000
Message-ID: <0e114cc9-421d-a30d-db40-91ec7a2a7a34@fb.com>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-2-jolsa@kernel.org>
 <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
In-Reply-To: <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0062.namprd19.prod.outlook.com
 (2603:10b6:300:94::24) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::e4be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e166064a-abe7-46f4-8278-08d79ee3795e
x-ms-traffictypediagnostic: DM6PR15MB2730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB27304B814C988DE9D19B7D52D30C0@DM6PR15MB2730.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(366004)(136003)(346002)(199004)(189003)(478600001)(66446008)(5660300002)(8676002)(64756008)(81156014)(8936002)(66476007)(66556008)(31686004)(81166006)(52116002)(53546011)(36756003)(6506007)(4326008)(6666004)(54906003)(110136005)(7416002)(316002)(86362001)(2906002)(71200400001)(31696002)(66946007)(2616005)(6512007)(186003)(16526019)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2730;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hCU2nS7/Un6s4ANmhz5Z3RnGC0El+lK027KrkdCxSp5+miBpUEImXPbs4t8628H8uOi6Lpc6aGtc5rVSqnsrJd52iEbAcNprTG4/ZpsO31LQC31M5VTxinRA5OYnJr3E4SmRMCyQ6lZHxoeNitqGKKboJuzoz7nBhrEBL+4uLb1XAWZCHPfGz1oMwaKka8qFMPiiNqGVLJDQnqpIa+wa5JN32d57jioWnjfLzW3bAnixtWjqZNI1cmC1ZweznQs1mBgfaZ7GCv8vC8zszAqW2S1Z7p13a/mOIdX6QBis9NqCup4nNrhV9qjHdJ32LfVsrRi+RGnwNW14nV7WpZvtUM82/Q7S/z69TQIdi/gz8iFz3vPBacfZzOQQ9yMeZG3C1Pf3Uwg2xb8fRGSlinCWDJav+T2205Eb/+r57XUg9eEb1/EAaJSPcxXlyeGUIaAF
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BA937CC07FE6049A8DCD0843F40728D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e166064a-abe7-46f4-8278-08d79ee3795e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 02:33:32.9344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQ0e+yu9hx7dXlxNIzGkU1V7np8nSKgmlw+rqI2oc56p/Dkq3vl+mRAEt5/xksHy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2730
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=988
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220018
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMjEvMjAgNTo1MSBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBPbiBU
dWUsIEphbiAyMSwgMjAyMCBhdCA0OjA1IEFNIEppcmkgT2xzYSA8am9sc2FAa2VybmVsLm9yZz4g
d3JvdGU6DQo+Pg0KPj4gV2hlbiBhY2Nlc3NpbmcgdGhlIGNvbnRleHQgd2UgYWxsb3cgYWNjZXNz
IHRvIGFyZ3VtZW50cyB3aXRoDQo+PiBzY2FsYXIgdHlwZSBhbmQgcG9pbnRlciB0byBzdHJ1Y3Qu
IEJ1dCB3ZSBvbWl0IHBvaW50ZXIgdG8gc2NhbGFyDQo+PiB0eXBlLCB3aGljaCBpcyB0aGUgY2Fz
ZSBmb3IgbWFueSBmdW5jdGlvbnMgYW5kIHNhbWUgY2FzZSBhcw0KPj4gd2hlbiBhY2Nlc3Npbmcg
c2NhbGFyLg0KPj4NCj4+IEFkZGluZyB0aGUgY2hlY2sgaWYgdGhlIHBvaW50ZXIgaXMgdG8gc2Nh
bGFyIHR5cGUgYW5kIGFsbG93IGl0Lg0KPj4NCj4+IEFja2VkLWJ5OiBKb2huIEZhc3RhYmVuZCA8
am9obi5mYXN0YWJlbmRAZ21haWwuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogSmlyaSBPbHNhIDxq
b2xzYUBrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgIGtlcm5lbC9icGYvYnRmLmMgfCAxMyArKysr
KysrKysrKystDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvYnRmLmMgYi9rZXJuZWwvYnBm
L2J0Zi5jDQo+PiBpbmRleCA4MzJiNWQ3ZmQ4OTIuLjIwN2FlNTU0ZTBjZSAxMDA2NDQNCj4+IC0t
LSBhL2tlcm5lbC9icGYvYnRmLmMNCj4+ICsrKyBiL2tlcm5lbC9icGYvYnRmLmMNCj4+IEBAIC0z
NjY4LDcgKzM2NjgsNyBAQCBib29sIGJ0Zl9jdHhfYWNjZXNzKGludCBvZmYsIGludCBzaXplLCBl
bnVtIGJwZl9hY2Nlc3NfdHlwZSB0eXBlLA0KPj4gICAgICAgICAgICAgICAgICAgICAgY29uc3Qg
c3RydWN0IGJwZl9wcm9nICpwcm9nLA0KPj4gICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGJw
Zl9pbnNuX2FjY2Vzc19hdXggKmluZm8pDQo+PiAgIHsNCj4+IC0gICAgICAgY29uc3Qgc3RydWN0
IGJ0Zl90eXBlICp0ID0gcHJvZy0+YXV4LT5hdHRhY2hfZnVuY19wcm90bzsNCj4+ICsgICAgICAg
Y29uc3Qgc3RydWN0IGJ0Zl90eXBlICp0cCwgKnQgPSBwcm9nLT5hdXgtPmF0dGFjaF9mdW5jX3By
b3RvOw0KPj4gICAgICAgICAgc3RydWN0IGJwZl9wcm9nICp0Z3RfcHJvZyA9IHByb2ctPmF1eC0+
bGlua2VkX3Byb2c7DQo+PiAgICAgICAgICBzdHJ1Y3QgYnRmICpidGYgPSBicGZfcHJvZ19nZXRf
dGFyZ2V0X2J0Zihwcm9nKTsNCj4+ICAgICAgICAgIGNvbnN0IGNoYXIgKnRuYW1lID0gcHJvZy0+
YXV4LT5hdHRhY2hfZnVuY19uYW1lOw0KPj4gQEAgLTM3MzAsNiArMzczMCwxNyBAQCBib29sIGJ0
Zl9jdHhfYWNjZXNzKGludCBvZmYsIGludCBzaXplLCBlbnVtIGJwZl9hY2Nlc3NfdHlwZSB0eXBl
LA0KPj4gICAgICAgICAgICAgICAgICAgKi8NCj4+ICAgICAgICAgICAgICAgICAgcmV0dXJuIHRy
dWU7DQo+Pg0KPj4gKyAgICAgICB0cCA9IGJ0Zl90eXBlX2J5X2lkKGJ0ZiwgdC0+dHlwZSk7DQo+
PiArICAgICAgIC8qIHNraXAgbW9kaWZpZXJzICovDQo+PiArICAgICAgIHdoaWxlIChidGZfdHlw
ZV9pc19tb2RpZmllcih0cCkpDQo+PiArICAgICAgICAgICAgICAgdHAgPSBidGZfdHlwZV9ieV9p
ZChidGYsIHRwLT50eXBlKTsNCj4+ICsNCj4+ICsgICAgICAgaWYgKGJ0Zl90eXBlX2lzX2ludCh0
cCkgfHwgYnRmX3R5cGVfaXNfZW51bSh0cCkpDQo+PiArICAgICAgICAgICAgICAgLyogVGhpcyBp
cyBhIHBvaW50ZXIgc2NhbGFyLg0KPj4gKyAgICAgICAgICAgICAgICAqIEl0IGlzIHRoZSBzYW1l
IGFzIHNjYWxhciBmcm9tIHRoZSB2ZXJpZmllciBzYWZldHkgcG92Lg0KPj4gKyAgICAgICAgICAg
ICAgICAqLw0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPiANCj4gVGhlIHJlYXNv
biBJIGRpZG4ndCBkbyBpdCBlYXJsaWVyIGlzIEkgd2FzIHRoaW5raW5nIHRvIHJlcHJlc2VudCBp
dA0KPiBhcyBQVFJfVE9fQlRGX0lEIGFzIHdlbGwsIHNvIHRoYXQgY29ycmVzcG9uZGluZyB1OC4u
dTY0DQo+IGFjY2VzcyBpbnRvIHRoaXMgbWVtb3J5IHdvdWxkIHN0aWxsIGJlIHBvc3NpYmxlLg0K
PiBJJ20gdHJ5aW5nIHRvIGFuYWx5emUgdGhlIHNpdHVhdGlvbiB0aGF0IHJldHVybmluZyBhIHNj
YWxhciBub3cNCj4gYW5kIGNvbnZlcnRpbmcgdG8gUFRSX1RPX0JURl9JRCBpbiB0aGUgZnV0dXJl
IHdpbGwga2VlcCBwcm9ncw0KPiBwYXNzaW5nIHRoZSB2ZXJpZmllci4gSXMgaXQgcmVhbGx5IHRo
ZSBjYXNlPw0KPiBDb3VsZCB5b3UgZ2l2ZSBhIHNwZWNpZmljIGV4YW1wbGUgdGhhdCBuZWVkcyB0
aGlzIHN1cHBvcnQ/DQo+IEl0IHdpbGwgaGVscCBtZSB1bmRlcnN0YW5kIHRoaXMgYmFja3dhcmQg
Y29tcGF0aWJpbGl0eSBjb25jZXJuLg0KPiBXaGF0IHByb2cgaXMgZG9pbmcgd2l0aCB0aGF0ICd1
MzIgKicgdGhhdCBpcyBzZWVuIGFzIHNjYWxhciA/DQo+IEl0IGNhbm5vdCBkZXJlZmVyZW5jZSBp
dC4gVXNlIGl0IGFzIHdoYXQ/DQoNCklmIHRoaXMgaXMgZnJvbSBvcmlnaW5hbCBiY2MgY29kZSwg
aXQgd2lsbCB1c2UgYnBmX3Byb2JlX3JlYWQgZm9yIA0KZGVyZWZlcmVuY2UuIFRoaXMgaXMgd2hh
dCBJIHVuZGVyc3RhbmQgd2hlbiBJIGZpcnN0IHJldmlld2VkIHRoaXMgcGF0Y2guDQpCdXQgaXQg
d2lsbCBiZSBnb29kIHRvIGdldCBKaXJpJ3MgY29uZmlybWF0aW9uLg0K
