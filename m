Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DC71B6B94
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDXCui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:50:38 -0400
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:9891
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbgDXCui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5dzQ/8nY/xBFUSbOy893AIKqvaXupsA3rfTK9Yyz3c=;
 b=uonxVElCFsIdx+RFr1GmsXcLr464Yt6OsJaCr62e2S/H9G7fEWWL6u1LnFjH6uKMQXLQWxjnDpxqyZjbHLXwCQVHFvMK33q2huaX/OSrWzW65dIgUS9UDoA9oSBqtme6mvQzGFhYLV5UShUljoFCAQhg7Eej2dE1rAdAU3ri+40=
Received: from AM4P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::19)
 by AM0PR08MB5203.eurprd08.prod.outlook.com (2603:10a6:208:15f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 02:50:32 +0000
Received: from AM5EUR03FT043.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:200:56:cafe::8) by AM4P190CA0009.outlook.office365.com
 (2603:10a6:200:56::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Fri, 24 Apr 2020 02:50:32 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT043.mail.protection.outlook.com (10.152.17.43) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.19 via Frontend Transport; Fri, 24 Apr 2020 02:50:31 +0000
Received: ("Tessian outbound 43fc5cd677c4:v53"); Fri, 24 Apr 2020 02:50:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: abc97a36b9ad8eb2
X-CR-MTA-TID: 64aa7808
Received: from f839f8d49bc5.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7D69440B-399A-4059-8480-E84E74C26EAC.1;
        Fri, 24 Apr 2020 02:50:26 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f839f8d49bc5.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 24 Apr 2020 02:50:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGiIi/kBlOCeKZonHSy/dZr/6sfDNmxSK/+ztULskJMIiHAV94PJuM9lmQFi2qDse1dK+T5mQtuUFqN5TUCB19aoAGPPn61Zj4fVx/OccrXp3hk7uzfc3swbpI7R3SU2KNYq88DShZSdU8kHK15xLe5zKfjB2BJGNzVdLAp3MvtKn1ebGq1dbjHTGIrjXp4besrU0Bf68oSVgRwx9GVhF2VD14AyuXGo4T6P0t8bOWQOH+2YAlL+V5uihFubITUX9zpLCYTWKD28wsMO3HbGXc7lfHJsJtd8oilngo4cvDnheW8te3vpJN9z34ONuNeRBx1nMSHLJpIbCBMTGgRl2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5dzQ/8nY/xBFUSbOy893AIKqvaXupsA3rfTK9Yyz3c=;
 b=RxywWHmHCdzjvBZYMvJFGLUmlBmhHYEL3t3ljUtgbZBDe9S6kqwS5BfiC8gcaRdc5kxvkofGYpvzCQI+1jtyCawjXDXHag3WqEVVh/hf4So9IkEr66HWPyI9l9nezB6mnYQ65VoKmsNG5Ka7A6hOh4cTwnPRzKCh5jdYoqt2HLsJDkU+eyluc++OvJYqm7gkYlxLaILFuhRG1TtSHa68ZkfkXjSJ/CfOgFZbTb4XRBO44Q+2mGInG1hFl7WS0R1f6H0mn3axMWQ41nYeYmCaDnwL8xzAK1ensX8T6DU/n23iAznw8fx2MSOY663PtHbw6QJUTJ8yN89whLt5IBgkoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5dzQ/8nY/xBFUSbOy893AIKqvaXupsA3rfTK9Yyz3c=;
 b=uonxVElCFsIdx+RFr1GmsXcLr464Yt6OsJaCr62e2S/H9G7fEWWL6u1LnFjH6uKMQXLQWxjnDpxqyZjbHLXwCQVHFvMK33q2huaX/OSrWzW65dIgUS9UDoA9oSBqtme6mvQzGFhYLV5UShUljoFCAQhg7Eej2dE1rAdAU3ri+40=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2282.eurprd08.prod.outlook.com (2603:10a6:3:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 02:50:22 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 02:50:22 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Mark Rutland <Mark.Rutland@arm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: Re: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Topic: [RFC PATCH v11 5/9] psci: Add hypercall service for ptp_kvm.
Thread-Index: AQHWF4xRpK0ubTCCx0eiqM1JOH1VE6iDV3gAgAQ/ngA=
Date:   Fri, 24 Apr 2020 02:50:22 +0000
Message-ID: <ab629714-c08c-2155-dd13-ad25e7f60b39@arm.com>
References: <20200421032304.26300-1-jianyong.wu@arm.com>
 <20200421032304.26300-6-jianyong.wu@arm.com>
 <20200421095736.GB16306@C02TD0UTHF1T.local>
In-Reply-To: <20200421095736.GB16306@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed42273e-0123-42bd-c674-08d7e7fa4136
x-ms-traffictypediagnostic: HE1PR0802MB2282:|HE1PR0802MB2282:|AM0PR08MB5203:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB52036F44A3554462150EF721F4D00@AM0PR08MB5203.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
x-forefront-prvs: 03838E948C
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(86362001)(6506007)(2616005)(6486002)(6512007)(31686004)(4326008)(26005)(37006003)(31696002)(316002)(6862004)(54906003)(186003)(53546011)(55236004)(71200400001)(76116006)(91956017)(5660300002)(478600001)(8676002)(66476007)(66446008)(64756008)(66556008)(36756003)(2906002)(8936002)(81156014)(66946007)(7416002)(6636002)(21314003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Ul2EbkEB9aLkZhbQGEpLmAAyP5Gt5iFFKB+GiVzihOj3i9Kokx97EHfXbvFy3YIgIYzGdlExk0LXV4irCh1Fv/OsQLRdETO9AlHoAMe8iHsJ7RVphMXyvmQ9Pchr4JM35bT6vzdetM46GQVRhhRqvnGWGkpDg5l7Q7RDVUqn4ELuiV4lFYnpyGrf+Z27dA4jD+OZ5HKVeDf9wSZQpUPunSognOt3d61swohQ3eEqCsAhaN6gyFIqhQ0nmkdcV4Ozeul8t/BvMeo9DWHuf+uYIJVJ9P2G0w+ftMHPA0+O0JiED9TwSS+12eIXgUc5fqQBsz8HtG8/XT6HrtXRRYnOm0prwW1Z+LHFcL2jVnJ8rC8mQf72bBO3yONiJ2Uw3CeZRm3sxnH4ws6I5Ymedt2UxuiQjjvMG5Q2QRKeJwf0EvPbWiwqotrQyMMVvhcCxNfoIaTSsKbHlHgLmh19lCQ692O2en/ndPEuTfALwRjoMRsuF8a+liuk2jZ5UhqMkTR/
x-ms-exchange-antispam-messagedata: YgQJQw455x+FKo5Pt8/cC2pGRZyuTFibG1mV6kUHLPgybpA0HJZIWi/8ldW2QeqpJHcnp3/hFoj8wia7uVAviCrpjN2ykhFUnLY/xVrVJReKkkOhkjqubuPKVR6VvbzDSWXRFuFX7Kmm45ZQ7b8YWw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF1D40F484214641B6EB9942D3DB49D8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2282
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966005)(37006003)(31686004)(26005)(47076004)(478600001)(82740400003)(82310400002)(53546011)(6512007)(54906003)(316002)(6636002)(6506007)(5660300002)(36756003)(6862004)(36906005)(4326008)(450100002)(336012)(31696002)(81166007)(6486002)(70206006)(70586007)(2616005)(356005)(86362001)(2906002)(186003)(81156014)(8676002)(8936002)(21314003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 33ad35b1-1bb2-4b6e-524d-08d7e7fa3b9a
X-Forefront-PRVS: 03838E948C
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eGRhEk/CqfedkZ35gYMCf0x4fqPwBx5gKMtIXZjaICRR1wwQ5dg9UMpkOYkuGYRqHlhGqVT3V9/jgUtu0F1XNPOLFJ99q6xzehSZVQr6SjldDEP/FOK3pzwi6PgLw38T/rUbB66Eu+R6WKL8p45eKp/bm3ttGaWlGP7JDLGCvtMsfessxVntoF2fgHxzEbOrH+dUGurGjZBysKEJ5wz0DxKjlsYXkGuZSh/X1Q9HRWV4yyzTMyIMq5dMCWCltl0PyJEYj0ilVOZ93D7TcPBRGlU8uXBcAERq3LfANZoGLCcLzLnpos5fzsn4HE6OpUh+kEU6/iWVNmKHKneqTW+u7lWJs+n+EZVE9qNWjaHSJqJU6YS9b9aQVDfD31U3n6u7ytwkDySn2XrSb/aZA8giyYPBDlhgfbdg2rSORHdo5hOL9Cltqp9S/GgWVBRd/iJQUPAH1wbduGCIixIIEdU8cT5XpVLfaIOBXkbt017Hpgbx1rghzsMWK0EYTWkHS32KVergXmcS5bVI4dxrBCt2BDuE3vZv9sHLh07ycYJfumc=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 02:50:31.6224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed42273e-0123-42bd-c674-08d7e7fa4136
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5203
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAyMC80LzIxIDU6NTcgUE0sIE1hcmsgUnV0bGFuZCB3cm90ZToNCg0KSGkgTWFyaywNCj4g
T24gVHVlLCBBcHIgMjEsIDIwMjAgYXQgMTE6MjM6MDBBTSArMDgwMCwgSmlhbnlvbmcgV3Ugd3Jv
dGU6DQo+PiBwdHBfa3ZtIG1vZHVsZXMgd2lsbCBnZXQgdGhpcyBzZXJ2aWNlIHRocm91Z2ggc21j
Y2MgY2FsbC4NCj4+IFRoZSBzZXJ2aWNlIG9mZmVycyByZWFsIHRpbWUgYW5kIGNvdW50ZXIgY3lj
bGUgb2YgaG9zdCBmb3IgZ3Vlc3QuDQo+PiBBbHNvIGxldCBjYWxsZXIgZGV0ZXJtaW5lIHdoaWNo
IGN5Y2xlIG9mIHZpcnR1YWwgY291bnRlciBvciBwaHlzaWNhbCBjb3VudGVyDQo+PiB0byByZXR1
cm4uDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSmlhbnlvbmcgV3UgPGppYW55b25nLnd1QGFybS5j
b20+DQo+PiAtLS0NCj4+ICAgaW5jbHVkZS9saW51eC9hcm0tc21jY2MuaCB8IDIxICsrKysrKysr
KysrKysrKysrKysNCj4+ICAgdmlydC9rdm0vYXJtL2h5cGVyY2FsbHMuYyB8IDQ0ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDY0
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9hcm0tc21jY2MuaCBiL2luY2x1ZGUvbGludXgvYXJtLXNtY2NjLmgNCj4+IGluZGV4
IDU5NDk0ZGYwZjU1Yi4uNzQ3Yjc1OTVkMGM2IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9saW51
eC9hcm0tc21jY2MuaA0KPj4gKysrIGIvaW5jbHVkZS9saW51eC9hcm0tc21jY2MuaA0KPj4gQEAg
LTc3LDYgKzc3LDI3IEBADQo+PiAgIAkJCSAgIEFSTV9TTUNDQ19TTUNfMzIsCQkJCVwNCj4+ICAg
CQkJICAgMCwgMHg3ZmZmKQ0KPj4gICANCj4+ICsvKiBQVFAgS1ZNIGNhbGwgcmVxdWVzdHMgY2xv
Y2sgdGltZSBmcm9tIGd1ZXN0IE9TIHRvIGhvc3QgKi8NCj4+ICsjZGVmaW5lIEFSTV9TTUNDQ19I
WVBfS1ZNX1BUUF9GVU5DX0lECQkJCVwNCj4+ICsJQVJNX1NNQ0NDX0NBTExfVkFMKEFSTV9TTUND
Q19GQVNUX0NBTEwsCQkJXA0KPj4gKwkJCSAgIEFSTV9TTUNDQ19TTUNfMzIsCQkJXA0KPj4gKwkJ
CSAgIEFSTV9TTUNDQ19PV05FUl9TVEFOREFSRF9IWVAsCVwNCj4+ICsJCQkgICAwKQ0KPj4gKw0K
Pj4gKy8qIHJlcXVlc3QgZm9yIHZpcnR1YWwgY291bnRlciBmcm9tIHB0cF9rdm0gZ3Vlc3QgKi8N
Cj4+ICsjZGVmaW5lIEFSTV9TTUNDQ19IWVBfS1ZNX1BUUF9WSVJUCQkJCVwNCj4+ICsJQVJNX1NN
Q0NDX0NBTExfVkFMKEFSTV9TTUNDQ19GQVNUX0NBTEwsCQkJXA0KPj4gKwkJCSAgIEFSTV9TTUND
Q19TTUNfMzIsCQkJXA0KPj4gKwkJCSAgIEFSTV9TTUNDQ19PV05FUl9TVEFOREFSRF9IWVAsCVwN
Cj4+ICsJCQkgICAxKQ0KPj4gKw0KPj4gKy8qIHJlcXVlc3QgZm9yIHBoeXNpY2FsIGNvdW50ZXIg
ZnJvbSBwdHBfa3ZtIGd1ZXN0ICovDQo+PiArI2RlZmluZSBBUk1fU01DQ0NfSFlQX0tWTV9QVFBf
UEhZCQkJCVwNCj4+ICsJQVJNX1NNQ0NDX0NBTExfVkFMKEFSTV9TTUNDQ19GQVNUX0NBTEwsCQkJ
XA0KPj4gKwkJCSAgIEFSTV9TTUNDQ19TTUNfMzIsCQkJXA0KPj4gKwkJCSAgIEFSTV9TTUNDQ19P
V05FUl9TVEFOREFSRF9IWVAsCVwNCj4+ICsJCQkgICAyKQ0KPiBBUk1fU01DQ0NfT1dORVJfU1RB
TkRBUkRfSFlQIGlzIGZvciBzdGFuZGFyZCBjYWxscyBhcyBkZWZpbmVkIGluIFNNQ0NDDQo+IGFu
ZCBjb21wYW5pb24gZG9jdW1lbnRzLCBzbyB3ZSBzaG91bGQgcmVmZXIgdG8gdGhlIHNwZWNpZmlj
DQo+IGRvY3VtZW50YXRpb24gaGVyZS4gV2hlcmUgYXJlIHRoZXNlIGNhbGxzIGRlZmluZWQ/DQp5
ZWFoLCBzaG91bGQgYWRkIHJlZmVyZW5jZSBkb2NzIG9mICJTTUMgQ0FMTElORyBDT05WRU5USU9O
IiBoZXJlLg0KPiBJZiB0aGVzZSBjYWxscyBhcmUgTGludXgtc3BlY2lmaWMgdGhlbiBBUk1fU01D
Q0NfT1dORVJfU1RBTkRBUkRfSFlQDQo+IGlzbid0IGFwcHJvcHJpYXRlIHRvIHVzZSwgYXMgdGhl
eSBhcmUgdmVuZG9yLXNwZWNpZmljIGh5cGVydmlzb3Igc2VydmljZQ0KPiBjYWxsLg0KeWVhaCwg
dmVuZG9yLXNwZWNpZmljIHNlcnZpY2UgaXMgbW9yZSBzdWl0YWJsZSBmb3IgcHRwX2t2bS4NCj4N
Cj4gSXQgbG9va3MgbGlrZSB3ZSBkb24ndCBjdXJyZW50bHkgaGF2ZSBhIEFSTV9TTUNDQ19PV05F
Ul9IWVAgZm9yIHRoYXQNCj4gKHdoaWNoIElJVUMgd291bGQgYmUgNiksIGJ1dCB3ZSBjYW4gYWRk
IG9uZSBhcyBuZWNlc3NhcnkuIEkgdGhpbmsgdGhhdA0KPiBXaWxsIG1pZ2h0IGhhdmUgYWRkZWQg
dGhhdCBhcyBwYXJ0IG9mIGhpcyBTTUNDQyBwcm9iaW5nIGJpdHMuDQoNCm9rLCBJIHdpbGwgYWRk
IGEgbmV3ICJBUk1fU01DQ0NfT1dORVJfVkVORE9SX0hZUCIgd2hvc2UgSUlVQyBpcyA2DQoNCmFu
ZCBjcmVhdGUgIkFSTV9TTUNDQ19IWVBfS1ZNX1BUUF9JRCIgYmFzZSBvbiBpdC4NCg0KPg0KPj4g
Kw0KPj4gICAjaWZuZGVmIF9fQVNTRU1CTFlfXw0KPj4gICANCj4+ICAgI2luY2x1ZGUgPGxpbnV4
L2xpbmthZ2UuaD4NCj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jIGIv
dmlydC9rdm0vYXJtL2h5cGVyY2FsbHMuYw0KPj4gaW5kZXggNTUwZGZhM2U1M2NkLi5hNTMwOWMy
OGQ0ZGMgMTAwNjQ0DQo+PiAtLS0gYS92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+PiArKysg
Yi92aXJ0L2t2bS9hcm0vaHlwZXJjYWxscy5jDQo+PiBAQCAtMyw2ICszLDcgQEANCj4+ICAgDQo+
PiAgICNpbmNsdWRlIDxsaW51eC9hcm0tc21jY2MuaD4NCj4+ICAgI2luY2x1ZGUgPGxpbnV4L2t2
bV9ob3N0Lmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L2Nsb2Nrc291cmNlX2lkcy5oPg0KPj4gICAN
Cj4+ICAgI2luY2x1ZGUgPGFzbS9rdm1fZW11bGF0ZS5oPg0KPj4gICANCj4+IEBAIC0xMSw4ICsx
MiwxMSBAQA0KPj4gICANCj4+ICAgaW50IGt2bV9odmNfY2FsbF9oYW5kbGVyKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4+ICAgew0KPj4gLQl1MzIgZnVuY19pZCA9IHNtY2NjX2dldF9mdW5jdGlv
bih2Y3B1KTsNCj4+ICsJc3RydWN0IHN5c3RlbV90aW1lX3NuYXBzaG90IHN5c3RpbWVfc25hcHNo
b3Q7DQo+PiArCWxvbmcgYXJnWzRdOw0KPj4gKwl1NjQgY3ljbGVzOw0KPj4gICAJbG9uZyB2YWwg
PSBTTUNDQ19SRVRfTk9UX1NVUFBPUlRFRDsNCj4+ICsJdTMyIGZ1bmNfaWQgPSBzbWNjY19nZXRf
ZnVuY3Rpb24odmNwdSk7DQo+PiAgIAl1MzIgZmVhdHVyZTsNCj4+ICAgCWdwYV90IGdwYTsNCj4+
ICAgDQo+PiBAQCAtNjIsNiArNjYsNDQgQEAgaW50IGt2bV9odmNfY2FsbF9oYW5kbGVyKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkNCj4+ICAgCQlpZiAoZ3BhICE9IEdQQV9JTlZBTElEKQ0KPj4gICAJ
CQl2YWwgPSBncGE7DQo+PiAgIAkJYnJlYWs7DQo+PiArCS8qDQo+PiArCSAqIFRoaXMgc2VydmVz
IHZpcnR1YWwga3ZtX3B0cC4NCj4+ICsJICogRm91ciB2YWx1ZXMgd2lsbCBiZSBwYXNzZWQgYmFj
ay4NCj4+ICsJICogcmVnMCBzdG9yZXMgaGlnaCAzMi1iaXQgaG9zdCBrdGltZTsNCj4+ICsJICog
cmVnMSBzdG9yZXMgbG93IDMyLWJpdCBob3N0IGt0aW1lOw0KPj4gKwkgKiByZWcyIHN0b3JlcyBo
aWdoIDMyLWJpdCBkaWZmZXJlbmNlIG9mIGhvc3QgY3ljbGVzIGFuZCBjbnR2b2ZmOw0KPj4gKwkg
KiByZWczIHN0b3JlcyBsb3cgMzItYml0IGRpZmZlcmVuY2Ugb2YgaG9zdCBjeWNsZXMgYW5kIGNu
dHZvZmYuDQo+PiArCSAqLw0KPj4gKwljYXNlIEFSTV9TTUNDQ19IWVBfS1ZNX1BUUF9GVU5DX0lE
Og0KPiBTaG91bGRuJ3QgdGhlIGhvc3Qgb3B0LWluIHRvIHByb3ZpZGluZyB0aGlzIHRvIHRoZSBn
dWVzdCwgYXMgd2l0aCBvdGhlcg0KPiBmZWF0dXJlcz8NCg0KZXIsIGRvIHlvdSBtZWFuIHRoYXQg
IkFSTV9TTUNDQ19IVl9QVl9USU1FX1hYWCIgYXMgIm9wdC1pbiI/IGlmIHNvLCBJIA0KdGhpbmsg
dGhpcw0KDQprdm1fcHRwIGRvZXNuJ3QgbmVlZCBhIGJ1ZGR5LiB0aGUgZHJpdmVyIGluIGd1ZXN0
IHdpbGwgY2FsbCB0aGlzIHNlcnZpY2UgDQppbiBhIGRlZmluaXRlIHdheS4NCg0KPj4gKwkJLyoN
Cj4+ICsJCSAqIHN5c3RlbSB0aW1lIGFuZCBjb3VudGVyIHZhbHVlIG11c3QgY2FwdHVyZWQgaW4g
dGhlIHNhbWUNCj4+ICsJCSAqIHRpbWUgdG8ga2VlcCBjb25zaXN0ZW5jeSBhbmQgcHJlY2lzaW9u
Lg0KPj4gKwkJICovDQo+PiArCQlrdGltZV9nZXRfc25hcHNob3QoJnN5c3RpbWVfc25hcHNob3Qp
Ow0KPj4gKwkJaWYgKHN5c3RpbWVfc25hcHNob3QuY3NfaWQgIT0gQ1NJRF9BUk1fQVJDSF9DT1VO
VEVSKQ0KPj4gKwkJCWJyZWFrOw0KPj4gKwkJYXJnWzBdID0gdXBwZXJfMzJfYml0cyhzeXN0aW1l
X3NuYXBzaG90LnJlYWwpOw0KPj4gKwkJYXJnWzFdID0gbG93ZXJfMzJfYml0cyhzeXN0aW1lX3Nu
YXBzaG90LnJlYWwpOw0KPiBXaHkgZXhhY3RseSBkb2VzIHRoZSBndWVzdCBuZWVkIHRoZSBob3N0
J3MgcmVhbCB0aW1lPyBOZWl0aGVyIHRoZSBjb3Zlcg0KPiBsZXR0ZXIgbm9yIHRoaXMgY29tbWl0
IG1lc3NhZ2UgaGF2ZSBleHBsYWluZWQgdGhhdCwgYW5kIGZvciB0aG9zZSBvZiB1cw0KPiB1bmZh
bWxpYXIgd2l0aCBQVFAgaXQgd291bGQgYmUgdmVyeSBoZWxwZnVsIHRvIGtub3cgdGhhdCB0byB1
bmRlcnN0YW5kDQo+IHdoYXQncyBnb2luZyBvbi4NCg0Kb2gsIHNvcnJ5LCBJIHNob3VsZCBoYXZl
IGFkZGVkIG1vcmUgYmFja2dyb3VuZCBrbm93bGVkZ2UgaGVyZS4NCg0KanVzdCBnaXZlIHNvbWUg
aGludHMgaGVyZToNCg0KdGhlIGt2bV9wdHAgdGFyZ2V0cyB0byBzeW5jIGd1ZXN0IHRpbWUgd2l0
aCBob3N0LiBzb21lIHNlcnZpY2VzIGluIHVzZXIgDQpzcGFjZQ0KDQpsaWtlIGNocm9ueSBjYW4g
ZG8gdGltZSBzeW5jIGJ5IGlucHV0aW5nIHRpbWUoaW4ga3ZtX3B0cCBhbHNvIGNsb2NrIA0KY291
bnRlciBzb21ldGltZXMpIGZyb20NCg0KcmVtb3RlIGNsb2Nrc291cmNlKG9mdGVuIG5ldHdvcmsg
Y2xvY2tzb3VyY2UpLiBUaGlzIGt2bV9wdHAgZHJpdmVyIGNhbiANCm9mZmVyIGEgaW50ZXJmYWNl
IGZvcg0KDQp0aG9zZSB1c2VyIHNwYWNlIHNlcnZpY2UgaW4gZ3Vlc3QgdG8gZ2V0IHRoZSBob3N0
IHRpbWUgdG8gZG8gdGltZSBzeW5jIA0KaW4gZ3Vlc3QuDQoNCj4+ICsJCS8qDQo+PiArCQkgKiB3
aGljaCBvZiB2aXJ0dWFsIGNvdW50ZXIgb3IgcGh5c2ljYWwgY291bnRlciBiZWluZw0KPj4gKwkJ
ICogYXNrZWQgZm9yIGlzIGRlY2lkZWQgYnkgdGhlIGZpcnN0IGFyZ3VtZW50Lg0KPj4gKwkJICov
DQo+PiArCQlmZWF0dXJlID0gc21jY2NfZ2V0X2FyZzEodmNwdSk7DQo+PiArCQlzd2l0Y2ggKGZl
YXR1cmUpIHsNCj4+ICsJCWNhc2UgQVJNX1NNQ0NDX0hZUF9LVk1fUFRQX1BIWToNCj4+ICsJCQlj
eWNsZXMgPSBzeXN0aW1lX3NuYXBzaG90LmN5Y2xlczsNCj4+ICsJCQlicmVhazsNCj4+ICsJCWNh
c2UgQVJNX1NNQ0NDX0hZUF9LVk1fUFRQX1ZJUlQ6DQo+PiArCQlkZWZhdWx0Og0KPj4gKwkJCWN5
Y2xlcyA9IHN5c3RpbWVfc25hcHNob3QuY3ljbGVzIC0NCj4+ICsJCQl2Y3B1X3Z0aW1lcih2Y3B1
KS0+Y250dm9mZjsNCj4+ICsJCX0NCj4+ICsJCWFyZ1syXSA9IHVwcGVyXzMyX2JpdHMoY3ljbGVz
KTsNCj4+ICsJCWFyZ1szXSA9IGxvd2VyXzMyX2JpdHMoY3ljbGVzKTsNCj4+ICsNCj4+ICsJCXNt
Y2NjX3NldF9yZXR2YWwodmNwdSwgYXJnWzBdLCBhcmdbMV0sIGFyZ1syXSwgYXJnWzNdKTsNCj4g
SSB0aGluayB0aGUgJ2FyZycgYnVmZmVyIGlzIGNvbmZ1c2luZyBoZXJlLCBhbmQgaXQnZCBiZSBj
bGVhcmVyIHRvIGhhdmU6DQo+DQo+IAl1NjQgc25hcGhvdDsNCj4gCXU2NCBjeWNsZXM7DQo+DQo+
IC4uLiBhbmQgaGVyZSBkbzoNCj4NCj4gCQlzbWNjY19zZXRfcmV0dmFsKHZjcHUsDQo+IAkJCQkg
dXBwZXJfMzJfYml0cyhzbmFwaG90KSwNCj4gCQkJCSBsb3dlcl8zMl9iaXRzKHNuYXBzaG90KSwN
Cj4gCQkJCSB1cHBlcl8zMl9iaXRzKGN5Y2xlcyksDQo+IAkJCQkgbG93ZXJfMzJfYml0cyhjeWNs
ZXMpKTsNCg0KaXQncyBiZXR0ZXIgdG8gdXNlIGEgbWVhbmluZ2Z1bCB2YXJpYW50IG5hbWUuIEkg
d2lsbCBmaXggaXQuDQoNCg0KdGhhbmtzDQoNCkppYW55b25nDQoNCj4NCj4gVGhhbmtzLA0KPiBN
YXJrLg0KDQoNCg==
