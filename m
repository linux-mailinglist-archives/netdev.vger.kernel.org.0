Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCE0144649
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAUVOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:14:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728741AbgAUVOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:14:11 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LL6rUX024123;
        Tue, 21 Jan 2020 13:13:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HnYatbYWT26ynDfvpVAuFW6jN+iTh2grBAM6j4okD/4=;
 b=nCrebNl/30YMhJ2JRSJaD0YeIlgYkpmeT1e1Rf619cCATw0wokqS5zaU9QNs2eNfbN9M
 wMYztvcwQslB6nabmVVqyuZyUdAP/OXl/NNAMMAW6EDEEgg4KMQstTWiaRPOG+DwUPIf
 il8K+ZgUQ8NiWAAQ4BZ2X9msx1mt50XKhxo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xmjeutw21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jan 2020 13:13:57 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 13:13:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2rVf7rMuAZaezYnQ2XouFSgrYWHtBXjjyLz+dmSHVDofosi9bsouqSW5RgExor4okPDp4bfjaDeOQa54X296osyxUwUmC+lWfmZProoF9DHbGlBnCbE0U3++K0NdE+IzWOngxTnqSnMAgEIWRvY2LViEW5m3YYDfmUwk3JcqmfQkj0Wnn26s8qq38nqKDUszHLTkOZrkor8B8FqaYX2ANS0fP/4/MQxFwpzWcWeZ2sdnuCzjWJ0/jx3NGAfuPYFs0jJrndCfxWKfAyERP5yTCfVINo28Iob8loe4pDKYX+2u1TfUn+p227JBbZ3ep9bX4Zsw6KtGE5tTuPkOZobMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnYatbYWT26ynDfvpVAuFW6jN+iTh2grBAM6j4okD/4=;
 b=NQzVgRhM+DHTy8FYP3eRqJczDecKT9AMq+CNA/y84dO+DANDOlxnyP3mgH56MLvfQa+KqYqZdrVQC4UB3lCaKr5z8l90Zjwx/ix9J2MpFP/SW0Ux9PE9kaxjzEY3K75NePsR3uuCuJWWf2eUqb1njKOyermVEh113XwwyLoteZVeSZWKyyBhg3JYyFprcZTMTtA+8T1yZi5a1Yys5g079Iid+PvTb/zPnTgTEN/nu3femYwxOzmUznSNVYOqasfjEynyD6pw5nxGaq0PQBeLCyn6pYe7NXie7j6bPHDLbeF08ovsUa500qFVXirC6WwY5OJbYE8hyVWCnpbtHapxnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnYatbYWT26ynDfvpVAuFW6jN+iTh2grBAM6j4okD/4=;
 b=giU84s3Uw6jssDFRzzo+wg9jXBTywBlLkzwmg/b0Z/5iUcROl9nzvw4KL1EtAJnuXPPN7hHtae/h4gqWyrO2oR3o3/G/9rWHdr4FPa0RHoDZazmcJzz4fcWawMaagyFJjciVhyJDhAh9wUWkposG6E80nhWnzvXe5fwgg6Bk54w=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3084.namprd15.prod.outlook.com (20.178.231.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Tue, 21 Jan 2020 21:13:53 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 21:13:53 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::2:3083) by MWHPR17CA0049.namprd17.prod.outlook.com (2603:10b6:300:93::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.21 via Frontend Transport; Tue, 21 Jan 2020 21:13:51 +0000
From:   Yonghong Song <yhs@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce dynamic program extensions
Thread-Topic: [PATCH v2 bpf-next 1/3] bpf: Introduce dynamic program
 extensions
Thread-Index: AQHVz/VP5Clb58eVWUeiLhlncXA4v6f0uyKAgACMtYCAACXTAIAAMbiA
Date:   Tue, 21 Jan 2020 21:13:53 +0000
Message-ID: <0ebae3f5-6ec4-c135-2c05-81bf6201f189@fb.com>
References: <20200121005348.2769920-1-ast@kernel.org>
 <20200121005348.2769920-2-ast@kernel.org>
 <5e26aa0bc382b_32772acafb17c5b410@john-XPS-13-9370.notmuch>
 <20200121160018.2w4o6o5nnhbdqicn@ast-mbp.dhcp.thefacebook.com>
 <5e273fce74a7f_20522ac6ec2c45c457@john-XPS-13-9370.notmuch>
In-Reply-To: <5e273fce74a7f_20522ac6ec2c45c457@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0049.namprd17.prod.outlook.com
 (2603:10b6:300:93::11) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:3083]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e1bf247-6a2f-4dba-979d-08d79eb6d18b
