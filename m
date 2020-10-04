Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A49282BE6
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 19:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgJDRM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 13:12:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40178 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726077AbgJDRM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 13:12:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 094HCCeP015919;
        Sun, 4 Oct 2020 10:12:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=19SNveT3/1FsvwrecD2T/NRh1Ge7yHRw5/gBv2IAZvc=;
 b=fxRJL+k7ex/1n85PS1rcyMhsseEhnuYMDSNrM/7fa36811BgojkKPXMDgCNsT/IdKHkU
 K3b+RG4WVSYcv030dlMuVBvg7L8pr8PJroUH1xVmqJ8LodC9Iydf2B4UeVKjsVXu1V47
 Igkgg1VLp7+8IyLHikDTAL4kWeUZGnUdxnhhfLxQtns0C81hVVPI+mfup2LDcAhlfgye
 MtXiiMbutIHi3NWi4O7evQMhpuFGfANZFvQsZKt5qHWUcDpCWkfl9YnytzmTKLrp0sBT
 axWqsI4qpMRAN2lhWI1wl12FJrRocQedO/baloXR0mkkDSXc8/Hs9Q4Uldq7fgKaWi2D MA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33xpnpjxsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Oct 2020 10:12:13 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Oct
 2020 10:12:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 4 Oct 2020 10:12:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUodKPnz27Kn1wd4ycKkjRBwd8xdBcsQPOwx3YvFuCz4gzSFV/Q6uJRhxsKNY8ndHTubZ82vuFyQMtZ+x6bFz9BLu0e2SQbqsW5rwdFO19zf4b16fpo4D5Fsi12hZIUDQPw4ej4sfrccsifvUNHSsc22WnU2vc0CvXS/hrPZX0uVtF830/bFaN7TyFo7TnDhVSC2wWJ9oTV2YQUEDR4RLaQid/0l8UVyBmRiABC+mmT39abzJLD4Zb+8I7DSNO8t7ow5q+l+wStmL+DkaXwdQFWulhAYmJaTtuCdlEcgb4Jqm9JmZsZFGRzvI7xkbJ4FnOigZL5zzQoVRxQz5MJ4og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19SNveT3/1FsvwrecD2T/NRh1Ge7yHRw5/gBv2IAZvc=;
 b=WCmQ3LCJ6+BFqryAh7mq3cTf1qD3i3P3nI9sj8MfUwAMFmY593ed20RzdnBjATSIyoYDxzcstisZ5IR71h9ikNTKuumJQv/FWHKI7KNxizIntz0ODul5uwP2vmX0Y5l15g3MZXMVB+c4MZSqpWaIuuJTEa2k5e8cGZqwpBqGxrjQfKW2CPOJZdUHc90taxzKQFtnJ3rM4VdoucoFR2LsfBSD6smeGpqRe+KADVkiKFPcSatB/KV3CSimjH76nxuXvWp041bHwxJ9xwxrX2g95D1bUPkImDYiYVPequf2pwuZF/IsLDQoEDgKASWPek1ruWV1on2r/MsIaqTIw3belQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19SNveT3/1FsvwrecD2T/NRh1Ge7yHRw5/gBv2IAZvc=;
 b=aR/WQqccz0SQxAdQJseewld6u3ByxfGx45TtpUkeKNdnzlandRk7bSBAvJ3v20MFhXKkn4aiG4vHrQjLrVp4xby7FZdykhGSNvreT3ljeQxsEicYl4aqS8t9vo1huId4HZl+qNW/iaP5nyFDGc7fg/ID2ALdZ8xRL9xSkoXp5EA=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by CO6PR18MB3889.namprd18.prod.outlook.com (2603:10b6:5:342::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36; Sun, 4 Oct
 2020 17:12:11 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f%5]) with mapi id 15.20.3433.043; Sun, 4 Oct 2020
 17:12:11 +0000
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
Subject: Re: [EXT] Re: [PATCH v4 11/13] task_isolation: net: don't flush
 backlog on CPUs running isolated tasks
Thread-Topic: [EXT] Re: [PATCH v4 11/13] task_isolation: net: don't flush
 backlog on CPUs running isolated tasks
