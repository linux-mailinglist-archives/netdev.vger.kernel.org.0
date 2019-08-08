Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DDC85733
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbfHHATc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:19:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729960AbfHHATb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:19:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7809tk1030304;
        Wed, 7 Aug 2019 17:19:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eLiiaRcPY81/A2NtauRP1ceEpGURks4Epr7BU9UZwV8=;
 b=aM1KDqIxiRg5c+UPfi+agZdSKXmhW0nsWGiN2JBnqiUHnPqZWEQwcn2CrcMgPL9xFdd2
 E8uwQqGttlbZtmh9nnmp9ZmUVjQ5zMS1/8xgSGBprtQHBi5gPZuZSsikn3Fz6HVYkmrU
 iv/HtwESz+gDSUGDR8QrTqFRLzDvRd08+Xw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u87ufg81d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 07 Aug 2019 17:19:03 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 17:19:01 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 17:19:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnHbOCkiGAdZDRnHs2Q2vpUQAsfu37akeeeIz3dmHDsLbwdMk2U8L+U2RrG8nY11zu377ZJtTp1YvKnx6kKB0x8xz2JPoRwSXneGgRiy77/jwczW5wKr5pwh+OuNP/1TCTkrO4LRM2Ev6RXZUj91khCPFYn5NT4EQoDdt/9+FG0xGZpc+61rM2i33UW1OrxK/1RY8LK7WQrgMuXNBTg0xKH5MZPh2Z3C7wKeFmy7/PRsQnVDHcwfJi4MTjqvM3IPk7QowR237n4qCDSGiy9SUq0soZX7wG93mVme1RS9pluPtf+yIwOd7Lp79jb2uuYbdPBC5lJFqtY/4NVFJ+q3CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLiiaRcPY81/A2NtauRP1ceEpGURks4Epr7BU9UZwV8=;
 b=I0J8LEBWHhQyI4cXvPothVtMnhUcMSa6vhO6s6f9tqVGRnngU3pwUjVjlHLLtZPYjj8LzD9rKLrHXQzp+PRPafIUEofJPp/uuDCfNK2TyP6+JX8GlDqXQ62EXaE+HHmrJOQjuRTDB58/wKh2TolfKHcpwiS+q1SkUbvtbfIgpIWG0VPo7GCdWjXNZo02RwraLJPbxo+B08IJ/Ln0x6ABpJqoYaRQ+3E4DcLPoH5UnDURtOuaHniYupiT8/CX/FwNfGrBd9DqU6e6NrdazJZ5rtMui0lK5XIgbRhAFenGChya+S8WOdXapR/lsUjkHt7VJhS1YmXyUHyywG1LyqdY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLiiaRcPY81/A2NtauRP1ceEpGURks4Epr7BU9UZwV8=;
 b=bRRmFRh8p9fB89/DHxtYPGTnxavubyQp+BluWSro7aCKG6z9Q34wQHrt6Iuxrz60K3p1YSkW0Z5yeFtp/WpLJbRCCzR1K+YzT4MyRc8T4/KsnOlgcyJWlg3FWZDSG5gHl504N2kbWrrXdVuZtll4JQm32MNtBJrdZWLK5i6VuRA=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2727.namprd15.prod.outlook.com (20.179.157.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Thu, 8 Aug 2019 00:19:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Thu, 8 Aug 2019
 00:19:00 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Topic: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Index: AQHVTTdwUPivpnTVP0StwugAgCIRIabv2OiAgACGp4CAAAO+gA==
Date:   Thu, 8 Aug 2019 00:18:59 +0000
Message-ID: <d4388370-d26d-1ee4-3dcc-a86a008fa9a2@fb.com>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
 <9bd56e49-c38d-e1c4-1ff3-8250531d0d48@fb.com>
 <20190808000533.GA2820@mini-arch>
In-Reply-To: <20190808000533.GA2820@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:a03:100::25) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f6d1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b9e7b5a-6419-44d1-0ebb-08d71b960282
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2727;
x-ms-traffictypediagnostic: BYAPR15MB2727:
x-microsoft-antispam-prvs: <BYAPR15MB2727A3E6D3871880D23F8249D3D70@BYAPR15MB2727.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(14454004)(53936002)(46003)(6486002)(6436002)(31686004)(81156014)(81166006)(25786009)(8676002)(486006)(476003)(4326008)(2616005)(8936002)(11346002)(5660300002)(6512007)(76176011)(446003)(186003)(102836004)(386003)(6506007)(53546011)(7736002)(478600001)(229853002)(305945005)(256004)(2906002)(316002)(71190400001)(52116002)(71200400001)(14444005)(6116002)(6246003)(36756003)(66446008)(64756008)(66556008)(31696002)(66946007)(86362001)(66476007)(54906003)(6916009)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2727;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YPdOGaAEnZItTAGXylUe0IPrlvT5H+uhWrnwVziXmqPYyYEYfYftd1XZyFk23VJ+OGW43ddz2aFm1BtWD3gEFwnyOg12G6iwJxcZMxMn5TJG06GvPvE8ZHVxMjesRKBOB158SV/EWQXdiSFXsyX6Kvw2OVyaB9FO+XRUPHqoqpxz9YsJ5boaDVuh113p6NRv6t2Tmn0v1yYknNGbx8XcH7YdNH4X6PRN+GqxbxC/lTwmbptsQ6QTz2DElyIooaujrq3PyFDND99pWRuHByWn2NCOcYRJpMoqsKbkSYoP9nyUJ3HLrF9m2ayNjPi8nyjA1bYHI4XP/MIfrqhxnO/eDvxjNXwkc/sRxSuyCD4a7X0vmdlpGLppHsuLsIvD3mKkwGnr3N95MoS0FaNtL/ZDDOcbk6D0ry+UYJktnyykFfA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5334C3CB73A1C4D9EB70C73630EB49D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9e7b5a-6419-44d1-0ebb-08d71b960282
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 00:19:00.1694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvNy8xOSA1OjA1IFBNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IE9uIDA4
LzA3LCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4NCj4+DQo+PiBPbiA4LzcvMTkgODo0NyBBTSwg
U3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPj4+IEFkZCBuZXcgaGVscGVyIGJwZl9za19zdG9y
YWdlX2Nsb25lIHdoaWNoIG9wdGlvbmFsbHkgY2xvbmVzIHNrIHN0b3JhZ2UNCj4+PiBhbmQgY2Fs
bCBpdCBmcm9tIGJwZl9za19zdG9yYWdlX2Nsb25lLiBSZXVzZSB0aGUgZ2FwIGluDQo+Pj4gYnBm
X3NrX3N0b3JhZ2VfZWxlbSB0byBzdG9yZSBjbG9uZS9ub24tY2xvbmUgZmxhZy4NCj4+Pg0KPj4+
IENjOiBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQo+Pj4gU2lnbmVkLW9mZi1ieTog
U3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCj4+DQo+PiBJIHRyaWVkIHRvIHNl
ZSB3aGV0aGVyIEkgY2FuIGZpbmQgYW55IG1pc3NpbmcgcmFjZSBjb25kaXRpb25zIGluDQo+PiB0
aGUgY29kZSBidXQgSSBmYWlsZWQuIFNvIGV4Y2VwdCBhIG1pbm9yIGNvbW1lbnRzIGJlbG93LA0K
PiBUaGFua3MgZm9yIGEgcmV2aWV3IQ0KPiANCj4+IEFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5
aHNAZmIuY29tPg0KPj4NCj4+PiAtLS0NCj4+PiAgICBpbmNsdWRlL25ldC9icGZfc2tfc3RvcmFn
ZS5oIHwgIDEwICsrKysNCj4+PiAgICBpbmNsdWRlL3VhcGkvbGludXgvYnBmLmggICAgIHwgICAx
ICsNCj4+PiAgICBuZXQvY29yZS9icGZfc2tfc3RvcmFnZS5jICAgIHwgMTAyICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tDQo+Pj4gICAgbmV0L2NvcmUvc29jay5jICAgICAgICAg
ICAgICB8ICAgOSArKy0tDQo+Pj4gICAgNCBmaWxlcyBjaGFuZ2VkLCAxMTUgaW5zZXJ0aW9ucygr
KSwgNyBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9icGZf
c2tfc3RvcmFnZS5oIGIvaW5jbHVkZS9uZXQvYnBmX3NrX3N0b3JhZ2UuaA0KPj4+IGluZGV4IGI5
ZGNiMDJlNzU2Yi4uOGU0ZjgzMWQyZTUyIDEwMDY0NA0KPj4+IC0tLSBhL2luY2x1ZGUvbmV0L2Jw
Zl9za19zdG9yYWdlLmgNCj4+PiArKysgYi9pbmNsdWRlL25ldC9icGZfc2tfc3RvcmFnZS5oDQo+
Pj4gQEAgLTEwLDQgKzEwLDE0IEBAIHZvaWQgYnBmX3NrX3N0b3JhZ2VfZnJlZShzdHJ1Y3Qgc29j
ayAqc2spOw0KPj4+ICAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3Nr
X3N0b3JhZ2VfZ2V0X3Byb3RvOw0KPj4+ICAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNf
cHJvdG8gYnBmX3NrX3N0b3JhZ2VfZGVsZXRlX3Byb3RvOw0KPj4+ICAgIA0KPj4+ICsjaWZkZWYg
Q09ORklHX0JQRl9TWVNDQUxMDQo+Pj4gK2ludCBicGZfc2tfc3RvcmFnZV9jbG9uZShjb25zdCBz
dHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBzb2NrICpuZXdzayk7DQo+Pj4gKyNlbHNlDQo+Pj4gK3N0
YXRpYyBpbmxpbmUgaW50IGJwZl9za19zdG9yYWdlX2Nsb25lKGNvbnN0IHN0cnVjdCBzb2NrICpz
aywNCj4+PiArCQkJCSAgICAgICBzdHJ1Y3Qgc29jayAqbmV3c2spDQo+Pj4gK3sNCj4+PiArCXJl
dHVybiAwOw0KPj4+ICt9DQo+Pj4gKyNlbmRpZg0KPj4+ICsNCj4+PiAgICAjZW5kaWYgLyogX0JQ
Rl9TS19TVE9SQUdFX0ggKi8NCj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2Jw
Zi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+Pj4gaW5kZXggNDM5M2JkNGIyNDE5Li4w
MDQ1OWNhNGM4Y2YgMTAwNjQ0DQo+Pj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+
Pj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+Pj4gQEAgLTI5MzEsNiArMjkzMSw3
IEBAIGVudW0gYnBmX2Z1bmNfaWQgew0KPj4+ICAgIA0KPj4+ICAgIC8qIEJQRl9GVU5DX3NrX3N0
b3JhZ2VfZ2V0IGZsYWdzICovDQo+Pj4gICAgI2RlZmluZSBCUEZfU0tfU1RPUkFHRV9HRVRfRl9D
UkVBVEUJKDFVTEwgPDwgMCkNCj4+PiArI2RlZmluZSBCUEZfU0tfU1RPUkFHRV9HRVRfRl9DTE9O
RQkoMVVMTCA8PCAxKQ0KPj4+ICAgIA0KPj4+ICAgIC8qIE1vZGUgZm9yIEJQRl9GVU5DX3NrYl9h
ZGp1c3Rfcm9vbSBoZWxwZXIuICovDQo+Pj4gICAgZW51bSBicGZfYWRqX3Jvb21fbW9kZSB7DQo+
Pj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2JwZl9za19zdG9yYWdlLmMgYi9uZXQvY29yZS9icGZf
c2tfc3RvcmFnZS5jDQo+Pj4gaW5kZXggOTRjN2Y3N2VjYjZiLi5iNmRlYTY3OTY1YmMgMTAwNjQ0
DQo+Pj4gLS0tIGEvbmV0L2NvcmUvYnBmX3NrX3N0b3JhZ2UuYw0KPj4+ICsrKyBiL25ldC9jb3Jl
L2JwZl9za19zdG9yYWdlLmMNCj4+PiBAQCAtMTIsNiArMTIsOSBAQA0KPj4+ICAgIA0KPj4+ICAg
IHN0YXRpYyBhdG9taWNfdCBjYWNoZV9pZHg7DQo+Pj4gICAgDQo+Pj4gKyNkZWZpbmUgQlBGX1NL
X1NUT1JBR0VfR0VUX0ZfTUFTSwkoQlBGX1NLX1NUT1JBR0VfR0VUX0ZfQ1JFQVRFIHwgXA0KPj4+
ICsJCQkJCSBCUEZfU0tfU1RPUkFHRV9HRVRfRl9DTE9ORSkNCj4+PiArDQo+Pj4gICAgc3RydWN0
IGJ1Y2tldCB7DQo+Pj4gICAgCXN0cnVjdCBobGlzdF9oZWFkIGxpc3Q7DQo+Pj4gICAgCXJhd19z
cGlubG9ja190IGxvY2s7DQo+Pj4gQEAgLTY2LDcgKzY5LDggQEAgc3RydWN0IGJwZl9za19zdG9y
YWdlX2VsZW0gew0KPj4+ICAgIAlzdHJ1Y3QgaGxpc3Rfbm9kZSBzbm9kZTsJLyogTGlua2VkIHRv
IGJwZl9za19zdG9yYWdlICovDQo+Pj4gICAgCXN0cnVjdCBicGZfc2tfc3RvcmFnZSBfX3JjdSAq
c2tfc3RvcmFnZTsNCj4+PiAgICAJc3RydWN0IHJjdV9oZWFkIHJjdTsNCj4+PiAtCS8qIDggYnl0
ZXMgaG9sZSAqLw0KPj4+ICsJdTggY2xvbmU6MTsNCj4+PiArCS8qIDcgYnl0ZXMgaG9sZSAqLw0K
Pj4+ICAgIAkvKiBUaGUgZGF0YSBpcyBzdG9yZWQgaW4gYW90aGVyIGNhY2hlbGluZSB0byBtaW5p
bWl6ZQ0KPj4+ICAgIAkgKiB0aGUgbnVtYmVyIG9mIGNhY2hlbGluZXMgYWNjZXNzIGR1cmluZyBh
IGNhY2hlIGhpdC4NCj4+PiAgICAJICovDQo+Pj4gQEAgLTUwOSw3ICs1MTMsNyBAQCBzdGF0aWMg
aW50IHNrX3N0b3JhZ2VfZGVsZXRlKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGJwZl9tYXAgKm1h
cCkNCj4+PiAgICAJcmV0dXJuIDA7DQo+Pj4gICAgfQ0KPj4+ICAgIA0KPj4+IC0vKiBDYWxsZWQg
YnkgX19za19kZXN0cnVjdCgpICovDQo+Pj4gKy8qIENhbGxlZCBieSBfX3NrX2Rlc3RydWN0KCkg
JiBicGZfc2tfc3RvcmFnZV9jbG9uZSgpICovDQo+Pj4gICAgdm9pZCBicGZfc2tfc3RvcmFnZV9m
cmVlKHN0cnVjdCBzb2NrICpzaykNCj4+PiAgICB7DQo+Pj4gICAgCXN0cnVjdCBicGZfc2tfc3Rv
cmFnZV9lbGVtICpzZWxlbTsNCj4+PiBAQCAtNzM5LDE5ICs3NDMsMTA2IEBAIHN0YXRpYyBpbnQg
YnBmX2ZkX3NrX3N0b3JhZ2VfZGVsZXRlX2VsZW0oc3RydWN0IGJwZl9tYXAgKm1hcCwgdm9pZCAq
a2V5KQ0KPj4+ICAgIAlyZXR1cm4gZXJyOw0KPj4+ICAgIH0NCj4+PiAgICANCj4+PiArc3RhdGlj
IHN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICoNCj4+PiArYnBmX3NrX3N0b3JhZ2VfY2xvbmVf
ZWxlbShzdHJ1Y3Qgc29jayAqbmV3c2ssDQo+Pj4gKwkJCSAgc3RydWN0IGJwZl9za19zdG9yYWdl
X21hcCAqc21hcCwNCj4+PiArCQkJICBzdHJ1Y3QgYnBmX3NrX3N0b3JhZ2VfZWxlbSAqc2VsZW0p
DQo+Pj4gK3sNCj4+PiArCXN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICpjb3B5X3NlbGVtOw0K
Pj4+ICsNCj4+PiArCWNvcHlfc2VsZW0gPSBzZWxlbV9hbGxvYyhzbWFwLCBuZXdzaywgTlVMTCwg
dHJ1ZSk7DQo+Pj4gKwlpZiAoIWNvcHlfc2VsZW0pDQo+Pj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVO
T01FTSk7DQo+Pj4gKw0KPj4+ICsJaWYgKG1hcF92YWx1ZV9oYXNfc3Bpbl9sb2NrKCZzbWFwLT5t
YXApKQ0KPj4+ICsJCWNvcHlfbWFwX3ZhbHVlX2xvY2tlZCgmc21hcC0+bWFwLCBTREFUQShjb3B5
X3NlbGVtKS0+ZGF0YSwNCj4+PiArCQkJCSAgICAgIFNEQVRBKHNlbGVtKS0+ZGF0YSwgdHJ1ZSk7
DQo+Pj4gKwllbHNlDQo+Pj4gKwkJY29weV9tYXBfdmFsdWUoJnNtYXAtPm1hcCwgU0RBVEEoY29w
eV9zZWxlbSktPmRhdGEsDQo+Pj4gKwkJCSAgICAgICBTREFUQShzZWxlbSktPmRhdGEpOw0KPj4+
ICsNCj4+PiArCXJldHVybiBjb3B5X3NlbGVtOw0KPj4+ICt9DQo+Pj4gKw0KPj4+ICtpbnQgYnBm
X3NrX3N0b3JhZ2VfY2xvbmUoY29uc3Qgc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc29jayAqbmV3
c2spDQo+Pj4gK3sNCj4+PiArCXN0cnVjdCBicGZfc2tfc3RvcmFnZSAqbmV3X3NrX3N0b3JhZ2Ug
PSBOVUxMOw0KPj4+ICsJc3RydWN0IGJwZl9za19zdG9yYWdlICpza19zdG9yYWdlOw0KPj4+ICsJ
c3RydWN0IGJwZl9za19zdG9yYWdlX2VsZW0gKnNlbGVtOw0KPj4+ICsJaW50IHJldDsNCj4+PiAr
DQo+Pj4gKwlSQ1VfSU5JVF9QT0lOVEVSKG5ld3NrLT5za19icGZfc3RvcmFnZSwgTlVMTCk7DQo+
Pj4gKw0KPj4+ICsJcmN1X3JlYWRfbG9jaygpOw0KPj4+ICsJc2tfc3RvcmFnZSA9IHJjdV9kZXJl
ZmVyZW5jZShzay0+c2tfYnBmX3N0b3JhZ2UpOw0KPj4+ICsNCj4+PiArCWlmICghc2tfc3RvcmFn
ZSB8fCBobGlzdF9lbXB0eSgmc2tfc3RvcmFnZS0+bGlzdCkpDQo+Pj4gKwkJZ290byBvdXQ7DQo+
Pj4gKw0KPj4+ICsJaGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KHNlbGVtLCAmc2tfc3RvcmFnZS0+
bGlzdCwgc25vZGUpIHsNCj4+PiArCQlzdHJ1Y3QgYnBmX3NrX3N0b3JhZ2VfbWFwICpzbWFwOw0K
Pj4+ICsJCXN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICpjb3B5X3NlbGVtOw0KPj4+ICsNCj4+
PiArCQlpZiAoIXNlbGVtLT5jbG9uZSkNCj4+PiArCQkJY29udGludWU7DQo+Pj4gKw0KPj4+ICsJ
CXNtYXAgPSByY3VfZGVyZWZlcmVuY2UoU0RBVEEoc2VsZW0pLT5zbWFwKTsNCj4+PiArCQlpZiAo
IXNtYXApDQo+Pj4gKwkJCWNvbnRpbnVlOw0KPj4+ICsNCj4+PiArCQljb3B5X3NlbGVtID0gYnBm
X3NrX3N0b3JhZ2VfY2xvbmVfZWxlbShuZXdzaywgc21hcCwgc2VsZW0pOw0KPj4+ICsJCWlmIChJ
U19FUlIoY29weV9zZWxlbSkpIHsNCj4+PiArCQkJcmV0ID0gUFRSX0VSUihjb3B5X3NlbGVtKTsN
Cj4+PiArCQkJZ290byBlcnI7DQo+Pj4gKwkJfQ0KPj4+ICsNCj4+PiArCQlpZiAoIW5ld19za19z
dG9yYWdlKSB7DQo+Pj4gKwkJCXJldCA9IHNrX3N0b3JhZ2VfYWxsb2MobmV3c2ssIHNtYXAsIGNv
cHlfc2VsZW0pOw0KPj4+ICsJCQlpZiAocmV0KSB7DQo+Pj4gKwkJCQlrZnJlZShjb3B5X3NlbGVt
KTsNCj4+PiArCQkJCWF0b21pY19zdWIoc21hcC0+ZWxlbV9zaXplLA0KPj4+ICsJCQkJCSAgICZu
ZXdzay0+c2tfb21lbV9hbGxvYyk7DQo+Pj4gKwkJCQlnb3RvIGVycjsNCj4+PiArCQkJfQ0KPj4+
ICsNCj4+PiArCQkJbmV3X3NrX3N0b3JhZ2UgPSByY3VfZGVyZWZlcmVuY2UoY29weV9zZWxlbS0+
c2tfc3RvcmFnZSk7DQo+Pj4gKwkJCWNvbnRpbnVlOw0KPj4+ICsJCX0NCj4+PiArDQo+Pj4gKwkJ
cmF3X3NwaW5fbG9ja19iaCgmbmV3X3NrX3N0b3JhZ2UtPmxvY2spOw0KPj4+ICsJCXNlbGVtX2xp
bmtfbWFwKHNtYXAsIGNvcHlfc2VsZW0pOw0KPj4+ICsJCV9fc2VsZW1fbGlua19zayhuZXdfc2tf
c3RvcmFnZSwgY29weV9zZWxlbSk7DQo+Pj4gKwkJcmF3X3NwaW5fdW5sb2NrX2JoKCZuZXdfc2tf
c3RvcmFnZS0+bG9jayk7DQo+Pg0KPj4gQ29uc2lkZXJpbmcgaW4gdGhpcyBwYXJ0aWN1bGFyIGNh
c2UsIG5ldyBzb2NrZXQgaXMgbm90IHZpc2libGUgdG8NCj4+IG91dHNpZGUgd29ybGQgeWV0IChi
b3RoIGtlcm5lbCBhbmQgdXNlciBzcGFjZSksIG1hcF9kZWxldGUvbWFwX3VwZGF0ZQ0KPj4gb3Bl
cmF0aW9ucyBhcmUgbm90IGFwcGxpY2FibGUgaW4gdGhpcyBzaXR1YXRpb24sIHNvDQo+PiB0aGUg
YWJvdmUgcmF3X3NwaW5fbG9ja19iaCgpIHByb2JhYmx5IG5vdCBuZWVkZWQuDQo+IEkgYWdyZWUs
IGl0J3MgZG9pbmcgbm90aGluZywgYnV0IF9fc2VsZW1fbGlua19zayBoYXMgdGhlIGZvbGxvd2lu
ZyBjb21tZW50Og0KPiAvKiBza19zdG9yYWdlLT5sb2NrIG11c3QgYmUgaGVsZCBhbmQgc2tfc3Rv
cmFnZS0+bGlzdCBjYW5ub3QgYmUgZW1wdHkgKi8NCj4gDQo+IEp1c3Qgd2FudGVkIHRvIGtlZXAg
dGhhdCBpbnZhcmlhbnQgZm9yIHRoaXMgY2FsbCBzaXRlIGFzIHdlbGwgKGluIGNhc2UNCj4gd2Ug
YWRkIHNvbWUgbG9ja2RlcCBlbmZvcmNlbWVudCBvciBzbXRoIGVsc2UpLiBXRFlUPw0KDQpBZ3Jl
ZS4gTGV0IHVzIGtlZXAgdGhlIGxvY2tpbmcgdG8gYmUgY29uc2lzdGVudCB3aXRoIG90aGVyIHVz
ZXMgaW4NCnRoZSBzYW1lIGZpbGUuIFRoaXMgaXMgbm90IHRoZSBjcml0aWNhbCBwYXRoLg0KDQo=
