Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEED4FE71B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358160AbiDLRfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358139AbiDLRfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:35:34 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137315BE77
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p15so38725065ejc.7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w97rX506l0IZkP+JZIYJlQ8t2kG9o3WJCY91DufueFk=;
        b=ORC1aokz3Akmjy39tO0RY2jzikbJzlVNlrJZb+6WACySbrtF6E+MNNtD7yGr1ALcME
         99TOioRefbrdi/g42nB6ZY9BxJZ7iNwer55DdjXCqeZr3gAihwdN9Z0rrqkAAAUgXdjJ
         QjE+mE4/eal7w8QmOY38mR4NOTj4YYlOOiON0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w97rX506l0IZkP+JZIYJlQ8t2kG9o3WJCY91DufueFk=;
        b=giuiESSndhBxtFHZ0jI9rM8N64oYOe+INr3nVGr5KbwPOK/Odr097+TpGOG8Rr35bq
         3MXL1RAQvnF874+kGkgdnc5fLtyB0yHfTK7bLlsXeR08JhsJ2EN5ljjUQnkDuruvxpvi
         IvwqJVyb6O8J6vZC2DLpG8qazodozrVarSaydsL6bH1u2IZ/FlihwRL543sgpudLrQ8C
         wGX+EjwPP47kcJk7qHnzGnWXS+AGXEMLA2thOQbPOq1wbO1IdZmVrx5K918m1WTdwwDb
         M0mzI6VVrBwEnCv+pr6WJTd+ynIVCFSNnZJ9CRsWotu05jvL8Lv7dMyzru5HuPRkQXTd
         4taA==
X-Gm-Message-State: AOAM533TTAVeMtPGNQF3hYx+iVMigibSLd9eEYzHzmalbQE7bhHBJS1q
        MYRgMsIynf08JVyAtlYlbZj14Q==
X-Google-Smtp-Source: ABdhPJy/Ds7apVGrE02M2cDXTimaPZi1syJE7lufyddpu55XI0GsM3dEf3LKDwyhS3Hs95uW5/m86A==
X-Received: by 2002:a17:906:7316:b0:6d7:16be:b584 with SMTP id di22-20020a170906731600b006d716beb584mr34948158ejc.759.1649784793578;
        Tue, 12 Apr 2022 10:33:13 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7dd43000000b00419db53ae65sm56142edw.7.2022.04.12.10.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:33:12 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable 5.16+ 0/3] backported Realtek DSA driver fixes for 5.16 and 5.17
Date:   Tue, 12 Apr 2022 19:32:49 +0200
Message-Id: <20220412173253.2247196-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

These fixes can be applied to both 5.16 and 5.17 - the subtree of
drivers/net/dsa/realtek is identical save for a few unrelated places.

The main backporting effort was to remove some parts of the patches
which touched the newly introduced MDIO interface, which was introduced
in the 5.18 development cycle, and to work around a mass-rename of a
single variable (smi -> priv). Regrettably this rename will make future
stable backports equally tedious and hard to automate.

Please let me know if you would like me to send the series again for
5.17.

Thanks!


Alvin Šipraga (3):
  net: dsa: realtek: allow subdrivers to externally lock regmap
  net: dsa: realtek: rtl8365mb: serialize indirect PHY register access
  net: dsa: realtek: make interface drivers depend on OF

 drivers/net/dsa/realtek/Kconfig            |  1 +
 drivers/net/dsa/realtek/realtek-smi-core.c | 48 +++++++++++++++++--
 drivers/net/dsa/realtek/realtek-smi-core.h |  2 +
 drivers/net/dsa/realtek/rtl8365mb.c        | 54 +++++++++++++---------
 4 files changed, 81 insertions(+), 24 deletions(-)

-- 
2.35.1

