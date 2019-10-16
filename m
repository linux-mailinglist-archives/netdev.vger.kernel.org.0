Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9FD8D74
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404517AbfJPKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:13:27 -0400
Received: from mail-eopbgr40075.outbound.protection.outlook.com ([40.107.4.75]:31143
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbfJPKN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W68CjDz+YFYlGQdlfn1ofOaDeRO0JBLPUa8xxDrqbhc=;
 b=PdpCEzvRh3l9YfJApovR3zzhp7+nA1B6p5cAVizaSQvBBjAs+dS8AcvhwviVzqgr1wOF2oIs3oMZOxUuZuMR46gohA0yRJoALJ2a568bOB7qFTaEO4Lw6jB7VtUZJn7UF0nRt5Sg1h1E7sdghXu3/YjPcNxpMgBHGPSZn8xkojo=
Received: from AM6PR08CA0044.eurprd08.prod.outlook.com (2603:10a6:20b:c0::32)
 by VI1PR0801MB1760.eurprd08.prod.outlook.com (2603:10a6:800:51::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.18; Wed, 16 Oct
 2019 10:11:40 +0000
Received: from DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::209) by AM6PR08CA0044.outlook.office365.com
 (2603:10a6:20b:c0::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.17 via Frontend
 Transport; Wed, 16 Oct 2019 10:11:40 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT064.mail.protection.outlook.com (10.152.21.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 10:11:38 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Wed, 16 Oct 2019 10:11:33 +0000
X-CR-MTA-TID: 64aa7808
Received: from 584ede32fc7e.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.5.50])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 9F4E5496-4962-42B0-A7F2-540BA592F33F.1;
        Wed, 16 Oct 2019 10:11:28 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-he1eur02lp2050.outbound.protection.outlook.com [104.47.5.50])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 584ede32fc7e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Wed, 16 Oct 2019 10:11:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8bxk818lSSIZcUAxsoB/o8tuuNWNckQxvJmuUkJ8PjVKAB/uYM6Ll/P8WtR0vk+XiF0XXDZe8rVMd+DEuFYWg52iEcD6Nl1mgBxK2p6es5yMrySl8HZrK8QUPSlHELvGq2DwpHDMhvaSMqqjSqFCXH1sG/d3ZtkRe05nSnHUPmaRc3/GcLuMUuPPSSQ1qMKiOsUoT54KiX4Xj52cqVaF8Sh4q/D5Cdbev1HXHq3a/urHbHH+/52t7vh56fCagbd7A489eVdOwtIXKCDGtiGWLdc97S447pb0bBOCPPettkKD9wvES7q8QCiihKsdbjjxQx2r8rIuywNk4pFe9HxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W68CjDz+YFYlGQdlfn1ofOaDeRO0JBLPUa8xxDrqbhc=;
 b=K36CsZ+OH4mYWzuMxAlb0UCqlyPiDrGFuJfWAVebT8yOh9+CZM3Q51skQYEtPIywU5GkPiL1cT5YHF3ZT+9EjeAxfYm3pJERUr6i6DaBLMPvIztlRnSYEVliQNlVgWur6Z5vQwot7GgexzJezD4GABuzohAycUy+U+7iFCJ9QmT4lmIoA8/1d/CEQQGaFy8X3Wq0cShO/lyb/n9unimwJhhpRdx/CR5VTSMlYvQ6aeu2lQSwktTx9n2EmtUo8sgnCzPMUvIHWYZN03SS9+v3W0yLlljrAuVLDZ2C2+f/SmjdkqzzLN2eqS5BS1ThpeS1tkDUdBkSG0SYjYhOgb1vGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W68CjDz+YFYlGQdlfn1ofOaDeRO0JBLPUa8xxDrqbhc=;
 b=PdpCEzvRh3l9YfJApovR3zzhp7+nA1B6p5cAVizaSQvBBjAs+dS8AcvhwviVzqgr1wOF2oIs3oMZOxUuZuMR46gohA0yRJoALJ2a568bOB7qFTaEO4Lw6jB7VtUZJn7UF0nRt5Sg1h1E7sdghXu3/YjPcNxpMgBHGPSZn8xkojo=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1SPR00MB244.eurprd08.prod.outlook.com (10.171.98.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 10:11:25 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 10:11:25 +0000
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
Subject: RE: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v5 5/6] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHVg0Y6A4wUAbusSUOkn5f/2HpSwadb56wAgAC7jVCAADfWgIAAAOYAgAAwG2A=
Date:   Wed, 16 Oct 2019 10:11:25 +0000
Message-ID: <HE1PR0801MB1676412E33493247F7C37C6CF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
 <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <6e9bfd40-4715-74b3-b5d4-fc49329bed24@redhat.com>
 <140551c1-b56d-0942-58b3-61a1f5331e83@redhat.com>
