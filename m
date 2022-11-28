Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E1963A726
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiK1LZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiK1LZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:25:20 -0500
Received: from wangsu.com (unknown [180.101.34.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EF01B50;
        Mon, 28 Nov 2022 03:25:13 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltADXxwySmoRjSUsAAA--.450S2;
        Mon, 28 Nov 2022 19:25:07 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf v2 0/4] bpf, sockmap: Fix some issues with using apply_bytes
Date:   Mon, 28 Nov 2022 19:24:41 +0800
Message-Id: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: SyJltADXxwySmoRjSUsAAA--.450S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1rWrykur17Aw4UCFy5CFg_yoW3CrgEvr
        W8tr98GFW8XF1rGay29rZ8CF97Cr4DZr97JF98try3Kry8ur1UGrs5Xr9YyryUGa90kr92
        gryku397Xr1jgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUUUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,MAY_BE_FORGED,SPF_HELO_PASS,T_SPF_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1~3 fixes three issues with using apply_bytes when redirecting.
Patch 4 adds ingress tests for txmsg with apply_bytes in selftests.

---
Changes in v2:
*Patch 2: Clear psock->flags explicitly before releasing the sock lock

Pengcheng Yang (4):
  bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
  bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
  bpf, sockmap: Fix data loss caused by using apply_bytes on ingress
    redirect
  selftests/bpf: Add ingress tests for txmsg with apply_bytes

 include/linux/skmsg.h                      |  1 +
 net/core/skmsg.c                           |  1 +
 net/ipv4/tcp_bpf.c                         | 10 ++++++++--
 net/tls/tls_sw.c                           |  1 +
 tools/testing/selftests/bpf/test_sockmap.c | 18 ++++++++++++++++++
 5 files changed, 29 insertions(+), 2 deletions(-)

-- 
1.8.3.1

