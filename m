Return-Path: <netdev+bounces-11258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F4A7324B4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D57CD28158A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD84629;
	Fri, 16 Jun 2023 01:36:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADDE627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:36:53 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2127.outbound.protection.outlook.com [40.107.215.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053B4294C;
	Thu, 15 Jun 2023 18:36:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKD0tUxajYdm/4i2Fbc2xdjjIpyXnY/Loz0oNi9YafBiwv0fY4Qk5KPnXadsk8T628EzQL3lxh6ImEu3xX/TRa661u2MCttJekg7xlLLjB+/Mi/UjWaNBkaFihqQcp4PJBjP3RlxzT7CRMvfzMWfT06r4SN/+Jbd0pqwKolZ/LZ/euJeCuATIwNFKyh1mp8J6rXnp1ThGb38sXBAtZo2BZHszH+Cv/j8gAZEt+553T45lN3Ua08/xVxRT5LzTaYj+04zQLnDc+KALUSHf9fxnvY19JRi22f2UzcinBbn48rtWVJVsmzfNtQE+HvLLGBegJHKKOFbu2xjlMMAjyerfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6X5lLRwlGaI3wpftMoiHf1aKXDIz8SN+FaOT8RWcn8=;
 b=gF4SjhM53X14527nFBq4GaknHadlDC364J0brQFHDcixx6apk2gQ7XG5kIAjjq1+RdmROvfmfcIdddw5UVJhdYsyYS7kGxrvvelbLOutrhf2nOlAlGUosIonKmL+zihhDG4E0s+59rKK+6XGRy/t+QIIFzMCQafsKIrqgBWNpGhpXdYcUXS6FPbKTTzzSF8+dldtDT/zAu2kzkp79Dpb5C5+dSkhboQXuukUmIsrj6RJ8VjCjiq7GUq2Abzv/HYX9H8ePWhfoh2g4VqOEUzgeZiTyPEJNWs1QUgtqXbPNL8viSlL6feVuTOI6sGsAK5wtL+npYB+6cR/cNwIkV4/kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6X5lLRwlGaI3wpftMoiHf1aKXDIz8SN+FaOT8RWcn8=;
 b=ZU8sukLJEaM5ASgM7j9oYwO3uXjjTsZHNXdfG0wyO+DuPC5bDQVWRMtruJ0rG4rYSwDoMD60IFyqoCyX4L72HV8/McYarIWy+puvwQSYxyRo+ECfz9K96pP96KkWM/aRqMJtY31gnMNx4So6YMo2/cnUEuip1Jq+fyp3qBazXXu6P/uPWSTQoNhU9OECBQPPshFuz/McPXQpvTYAGz/XomXJ1yVkwx+6CP5GdwrYCy6Pe9a7HWXBuYhL4TYN1PDoLVap7Qp/yKCoQrnSepUT6XD8Tu0lUS98rCbs6jys+ZtCiAwI7gBJwauJaEHt8CP/RBpJoASRYqtFDQScMEftEQ==
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 (2603:1096:300:78::18) by SI2PR06MB4994.apcprd06.prod.outlook.com
 (2603:1096:4:1a1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 16 Jun
 2023 01:36:43 +0000
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e]) by PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 01:36:43 +0000
From: =?gb2312?B?zfXD9y3I7bz+tdey47y8yvWyvw==?= <machel@vivo.com>
To: Vladimir Oltean <olteanv@gmail.com>
CC: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Stephen
 Rothwell <sfr@canb.auug.org.au>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, opensource.kernel
	<opensource.kernel@vivo.com>
Subject:
 =?gb2312?B?u9i4tDogW1BBVENIIHYxXSBkcml2ZXJzOm5ldDpkc2E6Rml4IHJlc291cmNl?=
 =?gb2312?B?IGxlYWtzIGluIGZ3bm9kZV9mb3JfZWFjaF9jaGlsZF9ub2RlKCkgbG9vcHM=?=
Thread-Topic: [PATCH v1] drivers:net:dsa:Fix resource leaks in
 fwnode_for_each_child_node() loops
Thread-Index: AQHZn1fmHrSmLcZ3zUeJPBQqdyR+uK+L1M6AgAB+uoCAAFLYUA==
Date: Fri, 16 Jun 2023 01:36:43 +0000
Message-ID:
 <PS1PR0601MB3737C84D2AF397AB8B4E9207BD58A@PS1PR0601MB3737.apcprd06.prod.outlook.com>
References: <20230615070512.6634-1-machel@vivo.com>
 <ZIsME1gwEWEyyN1o@corigine.com> <20230615203649.amziv2aqzi3vishu@skbuf>
