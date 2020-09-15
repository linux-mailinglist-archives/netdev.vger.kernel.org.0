Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9042269DB0
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgIOFKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:10:04 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:11980 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgIOFKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 01:10:03 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f604ca80000>; Tue, 15 Sep 2020 13:10:00 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 22:10:00 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Mon, 14 Sep 2020 22:10:00 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 05:09:57 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Sep 2020 05:09:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEiyJQoENdPdfuaMNjqenimg/iSI9QPIQ7DBV/hZzOnSX368dZ+6igGs+8+qa33KGyatRjPq+F2RwSWPMLpLieHa/CMLBAV9JkyFIyd7ELQXIgLaFJ8RmxL32OqYxIcQrVuXPi833pTOiApFPO7rfRpIKQuUl7ZxHWf8+EP09DEyEluDOfJdLJJcBQYQ9Du3Bamud69vgOH54K6g2FlreApksb8s9PSc0XZY1eSHhQZHkI9VX2iOYhvfHTov8WJCwPXMqcLroq/MqB9rm0vS8mYrB0HNrINtBvkdqt/ekeHdm9mXwXfsTS4NF3Q9OakTvy08C4Dz0FnZUf1n/7k21w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJJUIzIVx0UTuysqsYuNUJq1zvgW7ydxQrboxygTpvU=;
 b=QCsZmY6iRycwcVYQx/N3BLYsBN+KgCHcdPvt055Qfvkx4S/cfL6mgmaqUogdnSL7JzDOlXWkjtLwJBobqF6ymDzYb9yBIv9ory8rAEnpGPyQCo7mkhCNOwrldX4cTV6hva91V9KsQ7D4XrFNxr2LMhakiFlVNYH8pCsEe2QuSyadwF9EyLLVzZ6wsHcNCvMLZLJEvtvE7BQs0FkkPYkcePaWmSWjcdryNg8NCaOXaV56lxQX42iYmBkHH8m6US37bfekj68PDyzeVjFf0duUW/Bo2WwOZckRt6e9QOw9LcvFEIjvVvjvmKNhUC+4sbjy+l7rsMZkL+dK+VfpzC2wEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4019.namprd12.prod.outlook.com (2603:10b6:a03:1a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 05:09:55 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 05:09:55 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next 6/6] net: hns3: use napi_consume_skb() when
 cleaning tx desc
Thread-Topic: [PATCH net-next 6/6] net: hns3: use napi_consume_skb() when
 cleaning tx desc
Thread-Index: AQHWir2H3yf9It5/Nkq7TwBJZtpCxalpJ2kA
Date:   Tue, 15 Sep 2020 05:09:55 +0000
Message-ID: <e615366cb2b260bf1b77fdaa0692957ab750a9a4.camel@nvidia.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
         <1600085217-26245-7-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1600085217-26245-7-git-send-email-tanhuazhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf316dbb-af1f-4faf-4c45-08d859359607
