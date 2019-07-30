Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A807A03E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 07:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfG3FIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 01:08:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729102AbfG3FIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 01:08:02 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6U57Okp031491;
        Mon, 29 Jul 2019 22:07:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x/cEDkRuaoMv4xK8Opv2bIJRyD2BG7xBRtlrptggz38=;
 b=QV227ssQbTLlBGqUgfU+BRQYgoTh4WhgvW50OOy422+8+psToTpo27zVjaUNpC6BUBGW
 +zCWRxG5Brv2P77GEEbO5wrlNdjXvhRU8POv06wyD2fp5ybGqJ6r3vP4vDH4smoY94I5
 XYfGFLVmIFGW6oG5PZ8jCgS6Q947RP7D5sg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u260g9w3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 22:07:35 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 29 Jul 2019 22:07:27 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jul 2019 22:07:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=empC5Fwg2CHh8sICv0un8svKP6BmYcJHS8CyKX1sVrlsVYP7irco9l2mvcJ6VOjUNEIruaBb+/iBdUzFXHX/1qeNOhK2IZ8sLEKrrfEqdFbaU53MTeArV6zOTdC8a0CyKwG++59ABJuzBELd9ZnShwxsfeNeAvFzBb5BmV6+N0KDi6bdqqvR7mtbare4AS8WZc6+1rSxvkp3nOqLTzwl3n2UB852eObNsAgh4RL7PK1L3ZiSQ+yB3EUP7KlAtZjizd0xzJGN4INY4gioN8ZlxF2YcU2O8LqiQ1ip3qk8H4VWZZ85zqy4mMW5EbLYEhyUw98VIPkmh13xaI/H/DpT5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/cEDkRuaoMv4xK8Opv2bIJRyD2BG7xBRtlrptggz38=;
 b=KlR8uoJFVTVB0oqK73NgeBoQZ64e9jXbkkZMeEtZeZibpc0s5Uk8O6t3n0fWaTe+gXNgfMouPgUEcpVJc16h1JcOFnXDlFBnu3uoEbfKu2OI3+/uY4RXELuAfkM3c+2Pfw4Gw+QNz/i20p6djb30bxSdYmGFGRXvUnwz+PBuBVMuY1Uvi3YgrtKwb8td4dALwDId6CXAuFsYXbY4VYAsnOGJ2/p416zbREfbfcVpoiV6BWA8TESFu6JhD8RLW2aCyC57NCD5WtXvNpW3HmGNCwLKnOa5bF6T7eTm+aWuBqPizqIga8Mu6rc66dMtRmW4WHUugePKvUiOaiTbOj5r4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/cEDkRuaoMv4xK8Opv2bIJRyD2BG7xBRtlrptggz38=;
 b=E+uFUXBrfIr6NJSXGth87v91HBG6BKX+T2p5m4s+dDmLw3Pin1jWcg77FWTAEqUTpS1wuxZzoKSGDzv6Q8qBv/9l4xKjBH9afHfvIJu8L8G4GOdcxREyzowh2kuvyHDCiQDDDDsjBrWArXKL4EdFsc94M1PC6AYUgd9A+XkYbY8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1229.namprd15.prod.outlook.com (10.175.7.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 05:07:26 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 05:07:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwAgAPZeAA=
Date:   Tue, 30 Jul 2019 05:07:25 +0000
Message-ID: <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
 <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
In-Reply-To: <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:3c23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c80a3d1f-7a3c-4f68-0824-08d714abd00d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1229;
x-ms-traffictypediagnostic: MWHPR15MB1229:
x-microsoft-antispam-prvs: <MWHPR15MB1229E6696CC2D38FA8F7AB31B3DC0@MWHPR15MB1229.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(8936002)(6512007)(57306001)(53936002)(6116002)(6506007)(305945005)(7736002)(8676002)(81166006)(476003)(102836004)(14454004)(53546011)(76116006)(186003)(11346002)(561944003)(2616005)(6486002)(33656002)(6916009)(81156014)(486006)(25786009)(7416002)(5660300002)(36756003)(5024004)(4326008)(2906002)(68736007)(86362001)(54906003)(478600001)(66476007)(66556008)(64756008)(66446008)(66946007)(446003)(99286004)(229853002)(6436002)(76176011)(71190400001)(46003)(71200400001)(50226002)(316002)(256004)(14444005)(6246003)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1229;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: imlD206nR0S/nhd+3GMI+2xGQI1Ratlr+xlZ3fKJSwRIkhjrCp/Hre6UUdnt9VErHn+0ZOC2h96sYwiDhy1eoB1dMU5pEmK77OE+I5lj1Aru1y9RVDEdSia6AR6O8ptDaMY2opadmWZ2s9G/BhLyWWA0sa3m21ryCUuQSZ679NaBwxioGzshQSSfieLe5jkEh9CnQa5kU3Wkma1Ur1Gmdef1I4OWVtFnljzVbPNXWwmhPTss3Nni3f4VP5pqUFpnpqhh3BxEs24Ee8hRD6QvP3IbsVRz+ofZJvMeUhI6GUEd39/tpaQGgfACA5QBneLSoK12ADw+q2BtZ0VHlAPHBE7QiQJWtctBXiVH9KlqH/ZG1bFuHdIi7V/3zKDTmIZD4ElGDlf39rwI8GEHZXqS/oizj2kvjfKE6tiPHUvDZH0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D618CF5378938B4EB6BB91CC24C6E28C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c80a3d1f-7a3c-4f68-0824-08d714abd00d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 05:07:25.6650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1229
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5keSwgDQoNCj4gT24gSnVsIDI3LCAyMDE5LCBhdCAxMToyMCBBTSwgU29uZyBMaXUgPHNv
bmdsaXVicmF2aW5nQGZiLmNvbT4gd3JvdGU6DQo+IA0KPiBIaSBBbmR5LCANCj4gDQo+Pj4+PiAN
Cj4+Pj4gDQo+Pj4+IFdlbGwsIHllcy4gc3lzX2JwZigpIGlzIHByZXR0eSBwb3dlcmZ1bC4gDQo+
Pj4+IA0KPj4+PiBUaGUgZ29hbCBvZiAvZGV2L2JwZiBpcyB0byBlbmFibGUgc3BlY2lhbCB1c2Vy
cyB0byBjYWxsIHN5c19icGYoKS4gSW4gDQo+Pj4+IHRoZSBtZWFud2hpbGUsIHN1Y2ggdXNlcnMg
c2hvdWxkIG5vdCB0YWtlIGRvd24gdGhlIHdob2xlIHN5c3RlbSBlYXNpbHkNCj4+Pj4gYnkgYWNj
aWRlbnQsIGUuZy4sIHdpdGggcm0gLXJmIC8uDQo+Pj4gDQo+Pj4gVGhhdOKAmXMgZWFzeSwgdGhv
dWdoIOKAlCBicGZ0b29sIGNvdWxkIGxlYXJuIHRvIHJlYWQgL2V0Yy9icGZ1c2VycyBiZWZvcmUg
YWxsb3dpbmcgcnVpZCAhPSAwLg0KPj4gDQo+PiBUaGlzIGlzIGEgZ3JlYXQgaWRlYSEgZnNjYXBz
ICsgL2V0Yy9icGZ1c2VycyBzaG91bGQgZG8gdGhlIHRyaWNrLiANCj4gDQo+IEFmdGVyIHNvbWUg
ZGlzY3Vzc2lvbnMgYW5kIG1vcmUgdGhpbmtpbmcgb24gdGhpcywgSSBoYXZlIHNvbWUgY29uY2Vy
bnMgDQo+IHdpdGggdGhlIHVzZXIgc3BhY2Ugb25seSBhcHByb2FjaC4gIA0KPiANCj4gSUlVQywg
eW91ciBwcm9wb3NhbCBmb3IgdXNlciBzcGFjZSBvbmx5IGFwcHJvYWNoIGlzIGxpa2U6IA0KPiAN
Cj4gMS4gYnBmdG9vbCAoYW5kIG90aGVyIHRvb2xzKSBjaGVjayAvZXRjL2JwZnVzZXJzIGFuZCBv
bmx5IGRvIA0KPiAgIHNldHVpZCBmb3IgYWxsb3dlZCB1c2VyczoNCj4gDQo+IAlpbnQgbWFpbigp
DQo+IAl7DQo+IAkJaWYgKC8qIHVpZCBpbiAvZXRjL2JwZnVzZXJzICovKQ0KPiAJCQlzZXR1aWQo
MCk7DQo+IAkJc3lzX2JwZiguLi4pOw0KPiAJfQ0KPiANCj4gMi4gYnBmdG9vbCAoYW5kIG90aGVy
IHRvb2xzKSBpcyBpbnN0YWxsZWQgd2l0aCBDQVBfU0VUVUlEOg0KPiANCj4gCXNldGNhcCBjYXBf
c2V0dWlkPWUrcCAvYmluL2JwZnRvb2wNCj4gDQo+IDMuIHN5cyBhZG1pbiBtYWludGFpbnMgcHJv
cGVyIC9ldGMvYnBmdXNlcnMuIA0KPiANCj4gVGhpcyBhcHByb2FjaCBpcyBub3QgaWRlYWwsIGJl
Y2F1c2Ugd2UgbmVlZCB0byB0cnVzdCB0aGUgdG9vbCB0byBnaXZlIA0KPiBpdCBDQVBfU0VUVUlE
LiBBIGhhY2tlZCB0b29sIGNvdWxkIGVhc2lseSBieXBhc3MgL2V0Yy9icGZ1c2VycyBjaGVjaw0K
PiBvciB1c2Ugb3RoZXIgcm9vdCBvbmx5IHN5cyBjYWxscyBhZnRlciBzZXR1aWQoMCkuIA0KPiAN
Cg0KSSB3b3VsZCBsaWtlIG1vcmUgY29tbWVudHMgb24gdGhpcy4gDQoNCkN1cnJlbnRseSwgYnBm
IHBlcm1pc3Npb24gaXMgbW9yZSBvciBsZXNzICJyb290IG9yIG5vdGhpbmciLCB3aGljaCB3ZSAN
CndvdWxkIGxpa2UgdG8gY2hhbmdlLiANCg0KVGhlIHNob3J0IHRlcm0gZ29hbCBpcyB0byBzZXBh
cmF0ZSBicGYgZnJvbSByb290LCBpbiBvdGhlciB3b3JkcywgaXQgaXMgDQoiYWxsIG9yIG5vdGhp
bmciLiBTcGVjaWFsIHVzZXIgc3BhY2UgdXRpbGl0aWVzLCBzdWNoIGFzIHN5c3RlbWQsIHdvdWxk
DQpiZW5lZml0IGZyb20gdGhpcy4gT25jZSB0aGlzIGlzIGltcGxlbWVudGVkLCBzeXN0ZW1kIGNh
biBjYWxsIHN5c19icGYoKSANCndoZW4gaXQgaXMgbm90IHJ1bm5pbmcgYXMgcm9vdC4gDQoNCklu
IGxvbmdlciB0ZXJtLCBpdCBtYXkgYmUgdXNlZnVsIHRvIHByb3ZpZGUgZmluZXIgZ3JhaW4gcGVy
bWlzc2lvbiBvZiANCnN5c19icGYoKS4gRm9yIGV4YW1wbGUsIHN5c19icGYoKSBzaG91bGQgYmUg
YXdhcmUgb2YgY29udGFpbmVyczsgYW5kDQp1c2VyIG1heSBvbmx5IGhhdmUgYWNjZXNzIHRvIGNl
cnRhaW4gYnBmIG1hcHMuIExldCdzIGNhbGwgdGhpcyANCiJmaW5lIGdyYWluIiBjYXBhYmlsaXR5
LiANCg0KDQpTaW5jZSB3ZSBhcmUgc2VlaW5nIG5ldyB1c2UgY2FzZXMgZXZlcnkgeWVhciwgd2Ug
d2lsbCBuZWVkIG1hbnkgDQppdGVyYXRpb25zIHRvIGltcGxlbWVudCB0aGUgZmluZSBncmFpbiBw
ZXJtaXNzaW9uLiBJIHRoaW5rIHdlIG5lZWQgYW4gDQpBUEkgdGhhdCBpcyBmbGV4aWJsZSBlbm91
Z2ggdG8gY292ZXIgZGlmZmVyZW50IHR5cGVzIG9mIHBlcm1pc3Npb24gDQpjb250cm9sLiANCg0K
Rm9yIGV4YW1wbGUsIGJwZl93aXRoX2NhcCgpIGNhbiBiZSBmbGV4aWJsZToNCg0KCWJwZl93aXRo
X2NhcChjbWQsIGF0dHIsIHNpemUsIHBlcm1fZmQpOw0KDQpXZSBjYW4gZ2V0IGRpZmZlcmVudCB0
eXBlcyBvZiBwZXJtaXNzaW9uIHZpYSBkaWZmZXJlbnQgY29tYmluYXRpb25zIG9mIA0KYXJndW1l
bnRzOg0KDQogICAgQSBwZXJtX2ZkIHRvIC9kZXYvYnBmIGdpdmVzIGFjY2VzcyB0byBhbGwgc3lz
X2JwZigpIGNvbW1hbmRzLCBzbyANCiAgICB0aGlzIGlzICJhbGwgb3Igbm90aGluZyIgcGVybWlz
c2lvbi4gDQoNCiAgICBBIHBlcm1fZmQgdG8gL3N5cy9mcy9jZ3JvdXAvLi4uL2JwZi54eHggd291
bGQgb25seSBhbGxvdyBzb21lIA0KICAgIGNvbW1hbmRzIHRvIHRoaXMgc3BlY2lmaWMgY2dyb3Vw
LiANCg0KDQpBbGV4ZWkgcmFpc2VkIGFub3RoZXIgaWRlYSBpbiBvZmZsaW5lIGRpc2N1c3Npb25z
OiBpbnN0ZWFkIG9mIGFkZGluZw0KYnBmX3dpdGhfY2FwKCksIHdlIGFkZCBhIGNvbW1hbmQgTE9B
RF9QRVJNX0ZELCB3aGljaCBlbmFibGVzIHNwZWNpYWwNCnBlcm1pc3Npb24gZm9yIHRoZSBfbmV4
dF8gc3lzX2JwZigpIGZyb20gY3VycmVudCB0YXNrOg0KDQogICAgYnBmKExPQURfUEVSTV9GRCwg
cGVybV9mZCk7DQogICAgLyogdGhlIG5leHQgc3lzX2JwZigpIHVzZXMgcGVybWlzc2lvbiBmcm9t
IHBlcm1fZmQgKi8NCiAgICBicGYoY21kLCBhdHRyLCBzaXplKTsNCg0KVGhpcyBpcyBlcXVpdmFs
ZW50IHRvIGJwZl93aXRoX2NhcChjbWQsIGF0dHIsIHNpemUsIHBlcm1fZmQpLCBidXQgDQpkb2Vz
bid0IHJlcXVpcmUgdGhlIG5ldyBzeXMgY2FsbC4gDQoNCg0KRm9yIGJvdGggdGhlc2UgaWRlYXMs
IHdlIHdpbGwgc3RhcnQgd2l0aCAvZGV2L2JwZi4gQXMgd2UgZ3JvdyB0aGUNCmZpbmUgZ3JhaW4g
cGVybWlzc2lvbiBjb250cm9sLCBmZXdlciB1c2Vycy9wcm9jZXNzZXMgd2lsbCBuZWVkIGFjY2Vz
cyANCnRvIC9kZXYvYnBmLiANCg0KDQpQbGVhc2UgbGV0IHVzIGtub3cgeW91ciB0aG91Z2h0IG9u
IHRoaXMuIFdvdWxkIHRoaXMgbWFrZSAvZGV2L2JwZiANCm1vcmUgcmVhc29uYWJsZT8gOi0pDQoN
CkEgZmV3IG5vdGVzIGZvciBwcmV2aW91cyBkaXNjdXNzaW9uczoNCg0KMS4gVXNlciBzcGFjZSBv
bmx5IGFwcHJvYWNoIGRvZXNuJ3Qgd29yaywgZXZlbiBmb3IgImFsbCBvciBub3RoaW5nIiANCiAg
IHBlcm1pc3Npb24gY29udHJvbC4gSSBleHBhbmRlZCB0aGUgZGlzY3Vzc2lvbiBpbiB0aGUgcHJl
dmlvdXMNCiAgIGVtYWlsLiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgSSBtaXNzZWQgYW55dGhpbmcg
dGhlcmUuIA0KDQoyLiBQZXJtaXNzaW9uIGNvbnRyb2wgb25seSBhdCBCUEZfUFJPR19BVFRBQ0gg
dGltZSBpcyBub3Qgc3VmZmljaWVudC4NCiAgIFdlIG5lZWQgcGVybWlzc2lvbiBjb250cm9sIGR1
cmluZyBCUEZfUFJPR19MT0FELCBlLmcuLCBpc19wcml2IGluIA0KICAgdGhlIHZlcmlmaWVyLiAN
Cg0KVGhhbmtzLA0KU29uZw==