In-Reply-To: <140551c1-b56d-0942-58b3-61a1f5331e83@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 14dea4f2-b891-4ba3-9452-a89be0130161.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 4709ad64-4d16-4ca2-f81b-08d752213bc0
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1SPR00MB244:|HE1SPR00MB244:|VI1PR0801MB1760:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB17604B235E3209521C304216F4920@VI1PR0801MB1760.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(189003)(199004)(13464003)(53546011)(14454004)(7696005)(76176011)(55016002)(5660300002)(86362001)(316002)(476003)(6436002)(9686003)(3846002)(11346002)(6116002)(446003)(99286004)(7416002)(66066001)(110136005)(186003)(102836004)(6506007)(26005)(54906003)(256004)(71200400001)(2501003)(2201001)(33656002)(52536014)(71190400001)(55236004)(486006)(6636002)(74316002)(305945005)(478600001)(25786009)(7736002)(76116006)(8676002)(66476007)(8936002)(81156014)(64756008)(66446008)(66556008)(66946007)(4326008)(6246003)(229853002)(2906002)(81166006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1SPR00MB244;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: X2rvBiNwCxruNT+7VAx6SGWdAs3F25IT5iNnDekCGw/xHwdKRks7GybByEneFEuYYXTQksaq64hKAj5lx5nWG4CC4d+ITk4nftyrU8/Rth6EDRNBNA3iFVvgKKpqgx3G4vwUy3wgL/A8b+/Oy9BAJaXWDvrOSzZYE6UZF3ZZkO8MQrMa25Q9Z+BIpPeI6pe7+agSKos0tOjO3rXCAorc6O0C7rCCEDoYGn57A7aWzgtDfoJzWMeuZmzbWlXs4k5Jr3uP9fSuZNzDcaPsApS0PWwpwYcqcRKfUh8mkcNVVhVyJJGGKtGPymoa9A1CFEXWvOTaLTTyfv10xlKKccUcQxUDn6DoK9kF5Ax/1+qWq0a2XNntkgrI5MCZY3UNuAyWaf2jp7pji9WIkUhSj/nzSCVTpsPcT7lIzwFUlNKhhSY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1SPR00MB244
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(13464003)(189003)(199004)(76130400001)(55016002)(5660300002)(436003)(63350400001)(70206006)(9686003)(186003)(53546011)(229853002)(26005)(70586007)(4326008)(110136005)(54906003)(102836004)(336012)(99286004)(356004)(6506007)(316002)(66066001)(22756006)(25786009)(2501003)(2486003)(8676002)(6116002)(52536014)(450100002)(76176011)(478600001)(2906002)(14454004)(3846002)(33656002)(305945005)(7696005)(86362001)(74316002)(6636002)(47776003)(23676004)(446003)(50466002)(11346002)(81166006)(81156014)(486006)(2201001)(476003)(126002)(7736002)(6246003)(26826003)(8936002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0801MB1760;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: e80cd277-4ded-4285-dc25-08d752213433
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: thuzZOgD69Nk1oKa8ofYz3K58AVbqWq2an7BJW2+T/QeyeKmAjNvUIQ+s9A/o4/YG0AvcmdH6sckgz7FBusPN8jM1r9Nz2K7I+8Q1VDKEfuJa93fFjL/wdjhFT/YSn1FaSujmlGImHPtgjSgzUwy9/9AgUvGsfD5e2N4eiFNayX3pSDi4VNjg/EB1SQY6s8lLszxP/dqMfKpYogPNOrJzA8sTlEazHzDkOQlEnW4v+5xAu9PKE6P8y6DrJSBeOLLfQnfkLkae8EnR4r3/2gNtlohWNf2eRXniuxl6CcCkw1grU7ZdRQxuCFH/t0HKogYLtXRlxggj1YfhUx9lJXaap52MSe9/yFVl0ai+qE6IouHQGxfJe4e4fKmUefD0PJ7cOkrHqwuU304x8ovVKAexhR4MsZxSpBmqjORli/M9G8=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 10:11:38.5294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4709ad64-4d16-4ca2-f81b-08d752213bc0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDE2LCAyMDE5IDM6MTQgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9neSBDaGlu
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
b20+OyBuZCA8bmRAYXJtLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NSA1LzZdIHB0cDog
YXJtNjQ6IEVuYWJsZSBwdHBfa3ZtIGZvciBhcm02NA0KPiANCj4gT24gMTYvMTAvMTkgMDk6MTAs
IFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+ID4gT24gMTYvMTAvMTkgMDU6NTIsIEppYW55b25nIFd1
IChBcm0gVGVjaG5vbG9neSBDaGluYSkgd3JvdGU6DQo+ID4+IFRoaXMgZnVuYyB1c2VkIG9ubHkg
Ynkga3ZtX2FyY2hfcHRwX2dldF9jbG9jayBhbmQgbm90aGluZyB0byBkbyB3aXRoDQo+ID4+IGt2
bV9hcmNoX3B0cF9nZXRfY2xvY2tfZm4uIEFsc28gaXQgY2FuIGJlIG1lcmdlZCBpbnRvDQo+ID4+
IGt2bV9hcmNoX3B0cF9nZXRfY2xvY2suDQo+ID4+DQo+ID4NCj4gPiBZb3VyIHBhdGNoZXMgYWxz
byBoYXZlIG5vIHVzZXIgZm9yIGt2bV9hcmNoX3B0cF9nZXRfY2xvY2ssIHNvIHlvdSBjYW4NCj4g
PiByZW1vdmUgaXQuDQo+IA0KPiBOZXZlcm1pbmQuICBJIG1pc3JlYWQgcGF0Y2ggMi4gIEhvd2V2
ZXIsIHRvIHJlbW92ZSB0aGUgY29uZnVzaW9uLCBjYW4geW91DQo+IHJlbmFtZSBrdm1fYXJjaF9w
dHBfZ2V0X2Nsb2NrX2ZuIHRvIGt2bV9hcmNoX3B0cF9nZXRfY3Jvc3N0c3RhbXA/DQo+IA0KDQp0
aGUgc3VmZml4IG9mIHRoaXMgZnVuY3Rpb24gbmFtZSBpcyByZXNlcnZlZCBmcm9tIGl0cyBhcmNo
LWluZGVwZW5kZW50IGNhbGxlciBwdHBfa3ZtX2dldF90aW1lX2ZuLCBzbyBpZiBJIGNoYW5nZSB0
aGlzIGZ1bmN0aW9uIG5hbWUNCkl0IHdpbGwgYmUgYmV0dGVyIGNoYW5nZSB0aGVtIHdob2xlLiBJ
IHRoaW5rICJwdHBfZ2V0X2Nyb3NzdHN0YW1wIiBpcyBhIGJldHRlciBzdWZmaXguDQoNClRoYW5r
cw0KSmlhbnlvbmcgDQoNCj4gUGFvbG8NCg0K
