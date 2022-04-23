Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811FF50CDFB
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 00:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiDWW5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 18:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiDWW5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 18:57:12 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3071D25C46
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:54:14 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s21so1149405wrb.8
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lsxcLOYzKVKTYOHKhWTEV/L0JYslhWQXECLP3cG1LVM=;
        b=SlOPtPTZdHl4BunIO6N+vKlt4psK7SQUs30aoA8izNAd/WIyRFdwwSjx88inK1FPkb
         QkOJWJaLqeSZiJtaqjLT5pUc16Z1OgW1IovxnUF5iY3eOl61NCoT+LhkoNUY6sAqUU5L
         hmeIB98V3bYxz4q2R7eM28+1L79W4XoqHNvHW0rP1Fw56KM/LPdwgPu99KisYTRGMVva
         suLoAwQe/f5gLZv2gijbXciBq0JXobX8RhPFO/WOWB6p452CMlVc17GyiNbMJcwRnQx+
         LTVbg+Ci/bFut/GNTvRNgupLG2og+aG0W4VTqJVcZNGgHgG5HHIQI3pIoavrpkac8XM6
         g9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lsxcLOYzKVKTYOHKhWTEV/L0JYslhWQXECLP3cG1LVM=;
        b=wCMH4bl+F0YZy31b7/Bb85vJJW7G9BdAz7HEw4zx0ERvJbbCGN/PZUzAlMVjadte0W
         SlGmonXqVK4PTttjooLBwhOyx/JHJ09X82SXldU06MyXPgjMsCQl/IFMYRsp4qoIelea
         aaXnrxkUqXfqtlW0K4I1CcCvWgmD3OOJpwCFQn7u8k7wBVKgeo9TwXBet1qq+czJKkNQ
         14hYUQfqk+7iDbwm+Eztg8vBAaW4YDuXEdtf9dFosbZRZpVqc7nNyoJP4Xcf3dzr3YqG
         6X7sH5hjOqjGrU5lLuT75arNp/Bt0amE+Oj8aQuKwslHLM2fqAvH4z3Ivp5rsESlHJhL
         1++w==
X-Gm-Message-State: AOAM533EUQHDLk+0d8bvhVf2FKGXsKI/Fq1+VMiA8uYsjQUh4wbXHqRv
        QyNJeKaWKnCnCQbj2cCmy9k=
X-Google-Smtp-Source: ABdhPJwX4bgnEogNLscDILHqfouZnPr8K/HK/CFgY4gLGfh22G3JDbJz2rGKLJzGvrJz9lxz88/7Kw==
X-Received: by 2002:a5d:5847:0:b0:20a:ae08:8d42 with SMTP id i7-20020a5d5847000000b0020aae088d42mr8452742wrf.650.1650754452180;
        Sat, 23 Apr 2022 15:54:12 -0700 (PDT)
Received: from alaa-emad ([197.57.78.84])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600c1d1000b00393e7e6ad58sm927270wms.26.2022.04.23.15.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 15:54:11 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        roopa.prabhu@gmail.com, jdenham@redhat.com, sbrivio@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2 0/2] propagate extack to vxlan_fdb_delete
Date:   Sun, 24 Apr 2022 00:54:06 +0200
Message-Id: <cover.1650754228.git.eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.36.0
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

In order to propagate extack to vxlan_fdb_delete and vxlan_fdb_parse,
add extack to .ndo_fdb_del and edit all fdb del handelers

Alaa Mohamed (2):
  rtnetlink: add extack support in fdb del handlers
  net: vxlan: vxlan_core.c: Add extack support to vxlan_fdb_delete

 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/vxlan/vxlan_core.c                | 38 +++++++++++++------
 include/linux/netdevice.h                     |  2 +-
 net/bridge/br_fdb.c                           |  2 +-
 net/bridge/br_private.h                       |  2 +-
 net/core/rtnetlink.c                          |  4 +-
 9 files changed, 36 insertions(+), 23 deletions(-)

-- 
2.36.0

