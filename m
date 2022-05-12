Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AD2524CEC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353786AbiELMd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353778AbiELMd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:33:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA2562CC3;
        Thu, 12 May 2022 05:33:52 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l11so4444272pgt.13;
        Thu, 12 May 2022 05:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gb3yCMXjkJI3+/JdjwFtXR6lgNAbIQCRTIXFBT2FkvU=;
        b=ElAs+DxFqXkJuHRHsQbaryOMx9dKJ5C4GmzY+xHi0RPDRLKXxYvj/4SQTL39jj5l6G
         pMtM4bcCpoVh4TPBUAxsRdDWDkvIEDevlKtbtLU2+/JQ7TtBah50NYR5m9TH6TO9FhBn
         Dz3GIlxkNG9uqxplLgQDGZNnH5/8+GiH9Rqzb5xd6Md0hUkyYIaetlk+nSOqjHay9xhd
         hYivK0ffOdlz79Pr5nvKr0diOIH37zuRFwKDBgFekwJyyWnHpd621XMCRdTPdKQNdpjR
         SeP3HW82fsnl7fnIqcsp1Dt1nr1uHI8w+IwO5Ca0YOo1ccykKFnrfYZSG0tgTBTdHETP
         Fp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gb3yCMXjkJI3+/JdjwFtXR6lgNAbIQCRTIXFBT2FkvU=;
        b=ozmLq5Q4Dc7CoQ18idP1kuqM0kU3PhWoNpLc/BYpEQHExbOOg8Yo7dgzllnzmhcJRm
         yXqYw3pz+kDvCXUfbXw7kA0E3R+Uy/KZcWGevmIRXbvHOWehqqU1wfdZaK3we9AAmIe8
         0K8AltZiwpClXm0TSRltcCPPaIMi2CRmyMe53RO6DdD93LVLp0tU34qHyec4stxs4MUV
         mpXTR5ZBADLKfb9QMc3Cl7B2gL66vC7w+T9c2t9ovYPilBhxWC8YQmJVQEqFo9koW7QD
         BQvSUv3eCld3D3CJeea5nPnapRowgk1jFb0y+vrKK3XGSZvKmeymaDcXipp5ThWlqPri
         lSvA==
X-Gm-Message-State: AOAM533mRx2LaAWd817k4DqHLFdgq0V9rWhy/AlDf+E2yHtjGj6T6jpe
        8DoCYWamw3SKTEtwaD7vusY2ZrCF0gA/hw==
X-Google-Smtp-Source: ABdhPJzr+56PnXBNQeGVzO7lKfSS6xc5F3BOBoi7cpAGcE5WEj4ippPAZ73wvkKzuxD8AsQZKEyIMA==
X-Received: by 2002:a65:6c06:0:b0:3c2:81e1:fd72 with SMTP id y6-20020a656c06000000b003c281e1fd72mr24987226pgu.209.1652358832440;
        Thu, 12 May 2022 05:33:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id y24-20020a63de58000000b003c14af50643sm1738130pgi.91.2022.05.12.05.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:33:51 -0700 (PDT)
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
Subject: [PATCH net-next v2 0/4] net: skb: check the boundrary of skb drop reason
Date:   Thu, 12 May 2022 20:33:09 +0800
Message-Id: <20220512123313.218063-1-imagedong@tencent.com>
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
(2th patch) and drop monitor (1th patch) to prevent such case happens
again.

Meanwhile, fix the invalid drop reason passed to kfree_skb_reason() in
tcp_v4_rcv() and tcp_v6_rcv().

Changes since v1:
- consider tcp_v6_rcv() in the 4th patch

Menglong Dong (4):
  net: dm: check the boundary of skb drop reasons
  net: skb: check the boundrary of drop reason in kfree_skb_reason()
  net: skb: change the definition SKB_DR_SET()
  net: tcp: reset 'drop_reason' to NOT_SPCIFIED in tcp_v{4,6}_rcv()

 include/linux/skbuff.h  | 3 ++-
 net/core/drop_monitor.c | 2 +-
 net/core/skbuff.c       | 5 +++++
 net/ipv4/tcp_ipv4.c     | 1 +
 net/ipv6/tcp_ipv6.c     | 1 +
 5 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.36.1

