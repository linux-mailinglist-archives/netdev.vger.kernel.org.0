Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC0D4D0E
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfJLExi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:53:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725308AbfJLExi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:53:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9C4qDgR031964;
        Fri, 11 Oct 2019 21:53:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DjS4Tl+QEStjbspV1k+CGx2qI1HiAMYRQ4POG1pHhQ0=;
 b=kNQQoxhmxnRuUy/dvQyz2C8yUFjvTnTqQNTGzDqSf9kfMl6sE88JCIQYHvJhjOpWfGRn
 no3kqIeljeSTaB/GW1bojvXexTZAQam8/u6EGnNTid8UUTrypuqjEaze8ptTGpfoh6ni
 5Pma65kBbey3a+2cSVlCtr8ZYzQ8Q2cHcMM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vjwxvjaqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 21:53:19 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 21:53:18 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 21:53:18 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 21:53:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDcxmdBZJTXxen5tIHTsTRh0txH60KmyWbwfiHXRLQGe+Jh5h/Q4LhpA+zhjN3TLnRmipeXA8fAOUQUDSyZeDJJajGDvPVjeNLj0HPLrP3/aIgCLR1oT4gw5VvFX99Nq2tmcPVBzP5Q4Pz6Kd5e4tL6G54cRlFRIV8egdauMtueeRcZMwemw6AovLsQwoN+szbvOfXvZtbOqSmKOuwIlkpBJgiSe5/xCGF0N5eqiRCDwoGwyjy5+eJCG7eg215SV5AlMAd1Hj+Ree+tmcqTAq/g+0dLESjVvQXpxYAd/n4JFRbwwlLYBbWfzby0V0aT75tIXltrQ0AWvFQqO+fc2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjS4Tl+QEStjbspV1k+CGx2qI1HiAMYRQ4POG1pHhQ0=;
 b=KrIR2TKNrQZKkfPGageesx3o8uNiqh3O3G3kp+Wbpn38AjLatiajO2e1VXplZVPFoBPID/og9m0C3rJNpEfmn1OERxXDCddkUMqB4V5Ukk9zRK9GqA/sjEywN+PjKHc6hryDACDi3Y5f3AfVgh5phpiyBsF2EYOVNq7EBBrMS1mJM2+x7ccmRTUgu3wfyFszYSfrZoRyiC1CST4zb21jGED88OA2sZaSzyp1irp3DwHZB1TA3AK4nAgitLFbRzz6+WTqjxilo+wpOVftdWwihle4gwZcOfI2ggsNS3kAEg0HNVkNASGlyx5q4OqtsUYmxu0Y1YckgyhZorwQDQfcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjS4Tl+QEStjbspV1k+CGx2qI1HiAMYRQ4POG1pHhQ0=;
 b=cez8cgzr+dAx/e525fLMZpFlPVidUyRX7kgwk8XcD9/IqA+VKoJcBljHn33wo+TEOWW12HtnocpgUWu8DMkvjmUawkz/G7sj4imniduFFYMm/6Yjq+iU81KtwEiIfTjFUnD/YQ1//fGKkFmILouCdGZk3Yfwvab0l/T7CGNud84=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3000.namprd15.prod.outlook.com (20.178.238.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Sat, 12 Oct 2019 04:53:17 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 04:53:17 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Topic: [PATCH v2 bpf-next 05/12] libbpf: auto-detect btf_id of
 raw_tracepoint
Thread-Index: AQHVfyFTTiLEwIVqQE6co+EkPTXoLKdVvxuAgABt1ACAAA3QgIAANKwAgAAEOYA=
Date:   Sat, 12 Oct 2019 04:53:16 +0000
Message-ID: <b16deef3-c736-1979-2ce8-6b03b426be67@fb.com>
References: <20191010041503.2526303-1-ast@kernel.org>
 <20191010041503.2526303-6-ast@kernel.org>
 <CAEf4BzZxQDUzYYjF091135d+O_fwZVdK9Dqw5H4_z=5QBqueYg@mail.gmail.com>
 <0dbf83e8-10ec-cc17-c575-949639a7f018@fb.com>
 <ec2ca725-6228-b9e9-e9fc-34e4b34d8a1a@fb.com>
 <CAEf4BzZsz-6ftv628bk9LtEFr1qUoARL32x-kGagi7esOBURyA@mail.gmail.com>
