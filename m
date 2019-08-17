Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207AB912EB
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfHQVF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:26 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44430 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so3888685plr.11
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wONjcKY8aQCxWgF2ypE2v73dMethUZBsO3TO0LcY3qM=;
        b=QTANGPC1jQYhPQROyXKt2x8taBoTR9bXWsoKWxCaohv7cRGwuTYCTD+og65+aJWANp
         8+9WEOKxrV+ninEJSjkT66y4/GdYiHMKPHX5P6NH92QzN79zDgSaGZdKtIR4ighLnWKl
         Z1SaHQDZfnjLKbwBY1iILM8yIBtv2JCN3kNN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wONjcKY8aQCxWgF2ypE2v73dMethUZBsO3TO0LcY3qM=;
        b=iwELkcs43uux8aC1DdQefHU0GHeZfhfC+y/YDOPMPNrvNB8jvbQyMLPadUiketlBaE
         d5NDlRa4LACRnjIU6xRryRFt+H1ZpXUfsIeG4JhA/8/CDdpAQ96feXI+2jZJQydkcO1H
         2fssZwN3zydNw9TOJ3nRTueWwfyYFq0qvLTsu87tbQI4oXCAuw0/TkgMSkhPfBxlfupd
         dD+BxRF+GtZNqQ+ruu1vomze8AlxEHU9U+0lroyOkkqZgleL28H6/h1DMKP/Yxfhyspq
         0ZDjfDSIZdiZPOtQAElZZj45A61wlH1ItbsgR+oC1GkGC4M7jqmfRRokte2pCkD+Z/Uz
         mrWA==
X-Gm-Message-State: APjAAAXTKvjZmFVCbylDo4OD+WACxp1Ckys8S7zxGBD3ixJLSxQleT9C
        SXmzC4fW/xTAKFoFKQF0E9BRteZWBkc=
X-Google-Smtp-Source: APXvYqwv22XCkFc5LJej8IJs220nvoZtG6iXJiQ+3hMdsZIx+tV+R5C/iKqEBYg19UAmw5ZP+Oi23A==
X-Received: by 2002:a17:902:1024:: with SMTP id b33mr15748611pla.325.1566075925639;
        Sat, 17 Aug 2019 14:05:25 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2 0/6] bnxt_en: Bug fixes.
Date:   Sat, 17 Aug 2019 17:04:46 -0400
Message-Id: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 Bug fixes related to 57500 shutdown sequence and doorbell sequence,
2 TC Flower bug fixes related to the setting of the flow direction,
1 NVRAM update bug fix, and a minor fix to suppress an unnecessary
error message.  Please queue for -stable as well.  Thanks.

v2: Fix compile warning reported by kbuild test robot on patch #6.

Michael Chan (2):
  bnxt_en: Fix VNIC clearing logic for 57500 chips.
  bnxt_en: Improve RX doorbell sequence.

Somnath Kotur (1):
  bnxt_en: Fix to include flow direction in L2 key

Vasundhara Volam (2):
  bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
  bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command

Venkat Duvvuru (1):
  bnxt_en: Use correct src_fid to determine direction of the flow

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 36 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  9 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 12 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c      |  8 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h      |  6 ++--
 5 files changed, 42 insertions(+), 29 deletions(-)

-- 
2.5.1

