Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA69AAB316
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391725AbfIFHRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:17:11 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:63470
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388342AbfIFHRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:17:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnRDdJcn2pvs3vH3nBmwgFuHedgsz3Q82lQsCSkti+3YrQR8Dwj3tdKG9dJqLWUqqFV5QSnstqRNgcL772CoT+FblkM7WXpsfIiYviKKJEvYXE5ZQxTbhOjqZXOMqYy1r3KOEUDoTGYETpivBt8X4liOG0EB6z8F7syWmF66UXLNMCYCpNlLfrxo+7zZw9S45tJgPi/r+kHTIV0EG/4qmFnDmgdO5vQVYbMCj2ro6aw4uNnQ7iMnm2URDCoamia6pAybwSvE1MTUX9w4gGER+V7Ou+Mi0TIgBcQbsBrEeluHAU7juMhek7tDpJGKOnhhGWcZQBAffcF/9qEt6iuGAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SWUheO2U2uGqJk0NAr3505t19hH9DUpy0UgeK5hiWI=;
 b=CQtQJ3tthIEtKyENbwSxyEMUWq//JdmrIrbu/bYG08blWZrjRT/Ua9KvQrFfGwtLOG8w9++hpfmdoGHsCTDzGVk3sbz5xHCfT1LvLXglZECuTdnfOqc4w4GS/oaGsV+f8ksHPmCtPOL84WunMqAUSADmBGqVODTDTq0vpyVMf0/WERnCgKEOBOR44i9sBb0TM+eMFF1eAnmNBnKBfNmHoDRwXvtUJp0OKRMC0QAlW69M/AF+JxYpuTN7qiheMCpvMKHsW9oUD91WS6acH7wUAUxO8iEbIBXKj9MUsb+zTQh5im6zZvxrwr4kQpIJGcLsjOzoUWGx85ucj8w0N0lA3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SWUheO2U2uGqJk0NAr3505t19hH9DUpy0UgeK5hiWI=;
 b=dbADnq/ZrHbRGkLBvciHl6l8HxNwzzEGU2lP18S2hGJ+sxwieVV5Nm+4f7c1/u3BE0Yfim/+YqryMnT/t3/2Y3gryEbUjmbEMCir1XLgpa8fP/BG1f4lXujs61qNjbSufSCyl4IMD9r0h1o/5ln4FOL0xCNQbzT9hRDkIadL3Sc=
