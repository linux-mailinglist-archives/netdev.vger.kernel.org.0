Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4477C0302
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfI0KK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:10:29 -0400
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:7406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbfI0KK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mCgbSjpcicQutl8OZMW12/8vRt7tLcsTSj+sJ5NLIc=;
 b=cz+U7PaCmtkxbpmCy4mu8fba667EP1PNGZAU0ymegRmioqscJvfejbxNaVb6WKxh0Gp3n6SNB0xB8XqqjeL6tyozrDgaF7MBzFyEIQbu4m3nB0o+5knE2VEkOB1KO50Yo0cDbIvAVREJM+T/AMMDJYNW/yxg1JDtr5np43yCMsY=
Received: from VI1PR08CA0087.eurprd08.prod.outlook.com (2603:10a6:800:d3::13)
 by DB6PR0802MB2438.eurprd08.prod.outlook.com (2603:10a6:4:a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20; Fri, 27 Sep
 2019 10:10:21 +0000
Received: from DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::207) by VI1PR08CA0087.outlook.office365.com
 (2603:10a6:800:d3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2305.15 via Frontend
 Transport; Fri, 27 Sep 2019 10:10:21 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT007.mail.protection.outlook.com (10.152.20.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Fri, 27 Sep 2019 10:10:20 +0000
Received: ("Tessian outbound 0cf06bf5c60e:v33"); Fri, 27 Sep 2019 10:10:17 +0000
X-CR-MTA-TID: 64aa7808
Received: from 711ae29de496.4 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.4.53])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7D7C44AC-D6DA-4185-A205-6ED37E819C1E.1;
        Fri, 27 Sep 2019 10:10:12 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 711ae29de496.4
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Fri, 27 Sep 2019 10:10:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aS7UdA97NUUjXgNdb0+0lzOFUnEWglZv93v7fIGnkWiwAJHhkO2Y9N8D2DFV5g677FN33+BnAJ6Yc8u7UZDC/92LL25GWk51cDPu0Oe7J6BDn/NRQwn4ZylyaA9b+sPeshITnsE5fNPgS17Ch1L73r58xDu+RtbX/A7+Xthhz2dj5VrCP5eqqRTUgMwVKIvDA80EUqePCJgnPa7uaVNdyt4MTR8924QUfUfvnGye95qaUNKp+1vr3xAAH4Q5Jq04ONz/OnMGALE1s4oEGhFctIxxf+bFdW8da57d4/h2gn/kfsexGAFBk38Wqwd7QL+O+uOwHjfOw4VTV5F6eTC8NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mCgbSjpcicQutl8OZMW12/8vRt7tLcsTSj+sJ5NLIc=;
 b=le34nx5eJmYP1hsCwwqsWDZ95M8HCCbOy1/MH7NyHXH8ymvajg/YMDV1Csk/t2qEi5XBKivkGTR1yEDr0Rk991zy72cTmSetfOoPvjIVB3VG+zAdeFScbwCIiQ9lUEYEnE9zbvTw/ZHmfqID0CrNr7RsdiDIYi/J7Jfppv5e0mwZsvpUAohrDoY8ci/biTxGrMaofZJQJoP2uYFMpX/LFkx0SWuR6twjsnS9hViKgzKWmJoWNcwc/xzaBXzIzTT7GR8aQPXIBc48pyU8O5O/e5rlsuHRyhn04sB195qRhffbP7ZIiagu7JQy+RNM1eBnTFsxaOrqgX1QGLXtzmbNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mCgbSjpcicQutl8OZMW12/8vRt7tLcsTSj+sJ5NLIc=;
 b=cz+U7PaCmtkxbpmCy4mu8fba667EP1PNGZAU0ymegRmioqscJvfejbxNaVb6WKxh0Gp3n6SNB0xB8XqqjeL6tyozrDgaF7MBzFyEIQbu4m3nB0o+5knE2VEkOB1KO50Yo0cDbIvAVREJM+T/AMMDJYNW/yxg1JDtr5np43yCMsY=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2041.eurprd08.prod.outlook.com (10.168.98.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Fri, 27 Sep 2019 10:10:10 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 10:10:10 +0000
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
Thread-Index: AQHVdF+Ft3UnKFEitUOtlQstSNDglqc97ZgAgAFgLEA=
Date:   Fri, 27 Sep 2019 10:10:10 +0000
Message-ID: <HE1PR0801MB167630F7B983A7F9DBB473DFF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
 <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
In-Reply-To: <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: c71b3542-34ef-4996-a434-864809ac6f26.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 0f4c6734-4d93-460d-54c2-08d74332e735
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB2041;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2041:|HE1PR0801MB2041:|DB6PR0802MB2438:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB2438E3421D917E70342D6D7AF4810@DB6PR0802MB2438.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:7691;
x-forefront-prvs: 0173C6D4D5
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(13464003)(189003)(199004)(2906002)(52536014)(486006)(66556008)(9686003)(66476007)(64756008)(55016002)(66446008)(6246003)(11346002)(8936002)(446003)(71200400001)(71190400001)(2201001)(6436002)(86362001)(229853002)(476003)(7416002)(76116006)(66946007)(25786009)(2501003)(99286004)(478600001)(81166006)(81156014)(305945005)(74316002)(8676002)(76176011)(7736002)(14444005)(316002)(5660300002)(6116002)(186003)(14454004)(3846002)(256004)(66066001)(33656002)(102836004)(55236004)(54906003)(4326008)(6636002)(26005)(7696005)(110136005)(53546011)(6506007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2041;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: 5df0i9w/dswQaqAUYzAkZQBp+Ivm1KJ3FqRsVlaEzcrkC/4pABljERNh0E4deM6Vai9nFtyXM9K+ddd/DiCRnr0Aoz0uP8//OdTh/n1Ai+xDOnCfAN12Ad7lbx1HzIoN2shOYy3r2vUDW8p7EcqWc8RyNNPqp5qoJ0ZKI3m5eYIw1T2KdGM/I6T2QaJdefDe79oFwgIiltOZOZKGg2AgLpanym+lfSC9IkiEgnc92St3LEtS76P29Zlk/Zo2l1PwgTTdI93k+BAQVuE00uXv/zPToLJ7ZyGGWdcALcK51BZO4J2svqNQbqigETFw4Yqhls1JhQ+QLnAY+gIrXQF5pXvDXkwYD542g5dyOhg4t7YVXcRCa+wRSNo1jy+YbTrvpn82BgcsDmE/93COc/SFhzNYeYOuOefwNlyGddkMcE4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2041
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT007.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(13464003)(199004)(189003)(76130400001)(450100002)(5660300002)(99286004)(25786009)(86362001)(50466002)(2501003)(74316002)(229853002)(7736002)(2201001)(305945005)(110136005)(54906003)(22756006)(3846002)(14454004)(6116002)(6636002)(66066001)(81166006)(26826003)(70586007)(26005)(70206006)(33656002)(316002)(486006)(476003)(2906002)(186003)(14444005)(63350400001)(446003)(8936002)(4326008)(11346002)(8676002)(126002)(81156014)(436003)(6246003)(2486003)(23676004)(52536014)(7696005)(55016002)(9686003)(47776003)(356004)(478600001)(53546011)(102836004)(336012)(76176011)(6506007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0802MB2438;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 348b2373-ee90-4782-1798-08d74332e155
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0802MB2438;
NoDisclaimer: True
X-Forefront-PRVS: 0173C6D4D5
X-Microsoft-Antispam-Message-Info: kOHWNuo/c/pnLKJ31BKu0Pqz7wYqnLdnqk8y8+o/D3Lh4p3cQ4xyg8Q1D6C833CIjeCZytUAi7tt7tow5fjr8+WAuHjgzfw6mpq0KUTsTaGqu4eqzDAfEV5RCEUZYgtHDqjb+d95yg9ZN3dZDqRptPJF+4BwXrXF6XmBAT5+FSIuUX9m9kER4Vet9RMG6PPNzPe3WrS+t+WWGL6xEEhwopp9ymnkZ2fGrl0ibzz4EJ5rheC+I9hxWjf7rnKE7sexlHn6Xj4DBaukyrHWcdGZJL6whmq2meB4pZXvJ4UlJxrXIoFgRI2y2WDKI0XG0Kwl0SE9cIjXNEQEDXc3k4MmFP+4SM+8Uv+7Uh3SSBAU+n0bYIgiAe10P/1mNicT1UtKMMukhRVsCW3638z5V8vV04s+Qvuuj0zsXtmrw/Dwibw=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2019 10:10:20.1811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4c6734-4d93-460d-54c2-08d74332e735
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2438
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3V6dWtpLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN1enVr
aSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBT
ZXB0ZW1iZXIgMjYsIDIwMTkgOTowNiBQTQ0KPiBUbzogSmlhbnlvbmcgV3UgKEFybSBUZWNobm9s
b2d5IENoaW5hKSA8SmlhbnlvbmcuV3VAYXJtLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IHlhbmdiby5sdUBueHAuY29tOyBqb2huLnN0dWx0ekBsaW5hcm8ub3JnOw0KPiB0Z2x4QGxp
bnV0cm9uaXguZGU7IHBib256aW5pQHJlZGhhdC5jb207IHNlYW4uai5jaHJpc3RvcGhlcnNvbkBp
bnRlbC5jb207DQo+IG1hekBrZXJuZWwub3JnOyByaWNoYXJkY29jaHJhbkBnbWFpbC5jb207IE1h
cmsgUnV0bGFuZA0KPiA8TWFyay5SdXRsYW5kQGFybS5jb20+OyBXaWxsIERlYWNvbiA8V2lsbC5E
ZWFjb25AYXJtLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdTsga3ZtQHZnZXIua2VybmVsLm9yZzsgU3RldmUgQ2FwcGVyDQo+IDxTdGV2ZS5DYXBw
ZXJAYXJtLmNvbT47IEthbHkgWGluIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEthbHkuWGlu
QGFybS5jb20+OyBKdXN0aW4gSGUgKEFybSBUZWNobm9sb2d5IENoaW5hKQ0KPiA8SnVzdGluLkhl
QGFybS5jb20+OyBuZCA8bmRAYXJtLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjQg
Mi81XSBwdHA6IFJlb3JnYW5pemUgcHRwX2t2bSBtb2R1bGVzIHRvIG1ha2UgaXQNCj4gYXJjaC1p
bmRlcGVuZGVudC4NCj4gDQo+IEhpIEppYW55b25nLA0KPiANCj4gT24gMjYvMDkvMjAxOSAxMjo0
MiwgSmlhbnlvbmcgV3Ugd3JvdGU6DQo+ID4gQ3VycmVudGx5LCBwdHBfa3ZtIG1vZHVsZXMgaW1w
bGVtZW50YXRpb24gaXMgb25seSBmb3IgeDg2IHdoaWNoDQo+ID4gaW5jbHVkcyBsYXJnZSBwYXJ0
IG9mIGFyY2gtc3BlY2lmaWMgY29kZS4gIFRoaXMgcGF0Y2ggbW92ZSBhbGwgb2YNCj4gPiB0aG9z
ZSBjb2RlIGludG8gbmV3IGFyY2ggcmVsYXRlZCBmaWxlIGluIHRoZSBzYW1lIGRpcmVjdG9yeS4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEppYW55b25nIFd1IDxqaWFueW9uZy53dUBhcm0uY29t
Pg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9wdHAvTWFrZWZpbGUgICAgICAgICAgICAgICAgIHwg
IDEgKw0KPiA+ICAgZHJpdmVycy9wdHAve3B0cF9rdm0uYyA9PiBrdm1fcHRwLmN9IHwgNzcgKysr
KysrLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gICBkcml2ZXJzL3B0cC9wdHBfa3ZtX3g4Ni5jICAg
ICAgICAgICAgfCA4Nw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gICBpbmNs
dWRlL2FzbS1nZW5lcmljL3B0cF9rdm0uaCAgICAgICAgfCAxMiArKysrDQo+ID4gICA0IGZpbGVz
IGNoYW5nZWQsIDExOCBpbnNlcnRpb25zKCspLCA1OSBkZWxldGlvbnMoLSkNCj4gPiAgIHJlbmFt
ZSBkcml2ZXJzL3B0cC97cHRwX2t2bS5jID0+IGt2bV9wdHAuY30gKDYzJSkNCj4gDQo+IG1pbm9y
IG5pdDogQ291bGQgd2Ugbm90IHNraXAgcmVuYW1pbmcgdGhlIGZpbGUgPyBHaXZlbiB5b3UgYXJl
IGZvbGxvd2luZyB0aGUNCj4gcHRwX2t2bV8qIGZvciB0aGUgYXJjaCBzcGVjaWZpYyBmaWxlcyBh
bmQgdGhlIGhlYWRlciBmaWxlcywgd291bGRuJ3QgaXQgYmUNCj4gZ29vZCB0byBrZWVwIHB0cF9r
dm0uYyA/DQo+IA0KSWYgdGhlIG1vZHVsZSBuYW1lIHB0cF9rdm0ua28gaXMgdGhlIHNhbWUgd2l0
aCBpdHMgZGVwZW5kZW50IG9iamVjdCBmaWxlIHB0cF9rdm0ubywgd2FybmluZyB3aWxsIGJlIGdp
dmVuIGJ5IGNvbXBpbGVyLCANClNvIEkgY2hhbmdlIHRoZSBwdHBfa3ZtLmMgdG8ga3ZtX3B0cC5j
IHRvIGF2b2lkIHRoYXQgY29uZmxpY3QuDQoNClRoYW5rcw0KSmlhbnlvbmcgV3UNCg0KPiBSZXN0
IGxvb2tzIGZpbmUuDQo+IA0KPiBDaGVlcnMNCj4gU3V6dWtpDQo=
