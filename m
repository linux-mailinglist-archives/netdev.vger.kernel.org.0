Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC58261AC9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbgIHSk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgIHSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:39:16 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22D8C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:39:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id fy7so69427pjb.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=f7y7+zjYdiMl/sSGJwiXVrFJ0d8h9TnUv3lF8KhJNw4=;
        b=sRGUCp8AHF86ygaOY/AKBMq5C37t7VqT5W5uq1/1Du1GWG862c5yG6qSVSu/sBFk8s
         f9aEOTUS6tRFgCLZ4q8UsP4bMi27w/fXuriunOd0akwQanFO6jfzglxvd8iZ4u3q0CCT
         hj+Giqalfpy+1OX7t6YcwSxz6CgBDf9/mrXL6ZdWwmPxXKghBFeAftrlXBRluw9/VcUr
         DLIX/DRhdEVlMbgwmfX9GQ9Bk3Y2lGKtWOXbttbKbXawe/uPDSxaPCymbka/ORz8NFhx
         4lrktKYZOCR1mdS1uktmmKlG4mlrYBNINEQak1OtDdKIaGEWolurmYCbeN6wHN7FqwEc
         OoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=f7y7+zjYdiMl/sSGJwiXVrFJ0d8h9TnUv3lF8KhJNw4=;
        b=ptN2HzPrVM2lKn5/Yc4uIVslBSRq/dEBoR61w0Tw/IGXd3RqYijVxt5/bWm6r4HDhA
         mxg5XWulXzFgs0ExD+FGosfdJpRIFUdj/aNLbhQjicH9e5qQBdHB5cSyTeRk2BilwLO9
         g89bJjvu5MM0VRgR6MEmPeVFdS/jBYaOfZrt3vAWYU+GpQkuMNh+AdJYIlu1ctKV7DR5
         dM7N8KVPuIME8w8gNZd8C2klsUPfFdK3ZSmIFEguwToFSNLjrbubk93JUA4uXqRE+Sok
         8EVOScq7NGsgoB/zt16YibgAV6r3r3F7nHQ0J599V1tItfVMnfgNY6ZiEwJqYigZjwKg
         mBbQ==
X-Gm-Message-State: AOAM533t2FmZ1riqHPjdvZ49VehBXugdaGPe3C22CJVaBTf5E/yjPXPf
        AiP27DMdNyk5w4r4w/92tHyJFaPgHEsInnzBTjcCHpsa9om8t/L4AsppQysp+SUyrkkVsUZiWEk
        PgG1gvYEEUPIl8Bq39XoJXM1sR0S+C1JmIGKJDXSb/0S0FUTeHH6nv99TJSeDjAqAZMnVet6l
X-Google-Smtp-Source: ABdhPJy/TBiWkmRqYHEm43GWXwX8WJjXckKsgGRvpC7q0gmh/xmkbCvUPSkWEQppWixaUoFYhb5QLIQhPJTIA+MN
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:6bc9:b029:d0:cb2d:f272 with
 SMTP id m9-20020a1709026bc9b02900d0cb2df272mr435756plt.11.1599590353080; Tue,
 08 Sep 2020 11:39:13 -0700 (PDT)
Date:   Tue,  8 Sep 2020 11:39:00 -0700
Message-Id: <20200908183909.4156744-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next v3 0/9] Add GVE Features
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v2:
Patch 3: Removed white space changes.
Patch 4: Removed 24-bit dma mask, clearer commit message.
Patch 5: Removed pointless loops (only one priv flag exists currently),
				 Removed unused function (gve_set_report_stats),
         Removed report-stats log statement, use ethtool stat
         instead (stats_report_trigger_cnt).

Catherine Sullivan (2):
  gve: Use dev_info/err instead of netif_info/err.
  gve: Add support for dma_mask register

David Awogbemila (2):
  gve: NIC stats for report-stats and for ethtool
  gve: Enable Link Speed Reporting in the driver.

Kuo Zhao (3):
  gve: Get and set Rx copybreak via ethtool
  gve: Add stats for gve.
  gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.

Patricio Noyola (1):
  gve: Use link status register to report link status

Sagi Shahar (1):
  gve: Batch AQ commands for creating and destroying queues.

 drivers/net/ethernet/google/gve/gve.h         | 107 +++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  | 316 +++++++++++++--
 drivers/net/ethernet/google/gve/gve_adminq.h  |  62 ++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 361 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 331 ++++++++++++----
 .../net/ethernet/google/gve/gve_register.h    |   4 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  37 +-
 7 files changed, 1039 insertions(+), 179 deletions(-)

-- 
2.28.0.526.ge36021eeef-goog

