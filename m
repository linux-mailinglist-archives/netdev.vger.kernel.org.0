Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85ED68AA35
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjBDNfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDNfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:35:44 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D081A5;
        Sat,  4 Feb 2023 05:35:43 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id h15so521452plk.12;
        Sat, 04 Feb 2023 05:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JESTXBXpvE2dnrDBgzuJeMZn7XvTRpG9gQzTmSpRBHs=;
        b=KcGjfh7vdYjSnpRH0dqpbF0f0a6GacpSypj/xI83J3TqG+DbFLN4gy6m0aHeVgYGZJ
         7bKvEALX1C+wqAPc1UV9d+NZz8+mPEsae1BF0eBNGMJtq4amTLaAfa5epu7VrbGQBIDO
         jzsT+o6+6tCoXgZep8nk9uGDauKtB/zvTMYDjR6Rh6hcrGnU3iWZ/ZJOgIcELJiJQvF2
         u1rh/OkeC8vux+RfIAVqBroO44CB7z45wPa/NylgNMDK9miIvdokDDzCPpDQ7wd/Xwlk
         Q7HTkpRXOkVcyGY86u2AOE6nEkmoTW1pIWJ9rGZMjs4hYn9r0HweTkxdZhYDcolZnPoL
         I/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JESTXBXpvE2dnrDBgzuJeMZn7XvTRpG9gQzTmSpRBHs=;
        b=u+h9zrEgXhrp2jBoAGZM3K+Buzy7Krw8/Q1zOL0AKRwuU4dORez/Z1aArc7uYPcDdz
         tQrKurmGulqF3w39zcl4UFekFXJOyrBYGKUceuAqAqEa/ucih00cRmUJgl6qmtgu5Wyx
         jrEGicTIuOsBzSGXJPzLqrbTHyk/jnbBKWmGZAKnu79jh8rM5aI1ATvUXN3e/3nX/cta
         oaEBULjAvOzRlipps2CoGGijJ+p3Uiv3G0lpIro58InXurTpXI2s2ydr2jnmORPSFsSK
         Jn+BDtf/e6lXpssbHrQ33+R3ZUJNUh9SWMMxloB0CCp1MLO+37G5vP744wTuYzxQYTuW
         XkBg==
X-Gm-Message-State: AO0yUKUtMshgBiHA2a5hOBD8iUVoKhMVaDVs9JKmZvQ0VJk7T0WUnm9m
        n8vIFkTvy7VH/lfDWnDX5iA=
X-Google-Smtp-Source: AK7set9xruy2VOYusg3UI6hKD/B5ieAba9v9cPg4ywRWHDVdsQpwQwcaSV7JzYJJjOHZzdJEF25vEw==
X-Received: by 2002:a17:903:3293:b0:196:7906:b4e with SMTP id jh19-20020a170903329300b0019679060b4emr12562223plb.19.1675517743350;
        Sat, 04 Feb 2023 05:35:43 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c25500b0019605a51d50sm3463575plg.61.2023.02.04.05.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 05:35:42 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net 0/3] Fix MTU related issues 
Date:   Sat,  4 Feb 2023 21:35:32 +0800
Message-Id: <20230204133535.99921-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

From: Jason Xing <kernelxing@tencent.com>

As suggested by Alexander Lobakin before, I follows the behavior when
computing MTU size as other drivers do. Adding a second VLAN HLEN could
solve the issue. I have some i40e and ixgbe drivers running on the servers,
so I choose to fix both of them.

Besides, I resent the first patch because the third patch is wrote based
on the first patch. It's relatively for maintainers to handle the
patchset, I think.

Jason Xing (3):
  ixgbe: allow to increase MTU to 3K with XDP enabled
  i40e: add double of VLAN header when computing the max MTU
  ixgbe: add double of VLAN header when computing the max MTU

 drivers/net/ethernet/intel/i40e/i40e.h        |  2 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 28 +++++++++++--------
 4 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.37.3

