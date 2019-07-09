Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F097C62FA3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 06:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfGIEak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 00:30:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbfGIEaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 00:30:39 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x694U61v026823;
        Mon, 8 Jul 2019 21:30:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9SxiEg7OUT+fwjTunUhPh0zZNz/vBuGzbUoAnka1mI8=;
 b=e0QTIdLJT0sgomkCMqd7hUMh5b4bgtw2UvcGOcJu/bUBsKewf9jF6rZUTlPzbp01T/2X
 8/VQEr912iilg3Y467tFnamjdOb7LRstIprcbtoq2ObE8ISAal2dfYiCCBQBH6uG4Vvs
 05bAaZKLyOPgsHpQ4LZacXc9xQL/Cax/LV0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tmebu0wrc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 21:30:18 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 8 Jul 2019 21:30:17 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 8 Jul 2019 21:30:17 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 8 Jul 2019 21:30:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SxiEg7OUT+fwjTunUhPh0zZNz/vBuGzbUoAnka1mI8=;
 b=nB1gPQ0/YXF/AebYMEHJ6xVW065/DxXM75iNLZ8NxqaFMn98VO7KuatNafVJVk3iMvUOpCfjwYKhlTZiBXWOrDNYDGGh1U4FJ022osxyjNXdti0X7EVneK3NFRGcoDssy53cokSmBA5MCpOp60OkGSJpxxw+lP4nsGrKkHh78hQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2423.namprd15.prod.outlook.com (52.135.198.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.20; Tue, 9 Jul 2019 04:30:15 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 04:30:15 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: fix ptr to u64 conversion warning on
 32-bit platforms
Thread-Topic: [PATCH bpf-next] libbpf: fix ptr to u64 conversion warning on
 32-bit platforms
Thread-Index: AQHVNgric3OeXG06AkuEFVGe9Esrg6bBseYA
Date:   Tue, 9 Jul 2019 04:30:15 +0000
Message-ID: <b4b00fad-3f99-c36a-a510-0b281a1f2bd7@fb.com>
References: <20190709040007.1665882-1-andriin@fb.com>
In-Reply-To: <20190709040007.1665882-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0069.namprd16.prod.outlook.com
 (2603:10b6:907:1::46) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:a38d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d906593c-fef1-4e4f-d339-08d7042623cc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2423;
x-ms-traffictypediagnostic: BYAPR15MB2423:
x-microsoft-antispam-prvs: <BYAPR15MB24234D3B3B897CB9FBAF806DD3F10@BYAPR15MB2423.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(396003)(366004)(39860400002)(199004)(189003)(36756003)(478600001)(7736002)(73956011)(6116002)(5024004)(256004)(46003)(5660300002)(14454004)(66556008)(64756008)(71190400001)(6636002)(71200400001)(52116002)(305945005)(66476007)(8676002)(66446008)(66946007)(81156014)(229853002)(86362001)(31696002)(6512007)(6486002)(81166006)(2906002)(53546011)(6506007)(386003)(102836004)(53936002)(186003)(6246003)(2201001)(6436002)(8936002)(99286004)(110136005)(2501003)(31686004)(25786009)(11346002)(446003)(68736007)(76176011)(316002)(486006)(2616005)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2423;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d/UddKsmdDX3EiqdYX8r/GBntyOF+H5/fy1qlD2qQUVprD0lGyo/JprPP4AdKhPL/st0eAR4zVdQ845Sx31X236SUth1mfxuk4szf4yjEbA8cE9sMFJfe4reSM+/nLmaBrnKS68PgqIt5kQnkj9FIdmon1wJxrf/Wbqi/us8OmK2fwuavxR4deSpEXpANnfip7FycHEeoILPKV1kCjYEsdOVKtaq/+Iza3kFXnm23nwzdltU6VglJrMiGhG7xVNac/TR4cqUuIBuvzuBKpMeMvLV+wgnd69NuV1Xg7Tzi7WcxxF4eF3Z3gtjmbaB8Ztq+Ll46v2pQQnzP6JWx80YYrclyASJo3jQmlRqHS9AJxl/9BshU204bim44E8+zGgU7n+PIy53Ekq7tBXhXPM07NHpAwD4B0zdI6I9REfkzz0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5C2CB38EAD3B74BA25DEB8491CC34AB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d906593c-fef1-4e4f-d339-08d7042623cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 04:30:15.4297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2423
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvOC8xOSA5OjAwIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIDMyLWJp
dCBwbGF0Zm9ybXMgY29tcGlsZXIgY29tcGxhaW5zIGFib3V0IGNvbnZlcnNpb246DQo+IA0KPiBs
aWJicGYuYzogSW4gZnVuY3Rpb24g4oCYcGVyZl9ldmVudF9vcGVuX3Byb2Jl4oCZOg0KPiBsaWJi
cGYuYzo0MTEyOjE3OiBlcnJvcjogY2FzdCBmcm9tIHBvaW50ZXIgdG8gaW50ZWdlciBvZiBkaWZm
ZXJlbnQNCj4gc2l6ZSBbLVdlcnJvcj1wb2ludGVyLXRvLWludC1jYXN0XQ0KPiAgICBhdHRyLmNv
bmZpZzEgPSAodWludDY0X3QpKHZvaWQgKiluYW1lOyAvKiBrcHJvYmVfZnVuYyBvciB1cHJvYmVf
cGF0aCAqLw0KPiAgICAgICAgICAgICAgICAgICBeDQo+IA0KPiBSZXBvcnRlZC1ieTogTWF0dCBI
YXJ0IDxtYXR0aGV3LmhhcnRAbGluYXJvLm9yZz4NCj4gRml4ZXM6IGIyNjUwMDI3NDc2NyAoImxp
YmJwZjogYWRkIGtwcm9iZS91cHJvYmUgYXR0YWNoIEFQSSIpDQo+IFRlc3RlZC1ieTogTWF0dCBI
YXJ0IDxtYXR0aGV3LmhhcnRAbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5h
a3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0Bm
Yi5jb20+DQoNCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyB8IDQgKystLQ0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuYyBiL3Rvb2xzL2xpYi9icGYvbGliYnBm
LmMNCj4gaW5kZXggZWQwNzc4OWIzZTYyLi43OTRkZDUwNjRhZTggMTAwNjQ0DQo+IC0tLSBhL3Rv
b2xzL2xpYi9icGYvbGliYnBmLmMNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYuYw0KPiBA
QCAtNDEyNiw4ICs0MTI2LDggQEAgc3RhdGljIGludCBwZXJmX2V2ZW50X29wZW5fcHJvYmUoYm9v
bCB1cHJvYmUsIGJvb2wgcmV0cHJvYmUsIGNvbnN0IGNoYXIgKm5hbWUsDQo+ICAgCX0NCj4gICAJ
YXR0ci5zaXplID0gc2l6ZW9mKGF0dHIpOw0KPiAgIAlhdHRyLnR5cGUgPSB0eXBlOw0KPiAtCWF0
dHIuY29uZmlnMSA9ICh1aW50NjRfdCkodm9pZCAqKW5hbWU7IC8qIGtwcm9iZV9mdW5jIG9yIHVw
cm9iZV9wYXRoICovDQo+IC0JYXR0ci5jb25maWcyID0gb2Zmc2V0OwkJICAgICAgIC8qIGtwcm9i
ZV9hZGRyIG9yIHByb2JlX29mZnNldCAqLw0KPiArCWF0dHIuY29uZmlnMSA9IHB0cl90b191NjQo
bmFtZSk7IC8qIGtwcm9iZV9mdW5jIG9yIHVwcm9iZV9wYXRoICovDQo+ICsJYXR0ci5jb25maWcy
ID0gb2Zmc2V0OwkJIC8qIGtwcm9iZV9hZGRyIG9yIHByb2JlX29mZnNldCAqLw0KPiAgIA0KPiAg
IAkvKiBwaWQgZmlsdGVyIGlzIG1lYW5pbmdmdWwgb25seSBmb3IgdXByb2JlcyAqLw0KPiAgIAlw
ZmQgPSBzeXNjYWxsKF9fTlJfcGVyZl9ldmVudF9vcGVuLCAmYXR0ciwNCj4gDQo=
