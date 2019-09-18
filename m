Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C650B59DA
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 04:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfIRCua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 22:50:30 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:20965
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfIRCua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 22:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJ3uPT8GF0Gl00Cq3URIxPGgcTqUzlQ+4RTIg7+hsGQ=;
 b=gKIcrgFYkGMiwlnMNGDXoG0ZS6J5Q4gyHe8G7IHU+8j0MgGdcvojPpWE9khB0A2B45Ng2aq2Yv44J4DFm5rGVAEb+N8zsd+2VHRdrwohqN/jvcMQ4GnU/DOCCI7BS1ArvpU791rpe8FWsnXTXiyA+21/8Qt1i6pEdPxHWm7iekk=
Received: from VE1PR08CA0023.eurprd08.prod.outlook.com (2603:10a6:803:104::36)
 by AM0PR08MB4404.eurprd08.prod.outlook.com (2603:10a6:208:137::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.24; Wed, 18 Sep
 2019 02:50:22 +0000
Received: from DB5EUR03FT057.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::203) by VE1PR08CA0023.outlook.office365.com
 (2603:10a6:803:104::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17 via Frontend
 Transport; Wed, 18 Sep 2019 02:50:22 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT057.mail.protection.outlook.com (10.152.20.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14 via Frontend Transport; Wed, 18 Sep 2019 02:50:21 +0000
Received: ("Tessian outbound 5061e1b5386c:v31"); Wed, 18 Sep 2019 02:50:16 +0000
X-CR-MTA-TID: 64aa7808
Received: from f6342ead8083.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.1.50])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id F311B91C-03C7-4803-9B61-F527D59C8A69.1;
        Wed, 18 Sep 2019 02:50:11 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01lp2050.outbound.protection.outlook.com [104.47.1.50])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f6342ead8083.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Wed, 18 Sep 2019 02:50:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcHsqYLSq5ldzcw4P1szNXt1xRaFEVWgJPqARWvyKjCBCeoK1wIAKe+goEw6LV47hd+aOyuoW+SSjoBCdl3bOprovx/jIelM9YQ+DUZFfWx8jKBMdaFOVLkbfOc1SWmRtmufX7iTmhdk5oeik0hENI7UM/ih6NSq63OZRdcXpGdKUfgT2kwQAcK6ENbLG7zuzl9RcFnH/Bs5531nsCPWPDFuEySUvbtjxojnj1s0+XkdQldgLOakDgk1AqvV1pcyJ+j21hvvg84VhxqXQfja0rOFi25uk9fYi92Q2ZW+qTX/h/m/rJ6QQX9sqU6RnbIzXQ7d65CwirXWv12WnruQ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJ3uPT8GF0Gl00Cq3URIxPGgcTqUzlQ+4RTIg7+hsGQ=;
 b=OTSjMJlkg9l1IDzTN+E+PNtgWPIyc5L/xaUqbk0d5aDPRpfoGGKSrQdDczQPjvg1S0su8CIX+oButnQK7wmqvXe6BnXqDkuze3iEL+KuMHh78iGQqXndsg4TIZnVo11pDXzaY0vaAHnc01IQl1/oMuz78hRv7Q4XCnK29Er/bsWu2cigpqq5VpRn+tlXFaLhw0INVH6+254mTJWl0FD94WoH+XzKqTj0DXDYLtRHbxi483pMXuximYOuAYUxrKbG1yKN/XgE09SHDSqu/bKYhXFO1JNk0Ja+UC7c7a7eVR2RB3noktMfXunRookevMESRL78X0EHpOC4rs3e5i9Lkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJ3uPT8GF0Gl00Cq3URIxPGgcTqUzlQ+4RTIg7+hsGQ=;
 b=gKIcrgFYkGMiwlnMNGDXoG0ZS6J5Q4gyHe8G7IHU+8j0MgGdcvojPpWE9khB0A2B45Ng2aq2Yv44J4DFm5rGVAEb+N8zsd+2VHRdrwohqN/jvcMQ4GnU/DOCCI7BS1ArvpU791rpe8FWsnXTXiyA+21/8Qt1i6pEdPxHWm7iekk=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2074.eurprd08.prod.outlook.com (10.168.92.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.23; Wed, 18 Sep 2019 02:50:08 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2263.023; Wed, 18 Sep
 2019 02:50:08 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/6] Timer: expose monotonic clock and counter value
