Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D797840FDAD
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbhIQQQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:16:02 -0400
Received: from mail-eopbgr120075.outbound.protection.outlook.com ([40.107.12.75]:41374
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238457AbhIQQPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:15:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNKD/A2/H11spXtrO293T5YBj/coB2ySUg4Eg9UknkSaJlRnFFb76l9FOCaz596PrMgq7ZlhqioudBYs40tnDE5YLqWcywtfXYvntB6C37p02vOCTQ+AnhYSQ1aaX11J0QgDVY+h6fNINIKgSs749lwnCj+wx0H8iD8mbWfNTK/Zgd648dCJnITouJX64sOTmByJiYqBCwPi1DikcqC8Pm0Jfl5rzNFbECn9/zLtj8DLOVEc4P3wi/wyYNOxoq3YiIQ3nK+8b8DCCVzKCeOM8UbznSj9Y9M+VdmFuXU1y4M4CmS/1wKIS51T6zAdwu1zVORZKjV+nFBMpk2VvBgZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=evnTjW/RL3rzZZbjxVR9KX66QaaxotVct2y1Xb768gk=;
 b=Eu9i4bKMWDOOHCLMlsFX6pqA9eW1QNTqr/aqGnEHpkSrXo1bwjd7BbDpAycov0DlBsHyRyWxqfToEyAw3xp8PR71XtNseMMvcJEw6ZA2kIoZvTAba0htsHAAytu82H7M6WOK+cUx4naslxfvDAgz+RV1JXLGQcGbobBorraEn/iLie1Q/gh6Kafl08K+xs+f5UU58jY6j1neDf2sRrzghybA3Q3W2PASbTnJ3o19lEnPWdsVnAeM4HBzxg503U9wdhnKuVDs957IyZnZ9Fl3jAdDKXwwVE0/+0LSMW13sLbujxkW52xeBQ2DPTb8OZnmyjHvvXO2znlS65HoAieQcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB1734.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 16:14:29 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::488a:db7:19ae:d1ff]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::488a:db7:19ae:d1ff%6]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 16:14:29 +0000
From:   LEROY Christophe <christophe.leroy@csgroup.eu>
To:     Hari Bathini <hbathini@linux.ibm.com>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "paulus@samba.org" <paulus@samba.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 4/8] powerpc/ppc-opcode: introduce PPC_RAW_BRANCH()
 macro
Thread-Topic: [PATCH v2 4/8] powerpc/ppc-opcode: introduce PPC_RAW_BRANCH()
 macro
Thread-Index: AQHXq9ksV7iD3kWRZESwiVNJ6huR9quoZnqA
Date:   Fri, 17 Sep 2021 16:14:29 +0000
Message-ID: <ff2a1595-3021-b199-c608-559e3c289b02@csgroup.eu>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
 <20210917153047.177141-5-hbathini@linux.ibm.com>
