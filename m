Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EA51BC74E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgD1Rz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgD1Rz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:55:57 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF0C03C1AB;
        Tue, 28 Apr 2020 10:55:57 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g19so34163566otk.5;
        Tue, 28 Apr 2020 10:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WPNSEszGsKvWwr5mWrgU0hiRBGrCOhQfvvHO8mYiip0=;
        b=NcxHbMn968e3SArAbgtFRgFPL/7mSv37DM6oLID+iG8epieq6FKHU0WOLraK04kbZ2
         h/HD75QC4hkpLYcbdrC3iudhC43FDT4oYSz+SRLL/s3B86MEWqUNXXNuhYZTkJxnZnDt
         +5iYECCkN0GH6NE8pdfMPgncaXEdPD6DYevJcraxu0GEah8Vci11j5MTWMv5f2NEwHbr
         aNA7T91VyiYzzcC8WiU8vw9GaJUWdAY76OPr5B+z8Y4mY4gyYbbJgvgyVagOFQ4F3jhj
         YuGs0PUQgakmA+zwHRxOiSbRSEFsDT4zPmEqjHcF7TsKE2XwwU5F7o6XTETR/l31u9fB
         2Vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WPNSEszGsKvWwr5mWrgU0hiRBGrCOhQfvvHO8mYiip0=;
        b=svynhwZ9fv9GuYvGOBtLvFaWKNhyQubZzLGMTkEj0H6yRad1745x9lRUr44hg/GOMg
         NwkQGE3FJsYIlDPXopvZfnqhIyFKtaMUV4tYSpn2SHeiCOditaXCFoVympPzew4FzVJC
         m2ymTAweiwonLFfH89mAo2x3o9mEKAgdNLtU+O8YLtOusKhMaefUfSbkVz4js1fMWSbw
         LnwRhDFvHRXtgqOA1yF7qs8Kvvonh+x8YTNEIvNsPC/GFPGOsQQCYWqVXFSHvXWCl6Ym
         Z/voO4iHzhQEg2Eogk8QdwvyF7YM1Ek3UVnKODiGylNXmc4C8lIA9z15Rk5nyVw/Jb+S
         UkWg==
X-Gm-Message-State: AGi0PuZmhVTF+ok9UVXc3/YDFyoUC5taba843famjMx5RYQrDmWTGeQw
        eCgb4RTa9ogR6GCSGseP8lA=
X-Google-Smtp-Source: APiQypIbp0GiAGwfiaFKNuw/Omid8A5x5maeShrzS4a9PPE02r0BseiG3bEp8QpYMByPXyBDhJ50OQ==
X-Received: by 2002:aca:eb95:: with SMTP id j143mr3883044oih.159.1588096556631;
        Tue, 28 Apr 2020 10:55:56 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id b6sm5007825otq.18.2020.04.28.10.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 10:55:55 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
Date:   Tue, 28 Apr 2020 10:54:56 -0700
Message-Id: <20200428175455.2109973-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
References: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netvsc_start_xmit is used as a callback function for the ndo_start_xmit
function pointer. ndo_start_xmit's return type is netdev_tx_t but
netvsc_start_xmit's return type is int.

This causes a failure with Control Flow Integrity (CFI), which requires
function pointer prototypes and callback function definitions to match
exactly. When CFI is in enforcing, the kernel panics. When booting a
CFI kernel with WSL 2, the VM is immediately terminated because of this.

The splat when CONFIG_CFI_PERMISSIVE is used:

[    5.916765] CFI failure (target: netvsc_start_xmit+0x0/0x10):
[    5.916771] WARNING: CPU: 8 PID: 0 at kernel/cfi.c:29 __cfi_check_fail+0x2e/0x40
[    5.916772] Modules linked in:
[    5.916774] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 5.7.0-rc3-next-20200424-microsoft-cbl-00001-ged4eb37d2c69-dirty #1
[    5.916776] RIP: 0010:__cfi_check_fail+0x2e/0x40
[    5.916777] Code: 48 c7 c7 70 98 63 a9 48 c7 c6 11 db 47 a9 e8 69 55 59 00 85 c0 75 02 5b c3 48 c7 c7 73 c6 43 a9 48 89 de 31 c0 e8 12 2d f0 ff <0f> 0b 5b c3 00 00 cc cc 00 00 cc cc 00 00 cc cc 00 00 85 f6 74 25
[    5.916778] RSP: 0018:ffffa803c0260b78 EFLAGS: 00010246
[    5.916779] RAX: 712a1af25779e900 RBX: ffffffffa8cf7950 RCX: ffffffffa962cf08
[    5.916779] RDX: ffffffffa9c36b60 RSI: 0000000000000082 RDI: ffffffffa9c36b5c
[    5.916780] RBP: ffff8ffc4779c2c0 R08: 0000000000000001 R09: ffffffffa9c3c300
[    5.916781] R10: 0000000000000151 R11: ffffffffa9c36b60 R12: ffff8ffe39084000
[    5.916782] R13: ffffffffa8cf7950 R14: ffffffffa8d12cb0 R15: ffff8ffe39320140
[    5.916784] FS:  0000000000000000(0000) GS:ffff8ffe3bc00000(0000) knlGS:0000000000000000
[    5.916785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.916786] CR2: 00007ffef5749408 CR3: 00000002f4f5e000 CR4: 0000000000340ea0
[    5.916787] Call Trace:
[    5.916788]  <IRQ>
[    5.916790]  __cfi_check+0x3ab58/0x450e0
[    5.916793]  ? dev_hard_start_xmit+0x11f/0x160
[    5.916795]  ? sch_direct_xmit+0xf2/0x230
[    5.916796]  ? __dev_queue_xmit.llvm.11471227737707190958+0x69d/0x8e0
[    5.916797]  ? neigh_resolve_output+0xdf/0x220
[    5.916799]  ? neigh_connected_output.cfi_jt+0x8/0x8
[    5.916801]  ? ip6_finish_output2+0x398/0x4c0
[    5.916803]  ? nf_nat_ipv6_out+0x10/0xa0
[    5.916804]  ? nf_hook_slow+0x84/0x100
[    5.916807]  ? ip6_input_finish+0x8/0x8
[    5.916807]  ? ip6_output+0x6f/0x110
[    5.916808]  ? __ip6_local_out.cfi_jt+0x8/0x8
[    5.916810]  ? mld_sendpack+0x28e/0x330
[    5.916811]  ? ip_rt_bug+0x8/0x8
[    5.916813]  ? mld_ifc_timer_expire+0x2db/0x400
[    5.916814]  ? neigh_proxy_process+0x8/0x8
[    5.916816]  ? call_timer_fn+0x3d/0xd0
[    5.916817]  ? __run_timers+0x2a9/0x300
[    5.916819]  ? rcu_core_si+0x8/0x8
[    5.916820]  ? run_timer_softirq+0x14/0x30
[    5.916821]  ? __do_softirq+0x154/0x262
[    5.916822]  ? native_x2apic_icr_write+0x8/0x8
[    5.916824]  ? irq_exit+0xba/0xc0
[    5.916825]  ? hv_stimer0_vector_handler+0x99/0xe0
[    5.916826]  ? hv_stimer0_callback_vector+0xf/0x20
[    5.916826]  </IRQ>
[    5.916828]  ? hv_stimer_global_cleanup.cfi_jt+0x8/0x8
[    5.916829]  ? raw_setsockopt+0x8/0x8
[    5.916830]  ? default_idle+0xe/0x10
[    5.916832]  ? do_idle.llvm.10446269078108580492+0xb7/0x130
[    5.916833]  ? raw_setsockopt+0x8/0x8
[    5.916833]  ? cpu_startup_entry+0x15/0x20
[    5.916835]  ? cpu_hotplug_enable.cfi_jt+0x8/0x8
[    5.916836]  ? start_secondary+0x188/0x190
[    5.916837]  ? secondary_startup_64+0xa5/0xb0
[    5.916838] ---[ end trace f2683fa869597ba5 ]---

Avoid this by using the right return type for netvsc_start_xmit.

Fixes: fceaf24a943d8 ("Staging: hv: add the Hyper-V virtual network driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1009
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Move splat into commit message rather than issue.

Comment from previous version:

Do note that netvsc_xmit still returns int because netvsc_xmit has a
potential return from netvsc_vf_xmit, which does not return netdev_tx_t
because of the call to dev_queue_xmit.

I am not sure if that is an oversight that was introduced by
commit 0c195567a8f6e ("netvsc: transparent VF management") or if
everything works properly as it is now.

My patch is purely concerned with making the definition match the
prototype so it should be NFC aside from avoiding the CFI panic.

 drivers/net/hyperv/netvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index d8e86bdbfba1e..ebcfbae056900 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -707,7 +707,8 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	goto drop;
 }
 
-static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netvsc_start_xmit(struct sk_buff *skb,
+				     struct net_device *ndev)
 {
 	return netvsc_xmit(skb, ndev, false);
 }

base-commit: 51184ae37e0518fd90cb437a2fbc953ae558cd0d
-- 
2.26.2

