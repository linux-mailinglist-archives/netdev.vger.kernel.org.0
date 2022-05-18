Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64DF52BF77
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbiERQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbiERQJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:09:35 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713A71D89D8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:09:18 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id e20so1847160qvr.6
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmgEtmIKL3gY05RaI4AMj5+Mqk4nvywAJDkR/5/vo5E=;
        b=gIkaWXNaPTf4P4UWCXVd28imIkF+hK4uvdmbOLR1Eiib9fJ0MUnmvPnlM2Lejof0W9
         gIhAWHOLaUf1BPFJK8iG1YVfZcEQLhIvNXKwj1DyaAQ/Z8bWecQCofFmeu+GKQmnK88E
         PEF0bQPvcYff+yYizBlsN70ST5rJZj3xz9OlSHWy+b8dfhzUVea/TSOgqmDBQ040vCfI
         fC241OMlrXM5hvzA9kc94y9XhKUOW+OiRpgooypUQ/rCVitzMOuiZwZzmlmFdJMRl47T
         ttKlGmPu4gacL5E9+Q6V+AlRa8cqCC+uJSHMm5eXo5ia+mmYZBmCrhKXKR9n+CGqRgPl
         Nxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmgEtmIKL3gY05RaI4AMj5+Mqk4nvywAJDkR/5/vo5E=;
        b=jSjwcSIKNX8VH1XxlZ6vrUy+o3e7D4BIs8XAkP9P0K/RrIcOt/MbV55fKys56uuvru
         gd7z6XcxsidhTyvutPtnKcHwCgBtEWe0uknxB1BLKlE2gkEXi3fRwwnDZ1GKxy6ssdqq
         nNaImNDnQbMpc/FknrsrooTPlCCnvS7SJoL53/ejwuLTxAbllt0zIpFFap6BApXLRsBl
         dIinQB/FULQJ1BrxL6ZJFOf9f0yPOKcYwrvoQg5Uc0TYJq1HclpVwBxZ3AfwhbxFSe00
         hSapKjwMqmFndzyTyzLHsc/nfjft9O4MOcsgilj2epN3UPNqKI8VWIs1wcfihCpXKxPb
         41jg==
X-Gm-Message-State: AOAM531hpaIXayOQHIKRPr14aaIx9mXXsBsd3G96cBnPUekig8nyRo0c
        vUbb87k4FOS2/ZYdJMdTQid4p/cHxafnjQ==
X-Google-Smtp-Source: ABdhPJwwTczWUF5yl2wdFzVU/F55vT8Vsrq71sEf5RKx960t5NF9O1T0pD4KQ7eCKJ1pvazQwoWBVA==
X-Received: by 2002:ad4:420e:0:b0:461:c9fc:e1c2 with SMTP id k14-20020ad4420e000000b00461c9fce1c2mr14541qvp.53.1652890157266;
        Wed, 18 May 2022 09:09:17 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v184-20020a3793c1000000b0069fc13ce244sm1695201qkd.117.2022.05.18.09.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:09:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCHv3 net] Documentation: add description for net.core.gro_normal_batch
Date:   Wed, 18 May 2022 12:09:15 -0400
Message-Id: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe it in admin-guide/sysctl/net.rst like other Network core options.
Users need to know gro_normal_batch for performance tuning.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Reported-by: Prijesh Patel <prpatel@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v1->v2:
- improve the description according to the suggestion from Edward
  and Jakub.
v2->v3:
- improve more for the description, and drop the default for
  gro_normal_batch, suggested by Jakub.

 Documentation/admin-guide/sysctl/net.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f86b5e1623c6..46b44fa82fa2 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -374,6 +374,15 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
 If set to 1 (default), hash rethink is performed on listening socket.
 If set to 0, hash rethink is not performed.
 
+gro_normal_batch
+----------------
+
+Maximum number of the segments to batch up on output of GRO. When a packet
+exits GRO, either as a coalesced superframe or as an original packet which
+GRO has decided not to coalesce, it is placed on a per-NAPI list. This
+list is then passed to the stack when the number of segments reaches the
+gro_normal_batch limit.
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
-- 
2.31.1

