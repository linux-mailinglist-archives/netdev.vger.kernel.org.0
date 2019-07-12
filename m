Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1646A666B4
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 08:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfGLGAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 02:00:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbfGLGAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 02:00:03 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6C5xkfk031554;
        Thu, 11 Jul 2019 22:59:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5S8P2eyR+rHB2rSzJARkOGn4/A/vHAbwepr1ZsaX6I0=;
 b=HyGRgBCaWbe082ggUUZSfZvTX448kae7uHol7UG7lR8yKEfDEe8ogf/8QkDafDbY7nhQ
 RJhl+izcLmNDdtiA+nf1l/ZGNtF33JfJpO17HBQH/qFq2p97i02xc5kQ6vwro0WBWbWj
 lT+xMkPJ8uFsMIRr9Kzv9VufSb69K7LZ7Fw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tpj7qrcb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 11 Jul 2019 22:59:46 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 11 Jul 2019 22:59:45 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 11 Jul 2019 22:59:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jALGRtwjHx5obOvuwptjAHrYPiiWy9D7RpW0TjpWkOuYK3w7dJ2lN1zwMjanSzUdf1Ye7PhBqrEgw/m9cCSc9n1+KKqv9bQaSRMK1moJixZ1+mmXSfjMzOHoLr+rRCSp5+wFJwnrm9XMH76MeBwMb35u1Bmpt9S58G87OwkDwroMQM4YHgDY2CSKCMlodX+UHq9bCNe2bRTK7s3JMMfrhUnasrm/nF46aSkBWNeV5Vpnc3KiFObV6U5ddflwwhGqh9iHZIDdMBcNUCqfGIhfhthgFNfahiwuBCDZ9A22Si5xk8oiWiKnKPEVIibUwdrd7ToVKrw7TYWUBYHxNIF/yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5S8P2eyR+rHB2rSzJARkOGn4/A/vHAbwepr1ZsaX6I0=;
 b=IU8p/C1uNg6EqYtkd8MQNRg2oS8VGPhtcx5kJZu7zEPDQF0g2UPMYauZ3uCGZ9pV8ZWS6oAxcMNXnhP8srkyJfofGEnT2p400PHP9RnA2YIUhUAhMfreq1ofeW8nO/F/lVqZApxUhygBfQ9zNHP9PBNW81QBnDhuiJJ9/dYc1e4kT1IekpHubc52NlWN+KvXxJFj+NMnoIPstorDUSeIhWinY96LaAVuCA0Q6T5y7TRPOlceZjGb/KlkYZgKrybddRVBP3ZVYXUdW29B66wf5fC7Ogh9B6T3sDHMhzxOlLDtyj8qpChILTxHLD/+m8x1vYo+LkI7wEg/dS0hYBgdUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5S8P2eyR+rHB2rSzJARkOGn4/A/vHAbwepr1ZsaX6I0=;
 b=C5U521wP6GvrDp8tzRMUBUsc0IRwmOOlvW3zhtreMtYfX4ugdUBdFoj+O9vgE2sfGDgcvE/xxK1CuyopvB63KZuQBAx4A5mQe+IBzU6dvwLjcTXktp95xfnQHT+CFl78+4kO6HvXytNxJxObsvu4jg/ZrANow4KD66Sz6w3g994=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3045.namprd15.prod.outlook.com (20.178.238.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.11; Fri, 12 Jul 2019 05:59:28 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.008; Fri, 12 Jul 2019
 05:59:28 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution
 logic
Thread-Topic: [PATCH v2 bpf-next 1/3] bpf: fix BTF verifier size resolution
 logic
Thread-Index: AQHVN7VeUwERn4PcZEKaNqiZLaNaLqbGfn2A
Date:   Fri, 12 Jul 2019 05:59:27 +0000
Message-ID: <ad29872e-a127-f21e-5581-03df5a388a55@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
 <20190711065307.2425636-2-andriin@fb.com>
In-Reply-To: <20190711065307.2425636-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0005.namprd10.prod.outlook.com (2603:10b6:301::15)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:bc57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b7fe77b-8573-4159-1cdf-08d7068e194f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3045;
x-ms-traffictypediagnostic: BYAPR15MB3045:
x-microsoft-antispam-prvs: <BYAPR15MB3045389E716D9612F79CBB40D3F20@BYAPR15MB3045.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39860400002)(376002)(396003)(136003)(189003)(199004)(86362001)(99286004)(2201001)(31696002)(305945005)(66946007)(31686004)(2501003)(81166006)(4326008)(8676002)(81156014)(5660300002)(7736002)(8936002)(25786009)(71200400001)(71190400001)(76176011)(68736007)(14454004)(6116002)(486006)(102836004)(386003)(53546011)(478600001)(66446008)(2906002)(36756003)(229853002)(52116002)(316002)(6436002)(14444005)(6486002)(256004)(6246003)(6506007)(476003)(46003)(53936002)(66476007)(66556008)(11346002)(186003)(446003)(2616005)(54906003)(64756008)(110136005)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3045;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nCnOXeC7EUuRXABPvr+IuQRNTZ7KGu33VfqYMVMlFC7PBYbW1D8mL63SGyc7O9uguyYUA0/lK+ERKE/zCiXce5dH3I8svPP4uXcAEOdssQDXhOwL0KO4qLOX4m3JhjnS78NkI3ba8aOvYmYZemWJkhogpAZWSZW6IecQ1m1Ewl8XurUW7xbvoU+vLUteowZl2C8vsnQV+yL4A577JtuHXAYpUMw5ft8qJyStRo50B+CAgmFEdnO2IAyfn1F5seaDc/j+9yMOa9zBoj/IW0HTo0JJ77t9qe47DcM50MsD+avUWgn+wJ0tErzIIAZYL7c0dUBsBMe0Uj5uKSrl00KQEwjjF9XPdMdhByfzT+WXx6R1trZd29tYeHexO3kCvacs1GTGkbbueXlE/QlG5MboQxWnixbtZWAVQh0Ugc8Ltgg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E79E8335B7040B4688C91A169E5FFCDD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7fe77b-8573-4159-1cdf-08d7068e194f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 05:59:27.8530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3045
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTAvMTkgMTE6NTMgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gQlRGIHZl
cmlmaWVyIGhhcyBhIHNpemUgcmVzb2x1dGlvbiBidWcgd2hpY2ggaW4gc29tZSBjaXJjdW1zdGFu
Y2VzIGxlYWRzIHRvDQo+IGludmFsaWQgc2l6ZSByZXNvbHV0aW9uIGZvciwgZS5nLiwgVFlQRURF
RiBtb2RpZmllci4gIFRoaXMgaGFwcGVucyBpZiB3ZSBoYXZlDQo+IFsxXSBQVFIgLT4gWzJdIFRZ
UEVERUYgLT4gWzNdIEFSUkFZLCBpbiB3aGljaCBjYXNlIGR1ZSB0byBiZWluZyBpbiBwb2ludGVy
DQo+IGNvbnRleHQgQVJSQVkgc2l6ZSB3b24ndCBiZSByZXNvbHZlZCAoYmVjYXVzZSBmb3IgcG9p
bnRlciBpdCBkb2Vzbid0IG1hdHRlciwgc28NCj4gaXQncyBhIHNpbmsgaW4gcG9pbnRlciBjb250
ZXh0KSwgYnV0IGl0IHdpbGwgYmUgcGVybWFuZW50bHkgcmVtZW1iZXJlZCBhcyB6ZXJvDQo+IGZv
ciBUWVBFREVGIGFuZCBUWVBFREVGIHdpbGwgYmUgbWFya2VkIGFzIFJFU09MVkVELiBFdmVudHVh
bGx5IEFSUkFZIHNpemUgd2lsbA0KPiBiZSByZXNvbHZlZCBjb3JyZWN0bHksIGJ1dCBUWVBFREVG
IHJlc29sdmVkX3NpemUgd29uJ3QgYmUgdXBkYXRlZCBhbnltb3JlLg0KPiBUaGlzLCBzdWJzZXF1
ZW50bHksIHdpbGwgbGVhZCB0byBlcnJvbmVvdXMgbWFwIGNyZWF0aW9uIGZhaWx1cmUsIGlmIHRo
YXQNCj4gVFlQRURFRiBpcyBzcGVjaWZpZWQgYXMgZWl0aGVyIGtleSBvciB2YWx1ZSwgYXMga2V5
X3NpemUvdmFsdWVfc2l6ZSB3b24ndA0KPiBjb3JyZXNwb25kIHRvIHJlc29sdmVkIHNpemUgb2Yg
VFlQRURFRiAoa2VybmVsIHdpbGwgYmVsaWV2ZSBpdCdzIHplcm8pLg0KPiANCj4gTm90ZSwgdGhh
dCBpZiBCVEYgd2FzIG9yZGVyZWQgYXMgWzFdIEFSUkFZIDwtIFsyXSBUWVBFREVGIDwtIFszXSBQ
VFIsIHRoaXMNCj4gd29uJ3QgYmUgYSBwcm9ibGVtLCBhcyBieSB0aGUgdGltZSB3ZSBnZXQgdG8g
VFlQRURFRiwgQVJSQVkncyBzaXplIGlzIGFscmVhZHkNCj4gY2FsY3VsYXRlZCBhbmQgc3RvcmVk
Lg0KPiANCj4gVGhpcyBidWcgbWFuaWZlc3RzIGl0c2VsZiBpbiByZWplY3RpbmcgQlRGLWRlZmlu
ZWQgbWFwcyB0aGF0IHVzZSBhcnJheQ0KPiB0eXBlZGVmIGFzIGEgdmFsdWUgdHlwZToNCj4gDQo+
IHR5cGVkZWYgaW50IGFycmF5X3RbMTZdOw0KPiANCj4gc3RydWN0IHsNCj4gICAgICBfX3VpbnQo
dHlwZSwgQlBGX01BUF9UWVBFX0FSUkFZKTsNCj4gICAgICBfX3R5cGUodmFsdWUsIGFycmF5X3Qp
OyAvKiBpLmUuLCBhcnJheV90ICp2YWx1ZTsgKi8NCj4gfSB0ZXN0X21hcCBTRUMoIi5tYXBzIik7
DQo+IA0KPiBUaGUgZml4IGNvbnNpc3RzIG9uIG5vdCByZWx5aW5nIG9uIG1vZGlmaWVyJ3MgcmVz
b2x2ZWRfc2l6ZSBhbmQgaW5zdGVhZCB1c2luZw0KPiBtb2RpZmllcidzIHJlc29sdmVkX2lkICh0
eXBlIElEIGZvciAiY29uY3JldGUiIHR5cGUgdG8gd2hpY2ggbW9kaWZpZXINCj4gZXZlbnR1YWxs
eSByZXNvbHZlcykgYW5kIGRvaW5nIHNpemUgZGV0ZXJtaW5hdGlvbiBmb3IgdGhhdCByZXNvbHZl
ZCB0eXBlLiBUaGlzDQo+IGFsbG93IHRvIHByZXNlcnZlIGV4aXN0aW5nICJlYXJseSBERlMgdGVy
bWluYXRpb24iIGxvZ2ljIGZvciBQVFIgb3INCj4gU1RSVUNUX09SX0FSUkFZIGNvbnRleHRzLCBi
dXQgc3RpbGwgZG8gY29ycmVjdCBzaXplIGRldGVybWluYXRpb24gZm9yIG1vZGlmaWVyDQo+IHR5
cGVzLg0KPiANCj4gRml4ZXM6IGViM2Y1OTVkYWI0MCAoImJwZjogYnRmOiBWYWxpZGF0ZSB0eXBl
IHJlZmVyZW5jZSIpDQo+IENjOiBNYXJ0aW4gS2FGYWkgTGF1IDxrYWZhaUBmYi5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+IC0tLQ0KPiAg
IGtlcm5lbC9icGYvYnRmLmMgfCAxNCArKysrKysrKysrLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCAxMCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2tl
cm5lbC9icGYvYnRmLmMgYi9rZXJuZWwvYnBmL2J0Zi5jDQo+IGluZGV4IGNhZDA5ODU4YTVmMi4u
MjJmZThiMTU1ZTUxIDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2J0Zi5jDQo+ICsrKyBiL2tl
cm5lbC9icGYvYnRmLmMNCj4gQEAgLTEwNzMsMTEgKzEwNzMsMTggQEAgY29uc3Qgc3RydWN0IGJ0
Zl90eXBlICpidGZfdHlwZV9pZF9zaXplKGNvbnN0IHN0cnVjdCBidGYgKmJ0ZiwNCj4gICAJCQkJ
ICFidGZfdHlwZV9pc192YXIoc2l6ZV90eXBlKSkpDQo+ICAgCQkJcmV0dXJuIE5VTEw7DQo+ICAg
DQo+IC0JCXNpemUgPSBidGYtPnJlc29sdmVkX3NpemVzW3NpemVfdHlwZV9pZF07DQo+ICAgCQlz
aXplX3R5cGVfaWQgPSBidGYtPnJlc29sdmVkX2lkc1tzaXplX3R5cGVfaWRdOw0KPiAgIAkJc2l6
ZV90eXBlID0gYnRmX3R5cGVfYnlfaWQoYnRmLCBzaXplX3R5cGVfaWQpOw0KPiAgIAkJaWYgKGJ0
Zl90eXBlX25vc2l6ZV9vcl9udWxsKHNpemVfdHlwZSkpDQo+ICAgCQkJcmV0dXJuIE5VTEw7DQo+
ICsJCWVsc2UgaWYgKGJ0Zl90eXBlX2hhc19zaXplKHNpemVfdHlwZSkpDQo+ICsJCQlzaXplID0g
c2l6ZV90eXBlLT5zaXplOw0KPiArCQllbHNlIGlmIChidGZfdHlwZV9pc19hcnJheShzaXplX3R5
cGUpKQ0KPiArCQkJc2l6ZSA9IGJ0Zi0+cmVzb2x2ZWRfc2l6ZXNbc2l6ZV90eXBlX2lkXTsNCj4g
KwkJZWxzZSBpZiAoYnRmX3R5cGVfaXNfcHRyKHNpemVfdHlwZSkpDQo+ICsJCQlzaXplID0gc2l6
ZW9mKHZvaWQgKik7DQo+ICsJCWVsc2UNCj4gKwkJCXJldHVybiBOVUxMOw0KDQpMb29rcyBnb29k
IHRvIG1lLiBOb3Qgc3VyZSB3aGV0aGVyIHdlIG5lZWQgdG8gZG8gYW55IGFkanVzdG1lbnQgZm9y
DQp2YXIga2luZCBvciBub3QuIE1heWJlIHdlIGNhbiBkbyBzaW1pbGFyIGNoYW5nZSBpbiBidGZf
dmFyX3Jlc29sdmUoKQ0KdG8gYnRmX21vZGlmaWVyX3Jlc29sdmUoKT8gQnV0IEkgZG8gbm90IHRo
aW5rIGl0IGltcGFjdHMgY29ycmVjdG5lc3MgDQpzaW1pbGFyIHRvIGJ0Zl9tb2RpZmllcl9yZXNv
bHZlKCkgYmVsb3cgYXMgeW91IGNoYW5nZWQgDQpidGZfdHlwZV9pZF9zaXplKCkgaW1wbGVtZW50
YXRpb24gaW4gdGhlIGFib3ZlLg0KDQo+ICAgCX0NCj4gICANCj4gICAJKnR5cGVfaWQgPSBzaXpl
X3R5cGVfaWQ7DQo+IEBAIC0xNjAyLDcgKzE2MDksNiBAQCBzdGF0aWMgaW50IGJ0Zl9tb2RpZmll
cl9yZXNvbHZlKHN0cnVjdCBidGZfdmVyaWZpZXJfZW52ICplbnYsDQo+ICAgCWNvbnN0IHN0cnVj
dCBidGZfdHlwZSAqbmV4dF90eXBlOw0KPiAgIAl1MzIgbmV4dF90eXBlX2lkID0gdC0+dHlwZTsN
Cj4gICAJc3RydWN0IGJ0ZiAqYnRmID0gZW52LT5idGY7DQo+IC0JdTMyIG5leHRfdHlwZV9zaXpl
ID0gMDsNCj4gICANCj4gICAJbmV4dF90eXBlID0gYnRmX3R5cGVfYnlfaWQoYnRmLCBuZXh0X3R5
cGVfaWQpOw0KPiAgIAlpZiAoIW5leHRfdHlwZSB8fCBidGZfdHlwZV9pc19yZXNvbHZlX3NvdXJj
ZV9vbmx5KG5leHRfdHlwZSkpIHsNCj4gQEAgLTE2MjAsNyArMTYyNiw3IEBAIHN0YXRpYyBpbnQg
YnRmX21vZGlmaWVyX3Jlc29sdmUoc3RydWN0IGJ0Zl92ZXJpZmllcl9lbnYgKmVudiwNCj4gICAJ
ICogc2F2ZSB1cyBhIGZldyB0eXBlLWZvbGxvd2luZyB3aGVuIHdlIHVzZSBpdCBsYXRlciAoZS5n
LiBpbg0KPiAgIAkgKiBwcmV0dHkgcHJpbnQpLg0KPiAgIAkgKi8NCj4gLQlpZiAoIWJ0Zl90eXBl
X2lkX3NpemUoYnRmLCAmbmV4dF90eXBlX2lkLCAmbmV4dF90eXBlX3NpemUpKSB7DQo+ICsJaWYg
KCFidGZfdHlwZV9pZF9zaXplKGJ0ZiwgJm5leHRfdHlwZV9pZCwgTlVMTCkpIHsNCj4gICAJCWlm
IChlbnZfdHlwZV9pc19yZXNvbHZlZChlbnYsIG5leHRfdHlwZV9pZCkpDQo+ICAgCQkJbmV4dF90
eXBlID0gYnRmX3R5cGVfaWRfcmVzb2x2ZShidGYsICZuZXh0X3R5cGVfaWQpOw0KPiAgIA0KPiBA
QCAtMTYzMyw3ICsxNjM5LDcgQEAgc3RhdGljIGludCBidGZfbW9kaWZpZXJfcmVzb2x2ZShzdHJ1
Y3QgYnRmX3ZlcmlmaWVyX2VudiAqZW52LA0KPiAgIAkJfQ0KPiAgIAl9DQo+ICAgDQo+IC0JZW52
X3N0YWNrX3BvcF9yZXNvbHZlZChlbnYsIG5leHRfdHlwZV9pZCwgbmV4dF90eXBlX3NpemUpOw0K
PiArCWVudl9zdGFja19wb3BfcmVzb2x2ZWQoZW52LCBuZXh0X3R5cGVfaWQsIDApOw0KPiAgIA0K
PiAgIAlyZXR1cm4gMDsNCj4gICB9DQo+IA0K
