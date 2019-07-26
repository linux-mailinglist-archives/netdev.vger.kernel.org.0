Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C93675EC3
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 08:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfGZGKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 02:10:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbfGZGKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 02:10:35 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6Q69sSg005720;
        Thu, 25 Jul 2019 23:10:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=h3rB8GUedc4BBn8ASd/v93zFVz50w91NLhgAMGh4q78=;
 b=rB1nTTq/Y1vIK4LI1fYFZTBr2kZk5CSNbJ35kCzC0Gap/1XtBgBfGt+Tj2Vos/SOc7vN
 eRsWVlqhyhm28tfp0NELp73YXoQT6ouwbvNygtGEonqkEIM47hPRTaUqVyfh1Y70UQ/2
 Fa71SPKg0H/LiH5bKwlElgGU989HAFUjFkU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tycy3bg77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jul 2019 23:10:08 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jul 2019 23:10:06 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jul 2019 23:10:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyA0+q7KHAg0LonoMzslHjq3RszT9foFU+bjXOpeRNwYqA+wzJFWsJZXimsO+zHw7U8oJwEamKJmpoN38isrsxjhxe+afY2rdQ46U5i+r82xq00Xfxqrgq7AO5t9Sjg3+ao78aFY5SogqPbE1YeBZ2QvT4DiZLA6EvdAvg/3Cf17m88xgxTfe0i1KSfnGPsGddf3Vd8q2s0R1AVHM93KRvNcRT21tEGldGbWe7pQK6uZx/6egi2642NEhXsqjf7eP4d1WbcvUhbzehmUMrL0nVOUBrvZcKFvj+OoGsiOvGuBkpqdYlu31YeR2EVf2Gvtod6PMtxo1s6kMply5RC39Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3rB8GUedc4BBn8ASd/v93zFVz50w91NLhgAMGh4q78=;
 b=Gdgks/yy8PXt+D3KSKL/PObRmOCLfSPLbGeJ+ltSyg4ZHO2S9OwntlSFq1k9LwyRG6COp7zPcNHBAA3WkItifB1uPXxb6M3+YKAy/j7V7N/SLqnIusIfRhsKmEhZy8wV3UxunNXgeg5LVc9Tb+c0LBHKwA/OGdTkz47jebYqtJEtEbjejBnzL56ChTIJyXximufOtePvBlQMQZIaVrInZGfGrdfARx7cLuO995xhWigDhPElYfkQo4y9lwWHxCJ2ROzHXHsmjxD6LuL1ird1f0ATmIrsSXwvKDVFnz40jX6kyWH+xZQWVMa83nZUJul2s1lKKpPs5AYpBXB3ZLVY1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3rB8GUedc4BBn8ASd/v93zFVz50w91NLhgAMGh4q78=;
 b=QNecGHDkWaUO+vIs2qlqufDy/A+eSFmX5BKg3JoKm1XHE/d86fN9qhbEmcnNlIpxkLZrqf4kBd91YaV2eVl5DN5Yj0fEClV14JB+zfx+FK2aj268vVs9rsJ3IU9oBERKDoYayTjip4YXjCK/eG/YQcMBei+IVQOaXPhdlaKKdTk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2568.namprd15.prod.outlook.com (20.179.155.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 06:10:02 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 06:10:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
Thread-Topic: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
Thread-Index: AQHVQ1QXCeTWaDA0LUe7xenqsSu2v6bcateA
Date:   Fri, 26 Jul 2019 06:10:02 +0000
Message-ID: <beb513cb-2d76-30d4-6500-2892c6566a7e@fb.com>
References: <20190724165803.87470-1-brianvv@google.com>
 <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
 <20190725235432.lkptx3fafegnm2et@ast-mbp>
 <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
 <CAADnVQJpp37fXLsu8ZnMFPoC0Uof3roz4gofX0QCewNkwtf-Xg@mail.gmail.com>
In-Reply-To: <CAADnVQJpp37fXLsu8ZnMFPoC0Uof3roz4gofX0QCewNkwtf-Xg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:102:2::37) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:dc6d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86ee48b8-f3ff-4f42-4a45-08d7118fe535
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2568;
x-ms-traffictypediagnostic: BYAPR15MB2568:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB2568D747C3F5D38B0FC27B16D3C00@BYAPR15MB2568.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(136003)(346002)(396003)(199004)(189003)(54906003)(6512007)(6246003)(6116002)(53936002)(5660300002)(7416002)(31686004)(966005)(25786009)(68736007)(46003)(486006)(14454004)(110136005)(76176011)(305945005)(7736002)(53546011)(6506007)(71190400001)(71200400001)(6436002)(102836004)(4326008)(31696002)(8936002)(52116002)(86362001)(14444005)(256004)(386003)(66946007)(81156014)(476003)(229853002)(6306002)(11346002)(81166006)(2616005)(66446008)(2906002)(36756003)(446003)(478600001)(64756008)(66556008)(66476007)(6486002)(8676002)(186003)(99286004)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2568;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G26z2c0K1rgSij3Q8qFzLzqCsAtrC9bzFA2cwcasrpf0w6agnpMG4NXoU4xyko/I73koGP99p1SI0TdFmxm14P/8NbctKLaWxPUH8gw7/a7g/tg769FhovuHFFnNYSoCJfMMwy7Gm1LWDjSycV4MkpGor9c3rYyPeDqiK1/YaTV7vZ5cVUGjYNhAvTxME00hj0aj6o0isEQGKapsmKTixXlWNoiKgHKNC30HW8gKpNHytauNeEELqWIvAAs8DtPkACuHpRMcDr2OwqtcuT265n1SBSzvCbO4VWHB+UFvlyj6h7sqT1wuwx3NF/u4uS8FmDf9HihY8X2Vb2ApBJ6ryIvUdngTi4azlbt9zVATZOvXI1s9WpE4WY0/umBKghgcy0+zcWSm2j6eHP9Oojb5BToEQ7cV4h9PfP5GXUy6ADA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5CB0B3874EF734BAD032C7CEACA8683@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ee48b8-f3ff-4f42-4a45-08d7118fe535
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 06:10:02.2393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=959 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260082
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjUvMTkgNjo0NyBQTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBPbiBU
aHUsIEp1bCAyNSwgMjAxOSBhdCA2OjI0IFBNIEJyaWFuIFZhenF1ZXogPGJyaWFudnYua2VybmVs
QGdtYWlsLmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gVGh1LCBKdWwgMjUsIDIwMTkgYXQgNDo1NCBQ
TSBBbGV4ZWkgU3Rhcm92b2l0b3YNCj4+IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPiB3
cm90ZToNCj4+Pg0KPj4+IE9uIFRodSwgSnVsIDI1LCAyMDE5IGF0IDA0OjI1OjUzUE0gLTA3MDAs
IEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+Pj4+Pj4+IElmIHByZXZfa2V5IGlzIGRlbGV0ZWQgYmVm
b3JlIG1hcF9nZXRfbmV4dF9rZXkoKSwgd2UgZ2V0IHRoZSBmaXJzdCBrZXkNCj4+Pj4+Pj4gYWdh
aW4uIFRoaXMgaXMgcHJldHR5IHdlaXJkLg0KPj4+Pj4+DQo+Pj4+Pj4gWWVzLCBJIGtub3cuIEJ1
dCBub3RlIHRoYXQgdGhlIGN1cnJlbnQgc2NlbmFyaW8gaGFwcGVucyBldmVuIGZvciB0aGUNCj4+
Pj4+PiBvbGQgaW50ZXJmYWNlIChpbWFnaW5lIHlvdSBhcmUgd2Fsa2luZyBhIG1hcCBmcm9tIHVz
ZXJzcGFjZSBhbmQgeW91DQo+Pj4+Pj4gdHJpZWQgZ2V0X25leHRfa2V5IHRoZSBwcmV2X2tleSB3
YXMgcmVtb3ZlZCwgeW91IHdpbGwgc3RhcnQgYWdhaW4gZnJvbQ0KPj4+Pj4+IHRoZSBiZWdpbm5p
bmcgd2l0aG91dCBub3RpY2luZyBpdCkuDQo+Pj4+Pj4gSSB0cmllZCB0byBzZW50IGEgcGF0Y2gg
aW4gdGhlIHBhc3QgYnV0IEkgd2FzIG1pc3Npbmcgc29tZSBjb250ZXh0Og0KPj4+Pj4+IGJlZm9y
ZSBOVUxMIHdhcyB1c2VkIHRvIGdldCB0aGUgdmVyeSBmaXJzdF9rZXkgdGhlIGludGVyZmFjZSBy
ZWxpZWQgaW4NCj4+Pj4+PiBhIHJhbmRvbSAobm9uIGV4aXN0ZW50KSBrZXkgdG8gcmV0cmlldmUg
dGhlIGZpcnN0X2tleSBpbiB0aGUgbWFwLCBhbmQNCj4+Pj4+PiBJIHdhcyB0b2xkIHdoYXQgd2Ug
c3RpbGwgaGF2ZSB0byBzdXBwb3J0IHRoYXQgc2NlbmFyaW8uDQo+Pj4+Pg0KPj4+Pj4gQlBGX01B
UF9EVU1QIGlzIHNsaWdodGx5IGRpZmZlcmVudCwgYXMgeW91IG1heSByZXR1cm4gdGhlIGZpcnN0
IGtleQ0KPj4+Pj4gbXVsdGlwbGUgdGltZXMgaW4gdGhlIHNhbWUgY2FsbC4gQWxzbywgQlBGX01B
UF9EVU1QIGlzIG5ldywgc28gd2UNCj4+Pj4+IGRvbid0IGhhdmUgdG8gc3VwcG9ydCBsZWdhY3kg
c2NlbmFyaW9zLg0KPj4+Pj4NCj4+Pj4+IFNpbmNlIEJQRl9NQVBfRFVNUCBrZWVwcyBhIGxpc3Qg
b2YgZWxlbWVudHMuIEl0IGlzIHBvc3NpYmxlIHRvIHRyeQ0KPj4+Pj4gdG8gbG9vayB1cCBwcmV2
aW91cyBrZXlzLiBXb3VsZCBzb21ldGhpbmcgZG93biB0aGlzIGRpcmVjdGlvbiB3b3JrPw0KPj4+
Pg0KPj4+PiBJJ3ZlIGJlZW4gdGhpbmtpbmcgYWJvdXQgaXQgYW5kIEkgdGhpbmsgZmlyc3Qgd2Ug
bmVlZCBhIHdheSB0byBkZXRlY3QNCj4+Pj4gdGhhdCBzaW5jZSBrZXkgd2FzIG5vdCBwcmVzZW50
IHdlIGdvdCB0aGUgZmlyc3Rfa2V5IGluc3RlYWQ6DQo+Pj4+DQo+Pj4+IC0gT25lIHNvbHV0aW9u
IEkgaGFkIGluIG1pbmQgd2FzIHRvIGV4cGxpY2l0bHkgYXNrZWQgZm9yIHRoZSBmaXJzdCBrZXkN
Cj4+Pj4gd2l0aCBtYXBfZ2V0X25leHRfa2V5KG1hcCwgTlVMTCwgZmlyc3Rfa2V5KSBhbmQgd2hp
bGUgd2Fsa2luZyB0aGUgbWFwDQo+Pj4+IGNoZWNrIHRoYXQgbWFwX2dldF9uZXh0X2tleShtYXAs
IHByZXZfa2V5LCBrZXkpIGRvZXNuJ3QgcmV0dXJuIHRoZQ0KPj4+PiBzYW1lIGtleS4gVGhpcyBj
b3VsZCBiZSBkb25lIHVzaW5nIG1lbWNtcC4NCj4+Pj4gLSBEaXNjdXNzaW5nIHdpdGggU3Rhbiwg
aGUgbWVudGlvbmVkIHRoYXQgYW5vdGhlciBvcHRpb24gaXMgdG8gc3VwcG9ydA0KPj4+PiBhIGZs
YWcgaW4gbWFwX2dldF9uZXh0X2tleSB0byBsZXQgaXQga25vdyB0aGF0IHdlIHdhbnQgYW4gZXJy
b3INCj4+Pj4gaW5zdGVhZCBvZiB0aGUgZmlyc3Rfa2V5Lg0KPj4+Pg0KPj4+PiBBZnRlciBkZXRl
Y3RpbmcgdGhlIHByb2JsZW0gd2UgYWxzbyBuZWVkIHRvIGRlZmluZSB3aGF0IHdlIHdhbnQgdG8g
ZG8sDQo+Pj4+IGhlcmUgc29tZSBvcHRpb25zOg0KPj4+Pg0KPj4+PiBhKSBSZXR1cm4gdGhlIGVy
cm9yIHRvIHRoZSBjYWxsZXINCj4+Pj4gYikgVHJ5IHdpdGggcHJldmlvdXMga2V5cyBpZiBhbnkg
KHdoaWNoIGJlIGxpbWl0ZWQgdG8gdGhlIGtleXMgdGhhdCB3ZQ0KPj4+PiBoYXZlIHRyYXZlcnNl
ZCBzbyBmYXIgaW4gdGhpcyBkdW1wIGNhbGwpDQo+Pj4+IGMpIGNvbnRpbnVlIHdpdGggbmV4dCBl
bnRyaWVzIGluIHRoZSBtYXAuIGFycmF5IGlzIGVhc3kganVzdCBnZXQgdGhlDQo+Pj4+IG5leHQg
dmFsaWQga2V5IChzdGFydGluZyBvbiBpKzEpLCBidXQgaG1hcCBtaWdodCBiZSBkaWZmaWN1bHQg
c2luY2UNCj4+Pj4gc3RhcnRpbmcgb24gdGhlIG5leHQgYnVja2V0IGNvdWxkIHBvdGVudGlhbGx5
IHNraXAgc29tZSBrZXlzIHRoYXQgd2VyZQ0KPj4+PiBjb25jdXJyZW50bHkgYWRkZWQgdG8gdGhl
IHNhbWUgYnVja2V0IHdoZXJlIGtleSB1c2VkIHRvIGJlLCBhbmQNCj4+Pj4gc3RhcnRpbmcgb24g
dGhlIHNhbWUgYnVja2V0IGNvdWxkIGxlYWQgdXMgdG8gcmV0dXJuIHJlcGVhdGVkIGVsZW1lbnRz
Lg0KPj4+Pg0KPj4+PiBPciBtYXliZSB3ZSBjb3VsZCBzdXBwb3J0IHRob3NlIDMgY2FzZXMgdmlh
IGZsYWdzIGFuZCBsZXQgdGhlIGNhbGxlcg0KPj4+PiBkZWNpZGUgd2hpY2ggb25lIHRvIHVzZT8N
Cj4+Pg0KPj4+IHRoaXMgdHlwZSBvZiBpbmRlY2lzaW9uIGlzIHRoZSByZWFzb24gd2h5IEkgd2Fz
bid0IGV4Y2l0ZWQgYWJvdXQNCj4+PiBiYXRjaCBkdW1waW5nIGluIHRoZSBmaXJzdCBwbGFjZSBh
bmQgZ2F2ZSAnc29mdCB5ZXMnIHdoZW4gU3Rhbg0KPj4+IG1lbnRpb25lZCBpdCBkdXJpbmcgbHNm
L21tL2JwZiB1Y29uZi4NCj4+PiBXZSBwcm9iYWJseSBzaG91bGRuJ3QgZG8gaXQuDQo+Pj4gSXQg
ZmVlbHMgdGhpcyBtYXBfZHVtcCBtYWtlcyBhcGkgbW9yZSBjb21wbGV4IGFuZCBkb2Vzbid0IHJl
YWxseQ0KPj4+IGdpdmUgbXVjaCBiZW5lZml0IHRvIHRoZSB1c2VyIG90aGVyIHRoYW4gbGFyZ2Ug
bWFwIGR1bXAgYmVjb21lcyBmYXN0ZXIuDQo+Pj4gSSB0aGluayB3ZSBnb3R0YSBzb2x2ZSB0aGlz
IHByb2JsZW0gZGlmZmVyZW50bHkuDQo+Pg0KPj4gU29tZSB1c2VycyBhcmUgd29ya2luZyBhcm91
bmQgdGhlIGR1bXBpbmcgcHJvYmxlbXMgd2l0aCB0aGUgZXhpc3RpbmcNCj4+IGFwaSBieSBjcmVh
dGluZyBhIGJwZl9tYXBfZ2V0X25leHRfa2V5X2FuZF9kZWxldGUgdXNlcnNwYWNlIGZ1bmN0aW9u
DQo+PiAoc2VlIGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRw
cy0zQV9fd3d3LmJvdW5jeWJvdW5jeS5uZXRfYmxvZ19icGYtNUZtYXAtNUZnZXQtNUZuZXh0LTVG
a2V5LTJEcGl0ZmFsbHNfJmQ9RHdJQmFRJmM9NVZEMFJUdE5sVGgzeWNkNDFiM01VdyZyPURBOGUx
QjVyMDczdklxUnJGejdNUkEmbT1Ydk54cXNEaFJpNjJnelowNEhiTFJUT0ZKWDhYNm1UdUs3UFpH
bjgwYWtZJnM9N3E3YmVaeE9KSjNRMGVsOEwwci14RGN0ZWRTcG5FZWpKNlBWWDFYWW90USZlPSAp
DQo+PiB3aGljaCBpbiBteSBvcGluaW9uIGlzIGFjdHVhbGx5IGEgZ29vZCBpZGVhLiBUaGUgb25s
eSBwcm9ibGVtIHdpdGgNCj4+IHRoYXQgaXMgdGhhdCBjYWxsaW5nIGJwZl9tYXBfZ2V0X25leHRf
a2V5KGZkLCBrZXksIG5leHRfa2V5KSBhbmQgdGhlbg0KPj4gYnBmX21hcF9kZWxldGVfZWxlbShm
ZCwga2V5KSBmcm9tIHVzZXJzcGFjZSBpcyByYWNpbmcgd2l0aCBrZXJuZWwgY29kZQ0KPj4gYW5k
IGl0IG1pZ2h0IGxvc2Ugc29tZSBpbmZvcm1hdGlvbiB3aGVuIGRlbGV0aW5nLg0KPj4gV2UgY291
bGQgdGhlbiBkbyBtYXBfZHVtcF9hbmRfZGVsZXRlIHVzaW5nIHRoYXQgaWRlYSBidXQgaW4gdGhl
IGtlcm5lbA0KPj4gd2hlcmUgd2UgY291bGQgYmV0dGVyIGhhbmRsZSB0aGUgcmFjaW5nIGNvbmRp
dGlvbi4gSW4gdGhhdCBzY2VuYXJpbw0KPj4gZXZlbiBpZiB3ZSByZXRyaWV2ZSB0aGUgc2FtZSBr
ZXkgaXQgd2lsbCBjb250YWluIGRpZmZlcmVudCBpbmZvICggdGhlDQo+PiBkZWx0YSBiZXR3ZWVu
IG9sZCBhbmQgbmV3IHZhbHVlKS4gV291bGQgdGhhdCB3b3JrPw0KPiANCj4geW91IG1lYW4gZ2V0
X25leHQrbG9va3VwK2RlbGV0ZSBhdCBvbmNlPw0KPiBTb3VuZHMgdXNlZnVsLg0KPiBZb25naG9u
ZyBoYXMgYmVlbiB0aGlua2luZyBhYm91dCBiYXRjaGluZyBhcGkgYXMgd2VsbC4NCg0KSW4gYmNj
LCB3ZSBoYXZlIG1hbnkgaW5zdGFuY2VzIGxpa2UgdGhpczoNCiAgICBnZXR0aW5nIGFsbCAoa2V5
IHZhbHVlKSBwYWlycywgZG8gc29tZSBhbmFseXNpcyBhbmQgb3V0cHV0LA0KICAgIGRlbGV0ZSBh
bGwga2V5cw0KDQpUaGUgaW1wbGVtZW50YXRpb24gdHlwaWNhbGx5IGxpa2UNCiAgICAvKiB0byBn
ZXQgYWxsIChrZXksIHZhbHVlKSBwYWlycyAqLw0KICAgIHdoaWxlKGJwZl9nZXRfbmV4dF9rZXko
KSA9PSAwKQ0KICAgICAgYnBmX21hcF9sb29rdXAoKQ0KICAgIC8qIGRvIGFuYWx5c2lzIGFuZCBv
dXRwdXQgKi8NCiAgICBmb3IgKGFsbCBrZXlzKQ0KICAgICAgYnBmX21hcF9kZWxldGUoKQ0KDQpn
ZXRfbmV4dCtsb29rdXArZGVsZXRlIHdpbGwgYmUgZGVmaW5pdGVseSB1c2VmdWwuDQpiYXRjaGlu
ZyB3aWxsIGJlIGV2ZW4gYmV0dGVyIHRvIHNhdmUgdGhlIG51bWJlciBvZiBzeXNjYWxscy4NCg0K
QW4gYWx0ZXJuYXRpdmUgaXMgdG8gZG8gYmF0Y2ggZ2V0X25leHQrbG9va3VwIGFuZCBiYXRjaCBk
ZWxldGUNCnRvIGFjaGlldmUgc2ltaWxhciBnb2FsIGFzIHRoZSBhYm92ZSBjb2RlLg0KDQpUaGVy
ZSBpcyBhIG1pbm9yIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGlzIGFwcHJvYWNoDQphbmQgdGhlIGFi
b3ZlIGdldF9uZXh0K2xvb2t1cCtkZWxldGUuDQpEdXJpbmcgc2Nhbm5pbmcgdGhlIGhhc2ggbWFw
LCBnZXRfbmV4dCtsb29rdXAgbWF5IGdldCBsZXNzIG51bWJlcg0Kb2YgZWxlbWVudHMgY29tcGFy
ZWQgdG8gZ2V0X25leHQrbG9va3VwK2RlbGV0ZSBhcyB0aGUgbGF0dGVyDQptYXkgaGF2ZSBtb3Jl
IGxhdGVyLWluc2VydGVkIGhhc2ggZWxlbWVudHMgYWZ0ZXIgdGhlIG9wZXJhdGlvbg0Kc3RhcnQu
IEJ1dCBib3RoIGFyZSBpbmFjY3VyYXRlLCBzbyBwcm9iYWJseSB0aGUgZGlmZmVyZW5jZQ0KaXMg
bWlub3IuDQoNCj4gDQo+IEkgdGhpbmsgaWYgd2UgY2Fubm90IGZpZ3VyZSBvdXQgaG93IHRvIG1h
a2UgYSBiYXRjaCBvZiB0d28gY29tbWFuZHMNCj4gZ2V0X25leHQgKyBsb29rdXAgdG8gd29yayBj
b3JyZWN0bHkgdGhlbiB3ZSBuZWVkIHRvIGlkZW50aWZ5L2ludmVudCBvbmUNCj4gY29tbWFuZCBh
bmQgbWFrZSBiYXRjaGluZyBtb3JlIGdlbmVyaWMuDQoNCm5vdCAxMDAlIHN1cmUuIEl0IHdpbGwg
YmUgaGFyZCB0byBkZWZpbmUgd2hhdCBpcyAiY29ycmVjdGx5Ii4NCkZvciBub3QgY2hhbmdpbmcg
bWFwLCBsb29waW5nIG9mIChnZXRfbmV4dCwgbG9va3VwKSBhbmQgYmF0Y2gNCmdldF9uZXh0K2xv
b2t1cCBzaG91bGQgaGF2ZSB0aGUgc2FtZSByZXN1bHRzLg0KRm9yIGNvbnN0YW50IGNoYW5naW5n
IGxvb3BzLCBub3Qgc3VyZSBob3cgdG8gZGVmaW5lIHdoaWNoIG9uZQ0KaXMgY29ycmVjdC4gSWYg
dXNlcnMgaGF2ZSBjb25jZXJucywgdGhleSBtYXkgbmVlZCB0byBqdXN0IHBpY2sgb25lDQp3aGlj
aCBnaXZlcyB0aGVtIG1vcmUgY29tZm9ydC4NCg0KPiBMaWtlIG1ha2Ugb25lIGp1bWJvL2NvbXBv
dW5kL2F0b21pYyBjb21tYW5kIHRvIGJlIGdldF9uZXh0K2xvb2t1cCtkZWxldGUuDQo+IERlZmlu
ZSB0aGUgc2VtYW50aWNzIG9mIHRoaXMgc2luZ2xlIGNvbXBvdW5kIGNvbW1hbmQuDQo+IEFuZCB0
aGVuIGxldCBiYXRjaGluZyB0byBiZSBhIG11bHRpcGxpZXIgb2Ygc3VjaCBjb21tYW5kLg0KPiBJ
biBhIHNlbnNlIHRoYXQgbXVsdGlwbGllciAxIG9yIE4gc2hvdWxkIGJlIGhhdmUgdGhlIHNhbWUg
d2F5Lg0KPiBObyBleHRyYSBmbGFncyB0byBhbHRlciB0aGUgYmF0Y2hpbmcuDQo+IFRoZSBoaWdo
IGxldmVsIGRlc2NyaXB0aW9uIG9mIHRoZSBiYXRjaCB3b3VsZCBiZToNCj4gcGxzIGV4ZWN1dGUg
Z2V0X25leHQsbG9va3VwLGRlbGV0ZSBhbmQgcmVwZWF0IGl0IE4gdGltZXMuDQo+IG9yDQo+IHBs
cyBleGVjdXRlIGdldF9uZXh0LGxvb2t1cCBhbmQgcmVwZWF0IE4gdGltZXMuDQo+IHdoZXJlIGVh
Y2ggY29tbWFuZCBhY3Rpb24gaXMgZGVmaW5lZCB0byBiZSBjb21wb3NhYmxlLg0KPiANCj4gSnVz
dCBhIHJvdWdoIGlkZWEuDQo+IA0K
