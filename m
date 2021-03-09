Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C21E332BE8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhCIQY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:24:59 -0500
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:8544
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhCIQYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 11:24:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1KqHzAWIz4dBmnlfgcJ5HAbMJj8oF03gLEIr7JfL8WHxdy5iPNxmknsanofiRjGHs1F3HYVg/annlr7fhZnSj6iN1nhjBUlpoD10fhGxelsSJed6N0zmamwr33wAD5wd4GsqbZicfgPC5dMVOoPmuMV3XC9VLoowkSwzlEWWyc5jBUsQ1V36ChZ6WbsUt7P0Vmii1ouvciKyLf73SBkhSRVnyLpdSbSDaV3rtcyzP3eTYEsXMk2qWm6tsBncYg3jJ+FiIZtU8eY6OdVbMfzoPPQIF85n99bVHZaVDJhiv2wLLVpd+0XhdtNGoBF/lnp98CB6PsjuXXUMGrKwGbELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4Gvo3mjkXQk43TU9cmNU4WrvEDwVWZ/37M5tzfHoMo=;
 b=nKVuwXiVlHq8x4xTdqJWWPUAKZNDw2kFqpqMHlMjNkfpUovnoDMHy2cqH+FGFbd6Vh+hJn1Kp0mYePkku7doqrtqARblxlSzI5e74stLrjiORwleNHfyW8JGpG5tjLFlyoLS9in171PIkgd151pd5HK+s2e0FALOw8s/HPNuzmNJGyVG4njXbmyGzP+DuCWdl042WGMPHD7WkVhM7GlfMQB5JyoHGyIk0mSOniBvQbxmynguJQWgoyV/B7z0+MahBPinEE7aSenA7U416YLgVSqAaOMz581ls1cCtbhesJdX/ZFjJaooiL78IvlfNGBrVBiOZN0uyR0msbtPCA0P6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 64.60.54.162) smtp.rcpttodomain=impinj.com smtp.mailfrom=canoga.com;
 dmarc=none action=none header.from=canoga.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canogaperkins.onmicrosoft.com; s=selector1-canogaperkins-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4Gvo3mjkXQk43TU9cmNU4WrvEDwVWZ/37M5tzfHoMo=;
 b=WTXGo91Yni2+xtDLF3OIPw6y1oPUGrgvz6gtSjiAeSNDTEFsQY67YqDNPmUgUPsa9H4sF1jzkYsY+JYdyrNdrXWnA7aFRGy/lcpN4YC+MzvD8KHGlukH1gV8CZfTa4T01xIR9+nD186LlXe+CD+l/+NV6IxI4sFZVrk9zIOjZD4=
Received: from MWHPR22CA0061.namprd22.prod.outlook.com (2603:10b6:300:12a::23)
 by BN6PR04MB0723.namprd04.prod.outlook.com (2603:10b6:404:d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 9 Mar
 2021 16:24:33 +0000
Received: from MW2NAM04FT025.eop-NAM04.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::6e) by MWHPR22CA0061.outlook.office365.com
 (2603:10b6:300:12a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 16:24:32 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 64.60.54.162)
 smtp.mailfrom=canoga.com; impinj.com; dkim=none (message not signed)
 header.d=none;impinj.com; dmarc=none action=none header.from=canoga.com;
