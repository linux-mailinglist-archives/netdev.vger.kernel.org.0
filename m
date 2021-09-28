Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0286941B014
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 15:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240942AbhI1NcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 09:32:01 -0400
Received: from mail-mw2nam12on2102.outbound.protection.outlook.com ([40.107.244.102]:55216
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240879AbhI1Nb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 09:31:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk/l1PHlZteLuDNH6CMu9MEHvcaUFcd6wAwOpd1MuauokKJRvTldbKIQEZpGRXdgIJTEluxDtJ3WGBh/BqNuYcQZenOyDREahDYModd6hqg1Ek54dyD1dPVVUrnESRoGW3naXf8beu2zLWUEmvWNBz7wrRH+nfIwrNL2QAVht21u1HyN8GsJcPL8uy1Bju2Ty6dvA9QwMU56x156ItQXVFYO/N+1g8Bw7FEmS7Hf8u8/hUPrjXFnsb0ihk0Jr7YsWjzKr578WbhjtOBPxpD+AEpftKd6lRAwecm5M1f7cWndQqIQbnb+xhrNmlfl7Sg6Aq7l/PYpY9U5DUEficpWwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8cpSliKMB7ZlY0I+pp58itFS6IC9e4sjbqLVyWpvDs=;
 b=aT1ZQsy49OT/l628lJJX5rud5WKBH66Gg+bpe/18i2dTuzHyy4+80WQRosEiLM7sbekzU+aX/Gh6Y2cR044E4q7dpWZ7/c5gzijUDliCHx5cJRCljkgJtP/y4jjVwi6lBs4FDJKgOOUr6jZlodQ2SE95KuoVmvNIXhs9FxeVN9yBmI22L0OEjiNwQbtkp3sWKEZOyBUTCRhLtKaXV0Wz2Yqu+JHx1dEwvnqQsv/INOeNvINCe76sQZGpYYmlyipfuNhLQ7hhtmRY3Xq/NDUUwa0D64ONDFBH0CYqkjQGW7KCBnQDpXlOosat0zAWOz/51OCeGh21Ary8ivE/78e/Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8cpSliKMB7ZlY0I+pp58itFS6IC9e4sjbqLVyWpvDs=;
 b=DE30/8O/tit4VLoF9CW8pygRpdxWzi/vHjnxoAwhWlhc1Hv2tQgFkPHo88gpYHnVzk2dqaxT6pV7gZU/sFK/68GYXItGzU/vAMQAY56bK1fwv0TZkIfRG1VIp9qsfSyrYsTWqIUfMJYdel5qIrrfQ17N9eLqUIiY7pXah12/KbA=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by CH2PR13MB3319.namprd13.prod.outlook.com (2603:10b6:610:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10; Tue, 28 Sep
 2021 13:30:17 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::185b:505d:b35c:a3a2%6]) with mapi id 15.20.4566.014; Tue, 28 Sep 2021
 13:30:17 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "neilb@suse.com" <neilb@suse.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wanghai38@huawei.com" <wanghai38@huawei.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "willy@infradead.org" <willy@infradead.org>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "kolga@netapp.com" <kolga@netapp.com>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Topic: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Thread-Index: AQHXtBciMSJq8UTGIk29qdNL+Xnf4qu5ccKA
Date:   Tue, 28 Sep 2021 13:30:17 +0000
Message-ID: <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
         <20210928031440.2222303-3-wanghai38@huawei.com>
