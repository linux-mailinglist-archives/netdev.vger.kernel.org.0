Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D3C8D775
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfHNPv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:51:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38290 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbfHNPv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:51:58 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7EFhx6e016551;
        Wed, 14 Aug 2019 08:51:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=x2t0o6e+bQHxHobP3O+blO6xm2f45Cp4VlCF0GVAMoE=;
 b=BPH1yosozlAzg3BUG1LFKTnjlnZ90l7+Y4ZDTf1aUv0UwW62PvlF+KZI76ntQEUQPoxi
 qSa5S++Ie3GxHvEdjTgR7lZyNR2iVLwzYhHZtq8KOe7cP52Ffa+DtEUVoT/J54X8h2Zd
 jYGPBaEgr7v9Vb5YyzmS2HbqaZWMXTIv0Vc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ucjbarux9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 08:51:32 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 14 Aug 2019 08:51:30 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 14 Aug 2019 08:51:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1u3FTNpKBM8e44SA/wXFpPRxCERDsy75ah6y8itCt+u951FwtHgkE48/qNGin9WhjnJu8AL8CnUx/t+hxVZULL7qq5czDYIWkyWX6XUvU9NNo/gIgQY/s/B5zISyNuqjxMIw4eY8DdnWsMyNro+5OIKk9w3n2U7edV3hPsd7mhoodOYV+3o55SktYXxzRLaPy9FKd4Zv9sgua8ekJ98kQy81VCLkD7UUKTBG3Abk6zJ8mAr6YgTXj4F+rAVP3niVewjOYfVhHXQ4AaXfQIWZ4vZN9claDQfEkNPFLapdbVrNjrbt+YInDfo3b9/zljkfhlm+skb+nkcK5fzeAIU2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2t0o6e+bQHxHobP3O+blO6xm2f45Cp4VlCF0GVAMoE=;
 b=XpwmxQ+o4WQpUQCU1LlTzPQOl92ZNlQBi/zTFWgHfytRjiEUd6q9MIxPBZ2c5oFP+1kyQw+LTQUdMgRpPNaCn0wG/KdBZYqadVNO4u1mbZMqYcvqRssgk7x9tN+V069FV2VupeId261BwRCH7N7Yb3kpd3x0tF/2WQcgltaidn+vYTIsgMpl+ed58rHulGnf7bq8lOyanYAeUasChdVLJma3LEalp57/9ttPDeI2NbQqDU2xNdQl+4pH0h/7QebTlZoHwLcGgPflHD7TX/S8MuQxVPwJqIgJZgzMeg2Q3aZJAp7VLjQkhSV8xJAdhDshv5lBmyW8OOELgiKcXdU6Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2t0o6e+bQHxHobP3O+blO6xm2f45Cp4VlCF0GVAMoE=;
 b=Ts62owqy6AgPI0cToy9mdAuYzDo0QLiLHUo0IhepBbWPCAlDhJxchi98Vc2CK41i5tgH3K7/rzHkxL1H14AoRICZy9jaO9wM9uLX0uMzJHIyktFq+L4FKA5k8QOEMTBY43PGFAimv8BSdIfIti3tZ4aSjyxQL8jOf13aLj1wDws=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2712.namprd15.prod.outlook.com (20.179.157.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 15:51:29 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 15:51:29 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Thread-Topic: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Thread-Index: AQHVUoIEKyrT2yAIekOTwiyoLftnBKb6yzyA
Date:   Wed, 14 Aug 2019 15:51:28 +0000
Message-ID: <f7be2fe9-cc06-ba99-dc78-f9296bcb4f20@fb.com>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
 <20190814092403.GA4142@khorivan>
In-Reply-To: <20190814092403.GA4142@khorivan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0086.namprd15.prod.outlook.com
 (2603:10b6:101:20::30) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:b5df]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a90710aa-416f-4189-70d5-08d720cf4522
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2712;
x-ms-traffictypediagnostic: BYAPR15MB2712:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR15MB2712F92564B6B1CCE220C4AFD3AD0@BYAPR15MB2712.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(366004)(376002)(346002)(52314003)(199004)(189003)(6116002)(31686004)(36756003)(966005)(110136005)(486006)(8936002)(64756008)(2616005)(31696002)(14454004)(66446008)(66556008)(11346002)(66476007)(446003)(66946007)(478600001)(316002)(53936002)(2906002)(52116002)(386003)(86362001)(53546011)(6506007)(99286004)(76176011)(476003)(25786009)(229853002)(46003)(6512007)(5660300002)(6306002)(6486002)(256004)(6436002)(186003)(102836004)(2501003)(6246003)(81156014)(8676002)(71190400001)(81166006)(7416002)(71200400001)(7736002)(305945005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2712;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ID/v7/cZoyX4/Eq77+hps1JsktovpvzY9leitgBjeA9PwTYnfqGIz6ZZZeDLAc9rCOKmgv5u5x/cEtQ1mqAvFkpqZV/s4u3DbjJw2vCcBKNvg2d2WzFex8u7+nEYIsNCU5C8Q2lP/pUVJbug61OcrRoKqFeaDofll2oRc4zwoaNDcNlCmy0b6hP06GgLBvwZEg9oizv6B7lv+5YltJgRgphw/0Yhoez+RMjibRTXu3ysUsq2R41NCDQwdOJRRBnChuutET6Xk/gyHrzIYZmOXFVuq76KPyGXNAD2uhNPAF2nEOMkpsR6bmI05vivHPMrK6tHPWbW8IOfsE7zN7oJBfltS8V6DtCtIjISYH3pTN2jHulO+2mSH85nZfcMdM++4vsYN/5Mw0/MwkOG8/pYCBkoV433gjMpNQ3y4NryDe8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB1DF4AD137DE34B9D5F98B17E637118@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a90710aa-416f-4189-70d5-08d720cf4522
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 15:51:28.9316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TjUMGeMes2Qg9X5WDAzSHKCU9N6I1txJ/aT1/Hr6pxIdLH0io3RuLw2Lq9P4Jk0I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2712
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTQvMTkgMjoyNCBBTSwgSXZhbiBLaG9yb256aHVrIHdyb3RlOg0KPiBPbiBUdWUs
IEF1ZyAxMywgMjAxOSBhdCAwNDozODoxM1BNIC0wNzAwLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6
DQo+IA0KPiBIaSwgQW5kcmlpDQo+IA0KPj4gT24gVHVlLCBBdWcgMTMsIDIwMTkgYXQgMzoyNCBB
TSBJdmFuIEtob3JvbnpodWsNCj4+IDxpdmFuLmtob3JvbnpodWtAbGluYXJvLm9yZz4gd3JvdGU6
DQo+Pj4NCj4+PiBUaGF0J3MgbmVlZGVkIHRvIGdldCBfX05SX21tYXAyIHdoZW4gbW1hcDIgc3lz
Y2FsbCBpcyB1c2VkLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogSXZhbiBLaG9yb256aHVrIDxp
dmFuLmtob3JvbnpodWtAbGluYXJvLm9yZz4NCj4+PiAtLS0NCj4+PiDCoHRvb2xzL2xpYi9icGYv
eHNrLmMgfCAxICsNCj4+PiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPj4+DQo+
Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYveHNrLmMgYi90b29scy9saWIvYnBmL3hzay5j
DQo+Pj4gaW5kZXggNTAwN2I1ZDRmZDJjLi5mMmZjNDBmOTgwNGMgMTAwNjQ0DQo+Pj4gLS0tIGEv
dG9vbHMvbGliL2JwZi94c2suYw0KPj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4+PiBA
QCAtMTIsNiArMTIsNyBAQA0KPj4+IMKgI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPj4+IMKgI2luY2x1
ZGUgPHN0cmluZy5oPg0KPj4+IMKgI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPj4+ICsjaW5jbHVkZSA8
YXNtL3VuaXN0ZC5oPg0KPj4NCj4+IGFzbS91bmlzdGQuaCBpcyBub3QgcHJlc2VudCBpbiBHaXRo
dWIgbGliYnBmIHByb2plY3Rpb24uIElzIHRoZXJlIGFueQ0KPiANCj4gTG9vayBvbiBpbmNsdWRl
cyBmcm9tDQo+IHRvb2xzL2xpYi9icGYvbGlicGYuYw0KPiB0b29scy9saWIvYnBmL2JwZi5jDQo+
IA0KPiBUaGF0J3MgaG93IGl0J3MgZG9uZS4uLiBDb3BwaW5nIGhlYWRlcnMgdG8gYXJjaC9hcm0g
d2lsbCBub3QNCj4gc29sdmUgdGhpcywgaXQgaW5jbHVkZXMgYm90aCBvZiB0aGVtIGFueXdheSwg
YW5kIGFueXdheSBpdCBuZWVkcw0KPiBhc20vdW5pc3RkLmggaW5jbHVzaW9uIGhlcmUsIG9ubHkg
YmVjYXVzZSB4c2suYyBuZWVkcyBfX05SXyoNCj4gDQo+IA0KPj4gd2F5IHRvIGF2b2lkIGluY2x1
ZGluZyB0aGlzIGhlYWRlcj8gR2VuZXJhbGx5LCBsaWJicGYgY2FuJ3QgZWFzaWx5IHVzZQ0KPj4g
YWxsIG9mIGtlcm5lbCBoZWFkZXJzLCB3ZSBuZWVkIHRvIHJlLWltcGxlbWVudGVkIGFsbCB0aGUg
ZXh0cmEgdXNlZA0KPj4gc3R1ZmYgZm9yIEdpdGh1YiB2ZXJzaW9uIG9mIGxpYmJwZiwgc28gd2Ug
dHJ5IHRvIG1pbmltaXplIHVzYWdlIG9mIG5ldw0KPj4gaGVhZGVycyB0aGF0IGFyZSBub3QganVz
dCBwbGFpbiB1YXBpIGhlYWRlcnMgZnJvbSBpbmNsdWRlL3VhcGkuDQo+IA0KPiBZZXMgSSBrbm93
LCBpdCdzIGZhciBhd2F5IGZyb20gcmVhbCBudW1iZXIgb2YgY2hhbmdlcyBuZWVkZWQuDQo+IEkg
ZmFjZWQgZW5vdWdoIGFib3V0IHRoaXMgYWxyZWFkeSBhbmQga2VybmVsIGhlYWRlcnMsIGVzcGVj
aWFsbHkNCj4gZm9yIGFybTMyIGl0J3MgYSBiaXQgZGVjZW5jeSBwcm9ibGVtLiBCdXQgdGhpcyBw
YXRjaCBpdCdzIHBhcnQgb2YNCj4gbm9ybWFsIG9uZS4gSSBoYXZlIGNvdXBsZSBpc3N1ZXMgZGVz
cGl0ZSB0aGlzIG5vcm1hbGx5IGZpeGVkIG1tYXAyDQo+IHRoYXQgaXMgdGhlIHNhbWUgZXZlbiBp
ZiB1YXBpIGluY2x1ZGVzIGFyZSBjb3BwaWVkIHRvIHRvb2xzL2FyY2gvYXJtLg0KPiANCj4gSW4g
Y29udGludWF0aW9uIG9mIGtlcm5lbCBoZWFkZXJzIGluY2x1c2lvbiBhbmQgYXJtIGJ1aWxkOg0K
PiANCj4gRm9yIGluc3RhbmNlLCB3aGF0IGFib3V0IHRoaXMgcm91Z2ggImtlcm5lbCBoZWFkZXJz
IiBoYWNrOg0KPiBodHRwczovL2dpdGh1Yi5jb20vaWtob3JuL2FmX3hkcF9zdHVmZi9jb21taXQv
YWE2NDVjY2NhNGQ4NDRmNDA0ZWMzYzJiMjc0MDJkNGQ3ODQ4ZDFiNSANCg0KVGhlICIuc3ludGF4
IHVuaWZpZWQiIGlzIG1lbnRpb25lZCBhIGNvdXBsZSBvZiB0aW1lcw0KaW4gYmNjIG1haWxpbmcg
bGlzdCBhcyB3ZWxsLiBsbHZtIGJwZiBiYWNrZW5kIG1pZ2h0DQpiZSBhYmxlIHRvIHNvbHZlIGl0
LiBJIGhhdmUgbm90IGxvb2tlZCBhdCB0aGUgZGV0YWlscyB0aG91Z2guDQoNCj4gDQo+IG9yIHRo
aXMgb25lIHJlbGF0ZWQgZm9yIGFybTMyIG9ubHk6DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9pa2hv
cm4vYWZfeGRwX3N0dWZmL2NvbW1pdC8yYzZjNmQ1Mzg2MDVhYWMzOTYwMGRjYjNjOWI2NmRlMTFj
NzBiOTYzIA0KDQpUaGlzIG1heSBub3Qgd29yayBpZiBicGYgcHJvZ3JhbSB0cmllcyB0byBoYW5k
bGUga2VybmVsIGhlYWRlcnMuDQpicGYgcHJvZ3JhbSBtYXkgZ2V0IHdyb25nIGxheW91dC4NCg0K
QW55d2F5LCB0aGUgYWJvdmUgdHdvIGNvbW1lbnRzIGFyZSBpcnJlbGV2YW50IHRvIHRoaXMgcGF0
Y2ggc2V0DQphbmQgaWYgbmVlZGVkIHNob3VsZCBiZSBkaXNjdXNzZWQgc2VwYXJhdGVseS4NCg0K
PiANCj4gDQo+IEkgaGF2ZSBtb3JlLi4uDQo+IA0KPj4NCj4+PiDCoCNpbmNsdWRlIDxhcnBhL2lu
ZXQuaD4NCj4+PiDCoCNpbmNsdWRlIDxhc20vYmFycmllci5oPg0KPj4+IMKgI2luY2x1ZGUgPGxp
bnV4L2NvbXBpbGVyLmg+DQo+Pj4gLS0gDQo+Pj4gMi4xNy4xDQo+Pj4NCj4gDQo=