In-Reply-To: <20210917153047.177141-5-hbathini@linux.ibm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b2d84fc-bde0-4539-3fd9-08d979f63a0c
x-ms-traffictypediagnostic: MRZP264MB1734:
x-microsoft-antispam-prvs: <MRZP264MB1734D8EE72917B761F79A857EDDD9@MRZP264MB1734.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BO3r4BctpgrCR2nVSFciTkLl40aBY879IeC8mWKtShDOXGZuFNL7NSuFgmKYzUropoicNYSor/5Qydenf18UoKodAxPR6d0w+VvldON6FJaYUgaKBAwCoxVPOfqDc1ah1LxprweFGLYQOpPKHq6uReDCAqc5eerx9ee+1jFKM4PBT0AdcKvaWVLJbmwq5nCLPJCcu6NWZKXKLCU/LCwRNtC42lPh7p1XvpY6FE/43cobsMCr7vYm4gmI5yMm+sKiB38HPzkLRKpGX5imS/AAcPBd5Qrq/yjOo2KyGhzUUcTxh8WL8s51Y1OfKACqwzAlUNzZx92SAkRiPkrqAuUTmHhhBwu2iQa50XAo+RG5MtAeMkiHAsy65U0w476fwTqqQBbW8LasppaLjxYQWg5F6K0SLSfAf3SwdMx1VrP2cu6A5rIjgpLi4n/eWh+YudZk4lLJ2ACZhzOiC44zq6kJQgQS5prqaghuBunDKUs1mLUvJCHonvFXSk/LCWruY5K/0xR6yv2DyWzEQjsWnRNz+eqrnbFqxmXS6l2wYGZ/cVpnpU78dyU3x5yubKDEaVmN0tZlJ9e4H7kjeunULfwymSrhtMR/0oBxpuho6819LhljhpxMwOqpY1Jan1YAYGw46S7BQzZ/xKjsSBZShdhRp+Z/+OSZAuccIiRPqqzGB8rLFq7sAcz4E9UUInXmRQjPckWiRS1EIT1O/NUQRXEGaoi7XgGbdVOPb7XPhZFR1e0NrqQuMGMLZ7wIO/x+gVG6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(91956017)(38070700005)(36756003)(76116006)(5660300002)(7416002)(26005)(8936002)(8676002)(31696002)(66476007)(66556008)(83380400001)(71200400001)(86362001)(31686004)(508600001)(64756008)(2906002)(66446008)(4326008)(110136005)(316002)(6486002)(186003)(38100700002)(122000001)(6512007)(2616005)(6506007)(54906003)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3FqQUw4MVBuSWRrdSsvZlp0NnR6MDlIelRKUnI5d3ZUOEprRkR5bDhXNkgr?=
 =?utf-8?B?MGlSSndXaS85enh5ai9JdDRXWHAzNHZoSUVTM3NvSkFzQVpVdTBsNlVGV1gw?=
 =?utf-8?B?RllEOHF5ZmI0QStWSW5jaFl1dDhqTmlmd3Z6WGpid1NOUUxGdWZLakUxaUMw?=
 =?utf-8?B?ZHBhR3JRSlY4NVdMYks2M2FOYVViU1Y3RmFlK1JDRWgxdFp6bVgxSFJ1QkdT?=
 =?utf-8?B?UmFrR0c4OWZYUmhLTVZ2UUVUNEJwb3NQRlZyT0s0WTVndjkwOEppVEhJM0Nv?=
 =?utf-8?B?cHVYUWQ0dGNpZXc4dnV4U29rdndXVnU1UFhQQUIvblRxbHdleWVCQ29HMFAy?=
 =?utf-8?B?bTdOcnVyWUU0Nnd3VjltVUp5bUd5dnRveWpvYkJsdkp2ZTlNcERxNStMQ2R2?=
 =?utf-8?B?QkxZaXJldVdVODI5citjd05TcThrVWRBendOQzZCSGN4ZGt1cS9wbUpaNTFU?=
 =?utf-8?B?Z2hwYWMyWXhQVWUwZnBQZjBYeEJ3SzkvdkhCZDRqclpsTUxSK0pXYVpsQmZB?=
 =?utf-8?B?RTlGUXp5aSthbkljUjBlMTZhdWJTOVRDRHA3Vko4VGM2Zjl2YlNBMHZjdVJM?=
 =?utf-8?B?ai96NnVZU25rNWR2ZFhVZXlVSFlmTDNPeXgvWG5rSVBGbXlwYWp6bVhJTHRy?=
 =?utf-8?B?TmdxdG4yVUYxWklTR0d0dTRUM1c1WkdFTFM0YWExUkpYeTVpbXA3S3FyMUZW?=
 =?utf-8?B?dUtSek9xSm9mdmpNK0MyOVUvam8xazF1WmpSWm9RSHAya3ZDVFlJVGc2WW5t?=
 =?utf-8?B?eHNZbjdWb1luckV4Vlhyb3lwSU5qZWVjNHpZMHhlZ3h2RXE1YTcrWUU5TGZ3?=
 =?utf-8?B?MGFGRmU2WXQwR1dNVWRRTXN0dmQ4ak9jYkVFWGNORm5SbjVnTUgzenlpVElq?=
 =?utf-8?B?SzNpQXdCNFFNZmhPbjI1M20yM0g2cEtFZW5hbFNVQnRvZ0VUdDhyRFdnbHVk?=
 =?utf-8?B?K0FNVUlkZFZXOGFvaGJ0Nkd6WUZUU3pHcjlFZmZZNEtxVlFhT0ZjVGxzaTBo?=
 =?utf-8?B?VkhjVHNTZ2hFVDNlVTlsb2srUkk3MnJwUU5jdnZLVmpJdHo4emRkZzRPWUMy?=
 =?utf-8?B?ekJNSWFjTkpYcEZwNkpNNmhWeFRPYXliT0xxMTZmQ0h2TWJkWURpWkJsUlN6?=
 =?utf-8?B?eDRHVmZFMWVQZUJaMXFCMFk4RWtYc1c5SWJzTmFRNzE1OU1kdWhvUmN2YlhR?=
 =?utf-8?B?WExZT3psTWRnSks2OVRQTHByVUc0WGJOTjVaLyttcktEak9NUFdLVmR0OFJp?=
 =?utf-8?B?a1pHc0xpWndDMTh0T0h3ZVdleUhEU0YzcWcwb0w2SUxtTjBheE9rYWwvV05z?=
 =?utf-8?B?WjJHbk9zRVEwWWp4ZStUMndXVFpjUFdVckJmSXZHNXN5WGJTRXd4NENBbk9z?=
 =?utf-8?B?VCtxQkVvUUc5b1kzWDZsdy9FVEhHT1JITjNBUWQ0cEJmS2E1RFFCS1JWVHZD?=
 =?utf-8?B?bXlhTWtWNW1BdHdKb1l0MWhoRDhpS0h2UFZReWsyUzBIa0Z3cjlLdFhKWXlh?=
 =?utf-8?B?SnlKTFZza1FoVTFLZ0loaitWZTltTUVHWDZUU3UvNWhtMmE5NjRKZ280OWRW?=
 =?utf-8?B?bkIwK3MwK1UxMWlvY2xaamRUMkhwSW9nRVdndkcwY3B6T1ZiT3NEa1FzSmVU?=
 =?utf-8?B?WUQ3aVZQZ2dUM2VIY2FJWXVvTnBGcEFVV29xRXB5T2lnVzJQNUE4bnpzU1V2?=
 =?utf-8?B?cVdJR3poUVNJRHB4MzJQY0U0N2lhb3hIYUc5bXR1c2U4UytZdytRdUpJVzJ1?=
 =?utf-8?B?Q3dNVW91TkhDMTJEeS9QaEhrQXVybkpXT0VQSmdFZm1odjFpckZHOVk2ZUxm?=
 =?utf-8?B?cmNMYzFUYUx3czdlZFVwQT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E448700B1B7B145B047764190ED8F8B@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2d84fc-bde0-4539-3fd9-08d979f63a0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 16:14:29.1516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OWHQm7/iGIXF8WBKY3JT3ykbUBk5APjXZ6ov5Yku/kiorHFdbpo8xADS+zRtE2JZlk1omPNILVB6BtYyIljAfH+gRZjUeWE3f5JFndUtf6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB1734
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzA5LzIwMjEgw6AgMTc6MzAsIEhhcmkgQmF0aGluaSBhIMOpY3JpdMKgOg0KPiBE
ZWZpbmUgYW5kIHVzZSBQUENfUkFXX0JSQU5DSCgpIG1hY3JvIGluc3RlYWQgb2Ygb3BlbiBjb2Rp
bmcgaXQuIFRoaXMNCj4gbWFjcm8gaXMgdXNlZCB3aGlsZSBhZGRpbmcgQlBGX1BST0JFX01FTSBz
dXBwb3J0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFyaSBCYXRoaW5pIDxoYmF0aGluaUBsaW51
eC5pYm0uY29tPg0KDQpSZXZpZXdlZC1ieTogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5s
ZXJveUBjc2dyb3VwLmV1Pg0KDQo+IC0tLQ0KPiANCj4gQ2hhbmdlcyBpbiB2MjoNCj4gKiBOZXcg
cGF0Y2ggdG8gaW50cm9kdWNlIFBQQ19SQVdfQlJBTkNIKCkgbWFjcm8uDQo+IA0KPiANCj4gICBh
cmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcHBjLW9wY29kZS5oIHwgMiArKw0KPiAgIGFyY2gvcG93
ZXJwYy9uZXQvYnBmX2ppdC5oICAgICAgICAgICAgfCA0ICsrLS0NCj4gICAyIGZpbGVzIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcHBjLW9wY29kZS5oIGIvYXJjaC9wb3dlcnBjL2luY2x1
ZGUvYXNtL3BwYy1vcGNvZGUuaA0KPiBpbmRleCBiYWVhNjU3YmM4NjguLmY1MDIxM2UyYTNlMCAx
MDA2NDQNCj4gLS0tIGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL3BwYy1vcGNvZGUuaA0KPiAr
KysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcHBjLW9wY29kZS5oDQo+IEBAIC01NjYsNiAr
NTY2LDggQEANCj4gICAjZGVmaW5lIFBQQ19SQVdfTVRTUFIoc3ByLCBkKQkJKDB4N2MwMDAzYTYg
fCBfX19QUENfUlMoZCkgfCBfX1BQQ19TUFIoc3ByKSkNCj4gICAjZGVmaW5lIFBQQ19SQVdfRUlF
SU8oKQkJCSgweDdjMDAwNmFjKQ0KPiAgIA0KPiArI2RlZmluZSBQUENfUkFXX0JSQU5DSChhZGRy
KQkJKFBQQ19JTlNUX0JSQU5DSCB8ICgoYWRkcikgJiAweDAzZmZmZmZjKSkNCj4gKw0KPiAgIC8q
IERlYWwgd2l0aCBpbnN0cnVjdGlvbnMgdGhhdCBvbGRlciBhc3NlbWJsZXJzIGFyZW4ndCBhd2Fy
ZSBvZiAqLw0KPiAgICNkZWZpbmUJUFBDX0JDQ1RSX0ZMVVNICQlzdHJpbmdpZnlfaW5fYygubG9u
ZyBQUENfSU5TVF9CQ0NUUl9GTFVTSCkNCj4gICAjZGVmaW5lCVBQQ19DUF9BQk9SVAkJc3RyaW5n
aWZ5X2luX2MoLmxvbmcgUFBDX1JBV19DUF9BQk9SVCkNCj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93
ZXJwYy9uZXQvYnBmX2ppdC5oIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0LmgNCj4gaW5kZXgg
NDExYzYzZDk0NWM3Li4wYzhmODg1YjhmNDggMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcG93ZXJwYy9u
ZXQvYnBmX2ppdC5oDQo+ICsrKyBiL2FyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdC5oDQo+IEBAIC0y
NCw4ICsyNCw4IEBADQo+ICAgI2RlZmluZSBFTUlUKGluc3RyKQkJUExBTlRfSU5TVFIoaW1hZ2Us
IGN0eC0+aWR4LCBpbnN0cikNCj4gICANCj4gICAvKiBMb25nIGp1bXA7ICh1bmNvbmRpdGlvbmFs
ICdicmFuY2gnKSAqLw0KPiAtI2RlZmluZSBQUENfSk1QKGRlc3QpCQlFTUlUKFBQQ19JTlNUX0JS
QU5DSCB8CQkJICAgICAgXA0KPiAtCQkJCSAgICAgKCgoZGVzdCkgLSAoY3R4LT5pZHggKiA0KSkg
JiAweDAzZmZmZmZjKSkNCj4gKyNkZWZpbmUgUFBDX0pNUChkZXN0KQkJRU1JVChQUENfUkFXX0JS
QU5DSCgoZGVzdCkgLSAoY3R4LT5pZHggKiA0KSkpDQo+ICsNCj4gICAvKiBibHI7ICh1bmNvbmRp
dGlvbmFsICdicmFuY2gnIHdpdGggbGluaykgdG8gYWJzb2x1dGUgYWRkcmVzcyAqLw0KPiAgICNk
ZWZpbmUgUFBDX0JMX0FCUyhkZXN0KQlFTUlUKFBQQ19JTlNUX0JMIHwJCQkgICAgICBcDQo+ICAg
CQkJCSAgICAgKCgoZGVzdCkgLSAodW5zaWduZWQgbG9uZykoaW1hZ2UgKyBjdHgtPmlkeCkpICYg
MHgwM2ZmZmZmYykpDQo+IA==
