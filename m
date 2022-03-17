Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251074DCC9D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiCQRi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiCQRi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:38:28 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A712217943;
        Thu, 17 Mar 2022 10:37:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmHeMPYkgNZoY8MGjete8bG5MZ069sU30pJ7Y7oYO2vYivpZ22ODjWG77D8Lh4g8/lpvf6vrbiP9a/KQAs35+3H9CBd2ohuTchxgMLehebiLSArUUP/KK6hSv5a6B2v2fr4G+GD9ukJ9iG44OM6nogOKZpANuF1M89b4zOZI4iBkwQ5I0YybU/OCyiAG5dTr1Jq6eiluOr70a+kltGMjQLjY0NVaqnwNDcZa1UBQkba1uSR/VMkX6jQp+4N3rHZcBpo4lcWneF8PEXGNiS/Kpp/q9fFb7IWh8Rhs5MlriGB8+lp0JtVOegQg+INu86hv3QYkezHI7SlbUq7NxMLqAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pPvysizrdy8QXCRh/OGt86snDOtCZ4vyCwovREc1go=;
 b=cJRSF42NOMscWaXLleZybupvNK6s6/PDSe4D6Z1h8FIwu25Ub5zZqMcRi4HBn2irF2c26LDE5al+yyPPJVAvUWrGtK7XXRcm6s0sjZCgGf1M9HCzJl1Gd/bI6H1Cms6W7VE0TMaMTrouovQqDkr+uBU8mgp/BVF9BpVHNQfmxzWXGa7abIbjwkf9i9dm/VG0m7LA/5UCHlDMYSYc31pwQt9mMcsIA2meSiBuod5lyba3MTnhWZ/kDHtFbcwJjXUZG3yfMEaxTnsHWwuhF7nkoHJPDyKmbe+qWp0HzWtg2OMxCctvEvoFErmk75JKD1xyChwxadZMUbQvocPAPS2CQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pPvysizrdy8QXCRh/OGt86snDOtCZ4vyCwovREc1go=;
 b=ArdIRIfcQt0sOgpNw7Zv909LDxPzfmqc2QL5inCUEh33EglPo48dq1bJ7iEE60uC1peSE8DCXhx+tVT0UPybAweJxfA6Zx8HVdtmXkGRV4/7ZspLpiJdPCk84oUEgIadri5sNzeHsBU1bp5mAkcDOiEk+OV2zBUOfQhxp2hvmgo=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DB8PR04MB6777.eurprd04.prod.outlook.com (2603:10a6:10:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 17:37:09 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e52e:aa62:6425:9e9b]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e52e:aa62:6425:9e9b%8]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 17:37:09 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Bill Wendling <morbo@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: RE: [PATCH] enetc: use correct format characters
