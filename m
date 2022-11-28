Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654EA63ACD0
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiK1Pnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiK1Pnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:43:35 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82D21D67B
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:43:34 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x2so16009310edd.2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGVijVIXjZ7j9/h6FCoDsleW1+RkPFK8TRFdOx8adZ0=;
        b=a8CvrWl70Ox/yXGODs+P47pEihWOCr5QSnRi/lPgXiee5SAIL9324apba9sEWWCynu
         c5OPpYO/t1Ntij8TjoPWU9g1BSzyx3yvxU8vhSeY+LcUGTDDWJmMyemSG31zQm82iUpU
         61svGeq2qS+YgrQENxwnSSfuJHLGheGB7JAxY89fvQ+prIyv2v+4g8hwAHikOiHMv9d9
         BqBuIisHI3xuM0TTj89nhD2DOtt7hBakfGiIx5Hfdnw1gVqr4BtR7x7SdK3KtBf/sXGO
         OZMA8WaRDhAopee6s/XvnDzzRlRNcDhrGsHQyYAQT6oIeiTPdX/HPuU8wGY7LG+eI2zc
         BtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGVijVIXjZ7j9/h6FCoDsleW1+RkPFK8TRFdOx8adZ0=;
        b=t6QB3x48H7VaAN5nLFpMRSziq8rsqMmvu7Q9Dj788h4kTqr0QLNvWd76N/eJgIPH2r
         6kuB3+ud9s+LDUToaIxKXDlw0P3pSAXiuSA7b+8ITw99AtN3E7HWVe/rrD46XXvUuAMS
         4LzO0U74iZ79D3WheFZ6FO8Vjcd2vg93PE8O6UMw7To2bsFNaFEpTo4HP8fZdjqL/QyP
         Ht4GLW5/Jzt12O5Q1/3WC+z6St7Nux6PIRppjU7rBQ0hqx8Y1eK6vXfPPiuWuCkq51Eg
         X84wL5XFmQzw3LR8SDp7fiqKYF1z/WT5YFt3lAEOWHh93mYEwU0ekeHfiZ9aQm4zFyU4
         1v1w==
X-Gm-Message-State: ANoB5pl4yTWLlpV8fhiE3JZRPoRw/S6CKJ8MQPwGzyUWizmptoSmxzhH
        L0v/s25ySe3IkEzaXaeiKxqvXQ==
X-Google-Smtp-Source: AA0mqf5+WyrmaBUVgrSnAJNrWw1Z8DrCjnR1v+nRHUqndrLXLj3jed+Epe3fHaesOUvIijzgNXmbFQ==
X-Received: by 2002:aa7:cc99:0:b0:44e:cd80:843b with SMTP id p25-20020aa7cc99000000b0044ecd80843bmr34106200edt.126.1669650213189;
        Mon, 28 Nov 2022 07:43:33 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n6-20020aa7db46000000b0046aa2a36954sm4854179edt.97.2022.11.28.07.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 07:43:32 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] mptcp: fix sleep in atomic at close time
