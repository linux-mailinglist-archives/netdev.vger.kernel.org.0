Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726C54CB4A2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 03:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiCCCA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 21:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiCCCA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 21:00:26 -0500
X-Greylist: delayed 932 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Mar 2022 17:59:40 PST
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9884838BD5;
        Wed,  2 Mar 2022 17:59:40 -0800 (PST)
Received: from BC-Mail-Ex06.internal.baidu.com (unknown [172.31.51.46])
        by Forcepoint Email with ESMTPS id AFF197E458F57ABBF49E;
        Thu,  3 Mar 2022 09:44:01 +0800 (CST)
Received: from BJHW-MAIL-EX25.internal.baidu.com (10.127.64.40) by
 BC-Mail-Ex06.internal.baidu.com (172.31.51.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 3 Mar 2022 09:44:01 +0800
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-MAIL-EX25.internal.baidu.com (10.127.64.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 3 Mar 2022 09:44:01 +0800
Received: from BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) by
 BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) with mapi id
 15.01.2308.020; Thu, 3 Mar 2022 09:44:01 +0800
From:   "Cai,Huoqing" <caihuoqing@baidu.com>
To:     Jianglei Nie <niejianglei2021@163.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Thread-Topic: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Thread-Index: AQHYLp5LKcUpXpLQGUa95DdJWAWshKys4eVw
Date:   Thu, 3 Mar 2022 01:44:01 +0000
Message-ID: <b2cfc764839a459f86eb46ae0286e9a0@baidu.com>
References: <20220303013022.459154-1-niejianglei2021@163.com>
In-Reply-To: <20220303013022.459154-1-niejianglei2021@163.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.18.80.46]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmlhbmdsZWkg
TmllIDxuaWVqaWFuZ2xlaTIwMjFAMTYzLmNvbT4NCj4gU2VudDogMjAyMsTqM9TCM8jVIDk6MzAN
Cj4gVG86IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgQ2FpLEh1b3FpbmcN
Cj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IEppYW5nbGVpIE5pZQ0KPiBTdWJqZWN0OiBbUEFUQ0hdIG5ldDogYXJjX2VtYWM6IEZpeCB1
c2UgYWZ0ZXIgZnJlZSBpbiBhcmNfbWRpb19wcm9iZSgpDQo+IA0KPiBJZiBidXMtPnN0YXRlIGlz
IGVxdWFsIHRvIE1ESU9CVVNfQUxMT0NBVEVELCBtZGlvYnVzX2ZyZWUoYnVzKSB3aWxsIGZyZWUN
Cj4gdGhlICJidXMiLiBCdXQgYnVzLT5uYW1lIGlzIHN0aWxsIHVzZWQgaW4gdGhlIG5leHQgbGlu
ZSwgd2hpY2ggd2lsbCBsZWFkDQo+IHRvIGEgdXNlIGFmdGVyIGZyZWUuDQo+IA0KPiBXZSBjYW4g
Zml4IGl0IGJ5IGFzc2lnbmluZyBkZXZfZXJyX3Byb2JlKCkgdG8gZGV2X2VyciBiZWZvcmUgdGhl
IGJ1cyBpcw0KPiBmcmVlZCB0byBhdm9pZCB0aGUgdWFmLg0KQWRkIGZpeCBsb2cgaGVyZTopDQpG
aXhlczogOTViNWZjMDNjMTg5ICgibmV0OiBhcmNfZW1hYzogTWFrZSB1c2Ugb2YgdGhlIGhlbHBl
ciBmdW5jdGlvbiBkZXZfZXJyX3Byb2JlKCkiKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmlhbmds
ZWkgTmllIDxuaWVqaWFuZ2xlaTIwMjFAMTYzLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9hcmMvZW1hY19tZGlvLmMgfCA1ICsrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2FyYy9lbWFjX21kaW8uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fy
Yy9lbWFjX21kaW8uYw0KPiBpbmRleCA5YWNmNTg5YjExNzguLjc5NWEyNWM1ODQ4YSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXJjL2VtYWNfbWRpby5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FyYy9lbWFjX21kaW8uYw0KPiBAQCAtMTY1LDkgKzE2NSwxMCBA
QCBpbnQgYXJjX21kaW9fcHJvYmUoc3RydWN0IGFyY19lbWFjX3ByaXYgKnByaXYpDQo+IA0KPiAg
CWVycm9yID0gb2ZfbWRpb2J1c19yZWdpc3RlcihidXMsIHByaXYtPmRldi0+b2Zfbm9kZSk7DQo+
ICAJaWYgKGVycm9yKSB7DQo+IC0JCW1kaW9idXNfZnJlZShidXMpOw0KPiAtCQlyZXR1cm4gZGV2
X2Vycl9wcm9iZShwcml2LT5kZXYsIGVycm9yLA0KPiArCQlpbnQgZGV2X2VyciA9IGRldl9lcnJf
cHJvYmUocHJpdi0+ZGV2LCBlcnJvciwNCj4gIAkJCQkgICAgICJjYW5ub3QgcmVnaXN0ZXIgTURJ
TyBidXMgJXNcbiIsIGJ1cy0NCj4gPm5hbWUpOw0KPiArCQltZGlvYnVzX2ZyZWUoYnVzKTsNCj4g
KwkJcmV0dXJuIGRldl9lcnI7DQo+ICAJfQ0KPiANCj4gIAlyZXR1cm4gMDsNCj4gLS0NCj4gMi4y
NS4xDQoNCg==
