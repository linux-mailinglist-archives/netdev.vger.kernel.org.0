Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32F9270AEE
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 07:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgISFjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 01:39:21 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:9265 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgISFjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 01:39:21 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6599850000>; Sat, 19 Sep 2020 13:39:17 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 19 Sep
 2020 05:39:14 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 19 Sep 2020 05:39:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYD7Rr0yNRp9wCA77FnUy7/IwQwOPtfuyiyLZd/5YjAanG2l2OAPINp2l2cVwIc1+6ANrBguD9CgpT/Ddcd4zeh0bFW0PltkB/HcUuJzSDmXhLLiT4J3wm2l/GbZun6SsUlDX+ax9smc12NJL+q/Y5RUMaDk5O/SipLfnch8k+z9ZRMQ9JPtGKZKL/NxM8XFZVei479NUzURTdU1qiA5NsZto1OU+mNvWpWCsYxVbbaLBpm6pLOve3ADJgkHvF2jWnByDTPaWFZR1+Gior5cJPsh74Mt75a2rQ2qnLNq/ar+odRBPvLvOkBVQ6NAV02OJMB/nDxAk2Ds+3ADFf7l9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbpCTB9+pWO/5OoeMt7IYQv//JRq3JDuly5xNOw2rAQ=;
 b=PS+gmHpRrUkPSgXCj49wFQ9+RVMvjoIraXgglWvkojZsFl1Yk077r7EQRnaf4oJZsTc7vbT186MtF7jpmgmsCj6eUb+GlS0gEdHrJZFQAXpnCCSnl2Lx055DAPS3hIw+qPgYqjqQI4PYdsWmQhOjrcLFzujdtf0OlUgybItAKsOoP90/U3bqhV83SMOXY8Z7PKRRqTaHMH5Gp9uXUISQax6mxQZI8oQvzAW/KTtOL+mMNyRdwGwRWrzcqsuswDrZtpq9BYQmPLmX2rnR+0TiPb+akIkdezP90/hLYQpj9GJ78yh2IC29gGzfFlilIHz5e2M9C8qneELrFSS0nugPvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3080.namprd12.prod.outlook.com (2603:10b6:a03:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Sat, 19 Sep
 2020 05:39:09 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3391.017; Sat, 19 Sep 2020
 05:39:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 2/8] devlink: Support add and delete devlink
 port
Thread-Topic: [PATCH net-next v2 2/8] devlink: Support add and delete devlink
 port
Thread-Index: AQHWjRbeKGlxhy7jlEOUHXi/YotCx6ltKoOAgAChIZCAATsAgIAAbM7g
Date:   Sat, 19 Sep 2020 05:39:09 +0000
Message-ID: <BY5PR12MB432225BBE736C0D2EA1ACC30DC3C0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-3-parav@nvidia.com>
 <28cbe5b9-a39e-9299-8c9b-6cce63328f0f@intel.com>
 <BY5PR12MB43227952D5E596D50CD0D74DDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <35296a46-e0c7-264d-b69b-a3a617ae2ba3@intel.com>
