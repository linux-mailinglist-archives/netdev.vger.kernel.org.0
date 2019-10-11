Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AFD4479
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfJKPfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:35:02 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38443 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJKPfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:35:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id x10so6003764pgi.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 08:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=kDXNvE+7gQdvUyVWPr7A9XMzGIYNEQ+LfNsblj+ZWek=;
        b=vTvpGo2OLw4l8Jnj0vPAmEfIebxuUoeio9APO9DMxmvQimFyoIgylaWfwsZwSz84Xv
         kuRe/U52CxAJmB+CH3l9oKbolvj9fEitA3eCSdFRGX2NGNHiKamS2A1IQ/FUTU5j3yH3
         ZRBQmuoC1kdPnJ/Nb8GbMd+d5UchEprrIavUBsjqShBrzB/F+WRT2q5swgYha+6wOGcc
         nAuU7bN3i2g0eICLeFrtiaMmNDV3/Nkfue77Qfgcm5TiU/Dn7T53d63hQXpaCvrAR74C
         0IqEdlPySSgKjnPG9oEWpg53Bm4j2CmyhCkHorH6bJJl7uI9g5WCTP7w+QoP7Kxi9NEb
         grVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kDXNvE+7gQdvUyVWPr7A9XMzGIYNEQ+LfNsblj+ZWek=;
        b=LctzVZZVMEXziwJWejJtY3qPRVenDMkT5I+Qhc/BfpaC2of2JCGl0d9fVRrBQNHF/Q
         KFgy3o/VmqiG5n5v/YUBxIDdW8jG8ibg60ktfi7ZMjNn9UjsDGuqlVeQiHL/XE2aSnGH
         5U2nC/p7JiV1Np3G6F0kuwMhuR9nEzqnZeMJNBlilvBNZE/YPxKEhBOS/5MAvln2SMo9
         dTa+V5RW3QAz5ZgC8o3XqImCsW+75C1mW/PuAOSzLARH9zZcc5goVUv0h/GowzB42TeC
         oEr6ECyicd7AekQbLJlFFxlctBvWM5XL+sB3EQ6XSdI2qMRR1V2YCGSLyb6JI9P2ipBH
         iYSg==
X-Gm-Message-State: APjAAAUhGhvkwgJ8YMbbQt5/DTnxCOEp3B4xvN2hTt5iJUEci6CPv/fv
        bHtbBsvWTcRdvd7P6H1YDIY=
X-Google-Smtp-Source: APXvYqwcs4NyECZf3Wfa9SDJOWplX35s7XDkuU1uPT6rNnsWEpGvNyRuAFutrA9fwSERCNVxpOfJvg==
X-Received: by 2002:aa7:9519:: with SMTP id b25mr17116157pfp.104.1570808100872;
        Fri, 11 Oct 2019 08:35:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id o60sm13296207pje.21.2019.10.11.08.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 08:35:00 -0700 (PDT)
Subject: [next-queue PATCH v2 2/2] e1000e: Drop unnecessary __E1000_DOWN bit
 twiddling
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Date:   Fri, 11 Oct 2019 08:34:59 -0700
Message-ID: <20191011153459.22313.17985.stgit@localhost.localdomain>
In-Reply-To: <20191011153219.22313.60179.stgit@localhost.localdomain>
References: <20191011153219.22313.60179.stgit@localhost.localdomain>
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
index db1591eef28e..c31259dde78d 100644
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

