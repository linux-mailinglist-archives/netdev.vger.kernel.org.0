Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508EC29D479
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgJ1VwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:52:18 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12025 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbgJ1VwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:52:16 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f99e7f90002>; Wed, 28 Oct 2020 14:51:53 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 21:52:11 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 28 Oct 2020 21:52:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7KGenI9ohn2UApCL+nIvd+opt9dUFgFW04bsUc78ao00leK0hhd7o0EIOtg0m/gLwsc5AGsSDjoYJObxViBivcHuosM636DtmtXWJRKY1JQPGnJHjm0yyDHjGA05CHPwhycl5e3NDKXQB1t99q58/ngTOIIWted1AxgH9AKcG3OJuiD1ymRHDqTXMKtmee8OmYPlNDSztxsejhcsn3giz9rsKOJfumWK+ZQFJTw1RlhgOQrelzAukDEFjQvcZSSyqLAIZi6z3w5chOi0O9TdHAzSLY4p2iKf1AJmIT/Z3jS82vzHTfXLiN754ICif+rsbl7BV1/r3WyHcTgwQVOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MzPcLrLSnLGHEzoeKiOINM5/Y1j364bOBbSSg/mnLs=;
 b=Cb6mYSeWcEbIQB6jpnVCqc0Pyt0JPPLWQIPHCokZkeuPrxXoqG4LrbAThxmRATuymbw5LbKqBy5e8IjC/QdZ0LJrNbL8Mql2MXrjICehErcQDLJOmRhOC9C3uhtgIXyWUoSAwOsz5DAVIQaF/FKw59uxc7wrLkvCop0Xsu/ngXqNbir3qv4jYymNW2M04jeGuU0xRP53JsOH08pTAJViY/471PCS3vWx3S1tOE7kGz+zMwUGSHrC1ZhnjNwY3Ar+vfVFpC27lVWsWRL9jCo6c+dphVDfs1Hi34mMVcJVDfGkUi20t14lkGrzexdvyLAfSWmadPOeABayFJBj9n5TzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Wed, 28 Oct
 2020 21:52:10 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::b885:8b56:a460:4624]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::b885:8b56:a460:4624%11]) with mapi id 15.20.3499.018; Wed, 28 Oct
 2020 21:52:10 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next] net: bridge: mcast: add support for raw L2
 multicast groups
Thread-Topic: [PATCH v3 net-next] net: bridge: mcast: add support for raw L2
 multicast groups
