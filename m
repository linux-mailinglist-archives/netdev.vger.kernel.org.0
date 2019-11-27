Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3010A77E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 01:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfK0A11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 19:27:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726957AbfK0A10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 19:27:26 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAR0ALZu016745;
        Tue, 26 Nov 2019 16:27:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XPJ18IDDKMf/vGhpd9AKylt3rHaW6bMTPb0FJ2ptk0c=;
 b=IZYXdYU8wcd9mM5B8Oi7tPN3lYVjrrmm1jgExdL8VkLs5Qytfoa/WttYl/ZHC46vqtH9
 aPnYOa4QCtv3r0N4YhunFi4A2oL/g+ue5InCsP9PT4rOwkb8zWJqNZhDZvtFCa7FAhCy
 WhvtPs85hXljrwec936EYhhUkhU3pm/bEuw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2whcy2rnah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Nov 2019 16:27:07 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Nov 2019 16:27:06 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Nov 2019 16:27:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jj1p9AIASKPuglw5VqDGTuVcSPgg/s8F7qIzqG/IHUN2uPlVCyu0Sg1Virj7hh0aK6shbN35ouvy0zMbf8rsybJBPrDAM6KMHE15OxEoEx93hq3VFbYNdvjMem6HDWnzb87dJvjZ0C6/cOvKx/9LLm4ZJONJQYZzA6dek/CFik+13Z/ilzoNL+PMqXrBgBPC95jG+SdB+ozkBcHE1YBxpbbHhxdNS2GklG+cJhguVrzsL/l/CO8EJltcbRPI45tvfXsQmmwK7g9R1GqhoFye3r663GNJ/A2Va16BDSiNX9lEBvngA5QJ4t325es4uNZj6n+uW2egquBCEP+SRAYOew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPJ18IDDKMf/vGhpd9AKylt3rHaW6bMTPb0FJ2ptk0c=;
 b=lZ52QnTy0/jtvQsJFfrr45dTxpczxj+uT2bJgAOXMeY4hJJF+VU/pSAtnO+gn3FKZOdCX6ig4Ezs59cIyXZ/PQ7t10nrpx5qxm5x9rhYmlL09ciBe1UdRCoJlfpq3r20QxGvzz3zKncy4ZlfigrJ+vnDrD+AgokpQAcM1joVjJ8dUC8GLWXRjIiANhyQiBpLVGt3kUxnjqk0N1t0rvNOAz1TKhhx0CBmbE6vrcOCEFf1GWEhtrF/ppI1xy8+VucpUdAL2vfb06kou+NzuGsVIhHAvtWbECFztQr1BTfk/KaTuvGa7s7XIB7ddB3iFKhlGj+D2sTMbK62vkzTYfq+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPJ18IDDKMf/vGhpd9AKylt3rHaW6bMTPb0FJ2ptk0c=;
 b=b5jBn4SQjGZCd9xB9BsuFkm8uALmsB9DG9DKayTgmBKefeiJ4Cy+LaG4+2VaEACIuNUG8US2laLcJsdA8h/hEHIrPQqROqqXbOhOzgH69OJOR59dqoBDFvIVMS1b4A43dooq6BbZbBMM0+vWeRMgv/swtArskIKHVLKN2DZtPQA=
Received: from CY4PR15MB1206.namprd15.prod.outlook.com (10.172.182.17) by
 CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.23; Wed, 27 Nov 2019 00:27:05 +0000