Thread-Topic: [PATCH] enetc: use correct format characters
Thread-Index: AQHYOX0qnqFJ37bnYU+9UBnfRcMWZazD12GA
Date:   Thu, 17 Mar 2022 17:37:09 +0000
Message-ID: <AM9PR04MB8397B7734E38A4E60C6965DB96129@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220316213109.2352015-1-morbo@google.com>
In-Reply-To: <20220316213109.2352015-1-morbo@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9c90f1b-4dc8-42b5-163f-08da083cc335
x-ms-traffictypediagnostic: DB8PR04MB6777:EE_
x-microsoft-antispam-prvs: <DB8PR04MB67774DD071651BBDD8BDFE1096129@DB8PR04MB6777.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HouohZ5P/gCvowk+bd/KqfEf4M1PMkNhyBdg21/1n+eqEJDnVbIzy3xclnCkpoagyGdxKOq6pQVv8mZxY9iGTAXFaI6M1FMFoPhkUgjIcNIUD6rTnpJUf7pZmiAYVwQPmoFrZKTcGsIN8dJ3xwJ9+c168XjkiUN/VaZpA+vS6GjlW6vuRI2Qwuu1PMCcplhuYtpLFrrLbUV93dCq9uUAQ+nOe5H1gOSSCKwartM5VZmdhOmpNGmz0A+sbSRTq9WvsXXC8P3Zd76R8QhfqVNNGjjdbykKCuPhu2BHpsepx8+JfFq43lZk1hqJrnRxlpvAM/x9JMb3OwvCXlKOUtbnYXItJbf3nEog9IYn8qj0Wgc250iv/2w8VGqY5CjhV4oqPNk4YeOAns5EeSuz1n8lCzXvqkFz1nXsefpwcIdtsTA4lbMALgn7f26LkPBhSFvsOXT+TqUmhw5GWQ7lqAcwFWycIM52JgyigBsgCtyGCJV891hTnJolYfs3ldrODCT0mfdwUp5LOi09vQlS+f1mPNu16h+L505RefUfTVT9p8qeQUCtColkj3WmLZ+g16Yy422hlU21DH9SK8fqbbv/tJR7OQnc/e81hbUMkCBXNGJaiGDPfEU6+aNS4VGCq4TarKuvYjXPGGGbWy6z+82ywBz+h0NiKUBlAQ+azCg2n3riSf08JkLlwbDcSo58/VNWssT6WheuAg8TB5ZP9TgKow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38070700005)(64756008)(66446008)(86362001)(33656002)(66946007)(66556008)(71200400001)(55016003)(19627235002)(66476007)(76116006)(9686003)(5660300002)(316002)(186003)(44832011)(26005)(122000001)(52536014)(7696005)(8936002)(55236004)(83380400001)(110136005)(38100700002)(508600001)(53546011)(8676002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzNzZC9IZlVmWGltWE5DNFdUVFVtL01vd3M3emo0QVVZcVB1cUdTbENvNkJI?=
 =?utf-8?B?VUZQWk5TVHNJSjBtSWtkOVZTbi9iYjZVMytvVyt3VHM0QWc5elB4Y3FjbUpz?=
 =?utf-8?B?Y09DSEVvWUpUY2pZZXdaWDhuN1g1NFRmdjI4emd3VXE2Y2ZqRm54WWtnNnQz?=
 =?utf-8?B?ZDhFTDlOU1ZrS0h0Q2dwMStldS9ncW1uNGpOTGZnK0dYQ3piRklEYzBqQzh5?=
 =?utf-8?B?Unc2OUdvc1RtOUVJVTJ4alhZNWE2Qm1XeEd6dXliNGVKN2RlMGJRcHE1V3VP?=
 =?utf-8?B?TGUxWFZZb1BwN1ZVdUVQZk4vc2xoV21sVzVzWnQ2aWprWEptbW5wM0xMMEF4?=
 =?utf-8?B?Vi9LNy9OWjdPUnJZWndNZlB5T0xmdVdEWFFkY09ZYVB6Z0NqaE1BUGZRN0pn?=
 =?utf-8?B?WjJ6NkNEZFFlbmcrT0dubUcxd24zZHlKVGFLWkFEK0I5SGRMNmUvYzBYeXAy?=
 =?utf-8?B?RW9uR2xCaVJuS1hmWWZ1aWNNS0ViVFdLVWVuMFFNMHVLNWYyWDJlWGh2bFZw?=
 =?utf-8?B?Yzd1dXNydk5nTGhPN0VlaWxTS25zdTVuSGpMay9YNS9FdHJGcE5GRWRFNHRp?=
 =?utf-8?B?eGcvdTNvbXF1eWFqN1B6N1I5RTRuWWVQZ201ZlB4c1E2WEZjYUdPOHlJTHlh?=
 =?utf-8?B?L3ZyZ004TWxhd1NBS3ZuZndOOE5rUkxnRFp4K2tKcE5ta2VuWmE5b0UyZUZI?=
 =?utf-8?B?WnpXVUZGaDZFdm91d3dTNGxNSFJkU2lCZ2tGb1pEaDB1akZVNWkreFZTSWR6?=
 =?utf-8?B?Q1ZldGliRHlqS3JkSnpLRFBtRmlpMUNtek8zYzZycy9HS3llNVdPSUJNNFNn?=
 =?utf-8?B?a2xaQzk4OXV0SXNEQ3d4NUN0WkVLeWRGN1psTGNEL2p6RXBXL0hNYmlmM05B?=
 =?utf-8?B?ZmduSTREUC83eWxIYUxWbTJTS3E2dG9rTGUyeFZwRXJvR0FuOHdIOHVJK0Ur?=
 =?utf-8?B?eFJBTXVaNlhiRUVCS3lRbFk1UkxOcGs4MEhtbE1nU0lrQjJReWdXaGhjbC9R?=
 =?utf-8?B?Q3dOM200bUNLYk9hT0E1VXN2OEhBcWxiVVJwbzdOaEdETVhnQkdsYVRScHlk?=
 =?utf-8?B?c0o1UVBRV0hQNWNyb2ZPZGhTTVZiZmgrWU1pU0p1dVdrZ2VGTDFVdW9KQ2NH?=
 =?utf-8?B?dVBVcXVpdUZVK20yME9IWmRUUEx1MG1Nd3hPdmh5dUFRdUFna0ZyZ1FiVUlJ?=
 =?utf-8?B?TWJlZVRlK1VqeUp3WHNpZE45cHBac0JHUjk4bTZxQTBabUVXL1NiYy91SUN4?=
 =?utf-8?B?UUxzNUxUZS90WlFjNWtxSXRsdVdaaStLbHZXWmgySDMvVG9hUWUzNktQcnNW?=
 =?utf-8?B?TzRMcGRzaklHaFhDWEEvQUIzNVlIQzlSVnFMMXhZUHJudDlWYnJnRVVuUmRl?=
 =?utf-8?B?bjBqUk15N1grSC9DN0ZQcXhsNTVaY2pvTWpzOC9NWDV5eVUycTd1MjFXU3B2?=
 =?utf-8?B?b3pCeUpRd05WOUQxbHQ4eW9YbVFjdDAzdVJVOU01a0dmTGZ0bHFhcnFraXlU?=
 =?utf-8?B?TmN4L0o5UWNWdnY2TjdZcUdYUEZSUVozVm1QTUlPallQb21Xd2hIc2RVZVhW?=
 =?utf-8?B?TmxoQVNpZTRzaW1HUWRFa05EeWpFOEtPaWpLY3o2UndsWmloNFlZVXJKbzMz?=
 =?utf-8?B?aEdod3g5M2hBSEVyM3RrTXliUk5WKzdZZVJzVzFUbE52bVloaFczYVE2SXhC?=
 =?utf-8?B?WTdBVW83MG1TZXZuSUZTU1Fsa3RRVFVuZzNxQy9BWUxLWml0djJ3NXczUmV2?=
 =?utf-8?B?Z2xFcG5RcGcwZ0d5UFhPTTZiQUFHU0dqSjFyR1FST2dIdHZQc0NmSThZMCtN?=
 =?utf-8?B?ait2eWE0UEwvNUFRcDdDbEhPNDMwVUpQZ3hGZS8rOXZESHd6WjJrVlF3Tkds?=
 =?utf-8?B?c3Q1ZmRYVXoyekQ1Q2dlKy9uN0ZpS3Vra0tzaHdyYmxLSnQwNE5aMWtsZitB?=
 =?utf-8?Q?9eE2CMe8mrZEHgvZOrIEISVBu0VsVf+a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c90f1b-4dc8-42b5-163f-08da083cc335
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 17:37:09.1192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hUyln6AUzK+KTFRZvSkki6ynlqQBE2i8XGV0M/oZTGXCRHfjiDirmt07vlv/wmkAcAD4TD8NM/gno89a064LbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCaWxsIFdlbmRsaW5nIDxtb3Ji
b0Bnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDE2LCAyMDIyIDExOjMxIFBN
DQpbLi4uXQ0KPiBTdWJqZWN0OiBbUEFUQ0hdIGVuZXRjOiB1c2UgY29ycmVjdCBmb3JtYXQgY2hh
cmFjdGVycw0KPiANCj4gV2hlbiBjb21waWxpbmcgd2l0aCAtV2Zvcm1hdCwgY2xhbmcgZW1pdHMg
dGhlIGZvbGxvd2luZyB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2VuZXRjL2VuZXRjX21kaW8uYzoxNTE6MjI6IHdhcm5pbmc6DQo+IGZvcm1hdCBzcGVjaWZp
ZXMgdHlwZSAndW5zaWduZWQgY2hhcicgYnV0IHRoZSBhcmd1bWVudCBoYXMgdHlwZSAnaW50Jw0K
PiBbLVdmb3JtYXRdDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIHBoeV9pZCwgZGV2X2FkZHIs
IHJlZ251bSk7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+
fn5+fg0KPiAuL2luY2x1ZGUvbGludXgvZGV2X3ByaW50ay5oOjE2Mzo0Nzogbm90ZTogZXhwYW5k
ZWQgZnJvbSBtYWNybyAnZGV2X2RiZycNCj4gICAgICAgICAgICAgICAgIGRldl9wcmludGsoS0VS
Tl9ERUJVRywgZGV2LCBkZXZfZm10KGZtdCksICMjX19WQV9BUkdTX18pOyBcDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB+fn4gICAgIF5+fn5+
fn5+fn5+DQo+IC4vaW5jbHVkZS9saW51eC9kZXZfcHJpbnRrLmg6MTI5OjM0OiBub3RlOiBleHBh
bmRlZCBmcm9tIG1hY3JvDQo+ICdkZXZfcHJpbnRrJw0KPiAgICAgICAgICAgICAgICAgX2Rldl9w
cmludGsobGV2ZWwsIGRldiwgZm10LCAjI19fVkFfQVJHU19fKTsgICAgICAgICAgICBcDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB+fn4gICAgXn5+fn5+fn5+fn4N
Cj4gDQo+IFRoZSB0eXBlcyBvZiB0aGVzZSBhcmd1bWVudHMgYXJlIHVuY29uZGl0aW9uYWxseSBk
ZWZpbmVkLCBzbyB0aGlzIHBhdGNoDQo+IHVwZGF0ZXMgdGhlIGZvcm1hdCBjaGFyYWN0ZXIgdG8g
dGhlIGNvcnJlY3Qgb25lcyBmb3IgaW50cyBhbmQgdW5zaWduZWQgaW50cy4NCj4gDQo+IExpbms6
IENsYW5nQnVpbHRMaW51eC9saW51eCMzNzgNCj4gU2lnbmVkLW9mZi1ieTogQmlsbCBXZW5kbGlu
ZyA8bW9yYm9AZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUgTWFub2lsIDxjbGF1
ZGl1Lm1hbm9pbEBueHAuY29tPg0KRml4ZXM6IGViZmNiMjNkNjJhYiAoImVuZXRjOiBBZGQgRU5F
VEMgUEYgbGV2ZWwgZXh0ZXJuYWwgTURJTyBzdXBwb3J0IikNCg0KQ2FuIGJlIGFsc28gbmV0LW5l
eHQgbWF0ZXJpYWwuIEl0J3MgdXAgdG8geW91LiBUaHguDQo=
