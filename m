Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE0512101D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLPQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:51:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60890 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfLPQvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:51:52 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGGpV11021446;
        Mon, 16 Dec 2019 08:51:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yXBIpBqYYKUEQv1C/BoVJqOcOFg9bS2fMVFzl858FiY=;
 b=GDyegePH/k/0nA/ER2iE057ruKxuCdxPKi8BP7hvAvJxZjnl2lxNqF3Eu9ttNsAM5AcY
 pRXKExgSlk0p07T8U9TZnnggP5CdWOfXnvkZ11M8VPNzigtEkZw8uykcQxsHOtmceRZh
 3Jivh4mLXQ9mWgWMcRAMuGxqZ1YSV3pTK2Y= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvxeqfd1n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 08:51:35 -0800
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 08:51:33 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 08:51:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 08:51:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CddNW5tTdZOpdfW3WoBTI/H8UI6AlMtxSKcIAXZ+L/aE5U6mfwP58rfDFzliVs/wDNPaOtKjej6DrTe4PWlF0iEWvcOaLSszQoKiziTOFHJm4XOTgelHNIbWrvEe4kdRi9vg3h5z0OEVWHieLsvNWCtzRoNwWzzYwcdFJ5dB69OhJWXzQiNRip9NeZtrqklKSq2M3UV+hQwc5zy6+YU+NsDB+q9LOTMLdHySVefvEnugdd5iJ8a3BZP4NuzwrjkK1epGPp7E8f1KkKR4qL3bmGi4xHqY6z0nR/EH0VS28lCWnszeJeHerbxvloeM/w3k1ujKxYfy8zSBkxJEoMSMOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXBIpBqYYKUEQv1C/BoVJqOcOFg9bS2fMVFzl858FiY=;
 b=gKadltr3QKc88y/jXQPOrU5zP7lHEUaUQmS+5u6vob61F+qro+mYQx7uwJCkHz0dFhsHS4BBR28rH0V5ivqbkLXONpvr8XrV7VGQlJsv9zUX2TUXpcS4qB/zsI3Ex7Q3AmsbUP9iBx2sYo+i7UaV59MnJm/q3QPVkHG6CfzgvJxXvoocsDElZtbQ5UQ5D33eRm/HUO8mTxxt475h1h64Wu8IZe7UKEQUwSa1uwb2v0FKzWHkUwESIB0Mko0YnLkhszlWvhvQARdp2G2hu7YQsl78j5WxS/oAKwk2D3c3NRi1vFvhAj3izvK7/TDqeGLfzqPF7Bg02Z85kNy8FmtCDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXBIpBqYYKUEQv1C/BoVJqOcOFg9bS2fMVFzl858FiY=;
 b=a1JEsjqRfELgvzQreRNp7c+M4a7fZTpJ3iJUx7iLdTZZBGb4ePDH+r4O2lFYaS1h3f3TRd+CIGtB7oBcYrBCWyEd9IiGKqIXMKc8iqpmMgHmgit82b6UyR91LdoCBFBKWyw828cF98+QPgwpRRlkXEegLAxB0EXGbqpyJdKihr4=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1356.namprd15.prod.outlook.com (10.173.221.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 16:51:31 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 16:51:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: Print hint about ulimit when getting
 permission denied error
Thread-Topic: [PATCH bpf-next] libbpf: Print hint about ulimit when getting
 permission denied error
Thread-Index: AQHVtA4T1AoGTXIWBkOGsCj01VK4Hae8+gIA
Date:   Mon, 16 Dec 2019 16:51:31 +0000
Message-ID: <2146814b-f70e-b401-3ed3-4d113ab47e34@fb.com>
References: <20191216124031.371482-1-toke@redhat.com>
In-Reply-To: <20191216124031.371482-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0026.namprd15.prod.outlook.com
 (2603:10b6:300:ad::12) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13d6f982-562a-4529-6e80-08d7824833c1
x-ms-traffictypediagnostic: DM5PR15MB1356:
x-microsoft-antispam-prvs: <DM5PR15MB13562FCA4C61D8047A972A91D3510@DM5PR15MB1356.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(8936002)(71200400001)(81166006)(81156014)(8676002)(2616005)(6512007)(66446008)(64756008)(66556008)(36756003)(66574012)(66476007)(5660300002)(110136005)(54906003)(316002)(86362001)(53546011)(966005)(52116002)(2906002)(186003)(66946007)(6506007)(6486002)(4326008)(31686004)(31696002)(478600001)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1356;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7x5Hap7PEgtQRn8vBeNLJ/vM1Dn4MiB6hJtCWFzBSG5176HlvpMIn0IVrIFN3bdNMJh1mT8IyTrLP5Nvh144oQSIV3gaa3iZ+PoM7EDLbSisZBSm7OXthabVWvcF2eD9rqDC126ysIlUkeevYnhI5Sm4QYHapPVS0MkPzZt+1sx3ZB5+88g5JvJJ3KoEMXHLVKLkUGuaI69IOh+ITTh2RZHWwEOQTwEsYfwLYQ0enmmk+gefCMCobP52rRxsvA9TFwrSSZIOEQ0L69YEbwYcY2ugF1kAMRxWBkZB6usRAGU9QCN6eFffuanGyj3OwiL3khvYiWHgUe0vzOc2UJtJ2270S/aUFLK1YeySYJeaG3yYy0rzUIYijwgHzXyQqIkwiY0o/DRW0dEyyDDHwddqYyNDOQCrgGPV6BPhzREebw4l6ny/nI3m21I7JMdl4WwenHoXMb+BKAcs2v2cPVe21d7b8AlkeLRXnjA/6AYvB73xQzlzX7xVCPVNxQEIUPlsPmmkcrNuW5AueGzkp1picUCBut7161ZJnWPqHA4D00=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A2E093ED4BCA04DB99414956B82A28C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d6f982-562a-4529-6e80-08d7824833c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 16:51:31.7453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ysyEPXoxjE0S9Q/pQe0N7x2Iyu+SNpd76Lj5VSgXE3ASlB6gXWLZ3x8I+f5BGmIv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1356
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_06:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDQ6NDAgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gUHJvYmFibHkgdGhlIHNpbmdsZSBtb3N0IGNvbW1vbiBlcnJvciBuZXdjb21lcnMgdG8gWERQ
IGFyZSBzdHVtcGVkIGJ5IGlzDQo+IHRoZSAncGVybWlzc2lvbiBkZW5pZWQnIGVycm9yIHRoZXkg
Z2V0IHdoZW4gdHJ5aW5nIHRvIGxvYWQgdGhlaXIgcHJvZ3JhbQ0KPiBhbmQgJ3VsaW1pdCAtcicg
aXMgc2V0IHRvbyBsb3cuIEZvciBleGFtcGxlcywgc2VlIFswXSwgWzFdLg0KPiANCj4gU2luY2Ug
dGhlIGVycm9yIGNvZGUgaXMgVUFQSSwgd2UgY2FuJ3QgY2hhbmdlIHRoYXQuIEluc3RlYWQsIHRo
aXMgcGF0Y2gNCj4gYWRkcyBhIGZldyBoZXVyaXN0aWNzIGluIGxpYmJwZiBhbmQgb3V0cHV0cyBh
biBhZGRpdGlvbmFsIGhpbnQgaWYgdGhleSBhcmUNCj4gbWV0OiBJZiBhbiBFUEVSTSBpcyByZXR1
cm5lZCBvbiBtYXAgY3JlYXRlIG9yIHByb2dyYW0gbG9hZCwgYW5kIGdldGV1aWQoKQ0KPiBzaG93
cyB3ZSBhcmUgcm9vdCwgYW5kIHRoZSBjdXJyZW50IFJMSU1JVF9NRU1MT0NLIGlzIG5vdCBpbmZp
bml0eSwgd2UNCj4gb3V0cHV0IGEgaGludCBhYm91dCByYWlzaW5nICd1bGltaXQgLXInIGFzIGFu
IGFkZGl0aW9uYWwgbG9nIGxpbmUuDQo+IA0KPiBbMF0gaHR0cHM6Ly9tYXJjLmluZm8vP2w9eGRw
LW5ld2JpZXMmbT0xNTcwNDM2MTI1MDU2MjQmdz0yDQo+IFsxXSBodHRwczovL2dpdGh1Yi5jb20v
eGRwLXByb2plY3QveGRwLXR1dG9yaWFsL2lzc3Vlcy84Ng0KPiANCj4gU2lnbmVkLW9mZi1ieTog
VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+DQoNCkxHVE0gd2l0aCBv
bmUgbWlub3Igbm8tZXNzZW50aWFsIHN1Z2dlc3Rpb24gYmVsb3cuDQoNCkFja2VkLWJ5OiBZb25n
aG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IC0tLQ0KPiAgIHRvb2xzL2xpYi9icGYvbGliYnBm
LmMgfCAyMSArKysrKysrKysrKysrKysrKysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwgMjEgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMgYi90
b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IGluZGV4IGEyY2M3MzEzNzYzYS4uYWVjNzk5NTY3NGQy
IDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+ICsrKyBiL3Rvb2xzL2xp
Yi9icGYvbGliYnBmLmMNCj4gQEAgLTQxLDYgKzQxLDcgQEANCj4gICAjaW5jbHVkZSA8c3lzL3R5
cGVzLmg+DQo+ICAgI2luY2x1ZGUgPHN5cy92ZnMuaD4NCj4gICAjaW5jbHVkZSA8c3lzL3V0c25h
bWUuaD4NCj4gKyNpbmNsdWRlIDxzeXMvcmVzb3VyY2UuaD4NCj4gICAjaW5jbHVkZSA8dG9vbHMv
bGliY19jb21wYXQuaD4NCj4gICAjaW5jbHVkZSA8bGliZWxmLmg+DQo+ICAgI2luY2x1ZGUgPGdl
bGYuaD4NCj4gQEAgLTEwMCw2ICsxMDEsMjQgQEAgdm9pZCBsaWJicGZfcHJpbnQoZW51bSBsaWJi
cGZfcHJpbnRfbGV2ZWwgbGV2ZWwsIGNvbnN0IGNoYXIgKmZvcm1hdCwgLi4uKQ0KPiAgIAl2YV9l
bmQoYXJncyk7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIHZvaWQgcHJfcGVybV9tc2coaW50IGVy
cikNCj4gK3sNCj4gKwlzdHJ1Y3QgcmxpbWl0IGxpbWl0Ow0KPiArDQo+ICsJaWYgKGVyciAhPSAt
RVBFUk0gfHwgZ2V0ZXVpZCgpICE9IDApDQo+ICsJCXJldHVybjsNCj4gKw0KPiArCWVyciA9IGdl
dHJsaW1pdChSTElNSVRfTUVNTE9DSywgJmxpbWl0KTsNCj4gKwlpZiAoZXJyKQ0KPiArCQlyZXR1
cm47DQo+ICsNCj4gKwlpZiAobGltaXQucmxpbV9jdXIgPT0gUkxJTV9JTkZJTklUWSkNCj4gKwkJ
cmV0dXJuOw0KPiArDQo+ICsJcHJfd2FybigicGVybWlzc2lvbiBlcnJvciB3aGlsZSBydW5uaW5n
IGFzIHJvb3Q7IHRyeSByYWlzaW5nICd1bGltaXQgLXInPyBjdXJyZW50IHZhbHVlOiAlbHVcbiIs
DQo+ICsJCWxpbWl0LnJsaW1fY3VyKTsNCg0KSGVyZSB3ZSBwcmludCBvdXQgaW4gdGVybXMgb2Yg
Ynl0ZXMuIE1heWJlIGluIHRlcm1zIG9mIGtpbG8gYnl0ZXMgb3IgDQptZWdhIGJ5dGVzIGlzIG1v
cmUgdXNlciBmcmllbmRseSwgZXNwLiB3ZSB3YW50IHRoZW0gdG8gc2V0IGEgZGlmZmVyZW50IA0K
dmFsdWU/DQoNCj4gK30NCj4gKw0KPiAgICNkZWZpbmUgU1RSRVJSX0JVRlNJWkUgIDEyOA0KPiAg
IA0KPiAgIC8qIENvcGllZCBmcm9tIHRvb2xzL3BlcmYvdXRpbC91dGlsLmggKi8NCj4gQEAgLTI5
ODMsNiArMzAwMiw3IEBAIGJwZl9vYmplY3RfX2NyZWF0ZV9tYXBzKHN0cnVjdCBicGZfb2JqZWN0
ICpvYmopDQo+ICAgCQkJY3AgPSBsaWJicGZfc3RyZXJyb3JfcihlcnIsIGVycm1zZywgc2l6ZW9m
KGVycm1zZykpOw0KPiAgIAkJCXByX3dhcm4oImZhaWxlZCB0byBjcmVhdGUgbWFwIChuYW1lOiAn
JXMnKTogJXMoJWQpXG4iLA0KPiAgIAkJCQltYXAtPm5hbWUsIGNwLCBlcnIpOw0KPiArCQkJcHJf
cGVybV9tc2coZXJyKTsNCj4gICAJCQlmb3IgKGogPSAwOyBqIDwgaTsgaisrKQ0KPiAgIAkJCQl6
Y2xvc2Uob2JqLT5tYXBzW2pdLmZkKTsNCj4gICAJCQlyZXR1cm4gZXJyOw0KPiBAQCAtNDM4MSw2
ICs0NDAxLDcgQEAgbG9hZF9wcm9ncmFtKHN0cnVjdCBicGZfcHJvZ3JhbSAqcHJvZywgc3RydWN0
IGJwZl9pbnNuICppbnNucywgaW50IGluc25zX2NudCwNCj4gICAJcmV0ID0gLWVycm5vOw0KPiAg
IAljcCA9IGxpYmJwZl9zdHJlcnJvcl9yKGVycm5vLCBlcnJtc2csIHNpemVvZihlcnJtc2cpKTsN
Cj4gICAJcHJfd2FybigibG9hZCBicGYgcHJvZ3JhbSBmYWlsZWQ6ICVzXG4iLCBjcCk7DQo+ICsJ
cHJfcGVybV9tc2cocmV0KTsNCj4gICANCj4gICAJaWYgKGxvZ19idWYgJiYgbG9nX2J1ZlswXSAh
PSAnXDAnKSB7DQo+ICAgCQlyZXQgPSAtTElCQlBGX0VSUk5PX19WRVJJRlk7DQo+IA0K
