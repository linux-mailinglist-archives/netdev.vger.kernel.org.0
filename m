Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9720B5BC2FD
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 08:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiISGlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 02:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiISGlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 02:41:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8E41CFC3;
        Sun, 18 Sep 2022 23:41:02 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fs14so26816657pjb.5;
        Sun, 18 Sep 2022 23:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jVyaKQYqRiMdpo0by7J+8aIudozzoWR6OVary4Nq6gM=;
        b=MpQtIZrDlHwHhrVaQURvkIMjJ8DJP/VpPEKsLacRyKC5Nh8ZPXaVsbtej+9XWTSHcD
         1osEcmgNn6b+SHZbLszupyUhtgbGv0ZmVCg9Od0HyJkFBoSsTg408mNXH4xERo2kFO95
         G3XZKMvYqVAh01Q1mHbf8mUe+iYNoedRSuBBwrk5sZo4AYAf+7TIiixBZlLG+E1qpaDz
         OWt8qdv1lM1AsO5tMHrAiiISafQO2q+0NZMb1cpR2HBicpSf2CVMF5Ea0plVS/4RXYdm
         iPdzqPHnGxGdL2szt+GnsYzRlteTFMVHL9UaZVZ8XwVQS174fpa6rmvAPRgfG1y5pg2E
         trgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jVyaKQYqRiMdpo0by7J+8aIudozzoWR6OVary4Nq6gM=;
        b=yzBkbV4p4+/FiyDxfGhi6cCyt5PhtS9ceCN38DU5TQyXYraOwfR9dkHQH5mdLHkeaJ
         aOX6FWIiFQ5zxZhxL5avi9WVLNj4fkrBF1TpiOMVBci8HRzVhnUAxK13GrkwvVDLfLns
         sPUX3h5sBpJ6ryZxufd4SwSBq7b3jQFqfsi5IU2w/qoZMrkJGypZgcwL51kanIkha14W
         qXyM1r1Nxo7GGMdHsYMHKURaA0WL0pZc/ffE5+Tzq4wbpCG2MnZPjqorx/fhXh8ieKpD
         ej7STsr5eeJHYkYwIU48mwO9+RBwgxBrBHoV0mljuJNm9Eh4jtI1qhMvXD50bbXzoTra
         Mj8g==
X-Gm-Message-State: ACrzQf2xcEjFfO/62zc+hnd712Og/EWNRpe5PxEgbk8CgEiYRZGOY23N
        uyAXkssfRncvzXF+9LHia8s=
X-Google-Smtp-Source: AMsMyM558OGJMblGwwVwVa7PcT0JYAMJabOFgMjtzZ2o85XUdnKtYNa5zZ6eujAPuxaHHA8Dbt4epQ==
X-Received: by 2002:a17:902:b209:b0:178:a537:4f13 with SMTP id t9-20020a170902b20900b00178a5374f13mr1785816plr.138.1663569661847;
        Sun, 18 Sep 2022 23:41:01 -0700 (PDT)
Received: from MacBook.stealien.com ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902a3c700b0016f1319d2a7sm19434623plb.297.2022.09.18.23.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 23:41:01 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
To:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] iwlwifi: api: delete repeated words
Date:   Mon, 19 Sep 2022 15:40:54 +0900
Message-Id: <20220919064055.17895-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.34.1
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

- Delete the repeated word 'the' in the comment.

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index ecc6706f66ed..194de9545989 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -200,7 +200,7 @@ enum iwl_tx_offload_assist_bz {
  *	cleared. Combination of RATE_MCS_*
  * @sta_id: index of destination station in FW station table
  * @sec_ctl: security control, TX_CMD_SEC_*
- * @initial_rate_index: index into the the rate table for initial TX attempt.
+ * @initial_rate_index: index into the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @reserved2: reserved
  * @key: security key
@@ -858,7 +858,7 @@ struct iwl_extended_beacon_notif {
 
 /**
  * enum iwl_dump_control - dump (flush) control flags
- * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
+ * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the FIFO is empty
  *	and the TFD queues are empty.
  */
 enum iwl_dump_control {
-- 
2.34.1

