Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B267597AAF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 02:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242477AbiHRAf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 20:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiHRAfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 20:35:55 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10olkn2037.outbound.protection.outlook.com [40.92.41.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2115A7233;
        Wed, 17 Aug 2022 17:35:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhObhCVFCr+1la65Gb0aiHN4ZPIIMQB+rBfPUjQbO903495Ib0XiVWc05VKnxLR4jNB+OxmyRGZRuDnmzVU494YnTrK5/cHswm2nTTbQ99gxrJ9dE/2Q9EZCgY0Oi5vGYjtjOSr0uEtuqtmChgRRdjxD5nKxH1gA0H3gA4p56MK40LlrM3d5PMZRmElSs8pteyZW8qY4k4OYKT5660mXaLatukbpT/WoVwwsLLdx38q54f4qoaDtMWr7zLpq23F1zzPCHuq8nOQJSu9i45nC7d3FpJyXJEBDrKPIKytgvu45p9mocXS0TkFsA4HM4VVYtjMyNbgkved1gjl2xfhGvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEI1JStEANaO+aOQ9wAbvzr5ZQFarw6qX+QNAB6sEns=;
 b=fhvoVCrp38B76COUmF2PVC372MdNPOH1k0aIip0SxtQG8YeNmyxL2+zb2GdqXu+2LNRjjKDCFeaV6K5bcBwY0PrbheGxnCVon10dEdUme21H1WaYuu8mu/gXUNuCT86nWKWNuK1Fl5xB2+wM2Uc3wkS0WUA8hzCaRwC28qYJv52WEL2cizVJq0LtAZGROc2VpvWwiyIN1rGwNJM0ep/cluBFFYLj8Br2cXNHq0zgZWgTmxP0j5s1XIfweXXVJmN9+qK3Z4nZ5XgvLwOkBeCuYJ0AS5bIhsRFMJKZlmt49f9Gqf9dDf89cgkCh9GMbZzwdVoCWRN/9QMw0DKOPSAOww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEI1JStEANaO+aOQ9wAbvzr5ZQFarw6qX+QNAB6sEns=;
 b=JxzhCNKI0BnoL5FZZmCI47G0Qkv03M7Qs3ibE9hYM0/rKnBiG2TVbkwxPhVOr3rQbLBVgjV8/sOlOiTbRelpd0x9SlXCJLxyG6WixwFcfrEqTPRuy3oV8vzNTnK1Exj7MAYAi9P4tB+jllwy3IAF5wLF2nuw43Q+TIkuATsT3SzhcODXfHM3mu+LJ/jHluRVQp4HSC7DjHa8qf0eV5R7kyf3ox+Eph1VJiu46vrDoxDZrTtW4O2QCnRS3BJtJQndCZF/zXkJIFm7jXathvgduPn/8Z4T6zhV0NYQVlYP8buRs4E/iO0vPqnXihfZSQfGAW1Du35Ryg5tKEAb+1m5RQ==
Received: from MN2PR15MB2622.namprd15.prod.outlook.com (2603:10b6:208:121::22)
 by PH0PR15MB5142.namprd15.prod.outlook.com (2603:10b6:510:12b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 00:35:50 +0000
Received: from MN2PR15MB2622.namprd15.prod.outlook.com
 ([fe80::2476:6854:fc5a:4d96]) by MN2PR15MB2622.namprd15.prod.outlook.com
 ([fe80::2476:6854:fc5a:4d96%7]) with mapi id 15.20.5525.019; Thu, 18 Aug 2022
 00:35:50 +0000
From:   Jonathan Chapman-Moore <jdm7dv@outlook.com>
To:     Paul Moore <paul@paul-moore.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "jackmanb@chromium.org" <jackmanb@chromium.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "stephen.smalley.work@gmail.com" <stephen.smalley.work@gmail.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "cgzones@googlemail.com" <cgzones@googlemail.com>,
        "karl@bigbadwolfsecurity.com" <karl@bigbadwolfsecurity.com>,
        "tixxdz@gmail.com" <tixxdz@gmail.com>
Subject: RE: [PATCH v5 0/4] Introduce security_create_user_ns()
Thread-Topic: [PATCH v5 0/4] Introduce security_create_user_ns()
Thread-Index: AQHYsMMXyK6PHfO+lkObpfzehugo062yExMAgAEiYkeAAA5JgIAAQuDmgAADiYCAAAxeS4AAAyGAgAAJZeGAAAJNgIAALcKw
Date:   Thu, 18 Aug 2022 00:35:49 +0000
Message-ID: <MN2PR15MB2622E8357FDB67B8222D47119A6D9@MN2PR15MB2622.namprd15.prod.outlook.com>
References: <20220815162028.926858-1-fred@cloudflare.com>
 <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com>
In-Reply-To: <CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [h1OqrPXj+ttbmlPl0gnm237a4Sjse7LF]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0e02009-49d8-4cd9-7ac3-08da80b199c5
x-ms-traffictypediagnostic: PH0PR15MB5142:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: impd1vfxHc8v220FL81xTzvgqtoBlkg4zP0B4qlfOZoqrm/kpJqGhHOR+aFmGvsjcsVwcFqF0l+qP0LQc4tD0OUv5kxtx5QxKKRQiGYLazu0+emOJzVhmNt88SU90wj9dqSrNEjxczqlmpJyRaOIbmhNhWRCmLXdoDPJH3lHC3N+AOncSwhhTKmqZIFVH/wSqiz56fI6S0W7GS2dCwdcbWQL/d8+KHo7J0htQGxR1k78bG2DsT7pI2BGE1GTQnWZmL8gfEIxWbAkASidX60QOm3ZdkGGBxwehZvH43EDXwpaYHtspxlvIpBVUzkeIlSCzVBuU4cup7BKbi+WyfNTWFRU3MOnKOq06m5lftNK7+dhqMx4Lt7EhWTy44gohE+R96ave0qozefVCzLCBm5Y7bf7NrnSDABD6ZrZ0qOSkz7QxspPlANTqR4GcypFIsNEP2m8TZZsZ/2zJANIM2EyPAFVap1vN9yW/yLzxwsuZYt150aUCbqJEvPqFX+Sw4Y9BlP9jN3U0KJjheQq7GKr0Q9h2gYM3fRtWA/QhuBPt65KAmDASzQT1Dedn/c3MKcuPhveRMivmuzrYcL9/MI1pba6lmkiuVVzJqqZ4U7BL0jyf0rIV/GKZ01q873ynKKNKiIk/KVC4fwoBduuaRI/gWjaPzTKKPSNDZLvvaEoJLGUCR3Z8PgkrwzNrtxLe6JI4nIE+ozOTICjjQ/98wx+nQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmNHQTVreCs3b2M1d242ZFhrazlseVFnUFRxa3lMWnVNbG4yOW1DMGZXaXEv?=
 =?utf-8?B?Y1ZFL1FNM2pZdnVKWUNDRk5DQXpsdEUwL0pDNmN1OEtVVDg4QU9IbGZ5NThs?=
 =?utf-8?B?aFdUeGxXSzNUQUswdUlEVFR0c1VTVXA1NTBCT21wdjlqNysydStWOVRScXRL?=
 =?utf-8?B?OVUyMXhxZ1cySllZQTdpY2lKekliVU13dUVFaEhYckhJRXhRMng2eDRWcmsr?=
 =?utf-8?B?TnJidGloY2JLenJtSkllaGNFck9kNVZPc2lWVnJLVDVrVjdZUHV6ZFRkOU9I?=
 =?utf-8?B?ZEozRlJQQ2JBdElXTm9kQmJkYWF2WllSSXkveWc2bld4cjNEVFdSd2VyN0w2?=
 =?utf-8?B?Sk8yWTRMdDZNS1BuUFNKN2RzRmtET1hEdWNNZk1mWkV5ZzB6OGFxZzhDTkNj?=
 =?utf-8?B?aU45VHBUZzBtT1RKdXY5MVFGNzVuc3RDMisxYjVhR0Q4WlNXRnQ2MDRjSGhz?=
 =?utf-8?B?M3YyMDNCcERpRXRYWUFrVjJUakRyakNIM05lYjVpSmM5UjNuWFF2c0tjWHpi?=
 =?utf-8?B?b2pYZnE0UDI2aXo5MGZHNHV2NjB0K3FpaVl2U0VUNnE5bmJ1cnYrVWtGZThs?=
 =?utf-8?B?cW1wVDFVcitCSWVjaVlQNXY4Qi9UQnk5YWZIUkpWTGNpUUgyL291SjJKZGZv?=
 =?utf-8?B?cXlGdkdobGUvb0xBZ0VMZ1JLYU13UnljK25VVHRBOXRGUmphY2UwdHc2ODlx?=
 =?utf-8?B?S1ZVTWwvQ2o1VWNwQzRVNEFQNmxuRlY1L1pFQTAxZEpYQjJ5TUJGN2s5TXZI?=
 =?utf-8?B?VWhkQktDUnh4SjB3ZXM4QXUwRDN3ZncvcitrTGhjVzhsMXcxYi9XbVZxU05o?=
 =?utf-8?B?dytnUUQreWFRbEc0ZG9FSjRlaU9DMTQxcS9NNFp5dnlvVGJ6eWNvYlFDNEFK?=
 =?utf-8?B?K1lra1hrL2U3azhXL3E1YVArVEVpR1AvTExTckZFMnZTaXNpYi9TdFdoRndO?=
 =?utf-8?B?WUtHYVRFcjdMRzJYRFp5b09JQXpwV3BYZ1VJSnZPcytncldWODhCYmtxcFpJ?=
 =?utf-8?B?eGU5L3Yra2lHMERmUlNGL1FYa1Z0WnRlbExCTFJrSy81YmFyUC9vNDdhb0RU?=
 =?utf-8?B?NEZ1eW9Xc1lVUG5NRElKMGI3S25WZnl4Wld0VE9lOEpVMzNYeXVBMHJFUENN?=
 =?utf-8?B?OHVabTgvNHZZQVlZNXVlZWM3VHU3RUJQdlR6Rkt2dzlQNkZ5WGo5U1BuanZS?=
 =?utf-8?B?SyttODV4WGNDck4vOGZYbGRzdnUraVBOeTlBWUVmaHltcU40TFFra25HNytN?=
 =?utf-8?B?dFRQRDhJUWtsMnpTeFI5eGxzc2E0YWd1d2l5RlZGME15NklUbXlKZ0ZCZUh3?=
 =?utf-8?B?b0VBeVBicmJpWTVYeTNaTy85bWZBVW5rRFR6WUdTSW51dXRTV254R3RhMFlu?=
 =?utf-8?B?NXMrd3FpUktPWmZUaHU5YTFnemtKNmNCZkdxazM2bGpybVRqeDdIdEVNQ0Mw?=
 =?utf-8?B?RzlYVGtIOHVOb20wYTdOQTRFVWNDMWprUWlhRFJ5VTI0L2xmbnJZUFBnVHNE?=
 =?utf-8?B?VEN3RGZ0M1dPSWQreXQvM3h0ZDRpaUNkYjcwN2FjVzZrOFFUcEw0TWpBaXRO?=
 =?utf-8?B?RUIyMExUczN6VC9Ncm52VGVVWjdJaDA2aTdYRTlZNkNHanJSdnVHT2VkUWNp?=
 =?utf-8?B?SHU1R1NMNUltWFBIZXVkT29sU2lOOGdmK01tVnAzc1RMTW1RclEvRVpxYmFx?=
 =?utf-8?Q?btzpxOtkAxoc5vYlr5Xg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB2622.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e02009-49d8-4cd9-7ac3-08da80b199c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 00:35:50.3456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClBsZWFzZSByZW1vdmUgbWUgZnJvbSB0aGlzIGxpc3QgYW5kIHN0b3AgaGFyYXNzaW5n
IG1lLg0KDQpKb25hdGhhbiBNb29yZQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJv
bTogUGF1bCBNb29yZSA8cGF1bEBwYXVsLW1vb3JlLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIEF1
Z3VzdCAxNywgMjAyMiA1OjUxIFBNDQpUbzogRXJpYyBXLiBCaWVkZXJtYW4gPGViaWVkZXJtQHht
aXNzaW9uLmNvbT4NCkNjOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlv
bi5vcmc+OyBGcmVkZXJpY2sgTGF3bGVyIDxmcmVkQGNsb3VkZmxhcmUuY29tPjsga3BzaW5naEBr
ZXJuZWwub3JnOyByZXZlc3RAY2hyb21pdW0ub3JnOyBqYWNrbWFuYkBjaHJvbWl1bS5vcmc7IGFz
dEBrZXJuZWwub3JnOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgYW5kcmlpQGtlcm5lbC5vcmc7IGth
ZmFpQGZiLmNvbTsgc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5aHNAZmIuY29tOyBqb2huLmZhc3Rh
YmVuZEBnbWFpbC5jb207IGptb3JyaXNAbmFtZWkub3JnOyBzZXJnZUBoYWxseW4uY29tOyBzdGVw
aGVuLnNtYWxsZXkud29ya0BnbWFpbC5jb207IGVwYXJpc0BwYXJpc3BsYWNlLm9yZzsgc2h1YWhA
a2VybmVsLm9yZzsgYnJhdW5lckBrZXJuZWwub3JnOyBjYXNleUBzY2hhdWZsZXItY2EuY29tOyBi
cGZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zZWN1cml0eS1tb2R1bGVAdmdlci5rZXJuZWwub3Jn
OyBzZWxpbnV4QHZnZXIua2VybmVsLm9yZzsgbGludXgta3NlbGZ0ZXN0QHZnZXIua2VybmVsLm9y
ZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
a2VybmVsLXRlYW1AY2xvdWRmbGFyZS5jb207IGNnem9uZXNAZ29vZ2xlbWFpbC5jb207IGthcmxA
YmlnYmFkd29sZnNlY3VyaXR5LmNvbTsgdGl4eGR6QGdtYWlsLmNvbQ0KU3ViamVjdDogUmU6IFtQ
QVRDSCB2NSAwLzRdIEludHJvZHVjZSBzZWN1cml0eV9jcmVhdGVfdXNlcl9ucygpDQoNCk9uIFdl
ZCwgQXVnIDE3LCAyMDIyIGF0IDU6MjQgUE0gRXJpYyBXLiBCaWVkZXJtYW4gPGViaWVkZXJtQHht
aXNzaW9uLmNvbT4gd3JvdGU6DQo+IEkgb2JqZWN0IHRvIGFkZGluZyB0aGUgbmV3IHN5c3RlbSBj
b25maWd1cmF0aW9uIGtub2IuDQo+DQo+IEVzcGVjaWFsbHkgd2hlbiBJIGRvbid0IHNlZSBwZW9w
bGUgZXhwbGFpbmluZyB3aHkgc3VjaCBhIGtub2IgaXMgYSBnb29kDQo+IGlkZWEuICBXaGF0IGlz
IHVzZXJzcGFjZSBnb2luZyB0byBkbyB3aXRoIHRoaXMgbmV3IGZlYXR1cmUgdGhhdCBtYWtlcyBp
dA0KPiB3b3J0aCBtYWludGFpbmluZyBpbiB0aGUga2VybmVsPw0KDQpGcm9tIGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC9DQUVpdmVVZFBoRVBBazdZMFpYalBzRD1WYjVobjQ1M0NIelM5YUct
dGt5UmE4YmZfZWdAbWFpbC5nbWFpbC5jb20vDQoNCiAiV2UgaGF2ZSB2YWxpZCB1c2UgY2FzZXMg
bm90IHNwZWNpZmljYWxseSByZWxhdGVkIHRvIHRoZQ0KICBhdHRhY2sgc3VyZmFjZSwgYnV0IGdv
IGludG8gdGhlIG1pZGRsZSBmcm9tIGJwZiBvYnNlcnZhYmlsaXR5DQogIHRvIGVuZm9yY2VtZW50
LiBBcyB3ZSB3YW50IHRvIHRyYWNrIG5hbWVzcGFjZSBjcmVhdGlvbiwgY2hhbmdlcywNCiAgbmVz
dGluZyBhbmQgcGVyIHRhc2sgY3JlZHMgY29udGV4dCBkZXBlbmRpbmcgb24gdGhlIG5hdHVyZSBv
Zg0KICB0aGUgd29ya2xvYWQuIg0KIC1EamFsYWwgSGFyb3VuaQ0KDQpGcm9tIGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2xpbnV4LXNlY3VyaXR5LW1vZHVsZS9DQUxydz1uR1Qwa2NIaDR3eUJ3VUYt
UTgrdjhEZ255RUpNNTV2Zm1BQndmVTY3RVFuPWdAbWFpbC5nbWFpbC5jb20vDQoNCiAiW1ddZSBk
byB3YW50IHRvIGVtYnJhY2UgdXNlciBuYW1lc3BhY2VzIGluIG91ciBjb2RlIGFuZCBzb21lIG9m
DQogIG91ciB3b3JrbG9hZHMgYWxyZWFkeSBkZXBlbmQgb24gaXQuIEhlbmNlIHdlIGRpZG4ndCBh
Z3JlZSB0bw0KICBEZWJpYW4ncyBhcHByb2FjaCBvZiBqdXN0IGhhdmluZyBhIGdsb2JhbCBzeXNj
dGwuIEJ1dCB0aGVyZSBpcw0KICAib3VyIGNvZGUiIGFuZCB0aGVyZSBpcyAidGhpcmQgcGFydHki
IGNvZGUsIHdoaWNoIG1pZ2h0IG5vdCBldmVuDQogIGJlIG9wZW4gc291cmNlIGR1ZSB0byB2YXJp
b3VzIHJlYXNvbnMuIEFuZCB3aGlsZSB0aGUgcGF0aCBleGlzdHMNCiAgZm9yIHRoYXQgY29kZSB0
byBkbyBzb21ldGhpbmcgYmFkIC0gd2Ugd2FudCB0byBibG9jayBpdC4iDQogLUlnbmF0IEtvcmNo
YWdpbg0KDQpGcm9tIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNlY3VyaXR5LW1vZHVs
ZS9DQUhDOVZoU0ttcW41d3hGM0JaNjdaKy1DVjdzWnpkbk8rSk9EcTQ4clpKNFdBZThVTEFAbWFp
bC5nbWFpbC5jb20vDQoNCiAiSSd2ZSBoZWFyZCB5b3UgdGFsayBhYm91dCBidWdzIGJlaW5nIHRo
ZSBvbmx5IHJlYXNvbiB3aHkgcGVvcGxlDQogIHdvdWxkIHdhbnQgdG8gZXZlciBibG9jayB1c2Vy
IG5hbWVzcGFjZXMsIGJ1dCBJIHRoaW5rIHdlJ3ZlIGFsbA0KICBzZWVuIHVzZSBjYXNlcyBub3cg
d2hlcmUgaXQgZ29lcyBiZXlvbmQgdGhhdC4gIEhvd2V2ZXIsIGV2ZW4gaWYNCiAgaXQgZGlkbid0
LCB0aGUgbmVlZCB0byBidWlsZCBoaWdoIGNvbmZpZGVuY2UvYXNzdXJhbmNlIHN5c3RlbXMNCiAg
d2hlcmUgYmlnIGNodW5rcyBvZiBmdW5jdGlvbmFsaXR5IGNhbiBiZSBkaXNhYmxlZCBiYXNlZCBv
biBhDQogIHNlY3VyaXR5IHBvbGljeSBpcyBhIHZlcnkgcmVhbCB1c2UgY2FzZSwgYW5kIHRoaXMg
cGF0Y2hzZXQgd291bGQNCiAgaGVscCBlbmFibGUgdGhhdC4iDQogLVBhdWwgTW9vcmUgKHdpdGgg
YXBvbG9naWVzIGZvciBzZWxmLXF1b3RpbmcpDQoNCkZyb20gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgtc2VjdXJpdHktbW9kdWxlL0NBSEM5VmhSU0NYQ001MXhwT1Q5NUdfV1ZpPVVRNDRn
TlY9dXZ2RzIzcDh3bjE2dVlTQUBtYWlsLmdtYWlsLmNvbS8NCg0KICJPbmUgb2YgdGhlIHNlbGxp
bmcgcG9pbnRzIG9mIHRoZSBCUEYgTFNNIGlzIHRoYXQgaXQgYWxsb3dzIGZvcg0KICB2YXJpb3Vz
IGRpZmZlcmVudCB3YXlzIG9mIHJlcG9ydGluZyBhbmQgbG9nZ2luZyBiZXlvbmQgYXVkaXQuDQog
IEhvd2V2ZXIsIGV2ZW4gaWYgaXQgd2FzIGxpbWl0ZWQgdG8ganVzdCBhdWRpdCBJIGJlbGlldmUg
dGhhdA0KICBwcm92aWRlcyBzb21lIHVzZWZ1bCBqdXN0aWZpY2F0aW9uIGFzIGF1ZGl0aW5nIGZv
cmsoKS9jbG9uZSgpDQogIGlzbid0IHF1aXRlIHRoZSBzYW1lIGFuZCBjb3VsZCBiZSBkaWZmaWN1
bHQgdG8gZG8gYXQgc2NhbGUgaW4NCiAgc29tZSBjb25maWd1cmF0aW9ucy4iDQogLVBhdWwgTW9v
cmUgKG15IGFwb2xvZ2llcyBhZ2FpbikNCg0KRnJvbSBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
aW51eC1zZWN1cml0eS1tb2R1bGUvMjAyMjA3MjIwODIxNTkuamd2dzdqZ2RzM3F3Znlxa0B3aXR0
Z2Vuc3RlaW4vDQoNCiAiTmljZSBhbmQgc3RyYWlnaHRmb3J3YXJkLiINCiAtQ2hyaXN0aWFuIEJy
YXVuZXINCg0KLS0gDQpwYXVsLW1vb3JlLmNvbQ0K