x-ms-traffictypediagnostic: BY5PR12MB4019:
x-microsoft-antispam-prvs: <BY5PR12MB4019913FA121EF217718C60AB3200@BY5PR12MB4019.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vai29TXPIUdacPYlgdTdDvbHApAKmzli95yY2p4qeqdqoL149U4n9gjKw2Y684whAoczMszbNmSgD3MKnp++RRDMcOqb7BWpF1ogUBPuWPgxbiA1HK1mQNuJG0aekCSYL/7PTegN3IBUmWkfYwOMZQbDce5YU3QeO87F6vVLM4hUB61PgUKqS6zvbUh/lqMlIbJmTPxhN9H2e8CO1nqbTfUW6hMvJyWuENigvYOeiT/hkf7iQ2NNjeqxNDx3NbstGPF8UPjsUZfo6bNA0Yt95O4IZ5QqaD0Q1n9nnK3gZEh3zD4Mc4lV2eX+Ni8+7QXt4AMr21hx5UXWT7PnyPlCxFvAG58V7MG9pTt1Re4bYMP6x7EEJcp58KsQvbm32UoM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(8936002)(76116006)(66556008)(2616005)(66446008)(64756008)(6512007)(71200400001)(66946007)(66476007)(6486002)(4326008)(6506007)(26005)(5660300002)(83380400001)(186003)(8676002)(316002)(2906002)(478600001)(86362001)(36756003)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3oGrI9/JO0hjtq3hGswiiCTacM+sgzpwznz3eiUrBnDzhSYMFuSFwRbeJVI+uda0K8F4+Ivb/F2MrGUp2F4u6MbZqzuvBzY80Hrj6lPLUEjlWlj7EUsAcsRAJ/ibT2wnhMpczGS1LrM1lfQGpGCp5J4p51OArzzvk5plXWwfDMRce8TraOmUplPIWDlsuiFu6W+bA1/jRi4gFlkSsIv68bkE5yLdpKfuyOnjAOuNnqlPGTPZWX5q0a0Y6asv/WaBqrjpAWZkLoVMs+cAceyBMD46cchYtPB5v/euHNHifzStjHIc6MbGH8IxgcmEIWynfYq9ZxYDZA2qfh1RDIV9TLzOHrtV8EooxFI8nuqO1MYlPPi4SXiDvQw4e1QrEBU6bZJrngM+nWPEVXhhSluq/REjI0LKqkDOgEx4APucVjI2m1SFcVKnoF1rQd7wl46WXfTxlMAYP0aOx2WRoj7BucL2XoVs2XNK7b+K5YG/UrTbfEuO9vyKXjWUVMfsrUChsfz18OzOLShdlQP+CawgR5bjQy+hOm8bJSsEHEyZzXCUP5HWFbYDlMBQpQOHHDPH6YgU83NHao6kkghf1AN1uzE6RuPOb3FbRTB4WhV2I7jmEnRB/AMh+XLjWnEYtCX15+DXaQwpCkJh2G24ukdnzQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C83526DDD8582F469BDF75DC8BAF18E2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf316dbb-af1f-4faf-4c45-08d859359607
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 05:09:55.6790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MY9/vfXH6Yvmr579qGtjvED1UAVLha6QKiT5FoK9GxtOF2uAkEcKlDic+H++X3dpyn6zIECk/3Y10iNOZOcAfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4019
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600146600; bh=gJJUIzIVx0UTuysqsYuNUJq1zvgW7ydxQrboxygTpvU=;
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
        b=T7MP5eZjjwTaYH1JGY2R2aF6DbE2SlCVjXfg/eQDR3l/DMZcH3mHy5QfbZxSWlmXh
         74jsxwTjFLiyKxnEtWDoS5qdiOejBXb+Z1l2uC9BMAi1fk3myRMU7f7TTTDxYc15E+
         DW0vOQS2xvHdvgZxdTagM6iz6LG1dgTG+Tak0vwlhnxqh1zCXEqAIsr7TpAOv4trO+
         1Ondr9DLQYReG2Bbdsmquq0Y+QRy7XfT6MG77loktqlXPF1NucJCOc0PCKxhRe2uhg
         rbhjipT/tpYMap0AxFzLAiAbj4YM3/m5wVyPdlX41Ii9JKtB3s6lFcEIqJUuQ2kMgM
         AA5vsGvor04jA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDIwOjA2ICswODAwLCBIdWF6aG9uZyBUYW4gd3JvdGU6DQo+
