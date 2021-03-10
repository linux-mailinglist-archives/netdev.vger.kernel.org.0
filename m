Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BA33341AB
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhCJPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:37:35 -0500
Received: from mail-eopbgr700083.outbound.protection.outlook.com ([40.107.70.83]:53729
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232931AbhCJPhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:37:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIiL2/TZMkd9efdYQZZUGLEKEA8XAUbrYD1rojsFiX2ktZS8VOTvbbNf9qF6u/8dOGIQVljY47CjiNJW+jTwQASqtlHaLPPIHhKGEdJ/cLyvHOExnFgjWW6L+4W+BLApdOF/AczzoPByOh3i8/MzrIySisKpTQeGqOrVkiiDXMh+lRc2Y3R+PlKDJ8BhKS3oKP8Yp7NQ1PH0Ox9qQ/pfKnSRqsGUDNcKBwP3wvAGPIBNDDrA9QW/BY830nOnXwZYB8tVerw+Poox3jAaoBCKyBLS3w9GmtYL4jRH/TaBfp3X+8WwOAcXZsyFJzSy7AUXEQKpkbE8ia09qOHN2C8fUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd1zcL572Hob1BaVYOfAeLRICLLEXhzZb0LtGkAbXM8=;
 b=irOqMH4kHeVtbIpozXX/Ceuh7fx64b7J27/sOl6uXCE/fTYKtugnCxBEUY2gNKwvhmwC0EoiYeiqDe+eIka4jTg+cXJgCsDYhRpFfN4nfUMlT0/atgUzdQmYKxSdXWthZKXHztotjiRShwGneFqc9v5eTwy85RAQ227feUuje7v70FDombVuxFLvVbIRicuU/6RtGznGPMdWonz8PsarPLwWxSYfyH98CLiEFkjCQzNwAXGjBTwydirQU6WZeREnSyn1Pdpw5YnT4xjURu0XuLiGkPPd5r1amimFJnyuwWfuFgbskvVhwD3YhkD50mjpn/aiweki9blJJrGZRSXx9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 64.60.54.162) smtp.rcpttodomain=lunn.ch smtp.mailfrom=canoga.com; dmarc=none
 action=none header.from=canoga.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canogaperkins.onmicrosoft.com; s=selector1-canogaperkins-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd1zcL572Hob1BaVYOfAeLRICLLEXhzZb0LtGkAbXM8=;
 b=FQobcn4hcJodrd19AioxpKZLJHfq/vGXNNne67Tsmbgb3SADb0i99PPCODOcbW8RLsJjKGKvzwDTsMK+kQwWFgvPr6nFCWCiXRvu9zlN8Jf689h0VxKY8taFl/H4rAgON46d4qg4EiCWRXYaiaJptJXIlL2qxY5cYuqV4P+gvAk=
Received: from BN9PR03CA0507.namprd03.prod.outlook.com (2603:10b6:408:130::32)
 by DM6PR04MB4667.namprd04.prod.outlook.com (2603:10b6:5:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 15:37:28 +0000
Received: from BN3NAM04FT062.eop-NAM04.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::f2) by BN9PR03CA0507.outlook.office365.com
 (2603:10b6:408:130::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:37:28 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 64.60.54.162)
 smtp.mailfrom=canoga.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=canoga.com;
