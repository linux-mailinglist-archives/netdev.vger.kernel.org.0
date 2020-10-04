Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7BF282B5B
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 17:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJDPDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 11:03:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2604 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDPDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 11:03:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 094EutUI017313;
        Sun, 4 Oct 2020 08:01:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=7Pb/OciLk3Y9le5DQsAAj2w9FwtF1uPU3iBMX18CdDA=;
 b=dXYphcak8orEGGb9MKUYoEWqHnsifyzt2Aqphto3hvp06+ErHDtajSPWV6/zg4IZ018f
 mFz59zFJFZewyBUXHPiuFgUwijnSOIkpmumhb4psn3v86m+EezgksxUSJSZ7nbvbPv0t
 LABzFXLF/NslGI9qEJnuRSKgxBkdwHMhqj4ZbUZO7jea6O7JJ1oerB+qI193FK8JeTc+
 POmQxUro7Gb8vAKebnGIgWygWPGzJFBNjRYzXgvSN5zXXJRb+2q0jNz5w0YL3TsUuLRC
 HxWnNG0NTD0WNDXXUNAXzq/g82fE/YPZDyFWnPKUqHPy6u/TaLy2tCO76GTp62kk2/OF rA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtna8yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Oct 2020 08:01:51 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Oct
 2020 08:01:49 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Oct
 2020 08:01:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 4 Oct 2020 08:01:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icrjhF3aKLxIodX2qKbfxcSHtCrYGMRzSkna0AvWeaKv47TlOHyvo58FSi5r0TcgTqQ9eSoPHGwUFo4TcjAin9JtZquzEytTbqzhEPDwfTB9s9G7K5UqintKFR4WAmPdyj6Ic7TMtiesII1LIbTBzWCetc1vDSnM+HEKBSMmeQR3xiTs+VJZHGSN3+nieO1FPTguwRlK4xEL0FmIUYfG4QCSs6XxmtCYzKDCwjXNQaJzcM0ngw8eyXv0+innsCErJ+ra38rhZ5CF8UkfbGqb2sw/KR+cL7JwwawatrEeRw2xFv275zU+iHRXeSR2Eyodvttax2R0a6k3UxkQFt3bqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Pb/OciLk3Y9le5DQsAAj2w9FwtF1uPU3iBMX18CdDA=;
 b=KjFiG7obdFditmyf4EN+ntLin+x2siU9E8nlOA68B9V1m29+gwwyFzjnmjd0a4oOVUWAhwoGIVCpzcdlJvaYyyhLfqcw9X5WnuPuJEO0yAfMHORo3CNf5YH59EQyEaN8BiRTIQg0szZH2SuGw3Vx6bE8A7hNQSbrcT7fJtmVzOF8zuAEj0TlgErbNGMmeIiT4jqPyCqz4Oo6pyZhbCYLCS95sb4Op7Bcft7b7R2AesWC7qg+DOxJI9PJ87FFHUuFtKJ/SNnmzPGbJUBxdiTqTnaJq3kaLiyE3W9bLLaaJSijhcd62XfAbn4HKud8qH9LFZAFEaKAwKkA+wTrlOjqqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Pb/OciLk3Y9le5DQsAAj2w9FwtF1uPU3iBMX18CdDA=;
 b=srdrWYBUHawLwlKdw+B+QQjwEtzQIARSV2HemJfp2IVoKLA+6YTeObhySs+xDkFaEXlQ0Mu05WxL/9mQzb6lBs0H/h4w/jDBmQd36aCALR1mg8dlPZ9PpdiEOszhd3CFH4JzemCRNxJaioRDPE/ow2JPaWQtIXOdMApBNWqMk+Q=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2345.namprd18.prod.outlook.com (2603:10b6:907:2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.42; Sun, 4 Oct
 2020 15:01:47 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f%5]) with mapi id 15.20.3433.043; Sun, 4 Oct 2020
 15:01:47 +0000
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
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Topic: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Index: AQHWYDdZDqoeqvfF50CzG3l43t/UoamDQUoAgAS81IA=
Date:   Sun, 4 Oct 2020 15:01:46 +0000
Message-ID: <70705fddfd2c7ecf4b2b06649e6a3379bf9c6916.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
         <20201001144052.GA6595@lothringen>