In-Reply-To: <20210928031440.2222303-3-wanghai38@huawei.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bca5103-8290-4a75-26f7-08d982841c61
x-ms-traffictypediagnostic: CH2PR13MB3319:
x-microsoft-antispam-prvs: <CH2PR13MB3319DC6FDA3526D5EEEAB762B8A89@CH2PR13MB3319.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dcd2kgvbhU0BFz0Wdk5QwzFYyj7ax+OZ8b2rAr4xkJ/ZWjubUTtgiWNCwIDuwolwd9Y3s2mrcZYDSuWrMpPaQ+xgEljENy2VnYUTl//lbf+/Yp5NJickMSmwq09mWcvlQU7/C2TJkETS41KDUttQYTDcJpsJaUmYPQnJsTlLwOOWA5FNGenMI4GyYGLkfBecHUfwpskfqw5carigvawfTRq+r9StHVLtuI/JOcSoeeJsANelckhB15OLB1J1q342JizA8Q8niW4PRNpxA7gU+khuzcgFfoFnd9eji8adTxYAOZbQf2ysq+q5J5jBndx1GX/1wy70K+yikX0baeKCs6GCx+kg9LWpw9rO2YDt06GklC4rsb9AtyTfVvz7GLZIIaelS9qqacbOorkmO2+4W0adedCSwwMJtnTeoEoBpARFopFolDBFVZdvdkEgtPk1paSk/mFH1X5Rahuo2Tf3U8HNtMpZ5RM+pQPKmf2YoOMxwguHtgVgxPrhkfTaBM+4DMBkg4jfAMF38f6vrRyox5GMxg7DsqYFIYLn4O67GwlOnGDwQOAoiSNPyowrpv8+XJFi1gWq0JRxo5cI3heze4cuWYpeTwekrMeOehEouLB+wcvp553JxZWA2Lkq3IV75Y2EBKC+GMxgpui5FfAZNY7RkqhT1tz9CejzQEpxs//k5KjyEzl9hv3LRIKpiELpX96mUKdi1wrJJAmHxtULPYP9i5Dj7qcZ4YkauDLABxk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(71200400001)(26005)(186003)(5660300002)(6486002)(921005)(8676002)(7416002)(4326008)(110136005)(54906003)(316002)(8936002)(6506007)(38100700002)(122000001)(76116006)(66946007)(38070700005)(6512007)(36756003)(2906002)(66556008)(66476007)(64756008)(66446008)(508600001)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXRad0wrY2R5Q0FBS3hKdHp1WmV3TWw4T3J6L1N5T0hQYlRkNkdkeXNxbHlq?=
 =?utf-8?B?anJpdUtRazlORlpJR0ZLa3k5Q29LS3hEeFlYaXphV3VZaGVMdEd4ODJlY05B?=
 =?utf-8?B?VnZuNStPM3FBYzlWUkdSRGxQRlhxTW9KRTFTZUl2RmdMNUJ2NVZMbDNXekRj?=
 =?utf-8?B?MERvMGdXODZIbjk0ZTVGR2c1SCt2M0tpWlJLcjdaSGR0ZVdWbUVqb2pFYUc4?=
 =?utf-8?B?YXVlNjY2UEg2VnlYTmRBM2xtaVh3VDZudGJ2L0MwcVNpUU1LcVNvUzhmY0Zt?=
 =?utf-8?B?QVZtZjU2dUt1aElNZkluREZoaFh1K1BjWkYzZDNvNFgwaVVRYjhKTjh4YkNu?=
 =?utf-8?B?cURaU1Y3K3AyWXNNb2xDcDhabFdWOTFPOXRHNDMyUS8wRlJHMzdWQzJNYjhl?=
 =?utf-8?B?bTJYVjdoa1lIRkdwNmxXL201bVBHTlJTTXp6clJHQ0s2K09vNTZKZjNiam1w?=
 =?utf-8?B?dkJzcmwyZXpwTVZxNzNvWjRza3VCMGxVb0NmMkVIYWgvZ3BxT3dYanJiSVE3?=
 =?utf-8?B?b2dYYXh4aU5JRXM0NnhPT3U2ZDBlRTFPaGczeUFkRS9hS1d1STB3VERKaGFE?=
 =?utf-8?B?U3dobWl5Yjg3aXZUdnRVTmRvM2huaVpZSzBRZHZjNVg1VkFKbGtWcTVGVUMy?=
 =?utf-8?B?M2RYZGt5RGw0NmpaK3ZVWjlqRm5TY3lDeWFjQThPRXdrNW1uc0lCd2xVOHR6?=
 =?utf-8?B?cHdrVW5DYk15VkhBbG9IVFRsZ2Q4cGtqY0JySENJTU5odG40N0NweE9NeWZ4?=
 =?utf-8?B?K2V0NWpnc25Na0xhazliVzdLRmtuNmp0NXlyek05RGRDZ0phQm9aQUJyQUxD?=
 =?utf-8?B?c3A0ZGRLcWNUWUZteldoODBsdjNGOFJjS3RqUGMxWW1Fc1ExcGs3OTdmcy90?=
 =?utf-8?B?eFF0cWc3Yzd1VG1td25WM3VEcnBjS01VVmpKMmxqZllFUmd5WDFEUmhKSWZ1?=
 =?utf-8?B?MUN1SXRnbGFOWTRMVEl1YnhGajNGQ05YbnJaemNCNUlQNmV3QXJEUCtQYXVY?=
 =?utf-8?B?VnJrMHVHRFNqY0hiekRBN3hCWS9SWElEb1NRUlhQcnR2dlZOWm55K21wWFNO?=
 =?utf-8?B?cDZOYTRaVEVNRGprYWJmRXFQUFNUbWF6RS85WFVhcklqZTc2SkRIbzRyd21U?=
 =?utf-8?B?alhlY2RNdHVBdGpGR1BEKzRFS2hwVlBrZ2xhdVJTdS9MeHV6aEZWT2pFUFlx?=
 =?utf-8?B?SGNkYTE0cm4raFhYc2xpbjdsU2pMcEEzYzlxQVVwWnh6aC9zblc3dFNEYXpa?=
 =?utf-8?B?K085Zk1LaWJ0am8wYzZOU3dZTjBSY3BvaFNOa0t2KzkrcGVDTk5xNUFSRHM4?=
 =?utf-8?B?RFNzRjFVSU5PZit2M1hhZDNSdktzRlVQV0pUbDlkL1BWTU9nbDFicDJPN1JF?=
 =?utf-8?B?b2J5b2NpYmI3K1E3L1EzQVBLeGVMakFjZXZsMkpYa0pRWVJ6cmFpaFAyU3E3?=
 =?utf-8?B?Qm42S1BCNm5icHYvRk52VTg3dWRRayt1enVsaStKT1l5OEMyNENRc2loaExo?=
 =?utf-8?B?bUsrMzZaenpoN3JnWG5CM254SUlJVnZmNkhQQnhndVM5a0RGd0wvR0l3MHk0?=
 =?utf-8?B?dU82b01uZkJUQVgxamdYVWhBMXNZVWRzL0hpSm1XZ1Q2b0lGZzhSRTlvMXFt?=
 =?utf-8?B?aUoyTy9vMFpYbTRmOXVTcDhYVEJQTjdFZSs1aUN3RzljclIxSXUwT1gxWmN4?=
 =?utf-8?B?c2c3ZFZoU3NiUktOT2J3eWRONzJMVHVlemd6MzlzaXdzTmU4MzBKS3VrSk81?=
 =?utf-8?Q?k3T/5PS0MIFk60HNFpEIbDI+Hx597xQDyxh0z8K?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9EE70289F81EC4B92544F6BEC8D70ED@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bca5103-8290-4a75-26f7-08d982841c61
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 13:30:17.1326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uENxMuoI/5KgJ68ZdZsTl5+3QW5Q9MqYHq/39IVLKERWQAaEkxLAgwbaA2IkpHKonJQj3824ngcK3LFhXJzKxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3319
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDExOjE0ICswODAwLCBXYW5nIEhhaSB3cm90ZToNCj4gV2hl
biB1c2UtZ3NzLXByb3h5IGlzIHNldCB0byAxLCB3cml0ZV9nc3NwKCkgY3JlYXRlcyBhIHJwYyBj
bGllbnQgaW4NCj4gZ3NzcF9ycGNfY3JlYXRlKCksIHRoaXMgaW5jcmVhc2VzIHRoZSBuZXRucyBy
ZWZjb3VudCBieSAyLCB0aGVzZQ0KPiByZWZjb3VudHMgYXJlIHN1cHBvc2VkIHRvIGJlIHJlbGVh
c2VkIGluIHJwY3NlY19nc3NfZXhpdF9uZXQoKSwgYnV0DQo+IGl0DQo+IHdpbGwgbmV2ZXIgaGFw
cGVuIGJlY2F1c2UgcnBjc2VjX2dzc19leGl0X25ldCgpIGlzIHRyaWdnZXJlZCBvbmx5DQo+IHdo
ZW4NCj4gdGhlIG5ldG5zIHJlZmNvdW50IGdldHMgdG8gMCwgc3BlY2lmaWNhbGx5Og0KPiDCoMKg
wqAgcmVmY291bnQ9MCAtPiBjbGVhbnVwX25ldCgpIC0+IG9wc19leGl0X2xpc3QgLT4NCj4gcnBj
c2VjX2dzc19leGl0X25ldA0KPiBJdCBpcyBhIGRlYWRsb2NrIHNpdHVhdGlvbiBoZXJlLCByZWZj
b3VudCB3aWxsIG5ldmVyIGdldCB0byAwIHVubGVzcw0KPiBycGNzZWNfZ3NzX2V4aXRfbmV0KCkg
aXMgY2FsbGVkLiBTbywgaW4gdGhpcyBjYXNlLCB0aGUgbmV0bnMgcmVmY291bnQNCj4gc2hvdWxk
IG5vdCBiZSBpbmNyZWFzZWQuDQo+IA0KPiBJbiB0aGlzIGNhc2UsIHhwcnQgd2lsbCB0YWtlIGEg
bmV0bnMgcmVmY291bnQgd2hpY2ggaXMgbm90IHN1cHBvc2VkDQo+IHRvIGJlIHRha2VuLiBBZGQg
YSBuZXcgZmxhZyB0byBycGNfY3JlYXRlX2FyZ3MgY2FsbGVkDQo+IFJQQ19DTE5UX0NSRUFURV9O
T19ORVRfUkVGIGZvciBub3QgaW5jcmVhc2luZyB0aGUgbmV0bnMgcmVmY291bnQuDQo+IA0KPiBJ
dCBpcyBzYWZlIG5vdCB0byBob2xkIHRoZSBuZXRucyByZWZjb3VudCwgYmVjYXVzZSB3aGVuDQo+
IGNsZWFudXBfbmV0KCksIGl0DQo+IHdpbGwgaG9sZCB0aGUgZ3NzcF9sb2NrIGFuZCB0aGVuIHNo
dXQgZG93biB0aGUgcnBjIGNsaWVudA0KPiBzeW5jaHJvbm91c2x5Lg0KPiANCj4gDQpJIGRvbid0
IGxpa2UgdGhpcyBzb2x1dGlvbiBhdCBhbGwuIEFkZGluZyB0aGlzIGtpbmQgb2YgZmxhZyBpcyBn
b2luZyB0bw0KbGVhZCB0byBwcm9ibGVtcyBkb3duIHRoZSByb2FkLg0KDQpJcyB0aGVyZSBhbnkg
cmVhc29uIHdoYXRzb2V2ZXIgd2h5IHdlIG5lZWQgdGhpcyBSUEMgY2xpZW50IHRvIGV4aXN0DQp3
aGVuIHRoZXJlIGlzIG5vIGFjdGl2ZSBrbmZzZCBzZXJ2ZXI/IElPVzogSXMgdGhlcmUgYW55IHJl
YXNvbiB3aHkgd2UNCnNob3VsZG4ndCBkZWZlciBjcmVhdGluZyB0aGlzIFJQQyBjbGllbnQgZm9y
IHdoZW4ga25mc2Qgc3RhcnRzIHVwIGluDQp0aGlzIG5ldCBuYW1lc3BhY2UsIGFuZCB3aHkgd2Ug
Y2FuJ3Qgc2h1dCBpdCBkb3duIHdoZW4ga25mc2Qgc2h1dHMNCmRvd24/DQoNCi0tIA0KVHJvbmQg
TXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9u
ZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
