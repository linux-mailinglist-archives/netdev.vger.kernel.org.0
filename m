Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBC38227
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 02:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFGA2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 20:28:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbfFGA2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 20:28:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x570P6xA014096;
        Thu, 6 Jun 2019 17:27:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UQ+AFJuyvIxypc10Gj+koHXcXM/O5HqhVueLDA8OH9g=;
 b=oPPYfd/U/GXJbTbD2ttnRCzmV/y1BtDvVNpT5QyQ+MIjGtgVBx8NXSo4fjwUAAAFSty/
 XBWgG4RrNhym6kMIiDFiFOj3emgACfW8Nm0RQTg8AiQvec3rtmzEWT+uQkEpZVcgxqJc
 Ai53tLvxTb1qo2vDXrictEGzw+WkiZuiKBo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy6mj1kdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 17:27:55 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 6 Jun 2019 17:27:54 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 17:27:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQ+AFJuyvIxypc10Gj+koHXcXM/O5HqhVueLDA8OH9g=;
 b=HLyVhf9YqrJ0WtPygT3MKGeaNhs9wKgoP7Cs7YPpDiMwhllgajcReWrFe1NajVHB1EfDFiOYOUvMx9IfOqlpI6CTZnO1dJFw3B71K/46bfhAM6SGeXL596A4RbgafwUtyIXa/k6vD0Z4NB9mmMgpJg8DmBxAB6X/FDZLuivqlh8=
Received: from SN6PR15MB2512.namprd15.prod.outlook.com (52.135.66.25) by
 SN6PR15MB2367.namprd15.prod.outlook.com (52.135.65.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Fri, 7 Jun 2019 00:27:52 +0000
Received: from SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494]) by SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 00:27:52 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
Thread-Topic: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Thread-Index: AQHVF+6FIN4ypCqNSkaaeWcXaUexbKaFv76AgAAZLICABEsPAIAAXHQAgAAyMACAAAE1gIAAOGMAgACbgwCAAD8rgIADYXQAgAAfwACAAAbfAIAAC+aAgAAE8QA=
Date:   Fri, 7 Jun 2019 00:27:52 +0000
Message-ID: <4553f579-c7bb-2d4c-a1ef-3e4fbed64427@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com> <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch>
 <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
 <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
 <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
 <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com>
 <20190606171007.1e1eb808@cakuba.netronome.com>
In-Reply-To: <20190606171007.1e1eb808@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:301:1::23) To SN6PR15MB2512.namprd15.prod.outlook.com
 (2603:10b6:805:25::25)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:ad4f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 502cebe3-abfd-49d0-162b-08d6eadefa36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN6PR15MB2367;
