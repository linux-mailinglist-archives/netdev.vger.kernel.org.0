Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28653D161
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347368AbiFCS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347334AbiFCS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:27:04 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A5562E1;
        Fri,  3 Jun 2022 11:09:32 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id h18so6086493qvj.11;
        Fri, 03 Jun 2022 11:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x235tBTmbtp/Zn3eJ+NV3r0CI+cJbWl2CV+l4nS6VkU=;
        b=fT5a0y671GKe4MIwhp2SPJGkjA0rJuWOIxzWcP7UXVILHjicLL6QNh/xCQWqIwYsCs
         zOVjvrOkEdCFex7B3C23gAkvXHTt0QFPuDVDEvi0vQaJAhkm0SG91yKJEHdQXjFVwDkN
         hMxUFQR3BurAV8mERJwLuNxlHnHa4B86Hs9KehqscVOh+WAe1OnaMc+rRaKnwxuHpsnt
         f6EKqa/e7d3fGWxxUI2+Az3+Blo136uRSkIQ1/ZBHwoo02NtiMUagnmzmGlxdkRtnMdz
         8P1CZ3qcaiZrNbfND4mFNTizacZrvHrts/iCS3eVTYcUjD1dSwIorSODyT5UJhp0pfEh
         j5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x235tBTmbtp/Zn3eJ+NV3r0CI+cJbWl2CV+l4nS6VkU=;
        b=klC4IYgdcVWyf9PXYO07x/VBVUwgecSHNMOQqtHd3ZGOLps0VvdBTmhIRkXM1hrW/L
         7RqqLcHcSPa2zZEmDq0Can0tR5diGx8R4CCeM5iKPJqLepAjA8PQB8xcoVFkxEjMiTz5
         E8IxLXR30nx80xlzg+3RHQvOHNYv3wOkvaw1BvnMlvU6X+uMlN8bu+e8fYX7cGh12laM
         0Rh/YfUl6Zp1chaixxOH1busVT7jbano4AEkGtbMdKO3N20xwjdkXxqz4tKsze+l5w59
         0l/t2XxaLtYtLulkIUODrLJMmZ+d+bpvVUlUpuhaWNd8bURSo+xHg09laz3F7L340HOo
         sSLA==
X-Gm-Message-State: AOAM530r75DlISWBuLegR0OWzP9kiN7kEcUK2v9U3JDtLagpJqZTjKcu
        NcqApiXcxD+kvzWx08QFJYWynUdj1SwPDmgb
X-Google-Smtp-Source: ABdhPJzHsBwqxJFFifqmBgmyolZ/j2IyZzSIaVnV5GMcKsf4qe6jyd8zvuSuN3Hl8gO0Em+lmaaIvQ==
X-Received: by 2002:a0c:90e1:0:b0:467:d438:2853 with SMTP id p88-20020a0c90e1000000b00467d4382853mr6035753qvp.11.1654279769350;
        Fri, 03 Jun 2022 11:09:29 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm5187589qka.63.2022.06.03.11.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:09:29 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 3/3] Documentation: add description for net.sctp.ecn_enable
Date:   Fri,  3 Jun 2022 14:09:25 -0400
Message-Id: <78f09abc15a2f53985159970123f0a0b9acd6b7c.1654279751.git.lucien.xin@gmail.com>
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

Fixes: 2f5268a9249b ("sctp: allow users to set netns ecn flag with sysctl")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b67f2f83ff32..52ce71aceb5a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2955,6 +2955,18 @@ intl_enable - BOOLEAN
 
 	Default: 0
 
+ecn_enable - BOOLEAN
+        Control use of Explicit Congestion Notification (ECN) by SCTP.
+        Like in TCP, ECN is used only when both ends of the SCTP connection
+        indicate support for it. This feature is useful in avoiding losses
+        due to congestion by allowing supporting routers to signal congestion
+        before having to drop packets.
+
+        1: Enable ecn.
+        0: Disable ecn.
+
+        Default: 1
+
 
 ``/proc/sys/net/core/*``
 ========================
-- 
2.31.1

