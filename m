Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BF82688CC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgINJwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:52:07 -0400
Received: from mail-db8eur05on2120.outbound.protection.outlook.com ([40.107.20.120]:31457
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgINJwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 05:52:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc5ykuS/xAJdDUC/206ZanRDKMyvfxcHCIe3rrk3H6SlhNy3Q02CHg018h6Okph888POYWIaaRIffD2z/HOoCSC3BXHqAQFBAi2e//5U8pkhAQZXFY/8rHZVDRavlOTc1opQG5n7kkcrgb1pTWlUv99bER7dKL51Ea71snf3aRncmzVa+CrFimSnnd87ENfPkm+csqpa3sa5T3DYpTX+EGNhW89dZoGzLBeNY6nsyllYd+g5RpgC7loJ5xt6MMuRXsuISRdF9p1GUBHkhrBqRj7uemW57cAiHT59r8nh3tMlRpnW16vjLnc4Sw058aKoAhleUfL2Kj8tPy5gm7PTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw/FSgfGU7BenHUj3zpEp+4CiwjF7GJUpZDgQJLoRHE=;
 b=mI14e2mKduBSNaY0LK59tEzFOZv2vxZWzGC4KGSC/3nf9crSl+RsyUv8WpUmjTD7DPBPd167yanNtx3xKESdIW3cVC91De/7nFdq54gsxfTdaLobEJSfjTvD95NtUIKDf60mDOG+tGdctb7JdBmpJvHBLvhHSScYTw7kDRKgjGOdTu0bjpjC+HYvG6YG+25UzeZllB43J4aUm5RaSDomHq10f/ke/ABsWTCtVB3fKD/gnPB6pIyoul24Z58XzfDwSJ7z2+33RNSRvpR8/QC1enkw97eZpdiWHY0XcUMLTaEPIjs+xy12bBEPbcWSV4yT+puRAsDnY5GmUlMLsbrvtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=habana.ai; dmarc=pass action=none header.from=habana.ai;
 dkim=pass header.d=habana.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=habanalabs.onmicrosoft.com; s=selector2-habanalabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw/FSgfGU7BenHUj3zpEp+4CiwjF7GJUpZDgQJLoRHE=;
 b=mFkA5RVnV9CU8hCbgFZH0I07XXQbDkDhFVvCeSqIYg+8bPYWnsjUwuoSLjlSNEmxxmc1Jjts5s4KA2lanh5UxuvJNAIvVaaO9vBjZr+iYujbWaMco9iAs5axgPOUI74lmIFVtVmZ55v1sURIB5YPCtYZS8cWhKYfPu0oIV+H0sA=
Received: from AM0PR02MB5523.eurprd02.prod.outlook.com (2603:10a6:208:15e::24)
 by AM4PR0201MB2177.eurprd02.prod.outlook.com (2603:10a6:200:49::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 09:52:00 +0000
Received: from AM0PR02MB5523.eurprd02.prod.outlook.com
 ([fe80::7c43:7d52:92d9:5c93]) by AM0PR02MB5523.eurprd02.prod.outlook.com
 ([fe80::7c43:7d52:92d9:5c93%5]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 09:52:00 +0000
From:   Omer Shpigelman <oshpigelman@habana.ai>
To:     Jakub Kicinski <kuba@kernel.org>,
        Oded Gabbay <oded.gabbay@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        SW_Drivers <SW_Drivers@habana.ai>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 05/15] habanalabs/gaudi: add NIC Ethernet support
Thread-Topic: [PATCH 05/15] habanalabs/gaudi: add NIC Ethernet support
Thread-Index: AQHWh40eyDMqzSAoUkuwz7EiOxxOUaliS7KAgAWM16A=
Date:   Mon, 14 Sep 2020 09:52:00 +0000
Message-ID: <AM0PR02MB5523D7FD712C3B50DA733CDDB8230@AM0PR02MB5523.eurprd02.prod.outlook.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
        <20200910161126.30948-6-oded.gabbay@gmail.com>
 <20200910130307.5dee086b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910130307.5dee086b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=habana.ai;
x-originating-ip: [141.226.12.25]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e935879-69ab-4bbf-198c-08d85893d3af
x-ms-traffictypediagnostic: AM4PR0201MB2177:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0201MB2177DCD12AA6F3A8A1D730A2B8230@AM4PR0201MB2177.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wk392NRiJGxsQHgD6+J6T9VuamoO8KwBqU7vxEHHxYtBBytra0LjvPsm9C5zygFWrEaLN5Uw9mYTXjzolY8RnX1TKPqXHSIFGvhoflg/e1DQUAtGP68CitgrIu2ZUfnK6ysjXJl52H5ltEOErlrEDlP3nT3ZaToW5GHLVIloG8nmXWrtiXt33IUUiIQVV33qoV0YkWhqWnnVEmKXRoyGxJUUxSb3X1KTaDEUCrfS6oU4c8M5xrSSxZlnwYjKByhv0NkJeqA7rQCufmpZ+efDKGrCG5WZp8vQSu4m+BHJP1u1YQp87RUiGOQ7nxgbjtR64EPPUe1c/sYMg82bVvBEjXZ3H6y8ou6JDWmVPrq5mrfnw2kXZ84qkpiLBUAqZEFl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5523.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(346002)(39850400004)(8936002)(5660300002)(71200400001)(186003)(52536014)(76116006)(2906002)(55016002)(26005)(6506007)(7696005)(33656002)(66946007)(508600001)(54906003)(86362001)(4326008)(66556008)(8676002)(53546011)(9686003)(4744005)(66446008)(110136005)(64756008)(66476007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zqvRdgntWGoGAXmM1jhxw4nIlgYtNILRac3lkGW6RZyynQ71p/4ItC2l9efCnS6obpXhPPaDVZh0k3lwMgrTVkojTCuZNL9T9iDAcE8WP6T1F8z88cVFT4LYT8EKgpkSLTR6e90SLG5cEnP/9k/J8wHQwqRB1F/GGWCI9TglyiKa4u7750qXJMHnGXcYC8aPiqWjvfK0wkgN4G0ecZX969wb3DjQLsTWP1+TnhnY0bFkZPsvUQYON6lNdESwFER3jnI0kQ7biAxHeCa132R56P68+zAh3zCQjmOQAIgLgdeAmZ1mjOM5V0b2nJJbZ5d3m01/nJM/BEwZEGoixzR9h4jg8KcYAPpTO5eVeYdvKRw0jp4FJHRC1sa2uf+w+BateE0Uk+EYDtheItTFAyyXtKEGx0HSJr+Fs3Wr1fWpVo1JKHWTqHyVZQBL0ZxG/c16R7bqmNkx+1/eszGPCunQAuAjrM5unSb73rb2jeO5a+j4v3kiPal4tgBzSFIZtXwtv+wRhbYDkafoh5MMmNwCEtSI0+6kWxem05er28cEGekDaQM6zeG8vWHA6mpaeInr/SUAqjxeuW/h5kyWhQ6vAJZLbpWUp4MMS4MWjE/FxQruVFhgWLhn7IIMST58KWTWmb4ERvGXUE7ekkyaBOmbFw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: habana.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e935879-69ab-4bbf-198c-08d85893d3af
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 09:52:00.6470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4d4539-213c-4ed8-a251-dc9766ba127a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WC989YHcw3RogW6MkOoj6EhiuCPMASyzGUwLEN7zeiVMF1kqebwcbWEdbJfUf9+dvmVyiagcitQFsrIvmCFkJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0201MB2177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBTZXAgMTAsIDIwMjAgYXQgMTE6MDMgUE0gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IE9uIFRodSwgMTAgU2VwIDIwMjAgMTk6MTE6MTYgKzAzMDAgT2Rl
ZCBHYWJiYXkgd3JvdGU6DQo+ID4gK21vZHVsZV9wYXJhbShuaWNfcnhfcG9sbCwgaW50LCAwNDQ0
KTsNCj4gTU9EVUxFX1BBUk1fREVTQyhuaWNfcnhfcG9sbCwNCj4gPiArCSJFbmFibGUgTklDIFJ4
IHBvbGxpbmcgbW9kZSAoMCA9IG5vLCAxID0geWVzLCBkZWZhdWx0IG5vKSIpOw0KPiANCj4gSWYg
eW91ciBjaGlwIGRvZXMgbm90IHN1cHBvcnQgSVJRIGNvYWxlc2NpbmcgeW91IGNhbiBjb25maWd1
cmUgcG9sbGluZyBhbmQgdGhlDQo+IHRpbWVvdXQgdmlhIGV0aHRvb2wgLUMsIHJhdGhlciB0aGFu
IGEgbW9kdWxlIHBhcmFtZXRlci4NCg0KSSBjb3VsZG4ndCBmaW5kIGFuIGV4YW1wbGUgZm9yIHRo
YXQgaW4gb3RoZXIgZHJpdmVycyBhbmQgSSBkaWRuJ3Qgc2VlIGFueXRoaW5nIHJlZ2FyZGluZyBw
b2xsaW5nIG1vZGUgaW4gdGhlIHBhcmFtZXRlcnMgZGVzY3JpcHRpb24gb2YgdGhpcyBldGh0b29s
IGNhbGxiYWNrLg0KQ2FuIHlvdSBwbGVhc2Ugc3BlY2lmeSBzb21lIHBvaW50ZXIgZm9yIHRoYXQ/
IE9yIGluIG90aGVyIHdvcmRzLCB3aGF0IHBhcmFtZXRlciBjYW4gd2UgdXNlIHRvIGVuYWJsZSBw
b2xsaW5nL3NldHRpbmcgdGhlIHRpbWVvdXQ/DQoNClRoYW5rcywNCk9tZXINCg==