x-ms-traffictypediagnostic: DM6PR15MB3084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB3084452A9D5D2D32F852F1ACD30D0@DM6PR15MB3084.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39860400002)(396003)(136003)(189003)(199004)(36756003)(8676002)(6512007)(478600001)(66556008)(66476007)(66446008)(5660300002)(8936002)(31696002)(71200400001)(186003)(16526019)(86362001)(81166006)(81156014)(6506007)(64756008)(53546011)(52116002)(2906002)(31686004)(2616005)(54906003)(6486002)(66946007)(4326008)(316002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3084;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CAfKIoBFWq2J/fYDoERBFuoJUrh+Ybc155XGB1XrW0gdvPiun3PkEh49ZGXmYPCkX1CarlPeDkalyCRylDlI7f7orXxqCnlmvOAe4YouKv6SfDFa0dcdLdxlLchr3kzbRmvsFsuHhAU6nmryBlWjemszQRooTBgLwQpQzxRKD9cic9SS0KSOqONSPL+qrALEamvXdfoxgDo62VflrppTDTl5WJD3hvQgTd2nIsMZvetCFdj3yFPM3uOHMhlVTAeHrNeMXzVFweDbI6xepNCsoX6XllGgcGcowESgsrixCHAFly0tupCWBIh9pURW2HtUc1t1rmnrHEwhWm5D37BIlRpRIlS3c/LHK03hBGG7N5/ucY/pQkCYIMate91Mh06QfBJmakkAZYwdpwXNzdBxsI2IngrvheinefhaJB9E1x4hsUBC/63dR7P2ybJTgWty
Content-Type: text/plain; charset="utf-8"
Content-ID: <14BDB1F7543A25478645EBC359550430@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1bf247-6a2f-4dba-979d-08d79eb6d18b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 21:13:53.5276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gHYNiTjuX7LO6VjqJXZ8vqZXAJmlVhKxJKNkpNF0Ox3CMhHlloZARnk2J25ZL0Ej
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3084
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMjEvMjAgMTA6MTUgQU0sIEpvaG4gRmFzdGFiZW5kIHdyb3RlOg0KPiBBbGV4ZWkg
U3Rhcm92b2l0b3Ygd3JvdGU6DQo+PiBPbiBNb24sIEphbiAyMCwgMjAyMCBhdCAxMTozNjo0M1BN
IC0wODAwLCBKb2huIEZhc3RhYmVuZCB3cm90ZToNCj4+Pg0KPj4+PiArDQo+Pj4+ICsJdDEgPSBi
dGZfdHlwZV9za2lwX21vZGlmaWVycyhidGYxLCB0MS0+dHlwZSwgTlVMTCk7DQo+Pj4+ICsJdDIg
PSBidGZfdHlwZV9za2lwX21vZGlmaWVycyhidGYyLCB0Mi0+dHlwZSwgTlVMTCk7DQo+Pj4NCj4+
PiBJcyBpdCByZWFsbHkgYmVzdCB0byBza2lwIG1vZGlmaWVycz8gSSB3b3VsZCBleHBlY3QgdGhh
dCBpZiB0aGUNCj4+PiBzaWduYXR1cmUgaXMgZGlmZmVyZW50IGluY2x1ZGluZyBtb2RpZmllcnMg
dGhlbiB3ZSBzaG91bGQganVzdCByZWplY3QgaXQuDQo+Pj4gT1RPSCBpdHMgbm90IHJlYWxseSBD
IGNvZGUgaGVyZSBlaXRoZXIgc28gbW9kaWZpZXJzIG1heSBub3QgaGF2ZSB0aGUgc2FtZQ0KPj4+
IG1lYW5pbmcuIFdpdGgganVzdCBpbnRlZ2VycyBhbmQgc3RydWN0IGl0IG1heSBiZSBvayBidXQg
aWYgd2UgYWRkIHBvaW50ZXJzDQo+Pj4gdG8gaW50cyB0aGVuIHdoYXQgd291bGQgd2UgZXhwZWN0
IGZyb20gYSBjb25zdCBpbnQqPw0KPj4+DQo+Pj4gU28gd2hhdHMgdGhlIHJlYXNvbmluZyBmb3Ig
c2tpcHBpbmcgbW9kaWZpZXJzPyBJcyBpdCBwdXJlbHkgYW4gYXJndW1lbnQNCj4+PiB0aGF0IGl0
cyBub3QgcmVxdWlyZWQgZm9yIHNhZmV0eSBzbyBzb2x2ZSBpdCBlbHNld2hlcmU/IEluIHRoYXQg
Y2FzZSB0aGVuDQo+Pj4gY2hlY2tpbmcgbmFtZXMgb2YgZnVuY3Rpb25zIGlzIGFsc28gZXF1YWxs
eSBub3QgcmVxdWlyZWQuDQo+Pg0KPj4gRnVuY3Rpb24gbmFtZXMgYXJlIG5vdCBjaGVja2VkIGJ5
IHRoZSBrZXJuZWwuIEl0J3MgcHVyZWx5IGxpYmJwZiBhbmQgYnBmX3Byb2cuYw0KPj4gY29udmVu
dGlvbi4gVGhlIGtlcm5lbCBvcGVyYXRlcyBvbiBwcm9nX2ZkK2J0Zl9pZCBvbmx5LiBUaGUgbmFt
ZXMgb2YgZnVuY3Rpb24NCj4+IGFyZ3VtZW50cyBhcmUgbm90IGNvbXBhcmVkIGVpdGhlci4NCj4g
DQo+IFNvcnJ5IG1pc3R5cGVkIG5hbWVzIG9mIHN0cnVjdCBpcyB3aGF0IEkgbWVhbnQsIGJ1dCB0
aGF0IGlzIHByb2JhYmx5IG5pY2UgdG8NCj4gaGF2ZSBwZXIgY29tbWVudC4NCj4gDQo+Pg0KPj4g
VGhlIGNvZGUgaGFzIHRvIHNraXAgbW9kaWZpZXJzLiBPdGhlcndpc2UgdGhlIHR5cGUgY29tcGFy
aXNvbiBhbGdvcml0aG0gd2lsbCBiZQ0KPj4gcXVpdGUgY29tcGxleCwgc2luY2UgdHlwZWRlZiBp
cyBzdWNoIG1vZGlmaWVyLiBMaWtlICd1MzInIGluIG9yaWdpbmFsIHByb2dyYW0NCj4+IGFuZCAn
dTMyJyBpbiBleHRlbnNpb24gcHJvZ3JhbSB3b3VsZCBoYXZlIHRvIGJlIHJlY3Vyc2l2ZWx5IGNo
ZWNrZWQuDQo+Pg0KPj4gQW5vdGhlciByZWFzb24gdG8gc2tpcCBtb2RpZmllcnMgaXMgJ3ZvbGF0
aWxlJyBtb2RpZmllci4gSSBzdXNwZWN0IHdlIHdvdWxkDQo+PiBoYXZlIHRvIHVzZSBpdCBmcm9t
IHRpbWUgdG8gdGltZSBpbiBvcmlnaW5hbCBwbGFjZWhvbGRlciBmdW5jdGlvbnMuIFlldCBuZXcN
Cj4+IHJlcGxhY2VtZW50IGZ1bmN0aW9uIHdpbGwgYmUgd3JpdHRlbiB3aXRob3V0IHZvbGF0aWxl
LiBUaGUgcGxhY2Vob2xkZXIgbWF5IG5lZWQNCj4+IHZvbGF0aWxlIHRvIG1ha2Ugc3VyZSBjb21w
aWxlciBkb2Vzbid0IG9wdGltaXplIHRoaW5ncyBhd2F5LiBJIGZvdW5kIGNhc2VzDQo+PiB3aGVy
ZSAnbm9pbmxpbmUnIGluIHBsYWNlaG9sZGVyIHdhcyBub3QgZW5vdWdoLiBjbGFuZyB3b3VsZCBz
dGlsbCBpbmxpbmUgdGhlDQo+PiBib2R5IG9mIHRoZSBmdW5jdGlvbiBhbmQgcmVtb3ZlIGNhbGwg
aW5zdHJ1Y3Rpb24uIFNvIGZhciBJJ3ZlIGJlZW4gdXNpbmcNCj4+IHZvbGF0aWxlIGFzIGEgd29y
a2Fyb3VuZC4gTWF5IGJlIHdlIHdpbGwgaW50cm9kdWNlIG5ldyBmdW5jdGlvbiBhdHRyaWJ1dGUg
dG8NCj4+IGNsYW5nLg0KPiANCj4gWWVzLCB3ZSBoYXZlIHZhcmlvdXMgc2ltaWxhciBpc3N1ZSBh
bmQgaGF2ZSBpbiB0aGUgcGFzdCB1c2VkIHZvbGF0aWxlIHRvIHdvcmsNCj4gYXJvdW5kIHRoZW0g
YnV0IHZvbGF0aWxlJ3MgaW5zaWRlIGxvb3BzIHRlbmRzIHRvIGJyZWFrIGxvb3Agb3B0aW1pemF0
aW9ucyBhbmQNCj4gY2F1c2UgY2xhbmcgd2FybmluZ3MvZXJyb3JzLiBBbm90aGVyIGNvbW1vbiBv
bmUgaXMgdmVyaWZpZXIgZmFpbGluZyB0byB0cmFjaw0KPiB3aGVuIHNjYWxhcnMgbW92ZSBhcm91
bmQgaW4gcmVnaXN0ZXJzLiBBcyBhbiBleGFtcGxlIHRoZSBmb2xsb3dpbmcgaXMgdmFsaWQNCj4g
QyBmb3IgYSBib3VuZGVkIGFkZGl0b24gdG8gYXJyYXkgcG9pbnRlciBidXQgbm90IHRyYWN0YWJs
ZSBmb3IgdGhlIHZlcmlmaWVyDQo+IGF0IHRoZSBtb21lbnQuIChtYWRlIGV4YW1wbGUgYXQgc29t
ZSBwb2ludCBJJ2xsIGRpZyB1cCBhIGNvbGxlY3Rpb24gb2YNCj4gcmVhbC13b3JsZCBleGFtcGxl
cykNCj4gDQo+ICAgICAgcjEgPSAqKHU2NCAqKShyMTAgLSA4KQ0KPiAgICAgIHI2ID0gcjENCj4g
ICAgICBpZiByNiA8ICVbY29uc3RdIGdvdG8gJWxbZXJyXQ0KPiAgICAgIHIzICs9IHIxDQo+ICAg
ICAgcjIgPSAlW2NvcHlfc2l6ZV0NCj4gICAgICByMSA9IHI3DQo+ICAgICAgY2FsbCA0DQo+IA0K
PiBjb21waWxlciBiYXJyaWVycyBoZWxwIGJ1dCBub3QgYWx3YXlzIGFuZCBhbHNvIGJyZWFrcyBs
b29wIG9wdGltaXphdGlvbg0KPiBwYXNzZXMuIEJ1dCwgdGhhdHMgYSBkaWZmZXJlbnQgZGlzY3Vz
c2lvbiBJIG9ubHkgbWVudGlvbiBpdCBiZWNhdXNlDQo+IGVpdGhlciB2ZXJpZmllciBoYXMgdG8g
dHJhY2sgYWJvdmUgbG9naWMgYmV0dGVyIG9yIG5ldyBhdHRyaWJ1dGVzIGluIGNsYW5nDQo+IGNv
dWxkIGJlIHVzZWQgZm9yIHRoZXNlIHRoaW5ncy4gQnV0IHRoZSBuZXcgYXR0cmlidXRlcyBkb24n
dCB1c3VhbGx5IHdvcmsNCj4gd2VsbCB3aGVuIG1peGVkIHdpdGggb3B0aW1pemF0aW9uIHBhc3Nl
cyB0aGF0IHdlIHdvdWxkIGFjdHVhbGx5IGxpa2UgdG8NCj4ga2VlcC4NCg0KSm9obiwgY291bGQg
eW91IHNlbmQgeW91ciBvcmlnaW5hbCBDIGNvZGUgaG93IHRvIHJlcHJvZHVjZSB0aGlzPyBJIGFt
IA0Kd29ya2luZyBvbiBsbHZtIHNpZGUgdG8gYXZvaWQgc3VjaCBvcHRpbWl6YXRpb25zLCBpLmUu
LCBtb3Zpbmcgc2NhbGFycyANCmFyb3VuZCBzbyBsYXRlciBvbiB5b3UgY291bGQgaGF2ZSB0d28g
c2NhbGVzIHdpdGggZGlmZmVyZW50IHZlcmlmaWVkIA0Kc3RhdGUgaG9sZGluZyB0aGUgW3NsaWdo
dGx5XSBzYW1lIHZhbHVlLg0KDQo+IA0KPj4NCj4+IEhhdmluZyBzYWlkIHRoYXQgSSBzaGFyZSB5
b3VyIGNvbmNlcm4gcmVnYXJkaW5nIHNraXBwaW5nICdjb25zdCcuIEZvciAnY29uc3QNCj4+IGlu
dCBhcmcnIGl0J3MgdG90YWxseSBvayB0byBza2lwIGl0LCBzaW5jZSBpdCdzIG1lYW5pbmdsZXNz
IGZyb20gc2FmZXR5IHBvdiwNCj4+IGJ1dCBmb3IgJ2NvbnN0IGludCAqYXJnJyBhbmQgJ2NvbnN0
IHN0cnVjdCBmb28gKmFyZycgSSdtIHBsYW5uaW5nIHRvIHByZXNlcnZlDQo+PiBpdC4gSXQgd2ls
bCBiZSBwcmVzZXJ2ZWQgYXQgdGhlIHZlcmlmaWVyIGJwZl9yZWdfc3RhdGUgbGV2ZWwgdGhvdWdo
LiBKdXN0DQo+PiBjaGVja2luZyB0aGF0ICdjb25zdCcgaXMgcHJlc2VudCBpbiBleHRlbnNpb24g
cHJvZydzIEJURiBkb2Vzbid0IGhlbHAgc2FmZXR5Lg0KPj4gSSdtIHBsYW5pbmcgdG8gbWFrZSB0
aGUgdmVyaWZpZXIgZW5mb3JjZSB0aGF0IGJwZiBwcm9nIGNhbm5vdCB3cml0ZSBpbnRvDQo+PiBh
cmd1bWVudCB3aGljaCB0eXBlIGlzIHBvaW50ZXIgdG8gY29uc3Qgc3RydWN0LiBUaGF0IHBhcnQg
aXMgc3RpbGwgd2lwLiBJdCB3aWxsDQo+PiBiZSBpbXBsZW1lbnRlZCBmb3IgZ2xvYmFsIGZ1bmN0
aW9ucyBmaXJzdCBhbmQgdGhlbiBmb3IgZXh0ZW5zaW9uIHByb2dyYW1zLg0KPj4gQ3VycmVudGx5
IHRoZSB2ZXJpZmllciByZWplY3RzIGFueSBwb2ludGVyIHRvIHN0cnVjdCAob3RoZXIgdGhhbiBj
b250ZXh0KSwgc28NCj4+IG5vIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgaXNzdWVzLg0KPiANCj4g
QWggb2sgdGhpcyB3aWxsIGJlIGdyZWF0LiBJbiB0aGF0IGNhc2UgY29uc3Qgd2lsbCBiZSBtb3Jl
IGdlbmVyYWwgdGhlbg0KPiBtZXJlbHkgZnVuY3Rpb25zIGFuZCBzaG91bGQgYmUgYXBwbGljYWJs
ZSBnZW5lcmFsbHkgYXQgbGVhc3QgYXMgYW4gZW5kDQo+IGdvYWwgSU1PLiBUaGVyZSB3aWxsIGJl
IGEgc2xpZ2h0IGFubm95YW5jZSB3aGVyZSBvbGQgZXh0ZW5zaW9ucyBtYXkgbm90DQo+IHJ1biBv
biBuZXcga2VybmVscyB0aG91Z2guIEkgd2lsbCBhcmd1ZSBzdWNoIGV4dGVuc2lvbnMgYXJlIGJy
b2tlbiB0aG91Z2guDQo+IA0KPiBGb3IgdGhpcyBwYXRjaCB0aGVuLA0KPiANCj4gQWNrZWQtYnk6
IEpvaG4gRmFzdGFiZW5kIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+DQo+IA0K
