Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D183DA9DD
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhG2RRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhG2RRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:17:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75FDC061765;
        Thu, 29 Jul 2021 10:17:48 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gn26so11974932ejc.3;
        Thu, 29 Jul 2021 10:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gq7rx9oAniujE018I/IJqmeyVCPCgAOiXAni59XWvAQ=;
        b=CQbu2i+pHNKR/gUNR3rRRvvTUhYuYkj2kAp4Wq5IWB3UY+rdGm9Hc2PPUQnjFaHspu
         LaUPDhIOzEYSHwSILsnqTeCM4AjNOKSp8/cE0zpHl6f1nt/zw4+/TduH4omBhzfLT2Ok
         Iw4GvSmYeeQ6WGrxjOTQ9RYdN7tvEU+uNRB245MO2M9giv1+Qg6Y1c+wu0BnLN6uWx0z
         QaVsqa9kVmcT25g0qhUFp1oW2keLv8pvVsS0dUy1Iab/YbsvhvlYmBYyBDhyVAj4RHhA
         DQfQdWgaCwrnSHKjOUa/IkJnz6HaxtouTvHXl4tYhrftObP6UvBlcJIyvTFeth+DaQBQ
         seSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gq7rx9oAniujE018I/IJqmeyVCPCgAOiXAni59XWvAQ=;
        b=Shp+Gc2UUMlRnyoskIC8meUJAEiE/SZv1mFjDIu5u2jotWk2dxzYTWZjgUMHS1N3sx
         QJKoNjRcGZTA8BKZl4IxoQEAzdUlVza3otx21YSINxXIaKD9xOxtQj7MVX8kO6FXyDHt
         kG9Oei9x4cxhEDCC3LOnTRkgdrZQdhvL859uBl1Akb0tBuqlWGr4ogGrrfuJwhrHhUnX
         OH9LkH8pOvVKUOGopypjvkHQeis1sivB0uejcl3jiH8zucMwgnMEob0uGN6ri7bwAC5p
         Ia06ON05zxyjOlgrl0oTnT7fGu4HrPVb7509jz4THxjzFnpfjTlnS4HUlEnQDm3efalp
         yjfA==
X-Gm-Message-State: AOAM530Z0PToElr7w/2iGDTOKeTXJDkSWwt1PImF5CDhlb81JeduyDeI
        kItIh5dsDZqEHoBfc6d0e5k=
X-Google-Smtp-Source: ABdhPJyeSUIpT7ufj1PQ6l/TmgDsukAcBv5GSKb4Ye2QI1/JmWsWyRzINVJfRKJxII77B0ZciKfOfA==
X-Received: by 2002:a17:906:6cb:: with SMTP id v11mr5606249ejb.482.1627579067437;
        Thu, 29 Jul 2021 10:17:47 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:46 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/9] dpaa2-switch: add mirroring support
Date:   Thu, 29 Jul 2021 20:18:52 +0300
Message-Id: <20210729171901.3211729-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set adds per port and per VLAN mirroring in dpaa2-switch.

The first 4 patches are just cosmetic changes. We renamed the
dpaa2_switch_acl_tbl structure into dpaa2_switch_filter_block so that we
can reuse it for filters that do not use the ACL table and reorganized
the addition of trap, redirect and drop filters into a separate
function. All this just to make for a more streamlined addition of the
support for mirroring.

The next 4 patches are actually adding the advertised support. Mirroring
rules can be added in shared blocks, the driver will replicate the same
configuration on all the switch ports part of the same block.

The last patch documents the feature, presents its behavior and
limitations and gives a couple of examples.

Ioana Ciornei (9):
  dpaa2-switch: rename dpaa2_switch_tc_parse_action to specify the ACL
  dpaa2-switch: rename dpaa2_switch_acl_tbl into filter_block
  dpaa2-switch: reorganize dpaa2_switch_cls_flower_replace
  dpaa2-switch: reorganize dpaa2_switch_cls_matchall_replace
  dpaa2-switch: add API for setting up mirroring
  dpaa2-switch: add support for port mirroring
  dpaa2-switch: add VLAN based mirroring
  dpaa2-switch: offload shared block mirror filters when binding to a
    port
  docs: networking: dpaa2: document mirroring support on the switch

 .../freescale/dpaa2/switch-driver.rst         |  43 ++
 .../freescale/dpaa2/dpaa2-switch-flower.c     | 530 +++++++++++++++---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 149 ++---
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  44 +-
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |  19 +
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   |  80 +++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |  31 +
 7 files changed, 747 insertions(+), 149 deletions(-)

-- 
2.31.1

