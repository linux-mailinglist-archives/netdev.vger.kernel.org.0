Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF194D5AE5
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 07:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfJNFuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 01:50:32 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:24992
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfJNFuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 01:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dA6JZxMaj5cWNl285wnkDJljeQu5X7emMbHJzZU0d0=;
 b=TkSWKJrxyG0vckNXsIEXbSr8rX4zOZ21kXmvyKdw6DUo5iNcEJpmJ+gjMlUDYbdLnV6FrKofbbl1vQW+FT4NlreNQPYJ6GmN7mephvAs/t/zwlWlbFa6U2hertZ/Yq2L3A5Bo8AsBm8aSUJ42wcRQqRVpW/8hMgYCr2XvwTo2aU=
Received: from HE1PR0802CA0016.eurprd08.prod.outlook.com (2603:10a6:3:bd::26)
 by DB7PR08MB2954.eurprd08.prod.outlook.com (2603:10a6:5:1c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.21; Mon, 14 Oct
 2019 05:50:19 +0000
Received: from AM5EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::205) by HE1PR0802CA0016.outlook.office365.com
 (2603:10a6:3:bd::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16 via Frontend
 Transport; Mon, 14 Oct 2019 05:50:19 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT003.mail.protection.outlook.com (10.152.16.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15 via Frontend Transport; Mon, 14 Oct 2019 05:50:16 +0000
Received: ("Tessian outbound 3fba803f6da3:v33"); Mon, 14 Oct 2019 05:50:11 +0000
X-CR-MTA-TID: 64aa7808
Received: from ec8b2b66c175.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.9.54])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 99D3134D-D85A-43DE-8904-E271A0923EEF.1;
        Mon, 14 Oct 2019 05:50:05 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-ve1eur03lp2054.outbound.protection.outlook.com [104.47.9.54])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ec8b2b66c175.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Mon, 14 Oct 2019 05:50:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJyGsb2u4dNIIBV42QUymTnvfVAnCiqO/QOamqHwtaoGzWLl1yNu+JUqKCX2DNNcZBU9JniplJ2xx1XFMnNREeKunbt0R0V5E5hlLMIvYBzgPtkLSXDVNfhToyw8OQzcu45h9iFyZxXvR/dVCYTWMcTgitub4+AntkRr20jZFWGUFo52+f/YUNz38PdBZ0FiZodnZoHyUTELgEL+l6PvOuhVFknoKAlk/LEtYRNJR5DqDwyBrcywsZc7Zmm5bpA5d677mOQVYh2n0e3CTjKlOF0aoQvxn13BtUgEFL7QvxuPhQkIXisgijshLwCuljvNPAEEoZUAxwHyOB1OQJGZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dA6JZxMaj5cWNl285wnkDJljeQu5X7emMbHJzZU0d0=;
 b=G0UHiHCbFiHpTJ6lR+vbL8u/PGftQrz9IYzkCigieMgvOxOIG5d+oX6oh5h67hrOfZa9H9TUVYkPdoeMSVcl8QOo9A/0VqHjRnBKc3B3UpqrkIsPAM5G5Dhf4UVaJIeIdhwfdaFBY53/XmAFCuQC5orjHYoUdNlBzBZ+RChifnZdz4iRxLsvrpUN6IcfQpwFvAFVCbwgV8Xx8o16VPDN7PifEwob1WbEByghZDxut358MLnYNWWVVhp0Znw682La93+i2qJfCVPdgmx4HGKIdNYrNeJcksb1IgZVcVBaJTUDrlsddiMP1fpuXFBLCpDhOrxCyOuuGgMhdPmX9TXmQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dA6JZxMaj5cWNl285wnkDJljeQu5X7emMbHJzZU0d0=;
 b=TkSWKJrxyG0vckNXsIEXbSr8rX4zOZ21kXmvyKdw6DUo5iNcEJpmJ+gjMlUDYbdLnV6FrKofbbl1vQW+FT4NlreNQPYJ6GmN7mephvAs/t/zwlWlbFa6U2hertZ/Yq2L3A5Bo8AsBm8aSUJ42wcRQqRVpW/8hMgYCr2XvwTo2aU=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1641.eurprd08.prod.outlook.com (10.168.146.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 14 Oct 2019 05:50:03 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.021; Mon, 14 Oct 2019
 05:50:02 +0000
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
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhAgAAo7ACAAAjcAIAACYiAgB7418CAABeSAIAAGcHggAASOoCAB6JbIA==
Date:   Mon, 14 Oct 2019 05:50:02 +0000
Message-ID: <HE1PR0801MB167635A4AA59FD93C45872E4F4900@HE1PR0801MB1676.eurprd08.prod.outlook.com>
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
 <HE1PR0801MB1676B1AD68544561403C3196F4950@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <6b8b59b2-a07e-7e33-588c-1da7658e3f1e@redhat.com>
In-Reply-To: <6b8b59b2-a07e-7e33-588c-1da7658e3f1e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 38df8d37-9067-49cf-ac81-7eff5440a728.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: a2226f0a-f2e8-4133-c86b-08d7506a63f5
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1641:|HE1PR0801MB1641:|DB7PR08MB2954:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB295486C9CB2F523493D73836F4900@DB7PR08MB2954.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 01901B3451
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(13464003)(199004)(189003)(3846002)(316002)(71190400001)(7736002)(6116002)(256004)(8676002)(14454004)(74316002)(305945005)(478600001)(7416002)(2501003)(2906002)(33656002)(71200400001)(76116006)(229853002)(66946007)(6436002)(55016002)(8936002)(81166006)(66476007)(66556008)(66446008)(81156014)(64756008)(2201001)(25786009)(86362001)(9686003)(4326008)(6636002)(6246003)(66066001)(102836004)(6506007)(55236004)(99286004)(26005)(52536014)(53546011)(486006)(76176011)(54906003)(11346002)(7696005)(446003)(110136005)(5660300002)(476003)(186003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1641;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ZHp02lbuaVdF6D5mQ4Cnt5pbvVIGv5GQSVpP166m8PvB/LMHI6jo7UNkYU8G9nWXBp5yaVMf1OSP8pkpXBPZ+Yr50O+Ec35Q1Vgnr8QquQ7qAf2htI9XoAW7Isxo3I7qNk0kafDVkUHT/ud8VviM0IOn12aas9l3iYsc/w9K9tCQ6BPgdmrLF5I5rzzIDPQqcmnB3Mv0qzB4iAsA0wkt1VDmGYWwbn2tiwSCpKzJ37lFciDLXbIJXyyHMQxBuj+vVJBJjBp1VvllRwFjHBHUi5Rx5aIDgSC4jkJeN7V9Uxsqn+e0yaxE0PUh2EBi6ZQ9/gqzvCnL1xHaLcH+QhJJC1dSOGCI5EX/87qij2vFAhE2o+3N1GkzAzH8Bpzct2LGS/QCia0/kqnzSuA8EPWtAYQe2w8ZaOiWEv/k892P0EU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1641
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(39860400002)(346002)(189003)(199004)(13464003)(6636002)(63350400001)(446003)(436003)(336012)(11346002)(486006)(74316002)(2906002)(126002)(7736002)(476003)(3846002)(305945005)(6116002)(55016002)(229853002)(22756006)(9686003)(107886003)(6246003)(4326008)(70586007)(70206006)(6506007)(8936002)(76130400001)(8676002)(81156014)(81166006)(186003)(76176011)(47776003)(7696005)(50466002)(36906005)(99286004)(25786009)(450100002)(5660300002)(2201001)(26005)(86362001)(2486003)(478600001)(356004)(316002)(26826003)(52536014)(14454004)(66066001)(102836004)(53546011)(54906003)(2501003)(33656002)(110136005)(23676004)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR08MB2954;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 2d65b43b-27c7-4576-c912-08d7506a5b94
NoDisclaimer: True
X-Forefront-PRVS: 01901B3451
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDqF094aktPOXa1VSuiJWAonSJY1al4eh7mPM42w1jc/vyJPwgALgN2r2oXabZ7cat+TXXs1geBteI/tgvfDoBtGRtwiBQUfLVa/SwutgiXe0W0TZEyNfC3kSanx3pJ38sfHJaJVEMEq87wYLcL4UcQsGMyhuxdzlkF0YeD4fU76c+3T/U111ebiiSazBYl4HfXjSjGgxS7Gq5EFdrZuo0GR7QF8wh9UNavfWRnG2efNpIFdyQ2Jh2yWIrTzU9WzvkU1LndF/KQnkoTBSo0m8zwcDJqD5bWSlTjbwYNtWH/pocGEGOM5kZxDQDyQ2jvToR0XUGvOBpozbl0uOYTC53TZ8TyiP/Ea1g+1LMwKS5+1LMsF2whmO8NYudNISTGtQ4I+L7ZUJzHXMkRC3HM6xPr88rRwqpDEt4x6PH3quXE=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2019 05:50:16.8871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2226f0a-f2e8-4133-c86b-08d7506a63f5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB2954
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDksIDIwMTkgNToxMyBQTQ0KPiBUbzogSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENoaW5h
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
LzEwLzE5IDEwOjE4LCBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIHdyb3RlOg0K
PiA+IEhpIFBhb2xvLA0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+
IEZyb206IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQo+ID4+IFNlbnQ6IFdl
ZG5lc2RheSwgT2N0b2JlciA5LCAyMDE5IDI6MzYgUE0NCj4gPj4gVG86IEppYW55b25nIFd1IChB
cm0gVGVjaG5vbG9neSBDaGluYSkgPEppYW55b25nLld1QGFybS5jb20+OyBNYXJjDQo+ID4+IFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4geWFuZ2Jv
Lmx1QG54cC5jb207DQo+ID4+IGpvaG4uc3R1bHR6QGxpbmFyby5vcmc7IHRnbHhAbGludXRyb25p
eC5kZTsNCj4gPj4gc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsgcmljaGFyZGNvY2hy
YW5AZ21haWwuY29tOyBNYXJrDQo+ID4+IFJ1dGxhbmQgPE1hcmsuUnV0bGFuZEBhcm0uY29tPjsg
V2lsbCBEZWFjb24NCj4gPFdpbGwuRGVhY29uQGFybS5jb20+Ow0KPiA+PiBTdXp1a2kgUG91bG9z
ZSA8U3V6dWtpLlBvdWxvc2VAYXJtLmNvbT4NCj4gPj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFN0ZXZlIENhcHBlcg0KPiA+PiA8U3RldmUu
Q2FwcGVyQGFybS5jb20+OyBLYWx5IFhpbiAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+ID4+IDxL
YWx5LlhpbkBhcm0uY29tPjsgSnVzdGluIEhlIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPj4g
PEp1c3Rpbi5IZUBhcm0uY29tPjsgbmQgPG5kQGFybS5jb20+OyBsaW51eC1hcm0tDQo+ID4+IGtl
cm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnDQo+ID4+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHYz
IDQvNl0gcHNjaTogQWRkIGh2YyBjYWxsIHNlcnZpY2UgZm9yIHB0cF9rdm0uDQo+ID4+DQo+ID4+
IE9uIDA5LzEwLzE5IDA3OjIxLCBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIHdy
b3RlOg0KPiA+Pj4gQXMgcHRwX2t2bSBjbG9jayBoYXMgZml4ZWQgdG8gYXJtIGFyY2ggc3lzdGVt
IGNvdW50ZXIgaW4gcGF0Y2ggc2V0DQo+ID4+PiB2NCwgd2UgbmVlZCBjaGVjayBpZiB0aGUgY3Vy
cmVudCBjbG9ja3NvdXJjZSBpcyBzeXN0ZW0gY291bnRlciB3aGVuDQo+ID4+PiByZXR1cm4gY2xv
Y2sgY3ljbGUgaW4gaG9zdCwgc28gYSBoZWxwZXIgbmVlZGVkIHRvIHJldHVybiB0aGUgY3VycmVu
dA0KPiA+Pj4gY2xvY2tzb3VyY2UuIENvdWxkIEkgYWRkIHRoaXMgaGVscGVyIGluIG5leHQgcGF0
Y2ggc2V0Pw0KPiA+Pg0KPiA+PiBZb3UgZG9uJ3QgbmVlZCBhIGhlbHBlci4gIFlvdSBuZWVkIHRv
IHJldHVybiB0aGUgQVJNIGFyY2ggY291bnRlcg0KPiA+PiBjbG9ja3NvdXJjZSBpbiB0aGUgc3Ry
dWN0IHN5c3RlbV9jb3VudGVydmFsX3QgdGhhdCB5b3UgcmV0dXJuLg0KPiA+PiBnZXRfZGV2aWNl
X3N5c3RlbV9jcm9zc3RzdGFtcCB3aWxsIHRoZW4gY2hlY2sgdGhhdCB0aGUgY2xvY2tzb3VyY2UN
Cj4gPj4gbWF0Y2hlcyB0aGUgYWN0aXZlIG9uZS4NCj4gPg0KPiA+IFdlIG11c3QgZW5zdXJlIGJv
dGggb2YgdGhlIGhvc3QgYW5kIGd1ZXN0IHVzaW5nIHRoZSBzYW1lIGNsb2Nrc291cmNlLg0KPiA+
IGdldF9kZXZpY2Vfc3lzdGVtX2Nyb3NzdHN0YW1wIHdpbGwgY2hlY2sgdGhlIGNsb2Nrc291cmNl
IG9mIGd1ZXN0IGFuZA0KPiA+IHdlIGFsc28gbmVlZCBjaGVjayB0aGUgY2xvY2tzb3VyY2UgaW4g
aG9zdCwgYW5kIHN0cnVjdCB0eXBlIGNhbid0IGJlDQo+IHRyYW5zZmVycmVkIGZyb20gaG9zdCB0
byBndWVzdCB1c2luZyBhcm0gaHlwZXJjYWxsLg0KPiA+IG5vdyB3ZSBsYWNrIG9mIGEgbWVjaGFu
aXNtIHRvIGNoZWNrIHRoZSBjdXJyZW50IGNsb2Nrc291cmNlLiBJIHRoaW5rIHRoaXMNCj4gd2ls
bCBiZSB1c2VmdWwgaWYgd2UgYWRkIG9uZS4NCj4gDQo+IEdvdCBpdC0tLXllcywgSSB0aGluayBh
ZGRpbmcgYSBzdHJ1Y3QgY2xvY2tzb3VyY2UgdG8gc3RydWN0DQo+IHN5c3RlbV90aW1lX3NuYXBz
aG90IHdvdWxkIG1ha2Ugc2Vuc2UuICBUaGVuIHRoZSBoeXBlcmNhbGwgY2FuIGp1c3QgdXNlDQo+
IGt0aW1lX2dldF9zbmFwc2hvdCBhbmQgZmFpbCBpZiB0aGUgY2xvY2tzb3VyY2UgaXMgbm90IHRo
ZSBBUk0gYXJjaCBjb3VudGVyLg0KPiANCj4gSm9obiAoU3R1bHR6KSwgZG9lcyB0aGF0IHNvdW5k
IGdvb2QgdG8geW91PyAgVGhlIGNvbnRleHQgaXMgdGhhdCBKaWFueW9uZw0KPiB3b3VsZCBsaWtl
IHRvIGFkZCBhIGh5cGVyY2FsbCB0aGF0IHJldHVybnMgYSAoY3ljbGVzLA0KPiBuYW5vc2Vjb25k
cykgcGFpciB0byB0aGUgZ3Vlc3QuICBPbiB4ODYgd2UncmUgcmVseWluZyBvbiB0aGUgdmNsb2Nr
X21vZGUNCj4gZmllbGQgdGhhdCBpcyBhbHJlYWR5IHRoZXJlIGZvciB0aGUgdkRTTywgYnV0IGJl
aW5nIGFibGUgdG8ganVzdCB1c2UNCj4ga3RpbWVfZ2V0X3NuYXBzaG90IHdvdWxkIGJlIG11Y2gg
bmljZXIuDQo+IA0KDQpDb3VsZCBJIGFkZCBzdHJ1Y3QgY2xvY2tzb3VyY2UgdG8gc3lzdGVtX3Rp
bWVfc25hcHNob3Qgc3RydWN0IGluIG5leHQgdmVyc2lvbiBvZiBteSBwYXRjaCBzZXQ/DQoNCkpp
YW55b25nIFd1DQpUaGFua3MNCg0KPiBQYW9sbw0KDQo=