In-Reply-To: <20230615203649.amziv2aqzi3vishu@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PS1PR0601MB3737:EE_|SI2PR06MB4994:EE_
x-ms-office365-filtering-correlation-id: 67d9871b-1c1d-40f9-2125-08db6e0a23be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 lxE75AdN3xL+VsHvLWkGgAwKcWtDVMDHbwLY5+ra6Ps1njdrrH9X0kbYHrQ8niSgY36VP+v+1UrtWCJ9N4ebg8EYiW/YlFoV2kWCBL/E19l9yKDSR0rCEdz5ERPWjA7qj5KbrZrA2MKwwNN0SgqmlROdV1Co15X64++iI8UjBKDpFYgL1u/4HTorkTGvtQL4CaaLAi3VyUKogz9CKPOzMs2Wuc1XoKbQ7a4bMaB0Y4L6owtQVg3W1vYYSfotCWeiiMaVhdeMZyFd7mdQgmuR+NXTQfVEVsNMOM6NvJ0uNeunBQgmYLX7hVPwHJToDDiV0LYfTKvyvYCQw2AGslz+ZGkrCKHJWx9D1oi0s4s5a0NfIGM3YRA5SpzfShmvXc8uBk6jRKlTW2zTNtA0BCPhoh/KBFASDqBteSnl4CsWGXVmK34BpYaSk+qRahiNVJjOqu9jiU5n+x/qMu8hHTR7bw14AicazABvU18vIuay7D02pWNQ4JU9XJgwcb8rpOwKlfR239Paiv9HYu/MJDh6CRxXc6DNfgENSi6SplpJTAgxQ8I+BeYU45u3NzBENSmFHGWLQawGJpc7D1jN3F0EHFVaDdH1nt44c3bGx0g6aXQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB3737.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(316002)(2906002)(41300700001)(478600001)(64756008)(54906003)(7416002)(52536014)(66446008)(8936002)(71200400001)(5660300002)(66556008)(76116006)(6916009)(66946007)(4326008)(7696005)(66476007)(107886003)(6506007)(26005)(38100700002)(9686003)(966005)(55016003)(224303003)(186003)(83380400001)(38070700005)(85182001)(122000001)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?VVlkb3dNRTlsUDd0ZGRoSHZrbHh0Tm9XWmlJc2RLM2p0eVZhekdCN25GMkF2?=
 =?gb2312?B?cUhUcmNUVGQ3YkxTYUVXODRaZTNSS0lKZkNFUkFtL0xOY0lyYllmaE0wK3Rz?=
 =?gb2312?B?NmJtK08xNW0wb0NjWjJBOGlTWmZYdHlGVDQ4RlRWVDRYWDFsOUZyYmlyMHhv?=
 =?gb2312?B?dXhhQiswOHNWWFgxazk4bFl2RmhMd2t2Q3E3UkFQUzlCb3Q3cENTdUZWU0ox?=
 =?gb2312?B?OFF4TktKNmZTNml4Z0xLSHd0cy9xVGtPTTArYjc4VXJUclpkL1JFc09SRzNF?=
 =?gb2312?B?TTFLb0JLQThWY01kb3BXQVp0bzU1VUJhMDBLampFUHBIalVGQTNNVUVHbkND?=
 =?gb2312?B?RkRhZ1FkdTdySHQzN29kTnVnL1lFeTk4ZjJVVS9hdFZ2N3p1UVVtanF3eE8x?=
 =?gb2312?B?MnhmTCtWYXZoVnJ2ejhiZndJVzY1L3dGOEhKOWNMSXlmaFdKclZTRVFsamJ2?=
 =?gb2312?B?dXR5cU9oOUdxdXo0c3N0U1Eva3czRi9RNlhZSnVoUUJSL3JuNXBGeS9UK25X?=
 =?gb2312?B?aGRKOUgvL2NBNDI1azlrcjJxNHV1ZTdIdVVWWnN6RTJNL3VDU1RsV0lvL3BY?=
 =?gb2312?B?S1hCT3JyK1FrMW5EdUsrTmIwSHdZc08wZzBQR2Z6NWVrcjBDNVhhaG1RK20x?=
 =?gb2312?B?M04zcVhLOTRaRVJBUm83YU1yOWR3N0x3bGE2SFFxVUhxSHR2WTgwSW91QXJh?=
 =?gb2312?B?QVlHa0VJOXNGaVdwQjVlYjVoNE9hK2ZaMTd0WjFieWJlUGF1NmlRa2I5VUFo?=
 =?gb2312?B?S3R5bjlkOVMwWTRKSWlCczZpL0dJb25SdzZ6bmFyUzBkUkNhVVE2aVRvdmU4?=
 =?gb2312?B?K2x2WE03T1o0V1prV3k4TndhcG1uWHkyMzdxdHB5aitYd3pGUlpGMVV4TXAw?=
 =?gb2312?B?dm84MVpzL3gwT1Y3K0E0dGRhQ0NGaFI5Z09YbFVYMUdHQ3ZSTmQ0NzJVSGR4?=
 =?gb2312?B?Y3pBNlhDbGR3TGdVVmNpTXV2akNySU1UblpIM0kvcUdKOG9zUEZWM0srNDd4?=
 =?gb2312?B?dVM1dFJrU01zU0dWR0c2bHhydC83aCtPZ1o4YWl5MnU0TGdLdzVadU1sYkJT?=
 =?gb2312?B?Qnc0c3FqM0lYa28vSnlabE1BSDNuU3BFLzZhTW9HK0YwSHZkQzdTeE9rUVNt?=
 =?gb2312?B?SXVwWWplODQ3aUN2Q045cDRvZ2VkdlphSTNQQ082TmdnZTV6TzUvQThZZ21o?=
 =?gb2312?B?b295R0dsZkEyZk9GWmtsZkhSN2pFU2RtMjh2ejZpYUlsZGc1THlxRVFMQm9z?=
 =?gb2312?B?VHZ3MEMwbU5PTm1ncFFBMTl5aDdISThUT0Z6bmg0RDJBS3JaQTJzRkEzMHZI?=
 =?gb2312?B?RFhqWWM2cFBQRC83NGM2YWdPbTNzMUZGc0wvT2p6eGdORFZUSnJNVXRrcDBC?=
 =?gb2312?B?VUhqV25rVmdIMHRYWnRTR1laOGFoQTMvTE1lSDZPMS96V3k2QmFZVjNRaTBa?=
 =?gb2312?B?MWtVbHhVaC9xSEJHcmtFQ1NJcHdJZEFiaVV3L01rUzFZZ0phemZTdTd2WFl6?=
 =?gb2312?B?OHpCc0tlSFpLaHlGbjFvWkVTcGhXVzdBM2ZxQnJRbkFNbEtLQzE5R3A0ZUdn?=
 =?gb2312?B?MGFqVkFYRS9pdWZPdms4cEppYjdxR2pnSXhPQlVLejlpc2RlcDNUMWxZOTZu?=
 =?gb2312?B?MjF4b3plL2hvblZsQjBrNm1oN2daVkJoMXZYWlc2NjhnM2dhZ0Rnd2tlVDlM?=
 =?gb2312?B?RmZFZnp0QTN4b1RlQXlhZkIxd2hhem5TN0t0aDJCMFZvcHpUa3N1VFovRmJH?=
 =?gb2312?B?UGUxeERPNERDV3RPK2JTMnY0clcvNzM2S3l2eEthOE9FMEw5UXBBc2cvVmtJ?=
 =?gb2312?B?ZnBGWVk2a0pyQWhZOTcrc2h6dnYxWGdsZ0FJczc4elByeTY5TW9FVVdtVVNw?=
 =?gb2312?B?dm9EZWZKZVJONzVUazFzNDFySXdDNTRORy96MkV5ckY4cHAzVHVEQjhrdXBM?=
 =?gb2312?B?V2ZxRUZQZkRmbUw1QWtld1dCMm5jcnB6Z3lMUmsrZ0UzY09Na2dNV2lyRTJk?=
 =?gb2312?B?WWxUcE1wSHIvVlA5TkN2cEJpWDZaMVpIWWlQOXcxMEFGZHF4UlBCdXFIdTUy?=
 =?gb2312?B?ZmFDa1V4TGJWbS93ajhCWmpFeUdheCtCL2xtMkh1d2lDRHNrNk1DS0dlNU40?=
 =?gb2312?Q?5Pxo=3D?=
