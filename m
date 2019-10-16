Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDC0D8DC0
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404516AbfJPKUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:20:38 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:39399
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729634AbfJPKUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 06:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2fnDxHPIWeFnZ5sV7PZ6gyFHF27CUL9JVJA8iIG8=;
 b=ItVmx7kCTQoqHaPd2x1E08X99ZztQVyOIdzrzqP/HTt6x2tjG73FD4nsoIvEZHQ7VPPyqmAYmskRE731TjEY1UsqjqruoRUkpxvNwgT5w15EjI/xlbmO3XMr6U1P4vIxPKUfGzn2Lc6o/W0PRnDKFLnD7OYFLaL1uZb5+oNjmOc=
Received: from VI1PR08CA0264.eurprd08.prod.outlook.com (2603:10a6:803:dc::37)
 by AM6PR08MB3829.eurprd08.prod.outlook.com (2603:10a6:20b:85::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2347.16; Wed, 16 Oct
 2019 10:20:30 +0000
Received: from DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::204) by VI1PR08CA0264.outlook.office365.com
 (2603:10a6:803:dc::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2347.16 via Frontend
 Transport; Wed, 16 Oct 2019 10:20:30 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT052.mail.protection.outlook.com (10.152.21.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Wed, 16 Oct 2019 10:20:28 +0000
Received: ("Tessian outbound 0cf06bf5c60e:v33"); Wed, 16 Oct 2019 10:20:26 +0000
X-CR-MTA-TID: 64aa7808
Received: from c6101318b283.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.13.55])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 69016E91-2A83-4FC6-8012-600F676F5E84.1;
        Wed, 16 Oct 2019 10:20:21 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c6101318b283.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 16 Oct 2019 10:20:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbOLwIIk6Z28jaIfCnlEP6absjRIULfvVGsJn2ijo6vBpp7jS1oT5WU1kY0tSkroogNxKBiIUrvtgLQOvt6deveZGWfGLhwGC7DsYG6gnmUMsp5lrpSLBbYYEkYSwR2vNO9VMwqpadgBYj1nplHbexCCWmaCiM4gGdzE7fJ1zGPEYrGredEx9xuhyl29Y1/uGKkFeiTOIQZb6AMqEZb4jVbjEu+hJXMuhDGIHkviMTYiVdwu9ar2hzX8vSjO1gp6wid4GXdJRKVH4ZPT4i6f1MWXujpomAMgSncl3Hfcq+NorORzfgmbiRS+ZFqu8eLwRsyv576sJiQfJg0gZluMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2fnDxHPIWeFnZ5sV7PZ6gyFHF27CUL9JVJA8iIG8=;
 b=O1kFKxkZauvO+a805UJa7+gvurCqxxic0cZ9PFFfH/ALDlaPtkTYjYyk+LMKa3AW8n+11Hf9gqCNCwK9LU7vJUfAGx3R3FnbNIs1RLrsSYt3KsZB+1yqXry4HVUHBJ6QvJEeSS7wbXdHH1VXh9f9pZqzzHqQrxzYlncjCoo3ANENa0K9PLqcgVkorGNScrp/P/aOMCAI5R9wc2AP7N51D1E9iYTiq84N2xtqUt8T5fce1j+i/YA4pht5aE0/vLxE37FNDMuJbMUO3PWGYg8DhG3mqTfYXO09+e7RWfqX0/wy0LuW4IYWJBQGLuNqZ9j8sL5FP07fTT422zxn+u6meg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDp2fnDxHPIWeFnZ5sV7PZ6gyFHF27CUL9JVJA8iIG8=;
 b=ItVmx7kCTQoqHaPd2x1E08X99ZztQVyOIdzrzqP/HTt6x2tjG73FD4nsoIvEZHQ7VPPyqmAYmskRE731TjEY1UsqjqruoRUkpxvNwgT5w15EjI/xlbmO3XMr6U1P4vIxPKUfGzn2Lc6o/W0PRnDKFLnD7OYFLaL1uZb5+oNjmOc=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1964.eurprd08.prod.outlook.com (10.168.94.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 10:20:19 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::b056:4113:e0bd:110d%6]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 10:20:19 +0000
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
Subject: RE: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [PATCH v5 4/6] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVg0Y6ldpzPhPiCEmlQj9Y39l92adc3w8AgAAwgWA=
Date:   Wed, 16 Oct 2019 10:20:19 +0000
Message-ID: <HE1PR0801MB16762F7310EC28FE8DDEAC2EF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-5-jianyong.wu@arm.com>
 <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
