Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F7D25266E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHZFJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgHZFJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:03 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17832C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:02 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x9so449883wmi.2
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LoMRTjuwvZhskkX5cHX5L/vUV91OTNGtVX2qQin411g=;
        b=R5ru968kuoSkwBXlXk9+lCixOuCB17aTWmb3CgvHApJ7ucx3b0bYmz4Bi4BmGnqjQC
         S2gYHn+Ve8RS+CBypkYi7WoPCSkGWmyzWmI0x2qMcyhekmigx032holccXZT3daerKo2
         0rgB7Q2JrAKCH1f50pcLP16eTKxsjwCumvi8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LoMRTjuwvZhskkX5cHX5L/vUV91OTNGtVX2qQin411g=;
        b=Kxsn7KKwmlcW37sBfQusGeEn4e/JECvV6mq52px4AhNFcPLaJ4Uq1EtBW54XUorMGD
         HxV6LoVldmg93DJXR/gA2kiIG7WTm8iYlqBE2Qm7FpHqtrVb69AUgRXcYHsPK454Zp/1
         mX1T5vARAO67l+6j0+LQgojYjv1QuyPjniLOK1oV8seyWBl+Qp8skE7B0ezNkzQ3uQkM
         //m3uw16tStD0PzvNC6w6NABw5zsk1KUTVL0SM4pi/yj4sQbGKs00r15Qh23g6jlUjkS
         +GIV+QT4MOun0H3zq9LNnSBP/SgQPZfnYiii0mU04unNAV/yb/5/cZJY0NQYpJaD6Hj7
         qABA==
X-Gm-Message-State: AOAM533Ys5vA0noOcfRl73VfEzTLuMfo9RvIIuRGCVcBVwOzdQW/dYO+
        WhKIRIqnhGOLpsjm5TN6E3IbnA==
X-Google-Smtp-Source: ABdhPJwzbW5NMantwaFis3U5Ioqjwn5JeBR74RlMvq10pX2z6IZZ1pdL2P9EBWhOvT0WLiYGZLTlmg==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr4779416wmc.149.1598418540424;
        Tue, 25 Aug 2020 22:09:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.08.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:08:59 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/8] bnxt_en: Bug fixes.
Date:   Wed, 26 Aug 2020 01:08:31 -0400
Message-Id: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of driver patches include bug fixes for ethtool get channels,
ethtool statistics, ethtool NVRAM, AER recovery, a firmware reset issue
that could potentially crash, hwmon temperature reporting issue on VF,
and 2 fixes for regressions introduced by the recent user-defined RSS
map feature.

Please queue patches 1 to 6 for -stable.  Thanks.

Edwin Peer (2):
  bnxt_en: fix HWRM error when querying VF temperature
  bnxt_en: init RSS table for Minimal-Static VF reservation

Michael Chan (3):
  bnxt_en: Fix ethtool -S statitics with XDP or TCs enabled.
  bnxt_en: Fix possible crash in bnxt_fw_reset_task().
  bnxt_en: Setup default RSS map in all scenarios.

Pavan Chebbi (1):
  bnxt_en: Don't query FW when netif_running() is false.

Vasundhara Volam (2):
  bnxt_en: Check for zero dir entries in NVRAM.
  bnxt_en: Fix PCI AER error recovery flow

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 78 ++++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 16 ++---
 2 files changed, 61 insertions(+), 33 deletions(-)

-- 
1.8.3.1

