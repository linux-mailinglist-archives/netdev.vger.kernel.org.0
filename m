Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517EC5D3D0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGBQCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:02:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54552 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbfGBQCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:02:40 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62FtZmm014884;
        Tue, 2 Jul 2019 09:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CIVrqPA0z0U9PzqVWg6xdtcl6wzYXLfkNHhtcOml8S8=;
 b=gWaxQJ9rAF0/wi+VqQv/qYCCPWFT0NeGLt2J7cJRTzXUV5tlVGiX/+tTKMqegbjvYsmD
 1BGMxYvCSv8UVTrTdySft+hZRTSNGj9rA4M2RPQ7Q4Qk92lxaoDgiJ8n/JoyhA7+zBTf
 eQKafAuw7dRp8kM5ups0Hrrg5E5FMZo2yuc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tg128ht1r-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Jul 2019 09:01:23 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 2 Jul 2019 09:01:18 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 09:01:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=nQduo3b0Rbuub2VtaaJMw/dBQFcHM43XFgGBWwmHNcwp9jhveCctzQHomf2PfYVuW97D8RXHG4w8pyXylYFuZi+BOS/ZhAs45zF38NiDNS6nRZ/ehE8eh2vqbpuAqjxa8SC/C1BpaZNcZnSS6ewz4I/mjOusz02PNfo+o4RAw58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIVrqPA0z0U9PzqVWg6xdtcl6wzYXLfkNHhtcOml8S8=;
 b=qZhP2UvqOwmBiE6sw1T9TKFZi1j5CriJSrmVuMeHWq4OorIEvhWmkuMSvE0I1sMTkr8oh0p5KVom8N1u5N2hYQqY+HIPRuQZcfcTO34gUGvirrZZhJR+Z0P9wv5jUARRlYMSTzQylYVeRoZI85FKtDfj86gPI40u4Lh0rn91FVY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIVrqPA0z0U9PzqVWg6xdtcl6wzYXLfkNHhtcOml8S8=;
 b=MURQg3308Oa3l+I1+5+BdM6dfd5UkfnMgJEfBE0MRwY/JuLw79bh2UAM3sqsDfSoN8tE8in3fqz9JtAUSTTdEcd4zU/pyx8DUTtpH410ibk5acQx3sfuT1PW7FRBD/Dt9+gVrOZGrDmcKxXwTyiYlDZglTfjhcJp0YqzIThswp4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2438.namprd15.prod.outlook.com (52.135.198.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 2 Jul 2019 16:01:16 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 16:01:16 +0000
From:   Yonghong Song <yhs@fb.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "sdf@google.com" <sdf@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Thread-Topic: [PATCH bpf-next] bpf: cgroup: Fix build error without CONFIG_NET
Thread-Index: AQHVMNo5OI4ru0GJ7k2XomHdGmFYp6a3fQmA
Date:   Tue, 2 Jul 2019 16:01:16 +0000
Message-ID: <5911e346-4b78-3a0c-e71a-38456e04e075@fb.com>
References: <20190702132913.26060-1-yuehaibing@huawei.com>
In-Reply-To: <20190702132913.26060-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0069.namprd15.prod.outlook.com
 (2603:10b6:101:20::13) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8eae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e66c63f3-b342-4427-f2ca-08d6ff06830b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2438;
x-ms-traffictypediagnostic: BYAPR15MB2438:
x-microsoft-antispam-prvs: <BYAPR15MB2438C3CCF9A00B4B2C648D39D3F80@BYAPR15MB2438.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(53546011)(31686004)(99286004)(76176011)(52116002)(256004)(6506007)(5024004)(36756003)(386003)(14454004)(478600001)(14444005)(102836004)(186003)(86362001)(2201001)(6116002)(6486002)(31696002)(2501003)(68736007)(6246003)(2906002)(486006)(81166006)(2616005)(11346002)(54906003)(8936002)(6512007)(305945005)(110136005)(66476007)(4326008)(66446008)(316002)(64756008)(66946007)(476003)(73956011)(81156014)(25786009)(8676002)(7736002)(229853002)(71190400001)(6436002)(46003)(53936002)(71200400001)(5660300002)(446003)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2438;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M+o3gZR9qIB/Z8ooexTl/r5NNmHtmSY0vKBp7AIEXSCNVSaunKL4s0P40d3k0ADf/v2FUHxDquE3rJy2ZUUcYgKOwxC06skiEGHn/GEFpWMa6VYjBR+e+HXzchyGeg8U+OUf3cA7LczIkQUDjZThBLbDCxSY5zAoc9WhGyR2p9gl+8BFsCh70FTjQPsmU3R2pDbj5VjCHUirNYcnrvglNZ7PJM3tz4GUZ9YmO7shut8/8zx9g7ipMiPJyH/U2U5UC+3U9UHHJy7u6BiFGfif+pOeK+sl0jRVehzXs8HsiWRHHIj6JiRzUSgcYDLBt1JXHCCunZZz1D27NIkABH/iufMG5w5r6HKFFV8ADQwNGsqHCtkIkk6S7ra81W3DhR5R3UbD21xcYZFhLyMCkteG0Tf4mD4ifN6+KbZsc9Q6r0I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <846404DD2137C4469EE15CFD0A23F91C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e66c63f3-b342-4427-f2ca-08d6ff06830b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 16:01:16.6292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2438
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMi8xOSA2OjI5IEFNLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBJZiBDT05GSUdfTkVU
IGlzIG5vdCBzZXQsIGdjYyBidWlsZGluZyBmYWlsczoNCj4gDQo+IGtlcm5lbC9icGYvY2dyb3Vw
Lm86IEluIGZ1bmN0aW9uIGBjZ19zb2Nrb3B0X2Z1bmNfcHJvdG8nOg0KPiBjZ3JvdXAuYzooLnRl
eHQrMHgyMzdlKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgYnBmX3NrX3N0b3JhZ2VfZ2V0X3By
b3RvJw0KPiBjZ3JvdXAuYzooLnRleHQrMHgyMzk0KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBg
YnBmX3NrX3N0b3JhZ2VfZGVsZXRlX3Byb3RvJw0KPiBrZXJuZWwvYnBmL2Nncm91cC5vOiBJbiBm
dW5jdGlvbiBgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfZ2V0c29ja29wdCc6DQo+ICgudGV4dCsw
eDJhMWYpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBsb2NrX3NvY2tfbmVzdGVkJw0KPiAoLnRl
eHQrMHgyY2EyKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgcmVsZWFzZV9zb2NrJw0KPiBrZXJu
ZWwvYnBmL2Nncm91cC5vOiBJbiBmdW5jdGlvbiBgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfc2V0
c29ja29wdCc6DQo+ICgudGV4dCsweDMwMDYpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBsb2Nr
X3NvY2tfbmVzdGVkJw0KPiAoLnRleHQrMHgzMmJiKTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBg
cmVsZWFzZV9zb2NrJw0KPiANCj4gQWRkIENPTkZJR19ORVQgZGVwZW5kZW5jeSB0byBmaXggdGhp
cy4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4g
Rml4ZXM6IDBkMDFkYTZhZmM1NCAoImJwZjogaW1wbGVtZW50IGdldHNvY2tvcHQgYW5kIHNldHNv
Y2tvcHQgaG9va3MiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1
YXdlaS5jb20+DQo+IC0tLQ0KPiAgIGluaXQvS2NvbmZpZyB8IDEgKw0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luaXQvS2NvbmZpZyBiL2lu
aXQvS2NvbmZpZw0KPiBpbmRleCBlMmU1MWI1Li4zNDFjZjJhIDEwMDY0NA0KPiAtLS0gYS9pbml0
L0tjb25maWcNCj4gKysrIGIvaW5pdC9LY29uZmlnDQo+IEBAIC05OTgsNiArOTk4LDcgQEAgY29u
ZmlnIENHUk9VUF9QRVJGDQo+ICAgY29uZmlnIENHUk9VUF9CUEYNCj4gICAJYm9vbCAiU3VwcG9y
dCBmb3IgZUJQRiBwcm9ncmFtcyBhdHRhY2hlZCB0byBjZ3JvdXBzIg0KPiAgIAlkZXBlbmRzIG9u
IEJQRl9TWVNDQUxMDQo+ICsJZGVwZW5kcyBvbiBORVQNCj4gICAJc2VsZWN0IFNPQ0tfQ0dST1VQ
X0RBVEENCj4gICAJaGVscA0KPiAgIAkgIEFsbG93IGF0dGFjaGluZyBlQlBGIHByb2dyYW1zIHRv
IGEgY2dyb3VwIHVzaW5nIHRoZSBicGYoMikNCg0KDQpBZGRpbmcgQ0dST1VQX0JQRiBkZXBlbmRp
bmcgb24gQ09ORklHX05FVCBpcyBub3QgYSBnb29kIGlkZWEuDQpUaGVyZSBzaG91bGQgYmUgcmVh
bGx5IGluZGVwZW5kZW50Lg0KDQpIb3cgYWJvdXQgdGhlIGZvbGxvd2luZyBjaGFuZ2U/DQoNCi1i
YXNoLTQuNCQgZ2l0IGRpZmYNCmRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL2Nncm91cC5jIGIva2Vy
bmVsL2JwZi9jZ3JvdXAuYw0KaW5kZXggNzZmYTAwNzZmMjBkLi4wYTAwZWFjYTZmYWUgMTAwNjQ0
DQotLS0gYS9rZXJuZWwvYnBmL2Nncm91cC5jDQorKysgYi9rZXJuZWwvYnBmL2Nncm91cC5jDQpA
QCAtOTM5LDYgKzkzOSw3IEBAIGludCBfX2Nncm91cF9icGZfcnVuX2ZpbHRlcl9zeXNjdGwoc3Ry
dWN0IA0KY3RsX3RhYmxlX2hlYWRlciAqaGVhZCwNCiAgfQ0KICBFWFBPUlRfU1lNQk9MKF9fY2dy
b3VwX2JwZl9ydW5fZmlsdGVyX3N5c2N0bCk7DQoNCisjaWZkZWYgQ09ORklHX05FVA0KICBzdGF0
aWMgYm9vbCBfX2Nncm91cF9icGZfcHJvZ19hcnJheV9pc19lbXB0eShzdHJ1Y3QgY2dyb3VwICpj
Z3JwLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0g
YnBmX2F0dGFjaF90eXBlIA0KYXR0YWNoX3R5cGUpDQogIHsNCkBAIC0xMTIwLDYgKzExMjEsNyBA
QCBpbnQgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfZ2V0c29ja29wdChzdHJ1Y3Qgc29jayANCipz
aywgaW50IGxldmVsLA0KICAgICAgICAgcmV0dXJuIHJldDsNCiAgfQ0KICBFWFBPUlRfU1lNQk9M
KF9fY2dyb3VwX2JwZl9ydW5fZmlsdGVyX2dldHNvY2tvcHQpOw0KKyNlbmRpZg0KDQogIHN0YXRp
YyBzc2l6ZV90IHN5c2N0bF9jcHlfZGlyKGNvbnN0IHN0cnVjdCBjdGxfZGlyICpkaXIsIGNoYXIg
KipidWZwLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVfdCAqbGVucCkNCkBA
IC0xMzg2LDEwICsxMzg4LDEyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8g
Kg0KICBjZ19zb2Nrb3B0X2Z1bmNfcHJvdG8oZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25z
dCBzdHJ1Y3QgYnBmX3Byb2cgDQoqcHJvZykNCiAgew0KICAgICAgICAgc3dpdGNoIChmdW5jX2lk
KSB7DQorI2lmZGVmIENPTkZJR19ORVQNCiAgICAgICAgIGNhc2UgQlBGX0ZVTkNfc2tfc3RvcmFn
ZV9nZXQ6DQogICAgICAgICAgICAgICAgIHJldHVybiAmYnBmX3NrX3N0b3JhZ2VfZ2V0X3Byb3Rv
Ow0KICAgICAgICAgY2FzZSBCUEZfRlVOQ19za19zdG9yYWdlX2RlbGV0ZToNCiAgICAgICAgICAg
ICAgICAgcmV0dXJuICZicGZfc2tfc3RvcmFnZV9kZWxldGVfcHJvdG87DQorI2VuZGlmDQogICNp
ZmRlZiBDT05GSUdfSU5FVA0KICAgICAgICAgY2FzZSBCUEZfRlVOQ190Y3Bfc29jazoNCiAgICAg
ICAgICAgICAgICAgcmV0dXJuICZicGZfdGNwX3NvY2tfcHJvdG87DQoNClN0YW5pc2xhdiwgeW91
IGludHJvZHVjZWQgZ2V0c29ja29wdCBhbmQgc2V0c29ja29wdCBob29rcyB3aGljaA0KaGF2ZSB0
aGlzIGNvbXBpbGF0aW9uIGlzc3VlcyBpZiBDT05GSUdfTkVUPW4uDQpXaGF0IGRvIHlvdSB0aGlu
ayBmb3IgdGhlIGFib3ZlIGNoYW5nZT8NCg0K
