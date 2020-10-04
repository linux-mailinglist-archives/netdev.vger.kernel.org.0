Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06616282B50
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJDOpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 10:45:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59016 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725825AbgJDOpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 10:45:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 094EaQx8005357;
        Sun, 4 Oct 2020 07:44:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=BTvvMP4towAAuGQAjxTkThyAC9pveBzp1UXXXgEwLfk=;
 b=Cdu/99j/wketvDCnfTEVmXfN+/k/SefreTU9375zmwUdd2FXMFqlQbQymVdTZxsMUCgT
 xPVH3xaVOEkro4XMPbdNvs717usgihNzIAZpwpUHmYmnrMRtqLDheBRCwVK9vbSrwfoJ
 sQ2GmHNB3OeoFice+EOaSamfc1vkDp7RgzqDlxd0zivk/9Gc4jPwdSAQ2NQpDLIkR1FM
 OPhFKu9dgdY/RB9neJXvf4KxxN8R8p/D3yv+JLynmHZw4djlLUxFPAj45EfrM6BhX2RI
 X421GjVOSOIwedv4iNHnRmFvNuIMvEABNuKdF2r2aPabXTKV1Z/+WDujyy0B6UBSjPWa ig== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33xpnpjqv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Oct 2020 07:44:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Oct
 2020 07:44:42 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Oct
 2020 07:44:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 4 Oct 2020 07:44:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/w+8VvX0SmEz0Tc014WXEH4mF8FOvvkZCyCCAZAIrdhazXIa9iBF2ovgxGE9etbdxSONjLr9Y5+NBIFzSHP/B7fjt2w0ZFVxTCdk2tJa97/DAWTiRM82ROb4+KYlZQNiJQZTp1vE/rP8AvN5q1/DF71WWJvKVzKaLWGhX+QXcxiLAM7lXRVRf+5DpsM/6lXBbv742HxNBl7fu7j1wcovPw2NqRlVPkJUgvS910oDCs+khFz4WOCS+fDA7ZPlBhb4f6StHsOwo3YD2IUWkEBjchgaORpLViwguDzYxOmfbG0fLwmr8b61MUobD2eDRh6BKyz1Xe0AOBKJq1BZg2NZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTvvMP4towAAuGQAjxTkThyAC9pveBzp1UXXXgEwLfk=;
 b=WkRtm/vadj2Pdh1r2EEZKMMJ3XDBbieTUKfOYSFXnC3wYxn9rrRAk7bnSdDek+qakKvJl90Ba9MBoDiZMWzTXq6qwXChUVHfEP/7fErHZ/ZmgGnGYAHkVPWr0s6J9z2j/DXNMY2P3k4DjuIxuHaQtj28U1uiFfEW5zoYrpDpkQL9m/yVVd/KHz2ASCWz5VeD9DME/9ty0AZC3EqC8BFcqwUXrqDkbSoSMA2BnTskypOBUVwAGvosYrIW0Q3WUZ0M1bMBrXFELMJrqU9hBAMHylbao2qvs456ktFDhA2AtJsn/1NtikkBBE72BN9VxogDaJOAFoHny+48JsSMoiBJTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTvvMP4towAAuGQAjxTkThyAC9pveBzp1UXXXgEwLfk=;
 b=MikUmlJfHmNy9u9801jOg1VRf9saSNC4XfzJjPopUYlbPUVxe2hktNhf40wTXQ0xiCUuEesN6zZ9A0RPR8nViWeXZgPDjfcF0OT0LE1X6QzgA2Eq7qNLp5qrTNibl+j4SPF4EGXrNvpDcmvun3PqMHBrE5fZ/O9SM2D58WFaQq8=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2089.namprd18.prod.outlook.com (2603:10b6:907:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Sun, 4 Oct
 2020 14:44:39 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::54a1:710f:41a5:c76f%5]) with mapi id 15.20.3433.043; Sun, 4 Oct 2020
 14:44:39 +0000
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
Thread-Index: AQHWYDdZDqoeqvfF50CzG3l43t/UoamDNPAAgATEYwA=
Date:   Sun, 4 Oct 2020 14:44:39 +0000
Message-ID: <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
         <20201001135640.GA1748@lothringen>
