Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A7DBACD3
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405359AbfIWDTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 23:19:32 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:53378
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404102AbfIWDTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 23:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taNXCqQBFyE75iJZhTnpCdm9XED6QdeXfjxzBfwcx4g=;
 b=88FzB8OSY+kX4B8aKYWYl9jI7VLG3T2T6L5bahpMGzAyNaDdm4VjJ2E3ZVKAL/Q4PYyDtTyZ+xrCGK7ILbE/MtXPIE9uHxyvmfKlgZWy3DZHAlVp0ZJrPNlN0v57ZUV+yZkzHvl7A4aTkjeee0yqNW2HYuf1uQW17twSvVufCGQ=
Received: from VI1PR08CA0103.eurprd08.prod.outlook.com (2603:10a6:800:d3::29)
 by DBBPR08MB4760.eurprd08.prod.outlook.com (2603:10a6:10:f6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.26; Mon, 23 Sep
 2019 03:19:20 +0000
Received: from VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::203) by VI1PR08CA0103.outlook.office365.com
 (2603:10a6:800:d3::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2284.21 via Frontend
 Transport; Mon, 23 Sep 2019 03:19:19 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT031.mail.protection.outlook.com (10.152.18.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2284.20 via Frontend Transport; Mon, 23 Sep 2019 03:19:18 +0000
Received: ("Tessian outbound d5a1f2820a4f:v31"); Mon, 23 Sep 2019 03:19:13 +0000
X-CR-MTA-TID: 64aa7808
Received: from 48af42da8a99.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.13.57])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id A41A4DF8-44B5-45BE-956E-DB6BFA8EA492.1;
        Mon, 23 Sep 2019 03:19:08 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2057.outbound.protection.outlook.com [104.47.13.57])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 48af42da8a99.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 23 Sep 2019 03:19:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3fiu8P14kfpMSMEd14a1+IzMyjoxsPKYwLMuPnEmIjFBPHm8Na61GMvyoyCfwdANh4OXviVikGXrVWdSSpZ8388Nd32+jr3gtLehtHosJZhzniV7hHYPrRABVE8FFwnVTgjL+EaAMEmkAXtnYxaxC6sYOk8cZRect/Ru+tEPvBuHS/uBDPZVqEAgCkqrSoRhmPJZ2BTKihCCFT9c3+8vmjjIcuq3av1Tev2/+gzcPRoNF/VhiqehgVOmofBqALU/9hRkDJmzVBbq2J0nwOQp/8KXonL8uU1poyD6rPiqgi7LlubziJ8g/J7a7faJPeqje+ww80aaMzQfkWVWu3gdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taNXCqQBFyE75iJZhTnpCdm9XED6QdeXfjxzBfwcx4g=;
 b=QoIIiFutQ3dqDdm0z4IL8Ac0hM2WNQcgwevFOxeDCIOTOi4HLDjJfrkw3/GdIPLl2Pet7L3HmpxCcxVvSYifBNmIeE5Lr3f8Q9xqzRsGvKjT3XfHR6wI/DN39+co0sewdkVXJnYQfb8SIIlCaI9O90AHvlrxWKhAh2WPtSbuuX3zexr3Dim68shjhtmkTZ0jqTnJ44Cw9eAbUYZ4k7T6WKBk6V9Zb34EfY0YRYUVglYfFXr15X8/brSineodsJ9FcdVdI0b6p7MW2ISyhCL7S+oAMIzGK/cAlbnL+iDrPp9YkGX6W3UfSniQymlcbX4gNC3qtvsu//5KiPZ0PbNC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taNXCqQBFyE75iJZhTnpCdm9XED6QdeXfjxzBfwcx4g=;
 b=88FzB8OSY+kX4B8aKYWYl9jI7VLG3T2T6L5bahpMGzAyNaDdm4VjJ2E3ZVKAL/Q4PYyDtTyZ+xrCGK7ILbE/MtXPIE9uHxyvmfKlgZWy3DZHAlVp0ZJrPNlN0v57ZUV+yZkzHvl7A4aTkjeee0yqNW2HYuf1uQW17twSvVufCGQ=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1771.eurprd08.prod.outlook.com (10.168.150.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Mon, 23 Sep 2019 03:19:06 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 03:19:06 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v3 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhAgAAo7ACAAAjcAIAACYiAgAWnltA=
Date:   Mon, 23 Sep 2019 03:19:06 +0000
Message-ID: <HE1PR0801MB1676A0D2B90A52997DD15675F4850@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
 <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
In-Reply-To: <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 57bd5335-da55-4975-aa8c-df24a27510eb.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 44408a65-0e27-4597-d2c6-08d73fd4d1fc
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB1771;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1771:|HE1PR0801MB1771:|DBBPR08MB4760:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB4760C73AE78E337164D1C7F6F4850@DBBPR08MB4760.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0169092318
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(199004)(189003)(13464003)(305945005)(476003)(11346002)(53546011)(6506007)(66556008)(66446008)(64756008)(66476007)(66946007)(6436002)(99286004)(7696005)(186003)(7416002)(26005)(6636002)(229853002)(2501003)(55016002)(55236004)(76116006)(102836004)(9686003)(71190400001)(71200400001)(54906003)(4326008)(110136005)(7736002)(66066001)(25786009)(2906002)(446003)(5660300002)(256004)(14444005)(2201001)(86362001)(33656002)(486006)(3846002)(6246003)(8936002)(316002)(81156014)(6116002)(81166006)(14454004)(52536014)(8676002)(74316002)(76176011)(478600001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1771;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: +LXHKWscQ0TP1vxu0T0WnWRg15B1Nc21iA1ut1Ln7m53L4HaN/mGbhcO5VoxBODU2zfTzBMF5CaHoJi6CmHS4k4pxIfX+Q5vBI9Lu34FdWTQ+YKUHPEGChGemhUmapbv6oXBRUKzmSJTZVqb088ZmtEpWy2R6XwVsDRMLIlzEtKMzKgdFuH4VIutB7mUJoR6jYCvgXKY9eEW/pP/cS/oV1jbke9pHgOZPxRp5ard635nJWUvtN2egj/uci4C4KLZldzEQnY83ww5VgzBJs8COH8fmIRUM9bjG4aAKJsXDPveI4g69Zq7Q04Upjfl5Pbd2QZ7iTkCUtUpWnKxOw2bzgddRZ6Ed5YrBZmAqo5CzF46IxvCNcmbe6WSCH0XZ42/DOQPkARZnACsEHulUhk/3bhIzAlb3w5u5tR5PKZ2Y9w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1771
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39850400004)(13464003)(199004)(189003)(7696005)(446003)(25786009)(11346002)(6116002)(6636002)(2906002)(356004)(6246003)(436003)(2486003)(23676004)(52536014)(476003)(126002)(22756006)(63350400001)(450100002)(186003)(486006)(8676002)(102836004)(26005)(99286004)(478600001)(76130400001)(5660300002)(81166006)(81156014)(3846002)(336012)(76176011)(26826003)(53546011)(6506007)(8936002)(74316002)(14454004)(305945005)(7736002)(33656002)(86362001)(4326008)(229853002)(2201001)(70206006)(70586007)(316002)(50466002)(66066001)(107886003)(2501003)(110136005)(54906003)(9686003)(36906005)(47776003)(55016002)(14444005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR08MB4760;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: d4b9ffe9-218d-4103-b01a-08d73fd4cacd
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DBBPR08MB4760;
NoDisclaimer: True
X-Forefront-PRVS: 0169092318
X-Microsoft-Antispam-Message-Info: h/kSZGZIhEH9trsVIR2rNU+ZE3rdOzskLWyFXZiNZcJeKlzcqwc7FokLd/90d1uAaoifRTg7WJCK/qe4KyK9BTgBCcc0nko9bEzaogB6GrBVQUU7Fsu3TOE/gVwPQv1ZX/2kJfsaYo60JEoPEuKhvTeyt/ZCHXFPNeLZ4gAo3Nd6NSlMmdDFaydA62fuIN50CrQGZDYzV7ZWKdLv1yq3p4qXF/EfM6B1fwQrcBnYiYQPrjGSblKaWjcFWNI1mgu/g7gC0NWgoM8kJydQLlNUuNuV8ifFHR1nOdqEYylCut/v1fgIzC+CNKiqOlUGqBcQMBFk7WZky91Mi+zpSSDZUTGTqpNJBlebI+OGIj+jTOmKnc0SgUlft0fNsnuT0j5C83hOnpItZlkEMkWJnO+rTd3uteecUvqAbu5qmPIGUUw=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2019 03:19:18.2706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44408a65-0e27-4597-d2c6-08d73fd4d1fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIFNl
cHRlbWJlciAxOSwgMjAxOSA4OjEzIFBNDQo+IFRvOiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPjsgSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8SmlhbnlvbmcuV3VA
YXJtLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHlhbmdiby5sdUBueHAuY29tOw0KPiBq
b2huLnN0dWx0ekBsaW5hcm8ub3JnOyB0Z2x4QGxpbnV0cm9uaXguZGU7IHNlYW4uai5jaHJpc3Rv
cGhlcnNvbkBpbnRlbC5jb207DQo+IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgTWFyayBSdXRs
YW5kIDxNYXJrLlJ1dGxhbmRAYXJtLmNvbT47IFdpbGwNCj4gRGVhY29uIDxXaWxsLkRlYWNvbkBh
cm0uY29tPjsgU3V6dWtpIFBvdWxvc2UNCj4gPFN1enVraS5Qb3Vsb3NlQGFybS5jb20+DQo+IENj
OiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBTdGV2
ZSBDYXBwZXINCj4gPFN0ZXZlLkNhcHBlckBhcm0uY29tPjsgS2FseSBYaW4gKEFybSBUZWNobm9s
b2d5IENoaW5hKQ0KPiA8S2FseS5YaW5AYXJtLmNvbT47IEp1c3RpbiBIZSAoQXJtIFRlY2hub2xv
Z3kgQ2hpbmEpDQo+IDxKdXN0aW4uSGVAYXJtLmNvbT47IG5kIDxuZEBhcm0uY29tPjsgbGludXgt
YXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBQ
QVRDSCB2MyA0LzZdIHBzY2k6IEFkZCBodmMgY2FsbCBzZXJ2aWNlIGZvciBwdHBfa3ZtLg0KPiAN
Cj4gT24gMTkvMDkvMTkgMTM6MzksIE1hcmMgWnluZ2llciB3cm90ZToNCj4gPj4gSSBkb24ndCB0
aGluayBpdCdzIHVnbHkgYnV0IG1vcmUgaW1wb3J0YW50LCB1c2luZyB0ay0+dGtyX21vbm8uY2xv
Y2sNCj4gPj4gaXMgaW5jb3JyZWN0LiAgU2VlIGhvdyB0aGUgeDg2IGNvZGUgaGFyZGNvZGVzICZr
dm1fY2xvY2ssIGl0J3MgdGhlDQo+ID4+IHNhbWUgZm9yIEFSTS4NCj4gPiBOb3QgcmVhbGx5LiBU
aGUgZ3Vlc3Qga2VybmVsIGlzIGZyZWUgdG8gdXNlIGFueSBjbG9ja3NvdXJjZSBpdCB3aXNoZXMu
DQo+IA0KPiBVbmRlcnN0b29kLCBpbiBmYWN0IGl0J3MgdGhlIHNhbWUgb24geDg2Lg0KPiANCj4g
SG93ZXZlciwgZm9yIFBUUCB0byB3b3JrLCB0aGUgY3ljbGVzIHZhbHVlIHJldHVybmVkIGJ5IHRo
ZSBjbG9ja3NvdXJjZSBtdXN0DQo+IG1hdGNoIHRoZSBvbmUgcmV0dXJuZWQgYnkgdGhlIGh5cGVy
Y2FsbC4gIFNvIGZvciBBUk0NCj4gZ2V0X2RldmljZV9zeXN0ZW1fY3Jvc3N0c3RhbXAgbXVzdCBy
ZWNlaXZlIHRoZSBhcmNoIHRpbWVyIGNsb2Nrc291cmNlLCBzbw0KPiB0aGF0IGl0IHdpbGwgcmV0
dXJuIC1FTk9ERVYgaWYgdGhlIGFjdGl2ZSBjbG9ja3NvdXJjZSBpcyBhbnl0aGluZyBlbHNlLg0K
PiANCg0KQWZ0ZXIgZGF5J3MgcmVmbGVjdGlvbiBvbiB0aGlzLCBJJ20gYSBsaXR0bGUgY2xlYXIg
YWJvdXQgdGhpcyBpc3N1ZSwgbGV0IG1lIGNsYXJpZnkgaXQuDQpJIHRoaW5rIHRoZXJlIGlzIHRo
cmVlIHByaW5jaXBsZXMgZm9yIHRoaXMgaXNzdWU6DQooMSk6IGd1ZXN0IGFuZCBob3N0IGNhbiB1
c2UgZGlmZmVyZW50IGNsb2Nrc291Y2VzIGFzIHRoZWlyIGN1cnJlbnQgY2xvY2tzb3VjZSBhdCB0
aGUgc2FtZSB0aW1lDQphbmQgd2UgY2FuJ3QgIG9yIGl0J3Mgbm90IGVhc3kgdG8gcHJvYmUgdGhh
dCBpZiB0aGV5IHVzZSB0aGUgc2FtZSBvbmUuDQooMik6IHRoZSBjeWNsZSB2YWx1ZSBhbmQgdGhl
IGNsb2Nrc291Y2Ugd2hpY2ggcGFzc2VkIHRvIGdldF9kZXZpY2Vfc3lzdGVtX2Nyb3NzdHN0YW1w
IG11c3QgYmUgbWF0Y2guDQooMyk6IHB0cF9rdm0gdGFyZ2V0IHRvIGluY3JlYXNlIHRoZSB0aW1l
IHN5bmMgcHJlY2lzaW9uIHNvIHdlIHNob3VsZCBjaG9vc2UgYSBoaWdoIHJhdGUgY2xvY2tzb3Vy
Y2UgYXMgcHRwX2t2bSBjbG9ja3NvdXJjZS4NCkJhc2Ugb24gKDEpIGFuZCAoMikgd2UgY2FuIGRl
ZHVjZSB0aGF0IHRoZSBwdHBfa3ZtIGNsb2Nrc291cmNlIHNob3VsZCBiZSBiZXR0ZXIgYSBmaXhl
ZCBvbmUuIFNvIHdlIGNhbiB0ZXN0IGlmIHRoZSBjeWNsZSBhbmQNCmNsb2Nrc291cmNlIGlzIG1h
dGNoLiANCkJhc2Ugb24gKDMpIHRoZSBhcmNoX3N5c190aW1lciBzaG91bGQgYmUgY2hvc2VuLCBh
cyBpdCdzIHRoZSBiZXN0IGNsb2Nrc291cmNlIGJ5IGZhciBmb3IgYXJtLg0KDQpUaGFua3MNCkpp
YW55b25nIFd1DQoNCj4gUGFvbG8NCj4gDQo+ID4gSW4gc29tZSBjYXNlcywgaXQgaXMgYWN0dWFs
bHkgZGVzaXJhYmxlIChsaWtlIHRoZXNlIGJyb2tlbiBzeXN0ZW1zDQo+ID4gdGhhdCBjYW5ub3Qg
dXNlIGFuIGluLWtlcm5lbCBpcnFjaGlwLi4uKS4gTWF5YmUgaXQgaXMgdGhhdCBvbiB4ODYgdGhl
DQo+ID4gZ3Vlc3Qgb25seSB1c2VzIHRoZSBrdm1fY2xvY2ssIGJ1dCB0aGF0J3MgYSBtdWNoIGhh
cmRlciBzZWxsIG9uIEFSTS4NCj4gPiBUaGUgZmFjdCB0aGF0IHB0cF9rdm0gYXNzdW1lcyB0aGF0
IHRoZSBjbG9ja3NvdXJjZSBpcyBmaXhlZCBkb2Vzbid0DQo+ID4gc2VlbSBjb3JyZWN0IGluIHRo
YXQgY2FzZS4NCg0K
