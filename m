Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C432017DE6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfEHQNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:13:20 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:58959
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727150AbfEHQNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 12:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRlCgllaeQFRhbw/4RWMMABHQbssZ5McwuHYWfho2V8=;
 b=M/igsZV2MCYkLooVAiZQU5gvT0Owhxw5OSqF8RTs1szzNMgPJ029JkmgcgHVl33hU16d7bl5nd11+NHqppujeXbMQVdx1vhns8AqHd4SHKUBuByUlaDF7NMAMMcHv+gW4qb7J8S8ewMmYPKVbwTTWkGituhK0TEC4ntUXOdNp3Y=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB2734.eurprd03.prod.outlook.com (10.171.108.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Wed, 8 May 2019 16:12:54 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a096:fef7:568:7358]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a096:fef7:568:7358%7]) with mapi id 15.20.1856.012; Wed, 8 May 2019
 16:12:54 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next v4] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next v4] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVBREof9SUD1rIBEGMErsp08m2pKZgXWkAgAEKPIA=
Date:   Wed, 8 May 2019 16:12:54 +0000
Message-ID: <58168C49-177F-4F74-8E67-8B9CF9B23FD3@darbyshire-bryant.me.uk>
References: <20190507.123952.2046042425594195721.davem@davemloft.net>
 <20190507201154.97646-1-ldir@darbyshire-bryant.me.uk>
 <20190507.172000.384528161562920463.davem@davemloft.net>
In-Reply-To: <20190507.172000.384528161562920463.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5808bfce-3a59-4591-72ce-08d6d3d006fb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR0302MB2734;
x-ms-traffictypediagnostic: VI1PR0302MB2734:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0302MB2734B98BC407D48F3B3A4ECEC9320@VI1PR0302MB2734.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(376002)(39830400003)(346002)(189003)(199004)(305945005)(6246003)(229853002)(2906002)(5660300002)(6486002)(7736002)(476003)(2616005)(486006)(102836004)(36756003)(54906003)(6916009)(53936002)(6512007)(6306002)(68736007)(25786009)(6436002)(4326008)(256004)(86362001)(83716004)(186003)(71190400001)(71200400001)(4744005)(8676002)(82746002)(81166006)(81156014)(6116002)(8936002)(99286004)(64756008)(66556008)(66476007)(66446008)(316002)(508600001)(966005)(91956017)(33656002)(76176011)(53546011)(66946007)(73956011)(76116006)(6506007)(446003)(11346002)(46003)(14454004)(74482002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2734;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xVk7iubFVfyUziI1HXR7vetzWBtRx9UHtxPxTqZYzxsQdBMLg9dM5Ks9EMIvSM1AHXCkaM75Fciie6GO3hqc3iKMYkdypany75Irull3wAxnl9QQQtNlIbcZi4qCWhMRxzykAEWAeWaW6bqfX2fexHuIoTLomptx8Nxd2ipjp9Nt2OGnFQ4qiUbmdkHab6L23M4MayPT2lEZ0PFyj8untI+TRc8xWImjninow2qUdZ0UVW/9OIYTjL8tijXQPACGN2zybXIRe+9Z0bg8J9+tp03ZK9GkR4rDat4QjB5/aHi6mCxfkUOQyt8ESkbDU5Odrn4BxGAjj3aKeK0wzFPVlt8oOg4bFy2KBhcCCqGty/QzvhnVyjPgWky14RMUd/Cm1iyq0eu8Cm96A8Yv1G+yOXegmEoRDrvWhBxQCKMucwM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0557ECDD62803F49B6325B1C33F92D61@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 5808bfce-3a59-4591-72ce-08d6d3d006fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 16:12:54.1853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2734
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gT24gOCBNYXkgMjAxOSwgYXQgMDE6MjAsIERhdmlkIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD4gd3JvdGU6DQo+IA0KPiANCj4gVGhlIG5ldC1uZXh0IHRyZWUgaXMg
Y2xvc2VkLg0KDQpBcG9sb2dpZXMsIEkgZGlkbuKAmXQgdW5kZXJzdGFuZCB3aGF0IHRoaXMgbWVh
bnQgaW4geW91ciBwcmlvciBtZXNzYWdlLCBoYXZpbmcgcmVhZCBodHRwczovL3d3dy5rZXJuZWwu
b3JnL2RvYy9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvbmV0ZGV2LUZBUS50eHQgYW5kIHNlZW4g
aHR0cDovL3ZnZXIua2VybmVsLm9yZy9+ZGF2ZW0vbmV0LW5leHQuaHRtbCBJIG5vdyBkby4NCg0K
PiANCj4gWW91IHdpbGwgaGF2ZSB0byBzdWJtaXQgdGhpcyBhZ2FpbiB3aGVuIHRoZSBuZXQtbmV4
dCB0cmVlIGlzIG9wZW4NCj4gYWdhaW4uDQoNCkNhdGNoIHlvdSBvbiB0aGUgZmxpcCBzaWRlLCBp
biAyLWlzaCB3ZWVrcyB0aW1lIDotKQ0KDQo+IA0KPiBUaGFuayB5b3UuDQoNClRoYW5rcyBmb3Ig
eW91ciBwYXRpZW5jZS4NCg0KS2V2aW4gRC1CDQoNCmdwZzogMDEyQyBBQ0IyIDI4QzYgQzUzRSA5
Nzc1ICA5MTIzIEIzQTIgMzg5QiA5REUyIDMzNEENCg0K
