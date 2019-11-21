Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54D1105900
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKUSAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:00:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41836 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfKUSAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:00:41 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALHwLpv026603;
        Thu, 21 Nov 2019 10:00:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0jHzbAeCAn9XlEhXsxYLk12L+TVswjDCeNHQweO7Y+Q=;
 b=UuAhCohHf/1N+bOYD6Gc3nPc2loja74vdj+bran9wv6fC4SbF1jiozD/SnAaOS/Dq7Gf
 ZpSF+lO7B0zzY0llhtEe9Jc7npxhklKdv1zyzXof8rXCHnsHXKxc3trb9HnGyT7Sy1LH
 rOH2IN5sSxhOMvU94KKSWcJdpDdapkE7Lyc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wddynrryx-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Nov 2019 10:00:21 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 10:00:20 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 10:00:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxVHnIAcShbA9BtA7m7VHaswT4UBYmfMI8SeNC4oTt0QAY9/YEZxCoAz02+7KTOajV55gSsAC29nMtqLrhHNSKHDR/6LYqBFRCVxrYWN5o/QsCaeMpGrDgspVUvk9rrt4+1bpoLcxI5UnsA2/bcZ6CWlkmkmF1w/79IalVINo7fLfokcGZs/W3Sklzl5fM4I5yjVSLO71Kv+2Ma+YnpOG2Tb744fLx6bQbtLnIJC7PVNlGVdaYlQjRObeg0JNWzQ+aWjMl15LstXwCR6gKOn+4NrFN1Seq3nXOvT/JCaSXwDI00BeI2W85DYQbKp/GKDadkiZCS/0bRRtzElkg5LeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jHzbAeCAn9XlEhXsxYLk12L+TVswjDCeNHQweO7Y+Q=;
 b=Se84tv5dOOmkQZVAM4ObH+LHArT1zCpfys68bka/J6KSyBwiMInAno5Z9rierZPpTh1MfUPJhMUEXZWMIQUxWHDiHTnXmZend4NkARVH+Kx/4ZSuz+8AD+p3cDC6wXaFNRcT35wVvZJux+JesNaWvychhKX2Nn7Y6n8cMZFcUgwhqNDP7EYgqjkQ1Z/qrPTWSrTTDKGB3Wr36g4c8vnc0vm/wPF4uhG6cnSYGq6CI/kR5NquDS2w/4ESkzxzDF2OQKBpsQwBgHZc7Y1PraDV9l83+88WgJX+dOwC7mcfiGsQrEXPLZ+j1XX+VvU3QHmpC0sIuDn34KvAA7yzpKKi/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jHzbAeCAn9XlEhXsxYLk12L+TVswjDCeNHQweO7Y+Q=;
 b=NIE0bBYarqQdGOQoJLPpX3m8gMTW2tjfQoGKHf8zMPC+HiwXmg80s4iwRJOKQ39bs9J8U+U896ZCWUMB3rh+WVAjyaPOaFvM4xVJE+slaePawReSWK/heKl2FvAihXceenBx0jwwiiyDGhbopW1nmAqEcnms4iJagyFYqDB5Fhw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3320.namprd15.prod.outlook.com (20.179.56.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Thu, 21 Nov 2019 18:00:19 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 18:00:19 +0000
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
Subject: Re: [PATCH v2 bpf-next 3/9] bpf: add generic support for update and
 delete batch ops
Thread-Topic: [PATCH v2 bpf-next 3/9] bpf: add generic support for update and
 delete batch ops
Thread-Index: AQHVnw/6zUZCp1egDkKYUdXR4CKbu6eV7O4A
Date:   Thu, 21 Nov 2019 18:00:19 +0000
Message-ID: <47ebff4c-1cb6-c136-b4a8-19dfe47a721f@fb.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-4-brianvv@google.com>
In-Reply-To: <20191119193036.92831-4-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0044.namprd21.prod.outlook.com
 (2603:10b6:300:129::30) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:b385]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec3ff9a1-b755-4a7b-d135-08d76eacabc3
