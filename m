Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E701C0956
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgD3Vcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:32:53 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:41711 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgD3Vcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:32:53 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MkHhB-1ijycN3S9Z-00kg62; Thu, 30 Apr 2020 23:32:10 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Brad Spengler <spender@grsecurity.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 05/15] bpf: avoid gcc-10 stringop-overflow warning
Date:   Thu, 30 Apr 2020 23:30:47 +0200
Message-Id: <20200430213101.135134-6-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CNokUhC2Wd1qKIMECqDz0OzwxjWsXarCmDvbpwr+hUv52yn5JoC
 9H3WOHuftCnlwalcINh7ammfYLcKgvWQiuKdukCpnN7gBpUGoJ9pyrT0dG6lc36FbmIQFML
 gPfWVYSSBDp3BPgxp6tHbBA46kd6tyVgyS1oFsiwg7QEX+dtCXixT5jKOo+dJGxeBzZv/dO
 sCQuKjMGxvMBfwAgQK9PQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EFuFrq1r0eY=:pH1mVhTjpOX9B51tQ10Xbj
 YHp/lf+shijhTXKq0mRIibRgPW3pjUW9S23wZzWdlLQ90F1RxuwBX7KvCW4JrP89ga4rLVMiT
 mOaSecFwCuWccoh2xVUmpSFy0zcYDfCiYnPCg5WPqXiMjUqaM4KQ/4dgvmQWrF/k66LD4LbxE
 8PCq9R7n+Zb139bUBs+/3nJfLi9M/FXYXxsGtXdTbhMBLzooauAxK2U2GeVmKPuU0/5D6sB85
 tLoTW9bm0aPblL//ymuooHMV4vqYbjVkC18uYDCDfgkD5Zj8Y0YT9UL62AI6hKz6eTQmYiltF
 n2ADtyTc7uoNWml71rH6sbJPUJeRebXtlpw1q0Mriceir5QUznrgSnvUtfZDY+L6oO+kWQum3
 Q7VXQn7zyMWB9XWS1mS0sKJG3tTPEi4z8Kj63U5fL0dzeJo3PWig2K4Y/NhJ+Pw2j79Km1859
 4hR/2m+WR+P6ArNOFfcgHwsYW39SMm0Q1rHdMoES7qwiE0VfmZyJQOue+DF8XCVhSCtxNygdS
 ol5nanhBsZpod1ed1mI7cM+yFFInHM8z/7LLDd39OtG/Ib9zaTznjr3xeBRqYvgVni+MS7o1t
 kt7iHPwNi2GV0klKBx5vTeWJFHmKFW3EeN6ZsHr8VUeBASecYnoIU8GJ0AmcHQ9vTf8Vv0FwQ
 cYawKz7w5FWdDEwItHfs/z9a2LwxDTannp+qZyLJcA5dj5YGiqdccZAXyKnAGtRNthhEIc1DW
 aZwUmZZXIQ1NHEsFZ519fLKKIU+UCLNQzvq/3nmKopkn02ctzhkOCsUEF6bR1utxugo3kJsg7
 VfvmXbGb+U8TuanOTfxiq+6NbwJiyqam0S6ApWkGx0wFbdDz4k=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 warns about accesses to zero-length arrays:

kernel/bpf/core.c: In function 'bpf_patch_insn_single':
cc1: warning: writing 8 bytes into a region of size 0 [-Wstringop-overflow=]
In file included from kernel/bpf/core.c:21:
include/linux/filter.h:550:20: note: at offset 0 to object 'insnsi' with size 0 declared here
  550 |   struct bpf_insn  insnsi[0];
      |                    ^~~~~~

In this case, we really want to have two flexible-array members,
but that is not possible. Removing the union to make insnsi a
flexible-array member while leaving insns as a zero-length array
fixes the warning, as nothing writes to the other one in that way.

This trick only works on linux-3.18 or higher, as older versions
had additional members in the union.

Fixes: 60a3b2253c41 ("net: bpf: make eBPF interpreter images read-only")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/filter.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index af37318bb1c5..73d06a39e2d6 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -545,10 +545,8 @@ struct bpf_prog {
 	unsigned int		(*bpf_func)(const void *ctx,
 					    const struct bpf_insn *insn);
 	/* Instructions for interpreter */
-	union {
-		struct sock_filter	insns[0];
-		struct bpf_insn		insnsi[0];
-	};
+	struct sock_filter	insns[0];
+	struct bpf_insn		insnsi[];
 };
 
 struct sk_filter {
-- 
2.26.0

