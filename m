Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8344D270AE3
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 07:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgISFgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 01:36:04 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:14065 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISFgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 01:36:04 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6598c00000>; Sat, 19 Sep 2020 13:36:00 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 19 Sep
 2020 05:36:00 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 19 Sep 2020 05:36:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXdXqi3TSWzVaS9bK8d/CcN3FL/yIXgoo3ZbntxRFlzGK0wiwP0NwL/KxQexz6uU1mfLpiIPfrpDVhCk5JyQCWG4ebC3iyGiG4zf3ym9ybW8TyetdsdJp59YuDtYYfl5UrXT7qOXSWcVJguypOi4+h1nxEM0fXNKjwa3FI4OS97+45gAfk1x7WwP/6x08dZuBi8F2bVMMX4KeDb4W2yKSvGi3X/qrrduupHPHjpPYPsWUtAo4uMuw2NJw39XUxKKppBCNCn6diaeDxWv+3Xw29XMLAaVDFLqNx7WI0TxaUC2pQNER/7R6VCqyH3s9xH+rupms/T8GnpemD7qGMRSJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Htk9Nq3Sq2d1Z2+xy6W0JeXqzB0e56hhLVpb13e1eLg=;
 b=l/UertNHviciBONCSkfYP5tx3lMncCud7jZDyIs1k2K03WOq7qr+uMpn0tWLhbVBOPEsGVoiFO04ln6hUeiJKM+/0EzidBTSNhm8q4+uJbij5VcDnEv/rabXbfIPiJ8WNHbQgVcycTrr5a3Am8haRCRJDu1jBEIUmZzXMOPKEIvPCefOWOCy7HdFjc2RYqB5Pjk+UZpuGfLhsmCSrA35auREY4b7+IiljEka3b4slhQY6IuZKn14smTldWLVhZsFPURjFdg7wJx+8ZQ0BHZ1j5LG+SnIghhcucsihIR8L+pcKTGy2DqtibcV+Qs27KhFSbCfcP5t6JiVN+YkkCpelQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3431.namprd12.prod.outlook.com (2603:10b6:a03:da::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sat, 19 Sep
 2020 05:35:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3391.017; Sat, 19 Sep 2020
 05:35:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Topic: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
Thread-Index: AQHWjRbfsBFsIsWtkkyNl1+R6ZtbG6ltQJQAgACEJpCAAL4hAIAACqxQgADYvwCAAAtwkA==
Date:   Sat, 19 Sep 2020 05:35:57 +0000
Message-ID: <BY5PR12MB4322220530B9A8FDB2B6554FDC3C0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <7b4627d3-2a69-5700-e985-2fe5c56f03cb@gmail.com>
 <BY5PR12MB43220E910463577F0D792965DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <f89dca1d-4517-bf4a-b3f0-4c3a076dd2ab@gmail.com>
 <BY5PR12MB432298572152955D2ACAA2A3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <4a55536d-3b79-c009-98e9-95f76c9aa88c@gmail.com>
In-Reply-To: <4a55536d-3b79-c009-98e9-95f76c9aa88c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4306ce0-0b22-49f8-f1fc-08d85c5de2c3
x-ms-traffictypediagnostic: BYAPR12MB3431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB34318C4FCCA2235BD0EE9FB2DC3C0@BYAPR12MB3431.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LToMRsdQakMH7rJ/AqB9zF+SNAHet/PusKB6d2arRmsKle38wYZ+breeT0ocklNDgntBTp7yD5n8YB1nGhp06WDZyJW3bqmsQcwVVV4rv7Q/idB0kJlXDIYWQkK6jJhqS/OeT/kElxkTjc38e9NQq9zGrgaa0pH2Kyf/N/aTGsFWzvjy8XhUYdP77kjvc7Z54odktY9cmVXZWEfKDmEG8AA1nLn2Xgd8uAtQVkZK7+7NXFWq5ASeHhLb2KKTkJSfmYAuM+QAzkUB3igy2+f+gTvNYckD9V6btGaDXpf3Hohd10qrXe1eb+TLqeq4SBodTw8czuknRpLPwogDRD1Frw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(8676002)(52536014)(186003)(110136005)(26005)(55236004)(53546011)(2906002)(478600001)(8936002)(316002)(86362001)(6506007)(4326008)(55016002)(64756008)(9686003)(71200400001)(66556008)(66476007)(5660300002)(66446008)(83380400001)(76116006)(66946007)(107886003)(7696005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2Ha+5T050tmlRwZVaKTfKGiHkWbrS8wcjX8nxuzCdKQt6qviLSDaPyu/8ORrGqwn5/EOuOIC5RpC02VBdlzQrJ/C/DaVXlnK4u9+PnuYHSJSxHZ+QJm1XKnh8UALS9/df/+npPNwv1v+6FL0Zb+mqwdRRZszNUeqGMVw0TudK9P0aUYYJsp6m2xRNiCfjsq8y/8Nh6iYqSh7J7Meik6nWXWxPXHQ42kiQoLL4QE3DDRHAUb460fnYn3tPwnu/J40WbNJIk4GBl4NyrrtOTjo3JTY2UlMRyIuLYjnhdaTfBAae8HfMbVr5RwMAltohQibS4YCZ06ah40NboNwOmPt4G2nSP9zXA9echtvWA3d49jZ0BuHxkPPyGBBvP8+kBWHm1wYPZfN+U1gnzwhUozITWAwxHRxXtdpm7/fnyfSJ5SdkEvNoL4HmNlhx4tRrlgIJmGJrrS/DcHXqLRWBj/1En42xECBrvva7F3yrMA35rpuQpC5i0O+Dh2WT7LYdlMTouF6ZV7Brc2KFiAq2I2fM/DOhX3SniAoW/6ciRL80a0fTyAT0lH3IWYoFIwf0a85KUBjpwKdLj2fPK0UJgzyS3tgXcHij6/4onEVDnW+IeVprXOup30PrclFU30/Z2t5Y+5+VYQlGwrRN7ONW0jaSQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4306ce0-0b22-49f8-f1fc-08d85c5de2c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 05:35:57.8066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +HJNTP6sWhxvruDozoP85jPh8tZQ8olPanpScXMtCJyNcTmn0ubyRmV5mUz0Hr1yivVbtFI6XnF3uT+AEpKUeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3431
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600493760; bh=Htk9Nq3Sq2d1Z2+xy6W0JeXqzB0e56hhLVpb13e1eLg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=oKyRPnsKCOiqF5QTvTFuQcZlhwg8S+FJQtoR/SQrizmi2BVyl/xstAI43KXBmb9Ow
         O8IMmOToNs4o3JZnZrOITiu4G7JxQRrpkjitajQCjnO8JOHPFHYBtxRxAtXdl0/CSv
         HQ8j/ARXQEptSIf6pm44yczQ5Q8G3iwWf7tP44KPiFCwYp+dAZ3w2cDLBcPFvlYTVB
         jE6zix4jSnTaNGUyLfJ+QuEwKTggVtmiExgHJYmp38l5OH06dNwzJEpyf17s88eI1Z
         Wz1LwyyshHvmCbdZyJk0lZL7lS8Yen2S+zJf35YBrVVW0kK6GuKNSLAcRVtP4CnIQM
         Fwnhh0j44RyvQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgU2VwdGVtYmVyIDE5LCAyMDIwIDEwOjE5IEFNDQo+IA0KPiBPbiA5LzE4LzIwIDEwOjEz
IEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+IFlvdSBrZWVwIGFkZGluZyBwYXRjaGVzIHRo
YXQgZXh0ZW5kIHRoZSB0ZW1wbGF0ZSBiYXNlZCBuYW1lcy4gVGhvc2UNCj4gPj4gYXJlIGdvaW5n
IHRvIGNhdXNlIG9kZCBFSU5WQUwgZmFpbHVyZXMgKHRoZSBhYnNvbHV0ZSB3b3JzdCBraW5kIG9m
DQo+ID4+IGNvbmZpZ3VyYXRpb24NCj4gPj4gZmFpbHVyZSkgd2l0aCBubyB3YXkgZm9yIGEgdXNl
ciB0byB1bmRlcnN0YW5kIHdoeSB0aGUgY29tbWFuZCBpcw0KPiA+PiBmYWlsaW5nLCBhbmQgeW91
IG5lZWQgdG8gaGFuZGxlIHRoYXQuIFJldHVybmluZyBhbiBleHRhY2sgbWVzc2FnZQ0KPiA+PiBi
YWNrIHRvIHRoZSB1c2VyIGlzIHByZWZlcnJlZC4NCj4gPiBTdXJlLCBtYWtlIHNlbnNlLg0KPiA+
IEkgd2lsbCBydW4gb25lIHNob3J0IHNlcmllcyBhZnRlciB0aGlzIG9uZSwgdG8gcmV0dXJuIGV4
dGFjayBpbiBiZWxvdyBjb2RlIGZsb3cNCj4gYW5kIG90aGVyIHdoZXJlIGV4dGFjayByZXR1cm4g
aXMgcG9zc2libGUuDQo+ID4gSW4gc3lzZnMgZmxvdyBpdCBpcyBpcnJlbGV2YW50IGFueXdheS4N
Cj4gDQo+IHllcywgc3lzZnMgaXMgYSBkaWZmZXJlbnQgcHJvYmxlbS4NCj4gDQo+ID4gcnRubF9n
ZXRsaW5rKCkNCj4gPiAgIHJ0bmxfcGh5c19wb3J0X25hbWVfZmlsbCgpDQo+ID4gICAgICBkZXZf
Z2V0X3BoeXNfcG9ydF9uYW1lKCkNCj4gPiAgICAgICAgbmRvX3BoeXNfcG9ydF9uYW1lKCkNCj4g
Pg0KPiA+IGlzIHRoYXQgb2s/DQo+IA0KPiBzdXJlLiBUaGUgb3ZlcmZsb3cgaXMgbm90IGdvaW5n
IHRvIGhhcHBlbiB0b2RheSB3aXRoIDEtMTAgU0ZzOyBidXQgeW91IGFyZQ0KPiBwdXNoaW5nIGV2
ZXIgY2xvc2UgdG8gdGhlIGxpbWl0IGhlbmNlIHRoZSBwdXNoLg0KPiANCk9rLiB5ZWFoLiBnb3Qg
aXQuDQo+IA0KPiA+IFRoaXMgc2VyaWVzIGlzIG5vdCByZWFsbHkgbWFraW5nIHBoeXNfcG9ydF9u
YW1lIGFueSB3b3JzZSBleGNlcHQgdGhhdCBzZm51bQ0KPiBmaWVsZCB3aWR0aCBpcyBiaXQgbGFy
Z2VyIHRoYW4gdmZudW0uDQo+ID4NCj4gPiBOb3cgY29taW5nIGJhY2sgdG8gcGh5c19wb3J0X25h
bWUgbm90IGZpdHRpbmcgaW4gMTUgY2hhcmFjdGVycyB3aGljaCBjYW4NCj4gdHJpZ2dlciAtRUlO
VkFMIGVycm9yIGlzIHZlcnkgc2xpbSBpbiBtb3N0IHNhbmUgY2FzZXMuDQo+ID4gTGV0J3MgdGFr
ZSBhbiBleGFtcGxlLg0KPiA+IEEgY29udHJvbGxlciBpbiB2YWxpZCByYW5nZSBvZiAwIHRvIDE2
LCBQRiBpbiByYW5nZSBvZiAwIHRvIDcsIFZGIGluDQo+ID4gcmFuZ2Ugb2YgMCB0byAyNTUsIFNG
IGluIHJhbmdlIG9mIDAgdG8gNjU1MzYsDQo+ID4NCj4gPiBXaWxsIGdlbmVyYXRlIFZGIHBoeXNf
cG9ydF9uYW1lPWMxNnBmN3ZmMjU1ICgxMSBjaGFycyArIDEgbnVsbCkgU0YNCj4gPiBwaHlzX3Bv
cnQgbmFtZSA9IGMxNnBmN3NmNjU1MzUgKDEzIGNoYXJzICsgMSBudWxsKSBTbyB5ZXMsIGV0aCBk
ZXYNCj4gPiBuYW1lIHdvbid0IGZpdCBpbiBidXQgcGh5c19wb3J0X25hbWUgZmFpbHVyZSBpcyBh
bG1vc3QgbmlsLg0KPiA+DQo+IA0KPiBZb3UgbG9zdCBtZSBvbiB0aGF0IGxhc3Qgc2VudGVuY2Uu
IFBlciB5b3VyIGV4YW1wbGUgZm9yIFNGLCBhZGRpbmcgJ2VuaScNCj4gb3IgJ2V0aCcgYXMgYSBw
cmVmaXggKHdoaWNoIHlvdSBjb21tb25seSB1c2UgaW4gZXhhbXBsZXMgYW5kIHdoaWNoIGFyZQ0K
PiBjb21tb24gcHJlZml4ZXMpIHRvIHRoYXQgbmFtZSBhbmQgeW91IG92ZXJmbG93IHRoZSBJRk5B
TUVTWiBsaW1pdC4NCj4NClJpZ2h0LiBHb3QgeW91Lg0KV2lsbCBydW4gc2hvcnQgc2VyaWVzIGZv
ciByZXR1cm5pbmcgZXh0YWNrLg0KIA0KPiANCj4gKHVuZGVyc3RhbmQgYWJvdXQgdGhlIHN5c3Rl
bWQgaW50ZWdyYXRpb24gYW5kIGFwcHJlY2lhdGUgdGhlIGZvcndhcmQgdGhpbmtpbmcNCj4gYWJv
dXQgdGhhdCkuDQpUaGFuayB5b3UgRGF2aWQuDQo=
