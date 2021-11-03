Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B050A443B8D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhKCCsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhKCCsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:48:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0EAC061714;
        Tue,  2 Nov 2021 19:45:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u11so1535601plf.3;
        Tue, 02 Nov 2021 19:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nw9KVnT8PMeXUXo9bUvbg5RLD/BnH9iNLwogddXnvZs=;
        b=CqpI7Xxs3cFAfQqnKOtLWaMRsTzjEhmQzrwN3vnK7wbjNn1exvesf9HrmNX/lrLSQ4
         KCpKwAaM1mZlQ7qQliggfOqqBZUw/lY2OOfOsIxgvtxaOswdnnUhgvds0ykksLp+nlEF
         YNI35OU4IiuP+0Vy03A2qUorrCKlfgoCDhdVY/hP5OXJ8Q2oFjrC4ep4qQ4r88Z9wtrL
         b3RIPyxhHTKHf1FiQkuiDvcE/Bryd/Tb8eY/W0uExzZJd+q8pbH9tsV19zNqaM43OQOO
         nrcU5dQWaoxIwNMMXqkl41C1oc8wxc5BWIV+rF6OMfDTYtqR9nTPazw6OMlhmMQTnY9f
         FcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nw9KVnT8PMeXUXo9bUvbg5RLD/BnH9iNLwogddXnvZs=;
        b=Hr44WBwQtCxPmNiFo1RKBcsc1PcKNEd+9mPGz5elbns87MxueOv3qOlzhceNFTVfKS
         1aGSI7nhYoItlCkV0jRS5HFuwCXciWHzKU7HJVHi5SyqPHwkBPhHDcAxiYMloeE9AnUr
         Tj+MAohtbVF4aqE/4vtjmk9H6DCtIqaoFx3gBdvWxefO+IMELyOqNN63RcMakpPzrP1s
         WRtZdFLcG7rupMo/6Jj3lF8sVmbfjkpLfw/vKgK8ZBS7KMUPmKwJsm1spBfDlgJ31Xgt
         1zimP176XRSeqCKJLC5cJ2Ra+GhoywCCuFtdBpcF2v0RHRh5XayS0CtlTBHIk8CjnHEX
         Swvg==
X-Gm-Message-State: AOAM533eF5iX5y7DbqM2jy3jlgnR5IK+Lqejot8rqeEpevT3yEOXFbop
        5a8mATwVd9BaTjooA2aR/l+rkKgG/EU=
X-Google-Smtp-Source: ABdhPJzgLcmwsJXkgDkNGZqPRe19LIl+StSnlgNbDIEWdPeaSjASJQGmFD5CdzG9W9VOpqMrhvoXTQ==
X-Received: by 2002:a17:902:c713:b0:141:bc54:f32c with SMTP id p19-20020a170902c71300b00141bc54f32cmr26113768plp.82.1635907530119;
        Tue, 02 Nov 2021 19:45:30 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm348088pgn.94.2021.11.02.19.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:45:29 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCHv3 net 5/5] kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
Date:   Wed,  3 Nov 2021 10:44:59 +0800
Message-Id: <20211103024459.224690-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103024459.224690-1-liuhangbin@gmail.com>
References: <20211103024459.224690-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the toeplitz.sh
and toeplitz_client.sh are missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Making them under TEST_PROGS_EXTENDED as they test NIC hardware features
and are not intended to be run from kselftests.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
--
v3: no update
v2: move the tests under TEST_PROGS_EXTENDED as Willem suggested.
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 218a24f0567e..7615f29831eb 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -35,6 +35,7 @@ TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
+TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.31.1

