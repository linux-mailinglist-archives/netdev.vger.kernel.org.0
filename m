Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581F5B60DF
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 11:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfIRJ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 05:57:28 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:37328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726676AbfIRJ51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 05:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjQnIimjXzmvXZKw6Ul+2qwLyb8Ra8tnhJv7axrllIc=;
 b=lqv89fkla2zA5SfZNAGEDpX2bD5ntgOM0MWGQc+JSxfzo1Wi8v+Kmw64oIqWFgSVNDm9t3MbUHAIP3vcigJtGdPwr9+5WDf/1XfsPiThL8Htfo7GfglwhXBXzTMlLMP0aOcFWlpHMOmSToyKeV9totZ8iJq5LF7Y5ydFivvYWvk=
Received: from HE1PR0802CA0006.eurprd08.prod.outlook.com (2603:10a6:3:bd::16)
 by AM5PR0801MB1762.eurprd08.prod.outlook.com (2603:10a6:203:39::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.24; Wed, 18 Sep
 2019 09:57:20 +0000
Received: from VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::208) by HE1PR0802CA0006.outlook.office365.com
 (2603:10a6:3:bd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Wed, 18 Sep 2019 09:57:20 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT036.mail.protection.outlook.com (10.152.19.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20 via Frontend Transport; Wed, 18 Sep 2019 09:57:19 +0000
Received: ("Tessian outbound d5a1f2820a4f:v31"); Wed, 18 Sep 2019 09:57:15 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8cc8e6ab4330.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.1.50])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D10562D6-0211-48EB-A680-C93540E75543.1;
        Wed, 18 Sep 2019 09:57:10 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01lp2050.outbound.protection.outlook.com [104.47.1.50])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8cc8e6ab4330.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 18 Sep 2019 09:57:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXn7U1hMHo3nlMXm0Vf6+MK+BC3YoWJkHMxmpEOLRpFzR1PwPYyN+nYlYZdQ47sIMcemL+xEROyl+pYpEDM+p3ftHmYDXvzA7XUrWpsI739Z/PQWYUsPjqkTwZwtvGjtH0UcR9K3GTK0JFK9fgGCg3yAeeHcnBXQhOPIgzvGmJfihe3jFOcEBuI8CDkeO2eDyqrDMraWru7CFlXSNqj8TfY7jVnQBbzx6DSkgyReX1OzLFOy4G8ZjTJ1+PUFYv9pwbVrD2nEYoLNQS8Zw16Z7i8Vl5J2skpQTMuKRyaTZAoz6ePMJx5hrAIUr5QgWstjsNiHhvPwshZmt7Cev4M3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjQnIimjXzmvXZKw6Ul+2qwLyb8Ra8tnhJv7axrllIc=;
 b=KBdIkM+jEYh5fiAzQEc+Ug3HBVJtn0Jg5OeN73JdUKSmPKieeqkqJ+AAYAsqse2WiETDZYHaTcmv2jJnsaTns+s37momLY2NeSKti0DKIJ7/6nqvMSfONT3pfzzWEHNaX0pY15kvxnzrIZKjXUOW4kf8ntjtfRvAMeoi5aUys1ZVnnDz3SiDRTmkFp9fgSYBDf2RLYw33dfO0eBQW3vN2TcSN5s/2u8ym8ZWSKkSWv21eRoskKwTwSV429NjotoNAcfSZ+zMXAOB2f2A2r5J36sQzb1AkLAcNdqnKGOTNXv2bMqwRiBViF7etY7fQvZKWbVy/9hnmvQkt+5bkzvrbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjQnIimjXzmvXZKw6Ul+2qwLyb8Ra8tnhJv7axrllIc=;
 b=lqv89fkla2zA5SfZNAGEDpX2bD5ntgOM0MWGQc+JSxfzo1Wi8v+Kmw64oIqWFgSVNDm9t3MbUHAIP3vcigJtGdPwr9+5WDf/1XfsPiThL8Htfo7GfglwhXBXzTMlLMP0aOcFWlpHMOmSToyKeV9totZ8iJq5LF7Y5ydFivvYWvk=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1787.eurprd08.prod.outlook.com (10.168.146.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Wed, 18 Sep 2019 09:57:07 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2263.023; Wed, 18 Sep
 2019 09:57:07 +0000
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
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMIA=
Date:   Wed, 18 Sep 2019 09:57:07 +0000
Message-ID: <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
In-Reply-To: <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 46568269-6997-43ca-80bd-9a8c34bd68fc.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 4b17771d-dcd3-44a5-5d8e-08d73c1e9811
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:HE1PR0801MB1787;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1787:|HE1PR0801MB1787:|AM5PR0801MB1762:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0801MB176255741D47722002822096F48E0@AM5PR0801MB1762.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 01644DCF4A
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(13464003)(189003)(199004)(102836004)(4326008)(7736002)(476003)(74316002)(81166006)(9686003)(2906002)(486006)(7696005)(66476007)(64756008)(66556008)(5660300002)(8676002)(66446008)(33656002)(81156014)(2201001)(7416002)(76176011)(66946007)(14454004)(86362001)(478600001)(446003)(229853002)(52536014)(11346002)(99286004)(316002)(71200400001)(6636002)(305945005)(71190400001)(25786009)(6436002)(3846002)(6246003)(8936002)(76116006)(6116002)(110136005)(54906003)(2501003)(256004)(55016002)(186003)(66066001)(55236004)(6506007)(26005)(53546011)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1787;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: WkLBeiX8l2LIH8S5ecJ+XMbDlIzf1yqVNmV2LRsnio/2bRdw51z2IImpisDmWo0stefyEdSthaSSO8+DWS7jjpgCUBjN4/0m0OSi6hrJ29qm7RirEtI1BNg+ZYAIuQc23zh5mSnFUJCzQqobH2qGPmzcyRvhUrS06BbhE25Uc28W1fe2VZaYU8+m1BbWz6hPjP2E8TbKYl6qjoau/pIgBlUOcDG/W1Ngkrjc5ysamK8G2tWxDhKsGMQbuHBXrrHd6N+zcnidfiqi3SE8wlYLshhtCw0QSoUVoccGySvlJ8NgRHjROqp+zix8pYFf9wDvvmOjxDyYGohvflRu5JinIz6D1XDzxSdSVpZaT48rRR2P8zN/YrKF/DPa2A0N50Zko+Yhvk5iy54yjb0lcO+Qe+iEZ/2462Wz0T1TA5K6S5c=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1787
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(189003)(13464003)(199004)(66066001)(7736002)(47776003)(7696005)(50466002)(33656002)(74316002)(55016002)(26005)(52536014)(356004)(8676002)(23676004)(2486003)(126002)(76130400001)(99286004)(5660300002)(9686003)(81156014)(53546011)(14454004)(486006)(81166006)(6636002)(102836004)(4326008)(6506007)(8936002)(76176011)(2501003)(476003)(316002)(186003)(26826003)(11346002)(446003)(305945005)(336012)(6246003)(54906003)(110136005)(2201001)(107886003)(450100002)(22756006)(436003)(478600001)(36906005)(3846002)(229853002)(86362001)(25786009)(2906002)(6116002)(63350400001)(70206006)(70586007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0801MB1762;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 221b1757-c335-4dd5-3b20-08d73c1e9132
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM5PR0801MB1762;
NoDisclaimer: True
X-Forefront-PRVS: 01644DCF4A
X-Microsoft-Antispam-Message-Info: OIBYAmyD9/ZL6zOVSVUkoUp/yTPZ2ynp7XvYNEhxACcyqUPkNpdxmBeW2E9fTxNLBwqpPbPhAalASzVTSRObYlGX5Fx4JuKcfugONCoktTEJGnn+ZMCpkx+BKrygXIA/pAFMIAevZ7nTP2EiKlqOkPhNo6D54hakWFINVXuPjh+8esxfvnz5ORuP2FL0Lq2vewmWEJ+L2cXbbq/p3AfanIrL17n23At8G+c1n175qHnuEQgSxjbV0P9pu9aw1uAdJeYLLTdQ34jkTQKm0DTihPSpRwo0CS7dX1VQSKf3SUilar8w9U1l6bEzTNiu2X/Ft+fKbsEqjsh8oDKskN8JseftJ9tk3jgrGx4dhGYicHqDMefMISjNoY8I0o6s1+X6tFMvCg+nTl3VfBOQLU0AUryBWsMeWnc8652zyTLAATo=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2019 09:57:19.2303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b17771d-dcd3-44a5-5d8e-08d73c1e9811
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1762
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1i
ZXIgMTgsIDIwMTkgNDoyNiBQTQ0KPiBUbzogSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENo
aW5hKSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHlh
bmdiby5sdUBueHAuY29tOyBqb2huLnN0dWx0ekBsaW5hcm8ub3JnOw0KPiB0Z2x4QGxpbnV0cm9u
aXguZGU7IHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb207IG1hekBrZXJuZWwub3JnOw0K
PiByaWNoYXJkY29jaHJhbkBnbWFpbC5jb207IE1hcmsgUnV0bGFuZCA8TWFyay5SdXRsYW5kQGFy
bS5jb20+OyBXaWxsDQo+IERlYWNvbiA8V2lsbC5EZWFjb25AYXJtLmNvbT47IFN1enVraSBQb3Vs
b3NlDQo+IDxTdXp1a2kuUG91bG9zZUBhcm0uY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgU3RldmUgQ2FwcGVyDQo+IDxTdGV2ZS5D
YXBwZXJAYXJtLmNvbT47IEthbHkgWGluIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEthbHku
WGluQGFybS5jb20+OyBKdXN0aW4gSGUgKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8SnVzdGlu
LkhlQGFybS5jb20+OyBuZCA8bmRAYXJtLmNvbT47IGxpbnV4LWFybS0NCj4ga2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjMgNC82XSBwc2NpOiBB
ZGQgaHZjIGNhbGwgc2VydmljZSBmb3IgcHRwX2t2bS4NCj4gDQo+IE9uIDE4LzA5LzE5IDEwOjA3
LCBKaWFueW9uZyBXdSB3cm90ZToNCj4gPiArCWNhc2UgQVJNX1NNQ0NDX1ZFTkRPUl9IWVBfS1ZN
X1BUUF9GVU5DX0lEOg0KPiA+ICsJCWdldG5zdGltZW9mZGF5KHRzKTsNCj4gDQo+IFRoaXMgaXMg
bm90IFkyMDM4LXNhZmUuICBQbGVhc2UgdXNlIGt0aW1lX2dldF9yZWFsX3RzNjQgaW5zdGVhZCwg
YW5kIHNwbGl0IHRoZQ0KPiA2NC1iaXQgc2Vjb25kcyB2YWx1ZSBiZXR3ZWVuIHZhbFswXSBhbmQg
dmFsWzFdLg0KPiANCkFzIGZhciBhcyBJIGtub3csIHkyMDM4LXNhZmUgd2lsbCBvbmx5IGFmZmVj
dCBzaWduZWQgMzItYml0IGludGVnZXIsIGhvdyBkb2VzIGl0IGFmZmVjdCA2NC1iaXQgaW50ZWdl
cj8NCkFuZCB3aHkgc3BsaXQgNjQtYml0IG51bWJlciBpbnRvIHR3byBibG9ja3MgaXMgbmVjZXNz
YXJ5Pw0KQWxzbywgc3BsaXQgbnVtYmVyIHdpbGwgbGVhZCB0byBzaG9ydGFnZSBvZiByZXR1cm4g
dmFsdWUuDQogDQo+IEhvd2V2ZXIsIGl0IHNlZW1zIHRvIG1lIHRoYXQgdGhlIG5ldyBmdW5jdGlv
biBpcyBub3QgbmVlZGVkIGFuZCB5b3UgY2FuDQo+IGp1c3QgdXNlIGt0aW1lX2dldF9zbmFwc2hv
dC4gIFlvdSdsbCBnZXQgdGhlIHRpbWUgaW4gc3lzdGltZV9zbmFwc2hvdC0+cmVhbA0KPiBhbmQg
dGhlIGN5Y2xlcyB2YWx1ZSBpbiBzeXN0aW1lX3NuYXBzaG90LT5jeWNsZXMuDQoNClNlZSBwYXRj
aCA1LzYsIEkgbmVlZCBib3RoIGNvdW50ZXIgY3ljbGUgYW5kIGNsb2Nrc291cmNlLCBrdGltZV9n
ZXRfc25hcHNob3Qgc2VlbXMgb25seSBvZmZlciBjeWNsZXMuDQogIA0KPiANCj4gPiArCQlnZXRf
Y3VycmVudF9jb3VudGVydmFsKCZzYyk7DQo+ID4gKwkJdmFsWzBdID0gdHMtPnR2X3NlYzsNCj4g
PiArCQl2YWxbMV0gPSB0cy0+dHZfbnNlYzsNCj4gPiArCQl2YWxbMl0gPSBzYy5jeWNsZXM7DQo+
ID4gKwkJdmFsWzNdID0gMDsNCj4gPiArCQlicmVhazsNCj4gDQo+IFRoaXMgc2hvdWxkIHJldHVy
biBhIGd1ZXN0LWN5Y2xlcyB2YWx1ZS4gIElmIHRoZSBjeWNsZXMgdmFsdWVzIGFsd2F5cyB0aGUg
c2FtZQ0KPiBiZXR3ZWVuIHRoZSBob3N0IGFuZCB0aGUgZ3Vlc3Qgb24gQVJNLCB0aGVuIG9rYXku
ICBJZiBub3QsIHlvdSBoYXZlIHRvDQo+IGFwcGx5IHdoYXRldmVyIG9mZnNldCBleGlzdHMuDQo+
IA0KSW4gbXkgb3Bpbmlvbiwgd2hlbiB1c2UgcHRwX2t2bSBhcyBjbG9jayBzb3VyY2VzIHRvIHN5
bmMgdGltZSBiZXR3ZWVuIGhvc3QgYW5kIGd1ZXN0LCB1c2VyIHNob3VsZCBwcm9taXNlIHRoZSBn
dWVzdCBhbmQgaG9zdCBoYXMgbm8NCmNsb2NrIG9mZnNldC4gU28gd2UgY2FuIGJlIHN1cmUgdGhh
dCB0aGUgY3ljbGUgYmV0d2VlbiBndWVzdCBhbmQgaG9zdCBzaG91bGQgYmUga2VlcCBjb25zaXN0
ZW50LiBCdXQgSSBuZWVkIGNoZWNrIGl0Lg0KSSB0aGluayBob3N0IGN5Y2xlIHNob3VsZCBiZSBy
ZXR1cm5lZCB0byBndWVzdCBhcyB3ZSBzaG91bGQgcHJvbWlzZSB3ZSBnZXQgY2xvY2sgYW5kIGNv
dW50ZXIgaW4gdGhlIHNhbWUgdGltZS4NCg0KVGhhbmtzDQpKaWFueW9uZyBXdQ0KDQo+IFRoYW5r
cywNCj4gDQo+IFBhb2xvDQoNCg==
