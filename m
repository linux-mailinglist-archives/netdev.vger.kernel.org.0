Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04365AF344
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiIFSE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 14:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiIFSEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 14:04:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241E01B7AE
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 11:04:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b16so16227635edd.4
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LVyWz9QjSr71K78QY/khwjiVlTkSeqPk1bL9XsiAab8=;
        b=Re5zgjEeBJwrtp6COp+yqdoKd0kJxgGB9EP8EM4lHbOkdRlFx+tG2KqkBItnfXBGLD
         0tJMg3b8rYTWqe5f+cbyWHxbMaF+qobw27G/noRRFH1el11lb0fzZER/R8A3G8NTFxEd
         j3LmcYlQRRgWYrLvdFaXMxGByfC3JcMtsiavJn7M389LN+Z5VjN8SjSvYZ4g4/iWxkhM
         ohI3Jf0X6QW6PyVWIKSnJQtEJOzMIPOhC1gYRpxgCXt8mtZxmxNF/UQf6iuv3w2xfsPh
         54aQrCsU7j7XYCmXDQj7hGzXURi43HqGgm7Kpr09I0t/QXcMQ4IHbYHBgfZFp8LDLCkx
         AQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LVyWz9QjSr71K78QY/khwjiVlTkSeqPk1bL9XsiAab8=;
        b=rzsB1Gs0MHIkkn+WoiIyvLBBUjetGu+ZF2rdrEmBJSKrl3wSDKq9GslZAaOu7yQ9oo
         2BoycE0N+CsyrH84k7A0nDm54ebo+DouAXkjCGjGlXAHm5gBYkyd1M/Mf81vYhRDw5HC
         lAPIyx4nr+OUQ3KS0atHssn9McK4jhqfPM/wi51R2okV7v6oX8qlpobbzRjRMnv1uESu
         IaYbdU5h5Lw+fkspDozQnT1H4sddS34oF5hMSTZfi2Zf6gqo5icgucOpEQ60DDnhZft7
         77QK2NuuiEhOXRNKOTqYd6UBTki8xgYkD5yhQYi9k38JKX00gJ6qle8Qx35BZU+sOGM5
         oNiw==
X-Gm-Message-State: ACgBeo3GZ7PLbkTtkIgqpJs6ykJQwJU1cNUM/mF6XWPbQeO7n3GZ81St
        KboWLpIRjQbfaEviphMhi73pcQ==
X-Google-Smtp-Source: AA6agR74kDMSCpJxhGlyOhnVWcbezEO1RBH7czD3h8FziyPXSo5pBqCBmmaucK+Bmgt7//B4Wn9b4Q==
X-Received: by 2002:a05:6402:415:b0:446:230d:2b82 with SMTP id q21-20020a056402041500b00446230d2b82mr48496731edv.200.1662487482513;
        Tue, 06 Sep 2022 11:04:42 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t6-20020a170906948600b00731745a7e62sm7007845ejx.28.2022.09.06.11.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 11:04:41 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH net 0/2] mptcp: fix fwd memory accounting and doc format
Date:   Tue,  6 Sep 2022 20:04:03 +0200
Message-Id: <20220906180404.1255873-3-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906180404.1255873-1-matthieu.baerts@tessares.net>
References: <20220906180404.1255873-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=628; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=cJSBkCmTFkNb+vTncfw1kpPps+aLxPT32YDqXYY6lw4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjF4uE2d4DWi8yvA2+8upFVesEuDDIHcfCBUtQV2ge
 XrB2+pqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYxeLhAAKCRD2t4JPQmmgczOeD/
 wIMnPNtrhZbg4tgRD18zm7fDyFZYITI3h1PCNF+6KwWJ6lmiQYWV0XKSMIk2NAmK44K66TL9XtcY81
 1QEtaKMawaIhqrhIFpAwqrcYye8HigHyMswwTtBX/u7LONhb4ZFvC0Fe7gKLhDHMcPeCF5H/DZMcld
 wS1Kqk6zYx/6JHLJDFp9TFdeABiOkR0fKXbuZr41hNmC+qPOKeBy5o0/SL2B0BrQwmE4vqGhD79V3L
 6dPXK/qsjfgD80EYOkg1kHvehBoAk2rJuHlDuOlTfABRNwB4rC4CiPo8N6w2o877M5Yzv5jD5Nv5wQ
 k/rCi3FDp9A9w6p2tbYL1168/DxoczkmDHOyuO6tohuzwn+ddCFBhJ3VeQqIsPgBSLYz0gBzB1v19V
 iBE5pq2cf1oQ+2hYK55m19T12y0ULKZwZfGd6+xgx5Kb++qYF7NTpSeqZo0X99hctnldRK8U8ARQTJ
 RNWaQhzPz3TvpOWjFtdMryRHm/LKSrB5uaDmHR9WlVfsXCUioQd5+FktBHaaZIDjnnNMH/ALEX6ECX
 QVVthel6qGBySl+oifBPvxxvwEW8l0OGNzj+ZMSyPUtyOxW4On0vXJqX26iNuG4+/v8Sxv2ZBEP7M6
 4gFyBE7YGdiQFZRsRMHFLGKfw4vKz6duQsDdeZ4vu3Wi8Y6J5L6GVYDKHbjw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes a memory accounting related splat reported by Intel's bot. It
fixes a regression introduced in this cycle (v6.0-rc1).

Patch 2 fixes a formatting issue in the documentation. The issue had been
introduced in the previous version (v5.19).

Matthieu Baerts (1):
  Documentation: mptcp: fix pm_type formatting

Paolo Abeni (1):
  mptcp: fix fwd memory accounting on coalesce

 Documentation/networking/mptcp-sysctl.rst | 1 -
 net/mptcp/protocol.c                      | 8 +++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)


base-commit: e1091e226a2bab4ded1fe26efba2aee1aab06450
-- 
2.37.2

