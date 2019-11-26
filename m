Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20204109A30
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 09:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKZIbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 03:31:15 -0500
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:22151
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfKZIbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 03:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gh7o1PaB51MDokxlVtsTJm7/H2ENFR/NWoNxMTPOxs=;
 b=DCVKv5M/wH6YlXPtrsh8Dt2sanLV2PkpVMYdW3soc2FK/ZaXznYGWBL2SSRoYvKtyeCdp+NxzaEEAOwMgj2mlS00O/51aDdLcqW9tcScQErb40x9+SBgw52WoWXX1m3CWwRIjW1r839+QLdaozLaXTw0xfyRH6quwDWTRLRvDg4=
Received: from AM4PR08CA0055.eurprd08.prod.outlook.com (2603:10a6:205:2::26)
 by AM6PR08MB3029.eurprd08.prod.outlook.com (2603:10a6:209:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.17; Tue, 26 Nov
 2019 08:31:05 +0000
Received: from VE1EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::209) by AM4PR08CA0055.outlook.office365.com
 (2603:10a6:205:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.16 via Frontend
 Transport; Tue, 26 Nov 2019 08:31:05 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT008.mail.protection.outlook.com (10.152.18.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Tue, 26 Nov 2019 08:31:05 +0000
Received: ("Tessian outbound f7868d7ede10:v33"); Tue, 26 Nov 2019 08:31:04 +0000
X-CR-MTA-TID: 64aa7808
Received: from 473ca04911d7.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.2.50])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B4020F65-33DE-4F9F-B1FD-73763AF0D7A7.1;
        Tue, 26 Nov 2019 08:30:59 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01lp2050.outbound.protection.outlook.com [104.47.2.50])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 473ca04911d7.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 26 Nov 2019 08:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRyOHXukHH1RgaX9E1kcvZBTzlU7yhZypQYK+Sv6LDmM4qY0IKAGOFQLTastCRE9FjEUkDmjv2sFvFRXX5bRVzRMYIRabjz7wxAlQ24kdcgePubvZDgktoXTsVB97cFz98+zBy386xVAkuNeRmqNl4ejAwdzRN//QEdo/ay+DzfYBcMOJO7HWYVUGzj1DELWsrnTn4dpFGa/mDBF9EpBRPpElGnoYCDuM/flej3glhWk2aylNb3gQhguoFUTsIqrRas/Z/BmoYWXfIcA/PmN4GEf90Y4q9Z1L+34hfUVpPu1an8fUkHNOeO8W8vXuXb0ujfXgFE3isRUs1ulb+e0Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gh7o1PaB51MDokxlVtsTJm7/H2ENFR/NWoNxMTPOxs=;
 b=TjAXW8tHInpEMrP8lpeX3qtZ5ALjgqzIdmOvxH6gQRIp4Zt19vIMK6xj9CUi7uYT2ArFDngG2oVnUhq5YWdkT+lrQvARLKNdC9WDSv+hI4EMl+JEYttZuUzRcXER/c7yfBgW41EIvOwlzJE7+WND3LlW9Gf69oooGHthhvjwNvZi3Y5Kphl/PoJ8Rb9RISW1xruaEALErLkqUGFSVOJQmiQaVd+0v2Hkm6Egq3GgyBTlB7Yg2tOQUyTJQu/nCrY9vg4pdzQf+7FMuwZmXOVaGbk7yeNa+oZscVCCdt/taX8Doou8MrRabQhnOr/daAl249qkVoHBVbPhIhTJ20eleA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gh7o1PaB51MDokxlVtsTJm7/H2ENFR/NWoNxMTPOxs=;
 b=DCVKv5M/wH6YlXPtrsh8Dt2sanLV2PkpVMYdW3soc2FK/ZaXznYGWBL2SSRoYvKtyeCdp+NxzaEEAOwMgj2mlS00O/51aDdLcqW9tcScQErb40x9+SBgw52WoWXX1m3CWwRIjW1r839+QLdaozLaXTw0xfyRH6quwDWTRLRvDg4=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2090.eurprd08.prod.outlook.com (10.168.93.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Tue, 26 Nov 2019 08:30:57 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294%8]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 08:30:56 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [RFC PATCH v8 3/8] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Topic: [RFC PATCH v8 3/8] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
