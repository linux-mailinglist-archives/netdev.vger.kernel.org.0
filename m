Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF9A3F32
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfH3U4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:56:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727992AbfH3U4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:56:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UKrGpn019694;
        Fri, 30 Aug 2019 13:55:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nQ/45DG/N1bdBGASZXSCfF/A9fRzn8qrX+kSqmwcijs=;
 b=FYwzSegLFl4TMukkZ04xK0TX9wPYwEQ9nzT6DF9XEPyadfbxiPd/R6SIYHV7CO0FAmdn
 u/qIbZ2sFQ+V8G5KaURvarssszDknPu+K8ifLzQpwvuRljoC6QhZq29xEFoLjzM3Bi9l
 4OnWCLC9K8t0oJQVdyp3LOvh2wKI8JWhISM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uq6br9m9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 13:55:35 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 13:55:35 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 13:55:34 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 13:55:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC9YACKyckiJ7yFnsdkar8V51WGJztPWN+sxR1PFOPGpqFeNH3L2CGbUQ5KbwJeo8vBe5snE5U3S0V4HSAbT+kfydcMke5chlxTJIEcIR3E68Ml/bCpNt9OZScfL2r/lrOmoPgaXbF7AZ4kgMY35DPablQ//bBbAhSkeWVlxXmmInlXpWHJKJUJGhFSmSiQsNJXlO4yO/WaLozHhoK7KQgKF8KMJrs+ait8c1FNThDGSkLfiCeLZvxqr7Vt1aIhzeFtWVOKV17cEsH+72kZboqIgoBqLRUBzTtOo9rqA6XmGYkL0uwc0YVpJUTkKBLtSTXhe8JSBAAbAvLDk6DZjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQ/45DG/N1bdBGASZXSCfF/A9fRzn8qrX+kSqmwcijs=;
 b=Ji715tQYAaLLaDsSj+G1rAA8s+R1ZGmBzITHs2lOfQEuQ/UdYLx+G45uO2M4KryuDKqZ/IovmH0pRTNtq55HE94njAZa/hSXr4ewT9YnJa8Z+t7QBm9vPp/Z/sYycRelAat3lVjdsMzcQZxqWkarseDiS1VvboS4TLzq+yGI9lQpF4KtJKAxur0hcfOhOfJuPiIhz6CK+P6a3O3b1CnnihfFaId8NwYYdy4ykJh6k1VNYf3xJt5Tob67myf9ccw+51n/1s6F2v0Q/1tP4BMiyU7RJEKLKXjRBPTAi8T0at+2sA9Zmgewn9pVq7yFk+jxitw1wuFMOMt9O22HS6mu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQ/45DG/N1bdBGASZXSCfF/A9fRzn8qrX+kSqmwcijs=;
 b=TJMUG27qzgl3ExyuWQaGZUSFLZxbga7fmTjVCEbF8K8qhnV5Mrg2aV51WxJKAdG5M87C7hH17u2FIF7cKd6KPN4uDMWInc03KjEb0zXDTCuNQAWCid1JhtqL2CiXwZQ6r6XCjI165ueyrMmQDd+7MegBc+wlMwXHhJ1DzP0/uyY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2469.namprd15.prod.outlook.com (52.135.196.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Fri, 30 Aug 2019 20:55:33 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 20:55:33 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Topic: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Index: AQHVXjVV7RBe3Y+1zUuAbrXegepHf6cSdccAgABMroCAABEcgIABT0aAgAALQgA=
Date:   Fri, 30 Aug 2019 20:55:33 +0000
Message-ID: <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
In-Reply-To: <20190830201513.GA2101@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:104:5::24) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:dd98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 081d2c2f-33ce-4474-8d10-08d72d8c665b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2469;
x-ms-traffictypediagnostic: BYAPR15MB2469:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2469DDE8D273F57702D236DDD3BD0@BYAPR15MB2469.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(256004)(66556008)(6486002)(478600001)(229853002)(53936002)(386003)(6506007)(6512007)(71190400001)(14454004)(2906002)(102836004)(71200400001)(6116002)(52116002)(76176011)(53546011)(36756003)(2616005)(31686004)(8676002)(86362001)(66946007)(25786009)(81156014)(81166006)(186003)(305945005)(7736002)(8936002)(66446008)(6436002)(476003)(64756008)(110136005)(561944003)(66476007)(31696002)(316002)(486006)(6246003)(11346002)(5660300002)(99286004)(446003)(4326008)(54906003)(46003)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2469;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YIlAPsT06l6Cg1QBMZ98gfoLDIwRPTLlTbJEIU7U1pSaTPCTgR+dByzdDiV1zoLMfF5A3y7hIiigFsefW1ozMuQ3B3VoqNO7tDqASp37mkRhSXDksoC4EnwPANJz32dtQT7rLP193pP9MxezbIVw4ma7CUcBeEFC7MKG7jOtxKY9jiuLsLe5GumNnhSisnSpp/bIzvKObUX/00KjpHBqNne9ox+mBkKmR166f5XIfSHmF5ImzmriVSKsnipeAe2LmbiP4+RyRxXKdN678XTKFiDNTVCap00us5tKwLdpayU7o+41wOuX3ZNf6Q/pKdNucBJ04ILFB4uUassJZJBVPIQOFVmu2KKKiN4WJHYyPjuWPNpMs1oiAHz6zb+y+40OB1Hbq+s1+KkoOuM435XiUAkGegDl18Ww+For8vlQTCQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16B4FCB980C42841AD09E6E5BF81468B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 081d2c2f-33ce-4474-8d10-08d72d8c665b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 20:55:33.4630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zV1lOPP5fRLSxhMDOp9PSGFVaY+PxybP08X+WyaxYJbboGMB7rfvCEk6QLPtdZzD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2469
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_07:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMzAvMTkgMToxNSBQTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBPbiAw
OC8yOSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+PiBPbiBUaHUsIDI5IEF1ZyAyMDE5IDE2OjEz
OjU5IC0wNzAwLCBCcmlhbiBWYXpxdWV6IHdyb3RlOg0KPj4+PiBXZSBuZWVkIGEgcGVyLW1hcCBp
bXBsZW1lbnRhdGlvbiBvZiB0aGUgZXhlYyBzaWRlLCBidXQgcm91Z2hseSBtYXBzDQo+Pj4+IHdv
dWxkIGRvOg0KPj4+Pg0KPj4+PiAgICAgICAgICBMSVNUX0hFQUQoZGVsZXRlZCk7DQo+Pj4+DQo+
Pj4+ICAgICAgICAgIGZvciBlbnRyeSBpbiBtYXAgew0KPj4+PiAgICAgICAgICAgICAgICAgIHN0
cnVjdCBtYXBfb3BfY3R4IHsNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgIC5rZXkgICAg
PSBlbnRyeS0+a2V5LA0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgLnZhbHVlICA9IGVu
dHJ5LT52YWx1ZSwNCj4+Pj4gICAgICAgICAgICAgICAgICB9Ow0KPj4+Pg0KPj4+PiAgICAgICAg
ICAgICAgICAgIGFjdCA9IEJQRl9QUk9HX1JVTihmaWx0ZXIsICZtYXBfb3BfY3R4KTsNCj4+Pj4g
ICAgICAgICAgICAgICAgICBpZiAoYWN0ICYgfkFDVF9CSVRTKQ0KPj4+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+Pj4+DQo+Pj4+ICAgICAgICAgICAgICAgICAg
aWYgKGFjdCAmIERFTEVURSkgew0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgbWFwX3Vu
bGluayhlbnRyeSk7DQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBsaXN0X2FkZChlbnRy
eSwgJmRlbGV0ZWQpOw0KPj4+PiAgICAgICAgICAgICAgICAgIH0NCj4+Pj4gICAgICAgICAgICAg
ICAgICBpZiAoYWN0ICYgU1RPUCkNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFr
Ow0KPj4+PiAgICAgICAgICB9DQo+Pj4+DQo+Pj4+ICAgICAgICAgIHN5bmNocm9uaXplX3JjdSgp
Ow0KPj4+Pg0KPj4+PiAgICAgICAgICBmb3IgZW50cnkgaW4gZGVsZXRlZCB7DQo+Pj4+ICAgICAg
ICAgICAgICAgICAgc3RydWN0IG1hcF9vcF9jdHggew0KPj4+PiAgICAgICAgICAgICAgICAgICAg
ICAgICAgLmtleSAgICA9IGVudHJ5LT5rZXksDQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAudmFsdWUgID0gZW50cnktPnZhbHVlLA0KPj4+PiAgICAgICAgICAgICAgICAgIH07DQo+Pj4+
DQo+Pj4+ICAgICAgICAgICAgICAgICAgQlBGX1BST0dfUlVOKGR1bXBlciwgJm1hcF9vcF9jdHgp
Ow0KPj4+PiAgICAgICAgICAgICAgICAgIG1hcF9mcmVlKGVudHJ5KTsNCj4+Pj4gICAgICAgICAg
fQ0KPj4+PiAgIA0KPj4+IEhpIEpha3ViLA0KPj4+DQo+Pj4gaG93IHdvdWxkIHRoYXQgYXBwcm9h
Y2ggc3VwcG9ydCBwZXJjcHUgbWFwcz8NCj4+Pg0KPj4+IEknbSB0aGlua2luZyBvZiBhIHNjZW5h
cmlvIHdoZXJlIHlvdSB3YW50IHRvIGRvIHNvbWUgY2FsY3VsYXRpb25zIG9uDQo+Pj4gcGVyY3B1
IG1hcHMgYW5kIHlvdSBhcmUgaW50ZXJlc3RlZCBvbiB0aGUgaW5mbyBvbiBhbGwgdGhlIGNwdXMg
bm90DQo+Pj4ganVzdCB0aGUgb25lIHRoYXQgaXMgcnVubmluZyB0aGUgYnBmIHByb2dyYW0uIEN1
cnJlbnRseSBvbiBhIHBjcHUgbWFwDQo+Pj4gdGhlIGJwZl9tYXBfbG9va3VwX2VsZW0gaGVscGVy
IG9ubHkgcmV0dXJucyB0aGUgcG9pbnRlciB0byB0aGUgZGF0YSBvZg0KPj4+IHRoZSBleGVjdXRp
bmcgY3B1Lg0KPj4NCj4+IFJpZ2h0LCB3ZSBuZWVkIHRvIGhhdmUgdGhlIGl0ZXJhdGlvbiBvdXRz
aWRlIG9mIHRoZSBicGYgcHJvZ3JhbSBpdHNlbGYsDQo+PiBhbmQgcGFzcyB0aGUgZWxlbWVudCBp
biB0aHJvdWdoIHRoZSBjb250ZXh0LiBUaGF0IHdheSB3ZSBjYW4gZmVlZCBlYWNoDQo+PiBwZXIg
Y3B1IGVudHJ5IGludG8gdGhlIHByb2dyYW0gc2VwYXJhdGVseS4NCj4gTXkgMiBjZW50czoNCj4g
DQo+IEkgcGVyc29uYWxseSBsaWtlIEpha3ViJ3MvUXVlbnRpbidzIHByb3Bvc2FsIG1vcmUuIFNv
IGlmIEkgZ2V0IHRvIGNob29zZQ0KPiBiZXR3ZWVuIHRoaXMgc2VyaWVzIGFuZCBKYWt1YidzIGZp
bHRlcitkdW1wIGluIEJQRiwgSSdkIHBpY2sgZmlsdGVyK2R1bXANCj4gKHBlbmRpbmcgcGVyLWNw
dSBpc3N1ZSB3aGljaCB3ZSBhY3R1YWxseSBjYXJlIGFib3V0KS4NCj4gDQo+IEJ1dCBpZiB3ZSBj
YW4gaGF2ZSBib3RoLCBJIGRvbid0IGhhdmUgYW55IG9iamVjdGlvbnM7IHRoaXMgcGF0Y2gNCj4g
c2VyaWVzIGxvb2tzIHRvIG1lIGEgbG90IGxpa2Ugd2hhdCBCcmlhbiBkaWQsIGp1c3QgZXh0ZW5k
ZWQgdG8gbW9yZQ0KPiBjb21tYW5kcy4gSWYgd2UgYXJlIGZpbmUgd2l0aCB0aGUgc2hvcnRjb21p
bmdzIHJhaXNlZCBhYm91dCB0aGUNCj4gb3JpZ2luYWwgc2VyaWVzLCB0aGVuIGxldCdzIGdvIHdp
dGggdGhpcyB2ZXJzaW9uLiBNYXliZSB3ZSBjYW4gYWxzbw0KPiBsb29rIGludG8gYWRkcmVzc2lu
ZyB0aGVzZSBpbmRlcGVuZGVudGx5Lg0KPiANCj4gQnV0IGlmIEkgcHJldGVuZCB0aGF0IHdlIGxp
dmUgaW4gYW4gaWRlYWwgd29ybGQsIEknZCBqdXN0IGdvIHdpdGgNCj4gd2hhdGV2ZXIgSmFrdWIg
YW5kIFF1ZW50aW4gYXJlIGRvaW5nIHNvIHdlIGRvbid0IGhhdmUgdG8gc3VwcG9ydA0KPiB0d28g
QVBJcyB0aGF0IGVzc2VudGlhbGx5IGRvIHRoZSBzYW1lIChtaW51cyBiYXRjaGluZyB1cGRhdGUs
IGJ1dA0KPiBpdCBsb29rcyBsaWtlIHRoZXJlIGlzIG5vIGNsZWFyIHVzZSBjYXNlIGZvciB0aGF0
IHlldDsgbWF5YmUpLg0KPiANCj4gSSBndWVzcyB5b3UgY2FuIGhvbGQgb2ZmIHRoaXMgc2VyaWVz
IGEgYml0IGFuZCBkaXNjdXNzIGl0IGF0IExQQywNCj4geW91IGhhdmUgYSB0YWxrIGRlZGljYXRl
ZCB0byB0aGF0IDotKSAoYW5kIGFmYWl1LCB5b3UgYXJlIGFsbCBnb2luZykNCg0KQWJzb2x1dGVs
eS4gV2Ugd2lsbCBoYXZlIGEgZGlzY3Vzc2lvbiBvbiBtYXAgYmF0Y2hpbmcgYW5kIEkgc2lnbmVk
DQpvbiB3aXRoIHRoYXQgOi0pLiBPbmUgb2YgZ29hbHMgZm9yIHRoaXMgcGF0Y2ggc2V0IGlzIGZv
ciBtZSB0byBleHBsb3JlDQp3aGF0IHVhcGkgKGF0dHIgYW5kIGJwZiBzdWJjb21tYW5kcykgd2Ug
c2hvdWxkIGV4cG9zZSB0byB1c2Vycy4NCkhvcGVmdWxseSBhdCB0aGF0IHRpbWUgd2Ugd2lsbCBn
ZXQgbW9yZSBjbGFyaXR5DQpvbiBKYWt1YidzIGFwcHJvYWNoIGFuZCB3ZSBjYW4gZGlzY3VzcyBo
b3cgdG8gcHJvY2VlZC4NCg==
