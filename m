Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E553311817F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfLJHt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:27 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45959 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfLJHt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so8609469pfg.12
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=9FeYUb5YQUACWEXuDtOr2fvX/MJc1fRm9krwMo+TMMA=;
        b=Va/k8G1ZkP75uyOGpe0IX9ac6awWhgzIlr7Z82kAYxsB/acxlDQ9JLPkM0MQjk08by
         mrGcr89TS9cBDNLzdPTmTAQUMdGrpzSnr9yWnB0DjnoMBYi6F3LP4e7G+ovMgJzddvHs
         r3bJCjEcq5Lvv5ZTEoGUQhyUMTpJmS8QL9ysg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9FeYUb5YQUACWEXuDtOr2fvX/MJc1fRm9krwMo+TMMA=;
        b=XEaWfSmgBrz0yLxL6kT/R6qXvjWhXZhEboyTzkWaP5t7UoP23Rl5C7RDrWROlpQypb
         v7EVy/H+HyopK/kiUSBPL+E3eGIjvov6oZZ0uBwEDT59w5euvur41DrX2+a294B+EhMs
         CCVTwa0u081ZPOC0xjyISJvc29PR7cMRiVQa5pFnF15mjnxTWjAIdEhAz74LdRgb5jWT
         QwyrC16saos9a+qoW3t8q1sNXZ9TsW+0ggjd1wgEfzf54d+ofP+1E2yG4K4Hz9JAxDGA
         BHom3deDvG13wyKHs40KpElLniB0i7B5Z6VyaOmH36POz09qwzUCfZmkSp5aJm/0/Hgs
         61sA==
X-Gm-Message-State: APjAAAXWS/GfMNu+TN6H63HVBfNnIHsTZwqrbY/DvSllv5JHpcFsG0r2
        JlqaYHYIMYU6ru8hc9dj2hC0MuIpsx8=
X-Google-Smtp-Source: APXvYqx+atnm1Vgwfdkn2O+R5MCAfIIG79PKV/XPN8AzxVqI8CclwXEBkQh9t2qgtdRWP/Z7pAUN6Q==
X-Received: by 2002:a63:8eca:: with SMTP id k193mr22977924pge.293.1575964166082;
        Mon, 09 Dec 2019 23:49:26 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:25 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/7] bnxt_en: Error recovery fixes.
Date:   Tue, 10 Dec 2019 02:49:06 -0500
Message-Id: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains fixes mostly for the error recovery feature
and related areas.  Please queue the series for -stable also.  Thanks.

Michael Chan (2):
  bnxt_en: Fix MSIX request logic for RDMA driver.
  bnxt_en: Free context memory in the open path if firmware has been
    reset.

Vasundhara Volam (5):
  bnxt_en: Return error if FW returns more data than dump length
  bnxt_en: Fix bp->fw_health allocation and free logic.
  bnxt_en: Remove unnecessary NULL checks for fw_health
  bnxt_en: Fix the logic that creates the health reporters.
  bnxt_en: Add missing devlink health reporters for VFs.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 61 ++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 93 +++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 38 +++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |  8 +-
 6 files changed, 146 insertions(+), 60 deletions(-)

-- 
2.5.1

