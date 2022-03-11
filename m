Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AEE4D6028
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348000AbiCKKyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiCKKyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:54:07 -0500
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA842A02;
        Fri, 11 Mar 2022 02:52:57 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 666F05FD03;
        Fri, 11 Mar 2022 13:52:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1646995974;
        bh=9rSBR8JGxQz0Wk2XstNzk9JnyfywhXEj+uhA+3pLrgQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=NGW1wUStNxtit3muLwKY3zd3zSfTCKLUwdL8lwg7qVhit5eHFRPlRj6xJBYQloZNN
         7eecMZ0YYCR/5ZVDX9mUart7M+aoitvfn+B6pBm1/+jr/YqPDWs7QL8clGXSEgXAcy
         GJpIKlFlyckm4lwAFzwy+AUgqZv0jbZaSZlxI1rYn4CKRPSDJl050EaF8fGdjPOvZR
         ULbK1ppWyAfn9hM2l5Pp/wUsbmZb8dkTBaDIKiOsNKf09XHFEWDbB3ad9C1KVoI5Hr
         5vCxlH9kdjQlMcxkToI27Kxc5USTrM19Kseb9OuwWTPW21I+zAgYU0Rvkh7D82Cbm1
         noufMgfsGATvw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 11 Mar 2022 13:52:52 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 1/3] af_vsock: add two new tests for SOCK_SEQPACKET
Thread-Topic: [RFC PATCH v1 1/3] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Index: AQHYNTYb8Fo8I4zas06sN3idOLyY0g==
Date:   Fri, 11 Mar 2022 10:52:36 +0000
Message-ID: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <38F466471E8C0F4A936B059DF0BDBF06@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/11 07:23:00 #18938550
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
ZXN0LmMgfCAxNzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQoxIGZp
bGUgY2hhbmdlZCwgMTcwIGluc2VydGlvbnMoKykNCg0KLS0gDQoyLjI1LjENCg==
