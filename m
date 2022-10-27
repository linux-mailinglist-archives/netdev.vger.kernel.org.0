Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585F760FC9C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiJ0QEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbiJ0QEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:04:45 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1212AAE52
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:04:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so6909065pji.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LFkbdG0WJnQwKqhJhztNzEofG20pgK23MPm3Xycvem4=;
        b=ku/L2v0i3ATZxKBwUjVe+jZAf89cFqlCmLVnigJas1VmcVOD3SrQteecKDk0MLv2AW
         L1EnLIgoThFweF1LiwLj1FOrJfOXVQxxLX8RIvQdNXV4vU9o5/fogWB2tWKecNUofRPG
         UVTkyrn1dnWr3liNifPr2u1UDEErvYaDY+fsnHC1bpUC2EfxIkjkxjuFpBqYVIJDHM87
         XrcDghDFf3VxYN/ONRrMHB31af2Y0UZYZ8cucTwZT8JTiJEC0jfum8YXgp/EfwdzUVgc
         QmCc6ZGaZjLr/ZpkOuuvJ99kBkJA8Bw14L6svD0YJi4JN3hxctrBmJuVr64MO1+PNNCc
         YDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFkbdG0WJnQwKqhJhztNzEofG20pgK23MPm3Xycvem4=;
        b=YAZMQl/QNhON4n27RI72PcVVpy/UIL1mb5I1gPcYu/0qWaV/wEWfb6he3XOKguOyl3
         9HrhmYBmpiwD4FOVoIfE0L0vmIsQZ0ngCOKrqQBc37RJ+QmjMHYQE9zCKUyLflVMnGCv
         w2TgmO3e9NBc0+rNCpBPLT6hXuzh8KGMd8u3NMo3U9E6JwTlCtEGVgvkHrTNd2LZhmMe
         /7dSE7GFaCx1bYLTz9pAb+RFX5M35uY8YSxq82xyqcwggy3/2ynSQasxMFs1dMP+EXLF
         U96Sw/Cwg4Q93bBvkiH8sJpPTm29RyiomUBE9zooHPIhtxozHGzrU9q2+9SbxgoPs4g7
         hYlw==
X-Gm-Message-State: ACrzQf2kRO3lEsuyOTreJw0HI9PrSJCeMNPdAT/P5CVwsi8ILUKcPIZe
        0OrOsmHxuREyhj6nBOE+2WPJ1NqCd7QIK6sb
X-Google-Smtp-Source: AMsMyM4dRn7uKUTea5U76m+G3SPGkgLnaV5LGGSXy5kGOmVK/XfWTqyvCz7bejEGfn7gfrN6eIxI9Q==
X-Received: by 2002:a05:6a00:a21:b0:562:99d6:c30a with SMTP id p33-20020a056a000a2100b0056299d6c30amr48113160pfh.35.1666886672034;
        Thu, 27 Oct 2022 09:04:32 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id q91-20020a17090a1b6400b001f94d25bfabsm2835612pjq.28.2022.10.27.09.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 09:04:31 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, simon.horman@corigine.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org
Cc:     skhan@linuxfoundation.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next v3] net: remove unusged netdev_unregistering()
Date:   Fri, 28 Oct 2022 01:04:24 +0900
Message-Id: <20221027160424.3489-1-claudiajkang@gmail.com>
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

Currently, use dev->reg_state == NETREG_UNREGISTERING to check the status
which is NETREG_UNREGISTERING, rather than using netdev_unregistering.
Also, A helper function which is netdev_unregistering on nedevice.h is no
longer used. Thus, netdev_unregistering removes from netdevice.h.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
v3:
 - v2 link : https://lore.kernel.org/netdev/20220928161740.1267-1-claudiajkang@gmail.com/
 - Apply review. Write commit message more specific.


v2:                                                                             
 - v1 link : https://lore.kernel.org/netdev/20220923160937.1912-1-claudiajkang@gmail.com/
 - Apply review. Remove netdev_unregistering().

v1:
 - Replace open code which is dev->reg_state == NETREG_UNREGISTERING to 
   netdev_unregistering() helper function.

 include/linux/netdevice.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..99e58b773266 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5101,11 +5101,6 @@ static inline const char *netdev_name(const struct net_device *dev)
 	return dev->name;
 }
 
-static inline bool netdev_unregistering(const struct net_device *dev)
-{
-	return dev->reg_state == NETREG_UNREGISTERING;
-}
-
 static inline const char *netdev_reg_state(const struct net_device *dev)
 {
 	switch (dev->reg_state) {
-- 
2.34.1

