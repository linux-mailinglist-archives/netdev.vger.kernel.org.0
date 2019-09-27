Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E49C0380
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfI0KgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:36:09 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:13884
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbfI0KgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHcdoF54D9BiMQlnQNMi1xxISdD/Thbn1ourleAWJew=;
 b=sV0OEhG8vrsjgGsjsJPHnSKXzwa1+crNB49fETcWL++zJcFeCDvbOIy7CVHX7YyKlvhG7HnZt9czAxz0yn1nUqAcLf21SJQkuqtyA+rnLATsnDbJk6jZaL9NDDJWthvV+6lgYYSUK5FsDl7vlKObqNT8Ez0QKQBQHynyaY7eP1U=
Received: from VI1PR08CA0228.eurprd08.prod.outlook.com (2603:10a6:802:15::37)
 by VI1PR08MB4046.eurprd08.prod.outlook.com (2603:10a6:803:e4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2305.20; Fri, 27 Sep
 2019 10:36:01 +0000
Received: from VE1EUR03FT033.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::205) by VI1PR08CA0228.outlook.office365.com
 (2603:10a6:802:15::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2305.15 via Frontend
 Transport; Fri, 27 Sep 2019 10:36:01 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT033.mail.protection.outlook.com (10.152.18.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2305.15 via Frontend Transport; Fri, 27 Sep 2019 10:36:00 +0000
Received: ("Tessian outbound 927f2cdd66cc:v33"); Fri, 27 Sep 2019 10:35:58 +0000
X-CR-MTA-TID: 64aa7808
Received: from 5f7cc7921a1a.4 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.13.56])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id F370A33A-78CE-4A24-959C-49399167C8B1.1;
        Fri, 27 Sep 2019 10:35:53 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 5f7cc7921a1a.4
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Fri, 27 Sep 2019 10:35:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJzXmHsrAm1axVKLEUhbQkogIGyN+SZk/8RynuaWrw9qqg/Vyxn36cwXpyMXYzejQJK1qyDOZecol6lU6mgvS6qXPfYRb4HqgCm/fbjbGmpbEsyxtP6oUhRXjnGfa4PRzV/A7+GeGvEAUtyZfjDNUt7e2Fc5hylRZnAWYKyJZxquEmTJ11cq2/cXnPrHsC3B3nhrD32WeT0H7tzE82Z0UDGvY+s1rIwhxxNVdtQ9ENBFFd5TC6maF+NyiId1kkMOKmly8zDB+jU7OsP8EM/0kciFQFFopzEZRCC9MMERwn+CMmeVuvYvU7fmtDIrtrM/U6NflzCOaN1bDunrNMPQHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHcdoF54D9BiMQlnQNMi1xxISdD/Thbn1ourleAWJew=;
 b=msG8Sq0EBVvQN2AbpxWcKGrielObWbzAAiXCAiJzwAIwl2wJ2PmUeoDRZLyRZ8E10coBND+ZB/L4BvYBU6OrJYMjCuBbJXwT9EQ1D6MNlzFW0jVU+ab7tsYjD9vA0oLBNeb3uftFceT3teLghAXArn6RebDEZ1MDX9auzyRL/hLoPRTi3DGvFnupNywalm1sNA33fdDl1tQ+gGqrSmfnfFl8yt/EMXTvxjMkB2rGS/ZaBZutWkp3y5W+wX8V7Mh6qdbK2ZwPVy67dWQMeVx6CG/j19lZzJNpvwmx3zfP1wQ0jPmdBJ1ihVXLaJhy/H3kecMMIOAMvj74fSZMR4Ym7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHcdoF54D9BiMQlnQNMi1xxISdD/Thbn1ourleAWJew=;
 b=sV0OEhG8vrsjgGsjsJPHnSKXzwa1+crNB49fETcWL++zJcFeCDvbOIy7CVHX7YyKlvhG7HnZt9czAxz0yn1nUqAcLf21SJQkuqtyA+rnLATsnDbJk6jZaL9NDDJWthvV+6lgYYSUK5FsDl7vlKObqNT8Ez0QKQBQHynyaY7eP1U=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1996.eurprd08.prod.outlook.com (10.168.97.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 27 Sep 2019 10:35:50 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::4d35:2b8f:1786:84cd%3]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 10:35:50 +0000
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
Thread-Index: AQHVdF+Ft3UnKFEitUOtlQstSNDglqc/UlgAgAADTsA=
Date:   Fri, 27 Sep 2019 10:35:50 +0000
Message-ID: <HE1PR0801MB1676C739058C44645D726C72F4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
 <47ceb25c-c9ff-e284-43bf-6cac7e128a98@arm.com>
