Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A68269E869
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBUTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBUTh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:37:57 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1ED1556B;
        Tue, 21 Feb 2023 11:37:55 -0800 (PST)
Received: from maxwell ([109.42.115.188]) by mrelayeu.kundenserver.de
 (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MLRDv-1pDIgO3GwF-00ITDs; Tue, 21 Feb 2023 20:37:27 +0100
References: <87fsaz6smr.fsf@henneberg-systemdesign.com>
 <Y/T0NRtorZn74EH3@corigine.com>
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2] net: stmmac: Premature loop termination check
 was ignored
Date:   Tue, 21 Feb 2023 20:35:25 +0100
In-reply-to: <Y/T0NRtorZn74EH3@corigine.com>
Message-ID: <877cwa7qtm.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:0u8rYgmp9bhY/iDXFU3B1tZaxQ+5aTcRHMJgkC1asXab22AA2cm
 8hNer//gFftW5zMJmS0OGwIMpVmCTrizh0H9L7v95+b+qKKQIXQxeBWrT8uTSD+BPaqAsZ2
 SxpUfRjtKZBOv9NvrIxikRZPsOt3MdG22XqRtXcn3osuHorBmsP0oeG8JViiLDRR5g39qnP
 Y9CIhIWvKmgS59PBH2A5Q==
UI-OutboundReport: notjunk:1;M01:P0:Mg6DrOlZEeI=;wZAdP1leOOBHltclXahfqutetpA
 k3esz5E4vIKMIvnehBqXryrzJzasNZLFQfRiUvZIxEN+44508EOhukCXdJgDZa38zZ/Z01QCI
 J4z0CEPs/6pq4Fxd1RkrfuPit8ZFXUq5QmhI53VVd4FUJRCQjROm4qrj4hLIZ55B/ihXl+Iv0
 XKvtYqn7jy8AXO8sxx+oOdSEiHNZmCx4LA5XaE+ULW59pqsYDQo6mSi+PBF950VvTCUKFsJ9s
 wgI42mvtJACdznjnOC3Byxc7XZ8zfhU27J8CE3RPvtv2IvTcJDrtkeQ5PUpegRmYMzMbrWQd1
 D/7bY/aMkWo0nAbMyUS0YprMZMi4dz5rmZPd0F+FYUGQgvRMOI5jZWD7URhIdXeG5fDYWFC6I
 cfsH8xvpxptlbLsZ09Xx4GUr2MrqfWUK4hQ2G2SS0WZNpQai3InKMwN7XUx2ivq9pL3/0AktW
 I9crEuzHvWuJvfqLXARoFJLslSCkiy/fZ+6piB7q6628CwZ3oe4lld6tccTP2vlqaMhzq2ff0
 uIUlqojMk7OKdPPiLEyp1XtgVFnIpptuGxqN/z4XOo0jQYZsKzZbsJu9WxQIHVM1BlfRjc8uC
 kJJaX7RUDf7klge2dMUEe1sh9uN9ETGLVkXWEAQU8DuqIbsrDzHbHDfZ98tTlk/zxx4jDfas6
 7boqcOChDavFIJ6hLzDL1Au3beYFhEFyj+82aAcCUQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The premature loop termination check makes sense only in case of the
jump to read_again where the count may have been updated. But
read_again did not include the check.

Fixes: bba2556efad6 (net: stmmac: Enable RX via AF_XDP zero-copy)
Fixes: ec222003bd94 (net: stmmac: Prepare to add Split Header support)
Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
V2: Added fixes tags for both commits that introduced the issue

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a5b8dab5e9b..de98c009866a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
@@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		buf2_len = 0;
 		entry = next_entry;
-- 
2.39.2
