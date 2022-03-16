Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADF44DABCC
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347423AbiCPH11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 03:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245150AbiCPH1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 03:27:25 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164FA5F8E0;
        Wed, 16 Mar 2022 00:26:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id E4D445FD04;
        Wed, 16 Mar 2022 10:26:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647415560;
        bh=8Iauk+HjSwn8BjH9AFq0dUmuDvbHkJMAnyi2ZBNSZkw=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=MzYuD7UsCKmkMrolmjzLlC35yd5lCiedPVNA8ecq6Kmzp3j6qbJp85W0dnjn0QYOQ
         QtAU7jd968KOOOdPySodGGqn65ZYgTKSo3ajCcmcABWbZFZw4Z4p29LmN2RDIEcVKx
         atTDskYLUeq7Ou2saJxo+LkCH+30vFQC0K6nlKC19OW7jc0Nv1zmY9PNNpdflIVLkx
         2je4ZxnZEHKo/AXDDFRcSfYTqxkF+e7xRpvubMlCh6PXg/dFhVYFtwXnSuus8wXatm
         k+QC06uyg+8AjyooYBGaaVgp1JcbsD/WTScRlBFmu622IyCtlYjp6sdGj/3HV+zg/W
         Zu6UDALHRf8eg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 16 Mar 2022 10:25:58 +0300 (MSK)
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
Subject: [RFC PATCH v2 0/2] af_vsock: add two new tests for SOCK_SEQPACKET
Thread-Topic: [RFC PATCH v2 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Index: AQHYOQbyso2e/I/ekky/gZ0IvB2spg==
Date:   Wed, 16 Mar 2022 07:25:07 +0000
Message-ID: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <85BC6D4351292846A2D936EEF0EA0315@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/16 03:19:00 #18979713
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
ZXN0LmMgfCAyMTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQoxIGZp
bGUgY2hhbmdlZCwgMjExIGluc2VydGlvbnMoKykNCg0KdjEgLT4gdjI6DQogc2VlIGV2ZXJ5IHBh
dGNoIGFmdGVyICctLS0nIGxpbmUuDQoNCi0tIA0KMi4yNS4xDQo=
