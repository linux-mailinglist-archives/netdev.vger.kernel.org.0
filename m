Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE780535B0E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349385AbiE0IGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 04:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349353AbiE0IFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 597D3102761
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 01:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653638744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/X8SgZNQ3cXN9FZsRJJsFZzgwIybQD1bPD9sTHjVW/U=;
        b=IOEYI0r4kaUq0a43nvKms9lco44QL745ayz8t5SpOJ3dgJQnnC4U3gXVjmgporGL1HWwnj
        X0a2sqKTeFLFi0suHezQnrB4D6zs/kYrmvULR5scLa//sloPO0wXMAF7dAIwdSMcUS4SR6
        iYp8kt8pk4iDhT02NWyqT6tPQQd5kik=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-AjuyIDhqMGucmisvC1KU8g-1; Fri, 27 May 2022 04:05:40 -0400
X-MC-Unique: AjuyIDhqMGucmisvC1KU8g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F537100BABB;
        Fri, 27 May 2022 08:05:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CA8C400F36;
        Fri, 27 May 2022 08:05:37 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net v2 0/2] sfc: fix some efx_separate_tx_channels errors
Date:   Fri, 27 May 2022 10:05:27 +0200
Message-Id: <20220527080529.24225-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v2:
* added Martin's patch instead of a previous mine. Mine one solved some
of the initialization errors, but Martin's solves them also in all 
possible cases.
* removed whitespaces cleanup, as requested by Jakub

Martin Habets (1):
  sfc: fix considering that all channels have TX queues

Íñigo Huguet (1):
  sfc: fix wrong tx channel offset with efx_separate_tx_channels

 drivers/net/ethernet/sfc/efx_channels.c | 6 ++----
 drivers/net/ethernet/sfc/net_driver.h   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

-- 
2.34.1

