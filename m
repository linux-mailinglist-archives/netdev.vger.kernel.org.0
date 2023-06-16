Return-Path: <netdev+bounces-11346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E78AD732AE1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A39F2280CD2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC77FD511;
	Fri, 16 Jun 2023 09:01:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183E6117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:01:23 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2120.outbound.protection.outlook.com [40.107.215.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF6835AB;
	Fri, 16 Jun 2023 02:01:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icBk+Jc4TSf2/v+42poUCORnkjlcDeguqCGxnJGOdBcfHMpQWA7GooayEHY+tOjanrincFa5hI7gsum+LNCkANd5jclVmxFdbSXJWeLrVhaFTy4b9CZ9DJZCETQQ3Bj7nGE8cNvm6pvI88gZ0lRYxcyIXZ96HxeCJk8zswU4v338GCNCWReuSgzFXEtUpVoK7mTj2PykEriCji3TAgIav8xXhQ56CieUYVSPGNtqC3XYdMbFWVTE++YSxg9WmkSuESgjsee//Ht7Q7uLMButBJyc9zfSPzGRrxFZ+877hi5XUIfkFooso9YTrAC4av4BSgTbhrLBsV0oyd6DAnQNiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDFfBA8OUFI0UVb4pJzgKR8tUYM9NHVsXmD+ZDs5qDI=;
 b=gEl+YC0qzBNguVaMKyaI/LOAG2yhDMbQEMTo7J9SEdk84mTSzVpRpsAPtK/nnk5YDicuQ7YT0lM9wx8UfbGt7+xfCFUorEq+57jBmaGEH2GNKxkXkdv4kULlyZOq1upTYBPvAlh2W0DOEXXQGSw8NZt9CAJS+6jeRC4OThVlMAFXTqufX67UpjVMqCvQJK3PNNv6tB5nW6kdl6rkgoCkrnALMVKW+8wa1LFTQpyBeTf7B/E8PMGvNgJ47HcXw7Vl14uc4E2Z58rE4RhbBrJWzDJmTIpm+6nXerWgsmMCRYidunIZr16AzJUliOoyTiwQ356wMzFi9xkXLb4gq6NeHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDFfBA8OUFI0UVb4pJzgKR8tUYM9NHVsXmD+ZDs5qDI=;
 b=ILiHIKbCAEA2jlKyNxq6HTKz4ulbNkwOgjg0XV7zrG0a7BJ3Qw1FxUhI6i+A9OdiOTCsoHEpjL6Oo4y9y5H8Cn3aqWmyB0rLFXPJ8Z433pX524BzVnJ824XhART/azgWRUR3pv1KH+ehO7Acm/sudw8K7QE3kPFg3VkNh5ty6ZSMdbcO59qS7N8mrznj+CYKM2OaXbG4DtxfRGRNQ3nCoWXZ/S/ME1VQoXqgo5tcr7Ep91HEpG42zYnSFbY8mgIwhPSXkPt6Klrzr9PqrrrhKjSosgFhFQr3joKBrwtHhvdFqFh8JJHKFPNCvZaQ3bV12wclJwSMQiVxlmTS0JFWzQ==
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 (2603:1096:300:78::18) by TYZPR06MB6191.apcprd06.prod.outlook.com
 (2603:1096:400:33d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 16 Jun
 2023 09:01:14 +0000
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e]) by PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 09:01:14 +0000
From: =?utf-8?B?546L5piOLei9r+S7tuW6leWxguaKgOacr+mDqA==?= <machel@vivo.com>
To: Vladimir Oltean <olteanv@gmail.com>
CC: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Stephen
 Rothwell <sfr@canb.auug.org.au>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, opensource.kernel
	<opensource.kernel@vivo.com>
Subject:
 =?utf-8?B?5Zue5aSNOiDlm57lpI06IFtQQVRDSCB2MV0gZHJpdmVyczpuZXQ6ZHNhOkZp?=
 =?utf-8?B?eCByZXNvdXJjZSBsZWFrcyBpbiBmd25vZGVfZm9yX2VhY2hfY2hpbGRfbm9k?=
 =?utf-8?Q?e()_loops?=
