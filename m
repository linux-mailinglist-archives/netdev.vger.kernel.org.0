Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0BC345146
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCVU77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCVU7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:23 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C52C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id j3so21012371edp.11
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wxv9iUavjoA7myo0v2QjEUO2tzYld2L/O7j3H4/kka4=;
        b=jo41hw6F5RPvltp+vCy/FKSOryJfRRMiu4YgZZ5xBsnBvw7nejqqYXzf5bWfUVgVoE
         H+6luUL8CU/2q7GalGA4XZy4DNq6BINboW/FkhDNrnumECl8r63MU/T1t6J6cqUoSiJN
         3jCMKdAv5jg3JC5d83WgeKtKsypwo6bMONoa8V1tat34Scv/bgGji0fYMrtlcaYOKI2w
         5XXnrE6W1NeKpyaUm01NY5hKZbW3rJcDzZdRmqEgcEkMQZiKmtPfCG877w+pWF1flU5I
         sVX27GxuFVp4jAqwvDX2AIZZRwPgttKwlbcMqRbEDxpOew5RcR35xMkuzYeigLlFsO25
         YWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wxv9iUavjoA7myo0v2QjEUO2tzYld2L/O7j3H4/kka4=;
        b=fhjhyCeaOKGwGVEHjJ8ZsgObG0buxxD1Ug5rqIsnmjmcgIkTGuutXfeeHH1xVcbUoG
         lCt8SNoQecL/VGqEf0mo/smIuSWyoS27RfS33Pq2+qEwAQBoRSTts601W7a1V9yhSILP
         pn0qBhXeHjq1oTGjkAkHyfqSJv5+xaMMo8SPAHsVwXiZUioQBT0G6Tz5LD+xRyq7mz50
         8goWmwrGcr5QU/OSKlwSIX5I1v/YiQBPl2o+q8WB7e9q+v67M6cHOdmNhXCAfcVnKWqT
         SakuW72FbhKcBqPuSagtOyXSR5uqA4vtATa0P8/wCq/KogU8w8AudoZjlcEKN5IokfUr
         98MA==
X-Gm-Message-State: AOAM5320jPBpgfPliEawlWeghXuLqhLTU19VGfZMIX3iLPtPPb8Wr03/
        rqwl59H9AEycF/LnYdXv5tk=
X-Google-Smtp-Source: ABdhPJxtTH3qo4u6RoXNMIW0ZOXbi03MphZ3jre7hzQwL++f94I3a4F1zLqLKg1eXTK+/N9upMjNGw==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr1432117edb.329.1616446762322;
        Mon, 22 Mar 2021 13:59:22 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:21 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/6] dpaa2-switch: offload bridge port flags to device
Date:   Mon, 22 Mar 2021 22:58:53 +0200
Message-Id: <20210322205859.606704-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add support for offloading bridge port flags to the switch. With this
patch set, the learning, broadcast flooding and unknown ucast/mcast
flooding states will be user configurable.

Apart from that, the last patch is a small fix that configures the
offload_fwd_mark if the switch port is under a bridge or not.

Ioana Ciornei (6):
  dpaa2-switch: move the dpaa2_switch_fdb_set_egress_flood function
  dpaa2-switch: refactor the egress flooding domain setup
  dpaa2-switch: add support for configuring learning state per port
  dpaa2-switch: add support for configuring per port broadcast flooding
  dpaa2-switch: add support for configuring per port unknown flooding
  dpaa2-switch: mark skbs with offload_fwd_mark

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 214 ++++++++++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   3 +-
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |  10 +
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   |  27 +++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |  25 +-
 5 files changed, 225 insertions(+), 54 deletions(-)

-- 
2.30.0

