Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC50D291309
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438710AbgJQQPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 12:15:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21082 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438208AbgJQQPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 12:15:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09HGAfNW010152;
        Sat, 17 Oct 2020 09:15:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=MhGnhV1tQWOk+fbCQ9U3xYzsbA8puzqBZ3iOYNGaIdM=;
 b=dYf6tByRj9GzPu10qfHwFBtBPpQnof1MR5Izq/lkIhzuL/69CS0KYLd1TAspVtiAHALR
 FJWnOcd0ud/9hmD990MIRryCqz1wRR/pFHL5YcrtpKz4GNsx44IbrBj1nrkmMGixfLT3
 PIfeSNraTwTBuqUh0JjnRhP8q4wivh0STZz1tTk2HUVL0QvQEHY+/Ieet8QwMdTZ9GYu
 pir99qQGgADrC7hZqi/IJMBi840R0AaPkKoAmm0ME3kFSWxRJoWF3sZl4dyYulw1YuvQ
 QLvPkprfB919uGvWP2waIF+nKrNjn6hPjHB6TOHo3SwNU5PZr9u6W3byxnPWxRnbtxGH wg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyq0p21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 17 Oct 2020 09:15:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 17 Oct
 2020 09:15:09 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 17 Oct
 2020 09:15:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 17 Oct 2020 09:15:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URJM5Fcg+tEY/RyYVuK6rMpTU5Do9k0xxxdl7+rf1HXz4EY4Fqa9fTfk/kO+TYuygnHscZSKRWOp0NDeMIm0xBRPds1lulhccebfWLpxl0SwVZMywlKA/Z7oyt05Vz/blGKuwdRnGLQQu0MC6J99F9irWqiMo/ot/UnBbI6X10ClRVYqEWe8JmgNC64sf7iFMEj8ijP81dT9RHnQSQeH1Fs2ljCLee8wmYC4wSRRbzpNOrdUb4aE/TYJOIjYogdChF4SlFVtCVR0IYVmHadKuaTKC3o61VVflUnyA9A9nyMMx74jBiW3VyB9OiFLZJuS6IOZEB267O2e1r/qYbG5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhGnhV1tQWOk+fbCQ9U3xYzsbA8puzqBZ3iOYNGaIdM=;
 b=DtrBhIa2oHy0xBDpCLukeixhsDFJmteE+IYbJLVQL52ypXS/S6wCeCvLjnByuo03hLXdEZqC6WUIt15ghrlbauNxIvONnMRvWVTz7WVWH0pt6rkjvSHycZ69eEJT/OnjfZUDFosb53CtcKGqSi1uuRSrop2TWhjhT92Er65siy8fibtfhQgWaFSbPM9C9UGnrgR9n/HOzjTs5PbcjWaPTsCKCd7zlAh7TmAJ0cEizTj7kBnt+aiV/mLpusqHEG0rmKf1H11q/GUCdPuagYGjPPUu5q+igsuHlJpwScaj2KysiIl+0Z08WfvXj8LmB8mxDxbKO+eJ6Y2cWh73EnE7Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhGnhV1tQWOk+fbCQ9U3xYzsbA8puzqBZ3iOYNGaIdM=;
 b=dFG3nuJoRzBRGIbEjy/lf7IMdCeAj8LyTT2VT5iric0d/WkgjBb2xXg9HHXmzDJcHW752m6CdZQT4iRT1WEZyYN41dy7fHLFfDdbJUVJYjJiPZoJ3Sgq62NVK1KzrUbt9/QSiC6fXivjQ4Dk8OmzrpX4RAp3QjnvrvkboajdX6E=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB2048.namprd18.prod.outlook.com (2603:10b6:301:67::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 16:15:06 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95%7]) with mapi id 15.20.3455.031; Sat, 17 Oct 2020
 16:15:05 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Topic: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Index: AQHWYDdZDqoeqvfF50CzG3l43t/UoamDNPAAgATEYwCAAI5YAIABSVeAgBGyj4CAAPt0AIAAAeQA
Date:   Sat, 17 Oct 2020 16:15:05 +0000
Message-ID: <e9c5513d0d8dcd8b2db07a932e9f45640be6b0ea.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
         <20201001135640.GA1748@lothringen>
         <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
         <20201004231404.GA66364@lothringen>
         <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
         <91b8301b0888bf9e5ff7711c3b49d21beddf569a.camel@marvell.com>
         <87r1pwj0nh.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87r1pwj0nh.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c30f92ac-963f-4cdb-a647-08d872b7cf77
