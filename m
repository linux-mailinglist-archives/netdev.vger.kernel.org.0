Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305A0636AF5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiKWUWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239592AbiKWUVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:21:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D0AC78CC;
        Wed, 23 Nov 2022 12:19:11 -0800 (PST)
Message-ID: <20221123201625.375284489@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669234735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=8mCfHxFOZzbOCsR313/bDzGhRTnb1fj4Q7VlJBNG0jE=;
        b=gsOHJxPeeeijJQ12VQfyqzGPX8xgyqZ96mWswxQCmi0j/GQ/N8eEa/pq5VJHwopx9L3PEG
        LB5I2kBB3h2QVSODmoCyUGI/dS7geEHzN74Ak1KEo9W5UkS/hf6yV8lITtey/5T7dJTemI
        KleqRuSumcCg2MAH+nAd6Bpi+YQ4wVPn8xj1+IvaSmpzZ13efp5MdqdCTa2mjb3d+MGJcC
        F9j8c9wv+5EJV9gOoPhtkzPnqEUEsGXHea+yEPHZeKkeKWOb5pJsPaVTKjLPzucEKimo4l
        3YyEaUFT7VqhaItBqAyU2VfCbZp9nc0nECPk9TQsmRXmvABOWcbborbkjpn1FQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669234735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=8mCfHxFOZzbOCsR313/bDzGhRTnb1fj4Q7VlJBNG0jE=;
        b=nN2gBcA8qa+c86/g9eNv5e51qKePiLEGDO3stJq4tkr3jZGsTDWvbRhR0cOUM6VloCC2XF
        P8Ox1KfFtz+yQJBA==
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [patch V3 16/17] timers: Update the documentation to reflect on the
 new timer_shutdown() API