IEZyb206IFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gDQo+IFVzZSBu
YXBpX2NvbnN1bWVfc2tiKCkgdG8gYmF0Y2ggY29uc3VtaW5nIHNrYiB3aGVuIGNsZWFuaW5nDQo+
IHR4IGRlc2MgaW4gTkFQSSBwb2xsaW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWXVuc2hlbmcg
TGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBIdWF6aG9uZyBU
YW4gPHRhbmh1YXpob25nQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaGlzaWxpY29uL2huczMvaG5zM19lbmV0LmMgICAgfCAyNyArKysrKysrKysrKy0NCj4gLS0t
LS0tLS0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM19lbmV0
LmggICAgfCAgMiArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5z
M19ldGh0b29sLmMgfCAgNCArKy0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMo
KyksIDE2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2hpc2lsaWNvbi9obnMzL2huczNfZW5ldC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aGlzaWxpY29uL2huczMvaG5zM19lbmV0LmMNCj4gaW5kZXggNGE0OWE3Ni4uZmVlYWY3NSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM19lbmV0
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM19lbmV0
LmMNCj4gQEAgLTIzMzMsMTAgKzIzMzMsMTAgQEAgc3RhdGljIGludCBobnMzX2FsbG9jX2J1ZmZl
cihzdHJ1Y3QNCj4gaG5zM19lbmV0X3JpbmcgKnJpbmcsDQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2
b2lkIGhuczNfZnJlZV9idWZmZXIoc3RydWN0IGhuczNfZW5ldF9yaW5nICpyaW5nLA0KPiAtCQkJ
ICAgICBzdHJ1Y3QgaG5zM19kZXNjX2NiICpjYikNCj4gKwkJCSAgICAgc3RydWN0IGhuczNfZGVz
Y19jYiAqY2IsIGludCBidWRnZXQpDQo+ICB7DQo+ICAJaWYgKGNiLT50eXBlID09IERFU0NfVFlQ
RV9TS0IpDQo+IC0JCWRldl9rZnJlZV9za2JfYW55KChzdHJ1Y3Qgc2tfYnVmZiAqKWNiLT5wcml2
KTsNCj4gKwkJbmFwaV9jb25zdW1lX3NrYihjYi0+cHJpdiwgYnVkZ2V0KTsNCg0KVGhpcyBjb2Rl
IGNhbiBiZSByZWFjaGVkIGZyb20gaG5zM19sYl9jbGVhcl90eF9yaW5nKCkgYmVsb3cgd2hpY2gg
aXMNCnlvdXIgbG9vcGJhY2sgdGVzdCBhbmQgY2FsbGVkIHdpdGggbm9uLXplcm8gYnVkZ2V0LCBJ
IGFtIG5vdCBzdXJlIHlvdQ0KYXJlIGFsbG93ZWQgdG8gY2FsbCBuYXBpX2NvbnN1bWVfc2tiKCkg
d2l0aCBub24temVybyBidWRnZXQgb3V0c2lkZQ0KbmFwaSBjb250ZXh0LCBwZXJoYXBzIHRoZSBj
Yi0+dHlwZSBmb3IgbG9vcGJhY2sgdGVzdCBpcyBkaWZmZXJlbnQgaW4gbGINCnRlc3QgY2FzZSA/
IElkay4uICwgcGxlYXNlIGRvdWJsZSBjaGVjayBvdGhlciBjb2RlIHBhdGhzLg0KDQpbLi4uXQ0K
DQo+ICBzdGF0aWMgdm9pZCBobnMzX2xiX2NsZWFyX3R4X3Jpbmcoc3RydWN0IGhuczNfbmljX3By
aXYgKnByaXYsIHUzMg0KPiBzdGFydF9yaW5naWQsDQo+IC0JCQkJICB1MzIgZW5kX3JpbmdpZCwg
dTMyIGJ1ZGdldCkNCj4gKwkJCQkgIHUzMiBlbmRfcmluZ2lkLCBpbnQgYnVkZ2V0KQ0KPiAgew0K
PiAgCXUzMiBpOw0KPiAgDQo+ICAJZm9yIChpID0gc3RhcnRfcmluZ2lkOyBpIDw9IGVuZF9yaW5n
aWQ7IGkrKykgew0KPiAgCQlzdHJ1Y3QgaG5zM19lbmV0X3JpbmcgKnJpbmcgPSAmcHJpdi0+cmlu
Z1tpXTsNCj4gIA0KPiAtCQlobnMzX2NsZWFuX3R4X3JpbmcocmluZyk7DQo+ICsJCWhuczNfY2xl
YW5fdHhfcmluZyhyaW5nLCBidWRnZXQpOw0KPiAgCX0NCj4gIH0NCj4gIA0K