x-ms-traffictypediagnostic: SN6PR15MB2367:
x-microsoft-antispam-prvs: <SN6PR15MB23676493DE8E4A8A1FE41B49D7100@SN6PR15MB2367.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(6512007)(66556008)(305945005)(31696002)(2906002)(6486002)(229853002)(86362001)(66446008)(64756008)(316002)(73956011)(6246003)(6436002)(486006)(7736002)(66476007)(66946007)(478600001)(186003)(31686004)(14454004)(46003)(256004)(446003)(36756003)(71190400001)(5660300002)(6116002)(102836004)(99286004)(53546011)(6506007)(386003)(25786009)(53936002)(2616005)(68736007)(76176011)(4326008)(110136005)(54906003)(52116002)(81166006)(11346002)(476003)(71200400001)(8676002)(81156014)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR15MB2367;H:SN6PR15MB2512.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pWM74CQXmov1a9e6obBugdAAQY6OVUwmfklUoE5vzXok8Zg6bdqUxdBSnOb0Y7khCCeeKaQTeozT0QDlUAKEz4YrxexFAvC9txA6WZCHfoLIM07/Qjyx6Y8d0HWwwFtiavevtjANyPTIfdYzkuwc33yB51fbP0rx0sh1XHHZls9fNsu2z1+M3KTm6pzMNNkrX3N2kpk7cRERNSvBuzs3D4PBALLrZrCN+RS5W8cz/aIXVamCqfelMyyOxrX4nrXUk3khk+zoTL9dLUKxAprpv2V870f1gfUjHyErDVcN75MD36KmphuqA6fgrF1ubPrkrbVVEwD+tZoSzUEI3reybV/KkxTruZVfdRyfemcCiJny0cyh7uJI3QD+p1qFrC+SHTYk4N96ovtahAKJDc1h3PZU2GqE7Vx1khMryvYMMMM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <923EE598356E394EA14E627AE2C519CE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 502cebe3-abfd-49d0-162b-08d6eadefa36
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 00:27:52.7048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2367
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi82LzE5IDU6MTAgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBUaHUsIDYgSnVu
IDIwMTkgMjM6Mjc6MzYgKzAwMDAsIEFsZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToNCj4+IE9uIDYv
Ni8xOSA0OjAyIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+Pj4+IHN0cnVjdCB7DQo+Pj4+
ICAgICAgICAgICBpbnQgdHlwZTsNCj4+Pj4gICAgICAgICAgIGludCBtYXhfZW50cmllczsNCj4+
Pj4gfSBteV9tYXAgX19hdHRyaWJ1dGVfXygobWFwKGludCxzdHJ1Y3QgbXlfdmFsdWUpKSkgPSB7
DQo+Pj4+ICAgICAgICAgICAudHlwZSA9IEJQRl9NQVBfVFlQRV9BUlJBWSwNCj4+Pj4gICAgICAg
ICAgIC5tYXhfZW50cmllcyA9IDE2LA0KPj4+PiB9Ow0KPj4+Pg0KPj4+PiBPZiBjb3Vyc2UgdGhp
cyB3b3VsZCBuZWVkIEJQRiBiYWNrZW5kIHN1cHBvcnQsIGJ1dCBhdCBsZWFzdCB0aGF0IGFwcHJv
YWNoDQo+Pj4+IHdvdWxkIGJlIG1vcmUgQyBsaWtlLiBUaHVzIHRoaXMgd291bGQgZGVmaW5lIHR5
cGVzIHdoZXJlIHdlIGNhbiBhdXRvbWF0aWNhbGx5DQo+Pj4gSSBndWVzcyBpdCdzIHRlY2huaWNh
bGx5IHBvc3NpYmxlIChub3QgYSBjb21waWxlciBndXJ1LCBidXQgSSBkb24ndA0KPj4+IHNlZSB3
aHkgaXQgd291bGRuJ3QgYmUgcG9zc2libGUpLiBCdXQgaXQgd2lsbCByZXF1aXJlIGF0IGxlYXN0
IHR3bw0KPj4+IHRoaW5nczoNCj4+PiAxLiBDb21waWxlciBzdXBwb3J0LCBvYnZpb3VzbHksIGFz
IHlvdSBtZW50aW9uZWQuDQo+Pg0KPj4gZXZlcnkgdGltZSB3ZSdyZSBkb2luZyBsbHZtIGNvbW1v
biBjaGFuZ2UgaXQgdGFrZXMgbWFueSBtb250aHMuDQo+PiBBZGRpbmcgQlRGIHRvb2sgNiBtb250
aCwgdGhvdWdoIHRoZSBjb21tb24gY2hhbmdlcyB3ZXJlIHRyaXZpYWwuDQo+PiBOb3cgd2UncmUg
YWxyZWFkeSAxKyBtb250aCBpbnRvIGFkZGluZyA0IGludHJpbnNpY3MgdG8gc3VwcG9ydCBDTy1S
RS4NCj4+DQo+PiBJbiB0aGUgcGFzdCBJIHdhcyB2ZXJ5IG11Y2ggaW4gZmF2b3Igb2YgZXh0ZW5k
aW5nIF9fYXR0cmlidXRlX18NCj4+IHdpdGggYnBmIHNwZWNpZmljIHN0dWZmLiBOb3cgbm90IHNv
IG11Y2guDQo+PiBfX2F0dHJpYnV0ZV9fKChtYXAoaW50LHN0cnVjdCBteV92YWx1ZSkpKSBjYW5u
b3QgYmUgZG9uZSBhcyBzdHJpbmdzLg0KPj4gY2xhbmcgaGFzIHRvIHByb2Nlc3MgdGhlIHR5cGVz
LCBjcmVhdGUgbmV3IG9iamVjdHMgaW5zaWRlIGRlYnVnIGluZm8uDQo+PiBJdCdzIG5vdCBjbGVh
ciB0byBtZSBob3cgdGhpcyBtb2RpZmllZCBkZWJ1ZyBpbmZvIHdpbGwgYmUgYXNzb2NpYXRlZA0K
Pj4gd2l0aCB0aGUgdmFyaWFibGUgbXlfbWFwLg0KPj4gU28gSSBzdXNwZWN0IGRvaW5nIF9fYXR0
cmlidXRlX18gd2l0aCBhY3R1YWwgQyB0eXBlIGluc2lkZSAoKCkpDQo+PiB3aWxsIG5vdCBiZSBw
b3NzaWJsZS4NCj4+IEkgdGhpbmsgaW4gdGhlIGZ1dHVyZSB3ZSBtaWdodCBzdGlsbCBhZGQgc3Ry
aW5nIGJhc2VkIGF0dHJpYnV0ZXMsDQo+PiBidXQgaXQncyBub3QgZ29pbmcgdG8gYmUgZWFzeS4N
Cj4+IFNvLi4uIFVubGVzcyBzb21lYm9keSBpbiB0aGUgY29tbXVuaXR5IHdobyBpcyBkb2luZyBm
dWxsIHRpbWUgbGx2bSB3b3JrDQo+PiB3aWxsIG5vdCBzdGVwIGluIHJpZ2h0IG5vdyBhbmQgc2F5
cyAiSSB3aWxsIGNvZGUgdGhlIGFib3ZlIGF0dHIgc3R1ZmYiLA0KPj4gd2Ugc2hvdWxkIG5vdCBj
b3VudCBvbiBzdWNoIGNsYW5nK2xsdm0gZmVhdHVyZS4NCj4gDQo+IElmIG5vYm9keSBoYXMgcmVz
b3VyY2VzIHRvIGNvbW1pdCB0byB0aGlzLCBwZXJoYXBzIHdlIGNhbiBqdXN0IHN0aWNrDQo+IHRv
IEJQRl9BTk5PVEFURV9LVl9QQUlSKCk/DQo+IA0KPiBBcG9sb2dpZXMsIGJ1dCBJIHRoaW5rIEkg
bWlzc2VkIHRoZSBtZW1vIG9uIHdoeSB0aGF0J3MgY29uc2lkZXJlZA0KPiBhIGhhY2suICBDb3Vs
ZCBzb21lb25lIHBvaW50IG1lIHRvIHRoZSByZWxldmFudCBkaXNjdXNzaW9uPw0KPiANCj4gV2Ug
Y291bGQgY29uY2VpdmFibHkgYWRkIEJURi1iYXNlZCBtYXBfZGVmIGZvciBvdGhlciBmZWF0dXJl
cywgYW5kDQo+IHNvbHZlIHRoZSBLL1YgcHJvYmxlbSBvbmNlIGEgY2xlYW4gc29sdXRpb24gYmVj
b21lcyBhcHBhcmVudCBhbmQNCj4gdHJhY3RhYmxlPyAgQlBGX0FOTk9UQVRFX0tWX1BBSVIoKSBp
cyBub3QgZ3JlYXQsIGJ1dCB3ZSBraW5kYSBhbHJlYWR5DQo+IGhhdmUgaXQuLg0KPiANCj4gUGVy
aGFwcyBJJ20gbm90IHRoaW5raW5nIGNsZWFybHkgYWJvdXQgdGhpcyBhbmQgSSBzaG91bGQgc3Rh
eSBxdWlldCA6KQ0KDQp0aGUgc29sdXRpb24gd2UncmUgZGlzY3Vzc2luZyBzaG91bGQgc29sdmUg
QlBGX0FOTk9UQVRFX0tWX1BBSVIgdG9vLg0KVGhhdCBoYWNrIG11c3QgZ28uDQoNCklmIEkgdW5k
ZXJzdG9vZCB5b3VyIG9iamVjdGlvbnMgdG8gQW5kcmlpJ3MgZm9ybWF0IGlzIHRoYXQNCnlvdSBk
b24ndCBsaWtlIHBvaW50ZXIgcGFydCBvZiBrZXkvdmFsdWUgd2hpbGUgQW5kcmlpIGV4cGxhaW5l
ZA0Kd2h5IHdlIHBpY2tlZCB0aGUgcG9pbnRlciwgcmlnaHQ/DQoNClNvIGhvdyBhYm91dDoNCg0K
c3RydWN0IHsNCiAgIGludCB0eXBlOw0KICAgaW50IG1heF9lbnRyaWVzOw0KICAgc3RydWN0IHsN
CiAgICAgX191MzIga2V5Ow0KICAgICBzdHJ1Y3QgbXlfdmFsdWUgdmFsdWU7DQogICB9IHR5cGVz
W107DQp9IC4uLg0KDQoNCg==
