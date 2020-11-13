Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733AE2B1CE1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 15:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKMOBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 09:01:46 -0500
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:4285
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgKMOBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 09:01:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hu5DQSjgYg6prfzHH1B87o0A8Z5h3DHzLEb7YXBGZ1eIdZGwmXzddvujwKToEbC1t9NgFzZi3QpnL7h/2/UsyTBsyv9foMbjVJoXLTRfgS+scl3XvMfmTXr9KkqcQVQfp+9IEOqfjajWWgr9ZJ23FRbGvWWQuPJWjCxMarnRAORF78MSR9HqPPXsOytxARYs4KIGxeNPFlYIptc7YLmUR8uvbaWKaQoa5qmseykhd/CyPaa2ZHuRZ2u27IhpJVzQi9dqb5vrWNoF9l7w20nE+02zhORtGc0eg378eidJamNnkoSUpPmcJsUXDYCJasA8eQl8jvh8MgV1ACr4koY8bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iP0YbfkJX57bCUFhWZgdaf4pM1DjB/4B4veTL3viHEU=;
 b=boRkjZ0OB+oKxUjbLKuDhIe2tsYLsn8fy7jSgztt98DU1ydT4pJfTozcZcUuDCOCrJ0Pk9gWcAqYnxJ+8S6G+9tLxLquGQrRDP5kiYGS4ROOZLiDCDoi3+WJb7pkmyfn+Be4vM5NUEVrGWrjV2GH0Ahpx7j+Pb72LFgWbKIssMwzGrnug4pw0We8pdfzMKi30EJ98KlfBiD3FQe75QnCgTVHuMsR+5I52JKCbcIC9fCuJZV/+8wPanykJGRH466h1YfrUufbnJZIPkZ+7lNVo05AnyZovn4CdEWC1m8hOM4V4hSZvulzK/fiRfBs+sLmXe9E2P8Z6b8Twt661V083w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iP0YbfkJX57bCUFhWZgdaf4pM1DjB/4B4veTL3viHEU=;
 b=pKU/a9jgHjFk8Uc1PCte0286ha1gfsETgDIGLdglC7wE2wWIBO7hz+hS+ie+RHi++97kjUtk30sWG0jMVrCC3i8sxJCn673LZg6TwZftHmmkCpTF9xmdYcGIm9ZJfPlIHB8y2/Fxk8VtXN72kEGAAbcveUtUdeyPCX0WF29enRU=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6877.eurprd04.prod.outlook.com (2603:10a6:803:131::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 14:01:40 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 14:01:40 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 4/7] dpaa_eth: add XDP_TX support
Thread-Topic: [PATCH net-next 4/7] dpaa_eth: add XDP_TX support
Thread-Index: AQHWuR8bopLxWXOj00WHSrHrw14xZ6nE+jOAgAEXUOA=
Date:   Fri, 13 Nov 2020 14:01:40 +0000
Message-ID: <VI1PR04MB58071624FE6EE90B3C20EFB0F2E60@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605181416.git.camelia.groza@nxp.com>
         <ba14ff6342f74c6cdc086d31c2ca77248f371003.1605181416.git.camelia.groza@nxp.com>
 <2380dc4cfc21ab598623a20c2569c8bf6444c12d.camel@kernel.org>
