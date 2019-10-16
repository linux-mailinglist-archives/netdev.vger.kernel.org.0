Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3088D86FD
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfJPDwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:52:39 -0400
Received: from mail-eopbgr20064.outbound.protection.outlook.com ([40.107.2.64]:47075
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfJPDwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 23:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hl8etiZDmKfpa+NAQsVrHee7fMzkNj8HZZVi7E0Lzk=;
 b=py/zl2cJEdDzmik7xGHO3Q1V1crQi/AnEXqChSEm/gk+msEq/L8pZfLCpWmqbPW/Enr4v4QCTin9iAHHm6Y66pyfZ2uQKX7g1ltbAvO4/YPOtaK1vjv0oABSA6wcxhzn/b05yz/20ftWcXderaftBfEipXvKAVkvDtGfCMbTuzs=
Received: from DB7PR08CA0058.eurprd08.prod.outlook.com (2603:10a6:10:26::35)
 by AM6PR08MB3736.eurprd08.prod.outlook.com (2603:10a6:20b:87::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16; Wed, 16 Oct
 2019 03:52:29 +0000
Received: from VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::209) by DB7PR08CA0058.outlook.office365.com
 (2603:10a6:10:26::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 03:52:29 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT050.mail.protection.outlook.com (10.152.19.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 03:52:28 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Wed, 16 Oct 2019 03:52:26 +0000
X-CR-MTA-TID: 64aa7808
Received: from c7fb7a3fb8cd.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.14.58])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3ECE13BA-B552-43D5-A38C-55A8FDE17978.1;
        Wed, 16 Oct 2019 03:52:21 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c7fb7a3fb8cd.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 16 Oct 2019 03:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0TbVXG8sfPJFObAAbieW+na4zDrPyTdNZbR3lSoTBEzZqCp8Aue1sNRPP7U+czJsqHYEsrZpdm3R3YEs5X/vSVe0RrbWdpsbTY35UyQaRZa0izDkU1U+84OSAZ+UtmG7rikPnDUCbFyXGHOoqb8eFzLWt8/ul+DbM6rkfnh9CINupMEyZL5Aq2owAuLSXsKX5uLqE1cErI+vuABxcutA0L5R0H8FG4kiYoxu2noPtvmsDn519nxMuTflFZGSRoCGIwk4eZh73UBb87VwxSwuCFMLKI2HoRjYqfG7+zuHYMlERZsPjGmYpH7jVQFlDBjERECo5ntGmGI1FJbcDDn1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hl8etiZDmKfpa+NAQsVrHee7fMzkNj8HZZVi7E0Lzk=;
 b=A8ZWRWC0QX6SmkytpCb14kAq5BZszqD1iQ5lhnWaIx79MiCsDhk2HNWjptwypvt472jaL+wR4ufl8OKU7e6RXCCiv/Dv3TIyt9P+Q7lNgFDUU7Ac2k1BLVPxxGYjE/ufU2WdmshKEoZkak9ljkROf/D5LKFMU//x8tTyHKft/kuVuAtumYFdvK0V85GdL1ys5rWfwd4ElQksbDde7xMolAFWMM6XmF4N7cnPRICotujQyIwySw5oYs7cOipZZzXrj/dDgbXSAIjt2YscfBTCXFiENAy9fPqFAo9rIbqXJJqxf8l4RD7mR1hMHXKm5J2waZkCjMxq1cNPO8zf5c40YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Hl8etiZDmKfpa+NAQsVrHee7fMzkNj8HZZVi7E0Lzk=;
 b=py/zl2cJEdDzmik7xGHO3Q1V1crQi/AnEXqChSEm/gk+msEq/L8pZfLCpWmqbPW/Enr4v4QCTin9iAHHm6Y66pyfZ2uQKX7g1ltbAvO4/YPOtaK1vjv0oABSA6wcxhzn/b05yz/20ftWcXderaftBfEipXvKAVkvDtGfCMbTuzs=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2122.eurprd08.prod.outlook.com (10.168.150.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Wed, 16 Oct 2019 03:52:17 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 03:52:17 +0000
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
Thread-Index: AQHVg0Y6A4wUAbusSUOkn5f/2HpSwadb56wAgAC7jVA=
Date:   Wed, 16 Oct 2019 03:52:17 +0000
Message-ID: <HE1PR0801MB167654440A67AF072E28FFFDF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-6-jianyong.wu@arm.com>
 <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
In-Reply-To: <da62c327-9402-9a5c-d694-c1a4378822e0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: a44c36d3-bcd2-4cf3-924a-6fc36127fde1.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 1b8b4fe3-aab2-40ee-dba9-08d751ec43be
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2122:|HE1PR0801MB2122:|AM6PR08MB3736:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB37360144A8E5E38E3912E8C3F4920@AM6PR08MB3736.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:2657;OLM:2657;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(13464003)(199004)(189003)(229853002)(76176011)(256004)(7696005)(2906002)(8936002)(33656002)(9686003)(316002)(478600001)(53546011)(6506007)(3846002)(6116002)(8676002)(55016002)(6436002)(81166006)(102836004)(4326008)(55236004)(81156014)(6246003)(11346002)(52536014)(446003)(476003)(25786009)(486006)(74316002)(99286004)(86362001)(186003)(26005)(305945005)(7416002)(71200400001)(71190400001)(54906003)(6636002)(110136005)(7736002)(2201001)(5660300002)(14454004)(76116006)(66446008)(2501003)(66946007)(66476007)(64756008)(66556008)(66066001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2122;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: aU1JMWWTxT808qT8BjGNWrwfRgUS/bk5rOoy5/srOXs7T35IXOOENSrj+VTBeFgu/tFr/500a3xdwgQvMlVOvmWR0bwvWAlOwpBza+mEwPv66bxxzVuloARo7dE1HcO9H2pWOjymuONAi3aefbV7JCkUpT21KI7mJXqbyk99ZzLnz7PG1sirYzGMWm06CxOddhUQQje8mzH6aS3aZ0ZDolVw3TVyDVPnzuEeX98W4YJUCGGz1p3stR8Bpd7otCVKYyVhHpc9OkqvLMF9ZenFRz789/k0ktLYLCbG87VoKD2133YHGfT3qhVV4Ck0Gbm9awI/AplVNsIZ2jfWxYcjAD3Rl25KkFMpi82qhiqAXYwHBm3FHJ64p6odh7j0wHJcENTumfX13sI1prtYefdrR2+d8S/1I7u0xKvOd9U7+WM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2122
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(13464003)(76130400001)(450100002)(478600001)(25786009)(70206006)(81156014)(8676002)(50466002)(8936002)(81166006)(26826003)(14454004)(33656002)(70586007)(22756006)(2501003)(2906002)(6246003)(7736002)(2201001)(102836004)(305945005)(74316002)(3846002)(6116002)(52536014)(6636002)(55016002)(436003)(186003)(5660300002)(26005)(86362001)(446003)(54906003)(7696005)(53546011)(76176011)(6506007)(66066001)(23676004)(36906005)(2486003)(316002)(229853002)(110136005)(63350400001)(9686003)(356004)(99286004)(486006)(126002)(4326008)(336012)(11346002)(47776003)(476003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3736;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8f059bff-4640-4875-c0a8-08d751ec3d36
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQrrq4c+8xqFEoV0rXELS77GQiv+Um5ca6evak9bBVNotqO8tUvUpmNb+w0cy8HTkiMm7FxNpgOlfThCbedTFGLyYf2pL2UPKMuztTRKxV356yN69/xd4Z0eED5SjvGDmdQcQjYXTqTPH9cgrbYLQ5fU4eoq2BZA+fnW3A5t0WcT0/WtFEbRZIr0wrc3qzhpeOvl5KsdOp2jWWw3J9CLj9ypGAcrOKJeeAHPJ2V4+K/zWZ4fa9rxPBCIq6FpyYD0lIlnqMmMVcRgPQJmeNmUwVM84YaTKheEeHCqlC6rnkQlo3lDSmGlTx8dbV3M8JAswxbwCgyJ1P9rHj1bjfOphw4uTRrQuuNquL+RB9l7UxsREznsPRyFwWzH6ozAyUpQ/Ztde/2QGiRvMr2j/s/FZAGcXQQeCst+Vz3p68rT+Ew=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 03:52:28.5174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b8b4fe3-aab2-40ee-dba9-08d751ec43be
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDE2LCAyMDE5IDEyOjM5IEFNDQo+IFRvOiBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hp
bmEpIDxKaWFueW9uZy5XdUBhcm0uY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgeWFu
Z2JvLmx1QG54cC5jb207IGpvaG4uc3R1bHR6QGxpbmFyby5vcmc7DQo+IHRnbHhAbGludXRyb25p
eC5kZTsgc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsgbWF6QGtlcm5lbC5vcmc7DQo+
IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgTWFyayBSdXRsYW5kIDxNYXJrLlJ1dGxhbmRAYXJt
LmNvbT47DQo+IHdpbGxAa2VybmVsLm9yZzsgU3V6dWtpIFBvdWxvc2UgPFN1enVraS5Qb3Vsb3Nl
QGFybS5jb20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0t
a2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHU7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFN0ZXZlIENhcHBlcg0KPiA8U3RldmUuQ2FwcGVyQGFy
bS5jb20+OyBLYWx5IFhpbiAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+IDxLYWx5LlhpbkBhcm0u
Y29tPjsgSnVzdGluIEhlIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEp1c3Rpbi5IZUBhcm0u
Y29tPjsgbmQgPG5kQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjUgNS82XSBwdHA6
IGFybTY0OiBFbmFibGUgcHRwX2t2bSBmb3IgYXJtNjQNCj4gDQo+IE9uIDE1LzEwLzE5IDEyOjQ4
LCBKaWFueW9uZyBXdSB3cm90ZToNCj4gPiAraW50IGt2bV9hcmNoX3B0cF9nZXRfY2xvY2tfZ2Vu
ZXJpYyhzdHJ1Y3QgdGltZXNwZWM2NCAqdHMsDQo+ID4gKwkJCQkgICBzdHJ1Y3QgYXJtX3NtY2Nj
X3JlcyAqaHZjX3Jlcykgew0KPiA+ICsJdTY0IG5zOw0KPiA+ICsJa3RpbWVfdCBrdGltZV9vdmVy
YWxsOw0KPiA+ICsNCj4gPiArDQo+IAlhcm1fc21jY2NfMV8xX2ludm9rZShBUk1fU01DQ0NfVkVO
RE9SX0hZUF9LVk1fUFRQX0ZVDQo+IE5DX0lELA0KPiA+ICsJCQkJICBodmNfcmVzKTsNCj4gPiAr
CWlmICgobG9uZykoaHZjX3Jlcy0+YTApIDwgMCkNCj4gPiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7
DQo+ID4gKw0KPiA+ICsJa3RpbWVfb3ZlcmFsbCA9IGh2Y19yZXMtPmEwIDw8IDMyIHwgaHZjX3Jl
cy0+YTE7DQo+ID4gKwkqdHMgPSBrdGltZV90b190aW1lc3BlYzY0KGt0aW1lX292ZXJhbGwpOw0K
PiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiANCj4gVGhpcyBzZWVtcyB3
cm9uZywgd2hvIHVzZXMga3ZtX2FyY2hfcHRwX2dldF9jbG9ja19mbj8NCj4gDQpUaGlzIGZ1bmMg
dXNlZCBvbmx5IGJ5IGt2bV9hcmNoX3B0cF9nZXRfY2xvY2sgYW5kIG5vdGhpbmcgdG8gZG8gd2l0
aCBrdm1fYXJjaF9wdHBfZ2V0X2Nsb2NrX2ZuLg0KQWxzbyBpdCBjYW4gYmUgbWVyZ2VkIGludG8g
a3ZtX2FyY2hfcHRwX2dldF9jbG9jay4NCg0KPiBQYW9sbw0KDQo=
