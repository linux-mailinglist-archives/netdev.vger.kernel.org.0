Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E911E6D42
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407519AbgE1VJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:09:39 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:6145
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407447AbgE1VJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 17:09:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfQfM+3mWysZUAwDJif6k2KShgBxB+mlauUhspnfejOIxDICK2FYAVq3wbjDly/+NPwE0dsUzdmCEH87QCpK0DSQ/tnBhJOf6nDgty3zdbMiUAAIlQj8wVKwOp+omvbjpUXtwWQSadkOsqBiwOrQnczPzmK7PWNFRNtYiFDRuYjwIo1j+Nd0Z+Z8O+coFMmyTITZRuHxi9KUgOGNa4e6t1xAgoN3QdFNF3BEZz2ojSMKHpcBhn4wIWH2/+MAD4sAmLGhXGtrO2A0IkZGRHUSmgbDfGqNWlEpvJGBlWGzixXGf4T4jZ5gJgn0HrwSR2LyCwoTiyex6vnrmTKaG78awQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqPVtKJP3g3I05Ex+6H0bOPS68CoFKmU+TWXnzLqwWw=;
 b=E07OO3f/J4BPX5tXJjsG1pCnMOCQ2H8xorZVa3LuX9bhz59KC6AllMXM3e2/kUfcZsGSIYOFh3K8Fc8pNCbsQRXeylzwFWfPmoV4gmAnx+MXsMEsbQ3bT3cqERCyGvgKJD4hLvXbNi4qiDyo6pjysaQo81xi51SlqoU1GWS1DNSZZDuF/ec2p8EslX2GBwU6yzBc7Bms5We6LUqc/kTvvl9NxCJ0PepXg8DnkicoAo3QBKwFgEsnMJwuIQ+/5ui5HvdiVQUpKQutGXAIUoqlQtzumzl0sNA/P+zTqC1c0/aPJ/kxsUXx/1KFfJmTmjEto1G53Qz0JQ4UKcJx3hDYow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqPVtKJP3g3I05Ex+6H0bOPS68CoFKmU+TWXnzLqwWw=;
 b=f0j6iDYkvXZ9l6nSqK4RP8/vAHOGKDL+LzyEJ049V15ZzckPfZoVrrood5wV65hqCCNE8Cfmt41yKwS5Vs7LuJhL6cP6EvqKxMyLyl94fbo7ATh57TpQeRV3ZZ7AiSuNJmNe+it7v6YE+TnzazmBh7K8lb2DMYXAFCtiH3tzZKw=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by BYAPR05MB4791.namprd05.prod.outlook.com (2603:10b6:a03:45::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.8; Thu, 28 May
 2020 21:09:33 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa%5]) with mapi id 15.20.3066.007; Thu, 28 May 2020
 21:09:27 +0000
From:   Ronak Doshi <doshir@vmware.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/4] vmxnet3: add support to get/set rx flow
 hash
Thread-Topic: [PATCH v2 net-next 2/4] vmxnet3: add support to get/set rx flow
 hash
Thread-Index: AQHWNR7k5PzqqC69m0OKIKa4vjDJWKi93/SA//+NFwCAAIIMgP//mdsA
Date:   Thu, 28 May 2020 21:09:27 +0000
Message-ID: <79D16E6B-CCEA-4EEA-ACA6-77AA59FE6B8F@vmware.com>
References: <20200528183615.27212-1-doshir@vmware.com>
 <20200528183615.27212-3-doshir@vmware.com>
 <20200528192051.hnqeifcjmfu5vffz@lion.mk-sys.cz>
 <EE27E96B-155D-445E-B205-861B7D516BE1@vmware.com>
 <20200528201501.q4rta6v2xjxn26ti@lion.mk-sys.cz>
