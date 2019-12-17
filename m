Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF231222F3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLQEOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:14:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfLQEOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:14:20 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBH4E27X005694;
        Mon, 16 Dec 2019 20:14:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S96yMpNRIrd5wdbMOJOVvQwtFgeRuj9GQmidIdVflDU=;
 b=qvlrlmoRLiDNrEzfFaOhcBUXfnhLwtbf189RgmgmQbm3qPjFLhkRICZO6xSy0wTPfZcE
 y8sYQ0ZHK+xzJss+PVxDtP2ilxzR2rNmniSldzHlt2RUKwvDXwoeH3GZY/etkbHL9jiT
 usMGyfcu+2KxHelu3KlvPSju0M1TDDMpX3o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwgayqpsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Dec 2019 20:14:02 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 20:13:59 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 20:13:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXkvRxctfKAxYHg7NbMFeY7T4yOk1KFaXZ/C/Odch7t6WcBHP989UK5K3BsFRSz+JVM0USbAB4DGLTN75Y1FxNMiQBGBBPllQWEIAq0YEFg8deOSUDTmoZ0dxnXAVxg/bQ8QSSxox7zRcf+5xBscT7blhLgoKpM4tdUZR7VqPgIPdcraWiX1Bld58zWPoe5iMueYsB/WcnJBj5Kb3ThZ835hsa4F8KaR5VK3ERNzHjSKJ5OwTD9K+Ng+pkGYtc5beVLNhdTxYqRzFPUnbQ5mcxHO0xeVQj7FoRwufm25unDuAZX/pkCoGBwGwr51fsaDXlrnJKqYXhJ7yciCfUvuzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S96yMpNRIrd5wdbMOJOVvQwtFgeRuj9GQmidIdVflDU=;
 b=LcIZQ9IHMJlsgS1BS9+wWj3Sb9AjQ3wCiEc+bOnrLo3jQlbBFPjkYvSoq0hHIZeP+JyzBjQOYZSyWFXEryV2gerqSvIcqXMJrvzWizLUxL2w1PfKgKYEpjGcgRAWI/FxbsVACGSfNV/i9Lzjj7/fOsYl7ohr3fVylHWrIgmPrf2lUkkea28WPMHpSbOlCL1ghraZsNtpeWP+B5xAXYEracQGVKNFflHzNdtV3sfmZ4qEYf6jOnU2nEzyTzWCtQls0LztaSnHtNpL+HFoG2Cbxs68B9icOt4f0i+Z2+BKcM4RBqzwN29IKilnja9myF2froywwXAHcY8i6+qWeKrymQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S96yMpNRIrd5wdbMOJOVvQwtFgeRuj9GQmidIdVflDU=;
 b=ATGQjWL2pZ9RoJfasCWb/oyygGf1HFUk5r5j3yL0P7x7IgvtHUwXYDQ8lx4hIPgWc/cHlnbJh7hxFkNRG6iI9ACqo4L1NFLAgC61quDgVl8Digu/D6s9EZzGIS5Mkp+0TERUjALjEap840Gql2aJ4Wn9cKqZXH25KrqfFTe0vDM=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1641.namprd15.prod.outlook.com (10.175.105.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 04:13:44 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 04:13:44 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v12 2/2] selftests/bpf: test for
 bpf_get_file_path() from tracepoint
Thread-Topic: [PATCH bpf-next v12 2/2] selftests/bpf: test for
 bpf_get_file_path() from tracepoint
Thread-Index: AQHVsvxYmrJNxRpypU29QIi+fvaSJ6e7YkuAgAJVDoCAAANcgA==
Date:   Tue, 17 Dec 2019 04:13:44 +0000
Message-ID: <71c53be6-add4-2557-bc8f-8acb8e4a2f39@fb.com>
References: <cover.1576381511.git.ethercflow@gmail.com>
 <088f1485865016d639cadc891957918060261405.1576381512.git.ethercflow@gmail.com>
 <737b90af-aa51-bd7d-8f68-b68050cbb028@fb.com>
 <CABtjQmZtzZT+OmZCn=eL9pvTeeCQ+TzKUMGgFJcGzwJDqyk6vw@mail.gmail.com>
