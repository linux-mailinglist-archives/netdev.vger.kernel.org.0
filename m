Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5404E54B61F
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344296AbiFNQam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242973AbiFNQaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:30:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4769443C0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:30:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gd1so8933207pjb.2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FtqzzQe2+EjpX9IjwYut+EP9igyPRTCiX9Db9s2vXzI=;
        b=WDknQGGK5YcdVIDeZF09cWgaCv1C0Fz5lHOFXwHtzia9rAaskHQmX38wbrIAd3Lxmp
         xmjKNRE+2pKFjhXsBxBAktYZyNs8ma2mAu5faiy6q+D4W7kocn6Jg2wFePws03iZyStV
         9pAICV3Mabw8N2ITIi147V79qZ1UJMmEihaQI1O2zPrZOyUrVegHcXCILSV9Ta0xphnf
         hvM2uGGWGzcl/2SvMQj02DK1Ye9GPw7d4oIg0RQhte7zNGjouzOpqY6BV1XnYcLXTimV
         +Arn9LfMtGWeDtvocAHXGU3IOTPKd+vFPG5vtbPWlzTg/XgmIrw+wClLza8dHYnFdVZq
         DmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FtqzzQe2+EjpX9IjwYut+EP9igyPRTCiX9Db9s2vXzI=;
        b=idOgcGinuUreu2KPCQgbvmIPN3aazvkKTDECS0Kk5NgQR7DCM+CoTtuoMGcpFnox/8
         YIBZ1Yne6QOlEWG7GrBTiM0oF3DwIhi/MrQDwaQNSrqgy9h8Kab9p/xjraivLpLHhTsx
         ff9ytXL1otQK5SJm3D7j4dmEKwVtb43g8NPS3lcER2f8atZi6daZDNAZVjtwpkSdD+ZR
         ybVGgaIlxK2/9lUr2t07qB5hDcRvhBFtVlALHxj3r7ml+scw694vGSvTO9BTb/qFhapD
         LqgCPlQVT5A6SDByl7KUUz+XLByWGlSy+wGNBFq6IrHdKuAYwXcgBgrog429lswWCBXA
         Krjw==
X-Gm-Message-State: AJIora/YsnErZmAuBDKZyKt/S4Wb5B+7LH9wrrq+lWquguaQKJmwPpcv
        3KO1Sd0KrGJakFRd0tpJubI=
X-Google-Smtp-Source: AGRyM1t1L78IaEuMgzKqhnMTB/Ir0kpqNMXO68/hhDIJZKjODYiVL+iAazohxSh0VbNfsCqpu70IwA==
X-Received: by 2002:a17:902:d545:b0:167:6ef7:d540 with SMTP id z5-20020a170902d54500b001676ef7d540mr5055928plf.133.1655224228109;
        Tue, 14 Jun 2022 09:30:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2dbb:8c54:2434:5ada])
        by smtp.gmail.com with ESMTPSA id p1-20020a170903248100b0016796cdd802sm7506484plw.19.2022.06.14.09.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:30:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] tcp: final (?) round of mem pressure fixes
Date:   Tue, 14 Jun 2022 09:30:22 -0700
Message-Id: <20220614163024.1061106-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

From: Eric Dumazet <edumazet@google.com>

While working on prior patch series (e10b02ee5b6c "Merge branch
'net-reduce-tcp_memory_allocated-inflation'"), I found that we
could still have frozen TCP flows under memory pressure.

I thought we had solved this in 2015, but the fix was not complete.

Eric Dumazet (2):
  tcp: fix over estimation in sk_forced_mem_schedule()
  tcp: fix possible freeze in tx path under memory pressure

 net/ipv4/tcp.c        | 18 ++++++++++++++++--
 net/ipv4/tcp_output.c |  7 ++++---
 2 files changed, 20 insertions(+), 5 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

