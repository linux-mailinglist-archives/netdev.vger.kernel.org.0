Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117771D72EE
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgERI3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERI3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 04:29:30 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEEEC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:29:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so10770666wrt.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 01:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SMO6DP9W1vkLqXxFpmxMjADEzeYPX7TRpx+znSRtVs0=;
        b=SSYR05JD07cfKOMcYGcSXZLFJ1KBvTmEgPuDGBTE974qORXDoLBBWdxO5gI7EQdSZi
         qYU1YbBq3eOjBTwvfil829kF8x557VBNWfJo7a5Dm0PqFFWEO7J7Hp9rycDbYLyBbFE+
         TuHc+zewUPlN74eSIK7OxwT4eBNz7naFyxCVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SMO6DP9W1vkLqXxFpmxMjADEzeYPX7TRpx+znSRtVs0=;
        b=V0+WoNyURYuyY4hDC3EPc+4sGeUa2a3yOXPJ3OJs3tikGTlu+NkXwhW1er8nKamMoY
         +/GMwFUBucWv+elTpaqjO1gbK/KgnbI8EouPWpxUXVgRKiXiMMDjVezqOd7fTv4oJ9Ty
         lok+6DGsiwXf/yQEOJisHOlJpFIyPTLYt8ZVPLDAOtJJZAxxha16dxNWzCCczlWUGjr3
         D4jQidUNZN8GxAqnbE/KBqgU/akt6bdF9dmKweFefiqHXRc2BRAmIiWPUMhEd1uVi5YE
         f6gG+D+2gqk0PVhaPWZymAd4D5BBI+jZhSxWXXlwTdIZWFr0rckIM7yMQFRqg+rGrD13
         pKQg==
X-Gm-Message-State: AOAM53346rEyFZrryUfNl0e28owBexPOxPofR/F69+K5RpQNg2oeCmbu
        gwvlcD9o17piFm0HkQIwooDM7g==
X-Google-Smtp-Source: ABdhPJxg1I5wctCMJsFuffFOoQTHRSPBc4ykBh2hT0K1BF17TB2yFo122R9fGI9Pl9OScYPhryjN9w==
X-Received: by 2002:adf:b786:: with SMTP id s6mr18030887wre.287.1589790568509;
        Mon, 18 May 2020 01:29:28 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m7sm15350144wmc.40.2020.05.18.01.29.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 01:29:27 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset" generic devlink parameter
Date:   Mon, 18 May 2020 13:57:15 +0530
Message-Id: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for a "enable_hot_fw_reset" generic devlink
parameter and use it in bnxt_en driver.

Also, firmware spec. is updated to 1.10.1.40.

Vasundhara Volam (4):
  devlink: Add new "enable_hot_fw_reset" generic device parameter.
  bnxt_en: Update firmware spec. to 1.10.1.40.
  bnxt_en: Use enable_hot_fw_reset generic devlink parameter
  bnxt_en: Check if hot_fw_reset is allowed before doing ETHTOOL_RESET

 Documentation/networking/devlink/bnxt.rst          |  6 ++
 .../networking/devlink/devlink-params.rst          |  6 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 61 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
 include/net/devlink.h                              |  4 ++
 net/core/devlink.c                                 |  5 ++
 10 files changed, 158 insertions(+), 36 deletions(-)

-- 
1.8.3.1

