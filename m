Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646A1269857
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgINVvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:51:46 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:10047 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgINVvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:51:38 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5fe5e60000>; Tue, 15 Sep 2020 05:51:34 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 14:51:34 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Mon, 14 Sep 2020 14:51:34 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 21:51:34 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 21:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUywvW1z2FN8aFPIua0FoLhRlUID+bgZXnWNJ0rGX9d7pN8WjdGRQnanRpKF1hzLAXzJW4TybyoNd9DKKhZWr9KKuE6KgY6lVnrTY/JuHkaqVCnMjrwqIG9/zkGbDGlgHMi+s3h413nU266sBqcAPOpSt9YUuzzqEbsCNHhJsPCbc2a4pIz9AbSziLnH9xHnCohuJMiSCMkwb1NDcZdTPuknxHETgSlQig5a2g1KtfqB76DTZXEChBoW3j/JJu214lWQG5RK08DdI+P87x7M48q41cKEudTE32enZESPek5ihiOvvP3O29wu6nsKjtB0GaHjE3lIEPq4J0O/C3F9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNMTBEjkJC+e1KfaToMgRfC0fG+BfYzUWFvChSkvAUI=;
 b=i1ngtca1mRz9ipZBzfg5eFZ68ZraTXuUaCF66P1cd4e34MmjbzJVzhYKdopfDCiW69bbPNAvsZyKQ6Ofi5PSI+TjHGrm2k85xJUqEs7H1KXWhP2/wNEfOQQ+5YHhPw8WqJAcUndcmx63XNVYq29+kaq0Ld+Tw9gGwTeJNgBYLchwClaUa+d2ye9yGUwcpPwNGYuoOc4fJ4tePGOZfF9ZAKtzhQn//bq/TZoqjke0tLwxZuQD58A0jdq027uWIzo/Q9R9/F6ORpDkzHIvmZ7GyBvDyjU87Hn9QkeAL5iKCzZ2HGUifSlISqqCn8A2HcdfUfUevvVkiO9IKrIySvgaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2949.namprd12.prod.outlook.com (2603:10b6:a03:12f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.19; Mon, 14 Sep
 2020 21:51:32 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 21:51:32 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "alex.dewar90@gmail.com" <alex.dewar90@gmail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH] ath10k: sdio: remove reduntant check in for loop