In-Reply-To: <20201001144052.GA6595@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8ddfbd8-d220-4f91-3c6d-08d868766a45
x-ms-traffictypediagnostic: MW2PR18MB2345:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2345A6EB45183DFE62097BCCBC0F0@MW2PR18MB2345.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tcX18O11iYo6r2XbqRcgXSZfWSJAnpytDVoUmxQqJ9rGGH9RNnkDfu2BM1UQzckLkuXaF4V5QlIPiWV7k3qdbUoWf+O8O6Jv8znG0ICOFbicJb8E5DsKgSCqQC1bqdE4FLUg7WBOiGKnMmGYVOtZ6navztMBWaW+jAYDBf+0PLgXwr0C0XQnJvirD0Uw6UZzcHWBa//LhHOpg0W3f7fNIqvMFEd2BSlDZHNFV11iYKjjfA+aF6JWu6ZMc/uxpoAvSzyHSWdjNoGg+Owl9GtrTNexhVYLMtW9qBLyAjhSBJzsscy7yWiXLf0huGiZCY7stszmKCZ7//GjLtLdk+4MLl5FfSraxoj9EKYAA4vUy/baNADW//5Urv9+pvVfdxhg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39850400004)(136003)(346002)(83380400001)(6506007)(5660300002)(71200400001)(6916009)(6512007)(8936002)(36756003)(6486002)(7416002)(66446008)(64756008)(66556008)(66476007)(8676002)(54906003)(2616005)(316002)(66946007)(26005)(186003)(4326008)(2906002)(76116006)(86362001)(91956017)(478600001)(87944003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QmwsY72YRMEKL3BepbwYIdEXAnZMfNVgk3WQeJKUh+mHySuOjkOvducEIXTx9Ndc1eh7M3Ws2KKLBA45+dlV+vY1D3SHb/9LBsETyv1Vd0AdJmYPewdV+kab+BVoVKrU4RESwlYrOinoRmOb/qBzpzZ/doCcZUcshcwTvGVzz/dlG5o1E+A4pl06YtpP6zjHzKLvgtCFBXJVlIxT6f8pmwkhTuqX2xWbpUbhwHfjiiTvwSEa/oeQQgSuA4L7kkJOich0pmtmoREtdiQjUCNK3voqtYdMHCNNGEScMiDUQE3p1tAQfmNgnwgjFjl/iCareoz7QS1hTdP2GwcKSh+bS47BFMkRbrVU9D0iFcZNaFvq6TvBvNYLt4xGd1rm2T4XMDjUulX1Rqk47HBDxgE/l5KWrB3JfBNc6gWMvkOwjAoor3MxVAUfyto8SED0vMP2f59sbUgK3rT3ETqb9knY1Tj66q1HLbQUy+pgk4J5DWgQDBZ8ppLWP3gfuT5d7RvEZmzSwgNyVxXi24SkKAA2CnWwLg3Qbs677NRoDrvwIhGrxVhh8T04UGhr+dBVPXjH7OBJGxZfXiMwyO8PUQeSpgWfUefpFlOwqFbSeJYsIIY4CDIlDTY1bA/FOsNhbQ8BQonJTx3PysfFI2qpeGZb3Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBD0B7452D91384D83EBC90A923EDE14@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ddfbd8-d220-4f91-3c6d-08d868766a45
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 15:01:46.8818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 94dlZpXaeBz8JZmR1BR1j/4x+DQME6Owm37ytAlk9Gm5e8PuULyywo8jaXL10jNaDIo9+1gQiD/W7PgYS0HmvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2345
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-04_13:2020-10-02,2020-10-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMTAtMDEgYXQgMTY6NDAgKzAyMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLQ0KPiBPbiBX
ZWQsIEp1bCAyMiwgMjAyMCBhdCAwMjo0OTo0OVBNICswMDAwLCBBbGV4IEJlbGl0cyB3cm90ZToN
Cj4gPiArLyoqDQo+ID4gKyAqIHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpIC0gY2xlYXIg
bG93LWxldmVsIHRhc2sgaXNvbGF0aW9uDQo+ID4gZmxhZw0KPiA+ICsgKg0KPiA+ICsgKiBUaGlz
IHNob3VsZCBiZSBjYWxsZWQgaW1tZWRpYXRlbHkgYWZ0ZXIgZW50ZXJpbmcga2VybmVsLg0KPiA+
ICsgKi8NCj4gPiArc3RhdGljIGlubGluZSB2b2lkIHRhc2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRl
cih2b2lkKQ0KPiA+ICt7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+ICsNCj4gPiAr
CS8qDQo+ID4gKwkgKiBUaGlzIGZ1bmN0aW9uIHJ1bnMgb24gYSBDUFUgdGhhdCByYW4gaXNvbGF0
ZWQgdGFzay4NCj4gPiArCSAqDQo+ID4gKwkgKiBXZSBkb24ndCB3YW50IHRoaXMgQ1BVIHJ1bm5p
bmcgY29kZSBmcm9tIHRoZSByZXN0IG9mIGtlcm5lbA0KPiA+ICsJICogdW50aWwgb3RoZXIgQ1BV
cyBrbm93IHRoYXQgaXQgaXMgbm8gbG9uZ2VyIGlzb2xhdGVkLg0KPiA+ICsJICogV2hlbiBDUFUg
aXMgcnVubmluZyBpc29sYXRlZCB0YXNrIHVudGlsIHRoaXMgcG9pbnQgYW55dGhpbmcNCj4gPiAr
CSAqIHRoYXQgY2F1c2VzIGFuIGludGVycnVwdCBvbiB0aGlzIENQVSBtdXN0IGVuZCB1cCBjYWxs
aW5nDQo+ID4gdGhpcw0KPiA+ICsJICogYmVmb3JlIHRvdWNoaW5nIHRoZSByZXN0IG9mIGtlcm5l
bC4gVGhhdCBpcywgdGhpcyBmdW5jdGlvbg0KPiA+IG9yDQo+ID4gKwkgKiBmYXN0X3Rhc2tfaXNv
bGF0aW9uX2NwdV9jbGVhbnVwKCkgb3Igc3RvcF9pc29sYXRpb24oKQ0KPiA+IGNhbGxpbmcNCj4g
PiArCSAqIGl0LiBJZiBhbnkgaW50ZXJydXB0LCBpbmNsdWRpbmcgc2NoZWR1bGluZyB0aW1lciwg
YXJyaXZlcywNCj4gPiBpdA0KPiA+ICsJICogd2lsbCBzdGlsbCBlbmQgdXAgaGVyZSBlYXJseSBh
ZnRlciBlbnRlcmluZyBrZXJuZWwuDQo+ID4gKwkgKiBGcm9tIHRoaXMgcG9pbnQgaW50ZXJydXB0
cyBhcmUgZGlzYWJsZWQgdW50aWwgYWxsIENQVXMgd2lsbA0KPiA+IHNlZQ0KPiA+ICsJICogdGhh
dCB0aGlzIENQVSBpcyBubyBsb25nZXIgcnVubmluZyBpc29sYXRlZCB0YXNrLg0KPiA+ICsJICoN
Cj4gPiArCSAqIFNlZSBhbHNvIGZhc3RfdGFza19pc29sYXRpb25fY3B1X2NsZWFudXAoKS4NCj4g
PiArCSAqLw0KPiA+ICsJc21wX3JtYigpOw0KPiANCj4gSSdtIGEgYml0IGNvbmZ1c2VkIHdoYXQg
dGhpcyByZWFkIG1lbW9yeSBiYXJyaWVyIGlzIG9yZGVyaW5nLiBBbHNvDQo+IGFnYWluc3QNCj4g
d2hhdCBpdCBwYWlycy4NCg0KTXkgYmFkLCBJIGhhdmUga2VwdCBpdCBhZnRlciB0aGVyZSB3ZXJl
IGxlZnQgbm8gd3JpdGUgYWNjZXNzZXMgZnJvbQ0Kb3RoZXIgQ1BVcy4NCg0KPiANCj4gPiArCWlm
KCh0aGlzX2NwdV9yZWFkKGxsX2lzb2xfZmxhZ3MpICYgRkxBR19MTF9UQVNLX0lTT0xBVElPTikg
PT0NCj4gPiAwKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwlsb2NhbF9pcnFfc2F2ZShm
bGFncyk7DQo+ID4gKw0KPiA+ICsJLyogQ2xlYXIgbG93LWxldmVsIGZsYWdzICovDQo+ID4gKwl0
aGlzX2NwdV93cml0ZShsbF9pc29sX2ZsYWdzLCAwKTsNCj4gPiArDQo+ID4gKwkvKg0KPiA+ICsJ
ICogSWYgc29tZXRoaW5nIGhhcHBlbmVkIHRoYXQgcmVxdWlyZXMgYSBiYXJyaWVyIHRoYXQgd291
bGQNCj4gPiArCSAqIG90aGVyd2lzZSBiZSBjYWxsZWQgZnJvbSByZW1vdGUgQ1BVcyBieSBDUFUg
a2ljayBwcm9jZWR1cmUsDQo+ID4gKwkgKiB0aGlzIGJhcnJpZXIgcnVucyBpbnN0ZWFkIG9mIGl0
LiBBZnRlciB0aGlzIGJhcnJpZXIsIENQVQ0KPiA+ICsJICoga2ljayBwcm9jZWR1cmUgd291bGQg
c2VlIHRoZSB1cGRhdGVkIGxsX2lzb2xfZmxhZ3MsIHNvIGl0DQo+ID4gKwkgKiB3aWxsIHJ1biBp
dHMgb3duIElQSSB0byB0cmlnZ2VyIGEgYmFycmllci4NCj4gPiArCSAqLw0KPiA+ICsJc21wX21i
KCk7DQo+ID4gKwkvKg0KPiA+ICsJICogU3luY2hyb25pemUgaW5zdHJ1Y3Rpb25zIC0tIHRoaXMg
Q1BVIHdhcyBub3Qga2lja2VkIHdoaWxlDQo+ID4gKwkgKiBpbiBpc29sYXRlZCBtb2RlLCBzbyBp
dCBtaWdodCByZXF1aXJlIHN5bmNocm9uaXphdGlvbi4NCj4gPiArCSAqIFRoZXJlIG1pZ2h0IGJl
IGFuIElQSSBpZiBraWNrIHByb2NlZHVyZSBoYXBwZW5lZCBhbmQNCj4gPiArCSAqIGxsX2lzb2xf
ZmxhZ3Mgd2FzIGFscmVhZHkgdXBkYXRlZCB3aGlsZSBpdCBhc3NlbWJsZWQgYSBDUFUNCj4gPiAr
CSAqIG1hc2suIEhvd2V2ZXIgaWYgdGhpcyBkaWQgbm90IGhhcHBlbiwgc3luY2hyb25pemUgZXZl
cnl0aGluZw0KPiA+ICsJICogaGVyZS4NCj4gPiArCSAqLw0KPiA+ICsJaW5zdHJfc3luYygpOw0K
PiANCj4gSXQncyB0aGUgZmlyc3QgdGltZSBJIG1lZXQgYW4gaW5zdHJ1Y3Rpb24gYmFycmllci4g
SSBzaG91bGQgZ2V0DQo+IGluZm9ybWF0aW9uDQo+IGFib3V0IHRoYXQgYnV0IHdoYXQgaXMgaXQg
b3JkZXJpbmcgaGVyZT8NCg0KQWdhaW5zdCBiYXJyaWVycyBpbiBpbnN0cnVjdGlvbiBjYWNoZSBm
bHVzaGluZyAoZmx1c2hfaWNhY2hlX3JhbmdlKCkNCmFuZCBzdWNoKS4gDQoNCj4gPiArCWxvY2Fs
X2lycV9yZXN0b3JlKGZsYWdzKTsNCj4gPiArfQ0KPiANCj4gVGhhbmtzLg0KDQo=
