Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42D7D8D44
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392207AbfJPKFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:05:42 -0400
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:7240
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfJPKFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQGczWTScr5w+6CN4LiAycC4W1vCOYvima47Au+h8Y=;
 b=VnZlvFbCFOalu0ZgqPwQYzXCpT3Ds+mHvNprLVJ529f2aubOeCLB9UsWP8JnkCRGhtc9co9LrpIHN0frzWPFwn7NraOZvG5SNVQOTpgLpk7th7IlDJwt1Fl5EkNepRbYVtJPLKha8KhsKudmhXWNJuRymP8rTduGvD6kVd2Pses=
Received: from DB6PR0801CA0062.eurprd08.prod.outlook.com (2603:10a6:4:2b::30)
 by AM5PR0802MB2595.eurprd08.prod.outlook.com (2603:10a6:203:a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.21; Wed, 16 Oct
 2019 10:04:55 +0000
Received: from VE1EUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::205) by DB6PR0801CA0062.outlook.office365.com
 (2603:10a6:4:2b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 10:04:55 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT063.mail.protection.outlook.com (10.152.18.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 10:04:54 +0000
Received: ("Tessian outbound 851a1162fca7:v33"); Wed, 16 Oct 2019 10:04:51 +0000
X-CR-MTA-TID: 64aa7808
Received: from 826696268afc.1 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.14.59])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 890A5724-0D73-4B48-9524-DA7DF9F4AD28.1;
        Wed, 16 Oct 2019 10:04:46 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 826696268afc.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Wed, 16 Oct 2019 10:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pa9wSs6v2ufdWB+TzQ26BgiClPtKSEtk7UJlA7RV0aRbla4eCY0RtAcLg/dLTWM+kuUjcyp4V+24oW9iJzJQy5NC8q+c+AdyAN1ia2Yeu9i/mHL7ngjzfj4iSg675TReWSNxwj+j1bkhkNv2iretEQ/4PYJFk2lIk092ZqVMJ2UCX7zr+ncX6pplh6tncMnhbvNGXuqCLtr+7nEuWawQ9H3iF5s7vx3lqDe+dY4zVzYcKvyj3zupAdRQTTgMvc4ZQtl5eX8QZORDlEgI8FBCJWNMmwiXrS5Un7o1lJflANUfLxZ+YN+6Qzqb4R6tXKM7szw9XaqFF/+9vnQW4wiPaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQGczWTScr5w+6CN4LiAycC4W1vCOYvima47Au+h8Y=;
 b=ofdSrNLzR7e69S+3PjyjcZcGf5EF8CgFZSkv5R9DOmp8C+UXuOxN8OBo3mhAVELMKm9vG8uV0rbZ2uMqtmYQ4ZiKfqMvKCOsYE7DOfPAItohJXTTljy5vWVwSXGhM5O14U9A88PqzCnqd0lfCiDakoBB95lD58NcmebKPtqtTFHCe2Q/0bZksysncKXBUdS16VJVErSYFCELA3j/m2nW7fNmk5xl8Gnlymc8FF9RBTgDwtbonQ/7EAdPgANjMUQ0Qd86tGV7DZQwfudUiHGAwZ6zTwB5dCkFMCZ2TcouG0Av3MYassHYWJS3YyKc1M7v4/osM0zgeOzreamNWt9qjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJQGczWTScr5w+6CN4LiAycC4W1vCOYvima47Au+h8Y=;
 b=VnZlvFbCFOalu0ZgqPwQYzXCpT3Ds+mHvNprLVJ529f2aubOeCLB9UsWP8JnkCRGhtc9co9LrpIHN0frzWPFwn7NraOZvG5SNVQOTpgLpk7th7IlDJwt1Fl5EkNepRbYVtJPLKha8KhsKudmhXWNJuRymP8rTduGvD6kVd2Pses=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1865.eurprd08.prod.outlook.com (10.168.94.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 10:04:43 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 10:04:43 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [PATCH v5 2/6] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [PATCH v5 2/6] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVg0Yy3IKxJp51oU6H7J1V0yQ+3Kdc2u8AgAAwgwA=
Date:   Wed, 16 Oct 2019 10:04:43 +0000
Message-ID: <HE1PR0801MB1676A5DA4C0B996FEDB2D47BF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-3-jianyong.wu@arm.com>
 <e0260f51-ad29-02ba-a46f-ebaa68f7a9ea@redhat.com>
In-Reply-To: <e0260f51-ad29-02ba-a46f-ebaa68f7a9ea@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 224ccb43-40ba-42fe-bb9c-f48f986e50d3.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 403fef5c-4de9-4196-5b4e-08d752204ab3
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1865:|HE1PR0801MB1865:|AM5PR0802MB2595:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0802MB259529C546423D854AF47AA8F4920@AM5PR0802MB2595.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(13464003)(189003)(199004)(9686003)(86362001)(6436002)(55016002)(316002)(2201001)(3846002)(71200400001)(229853002)(11346002)(486006)(446003)(6116002)(66066001)(476003)(71190400001)(6636002)(76176011)(186003)(55236004)(6506007)(110136005)(99286004)(53546011)(54906003)(2501003)(7696005)(256004)(102836004)(26005)(4744005)(33656002)(7736002)(7416002)(74316002)(305945005)(52536014)(5660300002)(25786009)(2906002)(478600001)(8936002)(76116006)(66946007)(4326008)(66556008)(66446008)(64756008)(6246003)(14454004)(81166006)(66476007)(81156014)(8676002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1865;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KA8atxduN7y7VJWTypMr4oOoPQJZK2+A9jCrfRzSjua2VSCl8wHq+yYTUZSB+H/gVmvq3HPl3Hj8ZU3WbHggWain+8An8Lkr3LYXLVsrBAplNSwiKbE326TKuTCTbeQnEL4mfcBgECDsxJxIWTZ9pzY/ZLqoi1qJ8NwVt1nxIcqzr28pRu2qx6SjRAPrW3LhTi66EPg/jOJt67NiSD9np/LHbUQjg78YRgvOjQxR7nxJWrsqW53LD/rDcxbRjpgMMFm9WoS/3I9xsTD0hRpfG6j5vxk3YL/FGnVD35Oo9QIxNT+VjR1h0mSENWMNFS748u580xmf3ERPW+pDcyC/ehhIvtrumAK8ni9iPfD8N2QR7i4HEo++sGKk+X8uxMPfFfb6zTm84EHwwajZau3NOiT5InCH9QVEGjvdqJNeOWA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1865
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(396003)(13464003)(189003)(199004)(36906005)(76130400001)(33656002)(47776003)(486006)(50466002)(22756006)(76176011)(476003)(126002)(110136005)(54906003)(55016002)(66066001)(70206006)(70586007)(86362001)(2201001)(446003)(26005)(74316002)(186003)(316002)(9686003)(11346002)(6506007)(436003)(53546011)(63350400001)(23676004)(2486003)(336012)(7696005)(102836004)(2501003)(2906002)(356004)(8936002)(26826003)(14454004)(478600001)(81156014)(81166006)(4326008)(229853002)(7736002)(5660300002)(6116002)(3846002)(25786009)(8676002)(6636002)(99286004)(6246003)(305945005)(52536014)(450100002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0802MB2595;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 89cf402e-eeb9-4982-23dd-08d752204445
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G4Ct70+gzil5gJgwwtBj8bvZV2a8JnlNudgDD3+GVjZsY5rlJU8hNGEG/YpAdICH3T2BBSSG3AHdQm2jZBol2WzFP+rjzVYLfhKNhRPM8jgBAG0oTqxqtrqOcc6J45wt0EPISyJ3O+k2t9vpp/hxaY6k6eX60vllRIXAKqHaIASjsvoj7YG02qYG23sgbWNm4SBQVNwQLRp7E0OZ0EqmkN4ndnzhMtxexhN5fSg5Es+APqN918vqgq9NrSbsUnoPuYipqDgYVgdb6+2xXMA9527y/j52BEEO8dtwbuPfMW5Pm9QNUEUy5IPwJwe0qRGFUtLRpp52vvTR5dN0goDUfqo5v+EZhfA884SwEGW9MgGS+K2VaxCAHffAtPVPgttk0rJ3lj9ROQG740U3FpW3M4xF2zUFKJpfJXAElc+K5fQ=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 10:04:54.0082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 403fef5c-4de9-4196-5b4e-08d752204ab3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0802MB2595
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDE2LCAyMDE5IDM6MTAgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9neSBDaGlu
YSkgPEppYW55b25nLld1QGFybS5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyB5YW5n
Ym8ubHVAbnhwLmNvbTsgam9obi5zdHVsdHpAbGluYXJvLm9yZzsNCj4gdGdseEBsaW51dHJvbml4
LmRlOyBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tOyBtYXpAa2VybmVsLm9yZzsNCj4g
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tOyBNYXJrIFJ1dGxhbmQgPE1hcmsuUnV0bGFuZEBhcm0u
Y29tPjsNCj4gd2lsbEBrZXJuZWwub3JnOyBTdXp1a2kgUG91bG9zZSA8U3V6dWtpLlBvdWxvc2VA
YXJtLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS1r
ZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dTsga3ZtQHZnZXIua2VybmVsLm9yZzsgU3RldmUgQ2FwcGVyDQo+IDxTdGV2ZS5DYXBwZXJAYXJt
LmNvbT47IEthbHkgWGluIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEthbHkuWGluQGFybS5j
b20+OyBKdXN0aW4gSGUgKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8SnVzdGluLkhlQGFybS5j
b20+OyBuZCA8bmRAYXJtLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NSAyLzZdIHB0cDog
UmVvcmdhbml6ZSBwdHBfa3ZtIG1vZHVsZXMgdG8gbWFrZSBpdA0KPiBhcmNoLWluZGVwZW5kZW50
Lg0KPiANCj4gT24gMTUvMTAvMTkgMTI6NDgsIEppYW55b25nIFd1IHdyb3RlOg0KPiA+ICsJcmV0
ID0ga3ZtX2FyY2hfcHRwX2luaXQoKTsNCj4gPiArCWlmICghcmV0KQ0KPiA+ICsJCXJldHVybiAt
RU9QTk9UU1VQUDsNCj4gDQo+IFRoaXMgc2hvdWxkIGJlICJpZiAocmV0KSIuDQo+IA0KDQpZZWFo
LCBJIGNoYW5nZSB0aGlzIGF0IHBhdGNoIDUvNiwgYnV0IG5lZWQgY2hhbmdlIGl0IGhlcmUuDQoN
ClRoYW5rcw0KSmlhbnlvbmcNCg0KPiBQYW9sbw0KDQo=
