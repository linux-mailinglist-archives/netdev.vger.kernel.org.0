Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5804C102D6F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 21:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKSUUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 15:20:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726722AbfKSUUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 15:20:00 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJK8h4U018026;
        Tue, 19 Nov 2019 12:19:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ntghji+10UOENrNlAGoyFH2WMHiLwZlU4a6P9BMnnNo=;
 b=obeFjOy5gby/DHFgIKKqz7qq+9xKSPg7l4aAhERiqzj6bbaNq1wuZiUB9njysyL+lSJx
 +P8kXyOvMSiOjNIL1bWrdb/bvREuIXw0y63lw77RHV4zsS3sxEUv0x4X7iG/m0Ah+alo
 9jwcrg6ys0GdGxW5AHtLxKHj0ygmfMtOxh8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wcextanka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Nov 2019 12:19:45 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Nov 2019 12:19:44 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 19 Nov 2019 12:19:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvvGzNjgyLhHs08SPp/TKpssAYDACKMqN5vAuCtyt3yn2C1pgAvCb+mTYdKD4Gvi7LTs4lvkM3yfpUgqjQa5OMSG+B3IC1jT/XSq10xDXbs4esgh4Vl/fylgxq6Id/zzxfLMuQqUAoBUZcRBXwaylVFM/wC3y9f1Pr+VnQIi6+kHt/19NLf3tcGAMB4NUvv85jIPYzWE6dkAhnciaPUgO4iu4QHwbfNm45EEIrBeBZkLwXn4GfPp1ZKcF1/UZzEdvvMDsXf1kNcPn2ynuUq2Pe5jsqhFcusVbo9jFbPFCnqf005C5hsTxw3/ISpHtsSP1ml8Wnn8HwNpLQpBODIKBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntghji+10UOENrNlAGoyFH2WMHiLwZlU4a6P9BMnnNo=;
 b=kL4Yv+ctZjq7vvyz2vRsgKoCoLmGtgy+N4kYXOImQIEu0vtcAqO0/+ANzbGmAbbe0uBsZuVB3n9G/LYT5SSXzjlBh9dPaIEkJ4WJ1Fvm+Rrn7iaMPC/eUtuzgX8j8kyzgJkn6rImyAJy/6MbjUP6dHHEo8Op0YLESus2drpm763j/1kzGkuT94B8HNt4oaL2fHNq9vdqv6m3enKQ9zEcxtSDT7rfJwpVd3c+OMpgnn2RaGmwlXErt4DOR7OGr1dHHY6LnqMLHhYQQQy2MjkxPfX5SxgRyQgqeGSjDlt4ovVzb+DuhjdOEXDpjlTA1uplnhEfIRBMuLvzwsk/q/i7Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntghji+10UOENrNlAGoyFH2WMHiLwZlU4a6P9BMnnNo=;
 b=FSMGB2qRZCVtnjxbbwPgNQ7FxHM+OcQZQbI0iQqiOV8+rpLuSBRmytOpvPde3fkkfrkx2/jQg3hsZncwcLzvFcjMNS5rXSvWsHzNOvZ73XBZqP2u6voW/j9jYfQjy1AjyIiLxMXIbMfh+P+ngT7DdzoEOPtK4lVhXIuo0/dNNDc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2616.namprd15.prod.outlook.com (20.179.154.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Tue, 19 Nov 2019 20:19:43 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.015; Tue, 19 Nov 2019
 20:19:43 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: fix call relocation offset calculation
 bug
Thread-Topic: [PATCH bpf-next] libbpf: fix call relocation offset calculation
 bug
Thread-Index: AQHVnqGnr2O6b8xiw0K60HzVhUwBA6eS8BOA
Date:   Tue, 19 Nov 2019 20:19:42 +0000
Message-ID: <81594aff-6d6d-74bd-78be-776f1d206c09@fb.com>
References: <20191119062151.777260-1-andriin@fb.com>
In-Reply-To: <20191119062151.777260-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR07CA0080.namprd07.prod.outlook.com (2603:10b6:100::48)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c433cf4-faea-46b8-a3f1-08d76d2dd004
x-ms-traffictypediagnostic: BYAPR15MB2616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2616E28A1499446F4E4DBE91D34C0@BYAPR15MB2616.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(486006)(478600001)(14444005)(256004)(66556008)(66476007)(66446008)(64756008)(66946007)(316002)(2906002)(8936002)(31696002)(4326008)(52116002)(99286004)(2501003)(110136005)(31686004)(8676002)(14454004)(6436002)(6512007)(76176011)(7736002)(305945005)(54906003)(6116002)(81156014)(81166006)(86362001)(6486002)(386003)(46003)(2201001)(6506007)(36756003)(6246003)(476003)(102836004)(71200400001)(446003)(2616005)(11346002)(25786009)(53546011)(71190400001)(186003)(229853002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2616;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WP2a25HZ4Y/laBs018iJhP2ct3qflcizCf5byK76E83uYNbIudJd0trQxfE6ixbYhVTfui8+3hKh+7IsXHHIDjbp/Ww5QuB1PjZZy30l/HtU3dZr4uHqrYpssIFkT5Od+k6cbRiad8OR/9lvIIs8P3hS/HLdGl2wzqxO96cp9XEkIr7mEZ3mp7mjJYjh6i77PDqlK6Hat0Td2PhDvFxrqbvpimTbrdt0NJ2U5YySVGVhupT6zDSCcj8Lol0dRH2c21DvMHlDXj9HEHQt4Sn46HfB9kOrK9x9Iz3dMp+pnFzga6Zr3/X3zApBGREt0hkJtRBxJboXYX7IaZOon8qFj2XjJPCIoLwMm7KFGV4dENoq1p6maONPsw7uRe5XOB5m/5Vh2GkMiQXoGdlHd/NbdRO9SAKJkcDxE2PX+6/Wd2qUT5W2a2OuP0xPpSiW5VbT
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA8CF8524075BB4C881C4DB664F1755C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c433cf4-faea-46b8-a3f1-08d76d2dd004
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 20:19:43.1183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vDCIhr1BBkCCVdh6yi0wFenzbH3k1Zsz9dpaIt2atQChAjdS/qltufzgssq/xsvG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2616
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_07:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=790 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzE4LzE5IDEwOjIxIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IFdoZW4g
cmVsb2NhdGluZyBzdWJwcm9ncmFtIGNhbGwsIGxpYmJwZiBkb2Vzbid0IHRha2UgaW50byBhY2Nv
dW50DQo+IHJlbG8tPnRleHRfb2ZmLCB3aGljaCBjb21lcyBmcm9tIHN5bWJvbCdzIHZhbHVlLiBU
aGlzIGdlbmVyYWxseSB3b3JrcyBmaW5lIGZvcg0KPiBzdWJwcm9ncmFtcyBpbXBsZW1lbnRlZCBh
cyBzdGF0aWMgZnVuY3Rpb25zLCBidXQgYnJlYWtzIGZvciBnbG9iYWwgZnVuY3Rpb25zLg0KPiAN
Cj4gVGFraW5nIGEgc2ltcGxpZmllZCB0ZXN0X3BrdF9hY2Nlc3MuYyBhcyBhbiBleGFtcGxlOg0K
PiANCj4gX19hdHRyaWJ1dGVfXyAoKG5vaW5saW5lKSkNCj4gc3RhdGljIGludCB0ZXN0X3BrdF9h
Y2Nlc3Nfc3VicHJvZzEodm9sYXRpbGUgc3RydWN0IF9fc2tfYnVmZiAqc2tiKQ0KPiB7DQo+ICAg
ICAgICAgIHJldHVybiBza2ItPmxlbiAqIDI7DQo+IH0NCj4gDQo+IF9fYXR0cmlidXRlX18gKChu
b2lubGluZSkpDQo+IHN0YXRpYyBpbnQgdGVzdF9wa3RfYWNjZXNzX3N1YnByb2cyKGludCB2YWws
IHZvbGF0aWxlIHN0cnVjdCBfX3NrX2J1ZmYgKnNrYikNCj4gew0KPiAgICAgICAgICByZXR1cm4g
c2tiLT5sZW4gKyB2YWw7DQo+IH0NCj4gDQo+IFNFQygiY2xhc3NpZmllci90ZXN0X3BrdF9hY2Nl
c3MiKQ0KPiBpbnQgdGVzdF9wa3RfYWNjZXNzKHN0cnVjdCBfX3NrX2J1ZmYgKnNrYikNCj4gew0K
PiAgICAgICAgICBpZiAodGVzdF9wa3RfYWNjZXNzX3N1YnByb2cxKHNrYikgIT0gc2tiLT5sZW4g
KiAyKQ0KPiAgICAgICAgICAgICAgICAgIHJldHVybiBUQ19BQ1RfU0hPVDsNCj4gICAgICAgICAg
aWYgKHRlc3RfcGt0X2FjY2Vzc19zdWJwcm9nMigyLCBza2IpICE9IHNrYi0+bGVuICsgMikNCj4g
ICAgICAgICAgICAgICAgICByZXR1cm4gVENfQUNUX1NIT1Q7DQo+ICAgICAgICAgIHJldHVybiBU
Q19BQ1RfVU5TUEVDOw0KPiB9DQo+IA0KPiBXaGVuIGNvbXBpbGVkLCB3ZSBnZXQgdHdvIHJlbG9j
YXRpb25zLCBwb2ludGluZyB0byAnLnRleHQnIHN5bWJvbC4gLnRleHQgaGFzDQo+IHN0X3ZhbHVl
IHNldCB0byAwIChpdCBwb2ludHMgdG8gdGhlIGJlZ2lubmluZyBvZiAudGV4dCBzZWN0aW9uKToN
Cj4gDQo+IDAwMDAwMDAwMDAwMDAwMDggIDAwMDAwMDA1MDAwMDAwMGEgUl9CUEZfNjRfMzIgICAg
ICAgICAgICAwMDAwMDAwMDAwMDAwMDAwIC50ZXh0DQo+IDAwMDAwMDAwMDAwMDAwNDAgIDAwMDAw
MDA1MDAwMDAwMGEgUl9CUEZfNjRfMzIgICAgICAgICAgICAwMDAwMDAwMDAwMDAwMDAwIC50ZXh0
DQo+IA0KPiB0ZXN0X3BrdF9hY2Nlc3Nfc3VicHJvZzEgYW5kIHRlc3RfcGt0X2FjY2Vzc19zdWJw
cm9nMiBvZmZzZXRzICh0YXJnZXRzIG9mIHR3bw0KPiBjYWxscykgYXJlIGVuY29kZWQgd2l0aGlu
IGNhbGwgaW5zdHJ1Y3Rpb24ncyBpbW0zMiBwYXJ0IGFzIC0xIGFuZCAyLA0KPiByZXNwZWN0aXZl
bHk6DQo+IA0KPiAwMDAwMDAwMDAwMDAwMDAwIHRlc3RfcGt0X2FjY2Vzc19zdWJwcm9nMToNCj4g
ICAgICAgICAwOiAgICAgICA2MSAxMCAwMCAwMCAwMCAwMCAwMCAwMCByMCA9ICoodTMyICopKHIx
ICsgMCkNCj4gICAgICAgICAxOiAgICAgICA2NCAwMCAwMCAwMCAwMSAwMCAwMCAwMCB3MCA8PD0g
MQ0KPiAgICAgICAgIDI6ICAgICAgIDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAwIGV4aXQNCj4gDQo+
IDAwMDAwMDAwMDAwMDAwMTggdGVzdF9wa3RfYWNjZXNzX3N1YnByb2cyOg0KPiAgICAgICAgIDM6
ICAgICAgIDYxIDEwIDAwIDAwIDAwIDAwIDAwIDAwIHIwID0gKih1MzIgKikocjEgKyAwKQ0KPiAg
ICAgICAgIDQ6ICAgICAgIDA0IDAwIDAwIDAwIDAyIDAwIDAwIDAwIHcwICs9IDINCj4gICAgICAg
ICA1OiAgICAgICA5NSAwMCAwMCAwMCAwMCAwMCAwMCAwMCBleGl0DQo+IA0KPiAwMDAwMDAwMDAw
MDAwMDAwIHRlc3RfcGt0X2FjY2VzczoNCj4gICAgICAgICAwOiAgICAgICBiZiAxNiAwMCAwMCAw
MCAwMCAwMCAwMCByNiA9IHIxDQo+ID09PT4gICAxOiAgICAgICA4NSAxMCAwMCAwMCBmZiBmZiBm
ZiBmZiBjYWxsIC0xDQo+ICAgICAgICAgMjogICAgICAgYmMgMDEgMDAgMDAgMDAgMDAgMDAgMDAg
dzEgPSB3MA0KPiAgICAgICAgIDM6ICAgICAgIGI0IDAwIDAwIDAwIDAyIDAwIDAwIDAwIHcwID0g
Mg0KPiAgICAgICAgIDQ6ICAgICAgIDYxIDYyIDAwIDAwIDAwIDAwIDAwIDAwIHIyID0gKih1MzIg
KikocjYgKyAwKQ0KPiAgICAgICAgIDU6ICAgICAgIDY0IDAyIDAwIDAwIDAxIDAwIDAwIDAwIHcy
IDw8PSAxDQo+ICAgICAgICAgNjogICAgICAgNWUgMjEgMDggMDAgMDAgMDAgMDAgMDAgaWYgdzEg
IT0gdzIgZ290byArOCA8TEJCMF8zPg0KPiAgICAgICAgIDc6ICAgICAgIGJmIDYxIDAwIDAwIDAw
IDAwIDAwIDAwIHIxID0gcjYNCj4gPT09PiAgIDg6ICAgICAgIDg1IDEwIDAwIDAwIDAyIDAwIDAw
IDAwIGNhbGwgMg0KPiAgICAgICAgIDk6ICAgICAgIGJjIDAxIDAwIDAwIDAwIDAwIDAwIDAwIHcx
ID0gdzANCj4gICAgICAgIDEwOiAgICAgICA2MSA2MiAwMCAwMCAwMCAwMCAwMCAwMCByMiA9ICoo
dTMyICopKHI2ICsgMCkNCj4gICAgICAgIDExOiAgICAgICAwNCAwMiAwMCAwMCAwMiAwMCAwMCAw
MCB3MiArPSAyDQo+ICAgICAgICAxMjogICAgICAgYjQgMDAgMDAgMDAgZmYgZmYgZmYgZmYgdzAg
PSAtMQ0KPiAgICAgICAgMTM6ICAgICAgIDFlIDIxIDAxIDAwIDAwIDAwIDAwIDAwIGlmIHcxID09
IHcyIGdvdG8gKzEgPExCQjBfMz4NCj4gICAgICAgIDE0OiAgICAgICBiNCAwMCAwMCAwMCAwMiAw
MCAwMCAwMCB3MCA9IDINCj4gMDAwMDAwMDAwMDAwMDA3OCBMQkIwXzM6DQo+ICAgICAgICAxNTog
ICAgICAgOTUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgZXhpdA0KPiANCj4gTm93LCBpZiB3ZSBjb21w
aWxlIGV4YW1wbGUgd2l0aCBnbG9iYWwgZnVuY3Rpb25zLCB0aGUgc2V0dXAgY2hhbmdlcy4NCj4g
UmVsb2NhdGlvbnMgYXJlIG5vdyBhZ2FpbnN0IHNwZWNpZmljYWxseSB0ZXN0X3BrdF9hY2Nlc3Nf
c3VicHJvZzEgYW5kDQo+IHRlc3RfcGt0X2FjY2Vzc19zdWJwcm9nMiBzeW1ib2xzLCB3aXRoIHRl
c3RfcGt0X2FjY2Vzc19zdWJwcm9nMiBwb2ludGluZyAyNA0KPiBieXRlcyBpbnRvIGl0cyByZXNw
ZWN0aXZlIHNlY3Rpb24gKC50ZXh0KSwgaS5lLiwgMyBpbnN0cnVjdGlvbnMgaW46DQo+IA0KPiAw
MDAwMDAwMDAwMDAwMDA4ICAwMDAwMDAwNzAwMDAwMDBhIFJfQlBGXzY0XzMyICAgICAgICAgICAg
MDAwMDAwMDAwMDAwMDAwMCB0ZXN0X3BrdF9hY2Nlc3Nfc3VicHJvZzENCj4gMDAwMDAwMDAwMDAw
MDA0OCAgMDAwMDAwMDgwMDAwMDAwYSBSX0JQRl82NF8zMiAgICAgICAgICAgIDAwMDAwMDAwMDAw
MDAwMTggdGVzdF9wa3RfYWNjZXNzX3N1YnByb2cyDQo+IA0KPiBDYWxscyBpbnN0cnVjdGlvbnMg
bm93IGVuY29kZSBvZmZzZXRzIHJlbGF0aXZlIHRvIGZ1bmN0aW9uIHN5bWJvbHMgYW5kIGFyZSBi
b3RoDQo+IHNldCBvdCAtMToNCj4gDQo+IDAwMDAwMDAwMDAwMDAwMDAgdGVzdF9wa3RfYWNjZXNz
X3N1YnByb2cxOg0KPiAgICAgICAgIDA6ICAgICAgIDYxIDEwIDAwIDAwIDAwIDAwIDAwIDAwIHIw
ID0gKih1MzIgKikocjEgKyAwKQ0KPiAgICAgICAgIDE6ICAgICAgIDY0IDAwIDAwIDAwIDAxIDAw
IDAwIDAwIHcwIDw8PSAxDQo+ICAgICAgICAgMjogICAgICAgOTUgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgZXhpdA0KPiANCj4gMDAwMDAwMDAwMDAwMDAxOCB0ZXN0X3BrdF9hY2Nlc3Nfc3VicHJvZzI6
DQo+ICAgICAgICAgMzogICAgICAgNjEgMjAgMDAgMDAgMDAgMDAgMDAgMDAgcjAgPSAqKHUzMiAq
KShyMiArIDApDQo+ICAgICAgICAgNDogICAgICAgMGMgMTAgMDAgMDAgMDAgMDAgMDAgMDAgdzAg
Kz0gdzENCj4gICAgICAgICA1OiAgICAgICA5NSAwMCAwMCAwMCAwMCAwMCAwMCAwMCBleGl0DQo+
IA0KPiAwMDAwMDAwMDAwMDAwMDAwIHRlc3RfcGt0X2FjY2VzczoNCj4gICAgICAgICAwOiAgICAg
ICBiZiAxNiAwMCAwMCAwMCAwMCAwMCAwMCByNiA9IHIxDQo+ID09PT4gICAxOiAgICAgICA4NSAx
MCAwMCAwMCBmZiBmZiBmZiBmZiBjYWxsIC0xDQo+ICAgICAgICAgMjogICAgICAgYmMgMDEgMDAg
MDAgMDAgMDAgMDAgMDAgdzEgPSB3MA0KPiAgICAgICAgIDM6ICAgICAgIGI0IDAwIDAwIDAwIDAy
IDAwIDAwIDAwIHcwID0gMg0KPiAgICAgICAgIDQ6ICAgICAgIDYxIDYyIDAwIDAwIDAwIDAwIDAw
IDAwIHIyID0gKih1MzIgKikocjYgKyAwKQ0KPiAgICAgICAgIDU6ICAgICAgIDY0IDAyIDAwIDAw
IDAxIDAwIDAwIDAwIHcyIDw8PSAxDQo+ICAgICAgICAgNjogICAgICAgNWUgMjEgMDkgMDAgMDAg
MDAgMDAgMDAgaWYgdzEgIT0gdzIgZ290byArOSA8TEJCMl8zPg0KPiAgICAgICAgIDc6ICAgICAg
IGI0IDAxIDAwIDAwIDAyIDAwIDAwIDAwIHcxID0gMg0KPiAgICAgICAgIDg6ICAgICAgIGJmIDYy
IDAwIDAwIDAwIDAwIDAwIDAwIHIyID0gcjYNCj4gPT09PiAgIDk6ICAgICAgIDg1IDEwIDAwIDAw
IGZmIGZmIGZmIGZmIGNhbGwgLTENCj4gICAgICAgIDEwOiAgICAgICBiYyAwMSAwMCAwMCAwMCAw
MCAwMCAwMCB3MSA9IHcwDQo+ICAgICAgICAxMTogICAgICAgNjEgNjIgMDAgMDAgMDAgMDAgMDAg
MDAgcjIgPSAqKHUzMiAqKShyNiArIDApDQo+ICAgICAgICAxMjogICAgICAgMDQgMDIgMDAgMDAg
MDIgMDAgMDAgMDAgdzIgKz0gMg0KPiAgICAgICAgMTM6ICAgICAgIGI0IDAwIDAwIDAwIGZmIGZm
IGZmIGZmIHcwID0gLTENCj4gICAgICAgIDE0OiAgICAgICAxZSAyMSAwMSAwMCAwMCAwMCAwMCAw
MCBpZiB3MSA9PSB3MiBnb3RvICsxIDxMQkIyXzM+DQo+ICAgICAgICAxNTogICAgICAgYjQgMDAg
MDAgMDAgMDIgMDAgMDAgMDAgdzAgPSAyDQo+IDAwMDAwMDAwMDAwMDAwODAgTEJCMl8zOg0KPiAg
ICAgICAgMTY6ICAgICAgIDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAwIGV4aXQNCj4gDQo+IFRodXMg
dGhlIHJpZ2h0IGZvcm11bGEgdG8gY2FsY3VsYXRlIHRhcmdldCBjYWxsIG9mZnNldCBhZnRlciBy
ZWxvY2F0aW9uIHNob3VsZA0KPiB0YWtlIGludG8gYWNjb3VudCByZWxvY2F0aW9uJ3MgdGFyZ2V0
IHN5bWJvbCB2YWx1ZSAob2Zmc2V0IHdpdGhpbiBzZWN0aW9uKSwNCj4gY2FsbCBpbnN0cnVjdGlv
bidzIGltbTMyIG9mZnNldCwgYW5kIChzdWJ0cmFjdGluZywgdG8gZ2V0IHJlbGF0aXZlIGluc3Ry
dWN0aW9uDQo+IG9mZnNldCkgaW5zdHJ1Y3Rpb24gaW5kZXggb2YgY2FsbCBpbnN0cnVjdGlvbiBp
dHNlbGYuIEFsbCB0aGF0IGlzIHNoaWZ0ZWQgYnkNCj4gbnVtYmVyIG9mIGluc3RydWN0aW9ucyBp
biBtYWluIHByb2dyYW0sIGdpdmVuIGFsbCBzdWItcHJvZ3JhbXMgYXJlIGNvcGllZCBvdmVyDQo+
IGFmdGVyIG1haW4gcHJvZ3JhbS4NCj4gDQo+IENvbnZlcnQgdGVzdF9wa3RfYWNjZXNzLmMgdG8g
Z2xvYmFsIGZ1bmN0aW9ucyB0byB2ZXJpZnkgdGhpcyB3b3Jrcy4NCj4gDQo+IFJlcG9ydGVkLWJ5
OiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBB
bmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29u
ZyA8eWhzQGZiLmNvbT4NCg==
