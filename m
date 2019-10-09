Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA29BD0979
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfJIITQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:19:16 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:22524
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbfJIITP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 04:19:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LovM6wvE2FNQT0LT/WY/odL2Gqs8IfHD91MvKp4ckQs=;
 b=DhxPmsRUsbhl3sycth0Ju/o/D/xdKPJc0Vg4p8n3nQpKoUZS/8Kbwzg+Cv6ZNzkN5BJORDKco7rqYv/NABprhz9L65NVVO55vFsb2MwJ51aI4U8nS/ZKt2b7aNXR0lL1NkGzgfpBp/c7lHrQcnc9nRTub5pLuC5kmxeZk3bclvs=
Received: from VE1PR08CA0017.eurprd08.prod.outlook.com (2603:10a6:803:104::30)
 by DB6PR08MB2629.eurprd08.prod.outlook.com (2603:10a6:6:22::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2327.24; Wed, 9 Oct
 2019 08:19:04 +0000
Received: from DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::200) by VE1PR08CA0017.outlook.office365.com
 (2603:10a6:803:104::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 9 Oct 2019 08:19:04 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT046.mail.protection.outlook.com (10.152.21.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 9 Oct 2019 08:19:02 +0000
Received: ("Tessian outbound 3fba803f6da3:v33"); Wed, 09 Oct 2019 08:18:56 +0000
X-CR-MTA-TID: 64aa7808
Received: from b6ba294ff628.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.10.51])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 47ED5A7E-4C35-4BCC-8C98-81C989C7C128.1;
        Wed, 09 Oct 2019 08:18:51 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b6ba294ff628.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Wed, 09 Oct 2019 08:18:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKVLnI6zvPBablkWcyp24S/aVV25EQsnBo8kqU3UCj4URIPIMaa8yA4VOmw69FDUZOl98rTVpkpaLVFQzeHOT4R69GiQLY6sxVSTgAFnMcBUFxY1oUzA92ty1YoLeYe/rxTQ6hv7eanvJH4XnOdkrJt0kAH+0JRDCcsOQBnNm8IFwdh3WQfLAhlzk6ZmJtwRoqldG+79Jwr+0H9gZrMmz6MAWYZCliCdoytu1jRi5CmWtI9pCvyQc0xB/+7WMpLkD5akimVqLDCoBxOzHvyth3gI603f2E+f11q80YM+ZOhC+yy189eKk3K1eod05+RSJnJJKNg/JLbPHpW30k+J/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LovM6wvE2FNQT0LT/WY/odL2Gqs8IfHD91MvKp4ckQs=;
 b=eArrd87MmJHHW6k+1OHLsPXXDBrooaOU47jGya1ehiDOmdYedXuPzd4/PuIUz9qJ0Je5JOqI3bMB1zNALACapaILjf0ifxCke1kwIIQI+1uYD/4pJ7GHaaAwdVnCKwOnAuzR1P26Xzn7kHnSSi92R9VsOFUjy1/rLHrZaZlMzqcK58OBz+K5IsQQb6sT4Ie5tpZhOP3EgvzPALMkZ0K5YS3wEza9/ybu0XCsHUYOS7HVhM+IZ/cf7czSd5p9Puw910pvA1DFEb92sQ9gE86bBY+te8ddBKV94tlYP9cPGkRyUH5eWxtmFL8Y9VtNDX0um92W/EzfcDWEETiWPaUXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LovM6wvE2FNQT0LT/WY/odL2Gqs8IfHD91MvKp4ckQs=;
 b=DhxPmsRUsbhl3sycth0Ju/o/D/xdKPJc0Vg4p8n3nQpKoUZS/8Kbwzg+Cv6ZNzkN5BJORDKco7rqYv/NABprhz9L65NVVO55vFsb2MwJ51aI4U8nS/ZKt2b7aNXR0lL1NkGzgfpBp/c7lHrQcnc9nRTub5pLuC5kmxeZk3bclvs=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1804.eurprd08.prod.outlook.com (10.168.150.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.25; Wed, 9 Oct 2019 08:18:48 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 08:18:47 +0000
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
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhAgAAo7ACAAAjcAIAACYiAgB7418CAABeSAIAAGcHg
Date:   Wed, 9 Oct 2019 08:18:47 +0000
Message-ID: <HE1PR0801MB1676B1AD68544561403C3196F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
 <a1b554b8-4417-5305-3419-fe71a8c50842@kernel.org>
 <56a5b885-62c8-c4ef-e2f8-e945c0eb700e@redhat.com>
 <HE1PR0801MB1676115C248E6DF09F9DD5A6F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com>
In-Reply-To: <1cc145ca-1af2-d46f-d530-0ae434005f0b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7edb023d-6344-4990-8295-8b48b11cd589.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: fe90ef95-b7d0-496c-1684-08d74c9157cf
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1804:|HE1PR0801MB1804:|DB6PR08MB2629:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR08MB2629ED2419B654F638E8EE3AF4950@DB6PR08MB2629.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 018577E36E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(199004)(189003)(13464003)(486006)(305945005)(7696005)(74316002)(53546011)(52536014)(110136005)(33656002)(478600001)(25786009)(2201001)(476003)(5660300002)(86362001)(7736002)(8936002)(8676002)(446003)(186003)(6636002)(11346002)(316002)(102836004)(26005)(6506007)(76176011)(55236004)(54906003)(99286004)(81166006)(81156014)(9686003)(229853002)(71200400001)(64756008)(66476007)(256004)(6116002)(76116006)(4326008)(66446008)(71190400001)(7416002)(66946007)(2501003)(66556008)(6436002)(14454004)(2906002)(66066001)(3846002)(55016002)(6246003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1804;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: IIJquPyoT8b5queayz+oQKbgVH6HNNWZz8pG8q6SyMGv/1FgMkZPRXZQhABYAH+KesDXJgkANJKBAG+u1pReDbOhAEDdkvM+XY/664X3eJ97+VLVzKuYesz351+xBHMXHAu0hJ1UDaJFzA0i7Mq7gTdjJt45hWQOX/aT/ypygppa25cnPoB+/lYKEPuErrsYLtq6out/0tmN/gUm+Pey5wKVbKuOBgy4AXQMhQ98jdXA698FJDI8+QH9wX52LfIH9k2Li8R/rF0l4O9qPYWPB37xbqGjCHB+H8RRcHoXhVfItGLVKd5USL0SX/X5t6mlRrcIbsTITguvSZH3dMrY4mlhYjfU7sOMxwhrEbUcSZOL86T++xsahqZi4h56Hkc2emaIAi+WNZW1FVmg4xzQtrtAf4z0Xr/gqY0Kg11lkp8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1804
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(376002)(189003)(199004)(13464003)(81156014)(22756006)(81166006)(8676002)(107886003)(102836004)(66066001)(2906002)(6506007)(53546011)(54906003)(110136005)(47776003)(8936002)(229853002)(52536014)(7696005)(55016002)(186003)(6246003)(23676004)(7736002)(2486003)(74316002)(76176011)(2501003)(305945005)(486006)(86362001)(2201001)(99286004)(126002)(25786009)(478600001)(26826003)(33656002)(436003)(336012)(50466002)(9686003)(11346002)(63350400001)(14454004)(316002)(76130400001)(6636002)(450100002)(26005)(4326008)(6116002)(356004)(3846002)(5660300002)(70206006)(70586007)(476003)(446003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR08MB2629;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 89651d3d-fec1-45dd-9bdf-08d74c914f44
NoDisclaimer: True
X-Forefront-PRVS: 018577E36E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+q58H6JOq4PcyAXYFElEoA9GO/26MPP9SJV1U/AJaUK61uvGk9shqceSALdOoLbKVuzZ6GnlqgPKjY6dsOJ0KiriWDf9x8xYQ5TVDMhXdVunnn7a+tfn6e5ZcuklEn47wGA7t5xymkyZx0Tul/k+CC+1wtx0UEFZnqCyfn7+CnXShD4A7HeGxiCTGjSsi3bBIFwc/diVmkyqX/Zw/D2eyX1OPjMxiHbyQTbTiS7jNEtAQBFyxPowxqH32poaUeE1CXfkYISntOqNQ7JfBZV0pQlTczw1c9xH/dNhzpYXuyEu45i3f/mdbB7PeXOunU0RN8llwzlhaMr+H3mdh/i0LwB9Hp+rIHiklD05uBPv3dgxStM1TD4Z1eH8C31U7RT2vdooNJlX9HcX5iE6wOPq8klb/rto5+uoQBLssN6rrA=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2019 08:19:02.2542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe90ef95-b7d0-496c-1684-08d74c9157cf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2629
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDksIDIwMTkgMjozNiBQTQ0KPiBUbzogSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENoaW5h
KSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47IE1hcmMNCj4gWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyB5YW5nYm8ubHVAbnhwLmNvbTsNCj4gam9obi5zdHVs
dHpAbGluYXJvLm9yZzsgdGdseEBsaW51dHJvbml4LmRlOyBzZWFuLmouY2hyaXN0b3BoZXJzb25A
aW50ZWwuY29tOw0KPiByaWNoYXJkY29jaHJhbkBnbWFpbC5jb207IE1hcmsgUnV0bGFuZCA8TWFy
ay5SdXRsYW5kQGFybS5jb20+OyBXaWxsDQo+IERlYWNvbiA8V2lsbC5EZWFjb25AYXJtLmNvbT47
IFN1enVraSBQb3Vsb3NlDQo+IDxTdXp1a2kuUG91bG9zZUBhcm0uY29tPg0KPiBDYzogbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgU3RldmUgQ2FwcGVy
DQo+IDxTdGV2ZS5DYXBwZXJAYXJtLmNvbT47IEthbHkgWGluIChBcm0gVGVjaG5vbG9neSBDaGlu
YSkNCj4gPEthbHkuWGluQGFybS5jb20+OyBKdXN0aW4gSGUgKEFybSBUZWNobm9sb2d5IENoaW5h
KQ0KPiA8SnVzdGluLkhlQGFybS5jb20+OyBuZCA8bmRAYXJtLmNvbT47IGxpbnV4LWFybS0NCj4g
a2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjMg
NC82XSBwc2NpOiBBZGQgaHZjIGNhbGwgc2VydmljZSBmb3IgcHRwX2t2bS4NCj4gDQo+IE9uIDA5
LzEwLzE5IDA3OjIxLCBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIHdyb3RlOg0K
PiA+IEFzIHB0cF9rdm0gY2xvY2sgaGFzIGZpeGVkIHRvIGFybSBhcmNoIHN5c3RlbSBjb3VudGVy
IGluIHBhdGNoIHNldCB2NCwNCj4gPiB3ZSBuZWVkIGNoZWNrIGlmIHRoZSBjdXJyZW50IGNsb2Nr
c291cmNlIGlzIHN5c3RlbSBjb3VudGVyIHdoZW4gcmV0dXJuDQo+ID4gY2xvY2sgY3ljbGUgaW4g
aG9zdCwgc28gYSBoZWxwZXIgbmVlZGVkIHRvIHJldHVybiB0aGUgY3VycmVudA0KPiA+IGNsb2Nr
c291cmNlLiBDb3VsZCBJIGFkZCB0aGlzIGhlbHBlciBpbiBuZXh0IHBhdGNoIHNldD8NCj4gDQo+
IFlvdSBkb24ndCBuZWVkIGEgaGVscGVyLiAgWW91IG5lZWQgdG8gcmV0dXJuIHRoZSBBUk0gYXJj
aCBjb3VudGVyDQo+IGNsb2Nrc291cmNlIGluIHRoZSBzdHJ1Y3Qgc3lzdGVtX2NvdW50ZXJ2YWxf
dCB0aGF0IHlvdSByZXR1cm4uDQo+IGdldF9kZXZpY2Vfc3lzdGVtX2Nyb3NzdHN0YW1wIHdpbGwg
dGhlbiBjaGVjayB0aGF0IHRoZSBjbG9ja3NvdXJjZQ0KPiBtYXRjaGVzIHRoZSBhY3RpdmUgb25l
Lg0KPiANCldlIG11c3QgZW5zdXJlIGJvdGggb2YgdGhlIGhvc3QgYW5kIGd1ZXN0IHVzaW5nIHRo
ZSBzYW1lIGNsb2Nrc291cmNlLg0KZ2V0X2RldmljZV9zeXN0ZW1fY3Jvc3N0c3RhbXAgd2lsbCBj
aGVjayB0aGUgY2xvY2tzb3VyY2Ugb2YgZ3Vlc3QgYW5kIHdlIGFsc28gbmVlZCBjaGVjaw0KdGhl
IGNsb2Nrc291cmNlIGluIGhvc3QsIGFuZCBzdHJ1Y3QgdHlwZSBjYW4ndCBiZSB0cmFuc2ZlcnJl
ZCBmcm9tIGhvc3QgdG8gZ3Vlc3QgdXNpbmcgYXJtIGh5cGVyY2FsbC4NCm5vdyB3ZSBsYWNrIG9m
IGEgbWVjaGFuaXNtIHRvIGNoZWNrIHRoZSBjdXJyZW50IGNsb2Nrc291cmNlLiBJIHRoaW5rIHRo
aXMgd2lsbCBiZSB1c2VmdWwgaWYgd2UgYWRkIG9uZS4NCg0KVGhhbmtzDQpKaWFueW9uZyAgV3UN
Cg0KPiBQYW9sbw0KDQo=
