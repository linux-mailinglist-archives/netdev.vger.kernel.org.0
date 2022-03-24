Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C274E6294
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349833AbiCXLkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349699AbiCXLk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:40:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958EC515B0
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:38:56 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d7so6214571wrb.7
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 04:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=bjI0cGhDGMIZKR+Hyo3RMWR53BAljyzuWzOAdVJru88=;
        b=nVD4w1tDBNZ7x32sGNWqQ/u/qUAkp8x3RGJbrR4dsAfonjXATGgH1b3T5GbS8Jpdrv
         bu+/K9+I5crzjocqfrSsruGpWKq3EoADRJny2+7NvDDiQdKozyYLQlA2i/8HYhKBWyXi
         8GI6iHqoyavP9jk4sGKBR+ZusEwxWAKCSh+GlaSRHcAQpiUZrlppEcsvhd3w2Lf22+uC
         JsuFdDU/BUy9XNCSkSmLecSVxVBBXNI/1FyWhlCUR0j6G/hG/dZGE8Ui1kRWeIh+Gz5W
         gimrwlJwCu+qUUG91ToXFOTU0e/fgD8/l9+TXBy4fI29EiowGG2p4yOWF46TSvUBHqZD
         y8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=bjI0cGhDGMIZKR+Hyo3RMWR53BAljyzuWzOAdVJru88=;
        b=e+RYoqq2Hu0ghPNPtw/oK/QmGgSPbj9YJrXyX83feNZ+YvfFgkIOY2v9fYNzZ+Vd6B
         9R8FAgxBs88Na1i+Y5Cou8wSiRBE+zPXd4fkIbs9EWKCVvLjI8g/rC1XpshSNydvEN0F
         2Ho4vBji9LUkgLcAa/LbdvQ547r2O405W+whVqoBd+6IN7Y3kuOim+bDgq6WRPR6TsPQ
         hULnLiAW2Hb6fCny/ihZ+HT6iFc574PIhIM45Gj7O/FNPBbdlGTbUeCOgcDp3zCYh1B8
         1FXIRj3B4JfBmM4d1NwF+sArmdKJt8pYKB+mToUkMvi7PmxaKgN/T3n4V6xFtzosseB9
         JLlw==
X-Gm-Message-State: AOAM533VfZc27GsOz1eT3BMyQgSqHXFAofws7mCa1a13Se+A5xV/Dnco
        UgS3ewKz47CnWbLSZ8rsCHy30qqXR6Y=
X-Google-Smtp-Source: ABdhPJxZJHMEjccNIXQ04o43ZHKbtb4cqZjU75To6gzyC//KaCD1uMC3zYdZQXYWb/QOxX/AFzOyxA==
X-Received: by 2002:a05:6000:1541:b0:204:18c9:7179 with SMTP id 1-20020a056000154100b0020418c97179mr4151645wry.581.1648121934917;
        Thu, 24 Mar 2022 04:38:54 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g1-20020a1c4e01000000b003899c8053e1sm2472498wmh.41.2022.03.24.04.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 04:38:54 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: sparx5: Refactor based on feedback on
Date:   Thu, 24 Mar 2022 12:38:51 +0100
Message-Id: <20220324113853.576803-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
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

This is a follow up to a previous patch that was merged
before manufacturer could give feedback. This addresses
the feedback. See link below for previous patch series.
https://lore.kernel.org/netdev/20220322081823.wqbx7vud4q7qtjuq@wse-c0155/T/#t

Casper Andersson (2):
  net: sparx5: Remove unused GLAG handling in PGID
  net: sparx5: Refactor mdb handling according to feedback

 .../microchip/sparx5/sparx5_mactable.c        | 19 ++++--------------
 .../ethernet/microchip/sparx5/sparx5_main.h   |  7 ++-----
 .../ethernet/microchip/sparx5/sparx5_pgid.c   | 20 +++----------------
 .../microchip/sparx5/sparx5_switchdev.c       | 18 ++++++++---------
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  7 +++++++
 5 files changed, 24 insertions(+), 47 deletions(-)

-- 
2.30.2

