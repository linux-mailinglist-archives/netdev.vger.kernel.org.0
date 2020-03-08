Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8016517D236
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 08:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgCHH3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 03:29:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37936 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgCHH3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 03:29:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0287P8v7006938;
        Sat, 7 Mar 2020 23:28:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=wu6Lo5wWstzRksrBKaN8MSm3+M+uReG9PpVkF3sgNV4=;
 b=ZhLyGGNUGFtMhhMzyjYM6nhFMh8kXc89yb700+CBpHQcVmCjBD/qlJUCSBTbd6BdlV9b
 vKS+WlU/MOz+thomYdEJFQiDHcpmn/SQrlkmESnRCS6VdTuIlqG9c8OttPzGs2iVh3aK
 FBwctUhX8zrsw5SRdYFk5Zfod5nb3AITwTkMOhC17w8mgnbZ/HMDdDD1ZT0627Zt1KJl
 F7BXwTJ49fvp7LS3vGmwAS56JzjmE4kyGkaHuKI1Cp2c4D4Mnd2aNqNCgzLuMKa0xTbo
 w+vIGZ4hO0gNcJKnOC1nkOk80KGOIi7MJRk9XDaVd1Mq5MXdfT48o3N9VV5tXyTmGnrl DA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ym9uwb951-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 23:28:26 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 23:28:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 23:28:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPyJGGOZYHcKDWs6xpQ4DVw1IsmhnADtcoMdF+yknAop5d0dNfZUHhtlYNw20x/8eGrMYrNT7zrNnKiqQraYKHsGcYEXf3qktf6n1XUMLUCQz36R1fWSMcEsDU4+Ta/NLYauBt7jfK37fCytosy2peR+NozlAfhOL65Bb6SfchgygHZ2aG1uSj23tk4OXpTkp9l2jSzADp2tZmoHadLBTlXp4Oq/vAFctzcpzldu8Yhiad9BKG1b2qj1Q1wCezlCrGIspUBXYhR38YeUpOlqaG95Tnmq0J0EfygIyyF95IQ95lLQXTQRlwCOaQPmyz/3Lc3Xu0uVFnAzDH3SqReUGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu6Lo5wWstzRksrBKaN8MSm3+M+uReG9PpVkF3sgNV4=;
 b=gDEgdFaUhp0+RVJw8F5uCefk6X6Rijy02cJ03yMVL2mgB8P6vO8NJIRU+MWz5AV1xuTWg18Tdgpf7gvMKO0ZIYz7yR3S0Pbzlklmo2CE6IcRtVZhyPNc7tAto2cT0a69HfFiI7Pii4UfOACoU/Gjo1VbE5Yv4wdRbIR7fzmbpdxvkUr2udNmHzaauXNnsRAwcduBuoUjInf+tHqYld7dTcztRehSFa7VSE+TviCFDWfORsfsJGW/YUTrRhVQOU8gPXtOqas4coi+dl33D+7FMUWg7+4WrvqiSpK+S97UH9of9IrreTxWXyrFmsSW1qpPWCBiY6NkGdgz0zG8pog02Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu6Lo5wWstzRksrBKaN8MSm3+M+uReG9PpVkF3sgNV4=;
 b=miyuqoxNzYPQygzas2NObXJbkD8MxbbhtZ+9Mpg5T5ks2QhU85XDjCmsxNyWWngbQN7Td68Ejx5yOm8mOIKJ1wlMcXq3Q8L7MzUOIwpr0ogHSCnIFP7Go8VnSG8ny+VeHSXZgeU0c+oypJSW3v+Z1NhqP2QMPIKJLFDe4yIIiwQ=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2472.namprd18.prod.outlook.com (2603:10b6:a03:13d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Sun, 8 Mar
 2020 07:28:23 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 07:28:23 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: Re: [EXT] Re: [PATCH 08/12] task_isolation: don't interrupt CPUs with
 tick_nohz_full_kick_cpu()
Thread-Topic: [EXT] Re: [PATCH 08/12] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Index: AQHV8j+6YdQrrVvjWUOq9zKJGSyO36g7vR0AgAKUrgA=
Date:   Sun, 8 Mar 2020 07:28:22 +0000
Message-ID: <646a22fd24e8dfeb1eb3101ae7be2b88e91dbfa3.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <d7ce01e57d4a35b126e1cb96a63109eaa9781cb6.camel@marvell.com>
         <20200306160341.GE8590@lenoir>
In-Reply-To: <20200306160341.GE8590@lenoir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b12f124-74ba-4bc5-51ed-08d7c33248c5
x-ms-traffictypediagnostic: BYAPR18MB2472:
x-microsoft-antispam-prvs: <BYAPR18MB2472BB25817FAFBEB894867FBCE10@BYAPR18MB2472.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(396003)(366004)(136003)(376002)(199004)(189003)(66446008)(71200400001)(186003)(26005)(5660300002)(4326008)(6486002)(64756008)(66946007)(76116006)(6506007)(91956017)(66476007)(66556008)(86362001)(6512007)(316002)(2616005)(2906002)(81166006)(81156014)(8676002)(478600001)(36756003)(8936002)(54906003)(7416002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2472;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NdDaKHFGHT/n9FMIHK+iNf8u58H+2/hk7KTMmTz8u23uJ4M/5EzZYcTSlYp8gOxKV/UEsX10HUgkfaZbXKLM9pz0faIiMst+ApnUIKWzpRkDYBziFb6tQ7vGpvPnUp8z3qulUjHM9VffsQH+xka9bR05Ya/8qDndYrTB3o+ImZDr5QsU+mYEXDrknvZYmBz3lhYHB1459a6Tgq5WlMJqf6TKYu9xR09v6PCKpY2f1Wpl8VKzwGKBLJTTwgDYaARXeKF4eURlTHcLdZpgCyddo9LCT1XWpzdXhf1a3tCAG6hG562gOA+ENmcqQ0VATEGeK7TOkYBynD8Df4+q1HvgOkoaDyLpnoaVFJpXM7SoxgUEELhe5isL+R5Jl7oomOXVb1qR9g5TBYusvYWeJAmj/hXzDckH4CkG7Pl0AJGRujk6rWvhFTMSPR771xHFXygB
x-ms-exchange-antispam-messagedata: p4nR8GcG16yoP2bXPJWhudVyra+Q5Xd6URvZTfFf1iMF8H/ZshA4mWqUB9ofbBIaW2PYq2P9FLs8l4xbFUWmGjmdxSbFM8cKjz/e8ZJDpo6YPUTiiwXz7sLp2+hbH4i+rKShwI4TgV9UBs5YuwDRvw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD5961556E38F24FA82A8F3B47E2B2FC@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b12f124-74ba-4bc5-51ed-08d7c33248c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 07:28:23.0228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TUeawNXKY+lzRNhXtmaquLvsXaP4C7NmQKRlzuv6EIvhxKRMmTekFgqGsNSI89+lNk54CwbcmzyQQka0lqbjKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2472
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-08_02:2020-03-06,2020-03-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTA2IGF0IDE3OjAzICswMTAwLCBGcmVkZXJpYyBXZWlzYmVja2VyIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAwNDoxMjo0MFBNICswMDAwLCBBbGV4IEJl
bGl0cyB3cm90ZToNCj4gPiBGcm9tOiBZdXJpIE5vcm92IDx5bm9yb3ZAbWFydmVsbC5jb20+DQo+
ID4gDQo+ID4gRm9yIG5vaHpfZnVsbCBDUFVzIHRoZSBkZXNpcmFibGUgYmVoYXZpb3IgaXMgdG8g
cmVjZWl2ZSBpbnRlcnJ1cHRzDQo+ID4gZ2VuZXJhdGVkIGJ5IHRpY2tfbm9oel9mdWxsX2tpY2tf
Y3B1KCkuIEJ1dCBmb3IgaGFyZCBpc29sYXRpb24gaXQncw0KPiA+IG9idmlvdXNseSBub3QgZGVz
aXJhYmxlIGJlY2F1c2UgaXQgYnJlYWtzIGlzb2xhdGlvbi4NCj4gPiANCj4gPiBUaGlzIHBhdGNo
IGFkZHMgY2hlY2sgZm9yIGl0Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVsaXRz
IDxhYmVsaXRzQG1hcnZlbGwuY29tPg0KPiA+IC0tLQ0KPiA+ICBrZXJuZWwvdGltZS90aWNrLXNj
aGVkLmMgfCAzICsrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpY2stc2NoZWQu
YyBiL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KPiA+IGluZGV4IDFkNGRlYzlkM2VlNy4uZmU0
NTAzYmExMzE2IDEwMDY0NA0KPiA+IC0tLSBhL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KPiA+
ICsrKyBiL2tlcm5lbC90aW1lL3RpY2stc2NoZWQuYw0KPiA+IEBAIC0yMCw2ICsyMCw3IEBADQo+
ID4gICNpbmNsdWRlIDxsaW51eC9zY2hlZC9jbG9jay5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgv
c2NoZWQvc3RhdC5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvc2NoZWQvbm9oei5oPg0KPiA+ICsj
aW5jbHVkZSA8bGludXgvaXNvbGF0aW9uLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1bGUu
aD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L2lycV93b3JrLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51
eC9wb3NpeC10aW1lcnMuaD4NCj4gPiBAQCAtMjYyLDcgKzI2Myw3IEBAIHN0YXRpYyB2b2lkIHRp
Y2tfbm9oel9mdWxsX2tpY2sodm9pZCkNCj4gPiAgICovDQo+ID4gIHZvaWQgdGlja19ub2h6X2Z1
bGxfa2lja19jcHUoaW50IGNwdSkNCj4gPiAgew0KPiA+IC0JaWYgKCF0aWNrX25vaHpfZnVsbF9j
cHUoY3B1KSkNCj4gPiArCWlmICghdGlja19ub2h6X2Z1bGxfY3B1KGNwdSkgfHwgdGFza19pc29s
YXRpb25fb25fY3B1KGNwdSkpDQo+ID4gIAkJcmV0dXJuOw0KPiANCj4gSSBmZWFyIHlvdSBjYW4n
dCBkbyB0aGF0LiBBIG5vaHogZnVsbCBDUFUgaXMga2lja2VkIGZvciBhIHJlYXNvbi4NCj4gQXMg
Zm9yIHRoZSBvdGhlciBjYXNlcywgeW91IG5lZWQgdG8gZml4IHRoZSBjYWxsZXJzLg0KPiANCj4g
SW4gdGhlIGdlbmVyYWwgY2FzZSwgcmFuZG9tbHkgaWdub3JpbmcgYW4gaW50ZXJydXB0IGlzIGEg
Y29ycmVjdG5lc3MNCj4gaXNzdWUuDQoNCk5vdCBpZ25vcmluZywganVzdCBkZWxheWluZyB1bnRp
bCB3ZSBhcmUgYmFjayBmcm9tIHVzZXJzcGFjZS4gV2Uga25vdw0KdGhhdCBldmVyeXRoaW5nIHdh
cyBkb25lIG9uIHRoaXMgQ1BVIHdoZW4gd2Ugc3VjY2Vzc2Z1bGx5IGVudGVyZWQNCnVzZXJzcGFj
ZSBpbiBpc29sYXRlZCBtb2RlIC0tIG90aGVyd2lzZSB3ZSB3b3VsZCBiZSBraWNrZWQgb3V0LiBX
ZQ0KcmVzdGFydCB0aW1lcnMgd2hlbiB3ZSBhcmUgYmFjayBpbiBrZXJuZWwgYWdhaW4gb24gY2xl
YW51cCwgc28gdGhpbmdzDQp3aWxsIGJlIGJhY2sgdG8gbm9ybWFsIGF0IHRoYXQgcG9pbnQuIEJl
dHdlZW4gdGhvc2UgbW9tZW50cyB3ZSBjYW4ganVzdA0KYXMgd2VsbCByZW1haW4gaW4gdXNlcnNw
YWNlIGFuZCBmb3JnZXQgYWJvdXQgdGhlIHRpbWVycyB1bnRpbCB3ZSBhcmUNCmJhY2sgaW4ga2Vy
bmVsLg0KDQo+IA0KPiBUaGFua3MuDQo=