Received: from VI1PR05MB5104.eurprd05.prod.outlook.com (20.177.49.142) by
 VI1PR05MB4288.eurprd05.prod.outlook.com (52.133.12.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 6 Sep 2019 07:17:06 +0000
Received: from VI1PR05MB5104.eurprd05.prod.outlook.com
 ([fe80::d91c:613f:c858:91f4]) by VI1PR05MB5104.eurprd05.prod.outlook.com
 ([fe80::d91c:613f:c858:91f4%2]) with mapi id 15.20.2220.024; Fri, 6 Sep 2019
 07:17:05 +0000
From:   Aya Levin <ayal@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [iproute2, master 1/2] devlink: Print health reporter's dump
 time-stamp in a helper function
Thread-Topic: [iproute2, master 1/2] devlink: Print health reporter's dump
 time-stamp in a helper function
Thread-Index: AQHVWNmUHdn+5fmdAkSx+6o8r3lTuqcS0G4AgAuEBwA=
Date:   Fri, 6 Sep 2019 07:17:05 +0000
Message-ID: <5eb144c6-4088-ad92-2e79-3bb4bbfc1e61@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
 <1566471942-28529-1-git-send-email-ayal@mellanox.com>
 <1566471942-28529-2-git-send-email-ayal@mellanox.com>
 <20190829162533.25606191@hermes.lan>
In-Reply-To: <20190829162533.25606191@hermes.lan>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0184.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::28) To VI1PR05MB5104.eurprd05.prod.outlook.com
 (2603:10a6:803:56::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ayal@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b8bcd41-968a-49ac-b6ec-08d7329a38b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4288;
x-ms-traffictypediagnostic: VI1PR05MB4288:|VI1PR05MB4288:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB428820AA35AF258C1296F352B0BA0@VI1PR05MB4288.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(396003)(376002)(39850400004)(199004)(189003)(66556008)(54906003)(6436002)(316002)(6116002)(3846002)(66946007)(64756008)(66446008)(2906002)(52116002)(66476007)(107886003)(6916009)(6246003)(102836004)(66066001)(4326008)(26005)(14454004)(6512007)(6486002)(25786009)(229853002)(6506007)(76176011)(386003)(53936002)(53546011)(31696002)(2616005)(186003)(8936002)(81166006)(81156014)(8676002)(11346002)(446003)(486006)(476003)(31686004)(478600001)(256004)(86362001)(36756003)(71200400001)(71190400001)(5660300002)(99286004)(305945005)(7736002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4288;H:VI1PR05MB5104.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: apXc4NG10w+U3C40rg+je66zAS6lfu4pAbZEM/B7Y2ZCFx1k5NOqPgVLJ7y8T5VJo8zgHqPy7Yn9tKPOtHS9EaHdw9frGzOtWKTxd3KCUI1ZLv5vIN2T0jrPK7K1Z9y7AU8qtA3FoqhG96QquAIHyKWSIln9OZex+9jjEQuSL4REI7IRK/av+y/rOm4eJ7HM3kMOFQKlb6DpHs16UHW6RbzDfUV++T/KBYkiMpZmwgNR0/z1XVRA7GH4RcQaOXrl38aeO5VAHAECiDM8jcgWbY3ikWluaxHrwl0vNhIlxhScMJqrMjAKYozfSbzFvBEvzsNnCKN2THrKPblqoQx8QMULEVPPfQSP7Cqk6Yq+WLhMQnOoPMyERN1JyTEVmZeICDn5Bp/JbXcePwue/GXk37MH7AksRC7fo/C669fYbk4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21B0BAF16C02334F841E622514F055F9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8bcd41-968a-49ac-b6ec-08d7329a38b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 07:17:05.6579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cacCWpo4fBZGJuaDU8sptNiPgPT0a28z0HG6KI3QuInzlQ8EUrOXVpahiIQOz28nh5407BFXVMg8IMT0NQN4uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4288
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMzAvMjAxOSAyOjI1IEFNLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90ZToNCj4gT24g
VGh1LCAyMiBBdWcgMjAxOSAxNDowNTo0MSArMDMwMA0KPiBBeWEgTGV2aW4gPGF5YWxAbWVsbGFu
b3guY29tPiB3cm90ZToNCj4gDQo+PiBBZGQgcHJfb3V0X2R1bXBfcmVwb3J0ZXIgcHJlZml4IHRv
IHRoZSBoZWxwZXIgZnVuY3Rpb24ncyBuYW1lIGFuZA0KPj4gZW5jYXBzdWxhdGUgdGhlIHByaW50
IGluIGl0Lg0KPj4NCj4+IEZpeGVzOiAyZjEyNDJlZmU5ZDAgKCJkZXZsaW5rOiBBZGQgZGV2bGlu
ayBoZWFsdGggc2hvdyBjb21tYW5kIikNCj4+IFNpZ25lZC1vZmYtYnk6IEF5YSBMZXZpbiA8YXlh
bEBtZWxsYW5veC5jb20+DQo+PiBBY2tlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBtZWxsYW5veC5j
b20+DQo+IA0KPiANCj4gTG9va3MgZmluZSwgYnV0IGRldmxpbmsgbmVlZHMgdG8gYmUgY29udmVy
dGVkIGZyb20gZG9pbmcgSlNPTg0KPiBwcmludGluZyBpdHMgb3duIHdheSBhbmQgdXNlIGNvbW1v
biBpcHJvdXRlMiBsaWJyYXJpZXMuDQpTb3JyeSBmb3IgdGhlIGxhdGUgcmVzcG9uc2UuDQpZb3Ug
YXJlIGNvcnJlY3QsIGl0IGlzIGluIG91ciBwbGFucyB0byBjb21wbGV0ZSBhIGZ1bGwgdHJhbnNp
dGlvbiB0byANCmNvbW1vbiBpcHJvdXRlMiBoZWxwZXJzIGluIHRoZSBmb2xsb3dpbmcgd2Vla3Mu
DQpJIGdvdCB5b3VyIHBvaW50LCBhbmQgd2lsbCBub3Qgc3VibWl0IG1vcmUgcGF0Y2hlcyBhZGRp
bmcgbmV3IHByaW50IA0KZnVuY3Rpb25zIHVzaW5nIHRoZSBjdXJyZW50IEFQSSBhbmQgd2lsbCB3
YWl0IGZvciBzdWJtaXNzaW9uIGFmdGVyIHRoZSANCnRyYW5zaXRpb24gdG8gdGhlIGNvbW1vbiBB
UEkuDQpUaGlzIHBhdGNoIHdpbGwgYmUgcmUtc3VibWl0dGVkIGFmdGVyIHRoZSB0cmFuc2l0aW9u
Lg0KPiANCg==
