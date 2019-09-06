Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A872AABF8E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406125AbfIFSoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:44:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35991 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405022AbfIFSoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:44:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so7608276wrd.3
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 11:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPqHMrarnj/eqlovwm4Ti2RJQ9+Z2LObwoWgr5fDQsE=;
        b=RM1AEuB6NKHxYqOmzyvfh1pE8zJny+uX6bt5h6/2Nqg7i15oiKqadupfQwGpI77Xgs
         KsUZd3nqZbDC73b1i9vNomNzhwAx2BkK3Rgm9IP2/JASILJ5iaNksRt94oQVzVeXBD22
         0k/YQ7s4x6QuYst2Va+zOTYQx4shLoyBO0dCYDjhtd1hP5bHxNQ9nT2KYWeenOpqHh+l
         QSF1Ng7ALjFXJ+Y0XTY491VAqkCbe7pNy3N7FbEXSklpOISvc48HDiNU/1689v+QKG+D
         c920l7G2RfDXGLMO1tLkc6D5JgdW+JdvsCT9hyKtes3KD3ubh1L2pPG5ar1Ekf/MZxza
         aU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPqHMrarnj/eqlovwm4Ti2RJQ9+Z2LObwoWgr5fDQsE=;
        b=H0P6M6rgETgFrf/ZI8JiF+fJAMnc4vrddVChIZFQbMD8qK0X6q86cFRRrWzuqMd0nV
         phmJ8hLwpODQH75e3QlQyCzXjSKOUYakxMPekNQm36uIHCPBD9FTugLT79UJfI5bWiLH
         KL8xaQPZ3gSv+2Jp51cDttgVZf4vQ7K2ldTnahaiyWAYUHj+PnKO6zjWBzmou4Gzcul+
         DtWES5RZV9aS5cqLuGsbfIcviqcTQr0Q6fw5XBRuhHHuzU00+89vBkWAt1qtMbAFSuwl
         oWJ9275wIyKGSw/ieVGXz9Y0I2PuZhvebaIM4HCvp8GkGsylE0Caac7htykRrz21xS0I
         LSMQ==
X-Gm-Message-State: APjAAAWJCT22hfOmIXm0cBWQiiSuohbT2nwKeFIZXWvgmyTLDRxWuuqp
        gXPhboZyXUjgDbCbslLkkvgrFG9SUkM=
X-Google-Smtp-Source: APXvYqygUSa0c8WopssymhzrAMjgf+qQaoVjaPv/4LPQwGZmneN5mnLBYb6uJZ14Ey6PvVpmNv39sQ==
X-Received: by 2002:adf:e784:: with SMTP id n4mr8562732wrm.144.1567795461026;
        Fri, 06 Sep 2019 11:44:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e20sm8922144wrc.34.2019.09.06.11.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 11:44:20 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 0/3] net: devlink: move reload fail indication to devlink core and expose to user
Date:   Fri,  6 Sep 2019 20:44:16 +0200
Message-Id: <20190906184419.5101-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

First two patches are dependencies of the last one. That moves devlink
reload failure indication to the devlink code, so the drivers do not
have to track it themselves. Currently it is only mlxsw, but I will send
a follow-up patchset that introduces this in netdevsim too.

Jiri Pirko (3):
  mlx4: Split restart_one into two functions
  net: devlink: split reload op into two
  net: devlink: move reload fail indication to devlink core and expose
    to user

 drivers/net/ethernet/mellanox/mlx4/catas.c |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c  | 44 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h  |  3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c | 30 +++++++++------
 drivers/net/netdevsim/dev.c                | 13 +++++--
 include/net/devlink.h                      |  8 +++-
 include/uapi/linux/devlink.h               |  2 +
 net/core/devlink.c                         | 35 +++++++++++++++--
 8 files changed, 106 insertions(+), 31 deletions(-)

-- 
2.21.0

