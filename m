Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A9D2FB4AF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbhASI6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:58:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729479AbhASI6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 03:58:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10J8uHhk008423;
        Tue, 19 Jan 2021 00:57:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=anzmUvTYVn5nN+8q3XDFrITEOXytsNwGZ+L8sjrsMuw=;
 b=fqVv+tNxqKnS1Vp1iT49DgQF7DzXiCrbFobZst6w4dOY6g8AglzZzgyQPuEUD0kohl06
 jzS5bXKiuJVXi+xT6/cz8L0njLReJWDYFimu+xXCYRS1qR9wYxdztt09moNzm6OOd/Io
 VaYLnONwxwwN7CDfh18kTY5UtmlcUqTTays+QH/KCxj5Y1jS85cqW0k8S1eyMGlKPECW
 tpW+3hiIqGhvuw2s6ahbBbVnfBypN8grZWqAqRuDqU+tLpK77M/bKAmsS9CAwH4Np5FI
 fCKq4fnOfaA69/uL1uVDGB6W+EtKw+qviOFiJWbQ/p8iMICAbmirJEYiDcGrowIWHaPV cw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3640hswum4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 00:57:13 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jan
 2021 00:57:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 19 Jan 2021 00:57:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVzIAeZQvewkLq9rToKMU0YIZFeT0BHy7qqrLQzLTFd9NzLAPT7k24XXn4/wuqHbHmv1TSQzaVhHehCgpGQ6G63bigD+jK3OuwBgLzOHxswwy18okf1m6hcgGGjv7yFQsjQLNvs+bjS+0XCZUUQbLLxSduMaFgXRaKvRLpiA/lcsk9mpMeRctOVSeXq1krzWLqrV4PDAHXUiqGoxmQoJLym+A4kwmGnc2GDoWQLNyVo9DPKmXunynQX+Xj2wzw6oB5hfIgYxW5CVBmJET1Ethpdcz6Oy7hd+bVIfc+AFdqWHR10JAfVcx6Q7yQQj8nWQ70yLeKK+Y4amS+Odrv/ADQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anzmUvTYVn5nN+8q3XDFrITEOXytsNwGZ+L8sjrsMuw=;
 b=KweiwGz1EabMiqw9/64RMmqbj4yJpsVFbAec6drh4/ytJS/vUoMjX24G4Y9GhPY2jUKzhO0h1XvKgcevTFTU0e68PHh2ajtHfN/UPbLmeBfGo0fwwtaOYX91Fit32RKNmql29OczmFLRhjoc17xUrNpo6QqgT6u4wOvWGS06shrLeB0Pn42ZdrMO2nNUHp2/CbNUmtAaYV9H49wwnif4nun810QDJhNTjSck+eqGA2AdaSb8TbMTKmCatLRdKv7qdRfNIRpDhADYpYTN5tAgw5wFGKm1qiLq9zfJkjPDOVoHQOc0VVFMQyyYesvzS67uhlBXkcSQ1nkW7LvaCki3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anzmUvTYVn5nN+8q3XDFrITEOXytsNwGZ+L8sjrsMuw=;
 b=S7C8e/KcrggKp3Afc5G/OTS4MlUt6a1G6tCwsz1nwxPoBjLLqVOOSVICDVUMP3CABXYWSay0+e/ceNw4rsR44asGFLtPXXSBkTlStKVIHGqjPu0LsSUiK61LMJkjGb/3DloH98/Lwd3hPHoCURDQECMFJdms8zsQjVcMLZzdJSc=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BY5PR18MB3315.namprd18.prod.outlook.com (2603:10b6:a03:196::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 08:57:10 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::ac42:1aab:6c14:1802]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::ac42:1aab:6c14:1802%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 08:57:10 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Mahipal Challa <mchalla@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next,2/3] octeontx2-af: Add support for CPT1
 in debugfs
Thread-Topic: [EXT] Re: [PATCH net-next,2/3] octeontx2-af: Add support for
 CPT1 in debugfs
Thread-Index: AQHW6b/Fk1vt1yIa2USCtGrc3/xxdKonzKSAgAbhSvA=
Date:   Tue, 19 Jan 2021 08:57:10 +0000
Message-ID: <BYAPR18MB2791C29DA828893C9B9A1F5FA0A31@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20210113152007.30293-1-schalla@marvell.com>
         <20210113152007.30293-3-schalla@marvell.com>
 <3edb033746906618bc451aa8a634bc3e51c162b8.camel@kernel.org>
