Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4822C2EFD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403957AbgKXRlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:41:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60394 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390613AbgKXRlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:41:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOHe2PH031364;
        Tue, 24 Nov 2020 09:40:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=LMRgz+rY9/HavjE2CVzuVjC6iuDx+iXyAgHGdFl2WIg=;
 b=Des+JfJn12E/FAdEAndKBCY+eC0UZlfadIOuPf92yqf603FZn4Xm9L5NQHf/piuvGO0V
 jvwMkrGOM03SN2VZ7C25DnaPAinu5PUoLa7E0vp07noJG3uAPpp0g/s/2LoJFRdDHZ7d
 H9x195dv/pWLKRomRosC5zmXk0L2OFOhlYxu4rtZCMWqXmJ6vlLiEAbRF3wh81TwSrSW
 jh7EPLErGcxzHjwiR2CN/gDj+l9NMweIuXUzLHrqxxL/Rr9gTHnm4zuvbeiFJgju1G8A
 7vsgMeuhf8zXA9Jt3u1RErKs9URKHeVKbLUdGbGfFHZBAIU5s9DqJROs2I/NwOt/D3Ju Kw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14ub5cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 09:40:54 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Nov
 2020 09:40:53 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Nov
 2020 09:40:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 24 Nov 2020 09:40:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPczTl8cataKyxivn2o7c8P03LngiyGiI3o8D3YrGtRSU6AUSLkpmy2ky2RBdbCyWli1ebknZUiljSgRsLhjXi23EQ3MKUtlkE1CI68VS/9vqtGPKuXEXcsSrrPLi6zSwExFUS3NJucb7xxZTKC4RKbsCkZ1kloOk5NWsWt5kHRTN0WAr7uAtQuPyzc20ab4kVX1N7JvUOub6VYTg/JlkS+zWc2faf9djtr/mRbADu5cK2AJDub4cyJDDkXGi9EjRasgCCcPhNj0GOTukbfXnIdlkizIhWf/vgN9ZdlDFIsJtStiR5J/0QJaH3k2laoRd4gvvwxBS2PDm/21ZDgxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMRgz+rY9/HavjE2CVzuVjC6iuDx+iXyAgHGdFl2WIg=;
 b=GYcRSHEZ+HHMSCs+5ni1F3IGVqVTS9EuyT3TfGa8LCg2120ruFVnuVkd9VdlH/z6PVZzboo73EF0XbMaH7rCe2fHe5STHAwx+2xyddTMFq6CA7K5cPZp+G/NfzhnFB9GO0JtEuChymTNyncESYRhqdJTnXlDVDaXSJkEsUfiddnN6sjzDTip6m5bNFEN3TP7tatA74UPyb2Ii/MUJ16k52v8Q4FkFuQNd2cxJ6rDxqRDeMWfAka+pjvlfaaAoT3/EjgcxaaNE7QSjXqAeeo0Mak/PQ2YQViD4JVoEQC7N2YReyO4cLJ17EwNnaOnDHWiFHRkIj0Qw6gKXtH+FqquPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMRgz+rY9/HavjE2CVzuVjC6iuDx+iXyAgHGdFl2WIg=;
 b=UEhNkQZrrrJHr6PE7/aybjSqt6ou3ca/mdc22acyMxzDjOyIIKEmIzB0dps+FBUYl3w1faFvQaT4sfpBIt2/NwT3/b1RMt6ujGWxmAH5O1hWYB9jwTo2ZN38pb/9R8es1aSTLpmbSGYSbBmIBcNGW8dJoZ7iSN5M37K+ymsB4GI=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR18MB0927.namprd18.prod.outlook.com (2603:10b6:300:9a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 17:40:49 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Tue, 24 Nov 2020
 17:40:49 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "trix@redhat.com" <trix@redhat.com>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 0/9] "Task_isolation" mode
Thread-Topic: [EXT] Re: [PATCH v5 0/9] "Task_isolation" mode
Thread-Index: AQHWwcAN4HMJq5rZb0WNk0YfmsaUganXfHoAgAAR6IA=
Date:   Tue, 24 Nov 2020 17:40:49 +0000
Message-ID: <a31f81cfa62936ff5edc420be63a5ac0b318b594.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
         <b0e7afd3-4c11-c8f3-834b-699c20dbdd90@redhat.com>