In-Reply-To: <CABtjQmZtzZT+OmZCn=eL9pvTeeCQ+TzKUMGgFJcGzwJDqyk6vw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0041.namprd22.prod.outlook.com
 (2603:10b6:301:16::15) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7395]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a955118-0c53-4840-1211-08d782a78175
x-ms-traffictypediagnostic: DM5PR15MB1641:
x-microsoft-antispam-prvs: <DM5PR15MB164112591B6FA0E8E7249A92D3500@DM5PR15MB1641.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(39860400002)(136003)(199004)(189003)(6512007)(36756003)(31696002)(71200400001)(52116002)(6486002)(2906002)(81166006)(6916009)(186003)(66946007)(66476007)(66556008)(64756008)(66446008)(5660300002)(316002)(8936002)(478600001)(4326008)(54906003)(2616005)(31686004)(81156014)(6506007)(53546011)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1641;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 69dDFTPPL9hzvCkHBZxPkoMPZ3KuluiYL3PtU7Ve9xCwFYIekoUYT0bXFzafHVyDFci5a2RQ6Eeuc5gbXT1rDYBoQiJNcOHFUVVfOi5mwrJ3y+5DRtp4BSdOC+TprSqgx/7kYa4ZEDk4etnYtBNC/OrIDgewmELFQYq2JrE2hRNFtiY7QNT0zCyF+xp+RjNnvpND/XwpSV4Zvm8MWRZsTrXsZ7eIkqulNh7GQzKXgrhgZuFI8pNMq4nCdnqvvlbpIne97cgGxYI0gSdFa8AQmVb546Y1PRQGq+q50nMkEErpDGhuUioystg9fWcqXZa6zXXZxgo8Qttmi53zi+agCtk02B6C9lJ7IwbhM4YdRi5GfQj/LNdFds7NQD4m0dc6jdDS+FpE2MUXtu/Ro60NiKYeDusXh20YAWvc9E3g8e4WZwz6IjtBiWvZ6Huh0s+u
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6BF108299374542957E1987BF385CFA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a955118-0c53-4840-1211-08d782a78175
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 04:13:44.1935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cMsMwm7QVdezDC23R7jRa/s9wzO8/ZWm8mNZ2pbSrqEsocgB+tkK1T097tRLAR1a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1641
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_01:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDg6MDEgUE0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPj4gSW4gbm9uLWJw
ZiAuYyBmaWxlLCB0eXBpY2FsbHkgd2UgZG8gbm90IGFkZCAnaW5saW5lJyBhdHRyaWJ1dGUuDQo+
PiBJdCBpcyB1cCB0byBjb21waWxlciB0byBkZWNpZGUgd2hldGhlciBpdCBzaG91bGQgYmUgaW5s
aW5lZC4NCj4gDQo+IFRoYW5rIHlvdSwgSSdsbCBmaXggdGhpcy4NCj4gDQo+Pj4gK3N0cnVjdCBz
eXNfZW50ZXJfbmV3ZnN0YXRfYXJncyB7DQo+Pj4gKyAgICAgdW5zaWduZWQgbG9uZyBsb25nIHBh
ZDE7DQo+Pj4gKyAgICAgdW5zaWduZWQgbG9uZyBsb25nIHBhZDI7DQo+Pj4gKyAgICAgdW5zaWdu
ZWQgaW50IGZkOw0KPj4+ICt9Ow0KPiANCj4+IFRoZSBCVEYgZ2VuZXJhdGVkIHZtbGludXguaCBo
YXMgdGhlIGZvbGxvd2luZyBzdHJ1Y3R1cmUsDQo+PiBzdHJ1Y3QgdHJhY2VfZW50cnkgew0KPj4g
ICAgICAgICAgIHNob3J0IHVuc2lnbmVkIGludCB0eXBlOw0KPj4gICAgICAgICAgIHVuc2lnbmVk
IGNoYXIgZmxhZ3M7DQo+PiAgICAgICAgICAgdW5zaWduZWQgY2hhciBwcmVlbXB0X2NvdW50Ow0K
Pj4gICAgICAgICAgIGludCBwaWQ7DQo+PiB9Ow0KPj4gc3RydWN0IHRyYWNlX2V2ZW50X3Jhd19z
eXNfZW50ZXIgew0KPj4gICAgICAgICAgIHN0cnVjdCB0cmFjZV9lbnRyeSBlbnQ7DQo+PiAgICAg
ICAgICAgbG9uZyBpbnQgaWQ7DQo+PiAgICAgICAgICAgbG9uZyB1bnNpZ25lZCBpbnQgYXJnc1s2
XTsNCj4+ICAgICAgICAgICBjaGFyIF9fZGF0YVswXTsNCj4+IH07DQo+IA0KPj4gVGhlIHRoaXJk
IHBhcmFtZXRlciB0eXBlIHNob3VsZCBiZSBsb25nLCBvdGhlcndpc2UsDQo+PiBpdCBtYXkgaGF2
ZSBpc3N1ZSBvbiBiaWcgZW5kaWFuIG1hY2hpbmVzPw0KPiANCj4gU29ycnksIEkgZG9uJ3QgdW5k
ZXJzdGFuZCB3aHkgdGhlcmUgaXMgYSBwcm9ibGVtIG9uIGJpZy1lbmRpYW4gbWFjaGluZXMuDQo+
IFdvdWxkIHlvdSBwbGVhc2UgZXhwbGFpbiB0aGF0IGluIG1vcmUgZGV0YWlsPyBUaGFuayB5b3Uu
DQoNClRoZSBrZXJuZWwgd2lsbCBhY3R1YWxseSBoYXZlIDggYnl0ZXMgb2YgbWVtb3J5IHRvIHN0
b3JlIGZkDQpiYXNlZCBvbiB0cmFjZV9ldmVudF9yYXdfc3lzX2VudGVyLg0KDQpGb3IgbGl0dGxl
IGVuZGlhbiBtYWNoaW5lLCB0aGUgbG93ZXIgNCBieXRlcyBhcmUgcmVhZCBiYXNlZCBvbg0KeW91
ciBzeXNfZW50ZXJfbmV3ZnN0YXRfYXJncywgd2hpY2ggaXMgImFjY2lkZW50YWxseSIgdGhlIGxv
d2VyDQo0IGJ5dGVzIGluIHU2NCwgc28geW91IGdldCB0aGUgY29ycmVjdCBhbnN3ZXIuDQoNCkZv
ciBiaWcgZW5kaWFuIG1hY2hpbmUsIHRoZSBsb3dlciA0IGJ5dGVzIHJlYWQgYmFzZWQgb24NCnlv
dXIgc3lzX2VudGVyX25ld2ZzdGF0X2FyZ3Mgd2lsbCBiZSBoaWdoIDQgYnl0ZXMgaW4gdTY0LCB3
aGljaA0KaXMgaW5jb3JyZWN0Lg0KDQo+IA0KPiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPiDk
uo4yMDE55bm0MTLmnIgxNuaXpeWRqOS4gCDkuIrljYgxMjoyNeWGmemBk++8mg0KPj4NCj4+DQo+
Pg0KPj4gT24gMTIvMTQvMTkgODowMSBQTSwgV2VuYm8gWmhhbmcgd3JvdGU6DQo+Pj4gdHJhY2Ug
ZnN0YXQgZXZlbnRzIGJ5IHRyYWNlcG9pbnQgc3lzY2FsbHMvc3lzX2VudGVyX25ld2ZzdGF0LCBh
bmQgaGFuZGxlDQo+Pj4gZXZlbnRzIG9ubHkgcHJvZHVjZWQgYnkgdGVzdF9maWxlX2dldF9wYXRo
LCB3aGljaCBjYWxsIGZzdGF0IG9uIHNldmVyYWwNCj4+PiBkaWZmZXJlbnQgdHlwZXMgb2YgZmls
ZXMgdG8gdGVzdCBicGZfZ2V0X2ZpbGVfcGF0aCdzIGZlYXR1cmUuDQo+Pj4NCj4+PiB2NC0+djU6
IGFkZHJlc3NlZCBBbmRyaWkncyBmZWVkYmFjaw0KPj4+IC0gcGFzcyBOVUxMIGZvciBvcHRzIGFz
IGJwZl9vYmplY3RfX29wZW5fZmlsZSdzIFBBUkFNMiwgYXMgbm90IHJlYWxseQ0KPj4+IHVzaW5n
IGFueQ0KPj4+IC0gbW9kaWZ5IHBhdGNoIHN1YmplY3QgdG8ga2VlcCB1cCB3aXRoIHRlc3QgY29k
ZQ0KPj4+IC0gYXMgdGhpcyB0ZXN0IGlzIHNpbmdsZS10aHJlYWRlZCwgc28gdXNlIGdldHBpZCBp
bnN0ZWFkIG9mIFNZU19nZXR0aWQNCj4+PiAtIHJlbW92ZSB1bm5lY2Vzc2FyeSBwYXJlbnMgYXJv
dW5kIGNoZWNrIHdoaWNoIGFmdGVyIGlmIChpIDwgMykNCj4+PiAtIGluIGtlcm4gdXNlIGJwZl9n
ZXRfY3VycmVudF9waWRfdGdpZCgpID4+IDMyIHRvIGZpdCBnZXRwaWQoKSBpbg0KPj4+IHVzZXJz
cGFjZSBwYXJ0DQo+Pj4gLSB3aXRoIHRoZSBwYXRjaCBhZGRpbmcgaGVscGVyIGFzIG9uZSBwYXRj
aCBzZXJpZXMNCj4+Pg0KPj4+IHYzLT52NDogYWRkcmVzc2VkIEFuZHJpaSdzIGZlZWRiYWNrDQo+
Pj4gLSB1c2UgYSBzZXQgb2YgZmQgaW5zdGVhZCBvZiBmZHMgYXJyYXkNCj4+PiAtIHVzZSBnbG9i
YWwgdmFyaWFibGVzIGluc3RlYWQgb2YgbWFwcyAoaW4gdjMsIEkgbWlzdGFrZW5seSB0aG91Z2h0
IHRoYXQNCj4+PiB0aGUgYnBmIG1hcHMgYXJlIGdsb2JhbCB2YXJpYWJsZXMuKQ0KPj4+IC0gcmVt
b3ZlIHVuY2Vzc2FyeSBnbG9iYWwgdmFyaWFibGUgcGF0aF9pbmZvX2luZGV4DQo+Pj4gLSByZW1v
dmUgZmQgY29tcGFyZSBhcyB0aGUgZnN0YXQncyBvcmRlciBpcyBmaXhlZA0KPj4+DQo+Pj4gdjIt
PnYzOiBhZGRyZXNzZWQgQW5kcmlpJ3MgZmVlZGJhY2sNCj4+PiAtIHVzZSBnbG9iYWwgZGF0YSBp
bnN0ZWFkIG9mIHBlcmZfYnVmZmVyIHRvIHNpbXBsaWZpZWQgY29kZQ0KPj4+DQo+Pj4gdjEtPnYy
OiBhZGRyZXNzZWQgRGFuaWVsJ3MgZmVlZGJhY2sNCj4+PiAtIHJlbmFtZSBicGZfZmQycGF0aCB0
byBicGZfZ2V0X2ZpbGVfcGF0aCB0byBiZSBjb25zaXN0ZW50IHdpdGggb3RoZXINCj4+PiBoZWxw
ZXIncyBuYW1lcw0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogV2VuYm8gWmhhbmcgPGV0aGVyY2Zs
b3dAZ21haWwuY29tPg0KPj4+IC0tLQ0KPj4+ICAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dfdGVz
dHMvZ2V0X2ZpbGVfcGF0aC5jICB8IDE3MSArKysrKysrKysrKysrKysrKysNCj4+PiAgICAuLi4v
c2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2dldF9maWxlX3BhdGguYyAgfCAgNDMgKysrKysNCj4+
PiAgICAyIGZpbGVzIGNoYW5nZWQsIDIxNCBpbnNlcnRpb25zKCspDQo+Pj4gICAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL2dldF9maWxl
X3BhdGguYw0KPj4+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvcHJvZ3MvdGVzdF9nZXRfZmlsZV9wYXRoLmMNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9nZXRfZmlsZV9wYXRoLmMgYi90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9nZXRfZmlsZV9wYXRoLmMNCj4+
PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4+IGluZGV4IDAwMDAwMDAwMDAwMC4uN2VjMTFlNDNl
MGZjDQo+Pj4gLS0tIC9kZXYvbnVsbA0KPj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi9wcm9nX3Rlc3RzL2dldF9maWxlX3BhdGguYw0KPj4+IEBAIC0wLDAgKzEsMTcxIEBADQo+
Pj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+Pj4gKyNkZWZpbmUgX0dO
VV9TT1VSQ0UNCj4+PiArI2luY2x1ZGUgPHRlc3RfcHJvZ3MuaD4NCj4+PiArI2luY2x1ZGUgPHN5
cy9zdGF0Lmg+DQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPg0KPj4+ICsjaW5jbHVkZSA8
c3lzL3N5c2NhbGwuaD4NCj4+PiArDQo+Pj4gKyNkZWZpbmUgTUFYX1BBVEhfTEVOICAgICAgICAg
MTI4DQo+Pj4gKyNkZWZpbmUgTUFYX0ZEUyAgICAgICAgICAgICAgICAgICAgICA3DQo+Pj4gKyNk
ZWZpbmUgTUFYX0VWRU5UX05VTSAgICAgICAgICAgICAgICAxNg0KPj4+ICsNCj4+PiArc3RhdGlj
IHN0cnVjdCBmaWxlX3BhdGhfdGVzdF9kYXRhIHsNCj4+PiArICAgICBwaWRfdCBwaWQ7DQo+Pj4g
KyAgICAgX191MzIgY250Ow0KPj4+ICsgICAgIF9fdTMyIGZkc1tNQVhfRVZFTlRfTlVNXTsNCj4+
PiArICAgICBjaGFyIHBhdGhzW01BWF9FVkVOVF9OVU1dW01BWF9QQVRIX0xFTl07DQo+Pj4gK30g
c3JjLCBkc3Q7DQo+Pj4gKw0KPj4+ICtzdGF0aWMgaW5saW5lIGludCBzZXRfcGF0aG5hbWUoaW50
IGZkKQ0KPj4NCj4+IEluIG5vbi1icGYgLmMgZmlsZSwgdHlwaWNhbGx5IHdlIGRvIG5vdCBhZGQg
J2lubGluZScgYXR0cmlidXRlLg0KPj4gSXQgaXMgdXAgdG8gY29tcGlsZXIgdG8gZGVjaWRlIHdo
ZXRoZXIgaXQgc2hvdWxkIGJlIGlubGluZWQuDQo+Pg0KPj4+ICt7DQo+Pj4gKyAgICAgY2hhciBi
dWZbTUFYX1BBVEhfTEVOXTsNCj4+PiArDQo+Pj4gKyAgICAgc25wcmludGYoYnVmLCBNQVhfUEFU
SF9MRU4sICIvcHJvYy8lZC9mZC8lZCIsIHNyYy5waWQsIGZkKTsNCj4+PiArICAgICBzcmMuZmRz
W3NyYy5jbnRdID0gZmQ7DQo+Pj4gKyAgICAgcmV0dXJuIHJlYWRsaW5rKGJ1Ziwgc3JjLnBhdGhz
W3NyYy5jbnQrK10sIE1BWF9QQVRIX0xFTik7DQo+Pj4gK30NCj4+PiArDQo+PiBbLi4uXQ0KPj4+
IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9nZXRf
ZmlsZV9wYXRoLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9nZXRf
ZmlsZV9wYXRoLmMNCj4+PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4+IGluZGV4IDAwMDAwMDAw
MDAwMC4uZWFlNjYzYzEyNjJhDQo+Pj4gLS0tIC9kZXYvbnVsbA0KPj4+ICsrKyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2dldF9maWxlX3BhdGguYw0KPj4+IEBAIC0w
LDAgKzEsNDMgQEANCj4+PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4+
PiArDQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9icGYuaD4NCj4+PiArI2luY2x1ZGUgPGxpbnV4L3B0
cmFjZS5oPg0KPj4+ICsjaW5jbHVkZSA8c3RyaW5nLmg+DQo+Pj4gKyNpbmNsdWRlIDx1bmlzdGQu
aD4NCj4+PiArI2luY2x1ZGUgImJwZl9oZWxwZXJzLmgiDQo+Pj4gKyNpbmNsdWRlICJicGZfdHJh
Y2luZy5oIg0KPj4+ICsNCj4+PiArI2RlZmluZSBNQVhfUEFUSF9MRU4gICAgICAgICAxMjgNCj4+
PiArI2RlZmluZSBNQVhfRVZFTlRfTlVNICAgICAgICAgICAgICAgIDE2DQo+Pj4gKw0KPj4+ICtz
dGF0aWMgc3RydWN0IGZpbGVfcGF0aF90ZXN0X2RhdGEgew0KPj4+ICsgICAgIHBpZF90IHBpZDsN
Cj4+PiArICAgICBfX3UzMiBjbnQ7DQo+Pj4gKyAgICAgX191MzIgZmRzW01BWF9FVkVOVF9OVU1d
Ow0KPj4+ICsgICAgIGNoYXIgcGF0aHNbTUFYX0VWRU5UX05VTV1bTUFYX1BBVEhfTEVOXTsNCj4+
PiArfSBkYXRhOw0KPj4+ICsNCj4+PiArc3RydWN0IHN5c19lbnRlcl9uZXdmc3RhdF9hcmdzIHsN
Cj4+PiArICAgICB1bnNpZ25lZCBsb25nIGxvbmcgcGFkMTsNCj4+PiArICAgICB1bnNpZ25lZCBs
b25nIGxvbmcgcGFkMjsNCj4+PiArICAgICB1bnNpZ25lZCBpbnQgZmQ7DQo+Pj4gK307DQo+Pg0K
Pj4gVGhlIEJURiBnZW5lcmF0ZWQgdm1saW51eC5oIGhhcyB0aGUgZm9sbG93aW5nIHN0cnVjdHVy
ZSwNCj4+IHN0cnVjdCB0cmFjZV9lbnRyeSB7DQo+PiAgICAgICAgICAgc2hvcnQgdW5zaWduZWQg
aW50IHR5cGU7DQo+PiAgICAgICAgICAgdW5zaWduZWQgY2hhciBmbGFnczsNCj4+ICAgICAgICAg
ICB1bnNpZ25lZCBjaGFyIHByZWVtcHRfY291bnQ7DQo+PiAgICAgICAgICAgaW50IHBpZDsNCj4+
IH07DQo+PiBzdHJ1Y3QgdHJhY2VfZXZlbnRfcmF3X3N5c19lbnRlciB7DQo+PiAgICAgICAgICAg
c3RydWN0IHRyYWNlX2VudHJ5IGVudDsNCj4+ICAgICAgICAgICBsb25nIGludCBpZDsNCj4+ICAg
ICAgICAgICBsb25nIHVuc2lnbmVkIGludCBhcmdzWzZdOw0KPj4gICAgICAgICAgIGNoYXIgX19k
YXRhWzBdOw0KPj4gfTsNCj4+DQo+PiBUaGUgdGhpcmQgcGFyYW1ldGVyIHR5cGUgc2hvdWxkIGJl
IGxvbmcsIG90aGVyd2lzZSwNCj4+IGl0IG1heSBoYXZlIGlzc3VlIG9uIGJpZyBlbmRpYW4gbWFj
aGluZXM/DQo=
