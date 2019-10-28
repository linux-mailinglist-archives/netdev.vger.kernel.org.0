Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A45E7544
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfJ1PfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:35:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbfJ1PfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:35:13 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SFLW0V007336;
        Mon, 28 Oct 2019 08:35:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ET+u2mI60eMAjDX9Qb1c2myTHgzqJP5F0PN0r8QkHIk=;
 b=W3j7LjTG1hCYyWAJSZfnJP+66gUZeIMTUUFyAcruzs7Fhy4DyaDyje991XuPeYF4dhjm
 v7R7Ms8cRhYvuoSz+bSAjcV68D4kh4fgFtxk8Qu1BEFGDy7en30N78Dw9Y4GrSsZZCd8
 EsHSQIvzBsuT4l18BIMEL/l+bfxwMWMo5TQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vw5tednfn-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Oct 2019 08:35:11 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 28 Oct 2019 08:35:02 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Oct 2019 08:35:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGR8A58T71kLpIk0XNwEpOfIoMGcpk8CXS/6YjpcBq89Rhjc3KhYSm1D8dnQao+3E/USpMEhemVy9pT7U4h/zrpPa3utm9/lD9LWb+eI2++7kL1TvPkFUfpbq7xPzCHM4J2NWN/3EAF9NmvBTmTgYWgbClgykWpsvulnP3M1GZJMqFY8CCIS8ZtJFufwwdBe1B0jK2QuDbC7IlmNEy8d/M/3lGMpLj0qzxFLa2nfRnXFtNSxELHSoIh933VcBdfGK0Qs9SUF6dWLzwkN/dCzqGPV9RtOR8WNyC8/OhQlO9oSTKEW/RoZRdCkJ+VXyC5ui4BHfwGc+60UOvfMXEPGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ET+u2mI60eMAjDX9Qb1c2myTHgzqJP5F0PN0r8QkHIk=;
 b=YwVhKSJTRDhLAmvGs1WA5+l/3tMfIwbwStpM0ok/QyYEG+DLpIqyhRjRz0771rVCWsBnTtk6UvlWvtY0SUKGKJd5Zb2JhGN8qxdFregZ2IojAlgF5Wwy0WVZcMtKKv4cgYm5Yo/90x37496Pbuv0uTtTTBVVM+a/+Q+D6x2yNSBZJEQX4yZS+DRmYuu+nN/CsAr585EhB/mhcPDGlaExeR7HRusk9sxaXTDY7ldjNyOhj1yTbjU/ybhBlzcNK/RvuxifNG2UBu3DWJePBHyV8g8z26muB43AJWbMWnSNNYMt+H9eoMEfZfD1T9gOIACsaUvDTojLV+hJ6UkMcT+smw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ET+u2mI60eMAjDX9Qb1c2myTHgzqJP5F0PN0r8QkHIk=;
 b=Yu74xA04AAeqiwkv3ugvVvLrLnb77eQIjaJBR/ihtcHCMfSNY9wEh+e2qRiHQJoIQhiOmHfxjJvelXXxQSgFBMPrMW0OEoK6bYme19gMSMyop3JRS4shdQpVzLXceEGIPdzHcA89RS1lEbeQfobsRfVodI9pwTHI/izqdenJbAU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2552.namprd15.prod.outlook.com (20.179.154.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Mon, 28 Oct 2019 15:35:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.021; Mon, 28 Oct 2019
 15:35:00 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Topic: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Thread-Index: AQHViQ10L4Sk4Hu3bUSGIRdEQH4YW6dnizGAgAitNYA=
Date:   Mon, 28 Oct 2019 15:34:59 +0000
Message-ID: <63882673-849d-cae3-1432-1d9411c10348@fb.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-2-cneirabustos@gmail.com>
 <7b7ba580-14f8-d5aa-65d5-0d6042e7a566@fb.com>
In-Reply-To: <7b7ba580-14f8-d5aa-65d5-0d6042e7a566@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0012.namprd10.prod.outlook.com
 (2603:10b6:301:2a::25) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:ec6a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2b0fa7e-a22b-413f-4af3-08d75bbc64a6
x-ms-traffictypediagnostic: BYAPR15MB2552:
x-microsoft-antispam-prvs: <BYAPR15MB2552E91DE5467A7C26006A7AD3660@BYAPR15MB2552.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(39860400002)(136003)(366004)(189003)(199004)(71190400001)(8936002)(25786009)(71200400001)(486006)(76176011)(2616005)(52116002)(14454004)(66946007)(256004)(64756008)(66446008)(6512007)(66556008)(8676002)(81166006)(66476007)(316002)(99286004)(81156014)(5660300002)(31686004)(31696002)(36756003)(110136005)(2501003)(6486002)(54906003)(478600001)(229853002)(446003)(86362001)(305945005)(7736002)(6436002)(46003)(186003)(2906002)(6506007)(11346002)(386003)(6116002)(4326008)(53546011)(102836004)(476003)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2552;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jFALu2FKKB5Fwq+xsmJTlMig875DpahhMVbOupKOwKJUEjf9noD/rlzXUjlXQe7XeQHiWH1aAA1RKcw+2wES8/zbn8Tov5ezUq4WNoT5n1/ylDE/66Mcw48ah6i60+XYCT8Z3jV1QWRjrLqlgFaUNZl6270+u1yItgMVx7ZfphU94oSCRhk3r39DYjpJ4Mpx6YaPd94Ia5sZreasXVc8VjX1sh5NQabLeOAuTBtXHecxIpBA2Zgp4iQvEELWttW4Kt1zFyjluQdXrTbGzV9D7YVRiQ5Bp+tRQuwrrTNdyII2c0Xw1KJY5kdvjm1350tGxRkmROzY5JT5+g+qwaInXaxIj3zDy4s/jKnPp/LwLOjQyW7hFu14aJw/ExWuzQq001G5WGFRBhwO7MuNqY9sHcSyoOZfAvFzReq44sG/EiLS5yNfdtFwoRl69EErPQX0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E45F61F4A6077C4A814A35F8F370B73E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b0fa7e-a22b-413f-4af3-08d75bbc64a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 15:34:59.9352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/nZbVX4gJIV3TfTVyHhk6/vVLB0mn3DgrlkMLTdrk6LOs1O25TYOkpNNUQcVjiX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_06:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910280156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGluZyBhZ2Fpbi4NCg0KRXJpYywgY291bGQgeW91IHRha2UgYSBsb29rIGF0IHRoaXMgcGF0Y2gg
YW5kIGFjayBpdCBpZiBpdCBpcyBva2F5Pw0KDQpUaGFua3MhDQoNCg0KT24gMTAvMjIvMTkgODow
NSBQTSwgWW9uZ2hvbmcgU29uZyB3cm90ZToNCj4gDQo+IEhpLCBFcmljLA0KPiANCj4gQ291bGQg
eW91IHRha2UgYSBsb29rIGF0IHRoaXMgcGF0Y2ggdGhlIHNlcmllcyBhcyB3ZWxsPw0KPiBJZiBp
dCBsb29rcyBnb29kLCBjb3VsZCB5b3UgYWNrIHRoZSBwYXRjaCAjMT8NCj4gDQo+IFRoYW5rcyEN
Cj4gDQo+IE9uIDEwLzIyLzE5IDEyOjE3IFBNLCBDYXJsb3MgTmVpcmEgd3JvdGU6DQo+PiBuc19t
YXRjaCByZXR1cm5zIHRydWUgaWYgdGhlIG5hbWVzcGFjZSBpbm9kZSBhbmQgZGV2X3QgbWF0Y2hl
cyB0aGUgb25lcw0KPj4gcHJvdmlkZWQgYnkgdGhlIGNhbGxlci4NCj4+DQo+PiBTaWduZWQtb2Zm
LWJ5OiBDYXJsb3MgTmVpcmEgPGNuZWlyYWJ1c3Rvc0BnbWFpbC5jb20+DQo+PiAtLS0NCj4+ICAg
IGZzL25zZnMuYyAgICAgICAgICAgICAgIHwgMTQgKysrKysrKysrKysrKysNCj4+ICAgIGluY2x1
ZGUvbGludXgvcHJvY19ucy5oIHwgIDIgKysNCj4+ICAgIDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5z
ZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9mcy9uc2ZzLmMgYi9mcy9uc2ZzLmMNCj4+
IGluZGV4IGEwNDMxNjQyYzZiNS4uZWY1OWNmMzQ3Mjg1IDEwMDY0NA0KPj4gLS0tIGEvZnMvbnNm
cy5jDQo+PiArKysgYi9mcy9uc2ZzLmMNCj4+IEBAIC0yNDUsNiArMjQ1LDIwIEBAIHN0cnVjdCBm
aWxlICpwcm9jX25zX2ZnZXQoaW50IGZkKQ0KPj4gICAgCXJldHVybiBFUlJfUFRSKC1FSU5WQUwp
Ow0KPj4gICAgfQ0KPj4gICAgDQo+PiArLyoqDQo+PiArICogbnNfbWF0Y2goKSAtIFJldHVybnMg
dHJ1ZSBpZiBjdXJyZW50IG5hbWVzcGFjZSBtYXRjaGVzIGRldi9pbm8gcHJvdmlkZWQuDQo+PiAr
ICogQG5zX2NvbW1vbjogY3VycmVudCBucw0KPj4gKyAqIEBkZXY6IGRldl90IGZyb20gbnNmcyB0
aGF0IHdpbGwgYmUgbWF0Y2hlZCBhZ2FpbnN0IGN1cnJlbnQgbnNmcw0KPj4gKyAqIEBpbm86IGlu
b190IGZyb20gbnNmcyB0aGF0IHdpbGwgYmUgbWF0Y2hlZCBhZ2FpbnN0IGN1cnJlbnQgbnNmcw0K
Pj4gKyAqDQo+PiArICogUmV0dXJuOiB0cnVlIGlmIGRldiBhbmQgaW5vIG1hdGNoZXMgdGhlIGN1
cnJlbnQgbnNmcy4NCj4+ICsgKi8NCj4+ICtib29sIG5zX21hdGNoKGNvbnN0IHN0cnVjdCBuc19j
b21tb24gKm5zLCBkZXZfdCBkZXYsIGlub190IGlubykNCj4+ICt7DQo+PiArCXJldHVybiAobnMt
PmludW0gPT0gaW5vKSAmJiAobnNmc19tbnQtPm1udF9zYi0+c19kZXYgPT0gZGV2KTsNCj4+ICt9
DQo+PiArDQo+PiArDQo+PiAgICBzdGF0aWMgaW50IG5zZnNfc2hvd19wYXRoKHN0cnVjdCBzZXFf
ZmlsZSAqc2VxLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpDQo+PiAgICB7DQo+PiAgICAJc3RydWN0
IGlub2RlICppbm9kZSA9IGRfaW5vZGUoZGVudHJ5KTsNCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L3Byb2NfbnMuaCBiL2luY2x1ZGUvbGludXgvcHJvY19ucy5oDQo+PiBpbmRleCBkMzFj
YjYyMTU5MDUuLjFkYTlmMzM0ODlmMyAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvcHJv
Y19ucy5oDQo+PiArKysgYi9pbmNsdWRlL2xpbnV4L3Byb2NfbnMuaA0KPj4gQEAgLTgyLDYgKzgy
LDggQEAgdHlwZWRlZiBzdHJ1Y3QgbnNfY29tbW9uICpuc19nZXRfcGF0aF9oZWxwZXJfdCh2b2lk
ICopOw0KPj4gICAgZXh0ZXJuIHZvaWQgKm5zX2dldF9wYXRoX2NiKHN0cnVjdCBwYXRoICpwYXRo
LCBuc19nZXRfcGF0aF9oZWxwZXJfdCBuc19nZXRfY2IsDQo+PiAgICAJCQkgICAgdm9pZCAqcHJp
dmF0ZV9kYXRhKTsNCj4+ICAgIA0KPj4gK2V4dGVybiBib29sIG5zX21hdGNoKGNvbnN0IHN0cnVj
dCBuc19jb21tb24gKm5zLCBkZXZfdCBkZXYsIGlub190IGlubyk7DQo+PiArDQo+PiAgICBleHRl
cm4gaW50IG5zX2dldF9uYW1lKGNoYXIgKmJ1Ziwgc2l6ZV90IHNpemUsIHN0cnVjdCB0YXNrX3N0
cnVjdCAqdGFzaywNCj4+ICAgIAkJCWNvbnN0IHN0cnVjdCBwcm9jX25zX29wZXJhdGlvbnMgKm5z
X29wcyk7DQo+PiAgICBleHRlcm4gdm9pZCBuc2ZzX2luaXQodm9pZCk7DQo+Pg0K
