Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C195B17D215
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 07:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCHGtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 01:49:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40434 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgCHGtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 01:49:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0286m28Q007156;
        Sat, 7 Mar 2020 22:48:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=s4z9kenL1VV3XzFpz/6OLODlErTPSoqQOqrlDcSRtMY=;
 b=wcMMYbfTHUQsctV/iJzcRHYyogQR3npcLhIp51zQbes3Q8geQyZQ/tb9zBkNGnW+G9G+
 FP38iJHSPxlnWyqRR/rTEeVvEtLENV/vbBSt+jDqTOb1esF2elvv5lDZIZnb3WV19+M+
 d26K1OjPtpNAnee8134BR95OSimGGi1DZLrOjUnOQMFTXtGtGb7fIFKn2uM6YR2AihKP
 RyePul2S+wT0LS/WU2xzQuue7UWVvshUfns1X+C0hgOPf1L6P+x7tPjp6s4Ir5fnlfdF
 Ei7w9Zu226MeQuXo6ZPdwOuxuPcORnOIGU7dCcXp3Pe8/NX9qE9vD4SHFh31NukjTRcO PA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwb6qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 22:48:47 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 22:48:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 22:48:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jp3McjKBtCiI3b5Qh08YTohlR+zqMeR8WhyCO1s+35n7v7z6VFaYgDQrGGKqVwfFj+IAkJ93r5bvI9bhd7yLn6xj0NQVU+KAANfM0eT6kUA5NWOiiQNqEBAi9FFFtpfjOkAO6fuV1a3BMhExW7E61mjW53XfW3WWyIyXTbfA4f6ekh88JoduU3WXi8cWMxz0R3z9uUc+jOymM8tegHOz2YZ+iF2mC6utLXchT2plSglid9FhKCs2xu5mkW9uiPSZYMduryGAYrQ5V6fypB/tBCyFAOOPAUqy8pRoMzCRo5rEWzy2fSYvyvFODVJTqqmLbUbrX3wGNudjKyXZBhuhfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4z9kenL1VV3XzFpz/6OLODlErTPSoqQOqrlDcSRtMY=;
 b=B7zBEMEBmLxjRgU22k07tNdUtVqzVSB5HCkggpczWzxsiBLdbbB5HZvMQPMSlkXHuKHAf0xe2uZXvk2z+WGER+nTLfmDn3stkrg4BgxLaKwCgJN9Gqj71A2Xt98qcpjiDMSFbE6GH1bKrSuA3aarBfMu55eveYeR6irW+cDA99QY5YQDli7USzziNongNxKLO0CG7iAEQ0LsnKohWJ8wMdv+p6M4hiInvbOkP2P3I0FyE8Z6INHoeYVc0aKEULcPdv7Io7BuVkPXOauylmQT1mWaAAHNhDU9fXpq7HJBrTaPdSrMS4zk6em79Nr36M1CQ4Fs1+PJPFu1MRLe+x4aUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4z9kenL1VV3XzFpz/6OLODlErTPSoqQOqrlDcSRtMY=;
 b=O/rw3P28RRLnlR6OWBVwgeA9mcltXiWahg0Dgl86koicRiYoDRVkCF1e4ws+8L/SDi+JC06TBirpqs52iVLdiZeZr353Zg7+YlTMyiI/CUDdZxf14AriEfZNKFWGuNwXzhbEdFGetUuzVXZMC22B2qpmOOqYAS4mmrP56qYvPko=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2613.namprd18.prod.outlook.com (2603:10b6:a03:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15; Sun, 8 Mar
 2020 06:48:43 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 06:48:43 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Prasun Kapoor" <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: Re: [EXT] Re: [PATCH 11/12] task_isolation: kick_all_cpus_sync: don't
 kick isolated cpus
Thread-Topic: [EXT] Re: [PATCH 11/12] task_isolation: kick_all_cpus_sync:
 don't kick isolated cpus
Thread-Index: AQHV8kAcdftBA0b3gky17yT7q2R3yKg7tQiAgAKRrQA=
Date:   Sun, 8 Mar 2020 06:48:43 +0000
Message-ID: <7e0ce8988f4811e7453859e22654d2618557d9ab.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <dfa5e0e9f34e6ff0ef048c81bc70496354f31300.camel@marvell.com>
         <20200306153446.GC8590@lenoir>
In-Reply-To: <20200306153446.GC8590@lenoir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57c1474a-4bd7-43da-2fbe-08d7c32cbe50
x-ms-traffictypediagnostic: BYAPR18MB2613:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB26139D4B383E9E6AB3DA9A4EBCE10@BYAPR18MB2613.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(39840400004)(376002)(396003)(199004)(189003)(186003)(5660300002)(36756003)(2906002)(478600001)(4326008)(6486002)(8936002)(6506007)(26005)(316002)(8676002)(81166006)(81156014)(6916009)(6512007)(71200400001)(76116006)(2616005)(66446008)(64756008)(66476007)(86362001)(54906003)(66556008)(66946007)(7416002)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2613;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZcH71kvqcABkWLDgO1Dxs1vZBLODsHrycCAHVAJjyQJlD8p7BoHcbPPJsp2iIzBmtkO87GLL5uRxZHoRmr3gsHRlGxklSCoEGtjuGam5NpIMO3PdiQu2wiL28m4gyEfzIfEFSP5Tl0n2EV+t3kTsn5oDY2sWoEtctBAH4FHs79l7GlhMjnTLHL8VxlNyo0V1P/apPGB4SVt7UdSj+LLdqWe+nDyaxOAplfJ/fWiKVCEJvDOhhYRjqQJ/+fNxoeQ757Sny3TbCd5Q5L914Gfj5r3wOK3wOITCksxVcgkYE2XdVUtwt2WnU2eURiWlUNemUZwfn9U3y0RPDMYEz+32EMAfRSUHGhlYK2pIjXkzb0MBfhvJfi+x8SKIzugb3XSlSIvKuGocBWxngKffTodkj3E9N7GMtWOO1RuOjy08lKE4EvTFV98jbhkZbUvdmY6l
x-ms-exchange-antispam-messagedata: p78Ku4XlFrN7TqILS4DhP94TlQMtu47F4hgrh2IDEyZRuWNxlz/qJs/VYfl7yBGkEMhQaEWak43j229GmpXK9Ep1RAMsVND/JTTd+r4i4X0JXpacvHnXYTYM5+h3jjxum5gLXbyeY6N3Bw7FHSfkyQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <22B91EB6759F5E429B9A26A5E13F7A1A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c1474a-4bd7-43da-2fbe-08d7c32cbe50
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 06:48:43.3319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 21N+fSkdxORmQGT7Q4tZZfWOXRbt1wYHwM8F95LtV3wtC7dA63rIoIu6tX3un7yvV4NZbvcS/yOKzdubbFef0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2613
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-08_01:2020-03-06,2020-03-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTA2IGF0IDE2OjM0ICswMTAwLCBGcmVkZXJpYyBXZWlzYmVja2VyIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAwNDoxNToyNFBNICswMDAwLCBBbGV4IEJl
bGl0cyB3cm90ZToNCj4gPiBGcm9tOiBZdXJpIE5vcm92IDx5bm9yb3ZAbWFydmVsbC5jb20+DQo+
ID4gDQo+ID4gTWFrZSBzdXJlIHRoYXQga2lja19hbGxfY3B1c19zeW5jKCkgZG9lcyBub3QgY2Fs
bCBDUFVzIHRoYXQgYXJlDQo+ID4gcnVubmluZw0KPiA+IGlzb2xhdGVkIHRhc2tzLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVsaXRzIDxhYmVsaXRzQG1hcnZlbGwuY29tPg0KPiA+
IC0tLQ0KPiA+ICBrZXJuZWwvc21wLmMgfCAxNCArKysrKysrKysrKysrLQ0KPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9rZXJuZWwvc21wLmMgYi9rZXJuZWwvc21wLmMNCj4gPiBpbmRleCAzYThiY2JkZDRj
ZTYuLmQ5YjRiMmZlZGZlZCAxMDA2NDQNCj4gPiAtLS0gYS9rZXJuZWwvc21wLmMNCj4gPiArKysg
Yi9rZXJuZWwvc21wLmMNCj4gPiBAQCAtNzMxLDkgKzczMSwyMSBAQCBzdGF0aWMgdm9pZCBkb19u
b3RoaW5nKHZvaWQgKnVudXNlZCkNCj4gPiAgICovDQo+ID4gIHZvaWQga2lja19hbGxfY3B1c19z
eW5jKHZvaWQpDQo+ID4gIHsNCj4gPiArCXN0cnVjdCBjcHVtYXNrIG1hc2s7DQo+ID4gKw0KPiA+
ICAJLyogTWFrZSBzdXJlIHRoZSBjaGFuZ2UgaXMgdmlzaWJsZSBiZWZvcmUgd2Uga2ljayB0aGUg
Y3B1cyAqLw0KPiA+ICAJc21wX21iKCk7DQo+ID4gLQlzbXBfY2FsbF9mdW5jdGlvbihkb19ub3Ro
aW5nLCBOVUxMLCAxKTsNCj4gPiArDQo+ID4gKwlwcmVlbXB0X2Rpc2FibGUoKTsNCj4gPiArI2lm
ZGVmIENPTkZJR19UQVNLX0lTT0xBVElPTg0KPiA+ICsJY3B1bWFza19jbGVhcigmbWFzayk7DQo+
ID4gKwl0YXNrX2lzb2xhdGlvbl9jcHVtYXNrKCZtYXNrKTsNCj4gPiArCWNwdW1hc2tfY29tcGxl
bWVudCgmbWFzaywgJm1hc2spOw0KPiA+ICsjZWxzZQ0KPiA+ICsJY3B1bWFza19zZXRhbGwoJm1h
c2spOw0KPiA+ICsjZW5kaWYNCj4gPiArCXNtcF9jYWxsX2Z1bmN0aW9uX21hbnkoJm1hc2ssIGRv
X25vdGhpbmcsIE5VTEwsIDEpOw0KPiA+ICsJcHJlZW1wdF9lbmFibGUoKTsNCj4gPiAgfQ0KPiAN
Cj4gVGhhdCBsb29rcyB2ZXJ5IGRhbmdlcm91cywgdGhlIGNhbGxlcnMgb2Yga2lja19hbGxfY3B1
c19zeW5jKCkgd2FudA0KPiB0bw0KPiBzeW5jIGFsbCBDUFVzIGZvciBhIHJlYXNvbi4gWW91IHdp
bGwgcmF0aGVyIG5lZWQgdG8gZml4IHRoZSBjYWxsZXJzLg0KDQpBbGwgY2FsbGVycyBvZiB0aGlz
IHVzZSB0aGlzIGZ1bmN0aW9uIHRvIHN5bmNocm9uaXplIElQSXMgYW5kIGljYWNoZSwNCmFuZCB0
aGV5IGhhdmUgbm8gaWRlYSBpZiB0aGVyZSBpcyBhbnl0aGluZyBzcGVjaWFsIGFib3V0IHRoZSBz
dGF0ZSBvZg0KQ1BVcy4gSWYgYSB0YXNrIGlzIGlzb2xhdGVkLCB0aGlzIGNhbGwgd291bGQgbm90
IGJlIG5lY2Vzc2FyeSBiZWNhdXNlDQp0aGUgdGFzayBpcyBpbiB1c2Vyc3BhY2UsIGFuZCBpdCB3
b3VsZCBoYXZlIHRvIGVudGVyIGtlcm5lbCBmb3IgYW55IG9mDQp0aGF0IHRvIGJlY29tZSByZWxl
dmFudCBidXQgdGhlbiBpdCB3aWxsIGhhdmUgdG8gc3dpdGNoIGZyb20gdXNlcnNwYWNlDQp0byBr
ZXJuZWwuIEF0IHdvcnN0IGl0IGlzIHJldHVybmluZyB0byB1c2Vyc3BhY2UgYWZ0ZXIgZW50ZXJp
bmcNCmlzb2xhdGlvbiBvciBiYWNrIGluIGtlcm5lbCBydW5uaW5nIGNsZWFudXAgYWZ0ZXIgaXNv
bGF0aW9uIGlzIGJyb2tlbg0KYnV0IGJlZm9yZSB0c2tfdGhyZWFkX2ZsYWdzX2NhY2hlIGlzIHVw
ZGF0ZWQuIFRoZXJlIHdpbGwgYmUgbm90aGluZyB0bw0KcnVuIG9uIHRoZSBzYW1lIENQVSBiZWNh
dXNlIHdlIGhhdmUganVzdCBsZWZ0IGlzb2xhdGlvbiwgc28gdGFzayB3aWxsDQplaXRoZXIgZXhp
dCBvciBnbyBiYWNrIHRvIHVzZXJzcGFjZS4NCg0KSXMgdGhlcmUgYW55IHJlYXNvbiBmb3IgYSBy
YWNlIGF0IHRoYXQgcG9pbnQ/DQoNCj4gVGhhbmtzLg0KPiANCj4gPiAgRVhQT1JUX1NZTUJPTF9H
UEwoa2lja19hbGxfY3B1c19zeW5jKTsNCj4gPiAgDQo+ID4gLS0gDQo+ID4gMi4yMC4xDQo+ID4g
DQoNCi0tIA0KQWxleA0K
