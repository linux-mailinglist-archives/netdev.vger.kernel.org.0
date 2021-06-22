Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B963B0191
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhFVKlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:41:50 -0400
Received: from mail-eopbgr140083.outbound.protection.outlook.com ([40.107.14.83]:57205
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229628AbhFVKlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FN6QyondipkHXWSqP1qxg1WiLTNt/FuJ5ijaVBYursQJVVwhcUyQdb6kpBTI4/aIBe4WG4vCPW7BTjeDPpC+aD4pkBDkRBLXdwG2yxja+Y/NuaINereNFMGA5iYk+MYRfyjb17tsFIWSGbdlug3k893aucxujDwDGB+CPEgIhujKIUTQ60wHLu5QhfeeO2gughouRGZuO4xre9MNN7cA64zFDBYlfuzS0agfjWGi43bLMKuUO2Smp+WXJJoZ+yerEdocfgeFQ132GUDkb75cBiM7c02OXwEELvwb5lp7MzTwA4BF2S5eqVOklsw3HwrBAUlwEyOn6VcnCH9AJFVYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSz8b2LsWmxnq21CC9754hyDb8H8Jy/bAHJtpnsU+5Q=;
 b=bR+zahxBfJvagjwM6ST/qniafcuu4TKiD0dJKvykM/mU7po1LjBJNAOpbvBZr5SX6Z5fQxA97RoRhQDaj7Kko1i3qmnAIy4865fKN2njNnBhM8XRqyo48SbVSeIlqGhmcUSQG0Zgvv4d47+nkHYtrHTB3W/T/18zufTwzh0B/MmOCxJO0fxI0lbTMtGyjjMdc3S5TcfezjUTwsD5in6J7tFA+HCVQCNV+rJ595zPo/upjnFSFCm9FnoDV1vX9AQW4BbJh0w/ODjc2mTw9YFIgG4NzJ7a5dRIPSJk/RephgjyOcJ7rH7WJKfaT/kvNA9uhXOQ7D/AeQJ/8J4zVYlTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSz8b2LsWmxnq21CC9754hyDb8H8Jy/bAHJtpnsU+5Q=;
 b=QscsDDqhjiKmdAVxsJ5SRXCcdambcRfhcFOy8Ccx+c1yfXdEtOVY6fNsD+PSlX4Xea0dM/h7v4wnABFBL1vTEdN3+vo8ZrnqeO2u+abpOU6qJrPscW7TFtNN7Yu8rfljiI6xFyDbI2GXZ/C58N1Y6yjkvThvUKOfk0aZIiyCpng=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 10:39:25 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:39:25 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Topic: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Index: AQHXYcnwaUvaYN3/1UWKJ0RWryDTcKsavVqAgAUjr7A=
Date:   Tue, 22 Jun 2021 10:39:25 +0000
Message-ID: <DB7PR04MB501756892A5B773671ABD044F8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-3-yangbo.lu@nxp.com> <20210619040623.GA14326@localhost>
In-Reply-To: <20210619040623.GA14326@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c65294f8-5857-4437-f4bb-08d9356a013e
x-ms-traffictypediagnostic: DB8PR04MB6459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6459DEED6C7F937BD1759950F8099@DB8PR04MB6459.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gktCSC2pepATIpMgOWriIVCxUlARMPsgMSY1c+lD/djZBDSweyJQPigL8wmOdn9NtYmGQpKw6W6uLUd9O8toapvOJI1UQombYE1UnGx5zuSsmb5oTLe9QBLROzXXLT3Xtz9Mn0RjbnEBPVT91bMMXx+K8WmqvqE8U/GmYkLe3fnLENFySpVHDJz4viCYatDmaLWpQQIsy1CONC6NQhZxvDmEYxsj9fjz+CcCLr74bqmSSm1SQddWLpMbfzgChsnpcbjsfDJLNHFKSO38Uuv4CgzANeT8In1sb8a0KKwHaXxVvka76Y3TG88HieG/qprobINMHbnasyPNiOlUlApTqyp/C6gQ2FaxFseuU5v/z12/dTIwk7imSM/czFKPSPqgQNRg0A8LfcWuI30VwalhwmMPZ40RKh5NgeNe1l/x/et3fCs7KjQ7HlM24K1bvZtMyXNTheTf56TDoRv2AXGu9k9tcen2iIRbxC+h1357EU23SKlcAuMeS3/KhFY6s3xmEPK+6TebPohzLaTdLH+OjofmzBKsjIdPzdEM6l+hKx5/XosfwCpGaQ1Ja4o7mmaHyCorZuma8q6oDMDhCgwsYhSL5cPLqwQaEOS7Dy3bD0w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(7416002)(33656002)(2906002)(6916009)(71200400001)(83380400001)(8936002)(8676002)(38100700002)(66446008)(64756008)(66556008)(6506007)(478600001)(55016002)(9686003)(4326008)(316002)(7696005)(186003)(26005)(66476007)(66946007)(76116006)(54906003)(5660300002)(52536014)(86362001)(122000001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?YVpZZUFScFlRS3FrK3pVNTl3YmE5bTl2SXVKbDdvTVFXT2FzeW5nZ3htTk5L?=
 =?gb2312?B?SjNXVzAxTDdYQmhaRERzeXl6V1l4dk10NzduNDNnMUlCZmNLTVpIZTJxUnI5?=
 =?gb2312?B?alhPdUo5N1BZanVwZU1YVlAxZ0l0Mkc1VmhieHN2Q0N2bVRZdEZyNHBESStk?=
 =?gb2312?B?Nm9ROU9HeVdzMW9zOGM1U05YSWtmNE81cmR6MUtNVGUzSkkxSDFuVm5MWEJh?=
 =?gb2312?B?aUpDV2tCZ3NFa2VXdktZT2tBdDN6clNxUXFMSGRCWmlKd2Z3WjduTitkUlda?=
 =?gb2312?B?czh1WHR3THB0ZDFhdGVnUWt4aVpEMjRTR1A3emZ5TllHT21PUldGM3BySnp1?=
 =?gb2312?B?SWY5OVo3aHBTWXJsM2V3ZHF6WlFFcFFtUnpUMkxqeHJaWHphdkU4S2xHb21E?=
 =?gb2312?B?anZ4VjYvV24vaytNV3hvWUVNZHl0Y2gxMmF5dzZ2ZWpFM21ibkdSZFlRbjRH?=
 =?gb2312?B?b3FSZUZaOTJML3hldUxDbWRFb3h0MGkrMU1nN2NPY2dyVVRNMzNIbzRHam93?=
 =?gb2312?B?RVY0blo2U3p0NzUza2tNUmtJWklSV09GMjlOTXBqY3U5dy9DRE93ank4a1BB?=
 =?gb2312?B?QVNGT21jWW1OOUN4c09ob2VkY3l2ZEptT3hIOEVPc3pWR2JVODBVN1N5SmpR?=
 =?gb2312?B?NEIzNXBMMC9OTEhkclQ4YWJJVkcrSGJQK3NiTTNwTkdIWlF3MS8xQW9kUHds?=
 =?gb2312?B?cldZdlIxM25iNjVHa3dva2hlMGJEdnRYWTYzTGlFKzFoV3EzSkM0WVlyM1dl?=
 =?gb2312?B?OVZEZm5BMjBZOUlYLzZqY1hnaXdUd0RnRjUwemY0QXUxNVdoRTRqQWVodTRk?=
 =?gb2312?B?cDB2dCtzU0cwQ0ZSbHhsZzBuZEh2S1NHV0tiRmhPMmFCK3N5c3JnMUdqVklN?=
 =?gb2312?B?MTdzdjdOeFRyUElIN0Q2dG5ybjd6Mi9OWmpNWXBSZzJPcCs1TWVRcStNM0NY?=
 =?gb2312?B?V2V6ZWlRSitJK1RvcG14eFdhS0FtVHVDWTZMdlNiWGRVc0VCUXdEb1RzTjF5?=
 =?gb2312?B?YjlUd1B5c1RtQjZYRXY4OER5dGkxYkxIWGM0ajgyVWpoeTYvUHM5QTdiQjIw?=
 =?gb2312?B?MjVzdlZFVEtMc3dYamcySkhXL1BqR1BjNzFxVWI0dDZLYVZOR1NxYWRlZW5U?=
 =?gb2312?B?dWZBUklmTzBmVDRoTlZFMC9NZTlsT0RuNytWV1Z2akxoaEUwN1h4Mk1md21Z?=
 =?gb2312?B?SUhzNHF1UnVVYnZDOFUwVndMKzh3S2tEWW1iSmd6b0hFZ3k4UkJNQlQzOU5C?=
 =?gb2312?B?Y0pnWERSNmJsM3NvOTVBcmRYOTJTWDJPTTZ0RUtnK1k3dTY3emVqVHpPenB0?=
 =?gb2312?B?ZjIrWlUxdzV1TGxvYlQ4aUdDdHhxbU5UT3dMR2VoMi9HVW5aQlJFSG9aMzZF?=
 =?gb2312?B?MWlwTTJaUUs1Vm1CcTAwa1ZPaEw2c2o0Mmh5TDU4aERDR1BWQmNBUldqUVY5?=
 =?gb2312?B?T1dpcVRSais5U1dzY3kxTzltbmJTbzVvcy9qTTNlRzQrTlA2akFjbkNzZmtm?=
 =?gb2312?B?NXB1TzRFd1BnUXVYQkRIZ0t2RkFDV3k2YVQvTlN5UDB2bkdZOHd5QW5WZm84?=
 =?gb2312?B?eEVZMmpCbVJuNU95MS90OThLWjlUVzcyQ1FRU1V5YUtUV29helFNbWloUEsx?=
 =?gb2312?B?elBRVEc5ZWN3ZFhMVlJqbGptalM5T2VyNDgxaFA1eXh3dXBFUWtGU0lsSnNi?=
 =?gb2312?B?MVlsUjlaaTdWMG1HdDRqb0xneE5EcEQyYUk3NjNHNnA2YlZnb3UrbzZESmcy?=
 =?gb2312?Q?Uuyc3803XOc8/qGv+8MUyHZSHX6iSWZtrafE8tp?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c65294f8-5857-4437-f4bb-08d9356a013e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:39:25.2085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGKbF2hcICQ5PdiWO0OldpP1HAK23PE7DyAz97t1cah2gjYrwuWe52rLyGwG8FBF5/z8S76/pxxsoFeD+QLWYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNtTC
MTnI1SAxMjowNg0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1rc2VsZnRlc3RAdmdlci5rZXJuZWwub3JnOyBtcHRjcEBsaXN0cy5saW51eC5kZXY7IERhdmlk
IFMgLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsgTWF0IE1hcnRpbmVhdQ0KPiA8bWF0aGV3LmoubWFydGluZWF1QGxpbnV4
LmludGVsLmNvbT47IE1hdHRoaWV1IEJhZXJ0cw0KPiA8bWF0dGhpZXUuYmFlcnRzQHRlc3NhcmVz
Lm5ldD47IFNodWFoIEtoYW4gPHNodWFoQGtlcm5lbC5vcmc+OyBNaWNoYWwNCj4gS3ViZWNlayA8
bWt1YmVjZWtAc3VzZS5jej47IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29t
PjsNCj4gQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgUnVpIFNvdXNhIDxydWkuc291c2FA
bnhwLmNvbT47IFNlYmFzdGllbg0KPiBMYXZlemUgPHNlYmFzdGllbi5sYXZlemVAbnhwLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtuZXQtbmV4dCwgdjMsIDAyLzEwXSBwdHA6IHN1cHBvcnQgcHRwIHBo
eXNpY2FsL3ZpcnR1YWwgY2xvY2tzDQo+IGNvbnZlcnNpb24NCj4gDQo+IE9uIFR1ZSwgSnVuIDE1
LCAyMDIxIGF0IDA1OjQ1OjA5UE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gDQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvcHRwL3B0cF9jbG9jay5jIGIvZHJpdmVycy9wdHAvcHRwX2Nsb2Nr
LmMgaW5kZXgNCj4gPiBhNzgwNDM1MzMxYzguLjc4NDE0YjNlMTZkZCAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL3B0cC9wdHBfY2xvY2suYw0KPiA+ICsrKyBiL2RyaXZlcnMvcHRwL3B0cF9jbG9j
ay5jDQo+ID4gQEAgLTc2LDYgKzc2LDExIEBAIHN0YXRpYyBpbnQgcHRwX2Nsb2NrX3NldHRpbWUo
c3RydWN0IHBvc2l4X2Nsb2NrDQo+ID4gKnBjLCBjb25zdCBzdHJ1Y3QgdGltZXNwZWM2NCAqdHAg
IHsNCj4gPiAgCXN0cnVjdCBwdHBfY2xvY2sgKnB0cCA9IGNvbnRhaW5lcl9vZihwYywgc3RydWN0
IHB0cF9jbG9jaywgY2xvY2spOw0KPiA+DQo+ID4gKwlpZiAocHRwX2d1YXJhbnRlZWRfcGNsb2Nr
KHB0cCkpIHsNCj4gDQo+IENhbiB3ZSBwbGVhc2UgaW52ZW50IGEgbW9yZSBkZXNjcmlwdGl2ZSBu
YW1lIGZvciB0aGlzIG1ldGhvZD8NCj4gVGhlIHdvcmQgImd1YXJhbnRlZWQiIHN1Z2dlc3RzIG11
Y2ggbW9yZS4NCj4gDQo+ID4gKwkJcHJfZXJyKCJwdHA6IHZpcnR1YWwgY2xvY2sgaW4gdXNlLCBn
dWFyYW50ZWUgcGh5c2ljYWwgY2xvY2sgZnJlZQ0KPiA+ICtydW5uaW5nXG4iKTsNCj4gDQo+IFRo
aXMgaXMgZ29vZDogICAgICAgICAgIF5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl4NCj4gWW91IGNh
biBkcm9wIHRoaXMgcGFydDoNCj4gXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5e
Xg0KPiANCj4gU28sIHBsZWFzZSByZW5hbWUgcHRwX2d1YXJhbnRlZWRfcGNsb2NrKCkgdG8gcHRw
X3ZjbG9ja19pbl91c2UoKTsNCj4gDQoNClRoYW5rIHlvdS4gV2lsbCBjb252ZXJ0IHRvIHRoYXQu
DQoNCj4gPiArCQlyZXR1cm4gLUVCVVNZOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgCXJldHVybiAg
cHRwLT5pbmZvLT5zZXR0aW1lNjQocHRwLT5pbmZvLCB0cCk7ICB9DQo+IA0KPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9wdHAvcHRwX3ByaXZhdGUuaCBiL2RyaXZlcnMvcHRwL3B0cF9wcml2
YXRlLmgNCj4gPiBpbmRleCAzZjM4OGQ2MzkwNGMuLjY5NDlhZmM5ZDczMyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3B0cC9wdHBfcHJpdmF0ZS5oDQo+ID4gKysrIGIvZHJpdmVycy9wdHAvcHRw
X3ByaXZhdGUuaA0KPiA+IEBAIC00Niw2ICs0Niw5IEBAIHN0cnVjdCBwdHBfY2xvY2sgew0KPiA+
ICAJY29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqcGluX2F0dHJfZ3JvdXBzWzJdOw0KPiA+
ICAJc3RydWN0IGt0aHJlYWRfd29ya2VyICprd29ya2VyOw0KPiA+ICAJc3RydWN0IGt0aHJlYWRf
ZGVsYXllZF93b3JrIGF1eF93b3JrOw0KPiA+ICsJdTggbl92Y2xvY2tzOw0KPiANCj4gV2h5IG5v
dCB1c2UgInVuc2lnbmVkIGludCIgdHlwZT8gIEkgZG9uJ3Qgc2VlIGEgbmVlZCB0byBzZXQgYW4g
YXJ0aWZpY2lhbCBsaW1pdC4NCg0KUGxlYXNlIHNlZSBteSBleHBsYWluIGluIGFub3RoZXIgZW1h
aWwgdGhyZWFkLiBUaGFua3MuDQoNCj4gDQo+ID4gKwlzdHJ1Y3QgbXV0ZXggbl92Y2xvY2tzX211
eDsgLyogcHJvdGVjdCBjb25jdXJyZW50IG5fdmNsb2NrcyBhY2Nlc3MgKi8NCj4gPiArCWJvb2wg
dmNsb2NrX2ZsYWc7DQo+IA0KPiAiZmxhZyIgaXMgdmFndWUuICBIb3cgYWJvdXQgImlzX3ZpcnR1
YWxfY2xvY2siIGluc3RlYWQ/DQoNClRoYXQncyBiZXR0ZXIuIFdpbGwgdXNlIGl0LiBUaGFuayB5
b3UuDQoNCj4gDQo+ID4gIH07DQo+ID4NCj4gPiAgI2RlZmluZSBpbmZvX3RvX3ZjbG9jayhkKSBj
b250YWluZXJfb2YoKGQpLCBzdHJ1Y3QgcHRwX3ZjbG9jaywgaW5mbykNCj4gPiBAQCAtNzUsNiAr
NzgsMTggQEAgc3RhdGljIGlubGluZSBpbnQgcXVldWVfY250KHN0cnVjdA0KPiB0aW1lc3RhbXBf
ZXZlbnRfcXVldWUgKnEpDQo+ID4gIAlyZXR1cm4gY250IDwgMCA/IFBUUF9NQVhfVElNRVNUQU1Q
UyArIGNudCA6IGNudDsgIH0NCj4gPg0KPiA+ICsvKg0KPiA+ICsgKiBHdWFyYW50ZWUgcGh5c2lj
YWwgY2xvY2sgdG8gc3RheSBmcmVlIHJ1bm5pbmcsIGlmIHB0cCB2aXJ0dWFsDQo+ID4gK2Nsb2Nr
cw0KPiA+ICsgKiBvbiBpdCBhcmUgaW4gdXNlLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGlubGlu
ZSBib29sIHB0cF9ndWFyYW50ZWVkX3BjbG9jayhzdHJ1Y3QgcHRwX2Nsb2NrICpwdHApIHsNCj4g
PiArCWlmICghcHRwLT52Y2xvY2tfZmxhZyAmJiBwdHAtPm5fdmNsb2NrcykNCj4gDQo+IE5lZWQg
dG8gdGFrZSBtdXRleCBmb3Igbl92Y2xvY2tzIHRvIHByZXZlbnQgbG9hZCB0ZWFyaW5nLg0KPiAN
Cj4gPiArCQlyZXR1cm4gdHJ1ZTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gZmFsc2U7DQo+ID4gK30N
Cj4gPiArDQo+ID4gIC8qDQo+ID4gICAqIHNlZSBwdHBfY2hhcmRldi5jDQo+ID4gICAqLw0KPiAN
Cj4gPiBAQCAtMTQ4LDYgKzE0OSw5MCBAQCBzdGF0aWMgc3NpemVfdCBwcHNfZW5hYmxlX3N0b3Jl
KHN0cnVjdCBkZXZpY2UNCj4gPiAqZGV2LCAgfSAgc3RhdGljIERFVklDRV9BVFRSKHBwc19lbmFi
bGUsIDAyMjAsIE5VTEwsDQo+ID4gcHBzX2VuYWJsZV9zdG9yZSk7DQo+ID4NCj4gPiArc3RhdGlj
IGludCB1bnJlZ2lzdGVyX3ZjbG9jayhzdHJ1Y3QgZGV2aWNlICpkZXYsIHZvaWQgKmRhdGEpIHsN
Cj4gPiArCXN0cnVjdCBwdHBfY2xvY2sgKnB0cCA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KPiA+
ICsJc3RydWN0IHB0cF9jbG9ja19pbmZvICppbmZvID0gcHRwLT5pbmZvOw0KPiA+ICsJc3RydWN0
IHB0cF92Y2xvY2sgKnZjbG9jazsNCj4gPiArCXU4ICpudW0gPSBkYXRhOw0KPiA+ICsNCj4gPiAr
CXZjbG9jayA9IGluZm9fdG9fdmNsb2NrKGluZm8pOw0KPiA+ICsJZGV2X2luZm8oZGV2LT5wYXJl
bnQsICJkZWxldGUgdmlydHVhbCBjbG9jayBwdHAlZFxuIiwNCj4gPiArCQkgdmNsb2NrLT5jbG9j
ay0+aW5kZXgpOw0KPiA+ICsNCj4gPiArCXB0cF92Y2xvY2tfdW5yZWdpc3Rlcih2Y2xvY2spOw0K
PiA+ICsJKCpudW0pLS07DQo+ID4gKw0KPiA+ICsJLyogRm9yIGJyZWFrLiBOb3QgZXJyb3IuICov
DQo+ID4gKwlpZiAoKm51bSA9PSAwKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4g
PiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgc3NpemVfdCBuX3ZjbG9j
a3Nfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gKwkJCSAgICAgIHN0cnVjdCBkZXZpY2Vf
YXR0cmlidXRlICphdHRyLCBjaGFyICpwYWdlKSB7DQo+ID4gKwlzdHJ1Y3QgcHRwX2Nsb2NrICpw
dHAgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gc25wcmludGYo
cGFnZSwgUEFHRV9TSVpFLTEsICIlZFxuIiwgcHRwLT5uX3ZjbG9ja3MpOw0KPiANCj4gVGFrZSBt
dXRleC4NCg0KV2lsbCB0YWtlIG11dGV4IGV2ZXJ5d2hlcmUgdG8gYWNjZXNzIGl0Lg0KDQo+IA0K
PiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgc3NpemVfdCBuX3ZjbG9ja3Nfc3RvcmUoc3RydWN0
IGRldmljZSAqZGV2LA0KPiA+ICsJCQkgICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0
dHIsDQo+ID4gKwkJCSAgICAgICBjb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkgew0KPiA+
ICsJc3RydWN0IHB0cF9jbG9jayAqcHRwID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ID4gKwlz
dHJ1Y3QgcHRwX3ZjbG9jayAqdmNsb2NrOw0KPiA+ICsJaW50IGVyciA9IC1FSU5WQUw7DQo+ID4g
Kwl1OCBudW0sIGk7DQo+ID4gKw0KPiA+ICsJaWYgKGtzdHJ0b3U4KGJ1ZiwgMCwgJm51bSkpDQo+
ID4gKwkJZ290byBvdXQ7DQo+ID4gKw0KPiA+ICsJaWYgKG51bSA+IFBUUF9NQVhfVkNMT0NLUykg
ew0KPiA+ICsJCWRldl9lcnIoZGV2LCAibWF4IHZhbHVlIGlzICVkXG4iLCBQVFBfTUFYX1ZDTE9D
S1MpOw0KPiA+ICsJCWdvdG8gb3V0Ow0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWlmIChtdXRleF9s
b2NrX2ludGVycnVwdGlibGUoJnB0cC0+bl92Y2xvY2tzX211eCkpDQo+ID4gKwkJcmV0dXJuIC1F
UkVTVEFSVFNZUzsNCj4gPiArDQo+ID4gKwkvKiBOZWVkIHRvIGNyZWF0ZSBtb3JlIHZjbG9ja3Mg
Ki8NCj4gPiArCWlmIChudW0gPiBwdHAtPm5fdmNsb2Nrcykgew0KPiA+ICsJCWZvciAoaSA9IDA7
IGkgPCBudW0gLSBwdHAtPm5fdmNsb2NrczsgaSsrKSB7DQo+ID4gKwkJCXZjbG9jayA9IHB0cF92
Y2xvY2tfcmVnaXN0ZXIocHRwKTsNCj4gPiArCQkJaWYgKCF2Y2xvY2spIHsNCj4gPiArCQkJCW11
dGV4X3VubG9jaygmcHRwLT5uX3ZjbG9ja3NfbXV4KTsNCj4gPiArCQkJCWdvdG8gb3V0Ow0KPiA+
ICsJCQl9DQo+ID4gKw0KPiA+ICsJCQlkZXZfaW5mbyhkZXYsICJuZXcgdmlydHVhbCBjbG9jayBw
dHAlZFxuIiwNCj4gPiArCQkJCSB2Y2xvY2stPmNsb2NrLT5pbmRleCk7DQo+ID4gKwkJfQ0KPiA+
ICsJfQ0KPiA+ICsNCj4gPiArCS8qIE5lZWQgdG8gZGVsZXRlIHZjbG9ja3MgKi8NCj4gPiArCWlm
IChudW0gPCBwdHAtPm5fdmNsb2Nrcykgew0KPiA+ICsJCWkgPSBwdHAtPm5fdmNsb2NrcyAtIG51
bTsNCj4gPiArCQlkZXZpY2VfZm9yX2VhY2hfY2hpbGRfcmV2ZXJzZShkZXYsICZpLA0KPiA+ICsJ
CQkJCSAgICAgIHVucmVnaXN0ZXJfdmNsb2NrKTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlpZiAo
bnVtID09IDApDQo+ID4gKwkJZGV2X2luZm8oZGV2LCAib25seSBwaHlzaWNhbCBjbG9jayBpbiB1
c2Ugbm93XG4iKTsNCj4gPiArCWVsc2UNCj4gPiArCQlkZXZfaW5mbyhkZXYsICJndWFyYW50ZWUg
cGh5c2ljYWwgY2xvY2sgZnJlZSBydW5uaW5nXG4iKTsNCj4gPiArDQo+ID4gKwlwdHAtPm5fdmNs
b2NrcyA9IG51bTsNCj4gPiArCW11dGV4X3VubG9jaygmcHRwLT5uX3ZjbG9ja3NfbXV4KTsNCj4g
PiArDQo+ID4gKwlyZXR1cm4gY291bnQ7DQo+ID4gK291dDoNCj4gPiArCXJldHVybiBlcnI7DQo+
ID4gK30NCj4gPiArc3RhdGljIERFVklDRV9BVFRSX1JXKG5fdmNsb2Nrcyk7DQo+ID4gKw0KPiA+
ICBzdGF0aWMgc3RydWN0IGF0dHJpYnV0ZSAqcHRwX2F0dHJzW10gPSB7DQo+ID4gIAkmZGV2X2F0
dHJfY2xvY2tfbmFtZS5hdHRyLA0KPiA+DQo+IA0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L3B0cF9jbG9jay5oDQo+ID4gYi9pbmNsdWRlL3VhcGkvbGludXgvcHRwX2Ns
b2NrLmggaW5kZXggMWQxMDhkNTk3ZjY2Li40YjkzM2RjMWI4MWINCj4gPiAxMDA2NDQNCj4gPiAt
LS0gYS9pbmNsdWRlL3VhcGkvbGludXgvcHRwX2Nsb2NrLmgNCj4gPiArKysgYi9pbmNsdWRlL3Vh
cGkvbGludXgvcHRwX2Nsb2NrLmgNCj4gPiBAQCAtNjksNiArNjksMTEgQEANCj4gPiAgICovDQo+
ID4gICNkZWZpbmUgUFRQX1BFUk9VVF9WMV9WQUxJRF9GTEFHUwkoMCkNCj4gPg0KPiA+ICsvKg0K
PiA+ICsgKiBNYXggbnVtYmVyIG9mIFBUUCB2aXJ0dWFsIGNsb2NrcyBwZXIgUFRQIHBoeXNpY2Fs
IGNsb2NrICAqLw0KPiA+ICsjZGVmaW5lIFBUUF9NQVhfVkNMT0NLUwkJCTIwDQo+IA0KPiBXaHkg
bGltaXQgdGhpcyB0byB0d2VudHkgY2xvY2tzPw0KDQpQbGVhc2Ugc2VlIG15IGV4cGxhaW4gaW4g
YW5vdGhlciBlbWFpbCB0aHJlYWQuIFRoYW5rcy4NCg0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJk
DQo=
