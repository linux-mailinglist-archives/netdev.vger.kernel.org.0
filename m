Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47ACB51F51F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiEIHQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiEIHCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:02:05 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3523B1A359B;
        Sun,  8 May 2022 23:58:12 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axuth4u3hiwqkOAA--.49630S4;
        Mon, 09 May 2022 14:58:03 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/3] net: sysctl: No need to check CAP_SYS_ADMIN for bpf_jit_*
Date:   Mon,  9 May 2022 14:57:54 +0800
Message-Id: <1652079475-16684-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1652079475-16684-1-git-send-email-yangtiezhu@loongson.cn>
References: <1652079475-16684-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Axuth4u3hiwqkOAA--.49630S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur15ZFyxur47uw4fGr1kuFg_yoW8Ar1UpF
        WrKrWIkFZ8Kr1xGrZ7KFZYqr13Aa1DXF4Uuwn7Wa4SywnFgwnxJrn3XryYqFyYyrW2kFyY
        qayFvr98uan3ta7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBFb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
        64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
        CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280
        aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8AwCF04k20xvY0x
        0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
        7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
        C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jgJ5OUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mode of the following procnames are defined as 0644, 0600, 0600
and 0600 respectively in net_core_table[], normal user can not write
them, so no need to check CAP_SYS_ADMIN in the related proc_handler
function, just remove the checks.

/proc/sys/net/core/bpf_jit_enable
/proc/sys/net/core/bpf_jit_harden
/proc/sys/net/core/bpf_jit_kallsyms
/proc/sys/net/core/bpf_jit_limit

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 net/core/sysctl_net_core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index cf00dd7..059352b 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -268,9 +268,6 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	int ret, jit_enable = *(int *)table->data;
 	struct ctl_table tmp = *table;
 
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	tmp.data = &jit_enable;
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 	if (write && !ret) {
@@ -291,9 +288,6 @@ static int
 proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				    void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
 # endif /* CONFIG_HAVE_EBPF_JIT */
@@ -302,9 +296,6 @@ static int
 proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
 				     void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #endif
-- 
2.1.0

