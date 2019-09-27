Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9163C0316
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfI0KOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:14:43 -0400
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:18817
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfI0KOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2gF2Swg9uwp0X/Fea/eKeMEPpP3YEBWTiwK95iYjc=;
 b=WkjJKGtpXmRLuMMtdysdV/T9BGEOcuxILw8dJgc4g5BrqjT4b8WzBkMd8lbjcxz497rg3CTo+WlLs0Erovv5t+KTyMDcVYxYfBWKl4PE6xh10fZtao5VomzOxmKkB3fobkxTy7EpPEeiM33rbKcn41Q3Q4UVuIP6zl3RfSLq8+4=
Received: from VI1PR08CA0184.eurprd08.prod.outlook.com (2603:10a6:800:d2::14)
 by AM0PR08MB4434.eurprd08.prod.outlook.com (2603:10a6:208:143::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20; Fri, 27 Sep
 2019 10:14:35 +0000
Received: from AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::205) by VI1PR08CA0184.outlook.office365.com
 (2603:10a6:800:d2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2305.15 via Frontend
 Transport; Fri, 27 Sep 2019 10:14:34 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT031.mail.protection.outlook.com (10.152.16.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Fri, 27 Sep 2019 10:14:33 +0000
Received: ("Tessian outbound 3fba803f6da3:v33"); Fri, 27 Sep 2019 10:14:30 +0000
X-CR-MTA-TID: 64aa7808
Received: from 335722af9282.4 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.14.59])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 942D3DAB-609D-4273-9071-B272EDB697AB.1;
        Fri, 27 Sep 2019 10:14:25 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 335722af9282.4
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Fri, 27 Sep 2019 10:14:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBQnLgUc+e6tol24I/TqgNVa4e4/LDRIIZLAUtUtbbnTd5c+LOJ5f0Wafxc6yzzUzVPBoMUgK12mrhdB4xS0N4YoAjElYLOz8kKYUVk43cvgZYd4CAJ4WBxBMmK91P1asSeE7o2xv86kFQ32mERrwmLJNJg8jiRqLURfxBvQ4bf0WDL6d0hjbEGtzBnvsGoax96DR+w4di3PnKlsXMQjweoMOunLYO2Gbz4zLVv1c+6R8Wq+b6YOGay0l1Pz+ViYcOPAY3YKYWTpYD3sFhnWshblvbCQ5R9Ccd+2iptODeDtt5aDDOzIBvzVxdQGc4kQ4qnXQec/jj1ozu0xD9Qw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2gF2Swg9uwp0X/Fea/eKeMEPpP3YEBWTiwK95iYjc=;
 b=YU+SsWHmxl3oUAKiSJgQr5F0xpHJjR0mP9u2o0jGAssKnpChWCBIN0sMtLIbDwaU9fACg3N7XNXl+KM7sbscfshxyzjOTeVEDuuIPpe1sIWvRr2Z+ltYTtPgDoDnsTJKyqknIJw3VCTIWHdeqOCANh1bYGlZxUqrarklOoSZtdFbkmECLMNxJQu5mzI3WX7g2aoEXEZWN18puDOlI2XJdIkRp1laBxjKVvXGqThNrv3u6zrtuYyfMDzHmKpM4ntOkaH5yumRY1mwaS9wpefEb3kqAo74s4cx5m+9tu/Be7XqjWtzkyN3R+ieCoFjiGrXWgkRI9Ihlu62GE1xhjLodg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2gF2Swg9uwp0X/Fea/eKeMEPpP3YEBWTiwK95iYjc=;
 b=WkjJKGtpXmRLuMMtdysdV/T9BGEOcuxILw8dJgc4g5BrqjT4b8WzBkMd8lbjcxz497rg3CTo+WlLs0Erovv5t+KTyMDcVYxYfBWKl4PE6xh10fZtao5VomzOxmKkB3fobkxTy7EpPEeiM33rbKcn41Q3Q4UVuIP6zl3RfSLq8+4=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1627.eurprd08.prod.outlook.com (10.168.146.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Fri, 27 Sep 2019 10:14:20 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 10:14:20 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVdF+Ft3UnKFEitUOtlQstSNDglqc97ZgAgAFgLECAAAGAgIAAAEGA
Date:   Fri, 27 Sep 2019 10:14:20 +0000
Message-ID: <HE1PR0801MB1676139461D06C2E421FA7BAF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
 <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
 <HE1PR0801MB167630F7B983A7F9DBB473DFF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <4337dcf0-bd60-4db8-6c9f-cd718b89d2a4@arm.com>
In-Reply-To: <4337dcf0-bd60-4db8-6c9f-cd718b89d2a4@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: cf23ba1a-bbd7-4b56-9a4d-63540697cb1e.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 3af6abcb-133c-47ee-d634-08d743337e1a
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1627:|HE1PR0801MB1627:|AM0PR08MB4434:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4434FB7F9EBAD780CD144B19F4810@AM0PR08MB4434.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0173C6D4D5
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(13464003)(189003)(199004)(71190400001)(6246003)(55236004)(6436002)(71200400001)(53546011)(102836004)(26005)(7416002)(186003)(6506007)(81166006)(81156014)(2501003)(52536014)(5660300002)(8936002)(8676002)(74316002)(66476007)(6636002)(66946007)(64756008)(66556008)(229853002)(476003)(11346002)(305945005)(76116006)(76176011)(54906003)(110136005)(478600001)(316002)(14444005)(256004)(14454004)(7736002)(66446008)(486006)(25786009)(66066001)(86362001)(99286004)(6116002)(2906002)(33656002)(3846002)(446003)(4326008)(55016002)(7696005)(2201001)(9686003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1627;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 3rtQeFkR11YtJNa7B8rr2pVOz1j1KNiPoMmWTcnoopAGKt5FPU5Skq3UtG322E5jABVXaHVqx1+dCoHUyxOA3CCnQu0r9RLrT2fx0OC3+ZCdpec4NF+DkGPVzLL3N36H7mbBC/mMCDCM9rMG2E0jtjKUKxTEqMoJh8jj/6SRicyVItbP1SCu5lr/6M9Vn375sKswLhVOBH2dG3O1gaQylddrctiVuUGRIzMMBwktNunEHlg7bMWoPsTi58F7Mbwa3vzvfVyWPkyXk0BZH/VdOm9uoddB+450xDCwLQzttQX2scDzsnwvtuaWWZOTsO1DuVexj2LIv8zSvFL+nPC7KFVeBjKN2cOSFyAItAq41/qP/qNWJ6bUKAra18wDeU3stqIVBYmmr5Lxq1Yc206rBOQhZ5j4gfcx9vDaWrF50B0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1627
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(189003)(199004)(13464003)(23676004)(14454004)(8676002)(26005)(316002)(476003)(110136005)(63350400001)(9686003)(36906005)(70586007)(74316002)(8936002)(76130400001)(54906003)(6246003)(7736002)(81156014)(50466002)(5660300002)(229853002)(2906002)(450100002)(52536014)(81166006)(70206006)(2501003)(6116002)(66066001)(14444005)(2201001)(33656002)(26826003)(86362001)(102836004)(305945005)(55016002)(336012)(436003)(47776003)(22756006)(356004)(6636002)(53546011)(186003)(6506007)(478600001)(3846002)(99286004)(4326008)(25786009)(446003)(2486003)(11346002)(486006)(7696005)(126002)(76176011)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4434;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 872ef3cd-1b83-4a22-c404-08d743337660
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR08MB4434;
NoDisclaimer: True
X-Forefront-PRVS: 0173C6D4D5
X-Microsoft-Antispam-Message-Info: 4PtYOm8CPQiakURvpZOR0xCjS6D5WgbEMXLNyATbDrVy5/lWkfga2pk4e+xgDP/CF7k3E0TDG5UjMlmpzO+GyqZIbdA71wyx9H7HRrZhh6Rnxhr4+3orHqCcAdsxBtmcGQAH/mUbejJyECmTZcnyOMR0NBwLbabBjFulREih3t+OEHdGxCDZT+6spelyoCtJsrV4bdNrFoyjV6gaIj2yQOQehcVTTzCP6mjCC0bK7spde0kmg8evwAfDh7DTeIRHo1jqBqayeWqqcMJgctcjqXXqXCAzoGy/Eh5fElsh1P4xC5Z3VBKhEXz2VeqTInR4lbWSMCVvfRhCatmp4QBOBCu8grQR7nh94tPTZxMYAXRaqKc8Yc//zirjtEozQCvu0a6gsdCVqUUxhiIts28q5J+Ajg8r2ORGD+rj//3pNKI=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2019 10:14:33.3354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3af6abcb-133c-47ee-d634-08d743337e1a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4434
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3V6dWtpLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN1enVr
aSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgU2Vw
dGVtYmVyIDI3LCAyMDE5IDY6MTIgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9n
eSBDaGluYSkgPEppYW55b25nLld1QGFybS5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyB5YW5nYm8ubHVAbnhwLmNvbTsgam9obi5zdHVsdHpAbGluYXJvLm9yZzsNCj4gdGdseEBsaW51
dHJvbml4LmRlOyBwYm9uemluaUByZWRoYXQuY29tOyBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50
ZWwuY29tOw0KPiBtYXpAa2VybmVsLm9yZzsgcmljaGFyZGNvY2hyYW5AZ21haWwuY29tOyBNYXJr
IFJ1dGxhbmQNCj4gPE1hcmsuUnV0bGFuZEBhcm0uY29tPjsgV2lsbCBEZWFjb24gPFdpbGwuRGVh
Y29uQGFybS5jb20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1h
cm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHU7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFN0ZXZlIENhcHBlcg0KPiA8U3RldmUuQ2FwcGVy
QGFybS5jb20+OyBLYWx5IFhpbiAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+IDxLYWx5LlhpbkBh
cm0uY29tPjsgSnVzdGluIEhlIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEp1c3Rpbi5IZUBh
cm0uY29tPjsgbmQgPG5kQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHY0IDIv
NV0gcHRwOiBSZW9yZ2FuaXplIHB0cF9rdm0gbW9kdWxlcyB0byBtYWtlIGl0DQo+IGFyY2gtaW5k
ZXBlbmRlbnQuDQo+IA0KPiANCj4gDQo+IE9uIDI3LzA5LzIwMTkgMTE6MTAsIEppYW55b25nIFd1
IChBcm0gVGVjaG5vbG9neSBDaGluYSkgd3JvdGU6DQo+ID4gSGkgU3V6dWtpLA0KPiA+DQo+ID4+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFN1enVraSBLIFBvdWxvc2Ug
PHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIg
MjYsIDIwMTkgOTowNiBQTQ0KPiA+PiBUbzogSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENo
aW5hKSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47DQo+ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IHlhbmdiby5sdUBueHAuY29tOyBqb2huLnN0dWx0ekBsaW5hcm8ub3JnOw0KPiA+PiB0Z2x4QGxp
bnV0cm9uaXguZGU7IHBib256aW5pQHJlZGhhdC5jb207DQo+ID4+IHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb207IG1hekBrZXJuZWwub3JnOw0KPiA+PiByaWNoYXJkY29jaHJhbkBnbWFp
bC5jb207IE1hcmsgUnV0bGFuZCA8TWFyay5SdXRsYW5kQGFybS5jb20+Ow0KPiBXaWxsDQo+ID4+
IERlYWNvbiA8V2lsbC5EZWFjb25AYXJtLmNvbT4NCj4gPj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+ID4+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsN
Cj4gPj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdTsga3ZtQHZnZXIua2VybmVsLm9yZzsg
U3RldmUgQ2FwcGVyDQo+ID4+IDxTdGV2ZS5DYXBwZXJAYXJtLmNvbT47IEthbHkgWGluIChBcm0g
VGVjaG5vbG9neSBDaGluYSkNCj4gPj4gPEthbHkuWGluQGFybS5jb20+OyBKdXN0aW4gSGUgKEFy
bSBUZWNobm9sb2d5IENoaW5hKQ0KPiA+PiA8SnVzdGluLkhlQGFybS5jb20+OyBuZCA8bmRAYXJt
LmNvbT4NCj4gPj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjQgMi81XSBwdHA6IFJlb3JnYW5p
emUgcHRwX2t2bSBtb2R1bGVzIHRvDQo+ID4+IG1ha2UgaXQgYXJjaC1pbmRlcGVuZGVudC4NCj4g
Pj4NCj4gPj4gSGkgSmlhbnlvbmcsDQo+ID4+DQo+ID4+IE9uIDI2LzA5LzIwMTkgMTI6NDIsIEpp
YW55b25nIFd1IHdyb3RlOg0KPiA+Pj4gQ3VycmVudGx5LCBwdHBfa3ZtIG1vZHVsZXMgaW1wbGVt
ZW50YXRpb24gaXMgb25seSBmb3IgeDg2IHdoaWNoDQo+ID4+PiBpbmNsdWRzIGxhcmdlIHBhcnQg
b2YgYXJjaC1zcGVjaWZpYyBjb2RlLiAgVGhpcyBwYXRjaCBtb3ZlIGFsbCBvZg0KPiA+Pj4gdGhv
c2UgY29kZSBpbnRvIG5ldyBhcmNoIHJlbGF0ZWQgZmlsZSBpbiB0aGUgc2FtZSBkaXJlY3Rvcnku
DQo+ID4+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogSmlhbnlvbmcgV3UgPGppYW55b25nLnd1QGFy
bS5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICAgIGRyaXZlcnMvcHRwL01ha2VmaWxlICAgICAgICAg
ICAgICAgICB8ICAxICsNCj4gPj4+ICAgIGRyaXZlcnMvcHRwL3twdHBfa3ZtLmMgPT4ga3ZtX3B0
cC5jfSB8IDc3ICsrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+Pj4gICAgZHJpdmVycy9wdHAv
cHRwX2t2bV94ODYuYyAgICAgICAgICAgIHwgODcNCj4gPj4gKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KPiA+Pj4gICAgaW5jbHVkZS9hc20tZ2VuZXJpYy9wdHBfa3ZtLmggICAgICAgIHwg
MTIgKysrKw0KPiA+Pj4gICAgNCBmaWxlcyBjaGFuZ2VkLCAxMTggaW5zZXJ0aW9ucygrKSwgNTkg
ZGVsZXRpb25zKC0pDQo+ID4+PiAgICByZW5hbWUgZHJpdmVycy9wdHAve3B0cF9rdm0uYyA9PiBr
dm1fcHRwLmN9ICg2MyUpDQo+ID4+DQo+ID4+IG1pbm9yIG5pdDogQ291bGQgd2Ugbm90IHNraXAg
cmVuYW1pbmcgdGhlIGZpbGUgPyBHaXZlbiB5b3UgYXJlDQo+ID4+IGZvbGxvd2luZyB0aGUNCj4g
Pj4gcHRwX2t2bV8qIGZvciB0aGUgYXJjaCBzcGVjaWZpYyBmaWxlcyBhbmQgdGhlIGhlYWRlciBm
aWxlcywgd291bGRuJ3QNCj4gPj4gaXQgYmUgZ29vZCB0byBrZWVwIHB0cF9rdm0uYyA/DQo+ID4+
DQo+ID4gSWYgdGhlIG1vZHVsZSBuYW1lIHB0cF9rdm0ua28gaXMgdGhlIHNhbWUgd2l0aCBpdHMg
ZGVwZW5kZW50IG9iamVjdA0KPiA+IGZpbGUgcHRwX2t2bS5vLCB3YXJuaW5nIHdpbGwgYmUgZ2l2
ZW4gYnkgY29tcGlsZXIsIFNvIEkgY2hhbmdlIHRoZQ0KPiBwdHBfa3ZtLmMgdG8ga3ZtX3B0cC5j
IHRvIGF2b2lkIHRoYXQgY29uZmxpY3QuDQo+IA0KPiBIbW0sIG9rLiBIb3cgYWJvdXQgcHRwX2t2
bV9jb21tb24uYyBpbnN0ZWFkIG9mIGt2bV9wdHAuYyA/DQoNClllYWgsIGl0J3MgYSBiZXR0ZXIg
bmFtZSwgSSB3aWxsIGNoYW5nZSBpdCBuZXh0IHZlcnNpb24uDQoNClRoYW5rcw0KSmlhbnlvbmcg
V3UNCj4gDQo+IFN1enVraQ0K
