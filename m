Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C41859E62F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244170AbiHWPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242406AbiHWPjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:39:55 -0400
X-Greylist: delayed 578 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 23 Aug 2022 04:32:27 PDT
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 0E51776754;
        Tue, 23 Aug 2022 04:32:26 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.19.15])
        by mail-app2 (Coremail) with SMTP id by_KCgDnqrA5uARjm7mFAw--.5982S2;
        Tue, 23 Aug 2022 19:21:39 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        briannorris@chromium.org
Cc:     johannes@sipsolutions.net, rafael@kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH v8 0/2] Add new APIs of devcoredump and fix bugs
Date:   Tue, 23 Aug 2022 19:21:25 +0800
Message-Id: <cover.1661252818.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgDnqrA5uARjm7mFAw--.5982S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZF48XryktryrCrykGw15urg_yoWxtrX_G3
        yIvayIyF4kG3W2qFWjy3W5Ary0yrW7XF1fG3W7trWkGFW7JrW5XrnxZr98t34UGFnFyrnx
        JFyDAFZ7ZasrZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbx8FF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wryl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQvt
        AUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgULAVZdtbI0NQASsS
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds new APIs to support migration of users
from old device coredump related APIs.

The second patch fix sleep in atomic context bugs of mwifiex
caused by dev_coredumpv().

Duoming Zhou (2):
  devcoredump: add new APIs to support migration of users from old
    device coredump related APIs
  mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv

 drivers/base/devcoredump.c                    | 116 ++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/init.c   |   9 +-
 drivers/net/wireless/marvell/mwifiex/main.h   |   3 +-
 .../net/wireless/marvell/mwifiex/sta_event.c  |   6 +-
 include/linux/devcoredump.h                   |  34 +++++
 5 files changed, 160 insertions(+), 8 deletions(-)

-- 
2.17.1

