Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97567178BEF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgCDHu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:50:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40142 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgCDHu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:50:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id l184so543174pfl.7
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 23:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mFqHUntBoV4lXEyrsttan0SPpITp8nHSMf6K2JVaGqY=;
        b=kKuOdRT6KZepGfvNzpBWxTHaiDzalMtjvEQzYdxRP03B1GAhWdvZ6F13FtvRX2YRo1
         +t33E7xJbTValeQxLBnY6bzgdhl6R3VEqYDlN0Vop3VzvlAP7f1eOpUQ9ADDF7AONUWR
         GvoiF7G+aAL5MPfwDXKkyObt2YN1gsnXSAVhAaUqCsAqecE9eCXfPnoKgsOG6YW6YTbH
         gFOicWIx+H8ili3Rbb7rQDZ6lCd+PXm7I0s/M7R9IavKfB7YMcSw3M1HePpM1cOSO/f/
         WwFkDJfLc030mYi2Djh3XuHsCJLSkmyXG+NWpCIXXUZF/wdcIsThkWW5QKDeBXF6ErIs
         o+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mFqHUntBoV4lXEyrsttan0SPpITp8nHSMf6K2JVaGqY=;
        b=iq4LbcSLwzqlxH+cmqZN0eCSKn0EBveBC7g8OEQTMAYUonvWbzuGNAbF5HbtHhz9pH
         yXvUnooZlCPI7CZT9QQeBUc3s1Eg91CJehPewV8nMCm2PFq/diubT/P/tBBlIcKWuY4j
         vlVnKCGBm0K+SjZgjiX147lF43ZGSGmPXW9kM2cGzflxyo/DRhhV8i+ccWnJs0n5ouTH
         JwO34X7duRWMmWGLPbC/TQXAo9BGha9lLUYAnOqJ/hQylWR01ptab80snc+Jd9qVRV8z
         oZegnHMU+sh2WSPDw01KO71q+sEDKkNtHxwhU6WcoVvd99jumnzoIGdPUA4t0Z3hhSMa
         cLoA==
X-Gm-Message-State: ANhLgQ2wD5AavcTByeTSq+dt0dJJLNjSNK+pdXF/+BADj4RGXorHgZWy
        oxzoJt2OyEt3GZAq3hRh8YcTmvLBKxs=
X-Google-Smtp-Source: ADFU+vvW8Jj01Cbd5XomrwLxMZJDi+JedmN3L/VvQW5Mp9B0gbci2pKjsl0V36VpmxgkCOG3T+IozQ==
X-Received: by 2002:a63:2a06:: with SMTP id q6mr1423043pgq.329.1583308258352;
        Tue, 03 Mar 2020 23:50:58 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id a143sm1786359pfd.108.2020.03.03.23.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 23:50:57 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 1/3] net: rmnet: add missing module alias
Date:   Wed,  4 Mar 2020 07:50:47 +0000
Message-Id: <20200304075047.23263-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current rmnet code, there is no module alias.
So, RTNL couldn't load rmnet module automatically.

Test commands:
    ip link add dummy0 type dummy
    modprobe -rv rmnet
    ip link add rmnet0 link dummy0 type rmnet  mux_id 1

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fbf4cbcf1a65..d846a0ccea8f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -475,4 +475,5 @@ static void __exit rmnet_exit(void)
 
 module_init(rmnet_init)
 module_exit(rmnet_exit)
+MODULE_ALIAS_RTNL_LINK("rmnet");
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

