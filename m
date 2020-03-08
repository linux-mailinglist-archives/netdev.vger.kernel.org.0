Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7F317D201
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 07:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCHGHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 01:07:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbgCHGHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 01:07:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02864kM8027595;
        Sat, 7 Mar 2020 22:06:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=zIFKKHEGW+vn11Hf3a1dMwqMiRnNbSOpSezFNbnFG8o=;
 b=FORN1mGRqG7tS1PsE2n4uGFgaXPL1mmMET/W/fhgkzsNyMO2ljJ/8w5QiiNicRbh6LDG
 cw9HGUvdYdsZ01e0C1qurJLMUse4FRf5wRrFCAALnZvRfZW7AX77ULookAMMtMMKPwCv
 HDnmP38d1VlknMqOUxus6Fl1l+xRvGiG542VKlOnUS7ierEDy8ouhfPPcfTQZJ4dpxPG
 ddN9a48XWx08pLdMSY66ra3UgeM9FfEzbSzUUOhVQAjhogtbdr2HN6ZLOKv2tQwUl2f7
 Q9PK0R+dCuEyk2U4pI7GYx0cWVPHln7+JZso/kzQQQGjHbYHlKYY+wWuckd+eVSn0MRj 4A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj9e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 22:06:25 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 22:06:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 22:06:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPUtT8yLcmlSYo0+9yogdd4oGCr7qu9H1ywuqL7bDlL/NUTxSketBvSE94zwqkTqh6LBnv66ODGiECrFRF2FgW9VpuS+onNROyJhF27bCCOYsfylfMGo+pYD7RlTsqSGM/NG/Ou8GV3lXbdDQn60aMARZruNK2uIoIt1m9GejBI/Sat9tEShl3xHQvOAgtuWl+5P70PPNOaAj5oHUDcjOxl0sht9CSJkVDv5WnnBezZVqwLfpYndNhiiwv4664hxBJvhLumIA1cPm+GB32HFsXsR0ImcOUja5TJKLYCZIBxrJPWMGcZFdazhUBOe1Efq/8eInVRW00OjEBAa21scMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIFKKHEGW+vn11Hf3a1dMwqMiRnNbSOpSezFNbnFG8o=;
 b=W0cOY73doUwnyFMsw2xOf4g+MuSYpMFvlu2lIoC0PjOKIW+JGKeGd2OrkiHhf/xuJajquNlyOV7LDgT1vWZsuZvnTbpZ9W/V9A/whsBsMi49TjGpBohODnzc201neJpFiMj1W/4+UcBurA5pNL7voQ7zP+ELEYLr6dMeqIk4GDI1ZxkMomgfSTpCIPXWBa/UgWn2KAVnq2T1bfBznuZPHaIx4N/yhTxxAqJhlZblhfX6ODxt3RBOG00TQU8PqLCYccgMJ7js2uw1T6WWOenmsKQFhLba9U8DfgFAzABq3VlxeiEkhmfez+ClcgBOH2mklCTOtkaRkocC3aUUJmUOiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIFKKHEGW+vn11Hf3a1dMwqMiRnNbSOpSezFNbnFG8o=;
 b=D+8S9RS9T/Trm/Mvx6Ho6qvV8azrc/vy0b3Q3088Uv+4QtSz4lhCS/nVMHvVMb1rfUCjce3EaafbpuwL+aXl0cdN8dEukH0oVbrn7Q8kFCL5bNEt/rhfjf2OV55N/K2by0EOLgGrjELvgSh0KhJCUViprp93eNYPTYVszbSyXTQ=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2662.namprd18.prod.outlook.com (2603:10b6:a03:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sun, 8 Mar
 2020 06:06:20 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 06:06:20 +0000
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
Thread-Index: AQHV8j73SZ7gA0FMRkuOSCw4mVFsAKg7sr2AgAKII4A=
Date:   Sun, 8 Mar 2020 06:06:19 +0000
Message-ID: <5b819b1a8c3a4c9c2361ff10a31ac91df1851b83.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <36d84b8dd168a38e6a56549dedc15dd6ebf8c09e.camel@marvell.com>
         <20200306152632.GB8590@lenoir>
In-Reply-To: <20200306152632.GB8590@lenoir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fda5adf1-ee54-41b8-b341-08d7c326d24e
x-ms-traffictypediagnostic: BYAPR18MB2662:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB26624A47E63058FB1F817E0FBCE10@BYAPR18MB2662.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39840400004)(366004)(396003)(189003)(199004)(316002)(2906002)(54906003)(6486002)(7416002)(5660300002)(86362001)(478600001)(186003)(8936002)(71200400001)(36756003)(4326008)(66946007)(26005)(81166006)(6916009)(6506007)(76116006)(2616005)(91956017)(66476007)(81156014)(8676002)(66556008)(66446008)(6512007)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2662;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EE9BGWrC1sXMUU31FqMJeThnubd+j4PBwVvTaEBzu7mrg/a0hmiJC01hsXRwlzljEiMqWs5aSWa60Wjij+lnq6eKePDVMCImdKm0NRXL7EdSND9MXjWIwjVlkkkDarFqa3lXWKSGezPX8RcY1ND9iVHDHtVo5ou8dksQkjD/qgIIGQIkHDI7y8ETpGm/ZIoaWyEFuW+Fc8lLQ3655LkeyIV605ifNbYj955aMNzygnpmRBD1VzLp3h1ndbFuST0Q1yVzBfKIDrnLeQeE1vY7mCqsSKGdfM+WJ5wJi3BimIsZLJU45Sf92/DJN27REJlcgu4I4zntjb+/o46iZc0ncSPZ0EOQZbV1J0Q683VESltgH8GarD7U6tWmn3nv/r8KCTKzYc58t5gKFPgV7/N1VAPV2AaZTOy4JW/D3AJ0jXpG4+ATnH2wAg/jpYfwSw4G
x-ms-exchange-antispam-messagedata: xRIxEzv9npUjnbJdOiPeOMPNH6YSwGqkppbI8Oa6wkgmW7/EejkJKz+BUq+OMrV2/V9wwk+gdfKuckgTBL89QDgbnPsYDMxNywysVErHadBR16hEeCqrG0t9BellOd7PNvOGOlCoMqaH6V4ISvO/vg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3ED4782FA3D7DB4CB3FB6ACA8D014FFC@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fda5adf1-ee54-41b8-b341-08d7c326d24e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 06:06:19.9182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AMA2aDtZ6kxf2ig/DNXk2uF/RCocVQu+DIt/40YGMs0mGl9W9eewTlV+ztjyil10c0DSRU4h7o2UQit7s0XZ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2662
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-08_01:2020-03-06,2020-03-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTA2IGF0IDE2OjI2ICswMTAwLCBGcmVkZXJpYyBXZWlzYmVja2VyIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAwNDowNzoxMlBNICswMDAwLCBBbGV4IEJl
bGl0cyB3cm90ZToNCj4gPiAJCWRvIHsNCj4gPiArCQkJLyogTWFrZSBzdXJlIHdlIGFyZSByZWFk
aW5nIHVwIHRvIGRhdGUgdmFsdWVzDQo+ID4gKi8NCj4gPiArCQkJc21wX21iKCk7DQo+ID4gKwkJ
CWluZCA9IGluZF9jb3VudGVyICYgMTsNCj4gPiArCQkJc25wcmludGYoYnVmX3ByZWZpeCwgc2l6
ZW9mKGJ1Zl9wcmVmaXgpLA0KPiA+ICsJCQkJICJpc29sYXRpb24gJXMvJWQvJWQgKGNwdSAlZCki
LA0KPiA+ICsJCQkJIGRlc2MtPmNvbW1baW5kXSwgZGVzYy0+dGdpZFtpbmRdLA0KPiA+ICsJCQkJ
IGRlc2MtPnBpZFtpbmRdLCBjcHUpOw0KPiA+ICsJCQlkZXNjLT53YXJuZWRbaW5kXSA9IHRydWU7
DQo+ID4gKwkJCWluZF9jb3VudGVyX29sZCA9IGluZF9jb3VudGVyOw0KPiA+ICsJCQkvKiBSZWNv
cmQgdGhlIHdhcm5lZCBmbGFnLCB0aGVuIHJlLXJlYWQNCj4gPiBkZXNjcmlwdG9yICovDQo+ID4g
KwkJCXNtcF9tYigpOw0KPiA+ICsJCQlpbmRfY291bnRlciA9IGF0b21pY19yZWFkKCZkZXNjLT5j
dXJyX2luZGV4KTsNCj4gPiArCQkJLyoNCj4gPiArCQkJICogSWYgdGhlIGNvdW50ZXIgY2hhbmdl
ZCwgc29tZXRoaW5nIHdhcw0KPiA+IHVwZGF0ZWQsIHNvDQo+ID4gKwkJCSAqIHJlcGVhdCBldmVy
eXRoaW5nIHRvIGdldCB0aGUgY3VycmVudCBkYXRhDQo+ID4gKwkJCSAqLw0KPiA+ICsJCX0gd2hp
bGUgKGluZF9jb3VudGVyICE9IGluZF9jb3VudGVyX29sZCk7DQo+ID4gKwl9DQo+IA0KPiBTbyB0
aGUgbmVlZCB0byBsb2cgdGhlIGZhY3Qgd2UgYXJlIHNlbmRpbmcgYW4gZXZlbnQgdG8gYSByZW1v
dGUgQ1BVDQo+IHRoYXQgKm1heSBiZSoNCj4gcnVubmluZyBhbiBpc29sYXRlZCB0YXNrIG1ha2Vz
IHRoaW5ncyB2ZXJ5IGNvbXBsaWNhdGVkIGFuZCBldmVuIHJhY3kuDQoNClRoZSBvbmx5IHJlYXNv
biB3aHkgdGhlIHJlc3VsdCBvZiB0aGlzIHdvdWxkIGJlIHdyb25nLCBpcyB0aGUgcmFjZQ0KYmV0
d2VlbiBtdWx0aXBsZSBjYXVzZXMgb2YgYnJlYWtpbmcgaXNvbGF0aW9uIG9mIHRoZSBzYW1lIHRh
c2sgb3IgcmFjZQ0Kd2l0aCB0aGUgdGFzayBleGl0aW5nIGlzb2xhdGlvbiBvbiBpdHMgb3duIGF0
IHRoZSBzYW1lIHRpbWUgKGFuZA0KcG9zc2libHkgcmUtZW50ZXJpbmcgaXQsIG9yIGV2ZW4gYW5v
dGhlciB0YXNrIGVudGVyaW5nIG9uIHRoZSBzYW1lIENQVQ0KY29yZSkuIFRoaXMgaXMgcG9zc2li
bGUsIGhvd2V2ZXIgZm9yIGFsbCBwcmFjdGljYWwgcHVycG9zZXMgd2UgYXJlDQpzdGlsbCBsb2dn
aW5nIGFuIGlzb2xhdGlvbi1icmVha2luZyBldmVudCB0aGF0IGhhcHBlbmVkIHdoaWxlIGEgcmVh
bA0KaXNvbGF0ZWQgdGFzayB3YXMgcnVubmluZy4gV2Ugc2hvdWxkIGtlZXAgaW4gbWluZCB0aGUg
cG9zc2liaWxpdHkgdGhhdA0KdGhpcyBpc29sYXRpb24tYnJlYWtpbmcgZXZlbnQgY291bGQgYmUg
cHJlZW1wdGVkIGJ5IGFub3RoZXIgaXNvbGF0aW9uDQpicmVha2luZyBjYXVzZSwgYW5kIGFsbCBv
ZiB0aGVtIHdpbGwgYmUgcmVjb3JkZWQgZXZlbiBpZiBvbmx5IG9uZSBlbmRlZA0KdXAgY2F1c2lu
ZyBmYXN0X3Rhc2tfaXNvbGF0aW9uX2NwdV9jbGVhbnVwKCkgdG8gYmUgY2FsbGVkIG9uIHRoZSB0
YXJnZXQNCkNQVSBjb3JlLg0KDQo+IEhvdyBiYWQgd291bGQgaXQgYmUgdG8gb25seSBsb2cgdGhv
c2UgaW50ZXJydXB0aW9ucyBvbmNlIHRoZXkgbGFuZCBvbg0KPiB0aGUgdGFyZ2V0Pw0KPiANCg0K
Rm9yIHRoZSBwdXJwb3NlIG9mIGRldGVybWluaW5nIHRoZSBjYXVzZSBvZiBpc29sYXRpb24gYnJl
YWtpbmcgLS0gdmVyeQ0KYmFkLiBFYXJseSB2ZXJzaW9ucyBvZiB0aGlzIG1hZGUgcGVvcGxlIHRl
YXIgdGhlaXIgaGFpciBvdXQgdHJ5aW5nIHRvDQpkaXZpbmUsIHdoZXJlIHNvbWUgSVBJIGNhbWUg
ZnJvbS4gVGhlbiB0aGVyZSB3YXMgYSBtb25zdHJvc2l0eSB0aGF0IGRpZA0Kc29tZSByYXRoZXIg
dW5zYWZlIG1hbmlwdWxhdGlvbnMgd2l0aCB0YXNrX3N0cnVjdCwgaG93ZXZlciBpdCB3YXMgb25s
eQ0Kc3VpdGFibGUgYXMgYSB0ZW1wb3JhcnkgbWVjaGFuaXNtIGZvciBkZXZlbG9wbWVudC4gVGhp
cyB2ZXJzaW9uIGtlZXBzDQp0aGluZ3MgY29uc2lzdGVudCBhbmQgb25seSBzaG93cyB1cCB3aGVu
IHRoZXJlIGlzIHNvbWV0aGluZyB0aGF0IHNob3VsZA0KYmUgcmVwb3J0ZWQuDQoNCj4gVGhhbmtz
Lg0KDQpUaGFua3MhDQoNCi0tIA0KQWxleA0K
