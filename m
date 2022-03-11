Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C9A4D5BEA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347015AbiCKHEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346976AbiCKHEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:04:34 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C3F38CD99;
        Thu, 10 Mar 2022 23:03:28 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgCXTiAx9CpiW75vAA--.16861S2;
        Fri, 11 Mar 2022 15:03:17 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jreuter@yaina.de, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, thomas@osterried.de,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net 0/2] Fix refcount leak and NPD bugs in ax25
Date:   Fri, 11 Mar 2022 15:03:05 +0800
Message-Id: <cover.1646981034.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgCXTiAx9CpiW75vAA--.16861S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY07CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
        6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
        UdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkFAVZdtYnj3gAKsP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes refcount leak in ax25 that could cause 
ax25-ex-connected-session-now-listening-state-bug.

The second patch fixes NPD bugs in ax25 timers.

Duoming Zhou (2):
  ax25: Fix refcount leaks caused by ax25_cb_del()
  ax25: Fix NULL pointer dereferences in ax25 timers

 include/net/ax25.h    |  5 +++++
 net/ax25/af_ax25.c    | 13 ++++++++++---
 net/ax25/ax25_dev.c   |  1 +
 net/ax25/ax25_timer.c | 10 +++++-----
 4 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.17.1