Thread-Index: AQHWYDiMpgobFulKPk24EMbX9A+yKamDQyOAgATfaQA=
Date:   Sun, 4 Oct 2020 17:12:11 +0000
Message-ID: <b72f14bee86c23ff63ed2f386977568a9e8c8c2c.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <01470cf1f1a2e79e46a87bb5a8a4780a1c3cc740.camel@marvell.com>
         <20201001144731.GC6595@lothringen>
In-Reply-To: <20201001144731.GC6595@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bf49b5e-2406-47af-adb6-08d86888a1c5
x-ms-traffictypediagnostic: CO6PR18MB3889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB38890B7F20C0CCE147D7ACA8BC0F0@CO6PR18MB3889.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cb+GG8FdJIlTOR6TPeu4wuWQ+Lxr+o6QEuABSWroVfX0JqI+KO7U60ECxFCRLmSroR+0zsbwX+fq/FU4mx0kLHjK76qQIPJugPtxcanjuIxwYMZSq+ZPZalEEbnXb9BLQGhAnFCeuhLaua5G+EA3fpqIWMc9UsD9fC+1OSmpEcRyVmF7VnhB7ZRmTr95uHLCi3o0znVX79tiLiIQ3aEkBV1DUKWGvBr0bZ95Qhxj+0Zh5j/w5mMEht1+Qu+iFMFHOFLdfrUgYhZlu+UyPnuFTApVT1sVUnkuTrsEYiW+pMnb8ehRPaCWjnmRH/Q22qS2aaiBZH4DqBhMfWj7aelLOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(66476007)(66946007)(91956017)(76116006)(8936002)(6506007)(26005)(6916009)(478600001)(5660300002)(7416002)(316002)(54906003)(66446008)(64756008)(36756003)(2616005)(86362001)(6486002)(83380400001)(4326008)(66556008)(71200400001)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: q0qKlBXyFd5MOXkyrMBB8bd4EF8J9Gqpn8CH66X5MzhZsAXohlGbuxCBZGjwLZ981RE67REoVGLrm+P8nsJA5ubzvUCCFxHETLzhzAbbx1VVroV8H5+yiZn8GsGDMDIZ8+G9jcSuCphlY+CyOQHQAOdJ52iMKX6ZW0z0aC4N5V7PHbmFqMvVQzYagVRzU3Wjovf4dSh46rc9U3BLAqO+HexvHX1HMHCeZ+fpzByjWPG19osLgK9yBW/SRO5EFujSpsOkTitEu4t39SJdS+kQX63AsuiQX2PmSeMaIw1lKG6dTrh8HzOZD/MwXEIznPZdzp0SyBkLgXeoHSoCyLG/CbjREeGy2qK0klbu3c3Gkvvn/3HN+I3zsj4pKL26G+UAR+o9fCa7UjiCnnhVzfbddqMPIGKkALi6ijvk85jvPEhNBAE8klTacHEHuPjWc/ibKSJZn7kvZdUMqJ56LR1qZYmnzV7yfdoXavWdkxQKr6cIL2sXzYTqCd4Ryi3w5QsTmHiJJEXSNiZ547RWOuxHjnbsvOCrOqp4KbsoxaBADc9xFYlRvLegXZrYUjhu64erjnxeNLfon7h7hV+JELSR7vwhoTHoH3JAfSqgtCPTv4c04I7oIs+fpbR+k5CqY0fEYYpcDnBf3aJKBYpgJWDczQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <53D0548F5897BC409A3E91F01CB6B17A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf49b5e-2406-47af-adb6-08d86888a1c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 17:12:11.0343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RdU0PkIDjRC1cD3LtaHNS7BTa90GovMdOuqvbLCec+GOUZX90Uu89A4GAI7qyNwPCOd6RMAn3eij8xfBUz6cgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3889
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-04_16:2020-10-02,2020-10-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMTAtMDEgYXQgMTY6NDcgKzAyMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLQ0KPiBPbiBX
ZWQsIEp1bCAyMiwgMjAyMCBhdCAwMjo1ODoyNFBNICswMDAwLCBBbGV4IEJlbGl0cyB3cm90ZToN
Cj4gPiBGcm9tOiBZdXJpIE5vcm92IDx5bm9yb3ZAbWFydmVsbC5jb20+DQo+ID4gDQo+ID4gSWYg
Q1BVIHJ1bnMgaXNvbGF0ZWQgdGFzaywgdGhlcmUncyBubyBhbnkgYmFja2xvZyBvbiBpdCwgYW5k
DQo+ID4gc28gd2UgZG9uJ3QgbmVlZCB0byBmbHVzaCBpdC4NCj4gDQo+IFdoYXQgZ3VhcmFudGVl
cyB0aGF0IHdlIGhhdmUgbm8gYmFja2xvZyBvbiBpdD8NCg0KSSBiZWxpZXZlLCB0aGUgbG9naWMg
d2FzIHRoYXQgaXQgaXMgbm90IHN1cHBvc2VkIHRvIGhhdmUgYmFja2xvZw0KYmVjYXVzZSBpdCBj
b3VsZCBub3QgYmUgcHJvZHVjZWQgd2hpbGUgdGhlIENQVSB3YXMgaW4gdXNlcnNwYWNlLA0KYmVj
YXVzZSBvbmUgaGFzIHRvIGVudGVyIGtlcm5lbCB0byByZWNlaXZlIChieSBpbnRlcnJ1cHQpIG9y
IHNlbmQgKGJ5DQpzeXNjYWxsKSBhbnl0aGluZy4NCg0KTm93LCBsb29raW5nIGF0IHRoaXMgcGF0
Y2guIEkgZG9uJ3QgdGhpbmssIGl0IGNhbiBiZSBndWFyYW50ZWVkIHRoYXQNCnRoZXJlIHdhcyBu
byBiYWNrbG9nIGJlZm9yZSBpdCBlbnRlcmVkIHVzZXJzcGFjZS4gVGhlbiBiYWNrbG9nDQpwcm9j
ZXNzaW5nIHdpbGwgYmUgZGVsYXllZCB1bnRpbCBleGl0IGZyb20gaXNvbGF0aW9uLiBJdCB3b24n
dCBiZQ0KcXVldWVkLCBhbmQgZmx1c2hfd29yaygpIHdpbGwgbm90IHdhaXQgd2hlbiBubyB3b3Jr
ZXIgaXMgYXNzaWduZWQsIHNvDQp0aGVyZSB3b24ndCBiZSBhIGRlYWRsb2NrLCBob3dldmVyIHRo
aXMgZGVsYXkgbWF5IG5vdCBiZSBzdWNoIGEgZ3JlYXQNCmlkZWEuDQoNClNvIGl0IG1heSBiZSBi
ZXR0ZXIgdG8gZmx1c2ggYmFja2xvZyBiZWZvcmUgZW50ZXJpbmcgaXNvbGF0aW9uLCBhbmQgaW4N
CmZsdXNoX2FsbF9iYWNrbG9ncygpIGluc3RlYWQgb2Ygc2tpcHBpbmcgYWxsIENQVXMgaW4gaXNv
bGF0ZWQgbW9kZSwNCmNoZWNrIGlmIHRoZWlyIHBlci1DUFUgc29mdG5ldF9kYXRhLT5pbnB1dF9w
a3RfcXVldWUgYW5kIHNvZnRuZXRfZGF0YS0NCj5wcm9jZXNzX3F1ZXVlIGFyZSBlbXB0eSwgYW5k
IGlmIHRoZXkgYXJlIG5vdCwgY2FsbCBiYWNrbG9nIGFueXdheS4NClRoZW4sIGlmIGZvciB3aGF0
ZXZlciByZWFzb24gYmFja2xvZyB3aWxsIGFwcGVhciBhZnRlciBmbHVzaGluZyAod2UNCmNhbid0
IGd1YXJhbnRlZSB0aGF0IG5vdGhpbmcgcHJlZW1wdGVkIHVzIHRoZW4pLCBpdCB3aWxsIGNhdXNl
IG9uZQ0KaXNvbGF0aW9uIGJyZWFraW5nIGV2ZW50LCBhbmQgaWYgbm90aGluZyB3aWxsIGJlIHF1
ZXVlZCBiZWZvcmUgcmUtDQplbnRlcmluZyBpc29sYXRpb24sIHRoZXJlIHdpbGwgYmUgbm8gYmFj
a2xvZyB1bnRpbCBleGl0aW5nIGlzb2xhdGlvbi4NCg0KPiANCj4gPiBDdXJyZW50bHkgZmx1c2hf
YWxsX2JhY2tsb2dzKCkNCj4gPiBlbnF1ZXVlcyBjb3JyZXNwb25kaW5nIHdvcmsgb24gYWxsIENQ
VXMgaW5jbHVkaW5nIG9uZXMgdGhhdCBydW4NCj4gPiBpc29sYXRlZCB0YXNrcy4gSXQgbGVhZHMg
dG8gYnJlYWtpbmcgdGFzayBpc29sYXRpb24gZm9yIG5vdGhpbmcuDQo+ID4gDQo+ID4gSW4gdGhp
cyBwYXRjaCwgYmFja2xvZyBmbHVzaGluZyBpcyBlbnF1ZXVlZCBvbmx5IG9uIG5vbi1pc29sYXRl
ZA0KPiA+IENQVXMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8eW5vcm92
QG1hcnZlbGwuY29tPg0KPiA+IFthYmVsaXRzQG1hcnZlbGwuY29tOiB1c2Ugc2FmZSB0YXNrX2lz
b2xhdGlvbl9vbl9jcHUoKQ0KPiA+IGltcGxlbWVudGF0aW9uXQ0KPiA+IFNpZ25lZC1vZmYtYnk6
IEFsZXggQmVsaXRzIDxhYmVsaXRzQG1hcnZlbGwuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvY29y
ZS9kZXYuYyB8IDcgKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIv
bmV0L2NvcmUvZGV2LmMNCj4gPiBpbmRleCA5MGI1OWZjNTBkYzkuLjgzYTI4MmY3NDUzZCAxMDA2
NDQNCj4gPiAtLS0gYS9uZXQvY29yZS9kZXYuYw0KPiA+ICsrKyBiL25ldC9jb3JlL2Rldi5jDQo+
ID4gQEAgLTc0LDYgKzc0LDcgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L2NwdS5oPg0KPiA+ICAj
aW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0K
PiA+ICsjaW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9o
YXNoLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51
eC9zY2hlZC5oPg0KPiA+IEBAIC01NjI0LDkgKzU2MjUsMTMgQEAgc3RhdGljIHZvaWQgZmx1c2hf
YWxsX2JhY2tsb2dzKHZvaWQpDQo+ID4gIA0KPiA+ICAJZ2V0X29ubGluZV9jcHVzKCk7DQo+ID4g
IA0KPiA+IC0JZm9yX2VhY2hfb25saW5lX2NwdShjcHUpDQo+ID4gKwlzbXBfcm1iKCk7DQo+IA0K
PiBXaGF0IGlzIGl0IG9yZGVyaW5nPw0KDQpTYW1lIGFzIHdpdGggb3RoZXIgY2FsbHMgdG8gdGFz
a19pc29sYXRpb25fb25fY3B1KGNwdSksIGl0IG9yZGVycw0KYWNjZXNzIHRvIGxsX2lzb2xfZmxh
Z3MuDQoNCj4gPiArCWZvcl9lYWNoX29ubGluZV9jcHUoY3B1KSB7DQo+ID4gKwkJaWYgKHRhc2tf
aXNvbGF0aW9uX29uX2NwdShjcHUpKQ0KPiA+ICsJCQljb250aW51ZTsNCj4gPiAgCQlxdWV1ZV93
b3JrX29uKGNwdSwgc3lzdGVtX2hpZ2hwcmlfd3EsDQo+ID4gIAkJCSAgICAgIHBlcl9jcHVfcHRy
KCZmbHVzaF93b3JrcywgY3B1KSk7DQo+ID4gKwl9DQo+ID4gIA0KPiA+ICAJZm9yX2VhY2hfb25s
aW5lX2NwdShjcHUpDQo+ID4gIAkJZmx1c2hfd29yayhwZXJfY3B1X3B0cigmZmx1c2hfd29ya3Ms
IGNwdSkpOw0KPiANCj4gVGhhbmtzLg0KDQo=
