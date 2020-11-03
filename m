Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09FE2A4D6C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgKCRq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCRq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:46:57 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD51C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:46:55 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id q8so18751732ybk.18
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=0khbfCjA1AQGPgXKvEHMsryQ8F3Uy3EJ2rCFVDHOT68=;
        b=aC+mws7uFPQlylPW7Jar19j3bbdWaeiQf0iH9us5UbbCvT2oMx3ZaMKlh1l9J5Py4j
         9CwZB7dDAkW4QM6VBjJyPVtWHfD+bY4HIVz3lZfD8vfqCk+wUbAhd5MQgqKpWt9WWDiz
         suX4IAxG1BI6NhUjgSZa9u7ic1Nnej4/D1EaE7TFksitwIU00TaGO+CRGgqe2yFIoqio
         uJMGUZ/iOifmj+NvFqy7LCUKUxDEheR3whJ8fae6POdvd4t1gzq8qCS2N+KXVbr9YXxH
         ZtJkL7fgqMgQSxLgTk31MGAdgjmxP5EB+Q5WzYMWcvlhapR7xiCGw/qim82zg3THZdKZ
         DMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=0khbfCjA1AQGPgXKvEHMsryQ8F3Uy3EJ2rCFVDHOT68=;
        b=bdXVm0to02jCT03ll+cbMbuzm1sPUTX5LKXJ1lI43/ZmEhFIedh789YD1Ym+AoHK+Y
         rsX323FwhdDOhNPkEieJEwcQAh2rROS2JhHzNoWgFMDzLukNpZg2dMhOMTeVllueHhKf
         bVXu/bVrJgwiQDIjQlPiHu0+t06p73+9DoQmn7YdP9qCIqBIqbsMJfRXv/s4weN+n/07
         0p7ub896od5F8TJveoevtIxMhvhr6KoIPiHXYQocMGakPJ4aPT3wtFQ/GOD2EcY3Icyo
         yg5H4kAwby1IZAXaMzOPeCavcbnj9tbMq7vAdB+8kq89r64jyA/ePd7IvIHm9y1iuqap
         myHg==
X-Gm-Message-State: AOAM533pzMcQ8V7z+Q8UkRfOdWuaafMdLTTc++YmFQJY4YEcWf4kjIo7
        XDpBLIXjifDQIlyxBhIM6XcWt0qP+b7MGKgCprwtL2pxVS6bS2GLhO0FDFI/7K/f43zlgbqBbFt
        y4Xs4NzZI3qwiJSpQitsBGLp6WXDYU6GHHByAQxlNlLHPUqftO4I436ahJvJvyL/LROlTvcEL
X-Google-Smtp-Source: ABdhPJxWVKjqVDpJA/Ahay7V2oKiWo6fiSxwnygNeRInyW+X+tCUT/IC9+rbZkixVuFc9/ZB8a8uw3hC1548UQXW
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:9209:: with SMTP id
 b9mr28413385ybo.400.1604425614813; Tue, 03 Nov 2020 09:46:54 -0800 (PST)
Date:   Tue,  3 Nov 2020 09:46:47 -0800
Message-Id: <20201103174651.590586-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH net-next v5 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v4:
Patch 2: Removed "#include <linux/device-mapper.h>" gve_rx.c - it was added
	by accident.
	Removed unused rx_no_refill_dropped_pkt field in gve_priv struct.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h        |  40 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  70 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 374 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 207 ++++++++--
 7 files changed, 581 insertions(+), 155 deletions(-)

-- 
2.29.0.rc1.297.gfa9743e501-goog

