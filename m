Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722E61C7C7C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgEFVdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:23 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:53575 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729152AbgEFVdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:33:22 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c1797ad1;
        Wed, 6 May 2020 21:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=SZ+7gT7++HRheT9GPfZjo5R/I
        cw=; b=Al5TclrdIGH9fhTsPxxbGYXp+n6d/V8wc/+vREbb/+HERF5JSlC7kQ956
        eklLV8PeKlCUvtwU4rdnc8l23k8EWLxCRrSS0JYI22wffzeNBMW/m2r5wKLgW18/
        aij0aapfounXSseM/maB0mPq1iyvvQKlJAOHPf2+phh1ww/Gg8GRQIEcLExkAurO
        0ogMni6APDIfX/WLlxoWBNvIWX6xobbkjGTeADBFk+gL2fh1nn8o4TYy9e0ikHBh
        T+jTB/MQsKJSayKaMCG1JyMbE/SWf0W0Pg1CP4hDTvu0CxyWp16z7nSyGtRJWrBu
        LH883eilUopBipcCCuccoIlMiz+2Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4ffbcace (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 6 May 2020 21:20:36 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/5] wireguard: selftests: use normal kernel stack size on ppc64
Date:   Wed,  6 May 2020 15:33:02 -0600
Message-Id: <20200506213306.1344212-2-Jason@zx2c4.com>
In-Reply-To: <20200506213306.1344212-1-Jason@zx2c4.com>
References: <20200506213306.1344212-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While at some point it might have made sense to be running these tests
on ppc64 with 4k stacks, the kernel hasn't actually used 4k stacks on
64-bit powerpc in a long time, and more interesting things that we test
don't really work when we deviate from the default (16k). So, we stop
pushing our luck in this commit, and return to the default instead of
the minimum.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config b/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config
index 990c510a9cfa..f52f1e2bc7f6 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/powerpc64le.config
@@ -10,3 +10,4 @@ CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=hvc0 wg.success=hvc1"
 CONFIG_SECTION_MISMATCH_WARN_ONLY=y
 CONFIG_FRAME_WARN=1280
+CONFIG_THREAD_SHIFT=14
-- 
2.26.2

