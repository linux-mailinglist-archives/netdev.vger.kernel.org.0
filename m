Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE5591CC5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 07:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfHSFvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 01:51:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51012 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbfHSFve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 01:51:34 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7J5nugR014183;
        Sun, 18 Aug 2019 22:51:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/D1aTRNaQpXeGhUKDkRERGc+8ROoHc7Ime160JrClvc=;
 b=oy1q7Cdhy5p8blsWij0JAI5ZmvqnMgN5FosnSIsebyvC+OCnN+MvmtOlF6AcG3mhPR99
 pkioYPNFq+t9eyPXgRLZFgwCqd48IE4rsAejFKA1uzF0I2foZ9IEe37uNS31xTQ0doWj
 hT5wiZ6sNVtO2hZyD4gMf+/LgKMCVv22oTw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ufnqb01h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 18 Aug 2019 22:51:12 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 18 Aug 2019 22:51:11 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 18 Aug 2019 22:51:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2FdP9OF8w6o9nZicQ4Ppzy1cUH1C+6fLBcnc97XUKYTl+/09zPWoUdBK0vpDIjn6XBJMTW6gMn+Id6RL0wptHTYyAbkquwSfrfStwhMEpSNTloJGM2AtvXA+A/slH95RjJDh8CJRQwP2qPW9M2jv7H8NLlhNcXEoJxmKMuJXy0uTb0MVZYY6/AMmaMHQFSN0bPq27lOwV5mKL9Pac/wYVE6UDSByCU9NeCRXpaRlBEFzCF34TdvKUlhoOOe9TEDXjWQB//bj0LLVeXTZcpOG/p9RqbkNOTJ+zmJAyTTJDYZk+Ufa9YzseUNUp91/19KWwiPq2oXVTwXAPACEFaNZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D1aTRNaQpXeGhUKDkRERGc+8ROoHc7Ime160JrClvc=;
 b=D50Bh+1C7VKLPMNS1VEeK8hagr6aJcwJK1Iu549RvP+h9cmNh6uMyqJbJ/TBOy2bqvWOTht+qkYK0lE46+k+Z+NxaBEYH9t3PjOjscp6LvcNaIn9p8dPRwxEUhUn3EezVKQrs6vQgijPNDO2qsU9EvaJCXfg2CZ5LQOIPgaOAsJaA7rEEVW0LIw2JeWoOtjNnEo2QnmSYY2iPJ/ltMmPFDIP0SyvFQ+PYznIAxZD6LgtNuMkC3RdDcT+umOkF/fc/Pcvv5tqeuNbQrgdA4k/mpK/zloHbBPO2cul8RJB3sGaAWANyr8leE9eHdM6NS3IYyxq80p2tMWDX5iyQeDqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D1aTRNaQpXeGhUKDkRERGc+8ROoHc7Ime160JrClvc=;
 b=WxRT3jjYgJ3H11Ri1JhOaSxYrrX56b8snR7oe7cy+b2HqJLSZcwIZ/SZoLGf2KwsQ7ckyNBiis+9LofwDvbW0f8sSVSyW31/p/E2aO9zDT21eNyRLKOrDx5QSWzyhs8S2MqYlZfKXAASNW6Fh1ykB1IEPrPaa4o/jnyZ+2krmtc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2439.namprd15.prod.outlook.com (52.135.198.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 05:51:09 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 05:51:09 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] test_bpf: Fix a new clang warning about xor-ing two
 numbers
Thread-Topic: [PATCH] test_bpf: Fix a new clang warning about xor-ing two
 numbers