In-Reply-To: <CAEf4BzZsz-6ftv628bk9LtEFr1qUoARL32x-kGagi7esOBURyA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0023.namprd10.prod.outlook.com
 (2603:10b6:301:2a::36) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::fa7a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f9a7d08-5dff-411e-41a3-08d74ed0186f
x-ms-traffictypediagnostic: BYAPR15MB3000:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3000B17E3E831E731DE5A933D7960@BYAPR15MB3000.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(396003)(376002)(39860400002)(189003)(199004)(186003)(6506007)(316002)(2906002)(53546011)(386003)(71190400001)(71200400001)(4326008)(6246003)(102836004)(66476007)(66946007)(66556008)(36756003)(5660300002)(7736002)(64756008)(86362001)(66446008)(305945005)(478600001)(14444005)(5024004)(256004)(14454004)(6512007)(31686004)(8936002)(99286004)(8676002)(25786009)(31696002)(52116002)(6486002)(229853002)(11346002)(446003)(46003)(486006)(76176011)(2616005)(476003)(54906003)(6116002)(81166006)(81156014)(6916009)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3000;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F0Rw3kedPUnNfQvF0/oOokg4C66ansGwohuyUTGqDwKxKtF6rLiUMb+Bor5sk8lpeptgVCyvHa7I9a5Du726pYWg8j/Qh12I1dyiMrvPnShUvi0KUX27TcAe95FtfO9m4wxYAoebq4vnDSccO7OukUwiyTi6HC/ZHDn4sO8V6BKElBaKTeSW8ihMd7zTl7S049ozXEEtWmhADf0QCtP/FWW3RwDUlAhgpcr31eMmXxGPmR14NiQy58muggEXis9wJVbPl9xUXydqRUvZULfD1ouwrTSBXa9/OTi+pNexsUxbVO3XvpPo1T/q6CPSCrorgVqHqJqqordhcOjovXj8pulOYDy/mPoIJyeV05hchQ2xoJEjNYO2HC6bO8fzyfaTeoJS9KrS/ZSci3FYUF0IPmoSB24N4h8tIHBOQrn5i1w=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E7D9EF8F24F2A41886C5F9BFF8374F4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9a7d08-5dff-411e-41a3-08d74ed0186f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 04:53:16.9211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: An5krBt66ZDWthFSXG5lOFtUjSvR+zvxXC2Pjcd0qkAmcptSfyHlh5Y3BO3/5Jdn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3000
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-12_02:2019-10-10,2019-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=830
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910120042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTEvMTkgOTozOCBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBGcmksIE9j
dCAxMSwgMjAxOSBhdCA2OjI5IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGZiLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gT24gMTAvMTEvMTkgNTo0MCBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3Rl
Og0KPj4+PiBCdXQgZXZlbiBpZiBrZXJuZWwgc3VwcG9ydHMgYXR0YWNoX2J0Zl9pZCwgSSB0aGlu
ayB1c2VycyBzdGlsbCBuZWVkIHRvDQo+Pj4+IG9wdCBpbiBpbnRvIHNwZWNpZnlpbmcgYXR0YWNo
X2J0Zl9pZCBieSBsaWJicGYuIFRoaW5rIGFib3V0IGV4aXN0aW5nDQo+Pj4+IHJhd190cCBwcm9n
cmFtcyB0aGF0IGFyZSB1c2luZyBicGZfcHJvYmVfcmVhZCgpIGJlY2F1c2UgdGhleSB3ZXJlIG5v
dA0KPj4+PiBjcmVhdGVkIHdpdGggdGhpcyBrZXJuZWwgZmVhdHVyZSBpbiBtaW5kLiBUaGV5IHdp
bGwgc3VkZGVubHkgc3RvcA0KPj4+PiB3b3JraW5nIHdpdGhvdXQgYW55IG9mIHVzZXIncyBmYXVs
dC4NCj4+Pg0KPj4+IFRoaXMgb25lIGlzIGV4Y2VsbGVudCBjYXRjaC4NCj4+PiBsb29wMS5jIHNo
b3VsZCBoYXZlIGNhdWdodCBpdCwgc2luY2UgaXQgaGFzDQo+Pj4gU0VDKCJyYXdfdHJhY2Vwb2lu
dC9rZnJlZV9za2IiKQ0KPj4+IHsNCj4+PiAgICAgaW50IG5lc3RlZF9sb29wcyh2b2xhdGlsZSBz
dHJ1Y3QgcHRfcmVncyogY3R4KQ0KPj4+ICAgICAgLi4gPSBQVF9SRUdTX1JDKGN0eCk7DQo+Pj4N
Cj4+PiBhbmQgdmVyaWZpZXIgd291bGQgaGF2ZSByZWplY3RlZCBpdC4NCj4+PiBCdXQgdGhlIHdh
eSB0aGUgdGVzdCBpcyB3cml0dGVuIGl0J3Mgbm90IHVzaW5nIGxpYmJwZidzIGF1dG9kZXRlY3QN
Cj4+PiBvZiBwcm9ncmFtIHR5cGUsIHNvIGV2ZXJ5dGhpbmcgaXMgcGFzc2luZy4NCj4+DQo+PiBX
aXRoOg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rl
c3RzL2JwZl92ZXJpZl9zY2FsZS5jDQo+PiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9w
cm9nX3Rlc3RzL2JwZl92ZXJpZl9zY2FsZS5jDQo+PiBpbmRleCAxYzAxZWUyNjAwYTkuLmUyNzE1
NmRjZTEwZCAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
X3Rlc3RzL2JwZl92ZXJpZl9zY2FsZS5jDQo+PiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYw0KPj4gQEAgLTY3LDcgKzY3LDcgQEAg
dm9pZCB0ZXN0X2JwZl92ZXJpZl9zY2FsZSh2b2lkKQ0KPj4gICAgICAgICAgICAgICAgICAgICov
DQo+PiAgICAgICAgICAgICAgICAgICB7ICJweXBlcmY2MDBfbm91bnJvbGwubyIsIEJQRl9QUk9H
X1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCj4+DQo+PiAtICAgICAgICAgICAgICAgeyAibG9vcDEu
byIsIEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCj4+ICsgICAgICAgICAgICAgICB7
ICJsb29wMS5vIiwgQlBGX1BST0dfVFlQRV9VTlNQRUN9LA0KPj4gICAgICAgICAgICAgICAgICAg
eyAibG9vcDIubyIsIEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCj4+DQo+PiBsaWJi
cGYgcHJvZyBhdXRvLWRldGVjdGlvbiBraWNrcyBpbiBhbmQgLi4uDQo+PiAjIC4vdGVzdF9wcm9n
cyAtbiAzLzEwDQo+PiBsaWJicGY6IGxvYWQgYnBmIHByb2dyYW0gZmFpbGVkOiBQZXJtaXNzaW9u
IGRlbmllZA0KPj4gbGliYnBmOiAtLSBCRUdJTiBEVU1QIExPRyAtLS0NCj4+IGxpYmJwZjoNCj4+
IHJhd190cCAna2ZyZWVfc2tiJyBkb2Vzbid0IGhhdmUgMTAtdGggYXJndW1lbnQNCj4+IGludmFs
aWQgYnBmX2NvbnRleHQgYWNjZXNzIG9mZj04MCBzaXplPTgNCj4+DQo+PiBHb29kIDopIFRoZSB2
ZXJpZmllciBpcyBkb2luZyBpdHMgam9iLg0KPiANCj4gb2gsIGFub3RoZXIgc3VwZXIgaW50dWl0
aXZlIGVycm9yIGZyb20gdmVyaWZpZXIgOykgMTB0aCBhcmd1bWVudCwgd2hhdD8uLg0KDQpJIGtu
b3csIGJ1dCB0aGVyZSBpcyBubyBlbnYtPmxpbmZvIGFuZCBubyBpbnNuX2lkeCB0byBjYWxsDQp2
ZXJib3NlX2xpbmZvKCkgZnJvbSB0aGVyZS4gVGhhdCdzIGV2ZW4gYmlnZ2VyIHJlZmFjdG9yaW5n
DQp0aGF0IEknZCByYXRoZXIgdG8gbGF0ZXIuDQo=
