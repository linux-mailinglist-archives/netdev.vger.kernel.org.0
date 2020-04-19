Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E5B1AF720
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 07:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgDSFDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 01:03:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbgDSFC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 01:02:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03J524wr032106;
        Sat, 18 Apr 2020 22:02:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=7bIebyD3RlLr9bkYWBN4z7EEXoFu+e+Cz7goFxLkkJ0=;
 b=lW/UxiPneSDoV2k00S2DCWImqh0rHCv/PXPn6+maDmTOWy/lTvq9Bgaz47AyS99hue44
 EQn4xCRrX+qdsFy6SP8zyHdyf66eFhOptKAZOAtuDhSp2iVCdpDGTdtPi4Pb576plXTV
 cvfac+l/MGd4WQRKmLpN4NT8y/a5OOWiqM+wOZlizEZ4oyXN8/to950E29Ih+ANsQVNo
 5vJcs7sgVPDaM+zww6JfxImC1q8KmW/7nLI7W9xwSzDA+XYQJ0+wLmjoWqkqQsVTeA0h
 p2XsRvpCr3wDS0GLamOmLRGugXc9Tkv1mnmVNevmLxZG+wsw4zxkbfOXrI/6vd2uusJm Aw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30g12njaac-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 18 Apr 2020 22:02:04 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 18 Apr
 2020 22:02:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 18 Apr 2020 22:02:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7dTgAA6nHzFLbQER1QSN+GdCbwlWcrj6ytRzB93EG3gr18nTVjVUZOslYigVyGakdKZzCTka8qATwk2f7WuFCRG9bPjxaxZbIWjbBwiq1nRY5vdcTF04UtsYSuAAtQbxEQ6Yq2Bq8YtA5yiBdbc277XsiBcs7k0Q3J9xGqAFJZHtXIqwKsnrk9NZGgzbefEyWESdizwxcoU2c1v8Gi9dbuvmzWWUeToiI0nT1r2OkPVDPqEoYCchS1IErb1bfhCPl+JIztWvgOcUcHAXJbTHtGn91YFVp03qbfV0rsJkaVGYJ62bw1WmXVN1Dl6VWyhfvKKMFkhaBt7dR8eXcVW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bIebyD3RlLr9bkYWBN4z7EEXoFu+e+Cz7goFxLkkJ0=;
 b=G5X5sN0XP7dFY1xo2dec3kvpk8vF1HCYkW3yjn39zLvh+ZPOca52YEVKIv0GZtkn6HDYmF48yeb36F7Puv8QtQUkHwli40kGnMCOkE07eLwQXGPF4jLgF5Ubg5Xh7yeABi2jVOqBM3irK/rkb/vVdPAcxMu5qyxmZ4Gra9WDeMkF1WyG3lkLEEaa8CEWOC7aYNVr/gxQfLamnmXepTgndSZqbFBACF4Cv1Lhr8xwzwTzHnrtZT8To+yQyzTgsow5g3WludoxH75NhTc+1/ovrqz3raLAHFvUNEJh3ma8FfS9eIUbngU7OSjmr4lUeB043bTRFY4SjGxmJweFyMEIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bIebyD3RlLr9bkYWBN4z7EEXoFu+e+Cz7goFxLkkJ0=;
 b=c+cDRjTi2Cs/zerdW913HmwrF0Se08knpeobWoxY3JyHKN39hCKicm23D6RY0vzVfIJqYypqcGnPDKrX7/5dcFEHYQrTbXiX8oYw0CHiZNlQyXe69Mv5014koGXlg1kSRqSNnhqVVMdF3z4R39HgIKv6oHkemOC+Jn11d/DGR6o=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2933.namprd18.prod.outlook.com (2603:10b6:a03:10e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 05:02:01 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 05:02:01 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "mark.rutland@arm.com" <mark.rutland@arm.com>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v3 03/13] task_isolation: add instruction
 synchronization memory barrier
Thread-Topic: [EXT] Re: [PATCH v3 03/13] task_isolation: add instruction
 synchronization memory barrier