Thread-Index: AQHWrRjFNLSERS0w+0m5jXcm3pUTwKmtjvgA
Date:   Wed, 28 Oct 2020 21:52:09 +0000
Message-ID: <76449de5bd88a9c00b75821c570dabbebef7675b.camel@nvidia.com>
References: <20201028105412.371741-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201028105412.371741-1-vladimir.oltean@nxp.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98a29bce-9fb5-4373-20e8-08d87b8bb89c
x-ms-traffictypediagnostic: MWHPR12MB1853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR12MB1853B1BA2FBACD9A9C5B0001DF170@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oKFVHM25kGio/y5O9HiRRZgeQY/cdZsvsPOzlZNHw4j9hZ3TRe4KQkDcVRaqwAK0Su0wlZPbHqlnmtHzP6sVtoUaQRvz88tk5UWHeplo8biQZBystQK7bxH9avf3rsaFJqp5s8D/c1UL2Zcl/ulUrwQIk2ELsf7/AHw/IQhDZbS3iQDrdLfcriTtiloTCOxxhYwZRzjMNJTTfkSGcdHKrZfkYXD4AdpXTFB1Txdnja8uVE+IDk6/6fdvbyY1/tSM6W+OZS0VKRupDHWQQ9colT3BIKmtydJEf7aFa7sj30XBa9XbWpjXTvKc3fN5Mqz4n6XQ0B6w5as7gFnClZjiCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(2616005)(110136005)(91956017)(66946007)(83380400001)(86362001)(66446008)(36756003)(478600001)(66476007)(66556008)(316002)(64756008)(186003)(26005)(6512007)(4326008)(7416002)(6506007)(76116006)(6486002)(2906002)(4001150100001)(8676002)(54906003)(3450700001)(71200400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IlT/dYz+EfyB7HouutEtrtNEgLEnd8agzdaee6hAU26ACU6J6LR7GFaWTynnFAA4pIkSHB38FPrZjchAxi5yFUngGE25VFGd4TD6ZqGUfVXgCPWFuFi/6A0Zf/UbgpDhRIcbCh8mCTDS3/oH8nuZ5bgAK3/W6blH5ZXqi8quttJmeM60A1nqpAGDsVTvL9N2Mo3uKasjkD4y1oAKBXGeH/b292WpJNaBlXV3Z+Wko9qSwYvSC/4wS7t3bF3tBlVVrWPe5GW3EH4o6V3qyoSriCouPxTGEBNs01pjgfi2N/45suEFU8oCfPDWgOcILD2ddAR5uwLhQ4clH6cOeO4BxMNVQ+0upx8tyBm7vynefAQ2SvFSC+8N8KRT6V2FMHVBw+e7GzVue3DKgqia61Gn2i1C8mgoJBPaeJ482jS8u59GIkpxcSzBoI+aCkrrRAztP+ZSDkh+qBvvMT8RzyK80HEt8VAiNGrbvPgNKv44DSD1YdSCnttV3fY0d+UpT6m7PIeZrAtMAEH0FYz9dW2E3rB5/WUBZ9xWuW6qkGNnDTR+IaMhxjmRqocAlrOtRPRlRuFAYCaUeCSC+X5KQw54Aj2xLVxP0hdcAkwT7M14A/0/J+Jbk0Fm2faOf7z4MnAPNssXKyzeP8VyakUFhWojgA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <F21A8D6F1C375247928FA1EF6CAA60BF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a29bce-9fb5-4373-20e8-08d87b8bb89c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 21:52:09.9306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I4+SApA3MPc5x4UXtWR8X52N90Gx7T6QMUylCOA1/eKjU8GZQS7yUt+lEF/Jp8Zt3mFR0ttQTVg820cduQXPFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603921913; bh=6MzPcLrLSnLGHEzoeKiOINM5/Y1j364bOBbSSg/mnLs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=KSLEm4tvP01MGnHQ2af6QoNpVUt6KFClGUr6/YSRr9aAoLWThFzk98UI88iaZNOxq
         Rx+v6q/AMgKBma6lSAOJYlt9O6ilm/4Lf3QfDSLlGTEimE+TdzVH0DGcCXyb/BaWrC
         R5wCEtszNIZrv7xO/k4ZW/fe5AETHmMMikny5bAIB/dmKkD4RlTCKaTx1G3mRyxWLR
         NVXHwVwXfto/rrrOJ/SdOpmWJNqiR19uZFlHpWpMFrwl8rtlGuEnu+/QtFpkhv8XSB
         CTwYAIHJjFH6sDNYOFKQnH2hK8d53ucVYv8qEx2Vd+AerKGqTNdPCdSP32qMjbGhCM
         gCHtdbYfSJqoQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTEwLTI4IGF0IDEyOjU0ICswMjAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEZyb206IE5pa29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCj4gDQo+
IEV4dGVuZCB0aGUgYnJpZGdlIG11bHRpY2FzdCBjb250cm9sIGFuZCBkYXRhIHBhdGggdG8gY29u
ZmlndXJlIHJvdXRlcw0KPiBmb3IgTDIgKG5vbi1JUCkgbXVsdGljYXN0IGdyb3Vwcy4NCj4gDQo+
IFRoZSB1YXBpIHN0cnVjdCBicl9tZGJfZW50cnkgdW5pb24gdSBpcyBleHRlbmRlZCB3aXRoIGFu
b3RoZXIgdmFyaWFudCwNCj4gbWFjX2FkZHIsIHdoaWNoIGRvZXMgbm90IGNoYW5nZSB0aGUgc3Ry
dWN0dXJlIHNpemUsIGFuZCB3aGljaCBpcyB2YWxpZA0KPiB3aGVuIHRoZSBwcm90byBmaWVsZCBp
cyB6ZXJvLg0KPiANCj4gVG8gYmUgY29tcGF0aWJsZSB3aXRoIHRoZSBmb3J3YXJkaW5nIGNvZGUg
dGhhdCBpcyBhbHJlYWR5IGluIHBsYWNlLA0KPiB3aGljaCBhY3RzIGFzIGFuIElHTVAvTUxEIHNu
b29waW5nIGJyaWRnZSB3aXRoIHF1ZXJpZXIgY2FwYWJpbGl0aWVzLCB3ZQ0KPiBuZWVkIHRvIGRl
Y2xhcmUgdGhhdCBmb3IgTDIgTURCIGVudHJpZXMgKGZvciB3aGljaCB0aGVyZSBleGlzdHMgbm8g
c3VjaA0KPiB0aGluZyBhcyBJR01QL01MRCBzbm9vcGluZy9xdWVyeWluZyksIHRoYXQgdGhlcmUg
aXMgYWx3YXlzIGEgcXVlcmllci4NCj4gT3RoZXJ3aXNlLCB0aGVzZSBlbnRyaWVzIHdvdWxkIGJl
IGZsb29kZWQgdG8gYWxsIGJyaWRnZSBwb3J0cyBhbmQgbm90DQo+IGp1c3QgdG8gdGhvc2UgdGhh
dCBhcmUgbWVtYmVycyBvZiB0aGUgTDIgbXVsdGljYXN0IGdyb3VwLg0KPiANCj4gTmVlZGxlc3Mg
dG8gc2F5LCBvbmx5IHBlcm1hbmVudCBMMiBtdWx0aWNhc3QgZ3JvdXBzIGNhbiBiZSBpbnN0YWxs
ZWQgb24NCj4gYSBicmlkZ2UgcG9ydC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pa29sYXkgQWxl
a3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIg
T2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCj4gLS0tDQo+IENoYW5nZXMgaW4gdjM6
DQo+IC0gUmVtb3ZlZCBzb21lIG5vaXNlIGluIHRoZSBkaWZmLg0KPiANCj4gQ2hhbmdlcyBpbiB2
MjoNCj4gLSBSZW1vdmVkIHJlZHVuZGFudCBNREJfRkxBR1NfTDIgKHdlIGFyZSBzaW1wbHkgc2ln
bmFsbGluZyBhbiBMMiBlbnRyeQ0KPiAgIHRocm91Z2ggcHJvdG8gPT0gMCkNCj4gLSBNb3ZlZCBt
YWNfYWRkciBpbnNpZGUgdW5pb24gZHN0IG9mIHN0cnVjdCBicl9pcC4NCj4gLSBWYWxpZGF0aW9u
IHRoYXQgTDIgbXVsdGljYXN0IGFkZHJlc3MgaXMgaW5kZWVkIG11bHRpY2FzdA0KPiANCj4gIGlu
Y2x1ZGUvbGludXgvaWZfYnJpZGdlLmggICAgICB8ICAxICsNCj4gIGluY2x1ZGUvdWFwaS9saW51
eC9pZl9icmlkZ2UuaCB8ICAxICsNCj4gIG5ldC9icmlkZ2UvYnJfZGV2aWNlLmMgICAgICAgICB8
ICAyICstDQo+ICBuZXQvYnJpZGdlL2JyX2lucHV0LmMgICAgICAgICAgfCAgMiArLQ0KPiAgbmV0
L2JyaWRnZS9icl9tZGIuYyAgICAgICAgICAgIHwgMjQgKysrKysrKysrKysrKysrKysrKysrKy0t
DQo+ICBuZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jICAgICAgfCAgOSArKysrKysrLS0NCj4gIG5l
dC9icmlkZ2UvYnJfcHJpdmF0ZS5oICAgICAgICB8IDEwICsrKysrKysrLS0NCj4gIDcgZmlsZXMg
Y2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4NCltzbmlwXQ0KPiBA
QCAtODU3LDYgKzg3MiwxMSBAQCBzdGF0aWMgaW50IGJyX21kYl9hZGRfZ3JvdXAoc3RydWN0IG5l
dF9icmlkZ2UgKmJyLCBzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwb3J0LA0KPiAgCQkJcmV0dXJu
IGVycjsNCj4gIAl9DQo+ICANCj4gKwlpZiAoZW50cnktPnN0YXRlICE9IE1EQl9QRVJNQU5FTlQg
JiYgYnJfZ3JvdXBfaXNfbDIoJm1wLT5hZGRyKSkgew0KPiArCQlOTF9TRVRfRVJSX01TR19NT0Qo
ZXh0YWNrLCAiT25seSBwZXJtYW5lbnQgTDIgZW50cmllcyBhbGxvd2VkIik7DQo+ICsJCXJldHVy
biAtRUlOVkFMOw0KPiArCX0NCj4gKw0KDQpTb3JyeSwgYnV0IEkgZGlkbid0IG5vdGljZSB0aGlz
IGVhcmxpZXIuIFdlIG5lZWQgdG8gY2hlY2sgZm9yIHRoaXMgZXJyb3IgYmVmb3JlDQpjcmVhdGlu
ZyB0aGUgbWRiIGdyb3VwIG90aGVyd2lzZSB3ZSBjYW4gZW5kIHVwIHdpdGggZW1wdHkgZ3JvdXBz
IHRoYXQgY2FuJ3QgYmUNCmRlbGV0ZWQgZHVlIHRvIGVycm9ycy4gSS5lLiBpdCBtdXN0IGJlIGJl
Zm9yZSB0aGUgYnJfbXVsdGljYXN0X25ld19ncm91cCgpIGNhbGwuDQoNClRoZSByZXN0IGxvb2tz
IGdvb2QgdG8gbWUsIHRoYW5rcyENCg0KPiAgCS8qIGhvc3Qgam9pbiAqLw0KPiAgCWlmICghcG9y
dCkgew0KPiAgCQlpZiAobXAtPmhvc3Rfam9pbmVkKSB7DQo+IGRpZmYgLS1naXQgYS9uZXQvYnJp
ZGdlL2JyX211bHRpY2FzdC5jIGIvbmV0L2JyaWRnZS9icl9tdWx0aWNhc3QuYw0KPiBpbmRleCBl
YWU4OThjM2NmZjcuLjk4ZGUwYWNiMDMwNyAxMDA2NDQNCj4gLS0tIGEvbmV0L2JyaWRnZS9icl9t
dWx0aWNhc3QuYw0KPiArKysgYi9uZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jDQo+IEBAIC0xNzks
NyArMTc5LDggQEAgc3RydWN0IG5ldF9icmlkZ2VfbWRiX2VudHJ5ICpicl9tZGJfZ2V0KHN0cnVj
dCBuZXRfYnJpZGdlICpiciwNCg0K
