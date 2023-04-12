Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE36DE91E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDLBuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDLBuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:50:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B4525A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 18:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7906266D
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D0C4339B;
        Wed, 12 Apr 2023 01:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681264244;
        bh=+iIgFR3d9RQa6nPPh5Fd7jB7qhLeZjqP2PDvbhg1uEs=;
        h=From:To:Cc:Subject:Date:From;
        b=KOB0/0oBa1PuSLStM9JVqEzRtq5B6MuTTUikw0si6W4V1Nmqio1iG3nyqONVbnosB
         hWw9nstUu9X+OrWgwmETNnb6traNTPSzsRvqXNZlaxR2wGLL4PwISNbAh5ikhv9uLu
         RwcpbEI3naO9cq9XUPjcxADk0oUmsBfACffoOcoP0raFBQviDk57M5+aA8g9gXMK/H
         4vW7TOHbQ8SBUO4PfFO042dCD4s4p+CHpU2FIRwgT6tvYE9DFh1GIMTeE1Zp0LvXnH
         OTAVl7dmFeiKO+qnBE0b+rrT5JQJiTKPV01LT5pWlENCWWBuSCFZjK4LeRXboGsr5F
         gp/c6axXIaezw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/3] net: use READ_ONCE/WRITE_ONCE for ring index accesses
Date:   Tue, 11 Apr 2023 18:50:35 -0700
Message-Id: <20230412015038.674023-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
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

Small follow up to the lockless ring stop/start macros.
Update the doc and the drivers suggested by Eric:
https://lore.kernel.org/all/CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=2+aStsbbwpWzKHjk51g@mail.gmail.com/

v2:
 - convert xdp paths in bnxt as well
v1: https://lore.kernel.org/all/20230411013323.513688-1-kuba@kernel.org/

Jakub Kicinski (3):
  net: docs: update the sample code in driver.rst
  bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
  mlx4: use READ_ONCE/WRITE_ONCE for ring indexes

 Documentation/networking/driver.rst           | 61 ++++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  9 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    |  8 ++-
 5 files changed, 42 insertions(+), 48 deletions(-)

-- 
2.39.2

