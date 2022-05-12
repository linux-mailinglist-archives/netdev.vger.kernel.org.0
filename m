Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BA25245B8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350376AbiELG06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350354AbiELG0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:26:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D5B5BD25;
        Wed, 11 May 2022 23:26:45 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d22so3965407plr.9;
        Wed, 11 May 2022 23:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8yRr6IhHVycdTfaRSyz5soIw6uXvzqCiB4oJS5Tk2Vs=;
        b=IlDPnzybBtoyQZsEd79y06SMZcbZWh1SaBQ0rO9v6ks/JHkYUXgf7vhPgJQCrAk0ag
         aWfdj8RyHeGAycKJtHnD5cJrYx1yQFqPebH9KAXwUmP0pU5WAYe7t5zDgvfQThRpBNhN
         4os8OhxS2MlqNssrrNwHEqUPvnDHbgfNtPX2OxkZfMnZv9e1Cu3IXCOinzCjOgnMFBc5
         W/jeJDlIuBrmyKpbfsGNJ7ezc/clMGAvoquM5rNUuen/Cargu3yo56dpbMFKaXeBAuvj
         ixz9a2Ag/oQ3zC3V21p0MZ+aHh35fwQDGjzSnDQAPsvNQVdVNe9BjLzzME3FYnuqjB9g
         FGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8yRr6IhHVycdTfaRSyz5soIw6uXvzqCiB4oJS5Tk2Vs=;
        b=4kLvhJY8PbcjoIUgQaQvtJyjAf7fizh3XzEx8zc21ohYfoXiBP2lenTL6fSgNV+0Bt
         cJOhhw0u0hkpRu0wWn8zBJqhc8UuilgFH/SUb0fg43097Jbm9UXaypxMlg3jOwtAQPH2
         AlRV7k+rjMCGMDtWZw6vvNPNgN1d7MQ1sKRmvHPpYKEu+G1jRRPWN3MVBlZeQKQpQy8t
         5PjLQLJrf+PPjsCRu+GIxUPzIMraIPvV5apCwgIt/RD2T0WVzcCS0Te7pHrntQfX6CGu
         2YXi1UC1Md7ordyB2gBkZBa/AsIOP7rfnwh0AWJcpMl1hDQjls8syP7bTB7cFwG7sXoD
         3Rdg==
X-Gm-Message-State: AOAM531sWQ7R/Y7nKoHqYr8JlVJ7Q8fn7qKBFCjMqzhUGL3U08AjPF6l
        ECpfHU1FcSgwZFDxd7iWPUc=
X-Google-Smtp-Source: ABdhPJyEz+lEtQC2DnvQPHiOEcNFsbv1te0Q/MxC8WuZz4tdeQROJlXHWlKZoGWHora4MZXOxAItOg==
X-Received: by 2002:a17:902:8698:b0:158:99d4:6256 with SMTP id g24-20020a170902869800b0015899d46256mr29321539plo.104.1652336805313;
        Wed, 11 May 2022 23:26:45 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id gn21-20020a17090ac79500b001d903861194sm999748pjb.30.2022.05.11.23.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 23:26:44 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, asml.silence@gmail.com, willemb@google.com,
        vasily.averin@linux.dev, ilias.apalodimas@linaro.org,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] net: skb: check the boundrary of skb drop reason
Date:   Thu, 12 May 2022 14:26:25 +0800
Message-Id: <20220512062629.10286-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
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

From: Menglong Dong <imagedong@tencent.com>

In the commit 1330b6ef3313 ("skb: make drop reason booleanable"),
SKB_NOT_DROPPED_YET is added to the enum skb_drop_reason, which makes
the invalid drop reason SKB_NOT_DROPPED_YET can leak to the kfree_skb
tracepoint. Once this happen (it happened, as 4th patch says), it can
cause NULL pointer in drop monitor and result in kernel panic.

Therefore, check the boundrary of drop reason in both kfree_skb_reason
(2th patch) and drop monitor (1th patch).

Meanwhile, fix the invalid drop reason passed to kfree_skb_reason() in
tcp_v4_rcv().

Menglong Dong (4):
  net: dm: check the boundary of skb drop reasons
  net: skb: check the boundrary of drop reason in kfree_skb_reason()
  net: skb: change the definition SKB_DR_SET()
  net: tcp: reset skb drop reason to NOT_SPCIFIED in tcp_v4_rcv()

 include/linux/skbuff.h  | 3 ++-
 net/core/drop_monitor.c | 2 +-
 net/core/skbuff.c       | 5 +++++
 net/ipv4/tcp_ipv4.c     | 1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.36.1

