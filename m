Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66680520C36
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiEJDmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiEJDkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:40:37 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4425017CC9E;
        Mon,  9 May 2022 20:35:10 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axythn3XliaKoPAA--.50059S4;
        Tue, 10 May 2022 11:35:05 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] bpf: Print some info if disable bpf_jit_enable failed
Date:   Tue, 10 May 2022 11:35:03 +0800
Message-Id: <1652153703-22729-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1652153703-22729-1-git-send-email-yangtiezhu@loongson.cn>
References: <1652153703-22729-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Axythn3XliaKoPAA--.50059S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJrW7KF43Cw4UAF45CryrCrg_yoW8XrWfpr
        48Jr92krZ0q34xG39rAFnIqr13trWDXF17Cr97Ca1av3WDZr9rJrs5KryUKanF9rWqga43
        Zr4IyF9rCaykK37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0
        owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
        IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
        kIc2xKxwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
        Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
        CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
        I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
        8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
        UjIFyTuYvjfUbyxRDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user told me that bpf_jit_enable can be disabled on one system, but he
failed to disable bpf_jit_enable on the other system:

  # echo 0 > /proc/sys/net/core/bpf_jit_enable
  bash: echo: write error: Invalid argument

No useful info is available through the dmesg log, a quick analysis shows
that the issue is related with CONFIG_BPF_JIT_ALWAYS_ON.

When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set
to 1 and setting any other value than that will return failure.

It is better to print some info to tell the user if disable bpf_jit_enable
failed.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 net/core/sysctl_net_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index cf00dd7..ca4527f 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -266,6 +266,8 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 					   loff_t *ppos)
 {
 	int ret, jit_enable = *(int *)table->data;
+	int min = *(int *)table->extra1;
+	int max = *(int *)table->extra2;
 	struct ctl_table tmp = *table;
 
 	if (write && !capable(CAP_SYS_ADMIN))
@@ -283,6 +285,10 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 			ret = -EPERM;
 		}
 	}
+
+	if (write && ret && min == max)
+		pr_info_once("CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set to 1.\n");
+
 	return ret;
 }
 
-- 
2.1.0

