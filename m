Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C06226F525
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgIREZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:25:19 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:47779 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgIREZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 00:25:19 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6436ac0000>; Fri, 18 Sep 2020 12:25:16 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 04:25:12 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 04:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZrqMspyRLsvs04M8tjNtXOTxxmB8XVpBWOZVN6gGAS7ZczDoQIrDkCcWj+ZnCMGGfuOizfUPHcoxAXQ0mZPu1XyJnIfGaNPlJ5vCV6AyLH5FMzLefUFVbD3i1hOHDCb8lOnFt5IT8M30K/llBkVS50vo6xiXDxbeqfHY6wptlKeh1LHEUhmunqruP8PjuejZclW1phRqCIhlt993HItKBdD1LPyl8eVdUEaErCP6jZI0Sr8AXGgZNcuEg1bKUC6Sh+Yww13awLopRVh8wYbDAxH2Zg+rCZEKp289x9663pk3b2QddSPzcJT0wOpio+coQa9v8qgcMYMjO9Ji6+WGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxNuorfcWzpXHnczqbKOKBri2Q9aITMQaMwMtD4duwc=;
 b=cmWLEoTXl04rSkWE1UgyhDK15UZrLBY4x3MW+YRvXoDIy/09wG9eHwtS1j3de4eg+d6NmIwvK1t/LAoZJ/40gu1GZB1dXTC1zszMExO99wJzoaDQ8kamzrte6LdhRpmJ3XN7+ENWHmvotW7ztITkRPx9Y6ZXPeBlIlSZIX+BFJPecHyLm1l12VdHZQdzbWS0lBhtD+cUGTJTHrI20N+kZ14HGXErWH1wmifJWgHu56FwkbYcaYSOOar1D3XKTdiXCbxoFw+zqF91vwKPSNvnPeZU2/1gBqGKSX/SsxREk4/D32ett/wZVtpLmArNNjJAWfYsSwHw0d4fCD8TGYgkFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4066.namprd12.prod.outlook.com (2603:10b6:a03:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 04:25:09 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 04:25:09 +0000
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
Thread-Index: AQHWjRbeKGlxhy7jlEOUHXi/YotCx6ltKoOAgAChIZA=
Date:   Fri, 18 Sep 2020 04:25:09 +0000
Message-ID: <BY5PR12MB43227952D5E596D50CD0D74DDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-3-parav@nvidia.com>
 <28cbe5b9-a39e-9299-8c9b-6cce63328f0f@intel.com>
In-Reply-To: <28cbe5b9-a39e-9299-8c9b-6cce63328f0f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25195fdd-8462-49a1-86d1-08d85b8ad460
x-ms-traffictypediagnostic: BY5PR12MB4066:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB40664C7E4C1F14CDE9038661DC3F0@BY5PR12MB4066.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P2ZUTa//1ivJP8PbtNCAwiLKNIP73TJEItPF3TGwBxybMuCk5rzIfTYbTtGd/AD0Ep5lFDNPX2k/0AFAMCHDSrHrCt0ybGV7XVgTKK4c5gRH9BWt0gSi0Sj/I8hCsOMHl2YirACbB02oThw5gbgBuC4t/K7u0onPXJ22D3uD/P1d0V5nEcjD0FqvpeXHoyGtqtELTVK+6ErJrD8xiOx9vdEC5ad5MVfygd336n2Uk3OKaAQa+ctbFtnpvsEJOEK8pBS+kxawCxoykBClS/n0TW+6JmfrjdfH28YUnwpYCGbQbdoxDJhsseDg5fEhr33LQZWMUm7xnjK9hJ9p0ZIpXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(55016002)(71200400001)(2906002)(55236004)(26005)(53546011)(6506007)(7696005)(66946007)(4326008)(83380400001)(107886003)(86362001)(8936002)(186003)(33656002)(76116006)(316002)(52536014)(478600001)(64756008)(66446008)(66556008)(66476007)(9686003)(8676002)(110136005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6WRQ9t+N1dK70zWnTK6yJ8KlXTytu+xvUZhMilVHFs0TIfme4323aqmyMBU3uoPVm8Qj6k5qXwTRMOviFlZAoJ43l8kLTMavDMbtAh2VSrXDUzblPMKFkQIBtiBNlQ2GqtEmXHKpWbDUaIchD4qMQ90wjX1kLvIHwts4QDwneZUkbgmFLz79Hw4YKn3x609H475Lhf53ZfDMLoRadTPkcfA1OPfPqBRFfFXPoNWmDibJlFC29e2mYWDbuYXaXN79thV4ZvR5HOYgsqdPnfRqCN/Lq07zWujetLr2y+HYTpqnfs9Irk0ZJzZdX1D8dAYNURTlsAa5HnVxJLNjG8/55d4ZUCGStpbXQwjmz7IhwGg6vboDabwcqeLW1DnA7GhXxjd6vfkPlLMkYz4hkKwVCuWdYXjbpdt0Pf0jjAp21G1YkgP29kY0rg+Y8EyVHDnfR2+U9Wy/FdPyRjtMJgMP+pE5X5f6CBVTkmI2Lxt3mkKsE6qiIX3CN6pgmJnqBRVET+AQYsM+bKCCzqPwKA7FZx0Oy7OVRrmVP0ObX6V6I0Ynwa2pPJjPwx2xRwOsO6ry22iuzIz/raBzofaNbKX974Nj6UuM81RL/CAKd7pxODM1nQVKcpHufy/KnXWXHBc3WXDamWP1Ig9GhffppZ1RwA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25195fdd-8462-49a1-86d1-08d85b8ad460
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 04:25:09.8530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /MCWCv/S1k5EozckN0ve0vxDxUKP+LBpY2oayRbb5U7qo8QR58sJGxQABCSCekVQtS1WO7bdXBfIEihsphfjww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4066
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600403116; bh=rxNuorfcWzpXHnczqbKOKBri2Q9aITMQaMwMtD4duwc=;
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
        b=A7ndBwgagQBEDUBXmNljbfWlA9La7iavb5KyAU2zVhZ7rbgU46GsShQfxfKT8kdO6
         BF4A3MvPrIIKFB5uK1lFxqv3ZFw0PEv5Sl71FoKIodV/czqK2qbLH/YA4xQ+bybCwO
         3T/tkE+yfebBkIZI/vIh2B5Tpcoz0ht4T0KcxJTG+mNJ/6Ez7dfAOJcwdODargPfqH
         0Wx7L+Rm/6u+rn7fpWrqYHGk4++hb6Nuf06xKa/xO1Yeo4kt5ziMvEZaz4Vu76Mz8l
         v32KL6sAv9k2bIy1oQQKDV8//H58V/dKbJ8f9d6eMey52jE+OqH/gU7y79HVq+KLai
         NIXlfFSd+vxOA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gU2VudDog
RnJpZGF5LCBTZXB0ZW1iZXIgMTgsIDIwMjAgMTI6MTMgQU0NCj4gDQo+IA0KPiBPbiA5LzE3LzIw
MjAgMTA6MjAgQU0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBFeHRlbmRlZCBkZXZsaW5rIGlu
dGVyZmFjZSBmb3IgdGhlIHVzZXIgdG8gYWRkIGFuZCBkZWxldGUgcG9ydC4NCj4gPiBFeHRlbmQg
ZGV2bGluayB0byBjb25uZWN0IHVzZXIgcmVxdWVzdHMgdG8gZHJpdmVyIHRvIGFkZC9kZWxldGUg
c3VjaA0KPiA+IHBvcnQgaW4gdGhlIGRldmljZS4NCj4gPg0KPiA+IFdoZW4gZHJpdmVyIHJvdXRp
bmVzIGFyZSBpbnZva2VkLCBkZXZsaW5rIGluc3RhbmNlIGxvY2sgaXMgbm90IGhlbGQuDQo+ID4g
VGhpcyBlbmFibGVzIGRyaXZlciB0byBwZXJmb3JtIHNldmVyYWwgZGV2bGluayBvYmplY3RzIHJl
Z2lzdHJhdGlvbiwNCj4gPiB1bnJlZ2lzdHJhdGlvbiBzdWNoIGFzIChwb3J0LCBoZWFsdGggcmVw
b3J0ZXIsIHJlc291cmNlIGV0YykgYnkgdXNpbmcNCj4gPiBleGlzaW5nIGRldmxpbmsgQVBJcy4N
Cj4gPiBUaGlzIGFsc28gaGVscHMgdG8gdW5pZm9ybWx5IHVzZWQgdGhlIGNvZGUgZm9yIHBvcnQg
cmVnaXN0cmF0aW9uDQo+ID4gZHVyaW5nIGRyaXZlciB1bmxvYWQgYW5kIGR1cmluZyBwb3J0IGRl
bGV0aW9uIGluaXRpYXRlZCBieSB1c2VyLg0KPiA+DQo+IA0KPiBPay4gU2VlbXMgbGlrZSBhIGdv
b2QgZ29hbCB0byBiZSBhYmxlIHRvIHNoYXJlIGNvZGUgdW5pZm9ybWx5IGJldHdlZW4gZHJpdmVy
DQo+IGxvYWQgYW5kIG5ldyBwb3J0IGNyZWF0aW9uLg0KPg0KWWVzLg0KIA0KPiA+ICtzdGF0aWMg
aW50IGRldmxpbmtfbmxfY21kX3BvcnRfbmV3X2RvaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3Ry
dWN0DQo+ID4gK2dlbmxfaW5mbyAqaW5mbykgew0KPiA+ICsJc3RydWN0IG5ldGxpbmtfZXh0X2Fj
ayAqZXh0YWNrID0gaW5mby0+ZXh0YWNrOw0KPiA+ICsJc3RydWN0IGRldmxpbmtfcG9ydF9uZXdf
YXR0cnMgbmV3X2F0dHJzID0ge307DQo+ID4gKwlzdHJ1Y3QgZGV2bGluayAqZGV2bGluayA9IGlu
Zm8tPnVzZXJfcHRyWzBdOw0KPiA+ICsNCj4gPiArCWlmICghaW5mby0+YXR0cnNbREVWTElOS19B
VFRSX1BPUlRfRkxBVk9VUl0gfHwNCj4gPiArCSAgICAhaW5mby0+YXR0cnNbREVWTElOS19BVFRS
X1BPUlRfUENJX1BGX05VTUJFUl0pIHsNCj4gPiArCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNr
LCAiUG9ydCBmbGF2b3VyIG9yIFBDSSBQRiBhcmUgbm90DQo+IHNwZWNpZmllZCIpOw0KPiA+ICsJ
CXJldHVybiAtRUlOVkFMOw0KPiA+ICsJfQ0KPiA+ICsJbmV3X2F0dHJzLmZsYXZvdXIgPSBubGFf
Z2V0X3UxNihpbmZvLQ0KPiA+YXR0cnNbREVWTElOS19BVFRSX1BPUlRfRkxBVk9VUl0pOw0KPiA+
ICsJbmV3X2F0dHJzLnBmbnVtID0NCj4gPiArbmxhX2dldF91MTYoaW5mby0+YXR0cnNbREVWTElO
S19BVFRSX1BPUlRfUENJX1BGX05VTUJFUl0pOw0KPiA+ICsNCj4gDQo+IFByZXN1bWluZyB0aGF0
IHRoZSBkZXZpY2Ugc3VwcG9ydHMgaXQsIHRoaXMgY291bGQgYmUgdXNlZCB0byBhbGxvdyBjcmVh
dGluZyBvdGhlcg0KPiB0eXBlcyBvZiBwb3J0cyBic2lkZXMgc3ViZnVuY3Rpb25zPw0KPg0KVGhp
cyBzZXJpZXMgaXMgY3JlYXRpbmcgUENJIFBGIGFuZCBzdWJmdW5jdGlvbiBwb3J0cy4NCkppcmkn
cyBSRkMgWzFdIGV4cGxhaW5lZCBhIHBvc3NpYmlsaXR5IGZvciBWRiByZXByZXNlbnRvcnMgdG8g
Zm9sbG93IHRoZSBzaW1pbGFyIHNjaGVtZSBpZiBkZXZpY2Ugc3VwcG9ydHMgaXQuDQoNCkkgYW0g
bm90IHN1cmUgY3JlYXRpbmcgb3RoZXIgcG9ydCBmbGF2b3VycyBhcmUgdXNlZnVsIGVub3VnaCBz
dWNoIGFzIENQVSwgUEhZU0lDQUwgZXRjLg0KSSBkbyBub3QgaGF2ZSBlbm91Z2gga25vd2xlZGdl
IGFib3V0IHVzZSBjYXNlIGZvciBjcmVhdGluZyBDUFUgcG9ydHMsIGlmIGF0IGFsbCBpdCBleGlz
dHMuDQpVc3VhbGx5IHBoeXNpY2FsIHBvcnRzIGFyZSBsaW5rZWQgdG8gYSBjYXJkIGhhcmR3YXJl
IG9uIGhvdyBtYW55IHBoeXNpY2FsIHBvcnRzIHByZXNlbnQgb24gY2lyY3VpdC4NClNvIEkgZmlu
ZCBpdCBvZGQgaWYgYSBkZXZpY2Ugc3VwcG9ydCBwaHlzaWNhbCBwb3J0IGNyZWF0aW9uLCBidXQg
YWdhaW4gaXRzIG15IGxpbWl0ZWQgdmlldyBhdCB0aGUgbW9tZW50Lg0KIA0KPiA+ICsJaWYgKGlu
Zm8tPmF0dHJzW0RFVkxJTktfQVRUUl9QT1JUX0lOREVYXSkgew0KPiA+ICsJCW5ld19hdHRycy5w
b3J0X2luZGV4ID0gbmxhX2dldF91MzIoaW5mby0NCj4gPmF0dHJzW0RFVkxJTktfQVRUUl9QT1JU
X0lOREVYXSk7DQo+ID4gKwkJbmV3X2F0dHJzLnBvcnRfaW5kZXhfdmFsaWQgPSB0cnVlOw0KPiA+
ICsJfQ0KPiANCj4gU28gaWYgdGhlIHVzZXJzcGFjZSBkb2Vzbid0IHByb3ZpZGUgYSBwb3J0IGlu
ZGV4LCBkcml2ZXJzIGFyZSByZXNwb25zaWJsZSBmb3INCj4gY2hvb3Npbmcgb25lPyBTYW1lIGZv
ciB0aGUgb3RoZXIgYXR0cmlidXRlcyBJIHN1cHBvc2U/DQpZZXMuDQoNCj4gDQo+ID4gKwlpZiAo
aW5mby0+YXR0cnNbREVWTElOS19BVFRSX1BPUlRfQ09OVFJPTExFUl9OVU1CRVJdKSB7DQo+ID4g
KwkJbmV3X2F0dHJzLmNvbnRyb2xsZXIgPQ0KPiA+ICsJCQlubGFfZ2V0X3UxNihpbmZvLQ0KPiA+
YXR0cnNbREVWTElOS19BVFRSX1BPUlRfQ09OVFJPTExFUl9OVU1CRVJdKTsNCj4gPiArCQluZXdf
YXR0cnMuY29udHJvbGxlcl92YWxpZCA9IHRydWU7DQo+ID4gKwl9DQo+ID4gKwlpZiAoaW5mby0+
YXR0cnNbREVWTElOS19BVFRSX1BPUlRfUENJX1NGX05VTUJFUl0pIHsNCj4gPiArCQluZXdfYXR0
cnMuc2ZudW0gPSBubGFfZ2V0X3UzMihpbmZvLQ0KPiA+YXR0cnNbREVWTElOS19BVFRSX1BPUlRf
UENJX1NGX05VTUJFUl0pOw0KPiA+ICsJCW5ld19hdHRycy5zZm51bV92YWxpZCA9IHRydWU7DQo+
ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYgKCFkZXZsaW5rLT5vcHMtPnBvcnRfbmV3KQ0KPiA+ICsJ
CXJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArDQo+ID4gKwlyZXR1cm4gZGV2bGluay0+b3BzLT5w
b3J0X25ldyhkZXZsaW5rLCAmbmV3X2F0dHJzLCBleHRhY2spOyB9DQo+ID4gKw0K