Thread-Index: AQHVo32GHa+cuSKk4Ea1AvmwxiCr5KecCFoAgAEQ+AA=
Date:   Tue, 26 Nov 2019 08:30:56 +0000
Message-ID: <HE1PR0801MB1676DCFA2490D1DB58C14A4AF4450@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
 <20191125104506.36850-4-jianyong.wu@arm.com>
 <a13a4f9554f36a46781308358fc63519@www.loen.fr>
In-Reply-To: <a13a4f9554f36a46781308358fc63519@www.loen.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: eab09f93-49f9-45f2-95e1-7cc5d9b54db5.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea278ce1-b61c-470a-5f99-08d7724afab0
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2090:|HE1PR0801MB2090:|AM6PR08MB3029:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB30299B0DA6654447B9A905B3F4450@AM6PR08MB3029.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:1169;OLM:1169;
x-forefront-prvs: 0233768B38
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(13464003)(189003)(199004)(7696005)(4326008)(5660300002)(76116006)(186003)(76176011)(66476007)(99286004)(66446008)(64756008)(66556008)(66946007)(55016002)(52536014)(9686003)(25786009)(316002)(6436002)(256004)(446003)(11346002)(81156014)(71200400001)(7416002)(8936002)(478600001)(6916009)(54906003)(66066001)(74316002)(3846002)(33656002)(7736002)(6116002)(55236004)(102836004)(6506007)(4001150100001)(53546011)(6246003)(81166006)(8676002)(26005)(14454004)(86362001)(229853002)(305945005)(2906002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2090;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: KfWg/d16QuwQByxjM04tH7Spmgy7WBbpSnXmDQaCEVoDPEVb5MKKK1e+Sm6477D0CTkFbgQxI8ZP/UoAcYl+SQImeDlvjf/tErzKpouv32vArq4erj3MQtbP03kuhiDHO51zFogk02JrBmyhDQ83OBYMZbU1ot8J1qEHYaC17WPPkaCw42FuojYx3H3La31DDLp/YgXYYWDnt28nr/nhPqIvD28ttBbRez1TMXTOh+UJQ66v7wlCFyO10KqmbrakBH49nPAvyFidsQwpIvN4UjbKqUBzPXve1O9TOM4B76cPkkXZah3QEAUd8k6pZjbGAmh3CWxFm/7PmpxhwzF2I/e5p17SpswBZAtmha4SbpOtn5n+mCz8KeJ5Kk2l74pUepKHmTjaox2t66bMi2pV9YPB0oLc8wLdqd5xgfxkBboikmScyn4EzPcHy8wWnqLX
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2090
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT008.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(199004)(13464003)(189003)(2906002)(305945005)(99286004)(7736002)(66066001)(14454004)(36906005)(26826003)(74316002)(316002)(25786009)(33656002)(22756006)(54906003)(186003)(478600001)(106002)(6506007)(53546011)(102836004)(76176011)(7696005)(47776003)(2486003)(50466002)(26005)(23676004)(81166006)(81156014)(336012)(86362001)(6246003)(55016002)(9686003)(446003)(436003)(11346002)(4326008)(6862004)(229853002)(76130400001)(450100002)(4001150100001)(70206006)(70586007)(52536014)(8676002)(8936002)(356004)(3846002)(6116002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3029;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 019346ed-ce47-4a0e-81ff-08d7724af583
NoDisclaimer: True
X-Forefront-PRVS: 0233768B38
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b19Poqe4kSjwUYE6KoyCEcnVB15S1o8tQ6bOZfH5tGYTxeyyBJkZukkbVI2faHHVOKu9sRRvFnZw4g9uKtp1yHk7rRDtH+tJCY6CA0q6ce8dN5VOAhOPgpYnFmJGEiusgVLbypWE9d4VTfLcOsln6NgJ2GyPB7EsvfnPDLmOob7Ua0n2Z+X75zqLQSV2NwWhbngEL5HRgXdrizmjNExFpQUbS6pfZgmXUz/wFxw0Eg1cOlcE+CvFCSbuN/omz+P/awEfbMRMaz1MVq96tjz39Lga+P/lFd3Do6wSVe1H/2sxawqqqYHxDPfsMBB7JaXim7OPZlwuV7Uq7CtUIHQ2cVMxJQeAmiGTyGFmdwjGvUSuHNzhRCRRFTpCvuV+Zdeu7QINype8ASlZwJqsXkAJIW/1i39t9kfxKvBaDzj9lA1rrEtRL3pIWW0Stf4lDWzR
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 08:31:05.3422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea278ce1-b61c-470a-5f99-08d7724afab0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDI1LCAyMDE5
IDExOjQ4IFBNDQo+IFRvOiBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIDxKaWFu
eW9uZy5XdUBhcm0uY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgeWFuZ2JvLmx1
QG54cC5jb207IGpvaG4uc3R1bHR6QGxpbmFyby5vcmc7DQo+IHRnbHhAbGludXRyb25peC5kZTsg
cGJvbnppbmlAcmVkaGF0LmNvbTsgc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsNCj4g
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tOyBNYXJrIFJ1dGxhbmQgPE1hcmsuUnV0bGFuZEBhcm0u
Y29tPjsNCj4gd2lsbEBrZXJuZWwub3JnOyBTdXp1a2kgUG91bG9zZSA8U3V6dWtpLlBvdWxvc2VA
YXJtLmNvbT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0ta2Vy
bmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHU7
IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFN0ZXZlIENhcHBlcg0KPiA8U3RldmUuQ2FwcGVyQGFybS5j
b20+OyBLYWx5IFhpbiAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+IDxLYWx5LlhpbkBhcm0uY29t
PjsgSnVzdGluIEhlIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEp1c3Rpbi5IZUBhcm0uY29t
PjsgbmQgPG5kQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHY4IDMvOF0gcHRw
OiBSZW9yZ2FuaXplIHB0cF9rdm0gbW9kdWxlcyB0byBtYWtlIGl0DQo+IGFyY2gtaW5kZXBlbmRl
bnQuDQo+IA0KPiBPbiAyMDE5LTExLTI1IDEwOjQ1LCBKaWFueW9uZyBXdSB3cm90ZToNCj4gPiBD
dXJyZW50bHksIHB0cF9rdm0gbW9kdWxlcyBpbXBsZW1lbnRhdGlvbiBpcyBvbmx5IGZvciB4ODYg
d2hpY2gNCj4gPiBpbmNsdWRzIGxhcmdlIHBhcnQgb2YgYXJjaC1zcGVjaWZpYyBjb2RlLiAgVGhp
cyBwYXRjaCBtb3ZlIGFsbCBvZg0KPiA+IHRob3NlIGNvZGUgaW50byBuZXcgYXJjaCByZWxhdGVk
IGZpbGUgaW4gdGhlIHNhbWUgZGlyZWN0b3J5Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlh
bnlvbmcgV3UgPGppYW55b25nLnd1QGFybS5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvcHRw
L01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvcHRw
L3twdHBfa3ZtLmMgPT4gcHRwX2t2bV9jb21tb24uY30gfCA3NyArKysrKy0tLS0tLS0tLS0tLS0N
Cj4gPiAgZHJpdmVycy9wdHAvcHRwX2t2bV94ODYuYyAgICAgICAgICAgICAgICAgICB8IDg3DQo+
ID4gKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGluY2x1ZGUvYXNtLWdlbmVyaWMvcHRwX2t2
bS5oICAgICAgICAgICAgICAgfCAxMiArKysNCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAxMTggaW5z
ZXJ0aW9ucygrKSwgNTkgZGVsZXRpb25zKC0pICByZW5hbWUNCj4gPiBkcml2ZXJzL3B0cC97cHRw
X2t2bS5jID0+IHB0cF9rdm1fY29tbW9uLmN9ICg2MyUpICBjcmVhdGUgbW9kZQ0KPiAxMDA2NDQN
Cj4gPiBkcml2ZXJzL3B0cC9wdHBfa3ZtX3g4Ni5jICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gPiBp
bmNsdWRlL2FzbS1nZW5lcmljL3B0cF9rdm0uaA0KPiANCj4gWy4uLl0NCj4gDQo+ID4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvYXNtLWdlbmVyaWMvcHRwX2t2bS5oDQo+ID4gYi9pbmNsdWRlL2FzbS1n
ZW5lcmljL3B0cF9rdm0uaCBuZXcgZmlsZSBtb2RlIDEwMDY0NCBpbmRleA0KPiA+IDAwMDAwMDAw
MDAwMC4uZTVkZDM4NmY2NjY0DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2luY2x1ZGUv
YXNtLWdlbmVyaWMvcHRwX2t2bS5oDQo+ID4gQEAgLTAsMCArMSwxMiBAQA0KPiA+ICsvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovDQo+ID4gKy8qDQo+ID4gKyAqICBW
aXJ0dWFsIFBUUCAxNTg4IGNsb2NrIGZvciB1c2Ugd2l0aCBLVk0gZ3Vlc3RzDQo+ID4gKyAqDQo+
ID4gKyAqICBDb3B5cmlnaHQgKEMpIDIwMTkgQVJNIEx0ZC4NCj4gDQo+IEkgdGhpbmsgeW91IHNo
b3VsZCBsaXZlIHRoZSBvcmlnaW5hbCBjb3B5cmlnaHQgYXNzaWdubWVudCBoZXJlLg0KPiBUaGlz
IHJlYWxseSBpc24ndCBhbnl0aGluZyBuZXcuDQo+IA0KDQpPaywNCg0KPiA+ICsgKiAgQWxsIFJp
Z2h0cyBSZXNlcnZlZA0KPiA+ICsgKi8NCj4gPiArDQo+ID4gK2ludCBrdm1fYXJjaF9wdHBfaW5p
dCh2b2lkKTsNCj4gPiAraW50IGt2bV9hcmNoX3B0cF9nZXRfY2xvY2soc3RydWN0IHRpbWVzcGVj
NjQgKnRzKTsgaW50DQo+ID4gK2t2bV9hcmNoX3B0cF9nZXRfY3Jvc3N0c3RhbXAodW5zaWduZWQg
bG9uZyAqY3ljbGUsDQo+ID4gKwkJc3RydWN0IHRpbWVzcGVjNjQgKnRzcGVjLCB2b2lkICpjcyk7
DQo+IA0KPiBXaHkgaXMgdGhpcyBpbmNsdWRlIGZpbGUgaW4gYXNtLWdlbmVyaWM/IFRoaXMgaXNu
J3QgYSBrZXJuZWwtd2lkZSBBUEkuDQo+IA0KPiBJIHRoaW5rIGl0IHNob3VsZCBiZSBzaXR0aW5n
IGluIGRyaXZlcnMvcHRwLCBhcyBpdCBpcyBvbmx5IHNoYXJlZCBiZXR3ZWVuIHRoZQ0KPiBnZW5l
cmljIGFuZCBhcmNoLXNwZWNpZmljIHN0dWZmLg0KDQpPaywgYWxsIHRoZXNlIEFQSXMgdXNlZCB1
bmRlciBkcml2ZXIvcHRwLCBzbyBpdCdzIGJldHRlciB0byBtb3ZlIHRoYXQgaGVhZGVyIGZpbGUg
aW50byBpdC4NCg0KVGhhbmtzDQpKaWFueW9uZw0KPiANCj4gVGhhbmtzLA0KPiANCj4gICAgICAg
ICAgTS4NCj4gLS0NCj4gSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4N
Cg==
