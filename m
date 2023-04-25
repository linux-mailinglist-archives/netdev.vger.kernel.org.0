Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AA56EE31B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjDYNdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbjDYNdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:33:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CED81447D;
        Tue, 25 Apr 2023 06:32:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a52667955dso62215375ad.1;
        Tue, 25 Apr 2023 06:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682429545; x=1685021545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zoR9Fsg5/l55jSVRx/0sBDpYiurjfKjGs0R746XGrss=;
        b=kXt5WCixyHs0dA27Dj571bsgRBuMta+ASG3ujgVZJSSYsn4BaNggesTg8Tk4k5gTcF
         B7iGe1DmJbhpttWKFc+FYfduqZepDPnlcy1J0vXWI/tck2CpeOtntCV813xOUUfuHNAj
         i2nY4HSz8Yh2qzrdkAuQssbJZyJoU/xSt4dNCKfO+ATNqc2Islf7k5+4OTUq2A3BL5Cd
         /IahwY2/b0ZOUGBbZS7DAQyFgywc7eTdRr7NbyW4p0oHyx6nUYLhOqhnt8JAbplFBLNd
         y4TWpaVEr7laijMfsWl2YEg2OpfNBNDYOOVI0u0aM30zyf5sd72PLEfwr9tF1Tcx4RlQ
         NN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682429545; x=1685021545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zoR9Fsg5/l55jSVRx/0sBDpYiurjfKjGs0R746XGrss=;
        b=RzKQ8SIY5G6qdrLoYfe3OijMgTRTShIJw1b9uDCMdhMwlNzB8hYs92gqkoW6i4yvSy
         kAQvk5pFS1k6P/4w3GwS/inxQhXaWCEl7/D2WbJJ+VvWXtqMCD64lgEnpAjyx61nU8gm
         /73XTKEaAwWnrHVWXjiLCC9l17LSGnK8WVKiABs7Lv/hT5fv+wZmtHyStrJb3QhjHjE6
         FE0D8g6kTcp1XrQ4nUtSSxK2EL/ggVnpOXmH7Jy/Gu48747RuBW5+lL5OUR7XLdH75Ov
         EfJI08KZdhQmAWu1Ki4umYyCZR3iKPaAVQ+b4+vF24n80LJVYBIwuroJuM5P6fYBA8IP
         PXlA==
X-Gm-Message-State: AAQBX9cT5Kgpz06nk6cRdhhRK35xJLAcwODYRZ3JVfQmBMtOC0LPS9sI
        EAk5hmALCdzpLG17JeSO8hg=
X-Google-Smtp-Source: AKy350Yax63ftBOy0W9i4i88+XNO+vGEo98ZcqKaJChEW9UaR8fv92nRvpbjI8UCOJa7CImWKaaIYw==
X-Received: by 2002:a17:902:e808:b0:1a4:f7b1:12f1 with SMTP id u8-20020a170902e80800b001a4f7b112f1mr21441706plg.4.1682429544781;
        Tue, 25 Apr 2023 06:32:24 -0700 (PDT)
Received: from cosmo-ubuntu-2204.dhcpserver.bu9bmc.local (1-34-79-176.hinet-ip.hinet.net. [1.34.79.176])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902a70800b001a6756a36f6sm8254983plq.101.2023.04.25.06.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 06:32:24 -0700 (PDT)
From:   cchoux <chou.cosmo@gmail.com>
To:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cosmo.chou@quantatw.com, cchoux <chou.cosmo@gmail.com>
Subject: [PATCH] net/ncsi: clear Tx enable mode when handling a Config required AEN
Date:   Tue, 25 Apr 2023 21:30:14 +0800
Message-Id: <20230425133014.1203602-1-chou.cosmo@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear the channel Tx enable flag before reconfiguring the channel
when handling a Configuration Required AEN. To avoid misjudging that
the channel Tx has been enabled, which results in the Enable Channel
Network Tx command not being sent during channel reconfiguration.

Signed-off-by: cchoux <chou.cosmo@gmail.com>
---
 net/ncsi/ncsi-aen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
index b635c194f0a8..62fb1031763d 100644
--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -165,6 +165,7 @@ static int ncsi_aen_handler_cr(struct ncsi_dev_priv *ndp,
 	nc->state = NCSI_CHANNEL_INACTIVE;
 	list_add_tail_rcu(&nc->link, &ndp->channel_queue);
 	spin_unlock_irqrestore(&ndp->lock, flags);
+	nc->modes[NCSI_MODE_TX_ENABLE].enable = 0;
 
 	return ncsi_process_next_channel(ndp);
 }
-- 
2.34.1

