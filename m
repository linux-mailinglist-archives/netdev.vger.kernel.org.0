Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1D503100
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348676AbiDOVIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346874AbiDOVHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:07:38 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564FB3C4A4;
        Fri, 15 Apr 2022 14:05:08 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so8988765fac.7;
        Fri, 15 Apr 2022 14:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=DFeHwl4kR/w9Nf006Bo+dIcrWUYjy2D9GswKriWjVME=;
        b=fPUNx3G1SpJx2MuqX7wgPfHiF6WcVq4YqREAqp5SfMCGctGw6vDNrk4nlSpL15iAGV
         qt9YGsjDDtSN/meYbCC/ysmw9SiEcnDckONqX/cGnoj3Plor14s6Egn+A3oOhHuf9b7X
         K0Gwpyv3McH3VHXVzx/x1u9SbtJvTgfH9JHml/7rYxXlfuho+Z3bHHXGEf+nlMhFjExa
         V5iCa8SlqCBYT3WKx2v7+gyFfakvkPzIfxmbdfze0VzezFIAuJBMoC87fNZ3pZVMDg7d
         zJL4y/hUkL8rGi7ABrLQk3VU6nKAFiwoh0GHuCxGn5eCQGehfA90akiumfUu6+7uhZeN
         AD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DFeHwl4kR/w9Nf006Bo+dIcrWUYjy2D9GswKriWjVME=;
        b=EdCoYy3Vz2g0RH2lZx9r5oShkCB7qGGVvVOCTg8h2jQqBI70GQqPhPBCzLxx2oQ+Np
         +ivQGJOvVWei9wKjs1rUoItMJ/IcXmJlfDx0LWpfFlvleYAW/gbkeH9rRFwK73zUHsmJ
         AIqrSB0SR0Pj7+3XUH9GwnR1FaLIdIMsnWmbLZYg1+7XCve5Cbth94/XFa/St4TwicBM
         wz3v6ZxRwrY4t6ws+ytvdVeU8OHiZZwdn3HnsyYwYFi0EvacVwFM8PkYlTVveSXkAyEj
         JA+E4Twzmz+2Fl5nWUPL8VdF3MCOrDVFPHvqtFGoHpYbWtfdtH9A7W7oXNTppnX1itde
         ZhUw==
X-Gm-Message-State: AOAM532qCZj/TAfCGNn7q1D1m/Z8Djc9R+s6nlgk96vS7ZeWi+phxdhj
        MlVUD1n31kgPYXCBM9pDoA4KFqd/byAAJN02
X-Google-Smtp-Source: ABdhPJwNGJEANI5cts9GYobmfi1XbWQKpS2jCDrzjflgzR1DOCL7uvUQ2Voorfi5bEeANWqkCWk7Zw==
X-Received: by 2002:a05:6870:4341:b0:d3:1412:8ecb with SMTP id x1-20020a056870434100b000d314128ecbmr315330oah.36.1650056706728;
        Fri, 15 Apr 2022 14:05:06 -0700 (PDT)
Received: from toe.qscaudio.com ([65.113.122.35])
        by smtp.gmail.com with ESMTPSA id bg37-20020a05680817a500b002fa739a0621sm1476525oib.16.2022.04.15.14.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:05:06 -0700 (PDT)
From:   Jeff Evanson <jeff.evanson@gmail.com>
X-Google-Original-From: Jeff Evanson <jeff.evanson@qsc.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     jeff.evanson@qsc.com, jeff.evanson@gmail.com
Subject: [PATCH 1/2] Fix race in igc_xdp_xmit_zc
Date:   Fri, 15 Apr 2022 15:04:21 -0600
Message-Id: <20220415210421.11217-1-jeff.evanson@qsc.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in igc_xdp_xmit_zc, initialize next_to_use while holding the netif_tx_lock
to prevent racing with other users of the tx ring

Signed-off-by: Jeff Evanson <jeff.evanson@qsc.com>
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

