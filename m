Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523B71E173D
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgEYVll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731414AbgEYVlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:41:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A926FC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:40 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m1so2837277pgk.1
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3mQUyFD0JXDrJJGAXoRk0NdIe44JYVnyUOreRnLn7ts=;
        b=MKlSYa+BrKcwtMOya4p21wz3s1JhNkM8fjwgxjVNc6GV8Whfjb6RVyci7iYepX5og6
         zqCwqbhQiuMNeXGLYO3UCLw70ritsGiHuW0EiJSebaun8P8FTo0/SkS9iNmiw/E/wxKO
         VFmnKKXt2aBg3QMDxDsHTsFeKh3o2oVsrmpM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3mQUyFD0JXDrJJGAXoRk0NdIe44JYVnyUOreRnLn7ts=;
        b=NoEleSJ+U3vqJSXSywpOiUf+odT5BGuCWBRN/kzIUWL0Z5dgOXqlXMPbPcRWtNrgaj
         sPMBIC8PVn79gSwDnM8hItaHo3T3uiJLXkQ/titgEAyKQrKq76YI6sb2lecAiB5JTcWn
         coklO1XtUlA/vpZNReSxZF7ei0TV13b+DATcYn6YZ03ZbnkjlOLZjAg2IE7xBYN5fvUs
         u0V5iyKjEHtG1fmJ0yTexTK9uraNryknw5djuf5pGzps9rxsJOVb+ivJx1F+7U4qSger
         5mEIKCYaaIugVLnHckrA20eCSaIlk9rnIsVXxjlqSGpZhwnyJrDgkYoMK2FE2afb1bYs
         E9jA==
X-Gm-Message-State: AOAM530Ae0JM49YOl1S5LtcFuWSfd14OUpyR4K2ZP6Z3sBn9/IFbbl37
        QQ1PSQz+75wHi/YnbBbSUbk6Iksu+LI=
X-Google-Smtp-Source: ABdhPJxMaqN8YHH0APeEQWN+8hUOvId4K4J5zyS0onMazvw8sQICPb7YNzD0x3fwipU8T42fFJzO/w==
X-Received: by 2002:a63:d844:: with SMTP id k4mr6145937pgj.141.1590442900215;
        Mon, 25 May 2020 14:41:40 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g1sm13309401pfo.142.2020.05.25.14.41.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 May 2020 14:41:39 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/3] bnxt_en: Bug fixes.
Date:   Mon, 25 May 2020 17:41:16 -0400
Message-Id: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 bnxt_en driver fixes, covering a bug in preserving the counters during
some resets, proper error code when flashing NVRAM fails, and an
endian bug when extracting the firmware response message length.

Please also queue these for -stable.  Thanks.

Edwin Peer (1):
  bnxt_en: fix firmware message length endianness

Michael Chan (1):
  bnxt_en: Fix accumulation of bp->net_stats_prev.

Vasundhara Volam (1):
  bnxt_en: Fix return code to "flash_device".

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 16 +++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  5 -----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  9 +++++----
 3 files changed, 10 insertions(+), 20 deletions(-)

-- 
2.5.1

