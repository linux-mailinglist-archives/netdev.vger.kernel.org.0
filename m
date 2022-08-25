Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38785A0C9D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiHYJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 05:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiHYJ2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 05:28:45 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C784AA354
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:28:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bq23so18384674lfb.7
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc;
        bh=TIA3eyyf0aRzewLsj3cyDokUjlVpxj3bvPMqPAz8VBQ=;
        b=W7PZsSGwbKnCdXcHI3aNYbIxpAaq3nZyvCKK2Z8KQasBL4fUzDB/TNOI0e6f9End7D
         SiQ9kj6zpK6Tjg1CDaLCoEAc0thafgFnYFPI4k5DjtlhrHky3DQhT4vctM4rzL4bIRqz
         v3X43g49W3fw+JRsOz91UuZKJEk9MXNT5cRKFpQ+PXdyzWzAIRmNY46PHtcOTs7Fx31x
         uoCbdrEW0m31085ppuWVlRDvaoANCFx6jnc6MZRAVK/gcMSuhfg1EJjwcXfwq/aKbjRh
         VMNIt62y3CzPvJuBxYYKoTQCHWaXF/PL2cXuK+/Ce4rE0fRLiLcGzTemmDC6U5Lw8I/0
         6fLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=TIA3eyyf0aRzewLsj3cyDokUjlVpxj3bvPMqPAz8VBQ=;
        b=BzNt/KV1bu5A3yoOPl/dTz4sbYRBK1ZswYYeIjgR+/mDPzWxIlRr+ngSrvg4eGOom3
         5z5kik+sj/8bPe36hk3rwzMp8Ga3JQvsqIcyzMc7KUw6ofLAZQNrXfgQJfcQMPVFaz5J
         QeLSBFk4bC+HiheBTU9lr2rf0Q0c8hZ5Gj7/+qHZ5AuW7RCW60w2waJzTJ6s+YyvFpXu
         Xfl8+U/ZH1alSJSYkC6EW7I8L65wNjttF0kEhPAJd5Tp9tQUpEInhOFpdhjGWna7IYX6
         RanUbAvD37uv1LQRVcbS5NLbAK2mlowchsYRbn64RQOk6IWJFJupN9s1klO7skeyaYKE
         vAhQ==
X-Gm-Message-State: ACgBeo0wzOfY2GvECXMAtWMs0i4eRWAaFAwde2KChJFqZEtYgP3i3LE5
        vraGsZ/qE0LYR+c3SJ686C4=
X-Google-Smtp-Source: AA6agR73M9lLld72PDelhHkx/iP1ZRPgssV5SjSMQ08dS016q0rlMKjmDAXOw12cA5I2+KsGWeK4og==
X-Received: by 2002:a05:6512:2828:b0:492:f6b8:75f7 with SMTP id cf40-20020a056512282800b00492f6b875f7mr954338lfb.79.1661419719438;
        Thu, 25 Aug 2022 02:28:39 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g16-20020a19e050000000b00492c4d2fcbfsm398988lfj.115.2022.08.25.02.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 02:28:38 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/3] net: sparx5: add mrouter support
Date:   Thu, 25 Aug 2022 11:28:34 +0200
Message-Id: <20220825092837.907135-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

This series adds support for multicast router ports to SparX5. To manage
mrouter ports the driver must keep track of mdb entries. When adding an
mrouter port the driver has to iterate over all mdb entries and modify
them accordingly.

v2:
- add bailout in free_mdb
- re-arrange mdb struct to avoid holes
- change devm_kzalloc -> kzalloc
- change GFP_ATOMIC -> GFP_KERNEL
- fix spelling

Casper Andersson (3):
  ethernet: Add helpers to recognize addresses mapped to IP multicast
  net: sparx5: add list for mdb entries in driver
  net: sparx5: add support for mrouter ports

 .../ethernet/microchip/sparx5/sparx5_main.c   |   4 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  15 +
 .../microchip/sparx5/sparx5_switchdev.c       | 271 ++++++++++++------
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |   7 +
 include/linux/etherdevice.h                   |  22 ++
 5 files changed, 232 insertions(+), 87 deletions(-)

-- 
2.34.1

