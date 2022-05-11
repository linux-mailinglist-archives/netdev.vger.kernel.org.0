Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA41D5230BF
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbiEKKgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiEKKgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:36:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58FFE2DD52
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652265373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5bGIB2oPiOZhgc9ueu5LeAKKswiPXglSUm5XgHGWVds=;
        b=ETDKX9GpNcKCFam4uvs8X1yfkzhzoJNMC5Qw1tejf9BNwuU8Le1zfrZ2u9rQP/9ypuPZfr
        4HnQw9HCgvkfG39+i1c+56GIqwXiTdATjnv6IcbYQgTpkesV8CMxjwDCPuMw+eJwIQxz1X
        ohS7+Piq5xN33wlZDIQHgiwWXKRdt/0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-h2EHwv7dPryRiww0b7Ca0w-1; Wed, 11 May 2022 06:36:11 -0400
X-MC-Unique: h2EHwv7dPryRiww0b7Ca0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D45CF101A52C;
        Wed, 11 May 2022 10:36:09 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08F56400E115;
        Wed, 11 May 2022 10:36:07 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        bhutchings@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 0/2] sfc: fix mtd memleak and simplify list handling
Date:   Wed, 11 May 2022 12:36:02 +0200
Message-Id: <20220511103604.37962-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches fix a memleak described in the first one and simplify
the mtd list handling to make more clear how it works and avoid similar
problems in the future.

Íñigo Huguet (2):
  sfc: fix memory leak on mtd_probe
  sfc: simplify mtd partitions list handling

 drivers/net/ethernet/sfc/ef10.c        | 17 +++++++++--
 drivers/net/ethernet/sfc/efx.h         |  4 +--
 drivers/net/ethernet/sfc/efx_common.c  |  3 --
 drivers/net/ethernet/sfc/mtd.c         | 42 ++++++++++----------------
 drivers/net/ethernet/sfc/net_driver.h  |  9 ++++--
 drivers/net/ethernet/sfc/siena/siena.c |  5 +++
 6 files changed, 43 insertions(+), 37 deletions(-)

-- 
2.34.1

