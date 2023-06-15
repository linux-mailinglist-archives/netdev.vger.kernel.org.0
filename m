Return-Path: <netdev+bounces-10960-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B06730D22
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ABE61C20E00
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 02:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B39F397;
	Thu, 15 Jun 2023 02:18:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883E3379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 02:18:23 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2097.outbound.protection.outlook.com [40.107.215.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E046269A;
	Wed, 14 Jun 2023 19:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evkinuCPyrH3xMf68kyqRjtJZJmFpFhaviwWTbE6eJwWVw5t5J5ciNL55vNMlMirsVIaQ9AOSpahRRF/rQcio2jF3ja1ctd9K3e6kCOdCqpXeqgAG+CyYB4H0UBU0WSMFtBQPzC8jZmxxuDSneW8ow83Ak7Aj0fhmjj9AtpMFeKFLOcXCDfgvti/rYbFb6PQAYStISdLs8mUUSxADQDArrxVhFOCm614TDPf0vMNA50Tq549B4NKkwXRDMC5Rj4lO/J7Rbrj+WN1EMWacC5YOkUOrO+nppbMm+MlFqn1F3ZG44rq4uTQOLOyXFJcKhxS1cvT8G/ljLAVVTkgvPzYjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh6NMF0sQJ+PwlUmuWQZl2zOWeYtTxPpBo32kti21Xg=;
 b=oIaGK7JBHVOEQ5cGUd2D1yRDGshUQkT2cBCQe1YjZ5NX/Bl7msUfFfLSGyUC/qAIHLn1Hf5pN2fU1gyGhuJeVNGNDkRtjR4z+DZ+qJkpWiJ+TsCSfUaBytai4fwb5iuIwT/UgPrceTFLO8g6Pf4Xu8Cf43AvmBuZNVN8KfgDqCB1IPZ0saD9hDIPhWtXGYe3n1uOFW08aDR7FyzxfCMdJxFkZTOvQYua8zIvuPYg/Dh+5zFeJ5k0hIuoEhPGH3ygDsgTgaF+x9RzWfwKZzkRsQ03mMwXxRIaUbDwXz5q6GdfVhxUmGL0oUWyPbUwJ3y5vy83O1rlgjDc1bZEJ1fUNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh6NMF0sQJ+PwlUmuWQZl2zOWeYtTxPpBo32kti21Xg=;
 b=cU2lIov2pmt7IvJ5IqEGouBNQQP1ecgkaJD6rtaSJqGB+8mk/Kqrb1nrZeNgLUjcN7NCUAkaPZQCXGptpzXCVh1u5Sp45a0d5SCUBq9abBcneofSBgzn0X0QKC5/qJX/U0wG5nfMoh/Cd5tPSYwdODms2zOQn664BKtGOhHDppjf2mGpMW11Bwr6zrz0KLg/tcdhUCYF8cc6r063cjg8amMZzAgnVCbdP1wCUxDOwtJuIikZkIL+EW0xS4mGyCgcYNzkVXkAfyF7zMp7QWfAsq1he/4jgcgbGb8ngItip7WdBhiXJQTRtEGiO6aoRTP4XVUch9KatUe6WNoiGqYAoQ==
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 TYSPR06MB6606.apcprd06.prod.outlook.com (2603:1096:400:481::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.37; Thu, 15 Jun 2023 02:18:15 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8%6]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 02:18:15 +0000
From: =?utf-8?B?546L5piOLei9r+S7tuW6leWxguaKgOacr+mDqA==?= <machel@vivo.com>
To: Pavan Chebbi <pavan.chebbi@broadcom.com>
CC: Jiawen Wu <jiawenwu@trustnetic.com>, Mengyuan Lou
	<mengyuanlou@net-swift.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	opensource.kernel <opensource.kernel@vivo.com>
Subject:
 =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggdjFdIGRyaXZlcnM6bmV0OmV0aGVybmV0OnJlbW92?=
 =?utf-8?Q?e_repeating_expression?=
Thread-Topic: [PATCH v1] drivers:net:ethernet:remove repeating expression
Thread-Index: AQHZnsIjxZhNtv/2gUes1Gr6A1/KD6+KUIIAgADQtPA=
Date: Thu, 15 Jun 2023 02:18:14 +0000
Message-ID:
 <SG2PR06MB37434ED2D5D1490297C19B27BD5BA@SG2PR06MB3743.apcprd06.prod.outlook.com>
References: <20230614131408.3097-1-machel@vivo.com>
 <CALs4sv0xmOAtWTzmJP1y8K1k6=tZo+E5js79ORj9Ypw=CVaVzQ@mail.gmail.com>
In-Reply-To:
 <CALs4sv0xmOAtWTzmJP1y8K1k6=tZo+E5js79ORj9Ypw=CVaVzQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SG2PR06MB3743:EE_|TYSPR06MB6606:EE_
x-ms-office365-filtering-correlation-id: 2c65d2be-fd43-4840-aa74-08db6d46c696
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 EiVvyC+THGi7JukmWzOIUViBOYoVfe4OChzO/b/9T10Tejs5Nebgi1Q4+13ZEl79tOS7JJ/QHLFJ08ITxHcSkIGZFJDR15fdmUVJrpkmu5JcJh6ojaehMYf7J0J/rsO8r7viMnHZIYLv/IdyWi8MPWMxCzfMZDjkgLzJXF4tQ9VG3SzHMWgUy8KavmnRt1fwp816LwlJFdGCcoLcArW9gW07dji8xAeygnrp0MnNFDoZTUWHhjdB9WSDsWNkwCqKvZ1zd+crUyEEDhLrU01jnaBHTAUJ/78LaWXx//6eyiwJCWCQ2tq+saEoBlqAtbs0XuvkkGDGyafxEos5ROw50UZv21mzRDyMDp3m6PMZBanJ6pv4B2NdtTSw7sJchK8WbFdmf5fMLJn27lvPZly3XeyL3YFFgPRCKoFVWQeR0I6O17m5c6kn88HEcHEBWRiNFNateopKksF4iFCN0YMKLiTUSMK4AaP1VaALD6oWJDAAgvz+kmqzAPr6IMb6lnu8DFuKdkIRMzKCR679UBQEwgEDZ300T5iBxK0hJrd7OK/4bg2xvc599201Q+PFBEE1Q2zQD8p7nYJhBnU/VKW+sAe6UOpxIXr8HbEt3bFiF+o=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199021)(186003)(26005)(9686003)(6506007)(53546011)(107886003)(2906002)(66556008)(4326008)(4744005)(76116006)(66946007)(64756008)(66476007)(6916009)(66446008)(83380400001)(224303003)(86362001)(85182001)(33656002)(966005)(7696005)(41300700001)(5660300002)(52536014)(8936002)(7416002)(316002)(38100700002)(55016003)(38070700005)(122000001)(54906003)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dmdSVEFwd1hiVGd2MXM5WmFDdlVWWkt4bktWRDAxUzhVVHdObjYxRDczeXBD?=
 =?utf-8?B?b0NTSTdWdThnYW15U1E0dnFMNlFRQmdxVUQ2ZC9MOXFEYjg4OVNnd3pYNHZp?=
 =?utf-8?B?ekptWGZCSE43RWp0YnE2NC9YVFFXRHFIbmZIaFIxTFJiWHdDakRiaFlyemZo?=
 =?utf-8?B?RitUZnZvRWsxZ2thMyt1U01BM3JlbDgvbU01ZU5SSUx2ajE4WGNYeEZ6TU9S?=
 =?utf-8?B?bDk4Q0F4NDY2Z3luR1ByTTZ0bEdEeE53RTJwSldqOUdBRWNVeEtGT2x1RW5a?=
 =?utf-8?B?Z3VYbWJWc2JzdDZVZ3hBU1RpUitYUU1YRzIyNzljK29BRjNCMzVsYTVzbzZE?=
 =?utf-8?B?cVZKdG9senRHalNJOGJVRDFwM0hXVnV6dGd5T2VLL1F6K3hMaXdhcVE4U0Ir?=
 =?utf-8?B?VWh6Z1kwMGpna0l4d0c3L0VjZm5POWJObjUyUExST2dNZzYwTzNxY3p1TlJV?=
 =?utf-8?B?ZDJLNUY5SUpRSFRHU01RQXIyN3h5VUM5aWkxcFpSK0xabDBVcDQrSEF2ZmYw?=
 =?utf-8?B?Z0g0bzlUL3EyK2tkTWxHV3RzeGl1MFU4VWtCRktYOHM2R2g2SmhkYTVwVXRz?=
 =?utf-8?B?djZVREFOaGJnRHpkSXd6ZlRWeFN0U1l1QmIrc0pUY3NVYWNLbzRoVG56ajN6?=
 =?utf-8?B?bVhDNmpJQVB6cEpvOVJwV3VyVGdJRG5XVkN3cTRwU1prWVhzNDRLRS9neUlI?=
 =?utf-8?B?YkRoSFIxOFF1eU5zRnhSUGFqSEU5NERhZ3JERjNZbkhNSExkVUppc0IvS1Zl?=
 =?utf-8?B?QlVLTEgxSklobUZxME44akFFRk9LdzJKUjJwRlJ6T2JyRHllQlFmdEdBcDVV?=
 =?utf-8?B?ZzBucnpmSUx0bnhFbU5OQ05pWDBhS1ZjY3RiTGxlc004Tyt4M0t1VXhvSWpU?=
 =?utf-8?B?MitjZ09SOEl4QjFkYmNSYnhiUXMwTGtRTzVIdDd3Z1I4Vk1nclZjVFJNOUxJ?=
 =?utf-8?B?TEVUZERJYks3RjErL3dlUHhpcXE5aWh3b3kyb1c0VW16bllSYlp0K25hOGdF?=
 =?utf-8?B?d1lQV2FEREttQmZ2c3dibG0vOGV0Q3ZGM0tlVFdqaHUrcDM0THJiMG1CVTNs?=
 =?utf-8?B?Vnltc1hiUWZDU3lJdlFzbkJiQzh5SWZYSWVIQmg0UmlvdW92eDRodlRuN3VZ?=
 =?utf-8?B?S1VHaG5CbmdkdHQ4VjhoeVJvaDBJWWNoYVl1TzZWWHBtTWpnWklybThCa09j?=
 =?utf-8?B?SEVwUHJiRkhMMlBtN3gzcDl6anhwYm9sZHJiemx0dGhPTlRuNzV2OWRRa1pp?=
 =?utf-8?B?WUhpR1FNck14c01SSjRmeDZwMUw2RVdzQzNneG5BbU9CZVRGVzB1akJRalZ4?=
 =?utf-8?B?bmdiV25GNmNhRG56SGtxN2pxajd4T2RKMUFLQ2tPWHBOZjhGQXluczd3cGlI?=
 =?utf-8?B?aXlnd0NKRzdHMTZYSlFXOTVLNlBjUW5RaHI5dHpqK3ZjY1ROWFJlMzF0N0Jj?=
 =?utf-8?B?WWs4Q21vSW5VY3pSRkRtalFrUFJFWEFhSWRZS2xBZ1kyZExUNGU2MG9IVTNt?=
 =?utf-8?B?cjhGNVpzdmJ1ZHMrQXVrSURLb3VNakpLRHAzdFd5K1hYcDEzUy9FNDBuNUF3?=
 =?utf-8?B?RXdqMm1KVmc1MFN6S1BjeWc0M0dLRmwrNW9XTjAvTDZjaHFCai82OWJrTVVK?=
 =?utf-8?B?V1B5V3BvczJ5VDlEcjRBMzVUSUY1SExRbDUvTS9PTUNTQXJyQU40Y3JqVzV1?=
 =?utf-8?B?WVFKLzVnOGJ5VUNjc25JVkdHL1BHeEFaWnNnTzB2bjhicG9zQ0FVem01bkxn?=
 =?utf-8?B?bXNUeEZkNXlqSnZHRkRMRkdyVVJ6M2VFa3hLUXloenJkY2x2N3UrSTU0VW04?=
 =?utf-8?B?bG5kbDBWUTAreUcrV3I3aGRmSG4xK0luSFBEZDBoYkIwK1VKd2VaQVFlSG85?=
 =?utf-8?B?U2NVemhwMnV4UmhnSmxxOUtHS0I2eUJXdDY4TjZxYWxIalZkMmpzTHFrOVNE?=
 =?utf-8?B?Y2w0MUdJb3VRWHZRR1lMY0hzOEUveDBtaUNaZlRHdXRJWVMxUEpZbDVZdkZ2?=
 =?utf-8?B?K2RhN3VYUDZLblE5M09waTlYM3lySXdSOWk5UnhuRTd6aVFieGxyWXM0RCt6?=
 =?utf-8?B?Tk1HT0VxQ3NwUHdla01NWmpVc2ZNMWJMVkFpOUxZRVN6a3hjRFhhUjJRWnBT?=
 =?utf-8?Q?P/LY=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c65d2be-fd43-4840-aa74-08db6d46c696
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 02:18:14.9856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aIFaEViREdex8dB9YuQmyiKuSGyza4l8smMReN1jn6XWMrKeZtqsSTzxjaWZ60EuSMYKjvyA7TfKT86VWXV70A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6606
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

VGhhbmtzLCBJIHdpbGwgZml4IHRoZSBwYXRjaCBmb3JtYXQoc3ViamVjdCkuDQoNCi0tLS0t6YKu
5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogUGF2YW4gQ2hlYmJpIDxwYXZhbi5jaGViYmlAYnJv
YWRjb20uY29tPiANCuWPkemAgeaXtumXtDogMjAyM+W5tDbmnIgxNOaXpSAyMTo0OQ0K5pS25Lu2
5Lq6OiDnjovmmI4t6L2v5Lu25bqV5bGC5oqA5pyv6YOoIDxtYWNoZWxAdml2by5jb20+DQrmioTp
gIE6IEppYXdlbiBXdSA8amlhd2Vud3VAdHJ1c3RuZXRpYy5jb20+OyBNZW5neXVhbiBMb3UgPG1l
bmd5dWFubG91QG5ldC1zd2lmdC5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgU3Rl
cGhlbiBSb3Rod2VsbCA8c2ZyQGNhbmIuYXV1Zy5vcmcuYXU+OyBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBvcGVuc291cmNlLmtlcm5lbCA8b3Bl
bnNvdXJjZS5rZXJuZWxAdml2by5jb20+DQrkuLvpopg6IFJlOiBbUEFUQ0ggdjFdIGRyaXZlcnM6
bmV0OmV0aGVybmV0OnJlbW92ZSByZXBlYXRpbmcgZXhwcmVzc2lvbg0KDQpPbiBXZWQsIEp1biAx
NCwgMjAyMyBhdCA2OjQ14oCvUE0gV2FuZyBNaW5nIDxtYWNoZWxAdml2by5jb20+IHdyb3RlOg0K
Pg0KPiBJZGVudGlmeSBpc3N1ZXMgdGhhdCBhcmlzZSBieSB1c2luZyB0aGUgdGVzdHMvZG91Ymxl
Yml0YW5kLmNvY2NpDQo+IHNlbWFudGljIHBhdGNoLk5lZWQgdG8gcmVtb3ZlIGR1cGxpY2F0ZSBl
eHByZXNzaW9uIGluIHN0YXRlbWVudC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogV2FuZyBNaW5nIDxt
YWNoZWxAdml2by5jb20+DQo+IC0tLQ0KDQpQbGVhc2UgZml4IHRoZSBwYXRjaCBmb3JtYXQgKHN1
YmplY3QpIHNvIHRoYXQgcGF0Y2ggZ29lcyB0aHJvdWdoDQpDSS9zYW5pdHkgY2hlY2tzLg0KaHR0
cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC92NS43L3Byb2Nlc3Mvc3VibWl0dGluZy1wYXRj
aGVzLmh0bWwNCg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvd2FuZ3h1bi9saWJ3eC93eF9ody5j
IHwgMSAtDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPg0K

