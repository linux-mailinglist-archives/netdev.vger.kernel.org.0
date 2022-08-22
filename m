Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E15A59C15E
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiHVOIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiHVOIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:08:05 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C272AE3E
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:04 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q18so9716528ljg.12
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 07:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc;
        bh=We+k7oFHlxeLGDBKPXOFjZcCzVfi5mmG+Eqa1yOk8Jc=;
        b=YYwQbm6Mh3qXAa5cswyCuBAr9HZnx1UhFyCpqCjiiiUN1BeS4FyPKFwiRLe7GGTOMh
         j2VrOdB8H0G6oF3vXs8RYqdbxPzCSYOQnXewdtzW4uZ1FcpFjbfxqq03VHwWz8i1ajLY
         3hxz9aniKNZgk/ylVaHJPHgWE1I/WSPlpT4BDtIgtnOi2qdvCH0Kvphs9yqmcieHuIEC
         KnNsCUyjdiZfRzF5UKmgsoD1Yz6F7OvHN0wwmtRZi/+RGDnPwW7CIN5m2P72JiAd62gQ
         C8kxzKie+qpnULtJ3jrCBL32kcOVwoYkBWFQySzQYNmgZ+p5Kb3+u4kcPtb63wD65qX3
         zmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=We+k7oFHlxeLGDBKPXOFjZcCzVfi5mmG+Eqa1yOk8Jc=;
        b=AiTvGPl6iVfpEhCX0yKsDS1kmkU/6NxeKT6dY2CrQVGIxieUdnQeR21/lG2htJHfhb
         eP7wbND8S6HE9FxaECTNJFzdv3MMNDN+cim+BL9TVOarsLcdGMbmkB1wZfFtbMxn1fxY
         td4T92nPiYMeHZfv50KXUbMgwYsb3is4ZhA9Gv6x3toS4zWeNTQob+cfsVDOepSPGCGs
         al7TzaiGX+SisWNPbpBmtRgYFKOpUt382r0OLEBIIUs9+WtE7gxWn9ID2w5cJ94Lotju
         +yPDS2fxBSyk+ILMH6YlQ29UNJGriqjAqZKoC+ZdeCefxWo7b4nXzCw7c16B/dNF7eyK
         nQrA==
X-Gm-Message-State: ACgBeo3DQYrxTJSatgAYk+F9C1w2zEVISKxTsJc3ryCATEI6FtTbGEMp
        IIvYdP4NT4rloQ1xz9fnBlE=
X-Google-Smtp-Source: AA6agR7Vkd52abiXPLFQWiSkbxQrn/AWC+wrpuEUwA8RAMLJjDjgsUgymRmCFeI7X7KSPvl4L6Xoog==
X-Received: by 2002:a2e:9819:0:b0:25f:dbcd:3ad5 with SMTP id a25-20020a2e9819000000b0025fdbcd3ad5mr5936393ljj.527.1661177282686;
        Mon, 22 Aug 2022 07:08:02 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id o14-20020a05651205ce00b0048bd7136ef3sm1934126lfo.221.2022.08.22.07.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 07:08:02 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/3] net: sparx5: add mrouter support
Date:   Mon, 22 Aug 2022 16:07:57 +0200
Message-Id: <20220822140800.2651029-1-casper.casan@gmail.com>
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

Here I keep track of if it is an mrouter port or not in the `struct
sparx5_port`. But I also considered keeping it as a bitmap in `struct
sparx5`. I'm not sure if either is better than the other.

Casper Andersson (3):
  ethernet: Add helpers to recognize addresses mapped to IP multicast
  net: sparx5: add list for mdb entries in driver
  net: sparx5: add support for mrouter ports

 .../ethernet/microchip/sparx5/sparx5_main.c   |   4 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  15 +
 .../microchip/sparx5/sparx5_switchdev.c       | 269 ++++++++++++------
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |   7 +
 include/linux/etherdevice.h                   |  22 ++
 5 files changed, 230 insertions(+), 87 deletions(-)

-- 
2.34.1

