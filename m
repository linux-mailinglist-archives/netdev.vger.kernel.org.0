Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB1170661
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgBZRoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:44:18 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32821 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:44:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay11so1577052plb.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=h+HuEc8XubY/vQH6wlbG4hOGSo1knaAl3w4HEbHRGbc=;
        b=e8MrkS92DlpOcm2wR3qV8W7s6sHLS0g7zHGlWsatCu38SYTiJX5gah8ZJa3Rjblngf
         YZQkttAAmFFN4HAL9DstO1hPWLJoYVr/0oJWX9qC5xh1Dpm4Jpk8WfEBAxyX8piD3Zd0
         4i3WFlRtCsPoHUPHMDQMCX0lJyteM/5iM5TNqsGUgSEqnenyU0NQV7ThYZRQ26RFBXik
         E+c6/bVQd7PWL5RlpAdq0h2dbHmvP0EDX8z2cLqVrwtobEnKGogBhsVy4Hx2fS5Mgzhs
         bR/U44xqH4ndToDBJ3veqq2mcFGL4HU55ZDLRNUkfUUmwXrvhzIRcNoEsm0YGpZgEBby
         lgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h+HuEc8XubY/vQH6wlbG4hOGSo1knaAl3w4HEbHRGbc=;
        b=kvDk1Lf3aovRBlYVgr76KiSNsIOD9uhmQYL6ogYTe8U2avVTEVntAWOoU1qT3SM7vw
         YT32wiOwXXLB7771Aq28bNaqRnsSG8jEs+pz5sNDDEjhbx27y68KkP6gRtTWx4SZ25wQ
         30RMQK1Yj3Xv++GqjiNqwzxlpo60ebhk77bPTL6FG8GcUMjgl/2SZ6naRpx6J0QUoUXD
         hWxC91V3iKrB9Oks3NneBSzGYGNkd8yg9CP7SHbG/7y6fuQZpDF0YRNDiFp6vAF3YWTr
         to8bmoqhi/Isq408iscbxivLdWO8xGEk6jnh+eqDM0LmQ9jHv+LiqrKXuOXKhiIlrL+t
         oLRw==
X-Gm-Message-State: APjAAAUOwb2AwLn7l77+m6bEVPO3e49aiN17yZIKyKaXekvMJWidNNex
        rnXdSO/dTU2SlxZXMGAASzs=
X-Google-Smtp-Source: APXvYqz3SohJIelCp2ZDuTye19+VhPMrtZLqvnlYbOVxvZ3eWnBfmtoCXnB9b62n6zS9cA0G8lMevw==
X-Received: by 2002:a17:90a:c385:: with SMTP id h5mr229201pjt.122.1582739057038;
        Wed, 26 Feb 2020 09:44:17 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id iq22sm3533300pjb.9.2020.02.26.09.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:44:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 02/10] net: rmnet: add missing module alias
Date:   Wed, 26 Feb 2020 17:44:09 +0000
Message-Id: <20200226174409.4519-1-ap420073@gmail.com>
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
index 471e3b2a1403..f3d6a43b97a1 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -484,4 +484,5 @@ static void __exit rmnet_exit(void)
 
 module_init(rmnet_init)
 module_exit(rmnet_exit)
+MODULE_ALIAS_RTNL_LINK("rmnet");
 MODULE_LICENSE("GPL v2");
-- 
2.17.1