Content-Type: text/plain; charset="gb2312"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d9871b-1c1d-40f9-2125-08db6e0a23be
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 01:36:43.1294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xfe5OtlZYvh3yGfXFHiYo/wNdh3K2pvg79YK9w/Mqdd63xnQ8ZdKs4u3i3hr938jXawa9OH1aeHnwmAgmq1K1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4994
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T2theaOsdGhhbmsgeW91ICxJIHdpbGwgZG8gYXMgeW91IHN1Z2dlc3QuDQoNCi0tLS0t08q8/tSt
vP4tLS0tLQ0Kt6K8/sjLOiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPiANCrei
y83KsbzkOiAyMDIzxOo21MIxNsjVIDQ6MzcNCsrVvP7IyzogU2ltb24gSG9ybWFuIDxzaW1vbi5o
b3JtYW5AY29yaWdpbmUuY29tPg0Ks63LzTogzfXD9y3I7bz+tdey47y8yvWyvyA8bWFjaGVsQHZp
dm8uY29tPjsgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgRmxvcmlhbiBGYWluZWxsaSA8
Zi5mYWluZWxsaUBnbWFpbC5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5u
ZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgU3RlcGhl
biBSb3Rod2VsbCA8c2ZyQGNhbmIuYXV1Zy5vcmcuYXU+OyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBvcGVuc291cmNlLmtlcm5lbCA8b3BlbnNv
dXJjZS5rZXJuZWxAdml2by5jb20+DQrW98ziOiBSZTogW1BBVENIIHYxXSBkcml2ZXJzOm5ldDpk
c2E6Rml4IHJlc291cmNlIGxlYWtzIGluIGZ3bm9kZV9mb3JfZWFjaF9jaGlsZF9ub2RlKCkgbG9v
cHMNCg0KSGkgU2ltb24sDQoNCk9uIFRodSwgSnVuIDE1LCAyMDIzIGF0IDAzOjAzOjE1UE0gKzAy
MDAsIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4gT24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgMDM6MDQ6
NThQTSArMDgwMCwgV2FuZyBNaW5nIHdyb3RlOg0KPiA+ICBUaGUgZndub2RlX2Zvcl9lYWNoX2No
aWxkX25vZGUgbG9vcCBpbiBxY2E4a19zZXR1cF9sZWRfY3RybCBzaG91bGQgIA0KPiA+IGhhdmUg
Zndub2RlX2hhbmRsZV9wdXQoKSBiZWZvcmUgcmV0dXJuIHdoaWNoIGNvdWxkIGF2b2lkIHJlc291
cmNlIGxlYWtzLg0KPiA+ICBUaGlzIHBhdGNoIGNvdWxkIGZpeCB0aGlzIGJ1Zy4NCj4gPiANCj4g
PiBTaWduZWQtb2ZmLWJ5OiBXYW5nIE1pbmcgPG1hY2hlbEB2aXZvLmNvbT4NCj4gDQo+IEhpIFdh
bmcgTWluZywNCj4gDQo+IHVuZm9ydHVuYXRlbHkgeW91ciBwYXRjaCBoYXMgYmVlbiB3aGl0ZXNw
YWNlIG1hbmdsZWQgLSB0YWJzIGhhdmUgYmVlbiANCj4gY29udmVydGVkIGludG8gOCBzcGFjZXMu
IFBvc3NpYmx5IHRoaXMgd2FzIGRvbmUgYnkgeW91ciBtYWlsIGNsaWVudCBvciANCj4gbWFpbCBz
ZXJ2ZXIuIEluIGFueSBjYXNlIHRoZSByZXN1bHQgaXMgdGhhdCB0aGUgcGF0Y2ggZG9lc24ndCBh
cHBseS4NCj4gQW5kIHVuZm9ydHVuYXRlbHkgdGhhdCBicmVha3Mgb3VyIHByb2Nlc3Nlcy4NCj4g
DQo+IEFsc28sIEknbSBhc3N1bWluZyB0aGF0IGFzIHRoaXMgcGF0Y2ggaXMgYSBmaXgsIGl0IGlz
IHRhcmdldGVkIGF0IHRoZSANCj4gIm5ldCIsIGFzIG9wcG9zZWQgdG8gIm5ldC1uZXh0IiwgdHJl
ZS4gVGhpcyBzaG91bGQgYmUgbm90ZWQgaW4gdGhlIHN1YmplY3QuDQo+IA0KPiAJU3ViamVjdDog
W1BBVENIIG5ldCB2Ml0gLi4uDQo+IA0KPiBMYXN0bHksIGxvb2tpbmcgYXQgdGhlIGdpdCBoaXN0
b3J5IG9mIHFjYThrLWxlZHMuYywgSSB0aGluayB0aGF0IGEgDQo+IGJldHRlciBwcmVmaXggZm9y
IHRoZSBwYXRjaCBpcyAibmV0OiBkc2E6IHFjYThrOiAiLg0KPiANCj4gCVN1YmplY3Q6IFtQQVRD
SCBuZXQgdjJdIG5ldDogZHNhOiBxY2E4azogLi4uDQo+IA0KPiBQbGVhc2UgY29uc2lkZXIgYWRk
cmVzc2luZyB0aGUgcHJvYmxlbXMgYW5kIHJlcG9zdGluZyB5b3VyIHBhdGNoLg0KPiANCj4gLS0N
Cj4gcHctYm90OiBjaGFuZ2VzLXJlcXVlc3RlZA0KDQpJIHRoaW5rIHRoYXQgYWNjb3JkaW5nIHRv
IHRoZSBkaXNjbGFpbWVyIHRleHQsIHlvdSBhcyBhIHN1YnNjcmliZXIgdG8gdGhlIG1haWxpbmcg
bGlzdCBzaG91bGQgaGF2ZSBkZWxldGVkIHRoaXMgbWVzc2FnZSBpbnN0ZWFkIG9mIGNvbW1lbnRp
bmcgb24gaXQgOikNCg0KfCBUaGUgY29udGVudHMgb2YgdGhpcyBtZXNzYWdlIGFuZCBhbnkgYXR0
YWNobWVudHMgbWF5IGNvbnRhaW4gDQp8IGNvbmZpZGVudGlhbCBhbmQvb3IgcHJpdmlsZWdlZCBp
bmZvcm1hdGlvbiBhbmQgYXJlIGludGVuZGVkIA0KfCBleGNsdXNpdmVseSBmb3IgdGhlIGFkZHJl
c3NlZShzKS4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIA0KfCByZWNpcGllbnQgb2YgdGhp
cyBtZXNzYWdlIG9yIHRoZWlyIGFnZW50LCBwbGVhc2Ugbm90ZSB0aGF0IGFueSB1c2UsIA0KfCBk
aXNzZW1pbmF0aW9uLCBjb3B5aW5nLCBvciBzdG9yYWdlIG9mIHRoaXMgbWVzc2FnZSBvciBpdHMg
YXR0YWNobWVudHMgaXMgbm90IGFsbG93ZWQuDQp8IElmIHlvdSByZWNlaXZlIHRoaXMgbWVzc2Fn
ZSBpbiBlcnJvciwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGJ5IA0KfCByZXBseSB0aGUgbWVz
c2FnZSBvciBwaG9uZSBhbmQgZGVsZXRlIHRoaXMgbWVzc2FnZSwgYW55IGF0dGFjaG1lbnRzIA0K
fCBhbmQgYW55IGNvcGllcyBpbW1lZGlhdGVseS4NCg0KU2VyaW91c2x5IG5vdywgdGhhdCBoYXMg
dG8gZ28gd2hlbiBwb3N0aW5nIHRvIGEgbWFpbGluZyBsaXN0IHdob3NlIGFyY2hpdmVzIGNhbiBi
ZSBzZWVuIG9uIHRoZSB3b3JsZCB3aWRlIHdlYi4NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25l
dGRldi8yMDIzMDYxNTA3MDUxMi42NjM0LTEtbWFjaGVsQHZpdm8uY29tLw0KDQoyIGNvbW1lbnRz
IGZyb20gbXkgc2lkZSBvbiB0aGUgYWN0dWFsIHBhdGNoLg0KDQoxLiBUaGVyZSBpcyBhbiBpbmRl
bnRhdGlvbiBvZiAxIHNwYWNlIGluIHRoZSBjb21taXQgbWVzc2FnZSB3aGljaA0KICAgZG9lc24n
dCBiZWxvbmcgdGhlcmUuDQoNCjIuIEkgYmVsaWV2ZSB0aGF0IHRoZSAicG9ydHMiIGZ3bm9kZV9o
YW5kbGUgaXMgYWxzbyBsZWFrZWQsIGJvdGggaW4gdGhlDQogICBlcnJvciBhcyB3ZWxsIGFzIGlu
IHRoZSBzdWNjZXNzIGNhc2UuDQoNCkFuZCBvbmUgbW9yZSBwcm9jZXNzLXJlbGF0ZWQgb2JzZXJ2
YXRpb24uIFlvdSBtdXN0IGZpbmQgdGhlIGNvbW1pdCB3aGljaCBpbnRyb2R1Y2VkIHRoZSBwcm9i
bGVtIGFuZCBhZGQ6DQoNCkZpeGVzOiAxZTI2NGY5ZDI5MTggKCJuZXQ6IGRzYTogcWNhOGs6IGFk
ZCBMRURzIGJhc2ljIHN1cHBvcnQiKQ0KDQphbmQgYWxzbyBDQyB0aGUgYXV0aG9yIG9mIHRoYXQg
cGF0Y2guDQo=

