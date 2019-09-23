Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303D3BAD5B
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 06:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfIWE6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 00:58:22 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:3495
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729231AbfIWE6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 00:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlAhPzzpZmZ/eEntNIvFjTQfOt8cQYIJkYmyHkGlZe0=;
 b=TaRC5T9f6z51Hof2ke7/8KJF9xJKjkBzuhMf7sijv9UBUqwicPpH0ntHWAcu8J3pvxT3jdyDjbM0Rq/7sjdzYEOmzW3BkUFXukBjOa3baH3jjbgITwTpbMWJEvkCbmpivVjHTreGLaMv2DFLHI8D2owXyfm0H/utXfn2U8YIHYI=
Received: from DB6PR0802CA0040.eurprd08.prod.outlook.com (2603:10a6:4:a3::26)
 by VI1PR0801MB1998.eurprd08.prod.outlook.com (2603:10a6:800:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.18; Mon, 23 Sep
 2019 04:58:11 +0000
Received: from DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::205) by DB6PR0802CA0040.outlook.office365.com
 (2603:10a6:4:a3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.20 via Frontend
 Transport; Mon, 23 Sep 2019 04:58:11 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT053.mail.protection.outlook.com (10.152.21.119) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20 via Frontend Transport; Mon, 23 Sep 2019 04:58:09 +0000
Received: ("Tessian outbound d5a1f2820a4f:v31"); Mon, 23 Sep 2019 04:58:05 +0000
X-CR-MTA-TID: 64aa7808
Received: from cd8b0bf95c0c.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.4.59])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id AD0F2F78-4B44-497C-A564-B874842DF3CA.1;
        Mon, 23 Sep 2019 04:58:00 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2059.outbound.protection.outlook.com [104.47.4.59])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cd8b0bf95c0c.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Mon, 23 Sep 2019 04:58:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHcMumab9RLbeKLL37Wncn6B+4QwIq0jW8TXTXWFKrO0YJwvord5PLud5iC96w0vRLEJeJ4SaiJdJnuCu6BODsoptVT3e8JY44Q/45fnpacYJ2MM1QOhHzv1Ajm4iGR2Daq9xbr0LKoBBPJzciJZ1KcS1q5k6DVUfR8htF+aLAzrQGxxMnxYU1H012DHa60hX3/dZ9AwZRwYHzcUmyQWeIqbU3hJbLTB/hJifa2f9saSA4xA/w5TgCMGd7gnE/blhQTktMeiDHIRzQaGcJBrAziilDhV06dLYs3NoQISBAGPQ1AkDKOl/bxK6YtCZSdVBn9sa/Ea12bP5A4rI+3Hgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlAhPzzpZmZ/eEntNIvFjTQfOt8cQYIJkYmyHkGlZe0=;
 b=BqT0PuzXCARypRTN+XhioUdEUCFCsdDz5Ll1RaMfrBJsglx6iZDmkNZnCR2T0ZnZ1OHjz/p8PLzwx3QfenHZD47+8bNrlyHnz13hYDxk68WiV3qJa0mxJJOT93zdgP7Hq4Si7o3ZO8umT2e0MbSjVRBO3QPbrzEgjD9QFbwIloBdR+V4+u5Ewv0FA1Xfo73wKeM3fs8YOhweA92/4+bcY3GZZFO5nUj5z7bX4j+8PnFD4HjBXdIp0IhP7NQ86NQo/srH4O4SoX65fno5wCK+/qNz/855YWbtWrebD7m0Oj9UV+pkVX9KrYW7uXUztOtoO1b/RnyIx+WTGXUFr+q7WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlAhPzzpZmZ/eEntNIvFjTQfOt8cQYIJkYmyHkGlZe0=;
 b=TaRC5T9f6z51Hof2ke7/8KJF9xJKjkBzuhMf7sijv9UBUqwicPpH0ntHWAcu8J3pvxT3jdyDjbM0Rq/7sjdzYEOmzW3BkUFXukBjOa3baH3jjbgITwTpbMWJEvkCbmpivVjHTreGLaMv2DFLHI8D2owXyfm0H/utXfn2U8YIHYI=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2076.eurprd08.prod.outlook.com (10.168.93.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.23; Mon, 23 Sep 2019 04:57:58 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 04:57:57 +0000
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
Thread-Index: AQHVbfg5HjMQ+p5UhEyfzqBy9sDEZacxGVuAgAAQMICAABDUgIABdZhAgAAo7ACABcbzoA==
Date:   Mon, 23 Sep 2019 04:57:57 +0000
Message-ID: <HE1PR0801MB1676A9D4A58118144F5C7B54F4850@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-5-jianyong.wu@arm.com>
 <83ed7fac-277f-a31e-af37-8ec134f39d26@redhat.com>
 <HE1PR0801MB1676F57B317AE85E3B934B32F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <629538ea-13fb-e666-8df6-8ad23f114755@redhat.com>
 <HE1PR0801MB167639E2F025998058A77F86F4890@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
In-Reply-To: <ef6ab8bd-41ad-88f8-9cfd-dc749ca65310@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 01bfebe5-072f-43ba-8ca4-955694402748.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 1f15f7b1-e0e9-4d35-8f53-08d73fe2a15f
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB2076;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2076:|HE1PR0801MB2076:|VI1PR0801MB1998:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB1998A0A64903CE119771C480F4850@VI1PR0801MB1998.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0169092318
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(189003)(13464003)(199004)(81166006)(8676002)(81156014)(229853002)(6636002)(9686003)(66066001)(55016002)(6436002)(2501003)(66476007)(66556008)(64756008)(66446008)(33656002)(7736002)(52536014)(99286004)(74316002)(7416002)(4326008)(2906002)(76176011)(53546011)(256004)(6506007)(14444005)(478600001)(7696005)(55236004)(3846002)(5660300002)(476003)(71200400001)(486006)(71190400001)(86362001)(446003)(11346002)(2201001)(25786009)(305945005)(6246003)(102836004)(6116002)(76116006)(26005)(316002)(186003)(66946007)(54906003)(110136005)(8936002)(14454004)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2076;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: kMfb5yGoBAOYdap4NnEl+/ovGD30zhqcN7hrOqus020ZjZcBmogUZlRjjB9v0SRZ8EyA1aB0Ttw7DPCcxs95c44iywfnctDMvL0U1Vyn0UY3ZNfdBAp0P7SQkfeCSxWIK5SYfcE1H69Lco6QG0ghpz3/prTVCVFpIMImm7NWpyoJAT0jca1+sQDciYdOSswLz+9zkslzMJfuVn6fLMATmtF+WnfIQGZaF49gAEM9UsCO7vWOX+6tm4yPhTfaTHqnex0VQDB6vmoVkAjvXokQdRN3pzu0YgrHnh4FygizQBvfomlTP0qNplK5IXlSnPv+GvL0A2bJTgF7mGc3nv5vq0WAJ5FcJBLUqpjBiZZ7g4sEP1765BJN30logNz1Ldjuhm+JQ+lLEtZ/Zx79ggLcERpnesm8Ag9+MdEhTqSV0g0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2076
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(39860400002)(13464003)(189003)(199004)(55016002)(99286004)(9686003)(8676002)(126002)(70206006)(70586007)(6636002)(316002)(305945005)(110136005)(54906003)(11346002)(8936002)(476003)(446003)(107886003)(356004)(7696005)(2486003)(2501003)(76130400001)(76176011)(23676004)(53546011)(74316002)(6506007)(86362001)(2201001)(102836004)(5660300002)(478600001)(450100002)(25786009)(7736002)(6246003)(66066001)(47776003)(26826003)(229853002)(52536014)(33656002)(4326008)(436003)(63350400001)(26005)(186003)(14454004)(336012)(50466002)(14444005)(486006)(22756006)(81166006)(2906002)(81156014)(6116002)(3846002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0801MB1998;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 6136431a-d087-47d7-5d41-08d73fe29a40
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0801MB1998;
NoDisclaimer: True
X-Forefront-PRVS: 0169092318
X-Microsoft-Antispam-Message-Info: wW3QOzmxlLTC+/7Uvil9ihoh87LboztKxrl0Q/h9w77O1J4nzzVChLwUxDm3OjTCJEqdPIwgu2wNcUeqAsefFnx2V1c3S6AsxTQdkIgmIcUo+5FYSwwITH5ReUC9D1MH8ef0cPVQK9FcK3UsC9AQb6849CmL/wZWy+ckttVSzwpzeR/Ra9iQWD+gAgbZl59SVP/jy7cbgqBu2snCUzJk/aRY/7v8adIlGt7hpWxZAKygcdz7iNGiUyZ6sa6/31PhCyGWvejnmbowJpzc9wVbJPXNqS5l6Sx/M3qEXd/aomaOWrCkNMaxgp7eBd32yQe0KGSBnpeDY0dTaitTXVTO0BzTtW9sGCVPG9tH3Bjw4XvaOhBmxkBaQa4sD7+LbnAc3bK1pdQa3cn4aYuMzfd/ug125pSzYNnjovjQs9WJ+cI=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2019 04:58:09.7937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f15f7b1-e0e9-4d35-8f53-08d73fe2a15f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1998
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFvbG8sIE1hcmMNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQ
YW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgU2Vw
dGVtYmVyIDE5LCAyMDE5IDc6MDcgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9n
eSBDaGluYSkgPEppYW55b25nLld1QGFybS5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyB5YW5nYm8ubHVAbnhwLmNvbTsgam9obi5zdHVsdHpAbGluYXJvLm9yZzsNCj4gdGdseEBsaW51
dHJvbml4LmRlOyBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tOyBtYXpAa2VybmVsLm9y
ZzsNCj4gcmljaGFyZGNvY2hyYW5AZ21haWwuY29tOyBNYXJrIFJ1dGxhbmQgPE1hcmsuUnV0bGFu
ZEBhcm0uY29tPjsgV2lsbA0KPiBEZWFjb24gPFdpbGwuRGVhY29uQGFybS5jb20+OyBTdXp1a2kg
UG91bG9zZQ0KPiA8U3V6dWtpLlBvdWxvc2VAYXJtLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFN0ZXZlIENhcHBlcg0KPiA8U3Rl
dmUuQ2FwcGVyQGFybS5jb20+OyBLYWx5IFhpbiAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+IDxL
YWx5LlhpbkBhcm0uY29tPjsgSnVzdGluIEhlIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEp1
c3Rpbi5IZUBhcm0uY29tPjsgbmQgPG5kQGFybS5jb20+OyBsaW51eC1hcm0tDQo+IGtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHYzIDQvNl0gcHNj
aTogQWRkIGh2YyBjYWxsIHNlcnZpY2UgZm9yIHB0cF9rdm0uDQo+IA0KPiBPbiAxOS8wOS8xOSAx
MTo0NiwgSmlhbnlvbmcgV3UgKEFybSBUZWNobm9sb2d5IENoaW5hKSB3cm90ZToNCj4gPj4gT24g
MTgvMDkvMTkgMTE6NTcsIEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9neSBDaGluYSkgd3JvdGU6
DQo+ID4+PiBQYW9sbyBCb256aW5pIHdyb3RlOg0KPiA+Pj4+IFRoaXMgaXMgbm90IFkyMDM4LXNh
ZmUuICBQbGVhc2UgdXNlIGt0aW1lX2dldF9yZWFsX3RzNjQgaW5zdGVhZCwNCj4gPj4+PiBhbmQg
c3BsaXQgdGhlIDY0LWJpdCBzZWNvbmRzIHZhbHVlIGJldHdlZW4gdmFsWzBdIGFuZCB2YWxbMV0u
DQo+ID4NCj4gPiBWYWxbXSBzaG91bGQgYmUgbG9uZyBub3QgdTMyIEkgdGhpbmssIHNvIGluIGFy
bTY0IEkgY2FuIGF2b2lkIHRoYXQNCj4gPiBZMjAzOF9zYWZlLCBidXQgYWxzbyBuZWVkIHJld3Jp
dGUgZm9yIGFybTMyLg0KPiANCj4gSSBkb24ndCB0aGluayB0aGVyZSdzIGFueXRoaW5nIGluaGVy
ZW50bHkgd3Jvbmcgd2l0aCB1MzIgdmFsW10sIGFuZCBhcyB5b3UNCj4gbm90aWNlIGl0IGxldHMg
eW91IHJldXNlIGNvZGUgYmV0d2VlbiBhcm0gYW5kIGFybTY0LiAgSXQncyB1cCB0byB5b3UgYW5k
DQo+IE1hcmMgdG8gZGVjaWRlLg0KPiANClRvIGNvbXBhdGlibGUgMzItYml0LCBJbnRlZ3JhdGVz
IHNlY29uZCB2YWx1ZSBhbmQgbmFub3NlY29uZCB2YWx1ZSBhcyBhIG5hbm9zZWNvbmQgdmFsdWUg
dGhlbiBzcGxpdCBpdCBpbnRvIHZhbFswXSBhbmQgdmFsWzFdIGFuZCBzcGxpdCBjeWNsZSB2YWx1
ZSBpbnRvIHZhbFsyXSBhbmQgdmFsWzNdLA0KIEluIHRoaXMgd2F5LCB0aW1lIHdpbGwgb3ZlcmZs
b3cgYXQgWTIyNjIuDQpXRFlUPw0KDQpUaGFua3MNCkppYW55b25nIFd1DQoNCg==
