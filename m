Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9605FE738
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 05:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJNDF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 23:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJNDFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 23:05:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768DB4D263;
        Thu, 13 Oct 2022 20:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16485B821B3;
        Fri, 14 Oct 2022 03:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A928C433D6;
        Fri, 14 Oct 2022 03:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665716709;
        bh=ldowPF7sFqLiViXUTA/fAMmO4R830NHCzYAbu57HVXA=;
        h=From:To:Cc:Subject:Date:From;
        b=AuU4ynnnStqadUaXN9zHktRKYJfqFZauBtmPaTMnSe3bJHDC8TWgrBgTWQRbvR/Ka
         mRcQtf4gs2h76hMIroTt5zVGkFtwVLGJ3ewbbkPQBxv8W882/zNo8bzVG0xurOCSCD
         mG24ZDPeAssJonhlvIKe8FRyytOVIblGCUDY4sgdUJ+pNP3YAVxJurFF2K8aj5fCiT
         ygy/mB99fFIqgI+rh9I/2Fsxy834HitnrOkFAO+nOk/T+CCMkPLZCO/T2YyPDtCarG
         dzoe3h4f8wfwaGgh4csMD8EQx/caCOHVbTy/i82O5mK1anDv+DrJlyCi63w6BKudtv
         ExuZppoDS6qdA==
From:   guoren@kernel.org
To:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH V2 0/2] net: Fixup cpu_mask usage
Date:   Thu, 13 Oct 2022 23:04:57 -0400
Message-Id: <20221014030459.3272206-1-guoren@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

Yury Norov repaired cpumask_check() in [1], which eveals the
problem in other code. The series fixup them one by one clearly.

[1] https://lore.kernel.org/all/20220919210559.1509179-1-yury.norov@gmail.com/

Changes:
v2:
 - Fixup fixes tag in commit log with Yury Norov advice.

v1:
https://lore.kernel.org/all/20221013163857.3086718-1-guoren@kernel.org/
https://lore.kernel.org/all/20221013171434.3132854-1-guoren@kernel.org/

Guo Ren (2):
  net: Fixup netif_attrmask_next_and warning
  net: Fixup virtnet_set_affinity() cause cpumask warning

 drivers/net/virtio_net.c | 2 ++
 net/core/dev.c           | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.36.1