In-Reply-To: <b0e7afd3-4c11-c8f3-834b-699c20dbdd90@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d48ef156-f7fd-4657-ec3b-08d890a01502
x-ms-traffictypediagnostic: MWHPR18MB0927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB0927833C5F81682579F317BCBCFB0@MWHPR18MB0927.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PAe9dPWZIWvLV61t0xLWkF1BuYOjgrxXryuqQKMwL3DBfODf+9PgX938x543TJBickmBVk8ulZ+s0N4BVhNSvdHpTflIPVkgasnNgxi3BHHNC3W6E7V70RLqiGmILmXVOPWUb0rTqD1NvcxZkEa9spUUPxAkSRMnjz2ZYF/mknjftw5YmvEoRnQAt9lEWLDnl9MwhOD7OpNWstETR7Kku1ChcglCWa8QxAfOiD0vOYPI5Xt76VYFrRUwzyPZGgeb+sC5FpOAXLcm9ddmh2oQRaCtI4pBW1judN9GxLVmYnP9sK4K5b/AlX9lS2xVEtqjCsLvivrP+HsWv++bbK3XdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(4001150100001)(2906002)(6512007)(71200400001)(83380400001)(54906003)(5660300002)(26005)(6486002)(186003)(64756008)(8936002)(53546011)(86362001)(66446008)(498600001)(8676002)(91956017)(4744005)(7416002)(6916009)(66476007)(66556008)(76116006)(36756003)(66946007)(4326008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pxZ1V49IcSIpsiLQ+ZI7coE6VnjJqEMR+5Dezf44lUR0TUaFKmZnZmoFwpM5NJO41IuvLnSKmMg0PxKs7vcsZ7grt++DfH1xAI1A0LoS060IElgLY7AsKZpe2pkrEAs3YwomXW+mSj/lHcWjU3IbWq+dVtp/M+Agbgw6EOEh3SNt2+tOHurtQRuhvuStZFC1Jh5TYU/tqhpup4vSXvsipJrcXJQCThLIMYMsll1EjzgkOxeZcLJ2v77esXwdlvpX14c7ocVYdskntGj1DNEEm23JMtWT5jm71Wc1ZSEIcrQTpK26R7czICc4mN6EHEtYbX9wlLebbqrF8jGdEUuoVhTR3mXUgbesqGQvkHvzI6K2FuJKov9roNOi98rfn3LHtJ8dI5YRbd59d8p+d09SX65Qg1JE1Soz2UjNDpRgiTPfGOM6j1mFisGa8IpUA6yttKx7/VPRw5STIXvMgj7UQR4KgeENJcKxLJbY6NgOmPx1vmyoRXFoSsqp213qDrUt6qo+rpzHQsXYtCddRLGXOGfayjb8VfPpXfETMzdxThTKzGJXN+lsLzu1MN+CoDPg7+1XlTU7+WwirWmWBL2dIxwNDvDk7KqHv7Cj8S4htQhh/X7J7mvJSRYp5JpmHBy3GbsijWJ9ATPY4dI9lqZmEWyOEkitvQ8xv/4ZPnrXTKzl4dVDYeeJ6uMxvlcair5mJqHic0+nWvqRvstVmmekWWOIb0HZm82NWGQbwM1+Isv4u0jLjz3mpwKBH0X6MEF+Y0pZoS0oBqt2d4w3I+Z/htmdDbj7lvhQlByz0LrErfqiWUGVkKznmQka38lyn0ZOc1hjO6ZwMJNod/htVWQpIL4lnafTeMlU2l5XrmFUP2TCCVV0zOpEKRyTih1TycRcOEoCewcIWOPrE0n2ZO75rw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <065E67963AFA9B4AA53162870E453322@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48ef156-f7fd-4657-ec3b-08d890a01502
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 17:40:49.2586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/mJu5rOmTUgzetmBo7zt45gSd4CIEfLLMe6uidczDhYn/jbatcPwsXY64wU1kARK4cwxVPNgyzfvtt8Cb1eSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB0927
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUdWUsIDIwMjAtMTEtMjQgYXQgMDg6MzYgLTA4MDAsIFRvbSBSaXggd3JvdGU6DQo+IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IC0tLQ0KPiANCj4gT24gMTEvMjMvMjAg
OTo0MiBBTSwgQWxleCBCZWxpdHMgd3JvdGU6DQo+ID4gVGhpcyBpcyBhbiB1cGRhdGUgb2YgdGFz
ayBpc29sYXRpb24gd29yayB0aGF0IHdhcyBvcmlnaW5hbGx5IGRvbmUNCj4gPiBieQ0KPiA+IENo
cmlzIE1ldGNhbGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4gYW5kIG1haW50YWluZWQgYnkgaGlt
IHVudGlsDQo+ID4gTm92ZW1iZXIgMjAxNy4gSXQgaXMgYWRhcHRlZCB0byB0aGUgY3VycmVudCBr
ZXJuZWwgYW5kIGNsZWFuZWQgdXANCj4gPiB0bw0KPiA+IGltcGxlbWVudCBpdHMgZnVuY3Rpb25h
bGl0eSBpbiBhIG1vcmUgY29tcGxldGUgYW5kIGNsZWFuZXIgbWFubmVyLg0KPiANCj4gSSBhbSBo
YXZpbmcgcHJvYmxlbXMgYXBwbHlpbmcgdGhlIHBhdGNoc2V0IHRvIHRvZGF5J3MgbGludXgtbmV4
dC4NCj4gDQo+IFdoaWNoIGtlcm5lbCBzaG91bGQgSSBiZSB1c2luZyA/DQoNClRoZSBwYXRjaGVz
IGFyZSBhZ2FpbnN0IExpbnVzJyB0cmVlLCBpbiBwYXJ0aWN1bGFyLCBjb21taXQNCmEzNDllNGM2
NTk2MDlmZDIwZTRiZWVhODllNWM0YTQwMzhlMzNhOTUNCg0KLS0gDQpBbGV4DQo=
