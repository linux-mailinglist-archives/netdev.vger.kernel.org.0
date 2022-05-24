Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E09532308
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiEXGXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiEXGXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:23:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38E8E6C544
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653373380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/+NSlpKCA7c0tgBAso38+DiKhAtq4AHwR7XB9Z9q82Q=;
        b=YSPjqLbCfNH0EbFaUmwAPsFj/FdLp+Y4ZTe5Y46C1yXxz55IGuP3RUM3RcolDIg3+jjM/i
        UNhRXGzLFh4QoRBZIKGyEkhedHQs5yTvXhH0WByl7nvY8ld7Q0m2AsZ7KbQs+RNMmCAlOc
        TrmhCEqwsBWMDcaXJU+d/AP5cZXfkvE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-kbt6zjIAMmmJbfmSafBZ7A-1; Tue, 24 May 2022 02:22:55 -0400
X-MC-Unique: kbt6zjIAMmmJbfmSafBZ7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36E1418A6581;
        Tue, 24 May 2022 06:22:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE3A6C27E8A;
        Tue, 24 May 2022 06:22:53 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next v2 0/2] sfc: simplify mtd partitions list handling
Date:   Tue, 24 May 2022 08:22:41 +0200
Message-Id: <20220524062243.9206-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the mtd list handling to make more clear how it works and avoid
potential future problems.

Tested: module load and unload in a system with Siena and EF10 cards
installed, both modules sfc and sfc_siena.

v2:
* Dropped patch fixing memory leak, already fixed in net
* Apply changes also in new siena driver

Íñigo Huguet (2):
  sfc: simplify mtd partitions list handling
  sfc/siena: simplify mtd partitions list handling

 drivers/net/ethernet/sfc/ef10.c             | 12 ++++--
 drivers/net/ethernet/sfc/efx.h              |  4 +-
 drivers/net/ethernet/sfc/efx_common.c       |  3 --
 drivers/net/ethernet/sfc/mtd.c              | 42 ++++++++-------------
 drivers/net/ethernet/sfc/net_driver.h       |  9 +++--
 drivers/net/ethernet/sfc/siena/efx.h        |  4 +-
 drivers/net/ethernet/sfc/siena/efx_common.c |  3 --
 drivers/net/ethernet/sfc/siena/mtd.c        | 42 ++++++++-------------
 drivers/net/ethernet/sfc/siena/net_driver.h |  9 +++--
 drivers/net/ethernet/sfc/siena/siena.c      | 12 ++++--
 10 files changed, 66 insertions(+), 74 deletions(-)

-- 
2.34.1

