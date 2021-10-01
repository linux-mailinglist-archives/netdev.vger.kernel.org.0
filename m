Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7E941F267
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354819AbhJAQsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhJAQsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 12:48:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611E1C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 09:46:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m26so8464734pff.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 09:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iBoDHwA9tInr/WklD3gtP4ZESZrmpeGp8APXYmqtFps=;
        b=KX2xa0X/jOK2b0PJu3k+6z7b4aFuFptpnURTSkpT72wtX1cTUEnKZiqk7Gr4Iq+ySQ
         +CzZmcMnXKOS7el/EH5pKEyfiZNL6xHm1kPQ8lU9N5sX+ggEdzDOi6Wg8gqs3FYgHeAn
         o9ERWRhaqaCO9EJSqbKAhaQsdl5KL/nNee/JB9g7xvpcrNxYzC8p1u03zSMAHBMkomxX
         JKUI0b1tml9jnDD6+RIrwAi81cAFl7zzeSK3080sN8PPCE8MfrnlkQlG3QUnAgJ1NiN0
         HWZGqwkDBiMFbtV9/yhMARIbpv0n3NlUaeT3dirOG3e5qEoMRuVAeayX4B/6pWihDntv
         KEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iBoDHwA9tInr/WklD3gtP4ZESZrmpeGp8APXYmqtFps=;
        b=kSq6osspJKCSGj4/78SYzBrY4pyQ2Wy3HxWmbUJuURYtOicLfFH3rqvPU+IB7mDj7I
         2x8zQIob7CJk6Mm1IMcjKW/UmFclarZ8+rxNB1XiDFz1ilX6+NBAkQcVyuvsnZ3Zd7YF
         MrzJ97k8IotazNHNdwNbjIsRRc627e6OMbg6W7ZP01D+s4UG8lbtWqZmU2yS/eVNcYhI
         xvH3G4nvPVziLrfxSrj0K8aKzeLR03ETmvo0K/NNFLsVFG+Rfup1ESY7uKvyJXNWqpOp
         KjjRUjg3dW/7HApkcRIx2hF3Fzxry8HlUf07eEKTuEI6d9A+6vRcrrgpuHP5FrssKCEi
         yI2Q==
X-Gm-Message-State: AOAM530KHZpTAgwRFH+qki2PR+QHU4kRHdLCVqk7O1x+CaCczh5FxDqw
        xWwE7NWWeqFkTPKFncuTsWM=
X-Google-Smtp-Source: ABdhPJx5q5iIHOm5qn/EwU2im6bJAtyiUCfIZJ9IcGFAhUaOoDonLpENr7kqeerO9ui9BMvhFlEtbg==
X-Received: by 2002:a62:1ac3:0:b0:44b:85d0:5a98 with SMTP id a186-20020a621ac3000000b0044b85d05a98mr12373872pfa.18.1633106785859;
        Fri, 01 Oct 2021 09:46:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b59b:abc0:171:fe0e])
        by smtp.gmail.com with ESMTPSA id y80sm6770673pfb.196.2021.10.01.09.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 09:46:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net] net: add kerneldoc comment for sk_peer_lock
Date:   Fri,  1 Oct 2021 09:46:22 -0700
Message-Id: <20211001164622.58520-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Fixes following warning:

include/net/sock.h:533: warning: Function parameter or member 'sk_peer_lock' not described in 'sock'

Fixes: 35306eb23814 ("af_unix: fix races in sk_peer_pid and sk_peer_cred accesses")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/net/sock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index ae929e21a376c5fe4909da248e88b3a6595828ca..ea6fbc88c8f90f44f660bbca2cd2288e73039ec7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -307,6 +307,7 @@ struct bpf_local_storage;
   *	@sk_priority: %SO_PRIORITY setting
   *	@sk_type: socket type (%SOCK_STREAM, etc)
   *	@sk_protocol: which protocol this socket belongs in this network family
+  *	@sk_peer_lock: lock protecting @sk_peer_pid and @sk_peer_cred
   *	@sk_peer_pid: &struct pid for this socket's peer
   *	@sk_peer_cred: %SO_PEERCRED setting
   *	@sk_rcvlowat: %SO_RCVLOWAT setting
-- 
2.33.0.800.g4c38ced690-goog

