Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEF6282B67
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgJDPWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 11:22:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53066 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDPWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 11:22:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 094FKBGd024313;
        Sun, 4 Oct 2020 08:22:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=zxgz1HvTOVZep6VwpdPMO19oBEeYFvSxsta1UZPlHTc=;
 b=LAOPMsu/nm0I4nsh4x4/W8OMnZLIE8FOosoh6hQh4uf+3a7+sPd6KvwxJw1inQGfOKdh
 Ou3arn67E7gQkX08jfceLwCa1QCpG0kw36M7FVhRu/u75S0nPaHkXSaV5wtoCmiD1Gkw
 g4VXg1CYePhwLIqUkBtzeJpC2Ts83O7JXuE+piHGv4NR3hdY1bDm8mEPERJrw9/8QprE
 b0bMDMGL7QzmeZSD4IrimigZZWqJ4LM1t7N25shMpcJ1dNCaGtE3orHVF5d5J48O83+H
 UclJtnPjy1dugpIvkT+pG/AgjAR8eToaMR5zlcemiIEsh7hb0qNEoLZZ5eKbV8VKPWV8 Og== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtna9vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Oct 2020 08:22:15 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Oct
 2020 08:22:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 4 Oct 2020 08:22:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCJ/XoHljAzJg/YH7cYrtvCgw9/iTr7g5Ld+vFZOIgO+Q3VQYNxoRBbFsBlOHGQme1zXDUT9UByaGrRyWA61NLqB3H59KI14mZbY/bZaoRyNxO2qovGk/X/QjECdPmBb58WPyyv/7b/0YDCfgnky/6aZvV8ubkDvajiWvAe1HSYL7LFSQ3riuNoJVgzNUKW6ihK6Xjjmf2st4VUOt3+b2jOJzTi1cex5OzC4Vxicml+TswIM40Y85KHZ9X/+D5BCXg/K8uI908dL1IpvarIhs8yP9KM58CqgCuzFkGFAoSYVoZnhZVAskQVy5u8SBnBKrnK7hJnDHDj9j6reizvj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxgz1HvTOVZep6VwpdPMO19oBEeYFvSxsta1UZPlHTc=;
 b=iIwRsfKusndYnIuF41MMBVP3Sc2fpwBy+ux5bbssZC0FGO6IoM2zTgr5QMns3iYmPc4Ikxq6DtizWPP07zjMkP9cUcV1+vkxyQon+/FZ3hMWNTEttsmTipJptQ9GP/uxckLs96BydjGUQW0uiCc2Q58zAjGBlHhg1KInvqzHLPfIwHZcxwPh8oLiblj4my9ptH7oN74Ey2bEclurRT9Z7lqK9659PhGPmUK6ZHVKGQ/kTAl5eTwRuZ9BgEnOtRkMVWauAjcz+Ihkx0sGJ1e2uh+/snFnTah2eNXs2mDPhcD/tOoBVub3a/FNj8QoFoRIoqv13SlgniFFd95XhUuKNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxgz1HvTOVZep6VwpdPMO19oBEeYFvSxsta1UZPlHTc=;
 b=T+0UYXuBBplwHxbXb6Gi2s7WGg3MPuIMme1TkLaLKYyLVKxNuYHAfW876KE/Fmw9VYSJMm54r3bOPaUpF7altEvQaJZm7I+6qvjXB1lY9gcjKQQFuI/8W8P6Vf/MTp8ZVetp3hn0sCYrO3bAKV1So56ThJU/3LBLijlA6h/sK8s=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2156.namprd18.prod.outlook.com (2603:10b6:907:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Sun, 4 Oct
 2020 15:22:10 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f%5]) with mapi id 15.20.3433.043; Sun, 4 Oct 2020
 15:22:10 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 10/13] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Topic: [EXT] Re: [PATCH v4 10/13] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Index: AQHWYDhuh3VfINlM20KwSBz5WuaF0amDQmgAgATBZ4A=
Date:   Sun, 4 Oct 2020 15:22:09 +0000
Message-ID: <ab85fd564686845648d08779b1d4ecc3ab440b2a.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <5acf7502c071c0d1365ba5e5940e003a7da6521f.camel@marvell.com>
         <20201001144454.GB6595@lothringen>
