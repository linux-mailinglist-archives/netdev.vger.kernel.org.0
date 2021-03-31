Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2E334F676
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhCaCDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbhCaCDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:03:03 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28219C061574;
        Tue, 30 Mar 2021 19:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=DcSskP8B4CWNXBYnK2+AtYODix9KPxwm3sCY
        rw4gNP0=; b=AeKZgHy2riAm3+brGQVmGiZplE1Rpwyg5HTjlLgDJ14peuBaOPzW
        xmD3wDXU0sTlSOBd7fhz0TQ2Keo8fVEDQ2CiPR5uESqMPaM/8uy9wiBEBhXfZ0Sg
        W5ZTt+anrgf5mSzFC+bBytReHQ4F7YsmwH548spFGIQFjxxPxoOW5+c=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Wed, 31 Mar
 2021 10:02:57 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Wed, 31 Mar 2021 10:02:57 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "David Miller" <davem@davemloft.net>
Cc:     santosh.shilimkar@oracle.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] net/rds: Fix a use after free in
 rds_message_map_pages
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210330.170228.191449180243560631.davem@davemloft.net>
References: <20210330101602.22505-1-lyl2019@mail.ustc.edu.cn>
 <20210330.170228.191449180243560631.davem@davemloft.net>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3c258c4e.20f4b.1788604fd68.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygBnb39R2GNgUL90AA--.5W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoRBlQhn5kl4AABsr
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIkRhdmlkIE1pbGxl
ciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IOWPkemAgeaXtumXtDogMjAyMS0wMy0zMSAwODow
MjoyOCAo5pif5pyf5LiJKQ0KPiDmlLbku7bkuro6IGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbg0K
PiDmioTpgIE6IHNhbnRvc2guc2hpbGlta2FyQG9yYWNsZS5jb20sIGt1YmFAa2VybmVsLm9yZywg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZywgbGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmcsIHJkcy1k
ZXZlbEBvc3Mub3JhY2xlLmNvbSwgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiDkuLvp
opg6IFJlOiBbUEFUQ0hdIG5ldC9yZHM6IEZpeCBhIHVzZSBhZnRlciBmcmVlIGluIHJkc19tZXNz
YWdlX21hcF9wYWdlcw0KPiANCj4gRnJvbTogTHYgWXVubG9uZyA8bHlsMjAxOUBtYWlsLnVzdGMu
ZWR1LmNuPg0KPiBEYXRlOiBUdWUsIDMwIE1hciAyMDIxIDAzOjE2OjAyIC0wNzAwDQo+IA0KPiA+
IEBAIC0zNDgsNyArMzQ4LDcgQEAgc3RydWN0IHJkc19tZXNzYWdlICpyZHNfbWVzc2FnZV9tYXBf
cGFnZXModW5zaWduZWQgbG9uZyAqcGFnZV9hZGRycywgdW5zaWduZWQgaW4NCj4gPiAgCXJtLT5k
YXRhLm9wX3NnID0gcmRzX21lc3NhZ2VfYWxsb2Nfc2dzKHJtLCBudW1fc2dzKTsNCj4gPiAgCWlm
IChJU19FUlIocm0tPmRhdGEub3Bfc2cpKSB7DQo+ID4gIAkJcmRzX21lc3NhZ2VfcHV0KHJtKTsN
Cj4gPiAtCQlyZXR1cm4gRVJSX0NBU1Qocm0tPmRhdGEub3Bfc2cpOw0KPiA+ICsJCXJldHVybiBF
UlJfUFRSKC1FTk9NRU0pOw0KPiA+ICAJfQ0KPiA+ICANCj4gPiAgCWZvciAoaSA9IDA7IGkgPCBy
bS0+ZGF0YS5vcF9uZW50czsgKytpKSB7DQo+IA0KPiBNYXliZSBpbnN0ZWFkIGRvOg0KPiANCj4g
ICAgICAgaW50IGVyciA9IEVSUl9DQVNUKHJtLT5kYXRhLm9wX3NnKTsNCj4gICAgICAgcmRzX21l
c3NhZ2VfcHV0KHJtKTsNCj4gICAgICAgcmV0dXJuIGVycjsNCj4gDQo+IFRoZW4gaWYgcmRzX21l
c3NhZ2VfYWxsb2Nfc2dzKCkgc3RhcnRzIHRvIHJldHVybiBvdGhlciBlcnJvcnMsIHRoZXkgd2ls
bCBwcm9wYWdhdGUuDQo+IA0KPiBUaGFuayB5b3UuDQoNClRoZSB0eXBlIG9mIEVSUl9DQVNUKCkg
aXMgdm9pZCAqLCBub3QgaW50LiANCkkgdGhpbmsgdGhlIGNvcnJlY3QgcGF0Y2ggaXM6DQoNCiAg
ICAgICAgdm9pZCAqZXJyID0gRVJSX0NBU1Qocm0tPmRhdGEub3Bfc2cpOw0KICAgICAgICByZHNf
bWVzc2FnZV9wdXQocm0pOw0KICAgICAgICByZXR1cm4gZXJyOw0KDQpJIGhhdmUgc3VibWl0dGVk
IHRoZSBQQVRDSCB2MiBmb3IgeW91IHRvIHJldmlldy4NCg0KVGhhbmtzLg0K
