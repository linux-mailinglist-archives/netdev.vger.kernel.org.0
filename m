Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7592B80998
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 07:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfHDFaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 01:30:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4686 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfHDFaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 01:30:07 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x745PAGi008677;
        Sat, 3 Aug 2019 22:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2O+oR6VlcWAHuTgLvsoVBohxgO44vwtLb63LKiW2k70=;
 b=mYePXWcVmZRWhItQJph5SQCt9MVO9T38T08B6RyzbQ9+WImMsKX5k1bRqKQfK6Y+Ag6a
 +UP69ul9tbrrpJBw97s9hqsLqHePllM5Uo/KXmarw1AzSKz30KDOJMkZilAFBNlZLTx4
 18W6cgBBnRwE/pLhy/+i8QiTPzAqiuRULwc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u56a4ajqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 03 Aug 2019 22:29:45 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 3 Aug 2019 22:29:44 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 3 Aug 2019 22:29:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/Dt019IQn3oLt5vOcD+a+KlbHVZ4H7z03247t1Yx4pPa8ZDvp16y/XOCnWpLEzAEd02R/5RgpcOPki49tLpi325PnV7dSqHphrRD+Rcq6sJ5Y8nDK90423YzrMqgKzbv0Wg7hzCKDlfy4Vq8ujsOveSQ15yDbLfWDvwH+dSGihsRvOhlbY8ZXifebmQrICUfGNz83cfaMCFc0SAxmj/9mx59qtd+L+/FHfUQqFNweATCzeRdFgW2ZYBhldwa8gSuftka+iAqSGi5ODW6axv90OcvqLM4SP+sH7zLf4YQeyVIVUfTC/TE1xrY/e1UoODcU5CYI7necHvBw6Btmgu7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2O+oR6VlcWAHuTgLvsoVBohxgO44vwtLb63LKiW2k70=;
 b=kQBxROAG2Je9CaR5fDXbzM/XoYaJfEGgky0t2bThu1O/SoeeXJ0rFfWUp7zvNBRP3AIUGXQRLsMhkGSpYvpSFfSW/7yDQKwVpVe08KaMYl1OsF4d6H0RAPNwt+Lj3dhBagtkTMQ67XSfWBzS+2pRqwNiZNN8L49VHzgh/5zBejQKzmNZRRaLC3J8AsguoPYcnZVD8Ma6/rMWIUXrCvDGz/2ccH/8tnRHpm1NHwigp90SkILe1qxTdhofYnhR5T+OkwRf+5ze5cu5JirYcQFYuVquUYpqa5xP0G3pe9VV0SiSi7jnP+h0Qt1gmvwDzG//i1IqdQAUI2tj2kujtISC+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2O+oR6VlcWAHuTgLvsoVBohxgO44vwtLb63LKiW2k70=;
 b=DE/Hn26s56ypOnHG+3xCWtO93/6mHq8WbWRr6wcc+IEQtFnqm6aoeOIFrWHyE/zMnPeYHdFeHpOOGNPYN+aqKujTl51/KsK6bP7WvX08VfOLewmOhLWntYLoFkxqbic0i1sZ0KB1KhVeD3XkyrdcaZycc58dphRGu8zRMb6BTAo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3064.namprd15.prod.outlook.com (20.178.238.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Sun, 4 Aug 2019 05:29:42 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Sun, 4 Aug 2019
 05:29:42 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Thread-Topic: [PATCH bpf-next 1/2] selftests/bpf: add loop test 4
Thread-Index: AQHVSYrDRvjRjh/ij0+eu7mMX24CUKbqeCCA
Date:   Sun, 4 Aug 2019 05:29:42 +0000
Message-ID: <63f123d2-b35f-a775-e414-004c90b4f4b7@fb.com>
References: <20190802233344.863418-1-ast@kernel.org>
 <20190802233344.863418-2-ast@kernel.org>
In-Reply-To: <20190802233344.863418-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0069.namprd21.prod.outlook.com
 (2603:10b6:300:db::31) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::dc4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28a968f4-43ab-40c5-667b-08d7189cc05d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3064;
x-ms-traffictypediagnostic: BYAPR15MB3064:
x-microsoft-antispam-prvs: <BYAPR15MB3064DA0DDBC19578BD7D0922D3DB0@BYAPR15MB3064.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:372;
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(39850400004)(136003)(346002)(199004)(189003)(46003)(2616005)(476003)(11346002)(446003)(229853002)(316002)(256004)(486006)(110136005)(31686004)(54906003)(2906002)(4326008)(68736007)(2501003)(25786009)(305945005)(81156014)(36756003)(53936002)(7736002)(5660300002)(14454004)(53546011)(6506007)(386003)(76176011)(52116002)(186003)(478600001)(102836004)(99286004)(71200400001)(71190400001)(81166006)(6436002)(8676002)(8936002)(66946007)(64756008)(66556008)(6486002)(66476007)(6116002)(31696002)(6512007)(6246003)(86362001)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3064;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K4Ue83vqKWkO0JAt3dZyujD3tA9Qh0+TN5eiOVnLd4IDiFlnYPFK/AZ5eiRs7a3xlhJggpa7XHjNBmh2wOmtXHAeoxnBw49L4C9VxDxms1vI/ByYT1Cnia2cKm/CAZNoK0Q65t9NE3ZE/T5Szk9GHAQKR3sjY2BumJRbyfdpZeHgXkwrqtIwDt5X2AZddNbWcfReSrsNfbzRBhXUNHjkm05Tk1NbzANINTzBanxXTeB/glk4oVX09sNsCMYdVS9hhBWGCGu+PcY7S8N78BMcXptlw5gnep/jMB4hxGYjKFivUTesEH7L63NWbBwTee+NwRWqnrvXq5XEs+WWYKHj5kgAy08y8fXbl09tEc/D4/h9KJ91PAZdll1UJki5BNfRoREOfGhVV5NeOc4dkqU5T73I2t159x2WVUWrpsRRL+8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E50920ECE046D14B879D18DE9DAEFFC0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a968f4-43ab-40c5-667b-08d7189cc05d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2019 05:29:42.0544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3064
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-04_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908040063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMi8xOSA0OjMzIFBNLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IEFkZCBh
IHRlc3QgdGhhdCByZXR1cm5zIGEgJ3JhbmRvbScgbnVtYmVyIGJldHdlZW4gWzAsIDJeMjApDQo+
IElmIHN0YXRlIHBydW5pbmcgaXMgbm90IHdvcmtpbmcgY29ycmVjdGx5IGZvciBsb29wIGJvZHkg
dGhlIG51bWJlciBvZg0KPiBwcm9jZXNzZWQgaW5zbnMgd2lsbCBiZSAyXjIwICogbnVtX29mX2lu
c25zX2luX2xvb3BfYm9keSBhbmQgdGhlIHByb2dyYW0NCj4gd2lsbCBiZSByZWplY3RlZC4NCg0K
VGhlIG1heGltdW0gcHJvY2Vzc2VkIGluc25zIHdpbGwgYmUgMl4yMCBvciAyXjIwICogDQpudW1f
b2ZfaW5zbnNfaW5fbG9vcF9ib2R5PyBJIHRob3VnaHQgdGhlIHZlcmlmaWVyIHdpbGwNCnN0b3Ag
cHJvY2Vzc2luZyBvbmNlIHByb2Nlc3NlZCBpbnNucyByZWFjaCAxTT8NCg0KQ291bGQgeW91IGVs
YWJvcmF0ZSB3aGljaCBwb3RlbnRpYWwgaXNzdWVzIGluIHZlcmlmaWVyDQp5b3UgdHJ5IHRvIGNv
dmVyIHdpdGggdGhpcyB0ZXN0IGNhc2U/IEV4dHJhIHRlc3RzIGFyZQ0KYWx3YXlzIHdlbGNvbWUu
IFdlIGFscmVhZHkgaGF2ZSBzY2FsZS9sb29wIHRlc3RzIGFuZCBzb21lDQooZS5nLiwgc3Ryb2Jl
bWV0YSB0ZXN0cykgYXJlIG1vcmUgY29tcGxleCB0aGFuIHRoaXMgb25lLg0KTWF5YmUgeW91IGhh
dmUgc29tZXRoaW5nIGluIG1pbmQgZm9yIHRoaXMgcGFydGljdWxhcg0KdGVzdD8gUHV0dGluZyBp
biB0aGUgY29tbWl0IG1lc3NhZ2UgbWF5IGhlbHAgcGVvcGxlIHVuZGVyc3RhbmQNCnRoZSBjb25j
ZXJucy4NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2Vy
bmVsLm9yZz4NCj4gLS0tDQo+ICAgLi4uL2JwZi9wcm9nX3Rlc3RzL2JwZl92ZXJpZl9zY2FsZS5j
ICAgICAgICAgIHwgIDEgKw0KPiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9s
b29wNC5jICAgICB8IDIzICsrKysrKysrKysrKysrKysrKysNCj4gICAyIGZpbGVzIGNoYW5nZWQs
IDI0IGluc2VydGlvbnMoKykNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A0LmMNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL2JwZl92ZXJpZl9zY2FsZS5jDQo+IGluZGV4
IGI0YmU5NjE2MmZmNC4uNzU3ZTM5NTQwZWRhIDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYw0KPiArKysgYi90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYw0KPiBA
QCAtNzEsNiArNzEsNyBAQCB2b2lkIHRlc3RfYnBmX3ZlcmlmX3NjYWxlKHZvaWQpDQo+ICAgDQo+
ICAgCQl7ICJsb29wMS5vIiwgQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVCB9LA0KPiAgIAkJ
eyAibG9vcDIubyIsIEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCj4gKwkJeyAibG9v
cDQubyIsIEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCg0KVGhlIHByb2dyYW0gaXMg
bW9yZSBsaWtlIGEgQlBGX1BST0dfVFlQRV9TQ0hFRF9DTFMgdHlwZSB0aGFuDQphIEJQRl9QUk9H
X1RZUEVfUkFXX1RSQUNFUE9JTlQ/DQoNCj4gICANCj4gICAJCS8qIHBhcnRpYWwgdW5yb2xsLiAx
OWsgaW5zbiBpbiBhIGxvb3AuDQo+ICAgCQkgKiBUb3RhbCBwcm9ncmFtIHNpemUgMjAuOGsgaW5z
bi4NCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9sb29w
NC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A0LmMNCj4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi4zZTdlZTE0ZmRkYmQNCj4gLS0t
IC9kZXYvbnVsbA0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvbG9v
cDQuYw0KPiBAQCAtMCwwICsxLDIzIEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMA0KPiArLy8gQ29weXJpZ2h0IChjKSAyMDE5IEZhY2Vib29rDQo+ICsjaW5jbHVkZSA8
bGludXgvc2NoZWQuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9wdHJhY2UuaD4NCg0KU2luY2UgdGhl
IHByb2dyYW0gaXMgYSBuZXR3b3JraW5nIHR5cGUsDQp0aGUgYWJvdmUgdHdvIGhlYWRlcnMgYXJl
IHByb2JhYmx5IHVubmVlZGVkLg0KDQo+ICsjaW5jbHVkZSA8c3RkaW50Lmg+DQo+ICsjaW5jbHVk
ZSA8c3RkZGVmLmg+DQo+ICsjaW5jbHVkZSA8c3RkYm9vbC5oPg0KPiArI2luY2x1ZGUgPGxpbnV4
L2JwZi5oPg0KPiArI2luY2x1ZGUgImJwZl9oZWxwZXJzLmgiDQo+ICsNCj4gK2NoYXIgX2xpY2Vu
c2VbXSBTRUMoImxpY2Vuc2UiKSA9ICJHUEwiOw0KPiArDQo+ICtTRUMoInNvY2tldCIpDQo+ICtp
bnQgY29tYmluYXRpb25zKHZvbGF0aWxlIHN0cnVjdCBfX3NrX2J1ZmYqIHNrYikNCj4gK3sNCj4g
KwlpbnQgcmV0ID0gMCwgaTsNCj4gKw0KPiArI3ByYWdtYSBub3Vucm9sbA0KPiArCWZvciAoaSA9
IDA7IGkgPCAyMDsgaSsrKQ0KPiArCQlpZiAoc2tiLT5sZW4pDQo+ICsJCQlyZXQgfD0gMSA8PCBp
Ow0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+IA0K
