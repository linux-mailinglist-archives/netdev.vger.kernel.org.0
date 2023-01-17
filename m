Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D4666D9D7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbjAQJ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236529AbjAQJ1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:27:10 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D465D7AAF;
        Tue, 17 Jan 2023 01:25:56 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so7615629wmc.1;
        Tue, 17 Jan 2023 01:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rDB8n1qE+b4M81Y/z+9pblqPEgccUtAWFw7jbD5qKT4=;
        b=FdtsSICmAWjuKsyaqm+vk9udTwUrQ9fuGKnDyWAzLI+fhDuctGz4KFwfkoP+/VBBv2
         76U2He3WALpG8yJWw53DmZVRnMPun0/AkzExP8s33eIZSKnpxGzS314py7Rtguriq6Bw
         sfS/LfULQwM06DYjTh1iGxcx9NelXpCNHXo8SXg54jKSU1xnNNMOrj6LRoXh1RCt7CC2
         NC8BrGNaX3XOSHj1aNTuO0yBP5qsCc47murIHD/8c+JGwQwWvpLYiwRV3HkluDZvibi7
         qOJkHyuppYK3GzOMWuFum2AuJvSKeHRZJfDAYcmq+f5v6+jjj5/a30t8Zvll/LJYl/UN
         n2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rDB8n1qE+b4M81Y/z+9pblqPEgccUtAWFw7jbD5qKT4=;
        b=lihrNIZaIzCxMvQ1LqHt73A3YXhO4xAzRuhvDthQuUMvyJDXv0bBYMCFwsVp/UrGCs
         IKSTCG+RTFU8CWheV3SewLV4KGjIdJNv5j4VGgoWkDADA1yjGm989DI2xlr9Mwr/4zJv
         t9/vtXY2r03qfMS6TO3DHH8JJRTGUhz9UgVrheSDC4E/HsOGAZNILSEj0dqtaL2Z9Zlo
         pn3Lox22zgGGQbRlH9DjEzqmcONsNRbu1J4sbSehKH08d9ERBepwBKriVq3Wk+sacQ/b
         qx9heKUePjRQuYW4lho8KPSb4qFu7qBccn35kAT4brwGRGx9HrFyxIC1hijunAZ6pz5Y
         VSiQ==
X-Gm-Message-State: AFqh2kpXRhHqVp9vQ0pvKdm9Pnpzr+APW+++IR5pIzbBSuL0ua7nY+zY
        M/wF6A+CaSLceJ5mvGE4qxSKKHo5eenvVlAXW1Q=
X-Google-Smtp-Source: AMrXdXu9ZP8i5erS9awbTLNEZSoQqd2j1tEzZDFkutdz6zD+PHCEsebchUHvo6GV41faYIVb/DAS8A==
X-Received: by 2002:a05:600c:d3:b0:3da:23a4:627e with SMTP id u19-20020a05600c00d300b003da23a4627emr2318060wmm.6.1673947555256;
        Tue, 17 Jan 2023 01:25:55 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id u21-20020a7bc055000000b003d9aa76dc6asm48008881wmc.0.2023.01.17.01.25.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:25:54 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net 0/5] net: xdp: execute xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:25:28 +0100
Message-Id: <20230117092533.5804-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be follwed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found in [1].

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in [2].

The drivers have only been compile-tested since I do not own any of
the HW below. So if you are a manintainer, please make sure I did not
mess something up. This is a lousy excuse for virtio-net though, but
it should be much simpler for the vitio-net maintainers to test this,
than me trying to find test cases, validation suites, instantiating a
good setup, etc. Michael and Jason can likely do this in minutes.

Note that these were the drivers I found that violated the ordering by
running a simple script and manually checking the ones that came up as
potential offenders. But the script was not perfect in any way. There
might still be offenders out there, since the script can generate
false negatives.

[1] https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
[2] https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/

Thanks: Magnus

Magnus Karlsson (5):
  qede: execute xdp_do_flush() before napi_complete_done()
  lan966x: execute xdp_do_flush() before napi_complete_done()
  virtio-net: execute xdp_do_flush() before napi_complete_done()
  dpaa_eth: execute xdp_do_flush() before napi_complete_done()
  dpaa2-eth: execute xdp_do_flush() before napi_complete_done()

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 6 +++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c      | 9 ++++++---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
 drivers/net/ethernet/qlogic/qede/qede_fp.c            | 7 ++++---
 drivers/net/virtio_net.c                              | 6 +++---
 5 files changed, 19 insertions(+), 15 deletions(-)


base-commit: 87b93b678e95c7d93fe6a55b0e0fbda26d8c7760
--
2.34.1