In-Reply-To: <2380dc4cfc21ab598623a20c2569c8bf6444c12d.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8565bac8-784a-4b2f-cba0-08d887dca4f3
x-ms-traffictypediagnostic: VI1PR04MB6877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB687797E975034F0FB5050151F2E60@VI1PR04MB6877.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qrbs/lEANEiFZtHtpueY691TKTbJsHGkgNkuQafQ0zgqXZtNGZS/wiMShVVoI7qoqWTglrNpp9XipeCT3zndHxsIVdOZJKmr1n3rxMSBFJcDBsOG6JdwzNyvZ50cQArt9V1TdXyA8uDzP7lbwGNxkqHuyVpSQVqLbF2i9tDLWNrsKFlAXM3bUakB4hWR/CaE7Lb6nYeQlRdcziaJujhbWcNuJamuYrUTjZ7Ss8Txvdsjvb/dp4qdVRUfeHvvfpvBMOZXlJOe9m0bYz6c7KdLOWW4C32/qOHFFj2BTIDfgJq3SERV5YPmV4hiITdckSm+ikeOsf5EVWiuhhN+H8RqsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(8676002)(83380400001)(8936002)(52536014)(478600001)(66556008)(71200400001)(66946007)(64756008)(66476007)(76116006)(66446008)(2906002)(55016002)(5660300002)(54906003)(110136005)(26005)(4326008)(9686003)(186003)(33656002)(86362001)(7696005)(6506007)(53546011)(4001150100001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: U6tVlfBQtLcaqHtmkUS7G3oCj6iElLr6iHPA6mPCCpXZhrCPV/3qAoPFlNeq9TPNfjEb2k4/5VI6p4hbwkOszoZolX7udan+y7b46PadF9gIFgIstPmBMGz6ay+74LeOY0og4ydYrOmn7sGUWZPNiCZKmqkh9VYygtcs/YXZjElqQiMbJj5ULD6cACMy0EplGFvbS3RHyxU70loFHrDT+WFQ+wjTpPp6+oWvUu1u5or+Fh8PPOjWefGw0rInqD8eGiOi+UcqLlQok52Ywe1INedCYTn4a94RQsNsbD4PdB0S/a+IjSlC/NUbUa/KNbghgIX7rvb+zHhmy6teWIiI1tQdi7aDNRVyAd8ZZgdE6FEY6pk4kNgsxA+Ciqz/y9e0QXROV3R8remHI5i0pt7VPVRU2cO5AG43SSZFHfjMXVZI2y4wcXpUU17p9+k6nj0L1qaPTnV+XYrtMrcFAMWlYv1CEe8z/zJn3bbWe8/C69zbKmefI65Lz62ijmKb3Hydy/x6Dew3XVNo7SpqXScNE6RpcYxHR3vYqtW2Ki8ihY94fCvKrEXSA1BtHs1xlhqmCWWu0K96drPklblctihMhYSJDBubbfazKmu1904c+lSXAaRtgpYSo5pzNh2shyOJXv73qwAXbtDEwP4JPchRJgFlswgFDvz7oisdes8WCM1GMSq2epWZ70NQvx9qJWmpXN8n9j4whW9ty8NK4IqH+T7Q0T1KIcB9xSGuHFYqkQir2RbDihPr3KjSz5ka5/I5g+c/man0JnGGKWubgoB5Ug1n+9+qNZT+7sMXoLQELsh8VBH+CNFufqZP0vSRbPb2uBdrxX5tGyIUWPY9e21x91aKm9B3twRNWK7l0AsDy2KEU0POID9fVZSt66rX0b1aelgrCoonlLfo/jmlpbXtKg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8565bac8-784a-4b2f-cba0-08d887dca4f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 14:01:40.1441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MnsAgRwO33fsNB7ELF4qMx2XbQZ4s78Pg+PDe5XqNRz8cWLS/uDA9C42KNUIJBL15fdQMUozpgjjqp00MU1R3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6877
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDEyLCAyMDIwIDIyOjU2
DQo+IFRvOiBDYW1lbGlhIEFsZXhhbmRyYSBHcm96YSA8Y2FtZWxpYS5ncm96YUBueHAuY29tPjsg
a3ViYUBrZXJuZWwub3JnOw0KPiBicm91ZXJAcmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dA0KPiBDYzogTWFkYWxpbiBCdWN1ciAoT1NTKSA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT47
IElvYW5hIENpb3JuZWkNCj4gPGlvYW5hLmNpb3JuZWlAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCA0LzddIGRwYWFfZXRoOiBh
ZGQgWERQX1RYIHN1cHBvcnQNCj4gDQo+IE9uIFRodSwgMjAyMC0xMS0xMiBhdCAyMDoxMCArMDIw
MCwgQ2FtZWxpYSBHcm96YSB3cm90ZToNCj4gPiBVc2UgYW4geGRwX2ZyYW1lIHN0cnVjdHVyZSBm
b3IgbWFuYWdpbmcgdGhlIGZyYW1lLiBTdG9yZSBhDQo+ID4gYmFja3BvaW50ZXIgdG8NCj4gPiB0
aGUgc3RydWN0dXJlIGF0IHRoZSBzdGFydCBvZiB0aGUgYnVmZmVyIGJlZm9yZSBlbnF1ZXVlaW5n
LiBVc2UgdGhlDQo+ID4gWERQDQo+ID4gQVBJIGZvciBmcmVlaW5nIHRoZSBidWZmZXIgd2hlbiBp
dCByZXR1cm5zIHRvIHRoZSBkcml2ZXIgb24gdGhlIFRYDQo+ID4gY29uZmlybWF0aW9uIHBhdGgu
DQo+ID4NCj4gPiBUaGlzIGFwcHJvYWNoIHdpbGwgYmUgcmV1c2VkIGZvciBYRFAgUkVESVJFQ1Qu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDYW1lbGlhIEdyb3phIDxjYW1lbGlhLmdyb3phQG54
cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFh
L2RwYWFfZXRoLmMgfCAxMjkNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKystDQo+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmggfCAgIDIgKw0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDEyNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2Rw
YWFfZXRoLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFf
ZXRoLmMNCj4gPiBpbmRleCBiOWIwZGIyLi4zNDNkNjkzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+ID4gQEAgLTExMzAs
NiArMTEzMCwyNCBAQCBzdGF0aWMgaW50IGRwYWFfZnFfaW5pdChzdHJ1Y3QgZHBhYV9mcQ0KPiA+
ICpkcGFhX2ZxLCBib29sIHRkX2VuYWJsZSkNCj4gPg0KPiA+ICAJZHBhYV9mcS0+ZnFpZCA9IHFt
YW5fZnFfZnFpZChmcSk7DQo+ID4NCj4gPiArCWlmIChkcGFhX2ZxLT5mcV90eXBlID09IEZRX1RZ
UEVfUlhfREVGQVVMVCB8fA0KPiA+ICsJICAgIGRwYWFfZnEtPmZxX3R5cGUgPT0gRlFfVFlQRV9S
WF9QQ0QpIHsNCj4gPiArCQllcnIgPSB4ZHBfcnhxX2luZm9fcmVnKCZkcGFhX2ZxLT54ZHBfcnhx
LCBkcGFhX2ZxLQ0KPiA+ID5uZXRfZGV2LA0KPiA+ICsJCQkJICAgICAgIGRwYWFfZnEtPmZxaWQp
Ow0KPiA+ICsJCWlmIChlcnIpIHsNCj4gPiArCQkJZGV2X2VycihkZXYsICJ4ZHBfcnhxX2luZm9f
cmVnIGZhaWxlZFxuIik7DQo+ID4gKwkJCXJldHVybiBlcnI7DQo+ID4gKwkJfQ0KPiA+ICsNCj4g
PiArCQllcnIgPSB4ZHBfcnhxX2luZm9fcmVnX21lbV9tb2RlbCgmZHBhYV9mcS0+eGRwX3J4cSwN
Cj4gPiArCQkJCQkJIE1FTV9UWVBFX1BBR0VfT1JERVIwLA0KPiA+IE5VTEwpOw0KPiANCj4gd2h5
IG5vdCBNRU1fVFlQRV9QQUdFX1BPT0w/DQo+IA0KPiBASmVzcGVyIGhvdyBjYW4gd2UgZW5jb3Vy
YWdlIG5ldyBkcml2ZXJzIHRvIGltcGxlbWVudCBYRFANCj4gd2l0aCBNRU1fVFlQRV9QQUdFX1BP
T0wgPw0KPiANCg0KSSdtIG5vdCBjZXJ0YWluIHdlIGFyZSBjb21wYXRpYmxlIHdpdGggdGhlIHBh
Z2VfcG9vbCBtb2RlbCAob25lIGJ1ZmZlciBwb29sIGZvciBhbGwgUlggcXVldWVzLCBzZXBhcmF0
ZSBSeC9UeCBETUEgZGV2aWNlcykuIEkgcHJlZmVyIHRvIHNlcGFyYXRlIHRoZSBiYXNpYyBYRFAg
c3VwcG9ydCBmcm9tIGl0IGZvciBub3cuDQoNCg0K
