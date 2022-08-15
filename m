Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED7459342E
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiHORuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiHORuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:50:16 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814BA229;
        Mon, 15 Aug 2022 10:50:15 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id y18so6001939qtv.5;
        Mon, 15 Aug 2022 10:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ONThvnlkxbM/ymhTTwi5zkIaGgHs/98tFbziK+wjxkA=;
        b=NvX8RngB51plaSuMB7XTujmlUEQnhgdEu7tlexs6AJQ9GiXrHzm3em08+mFR7NfXE8
         gfnu/6F9PYhRBZONUKuMuRmjgN/AFG4+vohSZTCDqf6OfyXdoO/0jUfR0l+tdi+U/SQA
         lkX3Le0bk5S03itqmljmISuOgeeyxmrGizdSqWFghRV4PDhdEmgXgKPHQRkKiwiQ4yWZ
         eLxse4FnpKfvzUKdlLXmehIzwVuyUXHCLyX4kn2L7BxPCLxUfu6BrFhxHZB5JUAIElFU
         ervcKBG2HjctOWunYfMA83q9V63GphLwzQ4GPcCp2u9B6Ny/mWHzv18S4rX12dxhYaC+
         QK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ONThvnlkxbM/ymhTTwi5zkIaGgHs/98tFbziK+wjxkA=;
        b=Jf7vYgFFHKZ+3taGG5nlk0mXlD3oYsWp/jufK3NXcvEDo5rVFc5Ltfy7WIcaHtsdqv
         Z0qcCcYCZ0Akjwl6tB0yBaNOrVQmEM4KgclYokv0uVqRSHnoi/QQyaTIi5hMNBijLdUm
         IgMfRrtcAYXp1WzdyMekLj2R29+XSGpKt7NlqhGehMqccj3sPhjR383fM6fgLg+Igipm
         h2+hfVELyJF2+4XYA9HNc+nULX7yP2E9WuEWhoK9SaM3Gy9v0sxwUxx+FwFPkHPi74hj
         TZYad7xd32mP40CvvOtHaCH0Zgu7KfxCp8Tfrz3ohWMAUwgq5I7ut5Y2EdbSSBsIm4UJ
         Q/Vw==
X-Gm-Message-State: ACgBeo3LK981JyV8jbTTEv5bzf+pP2wDKJRVEeygjWS2vYk1n9wgu8ww
        wSHYuDObZkWQHginhvGnTIVegiIlLHs=
X-Google-Smtp-Source: AA6agR7I8SisvDoFLgW4g7IEccHvVHxcdanDBVWuasRqH9VUFmCvFW9bkHAa7BN43XsX5ovTI5Vqrw==
X-Received: by 2002:ac8:5983:0:b0:344:5dcb:3b6b with SMTP id e3-20020ac85983000000b003445dcb3b6bmr5308096qte.503.1660585814215;
        Mon, 15 Aug 2022 10:50:14 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ez12-20020a05622a4c8c00b00339163a06fcsm8741524qtb.6.2022.08.15.10.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:50:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all ports
Date:   Mon, 15 Aug 2022 10:50:07 -0700
Message-Id: <20220815175009.2681932-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Hi all,

This patch series has the bcm_sf2 driver utilize PHYLINK to configure
the CPU port link parameters to unify the configuration and pave the way
for DSA to utilize PHYLINK for all ports in the future.

Tested on BCM7445 and BCM7278

Florian Fainelli (2):
  net: dsa: bcm_sf2: Introduce helper for port override offset
  net: dsa: bcm_sf2: Have PHYLINK configure CPU/IMP port(s)

 drivers/net/dsa/bcm_sf2.c | 130 ++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 67 deletions(-)

-- 
2.25.1