In-Reply-To: <47ceb25c-c9ff-e284-43bf-6cac7e128a98@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6d537bca-1c2d-4e6a-bfe5-12f285ab8d8b.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: fb7200db-fddb-4ee8-53cf-08d743367d46
X-MS-Office365-Filtering-HT: Tenant
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1996:|HE1PR0801MB1996:|VI1PR08MB4046:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB4046A32DC3424AF318ABC297F4810@VI1PR08MB4046.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:4714;OLM:4714;
x-forefront-prvs: 0173C6D4D5
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(199004)(189003)(13464003)(5660300002)(52536014)(71190400001)(256004)(71200400001)(478600001)(11346002)(476003)(8676002)(229853002)(81166006)(81156014)(2501003)(305945005)(99286004)(74316002)(7736002)(8936002)(7416002)(446003)(66066001)(76116006)(14454004)(7696005)(26005)(102836004)(6506007)(66446008)(186003)(25786009)(53546011)(486006)(66556008)(64756008)(66946007)(66476007)(76176011)(55236004)(86362001)(2201001)(6246003)(55016002)(6636002)(4326008)(9686003)(54906003)(110136005)(33656002)(316002)(6436002)(2906002)(6116002)(3846002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1996;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: fUfMtMH09SaJHMMSXV4YPYqgl7wdRx1SbUvLJ9N0u/Oq9j4Ylh4hiZ6+keMyN/Fao4rNMqnrFEq1z00mxliidyc/o3NnCp4xrNPIMYdQfDSUEnq4/9JXTiBD4J5VVnZQCDAC+2kAsDeIBKIJlRjkMLGb4EA0aVjMDDuvdXv7YoCbFBNH2gnXux4pNHVEcWTyZIKPqV59AKWxvGO0XYG0YDVxh7jtIgQqlbolJQ+kNjuO9lDUjogZX1lbrhy2GayZ560h9LfW7MpvB9uA6ZYNLJrjAbTKNIi1WvTqJnjGvJP0CwsLtgeENU6wyrLy/IvxjQO1Pyv0zTmyR8DuAmZLj1freMWJNYb5sJC85zDlhpNOHE2gJO9lgaRBW1erWiJhSGzt0BmVUU2uN/6UM7kYrHTwVPm3ih0vomV80rmCrHU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1996
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT033.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(199004)(189003)(13464003)(26005)(53546011)(6506007)(36906005)(4326008)(316002)(7696005)(7736002)(2501003)(54906003)(99286004)(110136005)(74316002)(76176011)(23676004)(305945005)(2486003)(102836004)(86362001)(2201001)(6636002)(356004)(70586007)(446003)(76130400001)(70206006)(436003)(476003)(126002)(486006)(63350400001)(11346002)(14454004)(50466002)(81156014)(6116002)(8676002)(66066001)(81166006)(3846002)(47776003)(336012)(478600001)(186003)(52536014)(26826003)(25786009)(9686003)(22756006)(2906002)(33656002)(5660300002)(8936002)(450100002)(55016002)(229853002)(6246003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB4046;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: d3d1f84f-d3d2-4030-2a2c-08d74336773e
NoDisclaimer: True
X-Forefront-PRVS: 0173C6D4D5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSYYkuNYYIZFGJ6B5jHk30eQyi7/P8VQWsCFDsg2j/n1xW5u/mj++lbe4l0Gi/nVTfLEhzSPfq5XwjwSBEC0oEdcN688zuySG1/y/WeJiJnN4qoE3gkDRdfnngDm/w8CUl9fbB97D0E6B+yQOwPHM9Susat750WFyfW8HMEnf7i7NC3HBGXJXzR9T/lxPsYaKuS8L4nBcWf+0GZWxff8qJy7yfbQVDWaXefPZumidABwFbRH+SB617z3iLGsAimLH9rEGr8BhtXnL+JTuvbzNQewNwfPcdJLOR7NGLZAe+gRHZPzKk0xY4iJZ4VG1CTG2onWqv94Hez1b3eQXDKL55JecnTQeYxlUcxw0F+aVcoE+wIPp/NesoDbpz/gSdQuKxJgdrUmCa/BHrV/DGZYZ/VOzrhL8X9HQ+UhnmHeU4k=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2019 10:36:00.3609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7200db-fddb-4ee8-53cf-08d743367d46
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3V6dWtpLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN1enVr
aSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgU2Vw
dGVtYmVyIDI3LCAyMDE5IDY6MjMgUE0NCj4gVG86IEppYW55b25nIFd1IChBcm0gVGVjaG5vbG9n
eSBDaGluYSkgPEppYW55b25nLld1QGFybS5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyB5YW5nYm8ubHVAbnhwLmNvbTsgam9obi5zdHVsdHpAbGluYXJvLm9yZzsNCj4gdGdseEBsaW51
dHJvbml4LmRlOyBwYm9uemluaUByZWRoYXQuY29tOyBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50
ZWwuY29tOw0KPiBtYXpAa2VybmVsLm9yZzsgcmljaGFyZGNvY2hyYW5AZ21haWwuY29tOyBNYXJr
IFJ1dGxhbmQNCj4gPE1hcmsuUnV0bGFuZEBhcm0uY29tPjsgV2lsbCBEZWFjb24gPFdpbGwuRGVh
Y29uQGFybS5jb20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1h
cm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHU7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFN0ZXZlIENhcHBlcg0KPiA8U3RldmUuQ2FwcGVy
QGFybS5jb20+OyBLYWx5IFhpbiAoQXJtIFRlY2hub2xvZ3kgQ2hpbmEpDQo+IDxLYWx5LlhpbkBh
cm0uY29tPjsgSnVzdGluIEhlIChBcm0gVGVjaG5vbG9neSBDaGluYSkNCj4gPEp1c3Rpbi5IZUBh
cm0uY29tPjsgbmQgPG5kQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIHY0IDIv
NV0gcHRwOiBSZW9yZ2FuaXplIHB0cF9rdm0gbW9kdWxlcyB0byBtYWtlIGl0DQo+IGFyY2gtaW5k
ZXBlbmRlbnQuDQo+IA0KPiANCj4gDQo+IE9uIDI2LzA5LzIwMTkgMTI6NDIsIEppYW55b25nIFd1
IHdyb3RlOg0KPiA+IEN1cnJlbnRseSwgcHRwX2t2bSBtb2R1bGVzIGltcGxlbWVudGF0aW9uIGlz
IG9ubHkgZm9yIHg4NiB3aGljaA0KPiA+IGluY2x1ZHMgbGFyZ2UgcGFydCBvZiBhcmNoLXNwZWNp
ZmljIGNvZGUuICBUaGlzIHBhdGNoIG1vdmUgYWxsIG9mDQo+ID4gdGhvc2UgY29kZSBpbnRvIG5l
dyBhcmNoIHJlbGF0ZWQgZmlsZSBpbiB0aGUgc2FtZSBkaXJlY3RvcnkuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBKaWFueW9uZyBXdSA8amlhbnlvbmcud3VAYXJtLmNvbT4NCj4gDQo+IC4uLg0K
PiANCj4gPiAraW50IGt2bV9hcmNoX3B0cF9nZXRfY2xvY2tfZm4odW5zaWduZWQgbG9uZyAqY3lj
bGUsIHN0cnVjdCB0aW1lc3BlYzY0DQo+ICp0c3BlYywNCj4gPiArCQkJICAgICAgc3RydWN0IGNs
b2Nrc291cmNlICoqY3MpDQo+IA0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9hc20tZ2Vu
ZXJpYy9wdHBfa3ZtLmgNCj4gPiBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvcHRwX2t2bS5oIG5ldyBm
aWxlIG1vZGUgMTAwNjQ0IGluZGV4DQo+ID4gMDAwMDAwMDAwMDAwLi4yMDhlODQyYmZhNjQNCj4g
PiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9wdHBfa3ZtLmgN
Cj4gDQo+ID4gK2ludCBrdm1fYXJjaF9wdHBfZ2V0X2Nsb2NrX2ZuKGxvbmcgKmN5Y2xlLA0KPiA+
ICsJCXN0cnVjdCB0aW1lc3BlYzY0ICp0c3BlYywgdm9pZCAqY3MpOw0KPiA+DQo+IA0KPiBDb25m
bGljdGluZyB0eXBlcyBmb3Iga3ZtX2FyY2hfcHRwX2dldF9jbG9ja19mbigpID8NCj4gDQpZZWFo
LCBuZWVkIGZpeC4NCg0KVGhhbmtzDQpKaWFueW9uZyBXdQ0KDQo+IFN1enVraQ0K