In-Reply-To: <20201001135640.GA1748@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71ebe096-584a-4721-7200-08d8687405ce
x-ms-traffictypediagnostic: MW2PR18MB2089:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB20898647D2597D48C94130EFBC0F0@MW2PR18MB2089.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kTtvDKKcdYaiaN8OhZSckNVTngMLjHY+nZE7KY6Y8Gn6Q/V23QjN0ZAUIXG1YO+5mKacJDEzDlnNfRgGFVNBAi0M16HTHoVLn1T4OZHn7ecxwk5cZ9Dr0rjsl/aPyMIUea+dMoCCTpRPF8G5MlIYPvl6GkupitCeMCjoWR63EZy0RT2e7RoxUMwclForVRvwSXEn77i1OvcoesnTCWiSFZ2qtjJSchqMOJIUU85lu6vBz/TvD0w+b8YukMgeGWT9EKDw644cuoCfMfXwPXj3rJNi53A82Iiww3qv90qiN4nUCo3c1VboSclu0/wcCF4kLgYFedP+vNAi14jXN9m6mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39850400004)(86362001)(71200400001)(83380400001)(2906002)(6506007)(8676002)(7416002)(36756003)(66476007)(54906003)(26005)(66446008)(64756008)(66556008)(8936002)(2616005)(6916009)(186003)(91956017)(76116006)(66946007)(6486002)(5660300002)(4326008)(478600001)(316002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8lDm45uqhgzqoCh43Hp1TVza0tHL09EbWv2SBlXrG+e+fSuf+fk4Y3AFUN8j3Mne2+3+pRq41iDyNH2elDQ/Qbb16tSQWad6U22+WGZ4vOgeSunbOQbo8WTfgYMjCtJVPdxWTn9Z60I3nnnWPystRxEnd71t6EGak+Q/U55qjnabh7Ifvn7EugDiutWpqxAbtcXFXixMFy9N6CNRdiSx25TpHXIATrKxnyHs+tX0lWLJFBQmGgwCCR0k5ZE4q3ex85pa3NxAZk6ZCfmdkkPBv7E2fxyDTrc8CEXaB6GhkHYsPCt0FWYFU53JDROITqJi6L25gCwJlwA95FQiZrLnAKaKz5lwVAdeMgs8QGI7cFtFjcZomcRDiSgKhJe5aXrU/HVd2J1p5owpBvZ0iVCYIbRiJXeIW5Vy3mkf8+bgyYewDHMxkLBy51Zaa8cch2gktfpwFe2xmxVTfY9ovVSC3zHunbBS++3VsEtOJE2VaBNee68LYhuj8lB0cnvCxIPnuoFXVkgh3ZxZl75SSoInPSuiCzsNzplajz2Mw3Ygg4F1swwQYPYyQ706dBVz841dKVdPLi3Mrt/DQ43mCERq8h6jD3fIAWkMX2TtxRzPj6tAW3Ot/dQkJsPv4J6hM2AzpoaURSxfBqm3n2mKBKUMzA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B90B1D5EC56FC848918C8252F37357E4@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ebe096-584a-4721-7200-08d8687405ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 14:44:39.1938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dH3PGOl6j/ZcVgOrIZNX+NWpW3ETXha6S8FQDYsNUfxtH5UXLD938s8CBjhylcufAzdqg8tiRgjIl+Nqm8bzsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2089
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-04_13:2020-10-02,2020-10-04 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTAxIGF0IDE1OjU2ICswMjAwLCBGcmVkZXJpYyBXZWlzYmVja2VyIHdy
b3RlOg0KPiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAtLS0NCj4gT24gV2Vk
LCBKdWwgMjIsIDIwMjAgYXQgMDI6NDk6NDlQTSArMDAwMCwgQWxleCBCZWxpdHMgd3JvdGU6DQo+
ID4gKy8qDQo+ID4gKyAqIERlc2NyaXB0aW9uIG9mIHRoZSBsYXN0IHR3byB0YXNrcyB0aGF0IHJh
biBpc29sYXRlZCBvbiBhIGdpdmVuDQo+ID4gQ1BVLg0KPiA+ICsgKiBUaGlzIGlzIGludGVuZGVk
IG9ubHkgZm9yIG1lc3NhZ2VzIGFib3V0IGlzb2xhdGlvbiBicmVha2luZy4gV2UNCj4gPiArICog
ZG9uJ3Qgd2FudCBhbnkgcmVmZXJlbmNlcyB0byBhY3R1YWwgdGFzayB3aGlsZSBhY2Nlc3Npbmcg
dGhpcw0KPiA+IGZyb20NCj4gPiArICogQ1BVIHRoYXQgY2F1c2VkIGlzb2xhdGlvbiBicmVha2lu
ZyAtLSB3ZSBrbm93IG5vdGhpbmcgYWJvdXQNCj4gPiB0aW1pbmcNCj4gPiArICogYW5kIGRvbid0
IHdhbnQgdG8gdXNlIGxvY2tpbmcgb3IgUkNVLg0KPiA+ICsgKi8NCj4gPiArc3RydWN0IGlzb2xf
dGFza19kZXNjIHsNCj4gPiArCWF0b21pY190IGN1cnJfaW5kZXg7DQo+ID4gKwlhdG9taWNfdCBj
dXJyX2luZGV4X3dyOw0KPiA+ICsJYm9vbAl3YXJuZWRbMl07DQo+ID4gKwlwaWRfdAlwaWRbMl07
DQo+ID4gKwlwaWRfdAl0Z2lkWzJdOw0KPiA+ICsJY2hhcgljb21tWzJdW1RBU0tfQ09NTV9MRU5d
Ow0KPiA+ICt9Ow0KPiA+ICtzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IGlzb2xfdGFza19k
ZXNjLCBpc29sX3Rhc2tfZGVzY3MpOw0KPiANCj4gU28gdGhhdCdzIHF1aXRlIGEgaHVnZSBwYXRj
aCB0aGF0IHdvdWxkIGhhdmUgbmVlZGVkIHRvIGJlIHNwbGl0IHVwLg0KPiBFc3BlY2lhbGx5IHRo
aXMgdHJhY2luZyBlbmdpbmUuDQo+IA0KPiBTcGVha2luZyBvZiB3aGljaCwgSSBhZ3JlZSB3aXRo
IFRob21hcyB0aGF0IGl0J3MgdW5uZWNlc3NhcnkuIEl0J3MNCj4gdG9vIG11Y2gNCj4gY29kZSBh
bmQgY29tcGxleGl0eS4gV2UgY2FuIHVzZSB0aGUgZXhpc3RpbmcgdHJhY2UgZXZlbnRzIGFuZCBw
ZXJmb3JtDQo+IHRoZQ0KPiBhbmFseXNpcyBmcm9tIHVzZXJzcGFjZSB0byBmaW5kIHRoZSBzb3Vy
Y2Ugb2YgdGhlIGRpc3R1cmJhbmNlLg0KDQpUaGUgaWRlYSBiZWhpbmQgdGhpcyBpcyB0aGF0IGlz
b2xhdGlvbiBicmVha2luZyBldmVudHMgYXJlIHN1cHBvc2VkIHRvDQpiZSBrbm93biB0byB0aGUg
YXBwbGljYXRpb25zIHdoaWxlIGFwcGxpY2F0aW9ucyBydW4gbm9ybWFsbHksIGFuZCB0aGV5DQpz
aG91bGQgbm90IHJlcXVpcmUgYW55IGFuYWx5c2lzIG9yIGh1bWFuIGludGVydmVudGlvbiB0byBi
ZSBoYW5kbGVkLg0KDQpBIHByb2Nlc3MgbWF5IGV4aXQgaXNvbGF0aW9uIGJlY2F1c2Ugc29tZSBs
ZWZ0b3ZlciBkZWxheWVkIHdvcmssIGZvcg0KZXhhbXBsZSwgYSB0aW1lciBvciBhIHdvcmtxdWV1
ZSwgaXMgc3RpbGwgcHJlc2VudCBvbiBhIENQVSwgb3IgYmVjYXVzZQ0KYSBwYWdlIGZhdWx0IG9y
IHNvbWUgb3RoZXIgZXhjZXB0aW9uLCBub3JtYWxseSBoYW5kbGVkIHNpbGVudGx5LCBpcw0KY2F1
c2VkIGJ5IHRoZSB0YXNrLiBJdCBpcyBhbHNvIHBvc3NpYmxlIHRvIGRpcmVjdCBhbiBpbnRlcnJ1
cHQgdG8gYSBDUFUNCnRoYXQgaXMgcnVubmluZyBhbiBpc29sYXRlZCB0YXNrIC0tIGN1cnJlbnRs
eSBpdCdzIHBlcmZlY3RseSB2YWxpZCB0bw0Kc2V0IGludGVycnVwdCBzbXAgYWZmaW5pdHkgdG8g
YSBDUFUgcnVubmluZyBpc29sYXRlZCB0YXNrLCBhbmQgdGhlbg0KaW50ZXJydXB0IHdpbGwgY2F1
c2UgYnJlYWtpbmcgaXNvbGF0aW9uLiBXaGlsZSBpdCdzIHByb2JhYmx5IG5vdCB0aGUNCmJlc3Qg
d2F5IG9mIGhhbmRsaW5nIGludGVycnVwdHMsIEkgd291bGQgcmF0aGVyIG5vdCBwcm9oaWJpdCB0
aGlzDQpleHBsaWNpdGx5Lg0KDQpUaGVyZSBpcyBhbHNvIGEgbWF0dGVyIG9mIGF2b2lkaW5nIHJh
Y2UgY29uZGl0aW9ucyBvbiBlbnRlcmluZw0KaXNvbGF0aW9uLiBPbmNlIENQVSBlbnRlcmVkIGlz
b2xhdGlvbiwgb3RoZXIgQ1BVcyBzaG91bGQgYXZvaWQNCmRpc3R1cmJpbmcgaXQgd2hlbiB0aGV5
IGtub3cgdGhhdCBDUFUgaXMgcnVubmluZyBhIHRhc2sgaW4gaXNvbGF0ZWQNCm1vZGUuIEhvd2V2
ZXIgZm9yIGEgc2hvcnQgdGltZSBhZnRlciBlbnRlcmluZyBpc29sYXRpb24gb3RoZXIgQ1BVcyBt
YXkNCmJlIHVuYXdhcmUgb2YgdGhpcywgYW5kIHdpbGwgc3RpbGwgc2VuZCBJUElzIHRvIGl0LiBQ
cmV2ZW50aW5nIHRoaXMNCnNjZW5hcmlvIGNvbXBsZXRlbHkgd291bGQgYmUgdmVyeSBjb3N0bHkg
aW4gdGVybXMgb2Ygd2hhdCBvdGhlciBDUFVzDQp3aWxsIGhhdmUgdG8gZG8gYmVmb3JlIG5vdGlm
eWluZyBvdGhlcnMsIHNvIHNpbWlsYXIgdG8gaG93IEVJTlRSIHdvcmtzLA0Kd2UgY2FuIHNpbXBs
eSBzcGVjaWZ5IHRoYXQgdGhpcyBpcyBhbGxvd2VkLCBhbmQgdGFzayBpcyBzdXBwb3NlZCB0byBy
ZS0NCmVudGVyIGlzb2xhdGlvbiBhZnRlciB0aGlzLiBJdCdzIHN0aWxsIGEgYmFkIGlkZWEgdG8g
c3BlY2lmeSB0aGF0DQppc29sYXRpb24gYnJlYWtpbmcgY2FuIGNvbnRpbnVlIGhhcHBlbmluZyB3
aGlsZSBhcHBsaWNhdGlvbiBpcyBydW5uaW5nDQppbiBpc29sYXRlZCBtb2RlLCBob3dldmVyIGFs
bG93aW5nIHNvbWUgImdyYWNlIHBlcmlvZCIgYWZ0ZXIgZW50ZXJpbmcNCmlzIGFjY2VwdGFibGUg
YXMgbG9uZyBhcyBhcHBsaWNhdGlvbiBpcyBhd2FyZSBvZiB0aGlzIGhhcHBlbmluZy4NCg0KSW4g
bGlidG1jIEkgaGF2ZSBtb3ZlZCB0aGlzIGhhbmRsaW5nIG9mIGlzb2xhdGlvbiBicmVha2luZyBp
bnRvIGENCnNlcGFyYXRlIHRocmVhZCwgaW50ZW5kZWQgdG8gYmVjb21lIGEgc2VwYXJhdGUgZGFl
bW9uIGlmIG5lY2Vzc2FyeS4gSW4NCnBhcnQgaXQgd2FzIGRvbmUgYmVjYXVzZSBpbml0aWFsIGlt
cGxlbWVudGF0aW9uIG9mIGlzb2xhdGlvbiBtYWRlIGl0DQp2ZXJ5IGRpZmZpY3VsdCB0byBhdm9p
ZCByZXBlYXRpbmcgZGVsYXllZCB3b3JrIG9uIGlzb2xhdGVkIENQVXMsIHNvDQpzb21ldGhpbmcg
aGFkIHRvIHdhdGNoIGZvciBpdCBmcm9tIG5vbi1pc29sYXRlZCBDUFUuIEl0J3MgcG9zc2libGUg
dGhhdA0Kbm93LCB3aGVuIGRlbGF5ZWQgd29yayBkb2VzIG5vdCBhcHBlYXIgb24gaXNvbGF0ZWQg
Q1BVcyBvdXQgb2Ygbm93aGVyZSwNCnRoZSBuZWVkIGluIGlzb2xhdGlvbiBtYW5hZ2VyIHRocmVh
ZCB3aWxsIGRpc2FwcGVhciwgYW5kIHRhc2sgaXRzZWxmDQp3aWxsIGJlIGFibGUgdG8gaGFuZGxl
IGFsbCBpc29sYXRpb24gYnJlYWtpbmcsIGxpa2Ugb3JpZ2luYWwNCmltcGxlbWVudGF0aW9uIGJ5
IENocmlzIHdhcyBzdXBwb3NlZCB0by4NCg0KSG93ZXZlciBpbiBlaXRoZXIgY2FzZSBpdCdzIHN0
aWxsIHVzZWZ1bCBmb3IgdGhlIHRhc2ssIG9yIGlzb2xhdGlvbg0KbWFuYWdlciwgdG8gZ2V0IGEg
ZGVzY3JpcHRpb24gb2YgdGhlIGlzb2xhdGlvbi1icmVha2luZyBldmVudC4gVGhpcyBpcw0Kd2hh
dCB0aG9zZSB0aGluZ3MgYXJlIGludGVuZGVkIGZvci4gTm93IHRoZXkgb25seSBwcm9kdWNlIGxv
ZyBtZXNzYWdlcw0KYmVjYXVzZSB0aGlzIGlzIHdoZXJlIGluaXRpYWxseSBhbGwgZGVzY3JpcHRp
b24gb2YgaXNvbGF0aW9uLWJyZWFraW5nDQpldmVudHMgd2VudCwgaG93ZXZlciBJIHdvdWxkIHBy
ZWZlciB0byBtYWtlIGxvZ2dpbmcgb3B0aW9uYWwgYnV0IGFsd2F5cw0KbGV0IGFwcGxpY2F0aW9u
cyByZWFkIHRob3NlIGV2ZW50cyBkZXNjcmlwdGlvbnMsIHJlZ2FyZGxlc3Mgb2YgYW55DQp0cmFj
aW5nIG1lY2hhbmlzbSBiZWluZyB1c2VkLiBJIHdhcyBtb3JlIGZvY3VzZWQgb24gbWFraW5nIHRo
ZQ0KcmVwb3J0aW5nIG1lY2hhbmlzbSBwcm9wZXJseSBkZXRlY3QgdGhlIGNhdXNlIG9mIGlzb2xh
dGlvbiBicmVha2luZw0KYmVjYXVzZSB0aGF0IGZ1bmN0aW9uYWxpdHkgd2FzIG5vdCBxdWl0ZSB3
b3JraW5nIGluIGVhcmxpZXIgd29yayBieQ0KQ2hyaXMgYW5kIFl1cmksIHNvIEkgaGF2ZSBrZXB0
IGxvZ2dpbmcgYXMgdGhlIG9ubHkgb3V0cHV0LCBidXQgbWFkZSBpdA0Kc3VpdGFibGUgZm9yIHBy
b2R1Y2luZyBldmVudHMgdGhhdCBhcHBsaWNhdGlvbnMgd2lsbCBiZSBhYmxlIHRvDQpyZWNlaXZl
LiBBcHBsaWNhdGlvbiwgb3IgaXNvbGF0aW9uIG1hbmFnZXIsIHdpbGwgcmVjZWl2ZSBjbGVhciBh
bmQNCnVuYW1iaWd1b3VzIHJlcG9ydGluZywgc28gdGhlcmUgd2lsbCBiZSBubyBuZWVkIGZvciBh
bnkgYWRkaXRpb25hbA0KYW5hbHlzaXMgb3IgZ3Vlc3N3b3JrLg0KDQpBZnRlciBhZGRpbmcgYSBw
cm9wZXIgImxvdy1sZXZlbCIgaXNvbGF0aW9uIGZsYWdzLCBJIGdvdCB0aGUgaWRlYSB0aGF0DQp3
ZSBtaWdodCBoYXZlIGEgYmV0dGVyIHlldCByZXBvcnRpbmcgbWVjaGFuaXNtLiBFYXJseSBpc29s
YXRpb24NCmJyZWFraW5nIGRldGVjdGlvbiBvbiBrZXJuZWwgZW50cnkgbWF5IHNldCBhIGZsYWcg
dGhhdCBzYXlzIHRoYXQNCmlzb2xhdGlvbiBicmVha2luZyBoYXBwZW5lZCwgaG93ZXZlciBpdHMg
Y2F1c2UgaXMgdW5rbm93bi4gT3IsIG1vcmUNCmxpa2VseSwgb25seSBzb21lIGdlbmVyYWwgaW5m
b3JtYXRpb24gYWJvdXQgaXNvbGF0aW9uIGJyZWFraW5nIGlzDQphdmFpbGFibGUsIGxpa2UgYSB0
eXBlIG9mIGV4Y2VwdGlvbi4gVGhlbiwgb25jZSBhIGtub3duIGlzb2xhdGlvbi0NCmJyZWFraW5n
IHJlcG9ydGluZyBtZWNoYW5pc20gaXMgY2FsbGVkIGZyb20gaW50ZXJydXB0LCBzeXNjYWxsLCBJ
UEkgb3INCmV4Y2VwdGlvbiBwcm9jZXNzaW5nLCB0aGUgZmxhZyBpcyBjbGVhcmVkLCBhbmQgcmVw
b3J0aW5nIGlzIHN1cHBvc2VkIHRvDQpiZSBkb25lLiBIb3dldmVyIGlmIHRoZW4ga2VybmVsIHJl
dHVybnMgdG8gdXNlcnNwYWNlIG9uIGlzb2xhdGVkIHRhc2sNCmJ1dCBpc29sYXRpb24gYnJlYWtp
bmcgaXMgbm90IHJlcG9ydGVkIHlldCwgYW4gaXNvbGF0aW9uIGJyZWFraW5nDQpyZXBvcnRpbmcg
d2l0aCAidW5rbm93biBjYXVzZSIgd2lsbCBoYXBwZW4uIFdlIG1heSBldmVuIGFkZCBzb21lIG1v
cmUNCm9wdGlvbmFsIGxpZ2h0d2VpZ2h0IHRyYWNpbmcgZm9yIGRlYnVnZ2luZyBwdXJwb3Nlcywg
aG93ZXZlciB0aGUgZmFjdA0KdGhhdCByZXBvcnRpbmcgd2lsbCBiZSBkb25lLCB3aWxsIGFsbG93
IHVzIHRvIG1ha2Ugc3VyZSB0aGF0IG5vIG1hdHRlcg0KaG93IGNvbXBsaWNhdGVkIGV4Y2VwdGlv
biBwcm9jZXNzaW5nIGlzLCBvciBob3cgd2UgbWFuYWdlZCB0byBtaXNzIHNvbWUNCnN1YnRsZSBk
ZXRhaWxzIG9mIGFuIGFyY2hpdGVjdHVyZSB3aGVyZSB3ZSBhcmUgaW1wbGVtZW50aW5nIHRhc2sN
Cmlzb2xhdGlvbiwgdGhlcmUgd2lsbCBiZSBhIHJlbGlhYmxlIHdheSB0byB0ZWxsIHRoZSB1c2Vy
IHRoYXQgc29tZXRoaW5nDQppcyB3cm9uZywgYW5kIHRlbGwgdGhlIHRhc2sgdGhhdCB0aGVyZSBp
cyBzb21ldGhpbmcgaXQgaGFzIHRvIHJlYWN0IHRvLg0KDQoNCj4gDQo+IFRoYW5rcy4NCj4gDQoN
Cg==
