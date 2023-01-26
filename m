Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCC567C4C4
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbjAZHOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbjAZHOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4173947427;
        Wed, 25 Jan 2023 23:14:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73875B81CFD;
        Thu, 26 Jan 2023 07:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B8CC433EF;
        Thu, 26 Jan 2023 07:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717272;
        bh=NsLtXHVZuv9pkXH6rJFVglLpeLeDcZUvVrcqHsNm6Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6a5RaoS2P656tj8QKlcyfszVI9oX9EA963egGff5h3eJk2LApUxZepDXNsdIj23C
         MZj+J9NfLKFG26og3L8j1P7Iq2hxUSVRy3BDjpCFPmRNP9rXbQ032PqAcChSZRgUab
         DOPC/tdEN1PDCA6FvztGPtXH6kejkpEFFKNMRTce+ftJO9jommJwA6otxBOa8k0IXO
         10jK4mMQo/O0i1ietZVhss3ElX0cYgtc1IffGu26fp3RVPnKJzSRBUqVnTl5qkpylX
         v6Rh7h0aMdFUSkU5XhK2aZdYoTgcL3ptUxckhZy4eGnBe1LezYPZrnhGqUOvs42jFh
         cNzxrAGaCM/Lg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, kuniyu@amazon.com,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 08/11] net: add missing includes of linux/splice.h
Date:   Wed, 25 Jan 2023 23:14:21 -0800
Message-Id: <20230126071424.1250056-9-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of files depend on linux/splice.h getting included
by linux/skbuff.h which soon will no longer be the case.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kgraul@linux.ibm.com
CC: wenjia@linux.ibm.com
CC: jaka@linux.ibm.com
CC: kuniyu@amazon.com
CC: linux-s390@vger.kernel.org
---
 net/smc/af_smc.c   | 1 +
 net/smc/smc_rx.c   | 1 +
 net/unix/af_unix.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 036532cf39aa..1c0fe9ba5358 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -27,6 +27,7 @@
 #include <linux/if_vlan.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/ctype.h>
+#include <linux/splice.h>
 
 #include <net/sock.h>
 #include <net/tcp.h>
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 0a6e615f000c..4380d32f5a5f 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -13,6 +13,7 @@
 #include <linux/net.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/signal.h>
+#include <linux/splice.h>
 
 #include <net/sock.h>
 #include <trace/events/sock.h>
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 009616fa0256..0be25e712c28 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -112,6 +112,7 @@
 #include <linux/mount.h>
 #include <net/checksum.h>
 #include <linux/security.h>
+#include <linux/splice.h>
 #include <linux/freezer.h>
 #include <linux/file.h>
 #include <linux/btf_ids.h>
-- 
2.39.1

