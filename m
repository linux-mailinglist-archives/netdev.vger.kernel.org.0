Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C884DBEC4
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 06:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiCQFyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 01:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiCQFy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 01:54:29 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83F8243179;
        Wed, 16 Mar 2022 22:25:32 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 4B8325FD06;
        Thu, 17 Mar 2022 08:25:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647494730;
        bh=0glQwIKIiSufGCHmagtfkwCzZanRCG4rlbbnru054do=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=Z6AnF60s2ny2xlua2Zj8AjBJDPp9hhIFgtEtfM29II9goDFQCkB+jrCuTKUspD/pK
         8KdTZc/3JOiCeuthvymI0jrd2c1DXCTZazEmSgq8ZgFWyAsV85Luk7PbGhUPtguPHb
         KXUxjOmnWKmJbER24GS3/Rq9l4/yz+OwIy7AIEQ8FoQ86a6bzv/biz6A3ih1xmC3nx
         EGHFx+Gil/myM+ntONqTXlmo8qqsFMytw6MKmHcYybUWHGSkMBDdLyfWc8C1vHl92u
         RnpjoF607knrefpk479o8zwXbk4UlAMaRWLP9XpP+feh7vEPUHlyuCO0kJ4s2zTNjX
         R9jQBvOC8wWfQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 08:25:28 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 0/2] af_vsock: add two new tests for,
 SOCK_SEQPACKET
Thread-Topic: [PATCH net-next v3 0/2] af_vsock: add two new tests for,
 SOCK_SEQPACKET
Thread-Index: AQHYOb9BasW0R6dbkEaL5d59R2bAxg==
Date:   Thu, 17 Mar 2022 05:24:26 +0000
Message-ID: <4ecfa306-a374-93f6-4e66-be62895ae4f7@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C75275A026858344B1E4ABB08198FFEE@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/17 01:49:00 #18989990
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
ciAnLS0tJyBsaW5lLg0KDQotLSANCjIuMjUuMQ0K
