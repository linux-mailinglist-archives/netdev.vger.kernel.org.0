Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7236F33C3ED
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhCORPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCORPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:15:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B7CC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:15:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lr13so67613345ejb.8
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1RURcpmMch727Ry8e1e4rE7LPwmwCCm3CKQbXHTVP1k=;
        b=VjaRKYrlU6zrK4i5Dbl2mp11CL4okopm1GnZdyIJPuqiQoK/zuwrDKG6RGT7Ebx9k/
         j3yGlADue1PlYQ8x2ktROsbItQVr/mvzwaHP1oTK4pCiPWmGVD8n6tQb8FieUxwim3wO
         5CO2+rbqDjn8jTgTV8V/S4bGDN4QRWw5wfw8BkW28E4uMu6GnpuWF1dFnoKOR+ZmdoFt
         3ljn5xKw8RMOTANCOA33zD410Jr8TEXekSsReLhFyZwIN2T4En4qJeYqNLLFeBkS3kic
         12cf/JjXcGm1rwa8i3rgO9X4uUIqfRDALgr8c2nEWvA5tJvKsc79E6zDpAylSUtZsWFF
         19/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1RURcpmMch727Ry8e1e4rE7LPwmwCCm3CKQbXHTVP1k=;
        b=f8T/4KbNdcRutxEGgg9QLWqZ0csbethrjoWStATPx8/Nq1NDgFeLY1WSm1KUYjGo72
         MtiekJbZBCWe3d0mX0vcC/aO1DX9RCrC2x2Gcu5TQJDF/txYc3oRN+1FLyzr9EFUnFO8
         209R3FyUMkH3Rf/eYZc6QALQ6eHAg47y1Ya/AK9PsaTbMQAW+RO9Z9w+WUw6AHScLO4X
         24/odSy7VpiqqQx/zDL62Vj4HhwXi9Itk+Qz1/rUJbIFdCy+EXHfgS4Zz4uF9gonyr01
         0XGcMxesnyJqMb/fgLcKnt77WOiadJWzkkBDF5/8o19ArHr2QgS+qJ9y5rIzFcyAgvL5
         8U2Q==
X-Gm-Message-State: AOAM533g5Nl/Q6r8lisdxgBwQQtkAJQWulmAy9R4VPj6HZ8MIyEeDJoU
        1VzMVqv3hV3HbynipG8k5x0PVXzuxDnqobdt
X-Google-Smtp-Source: ABdhPJwU6dDLJtr1QOOmvDAvd4hI/729yXU/bkc+q9aw5GPP7c0bwtG+Dw+bHCRsQbqSJLqysCAJVw==
X-Received: by 2002:a17:906:719b:: with SMTP id h27mr24462560ejk.123.1615828533283;
        Mon, 15 Mar 2021 10:15:33 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b12sm8297369eds.94.2021.03.15.10.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:15:32 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 0/2] net: bridge: mcast: simplify allow/block EHT code
Date:   Mon, 15 Mar 2021 19:13:40 +0200
Message-Id: <20210315171342.232809-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
The set does two minor cleanups of the EHT allow/block handling code:
patch 01 removes code which is unreachable (it was used in initial EHT
versions, but isn't anymore) and prepares the allow/block functions to be
factored out. Patch 02 factors out common allow/block handling code.
There are no functional changes.

v2: send patch 02 and the proper version of both patches

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: mcast: remove unreachable EHT code
  net: bridge: mcast: factor out common allow/block EHT handling

 net/bridge/br_multicast_eht.c | 141 +++++++++-------------------------
 1 file changed, 35 insertions(+), 106 deletions(-)

-- 
2.29.2

