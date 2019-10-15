Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29C2D798C
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 17:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733221AbfJOPPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 11:15:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58902 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbfJOPPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 11:15:19 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FFB0wg006152;
        Tue, 15 Oct 2019 08:15:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=umHBjyUrTa+w9g4cqSMK/Toz0wx0G8UvLviSR9eNbLc=;
 b=kW4cd/v+KHBQimguNsH0UUlvDuhqTMKRvgeMll8elN3/tdIixI6J3TpwhpPv7Uki5P5n
 p1aKTb/VV0PnKKCcTfoofnUBYbzDs9uXhcafm94hnZn4EEpKSayDwi4bOiqQRrCNYNYB
 yDCT0GboZEoMuWsAxll54FPhriO8MC+pUwg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vkxget7yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Oct 2019 08:15:06 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 08:15:04 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 08:15:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaz7N0N+YEwbs8rJLoJgmMKBzFHcD+TyYs6Cl7eiP/tSeF9KEV3uf5idP/TZS7UCtdtKNt9cGqjL7wjLjQ4T6Psc8ETKtN4Vo3l4/qy7ijvDjrKGj3LG/WAYLvmOTyZN87xjwOKZOziCr9dq1ann1/xzyyRY/tbjeU8sjnSrYIdJQNz+R1ArwlM8NGWdUhEgUhlNxN691ZbqwOgc1+8oLHm07drdUZXaaUewVWgr93QwvYShnXOagzFI5NiYoBf6abLxLfxVNIqzsVovf3EeED24f8mGrB4xqnjS0V/aOjjvZNm+8DzE38iPEjt1/CXU1dtAoJxzROf2S4Vzp8pN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umHBjyUrTa+w9g4cqSMK/Toz0wx0G8UvLviSR9eNbLc=;
 b=N7y91TlehVJd0jn1I9do8aY+pvpGJR6OY7kFfwNZPoltRLi7isRlVaEnQ388aZAkOoSGFs7rvd1TiuLA7TddpvniUTAOaaFMN8656Jjt/Kuo2x6ytlG7TDaYxhWOEV01vXivY88xq1UTxDQKiJbRNUJeawTxyzQthhnr+ubjfI0xW+ob2SoWaWkIMwxaP4DqTFSqkWmGlFYL0/sldqUR5CWk5abq/5LToIMjtXMWI4catCKPM4p3PlJ3P90a52WeXveNEBpLrSwPf97o+QQnj1rqbdHZl5+ob7duWLwWc5w/PTuI/ZumTitSmc/RgJyyKQIE4T9+QuH1FdmWN0Pr3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umHBjyUrTa+w9g4cqSMK/Toz0wx0G8UvLviSR9eNbLc=;
 b=EBeCqAwIo6SlBVRm2rFoIqkxqgD362fDNb3dhODD5EalWnNR7j1UdSa2NcQ6PCvOmM09BcTqCSt25BvzWXpTb7Bqkiv74F9cMKvxGy1s6Wrfwo/UEv7XQWWTPNxDTRQRRMgyTHDv/l86T51l46IUt5yQYPKtWiAXJHwbwJ3F/dU=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2231.namprd15.prod.outlook.com (52.135.199.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Tue, 15 Oct 2019 15:15:03 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 15:15:03 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/5] libbpf: update BTF reloc support to latest
 Clang format
Thread-Topic: [PATCH bpf-next 1/5] libbpf: update BTF reloc support to latest
 Clang format
Thread-Index: AQHVguoPeleVgCAPQE+guuLGfNukYadb0MqA
Date:   Tue, 15 Oct 2019 15:15:03 +0000
Message-ID: <4c10947e-5d75-a224-8b9c-6af81fc07324@fb.com>
References: <20191014234928.561043-1-andriin@fb.com>
 <20191014234928.561043-2-andriin@fb.com>
