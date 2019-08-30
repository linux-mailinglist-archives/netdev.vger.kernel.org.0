Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFCA409F
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfH3WjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:39:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728143AbfH3WjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:39:04 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMcdx3017982;
        Fri, 30 Aug 2019 15:38:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ypyap/SMQesWT9pyf2WmBWqZsovzUfzFD0EqFoapLRU=;
 b=WUcM2YP79YECqeLtW5tO9ECRy/6kcFGEForS3aH9Io8Kx5SvLveFuuh07RRBEUoe8iIL
 Gj3iqGVidSBErLXF8OSZHhnrG1ZYwI3i8e3uQHPaiCVFLQLMjZV5eX5zUTcp7I4dbQE0
 VAMqYpFAWNaaE9bWSoIjqakf1AyOjGhAHIg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uq6bra08x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:38:39 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 15:38:18 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 30 Aug 2019 15:38:18 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 15:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfRGImxRN9JWJ9FKC3vYYLsk2MZG2zm5WZtfLTXwO79B/HIya7+6SLHJUrKvjPhBkIyDKX6nYybolvR50P9ApAX/NwC/j6utQPiCJ1XHWMVHovw/EYMzFQTXi1f+Ay4MUzyEYIPygB+ofh6TB+1wOHNOFr1btf+6heukRvFqximVJui9UcCtcjGgAghIugRAtooZpHKXIZOymFat91Fh7RSawgyTxWUMj5R8Uib+PislWPgNAk/v7XzcGI1vG48QC7pDTZyjjaUL9m6h+QuH1wDqvmVHGxTT0Fe7gXeqevmm2NSUM21ZffIvuO9T+o1A1NjJxjzukE8YajTk0l9tlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypyap/SMQesWT9pyf2WmBWqZsovzUfzFD0EqFoapLRU=;
 b=UEeuD7pFJoXBayGUlu5CUNt/lEHRBrBduqNLL1+ukpB5OKEQjWrqG2ZwLszoRJj6+nRAPBF2s4pQvz7ATwtwILjsIhmF1q+AGozNGhTquImHeZ6Rua7KqFTfAz0rfWwvemSDaHrZt+uo3cISXpnH9tB2CyfF1wQxTdSVXVH44fEcZG82Wb9ekQ9cEAwY/bq8KuWTlN2tPwp51d4KjfR6IIYyDVLIbhxWztv6buvafdln6h6l4XfTpPL/kPFtJmPI8fGIc3nGi/Sn4A3YQ7QQAfzBrrnRxQzmvgJy7/oWS0ysBpOA6jtm+GXyk6QCKUdbjlHVR6v/FvvLB0W2uZAMHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypyap/SMQesWT9pyf2WmBWqZsovzUfzFD0EqFoapLRU=;
 b=ID8QZx3PyLxnjQrT51u0mS9IHf0pJ+8yefTM201+NddOmGDYpdv6B+KevLnAfNwZNETqriXOsGF0rogBBF2Gw+HWLZg9kX2xzVz9qQSwCKtZr0OektShd0IqhgrsJUbXbGLX+4eXu40AzSRlU37hQK1UH3BCxyNvXVXQsAAnQZI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2229.namprd15.prod.outlook.com (52.135.194.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Fri, 30 Aug 2019 22:38:16 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 22:38:16 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Topic: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Index: AQHVXjVV7RBe3Y+1zUuAbrXegepHf6cSdccAgADWGgCAAO1LAIAAEaCA
Date:   Fri, 30 Aug 2019 22:38:16 +0000
Message-ID: <7ba9b492-8a08-a1d0-9c6e-03be4b8e5e07@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <a3422ffd-e9f2-af77-a92d-81393a9f4fc7@fb.com>
 <20190830143508.73c30631@cakuba.netronome.com>
In-Reply-To: <20190830143508.73c30631@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0005.namprd17.prod.outlook.com
 (2603:10b6:301:14::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:dd98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ae7695c-059b-4cfa-95a6-08d72d9abfe1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2229;
x-ms-traffictypediagnostic: BYAPR15MB2229:
x-ms-exchange-purlcount: 5
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2229D1BF2F8F47BFD91B3178D3BD0@BYAPR15MB2229.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(31696002)(46003)(86362001)(11346002)(446003)(486006)(186003)(386003)(102836004)(53546011)(2616005)(6506007)(476003)(31686004)(6116002)(6436002)(6512007)(54906003)(99286004)(76176011)(6306002)(316002)(5660300002)(256004)(53936002)(14444005)(4326008)(71190400001)(25786009)(71200400001)(52116002)(6246003)(229853002)(36756003)(8936002)(81166006)(81156014)(8676002)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(2906002)(6486002)(966005)(14454004)(6916009)(7736002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2229;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: enmkBCJh71fioQQ1KWs218stn5LmZFk+mob7Pb+AYx6Ti/kDYzFM1lNsogyS3owICfVIMddhXjbhnnUuVVGMD3Ybe8NsjhFhKJqzbKPSBxIkfiU9YU4P9UUQ/XXza580f+lo6LMVefxggd7UHcjtUjgKm4I6HYMOe9CpNBm7xelKEtS422Zpj8syW5MPLGw1yKB6eOLzH/3BhofHXSkzUEYmLGe9yF68TUpxPl2HxW0eJS4Rw/kszFrUPqUggB81lewCdCVb8DwD6QNOlSPZB9dnCbdWtXxRFJAWb3ifLIck9fA/oFurgTmAvZi/gOXI8Wd50j5/5xwINhhUR2PxBWLXlEcRUaiBOb7qNYJ+B5TrlSSHsvCXR6hLQrO2se/mBQCBhxqs577RFEvdyYU9AkBJx+khadZzWTPZ6719j6w=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1745A116ED720498AB1CCB1D7145174@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae7695c-059b-4cfa-95a6-08d72d9abfe1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 22:38:16.5559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qv5S7RXSGMShncLmtw9b0tMHT6FqZsElhCBPX4hmWMs8KrzF5maCYfjwcja0ySCI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2229
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300220
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMzAvMTkgMjozNSBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwg
MzAgQXVnIDIwMTkgMDc6MjU6NTQgKzAwMDAsIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+PiBPbiA4
LzI5LzE5IDExOjM5IEFNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+PiBPbiBXZWQsIDI4IEF1
ZyAyMDE5IDIzOjQ1OjAyIC0wNzAwLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPj4+PiBCcmlhbiBW
YXpxdWV6IGhhcyBwcm9wb3NlZCBCUEZfTUFQX0RVTVAgY29tbWFuZCB0byBsb29rIHVwIG1vcmUg
dGhhbiBvbmUNCj4+Pj4gbWFwIGVudHJpZXMgcGVyIHN5c2NhbGwuDQo+Pj4+ICAgICBodHRwczov
L2xvcmUua2VybmVsLm9yZy9icGYvQ0FCQ2dwYVUzeHhYNkNNTXhEKzFrbkFwaXZ0YzJqTEJIeXNE
WHctMEU5YlFFTDBxQzNBQG1haWwuZ21haWwuY29tL1QvI3QNCj4+Pj4NCj4+Pj4gRHVyaW5nIGRp
c2N1c3Npb24sIHdlIGZvdW5kIG1vcmUgdXNlIGNhc2VzIGNhbiBiZSBzdXBwb3J0ZWQgaW4gYSBz
aW1pbGFyDQo+Pj4+IG1hcCBvcGVyYXRpb24gYmF0Y2hpbmcgZnJhbWV3b3JrLiBGb3IgZXhhbXBs
ZSwgYmF0Y2hlZCBtYXAgbG9va3VwIGFuZCBkZWxldGUsDQo+Pj4+IHdoaWNoIGNhbiBiZSByZWFs
bHkgaGVscGZ1bCBmb3IgYmNjLg0KPj4+PiAgICAgaHR0cHM6Ly9naXRodWIuY29tL2lvdmlzb3Iv
YmNjL2Jsb2IvbWFzdGVyL3Rvb2xzL3RjcHRvcC5weSNMMjMzLUwyNDMNCj4+Pj4gICAgIGh0dHBz
Oi8vZ2l0aHViLmNvbS9pb3Zpc29yL2JjYy9ibG9iL21hc3Rlci90b29scy9zbGFicmF0ZXRvcC5w
eSNMMTI5LUwxMzgNCj4+Pj4gICAgICAgDQo+Pj4+IEFsc28sIGluIGJjYywgd2UgaGF2ZSBBUEkg
dG8gZGVsZXRlIGFsbCBlbnRyaWVzIGluIGEgbWFwLg0KPj4+PiAgICAgaHR0cHM6Ly9naXRodWIu
Y29tL2lvdmlzb3IvYmNjL2Jsb2IvbWFzdGVyL3NyYy9jYy9hcGkvQlBGVGFibGUuaCNMMjU3LUwy
NjQNCj4+Pj4NCj4+Pj4gRm9yIG1hcCB1cGRhdGUsIGJhdGNoZWQgb3BlcmF0aW9ucyBhbHNvIHVz
ZWZ1bCBhcyBzb21ldGltZXMgYXBwbGljYXRpb25zIG5lZWQNCj4+Pj4gdG8gcG9wdWxhdGUgaW5p
dGlhbCBtYXBzIHdpdGggbW9yZSB0aGFuIG9uZSBlbnRyeS4gRm9yIGV4YW1wbGUsIHRoZSBiZWxv
dw0KPj4+PiBleGFtcGxlIGlzIGZyb20ga2VybmVsL3NhbXBsZXMvYnBmL3hkcF9yZWRpcmVjdF9j
cHVfdXNlci5jOg0KPj4+PiAgICAgaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2Js
b2IvbWFzdGVyL3NhbXBsZXMvYnBmL3hkcF9yZWRpcmVjdF9jcHVfdXNlci5jI0w1NDMtTDU1MA0K
Pj4+Pg0KPj4+PiBUaGlzIHBhdGNoIGFkZHJlc3NlcyBhbGwgdGhlIGFib3ZlIHVzZSBjYXNlcy4g
VG8gbWFrZSB1YXBpIHN0YWJsZSwgaXQgYWxzbw0KPj4+PiBjb3ZlcnMgb3RoZXIgcG90ZW50aWFs
IHVzZSBjYXNlcy4gRm91ciBicGYgc3lzY2FsbCBzdWJjb21tYW5kcyBhcmUgaW50cm9kdWNlZDoN
Cj4+Pj4gICAgICAgQlBGX01BUF9MT09LVVBfQkFUQ0gNCj4+Pj4gICAgICAgQlBGX01BUF9MT09L
VVBfQU5EX0RFTEVURV9CQVRDSA0KPj4+PiAgICAgICBCUEZfTUFQX1VQREFURV9CQVRDSA0KPj4+
PiAgICAgICBCUEZfTUFQX0RFTEVURV9CQVRDSA0KPj4+Pg0KPj4+PiBJbiB1c2Vyc3BhY2UsIGFw
cGxpY2F0aW9uIGNhbiBpdGVyYXRlIHRocm91Z2ggdGhlIHdob2xlIG1hcCBvbmUgYmF0Y2gNCj4+
Pj4gYXMgYSB0aW1lLCBlLmcuLCBicGZfbWFwX2xvb2t1cF9iYXRjaCgpIGluIHRoZSBiZWxvdzoN
Cj4+Pj4gICAgICAgcF9rZXkgPSBOVUxMOw0KPj4+PiAgICAgICBwX25leHRfa2V5ID0gJmtleTsN
Cj4+Pj4gICAgICAgd2hpbGUgKHRydWUpIHsNCj4+Pj4gICAgICAgICAgZXJyID0gYnBmX21hcF9s
b29rdXBfYmF0Y2goZmQsIHBfa2V5LCAmcF9uZXh0X2tleSwga2V5cywgdmFsdWVzLA0KPj4+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmYmF0Y2hfc2l6ZSwgZWxlbV9mbGFn
cywgZmxhZ3MpOw0KPj4+PiAgICAgICAgICBpZiAoZXJyKSAuLi4NCj4+Pj4gICAgICAgICAgaWYg
KHBfbmV4dF9rZXkpIGJyZWFrOyAvLyBkb25lDQo+Pj4+ICAgICAgICAgIGlmICghcF9rZXkpIHBf
a2V5ID0gcF9uZXh0X2tleTsNCj4+Pj4gICAgICAgfQ0KPj4+PiBQbGVhc2UgbG9vayBhdCBpbmRp
dmlkdWFsIHBhdGNoZXMgZm9yIGRldGFpbHMgb2YgbmV3IHN5c2NhbGwgc3ViY29tbWFuZHMNCj4+
Pj4gYW5kIGV4YW1wbGVzIG9mIHVzZXIgY29kZXMuDQo+Pj4+DQo+Pj4+IFRoZSB0ZXN0aW5nIGlz
IGFsc28gZG9uZSBpbiBhIHFlbXUgVk0gZW52aXJvbm1lbnQ6DQo+Pj4+ICAgICAgICAgbWVhc3Vy
ZV9sb29rdXA6IG1heF9lbnRyaWVzIDEwMDAwMDAsIGJhdGNoIDEwLCB0aW1lIDM0Mm1zDQo+Pj4+
ICAgICAgICAgbWVhc3VyZV9sb29rdXA6IG1heF9lbnRyaWVzIDEwMDAwMDAsIGJhdGNoIDEwMDAs
IHRpbWUgMjk1bXMNCj4+Pj4gICAgICAgICBtZWFzdXJlX2xvb2t1cDogbWF4X2VudHJpZXMgMTAw
MDAwMCwgYmF0Y2ggMTAwMDAwMCwgdGltZSAyNzBtcw0KPj4+PiAgICAgICAgIG1lYXN1cmVfbG9v
a3VwOiBtYXhfZW50cmllcyAxMDAwMDAwLCBubyBiYXRjaGluZywgdGltZSAxMzQ2bXMNCj4+Pj4g
ICAgICAgICBtZWFzdXJlX2xvb2t1cF9kZWxldGU6IG1heF9lbnRyaWVzIDEwMDAwMDAsIGJhdGNo
IDEwLCB0aW1lIDQzM21zDQo+Pj4+ICAgICAgICAgbWVhc3VyZV9sb29rdXBfZGVsZXRlOiBtYXhf
ZW50cmllcyAxMDAwMDAwLCBiYXRjaCAxMDAwLCB0aW1lIDM2M21zDQo+Pj4+ICAgICAgICAgbWVh
c3VyZV9sb29rdXBfZGVsZXRlOiBtYXhfZW50cmllcyAxMDAwMDAwLCBiYXRjaCAxMDAwMDAwLCB0
aW1lIDM1N21zDQo+Pj4+ICAgICAgICAgbWVhc3VyZV9sb29rdXBfZGVsZXRlOiBtYXhfZW50cmll
cyAxMDAwMDAwLCBub3QgYmF0Y2gsIHRpbWUgMTg5NG1zDQo+Pj4+ICAgICAgICAgbWVhc3VyZV9k
ZWxldGU6IG1heF9lbnRyaWVzIDEwMDAwMDAsIGJhdGNoLCB0aW1lIDIyMG1zDQo+Pj4+ICAgICAg
ICAgbWVhc3VyZV9kZWxldGU6IG1heF9lbnRyaWVzIDEwMDAwMDAsIG5vdCBiYXRjaCwgdGltZSAx
Mjg5bXMNCj4+Pj4gRm9yIGEgMU0gZW50cnkgaGFzaCB0YWJsZSwgYmF0Y2ggc2l6ZSBvZiAxMCBj
YW4gcmVkdWNlIGNwdSB0aW1lDQo+Pj4+IGJ5IDcwJS4gUGxlYXNlIHNlZSBwYXRjaCAidG9vbHMv
YnBmOiBtZWFzdXJlIG1hcCBiYXRjaGluZyBwZXJmIg0KPj4+PiBmb3IgZGV0YWlscyBvZiB0ZXN0
IGNvZGVzLg0KPj4+DQo+Pj4gSGkgWW9uZ2hvbmchDQo+Pj4NCj4+PiBncmVhdCB0byBzZWUgdGhp
cywgd2UgaGF2ZSBiZWVuIGxvb2tpbmcgYXQgaW1wbGVtZW50aW5nIHNvbWUgd2F5IHRvDQo+Pj4g
c3BlZWQgdXAgbWFwIHdhbGtzIGFzIHdlbGwuDQo+Pj4NCj4+PiBUaGUgZGlyZWN0aW9uIHdlIHdl
cmUgbG9va2luZyBpbiwgYWZ0ZXIgcHJldmlvdXMgZGlzY3Vzc2lvbnMgWzFdLA0KPj4+IGhvd2V2
ZXIsIHdhcyB0byBwcm92aWRlIGEgQlBGIHByb2dyYW0gd2hpY2ggY2FuIHJ1biB0aGUgbG9naWMg
ZW50aXJlbHkNCj4+PiB3aXRoaW4gdGhlIGtlcm5lbC4NCj4+Pg0KPj4+IFdlIGhhdmUgYSByb3Vn
aCBQb0Mgb24gdGhlIEZXIHNpZGUgKHdlIGNhbiBvZmZsb2FkIHRoZSBwcm9ncmFtIHdoaWNoDQo+
Pj4gd2Fsa3MgdGhlIG1hcCwgd2hpY2ggaXMgcHJldHR5IG5lYXQpLCBidXQgdGhlIGtlcm5lbCB2
ZXJpZmllciBzaWRlDQo+Pj4gaGFzbid0IHJlYWxseSBwcm9ncmVzc2VkLiBJdCB3aWxsIHNvb24u
DQo+Pj4NCj4+PiBUaGUgcm91Z2ggaWRlYSBpcyB0aGF0IHRoZSB1c2VyIHNwYWNlIHByb3ZpZGVz
IHR3byBwcm9ncmFtcywgImZpbHRlciINCj4+PiBhbmQgImR1bXBlciI6DQo+Pj4NCj4+PiAJYnBm
dG9vbCBtYXAgZXhlYyBpZCBYWVogZmlsdGVyIHBpbm5lZCAvc29tZS9wcm9nIFwNCj4+PiAJCQkJ
ZHVtcGVyIHBpbm5lZCAvc29tZS9vdGhlcl9wcm9nDQo+Pj4NCj4+PiBCb3RoIHByb2dyYW1zIGdl
dCB0aGlzIGNvbnRleHQ6DQo+Pj4NCj4+PiBzdHJ1Y3QgbWFwX29wX2N0eCB7DQo+Pj4gCXU2NCBr
ZXk7DQo+Pj4gCXU2NCB2YWx1ZTsNCj4+PiB9DQo+Pj4NCj4+PiBXZSBuZWVkIGEgcGVyLW1hcCBp
bXBsZW1lbnRhdGlvbiBvZiB0aGUgZXhlYyBzaWRlLCBidXQgcm91Z2hseSBtYXBzDQo+Pj4gd291
bGQgZG86DQo+Pj4NCj4+PiAJTElTVF9IRUFEKGRlbGV0ZWQpOw0KPj4+DQo+Pj4gCWZvciBlbnRy
eSBpbiBtYXAgew0KPj4+IAkJc3RydWN0IG1hcF9vcF9jdHggew0KPj4+IAkJCS5rZXkJPSBlbnRy
eS0+a2V5LA0KPj4+IAkJCS52YWx1ZQk9IGVudHJ5LT52YWx1ZSwNCj4+PiAJCX07DQo+Pj4NCj4+
PiAJCWFjdCA9IEJQRl9QUk9HX1JVTihmaWx0ZXIsICZtYXBfb3BfY3R4KTsNCj4+PiAJCWlmIChh
Y3QgJiB+QUNUX0JJVFMpDQo+Pj4gCQkJcmV0dXJuIC1FSU5WQUw7DQo+Pj4NCj4+PiAJCWlmIChh
Y3QgJiBERUxFVEUpIHsNCj4+PiAJCQltYXBfdW5saW5rKGVudHJ5KTsNCj4+PiAJCQlsaXN0X2Fk
ZChlbnRyeSwgJmRlbGV0ZWQpOw0KPj4+IAkJfQ0KPj4+IAkJaWYgKGFjdCAmIFNUT1ApDQo+Pj4g
CQkJYnJlYWs7DQo+Pj4gCX0NCj4+Pg0KPj4+IAlzeW5jaHJvbml6ZV9yY3UoKTsNCj4+Pg0KPj4+
IAlmb3IgZW50cnkgaW4gZGVsZXRlZCB7DQo+Pj4gCQlzdHJ1Y3QgbWFwX29wX2N0eCB7DQo+Pj4g
CQkJLmtleQk9IGVudHJ5LT5rZXksDQo+Pj4gCQkJLnZhbHVlCT0gZW50cnktPnZhbHVlLA0KPj4+
IAkJfTsNCj4+PiAJCQ0KPj4+IAkJQlBGX1BST0dfUlVOKGR1bXBlciwgJm1hcF9vcF9jdHgpOw0K
Pj4+IAkJbWFwX2ZyZWUoZW50cnkpOw0KPj4+IAl9DQo+Pj4NCj4+PiBUaGUgZmlsdGVyIHByb2dy
YW0gY2FuJ3QgcGVyZm9ybSBhbnkgbWFwIG9wZXJhdGlvbnMgb3RoZXIgdGhhbiBsb29rdXAsDQo+
Pj4gb3RoZXJ3aXNlIHdlIHdvbid0IGJlIGFibGUgdG8gZ3VhcmFudGVlIHRoYXQgd2UnbGwgd2Fs
ayB0aGUgZW50aXJlIG1hcA0KPj4+IChpZiB0aGUgZmlsdGVyIHByb2dyYW0gZGVsZXRlcyBzb21l
IGVudHJpZXMgaW4gYSB1bmZvcnR1bmF0ZSBvcmRlcikuDQo+Pg0KPj4gTG9va3MgbGlrZSB5b3Ug
d2lsbCBwcm92aWRlIGEgbmV3IHByb2dyYW0gdHlwZSBhbmQgcGVyLW1hcA0KPj4gaW1wbGVtZW50
YXRpb24gb2YgYWJvdmUgY29kZS4gTXkgcGF0Y2ggc2V0IGluZGVlZCBhdm9pZGVkIHBlci1tYXAN
Cj4+IGltcGxlbWVudGF0aW9uIGZvciBhbGwgb2YgbG9va3VwL2RlbGV0ZS9nZXQtbmV4dC1rZXku
Li4NCj4gDQo+IEluZGVlZCwgdGhlIHNpbXBsZSBiYXRjaGVkIG9wcyBhcmUgdW5kZW5pYWJseSBs
b3dlciBMb0MuDQo+IA0KPj4+IElmIHVzZXIgc3BhY2UganVzdCB3YW50cyBhIHB1cmUgZHVtcCBp
dCBjYW4gc2ltcGx5IGxvYWQgYSBwcm9ncmFtIHdoaWNoDQo+Pj4gZHVtcHMgdGhlIGVudHJpZXMg
aW50byBhIHBlcmYgcmluZy4NCj4+DQo+PiBwZXJjcHUgcGVyZiByaW5nIGlzIG5vdCByZWFsbHkg
aWRlYWwgZm9yIHVzZXIgc3BhY2Ugd2hpY2ggc2ltcGx5IGp1c3QNCj4+IHdhbnQgdG8gZ2V0IHNv
bWUga2V5L3ZhbHVlIHBhaXJzIGJhY2suIFNvbWUga2luZCBvZiBnZW5lcmF0ZSBub24tcGVyLWNw
dQ0KPj4gcmluZyBidWZmZXIgbWlnaHQgYmUgYmV0dGVyIGZvciBzdWNoIGNhc2VzLg0KPiANCj4g
SSBkb24ndCB0aGluayBpdCBoYWQgdG8gYmUgcGVyLWNwdSwgYnV0IEkgbWF5IGJlIGJsaXNzZnVs
bHkgaWdub3JhbnQNCj4gYWJvdXQgdGhlIHBlcmYgcmluZyBkZXRhaWxzIDopIGJwZl9wZXJmX2V2
ZW50X291dHB1dCgpIHRha2VzIGZsYWdzLA0KPiB3aGljaCBhcmUgZWZmZWN0aXZlbHkgc2VsZWN0
aW5nIHRoZSAib3V0cHV0IENQVSIsIG5vPw0KDQpSaWdodCwgaXQgZG9lcyBub3QgbmVlZCB0byBi
ZSBwZXItY3B1LiBPbmUgcGFydGljdWxhciBjcHUNCmNhbiBiZSBzZWxlY3RlZC4gQmluZGluZyB0
byB3aGljaCBjcHUgbWlnaHQgYmUgYWx3YXlzDQpzdWJqZWN0IHRvIGRlYmF0ZSBsaWtlIHdoeSB0
aGlzIGNwdSwgbm90IGFub3RoZXIgY3B1Lg0KVGhpcyB3b3JrcywgYW5kIEkgYW0ganVzdCB0aGlu
a2luZyBhIHJpbmcgYnVmZmVyIHdpdGhvdXQNCmJpbmRpbmcgdG8gY3B1IGlzIGJldHRlciBhbmQg
bGVzcyBjb25mdXNpb24gdG8gdXNlci4NCkJ1dCB0aGlzIG1heSBuZWVkIHlldCBhbm90aGVyIHJp
bmcgYnVmZmVyIGltcGxlbWVudGF0aW9uDQppbiB0aGUga2VybmVsIGFuZCBwZW9wbGUgbWlnaHQg
bm90IGxpa2UgaXQuDQo=