x-ms-traffictypediagnostic: MWHPR1801MB2048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB2048E3BBA5AE974E1799162DBC000@MWHPR1801MB2048.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hdivmllgBYQE6DHlyZXSSt6LkpDBdL38puZnM5fgFF0q4FcPH58IRWKecXL4PLKt/GTUdgS2aUoZw1emleeujTMS/z0gyKY/HHhLBD7wlWBYWMBMcv9pkKbx+YNgJMWfI8dsNCWIikJ1u4pLvzkw0GHc1Z7KQKACTOBAb5fOPqNS77uwrmwYhWSWMqBSUvUCgBKf4rnEOpjaYpgQMTaLDoTowtix9JPf/ojYE/k0LxfX35p7uenDy3fAcP5teNccwtuPKndfeqP/ICADlTFQbQq44huurLB+CzOlAXqYX9gA6MumDFUSI3NRBXnq5/tI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(136003)(376002)(366004)(6506007)(53546011)(8676002)(54906003)(83380400001)(71200400001)(4001150100001)(8936002)(110136005)(316002)(4744005)(64756008)(186003)(66946007)(76116006)(91956017)(26005)(66446008)(2616005)(5660300002)(7416002)(2906002)(6512007)(36756003)(6486002)(66476007)(66556008)(478600001)(86362001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PKiE34L5LHoH5WZQYSvAaR9GVLrHydEixl/QCw7emtrVhWyTBkvIKNoxea5vODqHo/NlZzdkmh401gAFsIp/RV5D+A7WOSQMi19jKtmbnAw0YofgySImZQHpEhtzGpqw9C5NM/yBxJgUH8oKlnDUNLAPaWbMrlUPeJ9lhULBG0ggg9zu3r3dkE+NtLyRAQJ9v5aAhaMLh4DqB2FmOXQz2KGVZHuRU6BDFd6a3SLT6Lihvcnumzt3D3XbA7tyt6MsCkX2mxXadKtM3+p2AxHZp0AEfvgTfEB3Lo2JPQzuhEdsaUVGBFjjpyAwquYEzOv82EQx7HJPxUM8emuBDmwz3xb+kyFt3w9APR05z3xhDnJQ0efJnVLgzJsFYEm6Zp2DkZfNB+nDhd35K4r36E48cJETx/PbNkletRDzPYbPaAWM9MANgml7G7H5SmNg02IYOq87XY+9E7S4Wugm+sV4dmGImrWS2HUNk5taoKb48vM2/VAoeZpHZW1asZzS6S7RfaNCM+jsCzqHFf3QDZORWzTvG4FSCuq15P5UFDRuaJypK67rHtUim9Fvvt7VjQ/a+zJJVuvumPxEPjNwo4Bq5lW2SzeV6nSqukHqCoy8yPGmEvBp/it+VZUAXONuDLtIACcAsY8Yt6jIt8iiFOD6HA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E54F6436DCA76488702297D93515F7A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c30f92ac-963f-4cdb-a647-08d872b7cf77
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 16:15:05.6602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPIdaDWe2+rwBGh3cYHLVosNafn3z8InfRuKLxoOaNOuWGX+j417TDgQ8qWsXAR1wNFQ0Hl3CYOsA7TQcBF8lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB2048
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-17_14:2020-10-16,2020-10-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBTYXQsIDIwMjAtMTAtMTcgYXQgMTg6MDggKzAyMDAsIFRob21hcyBHbGVpeG5lciB3cm90
ZToNCj4gT24gU2F0LCBPY3QgMTcgMjAyMCBhdCAwMTowOCwgQWxleCBCZWxpdHMgd3JvdGU6DQo+
ID4gT24gTW9uLCAyMDIwLTEwLTA1IGF0IDE0OjUyIC0wNDAwLCBOaXRlc2ggTmFyYXlhbiBMYWwg
d3JvdGU6DQo+ID4gPiBPbiAxMC80LzIwIDc6MTQgUE0sIEZyZWRlcmljIFdlaXNiZWNrZXIgd3Jv
dGU6DQo+ID4gSSB0aGluayB0aGF0IHRoZSBnb2FsIG9mICJmaW5kaW5nIHNvdXJjZSBvZiBkaXN0
dXJiYW5jZSIgaW50ZXJmYWNlDQo+ID4gaXMNCj4gPiBkaWZmZXJlbnQgZnJvbSB3aGF0IGNhbiBi
ZSBhY2NvbXBsaXNoZWQgYnkgdHJhY2luZyBpbiB0d28gd2F5czoNCj4gPiANCj4gPiAxLiAiU291
cmNlIG9mIGRpc3R1cmJhbmNlIiBzaG91bGQgcHJvdmlkZSBzb21lIHVzZWZ1bCBpbmZvcm1hdGlv
bg0KPiA+IGFib3V0DQo+ID4gY2F0ZWdvcnkgb2YgZXZlbnQgYW5kIGl0IGNhdXNlIGFzIG9wcG9z
ZWQgdG8gZGV0ZXJtaW5pbmcgYWxsDQo+ID4gcHJlY2lzZQ0KPiA+IGRldGFpbHMgYWJvdXQgdGhp
bmdzIGJlaW5nIGNhbGxlZCB0aGF0IHJlc3VsdGVkIG9yIGNvdWxkIHJlc3VsdCBpbg0KPiA+IGRp
c3R1cmJhbmNlLiBJdCBzaG91bGQgbm90IGRlcGVuZCBvbiB0aGUgdXNlcidzIGtub3dsZWRnZSBh
Ym91dA0KPiA+IGRldGFpbHMNCj4gDQo+IFRyYWNlcG9pbnRzIGFscmVhZHkgZ2l2ZSB5b3Ugc2Vs
ZWN0aXZlbHkgdXNlZnVsIGluZm9ybWF0aW9uLg0KDQpDYXJlZnVsbHkgcGxhY2VkIHRyYWNlcG9p
bnRzIGFsc28gY2FuIGdpdmUgdGhlIHVzZXIgaW5mb3JtYXRpb24gYWJvdXQNCmZhaWx1cmVzIG9m
IG9wZW4oKSwgd3JpdGUoKSwgZXhlY3ZlKCkgb3IgbW1hcCgpLiBIb3dldmVyIHN5c2NhbGxzIHN0
aWxsDQpwcm92aWRlIGFuIGVycm9yIGNvZGUgaW5zdGVhZCBvZiByZXR1cm5pbmcgZ2VuZXJpYyBm
YWlsdXJlIGFuZCBsZXR0aW5nDQp1c2VyIGRlYnVnIHRoZSBjYXVzZS4NCg0KLS0gDQpBbGV4DQo=