Date:   Mon, 28 Nov 2022 16:42:38 +0100
Message-Id: <20221128154239.1999234-3-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221128154239.1999234-1-matthieu.baerts@tessares.net>
References: <20221128154239.1999234-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3373; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=tMvi4+vIcCAwZo0qGbkn3WtN/NKmtz/uPknBepj8oWE=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjhNboS4KbRjjnqAXEMN49GaJI8GuN435taSgbFz5G
 IH9TYFGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4TW6AAKCRD2t4JPQmmgc7TvD/
 9RFK+WHIzkHceQfrpvewNDQiumCx4bx4DQo0tbQH1jLm8Mt2mn+4nULjhQNVCldAJlLBDijt3YMI70
 B8LAk6iYycO7qmCc0pzztbvX9fGi/cyrsPJGwFpNotKitEO3GAapaE9JMn06X4RI6K2yAbZ1KwLZxQ
 z0/ujyNnZPOh5El0IQd6/IiTZGXpZsPDwKv+f0aJTx9MVdMG+oiOUHCueWZT7VHdyhJ+d0LEfanqdd
 KvnBvOLjmwZeny/kFVGdLLWOeetAx6OfFxM0aJUpKYYaz0OAd6MGsdcg/sdJuxEREVir4M1+tgKiXB
 UkYFXAT28Dn+mUZf8w/4IHE3cHtOtKYQDb9Zbgk2OOc2qvW6zVaDTSUELFZm+uaM/Yzz8BFuQMIqhc
 jxO1iBHeSiSdtUILSK1pCFhcDM31En7dJTTGX6DKzojLgSyvzhkVMESuE7+5o/eMqWaBA+6sCncMHC
 F9OSGGBGkXSrEOOefV6fu+L+7mWHxrXG3pZJ987mHrr56L8lQfdBxCQErfOZVCfCvrEtNaT52Gktzc
 xRLaqLVsePlhbmXSjiIU6ad9Nm019XwMYxDJGNbYr0JNR8uy3dT+5FUcKcxSlH8PuL/uupqru2fv1+
 fP1+1o3IrCat7DbZBlRB3xaQI4wx4Ks5woy1PfdBII/6dsOG4bGQ53MBtCvA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Matt reported a splat at msk close time:

    BUG: sleeping function called from invalid context at net/mptcp/protocol.c:2877
    in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 155, name: packetdrill
    preempt_count: 201, expected: 0
    RCU nest depth: 0, expected: 0
    4 locks held by packetdrill/155:
    #0: ffff888001536990 (&sb->s_type->i_mutex_key#6){+.+.}-{3:3}, at: __sock_release (net/socket.c:650)
    #1: ffff88800b498130 (sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close (net/mptcp/protocol.c:2973)
    #2: ffff88800b49a130 (sk_lock-AF_INET/1){+.+.}-{0:0}, at: __mptcp_close_ssk (net/mptcp/protocol.c:2363)
    #3: ffff88800b49a0b0 (slock-AF_INET){+...}-{2:2}, at: __lock_sock_fast (include/net/sock.h:1820)
    Preemption disabled at:
    0x0
    CPU: 1 PID: 155 Comm: packetdrill Not tainted 6.1.0-rc5 #365
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
    Call Trace:
    <TASK>
    dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
    __might_resched.cold (kernel/sched/core.c:9891)
    __mptcp_destroy_sock (include/linux/kernel.h:110)
    __mptcp_close (net/mptcp/protocol.c:2959)
    mptcp_subflow_queue_clean (include/net/sock.h:1777)
    __mptcp_close_ssk (net/mptcp/protocol.c:2363)
    mptcp_destroy_common (net/mptcp/protocol.c:3170)
    mptcp_destroy (include/net/sock.h:1495)
    __mptcp_destroy_sock (net/mptcp/protocol.c:2886)
    __mptcp_close (net/mptcp/protocol.c:2959)
    mptcp_close (net/mptcp/protocol.c:2974)
    inet_release (net/ipv4/af_inet.c:432)
    __sock_release (net/socket.c:651)
    sock_close (net/socket.c:1367)
    __fput (fs/file_table.c:320)
    task_work_run (kernel/task_work.c:181 (discriminator 1))
    exit_to_user_mode_prepare (include/linux/resume_user_mode.h:49)
    syscall_exit_to_user_mode (kernel/entry/common.c:130)
    do_syscall_64 (arch/x86/entry/common.c:87)
    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

We can't call mptcp_close under the 'fast' socket lock variant, replace
it with a sock_lock_nested() as the relevant code is already under the
listening msk socket lock protection.

Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/316
Fixes: 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 02a54d59697b..2159b5f9988f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1745,16 +1745,16 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
 
 	for (msk = head; msk; msk = next) {
 		struct sock *sk = (struct sock *)msk;
-		bool slow, do_cancel_work;
+		bool do_cancel_work;
 
 		sock_hold(sk);
-		slow = lock_sock_fast_nested(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		next = msk->dl_next;
 		msk->first = NULL;
 		msk->dl_next = NULL;
 
 		do_cancel_work = __mptcp_close(sk, 0);
-		unlock_sock_fast(sk, slow);
+		release_sock(sk);
 		if (do_cancel_work)
 			mptcp_cancel_work(sk);
 		sock_put(sk);
-- 
2.37.2