In-Reply-To: <3edb033746906618bc451aa8a634bc3e51c162b8.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [157.44.90.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c14674d-5343-4da0-23d6-08d8bc583504
x-ms-traffictypediagnostic: BY5PR18MB3315:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3315C959AA14D902DB40C98BA0A31@BY5PR18MB3315.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rdyVVw2iU5IqBB2gB8c+cQEriqJcOZVKw/CKPPHCfnrmuKGolc59JDX5q+h8VxxcmN02QTWxvE6YyUdwVtn1Voyias4ntj52ODkL0W8lRWCQ9QGQSSTlV/OwBeZQ2ulOKyXWiM7ebDVYElANJ3sUi4PAiUhEHE74dqxaZ4Ti1isB9Nsb9MTFdoNMfOb5eF8AISTlTJHdDnEADRMvju127aXGGQ/+9mxK0V5e8PfwnCD3j3BHsNXqa/ZpU0lOMqyBV9b9H5ouWnQ2Z5tz62SUMY/3S17H+cjkyTRDpZbFg+nN0cUyHHk1/iXppcfXPcJR3SOkoCOnT1OG9KtdsUMgSuc1iaf4SYz97gUB+F0lhfiDUwNAHTOG0pVxTBfRXP0+JqMCDuSldev6Y07O3O9ZNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(55016002)(7696005)(478600001)(26005)(5660300002)(9686003)(52536014)(83380400001)(316002)(186003)(6506007)(110136005)(4326008)(86362001)(54906003)(71200400001)(2906002)(8676002)(76116006)(8936002)(66446008)(107886003)(66556008)(66946007)(64756008)(33656002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aTBoRlRvZGo3YU13VGZGUmhhM3I2eklDVmo4ZE52VWhTUkF2WWtrampIajdk?=
 =?utf-8?B?N1g0WXM5NUZac1Bka2o1SzdIaFZib1I4TEhGL1BpRno3U1JQK04zcGZraEtS?=
 =?utf-8?B?cE5Cc2JISDZJcnNlSVpUbE8zenBtcENqM1JqQkIyZmFYMFpDVGZKZG9ndmJZ?=
 =?utf-8?B?WWFQcmZ1cGY2QThrUnBqWm1nTUlWNzdkZWIydzF1VWdHMGVNVHNPbnRNcERR?=
 =?utf-8?B?c05ndzFqRnpINEQ4c1h4L2o4WlBQWU92QUZNem50TmxKTnFhWHVSWkpxOUFF?=
 =?utf-8?B?WDEwRGlLRDd5YUZlNEo4VjZhYzV2UUJaTWkzWSsyZ0xiVFBDSGZCalJJMkVl?=
 =?utf-8?B?cmk0RFUvNGppK1BRNmRUY2MwMU80NHovSDl0dExkZDVEVTdwcUZKd25PWkJI?=
 =?utf-8?B?UitKRmlUSlQ0UVVkTlMyOVl4bE1GUElHSFJkNFFDUXdnUnpNSUxobFRZRW90?=
 =?utf-8?B?VGFuN0RXSEJ1WFp1NkR3RmtpYUdjb1A3WHY3WXBhTkt5ajAreUJ4Zk1zOXEy?=
 =?utf-8?B?WUQwK3pTYWpHait6ZkFZWGhCTGJoWHVoZVdqRUdIODViaFh4MXI0L2pXcU5l?=
 =?utf-8?B?dURMR3BHMVZEeXRTQmdVdFdVVTIrSDJ1UnNCTGVDQXRET2I1MUgvRGZBL0xo?=
 =?utf-8?B?WlQvd1dramhPbFF2QmxFL0crdmlrek5CVVB6S3VWUFNTUll6a2J4cSs3QnJw?=
 =?utf-8?B?R0VSVVA2ZmhkZGNIcTlackpTTXhCRnZkOXNveGR1c1pZUUJpdEczMG1mN0tT?=
 =?utf-8?B?YXZMMDB4UHYyZ2lrV1BWemFjbGloVll3VklUaVlBa01PZ09wckVrQ0Y0TlUv?=
 =?utf-8?B?dSs2UzMxQ1NNRWtVZEQ3ZTFNK085ZTlnS0tYQk9JNGZUNm5nSGJZS0Nyd1RI?=
 =?utf-8?B?SGxPTVZFb0hOWVB3TkRoeHBHY1BFQ243Sko5RUh2M3liTm9LeFYwbGorTWhL?=
 =?utf-8?B?NTlOUXdLWmplQkRwYjlPUjlCNktnNGJiSjJQdkhXR2gybVM1YlJlN1JqVkZC?=
 =?utf-8?B?dVVJQjRLUVhJN2pQd2REalgwOE8zdk1FMlErWmM2elFGNXAvS09JbHRDVzN5?=
 =?utf-8?B?QmZTenFJTEhZWDhGcjRCWHMxM1kvL2lCT3cweiswWEVabjdCS2NIQmtpeno3?=
 =?utf-8?B?VGpIM2ZKamtxaEd2MnByR1h5QnR1bkprOGdrZEFSV0xoclhGOUg4YlBEUURi?=
 =?utf-8?B?dFJWNSt5RVplRm8vbnFhMFdQTTBnTTUxRi91NFhzOFJSa0Q4VUJWVUF2cU9l?=
 =?utf-8?B?Nk5RdHFJeFVzcHZsTkJReGsvRU9XWE1sVlIzeVBia2orZDBoc014WElURDhj?=
 =?utf-8?B?YlgreWJjOHFFTmRoczFOb1Nudk5jSUN2RFB6bTFZRVIzOWZZdm5zeGhiRjR6?=
 =?utf-8?B?RTREMCtRSGZIT3pOSVgrNXBpeTU3OGdUZFBBZGljT1QvYmI2bGg1TUhsNzNY?=
 =?utf-8?Q?00C8sjmN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c14674d-5343-4da0-23d6-08d8bc583504
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 08:57:10.3474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3oPgy16xvi1tSC2F0wJ1sK7/6IN8a5sf+X7XHYBBhDfYiE4dACz/QgintJK7S1cHaxzvwmrUHncpxN8of2CFtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3315
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIDIwMjEtMDEtMTMgYXQgMjA6NTAgKzA1MzAsIFNydWphbmEgQ2hhbGxhIHdyb3Rl
Og0KPiA+IEFkZHMgc3VwcG9ydCB0byBkaXNwbGF5IGJsb2NrIENQVDEgc3RhdHMgYXQNCj4gPiAi
L3N5cy9rZXJuZWwvZGVidWcvb2N0ZW9udHgyL2NwdDEiLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogTWFoaXBhbCBDaGFsbGEgPG1jaGFsbGFAbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogU3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+ID4gLS0tDQo+ID4gIC4u
Li9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfZGVidWdmcy5jICAgICAgICB8IDQ1ICsrKysrKysr
KysrLS0tLQ0KPiA+IC0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyks
IDE5IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL3J2dV9kZWJ1Z2ZzLmMNCj4gPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL3J2dV9kZWJ1Z2ZzLmMNCj4gPiBpbmRleCBk
Mjc1NDNjMWExNjYuLjE1ODg3NjM2NmRkMyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfZGVidWdmcy5jDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1X2RlYnVnZnMuYw0KPiA+
IEBAIC0xOTA0LDYgKzE5MDQsMTggQEAgc3RhdGljIHZvaWQgcnZ1X2RiZ19ucGNfaW5pdChzdHJ1
Y3QgcnZ1ICpydnUpDQo+ID4gfQ0KPiA+DQo+ID4gIC8qIENQVCBkZWJ1Z2ZzIEFQSXMgKi8NCj4g
PiArc3RhdGljIGludCBjcHRfZ2V0X2Jsa2FkZHIoc3RydWN0IHNlcV9maWxlICpmaWxwKSB7DQo+
ID4gKwlzdHJ1Y3QgZGVudHJ5ICpjdXJyZW50X2RpcjsNCj4gPiArCWludCBibGthZGRyOw0KPiA+
ICsNCj4gPiArCWN1cnJlbnRfZGlyID0gZmlscC0+ZmlsZS0+Zl9wYXRoLmRlbnRyeS0+ZF9wYXJl
bnQ7DQo+ID4gKwlibGthZGRyID0gKCFzdHJjbXAoY3VycmVudF9kaXItPmRfbmFtZS5uYW1lLCAi
Y3B0MSIpID8NCj4gPiArCQkJICAgQkxLQUREUl9DUFQxIDogQkxLQUREUl9DUFQwKTsNCj4gPiAr
DQo+IA0KPiBUaGlzIGlzIHZlcnkgZnJhZ2lsZSBwaWVjZSBvZiBjb2RlISBpdCBhc3N1bWVzIHN0
YXRpYyBkZWJ1Z2ZzIGRpcmVjdG9yeSBzdHJ1Y3R1cmUNCj4gYW5kIG5hbWluZywgd2h5IGRvbid0
IHlvdSBzdG9yZSB0aGUgQ1BUIGNvbnRleHQgaW4gdGhlIHNxZV9maWxlIHByaXZhdGUgPyBhcw0K
PiB5b3UgYWxyZWFkeSBoYXZlIGluIHJ2dV9kYmdfbml4X2luaXQgIGZvciBuaXhfaHcgdHlwZQ0K
PiANCk9rYXksIEkgd2lsbCBkbyB0aGUgY2hhbmdlcyBhY2NvcmRpbmdseSBhbmQgc3VibWl0IG5l
eHQgdmVyc2lvbi4NClRoYW5rcy4NCg==
