Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E87A53BE22
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiFBSiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiFBSiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:38:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F81D388C;
        Thu,  2 Jun 2022 11:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwAYmpNCh0HQq5BRlQqHE2/pimfEq0tpHRncm/W6M6U4MdpbSP8LW68x1MmLv9QrsdW7fTJdvakzRQpc7HJ45/GhZHpKxAwr3ZnPAtmEPGeJKs3iMhhoh2VkMxxNJl9dYXyLI62g1XklHPKjolgy6VIlrz4Lhl62Twu6fNgsy8mX0i59SkCopPiLxQB8baYAIE4KTe0aEBqGiYxOCZnu/WVl3jppIyjx/JbLK+f7StW96yp4D3E1IYhwWx/NXeuL684k2dEaWlKtMcqQw+9wEJAqa3NtHagrSgbRQS/V3EhAwJX7V7ma450izbNDC2ysBqfPYvIBR3Gqqx29wHopnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJmIO4XcM+zOFV7XEpVLwgXKj6w1V4fKchVAO4agd+w=;
 b=BwuoVWMtqu5lJGZ4Q8gN1aroIer9BHHqUDrsU8Ap55Ffasz3eK9y6DWeTyMwBnW2eXXIb96glqXWrUCrBqoVOPafXwOEFsI9AOVktLYm+7h888bRACKCDOTZ+MxOmD+CCq2fPgL4COZnuovFkhpvOIzOdbxaZNV3CykoCSiysx3/ZeOdqbB4UTwVz0Mg6sqexK1EL5q/BowWDxdRzOpoFLGtyJMzfeEJANrEoNcBrKvA66sJjOvVF1QX+pRgdLSyAAZAKABV+k127kqs0CVemhAZt1QarNKmvll8Wgodnxv47BwDbUB9tsU6TeVmx1OEPB4zWy/iK1L2d1UBG9GCmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJmIO4XcM+zOFV7XEpVLwgXKj6w1V4fKchVAO4agd+w=;
 b=UOPvtlblwxVtdVgkUgxRMbmDiWa8EeGSMMqt4f8VP3IvuLxGf/tAD+gS+FHA17VjFDvw/utL7x/ZuUnGJaGgXUVOjJwI1em9zuQR1hqIyKoMb7MD7kQekMUemjOk6iz4hbs3HQJLu32sIItB4C02SX7bAnX9G+Mc8JNQG1nu/Uw=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by BN6PR1001MB2051.namprd10.prod.outlook.com (2603:10b6:405:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 18:38:16 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 18:38:15 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YCAAG4kgIAACD8AgAAI2QCAAATTAIAAC6cAgAADeICAAAgVgA==
Date:   Thu, 2 Jun 2022 18:38:15 +0000
Message-ID: <86a5400b2765f1cb97899ec91c5e9036fbdaf5b2.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
         <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
         <20220602085645.5ecff73f@hermes.local>
         <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
         <20220602095756.764471e8@kernel.org>
         <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
         <20220602105654.58faf4bd@hermes.local>
         <2390a40206f0f822569e6f55b8b7ae636eef7d05.camel@infinera.com>
In-Reply-To: <2390a40206f0f822569e6f55b8b7ae636eef7d05.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1695572d-550b-4bd3-7a47-08da44c70e6c
x-ms-traffictypediagnostic: BN6PR1001MB2051:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB205139C501C27158C8931566F4DE9@BN6PR1001MB2051.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Hg2NRbGGx2N2mMtvQqKtBPqOC9Hi/igSH4OlZAXk3+tqutjm2h7yY8q9V6YGOJYkWvvbGkIZ2L+wehlILnh1+RLPExyhu+b2v4LNITU3WsYME08VCz333h4Vea2p3ZDNyfqMDKdiKvp3QpF08EGWSA4ozh/Z1LB60rtSFxGitH9u8GRYxeaNQiVu2xRNFoZLmht3mymnvh5GiEKNSHqHWNnb49FMxDsCRAAgFPgxnXwsj6PENvHsm5oCnYALRAX52hujq6VpmB2ggRMnWrw0+R3D2bf3+kFnjxPgm27Fri/fY/dqUfuKGjGvt/AVT6IaqSoqhSBn7nlktWK72KfF30jIUZKyPu4vqUrY1bRpYQraBRo7JvPNNi3JS2nTJ8A9eBVmfktaY/rjT3I/oj9pLNZR1SmE7cOpX0X8kaLy731tm+nfRlbPPLVblAQwMegzsWL3dOWRxYr4QCATOQJbBokKTzTPbjoYWIcANi4cO7PNPiKIfcB/gPwkkAy9j3vyzxZ7RElG5plIFRXIGQQcSaKOQXOII3Ws7zyfxN1UiccK+JC7Ojz4W7WpwNdNPpo4mtrjYwDhWYbGchsnaS8B04XZsDxfQWmYgAWnuVBAWvHbipT0YModxnRX3BsOiQGMwNH9XqNQCcW7pg1aq1WMWTK7Li9pTZcCT88h6Qg7sbqsSzGtTZDuX+uZhIL4aIjeS/JpqCY+9TLkckSLqYJ6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(6512007)(186003)(38100700002)(5660300002)(8936002)(91956017)(122000001)(38070700005)(4326008)(2906002)(8676002)(83380400001)(76116006)(64756008)(66946007)(66446008)(66556008)(26005)(66476007)(6506007)(6916009)(54906003)(36756003)(508600001)(71200400001)(316002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXJrU1AzcW1relFBTHRVZ0EraDJjWHBTRDZRNEpGQ0xiL2l5RkhOUWZTMnhr?=
 =?utf-8?B?OEtBL3ROTXhtclhhUkpnWWk3Qzc3cUFUNFdkSmRJc3Y3aUh3SVQ5T3l3YWha?=
 =?utf-8?B?ZU9xR01Ec1FqVXJudVA0QmZ4ZEw5M3F6bWcwbnE3YnJydENTbGRLMkFLNkxs?=
 =?utf-8?B?QmJreE42aEllelg3ZkUrNXdmZGlyLzRrZmI5ajUzQTZ5dHdnSFNLM2xNQy9X?=
 =?utf-8?B?Ym4vZ05TeldENnNvSzQzeUszM2JPUGV6Z1JQaXBEdjBhTXdHU2pOZUZJYXUy?=
 =?utf-8?B?cjVyUlZJT2J1WlpKOHVHMEJxc3MwY3lreUJPYU40enM4SzUxTlFEaHJFWWNP?=
 =?utf-8?B?VGZoeERHM2s5MDlubThsSVFCMVdOdmNnUmxvNFFJM29GYm9QZFhtRjluSW5o?=
 =?utf-8?B?cURYYUY4WG5wUFVXMUlNbEMzZUpMV1NqUTFxbGczT2FsVEFPNnQ1NXdkV3hP?=
 =?utf-8?B?bXY3ZUROWjdVQjlPTlAxVUNCVUI5RDlpaGtqODFCYlE0bVNjN2oxSElaeVFl?=
 =?utf-8?B?aXA0RURtMmpDOEczZTBYQzA1NzNWSVVxdzB3Y3pIWm5QMllGSmpJN1VuNkFC?=
 =?utf-8?B?bjZVWWdma1dPN21YdXYyM1RDR0pOTSs3SzBRQXpOellyaEpPTXNNT0NoN3pi?=
 =?utf-8?B?bGlDdUhsZVpaVHE0RnRMRldvSnRsRGZVeFQrcTZleHVuN1ExZWVVbHJJdlhD?=
 =?utf-8?B?eURPa3pHMHNQVW9oekdXak9VSzFCeW9ZWXVJTWRSTWdVV1hXN1NES2EyaGxS?=
 =?utf-8?B?cC9DSTVlRktHWWhSM21KSjBLdHpFRU45T1NGVnBoVFJDdGRGbWxiWGlNTHBV?=
 =?utf-8?B?TXBHY3duZTFTcW5zWmIvSVQvOEFNZVNLVWdnc3dRUlVPeEV0T0wzTzBMc2hN?=
 =?utf-8?B?czRpTlNzOVJ2bEsyVVJ1SVE4ZGpqcnZPdFFKZzdwMGUwWVd6L0RyanA1Uzlu?=
 =?utf-8?B?MDNITjZFekR2U2dIZk5UbnlpUzRsMFljbXh3bzAvWnBpUTQ3T0xuNHN0azE1?=
 =?utf-8?B?UzlVaVVzRnhRNkxQWUJwa0h3bldVMGc0b2ZMU3dsZFFXL0t0U1NMSEFzVVc4?=
 =?utf-8?B?aCt0dFpFc1NuaC9kSHBRY3Vnc3k1OHVlSU8zcXZ0dTFkUmxtek9XdVJGaWN4?=
 =?utf-8?B?a2JQYXc0RERZMjZldFNscmRhNjl5VTM2VjhhYjIyR1Y0aVZXL1ROR1ZTd1FP?=
 =?utf-8?B?UWlUT2ZRWm04Y1NkT3o1d2ZWaEdJcllrMWo0OUhOUDJpcVRYRFJPZThycTdT?=
 =?utf-8?B?Y0NVaDd1Mk5reWx6b0RIQmpkQUNNYlc4Rkhpck9IQXRMNTdzNGNKUVNDcDVV?=
 =?utf-8?B?akpWdkZKZ2ErOXgvUk9FdDUyUjAxUHNSU0hJYnJjdWUwTmZLQWVQNGNpa0Zk?=
 =?utf-8?B?ODRkVTdkMkRIZVJWdVpSa2NUVHhmREJIaHJCd3hrZWpDMW1mRXdzYmplNFVE?=
 =?utf-8?B?elA4NVMwNmRZS1ZDYkZQUWIwdTBEdGtjVVQzTEZKai9oRWVuWVl1TzQ2b3hT?=
 =?utf-8?B?UmZEcHhkcmUyWDZnSFNGbHRRMHpmKzZETk0zcUg1bUZXRFQ5WGJYaXdtdnJz?=
 =?utf-8?B?UVBGVW9wcmova3B6RmtEb2JjRXNMVS9rcHdUWjZZa0J5dEtMY0VCVlN1YTV0?=
 =?utf-8?B?ZVh6M1l0dXBhcEViWmJERHBQRW5QN2xzb3NGQmVuTTQzcTROcTE2amNtYTNM?=
 =?utf-8?B?bXowM3pwaDBMTHAzOGVuMkR6NkVFUXJqcnlnVFNZN0VsSDRmSnhDcGlZdjZn?=
 =?utf-8?B?RkRZcVV3WFl4RVIwMkJ6dDdjOE1wNWhSa2pTYjB0NmtIckxncW5kQmdvdVpr?=
 =?utf-8?B?WnBWb3VEZ3c5TnpMTGJlaUtLU040SmhWVDBkS21WU1VvWjBXaWl1Ymt3N1NO?=
 =?utf-8?B?Q3YxWTMxcUlqVk40QnBrV25rNUpGdzBKd3lmYnJ6T3I2RHlRNUdxcXJvREpU?=
 =?utf-8?B?a2lXSGFkQ3N1ZEo0M2VXaVpRWHBSeTZDRlFEQkFnazNLeW4zUGxjS1RKYzdQ?=
 =?utf-8?B?RHJnT0pBblhEUXNZOHlTeHFQZVBTQkhDOXpMZ1lZeks2YStTUFZiUHVVWlV4?=
 =?utf-8?B?VVYrOTdsYUdDdkNRYzAySzE1YU1CQ0I5MHdxcVV3QmkxQXc0RWtJTWczM0RW?=
 =?utf-8?B?b05WdXRZSjAvNm9KZE0rSGlBVjRjZzhZclRGYis2cVI2RTBKUHRPM01PSlFn?=
 =?utf-8?B?VWRrQzM2WkkwczdWUjMyV2tkODdIYUpLQTh1LzlJZFY4b05WMjV0YVNjcFFC?=
 =?utf-8?B?RnZCV3lLeS9KMjNqVDBiLzhwL2o1NC9EQ2IxYUZJNVEyN1FVZ0xUUDc1ZXlJ?=
 =?utf-8?B?TkNqMWJrUzVjZUdMQ1I1aTROMytmVlVBOFg2ZU85OUxPaG9oUnhjRHpqZ0tR?=
 =?utf-8?Q?aTqZE5qXK0VdpQLk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E4B73290AAFCF41B065C5EB008A1E63@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1695572d-550b-4bd3-7a47-08da44c70e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 18:38:15.6892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bw63GypZyqKnHyQSk0FxylEiRrbaFPcEOYXd9eA1a33Q0stS4g8Dqfrj4L4radWes+JYlcNiuUMOY39Wc9GKnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTAyIGF0IDIwOjA5ICswMjAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
Og0KPiBPbiBUaHUsIDIwMjItMDYtMDIgYXQgMTA6NTYgLTA3MDAsIFN0ZXBoZW4gSGVtbWluZ2Vy
IHdyb3RlOg0KPiA+IE9uIFRodSwgMiBKdW4gMjAyMiAxNzoxNToxMyArMDAwMA0KPiA+IEpvYWtp
bSBUamVybmx1bmQgPEpvYWtpbS5UamVybmx1bmRAaW5maW5lcmEuY29tPiB3cm90ZToNCj4gPiAN
Cj4gPiA+IE9uIFRodSwgMjAyMi0wNi0wMiBhdCAwOTo1NyAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gPiA+IE9uIFRodSwgMiBKdW4gMjAyMiAxNjoyNjoxOCArMDAwMCBKb2FraW0g
VGplcm5sdW5kIHdyb3RlOiAgDQo+ID4gPiA+ID4gT24gVGh1LCAyMDIyLTA2LTAyIGF0IDA4OjU2
IC0wNzAwLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90ZTogIA0KPiA+ID4gPiA+ID4gPiBTdXJlLCBv
dXIgSFcgaGFzIGNvbmZpZy9zdGF0ZSBjaGFuZ2VzIHRoYXQgbWFrZXMgaXQgaW1wb3NzaWJsZSBm
b3IgbmV0IGRyaXZlcg0KPiA+ID4gPiA+ID4gPiB0byB0b3VjaCBhbmQgcmVnaXN0ZXJzIG9yIFRY
IHBrZ3MoY2FuIHJlc3VsdCBpbiBTeXN0ZW0gRXJyb3IgZXhjZXB0aW9uIGluIHdvcnN0IGNhc2Uu
ICANCj4gPiA+ID4gDQo+ID4gPiA+IFdoYXQgaXMgIm91ciBIVyIsIHdoYXQga2VybmVsIGRyaXZl
ciBkb2VzIGl0IHVzZSBhbmQgd2h5IGNhbid0IHRoZQ0KPiA+ID4gPiBrZXJuZWwgZHJpdmVyIHRh
a2UgY2FyZSBvZiBtYWtpbmcgc3VyZSB0aGUgZGV2aWNlIGlzIG5vdCBhY2Nlc3NlZA0KPiA+ID4g
PiB3aGVuIGl0J2QgY3Jhc2ggdGhlIHN5c3RlbT8gIA0KPiA+ID4gDQo+ID4gPiBJdCBpcyBhIGN1
c3RvbSBhc2ljIHdpdGggc29tZSBob21lZ3Jvd24gY29udHJvbGxlci4gVGhlIGZ1bGwgY29uZmln
IHBhdGggaXMgdG9vIGNvbXBsZXggZm9yIGtlcm5lbCB0b28NCj4gPiA+IGtub3cgYW5kIGRlcGVu
ZHMgb24gdXNlciBpbnB1dC4gVGhlIGNhc2hpbmcvVFggVE1PIHBhcnQgd2FzIG5vdCBwYXJ0IG9m
IHRoZSBkZXNpZ24gcGxhbnMgYW5kDQo+ID4gPiBJIGhhdmUgYmVlbiBkb3duIHRoaXMgcm91dGUg
d2l0aCB0aGUgSFcgZGVzaWduZXJzIHdpdGhvdXQgc3VjY2Vzcy4NCj4gPiANCj4gPiBDaGFuZ2lu
ZyB1cHN0cmVhbSBjb2RlIHRvIHN1cHBvcnQgb3V0IG9mIHRyZWUgY29kZT8NCj4gPiBUaGUgcmlz
ayBvZiBicmVha2luZyBjdXJyZW50IHVzZXJzIGZvciBzb21ldGhpbmcgdGhhdCBubyBvbmUgZWxz
ZSB1c2VzDQo+ID4gaXMgYSBiYWQgaWRlYS4NCj4gDQo+IFRoZXJlIGFyZSBpbiB0cmVlIHVzZXJz
IHRvbywgc2VlIGZpeGVkX3BoeV9jaGFuZ2VfY2FycmllcigpLCBJIGFtIG5vdCBhc2tpbmcgZm9y
IGFkZGluZw0KPiBhIG5ldyBmZWF0dXJlLCBqdXN0IG1ha2luZyBhbiBleGlzdGluZyBvbmUgbW9y
ZSB1c2FibGUuDQo+IA0KPiA+IA0KPiA+ID4gPiAgIA0KPiA+ID4gPiA+IE1heWJlIHNvIGJ1dCBp
dCBzZWVtcyB0byBtZSB0aGF0IHRoaXMgbGltaXRhdGlvbiB3YXMgcHV0IGluIHBsYWNlIHdpdGhv
dXQgbXVjaCB0aG91Z2h0LiAgDQo+ID4gPiA+IA0KPiA+ID4gPiBEb24ndCBtYWtlIHVubmVjZXNz
YXJ5IGRpc3BhcmFnaW5nIHN0YXRlbWVudHMgYWJvdXQgc29tZW9uZSBlbHNlJ3Mgd29yay4NCj4g
PiA+ID4gV2hvZXZlciB0aGF0IHBlcnNvbiB3YXMuICANCj4gPiA+IA0KPiA+ID4gVGhhdCB3YXMg
bm90IG1lYW50IHRoZSB3YXkgeW91IHJlYWQgaXQsIHNvcnJ5IGZvciBiZWluZyB1bmNsZWFyLg0K
PiA+ID4gVGhlIGNvbW1pdCBmcm9tIDIwMTIgc2ltcGx5IHNheXM6DQo+ID4gPiBuZXQ6IGFsbG93
IHRvIGNoYW5nZSBjYXJyaWVyIHZpYSBzeXNmcw0KPiA+ID4gICAgIA0KPiA+ID4gICAgIE1ha2Ug
Y2FycmllciB3cml0YWJsZQ0KPiA+ID4gDQo+ID4gDQo+ID4gU2V0dGluZyBjYXJyaWVyIGZyb20g
dXNlcnNwYWNlIHdhcyBhZGRlZCB0byBzdXBwb3J0IFZQTidzIGV0YzsNCj4gPiBpbiBnZW5lcmFs
IGl0IHdhcyBub3QgbWVhbnQgYXMgaGFyZHdhcmUgd29ya2Fyb3VuZC4NCj4gPiANCj4gPiBPZnRl
biB1c2luZyBvcGVyc3RhdGUgaXMgYmV0dGVyIHdpdGggY29tcGxleCBoYXJkd2FyZSBkaWQgeW91
IGxvb2sgYXQgdGhhdD8NCj4gDQo+IFlvdSBtZWFuPw0KPiBscyAtbCAvc3lzL2NsYXNzL25ldC9z
Z21paS9vcGVyc3RhdGUgIA0KPiAtci0tci0tci0tICAgIDEgcm9vdCAgICAgcm9vdCAgICAgICAg
ICA0MDk2IE1hciAgOSAxMjo0NiAvc3lzL2NsYXNzL25ldC9zZ21paS9vcGVyc3RhdGUNCj4gDQo+
IEkgZGlkLCBidXQgb3BlcnN0YXRlIGhlcmUgaXMgbm90IHdyaXRlYWJsZS4NCj4gRGlkIHlvdSBw
ZXJoYXBzIG1lYW4gc29tZSBvdGhlciBvcGVyc3RhdGUgPw0KPiANCg0KTG9va2VkIGEgbGl0dGxl
IGRlZXBlciBhbmQgZm91bmQ6DQogIGlwIGxpbmsgc2V0IGV0aDAgY2FycmllciBvZmYvb24NCndo
aWNoIHdvcmtzIHJlZ2FyZGxlc3Mgb2YgZXRoMCBVUC9ET1dOIHN0YXRlIGZvciBtZS4NCg0KRXhh
Y3RseSB3aGF0IEkgYW0gYXNraW5nIG5ldC1zeXNmcyB0byBhbGxvdyBhcyB3ZWxsLg0KaWYgbmV0
LXN5c2ZzIGNhcnJpZXIgYW5kIGlwIGxpbmsgc2V0IGV0aDAgY2FycmllciBhcmUgdGhlIHNhbWUg
ZnVuY3Rpb24gaXQgbWFrZXMgc2Vuc2UNCnRoZXkgaGF2ZSB0aGUgc2FtZSBwcml2cywgcmlnaHQ/
DQoNCiBKb2NrZQ0K
