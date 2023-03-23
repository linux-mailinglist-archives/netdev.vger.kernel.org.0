Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3150C6C6392
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjCWJ2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCWJ2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:28:10 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1647A1B542;
        Thu, 23 Mar 2023 02:25:01 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y2so8303210pfw.9;
        Thu, 23 Mar 2023 02:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679563501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oedrkQTKeKhk5jpPMXJExckMWKmDYsOLUWEd03oO1jc=;
        b=Xsnwqe0u+OhenA0uQnCmo5f7oZse/SWWrlZMDr1wmNtIez+HCNRnydnG7mIWS5H7cc
         jQErK+9VQDBe9Ybt86Bh8s5xzW660Zs4Wlc0qYNxJGvE/KrYckpFYE3c7BjNeAxxnJR/
         +CPRu1DhGodVbU5q9R8xszUXPwfvJkbd7GyiLnGnDiXIV3IR5RVubAFqy5uedx5/rpBU
         desOUjczT857xaWluqFGj5kMfTiiRQenWqjXBO5QNuVfO4Gi8uqxPFGwGVw/1ZC7L+es
         Z8aTaPy+16fxwcuRztySG+OgRmQNXcBgKwcbE3lZjj3V5uNpIhoOU8QZQ6Y5BYdcVnH/
         Gf0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679563501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oedrkQTKeKhk5jpPMXJExckMWKmDYsOLUWEd03oO1jc=;
        b=tvlErEZ0rFvo2rd0SAz1xjl83bgOYTRUYE349+DTpxU7bfZFchRvmzE43qAqNgsHPC
         Au89A2n6rTRKqJPVIMgaoLxuv7M/hbPShImRgmCkK9av5gzeRRYCCRasVz1ksEFrQJzE
         W3SVXa4YHkE/qbLJxiY1okJjGJuJcj8W/2llWK+q5aHNvko5HmvO/23O85cpM6dhUMFO
         RZX97efjbDidbGILgMA+5OQmFFESg+dalnbx64vtptZkQsdm4GQd/FsBbnedbbEbVW3c
         DjQjwNbH8IArypKdGanu0fwZMF1ulmZ3MIN2HsZmi7OWRAYNMCpRteQNNPHeaWUUWRoX
         2n/w==
X-Gm-Message-State: AO0yUKXrC/NCGenecwyltk2Le67X5yq9qFi0mS6z7w8z1/n6Gk8ibSgG
        ZOnQTWUctlKcaaSr5aHLdyg=
X-Google-Smtp-Source: AK7set90RsGF6plNEmkD3dIggH5nrDX5jcX7Ql9g4f9DKWsEsiMQK33OuujoCaxeaDME4YoPIa1akg==
X-Received: by 2002:aa7:9dc1:0:b0:627:e69c:847c with SMTP id g1-20020aa79dc1000000b00627e69c847cmr6401408pfq.16.1679563501129;
        Thu, 23 Mar 2023 02:25:01 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id u16-20020aa78490000000b00627df85cd72sm9547769pfn.199.2023.03.23.02.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:25:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 2DEB21066D3; Thu, 23 Mar 2023 16:24:56 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Linux Wireless Development <linux-wireless@vger.kernel.org>,
        Linux Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] wifi: mac80211: use bullet list for amsdu_mesh_control formats list
Date:   Thu, 23 Mar 2023 16:24:54 +0700
Message-Id: <20230323092454.391815-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1928; i=bagasdotme@gmail.com; h=from:subject; bh=sghnb6cYp6gN1i8QCZqutc4mpo/Cxsdj7NRwu8vq+VU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkyUo8eHzmYfPRswKMlnzI3W72vkvracW57yWE9v+lG2 2ZOzFO90FHKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJnJNnZHjVwetxtMOwVtgi rJhzkpP32kmTmkqdrnE/f7p3cZ2YRgrD/4zzMT8rpB82877SmnmCad+uu3V7agueN1zTVtB1Yi8 15QAA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fe4a6d2db3bad4 ("wifi: mac80211: implement support for yet
another mesh A-MSDU format") expands amsdu_mesh_control list to
multi-line list. However, the expansion triggers Sphinx warning:

Documentation/driver-api/80211/mac80211-advanced:214: ./net/mac80211/sta_info.h:628: WARNING: Unexpected indentation.

Use bullet list instead to fix the warning.

Link: https://lore.kernel.org/linux-next/20230323141548.659479ef@canb.auug.org.au/
Fixes: fe4a6d2db3bad4 ("wifi: mac80211: implement support for yet another mesh A-MSDU format")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 net/mac80211/sta_info.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f354d470e1740c..195b563132d6c5 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -622,11 +622,13 @@ struct link_sta_info {
  *	taken from HT/VHT capabilities or VHT operating mode notification
  * @cparams: CoDel parameters for this station.
  * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
- * @amsdu_mesh_control: track the mesh A-MSDU format used by the peer
- *	(-1: not yet known,
- *	  0: non-mesh A-MSDU length field
- *	  1: big-endian mesh A-MSDU length field
- *	  2: little-endian mesh A-MSDU length field)
+ * @amsdu_mesh_control: track the mesh A-MSDU format used by the peer:
+ *
+ *	  * -1: not yet known
+ *	  * 0: non-mesh A-MSDU length field
+ *	  * 1: big-endian mesh A-MSDU length field
+ *	  * 2: little-endian mesh A-MSDU length field
+ *
  * @fast_tx: TX fastpath information
  * @fast_rx: RX fastpath information
  * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to

base-commit: 0dd45ebc08de2449efe1a0908147796856a5f824
-- 
An old man doll... just what I always wanted! - Clara