Thread-Index: AQHWDoICUCw40vC9nkuNpTFu2Vf0Xqh6Ki6AgAXIHgA=
Date:   Sun, 19 Apr 2020 05:02:01 +0000
Message-ID: <e4d2cda6f011e80a0d8e482b85bca1c57665fcfd.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
         <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
         <d995795c731d6ecceb36bdf1c1df3d72fefd023d.camel@marvell.com>
         <20200415124427.GB28304@C02TD0UTHF1T.local>
In-Reply-To: <20200415124427.GB28304@C02TD0UTHF1T.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ce704de-d73a-4b47-f4a1-08d7e41ecbed
x-ms-traffictypediagnostic: BYAPR18MB2933:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2933B3B5CDABA68E4C2D0C4FBCD70@BYAPR18MB2933.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0378F1E47A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39850400004)(376002)(316002)(66476007)(26005)(66446008)(64756008)(76116006)(66556008)(66946007)(186003)(478600001)(2616005)(6916009)(7416002)(54906003)(6506007)(5660300002)(8676002)(6486002)(8936002)(81156014)(71200400001)(6512007)(2906002)(4326008)(36756003)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Nw4j5ltzd6STETXx1HjKgWzieGPi2hQRppHetfWHbTafKJVLKTcLuQR9v4TDw1DaQ0h0Hdmwc9ICmWPNMvgxdgmn7TYQQrgQA4woPFPW+cPmXvqNKy7jP350XY1TMmuiEf+5RMLp1yGMfrqWVVmGN5mIzeEsb/fjA+2qgjr5Jnvg80yApxhHzcrMo5SwXvHi5JLvlJzofJj+2NYAUTSRlfj/VhD7tmZ3EoTqZ+XVTg2mzdSJFS4oRqURR8f2FI2UmNZ89FMb+7qsEvESHNRG14DuODVgS55saPZeh3LeD07odjRlAjL3eKohMFfqllTuDIezcy9nbM3t593XwGd2WdhLrTgAj2DG51Ueej4/F4U5wAXWZHtSlstw1LcKP3zcjEHIoNzvU9hPRWbYTLu/YjC0nfMOCFWJnQbe4EJ4+Jj7coHKW8wFYjOSMO2vWYj
x-ms-exchange-antispam-messagedata: 6FD19SjXR7aFcRTcVw9COPaKrv1U8wjr+hDAAMaZhYU7CwTQrb8D19fM2rC5/dfVvkh92ZelRP40BjPIQTInBasWQXKaqyyRmlN8Jz1sSbG7AbKZ71SPwJ77L/YS9MLD6mXN8YGC01phD4i3qTwCz/pQHA1O/SZ/xsOVRLgyrnCI05o5hkq0QM+HCfasyDY/46nSJb20utfSKNlxIW8bTT9In/Q8yufYVFbqna740QhEAhXwjOPhT9PxNO1TliB43C9w1XMHn8LL20/jU3H6bLvfFgfyqEfxjFdbLwCj2LMzU50LP1z2sd6en10QfGPc74LYuO2qVWNqez6rgGi1+nQJNWLI5hLyp3Q2e+HhZeC7KMl+hysneWRW3yd6KBOQpccyuiXaD78v61VCcTtfP9j3qu/XGTLzv9LgOkQwQePEbsxElGMeH+Eldr60eA920ZOefwOUZRkxEgx7l0Wj/yJ3Ikgpb3RNpOCE4LuhQmeVAIz6+JkIdMnKdOwnCF/OTgcx/qQowNPro8bSQd6U7ICG6+X3gWmsSdMcTKrRpAq+CddtHKq0CeVclUbEJWYS8bmy4VWiT/ZLBrUNkzK1n7IcOnExIErBU5gzrgaEipASNS/YPjPUKrHlLc6nWqzmfBXQLNa/HvK1KXZJ4CYTat9O217tNUctDAwh3JwDy7/y1jRG9PtOdoBCr2nYqUROtvss0czAuYUPIy0vct/9Xs6gR6Y9F7ic3347tRHiQyHUVaYU1FdKWXago5NQ0rHhiXERLvDlNonFCf3Y8ySv+EbpQmW9ExYD1yGPw/loUS4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE493171FAB7DC4EA12DCB54BAC853AE@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce704de-d73a-4b47-f4a1-08d7e41ecbed
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2020 05:02:01.6706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KTgZCkjHvF/akFxHrWMNQ9orQDRqIjG293+b0Pu/75yfvkWBDlQ3VOqvHQfFUk/xwLgUa4bDp6PFOa4qe8NKRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2933
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_10:2020-04-17,2020-04-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQsIDIwMjAtMDQtMTUgYXQgMTM6NDQgKzAxMDAsIE1hcmsgUnV0bGFuZCB3cm90ZToN
Cj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gLS0tDQo+IE9uIFRodSwgQXBy
IDA5LCAyMDIwIGF0IDAzOjE3OjQwUE0gKzAwMDAsIEFsZXggQmVsaXRzIHdyb3RlOg0KPiA+IFNv
bWUgYXJjaGl0ZWN0dXJlcyBpbXBsZW1lbnQgbWVtb3J5IHN5bmNocm9uaXphdGlvbiBpbnN0cnVj
dGlvbnMNCj4gPiBmb3INCj4gPiBpbnN0cnVjdGlvbiBjYWNoZS4gTWFrZSBhIHNlcGFyYXRlIGtp
bmQgb2YgYmFycmllciB0aGF0IGNhbGxzIHRoZW0uDQo+IA0KPiBNb2RpZnlpbmcgdGhlIGluc3Ry
dWN0aW9uIGNhY2hlcyByZXF1cmllcyBtb3JlIHRoYW4gYW4gSVNCLCBhbmQgdGhlDQo+ICdJTUIn
IG5hbWluZyBpbXBsaWVzIHlvdSdyZSB0cnlpbmcgdG8gb3JkZXIgYWdhaW5zdCBtZW1vcnkgYWNj
ZXNzZXMsDQo+IHdoaWNoIGlzbid0IHdoYXQgSVNCIChnZW5lcmFsbHkpIGRvZXMuDQo+IA0KPiBX
aGF0IGV4YWN0bHkgZG8geW91IHdhbnQgdG8gdXNlIHRoaXMgZm9yPw0KDQpJIGd1ZXNzLCB0aGVy
ZSBzaG91bGQgYmUgZGlmZmVyZW50IGV4cGxhbmF0aW9uIGFuZCBuYW1pbmcuDQoNClRoZSBpbnRl
bnRpb24gaXMgdG8gaGF2ZSBhIHNlcGFyYXRlIGJhcnJpZXIgdGhhdCBjYXVzZXMgY2FjaGUNCnN5
bmNocm9uaXphdGlvbiBldmVudCwgZm9yIHVzZSBpbiBhcmNoaXRlY3R1cmUtaW5kZXBlbmRlbnQg
Y29kZS4gSSBhbQ0Kbm90IHN1cmUsIHdoYXQgZXhhY3RseSBpdCBzaG91bGQgZG8gdG8gYmUgaW1w
bGVtZW50ZWQgaW4gYXJjaGl0ZWN0dXJlLQ0KaW5kZXBlbmRlbnQgbWFubmVyLCBzbyBpdCBwcm9i
YWJseSBvbmx5IG1ha2VzIHNlbnNlIGFsb25nIHdpdGggYQ0KcmVndWxhciBtZW1vcnkgYmFycmll
ci4NCg0KVGhlIHBhcnRpY3VsYXIgcGxhY2Ugd2hlcmUgSSBoYWQgdG8gdXNlIGlzIHRoZSBjb2Rl
IHRoYXQgaGFzIHRvIHJ1bg0KYWZ0ZXIgaXNvbGF0ZWQgdGFzayByZXR1cm5zIHRvIHRoZSBrZXJu
ZWwuIEluIHRoZSBtb2RlbCB0aGF0IEkgcHJvcG9zZQ0KZm9yIHRhc2sgaXNvbGF0aW9uLCByZW1v
dGUgY29udGV4dCBzeW5jaHJvbml6YXRpb24gaXMgc2tpcHBlZCB3aGlsZQ0KdGFzayBpcyBpbiBp
c29sYXRlZCBpbiB1c2Vyc3BhY2UgKGl0IGRvZXNuJ3QgcnVuIGtlcm5lbCwgYW5kIGtlcm5lbA0K
ZG9lcyBub3QgbW9kaWZ5IGl0cyB1c2Vyc3BhY2UgY29kZSwgc28gaXQncyBoYXJtbGVzcyB1bnRp
bCBlbnRlcmluZyB0aGUNCmtlcm5lbCkuIFNvIGl0IHdpbGwgc2tpcCB0aGUgcmVzdWx0cyBvZiBr
aWNrX2FsbF9jcHVzX3N5bmMoKSB0aGF0IHdhcw0KdGhhdCB3YXMgY2FsbGVkIGZyb20gZmx1c2hf
aWNhY2hlX3JhbmdlKCkgYW5kIG90aGVyIHNpbWlsYXIgcGxhY2VzLg0KVGhpcyBtZWFucyB0aGF0
IG9uY2UgaXQncyBvdXQgb2YgdXNlcnNwYWNlLCBpdCBzaG91bGQgb25seSBydW4NCnNvbWUgInNh
ZmUiIGtlcm5lbCBlbnRyeSBjb2RlLCBhbmQgdGhlbiBzeW5jaHJvbml6ZSBpbiBzb21lIG1hbm5l
ciB0aGF0DQphdm9pZHMgcmFjZSBjb25kaXRpb25zIHdpdGggcG9zc2libGUgSVBJcyBpbnRlbmRl
ZCBmb3IgY29udGV4dA0Kc3luY2hyb25pemF0aW9uIHRoYXQgbWF5IGhhcHBlbiBhdCB0aGUgc2Ft
ZSB0aW1lLiBNeSBuZXh0IHBhdGNoIGluIHRoZQ0Kc2VyaWVzIHVzZXMgaXQgaW4gdGhhdCBvbmUg
cGxhY2UuDQoNClN5bmNocm9uaXphdGlvbiB3aWxsIGhhdmUgdG8gYmUgaW1wbGVtZW50ZWQgd2l0
aG91dCBhIG1hbmRhdG9yeQ0KaW50ZXJydXB0IGJlY2F1c2UgaXQgbWF5IGJlIHRyaWdnZXJlZCBs
b2NhbGx5LCBvbiB0aGUgc2FtZSBDUFUuIE9uIEFSTSwNCklTQiBpcyBkZWZpbml0ZWx5IG5lY2Vz
c2FyeSB0aGVyZSwgaG93ZXZlciBJIGFtIG5vdCBzdXJlLCBob3cgdGhpcw0Kc2hvdWxkIGxvb2sg
bGlrZSBvbiB4ODYgYW5kIG90aGVyIGFyY2hpdGVjdHVyZXMuIE9uIEFSTSB0aGlzIHByb2JhYmx5
DQpzdGlsbCBzaG91bGQgYmUgY29tYmluZWQgd2l0aCBhIHJlYWwgbWVtb3J5IGJhcnJpZXIgYW5k
IGNhY2hlDQpzeW5jaHJvbml6YXRpb24sIGhvd2V2ZXIgSSBhbSBub3QgZW50aXJlbHkgc3VyZSBh
Ym91dCBkZXRhaWxzLiBXb3VsZA0KaXQgbWFrZSBtb3JlIHNlbnNlIHRvIHJ1biBETUIsIElDIGFu
ZCBJU0I/IA0KDQo+IA0KQXMtaXMsIEkgZG9uJ3QgdGhpbmsgdGhpcyBtYWtlcyBzZW5zZSBhcyBh
IGdlbmVyaWMgYmFycmllci4NCg0KVGhhbmtzLA0KTWFyay4NCg0KU2lnbmVkLW9mZi1ieTogQWxl
eCBCZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBhcmNoL2FybS9pbmNsdWRlL2Fz
bS9iYXJyaWVyLmggICB8IDIgKysNCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2JhcnJpZXIuaCB8
IDIgKysNCiBpbmNsdWRlL2FzbS1nZW5lcmljL2JhcnJpZXIuaCAgICB8IDQgKysrKw0KIDMgZmls
ZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNs
dWRlL2FzbS9iYXJyaWVyLmgNCmIvYXJjaC9hcm0vaW5jbHVkZS9hc20vYmFycmllci5oDQppbmRl
eCA4M2FlOTdjMDQ5ZDkuLjZkZWY2MmM5NTkzNyAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL2luY2x1
ZGUvYXNtL2JhcnJpZXIuaA0KKysrIGIvYXJjaC9hcm0vaW5jbHVkZS9hc20vYmFycmllci5oDQpA
QCAtNjQsMTIgKzY0LDE0IEBAIGV4dGVybiB2b2lkIGFybV9oZWF2eV9tYih2b2lkKTsNCiAjZGVm
aW5lIG1iKCkJCV9fYXJtX2hlYXZ5X21iKCkNCiAjZGVmaW5lIHJtYigpCQlkc2IoKQ0KICNkZWZp
bmUgd21iKCkJCV9fYXJtX2hlYXZ5X21iKHN0KQ0KKyNkZWZpbmUgaW1iKCkJCWlzYigpDQogI2Rl
ZmluZSBkbWFfcm1iKCkJZG1iKG9zaCkNCiAjZGVmaW5lIGRtYV93bWIoKQlkbWIob3Noc3QpDQog
I2Vsc2UNCiAjZGVmaW5lIG1iKCkJCWJhcnJpZXIoKQ0KICNkZWZpbmUgcm1iKCkJCWJhcnJpZXIo
KQ0KICNkZWZpbmUgd21iKCkJCWJhcnJpZXIoKQ0KKyNkZWZpbmUgaW1iKCkJCWJhcnJpZXIoKQ0K
ICNkZWZpbmUgZG1hX3JtYigpCWJhcnJpZXIoKQ0KICNkZWZpbmUgZG1hX3dtYigpCWJhcnJpZXIo
KQ0KICNlbmRpZg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vYmFycmllci5o
DQpiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vYmFycmllci5oDQppbmRleCA3ZDljYzVlYzQ5NzEu
LjEyYTdkYmQ2OGJlZCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vYmFycmll
ci5oDQorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2JhcnJpZXIuaA0KQEAgLTQ1LDYgKzQ1
LDggQEANCiAjZGVmaW5lIHJtYigpCQlkc2IobGQpDQogI2RlZmluZSB3bWIoKQkJZHNiKHN0KQ0K
IA0KKyNkZWZpbmUgaW1iKCkJCWlzYigpDQorDQogI2RlZmluZSBkbWFfcm1iKCkJZG1iKG9zaGxk
KQ0KICNkZWZpbmUgZG1hX3dtYigpCWRtYihvc2hzdCkNCiANCmRpZmYgLS1naXQgYS9pbmNsdWRl
L2FzbS1nZW5lcmljL2JhcnJpZXIuaCBiL2luY2x1ZGUvYXNtLQ0KZ2VuZXJpYy9iYXJyaWVyLmgN
CmluZGV4IDg1YjI4ZWI4MGIxMS4uZDVhODIyZmIzZTkyIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9h
c20tZ2VuZXJpYy9iYXJyaWVyLmgNCisrKyBiL2luY2x1ZGUvYXNtLWdlbmVyaWMvYmFycmllci5o
DQpAQCAtNDYsNiArNDYsMTAgQEANCiAjZGVmaW5lIGRtYV93bWIoKQl3bWIoKQ0KICNlbmRpZg0K
IA0KKyNpZm5kZWYgaW1iDQorI2RlZmluZSBpbWIJCWJhcnJpZXIoKQ0KKyNlbmRpZg0KKw0KICNp
Zm5kZWYgcmVhZF9iYXJyaWVyX2RlcGVuZHMNCiAjZGVmaW5lIHJlYWRfYmFycmllcl9kZXBlbmRz
KCkJCWRvIHsgfSB3aGlsZSAoMCkNCiAjZW5kaWYNCi0tIA0KMi4yMC4xDQoNCg0KDQoNCg==
