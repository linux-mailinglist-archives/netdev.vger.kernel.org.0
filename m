Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA211E950
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfLMRlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:41:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39938 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728413AbfLMRlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:41:05 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDHXm61015493;
        Fri, 13 Dec 2019 09:38:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=foHw/jZ17Thk/5Nb/bHJxs6it5AUgCx0N2wWxNBYrwA=;
 b=CUz8b4osbmn92AkGvxRCVnsLwnagOL/4YdvatLL8Mz7yhpF1NiSQbX65LGq6Fb2pC0OV
 h9w9Bmuw7ZC9B0NwZe2sPsXViyKJm3xa9Y8wpfVZi7orgoHwgWX1Fm6LG+KqrhnOPUTa
 9Hh5izXDmZdUC8FPKNhbuS0Gw2/j0LRM7Qk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wuuxkct3p-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Dec 2019 09:38:47 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 09:38:42 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Dec 2019 09:38:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyrNqWOsau1sYjyNQ7d8dZHfv9SOzHo4FpQtGOafPBKh9f/dy5yGNCrYJjXcOg8PcEkMXAiNQe+u72eQE4/Jz9nZOmSmcZieB67V3XoxyfH50W0zEd5ROt7ip59nwfttDPG3CVbA4sY+j5mpq+h1YI2HUJS1eN6xe6RnSiNZw6nj9iuXyk0xsLE18LHySrdMr4iBmjXLOyLGJnoa4A+GbYOX6uESZwE44OvfUx55gBGerEzkX7XSUpcRIi2HGFdZepv18nLiVaV5EZGlrqbwT7WqnESFyxCxaOgNLnIcEftXlrWyx4Ko/J7TxelwyVEhf2ftM9/mQDpDIcb9gMkPjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foHw/jZ17Thk/5Nb/bHJxs6it5AUgCx0N2wWxNBYrwA=;
 b=dxcgdmFClHM7b4bVrF+CkAUC7tuHM32nWMT5KNbKVvmdjZjtL7V/qyu3onzRktMiQx02MW10b4erlQCaivAKUEWUfBahAiP6b0jN5xF/OUR1LnUMgnK5JB63MzPBBIn6udX7GfRFYAwWG8GWV940tA+oeUS7k0XvQGs8FVsvRKKXj2X7EFxEJEiiMMn2KciQ3o8e2X0x6/LazOmRIU5vZmKS7hWqIiFW1jEI5Y08xYh4uVRUE4GHCriXvkHVMa5bequ6DVDu3K94/nOg0Pb0r24pLe5NCbaVJrma4dskPmaoyXD2C3thTDuyuwI5tMVw75ifseYbIsmC7SLC7qBm/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foHw/jZ17Thk/5Nb/bHJxs6it5AUgCx0N2wWxNBYrwA=;
 b=k6g/DF1gpHdSsbCZIHLNSLUUTl+gu/cqLgYoP7uCqok4UhwxfC25SM63ogo7JZgKrM6IHOp14dQ0hyAihQOfc7vvbsTPCWbchwxc0hFg0OCKVlADWJGfO60udI1Bgs1bu/cZ5UXhXqPi8Xa0mOqpmvYV8tLuo2Igr0Edco72LxA=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1450.namprd15.prod.outlook.com (10.173.224.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Fri, 13 Dec 2019 17:38:42 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2516.018; Fri, 13 Dec 2019
 17:38:42 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 03/11] bpf: add generic support for update and
 delete batch ops
Thread-Topic: [PATCH v3 bpf-next 03/11] bpf: add generic support for update
 and delete batch ops