In-Reply-To: <35296a46-e0c7-264d-b69b-a3a617ae2ba3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a80a59b8-191c-4cb9-daf8-08d85c5e5515
x-ms-traffictypediagnostic: BYAPR12MB3080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3080E1B36BDD8B5C18D1A875DC3C0@BYAPR12MB3080.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q022tDsHZByX9478VtXVmayHRex9sFzF+HDa2N71I+uwcov8yCAOv+ziuvSp6SCOidpXTOmwisfkn59MCJtQK4GjpemJ+UwxaC9b/nDJ4QI39dZQ0mr5O34AeYqlQlaFOL28YDq0RRHD2aoL+ozDMWknVIfaylENowIp3eA+yYXs9g53kJI87j+TokTvMpK6Uq7woNCklXjFsyvvr0eZKEP/WYa8TE2QnDzg85AKhwpP/xo+/zDnOwBSkd7vP+l4Os6RCBx2hQLIA1z1qSiD/o13J/z1xb2pmQ0qtr1QIF9cTNBP5QMMjZUn6QQW/HPMZ1lv8lASNaxT0QhpBx4ISphuTZOpJ1dyBmEgeBZxS9YVeFf4GXIxVjmkCTiJ7No+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(107886003)(478600001)(83380400001)(26005)(110136005)(8936002)(316002)(4326008)(33656002)(66946007)(86362001)(7696005)(66556008)(66476007)(186003)(64756008)(76116006)(5660300002)(52536014)(8676002)(2906002)(55016002)(9686003)(6506007)(53546011)(55236004)(71200400001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YHykLpM4uOeNYEu6mahf2HVp8iL8j1mkPSC+teHLKUGjjoR8DHcCDCs5CsP7cEOxrxg93YIqdBpuoT8QiXcS/nzyVcWW7bc20czh6uGdmDVgJGCoctJpdXR0suBzJuRtvt2i6If0lZCWJsOdshBGkCf1hWj1AHoWwe5FFJT8c+MWv0AqY7PY1T4Gb6G21iY/bWtgdrlDUByV3ZNcDTwa4KGKrqfotnNwF4y88msbNewJyQv+ZIJGIgAmGDPNFb4G9j0yWfT9GqAKguSt6jge2qtqh+MRKjCYNIBVvgW12VN82hGANRP5qNY/3GsNRw6uywfiEeUQxoUrB8iYra2wEeTBfSA55qt+PbhtYw19C0h4ocnDsL68LkAS86Zahk7sx5sed+gkw8g4Jfi0uKqXkbavO8Mgu5dt/lb0SV+9SWCJDb7QtecgykF1O3Y5MSMhELXVbEQU3g4u6N5lxbvEqaHIHbzzBKMdofZZ5bOurtFIZRijNpWtnTg95OAh+4gWCoEbvT+9fHhUWmeWBdoXTXC5N6AvPKhnSrziR4kjAvff4vh4E2Lbkh9h/xaz1UjMIoZH5Nhjqg4I5n1j1o9O7891q0wEf7ymiU4Ufs1L2/oSRSWiLmgIi2+jBR1OI1eHeiiTooS7fUkkMjKBZKHz+Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80a59b8-191c-4cb9-daf8-08d85c5e5515
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 05:39:09.6793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 20dUWkzYQiyvVsI5J2vm/Ipd5Fbwwdzbf2H2V5QqcWx6xgvHUneIXUmj9w81PTR8VAu8KQIb9lncNP0O4upyPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3080
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600493957; bh=pbpCTB9+pWO/5OoeMt7IYQv//JRq3JDuly5xNOw2rAQ=;
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
        b=DtaE18c4HK5ooODE+GnxLXYUm7wYlMX/Sic95jaLp+3PD2Hl72H7vW+MrYt3tgHWK
         l0f6dXXBCw+jVAHz+X+tbEUogdhFkFIG9+cSN8GWTI7GlhRbezgnBwYbOh/k0lWvss
         U+0qWagbO94IOwQpTvmPkQdWtyR6hCyUsB9sb63U4z7xctmOacqxAv/8Yu2TVDlbvC
         F/CJvNgIAOwL7HI2EVQubHzqA9ZHqT1ueuEe01v0yhmUlr2T0cCvJVKSZofYOG2TJ6
         SvjaYm0RpeLWHqF+m/XszgpY5KZGQhDws04safsXZbkPEpmt77iTG1KYItP9oJhTk7
         SfEJL8Wg2wuGA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IFNl
bnQ6IFNhdHVyZGF5LCBTZXB0ZW1iZXIgMTksIDIwMjAgNDozNyBBTQ0KPiANCj4gDQo+IE9uIDkv
MTcvMjAyMCA5OjI1IFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+IEZyb206IEphY29iIEtl
bGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIFNlcHRl
bWJlciAxOCwgMjAyMCAxMjoxMyBBTQ0KPiA+Pg0KPiA+Pg0KPiA+PiBPbiA5LzE3LzIwMjAgMTA6
MjAgQU0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPj4+IEV4dGVuZGVkIGRldmxpbmsgaW50ZXJm
YWNlIGZvciB0aGUgdXNlciB0byBhZGQgYW5kIGRlbGV0ZSBwb3J0Lg0KPiA+Pj4gRXh0ZW5kIGRl
dmxpbmsgdG8gY29ubmVjdCB1c2VyIHJlcXVlc3RzIHRvIGRyaXZlciB0byBhZGQvZGVsZXRlIHN1
Y2gNCj4gPj4+IHBvcnQgaW4gdGhlIGRldmljZS4NCj4gPj4+DQo+ID4+PiBXaGVuIGRyaXZlciBy
b3V0aW5lcyBhcmUgaW52b2tlZCwgZGV2bGluayBpbnN0YW5jZSBsb2NrIGlzIG5vdCBoZWxkLg0K
PiA+Pj4gVGhpcyBlbmFibGVzIGRyaXZlciB0byBwZXJmb3JtIHNldmVyYWwgZGV2bGluayBvYmpl
Y3RzIHJlZ2lzdHJhdGlvbiwNCj4gPj4+IHVucmVnaXN0cmF0aW9uIHN1Y2ggYXMgKHBvcnQsIGhl
YWx0aCByZXBvcnRlciwgcmVzb3VyY2UgZXRjKSBieQ0KPiA+Pj4gdXNpbmcgZXhpc2luZyBkZXZs
aW5rIEFQSXMuDQo+ID4+PiBUaGlzIGFsc28gaGVscHMgdG8gdW5pZm9ybWx5IHVzZWQgdGhlIGNv
ZGUgZm9yIHBvcnQgcmVnaXN0cmF0aW9uDQo+ID4+PiBkdXJpbmcgZHJpdmVyIHVubG9hZCBhbmQg
ZHVyaW5nIHBvcnQgZGVsZXRpb24gaW5pdGlhdGVkIGJ5IHVzZXIuDQo+ID4+Pg0KPiA+Pg0KPiA+
PiBPay4gU2VlbXMgbGlrZSBhIGdvb2QgZ29hbCB0byBiZSBhYmxlIHRvIHNoYXJlIGNvZGUgdW5p
Zm9ybWx5IGJldHdlZW4NCj4gPj4gZHJpdmVyIGxvYWQgYW5kIG5ldyBwb3J0IGNyZWF0aW9uLg0K
PiA+Pg0KPiA+IFllcy4NCj4gPg0KPiA+Pj4gK3N0YXRpYyBpbnQgZGV2bGlua19ubF9jbWRfcG9y
dF9uZXdfZG9pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QNCj4gPj4+ICtnZW5sX2luZm8g
KmluZm8pIHsNCj4gPj4+ICsJc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrID0gaW5mby0+
ZXh0YWNrOw0KPiA+Pj4gKwlzdHJ1Y3QgZGV2bGlua19wb3J0X25ld19hdHRycyBuZXdfYXR0cnMg
PSB7fTsNCj4gPj4+ICsJc3RydWN0IGRldmxpbmsgKmRldmxpbmsgPSBpbmZvLT51c2VyX3B0clsw
XTsNCj4gPj4+ICsNCj4gPj4+ICsJaWYgKCFpbmZvLT5hdHRyc1tERVZMSU5LX0FUVFJfUE9SVF9G
TEFWT1VSXSB8fA0KPiA+Pj4gKwkgICAgIWluZm8tPmF0dHJzW0RFVkxJTktfQVRUUl9QT1JUX1BD
SV9QRl9OVU1CRVJdKSB7DQo+ID4+PiArCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLCAiUG9y
dCBmbGF2b3VyIG9yIFBDSSBQRiBhcmUgbm90DQo+ID4+IHNwZWNpZmllZCIpOw0KPiA+Pj4gKwkJ
cmV0dXJuIC1FSU5WQUw7DQo+ID4+PiArCX0NCj4gPj4+ICsJbmV3X2F0dHJzLmZsYXZvdXIgPSBu
bGFfZ2V0X3UxNihpbmZvLQ0KPiA+Pj4gYXR0cnNbREVWTElOS19BVFRSX1BPUlRfRkxBVk9VUl0p
Ow0KPiA+Pj4gKwluZXdfYXR0cnMucGZudW0gPQ0KPiA+Pj4gK25sYV9nZXRfdTE2KGluZm8tPmF0
dHJzW0RFVkxJTktfQVRUUl9QT1JUX1BDSV9QRl9OVU1CRVJdKTsNCj4gPj4+ICsNCj4gPj4NCj4g
Pj4gUHJlc3VtaW5nIHRoYXQgdGhlIGRldmljZSBzdXBwb3J0cyBpdCwgdGhpcyBjb3VsZCBiZSB1
c2VkIHRvIGFsbG93DQo+ID4+IGNyZWF0aW5nIG90aGVyIHR5cGVzIG9mIHBvcnRzIGJzaWRlcyBz
dWJmdW5jdGlvbnM/DQo+ID4+DQo+ID4gVGhpcyBzZXJpZXMgaXMgY3JlYXRpbmcgUENJIFBGIGFu
ZCBzdWJmdW5jdGlvbiBwb3J0cy4NCj4gPiBKaXJpJ3MgUkZDIFsxXSBleHBsYWluZWQgYSBwb3Nz
aWJpbGl0eSBmb3IgVkYgcmVwcmVzZW50b3JzIHRvIGZvbGxvdyB0aGUgc2ltaWxhcg0KPiBzY2hl
bWUgaWYgZGV2aWNlIHN1cHBvcnRzIGl0Lg0KPiA+DQo+IA0KPiBSaWdodCwgVkZzIHdhcyB0aGUg
bW9zdCBvYnZpb3VzIHBvaW50LiBUaGUgYWJpbGl0eSB0byBjcmVhdGUgVkZzIHdpdGhvdXQgbmVl
ZGluZw0KPiB0byBkZXN0cm95IGFsbCBWRnMgYW5kIHJlLWNyZWF0ZSB0aGVtIHNlZW1zIHF1aXRl
IHVzZWZ1bC4NCj4gDQpZZXMuDQo+ID4gSSBhbSBub3Qgc3VyZSBjcmVhdGluZyBvdGhlciBwb3J0
IGZsYXZvdXJzIGFyZSB1c2VmdWwgZW5vdWdoIHN1Y2ggYXMgQ1BVLA0KPiBQSFlTSUNBTCBldGMu
DQo+ID4gSSBkbyBub3QgaGF2ZSBlbm91Z2gga25vd2xlZGdlIGFib3V0IHVzZSBjYXNlIGZvciBj
cmVhdGluZyBDUFUgcG9ydHMsIGlmIGF0DQo+IGFsbCBpdCBleGlzdHMuDQo+ID4gVXN1YWxseSBw
aHlzaWNhbCBwb3J0cyBhcmUgbGlua2VkIHRvIGEgY2FyZCBoYXJkd2FyZSBvbiBob3cgbWFueSBw
aHlzaWNhbA0KPiBwb3J0cyBwcmVzZW50IG9uIGNpcmN1aXQuDQo+ID4gU28gSSBmaW5kIGl0IG9k
ZCBpZiBhIGRldmljZSBzdXBwb3J0IHBoeXNpY2FsIHBvcnQgY3JlYXRpb24sIGJ1dCBhZ2FpbiBp
dHMgbXkNCj4gbGltaXRlZCB2aWV3IGF0IHRoZSBtb21lbnQuDQo+ID4NCj4gWWVhLCBJIGFncmVl
IGhlcmUgdG9vLiBJIGZpbmQgdGhhdCBzb21ld2hhdCBvZGQsIGJ1dCBJIHN1cHBvc2UgZm9yIGV2
ZXJ5dGhpbmcgYnV0DQo+IFBIWVNJQ0FMIHR5cGVzIGl0J3Mgbm90IGltcG9zc2libGUuDQpPay4N
Cg==
