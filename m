Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF99650C6
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 06:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfGKEO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 00:14:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26362 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbfGKEO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 00:14:57 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B4CxxP004110;
        Wed, 10 Jul 2019 21:14:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=E2PXg3e8quTnLXdfS9ieDdbmRAddLYVPxl6YA1PDLNE=;
 b=e/l+/GtbKKybNxJ+U+n4cEgLhW59aR+l4CdNnyy3oS0wmTbiZXUQa4sOm6kRtEKK42a0
 2mD/q/nGzB+XdBVf7Tv1zjxuPZdvyuB4chB1jCEqzfZHTwd7CCCRV3T/IT7lxaReGsWM
 N4etfvd/2hc6WtesRlAH9s61GElaH7r1cl8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnub38cgf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Jul 2019 21:14:36 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jul 2019 21:14:35 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 10 Jul 2019 21:14:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQyonOGUhaE5wea/DFdUZ38ohmuEr8mAQdSzPXt3a13XiCC4nnOUZVMn/mbZkvO9p1z6lz+ctKNqGqVKScz3l69UCsnDUNL/uKWlivq5WprUbRr308NL22or2rmU2KJ2vgalWmt5w4646aeLneF0QCDW/Tg5GcC642uq+HnuQsq9ui56lI0JlwcaR8PhNK+3zKpdzfwCgwQFtduTtgoXauMo/SMv1EfOALKt/X0KxE+8J5d1vdm6BkebDE0/v5XjAMBvRx5F0/cY0T2KQFb8UQpaSuDnaesqckkbJIFuermESXzd003QXkRBH6Z+uKBqOyrsDsk1ceotceoVgPvgUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2PXg3e8quTnLXdfS9ieDdbmRAddLYVPxl6YA1PDLNE=;
 b=Nh+rMbTo0R51S22LnyH6s9ydKepbYzitBqeyhuibB+hofuHE+n+Pw2vRz/Aq4WQZoJqYGYND2E4cW9+fBNOHlsMQtldA0/CD5Q1Pw+VGQuqZw3zcyzlnqEyPcX/0+hodMze66yiqAsL1yV5/BvbM1Rbhp/Xq7yjtVwrOMfThDZiN0MXZ95nzw4K5qTQxwE74F6eu9hvO2KE71a5TqY4JCwybic9keOticZ2XnLRviBCksawd+pxysnrmEAm3MIrpklMWcF5y2AhkyQ/n108EWy/FoRAXeCItb0zIWQhZzRwp3Lw59NOFFm944jgpU7lm0epzM4Zs2g/J5Ee7sYPuIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2PXg3e8quTnLXdfS9ieDdbmRAddLYVPxl6YA1PDLNE=;
 b=lEdb4JEV60pChwSLiMSjb14rAXWmiEx5AB0KzeLffRSS56kb8N1t1e7X6j9PD5nW5PehBwfYzdKILuWSq5oMua6a0tm0btt6BKlA9rC75CA2wdDHS93nDkRq2wNMO3kBC0FuUYYVHkM+TO643CjOjQxTNxKlMfN2vK7qv9Ffu7I=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2262.namprd15.prod.outlook.com (52.135.197.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Thu, 11 Jul 2019 04:14:34 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Thu, 11 Jul 2019
 04:14:34 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Thread-Topic: [PATCH bpf] bpf: fix BTF verifier size resolution logic
Thread-Index: AQHVNvb9OTRSXZV6J0yyn1q3qDFOww==
Date:   Thu, 11 Jul 2019 04:14:33 +0000
Message-ID: <05db3afa-b94e-d0ba-7d61-ec1bf9a82777@fb.com>
References: <20190710080840.2613160-1-andriin@fb.com>
 <f6bc7a95-e8e1-eec4-9728-3b9e36b434fa@fb.com>
 <CAEf4BzaVouFd=3whC1EjhQ9mit62b-C+NhQuW4RiXW02Rq_1Ug@mail.gmail.com>
 <304d8535-5043-836d-2933-1a5efb7aec72@fb.com>
 <CAEf4Bza6Y87C2_Fobj9CwU-2YRTU32S61f8_8CQdhMPenJiJZQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza6Y87C2_Fobj9CwU-2YRTU32S61f8_8CQdhMPenJiJZQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0068.namprd21.prod.outlook.com
 (2603:10b6:300:db::30) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:fea5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3c7ade-86e2-49e5-4af8-08d705b6477d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2262;
x-ms-traffictypediagnostic: BYAPR15MB2262:
x-microsoft-antispam-prvs: <BYAPR15MB226267BE68E104CBF368BB84D3F30@BYAPR15MB2262.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(39860400002)(376002)(396003)(51444003)(189003)(199004)(186003)(36756003)(76176011)(478600001)(52116002)(2906002)(66946007)(66476007)(66556008)(64756008)(66446008)(229853002)(99286004)(14454004)(6916009)(68736007)(316002)(5660300002)(54906003)(6506007)(53546011)(102836004)(386003)(31696002)(86362001)(6486002)(6436002)(4326008)(8936002)(25786009)(31686004)(81166006)(81156014)(71200400001)(71190400001)(8676002)(7736002)(305945005)(6116002)(46003)(256004)(14444005)(476003)(6246003)(2616005)(53936002)(446003)(11346002)(486006)(6512007)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2262;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i26OKLNaCTi/FoYZz5iG9yFlXMm/LVYQ4njLSV1ngaNWfAaMQ3hJVL4k8zLwns2SSDOtfSSeHyZSu/iaO8maATQdjzs03cST6tjG6eTG+FAKGDZou4L+IN1ooXuhFLidoppWV8uifcfpV8ZYfQHmf27vVnCgIMmQfbaN3ZmqjjxM5DXp516OYSguF6wd1/m0e/HgE/Ap8G60oyRCgR5VdNResjI4CITbxQZOv+CERUAhkzPUIV0wjy4jsqOzXUs2q/7GMtAuG1pQ1ysRlN/u3YCE8jFFSRZOKErggwa3M/Bmn4RuNHxd3KRwM8KabQxX1Vft5ztqBv+cJ/EIoEklY4iq7v63gWN/bhoCGKfQWIWwnyc5zj/wJIPANPEUPp9lrqb5FEUQzh66V6ZN7V+iFJ3Rld42eOcF/KfEATuVVRg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3C723970955D448ABA795BF21338F94@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3c7ade-86e2-49e5-4af8-08d705b6477d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 04:14:34.0023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2262
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTAvMTkgNjo0NSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBXZWQs
IEp1bCAxMCwgMjAxOSBhdCA1OjM2IFBNIFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+IHdyb3Rl
Og0KPj4NCj4+DQo+Pg0KPj4gT24gNy8xMC8xOSA1OjI5IFBNLCBBbmRyaWkgTmFrcnlpa28gd3Jv
dGU6DQo+Pj4gT24gV2VkLCBKdWwgMTAsIDIwMTkgYXQgNToxNiBQTSBZb25naG9uZyBTb25nIDx5
aHNAZmIuY29tPiB3cm90ZToNCj4+Pj4NCj4+Pj4NCj4+Pj4NCj4+Pj4gT24gNy8xMC8xOSAxOjA4
IEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+Pj4+PiBCVEYgdmVyaWZpZXIgaGFzIERpZmZl
cmVudCBsb2dpYyBkZXBlbmRpbmcgb24gd2hldGhlciB3ZSBhcmUgZm9sbG93aW5nDQo+Pj4+PiBh
IFBUUiBvciBTVFJVQ1QvQVJSQVkgKG9yIHNvbWV0aGluZyBlbHNlKS4gVGhpcyBpcyBhbiBvcHRp
bWl6YXRpb24gdG8NCj4+Pj4+IHN0b3AgZWFybHkgaW4gREZTIHRyYXZlcnNhbCB3aGlsZSByZXNv
bHZpbmcgQlRGIHR5cGVzLiBCdXQgaXQgYWxzbw0KPj4+Pj4gcmVzdWx0cyBpbiBhIHNpemUgcmVz
b2x1dGlvbiBidWcsIHdoZW4gdGhlcmUgaXMgYSBjaGFpbiwgZS5nLiwgb2YgUFRSIC0+DQo+Pj4+
PiBUWVBFREVGIC0+IEFSUkFZLCBpbiB3aGljaCBjYXNlIGR1ZSB0byBiZWluZyBpbiBwb2ludGVy
IGNvbnRleHQgQVJSQVkNCj4+Pj4+IHNpemUgd29uJ3QgYmUgcmVzb2x2ZWQsIGFzIGl0IGlzIGNv
bnNpZGVyZWQgdG8gYmUgYSBzaW5rIGZvciBwb2ludGVyLA0KPj4+Pj4gbGVhZGluZyB0byBUWVBF
REVGIGJlaW5nIGluIFJFU09MVkVEIHN0YXRlIHdpdGggemVybyBzaXplLCB3aGljaCBpcw0KPj4+
Pj4gY29tcGxldGVseSB3cm9uZy4NCj4+Pj4+DQo+Pj4+PiBPcHRpbWl6YXRpb24gaXMgZG91YnRm
dWwsIHRob3VnaCwgYXMgYnRmX2NoZWNrX2FsbF90eXBlcygpIHdpbGwgaXRlcmF0ZQ0KPj4+Pj4g
b3ZlciBhbGwgQlRGIHR5cGVzIGFueXdheXMsIHNvIHRoZSBvbmx5IHNhdmluZyBpcyBhIHBvdGVu
dGlhbGx5IHNsaWdodGx5DQo+Pj4+PiBzaG9ydGVyIHN0YWNrLiBCdXQgY29ycmVjdG5lc3MgaXMg
bW9yZSBpbXBvcnRhbnQgdGhhdCB0aW55IHNhdmluZ3MuDQo+Pj4+Pg0KPj4+Pj4gVGhpcyBidWcg
bWFuaWZlc3RzIGl0c2VsZiBpbiByZWplY3RpbmcgQlRGLWRlZmluZWQgbWFwcyB0aGF0IHVzZSBh
cnJheQ0KPj4+Pj4gdHlwZWRlZiBhcyBhIHZhbHVlIHR5cGU6DQo+Pj4+Pg0KPj4+Pj4gdHlwZWRl
ZiBpbnQgYXJyYXlfdFsxNl07DQo+Pj4+Pg0KPj4+Pj4gc3RydWN0IHsNCj4+Pj4+ICAgICAgICAg
X191aW50KHR5cGUsIEJQRl9NQVBfVFlQRV9BUlJBWSk7DQo+Pj4+PiAgICAgICAgIF9fdHlwZSh2
YWx1ZSwgYXJyYXlfdCk7IC8qIGkuZS4sIGFycmF5X3QgKnZhbHVlOyAqLw0KPj4+Pj4gfSB0ZXN0
X21hcCBTRUMoIi5tYXBzIik7DQo+Pj4+Pg0KPj4+Pj4gRml4ZXM6IGViM2Y1OTVkYWI0MCAoImJw
ZjogYnRmOiBWYWxpZGF0ZSB0eXBlIHJlZmVyZW5jZSIpDQo+Pj4+PiBDYzogTWFydGluIEthRmFp
IExhdSA8a2FmYWlAZmIuY29tPg0KPj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtv
IDxhbmRyaWluQGZiLmNvbT4NCj4+Pj4NCj4+Pj4gVGhlIGNoYW5nZSBzZWVtcyBva2F5IHRvIG1l
LiBDdXJyZW50bHksIGxvb2tzIGxpa2UgaW50ZXJtZWRpYXRlDQo+Pj4+IG1vZGlmaWVyIHR5cGUg
d2lsbCBjYXJyeSBzaXplID0gMCAoaW4gdGhlIGludGVybmFsIGRhdGEgc3RydWN0dXJlKS4NCj4+
Pg0KPj4+IFllcywgd2hpY2ggaXMgdG90YWxseSB3cm9uZywgZXNwZWNpYWxseSB0aGF0IHdlIHVz
ZSB0aGF0IHNpemUgaW4gc29tZQ0KPj4+IGNhc2VzIHRvIHJlamVjdCBtYXAgd2l0aCBzcGVjaWZp
ZWQgQlRGLg0KPj4+DQo+Pj4+DQo+Pj4+IElmIHdlIHJlbW92ZSBSRVNPTFZFIGxvZ2ljLCB3ZSBw
cm9iYWJseSB3YW50IHRvIGRvdWJsZSBjaGVjaw0KPj4+PiB3aGV0aGVyIHdlIGhhbmRsZSBjaXJj
dWxhciB0eXBlcyBjb3JyZWN0bHkgb3Igbm90LiBNYXliZSB3ZSB3aWxsDQo+Pj4+IGJlIG9rYXkg
aWYgYWxsIHNlbGYgdGVzdHMgcGFzcy4NCj4+Pg0KPj4+IEkgY2hlY2tlZCwgaXQgZG9lcy4gV2Un
bGwgYXR0ZW1wdCB0byBhZGQgcmVmZXJlbmNlZCB0eXBlIHVubGVzcyBpdCdzIGENCj4+PiAicmVz
b2x2ZSBzaW5rIiAod2hlcmUgc2l6ZSBpcyBpbW1lZGlhdGVseSBrbm93bikgb3IgaXMgYWxyZWFk
eQ0KPj4+IHJlc29sdmVkIChpdCdzIHN0YXRlIGlzIFJFU09MVkVEKS4gSW4gb3RoZXIgY2FzZXMs
IHdlJ2xsIGF0dGVtcHQgdG8NCj4+PiBlbnZfc3RhY2tfcHVzaCgpLCB3aGljaCBjaGVjayB0aGF0
IHRoZSBzdGF0ZSBvZiB0aGF0IHR5cGUgaXMNCj4+PiBOT1RfVklTSVRFRC4gSWYgaXQncyBSRVNP
TFZFRCBvciBWSVNJVEVELCBpdCByZXR1cm5zIC1FRVhJU1RTLiBXaGVuDQo+Pj4gdHlwZSBpcyBh
ZGRlZCBpbnRvIHRoZSBzdGFjaywgaXQncyByZXNvbHZlIHN0YXRlIGdvZXMgZnJvbSBOT1RfVklT
SVRFRA0KPj4+IHRvIFZJU0lURUQuDQo+Pj4NCj4+PiBTbywgaWYgdGhlcmUgaXMgYSBsb29wLCB0
aGVuIHdlJ2xsIGRldGVjdCBpdCBhcyBzb29uIGFzIHdlJ2xsIGF0dGVtcHQNCj4+PiB0byBhZGQg
dGhlIHNhbWUgdHlwZSBvbnRvIHRoZSBzdGFjayBzZWNvbmQgdGltZS4NCj4+Pg0KPj4+Pg0KPj4+
PiBJIG1heSBzdGlsbCBiZSB3b3J0aHdoaWxlIHRvIHF1YWxpZnkgdGhlIFJFU09MVkUgb3B0aW1p
emF0aW9uIGJlbmVmaXQNCj4+Pj4gYmVmb3JlIHJlbW92aW5nIGl0Lg0KPj4+DQo+Pj4gSSBkb24n
dCB0aGluayB0aGVyZSBpcyBhbnksIGJlY2F1c2UgZXZlcnkgdHlwZSB3aWxsIGJlIHZpc2l0ZWQg
ZXhhY3RseQ0KPj4+IG9uY2UsIGR1ZSB0byBERlMgbmF0dXJlIG9mIGFsZ29yaXRobS4gVGhlIG9u
bHkgZGlmZmVyZW5jZSBpcyB0aGF0IGlmDQo+Pj4gd2UgaGF2ZSBhIGxvbmcgY2hhaW4gb2YgbW9k
aWZpZXJzLCB3ZSBjYW4gdGVjaG5pY2FsbHkgcmVhY2ggdGhlIG1heA0KPj4+IGxpbWl0IGFuZCBm
YWlsLiBCdXQgYXQgMzIgSSB0aGluayBpdCdzIHByZXR0eSB1bnJlYWxpc3RpYyB0byBoYXZlIHN1
Y2gNCj4+PiBhIGxvbmcgY2hhaW4gb2YgUFRSL1RZUEVERUYvQ09OU1QvVk9MQVRJTEUvUkVTVFJJ
Q1RzIDopDQo+Pj4NCj4+Pj4NCj4+Pj4gQW5vdGhlciBwb3NzaWJsZSBjaGFuZ2UgaXMsIGZvciBl
eHRlcm5hbCB1c2FnZSwgcmVtb3ZpbmcNCj4+Pj4gbW9kaWZpZXJzLCBiZWZvcmUgY2hlY2tpbmcg
dGhlIHNpemUsIHNvbWV0aGluZyBsaWtlIGJlbG93Lg0KPj4+PiBOb3RlIHRoYXQgSSBhbSBub3Qg
c3Ryb25nbHkgYWR2b2NhdGluZyBteSBiZWxvdyBwYXRjaCBhcw0KPj4+PiBpdCBoYXMgdGhlIHNh
bWUgc2hvcnRjb21pbmcgdGhhdCBtYWludGFpbmVkIG1vZGlmaWVyIHR5cGUNCj4+Pj4gc2l6ZSBt
YXkgbm90IGJlIGNvcnJlY3QuDQo+Pj4NCj4+PiBJIGRvbid0IHRoaW5rIHlvdXIgcGF0Y2ggaGVs
cHMsIGl0IGNhbiBhY3R1YWxseSBjb25mdXNlIHRoaW5ncyBldmVuDQo+Pj4gbW9yZS4gSXQgc2tp
cHMgbW9kaWZpZXJzIHVudGlsIHVuZGVybHlpbmcgdHlwZSBpcyBmb3VuZCwgYnV0IHlvdSBzdGls
bA0KPj4+IGRvbid0IGd1YXJhbnRlZSB0aGF0IGF0IHRoYXQgdGltZSB0aGF0IHVuZGVybHlpbmcg
dHlwZSB3aWxsIGhhdmUgaXRzDQo+Pj4gc2l6ZSByZXNvbHZlZC4NCj4+DQo+PiBJdCBhY3R1YWxs
eSBkb2VzIGhlbHAuIEl0IGRvZXMgbm90IGNoYW5nZSB0aGUgaW50ZXJuYWwgYnRmIHR5cGUNCj4+
IHRyYXZlcnNhbCBhbGdvcml0aG1zLiBJdCBvbmx5IGNoYW5nZSB0aGUgaW1wbGVtZW50YXRpb24g
b2YNCj4+IGFuIGV4dGVybmFsIEFQSSBidGZfdHlwZV9pZF9zaXplKCkuIFByZXZpb3VzbHksIHRo
aXMgZnVuY3Rpb24NCj4+IGlzIHVzZWQgYnkgZXh0ZXJuYWxzIGFuZCBpbnRlcm5hbCBidGYuYy4g
SSBicm9rZSBpdCBpbnRvIHR3bywNCj4+IG9uZSBpbnRlcm5hbCBfX2J0Zl90eXBlX2lkX3NpemUo
KSwgYW5kIGFub3RoZXIgZXh0ZXJuYWwNCj4+IGJ0Zl90eXBlX2lkX3NpemUoKS4gVGhlIGV4dGVy
bmFsIG9uZSByZW1vdmVzIG1vZGlmaWVyIGJlZm9yZQ0KPj4gZmluZGluZyB0eXBlIHNpemUuIFRo
ZSBleHRlcm5hbCBvbmUgaXMgdHlwaWNhbGx5IHVzZWQgb25seQ0KPj4gYWZ0ZXIgYnRmIGlzIHZh
bGlkYXRlZC4NCj4gDQo+IFN1cmUsIGZvciBleHRlcm5hbCBjYWxsZXJzIHllcywgaXQgc29sdmVz
IHRoZSBwcm9ibGVtLiBCdXQgdGhlcmUgaXMNCj4gZGVlcGVyIHByb2JsZW06IHdlIG1hcmsgbW9k
aWZpZXIgdHlwZXMgUkVTT0xWRUQgYmVmb3JlIHR5cGVzIHRoZXkNCj4gdWx0aW1hdGVseSBwb2lu
dCB0byBhcmUgcmVzb2x2ZWQuIFRoZW4gaW4gYWxsIHRob3NlIGJ0Zl94eHhfcmVzb2x2ZSgpDQo+
IGZ1bmN0aW9ucyB3ZSBoYXZlIGNoZWNrOg0KPiANCj4gaWYgKCFlbnZfdHlwZV9pc19yZXNvbHZl
X3NpbmsgJiYgIWVudl90eXBlX2lzX3Jlc29sdmVkKQ0KPiAgICByZXR1cm4gZW52X3N0YWNrX3B1
c2goKTsNCj4gZWxzZSB7DQo+IA0KPiAgICAvKiBoZXJlIHdlIGFzc3VtZSB0aGF0IHdlIGNhbiBj
YWxjdWxhdGUgc2l6ZSBvZiB0aGUgdHlwZSAqLw0KPiAgICAvKiBzbyBldmVuIGlmIHdlIHRyYXZl
cnNlIHRocm91Z2ggYWxsIHRoZSBtb2RpZmllcnMgYW5kIGZpbmQNCj4gdW5kZXJseWluZyB0eXBl
ICovDQo+ICAgIC8qIHRoYXQgdHlwZSB3aWxsIGhhdmUgcmVzb2x2ZWRfc2l6ZSA9IDAsIGJlY2F1
c2Ugd2UgaGF2ZW4ndA0KPiBwcm9jZXNzZWQgaXQgeWV0ICovDQo+ICAgIC8qIGJ1dCB3ZSB3aWxs
IGp1c3QgaW5jb3JyZWN0bHkgYXNzdW1lIHRoYXQgemVybyBpcyAqZmluYWwqIHNpemUgKi8NCj4g
fQ0KPiANCj4gU28gSSB0aGluayB0aGF0IHlvdXIgcGF0Y2ggaXMgc3RpbGwganVzdCBoaWRpbmcg
dGhlIHByb2JsZW0sIG5vdCBzb2x2aW5nIGl0Lg0KPiANCj4gQlRXLCBJJ3ZlIGFsc28gaWRlbnRp
ZmllZCBwYXJ0IG9mIGJ0Zl9wdHJfcmVzb2x2ZSgpIGxvZ2ljIHRoYXQgY2FuIGJlDQo+IG5vdyBz
YWZlbHkgcmVtb3ZlZCAoaXQncyBhIHNwZWNpYWwgY2FzZSB0aGF0ICJyZXN0YXJ0cyIgREZTIHRy
YXZlcnNhbA0KPiBmb3IgbW9kaWZpZXJzLCBiZWNhdXNlIHRoZXkgY291bGQgaGF2ZSBiZWVuIHBy
ZW1hdHVyZWx5IG1hcmtlZA0KPiByZXNvbHZlZCkuIFRoaXMgaXMgYW5vdGhlciBzaWduIHRoYXQg
dGhlcmUgaXMgc29tZXRoaW5nIHdyb25nIGluIGFuDQo+IGFsZ29yaXRobS4NCj4gDQo+IEknZCBy
YXRoZXIgcmVtb3ZlIHVubmVjZXNzYXJ5IGNvbXBsZXhpdHkgYW5kIGZpeCB1bmRlcmx5aW5nIHBy
b2JsZW0sDQo+IGVzcGVjaWFsbHkgZ2l2ZW4gdGhhdCB0aGVyZSBpcyBubyBwZXJmb3JtYW5jZSBv
ciBjb3JyZWN0bmVzcyBwZW5hbHR5Lg0KDQpDb3VsZCB5b3UgY3JlYXRlIGEgc3BlY2lhbCBidGYg
d2l0aCB0eXBlIGxpa2UNCnR5cGVkZWYgaW50IGExOw0KdHlwZWRlZiBhMSBhMjsNCi4uLg0KdHlw
ZWRlZiBhNjU1MzMgYTY1NTMyOw0KKG1heGltdW0ga2VybmVsIGFsbG93ZWQgbnVtYmVyIG9mIHR5
cGVzIGlzIDY0S0IpDQoNCkluIHRoZSBCVEYsIHRoZSB0eXBlZGVmIG9yZGVyIGlzIHJldmVyc2UN
CjE6IHR5cGVkZWYgYTY1NTMzIHRvIDINCjI6IHR5cGVkZWYgLi4uIHRvIDMNCjMgLi4uDQoNClNv
IGtlcm5lbCB3b24ndCBydW4gaW50byBkZWVwIHJlY3Vyc2lvbiBvciBwYW5pYz8NCg0KVGhhbmtz
Lg0KDQo+IA0KPiBJJ2xsIHBvc3QgdjIgc29vbi4NCj4gDQo+Pg0KPj4gV2lsbCBnbyB0aHJvdWdo
IHlvdXIgb3RoZXIgY29tbWVudHMgbGF0ZXIuDQo+Pg0KPj4+DQo+Pj4+DQo+Pj4+IGRpZmYgLS1n
aXQgYS9rZXJuZWwvYnBmL2J0Zi5jIGIva2VybmVsL2JwZi9idGYuYw0KPj4+PiBpbmRleCA1NDZl
YmVlMzllMmEuLjZmOTI3YzNlMGE4OSAxMDA2NDQNCj4+Pj4gLS0tIGEva2VybmVsL2JwZi9idGYu
Yw0KPj4+PiArKysgYi9rZXJuZWwvYnBmL2J0Zi5jDQo+Pj4+IEBAIC02MjAsNiArNjIwLDU0IEBA
IHN0YXRpYyBib29sIGJ0Zl90eXBlX2ludF9pc19yZWd1bGFyKGNvbnN0IHN0cnVjdA0KPj4+PiBi
dGZfdHlwZSAqdCkNCj4+Pj4gICAgICAgICAgICByZXR1cm4gdHJ1ZTsNCj4+Pj4gICAgIH0NCj4+
Pj4NCj4+Pj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgYnRmX3R5cGUgKl9fYnRmX3R5cGVfaWRfc2l6
ZShjb25zdCBzdHJ1Y3QgYnRmICpidGYsDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB1MzIgKnR5cGVfaWQsIHUzMg0KPj4+PiAqcmV0X3NpemUs
DQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBi
b29sIHNraXBfbW9kaWZpZXIpDQo+Pj4+ICt7DQo+Pj4+ICsgICAgICAgY29uc3Qgc3RydWN0IGJ0
Zl90eXBlICpzaXplX3R5cGU7DQo+Pj4+ICsgICAgICAgdTMyIHNpemVfdHlwZV9pZCA9ICp0eXBl
X2lkOw0KPj4+PiArICAgICAgIHUzMiBzaXplID0gMDsNCj4+Pj4gKw0KPj4+PiArICAgICAgIHNp
emVfdHlwZSA9IGJ0Zl90eXBlX2J5X2lkKGJ0Ziwgc2l6ZV90eXBlX2lkKTsNCj4+Pj4gKyAgICAg
ICBpZiAoc2l6ZV90eXBlICYmIHNraXBfbW9kaWZpZXIpIHsNCj4+Pj4gKyAgICAgICAgICAgICAg
IHdoaWxlIChidGZfdHlwZV9pc19tb2RpZmllcihzaXplX3R5cGUpKQ0KPj4+PiArICAgICAgICAg
ICAgICAgICAgICAgICBzaXplX3R5cGUgPSBidGZfdHlwZV9ieV9pZChidGYsIHNpemVfdHlwZS0+
dHlwZSk7DQo+Pj4+ICsgICAgICAgfQ0KPj4+PiArDQo+Pj4+ICsgICAgICAgaWYgKGJ0Zl90eXBl
X25vc2l6ZV9vcl9udWxsKHNpemVfdHlwZSkpDQo+Pj4+ICsgICAgICAgICAgICAgICByZXR1cm4g
TlVMTDsNCj4+Pj4gKw0KPj4+PiArICAgICAgIGlmIChidGZfdHlwZV9oYXNfc2l6ZShzaXplX3R5
cGUpKSB7DQo+Pj4+ICsgICAgICAgICAgICAgICBzaXplID0gc2l6ZV90eXBlLT5zaXplOw0KPj4+
PiArICAgICAgIH0gZWxzZSBpZiAoYnRmX3R5cGVfaXNfYXJyYXkoc2l6ZV90eXBlKSkgew0KPj4+
PiArICAgICAgICAgICAgICAgc2l6ZSA9IGJ0Zi0+cmVzb2x2ZWRfc2l6ZXNbc2l6ZV90eXBlX2lk
XTsNCj4+Pj4gKyAgICAgICB9IGVsc2UgaWYgKGJ0Zl90eXBlX2lzX3B0cihzaXplX3R5cGUpKSB7
DQo+Pj4+ICsgICAgICAgICAgICAgICBzaXplID0gc2l6ZW9mKHZvaWQgKik7DQo+Pj4+ICsgICAg
ICAgfSBlbHNlIHsNCj4+Pj4gKyAgICAgICAgICAgICAgIGlmIChXQVJOX09OX09OQ0UoIWJ0Zl90
eXBlX2lzX21vZGlmaWVyKHNpemVfdHlwZSkgJiYNCj4+Pj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIWJ0Zl90eXBlX2lzX3ZhcihzaXplX3R5cGUpKSkNCj4+Pj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+Pj4+ICsNCj4+Pj4gKyAgICAgICAgICAgICAg
IHNpemUgPSBidGYtPnJlc29sdmVkX3NpemVzW3NpemVfdHlwZV9pZF07DQo+Pj4+ICsgICAgICAg
ICAgICAgICBzaXplX3R5cGVfaWQgPSBidGYtPnJlc29sdmVkX2lkc1tzaXplX3R5cGVfaWRdOw0K
Pj4+PiArICAgICAgICAgICAgICAgc2l6ZV90eXBlID0gYnRmX3R5cGVfYnlfaWQoYnRmLCBzaXpl
X3R5cGVfaWQpOw0KPj4+PiArICAgICAgICAgICAgICAgaWYgKGJ0Zl90eXBlX25vc2l6ZV9vcl9u
dWxsKHNpemVfdHlwZSkpDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBOVUxM
Ow0KPj4+PiArICAgICAgIH0NCj4+Pj4gKw0KPj4+PiArICAgICAgICp0eXBlX2lkID0gc2l6ZV90
eXBlX2lkOw0KPj4+PiArICAgICAgIGlmIChyZXRfc2l6ZSkNCj4+Pj4gKyAgICAgICAgICAgICAg
ICpyZXRfc2l6ZSA9IHNpemU7DQo+Pj4+ICsNCj4+Pj4gKyAgICAgICByZXR1cm4gc2l6ZV90eXBl
Ow0KPj4+PiArfQ0KPj4+PiArDQo+PiBbLi4uXQ0KPiANCg==