Thread-Topic: [PATCH 3/6] Timer: expose monotonic clock and counter value
Thread-Index: AQHVbUqaDFZ5iqdiL0+E9FJrHymYEKcwGwMAgACcHGA=
Date:   Wed, 18 Sep 2019 02:50:07 +0000
Message-ID: <HE1PR0801MB1676426BF970B5A99B9762D8F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190917112430.45680-1-jianyong.wu@arm.com>
 <20190917112430.45680-4-jianyong.wu@arm.com>
 <ad38f692-a7c4-34e0-8236-ebd2d237bd93@kernel.org>
In-Reply-To: <ad38f692-a7c4-34e0-8236-ebd2d237bd93@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 102f8c9b-54c9-422d-8d75-50051e2275f2.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 735425bb-d077-4b9e-f57d-08d73be2f262
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:HE1PR0801MB2074;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2074:|HE1PR0801MB2074:|AM0PR08MB4404:
X-MS-Exchange-PUrlCount: 1
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB44048F188BB1080CBC863CB0F48E0@AM0PR08MB4404.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 01644DCF4A
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(13464003)(189003)(52544003)(4326008)(55016002)(7696005)(8936002)(478600001)(316002)(110136005)(2201001)(966005)(76116006)(256004)(14444005)(9686003)(99286004)(66946007)(66446008)(66476007)(476003)(11346002)(14454004)(71200400001)(446003)(64756008)(2906002)(66556008)(71190400001)(5660300002)(52536014)(186003)(3846002)(53546011)(33656002)(66066001)(229853002)(6306002)(86362001)(25786009)(2501003)(54906003)(6506007)(6116002)(7736002)(305945005)(26005)(6246003)(6636002)(8676002)(81166006)(81156014)(486006)(55236004)(76176011)(102836004)(6436002)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2074;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: iNvgEymX6VTPYDkn71/Gv9Zk6wbSO+VUQ30XfHvlGoMSpgOCKQgcykgFS/nfA2VcWjVEc7nrAeD0xqUCiSs165u307mniVDzy6Inu/6FcukQo8iPXgEbEdSMsSL8v3dCzvH1VONNznUf/F3tSJyA3+pXbvM1aw1p0PQ7Aj/BwYwx0Hd+bdB671NtBmrnJgTWWjzF/itnQEILPgJyLlw1PDbYP2jQza/8hGiuQ8sveWxMFH2Oaumx92anLcppVC37YZ9eeVtYaTZ8c9Q8+IOrtIkVLWli1a6nwBIkaUmNOyRalbbTaXC4Dz+S46fjCRjL3ixupsHYsfIk5/mLparT9lnt5lyoR3lDWQMTJTamrkYUPvqLhK9fQamNs4I5q0Si0x8il9CO1VeNEr5RUJsmDkgCcC7CKI0lSfegCnc7MkA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2074
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT057.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(199004)(189003)(52544003)(13464003)(450100002)(107886003)(26826003)(8676002)(336012)(9686003)(53546011)(70586007)(76176011)(2486003)(25786009)(186003)(4326008)(6306002)(14454004)(6116002)(966005)(86362001)(2201001)(50466002)(74316002)(7696005)(305945005)(7736002)(22756006)(2906002)(23676004)(55016002)(33656002)(99286004)(14444005)(476003)(316002)(26005)(102836004)(356004)(2501003)(6246003)(486006)(229853002)(6636002)(5660300002)(66066001)(47776003)(81156014)(478600001)(3846002)(8936002)(126002)(446003)(81166006)(110136005)(76130400001)(52536014)(436003)(54906003)(70206006)(63350400001)(6506007)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4404;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: c9f33a84-28c7-4b4d-ddd1-08d73be2eae7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR08MB4404;
NoDisclaimer: True
X-Forefront-PRVS: 01644DCF4A
X-Microsoft-Antispam-Message-Info: BF5R3zfwXSxtlMFnwajxbMbdGrYNlDIUCQ+1v89lUNC+kgCPSFJusLi4e2tLJg5WUcoI4Lfqhg4bUqbhNiQ1J2hrLBoij2DL/jciHHaDOrDYP6wgqTGU9UjitrcOSpfGkm/5z0i4Z9UGhM+37LTReQj3rER52ix5rbtAtKeQsUoiIoRxkRgjtFQRmKXhcViS8nGKaye4nv9CYUWCK1veoonW036XUQYJDssq7DFxDfargUaQggXS8tHio6wfM+Igk0+k/eyxddkFpW5hS0ilLv0lVXwBldcsrkd0LwYsetAGrbYGPeJJHR34RlwOgaAAU+V3ZcPIylCuTFq6MTP2hoiVYEq7v0etMVgkHEzTt8YesaVTxw+35XxOF5umnlY5ehuBu5NHTncZdOjM7vbN5Ayk/sinxaRceNg69zHI2kQ=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2019 02:50:21.0713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 735425bb-d077-4b9e-f57d-08d73be2f262
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIFp5
bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAxOCwg
MjAxOSAxOjEwIEFNDQo+IFRvOiBKaWFueW9uZyBXdSAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpIDxK
aWFueW9uZy5XdUBhcm0uY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgcGJvbnppbmlA
cmVkaGF0LmNvbTsNCj4gc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsgcmljaGFyZGNv
Y2hyYW5AZ21haWwuY29tOyBNYXJrIFJ1dGxhbmQNCj4gPE1hcmsuUnV0bGFuZEBhcm0uY29tPjsg
V2lsbCBEZWFjb24gPFdpbGwuRGVhY29uQGFybS5jb20+OyBTdXp1a2kNCj4gUG91bG9zZSA8U3V6
dWtpLlBvdWxvc2VAYXJtLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IFN0ZXZlIENhcHBlciA8U3RldmUuQ2FwcGVyQGFybS5jb20+Ow0KPiBLYWx5IFhpbiAoQXJtIFRl
Y2hub2xvZ3kgQ2hpbmEpIDxLYWx5LlhpbkBhcm0uY29tPjsgSnVzdGluIEhlIChBcm0NCj4gVGVj
aG5vbG9neSBDaGluYSkgPEp1c3Rpbi5IZUBhcm0uY29tPjsgbmQgPG5kQGFybS5jb20+OyBsaW51
eC1hcm0tDQo+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggMy82XSBUaW1lcjogZXhwb3NlIG1vbm90b25pYyBjbG9jayBhbmQgY291bnRlciB2YWx1ZQ0K
PiANCj4gT24gMTcvMDkvMjAxOSAxMjoyNCwgSmlhbnlvbmcgV3Ugd3JvdGU6DQo+ID4gQSBudW1i
ZXIgb2YgUFRQIGRyaXZlcnMgKHN1Y2ggYXMgcHRwLWt2bSkgYXJlIGFzc3VtaW5nIHdoYXQgdGhl
DQo+ID4gY3VycmVudCBjbG9jayBzb3VyY2UgaXMsIHdoaWNoIGNvdWxkIGxlYWQgdG8gaW50ZXJl
c3RpbmcgZWZmZWN0cyBvbg0KPiA+IHN5c3RlbXMgd2hlcmUgdGhlIGNsb2Nrc291cmNlIGNhbiBj
aGFuZ2UgZGVwZW5kaW5nIG9uIGV4dGVybmFsIGV2ZW50cy4NCj4gPg0KPiA+IEZvciB0aGlzIHB1
cnBvc2UsIGFkZCBhIG5ldyBBUEkgdGhhdCByZXRyaXZlcyBib3RoIHRoZSBjdXJyZW50DQo+ID4g
bW9ub3RvbmljIGNsb2NrIGFzIHdlbGwgYXMgaXRzIGNvdW50ZXIgdmFsdWUuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEppYW55b25nIFd1IDxqaWFueW9uZy53dUBhcm0uY29tPg0KPiANCj4gVGhlcmUgbXVz
dCBiZSBzb21ldGhpbmcgd3Jvbmcgd2l0aCB0aGUgd2F5IHlvdSd2ZSB0YWtlbiB0aGlzIHBhdGNo
IGluIHlvdXINCj4gdHJlZS4gTXkgYXV0aG9yc2hpcCBpcyBnb25lIChub3QgdGhhdCBJIGRlZXBs
eSBjYXJlIGFib3V0IGl0LCBidXQgaXQgaXMgZ29vZA0KPiBwcmFjdGljZSB0byBrZWVwIGF0dHJp
YnV0aW9ucyksIGFuZCB0aGUgc3ViamVjdCBsaW5lIGhhcyBiZWVuIHJld3JpdHRlbi4NCj4gDQo+
IEknZCBhcHByZWNpYXRlIGl0IGlmIHlvdSBjb3VsZCBmaXggdGhpcyBpbiBhIGZ1dHVyZSByZXZp
c2lvbiBvZiB0aGlzIHNlcmllcy4gRm9yDQo+IHJlZmVyZW5jZSwgdGhlIG9yaWdpbmFsIHBhdGNo
IGlzIGhlcmVbMV0uDQo+IA0KDQpTb3JyeSBmb3IgInN0ZWFsIiB5b3VyIHBhdGNoLCBJJ20gbm90
IGZhbWlsaWFyIHdpdGggaXQgYW5kIG5lZ2xlY3QgdGhpcyBpbXBvcnRhbnQgY2hhbmdlLg0KSSBq
dXN0IGNvcHkgdGhpcyBwYXRjaCBmcm9tIHlvdXIgZW1haWwgYW5kIGFkZCB0aGUgc3ViamVjdCBt
eXNlbGYuDQpJIHdpbGwgZml4IGFsbCBvZiB0aGVtIGxhdGVyIGluIHYzLg0KDQo+ID4gLS0tDQo+
ID4gIGluY2x1ZGUvbGludXgvdGltZWtlZXBpbmcuaCB8ICAzICsrKw0KPiA+ICBrZXJuZWwvdGlt
ZS90aW1la2VlcGluZy5jICAgfCAxMyArKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgMTYgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
dGltZWtlZXBpbmcuaCBiL2luY2x1ZGUvbGludXgvdGltZWtlZXBpbmcuaA0KPiA+IGluZGV4IGE4
YWIwZjE0M2FjNC4uYTUzODlhZGFhOGJjIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgv
dGltZWtlZXBpbmcuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvdGltZWtlZXBpbmcuaA0KPiA+
IEBAIC0yNDcsNiArMjQ3LDkgQEAgZXh0ZXJuIGludCBnZXRfZGV2aWNlX3N5c3RlbV9jcm9zc3Rz
dGFtcCgNCj4gPiAgCQkJc3RydWN0IHN5c3RlbV90aW1lX3NuYXBzaG90ICpoaXN0b3J5LA0KPiA+
ICAJCQlzdHJ1Y3Qgc3lzdGVtX2RldmljZV9jcm9zc3RzdGFtcCAqeHRzdGFtcCk7DQo+ID4NCj4g
PiArLyogT2J0YWluIGN1cnJlbnQgbW9ub3RvbmljIGNsb2NrIGFuZCBpdHMgY291bnRlciB2YWx1
ZSAgKi8gZXh0ZXJuDQo+ID4gK3ZvaWQgZ2V0X2N1cnJlbnRfY291bnRlcnZhbChzdHJ1Y3Qgc3lz
dGVtX2NvdW50ZXJ2YWxfdCAqc2MpOw0KPiA+ICsNCj4gPiAgLyoNCj4gPiAgICogU2ltdWx0YW5l
b3VzbHkgc25hcHNob3QgcmVhbHRpbWUgYW5kIG1vbm90b25pYyByYXcgY2xvY2tzDQo+ID4gICAq
Lw0KPiA+IGRpZmYgLS1naXQgYS9rZXJuZWwvdGltZS90aW1la2VlcGluZy5jIGIva2VybmVsL3Rp
bWUvdGltZWtlZXBpbmcuYw0KPiA+IGluZGV4IDQ0YjcyNmJhYjRiZC4uMDdhMDk2OTYyNWIxIDEw
MDY0NA0KPiA+IC0tLSBhL2tlcm5lbC90aW1lL3RpbWVrZWVwaW5nLmMNCj4gPiArKysgYi9rZXJu
ZWwvdGltZS90aW1la2VlcGluZy5jDQo+ID4gQEAgLTEwOTgsNiArMTA5OCwxOSBAQCBzdGF0aWMg
Ym9vbCBjeWNsZV9iZXR3ZWVuKHU2NCBiZWZvcmUsIHU2NCB0ZXN0LA0KPiB1NjQgYWZ0ZXIpDQo+
ID4gIAlyZXR1cm4gZmFsc2U7DQo+ID4gIH0NCj4gPg0KPiA+ICsvKioNCj4gPiArICogZ2V0X2N1
cnJlbnRfY291bnRlcnZhbCAtIFNuYXBzaG90IHRoZSBjdXJyZW50IGNsb2Nrc291cmNlIGFuZCBj
b3VudGVyDQo+IHZhbHVlDQo+ID4gKyAqIEBzYzoJUG9pbnRlciB0byBhIHN0cnVjdCBjb250YWlu
aW5nIHRoZSBjdXJyZW50IGNsb2Nrc291cmNlIGFuZCBpdHMNCj4gdmFsdWUNCj4gPiArICovDQo+
ID4gK3ZvaWQgZ2V0X2N1cnJlbnRfY291bnRlcnZhbChzdHJ1Y3Qgc3lzdGVtX2NvdW50ZXJ2YWxf
dCAqc2MpIHsNCj4gPiArCXN0cnVjdCB0aW1la2VlcGVyICp0ayA9ICZ0a19jb3JlLnRpbWVrZWVw
ZXI7DQo+ID4gKw0KPiA+ICsJc2MtPmNzID0gUkVBRF9PTkNFKHRrLT50a3JfbW9uby5jbG9jayk7
DQo+ID4gKwlzYy0+Y3ljbGVzID0gc2MtPmNzLT5yZWFkKHNjLT5jcyk7DQo+ID4gK30NCj4gPiAr
RVhQT1JUX1NZTUJPTF9HUEwoZ2V0X2N1cnJlbnRfY291bnRlcnZhbCk7DQo+IA0KPiBUaGlzIGV4
cG9ydCB3YXNuJ3QgaW4gbXkgb3JpZ2luYWwgcGF0Y2guIEkgZ3Vlc3MgeW91IG5lZWQgaXQgYmVj
YXVzZSB5b3VyIHB0cA0KPiBkcml2ZXIgYnVpbGRzIGFzIGEgbW9kdWxlPyBJdCdkIGJlIGdvb2Qg
dG8gbWVudGlvbiBpdCBpbiB0aGUgY29tbWl0IGxvZy4NCj4gDQpZZWFoLCBwdHBfa3ZtIHdpbGwg
YmUgYSBtb2R1bGUsIHNvIGV4cG9ydCBpcyBuZWNlc3NhcnkuIEkgd2lsbCBtZW50aW9uIHRoaXMg
Y2hhbmdlDQppbiBjb21taXQgbG9nLg0KDQpUaGFua3MNCkppYW55b25nIFd1DQoNCj4gPiArDQo+
ID4gIC8qKg0KPiA+ICAgKiBnZXRfZGV2aWNlX3N5c3RlbV9jcm9zc3RzdGFtcCAtIFN5bmNocm9u
b3VzbHkgY2FwdHVyZQ0KPiBzeXN0ZW0vZGV2aWNlIHRpbWVzdGFtcA0KPiA+ICAgKiBAZ2V0X3Rp
bWVfZm46CUNhbGxiYWNrIHRvIGdldCBzaW11bHRhbmVvdXMgZGV2aWNlIHRpbWUgYW5kDQo+ID4N
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiANCj4gWzFdDQo+IGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21hei9hcm0tDQo+IHBsYXRmb3Jtcy5naXQv
Y29tbWl0Lz9oPXRpbWVyL2NvdW50ZXJ2YWwmaWQ9YTZlOGFiY2UwMjU2OTFiNmE1NWUxYzE5NQ0K
PiA4NzhkN2Y3NmJmZWI5ZDENCj4gLS0NCj4gSmF6eiBpcyBub3QgZGVhZCwgaXQganVzdCBzbWVs
bHMgZnVubnkuLi4NCg==
