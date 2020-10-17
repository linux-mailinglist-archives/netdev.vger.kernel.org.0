Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CE1290F92
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436687AbgJQFor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:44:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27856 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411623AbgJQFoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:44:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09H0ovQd010969;
        Fri, 16 Oct 2020 18:08:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=EDOZu0LlohVHOe6pDFJ2pBFL/gQjBbDi+hMpuygOAvM=;
 b=Rr9eMy9h+43yhSHXfQN95KyhONURKfTXHz3CJJVKTNvcw8imLHT7JbmwMZg1tdTXArRF
 2UenHTPqTgw64cyNGBpiLQQUbNVLQKjIitqgzHaAfaHCHAA+uiX6ocNNI9zPKwt/5Vb2
 FluGO3OwlfD2r36kxqj/BE8yaTrKZxKKhQj9cblBJhSleKsBwvkkscN9+P5/eNFu/ecN
 GyeiLbYpVY3e2FXTGJ6uEHYXAPhagBz93akqWYdmx6EGIppj4zFDRYvOfDkSxU+SHpHQ
 /zAHuvfcV6ezl+HEjodN4+fZmahtGv0etVzVqFGskHp5VjuNNmQZJwF54tYXouZS9y+s Fg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 343cfjrsj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 18:08:26 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 18:08:25 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.56) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 16 Oct 2020 18:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRROTGCbPqimSXofOvmI1dUPIIdNmH6qN5m0kONLrroGKnqUkNNrGrQgNOlWZHJvthv5cyhf9KEFNdwb+fT4hN0R5LSFoSbv9mYqevXAKsN+YFYL9GWBQV/8YtoESe5ILk7MllGzTmEvywgTvvWleRw6z4K2qr57miTeUOa0hCBy9j76TH1OUPaO+/5GL9Sjp2oIkgK63Is/KINl0tLugffSYvQ1ym/batQdaD9NG0XTSytX5l/R4vYvX6m45GN3efQnhzuVI+lletJN8NtBjRyZXbL2SZREIa1ROYgZffY/sb4xP4hodorQLj8JP+Cj8oM0KXUV0hPol6krcJEvrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDOZu0LlohVHOe6pDFJ2pBFL/gQjBbDi+hMpuygOAvM=;
 b=NXEZ8rFuPiaAxpPYRPQrN8PEVgkoufYW9PNEsOcUmy9/nS49+5t00vt0D+dWPVTmb7Eb9Ltnoz63sdmw3b9XIOkBBvzcldqF+BkfsQpNRvNmCQG+5gxC3zTN5BHKbObGrOv5i7fENdUxec/GTou01wQXULAyO8+kIMbBwrq0W1oMe7M4YDbUjHlG8Dl86L+fpmw1tYg+ghQGenujKM8/CJE3GlBupfLUMu4Tj2sOoJOFSc8i6hAc2mZ8WJPZdkDR02kT7OzEhh6Bl316bD1ApFreHkGKsTh347tgnpXEiwwKvddSGJqniVaDQnRmtneBo8fxYlUf1MaOrZCC0mCvoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDOZu0LlohVHOe6pDFJ2pBFL/gQjBbDi+hMpuygOAvM=;
 b=iU3GfC4nKlmu/qY1aBlmpsinE8jUYf4ecuA/z7TWK3U5zw84xWlRQC58DagttE20wvplaMWtnRpJQ5YVeXTe6o4+t1mleiGo8MWAVL9hmsy5B5o6KIQMaH4LiwY8n0h1ep8NjDkvSFGLqXPX+JmmgV1Ockfh214VQYZoxpX9i8k=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1822.namprd18.prod.outlook.com (2603:10b6:301:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Sat, 17 Oct
 2020 01:08:20 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95%7]) with mapi id 15.20.3455.031; Sat, 17 Oct 2020
 01:08:20 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Topic: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Index: AQHWYDdZDqoeqvfF50CzG3l43t/UoamDNPAAgATEYwCAAI5YAIABSVeAgBGyj4A=
Date:   Sat, 17 Oct 2020 01:08:20 +0000
Message-ID: <91b8301b0888bf9e5ff7711c3b49d21beddf569a.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
         <20201001135640.GA1748@lothringen>
         <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
         <20201004231404.GA66364@lothringen>
         <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