In-Reply-To: <20191014234928.561043-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0048.namprd12.prod.outlook.com
 (2603:10b6:301:2::34) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a5e7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 965c73a0-e8a2-4009-8ba2-08d7518273bf
x-ms-traffictypediagnostic: BYAPR15MB2231:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB22319C610EA227ADD0FE1959D7930@BYAPR15MB2231.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(186003)(99286004)(2201001)(478600001)(14454004)(2501003)(86362001)(31686004)(36756003)(316002)(71200400001)(110136005)(54906003)(71190400001)(5660300002)(386003)(53546011)(31696002)(25786009)(6506007)(76176011)(52116002)(102836004)(486006)(476003)(6116002)(6486002)(4326008)(446003)(2616005)(6436002)(46003)(256004)(6246003)(66556008)(66446008)(2906002)(11346002)(7736002)(229853002)(305945005)(8676002)(81156014)(81166006)(8936002)(6512007)(66946007)(66476007)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2231;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +a6WYa0xjTiaphEoKjyQlI/7AjsYHHIr9S00Y/mJr/euoI+DQ1Z/L4R8GjlKSSMQe4P0SLk8n4jLyYu6PBLXttlB/cwKA1DifxWZ+TsF7yt9UBfhMeVmjxaijTHP3ONHn4gkk7PuFcP488r9o2EBZCxfAh4R2vqKmLut+7KCpWxoEPcqo+LUo2QsSy4Yc8bVBfVXeQ55bbBVN4kKGJFN8xUTpsL6bi3ApiASVA7fCeUS7ZuY+itiQ3Vs5HS8XoCYYPSdzOq77io4eYmXV0zZ4kkastsTE+YzespveZoQJELTCKDbbwKYMSYUfjYvqLZjEIhFgi6GqCewUZg73djQJ7CB4gz4zTVF4kWtiKcPVi8rabH2rXCv0iw9G3Qx82ELYK5GS4L8Mghv7DKBTivOSVyel4EPzITg40Ff8DTUCmk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <778700E6E90AAB4EBE900AC73676F47A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 965c73a0-e8a2-4009-8ba2-08d7518273bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 15:15:03.0523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XJUuZiA5DhQDFqxOjge/jQvE5Cv2y3UvAFn1796WTjtC7hvwhZ3jCi7fhCGTHEAV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2231
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_05:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTQvMTkgNDo0OSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBCVEYgb2Zmc2V0
IHJlbG9jIHdhcyBnZW5lcmFsaXplZCBpbiByZWNlbnQgQ2xhbmcgaW50byBmaWVsZCByZWxvY2F0
aW9uLA0KPiBjYXB0dXJpbmcgZXh0cmEgdTMyIGZpZWxkLCBzcGVjaWZ5aW5nIHdoYXQgYXNwZWN0
IG9mIGNhcHR1cmVkIGZpZWxkDQo+IG5lZWRzIHRvIGJlIHJlbG9jYXRlZC4gVGhpcyBjaGFuZ2Vz
IC5CVEYuZXh0J3MgcmVjb3JkIHNpemUgZm9yIHRoaXMNCj4gcmVsb2NhdGlvbiBmcm9tIDEyIGJ5
dGVzIHRvIDE2IGJ5dGVzLiBHaXZlbiB0aGVzZSBmb3JtYXQgY2hhbmdlcw0KPiBoYXBwZW5lZCBp
biBDbGFuZyBiZWZvcmUgb2ZmaWNpYWwgcmVsZWFzZWQgdmVyc2lvbiwgaXQncyBvayB0byBub3QN
Cj4gc3VwcG9ydCBvdXRkYXRlZCAxMi1ieXRlIHJlY29yZCBzaXplIHcvbyBicmVha2luZyBBQkku
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0K
Li4uPiAtLyogVGhlIG1pbmltdW0gYnBmX29mZnNldF9yZWxvYyBjaGVja2VkIGJ5IHRoZSBsb2Fk
ZXINCj4gKy8qIGJwZl9maWVsZF9yZWxvY19raW5kIGVuY29kZXMgd2hpY2ggYXNwZWN0IG9mIGNh
cHR1cmVkIGZpZWxkIGhhcyB0byBiZQ0KPiArICogYWRqdXN0ZWQgYnkgcmVsb2NhdGlvbnMuIEN1
cnJlbnRseSBzdXBwb3J0ZWQgdmFsdWVzIGFyZToNCj4gKyAqICAgLSBCUEZfRklfQllURV9PRkZT
RVQ6IGZpZWxkIG9mZnNldCAoaW4gYnl0ZXMpOw0KPiArICogICAtIEJQRl9GSV9FWElTVFM6IGZp
ZWxkIGV4aXN0ZW5jZSAoMSBpZiBmaWVsZCBleGlzdHMsIDAgLSBvdGhlcndpc2UpOw0KPiArICov
DQo+ICtlbnVtIGJwZl9maWVsZF9yZWxvY19raW5kIHsNCj4gKwlCUEZfRlJLX0JZVEVfT0ZGU0VU
ID0gMCwNCj4gKwlCUEZfRlJLX0VYSVNUUyA9IDIsDQo+ICt9Ow0KDQpDb21tZW50IGFib3ZlIGRv
ZXNuJ3QgbWF0Y2ggdGhlIGVudW0uDQpBbHNvIGluIHBhdGNoIDQgOg0KK2VudW0gYnBmX2ZpZWxk
X2luZm9fa2luZCB7DQorCUJQRl9GSV9CWVRFX09GRlNFVCA9IDAsCSAgLyogZmllbGQgYnl0ZSBv
ZmZzZXQgKi8NCisJQlBGX0ZJX0VYSVNUUyA9IDIsCSAgLyogd2hldGhlciBmaWVsZCBleGlzdHMg
aW4gdGFyZ2V0IGtlcm5lbCAqLw0KK307DQoNCkRvIHlvdSBleHBlY3QgdGhhdCAuYnRmLmV4dCBl
bmNvZGluZyB0byBiZSBkaWZmZXJlbnQgZnJvbQ0KYXJndW1lbnQgcGFzc2VkIGludG8gX19idWls
dGluX2ZpZWxkX2luZm8oKSA/DQpNYXkgYmUgYmV0dGVyIHRvIGRlc2lnbiB0aGUgaW50ZXJmYWNl
IHRoYXQgaXQgYWx3YXlzIG1hdGNoZXMNCmFuZCBrZWVwIHNpbmdsZSBlbnVtIGZvciBib3RoPw0K
SSBkb24ndCBsaWtlIGVpdGhlciBGUksgb3IgRkkgYWJicmV2aWF0aW9ucy4NCk1heSBiZQ0KQlBG
X0ZJRUxEX0JZVEVfT0ZGU0VUDQpCUEZfRklFTERfRVhJU1RTID8NCg0KVGhlc2UgY29uc3RhbnRz
IHdvdWxkIG5lZWQgdG8gYmUgZXhwb3NlZCBpbiBicGZfY29yZV9yZWFkLmggYW5kDQp3aWxsIGJl
Y29tZSB1YXBpIGFzIHNvb24gYXMgd2UgcmVsZWFzZSBuZXh0IGxpYmJwZiBhdA0KdGhlIGVuZCBv
ZiB0aGlzIGJwZi1uZXh0IGN5Y2xlLiBBdCB0aGF0IHBvaW50IGxsdm0gc2lkZSB3b3VsZCBoYXZl
DQp0byBzdGljayB0byB0aGVzZSBjb25zdGFudHMgYXMgd2VsbC4NCkl0IHdvdWxkIGhhdmUgdG8g
dW5kZXJzdGFuZCB0aGVtIGFzIGFyZ3VtZW50cyBhbmQgdXNlIHRoZSBzYW1lIGluIC5idGYuZXh0
Lg0KRG9lcyBpdCBtYWtlIHNlbnNlPw0KDQo=
