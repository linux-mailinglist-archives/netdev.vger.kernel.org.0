Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6C22F479C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbhAMJaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:30:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:37567 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbhAMJav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:30:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610530251; x=1642066251;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lkAyzwBzZeOfugwoLnJ7mZXBEda2AEESDqRksJ++E5o=;
  b=z5Oqe7l/OvmoMvVLa6cYhdaTjsOq9GF5Mu7wviECez6QpHoxOFO4DG+a
   iwNSSfnGzhKVFgCNpOWsPzW/ZpghxLdxEFCreHhG8evP47GsbNNi5S5dU
   jfzLda3I95jqnsNS4cGjKFCPmTlx9MOR4iFUoRbKiinRONfveEJqjroKS
   7yfwJl5XymK1DMKzvWIWbc4DE6OfvndjiPOZEeFwvya8qULvrXA6mJqgP
   kGYwYJVXO1WLQrFJ+lMjMVguHUpZOyuu/mtMfkVMQoLSQJGG1stUBIJR7
   Gl/Pl7vTn8pjOInv2pNjBX2PJZiFkPYdwCXKr77cwHP4+ZH6rkltmcm0+
   Q==;
IronPort-SDR: 9zjNJoUX7Rx1aKQ/ssQo5BvFoUMjMx/AsPMD5H3qmerRxLMLEet4/UcPZOo/PoPKaqDMDqXIMP
 C21bFbmMMd5CzCpoL7khz1S0OktcXhI8fBts/UbEBsWuUCB7vHhtyYKN9ZBf3V5vD3kSiUJetf
 oE1+elkwdwP5x3BBQSO0dx/HGq8OU/F+SfLU5EvrBs0qUCfO7bC7Q32NLoE4mO5MOxpBwITZXr
 bw0iGxVpFmNMXCx2Bx0sP34u0l+BPfefqT8EpUdunl0m4S9nwhfqZDq1frlsJT9CffMUKXXKMW
 XqU=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="105810639"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2021 02:29:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 02:29:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 13 Jan 2021 02:29:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iys7jh5QuWMglwWOVjue5/wlkBooPG43WLZuhOWZh5pdX1fVofFnA0FxbRkI8T27VXA3YxpV+gmLKYjUbOeThOSYjmq1k4VYVjhTQCUjIixE9/kXGxh2YJVq3s+8uVoECVwO8wUW/7+FIYIO4UMU6na69M0uV75kY6z59q+HZTXLkHFdqk1dNycA6NEuIfNZYCWVYiNf7si5ORrhB7c5tS03dDhNFto6Cl9mjhMKuYw0aOO+uOWeYX6grb5AuPCVEyTztQrrT9EOibUKJU58OFwzH8pQZABzLSMw0zlHFotLzd2n6S1Ssy+6RhnWFmnI9aTIYSgo1n6U6PUg3iHK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkAyzwBzZeOfugwoLnJ7mZXBEda2AEESDqRksJ++E5o=;
 b=bCM33sVHnzvOyeIkAci8pVESTk1vwJmOdTbOkWJ5XmhzoLJ/xTSSTzjkMzQ6oq1d5O48mHPoyQ+/DtNWW0fLw/cLLebwJSCGA7dga7VaSNPnAvbvV7RjBncxPHb+t97La2g8zxkUY7domAgv2eyLur3g60p9TBsGWGny+QKduJNhIjS0Xg6oISU9KE+FCkddOZOIxq+SdN+ib+MyJlaW1sCnjlgPOp5n6Pwkf5AlCjsMELOcJtM4uIa0QeEhxNaDlljnctMrywawUj1IQMdlbGgAHd0F2yXZjnQBjp6VsEw1KkmwRgPSmmii2FJoGXGE/7x+fZeQDmt4zz01sAgbbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkAyzwBzZeOfugwoLnJ7mZXBEda2AEESDqRksJ++E5o=;
 b=WC1CzUjs6yR/uA0eLFLWjGNoRIbTh3PQixeiIToBeZoOI9y62938yn19ioGcWbNVOaXyl4CcEN8QUs6vHosO61PQA/Jv74jhyOGqJ4/lxlOda3DpBEWJW03V6mzTzY34vSRw3PYld++7wj+kGyKfc6UJ4uBMEfGVnn76BLJkNbY=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB2538.namprd11.prod.outlook.com (2603:10b6:5:be::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Wed, 13 Jan 2021 09:29:33 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 09:29:32 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <hkallweit1@gmail.com>, <andrew@lunn.ch>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Topic: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Index: AQHW6Y6UrG2j4PiM1k2BT3XuGZuJHg==
Date:   Wed, 13 Jan 2021 09:29:32 +0000
Message-ID: <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
In-Reply-To: <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1950bf1-d410-49fe-c3f3-08d8b7a5bc52
x-ms-traffictypediagnostic: DM6PR11MB2538:
x-microsoft-antispam-prvs: <DM6PR11MB253830384A6DF6AF584B1C4487A90@DM6PR11MB2538.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b08qXumU99ZXPpQSP7SG49QaRHKIf8c4ZLALCmSg0a545x5qrN4DEtzVbnUekP5b9YQCGi13iPwwJtmjQLYKRT9QzWcpq/jwTXq2aTBidEPujHht+qpLXebP8hEIcKW+IktOHkGDxeCs1+X3yz/2ADxTM9nghjTfTDjWnphcjeaFMksHPDJVYdLki4Kd8GmwV/Npi7sXGZRF+9ia8tNiYJeKnSiIUrxAUqO/tVQLwiWhPN/orApdq417ivupLNzER6HTi/W1GNfG2yVSeb7bUVlEUKywLpc80vxoLBuXQTHcJzyap5saDOb7P5gTsG6L9NVTAzYu911++11zfaHn64XM5BokyXmgYSRzwhcvRxE2kPcxT+vC0DjTmuUaafzKg8jytYeo/oUaBS8CwBaXNSLL97Q9pDVD7WS6fLK+Le67g4tGe+6f+u4k30oO9RZaY86H1bkwDtdCF/lc62D827msc3rIxs7zbkQUlP5PpYI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(8676002)(6506007)(316002)(53546011)(31686004)(6486002)(66946007)(4326008)(8936002)(86362001)(2906002)(6512007)(76116006)(36756003)(2616005)(91956017)(83380400001)(66556008)(186003)(66476007)(64756008)(66446008)(26005)(54906003)(110136005)(71200400001)(31696002)(5660300002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WmRFQnZDOEcvSDc2ZGxpNFRJdEdEOEh4L1puS3pQbUo0UzFNL09DbDVUVzEr?=
 =?utf-8?B?dXJuNHJua05jeHlRMEZDUTV6Y1ZTOW85bjk0NkgzT092VnNvTkZkdnpSQTlC?=
 =?utf-8?B?a3l4Ykk0WXpRbWtsSGlSUUdlb3lLdkhGYVNRdlg1ZXVKNmpYaXpsTkRERzYw?=
 =?utf-8?B?OTJRUUVlUDgyWjZraHMzdGpGQlllcXd4VVU5QlVkcHd2akZUYVlSMG5yTEp2?=
 =?utf-8?B?YVBzRExhcytHOVRqS2JsRUZZendrYngzTWJxZkpYcSszbFkrdTBJNkFUUWti?=
 =?utf-8?B?UFYxNUxzenlpaDJOdlFsellDeG1QS2dWVllQNmVQdHdaR0l4bktFU0RRV2hI?=
 =?utf-8?B?Z2FkV0lTMVRDcXR1amFLdmNwSklDTlNXSHhiV3VCdHh3RUJ0TEhrUnVuL1JL?=
 =?utf-8?B?UEpIN09EUWxsZ2daK2ZrL0hhL1hsYzMxbXc2ZThpeVlzNkNram5qMmMzeEpj?=
 =?utf-8?B?bXN1c2UzeVdXV1hzNFZ5a0FJamt0Q0lzNTFWR2lycU9nQjFESUxldVYyMWZ4?=
 =?utf-8?B?UmJONUk5aUVzWUpETzBvd1AwMTFhUGxMcUFXZHg1WGZxUHozNHVwMm9ueERB?=
 =?utf-8?B?dU5TeFJNaVBuUVE2eCtoT1kzWUtpSG5SK3hrNTZaNUJ5WlJwVW5qb2d1Qk5C?=
 =?utf-8?B?WktCUTJXQlVtSVUwN0k0MFU3ZXBXQUZFNUVvWnpIMi9lSXdYNWVPdnhHUXZs?=
 =?utf-8?B?a2REekhrNUVYdU9CeUF6d1RCL0d2Y0FsTmFqNlBWamVQYjNGbjZvOUNKcE8r?=
 =?utf-8?B?N2lzN3Z1dUtldndYUUF2VUFnci93OWNCNVRyZTRkMlBxdlUyU3lFWk9PK3Vy?=
 =?utf-8?B?eVFwa0liMjNRcElOQjRLcFg4aGNXTVVRb2VFTmgvWkdCQ3BjUC9DOHNqNWNK?=
 =?utf-8?B?bm5CWWNHdEw0ZzN6YnVOdU9BZ1dIVzQydW1ZcEdmV0ZDOEJVVlVVakF6K1pO?=
 =?utf-8?B?VXRjc2M2Y29nY29YTE1WOW5MeFIrOUhvZ3psYm80YjhuZGdKalk1Z1RHeFgw?=
 =?utf-8?B?TzFPM21DMXRISXJXY1Z3dzJJTDdwblUvb0gyVVZaNkpsWFVtRDFQYWlGeDFT?=
 =?utf-8?B?TnNwUVdrcjJ4YkZGczNFSEJPOGVvN292TzhBb1Fia2VXSWFTMFk0UUZPbkl1?=
 =?utf-8?B?MWpPVE9sSTdFcklSSlo5cmVqbk9KM2ZnaGJXSDVrYldkL0E0NjVtUUxUMUtV?=
 =?utf-8?B?Ulh0K2RhdmxqWFkwcXJNMDIrckVtRDZ0YmcrcXpHMHp2c0gwUWhtM244UStT?=
 =?utf-8?B?Zk13dXZXR1ZzS21rRWhJc0p5M2lZVGxTVUoyNjJsNUdYOW1OUlREajZxOVZ0?=
 =?utf-8?Q?N5jPWLUTJmr7O5yYhnGcxBAxtroNwoKlEI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C0AEAF9735B4B40A390D557CE7EC9B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1950bf1-d410-49fe-c3f3-08d8b7a5bc52
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 09:29:32.9113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FBlH+zbUyZIifUnSL21sNu1SB4YXQrWFIIE8uao3M0MDdDKQEvcDALNv5Y33PwwNI8e6XwACU5WfqD03KxMFvGfaBxcMTUCwG5l7vs3nevU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpbmVyLA0KDQpPbiAwOC4wMS4yMDIxIDE4OjMxLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gMDguMDEuMjAy
MSAxNjo0NSwgQ2xhdWRpdSBCZXpuZWEgd3JvdGU6DQo+PiBLU1o5MTMxIGlzIHVzZWQgaW4gc2V0
dXBzIHdpdGggU0FNQTdHNS4gU0FNQTdHNSBzdXBwb3J0cyBhIHNwZWNpYWwNCj4+IHBvd2VyIHNh
dmluZyBtb2RlIChiYWNrdXAgbW9kZSkgdGhhdCBjdXRzIHRoZSBwb3dlciBmb3IgYWxtb3N0IGFs
bA0KPj4gcGFydHMgb2YgdGhlIFNvQy4gVGhlIHJhaWwgcG93ZXJpbmcgdGhlIGV0aGVybmV0IFBI
WSBpcyBhbHNvIGN1dCBvZmYuDQo+PiBXaGVuIHJlc3VtaW5nLCBpbiBjYXNlIHRoZSBQSFkgaGFz
IGJlZW4gY29uZmlndXJlZCBvbiBwcm9iZSB3aXRoDQo+PiBzbGV3IHJhdGUgb3IgRExMIHNldHRp
bmdzIHRoZXNlIG5lZWRzIHRvIGJlIHJlc3RvcmVkIHRodXMgY2FsbA0KPj4gZHJpdmVyJ3MgY29u
ZmlnX2luaXQoKSBvbiByZXN1bWUuDQo+Pg0KPiBXaGVuIHdvdWxkIHRoZSBTb0MgZW50ZXIgdGhp
cyBiYWNrdXAgbW9kZT8NCg0KSXQgY291bGQgZW50ZXIgaW4gdGhpcyBtb2RlIGJhc2VkIG9uIHJl
cXVlc3QgZm9yIHN0YW5kYnkgb3Igc3VzcGVuZC10by1tZW06DQplY2hvIG1lbSA+IC9zeXMvcG93
ZXIvc3RhdGUNCmVjaG8gc3RhbmRieSA+IC9zeXMvcG93ZXIvc3RhdGUNCg0KV2hhdCBJIGRpZG4n
dCBtZW50aW9uZWQgcHJldmlvdXNseSBpcyB0aGF0IHRoZSBSQU0gcmVtYWlucyBpbiBzZWxmLXJl
ZnJlc2gNCndoaWxlIHRoZSByZXN0IG9mIHRoZSBTb0MgaXMgcG93ZXJlZCBkb3duLg0KDQo+IEFu
ZCB3b3VsZCBpdCBzdXNwZW5kIHRoZQ0KPiBNRElPIGJ1cyBiZWZvcmUgY3V0dGluZyBwb3dlciB0
byB0aGUgUEhZPw0KDQpTQU1BN0c1IGVtYmVkcyBDYWRlbmNlIG1hY2IgZHJpdmVyIHdoaWNoIGhh
cyBhIGludGVncmF0ZWQgTURJTyBidXMuIEluc2lkZQ0KbWFjYiBkcml2ZXIgdGhlIGJ1cyBpcyBy
ZWdpc3RlcmVkIHdpdGggb2ZfbWRpb2J1c19yZWdpc3RlcigpIG9yDQptZGlvYnVzX3JlZ2lzdGVy
KCkgYmFzZWQgb24gdGhlIFBIWSBkZXZpY2VzIHByZXNlbnQgaW4gRFQgb3Igbm90LiBPbiBtYWNi
DQpzdXNwZW5kKCkvcmVzdW1lKCkgZnVuY3Rpb25zIHRoZXJlIGFyZSBjYWxscyB0bw0KcGh5bGlu
a19zdG9wKCkvcGh5bGlua19zdGFydCgpIGJlZm9yZSBjdXR0aW5nL2FmdGVyIGVuYWJsaW5nIHRo
ZSBwb3dlciB0bw0KdGhlIFBIWS4NCg0KPiBJJ20gYXNraW5nIGJlY2F1c2UgaW4gbWRpb19idXNf
cGh5X3Jlc3RvcmUoKSB3ZSBjYWxsIHBoeV9pbml0X2h3KCkNCj4gYWxyZWFkeSAodGhhdCBjYWxs
cyB0aGUgZHJpdmVyJ3MgY29uZmlnX2luaXQpLg0KDQpBcyBmYXIgYXMgSSBjYW4gc2VlIGZyb20g
ZG9jdW1lbnRhdGlvbiB0aGUgLnJlc3RvcmUgQVBJIG9mIGRldl9wbV9vcHMgaXMNCmhpYmVybmF0
aW9uIHNwZWNpZmljIChwbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcpLiBPbiB0cmFuc2l0
aW9ucyB0bw0KYmFja3VwIG1vZGUgdGhlIHN1c3BlbmQoKS9yZXN1bWUoKSBQTSBBUElzIGFyZSBj
YWxsZWQgb24gdGhlIGRyaXZlcnMuDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUgQmV6bmVhDQoNCj4g
DQo+PiBTaWduZWQtb2ZmLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9j
aGlwLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvbmV0L3BoeS9taWNyZWwuYyB8IDIgKy0NCj4+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jIGIvZHJpdmVycy9uZXQvcGh5L21p
Y3JlbC5jDQo+PiBpbmRleCAzZmU1NTI2NzVkZDIuLjUyZDNhMDQ4MDE1OCAxMDA2NDQNCj4+IC0t
LSBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L21p
Y3JlbC5jDQo+PiBAQCAtMTA3Nyw3ICsxMDc3LDcgQEAgc3RhdGljIGludCBrc3pwaHlfcmVzdW1l
KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiAgICAgICAgKi8NCj4+ICAgICAgIHVzbGVl
cF9yYW5nZSgxMDAwLCAyMDAwKTsNCj4+DQo+PiAtICAgICByZXQgPSBrc3pwaHlfY29uZmlnX3Jl
c2V0KHBoeWRldik7DQo+PiArICAgICByZXQgPSBwaHlkZXYtPmRydi0+Y29uZmlnX2luaXQocGh5
ZGV2KTsNCj4+ICAgICAgIGlmIChyZXQpDQo+PiAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+
Pg0KPj4NCj4g
