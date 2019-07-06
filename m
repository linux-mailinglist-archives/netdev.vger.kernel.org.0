Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA4560F0F
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 07:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfGFFRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 01:17:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbfGFFRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 01:17:51 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x665HBCH028850;
        Fri, 5 Jul 2019 22:17:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NJK9+DOfeekDeTtp3GDPmeDr8IH6NO29PGBDRHtPGb4=;
 b=ggdQEpz/v/hIHu6mHMHw0NIvlsV92Zjz/34Cz1CGow28UUhftvwpOVfKaqgeIe/KTCR5
 GApWLP0YfZmAO13cZFLWQsdxDur/i9pDQpYUthP30YERE+yh4LeHeN4/bU+FBKE/Cnvq
 UVJzbBf/IQUdNBfJ3JLDxTc2/YGg9gRgFxg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2tj81v2cdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Jul 2019 22:17:31 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 5 Jul 2019 22:17:30 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 5 Jul 2019 22:17:30 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 5 Jul 2019 22:17:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJK9+DOfeekDeTtp3GDPmeDr8IH6NO29PGBDRHtPGb4=;
 b=V+A+cFwTiOuatAtiKfqjDSenBl04kTsCo3PfTbvzBGddESVGIze4Mv09tdeHhTdRO8jJoiRtXA+gklBpz+npGRmQyILgUsv8zMgZnIY+SwKnyD8OzvTSXA5JPuHvrq4JgfS4QMXY9Oz5Va6hayJR5Cy+9O7TaApyXDRU0o5iv+g=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3141.namprd15.prod.outlook.com (20.178.239.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.17; Sat, 6 Jul 2019 05:17:15 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.019; Sat, 6 Jul 2019
 05:17:15 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_attach_probe map
 definition
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix test_attach_probe map
 definition
Thread-Index: AQHVM7WClj4FHQCEEU2w6upHVtCfUaa9DJmA
Date:   Sat, 6 Jul 2019 05:17:15 +0000
Message-ID: <563a0bfc-aad1-cc17-f9c1-dd2f8516b7f3@fb.com>
References: <20190706044420.1582763-1-andriin@fb.com>
In-Reply-To: <20190706044420.1582763-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0047.namprd22.prod.outlook.com
 (2603:10b6:301:16::21) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:2331]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a87175cd-89b7-4363-ca47-08d701d13540
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3141;
x-ms-traffictypediagnostic: BYAPR15MB3141:
x-microsoft-antispam-prvs: <BYAPR15MB314164DDBA45398549F35A88D3F40@BYAPR15MB3141.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(39860400002)(346002)(136003)(396003)(189003)(199004)(66446008)(46003)(2616005)(446003)(476003)(102836004)(486006)(5660300002)(66556008)(11346002)(186003)(73956011)(66476007)(2906002)(6486002)(66946007)(229853002)(5024004)(256004)(6436002)(305945005)(71200400001)(76176011)(71190400001)(6116002)(64756008)(6512007)(31686004)(68736007)(7736002)(6636002)(110136005)(6246003)(8936002)(2501003)(36756003)(8676002)(81166006)(316002)(25786009)(81156014)(2201001)(53936002)(31696002)(52116002)(14454004)(478600001)(99286004)(6506007)(86362001)(386003)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3141;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SjzT47BUz3lnRBMqpYR4NY2x9fFje9a/ewNDQ0go1RmECcLZNccp/BVZtjFN1Imu9dF8+DgN4BAmDA6FWvB2hexfowGXbR4plpPj5DevnYXtOJ4rTMDFxkQlWFmuGlTwGZ2N9VhHFC9nf589NmnOI2NfRTeUzPZG5k2/N+puNYzmvlNxXJ+OGglA7sRrirYFbcyeVe2u9vZQrte3VlcWh2ZhKA61eWmjairudUOHQJEgis5YXXhNMQDMQcNIsdP+WxQRQqL3koGjliR7vanF2S9A5zDiNGVrPZx9u2WXjvuE5aQy0hElA4qfFYd2L7jSMYVPAyzs4H8HUMFAFa6CHL6hE/gCX80OUp6DxMvcTgMKNDhCkyOdZ5tMCZY6iWZVCfVzig4YNw/xigt6Nx1M37MgFTo/rQKtYSXNgQi6Oqc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F235075141BF784C8760FC8AD9D4B34C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a87175cd-89b7-4363-ca47-08d701d13540
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 05:17:15.2014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3141
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060069
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNS8xOSA5OjQ0IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IGVmOTliMDJi
MjNlZiAoImxpYmJwZjogY2FwdHVyZSB2YWx1ZSBpbiBCVEYgdHlwZSBpbmZvIGZvciBCVEYtZGVm
aW5lZCBtYXANCj4gZGVmcyIpIGNoYW5nZWQgQlRGLWRlZmluZWQgbWFwcyBzeW50YXgsIHdoaWxl
IGluZGVwZW5kZW50bHkgbWVyZ2VkDQo+IDFlODYxMWJiZGZjOSAoInNlbGZ0ZXN0cy9icGY6IGFk
ZCBrcHJvYmUvdXByb2JlIHNlbGZ0ZXN0cyIpIGFkZGVkIG5ldw0KPiB0ZXN0IHVzaW5nIG91dGRh
dGVkIHN5bnRheCBvZiBtYXBzLiBUaGlzIHBhdGNoIGZpeGVzIHRoaXMgdGVzdCBhZnRlcg0KPiBj
b3JyZXNwb25kaW5nIHBhdGNoIHNldHMgd2VyZSBtZXJnZWQuDQo+IA0KPiBGaXhlczogZWY5OWIw
MmIyM2VmICgibGliYnBmOiBjYXB0dXJlIHZhbHVlIGluIEJURiB0eXBlIGluZm8gZm9yIEJURi1k
ZWZpbmVkIG1hcCBkZWZzIikNCj4gRml4ZXM6IDFlODYxMWJiZGZjOSAoInNlbGZ0ZXN0cy9icGY6
IGFkZCBrcHJvYmUvdXByb2JlIHNlbGZ0ZXN0cyIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJpaSBO
YWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNA
ZmIuY29tPg0KDQo+IC0tLQ0KPiAgIC4uLi90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVz
dF9hdHRhY2hfcHJvYmUuYyB8IDEzICsrKysrLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwg
NSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2F0dGFjaF9wcm9iZS5jIGIvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfYXR0YWNoX3Byb2JlLmMNCj4gaW5kZXgg
N2E3YzVjZDcyOGM4Li42M2E4ZGZlZjg5M2IgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2F0dGFjaF9wcm9iZS5jDQo+ICsrKyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2F0dGFjaF9wcm9iZS5jDQo+IEBAIC02LDE0
ICs2LDExIEBADQo+ICAgI2luY2x1ZGUgImJwZl9oZWxwZXJzLmgiDQo+ICAgDQo+ICAgc3RydWN0
IHsNCj4gLQlpbnQgdHlwZTsNCj4gLQlpbnQgbWF4X2VudHJpZXM7DQo+IC0JaW50ICprZXk7DQo+
IC0JaW50ICp2YWx1ZTsNCj4gLX0gcmVzdWx0c19tYXAgU0VDKCIubWFwcyIpID0gew0KPiAtCS50
eXBlID0gQlBGX01BUF9UWVBFX0FSUkFZLA0KPiAtCS5tYXhfZW50cmllcyA9IDQsDQo+IC19Ow0K
PiArCV9fdWludCh0eXBlLCBCUEZfTUFQX1RZUEVfQVJSQVkpOw0KPiArCV9fdWludChtYXhfZW50
cmllcywgNCk7DQo+ICsJX190eXBlKGtleSwgaW50KTsNCj4gKwlfX3R5cGUodmFsdWUsIGludCk7
DQo+ICt9IHJlc3VsdHNfbWFwIFNFQygiLm1hcHMiKTsNCj4gICANCj4gICBTRUMoImtwcm9iZS9z
eXNfbmFub3NsZWVwIikNCj4gICBpbnQgaGFuZGxlX3N5c19uYW5vc2xlZXBfZW50cnkoc3RydWN0
IHB0X3JlZ3MgKmN0eCkNCj4gDQo=