References: <20221123201306.823305113@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Wed, 23 Nov 2022 21:18:55 +0100 (CET)
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
b2VjayA8bGludXhAcm9lY2stdXMubmV0PgpSZXZpZXdlZC1ieTogSmFjb2IgS2VsbGVyIDxqYWNv
Yi5lLmtlbGxlckBpbnRlbC5jb20+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAy
MjExMTAwNjQxNDcuNzEyOTM0NzkzQGdvb2RtaXMub3JnCi0tLQogRG9jdW1lbnRhdGlvbi9SQ1Uv
RGVzaWduL1JlcXVpcmVtZW50cy9SZXF1aXJlbWVudHMucnN0ICB8ICAgIDIgKy0KIERvY3VtZW50
YXRpb24vY29yZS1hcGkvbG9jYWxfb3BzLnJzdCAgICAgICAgICAgICAgICAgICAgfCAgICAyICst
CiBEb2N1bWVudGF0aW9uL2tlcm5lbC1oYWNraW5nL2xvY2tpbmcucnN0ICAgICAgICAgICAgICAg
IHwgICAgNSArKysrKwogRG9jdW1lbnRhdGlvbi90cmFuc2xhdGlvbnMvemhfQ04vY29yZS1hcGkv
bG9jYWxfb3BzLnJzdCB8ICAgIDIgKy0KIDQgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQoKLS0tIGEvRG9jdW1lbnRhdGlvbi9SQ1UvRGVzaWduL1JlcXVpcmVt
ZW50cy9SZXF1aXJlbWVudHMucnN0CisrKyBiL0RvY3VtZW50YXRpb24vUkNVL0Rlc2lnbi9SZXF1
aXJlbWVudHMvUmVxdWlyZW1lbnRzLnJzdApAQCAtMTg1OCw3ICsxODU4LDcgQEAgdW5sb2FkZWQu
IEFmdGVyIGEgZ2l2ZW4gbW9kdWxlIGhhcyBiZWVuCiBvbmUgb2YgaXRzIGZ1bmN0aW9ucyByZXN1
bHRzIGluIGEgc2VnbWVudGF0aW9uIGZhdWx0LiBUaGUgbW9kdWxlLXVubG9hZAogZnVuY3Rpb25z
IG11c3QgdGhlcmVmb3JlIGNhbmNlbCBhbnkgZGVsYXllZCBjYWxscyB0byBsb2FkYWJsZS1tb2R1
bGUKIGZ1bmN0aW9ucywgZm9yIGV4YW1wbGUsIGFueSBvdXRzdGFuZGluZyBtb2RfdGltZXIoKSBt
dXN0IGJlIGRlYWx0Ci13aXRoIHZpYSB0aW1lcl9kZWxldGVfc3luYygpIG9yIHNpbWlsYXIuCit3
aXRoIHZpYSB0aW1lcl9zaHV0ZG93bl9zeW5jKCkgb3Igc2ltaWxhci4KIAogVW5mb3J0dW5hdGVs
eSwgdGhlcmUgaXMgbm8gd2F5IHRvIGNhbmNlbCBhbiBSQ1UgY2FsbGJhY2s7IG9uY2UgeW91CiBp
bnZva2UgY2FsbF9yY3UoKSwgdGhlIGNhbGxiYWNrIGZ1bmN0aW9uIGlzIGV2ZW50dWFsbHkgZ29p
bmcgdG8gYmUKLS0tIGEvRG9jdW1lbnRhdGlvbi9jb3JlLWFwaS9sb2NhbF9vcHMucnN0CisrKyBi
L0RvY3VtZW50YXRpb24vY29yZS1hcGkvbG9jYWxfb3BzLnJzdApAQCAtMTkxLDcgKzE5MSw3IEBA
IEhlcmUgaXMgYSBzYW1wbGUgbW9kdWxlIHdoaWNoIGltcGxlbWVudHMKIAogICAgIHN0YXRpYyB2
b2lkIF9fZXhpdCB0ZXN0X2V4aXQodm9pZCkKICAgICB7Ci0gICAgICAgICAgICB0aW1lcl9kZWxl
dGVfc3luYygmdGVzdF90aW1lcik7CisgICAgICAgICAgICB0aW1lcl9zaHV0ZG93bl9zeW5jKCZ0
ZXN0X3RpbWVyKTsKICAgICB9CiAKICAgICBtb2R1bGVfaW5pdCh0ZXN0X2luaXQpOwotLS0gYS9E
b2N1bWVudGF0aW9uL2tlcm5lbC1oYWNraW5nL2xvY2tpbmcucnN0CisrKyBiL0RvY3VtZW50YXRp
b24va2VybmVsLWhhY2tpbmcvbG9ja2luZy5yc3QKQEAgLTEwMDcsNiArMTAwNywxMSBAQCBjYWxs
aW5nIGFkZF90aW1lcigpIGF0IHRoZSBlbmQgb2YgdGhlaXIKIEJlY2F1c2UgdGhpcyBpcyBhIGZh
aXJseSBjb21tb24gY2FzZSB3aGljaCBpcyBwcm9uZSB0byByYWNlcywgeW91IHNob3VsZAogdXNl
IHRpbWVyX2RlbGV0ZV9zeW5jKCkgKGBgaW5jbHVkZS9saW51eC90aW1lci5oYGApIHRvIGhhbmRs
ZSB0aGlzIGNhc2UuCiAKK0JlZm9yZSBmcmVlaW5nIGEgdGltZXIsIHRpbWVyX3NodXRkb3duKCkg
b3IgdGltZXJfc2h1dGRvd25fc3luYygpIHNob3VsZCBiZQorY2FsbGVkIHdoaWNoIHdpbGwga2Vl
cCBpdCBmcm9tIGJlaW5nIHJlYXJtZWQuIEFueSBzdWJzZXF1ZW50IGF0dGVtcHQgdG8KK3JlYXJt
IHRoZSB0aW1lciB3aWxsIGJlIHNpbGVudGx5IGlnbm9yZWQgYnkgdGhlIGNvcmUgY29kZS4KKwor
CiBMb2NraW5nIFNwZWVkCiA9PT09PT09PT09PT09CiAKLS0tIGEvRG9jdW1lbnRhdGlvbi90cmFu
c2xhdGlvbnMvemhfQ04vY29yZS1hcGkvbG9jYWxfb3BzLnJzdAorKysgYi9Eb2N1bWVudGF0aW9u
L3RyYW5zbGF0aW9ucy96aF9DTi9jb3JlLWFwaS9sb2NhbF9vcHMucnN0CkBAIC0xODUsNyArMTg1
LDcgQEAgVVDkuYvpl7TmsqHmnInkuI3lkIznmoTooYzkuLrvvIzlnKjkvaDvv70KIAogICAgIHN0
YXRpYyB2b2lkIF9fZXhpdCB0ZXN0X2V4aXQodm9pZCkKICAgICB7Ci0gICAgICAgICAgICB0aW1l
cl9kZWxldGVfc3luYygmdGVzdF90aW1lcik7CisgICAgICAgICAgICB0aW1lcl9zaHV0ZG93bl9z
eW5jKCZ0ZXN0X3RpbWVyKTsKICAgICB9CiAKICAgICBtb2R1bGVfaW5pdCh0ZXN0X2luaXQpOwoK
