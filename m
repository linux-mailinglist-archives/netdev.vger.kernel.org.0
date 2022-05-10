Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA68A5221F6
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347780AbiEJRNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347779AbiEJRM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:12:57 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20120.outbound.protection.outlook.com [40.107.2.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8579928F1F8
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsQk3s4sFNwPj5f1CUsKekayEkCiUcgtuOMHUhQiUJIGsF0HufUpnuJjk68lHWUkqF46BrdEWNBwS9vMNVL59oYAsDLZdKI5+TYV8k0xirmSFnlrERfpnemUHgpb404w6AM+hH+wWdGSzOaYShR5QbtuO/94DIetEShiOXwcYPceDjwmn/wIo+NjBjhhNYgq0c4lkAXoPOVEkTKOIp6h12ErW7g3QR22uARW+cnGsdFyORa0i9Xn+g7SI5s9gpi1knf3Y50tvyfYRppdj7RSpCbxDuQOib5g1g1XE/XmINVxD1+PM2nyA7gOQZTryGLhDyKBPU82YDmHjumi85FUAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6pbniI+Lpda7u7E23jvMfiIaTT7q4mkDUVCGh8WEfM=;
 b=kOc4ZMlupV9gnhmBmdmNPxEAnpo2d8XOPxm+UYn09ekS2NT8BuZ90HazAiJzz2uzfldSqmhV5aMhsdMykpJwRb/VHZHwyaCLLyRl81+On2RprCw2BTpKomeyLWwWpC9K0trakANS57NNZyyznJ8pyKvnPR4Oc/y3/jJFihUt/Vh7dceDoAoMZQ0REZeu93VGH2VdGdw74zGytb8KX4oRNU9lLHB8fQXFxuXH0w+PkphGUvTEKYn+aTSC7TjbFdOt5e+w7dqE8ILrNxR+40c9U19YS0QkbLGftqvbv+XAoIqvaiIL249ILro9hhOjXxvKpQ2UD8B51KsTIzTrfN0sZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6pbniI+Lpda7u7E23jvMfiIaTT7q4mkDUVCGh8WEfM=;
 b=qp2HvesAknuBYf2mPxcmXMXDbrRvxu5oVUxTqFCwV0bZWrnlU5QgmT3rSnpVTczhnn7hNaxUyEaeYweWVistd1Bd7SkRX/sVu+wzQCjMAM6hgTdJBVqEhyry9AWmGz3gVuWoyAjiTh5gaK/6hnPFO87TLXqfU5aj1mH3GrMCiwg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7565.eurprd03.prod.outlook.com (2603:10a6:10:2c1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 17:08:55 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 17:08:55 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Thread-Topic: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Thread-Index: AQHYYy3+nqGpaE4GI0qiplW07al2UK0YWuaA
Date:   Tue, 10 May 2022 17:08:55 +0000
Message-ID: <20220510170855.tdpebk2fzycsjfwn@bang-olufsen.dk>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-1-hauke@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80dd2823-42f1-4d4c-60f5-08da32a7c429
x-ms-traffictypediagnostic: DB9PR03MB7565:EE_
x-microsoft-antispam-prvs: <DB9PR03MB7565C3E70EC13F5EBBFB689283C99@DB9PR03MB7565.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1I0SrJKrEF+oWuLmUP0pLDxsL5LcrAr7hqwdg2XnGXhV4SXZTZ3RZf+cUR7EX0PfS5tExR8MNkBpWyFAUXjymYcz7Xn1g+yes49OsFQRTKz5mfFRCLya9UmVOJA1yOvsqj4BY07QXX3rC2jJXR4cqx2G7bvdgp0SY64PiA+Phf7jrBnMQQAWzqzPJI3WO3ZvL+pieBqUmXuytzupMpScGzTmWZLvsdkBl2NyxE+Y2vJocxwjOORfqQBdClnvib9fn2YYkwYjwxYX9opHvHdVlpeDXQkM4P33qudZz47PN9h+hQsAjPLFNIhxgDklfytHdkLoYjrWDt1UIfdE/r0aduKyFmW6CZeAcAn86/e9TLKUNgWQvdSl4jAHm+65VbVxsufj5KZkQLGR3lkL8d9KRvi9xsfDfsgrJkAm7AmT9sxzuZrQrO8GWcJEd4ndIg+eSzlHk54Jsf7USAEwKt/988jnoj6YfOAVzpHvNoNNRaSMb+EEmS1L/nPobTFN4nDzKr4ygfYoaCyemJWlFSX1+kj1dRlk0w1lWnwSo7CI8UO3AvJmn82n5XWVXWYLAYp/hgXQsgTvfmS6LTUqNdfFESyt1TEq0cu6UXA8u1oJSBfF35boiaiLt5LD5oACTOkAuOyQ0us4pnYLWJ+qdSvmO0b9Yrcgb940Z8Coio70O46Im+rCTGj3RP0eQqHgtpqVetSIqfBaKi9E3z05DB/XJY3HyP/V1efb0HEhENdR5ZY6s4D5NuNvvRj1hsdQ/rBEu/mOzDrf3BSD2Q3IzJ94owzyxNntMySeYvoX9TdLeks=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(91956017)(86362001)(64756008)(66476007)(6916009)(76116006)(66946007)(316002)(66556008)(8976002)(54906003)(66446008)(2616005)(8676002)(4326008)(8936002)(1076003)(38100700002)(6486002)(2906002)(6512007)(122000001)(6506007)(26005)(508600001)(71200400001)(38070700005)(966005)(85202003)(36756003)(85182001)(83380400001)(186003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXVCS2tsemRlUG9MMDZvSEk1Q01LS3Z2eXpla05YMTZadkJHMUx5OUplNVlX?=
 =?utf-8?B?VER6NGZTV2ZqS054cy9VVUs5cTQralRvQzVubVRvQ2pCdzUvR1M0SmY0NHpv?=
 =?utf-8?B?bUVTMXhueUd4cDNFaDI0S3A4VVRoZkZ3bVBtUGlRNkcvMGlITnh2a3Q3YmVY?=
 =?utf-8?B?N3hhb3RwUlJ5OTlLMGs4VnFRR2ZjcTZ2Rm5iWE5WUnVLZjRpMWw4VjRHY1M3?=
 =?utf-8?B?L01oSysveFo5NzJpV2oxZi91dVJvMmdHNnpHZ0xyaEUySU03K0ZzaE8wTm5B?=
 =?utf-8?B?QnNwKzdFdDdpUC80U240ZXdXb0ZncXJnT1pTTnVFOEFQQmdSNjBrWFlvQThQ?=
 =?utf-8?B?SWUvNFAzRGxnRVdxRkRTQkx0NkNmUjVMY3BZdkRnOG9heU8yaXpPTjVuTVpt?=
 =?utf-8?B?UkdMNUxRTzFOSWVacnhvMzVDZ2N6ckRBWk9ic1JNUXo2ejZhNS9INklHQWU1?=
 =?utf-8?B?dTdOcWF2bHlwTlEzZGplY0JCWitpWFEvTStQRTJnV2U4V1V3UTQwTDB6aHov?=
 =?utf-8?B?S2p4UzQwU1pVbEtlYnJsTkNySnRkeXl3MU91R0kxOUZPN3BIRWp0ZHpTS3d3?=
 =?utf-8?B?RUthc1djSHRSOUVYZjdHZnN5WGxqNkxpV1dtZFgxeUJ2b29uOG9hU1RNMVBX?=
 =?utf-8?B?cU9ORUdlLytOMTJSV1hMcDVxT1ZrMUNCdzZqNlpUTXQzM1NVOTFqeTdsNWZ6?=
 =?utf-8?B?cnVYenpoOWxES3VZUHRVYU9rMytmRkp3blBVdys5THRHVUt5U0dSQ0tPZVho?=
 =?utf-8?B?Ulk2a3JMTWNHNVFmaXpOS0lSS1ZPa1Jhd2tMamE0Rk5nWUxhamlNa3krWDFs?=
 =?utf-8?B?WVN3K29jR1hxcjJLWmxXRjZvR3RaU296ZTVXQy91RzhyUGZrR0RrcmVhL1Jt?=
 =?utf-8?B?Ymw0QU9CT2Q4N0l2VnFGKzMyQmkvV3hBRFA2R0U5b0VnZGVSdng1RDNrRHFP?=
 =?utf-8?B?QTJQYnFxWjRVUVBhQXVNdEVYT3RxdlpJeXFzdWpnaTROYUZNQlR2aC83RkJ1?=
 =?utf-8?B?c1RUY0syMi9sRnNxeis0MmpFaVRJK3E4aFhsSSswcFBRRFdKOXdWZHpuVnpk?=
 =?utf-8?B?MWxWSUZTZVF4S2RQaktpeUcvdlhwYjdXS1BoQnVKM0lsRVBpNDBXY3owNGp4?=
 =?utf-8?B?c0RaMnNCamNXb1F5eEs2TCs2bEh6cXdaMTN1R09jVnEycGQ5cVBSUWN4Z2g2?=
 =?utf-8?B?M0xNcExGaUhwRHV5bnozQ3dKTlBDV0ZtYUJUUjk1MGdvUEJhNEhhb0hxcmto?=
 =?utf-8?B?UnB2YTNCZE5Fc01JYVduUkRjbFIvV25FbG54M3E5aDNPK2EwbkpWQjA2M25Q?=
 =?utf-8?B?d1pUT1VhTFUvcUhockJESENQZW1KdjVkLzFLVDd3MEIwRThJM0pXM3BwZ1V6?=
 =?utf-8?B?WDY5eHVhSlFKRkxBb0tpSXBEQ0p5VENOMnhIcjRkc213K3Z3NmJSemthQ001?=
 =?utf-8?B?Y3BMZDBQcm1JUk5JOGxqSlZNdlYyT0lpYi9FN2RGQTNDU0d4aUhaMm50Znoy?=
 =?utf-8?B?Vko0WTNaeEg5OXhGREpTUWc2dFg2bGhwbncxTDlndGZSQlhSZU1iYVl4djNF?=
 =?utf-8?B?WGgxR0EwUkxsOGFMcjN6dEtsN1BzQzRFdHhTRU1IZ1ZzNFJKS0U5cDNMNlAr?=
 =?utf-8?B?WVJ6T0JWVmdELzFJK3RUang4dlFYdzJiVWNpd1pWVlM3bWhaUWdQMGlPdmRz?=
 =?utf-8?B?aFVKTXZLaU5HMm9NSFoyZm90QnBGbCtabTI0OCtzSGcyVS85ZGxxeUMxN2N4?=
 =?utf-8?B?dUdPb0l1dkVmYWplVlNKd1N6Rm1Sb0RrK0lVZ01wanMzL0ZqcVN0dDNsTUtv?=
 =?utf-8?B?NFlHVWpEaXY4aDVQcWJVQWZTK1IrSlNJZFV3TXd2ZU91eWJHSm45RkVyMldN?=
 =?utf-8?B?UlJrSzZHZFE2NzBPMWF0aDJMYWlvcFZZZkhkZnBLS3Zmd2ozWHRGeVREdG16?=
 =?utf-8?B?OG9vK1NwZ0VZTytIdUVCRnFXV2Fpa2xrUXhoQitGR3dpT2MwSHVhSHB2YWRK?=
 =?utf-8?B?aXFuWVZ4R1M5OXlNeU5pZ1JkaGpwd1ZxVEdRY0w3c1V3bjcxeDVpQ3lLenp0?=
 =?utf-8?B?bWovNHNoSlBLTjNCdE85ZGdrL3lGOGNLcldZdzZSY3prcTIyOFZEcFRtTVlW?=
 =?utf-8?B?dXBlc1N1ZVd1cHM5aEZ1aFpmZUJGRkhWaXhCMEhDd05zVCt6V0M4a2wyejhB?=
 =?utf-8?B?RGdQdlJsWDJCMk14TldWSWh1YlFac3VBUloxdTNIS2VYNDg5aHpDWThkOC9N?=
 =?utf-8?B?a2xyeCtLRkwvTVE1MzE2MjQzREhnTVFuY2sydzZvMHl0UjVHQXdLUlVqZE1v?=
 =?utf-8?B?N1Y4bUVWSHpEV2czRDMzVW9VYWVHQjRaSHpiQTRZWWN0aDJnUVlFU29NRndp?=
 =?utf-8?Q?HsRxCX55OGjHwyZs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04C2249652408740A836E217620C1B7F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80dd2823-42f1-4d4c-60f5-08da32a7c429
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 17:08:55.8007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zYQiUHU11FgourS8y4CUaLyTjZrzBpb4XHCkonmyurRtqw/Qc2d6fQuUzUqjewWfoCERdkhBiTOpSz7xFpCPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7565
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGF1a2UsDQoNClRoYW5rcyBmb3IgeW91ciBzZXJpZXMuDQoNCk9uIE1vbiwgTWF5IDA5LCAy
MDIyIGF0IDEyOjQ4OjQ0QU0gKzAyMDAsIEhhdWtlIE1laHJ0ZW5zIHdyb3RlOg0KPiBUaGlzIHdh
cyB0ZXN0ZWQgb24gYSBCdWZmYWxvIFdTUi0yNTMzREhQMi4gVGhpcyBpcyBhIGJvYXJkIHVzaW5n
IGEgDQo+IE1lZGlhdGVrIE1UNzYyMiBTb0MgYW5kIGl0cyAyLjVHIEV0aGVybmV0IE1BQyBjb25u
ZWN0ZWQgb3ZlciBhIDIuNUcgDQo+IEhTR01JSSBsaW5rIHRvIGEgUlRMODM2N1Mgc3dpdGNoIHBy
b3ZpZGluZyA1IDFHIHBvcnRzLg0KPiBUaGlzIGlzIHRoZSBvbmx5IGJvYXJkIEkgaGF2ZSB1c2lu
ZyB0aGlzIHN3aXRjaC4NCj4gDQo+IFdpdGggdGhlIERTQV9UQUdfUFJPVE9fUlRMOF80IHRhZyBm
b3JtYXQgdGhlIFRDUCBjaGVja3N1bSBmb3IgYWxsIFRDUCANCj4gc2VuZCBwYWNrZXRzIGlzIHdy
b25nLiBJdCBpcyBzZXQgdG8gMHg4M2M2LiBUaGUgbWFjIGRyaXZlciBwcm9iYWJseSANCj4gc2hv
dWxkIGRvIHNvbWUgVENQIGNoZWNrc3VtIG9mZmxvYWQsIGJ1dCBpdCBkb2VzIG5vdCB3b3JrLiAN
Cj4gDQo+IFdoZW4gSSB1c2VkIHRoZSBEU0FfVEFHX1BST1RPX1JUTDhfNFQgdGFnIGZvcm1hdCB0
aGUgc2VuZCBwYWNrZXRzIGFyZSANCj4gb2ssIGJ1dCBpdCBsb29rcyBsaWtlIHRoZSBzeXN0ZW0g
ZG9lcyBUQ1AgTGFyZ2UgcmVjZWl2ZSBvZmZsb2FkLCBidXQgDQo+IGRvZXMgbm90IHVwZGF0ZSB0
aGUgVENQIGNoZWNrc3VtIGNvcnJlY3RseS4gSSBzZWUgdGhhdCBtdWx0aXBsZSByZWNlaXZlZCAN
Cj4gVENQIHBhY2tldHMgYXJlIGNvbWJpbmVkIGludG8gb25lICh1c2luZyB0Y3BkdW1wIG9uIHN3
aXRjaCBwb3J0IG9uIA0KPiBkZXZpY2UpLiBUaGUgc3dpdGNoIHRhZyBpcyBhbHNvIGNvcnJlY3Rs
eSByZW1vdmVkLiB0Y3BkdW1wIGNvbXBsYWlucw0KPiB0aGF0IHRoZSBjaGVja3N1bSBpcyB3cm9u
ZywgaXQgd2FzIHVwZGF0ZWQgc29tZXdoZXJlLCBidXQgaXQgaXMgd3JvbmcuDQo+IA0KPiBEb2Vz
IGFueW9uZSBrbm93IHdoYXQgY291bGQgYmUgd3JvbmcgaGVyZSBhbmQgaG93IHRvIGZpeCB0aGlz
Pw0KPiANCj4gVGhpcyB1c2VzIHRoZSBydGw4MzY3cy1zZ21paS5iaW4gZmlybXdhcmUgZmlsZS4g
SSBleHRyYWN0ZWQgaXQgZnJvbSBhIA0KPiBHUEwgZHJpdmVyIHNvdXJjZSBjb2RlIHdpdGggYSBH
UEwgbm90aWNlIG9uIHRvcC4gSSBkbyBub3QgaGF2ZSB0aGUgDQo+IHNvdXJjZSBjb2RlIG9mIHRo
aXMgZmlybXdhcmUuIFlvdSBjYW4gZG93bmxvYWQgaXQgaGVyZToNCj4gaHR0cHM6Ly9oYXVrZS1t
LmRlL2ZpbGVzL3J0bDgzNjcvcnRsODM2N3Mtc2dtaWkuYmluDQo+IEhlcmUgYXJlIHNvbWUgaW5m
b3JtYXRpb24gYWJvdXQgdGhlIHNvdXJjZToNCj4gaHR0cHM6Ly9oYXVrZS1tLmRlL2ZpbGVzL3J0
bDgzNjcvcnRsODM2N3Mtc2dtaWkudHh0DQo+IA0KPiBUaGlzIGZpbGUgZG9lcyBub3QgbG9vayBs
aWtlIGludGVudGlvbmFsIEdQTC4gSXQgd291bGQgYmUgbmljZSBpZiANCj4gUmVhbHRlayBjb3Vs
ZCBzZW5kIHRoaXMgZmlsZSBvciBhIHNpbWlsYXIgdmVyc2lvbiB0byB0aGUgbGludXgtZmlybXdh
cmUgDQo+IHJlcG9zaXRvcnkgdW5kZXIgYSBsaWNlbnNlIHdoaWNoIGFsbG93cyByZWRpc3RyaWJ1
dGlvbi4gSSBkbyBub3QgaGF2ZSANCj4gYW55IGNvbnRhY3QgYXQgUmVhbHRlaywgaWYgc29tZW9u
ZSBoYXMgYSBjb250YWN0IHRoZXJlIGl0IHdvdWxkIGJlIG5pY2UgDQo+IGlmIHdlIGNhbiBoZWxw
IG1lIG9uIHRoaXMgdG9waWMuDQoNCkxldCBtZSBmb2xsb3cgdXAgb24gdGhpcy4gSXQgd2lsbCB0
YWtlIHNvbWUgZGF5cyBzbyBwbGVhc2UgYmUgcGF0aWVudC4NCg0KSG93ZXZlciwgaW4gdGhlIHdv
cnN0IGNhc2UsIEkgdGhpbmsgdGhhdCB0aGUgbGljZW5zZSBoZWFkZXIgaW4gdGhhdCBmaWxlIGlz
DQpwcmV0dHkgZXhwbGljaXQ6IFlvdSBkaWQgbm90IGVudGVyIGFueSBwYXJ0aWN1bGFyIGxpY2Vu
c2luZyBhZ3JlZW1lbnQgd2l0aA0KUmVhbHRlaywgYW5kIHRoZXJlZm9yZSB0aGUgY29kZSAoaW5j
bHVkaW5nIHRob3NlIGJ5dGVzIG9mIFNHTUlJIGZpcm13YXJlKSBhcmUNCmxpY2Vuc2VkIHRvIHlv
dSB1bmRlciB0aGUgR1BMLiBJQU5BTCBidXQgaXQgc2VlbXMgcXVpdGUgY2xlYXIsIG5vPw0KDQo+
IA0KPiBIYXVrZSBNZWhydGVucyAoNCk6DQo+ICAgbmV0OiBkc2E6IHJlYWx0ZWs6IHJ0bDgzNjVt
YjogRml4IGludGVyZmFjZSB0eXBlIG1hc2sNCj4gICBuZXQ6IGRzYTogcmVhbHRlazogcnRsODM2
NW1iOiBHZXQgY2hpcCBvcHRpb24NCj4gICBuZXQ6IGRzYTogcmVhbHRlazogcnRsODM2NW1iOiBB
ZGQgc2V0dGluZyBNVFUNCj4gICBuZXQ6IGRzYTogcmVhbHRlazogcnRsODM2NW1iOiBBZGQgU0dN
SUkgYW5kIEhTR01JSSBzdXBwb3J0DQo+IA0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRs
ODM2NW1iLmMgfCA0NDQgKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDQxMyBpbnNlcnRpb25zKCspLCAzMSBkZWxldGlvbnMoLSkNCj4gDQo+IC0tIA0KPiAy
LjMwLjINCj4=
