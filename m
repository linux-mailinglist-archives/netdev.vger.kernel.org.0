Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A5A2CDA62
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgLCPv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:51:58 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:37560
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbgLCPv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:51:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RF/jhvHwbjyfGXSOTt2H7Bb49EavsVjgcCWNF6YVlAslz08Vvyi3ebEG6H0PrbxubbS6MZMPrYTc84g4I6DsrB4sfAQ4FRG9RRSwPVElHKBAH7FCGWmJIxfYgIGUOA+uysxl68+AV5Rdm+3N58kvjNvPZc/VyZUzMyS2REz1JjTq21RyqHu2J3A6MfIwKysRAYY5x5Wj3NaTDD8C+vtlxdkWP5e/Zmb2gpCB84rqNx+qwoT+TdYHyc5ISqFc/ncVEcQqRMHHoS+bVhrWNZQvVDKG/cw/cnAbQ3cNq/S/XjQsISaLQtcL1IqFIUE4IjpHFKlyhl7K6PKASX1yTRsgUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kG/QwJ0aN1KI87GdPnB3epu2bq06U9EsT5pd1URhp0M=;
 b=j+PKG9ia2SB0mp18pp1lkiRJGLLZZOp3aNso91um+mkVp1nYBI9oCX/SL82HCEneHT8V0XJUwxwV8MLYQNxq8hCCMPlSwOpp21a6zEWsqDTeuysR1e9R7VgwjFwcRPujpjut8oTqfEVenlqtjVeF/0HC/zqv99rDH/HZ9BJu+Z7PdWU8036iw5d2/rcAqnhUbjwFdjW4pvK7FbFlnlGxIfmglVBuo9mRap/lsjh5GnTvJWYCPDX0dIaiQxNwmBIGzyt+UiZhWh8pAG8csOzgjdlcYNxbTE7pKNyhITMk/TzkJEX/kmmbvvpKUpPpA+qRcRqxWf5ORajeTlhw/7zmSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kG/QwJ0aN1KI87GdPnB3epu2bq06U9EsT5pd1URhp0M=;
 b=mWEsN2somPUzf6412mrf+XHJz7B/m+Ci6JAdyJFl0yY6B+Mx4sQ+xfjJFSK48BfLEWRbEIwrZM309IQr0OkkBgSO8U/VxKgr9SPWNqIL16XIwY8CWwGQbYsi0h8OaFGtE5KMaoVUmPcxnKA3oee9ucw+ytAlFVmndk/+zj7Bb4c=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR0402MB3335.eurprd04.prod.outlook.com (2603:10a6:209:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 15:51:05 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21%4]) with mapi id 15.20.3611.032; Thu, 3 Dec 2020
 15:51:05 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Anders Roxell <anders.roxell@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] dpaa_eth: fix build errorr in dpaa_fq_init
