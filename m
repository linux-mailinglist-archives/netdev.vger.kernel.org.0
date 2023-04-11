Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F06DCF5E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 03:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjDKBdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 21:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDKBdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 21:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C941723
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 18:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C01561962
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C132EC433D2;
        Tue, 11 Apr 2023 01:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681176809;
        bh=Pw9KzPYm80cQryhAWPkAO8j4D1S30wqD7hyjd5fmDag=;
        h=From:To:Cc:Subject:Date:From;
        b=hJDPC0YCf7PRx/dcmCpY142APTbq2mnLsLL7ARrgBvdWJGISn1mb5HzuR3pmIXYcE
         VM/AaXCdCxcrCtFTkDpyD0dmGzI0gwEMoE6OMfX8SBNfQTII6w56mTC+YXmq2vgvUc
         bNKk5/zENJP/GBZkDlMz2bDVwAKpwgC4QR6X+zT+zOVe3ACRwjVzGZqkSfMBW4SHdk
         VcisZ5a1Lp7AUT89yaQs/3wLjstupLEgSOMjvPIzJG5gl/seh1xxNYPSf/pvVw9paP
         hRcgDsOHewcwgNKJLXIZaCdj7DFrI5Wxw0Nme+pU++gPMPTd0ST+LoY0JmSf1Eo3dP
         ep4O5M3gw/Qlg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: use READ_ONCE/WRITE_ONCE for ring index accesses
Date:   Mon, 10 Apr 2023 18:33:20 -0700
Message-Id: <20230411013323.513688-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small follow up to the lockless ring stop/start macros.
Update the doc and the drivers suggested by Eric:
https://lore.kernel.org/all/CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=2+aStsbbwpWzKHjk51g@mail.gmail.com/

Jakub Kicinski (3):
  net: docs: update the sample code in driver.rst
  bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
  mlx4: use READ_ONCE/WRITE_ONCE for ring indexes

 Documentation/networking/driver.rst        | 61 ++++++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c  |  6 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h  |  9 ++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |  8 +--
 4 files changed, 39 insertions(+), 45 deletions(-)

-- 
2.39.2

