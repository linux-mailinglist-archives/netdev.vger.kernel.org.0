Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ABE1E6AF8
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406548AbgE1T3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:29:41 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:46080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406289AbgE1T3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 15:29:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GD3GJzgarcQg+Ocv9S15mbuh1P97d6Lyq/Cft2UtyCwpMx0wNk8mJPR8aaYINMtRBYjh27ISDk5Iq+7czfoglJqLvej9NqgUI+be3c46lDPx0TG5o7z88lHzzNcfUqkZg3PjB7Iqxv/nQSJRrFmb+KcHeuTt91P9oTdAHP4L5dGPSJemprioki4iU+o5zIBnivAO2kC7BWzWowZhmBdXFjZjNYyByJiXUXNCMQ0UHn1j8oknKmovgT1pNbGqBHTDHVxXSqxM3dt8KLJcWjF3OYI+PZeVuEbKFJHsad/vuDSiGC0QGHe9lVYAG+TobqYZEfHmcWrp9cYg1//iiRzcTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqWwB9309tuMS0lE50Pla6fJ9aTDRbGvGhtJpuKDrJI=;
 b=n7VksMDco2d3Qx24uapQJT4eUqkHP88T58g7nwzJUpTzf8Z8SPWp/UT7irwu+Yw/njYpMU3SBbNVxRBpKBeM8KMeGAjPERD67PL+RzNzg3fZS0+QSg+sRTTMTPeR9r8KZx3+l+ficFj+ki/JLuM+oyfXLouo4eR0t54O5mKwNX4vIvUVzkkmHHmc1aRQ4CMb3eQM9XYH2QtB/lV7LvOTK4UOlQddx0v24ipX+hCjHbPMiuReEvMsXwVfFS07AJDkr97RjV1mpqNIx/6Hz0myYIt5BErZI+MaQQFRzeIH6vh1gro2WYipFDs8R2jlhqyUQYdzCoi9LiyyVmirdlUAUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqWwB9309tuMS0lE50Pla6fJ9aTDRbGvGhtJpuKDrJI=;
 b=mTdjVwAjcu0kXLAjpUI6OIxFd/SBldi1PvSs27sVe6lWsjpi3WL6n9XGFkZMciHbNHZsegQhJnEyR2F0tiqfKu8A3G/OZvTpYpCjPMP67z3o7LNj1pQJVI2vmmnMSOnPzctF8YR9vuirbe7uLP1UR5N5ph5411WM0e2VUTfhdGA=
Received: from BYAPR05MB4470.namprd05.prod.outlook.com (2603:10b6:a02:fc::24)
 by BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7; Thu, 28 May
 2020 19:29:34 +0000
Received: from BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa]) by BYAPR05MB4470.namprd05.prod.outlook.com
 ([fe80::55e9:efdd:af31:50fa%5]) with mapi id 15.20.3066.007; Thu, 28 May 2020
 19:29:34 +0000
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
Thread-Index: AQHWNR7k5PzqqC69m0OKIKa4vjDJWKi93/SA//+NFwA=
Date:   Thu, 28 May 2020 19:29:34 +0000
Message-ID: <EE27E96B-155D-445E-B205-861B7D516BE1@vmware.com>
References: <20200528183615.27212-1-doshir@vmware.com>
 <20200528183615.27212-3-doshir@vmware.com>
 <20200528192051.hnqeifcjmfu5vffz@lion.mk-sys.cz>
