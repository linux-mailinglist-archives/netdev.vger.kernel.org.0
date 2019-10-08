Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBCF8D02B1
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfJHVQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:16:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41017 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbfJHVQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:16:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so5152507pga.8
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=TxlfhWbpcunGBzzfNw2ijs+JMA3LBzP7XlcoEFlBGz0=;
        b=sz3ldgI+AoCabCy0dt3u3e14oPscxWCZpcM6rQVoSGDhvGWZLTUwsYUA+7692YcXB+
         ul6g+wSHsMK156ht3S5CkAijSXWxko9CHurkCHjDUVwqQ0iJiLGIKvpqJ57iacQ/Ol7a
         ClBzUfhMVKUYYyi7uoujOFW0J+1NIZhxC9eSJQr/6MpceQYF6pSjyoIdiEsDWUfvNvda
         KJ5unsSokihuredX8hza2QpuyROWkAFt+4YiibrnQS8ANr2UzGBursDhOzW3xJ/4THZo
         o+xbicWC9mclAjfzyTLwvgD2BAedY/Mh0zuekN1x6r1E2Wh9m5wN+oQBJUShftokMTyD
         ttzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TxlfhWbpcunGBzzfNw2ijs+JMA3LBzP7XlcoEFlBGz0=;
        b=cznRlFinnZtqP+QcBDwUvGxO5c3rABbfx9N0XandCduEKoSqstWH/hlBCSY6OBdHcv
         9m3XigjDKwBXzSriwMKAb0smjt/wAY88VTHZmegbmAaciGlLlrOR/S1ltZYgR9BuNqfC
         Zjc7zkN/so5E/RCYQzSZ6hS069eH6EsBL/di92N/mkLinNnI9+eKZTdb7TZ6uXNLq9DN
         DAIaTYZa6i4gBuOaY87VxDb/XCuYWL9h/nX8D+9s+vAJFa/eTIYSYJ4uUzLy4+MR1j6V
         gr/VqdQg2JV2hOMcdGJae4hta17cGtQaiHa80szokaZlas3F52lFBI91yf3FbsLg7wcF
         Y2wg==
X-Gm-Message-State: APjAAAU2U89GuD5+YVZ6/cTgeNCHbLU95QlCWUVno5FfMNQESK62VhRH
        7Z0FVma1CzCfy5POgErwllT4WpZo5wx+OA==
X-Google-Smtp-Source: APXvYqxvHpDH5MjJEeTSJwoYowxlOtitxd2+6Jh9UJDazvULERueDJfKAg7c3G8DPZWrwHmWXMS0Sw==
X-Received: by 2002:a17:90a:7142:: with SMTP id g2mr8323303pjs.36.1570569406178;
        Tue, 08 Oct 2019 14:16:46 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id s73sm102895pjb.15.2019.10.08.14.16.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 14:16:45 -0700 (PDT)
Subject: [next-queue PATCH 2/2] e1000e: Drop unnecessary __E1000_DOWN bit
 twiddling
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Date:   Tue, 08 Oct 2019 14:16:45 -0700
Message-ID: <20191008211644.4575.90683.stgit@localhost.localdomain>
In-Reply-To: <20191008210639.4575.44144.stgit@localhost.localdomain>
References: <20191008210639.4575.44144.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Since we no longer check for __E1000_DOWN in e1000e_close we can drop the
spot where we were restoring the bit. This saves us a bit of unnecessary
complexity.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 8b4e589aca36..1e4f69a0f0aa 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7409,15 +7409,13 @@ static void e1000_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	bool down = test_bit(__E1000_DOWN, &adapter->state);
 
 	e1000e_ptp_remove(adapter);
 
 	/* The timers may be rescheduled, so explicitly disable them
 	 * from being rescheduled.
 	 */
-	if (!down)
-		set_bit(__E1000_DOWN, &adapter->state);
+	set_bit(__E1000_DOWN, &adapter->state);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	cancel_work_sync(&adapter->reset_task);
@@ -7437,9 +7435,6 @@ static void e1000_remove(struct pci_dev *pdev)
 		}
 	}
 
-	/* Don't lie to e1000_close() down the road. */
-	if (!down)
-		clear_bit(__E1000_DOWN, &adapter->state);
 	unregister_netdev(netdev);
 
 	if (pci_dev_run_wake(pdev))