Received-SPF: Fail (protection.outlook.com: domain of canoga.com does not
 designate 64.60.54.162 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.60.54.162; helo=EXCH-01.canoga.com;
Received: from EXCH-01.canoga.com (64.60.54.162) by
 BN3NAM04FT062.mail.protection.outlook.com (10.152.92.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3912.25 via Frontend Transport; Wed, 10 Mar 2021 15:37:28 +0000
Received: from EXCH-01.canoga.com (172.16.1.93) by EXCH-01.canoga.com
 (172.16.1.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 10 Mar
 2021 07:37:27 -0800
Received: from EXCH-01.canoga.com ([fe80::c192:5930:394b:bb4a]) by
 EXCH-01.canoga.com ([fe80::c192:5930:394b:bb4a%11]) with mapi id
 15.01.2176.002; Wed, 10 Mar 2021 07:37:26 -0800
From:   "Wyse, Chris" <cwyse@canoga.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "drichards@impinj.com" <drichards@impinj.com>
Subject: Re: DSA
Thread-Topic: DSA
Thread-Index: AQHXFOsWsphWsVyLO0WnfdN7crkaW6p8XaIAgAAGIICAAFZYgIAAEEQAgABzbICAAIUBgIAAIASA
Date:   Wed, 10 Mar 2021 15:37:26 +0000
Message-ID: <497bb0d287474ba1dbaded0c5068569203a8691a.camel@canoga.com>
References: <MWHPR06MB3503CE521D6993C7786A3E93DC8D0@MWHPR06MB3503.namprd06.prod.outlook.com>
         <20180430125030.GB10066@lunn.ch>
         <bf9115d87b65766dab2d5671eceb1764d0d8dc0c.camel@canoga.com>
         <YEemYTQ9EhQQ9jyH@lunn.ch>
         <20fd4a9ce09117e765dbf63f1baa9da5c834a64b.camel@canoga.com>
         <YEf8dFUCB+/vMkU8@lunn.ch>
         <9d866ab9d2f324f34804b3c74e350138d5413706.camel@canoga.com>
         <YEjM2T8rI05F/Fbr@lunn.ch>
In-Reply-To: <YEjM2T8rI05F/Fbr@lunn.ch>
Reply-To: "Wyse, Chris" <cwyse@canoga.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.28.10.1]
x-esetresult: clean, is OK
x-esetid: 37303A2957037458627162
Content-Type: text/plain; charset="utf-8"
Content-ID: <00D7FA6783F5B341B830EF2BB54B2947@canoga.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3361dfd8-e8a4-497d-14fc-08d8e3da6963
X-MS-TrafficTypeDiagnostic: DM6PR04MB4667:
X-Microsoft-Antispam-PRVS: <DM6PR04MB466776E86BC4A999D5AF253BCB919@DM6PR04MB4667.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUD1gguh2acIPnQyyXHxjhixFq46NdP8bBcHUZ8qNofrUR4pCOqF5pOT0TVo6B3Z4Kwm/Dz1Kcekc2iqc1m3uBmd0uqTRSHJfbPA+elWR51YA+qncpBSqSnUhfgCI+YCeDfN+FtHO4w0dtEn/Vi60aSoerg0xLx1fLE5tMMO7t4/rEac/QL36JPHKA5PJWTkKcwnYcobfn2JBB7wkj3RnubitHYGMudNuQhLB+VkwH/Uh18xkC80SovmT0BcE9IAAiD+RtaVac0EMaJ76K42U7s1LLUMWQ1seZlY6xzR9XQSWwjSb/qb1T9nnC3V91G3uYU89gepqQ4u8otFFx8EuWVdAbkItgKiYpfykcL6BYnc5FbpmCpfqJcagBo5WllfLwTgpwLmcZKVyn2Wx1qMgas3B2hoteneatwquOFSLiigYLWW1APP5T7NMVA42zvJTmYe1jsIQZ8Emybsh9o1Gx4vWLGI8sdNvy++mOiM/+PbbwD4U00HjrNVXsZNKXtzaUxoz2/CvHBb1aeMPMb3GwMjd6cI6ZaFdEqUEuz9BOg5u8mLxLS4tt8sxcEMdk0cNpyX2E2cbnSu4bX9sAnEvi3FPgz+7D59T9eObLj+ci2Ox1TuDuImaND1hNTqk/iSW4A5EiC9UfMR/w/03s3nBQ==
X-Forefront-Antispam-Report: CIP:64.60.54.162;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:EXCH-01.canoga.com;PTR:64-60-54-162.static-ip.telepacific.net;CAT:NONE;SFS:(376002)(136003)(39830400003)(396003)(346002)(36840700001)(46966006)(7116003)(4326008)(7696005)(6916009)(86362001)(82310400003)(478600001)(356005)(54906003)(8676002)(36756003)(36906005)(26005)(36860700001)(336012)(47076005)(3450700001)(316002)(8936002)(2906002)(186003)(83380400001)(426003)(2616005)(70206006)(70586007)(5660300002)(81166007)(3480700007);DIR:OUT;SFP:1101;
X-OriginatorOrg: canoga.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:37:28.2232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3361dfd8-e8a4-497d-14fc-08d8e3da6963
X-MS-Exchange-CrossTenant-Id: 6638fc67-e5b4-4bf1-8d4b-c62f4d909614
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=6638fc67-e5b4-4bf1-8d4b-c62f4d909614;Ip=[64.60.54.162];Helo=[EXCH-01.canoga.com]
X-MS-Exchange-CrossTenant-AuthSource: BN3NAM04FT062.eop-NAM04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4667
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IFRoZSBjdXJyZW50IGJvb3Qgc2VxdWVuY2UgaXMgYmVsb3c6DQo+ID4gMS4gaTIxMCBkcml2
ZXIgbG9hZHMNCj4gPiAyLiBEZXZpY2UgVHJlZSBvdmVybGF5IGluc3RhbGxlZCAoaW4gYWRkaXRp
b24gdG8gQUNQSSkNCj4gPiAgICAtIEluY2x1ZGVzIERTQSBzd2l0Y2ggYW5kIHBvcnRzLCBidXQg
bWFzdGVyIHBvcnQgd2FzIGluY29ycmVjdGx5DQo+ID4gc3BlY2lmaWVkIGFzIHRoZSBFTUFDTGl0
ZSBJUCBtb2R1bGUsIHdoaWNoIGhhZCBhIERUIG5vZGUNCj4gPiAgICAtIE5vIERUIG5vZGUgZm9y
IHRoZSBpMjEwDQo+ID4gMy4gTUZEIGRyaXZlciByZWFkcyBEVCBvdmVybGF5IGFuZCBpbnN0YW50
aWF0ZXMgc3VwcG9ydGluZyBkZXZpY2VzDQphbmQNCj4gPiB0aGUgRFNBIGRyaXZlcg0KPiA+DQo+
ID4gTXkgdGhvdWdodCB3YXMgdG8gY3JlYXRlIGEgRFQgZW50cnkgZm9yIHRoZSBpMjEwIGluIHRo
ZSBvdmVybGF5LA0KZXZlbg0KPiA+IHRob3VnaCB0aGUgZHJpdmVyIGlzIGFscmVhZHkgbG9hZGVk
IHZpYSBBQ1BJLiAgVGhlIERUIG92ZXJsYXkgbm9kZQ0KZm9yDQo+ID4gdGhlIGkyMTAgd291bGQg
cHJvdmlkZSBhbnkgbmVlZGVkIGluZm9ybWF0aW9uIHRvIHRoZSBEU0ENCmRyaXZlci4gIEl0DQo+
ID4gd291bGQgYmUgZXNzZW50aWFsbHkgYSByZWZlcmVuY2UgdG8gdGhlIGFscmVhZHkgbG9hZGVk
IGRyaXZlci4NCj4NCj4gSSBkb24ndCB0aGluayB3aGF0IHdvcmtzLiBUaGUgbm9ybWFsIHNlcXVl
bmNlIGlzIHRoYXQgdGhlIFBDSSBidXMgaXMNCj4gcHJvYmVkIGFuZCBkZXZpY2VzIGZvdW5kLiBB
dCB0aGF0IHBvaW50IGluIHRpbWUsIHRoZSBQQ0kgY29yZSBsb29rcw0KaW4NCj4gRFQgYW5kIGZp
bmRzIHRoZSBEVCBub2RlIGFzc29jaWF0ZWQgd2l0aCB0aGUgZGV2aWNlLCBhbmQgYXNzaWducw0K
PiBkZXYtPm9mX25vZGUgdG8gcG9pbnQgdG8gdGhlIERUIG5vZGUuIFRoZSBkZXZpY2UgaXMgdGhl
biByZWdpc3RlcmVkDQo+IHdpdGggdGhlIGRldmljZSBjb3JlLiBJdCB3aWxsIGdvIG9mZiBhbmQg
dHJ5IHRvIGZpbmQgYSBkcml2ZXIgb2YgdGhlDQo+IGRldmljZSwgcHJvYmUgaXQsIGV0Yy4NCj4N
Cj4gU29tZXRpbWUgbGF0ZXIsIHRoZSBEU0EgZHJpdmVyIHdpbGwgcHJvYmUuIFRoZSBwaGFuZGxl
IGluIGRldmljZSB0cmVlDQo+IGlzIHR1cm5lZCBpbnRvIGEgcG9pbnRlci4gQW5kIHRoZW4gYWxs
IGRldmljZXMgcmVnaXN0ZXJlZCBmb3IgdGhlDQo+IG5ldGRldiBjbGFzcyBhcmUgd2Fsa2VkIHRv
IHNlZSBpZiBhbnkgaGF2ZSBkZXYtPm9mX25vZGUgc2V0IHRvIHRoZQ0KPiBub2RlLg0KPg0KPiBT
byBmb3IgdGhpcyBzZXF1ZW5jZSB0byB3b3JrLCB0aGUgb3ZlcmxvYWQgbmVlZHMgdG8gYmUgbG9h
ZGVkIGF0IHRoZQ0KPiBwb2ludCB0aGUgUENJIGJ1cyBpcyBzY2FubmVkIGZvciBkZXZpY2VzLiBO
b3csIHRoZXJlIGNvdWxkIGJlIHNvbWUNCj4gbWFnaWMgZ29pbmcgb24gd2hlbiBhbiBvdmVybGF5
IGlzIGxvYWRlZCwgc2Nhbm5pbmcgdGhlIERUIGZvciBkZXZpY2VzDQo+IHdoaWNoIGhhdmUgYWxy
ZWFkeSBsb2FkZWQsIGFuZCBhc3NpZ25pbmcgdGhlcmUgZGV2LT5vZl9ub2RlPyBJJ3ZlIG5vDQo+
IGlkZWEsIGkndmUgbm90IHVzZWQgb3ZlcmxheXMuIFlvdSBwcm9iYWJseSB3YW50IHRvIGFkZCBz
b21lIHByaW50aygpDQo+IGludG8gcGNpX3NldF9vZl9ub2RlKCkuDQo+DQo+IFRoZSBpZGVhIHdp
dGggaG90cGx1ZyBpcyB0aGF0IGkgZ3Vlc3MgaXQgc2hvdWxkIHJlc2NhbiB0aGUgUENJIGJ1cy4N
ClNvDQo+IHRoYXQgc2hvdWxkIGNhdXNlIHBjaV9zZXRfb2Zfbm9kZSgpIHRvIGJlIGNhbGxlZCwg
YW5kIG5vdyB0aGVyZSBpcyBhDQo+IERUIG5vZGUgZm9yIHRoZSBkZXZpY2UuDQo+DQo+IFNvIGkg
c3VnZ2VzdCB5b3Ugc2NhdHRlciBzb21lIHByaW50aygpIGluIHRoZSBQQ0kgY29kZSwgYW5kDQo+
IG9mX2ZpbmRfbmV0X2RldmljZV9ieV9ub2RlKCkgYW5kIHRoZSBmdW5jdGlvbnMgaXQgY2FsbHMg
dG8gc2VlIHdoYXQNCmlzDQo+IHJlYWxseSBnb2luZyBvbiwgZG8gaSBoYXZlIHRoZSBzZXF1ZW5j
aW5nIGNvcnJlY3QuDQo+DQpHcmVhdCBpbmZvcm1hdGlvbiBhbmQgaWRlYXMuICBUaGFuayB5b3Uu
DQoNCkN1cnJlbnRseSwgdGhlIFBDSSBidXMgaXMgcHJvYmVkIGF0IGJvb3QsIGFuZCB0aGUgRlBH
QSB0aGUgaTIxMCBhcmUNCmRldGVjdGVkLiAgVGhlIGkyMTAgZHJpdmVyIGdldHMgbG9hZGVkIGF0
IGJvb3QsIHRoZSBEVCBvdmVybGF5cyBhcmUNCmFwcGxpZWQsIGFuZCB0aGVuIHdlIGxvYWQgdGhl
IE1GRCBkcml2ZXIgZm9yIHRoZSBGUEdBLiAgVGhlIE1GRCBkcml2ZXINCmxvYWRzIGFsbCBzdXBw
b3J0aW5nIGRyaXZlcnMsIHRoZW4gbG9hZHMgdGhlIERTQSBkcml2ZXIuDQoNCkknbSB3b25kZXJp
bmcgaWYgSSBjb3VsZCBidWlsZCB0aGUgaWdiIGRyaXZlciBhcyBhIG1vZHVsZSAobm90IHF1aXRl
DQp0aGUgc2FtZSBhcyBob3RwbHVnLCBidXQgc2VlbXMgbGlrZSBpdCB3b3VsZCB3b3JrKSwgdGhl
biBsb2FkIGl0IGFmdGVyDQp0aGUgRFQgb3ZlcmxheSBoYXMgYmVlbiBhZGRlZC4gIFRoZSBQQ0kg
Y29yZSB3b3VsZCBuZWVkIHRvIGxvb2sgZm9yIGENCmRldmljZSB0cmVlIG5vZGUgcHJpb3IgdG8g
YW4gQUNQSSBub2RlIChvciBJJ2QgbmVlZCB0byBtb2RpZnkgaXQgdG8NCndvcmsgdGhhdCB3YXkp
LiAgT3RoZXJ3aXNlLCBJIGJlbGlldmUgdGhhdCB0aGUgRFQgY29kZSB3b3VsZCBiZQ0Kc2tpcHBl
ZC4NCg0KSSBfdGhpbmtfIHRoYXQgSSBjb3VsZCB1c2Ugc29tZXRoaW5nIHNpbWlsYXIgdG8geW91
ciBob3N0QDAgbm9kZSBmb3INCnRoZSBpMjEwIERUIGRlZmluaXRpb24gYW5kIGFkZHJlc3Npbmcu
ICBJIHdvdWxkbid0IG5lZWQgYSBub2RlIGZvciB0aGUNClBDSWUgYXMgbG9uZyBhcyBJIHByb3Zp
ZGVkIHRoZSBjb3JyZWN0IGFkZHJlc3NpbmcgZm9yIHRoZSBpMjEwIG5vZGUuDQoNCi0tLS0gQW5v
dGhlciB0aG91Z2h0IC0tLQ0KDQpUaGUgbG9hZGluZyBvZiB0aGUgZGV2aWNlIHRyZWUgb3Zlcmxh
eXMgd2FzIGJhc2VkIG9uIHRoZSBkZXZpY2UgdHJlZQ0KdW5pdCB0ZXN0IGNvZGUuICBGcm9tIHRo
YXQsIEkgY3JlYXRlZCBhIHNpbXBsZSBkZXZpY2UgZHJpdmVyIHRoYXQgdGFrZXMNCmEgZHRibyBm
aWxlIGFuZCBsb2FkcyBpdC4gIEluc3RlYWQgb2YgY3JlYXRpbmcgaXQgYXMgYSBtb2R1bGUsIEkg
Y291bGQNCmluc3RhbnRpYXRlIGl0IHByaW9yIHRvIHRoZSB0aGUgUENJIGRyaXZlci4gIElmIHRo
ZSBQQ0kgY29kZSBmYXZvcnMgdGhlDQpEVCBvdmVyIHRoZSBBQ1BJLCB0aGUgbWF5YmUgaXQgd291
bGQgbG9hZCB0aGUgZHJpdmVyIGZvciBtZSB2aWEgRFQNCndpdGhvdXQgYW55IG90aGVyIGNoYW5n
ZXMuDQoNCi0tLS0NCg0KTG9va2luZyBpbnRvIHRoZSBjb2RlIG5vdyB0byBzZWUgaG93IHRoZXNl
IG9wdGlvbnMgd291bGQgcGxheSBvdXQsIHdpdGgNCmVtcGhhc2lzIG9uIHRoZSBhcmVhcyB5b3Ug
bWVudGlvbmVkLiAgUGxlYXNlIGxldCBtZSBrbm93IGlmIEkndmUNCm1pc2ludGVycHJldGVkIGFu
eSBvZiB5b3VyIGNvbW1lbnRzIG9yIGlmIGl0J3MgYXBwYXJlbnQgdGhhdCBJJ3ZlDQptaXNzZWQg
YSBjcml0aWNhbCBwaWVjZS4gIEknbSBub3QgYW4gZXhwZXJ0IGluIGFueSBvZiB0aGVzZSBhcmVh
LCBhbmQNCnN0cnVnZ2xpbmcgYSBiaXQgdG8gcHJvdmlkZSBjb2hlcmVudCBhbmQgcmVhc29uYWJs
ZSByZXNwb25zZXMsIHNvIHlvdXINCmZlZWRiYWNrIGlzIHdlbGNvbWUuDQoNCkNocmlzDQoNCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQoNCkNhbm9nYSBQZXJraW5zDQoyMDYwMCBQ
cmFpcmllIFN0cmVldA0KQ2hhdHN3b3J0aCwgQ0EgOTEzMTENCig4MTgpIDcxOC02MzAwDQoNClRo
aXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNoZWQgZG9jdW1lbnQocykgaXMgY29uZmlkZW50aWFsIGFu
ZCBpcyBpbnRlbmRlZCBvbmx5IGZvciB0aGUgcmV2aWV3IG9mIHRoZSBwYXJ0eSB0byB3aG9tIGl0
IGlzIGFkZHJlc3NlZC4gSWYgeW91IGhhdmUgcmVjZWl2ZWQgdGhpcyB0cmFuc21pc3Npb24gaW4g
ZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZGlzY2FyZCB0
aGUgb3JpZ2luYWwgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnQocykuDQo=