In-Reply-To: <20200528192051.hnqeifcjmfu5vffz@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190512
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [2601:647:4c00:97e:fd55:6286:cbbd:103a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6599b6ee-7f72-4302-77d8-08d8033d740b
x-ms-traffictypediagnostic: BYAPR05MB3960:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB3960440FD2BCA15CCF317BD9A48E0@BYAPR05MB3960.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yvbpwZ6zbGDjEw4iF5FSmz7Tgb2ZBnldSKrwa6tH5L6qdKHi+eATX7Dm50lPdlC43QHjyZP/ysIlyosenhVdXH3O5c4+GzOdf0dWNDSl+YZ3NLtsFp8DFMkjHJLvdrOzJS++dXcTzXZmiHDYrZBOWssTovvPYpWDn0sfX8gO8AJjGSgQQsPC8QZKdr54oXAx9lKBTFDZxslvkJWmxiUfpQ5nJ609M8CopUNU8URhJLwqNnPqBIDZS7A+DoYi/+N42qz072YLAxXZyjTKEEkj19dFrlr+t58QuLlbgblPNmRTazKBud6PjusA5PhaRsNJTBIfjA8Y9KG1Xmnd08R4sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4470.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(36756003)(8676002)(86362001)(186003)(6486002)(6506007)(53546011)(66446008)(64756008)(478600001)(33656002)(66476007)(66946007)(5660300002)(76116006)(316002)(8936002)(66556008)(6512007)(2616005)(83380400001)(71200400001)(110136005)(2906002)(4326008)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uABSaOe10sn9QFkobNZH1DxDVzBVGDBvzMhgjLNRIInnyA3MsU4TZJEuAQmBT9ZGc4Kqx6sZwOFj2s0vgylF+HYeWOyRABcud7ma8IExg5bCOdYi711NtxLTI1QNRxdjLl1EvXF7GXckUIteR2A3vxmqpDmxlCb4/nxLS8nvYPv+CgeXWB15ihNeCP0nZ7vnwzSsHi++Ei0ibFnG/qw0Ue9B7u874ib168jZcypNzAmbqWYBG2sp/Ouy0IxAYstNaSHG79YCS9c0N+tmfx2cqYhjbP6tRn+v4+9XhN340fpOv0AdV+j8dEpnwRvyisUp7FS579gonGiX2TDYp+cKWyxaxQWnoykcQns3+cUBTvdqG3TJgPcAf0vJqKSKeNl/RL05VeloO+LMPZ/petLfwopFpJVBNj//eaHPblR9kQjE4P9N6u9BV0CV+NLzgavu/fafDhBc/MwwnaDKpEK6Pqfxk251LQbvSYPR5I6Y4oHoXjVGcIJAjp4YP9OXMae2D9aSRxhbNko/t3QaotqOkl+egH40kdik6cNJqeisQIM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70E64C63E18B5748BBFB9B3BD63C755B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6599b6ee-7f72-4302-77d8-08d8033d740b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 19:29:34.5173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hg3Gk0INijjF5bdRFyM5DA6D7Cd7OJ8T5k/lUJHfWXXiOPRjNAv2ECInARQKle59wkPhSwgWjqliu6HajL8/gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB3960
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA1LzI4LzIwLCAxMjoyMSBQTSwgIk1pY2hhbCBLdWJlY2VrIiA8bWt1YmVjZWtAc3VzZS5j
ej4gd3JvdGU6DQoNCj4gICAgT24gVGh1LCBNYXkgMjgsIDIwMjAgYXQgMTE6MzY6MTNBTSAtMDcw
MCwgUm9uYWsgRG9zaGkgd3JvdGU6DQo+ICAgID4gV2l0aCB2bXhuZXQzIHZlcnNpb24gNCwgdGhl
IGVtdWxhdGlvbiBzdXBwb3J0cyBtdWx0aXF1ZXVlKFJTUykgZm9yDQo+ICAgID4gVURQIGFuZCBF
U1AgdHJhZmZpYy4gQSBndWVzdCBjYW4gZW5hYmxlL2Rpc2FibGUgUlNTIGZvciBVRFAvRVNQIG92
ZXINCj4gICAgPiBJUHY0L0lQdjYgYnkgaXNzdWluZyBjb21tYW5kcyBpbnRyb2R1Y2VkIGluIHRo
aXMgcGF0Y2guIEVTUCBpcHY2IGlzDQo+ICAgID4gbm90IHlldCBzdXBwb3J0ZWQgaW4gdGhpcyBw
YXRjaC4NCj4gICAgPiANCj4gICAgPiBUaGlzIHBhdGNoIGltcGxlbWVudHMgZ2V0X3Jzc19oYXNo
X29wdHMgYW5kIHNldF9yc3NfaGFzaF9vcHRzDQo+ICAgID4gbWV0aG9kcyB0byBhbGxvdyBxdWVy
eWluZyBhbmQgY29uZmlndXJpbmcgZGlmZmVyZW50IFJ4IGZsb3cgaGFzaA0KPiAgICA+IGNvbmZp
Z3VyYXRpb25zLg0KPiAgICA+IA0KPiAgICA+IFNpZ25lZC1vZmYtYnk6IFJvbmFrIERvc2hpIDxk
b3NoaXJAdm13YXJlLmNvbT4NCj4gICAgPiAtLS0NCj4NCj4gICAgVGhpcyBzdGlsbCBzdWZmZXJz
IGZyb20gdGhlIGluY29uc2lzdGVuY3kgYmV0d2VlbiBnZXQgYW5kIHNldCBoYW5kbGVyDQo+ICAg
SSBhbHJlYWR5IHBvaW50ZWQgb3V0IGluIHYxOg0KPiAgIA0KPiAgICAtIHRoZXJlIGlzIG5vIHdh
eSB0byBjaGFuZ2UgVk1YTkVUM19SU1NfRklFTERTX1RDUElQezQsNn0gYml0cw0KPiAgICAtIGdl
dF9yeG5mYygpIG1heSByZXR1cm4gdmFsdWUgdGhhdCBzZXRfcnhuZmMoKSB3b24ndCBhY2NlcHQN
Cj4gICAgLSBnZXRfcnhuZmMoKSBtYXkgcmV0dXJuIGRpZmZlcmVudCB2YWx1ZSB0aGFuIHNldF9y
eG5mYygpIHNldA0KPiAgICANCj4gICAgQWJvdmUsIHZteG5ldDNfZ2V0X3Jzc19oYXNoX29wdHMo
KSByZXR1cm5zIDAgb3INCj4gICAgUlhIX0w0X0JfMF8xIHwgUlhIX0w0X0JfMl8zIHwgUlhIX0lQ
X1NSQyB8IFJYSF9JUF9EU1QgZm9yIGFueSBvZg0KPiAgICB7VENQLFVEUH1fVns0LDZ9X0ZMT1cs
IGRlcGVuZGluZyBvbiBjb3JyZXNwb25kaW5nIGJpdCBpbiByc3NfZmllbGRzLiBCdXQNCj4gICAg
aGVyZSB5b3UgYWNjZXB0IG9ubHkgYWxsIGZvdXIgYml0cyBmb3IgVENQIChib3RoIHY0IGFuZCB2
NikgYW5kIGVpdGhlcg0KPiAgICB0aGUgdHdvIFJYSF9JUF8qIGJpdHMgb3IgYWxsIGZvdXIgZm9y
IFVEUC4NCj4gICAgDQo+ICAgIE1pY2hhbA0KIA0KSGkgTWljaGFsLA0KDQpUaGF0IGlzIGludGVu
dGlvbmFsIGFzIHZteG5ldDMgZGV2aWNlIGFsd2F5cyBleHBlY3RzIFRDUCByc3MgdG8gYmUgZW5h
YmxlZA0KaWYgcnNzIGlzIHN1cHBvcnRlZC4gSWYgUlNTIGlzIGVuYWJsZWQsIGJ5IGRlZmF1bHQg
cnNzX2ZpZWxkcyBoYXMgVENQL0lQIFJTUw0Kc3VwcG9ydGVkIGFuZCBjYW5ub3QgYmUgZGlzYWJs
ZWQuIEl0cyBvbmx5IGZvciBVRFAvRVNQIGZsb3dzIHRoZSBjb25maWcNCmNhbiBjaGFuZ2UuIEhl
bmNlLCBnZXRfcnNzIGFsd2F5cyByZXBvcnRzIFRDUC9JUCBSU1MgZW5hYmxlZCwgYW5kIHNldF9y
c3MNCmRvZXMgbm90IGFjY2VwdCBkaXNhYmxpbmcgVENQIFJTUy4gSG9wZSB0aGlzIGFuc3dlcnMg
eW91ciBjb25jZXJuLg0KDQpUaGFua3MsDQpSb25haw0KDQo=