In-Reply-To: <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b328d48-849c-4df5-fea7-08d872392359
x-ms-traffictypediagnostic: MWHPR1801MB1822:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB182289167D9CE4A7A8C73C2FBC000@MWHPR1801MB1822.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TgmW+Uv/DOmjdOsGwTsAr0NbrGLUTUTXUdo/wbCX9orYIJBlDHgy0ojUrVtbv5HPdXV/iRK6beTUYcOwY7xIMQpQJ7gC+NUXKxLkidBRG/ews45dCxZ3Z2PiH/kR/hIkZGOUgpj3e39Q4dQ7hvT6pEnzJXdBrqXe1KoYTsoe66sPxpY+s+wIPNNxFVc83FXFKoO+GtDzRZ4oNZYAes1p20fBFFJewL82FEqWBnD9BsmeEqNM02BWpK7IcSIY5MBGtvMKJ50dJHnVZMZ3tgNl0NH7YCcPinlEt3nRpYpLYMvhJzrgJA81KYMdS6TN4io2Y0pIUvisR/eV+HIk9EusNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(53546011)(6506007)(66476007)(66556008)(186003)(2616005)(86362001)(6486002)(4326008)(76116006)(91956017)(6512007)(316002)(66946007)(7416002)(8936002)(71200400001)(66446008)(64756008)(5660300002)(54906003)(83380400001)(2906002)(478600001)(26005)(110136005)(8676002)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: C4eegixIrQpf70lhX7lXbF4MwSxt7RrWK5pK0drbB8J45x76xMUma53rBR3XexhSD7xXF4Z3Or8NHod96LxLJN535vZZtIMq6nXsifQoEIVFVC3MEIs1eTCVbYmfJHjwLaqJb4abqMBGitS6ZqKISfFilPDSp9zNKbsWt91ECfGjfLqD1yx6ByJJsgVuX/d94SWPSZJ+8x4rSkdBF/FR+CKSm1EZVJWdKAt8tYdR2qaMcUdu6DZv+Q4n0Yaq70gbEc81RBy60ofx5e/VKWwjeUZbjCH7lBVDW9bBBTzIfMDszt0kkUnoz6u6Mu4GnvtYvIk5iZsUjF2Dm+/Xjja15wvkHqJ9/fVWLAPS0431PjhjfBbnvwAf9OEIp40SObJrHsDQh4mksNaqUgw33oIeqXprNNE1+/KCSvnJP4ufCkbHUZq+Iv3doL+UjlHqUISs/+hkG8lK3qEH5whPqTFHRmq2s8YCQb+RCbkL5OwDatTuvqZEyj8ZFBscb40Xtri6N/PCIY9fKiexLjvJorvRdJMozYiN5lZzfN6zzhtCBHP1UvTy+5IFA1GzT8wt6UGnneJeGbp0zL2lw6RKEtDZrY0ujooIeMH8pSpjCYm+UyetYkqXfDaTB4ewT0ffDjv9mFCuEcn8Di6iddWMTZGsBw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <667B3873B7052043B22F58D0FBC4F61A@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b328d48-849c-4df5-fea7-08d872392359
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 01:08:20.3718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hn1pI0iEhEH9X7+8v3+kWzwCLZkSVdZs6TG0MZAVkkCsP+R68M/Cx+M9ezsD6HZbyZ1v1480vnzay8yjHXiQmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1822
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_12:2020-10-16,2020-10-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBNb24sIDIwMjAtMTAtMDUgYXQgMTQ6NTIgLTA0MDAsIE5pdGVzaCBOYXJheWFuIExhbCB3
cm90ZToNCj4gT24gMTAvNC8yMCA3OjE0IFBNLCBGcmVkZXJpYyBXZWlzYmVja2VyIHdyb3RlOg0K
PiA+IE9uIFN1biwgT2N0IDA0LCAyMDIwIGF0IDAyOjQ0OjM5UE0gKzAwMDAsIEFsZXggQmVsaXRz
IHdyb3RlOg0KPiA+ID4gT24gVGh1LCAyMDIwLTEwLTAxIGF0IDE1OjU2ICswMjAwLCBGcmVkZXJp
YyBXZWlzYmVja2VyIHdyb3RlOg0KPiA+ID4gPiBFeHRlcm5hbCBFbWFpbA0KPiA+ID4gPiANCj4g
PiA+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPiA+ID4gPiAtLS0tLS0NCj4gPiA+ID4gLS0tDQo+ID4gPiA+IE9uIFdlZCwg
SnVsIDIyLCAyMDIwIGF0IDAyOjQ5OjQ5UE0gKzAwMDAsIEFsZXggQmVsaXRzIHdyb3RlOg0KPiA+
ID4gPiA+ICsvKg0KPiA+ID4gPiA+ICsgKiBEZXNjcmlwdGlvbiBvZiB0aGUgbGFzdCB0d28gdGFz
a3MgdGhhdCByYW4gaXNvbGF0ZWQgb24gYQ0KPiA+ID4gPiA+IGdpdmVuDQo+ID4gPiA+ID4gQ1BV
Lg0KPiA+ID4gPiA+ICsgKiBUaGlzIGlzIGludGVuZGVkIG9ubHkgZm9yIG1lc3NhZ2VzIGFib3V0
IGlzb2xhdGlvbg0KPiA+ID4gPiA+IGJyZWFraW5nLiBXZQ0KPiA+ID4gPiA+ICsgKiBkb24ndCB3
YW50IGFueSByZWZlcmVuY2VzIHRvIGFjdHVhbCB0YXNrIHdoaWxlIGFjY2Vzc2luZw0KPiA+ID4g
PiA+IHRoaXMNCj4gPiA+ID4gPiBmcm9tDQo+ID4gPiA+ID4gKyAqIENQVSB0aGF0IGNhdXNlZCBp
c29sYXRpb24gYnJlYWtpbmcgLS0gd2Uga25vdyBub3RoaW5nDQo+ID4gPiA+ID4gYWJvdXQNCj4g
PiA+ID4gPiB0aW1pbmcNCj4gPiA+ID4gPiArICogYW5kIGRvbid0IHdhbnQgdG8gdXNlIGxvY2tp
bmcgb3IgUkNVLg0KPiA+ID4gPiA+ICsgKi8NCj4gPiA+ID4gPiArc3RydWN0IGlzb2xfdGFza19k
ZXNjIHsNCj4gPiA+ID4gPiArCWF0b21pY190IGN1cnJfaW5kZXg7DQo+ID4gPiA+ID4gKwlhdG9t
aWNfdCBjdXJyX2luZGV4X3dyOw0KPiA+ID4gPiA+ICsJYm9vbAl3YXJuZWRbMl07DQo+ID4gPiA+
ID4gKwlwaWRfdAlwaWRbMl07DQo+ID4gPiA+ID4gKwlwaWRfdAl0Z2lkWzJdOw0KPiA+ID4gPiA+
ICsJY2hhcgljb21tWzJdW1RBU0tfQ09NTV9MRU5dOw0KPiA+ID4gPiA+ICt9Ow0KPiA+ID4gPiA+
ICtzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IGlzb2xfdGFza19kZXNjLA0KPiA+ID4gPiA+
IGlzb2xfdGFza19kZXNjcyk7DQo+ID4gPiA+IFNvIHRoYXQncyBxdWl0ZSBhIGh1Z2UgcGF0Y2gg
dGhhdCB3b3VsZCBoYXZlIG5lZWRlZCB0byBiZSBzcGxpdA0KPiA+ID4gPiB1cC4NCj4gPiA+ID4g
RXNwZWNpYWxseSB0aGlzIHRyYWNpbmcgZW5naW5lLg0KPiA+ID4gPiANCj4gPiA+ID4gU3BlYWtp
bmcgb2Ygd2hpY2gsIEkgYWdyZWUgd2l0aCBUaG9tYXMgdGhhdCBpdCdzIHVubmVjZXNzYXJ5Lg0K
PiA+ID4gPiBJdCdzDQo+ID4gPiA+IHRvbyBtdWNoDQo+ID4gPiA+IGNvZGUgYW5kIGNvbXBsZXhp
dHkuIFdlIGNhbiB1c2UgdGhlIGV4aXN0aW5nIHRyYWNlIGV2ZW50cyBhbmQNCj4gPiA+ID4gcGVy
Zm9ybQ0KPiA+ID4gPiB0aGUNCj4gPiA+ID4gYW5hbHlzaXMgZnJvbSB1c2Vyc3BhY2UgdG8gZmlu
ZCB0aGUgc291cmNlIG9mIHRoZSBkaXN0dXJiYW5jZS4NCj4gPiA+IFRoZSBpZGVhIGJlaGluZCB0
aGlzIGlzIHRoYXQgaXNvbGF0aW9uIGJyZWFraW5nIGV2ZW50cyBhcmUNCj4gPiA+IHN1cHBvc2Vk
IHRvDQo+ID4gPiBiZSBrbm93biB0byB0aGUgYXBwbGljYXRpb25zIHdoaWxlIGFwcGxpY2F0aW9u
cyBydW4gbm9ybWFsbHksIGFuZA0KPiA+ID4gdGhleQ0KPiA+ID4gc2hvdWxkIG5vdCByZXF1aXJl
IGFueSBhbmFseXNpcyBvciBodW1hbiBpbnRlcnZlbnRpb24gdG8gYmUNCj4gPiA+IGhhbmRsZWQu
DQo+ID4gU3VyZSBidXQgeW91IGNhbiB1c2UgdHJhY2UgZXZlbnRzIGZvciB0aGF0LiBKdXN0IHRy
YWNlIGludGVycnVwdHMsDQo+ID4gd29ya3F1ZXVlcywNCj4gPiB0aW1lcnMsIHN5c2NhbGxzLCBl
eGNlcHRpb25zIGFuZCBzY2hlZHVsZXIgZXZlbnRzIGFuZCB5b3UgZ2V0IGFsbA0KPiA+IHRoZSBs
b2NhbA0KPiA+IGRpc3R1cmJhbmNlLiBZb3UgbWlnaHQgd2FudCB0byB0dW5lIGEgZmV3IGZpbHRl
cnMgYnV0IHRoYXQncyBwcmV0dHkNCj4gPiBtdWNoIGl0Lg0KPiA+IA0KPiA+IEFzIGZvciB0aGUg
c291cmNlIG9mIHRoZSBkaXN0dXJiYW5jZXMsIGlmIHlvdSByZWFsbHkgbmVlZCB0aGF0DQo+ID4g
aW5mb3JtYXRpb24sDQo+ID4geW91IGNhbiB0cmFjZSB0aGUgd29ya3F1ZXVlIGFuZCB0aW1lciBx
dWV1ZSBldmVudHMgYW5kIGp1c3QgZmlsdGVyDQo+ID4gdGhvc2UgdGhhdA0KPiA+IHRhcmdldCB5
b3VyIGlzb2xhdGVkIENQVXMuDQo+ID4gDQo+IA0KPiBJIGFncmVlIHRoYXQgd2UgY2FuIGRvIGFs
bCB0aG9zZSB0aGluZ3Mgd2l0aCB0cmFjaW5nLg0KPiBIb3dldmVyLCBJTUhPIGhhdmluZyBhIHNp
bXBsaWZpZWQgbG9nZ2luZyBtZWNoYW5pc20gdG8gZ2F0aGVyIHRoZQ0KPiBzb3VyY2Ugb2YNCj4g
dmlvbGF0aW9uIG1heSBoZWxwIGluIHJlZHVjaW5nIHRoZSBtYW51YWwgZWZmb3J0Lg0KPiANCj4g
QWx0aG91Z2gsIEkgYW0gbm90IHN1cmUgaG93IGVhc3kgd2lsbCBpdCBiZSB0byBtYWludGFpbiBz
dWNoIGFuDQo+IGludGVyZmFjZQ0KPiBvdmVyIHRpbWUuDQoNCkkgdGhpbmsgdGhhdCB0aGUgZ29h
bCBvZiAiZmluZGluZyBzb3VyY2Ugb2YgZGlzdHVyYmFuY2UiIGludGVyZmFjZSBpcw0KZGlmZmVy
ZW50IGZyb20gd2hhdCBjYW4gYmUgYWNjb21wbGlzaGVkIGJ5IHRyYWNpbmcgaW4gdHdvIHdheXM6
DQoNCjEuICJTb3VyY2Ugb2YgZGlzdHVyYmFuY2UiIHNob3VsZCBwcm92aWRlIHNvbWUgdXNlZnVs
IGluZm9ybWF0aW9uIGFib3V0DQpjYXRlZ29yeSBvZiBldmVudCBhbmQgaXQgY2F1c2UgYXMgb3Bw
b3NlZCB0byBkZXRlcm1pbmluZyBhbGwgcHJlY2lzZQ0KZGV0YWlscyBhYm91dCB0aGluZ3MgYmVp
bmcgY2FsbGVkIHRoYXQgcmVzdWx0ZWQgb3IgY291bGQgcmVzdWx0IGluDQpkaXN0dXJiYW5jZS4g
SXQgc2hvdWxkIG5vdCBkZXBlbmQgb24gdGhlIHVzZXIncyBrbm93bGVkZ2UgYWJvdXQgZGV0YWls
cw0Kb2YgaW1wbGVtZW50YXRpb25zLCBpdCBzaG91bGQgcHJvdmlkZSBzb21lIGRlZmluaXRlIGFu
c3dlciBvZiB3aGF0DQpoYXBwZW5lZCAod2l0aCB3aGF0ZXZlciBhbW91bnQgb2YgZGV0YWlscyBj
YW4gYmUgZ2l2ZW4gaW4gYSBnZW5lcmljDQptZWNoYW5pc20pIGV2ZW4gaWYgdGhlIHVzZXIgaGFz
IG5vIGlkZWEgaG93IHRob3NlIHRoaW5ncyBoYXBwZW4gYW5kDQp3aGF0IHBhcnQgb2Yga2VybmVs
IGlzIHJlc3BvbnNpYmxlIGZvciBlaXRoZXIgY2F1c2luZyBvciBwcm9jZXNzaW5nDQp0aGVtLiBU
aGVuIGlmIHRoZSB1c2VyIG5lZWRzIGZ1cnRoZXIgZGV0YWlscywgdGhleSBjYW4gYmUgb2J0YWlu
ZWQgd2l0aA0KdHJhY2luZy4NCg0KMi4gSXQgc2hvdWxkIGJlIHVzYWJsZSBhcyBhIHJ1bnRpbWUg
ZXJyb3IgaGFuZGxpbmcgbWVjaGFuaXNtLCBzbyB0aGUNCmluZm9ybWF0aW9uIGl0IHByb3ZpZGVz
IHNob3VsZCBiZSBzdWl0YWJsZSBmb3IgYXBwbGljYXRpb24gdXNlIGFuZA0KbG9nZ2luZy4gSXQg
c2hvdWxkIGJlIHVzYWJsZSB3aGVuIGFwcGxpY2F0aW9ucyBhcmUgcnVubmluZyBvbiBhIHN5c3Rl
bQ0KaW4gcHJvZHVjdGlvbiwgYW5kIG5vIHNwZWNpZmljIHRyYWNpbmcgb3IgbW9uaXRvcmluZyBt
ZWNoYW5pc20gY2FuIGJlDQppbiB1c2UuIElmLCBzYXksIHRob3VzYW5kcyBvZiBkZXZpY2VzIGFy
ZSBjb250cm9sbGluZyBuZXV0cmlubw0KZGV0ZWN0b3JzIG9uIGFuIG9jZWFuIGZsb29yLCBhbmQg
aW4gYSBtb250aCBvZiB3b3JrIG9uZSBvZiB0aGVtIGdvdCBvbmUNCmlzb2xhdGlvbiBicmVha2lu
ZyBldmVudCwgaXQgc2hvdWxkIGJlIGFibGUgdG8gcmVwb3J0IHRoYXQgaXNvbGF0aW9uDQp3YXMg
YnJva2VuIGJ5IGFuIGludGVycnVwdCBmcm9tIGEgbmV0d29yayBpbnRlcmZhY2UsIHNvIHRoZSB1
c2VycyB3aWxsDQpiZSBhYmxlIHRvIHRyYWNrIGl0IGRvd24gdG8gc29tZSB1c2Vyc3BhY2UgYXBw
bGljYXRpb24gcmVjb25maWd1cmluZw0KdGhvc2UgaW50ZXJydXB0cy4NCg0KSXQgd2lsbCBiZSBh
IGdvb2QgaWRlYSB0byBtYWtlIHN1Y2ggbWVjaGFuaXNtIG9wdGlvbmFsIGFuZCBzdWl0YWJsZSBm
b3INCnRyYWNraW5nIHRoaW5ncyBvbiBjb25kaXRpb25zIG90aGVyIHRoYW4gImFsd2F5cyBlbmFi
bGVkIiBhbmQgImVuYWJsZWQNCndpdGggdGFzayBpc29sYXRpb24iLiBIb3dldmVyIGluIG15IG9w
aW5pb24sIHRoZXJlIHNob3VsZCBiZSBzb21ldGhpbmcNCmluIGtlcm5lbCBlbnRyeSBwcm9jZWR1
cmUgdGhhdCwgaWYgZW5hYmxlZCwgcHJlcGFyZWQgc29tZXRoaW5nIHRvIGJlDQpmaWxsZWQgYnkg
dGhlIGNhdXNlIGRhdGEsIGFuZCB3ZSBrbm93IGF0IGxlYXN0IG9uZSBzdWNoIHNpdHVhdGlvbiB3
aGVuDQp0aGlzIGtlcm5lbCBlbnRyeSBwcm9jZWR1cmUgc2hvdWxkIGJlIHRyaWdnZXJlZCAtLSB3
aGVuIHRhc2sgaXNvbGF0aW9uDQppcyBvbi4NCg0KLS0gDQpBbGV4DQo=
