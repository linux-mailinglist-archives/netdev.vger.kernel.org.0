Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4FC545072
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344148AbiFIPR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbiFIPRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:17:22 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B1049F0C;
        Thu,  9 Jun 2022 08:17:20 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id p8so17333402qtx.9;
        Thu, 09 Jun 2022 08:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tl+mtvibyOVIrQwhP4oxytSFsNmMVwz3s+QSpjel0gQ=;
        b=Mjc5vnIj7dJjk7SQVe1m63MGpZE29Rd0ohgLStSqEosRrEMXNoCvs7kjhy4rDDOX4y
         9WCSITWCTTpkrg8h4DtxfzGsTYQTBH6+W5aeMz71/aKt6AoZvbV6uY8P5Um/MPqvz3Rl
         2Edg5CanekgJxjtrc3SwUVHtvkipdN4CH6ov7feRSOs3gxskGgUE6dJaCxnVBEpu4G+3
         +PoojQOP7h+gujbCvzMRU+39frckr1Xc67lxN8CidB1c9Ld1gubPQu0L+b47TmoamRZQ
         L/K2ldYwxiduKxDuKcXgr9X77QKaALHwQXzychkt6FDo9KX6p62eQX+zcbJdxYypYiSp
         FqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tl+mtvibyOVIrQwhP4oxytSFsNmMVwz3s+QSpjel0gQ=;
        b=cNDGReYe0f9tLTLi3f1QiV1IDp2Ufhs/Se0dlKyUB+v+e9sQzY+S/tUJaoVm7ON+93
         BfhiPGNRUQWuHy3KIwXTkt8Jnru7meLWD8nA7Jo4kSSOHb3IoIosjiPB7u5qVUmYHup5
         /O5XVrMl3HCXjskBfzVz5/VGtb/ijsIc9WvHKj9+i0LCOLdB5h4m8GtkEY9si3B9SQhZ
         4qyyaSJNSyBfT5JyKDAQMvnQkKtXv6WoCX/RbTSSz0dl9R2cLUhE5fzNKuJm+tbtoylH
         A4A4sWIGJJepKAVtOT+R9nyQY1gRQOubh/7j+HtCeSvKv2paOMYIGS1701W07anF6SCZ
         IGjg==
X-Gm-Message-State: AOAM530qYu/kR9JQIzCwCg028ZDhJQ3p8OUxZB6hNHsCiOxh057+yvG7
        /Wh/F+D6sF5iA7g2iWV+kZr/3aWcmnpXk9L4
X-Google-Smtp-Source: ABdhPJw0Wgq4WSjiCYEALJc3aM7LHt/3Qjg7k2HSrn6Tjf9c6Iugj3agmGZruy9qfKnxP7gKuQLUCQ==
X-Received: by 2002:ac8:7f16:0:b0:300:c862:5c79 with SMTP id f22-20020ac87f16000000b00300c8625c79mr31776609qtk.523.1654787839194;
        Thu, 09 Jun 2022 08:17:19 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n64-20020a37bd43000000b006a60190ed0fsm18199469qkf.74.2022.06.09.08.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:17:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCHv2 net 2/3] Documentation: add description for net.sctp.intl_enable
Date:   Thu,  9 Jun 2022 11:17:14 -0400
Message-Id: <2792d34dbac5750f23854bdb042f03f63d3fa918.1654787716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1654787716.git.lucien.xin@gmail.com>
References: <cover.1654787716.git.lucien.xin@gmail.com>
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

Describe it in networking/ip-sysctl.rst like other SCTP options.
We need to document this especially as when using the feature
of User Message Interleaving, some socket options also needs
to be set.

Fixes: 463118c34a35 ("sctp: support sysctl to allow users to use stream interleave")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 3abd494053a9..5d90e219398c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2941,6 +2941,20 @@ reconf_enable - BOOLEAN
 
 	Default: 0
 
+intl_enable - BOOLEAN
+        Enable or disable extension of User Message Interleaving functionality
+        specified in RFC8260. This extension allows the interleaving of user
+        messages sent on different streams. With this feature enabled, I-DATA
+        chunk will replace DATA chunk to carry user messages if also supported
+        by the peer. Note that to use this feature, one needs to set this option
+        to 1 and also needs to set socket options SCTP_FRAGMENT_INTERLEAVE to 2
+        and SCTP_INTERLEAVING_SUPPORTED to 1.
+
+	- 1: Enable extension.
+	- 0: Disable extension.
+
+	Default: 0
+
 
 ``/proc/sys/net/core/*``
 ========================
-- 
2.31.1

