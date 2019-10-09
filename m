Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8477AD06DF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 07:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbfJIFVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 01:21:37 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:64388
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730342AbfJIFVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 01:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hq7LDTR4q0a5CpQhZSSxUkA+16ZVMblXsMozmdy6nnk=;
 b=bM0Ds8iFXU+3dB2YKOV9qv4TAtnUXYEYI7tEdu1ZXg3O7fCw4lVCHcU+SpvfbBKLNGgDgRjq0KchNUrfsmPn2Qz2rGSbtucVMqD4jPnQTngzxTVv+3tEk56j9jCkX8gn66wmDI326Xkme3FxvC/y0i0gsJJnJzWdwWFcOzGKprI=
Received: from VI1PR08CA0217.eurprd08.prod.outlook.com (2603:10a6:802:15::26)
 by AM6PR08MB4342.eurprd08.prod.outlook.com (2603:10a6:20b:b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2327.24; Wed, 9 Oct
 2019 05:21:29 +0000
Received: from VE1EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::204) by VI1PR08CA0217.outlook.office365.com
 (2603:10a6:802:15::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 9 Oct 2019 05:21:29 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT008.mail.protection.outlook.com (10.152.18.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 9 Oct 2019 05:21:26 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Wed, 09 Oct 2019 05:21:22 +0000
X-CR-MTA-TID: 64aa7808
Received: from a16d394a8436.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.0.52])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 029B9617-B73E-42CF-89E0-13040C75A9DD.1;
        Wed, 09 Oct 2019 05:21:17 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2052.outbound.protection.outlook.com [104.47.0.52])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a16d394a8436.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 09 Oct 2019 05:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJ5e1WPh/NhwgKIs77TaJKxdGIZRt2sgIBcb3nBXeq3FHqf4cV9QagAN8OR/OjstGyJYvOgWKHpiJbOqokE1MqJdYyTUrka798w5oUY9urbQX2Y8QtJPSCxMrag78rUKttSWnziL/8O0E9kHOFRMvFhcmmkX5SI+SBit0NiEUFDqa3ICTEuNXE8dFKtoUYuxwmUusvCqWx+6aikvS6vMe0TBzFvRUiBfwIaG2KCUQiqTWN/D/UVH+HKTJJmkTcWhpJ3KmYW4UPBAnsAF+JOgPOUHlvAO1kuUTHWehgweGyX/lNt1QUDag1TXGJv4cgeD7gEVUNQ77G8EgVM54tMgzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hq7LDTR4q0a5CpQhZSSxUkA+16ZVMblXsMozmdy6nnk=;
 b=V/hWFwc1GYsuEO5PrpzM38Kr5CcAF+26NJnLWMminSyTd6YeGal6VA4+n1XRo7fIdjm+Ero+qqKwGB9inaxI+R8IkzzEDIl6mdUqInQYsZcAwE//Jav2bhHQpQSS6+Asbs0zh7w2cDoWRYWSYC935bRKPkvrRyoKpCgjVNAAzMQOhiCIDn2JFuHrfkBKC0bsTEHxk0HiKV2QzNatmFhe5KiplKdSBGO+t5GGc7R2xRGG+f0ujBWhGKSeds1qSvvT8ym0AYL2tspNbVajltWfew2IDKiKMBQJ11wHPW4/BhNRuGnDz2HqhDEE0Nr2xfTqOz0GBlTyysa3gw8eFUNyNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hq7LDTR4q0a5CpQhZSSxUkA+16ZVMblXsMozmdy6nnk=;
 b=bM0Ds8iFXU+3dB2YKOV9qv4TAtnUXYEYI7tEdu1ZXg3O7fCw4lVCHcU+SpvfbBKLNGgDgRjq0KchNUrfsmPn2Qz2rGSbtucVMqD4jPnQTngzxTVv+3tEk56j9jCkX8gn66wmDI326Xkme3FxvC/y0i0gsJJnJzWdwWFcOzGKprI=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2091.eurprd08.prod.outlook.com (10.168.95.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 05:21:14 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 05:21:14 +0000
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
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhAgAAo7ACAAAjcAIAACYiAgB7418A=
Date:   Wed, 9 Oct 2019 05:21:13 +0000
Message-ID: <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
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
x-ts-tracking-id: 0332c8ce-b1c2-4bf0-a0fd-3e5ad07cc41a.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: b8dd3777-847b-4178-d418-08d74c788896
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2091:|HE1PR0801MB2091:|AM6PR08MB4342:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB43424895519CCEF9C5EC198CF4950@AM6PR08MB4342.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
x-forefront-prvs: 018577E36E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(13464003)(102836004)(86362001)(66476007)(99286004)(64756008)(66446008)(66556008)(6246003)(71190400001)(71200400001)(76176011)(6506007)(7696005)(55236004)(33656002)(66946007)(229853002)(305945005)(54906003)(110136005)(5660300002)(74316002)(316002)(53546011)(7736002)(2906002)(2201001)(52536014)(66066001)(4326008)(478600001)(25786009)(7416002)(6116002)(3846002)(14454004)(6636002)(9686003)(6436002)(55016002)(256004)(14444005)(2501003)(8936002)(81156014)(81166006)(186003)(26005)(486006)(11346002)(8676002)(446003)(476003)(76116006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2091;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: sbakS9+zkJJj313GZmp0zA1UXPN+KS03akwHlvplmNYnSFdtjqojqQy/oCkmLkz1MUhxIrwQEEXdTPbtwo3TWPQP1UbYoXgGdyxZC9S7rO7d+f4d3/I0kSxyjUHgbFItGI/8O8I2/FOJjLcBjiaKmrx6ZxZEiX39amsLXLwj0jaKXKJKk9w5cIBGne1ny5goMyifBsnzs6MEzH94ehUoUpbnaz87tBA7XxjcVoZQP1GQHSfFNtJXfw1coZ7ir7VOMzULyIdr1QaimIHYURHd9Y+eXZMOiv7SLWlBCwVsFmYkNKwTEM0mP3ikllL5YgWIxYCdS77cOO1e8UYTJX4uf7R43q3Z8ogkevJTesuOnoaSGoNOD/q9OQdLmTOFMfXey83aDjDnEtrGARabzqGVaQbgD+HwYsqhH9TwLaA89/c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2091
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT008.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(13464003)(189003)(199004)(81156014)(81166006)(478600001)(6506007)(53546011)(76176011)(14444005)(186003)(33656002)(26005)(8676002)(5660300002)(356004)(7696005)(26826003)(476003)(86362001)(52536014)(6636002)(11346002)(446003)(50466002)(6246003)(14454004)(25786009)(76130400001)(486006)(102836004)(70586007)(126002)(107886003)(450100002)(70206006)(36906005)(47776003)(74316002)(2501003)(22756006)(229853002)(55016002)(305945005)(6116002)(66066001)(3846002)(9686003)(110136005)(4326008)(54906003)(7736002)(99286004)(8936002)(2201001)(2906002)(436003)(63350400001)(2486003)(23676004)(336012)(316002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB4342;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 83a25e0e-af9f-4ac9-8595-08d74c788102
NoDisclaimer: True
X-Forefront-PRVS: 018577E36E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSjMt2UJ77B6pCkRFUKLWObEELHXpmAgEqx85JKLrBQdwWxU9NnoZdiv9y3iR/CNCj9NtL0tPSf98b4n2LLNksMQ6WVeYEQIoN7y67GiMfYk7GT/Hfi7Y+Z4wd/iO8m0LiiRlcc0z/rvhWAqWcSvavbqcf8HxAo88xfq/gGesoA+nnOPy166KKrvAVD6kYvZcnKYj78xeyDf2a8CvD/Ytk8WMrFzZu9nDV87P7Q++jlNNaQCRYSRLPDSrgEngahDW5oV4QULoylE/Bus/Qecvt7/BAWTIQXiMwUJE4mJQ29Qy232z6RA2Fd8a9RPgLrWX/Qe6gmQpFQ4almV5hy+QN0bkY2csme9R61vh8wgMY9JbCQAT4Zl6Ao1PS1YxbbtZy+zRo0DQZz0+y544NM3fbaYcf8/1eUZhh7o50uy6+4=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2019 05:21:26.5865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dd3777-847b-4178-d418-08d74c788896
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4342
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJl
ciAxOSwgMjAxOSA4OjEzIFBNDQo+IFRvOiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPjsg
SmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8SmlhbnlvbmcuV3VAYXJtLmNv
bT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHlhbmdiby5sdUBueHAuY29tOw0KPiBqb2huLnN0
dWx0ekBsaW5hcm8ub3JnOyB0Z2x4QGxpbnV0cm9uaXguZGU7IHNlYW4uai5jaHJpc3RvcGhlcnNv
bkBpbnRlbC5jb207DQo+IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgTWFyayBSdXRsYW5kIDxN
YXJrLlJ1dGxhbmRAYXJtLmNvbT47IFdpbGwNCj4gRGVhY29uIDxXaWxsLkRlYWNvbkBhcm0uY29t
PjsgU3V6dWtpIFBvdWxvc2UNCj4gPFN1enVraS5Qb3Vsb3NlQGFybS5jb20+DQo+IENjOiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBTdGV2ZSBDYXBw
ZXINCj4gPFN0ZXZlLkNhcHBlckBhcm0uY29tPjsgS2FseSBYaW4gKEFybSBUZWNobm9sb2d5IENo
aW5hKQ0KPiA8S2FseS5YaW5AYXJtLmNvbT47IEp1c3RpbiBIZSAoQXJtIFRlY2hub2xvZ3kgQ2hp
bmEpDQo+IDxKdXN0aW4uSGVAYXJtLmNvbT47IG5kIDxuZEBhcm0uY29tPjsgbGludXgtYXJtLQ0K
PiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2
MyA0LzZdIHBzY2k6IEFkZCBodmMgY2FsbCBzZXJ2aWNlIGZvciBwdHBfa3ZtLg0KPiANCj4gT24g
MTkvMDkvMTkgMTM6MzksIE1hcmMgWnluZ2llciB3cm90ZToNCj4gPj4gSSBkb24ndCB0aGluayBp
dCdzIHVnbHkgYnV0IG1vcmUgaW1wb3J0YW50LCB1c2luZyB0ay0+dGtyX21vbm8uY2xvY2sNCj4g
Pj4gaXMgaW5jb3JyZWN0LiAgU2VlIGhvdyB0aGUgeDg2IGNvZGUgaGFyZGNvZGVzICZrdm1fY2xv
Y2ssIGl0J3MgdGhlDQo+ID4+IHNhbWUgZm9yIEFSTS4NCj4gPiBOb3QgcmVhbGx5LiBUaGUgZ3Vl
c3Qga2VybmVsIGlzIGZyZWUgdG8gdXNlIGFueSBjbG9ja3NvdXJjZSBpdCB3aXNoZXMuDQo+IA0K
PiBVbmRlcnN0b29kLCBpbiBmYWN0IGl0J3MgdGhlIHNhbWUgb24geDg2Lg0KPiANCj4gSG93ZXZl
ciwgZm9yIFBUUCB0byB3b3JrLCB0aGUgY3ljbGVzIHZhbHVlIHJldHVybmVkIGJ5IHRoZSBjbG9j
a3NvdXJjZSBtdXN0DQo+IG1hdGNoIHRoZSBvbmUgcmV0dXJuZWQgYnkgdGhlIGh5cGVyY2FsbC4g
IFNvIGZvciBBUk0NCj4gZ2V0X2RldmljZV9zeXN0ZW1fY3Jvc3N0c3RhbXAgbXVzdCByZWNlaXZl
IHRoZSBhcmNoIHRpbWVyIGNsb2Nrc291cmNlLCBzbw0KPiB0aGF0IGl0IHdpbGwgcmV0dXJuIC1F
Tk9ERVYgaWYgdGhlIGFjdGl2ZSBjbG9ja3NvdXJjZSBpcyBhbnl0aGluZyBlbHNlLg0KPiANCkFz
IHB0cF9rdm0gY2xvY2sgaGFzIGZpeGVkIHRvIGFybSBhcmNoIHN5c3RlbSBjb3VudGVyIGluIHBh
dGNoIHNldCB2NCwgd2UgbmVlZCBjaGVjayBpZiB0aGUgY3VycmVudCBjbG9ja3NvdXJjZSBpcyBz
eXN0ZW0gY291bnRlciB3aGVuIHJldHVybiBjbG9jayBjeWNsZSBpbiBob3N0LA0Kc28gYSBoZWxw
ZXIgbmVlZGVkIHRvIHJldHVybiB0aGUgY3VycmVudCBjbG9ja3NvdXJjZS4NCkNvdWxkIEkgYWRk
IHRoaXMgaGVscGVyIGluIG5leHQgcGF0Y2ggc2V0Pw0KDQpUaGFua3MNCkppYW55b25nIHd1DQoN
Cj4gUGFvbG8NCj4gDQo+ID4gSW4gc29tZSBjYXNlcywgaXQgaXMgYWN0dWFsbHkgZGVzaXJhYmxl
IChsaWtlIHRoZXNlIGJyb2tlbiBzeXN0ZW1zDQo+ID4gdGhhdCBjYW5ub3QgdXNlIGFuIGluLWtl
cm5lbCBpcnFjaGlwLi4uKS4gTWF5YmUgaXQgaXMgdGhhdCBvbiB4ODYgdGhlDQo+ID4gZ3Vlc3Qg
b25seSB1c2VzIHRoZSBrdm1fY2xvY2ssIGJ1dCB0aGF0J3MgYSBtdWNoIGhhcmRlciBzZWxsIG9u
IEFSTS4NCj4gPiBUaGUgZmFjdCB0aGF0IHB0cF9rdm0gYXNzdW1lcyB0aGF0IHRoZSBjbG9ja3Nv
dXJjZSBpcyBmaXhlZCBkb2Vzbid0DQo+ID4gc2VlbSBjb3JyZWN0IGluIHRoYXQgY2FzZS4NCg0K