Thread-Topic: [PATCH] dpaa_eth: fix build errorr in dpaa_fq_init
Thread-Index: AQHWyYK3NnTScBlWBESHuOopY6/w/KnlhN+g
Date:   Thu, 3 Dec 2020 15:51:05 +0000
Message-ID: <AM6PR04MB3976D797CD59CB6A7994F7D6ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201203144343.790719-1-anders.roxell@linaro.org>
In-Reply-To: <20201203144343.790719-1-anders.roxell@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9286e8a6-b9df-4314-378b-08d897a33ea8
x-ms-traffictypediagnostic: AM6PR0402MB3335:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-microsoft-antispam-prvs: <AM6PR0402MB3335F905BF71B7936B7E7F77ADF20@AM6PR0402MB3335.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v3VMGIlQlXE/WYcG59nUBV6vjKnDRTW3vIVcAY1VF3TQRqy+61X2N9sfOtyMOMdl5Wq69/Hvd6MS9jH40soJr/JdsRix399BONaX/v+8Qez4eAtrb+aCUmFq+z8RXB0k8MvgPRZQXiMajRxhEUxpXhy07TxIg2AurQGu6P3nyNySxfZL3mnG//Xc/9xLHhmruv2wHUYGChIEHckwM29Hb54YmzGdTHSKxP2pJkvJoyX0yHSrwPZQ5E4qAOJjtjZsyUysarpFiwIDDCvw9nA/uIzrq0Drwx1addXVDasSKgUTPQXgAv/YefdERHvFyYjOeMQNiOfXvuZ/3fUt4IwPrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(54906003)(316002)(5660300002)(52536014)(86362001)(110136005)(6506007)(71200400001)(186003)(7416002)(7696005)(66446008)(53546011)(76116006)(64756008)(66556008)(4326008)(66476007)(66946007)(26005)(33656002)(9686003)(55016002)(8676002)(2906002)(8936002)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?akQwRkt3dlY4RVBwbTMwWkxFajFYTGhBUFNrZnJOMXljY1ZCYVVrT25VNUkz?=
 =?utf-8?B?MkRSVk11Y1htamlUVFdsNFBQbGh1YXJrZlczVm96RlNXQnFPMUV4YzFaMkRj?=
 =?utf-8?B?bTZLZXVyaVYyRVd5aXJFWmduQ2hmbUt1RlUvdXVDVE9yTWVWMTM3eEk5WjhF?=
 =?utf-8?B?VjJTeFNzUm9JNXZ0K2tuL0ZCaU1CbXRGRTQ5NmJqclk0UFZYaW00bTVJWHBh?=
 =?utf-8?B?RzE3dXpiYTV3dS9FL3JlNFFOTmc2dnV2aTl3em4xZFJySDR1S0p2d29YSldY?=
 =?utf-8?B?YnpjanE1WDBOYytNVkhWTEtJcURRTlBwUkZ3eFBqbVJQSzdSeVVid0ZBSlZr?=
 =?utf-8?B?V0JoR1JWZm5NenNocDl1NUxGdnd1a0lTVnBpY0ZTam9JWFprby9xN2RGN0Rt?=
 =?utf-8?B?Z3ZwREpoMWp4QkVBcGF6NEpzSklVNGlYWUNPeEZ4QXVySnNHdXduYzJpSlNU?=
 =?utf-8?B?Wjh3d01QSi9QUHQ5YW94UExmY3E4V1NDSUZpeHQ4VTRUV1d2MHZKWnpUNENw?=
 =?utf-8?B?NUdiLyt3VG95LzJMU3V2TTRlSmYvREtxM1Q2SitTenBYUFdLT00xUDhRMUNP?=
 =?utf-8?B?MW5lT1RSWEQ4VVBMRWJYcEhNRG9UQlBOUEFqU1R5a3BWTU1uaURrYkhrWUxa?=
 =?utf-8?B?ZnlQaldYUkI0SmdWNS9LQXBoWnVBQ0gyNW4yTUcySEsvTnZLTlk5ejVGSHJL?=
 =?utf-8?B?UGxUL3ZyZEt5M1B3R2FWSUhDMU9LTlMyZHQxdVNWQm9VMTB5OHRQczdYMTly?=
 =?utf-8?B?QWU2NzVTMVJIcktFMDc5TTROV0FNYXlpamI2ejNMNVgyMFhUSm1NREkrTzhX?=
 =?utf-8?B?Rkh3d3JkaHpXQ3VBRjBYeG5zVzRUQUQxN2RTalZKVkljaHVFT0ZPMWNlS1ln?=
 =?utf-8?B?T0J1K2tyZnJXMDFXSHdDM3RiWmplQUdsRzlHaElpaFNlOHFqYlUxRDFXRnJL?=
 =?utf-8?B?aGszWW9teDlCMFA0SEJiZU41ZW1DbXNDRUJOMWFJVVVvTFpFT0oycXpWRTRM?=
 =?utf-8?B?UFdZVFl3cW9GNDR0VFpZZGQ3UlFFbFFnUUk4Mm1OcGxqaEhnYVpMcjk0Ym4r?=
 =?utf-8?B?N3J0WFZkWWlVYTFuc21NS2dXclhWREowbHJvcEdSdkVpRW5YZmxOWTVVSXZS?=
 =?utf-8?B?NkxzK1VYQkpDTSsxVHRnWW8zRUcwdC9MY0YvWml3bjZhSjVkYzlhSENucnY5?=
 =?utf-8?B?UE5qaXFpWTQzZzMvWHZldHg5U0pPSDNUL0VqTWcxWjZOK2wrQk94NkJobE5B?=
 =?utf-8?B?Tk1jYkJvbkZqTS9SZ1VFWktTUW80Z2J5SGhRb0FqMG9jTFoySWVUcFBnT3Fj?=
 =?utf-8?Q?QUeatiiK958+w=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9286e8a6-b9df-4314-378b-08d897a33ea8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 15:51:05.8900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHiZA7p6UYzDZDRJjvcHvE6p2VstUxh3rqMTs5EzCDj7EUMSJCUMH6+ytxMvgDCtjAK/h1ZozxPRBdw0rT5deA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRlcnMgUm94ZWxsIDxhbmRl
