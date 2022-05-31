Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7805391F4
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbiEaNnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiEaNnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C11EB4A3FD
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 06:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654004445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eZX4OsUQGgF4+aedHkG8t5BiTDq0ZyFJTcnmJmfBiKU=;
        b=Sp7qMrdOHeMQwqZXw1i+Wfy86VCN+BXb81rYeaWmRCIJfysNIuPHJ9lJx3zcgpqWL36ngi
        oc0qfMKP+gCXGlVrgZeFvPto5JapWLfES9bAWTqDYeQHAHRTGFQ4D6zY4KClZOvQq/lx/p
        8gcmhxgGF0yKOHIv9qT5dw6c1CbkhZA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-2s0bSOdBMlS0rZScgyyzrg-1; Tue, 31 May 2022 09:40:40 -0400
X-MC-Unique: 2s0bSOdBMlS0rZScgyyzrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 156D41C00ACC;
        Tue, 31 May 2022 13:40:40 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.195.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A59E40885A1;
        Tue, 31 May 2022 13:40:37 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net 0/2] sfc/siena: fix some efx_separate_tx_channels errors
Date:   Tue, 31 May 2022 15:40:32 +0200
Message-Id: <20220531134034.389792-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trying to load sfc driver with modparam efx_separate_tx_channels=1
resulted in errors during initialization and not being able to use the
NIC. This patches fix a few bugs and make it work again.

This has been already done in sfc, do it also in sfc_siena.

Martin Habets (1):
  sfc/siena: fix considering that all channels have TX queues

Íñigo Huguet (1):
  sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels

 drivers/net/ethernet/sfc/siena/efx_channels.c | 6 ++----
 drivers/net/ethernet/sfc/siena/net_driver.h   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

-- 
2.34.1