In-Reply-To: <20201001144454.GB6595@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 423b07b7-549d-41bb-01cd-08d868794348
x-ms-traffictypediagnostic: MW2PR18MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB21568363C14DF4516CC688E2BC0F0@MW2PR18MB2156.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T7ZqZ/yd2UMF8qe74j5icVgXXAMEzZiskQBSjkYpVIJM9hylSHJ0B1930a60vaqXTVzXGho7NsNLsaVTnMaKSD3L+43W/LsyZn/Y1BhHsGaxSg8wrL0+i+VjXaOzPMXPrHrX0Hc+jc2gb13ElMhisSewtivo1b38haTDMvb+mybjOoNd5xlg18V2S19g6mSwg3RdLQG4mGSdovfy+Rfd8vpKKekCBNkrOLoTlH9LttHJJDKLPIwl1ZcU5E8n/9HsoaosfkVN/u5FN43C2DjiViQJVvgYb8bUAzrvziApcyzCyXXV6m/uOG1pxY13sWMnTZgu7++OFlztVOQklh74VQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(376002)(346002)(366004)(136003)(91956017)(76116006)(83380400001)(8676002)(6916009)(6506007)(54906003)(66556008)(66446008)(6512007)(316002)(478600001)(36756003)(66476007)(7416002)(64756008)(66946007)(8936002)(71200400001)(2616005)(5660300002)(186003)(26005)(86362001)(4326008)(6486002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: MREOlZXh5y6yiN+3zYYDwiDLlkWXWgFg/2gk2WOjEuY67r9BQWvyvVAtMUj4brqqZTRhBHk3nGqQ4E0hCtu6snsfRBQtMu4UfyIBA/LVmux/DknzuI236fXyWmDqmFjc5jdSrkYL5KPtT/NAWGaTpNQ+QbI0ILzt6gN60aCMi23DesVS2S65LnOxzvpq7iHkpZmmKZ3cMpCDQ1vipyNxbmZRT4siShFtPxhjPyAQI/BwsLrqN7aVaWdKj2WA/YjaipzOS+lIZdRT27rM2tq3zYQAwUj5oOY+AQcrjQb2Uf4H8A/IlnfyD4DB/BHUk6X07ME/RqzBVVcMnT9E8W4fuTIJcTfUexn4VHh2BpBZKE6pDlw/eRkgoYfSxEHL9LcXy3M2VqZZLHvjCn8/60My5sDiHOoKCsjmn060ln2SZm5aggxD2Y6oMqYdKg1Peb59yM8BKN73XiicSOrERBq9kuYC1w5rd1IX/Otmm80+1qW+0mVR2MS9JfroaHpxX0vl5RpzR52xKvyG3xaaR8vJN14btsOoCWFW4lUEUL9xKYTlBfsxOGv9fnHixossp41XRE8SIkgz07wXByRmoIYfydkAtydZwv7X2CdV4xp7ZeF1uiE8VWrtSafspWUbhHYXj95XZy8OJDngtSqgp5bMxA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D203A5F6D453444A31FB4AECFDED90E@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 423b07b7-549d-41bb-01cd-08d868794348
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 15:22:10.0040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 58ykxhWvgeFjHAaulvYh2/d5BQ90CqSKf1R82himN9VnTLvBXvopbJcj075Mx6fGwx8o2o/DH1vdToQprCE2Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2156
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-04_13:2020-10-02,2020-10-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMTAtMDEgYXQgMTY6NDQgKzAyMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLQ0KPiBPbiBX
ZWQsIEp1bCAyMiwgMjAyMCBhdCAwMjo1NzozM1BNICswMDAwLCBBbGV4IEJlbGl0cyB3cm90ZToN
Cj4gPiBGcm9tOiBZdXJpIE5vcm92IDx5bm9yb3ZAbWFydmVsbC5jb20+DQo+ID4gDQo+ID4gRm9y
IG5vaHpfZnVsbCBDUFVzIHRoZSBkZXNpcmFibGUgYmVoYXZpb3IgaXMgdG8gcmVjZWl2ZSBpbnRl
cnJ1cHRzDQo+ID4gZ2VuZXJhdGVkIGJ5IHRpY2tfbm9oel9mdWxsX2tpY2tfY3B1KCkuIEJ1dCBm
b3IgaGFyZCBpc29sYXRpb24gaXQncw0KPiA+IG9idmlvdXNseSBub3QgZGVzaXJhYmxlIGJlY2F1
c2UgaXQgYnJlYWtzIGlzb2xhdGlvbi4NCj4gPiANCj4gPiBUaGlzIHBhdGNoIGFkZHMgY2hlY2sg
Zm9yIGl0Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFl1cmkgTm9yb3YgPHlub3JvdkBtYXJ2
ZWxsLmNvbT4NCj4gPiBbYWJlbGl0c0BtYXJ2ZWxsLmNvbTogdXBkYXRlZCwgb25seSBleGNsdWRl
IENQVXMgcnVubmluZyBpc29sYXRlZA0KPiA+IHRhc2tzXQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEFs
ZXggQmVsaXRzIDxhYmVsaXRzQG1hcnZlbGwuY29tPg0KPiA+IC0tLQ0KPiA+ICBrZXJuZWwvdGlt
ZS90aWNrLXNjaGVkLmMgfCA0ICsrKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9rZXJuZWwvdGltZS90
aWNrLXNjaGVkLmMgYi9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMNCj4gPiBpbmRleCA2ZTRjZDg0
NTlmMDUuLjJmODJhNmRhZjhmYyAxMDA2NDQNCj4gPiAtLS0gYS9rZXJuZWwvdGltZS90aWNrLXNj
aGVkLmMNCj4gPiArKysgYi9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMNCj4gPiBAQCAtMjAsNiAr
MjAsNyBAQA0KPiA+ICAjaW5jbHVkZSA8bGludXgvc2NoZWQvY2xvY2suaD4NCj4gPiAgI2luY2x1
ZGUgPGxpbnV4L3NjaGVkL3N0YXQuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3NjaGVkL25vaHou
aD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KPiA+ICAjaW5jbHVkZSA8bGlu
dXgvbW9kdWxlLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9pcnFfd29yay5oPg0KPiA+ICAjaW5j
bHVkZSA8bGludXgvcG9zaXgtdGltZXJzLmg+DQo+ID4gQEAgLTI2OCw3ICsyNjksOCBAQCBzdGF0
aWMgdm9pZCB0aWNrX25vaHpfZnVsbF9raWNrKHZvaWQpDQo+ID4gICAqLw0KPiA+ICB2b2lkIHRp
Y2tfbm9oel9mdWxsX2tpY2tfY3B1KGludCBjcHUpDQo+ID4gIHsNCj4gPiAtCWlmICghdGlja19u
b2h6X2Z1bGxfY3B1KGNwdSkpDQo+ID4gKwlzbXBfcm1iKCk7DQo+IA0KPiBXaGF0IGlzIGl0IG9y
ZGVyaW5nPw0KDQpsbF9pc29sX2ZsYWdzIHdpbGwgYmUgcmVhZCBpbiB0YXNrX2lzb2xhdGlvbl9v
bl9jcHUoKSwgdGhhdCBhY2Nyc3MNCnNob3VsZCBiZSBvcmRlcmVkIGFnYWluc3Qgd3JpdGluZyBp
bg0KdGFza19pc29sYXRpb25fa2VybmVsX2VudGVyKCksIGZhc3RfdGFza19pc29sYXRpb25fY3B1
X2NsZWFudXAoKQ0KYW5kIHRhc2tfaXNvbGF0aW9uX3N0YXJ0KCkuDQoNClNpbmNlIHRhc2tfaXNv
bGF0aW9uX29uX2NwdSgpIGlzIG9mdGVuIGNhbGxlZCBmb3IgbXVsdGlwbGUgQ1BVcyBpbiBhDQpz
ZXF1ZW5jZSwgaXQgd291bGQgYmUgd2FzdGVmdWwgdG8gaW5jbHVkZSBhIGJhcnJpZXIgaW5zaWRl
IGl0Lg0KDQo+ID4gKwlpZiAoIXRpY2tfbm9oel9mdWxsX2NwdShjcHUpIHx8IHRhc2tfaXNvbGF0
aW9uX29uX2NwdShjcHUpKQ0KPiA+ICAJCXJldHVybjsNCj4gDQo+IFlvdSBjYW4ndCBzaW1wbHkg
aWdub3JlIGFuIElQSS4gVGhlcmUgaXMgYWx3YXlzIGEgcmVhc29uIGZvciBhDQo+IG5vaHpfZnVs
bCBDUFUNCj4gdG8gYmUga2lja2VkLiBTb21ldGhpbmcgdHJpZ2dlcmVkIGEgdGljayBkZXBlbmRl
bmN5LiBJdCBjYW4gYmUgcG9zaXgNCj4gY3B1IHRpbWVycw0KPiBmb3IgZXhhbXBsZSwgb3IgYW55
dGhpbmcuDQoNCkkgcmVhbGl6ZSB0aGF0IHRoaXMgaXMgdW51c3VhbCwgaG93ZXZlciB0aGUgaWRl
YSBpcyB0aGF0IHdoaWxlIHRoZSB0YXNrDQppcyBydW5uaW5nIGluIGlzb2xhdGVkIG1vZGUgaW4g
dXNlcnNwYWNlLCB3ZSBhc3N1bWUgdGhhdCBmcm9tIHRoaXMgQ1BVcw0KcG9pbnQgb2YgdmlldyB3
aGF0ZXZlciBpcyBoYXBwZW5pbmcgaW4ga2VybmVsLCBjYW4gd2FpdCB1bnRpbCBDUFUgaXMNCmJh
Y2sgaW4ga2VybmVsLCBhbmQgd2hlbiBpdCBmaXJzdCBlbnRlcnMga2VybmVsIGZyb20gdGhpcyBt
b2RlLCBpdA0Kc2hvdWxkICJjYXRjaCB1cCIgd2l0aCBldmVyeXRoaW5nIHRoYXQgaGFwcGVuZWQg
aW4gaXRzIGFic2VuY2UuDQp0YXNrX2lzb2xhdGlvbl9rZXJuZWxfZW50ZXIoKSBpcyBzdXBwb3Nl
ZCB0byBkbyB0aGF0LCBzbyBieSB0aGUgdGltZQ0KYW55dGhpbmcgc2hvdWxkIGJlIGRvbmUgaW52
b2x2aW5nIHRoZSByZXN0IG9mIHRoZSBrZXJuZWwsIENQVSBpcyBiYWNrDQp0byBub3JtYWwuDQoN
Ckl0IGlzIGFwcGxpY2F0aW9uJ3MgcmVzcG9uc2liaWxpdHkgdG8gYXZvaWQgdHJpZ2dlcmluZyB0
aGluZ3MgdGhhdA0KYnJlYWsgaXRzIGlzb2xhdGlvbiwgc28gdGhlIGFwcGxpY2F0aW9uIGFzc3Vt
ZXMgdGhhdCBldmVyeXRoaW5nIHRoYXQNCmludm9sdmVzIGVudGVyaW5nIGtlcm5lbCB3aWxsIG5v
dCBiZSBhdmFpbGFibGUgd2hpbGUgaXQgaXMgaXNvbGF0ZWQuIElmDQppc29sYXRpb24gd2lsbCBi
ZSBicm9rZW4sIG9yIGFwcGxpY2F0aW9uIHdpbGwgcmVxdWVzdCByZXR1cm4gZnJvbQ0KaXNvbGF0
aW9uLCBldmVyeXRoaW5nIHdpbGwgZ28gYmFjayB0byBub3JtYWwgZW52aXJvbm1lbnQgd2l0aCBh
bGwNCmZ1bmN0aW9uYWxpdHkgYXZhaWxhYmxlLg0KDQo+ID4gIA0KPiA+ICAJaXJxX3dvcmtfcXVl
dWVfb24oJnBlcl9jcHUobm9oel9mdWxsX2tpY2tfd29yaywgY3B1KSwgY3B1KTsNCj4gPiAtLSAN
Cj4gPiAyLjI2LjINCj4gPiANCg0K
