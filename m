Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535D417D1B7
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 06:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgCHFdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 00:33:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31190 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725775AbgCHFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 00:33:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0285WOaP008199;
        Sat, 7 Mar 2020 21:32:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=axcSiAurOmgpk6xOgVU5CnMXA0eIErwtCYrlNtJt6H0=;
 b=xjb2sFGCLyuhBtKUfSDF+EDCsnYQEU3XFMtQlMA7+rJl4IIL8FBjq/sE+gCz150ZWfmS
 awQQHPR6t5GT908YoPtoYg2wMLIwsnNxx4/2W8BIceKVnNnX3xpUBt4BLZZ/t1WbvBDE
 381kD0F7SPQJnK2nTxa60GeE9Pq3mtjMQCzX2Hjz8iPjAZi34Hkx2unuIUpE8uV7TErB
 EPktM+n5oghJaMo4QpoPq/DJpnklj8Q+5LY3FXycqQe/Hja+y5KM/jA2V2tV0oEUqhi3
 ojop15wKr8B9KKWp3835LmcfwI0rW9DkBXIhPJJAHHlIy3QGjz5XvDttiuAjeCVuzgbv WQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwb2mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 21:32:24 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 21:32:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 21:32:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiidvnfpI6M1XUbZnDuUfCGZ9sgEN1T7LwQfR0d8RnZ7lun4iPq1d0+RdAgXRdXDp0rBEc5HtAxcMVBgDy0SEJJM3tLGJON9UXnc1xkxAiCMJaxgtbax8F4lgvIx3TECBvGQV2ZRq4OIUVELGCgSOo3W6bnv5dEJjUqDgJRX2dn+FpPA7MQ34Oa7Ewndopbl7pkYdRRuKTZcWZMO7oaz6xACeQ6oGDoijJw0YHiPBZzfIKuH+TfUk9KwBMyjUTnVFiX+y0gfkCGaxavjnAGe9lBNhWjLTxooZSablIZTLhpH8Ow9HwAlCDL5xbj9ZEXpUhPO9I9FByGhOZZvf0QmXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axcSiAurOmgpk6xOgVU5CnMXA0eIErwtCYrlNtJt6H0=;
 b=CvygJgZGgguKF+5sfIAY2LCJqX4C+01xMqxICAi5scWraRbbAYmKegVMUdjzHBiTKVIaJ5S5+a2U+iUEaNlCTuGPXiFwuz3rBYx+9JCqW0QpoLBceLsBofx1R33Flb/2g3IHwAqyJw6Hhk7jtOt+N5GCHjSvzn0iL8DnEtSxEeGNC6d71hhjiq71BxjqJrxwXDVU7ifjUvhZJ03iI3WdzMzKgBN68EbQKeoKd03W6tDNn+l4yrcMEAfsbqExsYK0MyQki8nqNN/DH3Or5QDEaZAURmeXf07xkbkX7LyUWC9D9pQ7x2LCPGYJe3lps2te8OiDPGPAg0guhlOUTzkziA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axcSiAurOmgpk6xOgVU5CnMXA0eIErwtCYrlNtJt6H0=;
 b=FiTgfSZ4FXFtYUI3p1fWeWKd5/imAaY5ihxxEE5SfaqRu2IkDhTUoS4cbRmygKnPQ+XKd6NZj29r9Oedif7+m6ZsSaGKGdIpYE5qssMu8ECiYRceNbVzUpYBKA3ppEMzthLrIX/zspXU6WMLaO9T1DGrYpnfrIV1F6hxpQhDJgA=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2951.namprd18.prod.outlook.com (2603:10b6:a03:10c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 05:32:20 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 05:32:19 +0000
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
Subject: Re: [EXT] Re: [PATCH 03/12] task_isolation: userspace hard isolation
 from kernel
Thread-Topic: [EXT] Re: [PATCH 03/12] task_isolation: userspace hard isolation
 from kernel
Thread-Index: AQHV8j73SZ7gA0FMRkuOSCw4mVFsAKg6VJCAgAPczwA=
Date:   Sun, 8 Mar 2020 05:32:19 +0000
Message-ID: <92135de5e710c3fddb7256259a759b20460e9052.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <36d84b8dd168a38e6a56549dedc15dd6ebf8c09e.camel@marvell.com>
         <20200305183313.GA29033@lenoir>
In-Reply-To: <20200305183313.GA29033@lenoir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 253cc83d-d1a9-4c6d-c5c4-08d7c322124c
x-ms-traffictypediagnostic: BYAPR18MB2951:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2951F7FDB3A9AD62857A0B71BCE10@BYAPR18MB2951.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(366004)(39840400004)(189003)(199004)(478600001)(316002)(54906003)(2906002)(71200400001)(81166006)(8936002)(81156014)(8676002)(6506007)(186003)(5660300002)(6916009)(6512007)(26005)(91956017)(66946007)(66556008)(64756008)(66476007)(66446008)(36756003)(86362001)(7416002)(6486002)(76116006)(2616005)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2951;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SjOGt74X9REYppB6qEEpPHVGIYrh9EqWV42wirpiiJ2i5Rfb+uW3CiTXME7HgImEpXNsHmreXeS+CHCmu9rj9DpcPncwPQ4W4NuOzsBaR0N1HUdqFL80q1hrSMUnNyDvn2268DUJi42sOLg8fPscxFZmPGctz8duhiEb1x+3tu0VPFoNBLzF/25PpF4A3nYszgjAJNi4YzVyEntnw4lqnLDFmomdy/STjVMUyUo1aD2Z+00qSJ8tac3jzWQEqIFGZmbzK2IOUo/WEAd24A/6/k44Jmvu8jvAz4HKFhv/QqSNNMNsrE1kLZllxUgAZKKb2vz49vE24pvAZzIClEC+UswoE4jtr/h9dadlBFT6CHgaZBJxBQ6YImag/zjF7/mfYw6N4CLMABbv9W1aImfZFk6+Y42lyP2/D/QizfPtgxkuXXFIFTBg94LnVPdm3adz
x-ms-exchange-antispam-messagedata: p+99BpVoiiu1zjgKN9iO34+GPQlI2/UwhDadIL/aqJuoxJjJ19amGTisGEjql4XlxURHCBuNOpNMgQR2x4IeY5WLU2rWXCMaa7bZvGtQ+LP+eILPGrWFAJiZ/CVv4oRt/rWUmG1N9a1PIXenFuh/6w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <128976CACCE956469B6E5F7E2D72E66E@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 253cc83d-d1a9-4c6d-c5c4-08d7c322124c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 05:32:19.7191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 61Bhl4P8mRmKHmG0w2Sh7RQNwx/+LoBndYHSjVEODIUXl7xaqMrQBxl+pZXJrZqKlP9upyY7wVMYJl9KBexCjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2951
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-08_01:2020-03-06,2020-03-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTA1IGF0IDE5OjMzICswMTAwLCBGcmVkZXJpYyBXZWlzYmVja2VyIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAwNDowNzoxMlBNICswMDAwLCBBbGV4IEJl
bGl0cyB3cm90ZToNCj4gPiANCj4gDQo+IEhpIEFsZXcsDQo+IA0KPiBJJ20gZ2xhZCB0aGlzIHBh
dGNoc2V0IGlzIGJlaW5nIHJlc3VyZWN0ZWQuDQo+IFJlYWRpbmcgdGhhdCBjaGFuZ2Vsb2csIEkg
bGlrZSB0aGUgZ2VuZXJhbCBpZGVhIGFuZCB0aGUgZGlyZWN0aW9uLg0KPiBUaGUgZGlmZiBpcyBh
IGJpdCBzY2FyeSB0aG91Z2ggYnV0IEknbGwgY2hlY2sgdGhlIHBhdGNoZXMgaW4gZGV0YWlsDQo+
IGluIHRoZSB1cGNvbWluZyBkYXlzLg0KPiANCg0KSSBtYWRlIHNvbWUgdXBkYXRlcyAtLSBhZGRl
ZCBtaXNzaW5nIGNvZGUgZm9yIGFybSBhbmQgeDg2LCByZXN0b3JlZA0Kc2lnbi1vZmYgbGluZXMg
YW5kIHVwZGF0ZWQgY29tbWl0IG1lc3NhZ2VzLg0KDQpUaGlzIGlzIHRoZSByZXN1bHQgb2Ygc29t
ZSB3b3JrIHRoYXQgbW9zdGx5IGhhcHBlbmVkIG9uIGVhcmxpZXINCnZlcnNpb25zIGFuZCBoYWQg
dG8gZGVhbCB3aXRoIHRoZSBmYWN0IHRoYXQgdGltZXJzIGFuZCBob3VzZWtlZXBpbmcNCndvcmsg
b2Z0ZW4gYXBwZWFyZWQgb24gYWxsIENQVXMsIHNvIHNvbWUgc29sdXRpb25zIG1heSBsb29rIGxp
a2UgYW4NCm92ZXJraWxsLiBOZXZlcnRoZWxlc3MgaXQgd2FzIHZlcnkgaGVscGZ1bCBmb3IgZmlu
ZGluZyB0aGUgc291cmNlcyBvZg0KdW5leHBlY3RlZCBkaXN0dXJiYW5jZXMuDQoNCkFsc28gb3Jp
Z2luYWxseSBzb21lIG9mIHRoZSByYWNlIGNvbmRpdGlvbnMgYW5kIHBvdGVudGlhbCBkZWxheWVk
IHdvcmsNCmF0IHRoZSB0aW1lIHdoZW4gYSB0YXNrIGlzIGVudGVyaW5nIGlzb2xhdGVkIHN0YXRl
IHdlcmUgY29uc2lkZXJlZA0KdW5hdm9pZGFibGUuIFNvIHRoZSBwYXJ0IGluIGtlcm5lbCB3YXMg
Zm9jdXNlZCBvbiBjb3JyZWN0bmVzcyBvZg0KaGFuZGxpbmcgdGhvc2UgY29uZGl0aW9ucywgd2hp
bGUgZGV0ZWN0aW9uIGFuZCBkZWFsaW5nIHdpdGggdGhlaXINCmNvbnNlcXVlbmNlcyB3YXMgZG9u
ZSBpbiB1c2Vyc3BhY2UgKGluIGxpYnRtYykuIE5vdyBpdCBsb29rcyBsaWtlIHRoZXJlDQptYXkg
YmUgbXVjaCBmZXdlciBzdWNoIHNpdHVhdGlvbnMsIGhvd2V2ZXIgSSBhbSBzdGlsbCBub3QgdmVy
eSB0aHJpbGxlZA0Kd2l0aCB0aGUgaWRlYSBvZiBjb21wbGljYXRpbmcgdGhlIGtlcm5lbCBtb3Jl
IHRoYW4gd2UgaGF2ZSB0by4NCkVzcGVjaWFsbHkgd2hlbiBpdCBjb21lcyB0byBjb2RlIHRoYXQg
aXMgcmVsZXZhbnQgb25seSBvdmVyIGZldyBzZWNvbmRzDQp3aGVuIHRoZSB0YXNrIGlzIHN0YXJ0
aW5nIGFuZCBlbnRlcmluZyBpc29sYXRlZCBtb2RlLiBTbyBJIGhhdmUgdG8NCmFkbWl0IHRoYXQg
c29tZSBzb2x1dGlvbnMgbG9vayBsaWtlICJtb3JlIEVJTlRSIHRoYW4gRUlOVFIiLCBhbmQgSQ0K
c3RpbGwgbGlrZSB0aGVtIG1vcmUgdGhhbiBtYWtpbmcga2VybmVsIHNpZGUgb2YgZW50ZXJpbmcv
ZXhpdGluZw0KaXNvbGF0aW9uIGV2ZW4gbW9yZSBjb21wbGV4IHRoYW4gaXQgaXMgbm93Lg0KDQpJ
IG1heSBiZSB3cm9uZywgYW5kIHRoZXJlIG1heSBiZSBzb21lIG1vcmUgZWxlZ2FudCBzb2x1dGlv
biwgaG93ZXZlciBJDQpkb24ndCBzZWUgaXQgbm93LiBVc2Vyc3BhY2UtYXNzaXN0ZWQgaXNvbGF0
aW9uIGVudGVyaW5nL2V4aXRpbmcNCnByb2NlZHVyZSB3b3JrZWQgdmVyeSB3ZWxsIGluIGEgc3lz
dGVtIHdpdGggYSBodWdlIG51bWJlciBvZiBjb3JlcywNCnRocmVhZHMsIGRyaXZlcnMgd2l0aCB1
bnVzdWFsIGZlYXR1cmVzLCBldGMuLCBzbyBhdCB2ZXJ5IGxlYXN0IHdlIGhhdmUNCnNvbWUgdXNh
YmxlIHJlZmVyZW5jZSBwb2ludC4NCg0KPiA+IEluIGEgbnVtYmVyIG9mIGNhc2VzIHdlIGNhbiB0
ZWxsIG9uIGEgcmVtb3RlIGNwdSB0aGF0IHdlIGFyZQ0KPiA+IGdvaW5nIHRvIGJlIGludGVycnVw
dGluZyB0aGUgY3B1LCBlLmcuIHZpYSBhbiBJUEkgb3IgYSBUTEIgZmx1c2guDQo+ID4gSW4gdGhh
dCBjYXNlIHdlIGdlbmVyYXRlIHRoZSBkaWFnbm9zdGljIChhbmQgb3B0aW9uYWwgc3RhY2sgZHVt
cCkNCj4gPiBvbiB0aGUgcmVtb3RlIGNvcmUgdG8gYmUgYWJsZSB0byBkZWxpdmVyIGJldHRlciBk
aWFnbm9zdGljcy4NCj4gPiBJZiB0aGUgaW50ZXJydXB0IGlzIG5vdCBzb21ldGhpbmcgY2F1Z2h0
IGJ5IExpbnV4IChlLmcuIGENCj4gPiBoeXBlcnZpc29yIGludGVycnVwdCkgd2UgY2FuIGFsc28g
cmVxdWVzdCBhIHJlc2NoZWR1bGUgSVBJIHRvDQo+ID4gYmUgc2VudCB0byB0aGUgcmVtb3RlIGNv
cmUgc28gaXQgY2FuIGJlIHN1cmUgdG8gZ2VuZXJhdGUgYQ0KPiA+IHNpZ25hbCB0byBub3RpZnkg
dGhlIHByb2Nlc3MuDQo+IA0KPiBJJ20gd29uZGVyaW5nIGlmIGl0J3Mgd2lzZSB0byBydW4gdGhh
dCBvbiBhIGd1ZXN0IGF0IGFsbCA6LSkNCj4gT3Igd2Ugc2hvdWxkIGNvbnNpZGVyIGFueSBndWVz
dCBleGl0IHRvIHRoZSBob3N0IGFzIGENCj4gZGlzdHVyYmFuY2UsIHdlIHdvdWxkIHRoZW4gbmVl
ZCBzb21lIHNvcnQgb2YgcGFyYXZpcnQNCj4gZHJpdmVyIHRvIG5vdGlmeSB0aGF0LCBldGMuLi4g
VGhhdCBkb2Vzbid0IHNvdW5kIGFwcGVhbGluZy4NCg0KV2h5IG5vdD8gSSBhbSBub3QgYSBiaWcg
ZmFuIG9mIHZpcnR1YWxpemF0aW9uLCBob3dldmVyIHBlb3BsZSBzZWVtIHRvDQp1c2UgaXQgZm9y
IGFsbCBraW5kcyBvZiBwdXJwb3NlcyBub3csIGFuZCB3ZSBvbmx5IGhhdmUgdG8gcHJvcGFnYXRl
IChvcg0KcmVqZWN0KSBpc29sYXRpb24gcmVxdWVzdHMgZnJvbSBndWVzdCB0byBob3N0IChhcyBs
b25nIGFzIHJlc291cmNlIGFuZA0KcGVybWlzc2lvbnMgcG9saWN5IGFsbG93IHRoYXQpLiBGb3Ig
S1ZNIGl0IHdvdWxkIGJlIGxpdGVyYWxseQ0KcmVwbGljYXRpbmcgZ3Vlc3QgdGFzayBpc29sYXRp
b24gc3RhdGUgb24gdGhlIGhvc3QsIGFuZCBhcyBsb25nIGFzIENQVQ0KY29yZSBpcyBpc29sYXRl
ZCwgZG9lcyBpdCByZWFsbHkgbWF0dGVyIGlmIHRoZSB0YXNrIHdhcyBjcmVhdGVkIHdpdGgNCnR3
byBsYXllcnMgb2YgdmlydHVhbGl6YXRpb24gaW5zdGVhZCBvZiBvbmU/DQoNCkZvciBpc29sYXRp
b24gdG8gbWFrZSBzZW5zZSwgaXQncyBzdGlsbCBjb2RlIHJ1bm5pbmcgb24gYSBDUFUgd2l0aA0K
Zml4ZWQgYWRkcmVzcyBtYXBwaW5nLiBJZiB0aGlzIGlzIHN0aWxsIHRoZSBjYXNlLCB2aXJ0dWFs
aXphdGlvbiBvbmx5DQpkZXRlcm1pbmVzIHdoYXQgY2FuIGJlIGluIHRoYXQgc3BhY2UsIG5vdCBo
b3cgaXQgYmVoYXZlcy4gSWYgdGhpcyBpcw0Kbm90IHRoZSBjYXNlLCBhbmQgdGFzayBjYXVzZXMg
a2VybmVsIGNvZGUgdG8gcnVuLCBiZSBpdCBndWVzdCBvciBob3N0DQprZXJuZWwsIHRoZW4gc29t
ZXRoaW5nIGlzIHdyb25nLCBhbmQgaXNvbGF0aW9uIGlzIGJyb2tlbi4gTm90IHZlcnkNCmRpZmZl
cmVudCBmcm9tIGJlaGF2aW9yIHdpdGhvdXQgdmlydHVhbGl6YXRpb24uDQoNClRoaXMgd291bGQg
YmUgdmVyeSBiYWQgZm9yIGVhcmx5IGRheXMgb2YgdmlydHVhbGl6YXRpb24gd2hlbiB2ZXJ5DQps
aXR0bGUgY291bGQgYmUgZG9uZSBieSBhIGd1ZXN0IHdpdGhvdXQgaG9zdCBtZXNzaW5nIHdpdGgg
aXQuIE5vdywgd2hlbg0KcGllY2VzIG9mIGhhcmR3YXJlIGNhbiBiZSAocmVsYXRpdmVseSkgc2Fm
ZWx5IGdpdmVuIHRvIHRoZSBndWVzdA0KdXNlcnNwYWNlIHRvIHdvcmsgb24sIHdlIGNhbiBqdXN0
IGFzIHdlbGwgbGV0IGl0IHJ1biBpc29sYXRlZC4NCg0KPiANCj4gVGhhbmtzLg0KDQpUaGFua3Mh
DQoNCi0tIA0KQWxleA0K