In-Reply-To: <9641fbff-cfcd-4854-e0c9-0b97d44193ee@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 94428382-265b-4841-b3fb-4bd68ecd7167.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: a67df942-ff60-408b-ba81-08d7522277e9
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1964:|HE1PR0801MB1964:|AM6PR08MB3829:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3829FFA7F914E2FA3C640B81F4920@AM6PR08MB3829.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0192E812EC
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(199004)(189003)(13464003)(25786009)(66446008)(2201001)(71200400001)(102836004)(86362001)(8676002)(2906002)(6636002)(74316002)(478600001)(76116006)(66946007)(71190400001)(81166006)(33656002)(81156014)(99286004)(66556008)(6116002)(64756008)(66476007)(3846002)(4326008)(256004)(5660300002)(55236004)(8936002)(6506007)(6246003)(53546011)(7416002)(186003)(54906003)(9686003)(6436002)(7736002)(316002)(2501003)(446003)(52536014)(14454004)(55016002)(305945005)(110136005)(229853002)(76176011)(476003)(66066001)(11346002)(486006)(7696005)(26005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1964;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: I1w2hbVbICQ9mMusbQX4PqCCA8pFB/i2aKV5CKr0K6eHJEHbkia21eb10F0waxU0rrGBxHkEpSQ1WJFf+4tVFRqxfX7cBM7MUpluZSOUdP9Bwl6Zt2GzIqS2xbfJm/0ujeNDJ0i3gYh7om1zLpfuL+x8dvB3sLGF+saCcMbrkQHJ8/LZsEWFAJYEC8VzEsbMzuKEAuzhsA+VdLgNJqNLlLhbPUGL2cl4xcAyo3f2Z0BeIyc8BKtXGDHJjcC3CC0nkjF8TYvSQBB0NxrCF4MHnhQdEOPzX+23o4nCVDcraqrXh+lSF22hErTr0KeU3H/vTJ19wKgHlX4EramCING8mJitfRBdZ3CB5lhIfI4Na43c0Pnt61zG5fky9oYroN//r61a1b6Lbwqle0516UqRrrMWORweq5mP6IkquPDdxeE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1964
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(13464003)(189003)(199004)(47776003)(81156014)(336012)(8676002)(70206006)(9686003)(186003)(7736002)(2486003)(70586007)(23676004)(53546011)(6506007)(486006)(76176011)(7696005)(66066001)(8936002)(2201001)(6636002)(74316002)(6246003)(81166006)(50466002)(99286004)(11346002)(476003)(436003)(446003)(86362001)(63350400001)(126002)(229853002)(26826003)(478600001)(25786009)(4326008)(110136005)(102836004)(2906002)(3846002)(52536014)(6116002)(2501003)(33656002)(22756006)(316002)(14454004)(305945005)(26005)(55016002)(54906003)(76130400001)(356004)(5660300002)(450100002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR08MB3829;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: eb38ac53-4990-4f53-aa7d-08d75222722a
NoDisclaimer: True
X-Forefront-PRVS: 0192E812EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2St3dwaxu4/wOhDaApqWV3UtSGUiWjOA6VetQJVmxsJGuBKqjpGmSN288ZBUsUTGBWqltaU2G1KCL/KWobZT6koZyvhGdjWmzRqvCr+nXWal5A/P1WXlVSrc5AQmynZBGH+VsA0o0nVzn2vqELkgahdpoYJrLIrtwp+XdSyeQLFT3MY6QCk5VilUK07FMoJDqrDccbCZ/i82PZrCZ/9n4DLEnZt6GdaY/wN5GZZDFaPeVkZrVkAT090yhEpVsQzdpi4D3zk61PGxnTIdB5tYvklBomotpZLfLffpanIO8cwB5pNzB8nRPLDbu1e94hEJK0YJBJzlJKfJlNWHprG5epiXBvrqeNyL9ATvBcEZH0cPknSdVWXBCYscm4XTU6f5KeI6t4BE1NB3WPfT/0gjlzbydZKkbeQ+z1YaBgKyN2g=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2019 10:20:28.9505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a67df942-ff60-408b-ba81-08d7522277e9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8g
Qm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVy
IDE2LCAyMDE5IDM6MjUgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9neSBDaGlu
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
b20+OyBuZCA8bmRAYXJtLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NSA0LzZdIHBzY2k6
IEFkZCBodmMgY2FsbCBzZXJ2aWNlIGZvciBwdHBfa3ZtLg0KPiANCj4gT24gMTUvMTAvMTkgMTI6
NDgsIEppYW55b25nIFd1IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Nsb2Nrc291
cmNlL2FybV9hcmNoX3RpbWVyLmMNCj4gPiBiL2RyaXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hf
dGltZXIuYw0KPiA+IGluZGV4IDA3ZTU3YTQ5ZDFlOC4uMzU5N2YxZjI3YjEwIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYw0KPiA+IEBAIC0xNjM0LDMgKzE2MzQs
OCBAQCBzdGF0aWMgaW50IF9faW5pdCBhcmNoX3RpbWVyX2FjcGlfaW5pdChzdHJ1Y3QNCj4gPiBh
Y3BpX3RhYmxlX2hlYWRlciAqdGFibGUpICB9ICBUSU1FUl9BQ1BJX0RFQ0xBUkUoYXJjaF90aW1l
ciwNCj4gPiBBQ1BJX1NJR19HVERULCBhcmNoX3RpbWVyX2FjcGlfaW5pdCk7ICAjZW5kaWYNCj4g
PiArDQo+ID4gK2Jvb2wgaXNfYXJtX2FyY2hfY291bnRlcih2b2lkICpjcykNCj4gPiArew0KPiA+
ICsJcmV0dXJuIChzdHJ1Y3QgY2xvY2tzb3VyY2UgKiljcyA9PSAmY2xvY2tzb3VyY2VfY291bnRl
cjsgfQ0KPiANCj4gQXMgVGhvbWFzIHBvaW50ZWQgb3V0LCBhbnkgcmVhc29uIHRvIGhhdmUgYSB2
b2lkICogaGVyZT8NCg0KTmVlZCBmaXguDQoNClRoYW5rcw0KSmlhbnlvbmcgDQoNCj4gDQo+IEhv
d2V2ZXIsIHNpbmNlIGhlIGRpZG4ndCBsaWtlIG1vZGlmeWluZyB0aGUgc3RydWN0LCBoZXJlIGlz
IGFuIGFsdGVybmF0aXZlIGlkZWE6DQo+IA0KPiAxKSBhZGQgYSAic3RydWN0IGNsb2Nrc291cmNl
KiIgYXJndW1lbnQgdG8ga3RpbWVfZ2V0X3NuYXBzaG90DQo+IA0KPiAyKSByZXR1cm4gLUVOT0RF
ViBpZiB0aGUgYXJndW1lbnQgaXMgbm90IE5VTEwgYW5kIGlzIG5vdCB0aGUgY3VycmVudA0KPiBj
bG9ja3NvdXJjZQ0KPiANCj4gMykgbW92ZSB0aGUgaW1wbGVtZW50YXRpb24gb2YgdGhlIGh5cGVy
Y2FsbCB0bw0KPiBkcml2ZXJzL2Nsb2Nrc291cmNlL2FybV9hcmNoX3RpbWVyLmMsIHNvIHRoYXQg
aXQgY2FuIGNhbGwNCj4ga3RpbWVfZ2V0X3NuYXBzaG90KCZzeXN0aW1lX3NuYXBzaG90LCAmY2xv
Y2tzb3VyY2VfY291bnRlcik7DQo+IA0KPiBQYW9sbw0KDQo=
