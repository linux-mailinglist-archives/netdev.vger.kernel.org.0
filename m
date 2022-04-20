Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B40507E26
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348468AbiDTBae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDTBae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:30:34 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B350524969;
        Tue, 19 Apr 2022 18:27:49 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 12so459220oix.12;
        Tue, 19 Apr 2022 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6RZt3pRY2aKwzYWHycI06GL3k6VJx2KQpfieK912YU8=;
        b=B+cxRY9FhW3qdrJo5zcX6sM27c423HY/NsSxFAgyuclMXAJFwQK1KTll69IMEU19Su
         20uLodQmfsoLbbRgBO1oFs/wUrRP13lxDSZSt44zqP8G+DteCzjY0ybV5oJgRQL3bgaW
         oL6afyZgrOEIVVpilc7VdFeRUhRpflx2IH60v0ZaFqjpnzYT4zDNijDaJErUFQR3NdN3
         rSgBxlNvI0tjgjQb65SZ8gtcqqOyhcT7dUYuSC2fuR8ciQ33E+K2Lbkkd+1+Ew5YtMkM
         RIw5Z/8GN7/6BzNwJl+EVKneuM2X8FAhSR1jNV6DD1h4OMfBD8bg48zfUH9Vn6N3xFid
         hUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6RZt3pRY2aKwzYWHycI06GL3k6VJx2KQpfieK912YU8=;
        b=0Xdv3h6/I2JlQzxJvtEDT8nZ0lgU9D+SeiHW1hIXEl9e6gulDeG6ew+MgA1RThWvUr
         BDPB7w662WB1uWpbQKfz5xEG0Jq9Uv27btonTvf0GFuoEpXjQiKcex+ToMDOgKIp9GTY
         wTGPuaz9S+1drFyEbIFVu/TkQ0J/hMFZK/rr3u4pdfmDu3UU8vPbfWxN7WM6uUodSQHO
         5pFuUMhs1YHJ5ZzdihJzAFDyuO29oDMzd5lNlMYh+UObtbaljrSeHY8IQaxrfDZ5uF0u
         9efDr1kFh5DYWUV6gQpSzTg2P1VByCxOS0g1984Y6Df9FB2+4XSKaVKUKzMOnlAirOWd
         h4Dw==
X-Gm-Message-State: AOAM530gyR3gVIqQTVCrSX8iVTyydSn+dLtiCslZPegvrk7pxS6OeiqH
        k8AjWFFP3EXYx8rEMpZXzPWHvIrkttpmWgLi
X-Google-Smtp-Source: ABdhPJy65y7OiIVCslGTDjTngaUh+H8salM/co/xL+9jxZxE9vPUet2d6AEN2W7VgaiYwaDveYO/zw==
X-Received: by 2002:aca:d9c3:0:b0:2fa:6f51:7bfe with SMTP id q186-20020acad9c3000000b002fa6f517bfemr639590oig.59.1650418069051;
        Tue, 19 Apr 2022 18:27:49 -0700 (PDT)
Received: from toe.qscaudio.com ([65.113.122.35])
        by smtp.gmail.com with ESMTPSA id i26-20020a4a929a000000b0033a29c8d564sm4284530ooh.3.2022.04.19.18.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:27:48 -0700 (PDT)
From:   jeff.evanson@gmail.com
X-Google-Original-From: jeff.evanson@qsc.com
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Cc:     Jeff Evanson <jeff.evanson@qsc.com>
Subject: [PATCH v2 1/2] igc: Fix race in igc_xdp_xmit_zc
Date:   Tue, 19 Apr 2022 19:26:34 -0600
Message-Id: <20220420012635.13733-2-jeff.evanson@qsc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220420012635.13733-1-jeff.evanson@qsc.com>
References: <20220420012635.13733-1-jeff.evanson@qsc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Evanson <jeff.evanson@qsc.com>

In igc_xdp_xmit_zc, initialize next_to_use while holding the netif_tx_lock
to prevent racing with other users of the tx ring.

Fixes: 9acf59a752d4 (igc: Enable TX via AF_XDP zero-copy)
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1c00ee310c19..a36a18c84aeb 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2598,7 +2598,7 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 	struct netdev_queue *nq = txring_txq(ring);
 	union igc_adv_tx_desc *tx_desc = NULL;
 	int cpu = smp_processor_id();
-	u16 ntu = ring->next_to_use;
+	u16 ntu;
 	struct xdp_desc xdp_desc;
 	u16 budget;
 
@@ -2607,6 +2607,8 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 
 	__netif_tx_lock(nq, cpu);
 
+	ntu = ring->next_to_use;
+
 	budget = igc_desc_unused(ring);
 
 	while (xsk_tx_peek_desc(pool, &xdp_desc) && budget--) {
-- 
2.17.1

