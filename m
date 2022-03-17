Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A055F4DC141
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiCQIc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCQIc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:32:27 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A21196D55;
        Thu, 17 Mar 2022 01:31:05 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id DEFDD5FD05;
        Thu, 17 Mar 2022 11:31:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647505862;
        bh=y4okb8u4vPpWQoxg9kRYRu10eVTvWGN37KpbgRv2jGA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=oaay5TIgPLWl3+3PcdxWwZ4TOM5uTtEsi2Sj9bazOkGbhfZuYIPP9vb0rlAD0/mSa
         8S4Gdh4uaF7oy7cV7aTcitjTLn/j7Mv8p3iM0qBFJPGZ68i6ASLvGYQ4T2p1gh0uJK
         oB87Wt8iYPbCOjBDamSIsiQZXZqUasFPAMGa34P4QMrZaDQhcAZ5eytWCnjvGFnpsg
         reLmjyXBSy3lAHwTGChIsXAK/r8Gfpd7QPK88sh0f7tU4I5B24SbTArIfQ9jQs3jpD
         5mjA89q8hX2xLF8qE9qsvV1mXPKIMSwsLhRM34lUtkOjcLZQ7DpZ+4wVMJAoXVxtES
         FNz0Y6RSxhMBA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 11:31:02 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: [PATCH net-next v4 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Topic: [PATCH net-next v4 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Index: AQHYOdkn7YTNsId4DUmR+TugFQYSWA==
Date:   Thu, 17 Mar 2022 08:29:50 +0000
Message-ID: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B08A18727E4C94B97CE9E6C020F9BD3@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/17 04:52:00 #18991242
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHR3byB0ZXN0czogZm9yIHJlY2VpdmUgdGltZW91dCBhbmQgcmVhZGluZyB0byBp
bnZhbGlkDQpidWZmZXIgcHJvdmlkZWQgYnkgdXNlci4gSSBmb3Jnb3QgdG8gcHV0IGJvdGggcGF0
Y2hlcyB0byBtYWluDQpwYXRjaHNldC4NCg0KQXJzZW5peSBLcmFzbm92KDIpOg0KDQphZl92c29j
azogU09DS19TRVFQQUNLRVQgcmVjZWl2ZSB0aW1lb3V0IHRlc3QNCmFmX3Zzb2NrOiBTT0NLX1NF
UVBBQ0tFVCBicm9rZW4gYnVmZmVyIHRlc3QNCg0KdG9vbHMvdGVzdGluZy92c29jay92c29ja190
ZXN0LmMgfCAyMTUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQoxIGZp
bGUgY2hhbmdlZCwgMjE1IGluc2VydGlvbnMoKykNCg0KdjEgLT4gdjI6DQogc2VlIGV2ZXJ5IHBh
dGNoIGFmdGVyICctLS0nIGxpbmUuDQoNCnYyIC0+IHYzOg0KIHNlZSBldmVyeSBwYXRjaCBhZnRl
ciAnLS0tJyBsaW5lLg0KDQp2MyAtPiB2NDoNCiBzZWUgZXZlcnkgcGF0Y2ggYWZ0ZXIgJy0tLScg
bGluZS4NCg0KLS0gDQoyLjI1LjENCg==
