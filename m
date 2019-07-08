Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE061F24
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbfGHM6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:58:20 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:40755 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731040AbfGHM6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:58:20 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MOz8O-1i9o621wUu-00PODH; Mon, 08 Jul 2019 14:57:46 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 2/2] bpf: avoid unused variable warning in tcp_bpf_rtt()
Date:   Mon,  8 Jul 2019 14:57:21 +0200
Message-Id: <20190708125733.3944836-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190708125733.3944836-1-arnd@arndb.de>
References: <20190708125733.3944836-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dI4LQODlR+/sYKWbgedywQqye07I8NlA3mUgYMxxT+wgW+CUrcV
 0zvx/lBQ45HY1KIOI8Cfub13DGqUILRkHK98BazQS981rGHESAasKmwd9poT76wcJmC/cee
 x2onzLs9P8O/aWPlvOYPjABJWDmrOa3nIUAPIz8jTtS2kOIp87/rJSIUE36gkyVfKecvWUx
 DRAuyQEuOSJhN4mWH+xtA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vDZFZPrEgQw=:pflKz3N+bgPLHDuz8gxf0r
 bbY+3ymbKnAvcg/qM0YYxPHS5Ki7NzKpqgf34Jv2vskCkP/jNMrSMc0vIRIzqJEO6UQLqhNXJ
 dAvdugMBkVnywngGmJYnXMvvnzQ1QplYZZSvqIjF4QKj8ntUWj6V58RMin68zetN2d9XjymyS
 v/VYKbXk2+LKCEarSrV3dxGNkfcstPC4D0lCPQenxYfEUVhbV1x86GZi+9GU7hefFd7WGa8+0
 BJTSAk1C7PqbcoceGNPPD/gKPUbDeT1XTr2hOVrvIuOTQQCwaey2Qy+TP9PM5y6OHbYiQfve8
 ebYktbo3wlqHw5X9RR1o5gsrmeAY0WFC5ZFMa/wj3pS4f84ZEEApz1KZzwsl241YQnxGquJ0F
 UP8Lf8qly2y+m4XR2r1lfv02kM7exUiKo9AyWDO/JrBo8i/qGa4Z6F+nyrncq31FJhr9vw3DI
 rsPxDNNVJbKZlghb7QwF2hdWM9hQAtsWcC/V2TGi6PDypV/bHWy/FeF7xaIpe+VZvU/KZOueB
 CtBR8756GXUtkIyz+c0h3sCZvg5XNV5ZfI2LZhdz4lOBjvl/XP4l2B6jfWQ9nYBXW4+RfQ5AW
 OQxizhG8bEhRms2mnK3j7E9Tec0uS+AW1j5pTro2wVeRqBQDFjghfhJfpiaW9W/AtGt5wdP91
 Xew3WCbEGcT/18gKxcd+VVX2ZeEbC36VXkl0qNJcreqiX5UWpmYequ+TBkbEEhEb/+niSfyJH
 Z/xQaOpchVbcHcHLhPSWmEhA7BPg3ipud9PqtA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_BPF is disabled, we get a warning for an unused
variable:

In file included from drivers/target/target_core_device.c:26:
include/net/tcp.h:2226:19: error: unused variable 'tp' [-Werror,-Wunused-variable]
        struct tcp_sock *tp = tcp_sk(sk);

The variable is only used in one place, so it can be
replaced with its value there to avoid the warning.

Fixes: 23729ff23186 ("bpf: add BPF_CGROUP_SOCK_OPS callback that is executed on every RTT")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/net/tcp.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e16d8a3fd3b4..cca3c59b98bf 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2223,9 +2223,7 @@ static inline bool tcp_bpf_ca_needs_ecn(struct sock *sk)
 
 static inline void tcp_bpf_rtt(struct sock *sk)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTT_CB_FLAG))
+	if (BPF_SOCK_OPS_TEST_FLAG(tcp_sk(sk), BPF_SOCK_OPS_RTT_CB_FLAG))
 		tcp_call_bpf(sk, BPF_SOCK_OPS_RTT_CB, 0, NULL);
 }
 
-- 
2.20.0

