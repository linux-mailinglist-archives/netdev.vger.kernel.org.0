Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7724A284E54
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgJFOxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:53:08 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:13384 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFOxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:53:08 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c84d00000>; Tue, 06 Oct 2020 22:53:04 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 14:53:04 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 14:53:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bapkoFbY01BVB6pa9ul0dDGjvNy4AUlpysYguYJC4rxAjIZP/0lfYO1BG4edU7usyXKDqMVLx18KK3ItSFxh1UVLk8LffVsOBu913Rf2yZZBjDLfFxK+kXnwPMJa/8MWzdhTmTDmX2j2RpHXRA3HcA0uEV4XutOr6UC5CUdZfymkh+BxaszFgIfGiP9BjtJqXCq0J5iinYGORnBeGLtcNGI9NwBrRZf2VX+8+FCeTAaS1ixosZxSpTpi3YRquCVEY8TfanoSN0XkCeraxpBwt6JCYBEHGHH+AJTNdn2a8KS65osFY+sNVAVnrIPXgf+Fvgz2djGbowd9ipGq602aqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7Rgl0kfFqjFsbInGe7wqL9JXxvpY8RtAOtYcTdUzb0=;
 b=ctzwHZA4E0o2H+1aQ69eKim0Q5BB6k6LWEoGS5sDubywefSx+d/Rw2luweevlorgD+R0nvYJZL7jzWqKgy8Ss+ywJ1772qoNXzXTnsdnpjSsED1vTY8xiucVsCiwxRZoZK3Rf90TjDZDLElMGlQZ/HazwHaUFX3ENaVqGQLi9N2GghMzB9tPQlDOzln8XnzLdEVRuf5J+dkoFfc1rNt+cxc5G4tLxgDayqPpkPgrMegLpRq9jF402DNdRc1+jEFE6zE9lHm9S8vSrpt4G0l9bz9ZN36RHW5olnpX/iG/ZiMqvoibuNIn+1GdvALyKZnQbWSMrUBTW79KqRNUQchXSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB4282.namprd12.prod.outlook.com (2603:10b6:5:223::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Tue, 6 Oct
 2020 14:53:01 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 14:53:01 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [net-next v2 09/11] bridge: cfm: Bridge port remove.
Thread-Topic: [net-next v2 09/11] bridge: cfm: Bridge port remove.
Thread-Index: AQHWl94/cZNwN8EcbUClfuJ4F4rKnqmKsQgA
Date:   Tue, 6 Oct 2020 14:53:00 +0000
Message-ID: <e1ee6179d667fee17e2f6d9582a85669d6792cf7.camel@nvidia.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
         <20201001103019.1342470-10-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201001103019.1342470-10-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20901386-5cc4-49f6-7002-08d86a07858a
x-ms-traffictypediagnostic: DM6PR12MB4282:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB428267EC58194D2E1D95D34EDF0D0@DM6PR12MB4282.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dGV9vPwsRxfj4s/Q0VCd9z4QHkDHzchIrKkKpLo6gSWTSfUZTUh6B3XTF+E+2pSMSq2GwWc6zdqenEkCky8ouG80i1KOK9iJUy3Dzn5615qXv+SM0rr4OyFpGuQCkMt2u7Z0lBjPRxWUbTFnhbR3fIrxhefviWlZMteVqOvGupEGZkdX2A6tE/z+9JffAs1JsiniuyD9ChZ+qj+70++ZTQ7u9XNAYGDAYvE/SIQfaP4OktXfBisLFu6kachRicSQ2+BRxcE+Bm8q0R8xZfXHPEiza/V+M5qWln8/Z80sPJylAX/GDRchu3yf2r7ww4u0bk85nekQGQr0uKjV00wqCiUzjcAVJhwTlJLlNXNZNkOjPTvm+AUP0X99Qg6wdeep
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(2906002)(2616005)(71200400001)(26005)(3450700001)(6506007)(83380400001)(186003)(5660300002)(478600001)(8676002)(8936002)(4326008)(36756003)(6486002)(86362001)(110136005)(91956017)(6512007)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(316002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: y/GBk6WsF61o5Xddks9ZDu5RpqJhEJvBAgrz7sZEFMsXsKB1vVolu63kh4cAn+qaWOPbp5joGQVRYUzqkWEqxEnJ+ymxQtW9l21euk8HvEUu4PXgt3a+GZ9rioItVjxPphicSRQT4JvL78Vaprs3uJUAF3HueNON66e2QiTNf7XV1+F9lGsxq7t+trt2cqRJ8JDAVc/1esR+qd2ljMuyCKMwEVCWLo8EpmhD2HTBpt+pGIC09b7VDOIUBN67rxYFmiELyoyNqXQt83xThktEmxCvPgYSATPxRS9t85AyhcqUVwhxLSPjp6n5bzwa23HdGaAuqAIQKKy0+cHbzvF626h9os6whMEO9SU5OK/dNPthEA7LnmGFtA2dxyYkf635wc7hOz+/ZNgvSviLa7VRU+A8WappSbiJDD1nUCFocpcW7xxkSZMc76unCpBcNy7LchxrRfcsalBwuZFaoH5n7xiWzQQPRN3c9VOJiQJS13B+4dSJvtLu1MVBt8aY1GvUU1/eCcv0+2PO62tMsCRLx/yOHYp0T4vsB88YpDPzQ4nhHa17AQPgQLwX4dYhPFVxPmV/kD7rebzjlRbWX0SdIwmWmjO1J1HAUfsmpqhaoL4dJabO+L1mLsLotB7OrnwI7G2gUqyzGQzTHIOrpVv5SA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A04CE34C6F2D549A27F6791FB556628@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20901386-5cc4-49f6-7002-08d86a07858a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 14:53:00.9183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ChPxl364uA2Fh3G+lj/04C4kX03FbLAa1l41nNv7mTia9BqKtJiBi0iDxXJNL7bJxKUNOFn0M7uHWsr8+zAAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4282
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601995984; bh=N7Rgl0kfFqjFsbInGe7wqL9JXxvpY8RtAOtYcTdUzb0=;
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
        b=WofO17WVN0CxHjpR1DnHwu5uvZGvtNe4zaYaFlB70MCYFONRgflid/udpd2p1xHmU
         UWO6mGDSvaFcZ4cvn0p5oyglvpCrN1TgQ1/BRaW6LmxEBI5jsBQD6axuhH5fLCJDz6
         +IqZiUxau11g2eRvLvB+66LyKrrcArg5nA/5XDNPLbBpdKyEle489hCpUNGrsr11h4
         E6anwexoXCx39e9Q8eElGt6evDvmNiDEvEcSt/rCxUmaZnQOVn/UdzKfyUD1FdFEft
         zhsWSsCPDQhzTFHKbFPuwmxCFHWpSMx17Lpk4wYDUsSvEUqE/JEUij5J66wWnqOsTe
         hQR1Y0QC0meqg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTAxIGF0IDEwOjMwICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyBhZGRpdGlvbiBvZiBDRk0gZnVuY3Rpb25hbGl0eSB0byBkZWxldGUgTUVQ
IGluc3RhbmNlcw0KPiBvbiBhIHBvcnQgdGhhdCBpcyByZW1vdmVkIGZyb20gdGhlIGJyaWRnZS4N
Cj4gQSBNRVAgY2FuIG9ubHkgZXhpc3Qgb24gYSBwb3J0IHRoYXQgaXMgcmVsYXRlZCB0byBhIGJy
aWRnZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVy
QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICA8aGVu
cmlrLmJqb2Vybmx1bmRAbWljcm9jaGlwLmNvbT5tDQo+IC0tLQ0KPiAgbmV0L2JyaWRnZS9icl9j
Zm0uYyAgICAgfCAxMyArKysrKysrKysrKysrDQo+ICBuZXQvYnJpZGdlL2JyX2lmLmMgICAgICB8
ICAxICsNCj4gIG5ldC9icmlkZ2UvYnJfcHJpdmF0ZS5oIHwgIDYgKysrKysrDQo+ICAzIGZpbGVz
IGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykNCj4gDQoNClRoaXMgcGF0Y2ggc2hvdWxkIGJlIGEg
cGFydCBvZiB0aGUgb25lIHdoaWNoIGFkZHMgdGhlIGFiaWxpdHkgdG8gYXR0YWNoIE1FUHMgdG8N
CnBvcnRzIHNvIHRoZXkgd2lsbCBnZXQgY2xlYW5lZCB1cCBwcm9wZXJseSBvbiBwb3J0IGRlbCBp
biB0aGUgc2FtZSBwYXRjaC4NCklzIHRoZXJlIGEgcmVhc29uIGZvciBpdCB0byBiZSBhIHNlcGFy
YXRlIHBhdGNoPw0KDQpPbmUgbW9yZSBjb21tZW50IGJlbG93Lg0KDQpUaGFua3MsDQogTmlrDQoN
Cj4gZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJfY2ZtLmMgYi9uZXQvYnJpZGdlL2JyX2NmbS5j
DQo+IGluZGV4IDZmYmZlZjQ0YzIzNS4uZmM4MjY4Y2I3NmMxIDEwMDY0NA0KPiAtLS0gYS9uZXQv
YnJpZGdlL2JyX2NmbS5jDQo+ICsrKyBiL25ldC9icmlkZ2UvYnJfY2ZtLmMNCj4gQEAgLTg2Nywz
ICs4NjcsMTYgQEAgYm9vbCBicl9jZm1fY3JlYXRlZChzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIpDQo+
ICB7DQo+ICAJcmV0dXJuICFobGlzdF9lbXB0eSgmYnItPm1lcF9saXN0KTsNCj4gIH0NCj4gKw0K
PiArLyogRGVsZXRlcyB0aGUgQ0ZNIGluc3RhbmNlcyBvbiBhIHNwZWNpZmljIGJyaWRnZSBwb3J0
DQo+ICsgKi8NCj4gK3ZvaWQgYnJfY2ZtX3BvcnRfZGVsKHN0cnVjdCBuZXRfYnJpZGdlICpiciwg
c3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcG9ydCkNCj4gK3sNCj4gKwlzdHJ1Y3QgYnJfY2ZtX21l
cCAqbWVwOw0KPiArDQo+ICsJQVNTRVJUX1JUTkwoKTsNCj4gKw0KPiArCWhsaXN0X2Zvcl9lYWNo
X2VudHJ5KG1lcCwgJmJyLT5tZXBfbGlzdCwgaGVhZCkNCg0KaGxpc3RfZm9yX2VhY2hfZW50cnlf
c2FmZSgpDQoNCj4gKwkJaWYgKG1lcC0+Y3JlYXRlLmlmaW5kZXggPT0gcG9ydC0+ZGV2LT5pZmlu
ZGV4KQ0KPiArCQkJbWVwX2RlbGV0ZV9pbXBsZW1lbnRhdGlvbihiciwgbWVwKTsNCj4gK30NCj4g
ZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJfaWYuYyBiL25ldC9icmlkZ2UvYnJfaWYuYw0KPiBp
bmRleCBhMGU5YTc5Mzc0MTIuLmY3ZDJmNDcyYWUyNCAxMDA2NDQNCj4gLS0tIGEvbmV0L2JyaWRn
ZS9icl9pZi5jDQo+ICsrKyBiL25ldC9icmlkZ2UvYnJfaWYuYw0KPiBAQCAtMzM0LDYgKzMzNCw3
IEBAIHN0YXRpYyB2b2lkIGRlbF9uYnAoc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCkNCj4gIAlz
cGluX3VubG9ja19iaCgmYnItPmxvY2spOw0KPiAgDQo+ICAJYnJfbXJwX3BvcnRfZGVsKGJyLCBw
KTsNCj4gKwlicl9jZm1fcG9ydF9kZWwoYnIsIHApOw0KPiAgDQo+ICAJYnJfaWZpbmZvX25vdGlm
eShSVE1fREVMTElOSywgTlVMTCwgcCk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL25ldC9icmlkZ2Uv
YnJfcHJpdmF0ZS5oIGIvbmV0L2JyaWRnZS9icl9wcml2YXRlLmgNCj4gaW5kZXggNTk1NGVlNDVh
ZjgwLi43MzVkZDAwMjhiNDAgMTAwNjQ0DQo+IC0tLSBhL25ldC9icmlkZ2UvYnJfcHJpdmF0ZS5o
DQo+ICsrKyBiL25ldC9icmlkZ2UvYnJfcHJpdmF0ZS5oDQo+IEBAIC0xNDY1LDYgKzE0NjUsNyBA
QCBzdGF0aWMgaW5saW5lIGludCBicl9tcnBfZmlsbF9pbmZvKHN0cnVjdCBza19idWZmICpza2Is
IHN0cnVjdCBuZXRfYnJpZGdlICpicikNCj4gIGludCBicl9jZm1fcGFyc2Uoc3RydWN0IG5ldF9i
cmlkZ2UgKmJyLCBzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwLA0KPiAgCQkgc3RydWN0IG5sYXR0
ciAqYXR0ciwgaW50IGNtZCwgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKTsNCj4gIGJv
b2wgYnJfY2ZtX2NyZWF0ZWQoc3RydWN0IG5ldF9icmlkZ2UgKmJyKTsNCj4gK3ZvaWQgYnJfY2Zt
X3BvcnRfZGVsKHN0cnVjdCBuZXRfYnJpZGdlICpiciwgc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAq
cCk7DQo+ICBpbnQgYnJfY2ZtX2NvbmZpZ19maWxsX2luZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwg
c3RydWN0IG5ldF9icmlkZ2UgKmJyKTsNCj4gIGludCBicl9jZm1fc3RhdHVzX2ZpbGxfaW5mbyhz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KPiAgCQkJICAgIHN0cnVjdCBuZXRfYnJpZGdlICpiciwNCj4g
QEAgLTE0ODQsNiArMTQ4NSwxMSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgYnJfY2ZtX2NyZWF0ZWQo
c3RydWN0IG5ldF9icmlkZ2UgKmJyKQ0KPiAgCXJldHVybiBmYWxzZTsNCj4gIH0NCj4gIA0KPiAr
c3RhdGljIGlubGluZSB2b2lkIGJyX2NmbV9wb3J0X2RlbChzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIs
DQo+ICsJCQkJICAgc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCkNCj4gK3sNCj4gK30NCj4gKw0K
PiAgc3RhdGljIGlubGluZSBpbnQgYnJfY2ZtX2NvbmZpZ19maWxsX2luZm8oc3RydWN0IHNrX2J1
ZmYgKnNrYiwgc3RydWN0IG5ldF9icmlkZ2UgKmJyKQ0KPiAgew0KPiAgCXJldHVybiAtRU9QTk9U
U1VQUDsNCg0K
