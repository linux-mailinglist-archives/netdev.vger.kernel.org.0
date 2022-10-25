Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EA160CAD8
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiJYLYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiJYLYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A92D4A0E
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:34 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so1072044pjh.1
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCtJZofqFuIfF1VOi/XOksVIA25s6D4licbpL6U4rso=;
        b=N+uLJz9C44R+8IAnYCbLfDSHsSS/8I20/7y9p5GFKcsU36PE+5qs//YS56XP7C19UM
         /BSvKOpYuvM3GKN9Jr9rIk+bUCgMhYkZnbn3mHknBArG4PQptSSZLj7s3MxUcQTK6hCy
         L4YikweLZax2sy3IXOAIDS0wuSIBYyqLHp3Omd15jR6VVTx/S7/t8K/ylUE6OReXw3/G
         RG9IpG1cwNL7NIbl2EXt35hA5QHYvWBm6OIX2FUe1FRy8X0U5+BTY/z/3D13k4cCdpfO
         xp2DasYykp0ZgjyVGDVJ+Pbmvw7XLhdDHCtom00NWFhCFtMKL4+TAdKnzJy0ScnO49Qa
         QNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCtJZofqFuIfF1VOi/XOksVIA25s6D4licbpL6U4rso=;
        b=MDrIfKUUTh3dYFFaSWEDMFdt+I/WQbhwiL8tOcDLYPHQnmEoAjpJbfYcbNTDTMy/8m
         gpX6bOOPFRuZfOo7jBjXUMd06mn9u7CEvun4PylgQLR4l/O9kPKqJXgli8FdUZRKrmfw
         vDHzi5ibDbpmqJ3/Q5x+Bhs8skqVA+7Egz9eOnV3XWIDhn9hqC7Wdd9Nk16cHwrByXki
         fcHEa/893Kn/0TL0MbUB0aPE+EqauG441PUDGgf2oP6hc30pudz5b0sy4MqiBzAMe4eR
         MzQMixkx2wnDe1wKVn3BpGVsWzKjMIubUqNMajwx8ya2iDXkZMktQuIdaMfdnQifuNgC
         2hWg==
X-Gm-Message-State: ACrzQf12xPNeFZ5iPwdPNVlqqvhJ0BAd7vdeOnGMVlSDSWA7J6wbGOx/
        gA/IYkIjYAWcaxt+hJ0PJHdmvw==
X-Google-Smtp-Source: AMsMyM5VynPBgNEw4R2ELNme20PKT8cQ9HDWZCieAuJlJTnqA13IOHGdrBZ8hc0x6DmfcrQFzS3DOw==
X-Received: by 2002:a17:90b:524f:b0:212:c22f:fbd1 with SMTP id sh15-20020a17090b524f00b00212c22ffbd1mr29612695pjb.155.1666697074141;
        Tue, 25 Oct 2022 04:24:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b00185507b5ef8sm1073425plp.50.2022.10.25.04.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/5] ionic: VF attr replay and other updates
Date:   Tue, 25 Oct 2022 04:24:21 -0700
Message-Id: <20221025112426.8954-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better VF management when a FW update restart or a FW crash recover is
detected, the PF now will replay any user specified VF attributes to be
sure the FW hasn't lost them in the restart.

Newer FW offers more packet processing offloads, so we now support them in
the driver.

A small refactor of the Rx buffer fill cleans a bit of code and will help
future work on buffer caching.

v2: simplify call to ionic_vf_start() by removing unnecessary vfid arg
    remove unnecessary function return casts
    remove unnecessary 0 in {} declaration initializer

Neel Patel (2):
  ionic: enable tunnel offloads
  ionic: refactor use of ionic_rx_fill()

Shannon Nelson (3):
  ionic: replay VF attributes after fw crash recovery
  ionic: only save the user set VF attributes
  ionic: new ionic device identity level and VF start control

 .../net/ethernet/pensando/ionic/ionic_dev.c   |  14 +++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  41 +++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 113 +++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_main.c  |   2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  31 +++--
 6 files changed, 173 insertions(+), 31 deletions(-)

-- 
2.17.1

