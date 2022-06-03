Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B653D168
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbiFCS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347239AbiFCS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:27:04 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0FABDB;
        Fri,  3 Jun 2022 11:09:29 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id o73so1654499qke.7;
        Fri, 03 Jun 2022 11:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IYjc+rNFmp3AJxr+2pm0gGrx/IzB3ZsbKxwBjGVt2GU=;
        b=UGj6kMBeipyIyMW7azvfQiuqn18gRCp+cPu9d0L72OMrdM+koT1FPLM8vavriNmXIZ
         ZJomquqrknQoDzV++m2fXWwcEVRD2PDYijnSQKQNa5CG+oQ6ScofIhaIP7d5EjkCfvQV
         55hLpaN4MI5EQjYV09TFpxChkTbmHOBl9ZdUz1OxbbIAc3pmqM4DSf3OKRwiAhB3ytdj
         AxfXMuq02fGEnXSm9S5WPRv3ge3FfPnMqvVytzT/R6FrxsuWpQLkmoYYvK0RO6zXwi3O
         xmHHfoJYZSQW1LKbUbIleuUooN/OEMDC58c2b6iNqiNKar/AnftJNvo0Q7H9HybGolHM
         pamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IYjc+rNFmp3AJxr+2pm0gGrx/IzB3ZsbKxwBjGVt2GU=;
        b=EJFm5GTnyq7lI3HhXlzSQ/UNcY/HlBMHoWVHH9P2lew6hidZBq31/M6zkNkKLMWL4O
         H2OCXI5i+O7M8Vbg/H6DleXpF2jQQx/y3M+7aDCSzmxv6SZxJiABRCgfAmq60UIvXmsV
         tAurdX84w+T0lioA8miB1rG3Z4u3pcw/FXzW2Tw4JW0up39QYhPTTJK5mer2XFj5aJzc
         noJMc2hVWKXge286fERucfWOMJryNPnqz7yunpFveCKAHvlmSjVxJlHIDdACytfZTYP7
         zDHS9whh7ZTxfEcAlzRjuqK7jZd8NrUb+AdqcZ5LeZCVVtxnT8Id5hmgiopuqal9kBsZ
         X3kw==
X-Gm-Message-State: AOAM530voXOvdxfj3MN44HRgPC3fJD3TjHnXYFD5Bx/N8rBUsGIsYiOC
        oWjcOd1ZQdcHo5Iiud2i85pPCEAfp/CeCipO
X-Google-Smtp-Source: ABdhPJxT8NDrj7Ddz4J3Ff8QDKvbf1Qqpuq35vuVcOwpVxOSdAMJAlV02GrXUxBON+3N7EsoF0STdw==
X-Received: by 2002:ae9:e90b:0:b0:6a5:816e:43d1 with SMTP id x11-20020ae9e90b000000b006a5816e43d1mr7785585qkf.66.1654279767599;
        Fri, 03 Jun 2022 11:09:27 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm5187589qka.63.2022.06.03.11.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:09:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 1/3] Documentation: add description for net.sctp.reconf_enable
Date:   Fri,  3 Jun 2022 14:09:23 -0400
Message-Id: <c09cab1e25ab3ad625ff72a3449e3e2149d1b165.1654279751.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1654279751.git.lucien.xin@gmail.com>
References: <cover.1654279751.git.lucien.xin@gmail.com>
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

Fixes: c0d8bab6ae51 ("sctp: add get and set sockopt for reconf_enable")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b882d4238581..3abd494053a9 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2930,6 +2930,17 @@ plpmtud_probe_interval - INTEGER
 
 	Default: 0
 
+reconf_enable - BOOLEAN
+        Enable or disable extension of Stream Reconfiguration functionality
+        specified in RFC6525. This extension provides the ability to "reset"
+        a stream, and it includes the Parameters of "Outgoing/Incoming SSN
+        Reset", "SSN/TSN Reset" and "Add Outgoing/Incoming Streams".
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