Thread-Topic:
 =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggdjFdIGRyaXZlcnM6bmV0OmRzYTpGaXggcmVzb3Vy?=
 =?utf-8?B?Y2UgbGVha3MgaW4gZndub2RlX2Zvcl9lYWNoX2NoaWxkX25vZGUoKSBsb29w?=
 =?utf-8?Q?s?=
Thread-Index: AQHZn1fmHrSmLcZ3zUeJPBQqdyR+uK+L1M6AgAB+uoCAAFLYUIAAfFuAgAAAepA=
Date: Fri, 16 Jun 2023 09:01:14 +0000
Message-ID:
 <PS1PR0601MB373719C6D7789B7BDD05AEC0BD58A@PS1PR0601MB3737.apcprd06.prod.outlook.com>
References: <20230615070512.6634-1-machel@vivo.com>
 <ZIsME1gwEWEyyN1o@corigine.com> <20230615203649.amziv2aqzi3vishu@skbuf>
 <PS1PR0601MB3737C84D2AF397AB8B4E9207BD58A@PS1PR0601MB3737.apcprd06.prod.outlook.com>
 <20230616085825.7tuz4ryp5dn7zims@skbuf>
In-Reply-To: <20230616085825.7tuz4ryp5dn7zims@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PS1PR0601MB3737:EE_|TYZPR06MB6191:EE_
x-ms-office365-filtering-correlation-id: 770dd785-6dd1-464e-3cee-08db6e483cfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 k5aKopCjXEOzY9ze9VpbjMnm/MSZufoz/4LPBS+RxStRcId9o7PxVCdamSMi9dkT9pZMvbAHZuf8SLO2jIB68aiGT/ZYBD45aAQh0wjQn3EpDu8nHUWIIKWlR7JGqNO2dRso8r5Ib/r14mJQOgvVtERjVYNKKgLnZh7bux97uy7WhnI7xpeYPmF5Xh7us6IVI0MOycExOWk/hUEQPrufH5nt5SrKA3Q40+XmgpBghpzwJxlnjCyUKaxgmgQ+cQ7dQ/MnvTUVbfDbkvTXq3Z0zbl2WcaTUdVjlE3+Np4N9hEcep46ZpCsnC0yeiPpfUHxW3vm9aGuJaqT0K8VtvrRNc0pA8RsuTOhDql8ekL/rbIKKdjKh2nJm4FVDYKuKYO4dV8rTJ85Ki8NERhwvkXSFClqE/o9bO1iX5nhUpTR76CLy0gyuYZpJM4fMCdTocNjCUaofWFyp8FiNHbheOGzAue5MIV97UoG77cfxKC6mSDIDEgQPGXou//2GwzZOAAao4g4RLGbl9vczCjQsPgnt8fkuDdIUHsDpunOnhQf5cn8W+dCRDqBAJiVo6r2+sbntTBZfujyusHrZZvRiox04b7OCAyEGr6ZeSDOOHIILToc/BCRX3wtHaBi0OKiwpFC
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB3737.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(39850400004)(396003)(451199021)(478600001)(71200400001)(7696005)(66556008)(66446008)(122000001)(4744005)(76116006)(2906002)(64756008)(66946007)(66476007)(86362001)(55016003)(38070700005)(85182001)(5660300002)(8936002)(52536014)(224303003)(4326008)(316002)(6916009)(41300700001)(33656002)(38100700002)(7416002)(54906003)(107886003)(9686003)(6506007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aitMYlZUalYzWnBaQTJOWitQR0NFbnM3dXdzcFFQNXFQRzl2WENrTkFlOEdH?=
 =?utf-8?B?Ly9NckdHNWpPWXNBbm0yM1NtVWN1WEVTdU5pY2tDOE0vOVJPRUJTcU5pTEkz?=
 =?utf-8?B?RGV4NUlDTUZDd2NYSThXamIvZll2SW9XUVNMY013RnRKNkxYd01ib2xYTG5B?=
 =?utf-8?B?OXZZNDJqaGlWOVlQY0ZyTSsxSTA2RWpkVjRUMkdZQVM5dGVsQ2wyVVdvaW0r?=
 =?utf-8?B?ak1XWmdFcW95bkg4YUZ0Mzg4V2dFWkhMc3VoVkNoWmxqRWVkR1VSYXlXUUxr?=
 =?utf-8?B?em1sZ2RrM2xEVlUvUVhRVVBid3ByYnFGelhOOUpoZGs0cUl5b0tqR3pxWlEy?=
 =?utf-8?B?Q0kyMEl6Y09MMFE2aExaUEFDRVBPY21xTGZoQ3BnT21OK3dWTTNkUHVkeWdK?=
 =?utf-8?B?L1FPQVdqMytQR1hwQkFkQ25UdVR0VFg5ejFEd1BoSFlUenB2U3RjVEZ0UnFK?=
 =?utf-8?B?dGxRWGlkb3FFc0Z4Q3BlTmFGQ0VGOXhDMzhrRXoxNHJxL1dZT1NKTmo0bkhz?=
 =?utf-8?B?djhrNkJUMkx6bG5USVM5UC94TDVIb2ZGTUxvd0ppQmcrbllidGoyVWdSbFN5?=
 =?utf-8?B?NzVNZXFnSDhUbGRtMVZqQ3FIOUNCNDJlZldZWDNvZXRQbmlCNjA1dDhSczJo?=
 =?utf-8?B?NGNmTnNsSE0zR1ovYko2NTBYdGtuQm1aRWNCeXN5RExHYjNLSDk5aDVnbXhI?=
 =?utf-8?B?QkJIb3JUcDBIZ25xTmMva2JWWmVXcmE0c3Zqb1pFMWFuSUdwTjR6V2MrSktY?=
 =?utf-8?B?cGpGS21XMzdrY2xtcW5adWpUZzB4VUN5aUJJODdTeVJ6VlEyaDNyMFhvcjh6?=
 =?utf-8?B?QURjTGJRNnlyb1JoN0lNeUgxbXVTRS9mb2JWUm5nR0EwYzlQc3JaK3JlM041?=
 =?utf-8?B?bjBKOVVYaldUODhOeUNCSFRMcXVsS0ltTmM3RUVrbm5nb1FiVGxvTmZEV1lx?=
 =?utf-8?B?T1FyVWJSYXhjeE4rOTAyamtCeWkxN2NhVFgvQ3I0SHMyQ2haWUV2dDM3Vlor?=
 =?utf-8?B?b2o4UHdkN3FzOHZuaDNmZ3hzQVZ6RlR4Y0h3QlNIU1FpUHhUemVkbm1tMXo3?=
 =?utf-8?B?UmJYVHoyeVRRL0V0bVRudGptNU1hSzNkYll0YUp6eUhyRkx5eFpOamx5TFZU?=
 =?utf-8?B?eFZlcGhoRXhMaWFiOHZtd2cvV05oLzhEcU5ldFFDOHhqVXc4MWF0Z0pVNWtC?=
 =?utf-8?B?NjVMR3k0NytZcnVpUVIwU1NvZ3E3eGVLM1I2TTdvMWdYTjJObTRud2I3bklO?=
 =?utf-8?B?ZEpDT2o4a3NZRlRBZzI1cjNYZjdLNTYyZEVEY21rMUlQWjk0ZGRwUGwySFUx?=
 =?utf-8?B?NjVpUHR6SVU5YXZBYjdKV0J3VTNrQUxpUkhVdGlQdUhqU1Z2dGpVMC9MUDlJ?=
 =?utf-8?B?VEhRM0xiOEd2MTdzS1ArVDZwekdNdStZc3R4ZVRjdzFVMmYvdys5SjR6cUw5?=
 =?utf-8?B?OHgyQURESkxBa1FxcUswd0JqazV0UC8wcVdkUnNZVDJGdzFyNkx1VnJ0NldI?=
 =?utf-8?B?eHpLUC9EazRwOTVQRk5FcGNnRE9iK0VyTDEzMVZYYWoycWhEdDFKZysvRWtT?=
 =?utf-8?B?NW1lWEV4cHZpS1loRjF1cFI4WU1KaWtKbTFOckh6L1RWSUJqM3VWSW5nRStT?=
 =?utf-8?B?Wlg0MlVxdFR0b3ViVzdEMUMyYldLOFlIMGFCZUxUdUVkVUVBdTJsS1lqUDVz?=
 =?utf-8?B?Yng1WlJCV2tzQlVuZlo3ckxlRU5XWjlycDhDWGhVejdUbWRESDRoRFg0ajd4?=
 =?utf-8?B?TVdUQU1iSCtPTGRsZi9aUU54ckNDMjE2ZHZBN3VwV1Y5cVphZDUxNHBReHFr?=
 =?utf-8?B?M3NIeVBUSWFJVVpaMmhKNTdCdG9oNDZxckc3OVBkTWVPbG5DWUpmdk1ERlgy?=
 =?utf-8?B?L0FRMVBGTU5CdGdEOFFWZEd4d0VkNW96QkJkazFnczZabWRPbGI0RWRqY3RQ?=
 =?utf-8?B?UFExYVRmclpiRGpZeUMwYWNTYlBCN2tjU0IyQS9pZUNoazg0U3UwSnNGTHJH?=
 =?utf-8?B?ZlVBc1FWUkxYbVRBcTRhVGpMdSt0cUFyZnV1cDNMaVlFMDRDNVpBSkVNL0o1?=
 =?utf-8?B?elpHbkxLcEI1ZVd1a1RmNm96a0hNVjl4NTNMYjI2YXQrQklHQmFwODJESzZu?=
 =?utf-8?Q?o56M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB3737.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770dd785-6dd1-464e-3cee-08db6e483cfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 09:01:14.2633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4tcW11FASjaqwE5I2hzjNMPxKHpwRY/8jbk+q9mC9jF33sYXeTtXA/lzOhZLVaNpiABjIjZ45zw6SnoCpirfOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T2vvvIx0aGFuayB5b3UsIEkgc2VlLg0KDQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bk
uro6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+IA0K5Y+R6YCB5pe26Ze0OiAy
MDIz5bm0NuaciDE25pelIDE2OjU4DQrmlLbku7bkuro6IOeOi+aYji3ova/ku7blupXlsYLmioDm
nK/pg6ggPG1hY2hlbEB2aXZvLmNvbT4NCuaKhOmAgTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5u
LmNoPjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBEYXZpZCBTLiBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2ds
ZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPjsgU3RlcGhlbiBSb3Rod2VsbCA8c2ZyQGNhbmIuYXV1Zy5vcmcuYXU+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBv
cGVuc291cmNlLmtlcm5lbCA8b3BlbnNvdXJjZS5rZXJuZWxAdml2by5jb20+DQrkuLvpopg6IFJl
OiDlm57lpI06IFtQQVRDSCB2MV0gZHJpdmVyczpuZXQ6ZHNhOkZpeCByZXNvdXJjZSBsZWFrcyBp
biBmd25vZGVfZm9yX2VhY2hfY2hpbGRfbm9kZSgpIGxvb3BzDQoNCk9uIEZyaSwgSnVuIDE2LCAy
MDIzIGF0IDAxOjM2OjQzQU0gKzAwMDAsIOeOi+aYji3ova/ku7blupXlsYLmioDmnK/pg6ggd3Jv
dGU6DQo+IE9rYXnvvIx0aGFuayB5b3UgLEkgd2lsbCBkbyBhcyB5b3Ugc3VnZ2VzdC4NCg0KQW5k
IGJlY2F1c2UgdGhhdCBwYXRjaCBpcyBpbiBuZXQtbmV4dC5naXQgYW5kIG5vdCAoeWV0KSBpbiBu
ZXQuZ2l0LCB0aGUgcHJlZml4IHNob3VsZCBiZSAiW1BBVENIIHYyIG5ldC1uZXh0XSIuDQo=