cnMucm94ZWxsQGxpbmFyby5vcmc+DQo+IFNlbnQ6IDAzIERlY2VtYmVyIDIwMjAgMTY6NDQNCj4g
VG86IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7DQo+IGt1YmFAa2VybmVsLm9yZzsgYXN0QGtlcm5lbC5vcmc7IGRhbmllbEBpb2dlYXJi
b3gubmV0OyBoYXdrQGtlcm5lbC5vcmc7DQo+IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbQ0KPiBD
YzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsN
Cj4gYnBmQHZnZXIua2VybmVsLm9yZzsgQW5kZXJzIFJveGVsbCA8YW5kZXJzLnJveGVsbEBsaW5h
cm8ub3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0hdIGRwYWFfZXRoOiBmaXggYnVpbGQgZXJyb3JyIGlu
IGRwYWFfZnFfaW5pdA0KPiANCj4gV2hlbiBidWlsZGluZyBGU0xfRFBBQV9FVEggdGhlIGZvbGxv
d2luZyBidWlsZCBlcnJvciBzaG93cyB1cDoNCj4gDQo+IC90bXAvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYzogSW4gZnVuY3Rpb24NCj4g4oCYZHBhYV9mcV9p
bml04oCZOg0KPiAvdG1wL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFf
ZXRoLmM6MTEzNTo5OiBlcnJvcjogdG9vIGZldw0KPiBhcmd1bWVudHMgdG8gZnVuY3Rpb24g4oCY
eGRwX3J4cV9pbmZvX3JlZ+KAmQ0KPiAgMTEzNSB8ICAgZXJyID0geGRwX3J4cV9pbmZvX3JlZygm
ZHBhYV9mcS0+eGRwX3J4cSwgZHBhYV9mcS0+bmV0X2RldiwNCj4gICAgICAgfCAgICAgICAgIF5+
fn5+fn5+fn5+fn5+fn4NCj4gDQo+IENvbW1pdCBiMDJlNWEwZWJiMTcgKCJ4c2s6IFByb3BhZ2F0
ZSBuYXBpX2lkIHRvIFhEUCBzb2NrZXQgUnggcGF0aCIpDQo+IGFkZGVkIGFuIGV4dHJhIGFyZ3Vt
ZW50IHRvIGZ1bmN0aW9uIHhkcF9yeHFfaW5mb19yZWcgYW5kIGNvbW1pdA0KPiBkNTdlNTdkMGNk
MDQgKCJkcGFhX2V0aDogYWRkIFhEUF9UWCBzdXBwb3J0IikgZGlkbid0IGtub3cgYWJvdXQgdGhh
dA0KPiBleHRyYSBhcmd1bWVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFuZGVycyBSb3hlbGwg
PGFuZGVycy5yb3hlbGxAbGluYXJvLm9yZz4NCj4gLS0tDQo+IA0KPiBJIHRoaW5rIHRoaXMgaXNz
dWUgaXMgc2VlbiBzaW5jZSBib3RoIHBhdGNoZXMgd2VudCBpbiBhdCB0aGUgc2FtZSB0aW1lDQo+
IHRvIGJwZi1uZXh0IGFuZCBuZXQtbmV4dC4NCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9kcGFhL2RwYWFfZXRoLmMNCj4gaW5kZXggOTQ3YjNkMmY5YzdlLi42Y2M4
YzRlMDc4ZGUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9k
cGFhL2RwYWFfZXRoLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Rw
YWEvZHBhYV9ldGguYw0KPiBAQCAtMTEzMyw3ICsxMTMzLDcgQEAgc3RhdGljIGludCBkcGFhX2Zx
X2luaXQoc3RydWN0IGRwYWFfZnEgKmRwYWFfZnEsDQo+IGJvb2wgdGRfZW5hYmxlKQ0KPiAgCWlm
IChkcGFhX2ZxLT5mcV90eXBlID09IEZRX1RZUEVfUlhfREVGQVVMVCB8fA0KPiAgCSAgICBkcGFh
X2ZxLT5mcV90eXBlID09IEZRX1RZUEVfUlhfUENEKSB7DQo+ICAJCWVyciA9IHhkcF9yeHFfaW5m
b19yZWcoJmRwYWFfZnEtPnhkcF9yeHEsIGRwYWFfZnEtPm5ldF9kZXYsDQo+IC0JCQkJICAgICAg
IGRwYWFfZnEtPmZxaWQpOw0KPiArCQkJCSAgICAgICBkcGFhX2ZxLT5mcWlkLCAwKTsNCj4gIAkJ
aWYgKGVycikgew0KPiAgCQkJZGV2X2VycihkZXYsICJ4ZHBfcnhxX2luZm9fcmVnKCkgPSAlZFxu
IiwgZXJyKTsNCj4gIAkJCXJldHVybiBlcnI7DQo+IC0tDQo+IDIuMjkuMg0KDQpUaGUgWERQIHN1
cHBvcnQgZm9yIERQQUEgMSBhbmQgdGhlIG5hcGlfaWQgcHJvcGFnYXRpb24gd2VyZSBjb25jdXJy
ZW50bHkNCmFwcGxpZWQsIHRoYW5rcyBmb3IgYWRkcmVzc2luZyB0aGlzLg0KDQpNYWRhbGluDQo=