x-ms-traffictypediagnostic: BYAPR15MB3320:
x-microsoft-antispam-prvs: <BYAPR15MB3320EBB941914A37FB3A8428D34E0@BYAPR15MB3320.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(376002)(366004)(136003)(189003)(199004)(256004)(76176011)(229853002)(6512007)(6116002)(86362001)(102836004)(386003)(6506007)(53546011)(7416002)(305945005)(66946007)(11346002)(14444005)(66556008)(64756008)(2906002)(6436002)(66446008)(36756003)(6486002)(8676002)(8936002)(81156014)(81166006)(2616005)(66476007)(446003)(7736002)(25786009)(14454004)(71190400001)(15650500001)(31686004)(52116002)(186003)(54906003)(31696002)(46003)(316002)(110136005)(99286004)(6246003)(5660300002)(478600001)(71200400001)(4326008)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3320;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jCIoiaMq1jpprxsI2ZYQHyOekTjhAUKzmzvJMff+MjnbIWMHh+UPkMMnQUI9XsCyEl6Ay1T7ct2GEdrC5zSRCYLmXHA0MqaaR6mVxX1uJSwBEaVNTXEhmP9GMsBNze5InwLnf8WvmYjO6/1KHkX0nKvM6WOiq2mv6+3loH5R+yNCJJNw8i6JZM8982fq5QTghXDWhVngtATzI9CZ4+sjlhC04RZDWdh7GWvQb1WR+nw0k97ShoNeqrozuk1thLZSZAGFS7H+R09cClJXU0S7Dnlncr8pW5cwe5zQdQjzSJ4vfAdpVAeFOhxrH2duS10KBcWuf2xpKTxT3s2arQWXCiEYgWAAYtDr9DtRpdZNrHcvJNNwGqeSOiHGeD7Pj/MLL9qcEd/cz6Q3divA4jsimB5bPqsn/JV+9XLlorUluxaSyj3IGDWeXDKjocUT8dFI
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D33106858A88CF408ECE398B755B50FB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3ff9a1-b755-4a7b-d135-08d76eacabc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 18:00:19.2321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Lu3sO/E2n6NPZhcsg+GnmCZRwPFoH4dq67XHcPvyLxW5u4BOW4sGql0L8qPxDXc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3320
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_05:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzE5LzE5IDExOjMwIEFNLCBCcmlhbiBWYXpxdWV6IHdyb3RlOg0KPiBUaGlzIGNv
bW1pdCBhZGRzIGdlbmVyaWMgc3VwcG9ydCBmb3IgdXBkYXRlIGFuZCBkZWxldGUgYmF0Y2ggb3Bz
IHRoYXQNCj4gY2FuIGJlIHVzZWQgZm9yIGFsbW9zdCBhbGwgdGhlIGJwZiBtYXBzLiBUaGVzZSBj
b21tYW5kcyBzaGFyZSB0aGUgc2FtZQ0KPiBVQVBJIGF0dHIgdGhhdCBsb29rdXAgYW5kIGxvb2t1
cF9hbmRfZGVsZXRlIGJhdGNoIG9wcyB1c2UgYW5kIHRoZQ0KPiBzeXNjYWxsIGNvbW1hbmRzIGFy
ZToNCj4gDQo+ICAgIEJQRl9NQVBfVVBEQVRFX0JBVENIDQo+ICAgIEJQRl9NQVBfREVMRVRFX0JB
VENIDQo+IA0KPiBUaGUgbWFpbiBkaWZmZXJlbmNlIGJldHdlZW4gdXBkYXRlL2RlbGV0ZSBhbmQg
bG9va3VwL2xvb2t1cF9hbmRfZGVsZXRlDQo+IGJhdGNoIG9wcyBpcyB0aGF0IGZvciB1cGRhdGUv
ZGVsZXRlIGtleXMvdmFsdWVzIG11c3QgYmUgc3BlY2lmaWVkIGZvcg0KPiB1c2Vyc3BhY2UgYW5k
IGJlY2F1c2Ugb2YgdGhhdCwgbmVpdGhlciBpbl9iYXRjaCBub3Igb3V0X2JhdGNoIGFyZSB1c2Vk
Lg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBCcmlhbiBWYXpxdWV6IDxicmlhbnZ2QGdvb2dsZS5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IC0tLQ0KPiAgIGlu
Y2x1ZGUvbGludXgvYnBmLmggICAgICB8ICAxMCArKysrDQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4
L2JwZi5oIHwgICAyICsNCj4gICBrZXJuZWwvYnBmL3N5c2NhbGwuYyAgICAgfCAxMjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCAx
MzcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvYnBmLmggYi9pbmNsdWRlL2xpbnV4L2JwZi5oDQo+IGluZGV4IDc2N2E4MjNkYmFj
NzQuLjk2YTE5ZTFmZDJiNWIgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvYnBmLmgNCj4g
KysrIGIvaW5jbHVkZS9saW51eC9icGYuaA0KPiBAQCAtNDYsNiArNDYsMTAgQEAgc3RydWN0IGJw
Zl9tYXBfb3BzIHsNCj4gICAJaW50ICgqbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoKShzdHJ1
Y3QgYnBmX21hcCAqbWFwLA0KPiAgIAkJCQkJICAgY29uc3QgdW5pb24gYnBmX2F0dHIgKmF0dHIs
DQo+ICAgCQkJCQkgICB1bmlvbiBicGZfYXR0ciBfX3VzZXIgKnVhdHRyKTsNCj4gKwlpbnQgKCpt
YXBfdXBkYXRlX2JhdGNoKShzdHJ1Y3QgYnBmX21hcCAqbWFwLCBjb25zdCB1bmlvbiBicGZfYXR0
ciAqYXR0ciwNCj4gKwkJCQl1bmlvbiBicGZfYXR0ciBfX3VzZXIgKnVhdHRyKTsNCj4gKwlpbnQg
KCptYXBfZGVsZXRlX2JhdGNoKShzdHJ1Y3QgYnBmX21hcCAqbWFwLCBjb25zdCB1bmlvbiBicGZf
YXR0ciAqYXR0ciwNCj4gKwkJCQl1bmlvbiBicGZfYXR0ciBfX3VzZXIgKnVhdHRyKTsNCj4gICAN
Cj4gICAJLyogZnVuY3MgY2FsbGFibGUgZnJvbSB1c2Vyc3BhY2UgYW5kIGZyb20gZUJQRiBwcm9n
cmFtcyAqLw0KPiAgIAl2b2lkICooKm1hcF9sb29rdXBfZWxlbSkoc3RydWN0IGJwZl9tYXAgKm1h
cCwgdm9pZCAqa2V5KTsNCj4gQEAgLTgwOCw2ICs4MTIsMTIgQEAgaW50ICBnZW5lcmljX21hcF9s
b29rdXBfYmF0Y2goc3RydWN0IGJwZl9tYXAgKm1hcCwNCj4gICBpbnQgIGdlbmVyaWNfbWFwX2xv
b2t1cF9hbmRfZGVsZXRlX2JhdGNoKHN0cnVjdCBicGZfbWFwICptYXAsDQo+ICAgCQkJCQkgY29u
c3QgdW5pb24gYnBmX2F0dHIgKmF0dHIsDQo+ICAgCQkJCQkgdW5pb24gYnBmX2F0dHIgX191c2Vy
ICp1YXR0cik7DQo+ICtpbnQgIGdlbmVyaWNfbWFwX3VwZGF0ZV9iYXRjaChzdHJ1Y3QgYnBmX21h
cCAqbWFwLA0KPiArCQkJICAgICAgY29uc3QgdW5pb24gYnBmX2F0dHIgKmF0dHIsDQo+ICsJCQkg
ICAgICB1bmlvbiBicGZfYXR0ciBfX3VzZXIgKnVhdHRyKTsNCj4gK2ludCAgZ2VuZXJpY19tYXBf
ZGVsZXRlX2JhdGNoKHN0cnVjdCBicGZfbWFwICptYXAsDQo+ICsJCQkgICAgICBjb25zdCB1bmlv
biBicGZfYXR0ciAqYXR0ciwNCj4gKwkJCSAgICAgIHVuaW9uIGJwZl9hdHRyIF9fdXNlciAqdWF0
dHIpOw0KPiAgIA0KPiAgIGV4dGVybiBpbnQgc3lzY3RsX3VucHJpdmlsZWdlZF9icGZfZGlzYWJs
ZWQ7DQo+ICAgDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNs
dWRlL3VhcGkvbGludXgvYnBmLmgNCj4gaW5kZXggZTYwYjdiN2NkYTYxYS4uMGY2ZmYwYzRkNzlk
ZCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ICsrKyBiL2luY2x1
ZGUvdWFwaS9saW51eC9icGYuaA0KPiBAQCAtMTA5LDYgKzEwOSw4IEBAIGVudW0gYnBmX2NtZCB7
DQo+ICAgCUJQRl9CVEZfR0VUX05FWFRfSUQsDQo+ICAgCUJQRl9NQVBfTE9PS1VQX0JBVENILA0K
PiAgIAlCUEZfTUFQX0xPT0tVUF9BTkRfREVMRVRFX0JBVENILA0KPiArCUJQRl9NQVBfVVBEQVRF
X0JBVENILA0KPiArCUJQRl9NQVBfREVMRVRFX0JBVENILA0KPiAgIH07DQo+ICAgDQo+ICAgZW51
bSBicGZfbWFwX3R5cGUgew0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9zeXNjYWxsLmMgYi9r
ZXJuZWwvYnBmL3N5c2NhbGwuYw0KPiBpbmRleCBkMGQzZDBlMGVhY2E0Li4wNmUxYmNmNDBmYjhk
IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL3N5c2NhbGwuYw0KPiArKysgYi9rZXJuZWwvYnBm
L3N5c2NhbGwuYw0KPiBAQCAtMTEyNyw2ICsxMTI3LDEyMCBAQCBzdGF0aWMgaW50IG1hcF9nZXRf
bmV4dF9rZXkodW5pb24gYnBmX2F0dHIgKmF0dHIpDQo+ICAgCXJldHVybiBlcnI7DQo+ICAgfQ0K
PiAgIA0KPiAraW50IGdlbmVyaWNfbWFwX2RlbGV0ZV9iYXRjaChzdHJ1Y3QgYnBmX21hcCAqbWFw
LA0KPiArCQkJICAgICBjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4gKwkJCSAgICAgdW5p
b24gYnBmX2F0dHIgX191c2VyICp1YXR0cikNCj4gK3sNCj4gKwl2b2lkIF9fdXNlciAqa2V5cyA9
IHU2NF90b191c2VyX3B0cihhdHRyLT5iYXRjaC5rZXlzKTsNCj4gKwlpbnQgdWZkID0gYXR0ci0+
bWFwX2ZkOw0KPiArCXUzMiBjcCwgbWF4X2NvdW50Ow0KPiArCXN0cnVjdCBmZCBmOw0KPiArCXZv
aWQgKmtleTsNCj4gKwlpbnQgZXJyOw0KPiArDQo+ICsJZiA9IGZkZ2V0KHVmZCk7DQo+ICsJaWYg
KGF0dHItPmJhdGNoLmVsZW1fZmxhZ3MgJiB+QlBGX0ZfTE9DSykNCj4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ICsNCj4gKwlpZiAoKGF0dHItPmJhdGNoLmVsZW1fZmxhZ3MgJiBCUEZfRl9MT0NLKSAm
Jg0KPiArCSAgICAhbWFwX3ZhbHVlX2hhc19zcGluX2xvY2sobWFwKSkgew0KPiArCQllcnIgPSAt
RUlOVkFMOw0KPiArCQlnb3RvIGVycl9wdXQ7DQoNCkp1c3QgcmV0dXJuIC1FSU5WQUw/DQoNCj4g
Kwl9DQo+ICsNCj4gKwltYXhfY291bnQgPSBhdHRyLT5iYXRjaC5jb3VudDsNCj4gKwlpZiAoIW1h
eF9jb3VudCkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwllcnIgPSAtRU5PTUVNOw0KDQpXaHkg
aW5pdGlhbGl6ZSBlcnIgdG8gLUVOT01FTT8gTWF5YmUganVzdCBlcnIgPSAwLg0KDQo+ICsJZm9y
IChjcCA9IDA7IGNwIDwgbWF4X2NvdW50OyBjcCsrKSB7DQo+ICsJCWtleSA9IF9fYnBmX2NvcHlf
a2V5KGtleXMgKyBjcCAqIG1hcC0+a2V5X3NpemUsIG1hcC0+a2V5X3NpemUpOw0KPiArCQlpZiAo
SVNfRVJSKGtleSkpIHsNCj4gKwkJCWVyciA9IFBUUl9FUlIoa2V5KTsNCj4gKwkJCWJyZWFrOw0K
PiArCQl9DQo+ICsNCj4gKwkJaWYgKGVycikNCj4gKwkJCWJyZWFrOw0KDQpUaGUgYWJvdmUgaXMg
aW5jb3JyZWN0LCBlc3AuIGlmIHlvdSBhc3NpZ24gZXJyIGluaXRpYWwgdmFsdWUgdG8gLUVOT01F
TS4NClRoZSBhYm92ZSBgIGlmIChlcnIpIGJyZWFrOyBgIGlzIG5vdCByZWFsbHkgbmVlZGVkLiBJ
ZiB0aGVyZSBpcyBlcnJvciwNCnlvdSBhbHJlYWR5IGJyZWFrIGluIHRoZSBhYm92ZS4NCklmIG1h
cC0+a2V5X3NpemUgaXMgbm90IDAsIHRoZSByZXR1cm4gdmFsdWUgJ2tleScgY2Fubm90IGJlIE5V
TEwgcG9pbnRlci4NCg0KPiArCQlpZiAoYnBmX21hcF9pc19kZXZfYm91bmQobWFwKSkgew0KPiAr
CQkJZXJyID0gYnBmX21hcF9vZmZsb2FkX2RlbGV0ZV9lbGVtKG1hcCwga2V5KTsNCj4gKwkJCWJy
ZWFrOw0KPiArCQl9DQo+ICsNCj4gKwkJcHJlZW1wdF9kaXNhYmxlKCk7DQo+ICsJCV9fdGhpc19j
cHVfaW5jKGJwZl9wcm9nX2FjdGl2ZSk7DQo+ICsJCXJjdV9yZWFkX2xvY2soKTsNCj4gKwkJZXJy
ID0gbWFwLT5vcHMtPm1hcF9kZWxldGVfZWxlbShtYXAsIGtleSk7DQo+ICsJCXJjdV9yZWFkX3Vu
bG9jaygpOw0KPiArCQlfX3RoaXNfY3B1X2RlYyhicGZfcHJvZ19hY3RpdmUpOw0KPiArCQlwcmVl
bXB0X2VuYWJsZSgpOw0KPiArCQltYXliZV93YWl0X2JwZl9wcm9ncmFtcyhtYXApOw0KPiArCQlp
ZiAoZXJyKQ0KPiArCQkJYnJlYWs7DQo+ICsJfQ0KPiArCWlmIChjb3B5X3RvX3VzZXIoJnVhdHRy
LT5iYXRjaC5jb3VudCwgJmNwLCBzaXplb2YoY3ApKSkNCj4gKwkJZXJyID0gLUVGQVVMVDsNCg0K
SWYgcHJldmlvdXMgZXJyID0gLUVGQVVMVCwgZXZlbiBpZiBjb3B5X3RvX3VzZXIoKSBzdWNjZWVk
ZWQsDQpyZXR1cm4gdmFsdWUgd2lsbCBiZSAtRUZBVUxULCBzbyB1YXR0ci0+YmF0Y2guY291bnQg
Y2Fubm90IGJlDQp0cnVzdGVkLiBTbyBtYXkgYmUgZG8NCiAgICBpZiAoZXJyICE9IC1FRkFVTFQg
JiYgY29weV90b191c2VyKC4uLikpDQogICAgICAgZXJyID0gLUVGQVVMVA0KPw0KVGhlcmUgYXJl
IHNldmVyYWwgb3RoZXIgcGxhY2VzIGxpa2UgdGhpcy4NCg0KPiArZXJyX3B1dDoNCg0KWW91IGRv
bid0IG5lZWQgZXJyX3B1dCBsYWJlbCBpbiB0aGUgYWJvdmUuDQoNCj4gKwlyZXR1cm4gZXJyOw0K
PiArfQ0KPiAraW50IGdlbmVyaWNfbWFwX3VwZGF0ZV9iYXRjaChzdHJ1Y3QgYnBmX21hcCAqbWFw
LA0KPiArCQkJICAgICBjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4gKwkJCSAgICAgdW5p
b24gYnBmX2F0dHIgX191c2VyICp1YXR0cikNCj4gK3sNCj4gKwl2b2lkIF9fdXNlciAqdmFsdWVz
ID0gdTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLnZhbHVlcyk7DQo+ICsJdm9pZCBfX3VzZXIg
KmtleXMgPSB1NjRfdG9fdXNlcl9wdHIoYXR0ci0+YmF0Y2gua2V5cyk7DQo+ICsJdTMyIHZhbHVl
X3NpemUsIGNwLCBtYXhfY291bnQ7DQo+ICsJaW50IHVmZCA9IGF0dHItPm1hcF9mZDsNCj4gKwl2
b2lkICprZXksICp2YWx1ZTsNCj4gKwlzdHJ1Y3QgZmQgZjsNCj4gKwlpbnQgZXJyOw0KPiArDQo+
ICsJZiA9IGZkZ2V0KHVmZCk7DQo+ICsJaWYgKGF0dHItPmJhdGNoLmVsZW1fZmxhZ3MgJiB+QlBG
X0ZfTE9DSykNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsNCj4gKwlpZiAoKGF0dHItPmJhdGNo
LmVsZW1fZmxhZ3MgJiBCUEZfRl9MT0NLKSAmJg0KPiArCSAgICAhbWFwX3ZhbHVlX2hhc19zcGlu
X2xvY2sobWFwKSkgew0KPiArCQllcnIgPSAtRUlOVkFMOw0KPiArCQlnb3RvIGVycl9wdXQ7DQoN
CkRpcmVjdGx5IHJldHVybiAtRUlOVkFMPw0KDQo+ICsJfQ0KPiArDQo+ICsJdmFsdWVfc2l6ZSA9
IGJwZl9tYXBfdmFsdWVfc2l6ZShtYXApOw0KPiArDQo+ICsJbWF4X2NvdW50ID0gYXR0ci0+YmF0
Y2guY291bnQ7DQo+ICsJaWYgKCFtYXhfY291bnQpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJ
ZXJyID0gLUVOT01FTTsNCj4gKwl2YWx1ZSA9IGttYWxsb2ModmFsdWVfc2l6ZSwgR0ZQX1VTRVIg
fCBfX0dGUF9OT1dBUk4pOw0KPiArCWlmICghdmFsdWUpDQo+ICsJCWdvdG8gZXJyX3B1dDsNCg0K
RGlyZWN0bHkgcmV0dXJuIC1FTk9NRU0/DQoNCj4gKw0KPiArCWZvciAoY3AgPSAwOyBjcCA8IG1h
eF9jb3VudDsgY3ArKykgew0KPiArCQlrZXkgPSBfX2JwZl9jb3B5X2tleShrZXlzICsgY3AgKiBt
YXAtPmtleV9zaXplLCBtYXAtPmtleV9zaXplKTsNCg0KRG8geW91IG5lZWQgdG8gZnJlZSAna2V5
JyBhZnRlciBpdHMgdXNlPw0KDQo+ICsJCWlmIChJU19FUlIoa2V5KSkgew0KPiArCQkJZXJyID0g
UFRSX0VSUihrZXkpOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gKwkJZXJyID0gLUVGQVVMVDsN
Cj4gKwkJaWYgKGNvcHlfZnJvbV91c2VyKHZhbHVlLCB2YWx1ZXMgKyBjcCAqIHZhbHVlX3NpemUs
IHZhbHVlX3NpemUpKQ0KPiArCQkJYnJlYWs7DQo+ICsNCj4gKwkJZXJyID0gYnBmX21hcF91cGRh
dGVfdmFsdWUobWFwLCBmLCBrZXksIHZhbHVlLA0KPiArCQkJCQkgICBhdHRyLT5iYXRjaC5lbGVt
X2ZsYWdzKTsNCj4gKw0KPiArCQlpZiAoZXJyKQ0KPiArCQkJYnJlYWs7DQo+ICsJfQ0KPiArDQo+
ICsJaWYgKGNvcHlfdG9fdXNlcigmdWF0dHItPmJhdGNoLmNvdW50LCAmY3AsIHNpemVvZihjcCkp
KQ0KPiArCQllcnIgPSAtRUZBVUxUOw0KDQpTaW1pbGFyIHRvIHRoZSBhYm92ZSBjb21tZW50LCBp
ZiBlcnIgYWxyZWFkeSAtRUZBVUxULCBubyBuZWVkDQp0byBkbyBjb3B5X3RvX3VzZXIoKS4NCg0K
PiArDQo+ICsJa2ZyZWUodmFsdWUpOw0KPiArZXJyX3B1dDoNCg0KZXJyX3B1dCBsYWJlbCBpcyBu
b3QgbmVlZGVkLg0KDQo+ICsJcmV0dXJuIGVycjsNCj4gK30NCj4gKw0KPiAgIHN0YXRpYyBpbnQg
X19nZW5lcmljX21hcF9sb29rdXBfYmF0Y2goc3RydWN0IGJwZl9tYXAgKm1hcCwNCj4gICAJCQkJ
ICAgICAgY29uc3QgdW5pb24gYnBmX2F0dHIgKmF0dHIsDQo+ICAgCQkJCSAgICAgIHVuaW9uIGJw
Zl9hdHRyIF9fdXNlciAqdWF0dHIsDQo+IEBAIC0zMTE3LDggKzMyMzEsMTIgQEAgc3RhdGljIGlu
dCBicGZfbWFwX2RvX2JhdGNoKGNvbnN0IHVuaW9uIGJwZl9hdHRyICphdHRyLA0KPiAgIA0KPiAg
IAlpZiAoY21kID09IEJQRl9NQVBfTE9PS1VQX0JBVENIKQ0KPiAgIAkJQlBGX0RPX0JBVENIKG1h
cC0+b3BzLT5tYXBfbG9va3VwX2JhdGNoKTsNCj4gLQllbHNlDQo+ICsJZWxzZSBpZiAoY21kID09
IEJQRl9NQVBfTE9PS1VQX0FORF9ERUxFVEVfQkFUQ0gpDQo+ICAgCQlCUEZfRE9fQkFUQ0gobWFw
LT5vcHMtPm1hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRjaCk7DQo+ICsJZWxzZSBpZiAoY21kID09
IEJQRl9NQVBfVVBEQVRFX0JBVENIKQ0KPiArCQlCUEZfRE9fQkFUQ0gobWFwLT5vcHMtPm1hcF91
cGRhdGVfYmF0Y2gpOw0KPiArCWVsc2UNCj4gKwkJQlBGX0RPX0JBVENIKG1hcC0+b3BzLT5tYXBf
ZGVsZXRlX2JhdGNoKTsNCg0KQWxzbyBuZWVkIHRvIGNoZWNrIG1hcF9nZXRfc3lzX3Blcm1zKCkg
cGVybWlzc2lvbnMgZm9yIHRoZXNlIHR3byBuZXcgDQpjb21tYW5kcy4gQm90aCBkZWxldGUgYW5k
IHVwZGF0ZSBuZWVkcyBGTU9ERV9DQU5fV1JJVEUgcGVybWlzc2lvbi4NCg0KPiAgIA0KPiAgIGVy
cl9wdXQ6DQo+ICAgCWZkcHV0KGYpOw0KPiBAQCAtMzIyOSw2ICszMzQ3LDEyIEBAIFNZU0NBTExf
REVGSU5FMyhicGYsIGludCwgY21kLCB1bmlvbiBicGZfYXR0ciBfX3VzZXIgKiwgdWF0dHIsIHVu
c2lnbmVkIGludCwgc2l6DQo+ICAgCQllcnIgPSBicGZfbWFwX2RvX2JhdGNoKCZhdHRyLCB1YXR0
ciwNCj4gICAJCQkJICAgICAgIEJQRl9NQVBfTE9PS1VQX0FORF9ERUxFVEVfQkFUQ0gpOw0KPiAg
IAkJYnJlYWs7DQo+ICsJY2FzZSBCUEZfTUFQX1VQREFURV9CQVRDSDoNCj4gKwkJZXJyID0gYnBm
X21hcF9kb19iYXRjaCgmYXR0ciwgdWF0dHIsIEJQRl9NQVBfVVBEQVRFX0JBVENIKTsNCj4gKwkJ
YnJlYWs7DQo+ICsJY2FzZSBCUEZfTUFQX0RFTEVURV9CQVRDSDoNCj4gKwkJZXJyID0gYnBmX21h
cF9kb19iYXRjaCgmYXR0ciwgdWF0dHIsIEJQRl9NQVBfREVMRVRFX0JBVENIKTsNCj4gKwkJYnJl
YWs7DQo+ICAgCWRlZmF1bHQ6DQo+ICAgCQllcnIgPSAtRUlOVkFMOw0KPiAgIAkJYnJlYWs7DQo+
IA0K