Thread-Topic: [PATCH] ath10k: sdio: remove reduntant check in for loop
Thread-Index: AQHWiswcA3kxotH5yEulxUUC/5HrMKlorM8A
Date:   Mon, 14 Sep 2020 21:51:32 +0000
Message-ID: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
References: <20200914191925.24192-1-alex.dewar90@gmail.com>
In-Reply-To: <20200914191925.24192-1-alex.dewar90@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9de3ba41-be8f-4e37-906e-08d858f8580a
x-ms-traffictypediagnostic: BYAPR12MB2949:
x-microsoft-antispam-prvs: <BYAPR12MB2949B8B3BD186DFCB7C24AA8B3230@BYAPR12MB2949.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CipkA6BbubHvBOBLpKigis5Dtdk5ScQ052T8BItD/8rp/rt2YHmOH7ekYMq6Hm7vcOHm3IDEpUDgMftV54NAK5gLdG/wfK/IHK6mU+B35YDtyTRM7rDjE3cHmEwvtsuOWY47KE/JxdC0OPMayJjSPQYHEklGYyV36GeC+yKoiWCUZDiiCIQ4CoIhWqXYPtyMM6F9k23DdI5lkNKhbnR7lQBGvpENpLkUuOf+T8MMaahYDK9rHZoFTcPPtIUbFaIKeprSxFAuLaWKNk7YlNqpbJYt+Pf7w5hp3NJX1q49gFS7KK22zHAgO4k/umZ20ahPm0Qadhekvd4KehOiOOmjCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(83380400001)(36756003)(8936002)(5660300002)(6506007)(76116006)(66476007)(2906002)(6916009)(4326008)(26005)(64756008)(66556008)(6512007)(186003)(66446008)(66946007)(316002)(86362001)(6486002)(54906003)(478600001)(71200400001)(2616005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: lKXswpgxRPM6Xa0W6dEfGyQxPITie26lS4aJpFq2vGllcI3JSd+mIBMf4PSBSBibz3H9w+PzkPUZJxxyot3IYCQumlHA2BJU5f83uQbUoJpaXEcKWPST50HWjnJivnpaB4Rag4CT1UXb6UuqSK2nBxvJVueyXCliXGD0hn05Y22i1rp/xKhTB0FVxueSk4RKsNbaJV187bAWUTpXIQKZ+clw58xWyMpiDWgkqwhgutouissdhS3O7AM8Ex1zxBXcHuNVWb5W62m4dXiOVWzwdj/VKQcx/WulZsF5vYA40cP2TajQZHB/zVU8ef8eVFJAwSZqe3bmYNEIYrOcs+q0mlTowH0LLc6yjpIjyPJG5F9Dwk64AxTy0iTf98mKzLDB2bQjcM8sW14jbH0/oJHDSexDzEmXQGGNa6nieatYudpyV4DOyNNejtwTN0XU0d3KBvp5ZQ2L5LW7hIfXxd+VTmBnp4sLkRn2q3/P1WAAYQUl/Tv8+1PIT02SO03HWubl7IucaNIVcKvznUWoX1b/YqNZuu7k54Uzrd8LE6N6KH7iDQsdkPFuhTszwBdqScKoORR3tWgvjbIpyxmJQ7T9GXfpVvnD6tsX0OX7uVYXooS20vb0CyuZOoFxk4Es7YIS+slRPV2871wIAQIjAgn/VQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD61C5C93AC8A24C9E211633178BB564@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de3ba41-be8f-4e37-906e-08d858f8580a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 21:51:32.3443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbi3mqzsPSdBKqdPTfRwueePwPKAOUiPvxhNyRDYZpKDkZ1D5A/2rso+0aLpN8Z3mJD2jrxQ/G8d0EThnzUMtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2949
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600120294; bh=VNMTBEjkJC+e1KfaToMgRfC0fG+BfYzUWFvChSkvAUI=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Toym0rXEmORTxbGB/av8LW1Cq6KT2ypxcgFkjLcqetGVLos9W7DyNvTEDwTB53fuq
         lYoPVqxAG2GtbZM6iYLN/WxqcAMMkQdVLET80CmOIeIVTe0/NNlMKsOgwq+LarSmhK
         v1pVzKNBsdU0a5i0LhQQKdsEQu3GiFD6v+kfDWRYMcrzTGszIigFPEX7pH2W0wfKA2
         xBj5mYFPbkUD7TKItn7AgUy1F+kL6oCGF4SR3bN8tX50bsjsE5OXmzttxPM/Xs84zW
         FmRUPbkxxeehOqcAGCWSVBoM92ZyaqRfEh7Sd0NaorEBK9FHGDgPlPVxIMYnI+ZqXq
         OV6XxGOSB+PDQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDIwOjE5ICswMTAwLCBBbGV4IERld2FyIHdyb3RlOg0KPiBU
aGUgZm9yIGxvb3AgY2hlY2tzIHdoZXRoZXIgY3VyX3NlY3Rpb24gaXMgTlVMTCBvbiBldmVyeSBp
dGVyYXRpb24sDQo+IGJ1dA0KPiB3ZSBrbm93IGl0IGNhbiBuZXZlciBiZSBOVUxMIGFzIHRoZXJl
IGlzIGFub3RoZXIgY2hlY2sgdG93YXJkcyB0aGUNCj4gYm90dG9tIG9mIHRoZSBsb29wIGJvZHku
IFJlbW92ZSB0aGlzIHVubmVjZXNzYXJ5IGNoZWNrLg0KPiANCj4gQWxzbyBjaGFuZ2UgaSB0byBz
dGFydCBhdCAxLCBzbyB0aGF0IHdlIGRvbid0IG5lZWQgYW4gZXh0cmEgKzEgd2hlbm8NCj4gd2UN
Cj4gdXNlIGl0Lg0KPiANCj4gQWRkcmVzc2VzLUNvdmVyaXR5OiAxNDk2OTg0ICgiTnVsbCBwb2lu
dGVyIGRlcmVmZXJlbmNlcykNCj4gU2lnbmVkLW9mZi1ieTogQWxleCBEZXdhciA8YWxleC5kZXdh
cjkwQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBr
L3NkaW8uYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoMTBrL3NkaW8uYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvc2Rpby5j
DQo+IGluZGV4IDgxZGRhYWZiNjcyMS4uZjMxYWIyZWMyYzQ4IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3NkaW8uYw0KPiArKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9hdGgvYXRoMTBrL3NkaW8uYw0KPiBAQCAtMjMwOCw3ICsyMzA4LDcgQEAgc3RhdGlj
IGludA0KPiBhdGgxMGtfc2Rpb19kdW1wX21lbW9yeV9zZWN0aW9uKHN0cnVjdCBhdGgxMGsgKmFy
LA0KPiAgDQo+ICAJY291bnQgPSAwOw0KPiAgDQo+IC0JZm9yIChpID0gMDsgY3VyX3NlY3Rpb247
IGkrKykgew0KPiArCWZvciAoaSA9IDE7IDsgaSsrKSB7DQonaScgaXMgb25seSByZWZlcmVuY2Vk
IG9uY2UgaW5zaWRlIHRoZSBsb29wIHRvIGNoZWNrIGJvdW5kYXJ5LA0KDQp0aGUgbG9vcCBpcyBh
Y3R1YWxseSBpdGVyYXRpbmcgb3ZlciBjdXJfc2VjdGlvbiwgc28gaSB3b3VsZCBtYWtlIGl0DQpj
bGVhciBpbiB0aGUgbG9vcCBzdGF0ZW1lbnQsIGUuZy46DQpSZW1vdmUgdGhlIGJyZWFrIGNvbmRp
dGlvbiBhbmQgdGhlIGN1cl9zZWN0aW9uIGFzc2lnbm1lbnQgYXQgdGhlIGVuZCBvZg0KdGhlIGxv
b3AgYW5kIHVzZSB0aGUgbG9vcCBzdGF0ZW1lbnQgdG8gZG8gaXQgZm9yIHlvdQ0KDQpmb3IgKDsg
Y3VyX3NlY3Rpb247IGN1cl9zZWN0aW9uID0gbmV4dF9zZWN0aW9uKQ0KDQoNCj4gIAkJc2VjdGlv
bl9zaXplID0gY3VyX3NlY3Rpb24tPmVuZCAtIGN1cl9zZWN0aW9uLT5zdGFydDsNCj4gIA0KPiAg
CQlpZiAoc2VjdGlvbl9zaXplIDw9IDApIHsNCj4gQEAgLTIzMTgsNyArMjMxOCw3IEBAIHN0YXRp
YyBpbnQNCj4gYXRoMTBrX3NkaW9fZHVtcF9tZW1vcnlfc2VjdGlvbihzdHJ1Y3QgYXRoMTBrICph
ciwNCj4gIAkJCWJyZWFrOw0KPiAgCQl9DQo+ICANCj4gLQkJaWYgKChpICsgMSkgPT0gbWVtX3Jl
Z2lvbi0+c2VjdGlvbl90YWJsZS5zaXplKSB7DQoNCkFuZCBmb3IgaSB5b3UgY2FuIGp1c3QgaW5j
cmVtZW50IGl0IGlubGluZToNCmlmICgrK2kgPT0gLi4uKQ0KICAgIA0KDQo+ICsJCWlmIChpID09
IG1lbV9yZWdpb24tPnNlY3Rpb25fdGFibGUuc2l6ZSkgew0KPiAgCQkJLyogbGFzdCBzZWN0aW9u
ICovDQo+ICAJCQluZXh0X3NlY3Rpb24gPSBOVUxMOw0KPiAgCQkJc2tpcF9zaXplID0gMDsNCg==