Received: from CY4PR15MB1206.namprd15.prod.outlook.com
 ([fe80::685e:e18b:36d6:e36f]) by CY4PR15MB1206.namprd15.prod.outlook.com
 ([fe80::685e:e18b:36d6:e36f%8]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 00:27:05 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for vmlinux
 BTF
Thread-Topic: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for
 vmlinux BTF
Thread-Index: AQHVpLEys+bl2TgVWEaJTkl587y446eeG06AgAACc4CAAAB4AIAABNMAgAAGWAA=
Date:   Wed, 27 Nov 2019 00:27:05 +0000
Message-ID: <9e43748f-300b-8eb8-fa88-ce5035e5ca83@fb.com>
References: <20191126232818.226454-1-sdf@google.com>
 <5dddb7059b13e_13b82abee0d625bc2d@john-XPS-13-9370.notmuch>
 <20191126234523.GF3145429@mini-arch.hsd1.ca.comcast.net>
 <02a27e2f-d269-0b04-a4ef-ebb347e3c918@fb.com>
 <20191127000420.GG3145429@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20191127000420.GG3145429@mini-arch.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0048.namprd11.prod.outlook.com
 (2603:10b6:300:115::34) To CY4PR15MB1206.namprd15.prod.outlook.com
 (2603:10b6:903:114::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:49cd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33c58036-0573-4f91-58e1-08d772d087c0
x-ms-traffictypediagnostic: CY4PR15MB1207:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <CY4PR15MB1207F57FD84E73F3EC0632A1C6440@CY4PR15MB1207.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(346002)(376002)(39860400002)(199004)(189003)(8936002)(6246003)(256004)(66946007)(54906003)(86362001)(14444005)(65806001)(65956001)(81166006)(81156014)(6306002)(36756003)(58126008)(46003)(6486002)(25786009)(4326008)(229853002)(6512007)(31696002)(99286004)(52116002)(186003)(14454004)(305945005)(6116002)(966005)(31686004)(6916009)(76176011)(6506007)(386003)(7736002)(316002)(66476007)(66556008)(64756008)(8676002)(102836004)(66446008)(2616005)(71190400001)(5660300002)(11346002)(71200400001)(2906002)(446003)(478600001)(6436002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1207;H:CY4PR15MB1206.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fGvbAz7ZNWjQVb1Q+ei3AghyuQ3G0GAWp6ZxfFrp4ysHxcm5SmaBtAN4tDjYf05A2h57fhVbWhed6vBHhwiLmFd/v4jR2lzyfWDH9bxwhH3vOfsv5iJLv/kk0QhoptB7zKgiZykIEo/BzgL1o+ZmyFI2ors5DzEqqdfMzeGSXUaWmC//ZC7jZrm3Zq+int9949NRvUWmvvKjgeT3uHMzPADQpObKCysy2qt14snO6JXmbiGYbvDfRd5UH94w3FH66X5fFzy3raKZDrH4JYViNGgVL9WUPs2oQMLj4Ve5xXd6A9tAZdYcdWkcgYu6baKiyzIscGbXjGWXn7VWtmOy5gK3deu5uZWLYok4NkjTrfXM7PG8l4PWVubgE/LepvfryetgV4mg+CbzqJWtbKA5qqgxEtxR/UeZG1VP+OPbMKbuqFW1tO+O6UsMxJdJ4DQ9bjkBckgK6EkjCQBaf6sk70gWE/t9zV9EgqIc9bnafEs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F76E7F9A09665944BF8146AAD525FE76@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c58036-0573-4f91-58e1-08d772d087c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 00:27:05.4947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ys/sNLY7UWtY374eMs3ndFmDXXcaMCbYAYb57IVLCzPVbTtvqv4aC+bWNGKZee1q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1207
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_08:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjYvMTkgNDowNCBQTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBPbiAxMS8y
NiwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPj4gT24gMTEvMjYvMTkgMzo0NSBQTSwgU3Rhbmlz
bGF2IEZvbWljaGV2IHdyb3RlOg0KPj4+IE9uIDExLzI2LCBKb2huIEZhc3RhYmVuZCB3cm90ZToN
Cj4+Pj4gU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPj4+Pj4gSWYgdm1saW51eCBCVEYgZ2Vu
ZXJhdGlvbiBmYWlscywgYnV0IENPTkZJR19ERUJVR19JTkZPX0JURiBpcyBzZXQsDQo+Pj4+PiAu
QlRGIHNlY3Rpb24gb2Ygdm1saW51eCBpcyBlbXB0eSBhbmQga2VybmVsIHdpbGwgcHJvaGliaXQN
Cj4+Pj4+IEJQRiBsb2FkaW5nIGFuZCByZXR1cm4gImluLWtlcm5lbCBCVEYgaXMgbWFsZm9ybWVk
Ii4NCj4+Pj4+DQo+Pj4+PiAtLWR1bXAtc2VjdGlvbiBhcmd1bWVudCB0byBiaW51dGlscycgb2Jq
Y29weSB3YXMgYWRkZWQgaW4gdmVyc2lvbiAyLjI1Lg0KPj4+Pj4gV2hlbiB1c2luZyBwcmUtMi4y
NSBiaW51dGlscywgQlRGIGdlbmVyYXRpb24gc2lsZW50bHkgZmFpbHMuIENvbnZlcnQNCj4+Pj4+
IHRvIC0tb25seS1zZWN0aW9uIHdoaWNoIGlzIHByZXNlbnQgb24gcHJlLTIuMjUgYmludXRpbHMu
DQo+Pj4+Pg0KPj4+Pj4gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL2NoYW5nZXMucnN0IHN0YXRlcyB0
aGF0IGJpbnV0aWxzIDIuMjErDQo+Pj4+PiBpcyBzdXBwb3J0ZWQsIG5vdCBzdXJlIHRob3NlIHN0
YW5kYXJkcyBhcHBseSB0byBCUEYgc3Vic3lzdGVtLg0KPj4+Pj4NCj4+Pj4+IHYyOg0KPj4+Pj4g
KiBleGl0IGFuZCBwcmludCBhbiBlcnJvciBpZiBnZW5fYnRmIGZhaWxzIChKb2huIEZhc3RhYmVu
ZCkNCj4+Pj4+DQo+Pj4+PiBDYzogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4+
Pj4+IENjOiBKb2huIEZhc3RhYmVuZCA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPg0KPj4+Pj4g
Rml4ZXM6IDM0MWRmY2Y4ZDc4ZWEgKCJidGY6IGV4cG9zZSBCVEYgaW5mbyB0aHJvdWdoIHN5c2Zz
IikNCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5j
b20+DQo+Pj4+PiAtLS0NCj4+Pj4+ICAgIHNjcmlwdHMvbGluay12bWxpbnV4LnNoIHwgNyArKysr
KystDQo+Pj4+PiAgICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL3NjcmlwdHMvbGluay12bWxpbnV4LnNoIGIv
c2NyaXB0cy9saW5rLXZtbGludXguc2gNCj4+Pj4+IGluZGV4IDA2NDk1Mzc5ZmNkOC4uMjk5OGRk
YjMyM2UzIDEwMDc1NQ0KPj4+Pj4gLS0tIGEvc2NyaXB0cy9saW5rLXZtbGludXguc2gNCj4+Pj4+
ICsrKyBiL3NjcmlwdHMvbGluay12bWxpbnV4LnNoDQo+Pj4+PiBAQCAtMTI3LDcgKzEyNyw4IEBA
IGdlbl9idGYoKQ0KPj4+Pj4gICAgCQljdXQgLWQsIC1mMSB8IGN1dCAtZCcgJyAtZjIpDQo+Pj4+
PiAgICAJYmluX2Zvcm1hdD0kKExBTkc9QyAke09CSkRVTVB9IC1mICR7MX0gfCBncmVwICdmaWxl
IGZvcm1hdCcgfCBcDQo+Pj4+PiAgICAJCWF3ayAne3ByaW50ICQ0fScpDQo+Pj4+PiAtCSR7T0JK
Q09QWX0gLS1kdW1wLXNlY3Rpb24gLkJURj0uYnRmLnZtbGludXguYmluICR7MX0gMj4vZGV2L251
bGwNCj4+Pj4+ICsJJHtPQkpDT1BZfSAtLXNldC1zZWN0aW9uLWZsYWdzIC5CVEY9YWxsb2MgLU8g
YmluYXJ5IFwNCj4+Pj4+ICsJCS0tb25seS1zZWN0aW9uPS5CVEYgJHsxfSAuYnRmLnZtbGludXgu
YmluIDI+L2Rldi9udWxsDQo+Pj4+PiAgICAJJHtPQkpDT1BZfSAtSSBiaW5hcnkgLU8gJHtiaW5f
Zm9ybWF0fSAtQiAke2Jpbl9hcmNofSBcDQo+Pj4+PiAgICAJCS0tcmVuYW1lLXNlY3Rpb24gLmRh
dGE9LkJURiAuYnRmLnZtbGludXguYmluICR7Mn0NCj4+Pj4+ICAgIH0NCj4+Pj4+IEBAIC0yNTMs
NiArMjU0LDEwIEBAIGJ0Zl92bWxpbnV4X2Jpbl9vPSIiDQo+Pj4+PiAgICBpZiBbIC1uICIke0NP
TkZJR19ERUJVR19JTkZPX0JURn0iIF07IHRoZW4NCj4+Pj4+ICAgIAlpZiBnZW5fYnRmIC50bXBf
dm1saW51eC5idGYgLmJ0Zi52bWxpbnV4LmJpbi5vIDsgdGhlbg0KPj4+Pj4gICAgCQlidGZfdm1s
aW51eF9iaW5fbz0uYnRmLnZtbGludXguYmluLm8NCj4+Pj4+ICsJZWxzZQ0KPj4+Pj4gKwkJZWNo
byA+JjIgIkZhaWxlZCB0byBnZW5lcmF0ZSBCVEYgZm9yIHZtbGludXgiDQo+Pj4+PiArCQllY2hv
ID4mMiAiVHJ5IHRvIGRpc2FibGUgQ09ORklHX0RFQlVHX0lORk9fQlRGIg0KPj4+Pg0KPj4+PiBJ
IHRoaW5rIHdlIHNob3VsZCBlbmNvdXJhZ2UgdXBncmFkaW5nIGJpbnV0aWxzIGZpcnN0PyBNYXli
ZQ0KPj4+Pg0KPj4+PiAiYmludXRpbHMgMi4yNSsgcmVxdWlyZWQgZm9yIEJURiBwbGVhc2UgdXBn
cmFkZSBvciBkaXNhYmxlIENPTkZJR19ERUJVR19JTkZPX0JURiINCj4+Pj4NCj4+Pj4gb3RoZXJ3
aXNlIEkgZ3Vlc3MgaXRzIGdvaW5nIHRvIGJlIGEgYml0IG15c3RpY2FsIHdoeSBpdCB3b3JrcyBp
bg0KPj4+PiBjYXNlcyBhbmQgbm90IG90aGVycyB0byBmb2xrcyB1bmZhbWlsaWFyIHdpdGggdGhl
IGRldGFpbHMuDQo+Pj4gV2l0aCB0aGUgY29udmVyc2lvbiBmcm9tIC0tZHVtcC1zZWN0aW9uIHRv
IC0tb25seS1zZWN0aW9uIHRoYXQgSQ0KPj4+IGRpZCBpbiB0aGlzIHBhdGNoLCBiaW51dGlscyAy
LjI1KyBpcyBubyBsb25nZXIgYSByZXF1aXJlbWVudC4NCj4+PiAyLjIxIChtaW5pbWFsIHZlcnNp
b24gZnJvbSBEb2N1bWVudGF0aW9uL3Byb2Nlc3MvY2hhbmdlcy5yc3QpIHNob3VsZCB3b3JrDQo+
Pj4ganVzdCBmaW5lLg0KPj4NCj4+IFllYWgsIGluc3RlYWQgaXQncyBiZXR0ZXIgdG8gbWVudGlv
biB0aGF0IHBhaG9sZSB2MS4xMysgaXMgcmVxdWlyZWQuDQo+IFdlIGFscmVhZHkgaGF2ZSBtb3N0
IG9mIHRoZSBtZXNzYWdlcyBhYm91dCBtaXNzaW5nIHBhaG9sZSBvciB3cm9uZyB2ZXJzaW9uOg0K
PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9icGYvYnBm
LW5leHQuZ2l0L3RyZWUvc2NyaXB0cy9saW5rLXZtbGludXguc2gjbjExMQ0KPiBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9icGYvYnBmLW5leHQuZ2l0L3Ry
ZWUvc2NyaXB0cy9saW5rLXZtbGludXguc2gjbjExNw0KPiANCj4gVGhleSBhcmUgJ2luZm8nIHRo
b3VnaCwgYnV0IGl0IHNlZW1zIGxvZ2ljYWwgdG8gZHJvcCAtcyBmcm9tIG1ha2UgYXJndW1lbnRz
DQo+IGlmIHNvbWVvbmUgd2FudHMgdG8gZGVidWcgZnVydGhlci4NCj4gDQoNCkZhaXIgZW5vdWdo
LiBQbGVhc2UgYWRkIGJhY2sgbXkgVGVzdGVkLWJ5OiB0YWcuDQoNCkFja2VkLWJ5OiBBbmRyaWkg
TmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0K
