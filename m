Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EF76342F2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiKVRrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbiKVRqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:46:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B18F84331;
        Tue, 22 Nov 2022 09:45:12 -0800 (PST)
Message-ID: <20221122173649.018971915@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669139110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=87QZpCh0faCKJGN7E79B+YLvDwCLrhCyE7zZDe+9ZyU=;
        b=wtECrHcC+cQJKedJl/ID7HXmlF6xyPU87K1kIEWbWThYdz0SdPyIMyKiTohxMyXNZSN03+
        lNqkCwWLR/rNJrh7piFsu58WJuoaS4Klh40CVnY9khH4RfaxRvaylrH3qNJNRIuYslFmQG
        WzWnDENmC+bBjqzmhuJ2EjyX1ycQ+14FeNBBllrPV9ndwhgQkie3iH2Cn8jB6u2hT9B6tn
        vT/LV+B8iyUdS97JWLQ6uebM5DtVQVHQdhRSJeX/g6s4adiQmXIwkXIGfUdCi6xrJ+x0Zt
        9x4WfDQ1950Vev1ue9cVttlHp44YB2TJrNEbNEPKBzR1PpCda1PPeRQS6+6Nxg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669139110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=87QZpCh0faCKJGN7E79B+YLvDwCLrhCyE7zZDe+9ZyU=;
        b=jZfQFAaa7z5EeBEPsw/N6W/viHAdTgwJVIkjofEh/cCCE12KwADUYOs2/fkJk2Dvqo3t03
        h3cUnBpFVKqYrOAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [patch V2 16/17] timers: Update the documentation to reflect on the
 new timer_shutdown() API
