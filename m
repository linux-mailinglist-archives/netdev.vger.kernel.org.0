Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1017D51F51C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiEIHQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiEIHCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:02:07 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63B971A35AA;
        Sun,  8 May 2022 23:58:13 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axuth4u3hiwqkOAA--.49630S5;
        Mon, 09 May 2022 14:58:06 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 3/3] bpf: Print some info if disable bpf_jit_enable failed
Date:   Mon,  9 May 2022 14:57:55 +0800
Message-Id: <1652079475-16684-4-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1652079475-16684-1-git-send-email-yangtiezhu@loongson.cn>
References: <1652079475-16684-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Axuth4u3hiwqkOAA--.49630S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJrW7KF43Cw4UAF45CryrCrg_yoW8XryUpr
        48Gr92krZ8X34xG39rAFnaqr13trWUXF1UCrnrCa15X3WDXr9rJrsYgryUKFZFvrWqga43
        Ar4Iyr9ruaykKa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBFb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280
        aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8AwCF04k20xvY0x
        0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
        7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
        C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07bz2NNUUUUU=
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
index 059352b..f8a1d450 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -266,6 +266,8 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 					   loff_t *ppos)
 {
 	int ret, jit_enable = *(int *)table->data;
+	int min = *(int *)table->extra1;
+	int max = *(int *)table->extra2;
 	struct ctl_table tmp = *table;
 
 	tmp.data = &jit_enable;
@@ -280,6 +282,10 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 			ret = -EPERM;
 		}
 	}
+
+	if (write && ret && min == max)
+		pr_info("CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set to 1.\n");
+
 	return ret;
 }
 
-- 
2.1.0