Thread-Index: AQHVVkfGI3lq+eqY6EetOxo2qpIqHacB956A
Date:   Mon, 19 Aug 2019 05:51:09 +0000
Message-ID: <00b21133-196c-f304-14a1-facb24c09103@fb.com>
References: <20190819043419.68223-1-natechancellor@gmail.com>
In-Reply-To: <20190819043419.68223-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0034.namprd21.prod.outlook.com
 (2603:10b6:300:129::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a8b3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfe2e8dd-f4e8-42a9-b03a-08d724693c09
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2439;
x-ms-traffictypediagnostic: BYAPR15MB2439:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2439B1BF18CBBCA0FA53C097D3A80@BYAPR15MB2439.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(396003)(366004)(199004)(189003)(25786009)(6246003)(14454004)(66556008)(478600001)(64756008)(66446008)(66476007)(53936002)(229853002)(4326008)(966005)(6116002)(31686004)(76176011)(52116002)(2906002)(446003)(5660300002)(6506007)(102836004)(6486002)(386003)(53546011)(7736002)(14444005)(31696002)(256004)(305945005)(86362001)(316002)(71190400001)(71200400001)(66946007)(99286004)(186003)(81156014)(81166006)(110136005)(8676002)(8936002)(36756003)(54906003)(6512007)(6306002)(6436002)(476003)(11346002)(486006)(2616005)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2439;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hU0I7CBEUiZygn4rD/I4IEwG8R8TciSNnNLFEanXgdL03ngJSp55zV6zfpNTaGPc0mVyp3MEDBJjq8zEiORqZwjahs/AvDPSDSy2Etnv1PZJvawtjUd4Nx49IuRmpH5DbtCxg6E4yf5x9Q4I4rFpzIaF+LUkRBtTJC4eScDTILvKnljI55x6teaKg/IjhF28TXgpxxGYl/w0W6Cdsu6PBgHmr+A8LbQAq78fmflgT/3xUpNu+llyBa3aVKbr9pOgflmXHnzFOhidzgGmsiLhBd/SZeIxMS7jomspSqU4ddLIJxz9yBai4zxxtI5BsA/h6g5BgJZOMZmIlMEVN/OMtVrw1jnwsBCCfqnmZ6XGKiMGZ5C/dJUrnIMQGk/lK1nW3f29ocm6Dmh8bBwQFkszaWh0JXZRKYb4ZTQGDUmcOhA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F8ECC3C16EEA947B68204269CE85C56@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe2e8dd-f4e8-42a9-b03a-08d724693c09
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 05:51:09.6716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rH0w1dUzAX1Z514QlhnfdCSSSwAHmRsHQLrydg7wuDMMXwtH6t5R84VJXnni0GvB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2439
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTgvMTkgOTozNCBQTSwgTmF0aGFuIENoYW5jZWxsb3Igd3JvdGU6DQo+IHIzNjky
MTcgaW4gY2xhbmcgYWRkZWQgYSBuZXcgd2FybmluZyBhYm91dCBwb3RlbnRpYWwgbWlzdXNlIG9m
IHRoZSB4b3INCj4gb3BlcmF0b3IgYXMgYW4gZXhwb25lbnRpYXRpb24gb3BlcmF0b3I6DQo+IA0K
PiAuLi9saWIvdGVzdF9icGYuYzo4NzA6MTM6IHdhcm5pbmc6IHJlc3VsdCBvZiAnMTAgXiAzMDAn
IGlzIDI5NDsgZGlkIHlvdQ0KPiBtZWFuICcxZTMwMCc/IFstV3hvci11c2VkLWFzLXBvd10NCj4g
ICAgICAgICAgICAgICAgICB7IHsgNCwgMTAgXiAzMDAgfSwgeyAyMCwgMTAgXiAzMDAgfSB9LA0K
PiAgICAgICAgICAgICAgICAgICAgICAgICB+fn5efn5+fg0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAxZTMwMA0KPiAuLi9saWIvdGVzdF9icGYuYzo4NzA6MTM6IG5vdGU6IHJlcGxhY2UgZXhw
cmVzc2lvbiB3aXRoICcweEEgXiAzMDAnIHRvDQo+IHNpbGVuY2UgdGhpcyB3YXJuaW5nDQo+IC4u
L2xpYi90ZXN0X2JwZi5jOjg3MDozMTogd2FybmluZzogcmVzdWx0IG9mICcxMCBeIDMwMCcgaXMg
Mjk0OyBkaWQgeW91DQo+IG1lYW4gJzFlMzAwJz8gWy1XeG9yLXVzZWQtYXMtcG93XQ0KPiAgICAg
ICAgICAgICAgICAgIHsgeyA0LCAxMCBeIDMwMCB9LCB7IDIwLCAxMCBeIDMwMCB9IH0sDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH5+fl5+fn5+DQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDFlMzAwDQo+IC4uL2xpYi90ZXN0
X2JwZi5jOjg3MDozMTogbm90ZTogcmVwbGFjZSBleHByZXNzaW9uIHdpdGggJzB4QSBeIDMwMCcg
dG8NCj4gc2lsZW5jZSB0aGlzIHdhcm5pbmcNCj4gDQo+IFRoZSBjb21taXQgbGluayBmb3IgdGhp
cyBuZXcgd2FybmluZyBoYXMgc29tZSBnb29kIGxvZ2ljIGJlaGluZCB3YW50aW5nDQo+IHRvIGFk
ZCBpdCBidXQgdGhpcyBpbnN0YW5jZSBhcHBlYXJzIHRvIGJlIGEgZmFsc2UgcG9zaXRpdmUuIEFk
b3B0IGl0cw0KPiBzdWdnZXN0aW9uIHRvIHNpbGVuY2UgdGhlIHdhcm5pbmcgYnV0IG5vdCBjaGFu
Z2UgdGhlIGNvZGUuIEFjY29yZGluZyB0bw0KPiB0aGUgZGlmZmVyZW50aWFsIHJldmlldyBsaW5r
IGluIHRoZSBjbGFuZyBjb21taXQsIEdDQyBtYXkgZXZlbnR1YWxseQ0KPiBhZG9wdCB0aGlzIHdh
cm5pbmcgYXMgd2VsbC4NCj4gDQo+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9DbGFuZ0J1aWx0
TGludXgvbGludXgvaXNzdWVzLzY0Mw0KPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vbGx2bS9s
bHZtLXByb2plY3QvY29tbWl0LzkyMDg5MGUyNjgxMmY4MDhhNzRjNjBlYmMxNGNjNjM2ZGFjNjYx
YzENCj4gU2lnbmVkLW9mZi1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFuY2VsbG9yQGdt
YWlsLmNvbT4NCg0KVmVyaWZpZWQgdGhhdCBsYXRlc3QgdHJ1bmsgY2xhbmcgaW5kZWVkIGhhcyB0
aGlzIHdhcm5pbmcsIGFuZCBiZWxvdyANCmNoYW5nZSBpbmRlZWQgZml4ZWQgdGhlIHdhcm5pbmcg
aW4gdGhlIGNvcnJlY3Qgd2F5Lg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNv
bT4NCg0KPiAtLS0NCj4gDQo+IEkgaGlnaGx5IGRvdWJ0IHRoYXQgMWUzMDAgd2FzIGludGVudGVk
IGJ1dCBpZiBpdCB3YXMgKG9yIHNvbWV0aGluZyBlbHNlDQo+IHdhcyksIHBsZWFzZSBsZXQgbWUg
a25vdy4gQ29tbWl0IGhpc3Rvcnkgd2Fzbid0IGVudGlyZWx5IGNsZWFyIG9uIHdoeQ0KPiB0aGlz
IGV4cHJlc3Npb24gd2FzIHVzZWQgb3ZlciBqdXN0IGEgcmF3IG51bWJlci4NCj4gDQo+ICAgbGli
L3Rlc3RfYnBmLmMgfCAyICstDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbGliL3Rlc3RfYnBmLmMgYi9saWIvdGVz
dF9icGYuYw0KPiBpbmRleCBjNDE3MDU4MzVjYmEuLjVlZjNlY2NlZTI3YyAxMDA2NDQNCj4gLS0t
IGEvbGliL3Rlc3RfYnBmLmMNCj4gKysrIGIvbGliL3Rlc3RfYnBmLmMNCj4gQEAgLTg2Nyw3ICs4
NjcsNyBAQCBzdGF0aWMgc3RydWN0IGJwZl90ZXN0IHRlc3RzW10gPSB7DQo+ICAgCQl9LA0KPiAg
IAkJQ0xBU1NJQywNCj4gICAJCXsgfSwNCj4gLQkJeyB7IDQsIDEwIF4gMzAwIH0sIHsgMjAsIDEw
IF4gMzAwIH0gfSwNCj4gKwkJeyB7IDQsIDB4QSBeIDMwMCB9LCB7IDIwLCAweEEgXiAzMDAgfSB9
LA0KPiAgIAl9LA0KPiAgIAl7DQo+ICAgCQkiU1BJTExfRklMTCIsDQo+IA0K