References: <20221122171312.191765396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Tue, 22 Nov 2022 18:45:10 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogIlN0ZXZlbiBSb3N0ZWR0IChHb29nbGUpIiA8cm9zdGVkdEBnb29kbWlzLm9yZz4KCklu
IG9yZGVyIHRvIG1ha2Ugc3VyZSB0aGF0IGEgdGltZXIgaXMgbm90IHJlLWFybWVkIGFmdGVyIGl0
IGlzIHN0b3BwZWQKYmVmb3JlIGZyZWVpbmcsIGEgbmV3IHNodXRkb3duIHN0YXRlIGlzIGFkZGVk
IHRvIHRoZSB0aW1lciBjb2RlLiBUaGUgQVBJCnRpbWVyX3NodXRkb3duX3N5bmMoKSBhbmQgdGlt
ZXJfc2h1dGRvd24oKSBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgdGhlCm9iamVjdCB0aGF0IGhvbGRz
IHRoZSB0aW1lciBjYW4gYmUgZnJlZWQuCgpVcGRhdGUgdGhlIGRvY3VtZW50YXRpb24gdG8gcmVm
bGVjdCB0aGlzIG5ldyB3b3JrZmxvdy4KClsgdGdseDogVXBkYXRlZCB0byB0aGUgbmV3IHNlbWFu
dGljcyBhbmQgdXBkYXRlZCB0aGUgemhfQ04gdmVyc2lvbiBdCgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZW4gUm9zdGVkdCAoR29vZ2xlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4KU2lnbmVkLW9mZi1ieTog
VGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+ClRlc3RlZC1ieTogR3VlbnRlciBS
b2VjayA8bGludXhAcm9lY2stdXMubmV0PgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9y
LzIwMjIxMTEwMDY0MTQ3LjcxMjkzNDc5M0Bnb29kbWlzLm9yZwotLS0KIERvY3VtZW50YXRpb24v
UkNVL0Rlc2lnbi9SZXF1aXJlbWVudHMvUmVxdWlyZW1lbnRzLnJzdCAgfCAgICAyICstCiBEb2N1
bWVudGF0aW9uL2NvcmUtYXBpL2xvY2FsX29wcy5yc3QgICAgICAgICAgICAgICAgICAgIHwgICAg
MiArLQogRG9jdW1lbnRhdGlvbi9rZXJuZWwtaGFja2luZy9sb2NraW5nLnJzdCAgICAgICAgICAg
ICAgICB8ICAgIDUgKysrKysKIERvY3VtZW50YXRpb24vdHJhbnNsYXRpb25zL3poX0NOL2NvcmUt
YXBpL2xvY2FsX29wcy5yc3QgfCAgICAyICstCiA0IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkKCi0tLSBhL0RvY3VtZW50YXRpb24vUkNVL0Rlc2lnbi9SZXF1
aXJlbWVudHMvUmVxdWlyZW1lbnRzLnJzdAorKysgYi9Eb2N1bWVudGF0aW9uL1JDVS9EZXNpZ24v
UmVxdWlyZW1lbnRzL1JlcXVpcmVtZW50cy5yc3QKQEAgLTE4NTgsNyArMTg1OCw3IEBAIHVubG9h
ZGVkLiBBZnRlciBhIGdpdmVuIG1vZHVsZSBoYXMgYmVlbgogb25lIG9mIGl0cyBmdW5jdGlvbnMg
cmVzdWx0cyBpbiBhIHNlZ21lbnRhdGlvbiBmYXVsdC4gVGhlIG1vZHVsZS11bmxvYWQKIGZ1bmN0
aW9ucyBtdXN0IHRoZXJlZm9yZSBjYW5jZWwgYW55IGRlbGF5ZWQgY2FsbHMgdG8gbG9hZGFibGUt
bW9kdWxlCiBmdW5jdGlvbnMsIGZvciBleGFtcGxlLCBhbnkgb3V0c3RhbmRpbmcgbW9kX3RpbWVy
KCkgbXVzdCBiZSBkZWFsdAotd2l0aCB2aWEgdGltZXJfZGVsZXRlX3N5bmMoKSBvciBzaW1pbGFy
Lgord2l0aCB2aWEgdGltZXJfc2h1dGRvd25fc3luYygpIG9yIHNpbWlsYXIuCiAKIFVuZm9ydHVu
YXRlbHksIHRoZXJlIGlzIG5vIHdheSB0byBjYW5jZWwgYW4gUkNVIGNhbGxiYWNrOyBvbmNlIHlv
dQogaW52b2tlIGNhbGxfcmN1KCksIHRoZSBjYWxsYmFjayBmdW5jdGlvbiBpcyBldmVudHVhbGx5
IGdvaW5nIHRvIGJlCi0tLSBhL0RvY3VtZW50YXRpb24vY29yZS1hcGkvbG9jYWxfb3BzLnJzdAor
KysgYi9Eb2N1bWVudGF0aW9uL2NvcmUtYXBpL2xvY2FsX29wcy5yc3QKQEAgLTE5MSw3ICsxOTEs
NyBAQCBIZXJlIGlzIGEgc2FtcGxlIG1vZHVsZSB3aGljaCBpbXBsZW1lbnRzCiAKICAgICBzdGF0
aWMgdm9pZCBfX2V4aXQgdGVzdF9leGl0KHZvaWQpCiAgICAgewotICAgICAgICAgICAgdGltZXJf
ZGVsZXRlX3N5bmMoJnRlc3RfdGltZXIpOworICAgICAgICAgICAgdGltZXJfc2h1dGRvd25fc3lu
YygmdGVzdF90aW1lcik7CiAgICAgfQogCiAgICAgbW9kdWxlX2luaXQodGVzdF9pbml0KTsKLS0t
IGEvRG9jdW1lbnRhdGlvbi9rZXJuZWwtaGFja2luZy9sb2NraW5nLnJzdAorKysgYi9Eb2N1bWVu
dGF0aW9uL2tlcm5lbC1oYWNraW5nL2xvY2tpbmcucnN0CkBAIC0xMDA3LDYgKzEwMDcsMTEgQEAg
Y2FsbGluZyBhZGRfdGltZXIoKSBhdCB0aGUgZW5kIG9mIHRoZWlyCiBCZWNhdXNlIHRoaXMgaXMg
YSBmYWlybHkgY29tbW9uIGNhc2Ugd2hpY2ggaXMgcHJvbmUgdG8gcmFjZXMsIHlvdSBzaG91bGQK
IHVzZSB0aW1lcl9kZWxldGVfc3luYygpIChgYGluY2x1ZGUvbGludXgvdGltZXIuaGBgKSB0byBo
YW5kbGUgdGhpcyBjYXNlLgogCitCZWZvcmUgZnJlZWluZyBhIHRpbWVyLCB0aW1lcl9zaHV0ZG93
bigpIG9yIHRpbWVyX3NodXRkb3duX3N5bmMoKSBzaG91bGQgYmUKK2NhbGxlZCB3aGljaCB3aWxs
IGtlZXAgaXQgZnJvbSBiZWluZyByZWFybWVkLiBBbnkgc3Vic2VxdWVudCBhdHRlbXB0IHRvCity
ZWFybSB0aGUgdGltZXIgd2lsbCBiZSBzaWxlbnRseSBpZ25vcmVkIGJ5IHRoZSBjb3JlIGNvZGUu
CisKKwogTG9ja2luZyBTcGVlZAogPT09PT09PT09PT09PQogCi0tLSBhL0RvY3VtZW50YXRpb24v
dHJhbnNsYXRpb25zL3poX0NOL2NvcmUtYXBpL2xvY2FsX29wcy5yc3QKKysrIGIvRG9jdW1lbnRh
dGlvbi90cmFuc2xhdGlvbnMvemhfQ04vY29yZS1hcGkvbG9jYWxfb3BzLnJzdApAQCAtMTg1LDcg
KzE4NSw3IEBAIFVQ5LmL6Ze05rKh5pyJ5LiN5ZCM55qE6KGM5Li677yM5Zyo5L2g77+9CiAKICAg
ICBzdGF0aWMgdm9pZCBfX2V4aXQgdGVzdF9leGl0KHZvaWQpCiAgICAgewotICAgICAgICAgICAg
dGltZXJfZGVsZXRlX3N5bmMoJnRlc3RfdGltZXIpOworICAgICAgICAgICAgdGltZXJfc2h1dGRv
d25fc3luYygmdGVzdF90aW1lcik7CiAgICAgfQogCiAgICAgbW9kdWxlX2luaXQodGVzdF9pbml0
KTsKCg==