Received-SPF: Fail (protection.outlook.com: domain of canoga.com does not
 designate 64.60.54.162 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.60.54.162; helo=EXCH-01.canoga.com;
Received: from EXCH-01.canoga.com (64.60.54.162) by
 MW2NAM04FT025.mail.protection.outlook.com (10.13.31.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3912.25 via Frontend Transport; Tue, 9 Mar 2021 16:24:32 +0000
Received: from EXCH-01.canoga.com (172.16.1.71) by EXCH-01.canoga.com
 (172.16.1.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 9 Mar 2021
 08:24:31 -0800
Received: from EXCH-01.canoga.com ([fe80::c192:5930:394b:bb4a]) by
 EXCH-01.canoga.com ([fe80::c192:5930:394b:bb4a%11]) with mapi id
 15.01.2176.002; Tue, 9 Mar 2021 08:24:31 -0800
From:   "Wyse, Chris" <cwyse@canoga.com>
To:     "drichards@impinj.com" <drichards@impinj.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA
Thread-Topic: DSA
Thread-Index: AQHXFOsWsphWsVyLO0WnfdN7crkaW6p8XaIA
Date:   Tue, 9 Mar 2021 16:24:31 +0000
Message-ID: <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
References: <MWHPR06MB3503CE521D6993C7786A3E93DC8D0@MWHPR06MB3503.namprd06.prod.outlook.com>
         <20180430125030.GB10066@lunn.ch>
In-Reply-To: <20180430125030.GB10066@lunn.ch>
Reply-To: "Wyse, Chris" <cwyse@canoga.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.28.10.1]
x-esetresult: clean, is OK
x-esetid: 37303A295703745862776A
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AFC7FB92420464497114E73093835DD@canoga.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 487c9e8a-1261-427e-8de6-08d8e317d262
X-MS-TrafficTypeDiagnostic: BN6PR04MB0723:
X-Microsoft-Antispam-PRVS: <BN6PR04MB072373017876FB4E806CD762CB929@BN6PR04MB0723.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YVV0/5oj6A129Z6JMi/Khn4rFTCqdoz0pzWKHLODtt7h0f6sY4iWbsFHPUPgRz1OyPqXnCoc9EVy74f9lhI6Q1u73m7v1UUubKi3afagfq6uf/cp+qKv1xmdRAyXrNhwIkqSKb70sZtCip4GhpTLF1DQOL7drtMGThfamXVmbD1CWE8D/ZMhj8V/adh1Sx0XTil5MPJH0AEq/1jOX+h7dcqCj537d87Af94uzpwoqNF8C3bd/eoWH1Z+dY1ICDFXPRICwygeijAYuRaBdhlEsW8rDpYcA9m2wjz0BpzP0rNFkKTJ8eyoWhhzv/UEeBcMmWqrJ30I1xJH9jXUtfow+BqNe4iGZheodhDEbbwC9OkHBoGTw58EYi4QjgM1wSVuxRVrA6TVVUwp/X79QWEJ6J0ompqlOfVEmily/IJQA+fZAUIC0/EsUogdc+8+7f/32Z4QzS6/iXJQ8BlLaPSZZIbNGyU7H4O+2oisc7uFpxPIM+g4SpEDSNx6Iu/PahWKpYMKU89m3VmL24x2zFvDOes6BXfxZDTelod72cXtYPuoWFDltFKzRSL/WCj1TSTINozLcFyPTB9dCA9wDbM0V8pL4Gtc0822Tv6HxZeElkV9pGmV63kBpS0szpMI7sZmPhxs09O5pvuUzDsHeG6+ruPyKFv01yk6y3mFgSh5MI0=
X-Forefront-Antispam-Report: CIP:64.60.54.162;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:EXCH-01.canoga.com;PTR:64-60-54-162.static-ip.telepacific.net;CAT:NONE;SFS:(39830400003)(136003)(346002)(376002)(396003)(46966006)(36840700001)(186003)(5660300002)(7116003)(47076005)(478600001)(3450700001)(8936002)(26005)(70586007)(70206006)(83380400001)(2906002)(36756003)(36860700001)(4326008)(36906005)(110136005)(82310400003)(3480700007)(2616005)(86362001)(426003)(8676002)(336012)(81166007)(356005)(316002)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: canoga.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 16:24:32.5622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 487c9e8a-1261-427e-8de6-08d8e317d262
X-MS-Exchange-CrossTenant-Id: 6638fc67-e5b4-4bf1-8d4b-c62f4d909614
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=6638fc67-e5b4-4bf1-8d4b-c62f4d909614;Ip=[64.60.54.162];Helo=[EXCH-01.canoga.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM04FT025.eop-NAM04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0723
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQotLQ0KDQpDaHJpcyBXeXNlDQoNCkVtYmVkZGVkIFNvZnR3YXJlIERldmVsb3BtZW50DQooMjAz
KSA4ODgtNzkxNCBleHQgMjAzDQoNCkNhbm9nYSBQZXJraW5zDQoxMDAgQmFuayBTdCwNClNleW1v
dXIsIENUIDA2NDgzDQoNCk9uIE1vbiwgMjAxOC0wNC0zMCBhdCAxNDo1MCArMDIwMCwgQW5kcmV3
IEx1bm4gd3JvdGU6DQo+IE9uIEZyaSwgQXByIDI3LCAyMDE4IGF0IDA2OjEwOjU1UE0gKzAwMDAs
IERhdmUgUmljaGFyZHMgd3JvdGU6DQo+DQo+IEhlbGxvLA0KPg0KPiBJIGFtIGJ1aWxkaW5nIGEg
cHJvdG90eXBlIGZvciBhIG5ldyBwcm9kdWN0IGJhc2VkIG9uIGEgTGFubmVyLCBJbmMuDQo+IGVt
YmVkZGVkIFBDLiAgSXQgaXMgYW4gSW50ZWwgQ2VsZXJvbi1iYXNlZCBzeXN0ZW0gd2l0aCB0d28g
aG9zdCBJMjEwDQo+IEdiRSBjaGlwcyBjb25uZWN0ZWQgdG8gMiBNVjg4RTYxNzIgY2hpcHMgKG9u
ZSBOSUMgdG8gb25lDQo+IHN3aXRjaCkuICBFdmVyeXRoaW5nIGFwcGVhcnMgdG8gc2hvdyB1cCBo
YXJkd2FyZS13aXNlLiAgTXkgcXVlc3Rpb24NCj4gaXMsIHdoYXQgaXMgdGhlIG5leHQgc3RlcD8g
IEhvdyBkb2VzIERTQSBrbm93IHdoaWNoIE5JQ3MgYXJlIGludGVuZGVkDQo+IHRvIGJlIG1hc3Rl
cnM/ICBJcyB0aGlzIHN1cHBvc2VkIHRvIGJlIGF1dG8tZGV0ZWN0ZWQgb3IgaXMgdGhpcw0KPiBr
bm93bGVkZ2Ugc3VwcG9zZWQgdG8gYmUgY29tbXVuaWNhdGVkIGV4cGxpY2l0bHkuICBSZWFkaW5n
IHRocm91Z2gNCj4gdGhlIERTQSBkcml2ZXIgY29kZSBJIHNlZSB0aGF0IHRoZXJlIGlzIGEgY2hl
Y2sgb2YgdGhlIE9GIHByb3BlcnR5DQo+IGxpc3QgZm9yIHRoZSBkZXZpY2UgZm9yIGEgImxhYmVs
Ii8iY3B1IiBwcm9wZXJ0eS92YWx1ZSBwYWlyIHRoYXQNCj4gbmVlZHMgdG8gYmUgcHJlc2VudC4g
IFdobyBzZXRzIHRoaXMgYW5kIHdoZW4/DQo+DQo+IEhpIERhdmUNCj4NCj4gU2luY2UgeW91IGFy
ZSBvbiBJbnRlbCwgeW91IGRvbid0IGhhdmUgc2ltcGxlIGFjY2VzcyB0byBEZXZpY2UNCj4gdHJl
ZS4gU28geW91IG5lZWQgdG8gdXNlIHBsYXRmb3JtIGRhdGEgaW5zdGVhZC4gT3IgcG9zc2libHkg
c3RhcnQNCj4gaGFja2luZyBvbiBBQ1BJIHN1cHBvcnQgZm9yIERTQS4gRm9yIHRoZSBtb21lbnQs
IGkgd291bGQgc3VnZ2VzdA0KPiBwbGF0Zm9ybSBkYXRhLg0KPg0KPiBJJ20gYWxzbyB3b3JraW5n
IG9uIGEgc2ltaWxhciBzZXR1cCwgaW50ZWwgQ1BVIGNvbm5lY3RlZCB0byBhbg0KPiBNVjg4RTY1
MzIuIEkgaGF2ZSBzb21lIHdvcmsgaW4gcHJvZ3Jlc3MgY29kZSBpIGNhbiBzaGFyZSB3aXRoIHlv
dSwNCj4gd2hpY2ggaSB3YW50IHRvIHN1Ym1pdCBmb3IgaW5jbHVzaW9uIHRvIG1haW5saW5lIGlu
IHRoZSBuZXh0IGZldw0KPiB3ZWVrcy4gIFRoaXMgYWRkcyBwbGF0Zm9ybSBkYXRhIHN1cHBvcnQg
dG8gdGhlIG12ODhlNnh4eCBkcml2ZXIsIGFuZA0KPiB3aWxsIGdpdmUgeW91IGFuIGlkZWEgaG93
IHlvdSBsaW5rIHRoZSBNQUMgdG8gdGhlIHN3aXRjaC4NCj4NCj4gV2hhdCBNRElPIGJ1cyBkbyB5
b3UgY29ubmVjdCB0aGUgc3dpdGNoZXMgdG8/IFRoZSBpMjEwIE1ESU8gYnVzPyBJZg0KPiBzbywg
dGhpcyBpcyBnb2luZyB0byBjYXVzZSB5b3UgYSBwcm9ibGVtLiBUaGUgaWdiIGRyaXZlciBpZ25v
cmVzIHRoZQ0KPiBMaW51eCBNRElPIGFuZCBQSFkgY29kZSwgYW5kIGRvZXMgaXQgYWxsIGl0c2Vs
Zi4gRFNBIGFzc3VtZXMgdGhlDQo+IHN3aXRjaCBjYW4gYmUgYWNjZXNzZWQgdXNpbmcgTGludXgg
c3RhbmRhcmQgTURJTyBpbnRlcmZhY2VzLiBTbyB5b3UNCj4gaGF2ZSBnb2luZyB0byBoYXZlIHRv
IGhhY2sgb24gdGhlIGlnYiBkcml2ZXIgdG8gbWFrZSBpdCB1c2Ugc3RhbmRhcmQNCj4gTURJTy4N
Cj4NCj4gQW5kcmV3DQo+DQoNCkkgaGF2ZSBhIGJvYXJkIHRoYXQgdXNlcyB0aGUgSW50ZWwgaTIx
MCwgYW5kIEknZCBsaWtlIGl0IGJlIHRoZSBEU0ENCm1hc3Rlci4gIEknbSBsb29raW5nIGZvciBz
dWdnZXN0aW9ucyBvbiBob3cgdG8gcHJvY2VlZC4NCg0KTXkgY29uZmlndXJhdGlvbiBpcyBhbiBJ
bnRlbCBFMzk1MCBDUFUgcnVubmluZyBMaW51eCA0LjE5LjYyLCB1c2luZw0KVUVGSS9BQ1BJLiAg
VGhlIGJvYXJkIGhhcyBhIFhpbGlueCBGUEdBIHRoYXQgc3VwcG9ydHMgU0ZQICYgUVNGUA0KZGV2
aWNlcy4gIFRoZSBTRlAgcG9ydHMgdXNlIHRoZSBzdGFuZGFyZCBTRlAgZHJpdmVyICYgcGh5bGlu
ay4gIFRoZQ0KUVNGUCBwb3J0cyB1c2UgYSBtb2RpZmllZCB2ZXJzaW9uIG9mIHRoZSBTRlAgZHJp
dmVyLiAgSXQgYWxzbyBpbmNsdWRlcw0KYW4gaW50ZXJmYWNlIHRvIGFuIEludGVsIGkyMTAgZXRo
ZXJuZXQuDQoNCldlIHVzZSBkZXZpY2UgdHJlZSBvdmVybGF5cyB0byBsb2FkIHRoZSBpbmZvcm1h
dGlvbiBmb3IgdGhlIGRldmljZXMNCnN1cHBvcnRlZCBieSB0aGUgRlBHQSwgdGhlbiBsb2FkIGFu
IE1GRCBGUEdBIGRyaXZlciB0aGF0IGluc3RhbnRpYXRlcw0KcGxhdGZvcm0gZHJpdmVycyBmb3Ig
ZWFjaCBvZiB0aG9zZSBkZXZpY2VzLiAgT25lIG9mIHRoZSBkcml2ZXJzIHRoYXQNCmdldHMgbG9h
ZGVkIGlzIGEgRFNBIGRyaXZlciB0aGF0IGhhcyB0aGUgU0ZQICYgUVNGUCBkZXZpY2VzIGFzIGl0
cw0Kc2xhdmVzLiAgVGhlIGludGVudCBpcyB0byB1c2UgdGhlIEludGVsIGkyMTAgb24gdGhlIG1h
c3RlciBwb3J0IG9mIHRoZQ0KRFNBIGRyaXZlci4NCg0KQXQgZmlyc3QgZ2xhbmNlLCBJIGJlbGll
dmUgSSBuZWVkIHRvIGNvbXBsZXRlIHRoZXNlIHRhc2tzOg0KICAxLiAgQ3JlYXRlIGEgZGV2aWNl
IHRyZWUgbm9kZSBmb3IgdGhlIGkyMTAsIHByb3ZpZGluZyBpbmZvcm1hdGlvbiBvbg0KdGhlIGFs
cmVhZHkgbG9hZGVkIGRyaXZlciwgdGhhdCBjYW4gYmUgdXNlZCBieSB0aGUgRFNBIGRyaXZlci4N
CiAgMi4gIE9idGFpbiBvciB1cGRhdGUgYSBpMjEwIGRyaXZlciB0aGF0IHdpbGwgd29yayB3aXRo
IERTQQ0KDQpJJ20gb3BlbiB0byBhbnkgc3VnZ2VzdGlvbnMgb24gaG93IHRvIHByb2NlZWQuICBX
ZSdyZSByZWxhdGl2ZWx5IHRpbWUNCmxpbWl0ZWQgLSBzbyBJJ20gaG9waW5nIHRvIGZpbmQgYSBx
dWljayBzb2x1dGlvbiwgZXZlbiBpZiB3ZSBvbmx5IHVzZQ0KaXQgZm9yIHRoZSBzaG9ydC10ZXJt
Lg0KDQpSZWdhcmRpbmcgdGhlIGkyMTAgZHJpdmVyLCBJIGxvb2tlZCB0aHJvdWdoIHRoZSBsYXRl
c3QgdmVyc2lvbiBvZiB0aGUNCmRyaXZlci4gIEkgZGlkbid0IHNlZSBhbnkgY29tbWl0cyBmcm9t
IHlvdSBmb3IgdGhlIGlnYiBkcml2ZXINCmNoYW5nZXMuICBEaWQgdGhleSBldmVyIGdldCBtYWlu
bGluZWQ/ICBJZiBub3QsIHdvdWxkIHlvdSBwbGVhc2UgZ2l2ZQ0KbWUgYWNjZXNzIHRvIHlvdXIg
bW9kaWZpZWQgdmVyc2lvbiBvZiB0aGUgZHJpdmVyIHNvdXJjZT8NCg0KVGhhbmtzLg0KDQpDaHJp
cyBXeXNlDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQoNCkNhbm9nYSBQZXJr
aW5zDQoyMDYwMCBQcmFpcmllIFN0cmVldA0KQ2hhdHN3b3J0aCwgQ0EgOTEzMTENCig4MTgpIDcx
OC02MzAwDQoNClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNoZWQgZG9jdW1lbnQocykgaXMgY29u
ZmlkZW50aWFsIGFuZCBpcyBpbnRlbmRlZCBvbmx5IGZvciB0aGUgcmV2aWV3IG9mIHRoZSBwYXJ0
eSB0byB3aG9tIGl0IGlzIGFkZHJlc3NlZC4gSWYgeW91IGhhdmUgcmVjZWl2ZWQgdGhpcyB0cmFu
c21pc3Npb24gaW4gZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBh
bmQgZGlzY2FyZCB0aGUgb3JpZ2luYWwgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnQocykuDQo=
