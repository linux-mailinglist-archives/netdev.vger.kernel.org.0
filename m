Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1D65F23CC
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJBPRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJBPRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:17:10 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B146833407;
        Sun,  2 Oct 2022 08:17:09 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y2so5426910qkl.11;
        Sun, 02 Oct 2022 08:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8ZKGMOLdHUAvHD8TfSpISeaa/lAswlSVkZZOT061oTg=;
        b=mkEy48eyEGRPo8CfBjpdFTfmcBVqCWeN8cTxbHoo75VCJrwfGohcqR9yEsrqzz92W1
         LqnboddvlVk5Q4A/fj/eBpAjyMYyhK1cS32pecPMKjg6PE8PouJ3/ae2RJavQNQt489L
         LuCBoSrEVzYuwE78Mk+oZ3frCOYY0qRGblc4H9czKHEvBsOXiZUCMcQs+p63CI1iNOCV
         glqbs3bikIjqMg106+WDVG1mbTy9hTVRtyi2cxnEoHBsFQ+E3ehEq0fkC9XkoZUawNHw
         Bx8f7QNVyyB4GdguQJ5FcxakvGeJcOiREQPjtKsrCBqL7Tn+PW99TqlBX2Urkf3NvTRM
         Y65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8ZKGMOLdHUAvHD8TfSpISeaa/lAswlSVkZZOT061oTg=;
        b=YWDB9qpBn87otQBSvIulMHh5a9TN6+LV1g1NawRcPCYCq8bKn6PadjgFxxASdfLgS9
         w64Ojy+HjDTGckIAIVrWfj5ak0kb5Cpfa7mL8RD6LQ8Gc3OKzn2Te6cVg0518wyLMBne
         VchezQ89sn1ZrLWGPYPfrTuv47qk35d67XVhSIpCcJlvUT2yxSBn1jm+DjDg19I1f5ae
         739HFz6wFV8zbTutSA1SyjnEWNibI1b902zz2kRC1hx8j4oQJrWlCvoJcD3P7kvjn/te
         KTcu1s9kbF1AoruQTHZzVrV50Cr7ChjwGGYQXdV4hoknm9JlHZw+jpcFTWIp1tUXHAaB
         8pNw==
X-Gm-Message-State: ACrzQf1ub2BFWQ00wuo4H2XJf8Yf6NnfVJhlPNDoonB5nDyoE/sNnILb
        lQMvB00kdhoajYGADIs6Qap1Xc6wasI=
X-Google-Smtp-Source: AMsMyM5FDsljRN+aBNt1iCHT/YyDVVvc2OJQaBZwEo+K8M0iQIF6ZForQnJfEEVftfJ+ZS+A4m6iQg==
X-Received: by 2002:a05:620a:1714:b0:6ce:7c5f:5f6f with SMTP id az20-20020a05620a171400b006ce7c5f5f6fmr11448474qkb.298.1664723828648;
        Sun, 02 Oct 2022 08:17:08 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec09:fca7:de7a:72aa])
        by smtp.gmail.com with ESMTPSA id q25-20020a37f719000000b006cf14cc6740sm4401430qkj.70.2022.10.02.08.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 08:17:08 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 0/4] net: drop netif_attrmask_next*()
Date:   Sun,  2 Oct 2022 08:16:58 -0700
Message-Id: <20221002151702.3932770-1-yury.norov@gmail.com>
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

Yury Norov (4):
  net: move setup code out of mutex in __netif_set_xps_queue()
  net: merge XPS_CPU_DEV_MAPS_SIZE and XPS_RXQ_DEV_MAPS_SIZE macros
  net: initialize online_mask unconditionally in __netif_set_xps_queue()
  net: fix opencoded for_each_and_bit() in __netif_set_xps_queue()

 include/linux/netdevice.h | 53 ++-------------------------------------
 net/core/dev.c            | 34 +++++++++++++------------
 2 files changed, 20 insertions(+), 67 deletions(-)

-- 
2.34.1