Thread-Index: AQHVsHMo24evxY0kgUqiNs7A+t48tKe4V2iA
Date:   Fri, 13 Dec 2019 17:38:41 +0000
Message-ID: <12eea246-4ffb-3d54-5df3-2d23b88f5414@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-4-brianvv@google.com>
In-Reply-To: <20191211223344.165549-4-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:300:4b::31) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e8f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9972fcbb-5c3d-453b-9a38-08d77ff34b94
x-ms-traffictypediagnostic: DM5PR15MB1450:
x-microsoft-antispam-prvs: <DM5PR15MB145018DDA7FC852A34E7A5F9D3540@DM5PR15MB1450.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:439;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(6486002)(478600001)(15650500001)(86362001)(31696002)(7416002)(71200400001)(54906003)(316002)(2906002)(31686004)(4326008)(6512007)(5660300002)(2616005)(53546011)(66556008)(64756008)(6506007)(8936002)(8676002)(52116002)(66446008)(81156014)(66946007)(36756003)(186003)(110136005)(66476007)(81166006)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1450;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: slc79BXa4ajZEivwV54fglT+1Ad3isLtUxfXUCfvbIIMyq3Y+hJGwwzzmGbnWmYABDzvMJx6AwHrU5sTxtst1lW7085aIAaS4BGGfB93CJa/Tj+NV4kjNMBDQlQuvNtV5ZXbb4l35WFL8hE9afUYHYJ5Pce4F36norktCTiReTJGeHlNsOJ12EY7RoMaUo+GQ6eCcT5OZZBfBaArum3bLEhuCbEFnYBDlHqfzz59NLNPuCfQPztlMZKVIVpAHsQ01WmMtPnZt0DH6oartBTd15vUq8aNB8V26jQFVgTCDL7tAgTPLBgYK2GFlESU6q/LUnhL1DmCsl5a30i94D0yiAFBdB8LJxJBvslD6Enu/hyRLj9TzHDyLzOm1WTo703rIKwKGXrOpE8FmXgKmHPLrBEw6dryBX/IJNwh04+3Ubo3piBMr3qXX+bZeFXJCpslWS2UndeJNc9LY7m7iuXz3yTqjps2pnSuhx2RsSmYJ6Y=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FDB94FD4881F745BD15F57504330324@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9972fcbb-5c3d-453b-9a38-08d77ff34b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 17:38:41.8914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zu++jGyucSqtK8fVLijXnRYcetwMQv9IQ+UGRL+V5GkrQfmFIIN7pDSSuCkSrBKS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1450
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzExLzE5IDI6MzMgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoaXMgY29t
bWl0IGFkZHMgZ2VuZXJpYyBzdXBwb3J0IGZvciB1cGRhdGUgYW5kIGRlbGV0ZSBiYXRjaCBvcHMg
dGhhdA0KPiBjYW4gYmUgdXNlZCBmb3IgYWxtb3N0IGFsbCB0aGUgYnBmIG1hcHMuIFRoZXNlIGNv
bW1hbmRzIHNoYXJlIHRoZSBzYW1lDQo+IFVBUEkgYXR0ciB0aGF0IGxvb2t1cCBhbmQgbG9va3Vw
X2FuZF9kZWxldGUgYmF0Y2ggb3BzIHVzZSBhbmQgdGhlDQo+IHN5c2NhbGwgY29tbWFuZHMgYXJl
Og0KPiANCj4gICAgQlBGX01BUF9VUERBVEVfQkFUQ0gNCj4gICAgQlBGX01BUF9ERUxFVEVfQkFU
Q0gNCj4gDQo+IFRoZSBtYWluIGRpZmZlcmVuY2UgYmV0d2VlbiB1cGRhdGUvZGVsZXRlIGFuZCBs
b29rdXAvbG9va3VwX2FuZF9kZWxldGUNCj4gYmF0Y2ggb3BzIGlzIHRoYXQgZm9yIHVwZGF0ZS9k
ZWxldGUga2V5cy92YWx1ZXMgbXVzdCBiZSBzcGVjaWZpZWQgZm9yDQo+IHVzZXJzcGFjZSBhbmQg
YmVjYXVzZSBvZiB0aGF0LCBuZWl0aGVyIGluX2JhdGNoIG5vciBvdXRfYmF0Y2ggYXJlIHVzZWQu
DQo+IA0KPiBTdWdnZXN0ZWQtYnk6IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IEJyaWFuIFZhenF1ZXogPGJyaWFudnZAZ29vZ2xlLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4gLS0tDQo+ICAgaW5j
bHVkZS9saW51eC9icGYuaCAgICAgIHwgIDEwICsrKysNCj4gICBpbmNsdWRlL3VhcGkvbGludXgv
YnBmLmggfCAgIDIgKw0KPiAgIGtlcm5lbC9icGYvc3lzY2FsbC5jICAgICB8IDExNyArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0NCj4gICAzIGZpbGVzIGNoYW5nZWQsIDEy
OCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9icGYuaCBiL2luY2x1ZGUvbGludXgvYnBmLmgNCj4gaW5kZXggYTE2ZjIwOTI1NWE1
OS4uODUxZmIzZmYwODRiMCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9icGYuaA0KPiAr
KysgYi9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+IEBAIC00OCw2ICs0OCwxMCBAQCBzdHJ1Y3QgYnBm
X21hcF9vcHMgew0KPiAgIAlpbnQgKCptYXBfbG9va3VwX2FuZF9kZWxldGVfYmF0Y2gpKHN0cnVj
dCBicGZfbWFwICptYXAsDQo+ICAgCQkJCQkgICBjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwN
Cj4gICAJCQkJCSAgIHVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0dHIpOw0KPiArCWludCAoKm1h
cF91cGRhdGVfYmF0Y2gpKHN0cnVjdCBicGZfbWFwICptYXAsIGNvbnN0IHVuaW9uIGJwZl9hdHRy
ICphdHRyLA0KPiArCQkJCXVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0dHIpOw0KPiArCWludCAo
Km1hcF9kZWxldGVfYmF0Y2gpKHN0cnVjdCBicGZfbWFwICptYXAsIGNvbnN0IHVuaW9uIGJwZl9h
dHRyICphdHRyLA0KPiArCQkJCXVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0dHIpOw0KPiAgIA0K
PiAgIAkvKiBmdW5jcyBjYWxsYWJsZSBmcm9tIHVzZXJzcGFjZSBhbmQgZnJvbSBlQlBGIHByb2dy
YW1zICovDQo+ICAgCXZvaWQgKigqbWFwX2xvb2t1cF9lbGVtKShzdHJ1Y3QgYnBmX21hcCAqbWFw
LCB2b2lkICprZXkpOw0KPiBAQCAtODQ5LDYgKzg1MywxMiBAQCBpbnQgIGdlbmVyaWNfbWFwX2xv
b2t1cF9iYXRjaChzdHJ1Y3QgYnBmX21hcCAqbWFwLA0KPiAgIGludCAgZ2VuZXJpY19tYXBfbG9v
a3VwX2FuZF9kZWxldGVfYmF0Y2goc3RydWN0IGJwZl9tYXAgKm1hcCwNCj4gICAJCQkJCSBjb25z
dCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4gICAJCQkJCSB1bmlvbiBicGZfYXR0ciBfX3VzZXIg
KnVhdHRyKTsNCj4gK2ludCAgZ2VuZXJpY19tYXBfdXBkYXRlX2JhdGNoKHN0cnVjdCBicGZfbWFw
ICptYXAsDQo+ICsJCQkgICAgICBjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4gKwkJCSAg
ICAgIHVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0dHIpOw0KPiAraW50ICBnZW5lcmljX21hcF9k
ZWxldGVfYmF0Y2goc3RydWN0IGJwZl9tYXAgKm1hcCwNCj4gKwkJCSAgICAgIGNvbnN0IHVuaW9u
IGJwZl9hdHRyICphdHRyLA0KPiArCQkJICAgICAgdW5pb24gYnBmX2F0dHIgX191c2VyICp1YXR0
cik7DQo+ICAgDQo+ICAgZXh0ZXJuIGludCBzeXNjdGxfdW5wcml2aWxlZ2VkX2JwZl9kaXNhYmxl
ZDsNCj4gICANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCBiL2luY2x1
ZGUvdWFwaS9saW51eC9icGYuaA0KPiBpbmRleCAzNmQzYjg4NWRkZWRkLi5kYWIyNGE3NjNlNGJi
IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gKysrIGIvaW5jbHVk
ZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0xMDksNiArMTA5LDggQEAgZW51bSBicGZfY21kIHsN
Cj4gICAJQlBGX0JURl9HRVRfTkVYVF9JRCwNCj4gICAJQlBGX01BUF9MT09LVVBfQkFUQ0gsDQo+
ICAgCUJQRl9NQVBfTE9PS1VQX0FORF9ERUxFVEVfQkFUQ0gsDQo+ICsJQlBGX01BUF9VUERBVEVf
QkFUQ0gsDQo+ICsJQlBGX01BUF9ERUxFVEVfQkFUQ0gsDQo+ICAgfTsNCj4gICANCj4gICBlbnVt
IGJwZl9tYXBfdHlwZSB7DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL3N5c2NhbGwuYyBiL2tl
cm5lbC9icGYvc3lzY2FsbC5jDQo+IGluZGV4IDcwOGFhODlmZTIzMDguLjgyNzJlNzYxODMwNjgg
MTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+ICsrKyBiL2tlcm5lbC9icGYv
c3lzY2FsbC5jDQo+IEBAIC0xMjA2LDYgKzEyMDYsMTExIEBAIHN0YXRpYyBpbnQgbWFwX2dldF9u
ZXh0X2tleSh1bmlvbiBicGZfYXR0ciAqYXR0cikNCj4gICAJcmV0dXJuIGVycjsNCj4gICB9DQo+
ICAgDQo+ICtpbnQgZ2VuZXJpY19tYXBfZGVsZXRlX2JhdGNoKHN0cnVjdCBicGZfbWFwICptYXAs
DQo+ICsJCQkgICAgIGNvbnN0IHVuaW9uIGJwZl9hdHRyICphdHRyLA0KPiArCQkJICAgICB1bmlv
biBicGZfYXR0ciBfX3VzZXIgKnVhdHRyKQ0KPiArew0KPiArCXZvaWQgX191c2VyICprZXlzID0g
dTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLmtleXMpOw0KPiArCXUzMiBjcCwgbWF4X2NvdW50
Ow0KPiArCWludCBlcnIgPSAwOw0KPiArCXZvaWQgKmtleTsNCj4gKw0KPiArCWlmIChhdHRyLT5i
YXRjaC5lbGVtX2ZsYWdzICYgfkJQRl9GX0xPQ0spDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiAr
DQo+ICsJaWYgKChhdHRyLT5iYXRjaC5lbGVtX2ZsYWdzICYgQlBGX0ZfTE9DSykgJiYNCj4gKwkg
ICAgIW1hcF92YWx1ZV9oYXNfc3Bpbl9sb2NrKG1hcCkpIHsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7
DQo+ICsJfQ0KPiArDQo+ICsJbWF4X2NvdW50ID0gYXR0ci0+YmF0Y2guY291bnQ7DQo+ICsJaWYg
KCFtYXhfY291bnQpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KDQpUbyBiZSBjb25zaXN0ZW50IHdp
dGggbG9va3VwIGFuZCBsb29rdXBfYW5kX2RlbGV0ZSwgaWYgbWF4X2NvdW50ID0gMCwNCndlIGNh
biBqdXN0IHJldHVybiAwIGluc3RlYWQgb2YgLUVJTlZBTC4NCg0KPiArDQo+ICsJZm9yIChjcCA9
IDA7IGNwIDwgbWF4X2NvdW50OyBjcCsrKSB7DQo+ICsJCWtleSA9IF9fYnBmX2NvcHlfa2V5KGtl
eXMgKyBjcCAqIG1hcC0+a2V5X3NpemUsIG1hcC0+a2V5X3NpemUpOw0KPiArCQlpZiAoSVNfRVJS
KGtleSkpIHsNCj4gKwkJCWVyciA9IFBUUl9FUlIoa2V5KTsNCj4gKwkJCWJyZWFrOw0KPiArCQl9
DQo+ICsNCj4gKwkJaWYgKGJwZl9tYXBfaXNfZGV2X2JvdW5kKG1hcCkpIHsNCj4gKwkJCWVyciA9
IGJwZl9tYXBfb2ZmbG9hZF9kZWxldGVfZWxlbShtYXAsIGtleSk7DQo+ICsJCQlicmVhazsNCj4g
KwkJfQ0KPiArDQo+ICsJCXByZWVtcHRfZGlzYWJsZSgpOw0KPiArCQlfX3RoaXNfY3B1X2luYyhi
cGZfcHJvZ19hY3RpdmUpOw0KPiArCQlyY3VfcmVhZF9sb2NrKCk7DQo+ICsJCWVyciA9IG1hcC0+
b3BzLT5tYXBfZGVsZXRlX2VsZW0obWFwLCBrZXkpOw0KPiArCQlyY3VfcmVhZF91bmxvY2soKTsN
Cj4gKwkJX190aGlzX2NwdV9kZWMoYnBmX3Byb2dfYWN0aXZlKTsNCj4gKwkJcHJlZW1wdF9lbmFi
bGUoKTsNCj4gKwkJbWF5YmVfd2FpdF9icGZfcHJvZ3JhbXMobWFwKTsNCj4gKwkJaWYgKGVycikN
Cj4gKwkJCWJyZWFrOw0KPiArCX0NCj4gKwlpZiAoY29weV90b191c2VyKCZ1YXR0ci0+YmF0Y2gu
Y291bnQsICZjcCwgc2l6ZW9mKGNwKSkpDQo+ICsJCWVyciA9IC1FRkFVTFQ7DQo+ICsJcmV0dXJu
IGVycjsNCj4gK30NCj4gKw0KPiAraW50IGdlbmVyaWNfbWFwX3VwZGF0ZV9iYXRjaChzdHJ1Y3Qg
YnBmX21hcCAqbWFwLA0KPiArCQkJICAgICBjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4g
KwkJCSAgICAgdW5pb24gYnBmX2F0dHIgX191c2VyICp1YXR0cikNCj4gK3sNCj4gKwl2b2lkIF9f
dXNlciAqdmFsdWVzID0gdTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLnZhbHVlcyk7DQo+ICsJ
dm9pZCBfX3VzZXIgKmtleXMgPSB1NjRfdG9fdXNlcl9wdHIoYXR0ci0+YmF0Y2gua2V5cyk7DQo+
ICsJdTMyIHZhbHVlX3NpemUsIGNwLCBtYXhfY291bnQ7DQo+ICsJaW50IHVmZCA9IGF0dHItPm1h
cF9mZDsNCj4gKwl2b2lkICprZXksICp2YWx1ZTsNCj4gKwlzdHJ1Y3QgZmQgZjsNCj4gKwlpbnQg
ZXJyID0gMDsNCj4gKw0KPiArCWYgPSBmZGdldCh1ZmQpOw0KDQpJIGRpZCBub3QgZmluZCB0aGUg
cGFpcmluZyBmZHB1dCgpLiBBbHNvLA0KdGhlIHZhcmlhYmxlICdmJyBpcyB1c2VkIHdheSBkb3du
IGluIHRoZSBsb29wLCBzbw0KeW91IGNhbiBkbyBmZGdldCgpIGxhdGVyLg0KDQo+ICsJaWYgKGF0
dHItPmJhdGNoLmVsZW1fZmxhZ3MgJiB+QlBGX0ZfTE9DSykNCj4gKwkJcmV0dXJuIC1FSU5WQUw7
DQo+ICsNCj4gKwlpZiAoKGF0dHItPmJhdGNoLmVsZW1fZmxhZ3MgJiBCUEZfRl9MT0NLKSAmJg0K
PiArCSAgICAhbWFwX3ZhbHVlX2hhc19zcGluX2xvY2sobWFwKSkgew0KPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gKwl9DQo+ICsNCj4gKwl2YWx1ZV9zaXplID0gYnBmX21hcF92YWx1ZV9zaXplKG1h
cCk7DQo+ICsNCj4gKwltYXhfY291bnQgPSBhdHRyLT5iYXRjaC5jb3VudDsNCj4gKwlpZiAoIW1h
eF9jb3VudCkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwl2YWx1ZSA9IGttYWxsb2ModmFsdWVf
c2l6ZSwgR0ZQX1VTRVIgfCBfX0dGUF9OT1dBUk4pOw0KPiArCWlmICghdmFsdWUpDQo+ICsJCXJl
dHVybiAtRU5PTUVNOw0KPiArDQo+ICsJZm9yIChjcCA9IDA7IGNwIDwgbWF4X2NvdW50OyBjcCsr
KSB7DQo+ICsJCWtleSA9IF9fYnBmX2NvcHlfa2V5KGtleXMgKyBjcCAqIG1hcC0+a2V5X3NpemUs
IG1hcC0+a2V5X3NpemUpOw0KPiArCQlpZiAoSVNfRVJSKGtleSkpIHsNCj4gKwkJCWVyciA9IFBU
Ul9FUlIoa2V5KTsNCj4gKwkJCWJyZWFrOw0KPiArCQl9DQo+ICsJCWVyciA9IC1FRkFVTFQ7DQo+
ICsJCWlmIChjb3B5X2Zyb21fdXNlcih2YWx1ZSwgdmFsdWVzICsgY3AgKiB2YWx1ZV9zaXplLCB2
YWx1ZV9zaXplKSkNCj4gKwkJCWJyZWFrOw0KPiArDQo+ICsJCWVyciA9IGJwZl9tYXBfdXBkYXRl
X3ZhbHVlKG1hcCwgZiwga2V5LCB2YWx1ZSwNCj4gKwkJCQkJICAgYXR0ci0+YmF0Y2guZWxlbV9m
bGFncyk7DQo+ICsNCj4gKwkJaWYgKGVycikNCj4gKwkJCWJyZWFrOw0KPiArCX0NCj4gKw0KPiAr
CWlmIChjb3B5X3RvX3VzZXIoJnVhdHRyLT5iYXRjaC5jb3VudCwgJmNwLCBzaXplb2YoY3ApKSkN
Cj4gKwkJZXJyID0gLUVGQVVMVDsNCj4gKw0KPiArCWtmcmVlKHZhbHVlKTsNCj4gKwlrZnJlZShr
ZXkpOw0KPiArCXJldHVybiBlcnI7DQo+ICt9DQo+ICsNClsuLi5dDQo=
