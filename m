Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018DC5FE5F2
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJMXny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJMXnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:43:52 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B59718C420;
        Thu, 13 Oct 2022 16:43:52 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w3so2749928qtv.9;
        Thu, 13 Oct 2022 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M3AV7ZQbI7aNl/tYezng4lVshBENwgW5MmDC2ALTMOU=;
        b=Dgwe+FsBX5p02aA/HrYcjA2hSo4aa6LZcE5tZ5X77GSffPHlEzTNHQFZEo2BuX6rVJ
         wO1wxGkmxEgyA50nCZ9Zhq3JggNVPlqsnkk1jjIZaWeQydKN2jGhlDSxEJ+tFbT80oFc
         vQAxt59KcqJbqEl3pfNGjWIKjX0ferW7vq/apXCMdZC20zg50mjj8t9IEKN+Vq44sYy7
         eEzlDUH1qhoQeuOdGWuLkCrhR9qEiO+LPQiN+RFKUXtnP/Ul1Akg+GBz6jl+szPt4Ssf
         f19isGUAYVfEOFlpRUp39I9k5s8IYvC5O1Xw6CEqcMJMpQ8quM0XFkfzp2Icv37BNI1p
         RPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M3AV7ZQbI7aNl/tYezng4lVshBENwgW5MmDC2ALTMOU=;
        b=sqOQVue5UgV3IKWjrY30kNli4Wz06Joll6hxC2Q2CV30+yGb3y78XLzKBXN33T2Xw6
         WM9hrc9SXt2TkD4gg+naZbWXiIilxj0DqaiIltWR6RQK5w9aBbSze0xd4uILTt9aATHn
         mgo70RkY5W1PGlJ7OTu4sBRT+WZ2XqQua4oHqvgA8S2BwU6BGbvOglFsqTmNxWQY8EBC
         L/L/T3gC+OpD3aviy1M9xMU07wxdErrmGdjMIt2SwwQJUG5dTt4+8g3xyKot3gN0q0LP
         20qcbVkFoTlFUWrdxkN2msryJRBawkmYajCk5HftuN2tmTV/RE1Z6H5RqwswJJfe7w8s
         +kxA==
X-Gm-Message-State: ACrzQf1ljfgOXQECrlew2/d2yU2i9LM33a6LLnaq3WRgNyQlHlXLu0dw
        blHZq+WamXYUAfFRmfDOV56p3wecqlY=
X-Google-Smtp-Source: AMsMyM7/dmSKM1pdeovR5OlPEchqOBoiCfJiV3EkIND51Jdfe1F1tWPFbGEUfjcqIDxog08KAts3+Q==
X-Received: by 2002:ac8:594b:0:b0:35c:d0b7:e2f9 with SMTP id 11-20020ac8594b000000b0035cd0b7e2f9mr2099023qtz.483.1665704630995;
        Thu, 13 Oct 2022 16:43:50 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec49:7545:4026:a70a])
        by smtp.gmail.com with ESMTPSA id d3-20020a37c403000000b006bba46e5eeasm841543qki.37.2022.10.13.16.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:43:50 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] net: drop netif_attrmask_next*()
Date:   Thu, 13 Oct 2022 16:43:44 -0700
Message-Id: <20221013234349.1165689-1-yury.norov@gmail.com>
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

netif_attrmask_next_and() generates warnings if CONFIG_DEBUG_PER_CPU_MAPS
is enabled. It is used in a single place. netif_attrmask_next() is not
used at all. With some rework of __netif_set_xps_queue(), we can drop
both functions, switch the code to well-tested bitmap API and fix the
warning.

v1: https://lore.kernel.org/netdev/20221002151702.3932770-1-yury.norov@gmail.com/T/
v2: Fix missed bitmap initialization in patch #3.

Yury Norov (4):
  net: move setup code out of mutex in __netif_set_xps_queue()
  net: merge XPS_CPU_DEV_MAPS_SIZE and XPS_RXQ_DEV_MAPS_SIZE macros
  net: initialize online_mask unconditionally in __netif_set_xps_queue()
  net: fix opencoded for_each_and_bit() in __netif_set_xps_queue()

 include/linux/netdevice.h | 53 ++-------------------------------------
 net/core/dev.c            | 35 ++++++++++++++------------
 2 files changed, 21 insertions(+), 67 deletions(-)

-- 
2.34.1

