Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9464462BCC6
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKPL7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiKPL7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:59:11 -0500
X-Greylist: delayed 720 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Nov 2022 03:50:40 PST
Received: from wangsu.com (unknown [180.101.34.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42664326CE;
        Wed, 16 Nov 2022 03:50:40 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltADX31tDynRjv7gBAA--.7945S2;
        Wed, 16 Nov 2022 19:32:20 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf 0/4] bpf, sockmap: Fix some issues with using apply_bytes
Date:   Wed, 16 Nov 2022 19:29:17 +0800
Message-Id: <1668598161-15455-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: SyJltADX31tDynRjv7gBAA--.7945S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1xGrWxtF4rZw1rCryfZwb_yoWxtrXEvr
        W8tr98GrW8ZF18CayY9rZ8AF97Ga1DZrykGF9Iqry2gry8Zrn8Grs5Zr9Yyry8G3yYkr92
        gr1kGrWkJr1jgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUUUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 0001~0003 fixes three issues with using apply_bytes when redirecting.
Patch 0004 adds ingress tests for txmsg with apply_bytes in selftests.

Pengcheng Yang (4):
  bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
  bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
  bpf, sockmap: Fix data loss caused by using apply_bytes on ingress
    redirect
  selftests/bpf: Add ingress tests for txmsg with apply_bytes

 include/linux/skmsg.h                      |  1 +
 net/core/skmsg.c                           |  1 +
 net/ipv4/tcp_bpf.c                         |  9 +++++++--
 net/tls/tls_sw.c                           |  1 +
 tools/testing/selftests/bpf/test_sockmap.c | 18 ++++++++++++++++++
 5 files changed, 28 insertions(+), 2 deletions(-)

-- 
1.8.3.1