In-Reply-To: <20200528201501.q4rta6v2xjxn26ti@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190512
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4c00:97e:fd55:6286:cbbd:103a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63f2f198-ee0a-47f0-25ac-08d8034b67fe
x-ms-traffictypediagnostic: BYAPR05MB4791:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB479110614C5DDA1AFC1B41CDA48E0@BYAPR05MB4791.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BUVRD+hCIepREgn8AsqWRoMxZRakmOAs0ZGzrF36pH2L/0boTyCwD4SgA7bo15Lc/A2IHNBO96nfXZs8kTy3xu/gstvVSSWr7kf9qP5AObg/cYCvKysLBqjEp45GWgEKYuwtXpoj7vmoW3cDeTrgoikfpjth4YMXkJlPC51fb7Gc4+6TdGjhP/t5rvf/L3EoV35krTnfspBRhLdrjQIvj3QQGYWFuyQQop0reEJrUgz+8aEGIHuRQx0okQnmWGt+qDgXrWSIeS9WHYz+y8mhdELsssdRaau+pbcKkJpnF9MYuG5RDaxzWWuShlGicVA7XJ/B0Rxlg5b10J1U0UZHDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(8936002)(6486002)(86362001)(66946007)(71200400001)(33656002)(76116006)(2616005)(4326008)(110136005)(54906003)(478600001)(83380400001)(6512007)(316002)(186003)(2906002)(8676002)(36756003)(64756008)(66556008)(66476007)(66446008)(4744005)(6506007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vo36TfDdWBWf8ekA3Jv3jhe7Y/Ijl0Fjb0nd/BWGp1lTwpTD7EnieYf7lwF8FG6vR/nqEkLbJv/tuXNYKUJlOKhCEJpNif/KV7l8JOwTLF4aYkRzNnfm9MGrcaf+D8k1wU1J92FElvypdhnZm1JTEHaJzVmA3HCc8HUHxxF6Dh1LkLZ/PAXFQFeq7AJMRziKCJSTRl/CRl7JZEXb6jsHjuJXUtSeIzr6+ViHkbxctMiLYyoe7ux2Tgldzmuc6tW1lv//BIk5cHe70lx1NkCh/aZiVEX8PLBO/MetUeore2ZTf4YgPb+cZb3I3RtlLgMwM2oJonQBMo/V6WnF6UozvsU3wEW10uze2AOk5VHd8/ald/N/ELTpvfod+eGsRT1H6tuRvCniDlPKfo569YWy6gY5yKJBTXT4cJ8tHuQCgol10Jj8uuCoy9t+TJLN5zjmyyusU9AfLRz9v98EwsIF4w4gw3Po/bSXoFA0Wuc5z1Ksw8EGMwR+gRnk57C88WVBUiZp0ShzVUUY9P9SiNxz8cUbKH38YD6HY3VMQT4ITs0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CA8635AA4FD2C499477F4F410B7FB6C@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f2f198-ee0a-47f0-25ac-08d8034b67fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 21:09:27.2875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eojh9TrezFh0SMuf1aIpPIdDbZGvdydstAjekotmw56OBsuOUmtI7GWISa1EChY9lnsJ8gZDEvPR7otL326O/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA1LzI4LzIwLCAxOjE1IFBNLCAiTWljaGFsIEt1YmVjZWsiIDxta3ViZWNla0BzdXNl
LmN6PiB3cm90ZToNCj4gICAgVGhpcyBtZWFucyB0aGF0IGZvciBib3RoIFRDUCBhbmQgVURQLCB5
b3UgaGF2ZSBjYXNlcyB3aGVyZSBnZXQgaGFuZGxlcg0KPiAgICB3aWxsIHJldHVybiB2YWx1ZSB3
aGljaCB3aWxsIGNhdXNlIGFuIGVycm9yIGlmIGl0J3MgZmVkIGJhY2sgdG8gc2V0DQo+ICAgIGhh
bmRsZXIuIEFuZCBmb3IgVURQLCBhY2NlcHRlZCB2YWx1ZXMgZm9yIHNldCBhcmUgTDMgYW5kIEwz
IHwgTDQgYnV0IGdldA0KPiAgICBoYW5kbGVyIHJldHVybnMgMCBvciBMMyB8IEw0Lg0KPiAgICAN
Cj4gICAgU28gVURQIHBhcnQgaXMgd3JvbmcgYW5kIGlmIFRDUCBhbHdheXMgaGFzaGVzIGJ5IGFs
bCBmb3VyIGZpZWxkcywgaXQNCj4gICAgd291bGQgYmUgY2xlYW5lciB0byByZXR1cm4gdGhhdCBp
bmZvcm1hdGlvbiB1bmNvbmRpdGlvbmFsbHksIGxpa2UgeW91IGRvDQo+ICAgIGUuZy4gZm9yIEVT
UHY2ICh3aXRoIGEgZGlmZmVyZW50IHZhbHVlKS4NCj4gICAgDQo+ICAgIE1pY2hhbA0KDQpPa2F5
LCB5ZXMgZm9yIFVEUCBJIHNob3VsZCByZXR1cm4gTDMgaW5zdGVhZCBvZiAwIHdoZW4gcnNzX2Zp
ZWxkcyBkb2VzIG5vdA0Kc3VwcG9ydCBVRFAgUlNTLiBJIG1hZGUgdGhlc2UgY2hhbmdlcyB0byBh
dm9pZCBmYWxsdGhyb3VnaCwgYnV0IG1pc3NlZCB0aGlzDQpwYXJ0LiBBbHNvLCB3aWxsIHJlbW92
ZSB0aGUgY2hlY2sgZm9yIFRDUCBhbmQgcGFzcyBpdCB1bmNvbmRpdGlvbmFsbHkuDQoNClRoYW5r
cw0KICAgIA0KDQo=
