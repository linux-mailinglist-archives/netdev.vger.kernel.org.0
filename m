Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7906E636ADB
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbiKWUTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239259AbiKWUSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:18:55 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82C991C3D;
        Wed, 23 Nov 2022 12:18:33 -0800 (PST)
Message-ID: <20221123201624.452282769@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669234711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=A2SY6j6h29m5XzjJBWQT9Lgn9maXUZXQdJe6ibdVF0Q=;
        b=oxrZpu8gy33vwLcTyeM9oUZzX6+fHMndkO85dqJdBjQrSOlDMZXxKsuysYXvvmQHsqdC1S
        dKmZpYRS9o//g+Tdxxsl3tdMHRDB2YGKAGnEx49qjFcr0Gi411RoXRYTsOxxswVKJax0CZ
        vduRr0EltYhwJQk6uWt+OB4vzGGMuKuDZIrGn1PmUj9YEv4vNktARpIEfHcJqkmECgFcBm
        +ehVfa4j/C9yB4fL3cStETcyNfdvCYhhQyw6Ac8e1BUk3vWTcJmynotgVrc6CglkAm/XeB
        j1CBJiGkmlaI1IxWLnv2jiCv/HSwdnC5Qfh4rV6zCBmvJv7FKJsyFk+GFnePqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669234711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=A2SY6j6h29m5XzjJBWQT9Lgn9maXUZXQdJe6ibdVF0Q=;
        b=frCxv+JYFv1m5JDYMLoiXzjV44LB/mMTKPW9MZAUzVGCvutW27XlDRZ8jQv7X5I18KDaiL
        g2pBWVq5VkpFKbBg==
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
Subject: [patch V3 01/17] Documentation: Remove bogus claim about del_timer_sync()
References: <20221123201306.823305113@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Wed, 23 Nov 2022 21:18:31 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZGVsX3RpbWVyX3N5bmMoKSBkb2VzIG5vdCByZXR1cm4gdGhlIG51bWJlciBvZiB0aW1lcyBpdCB0
cmllZCB0byBkZWxldGUgdGhlCnRpbWVyIHdoaWNoIHJlYXJtcyBpdHNlbGYuIEl0J3MgY2xlYXJs
eSBkb2N1bWVudGVkOgoKIFRoZSBmdW5jdGlvbiByZXR1cm5zIHdoZXRoZXIgaXQgaGFzIGRlYWN0
aXZhdGVkIGEgcGVuZGluZyB0aW1lciBvciBub3QuCgpUaGlzIHBhcnQgb2YgdGhlIGRvY3VtZW50
YXRpb24gaXMgZnJvbSAyMDAzIHdoZXJlIGRlbF90aW1lcl9zeW5jKCkgcmVhbGx5CnJldHVybmVk
IHRoZSBudW1iZXIgb2YgZGVsZXRpb24gYXR0ZW1wdHMgZm9yIHVua25vd24gcmVhc29ucy4gVGhl
IGNvZGUKd2FzIHJld3JpdHRlbiBpbiAyMDA1LCBidXQgdGhlIGRvY3VtZW50YXRpb24gd2FzIG5v
dCB1cGRhdGVkLgoKU2lnbmVkLW9mZi1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9u
aXguZGU+ClJldmlld2VkLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNv
bT4KLS0tCiBEb2N1bWVudGF0aW9uL2tlcm5lbC1oYWNraW5nL2xvY2tpbmcucnN0ICAgICAgICAg
ICAgICAgICAgICB8ICAgIDMgKy0tCiBEb2N1bWVudGF0aW9uL3RyYW5zbGF0aW9ucy9pdF9JVC9r
ZXJuZWwtaGFja2luZy9sb2NraW5nLnJzdCB8ICAgIDQgKy0tLQogMiBmaWxlcyBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgotLS0gYS9Eb2N1bWVudGF0aW9uL2tlcm5l
bC1oYWNraW5nL2xvY2tpbmcucnN0CisrKyBiL0RvY3VtZW50YXRpb24va2VybmVsLWhhY2tpbmcv
bG9ja2luZy5yc3QKQEAgLTEwMDYsOCArMTAwNiw3IEBAIEFub3RoZXIgY29tbW9uIHByb2JsZW0g
aXMgZGVsZXRpbmcgdGltZXIKIGNhbGxpbmcgYWRkX3RpbWVyKCkgYXQgdGhlIGVuZCBvZiB0aGVp
ciB0aW1lciBmdW5jdGlvbikuCiBCZWNhdXNlIHRoaXMgaXMgYSBmYWlybHkgY29tbW9uIGNhc2Ug
d2hpY2ggaXMgcHJvbmUgdG8gcmFjZXMsIHlvdSBzaG91bGQKIHVzZSBkZWxfdGltZXJfc3luYygp
IChgYGluY2x1ZGUvbGludXgvdGltZXIuaGBgKSB0bwotaGFuZGxlIHRoaXMgY2FzZS4gSXQgcmV0
dXJucyB0aGUgbnVtYmVyIG9mIHRpbWVzIHRoZSB0aW1lciBoYWQgdG8gYmUKLWRlbGV0ZWQgYmVm
b3JlIHdlIGZpbmFsbHkgc3RvcHBlZCBpdCBmcm9tIGFkZGluZyBpdHNlbGYgYmFjayBpbi4KK2hh
bmRsZSB0aGlzIGNhc2UuCiAKIExvY2tpbmcgU3BlZWQKID09PT09PT09PT09PT0KLS0tIGEvRG9j
dW1lbnRhdGlvbi90cmFuc2xhdGlvbnMvaXRfSVQva2VybmVsLWhhY2tpbmcvbG9ja2luZy5yc3QK
KysrIGIvRG9jdW1lbnRhdGlvbi90cmFuc2xhdGlvbnMvaXRfSVQva2VybmVsLWhhY2tpbmcvbG9j
a2luZy5yc3QKQEAgLTEwMjcsOSArMTAyNyw3IEBAIFVuIGFsdHJvIHByb2JsZW1hIMOoIGwnZWxp
bWluYXppb25lIGRlaQogZGEgc29saSAoY2hpYW1hbmRvIGFkZF90aW1lcigpIGFsbGEgZmluZSBk
ZWxsYSBsb3JvIGVzZWN1emlvbmUpLgogRGF0byBjaGUgcXVlc3RvIMOoIHVuIHByb2JsZW1hIGFi
YmFzdGFuemEgY29tdW5lIGNvbiB1bmEgcHJvcGVuc2lvbmUKIGFsbGUgY29yc2UgY3JpdGljaGUs
IGRvdnJlc3RlIHVzYXJlIGRlbF90aW1lcl9zeW5jKCkKLShgYGluY2x1ZGUvbGludXgvdGltZXIu
aGBgKSBwZXIgZ2VzdGlyZSBxdWVzdG8gY2Fzby4gUXVlc3RhIHJpdG9ybmEgaWwKLW51bWVybyBk
aSB2b2x0ZSBjaGUgaWwgdGVtcG9yaXp6YXRvcmUgw6ggc3RhdG8gaW50ZXJyb3R0byBwcmltYSBj
aGUKLWZvc3NlIGluIGdyYWRvIGRpIGZlcm1hcmxvIHNlbnphIGNoZSBzaSByaWF2dmlhc3NlLgor
KGBgaW5jbHVkZS9saW51eC90aW1lci5oYGApIHBlciBnZXN0aXJlIHF1ZXN0byBjYXNvLgogCiBW
ZWxvY2l0w6AgZGVsbGEgc2luY3Jvbml6emF6aW9uZQogPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQoK
