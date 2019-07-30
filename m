Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F58D7A5B0
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbfG3KKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:10:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44221 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3KKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:10:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so65083441wrf.11;
        Tue, 30 Jul 2019 03:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M6bqb+lWrb/E2mkcX84w3humgmw2uZSZn3Vj/9n2zYU=;
        b=QSvTYAuFIUhIwAXJ70hsr7X8I6ildM6Tnm6Br7Uc6Bp3eJJyf9gcoW9EZd/MBcDLFc
         mkJxF2BhWKGCRmJgMw7SFfryNoin18VjUlMgxXF2RiVzC8Hee5nuN+jLhwY2MHRy9g8p
         b9VpF38H26y0Jdsg4lqkiLWYaVsyZfEeMpg3fG9qn0AsThOa4LVd9TanogZbRZ1liGDA
         bJ+srI0Ah1uR1PYHb7sdhPNXkNUdqaKonwWHOP5xPjgUC6I1lyTnzrNeFH6Rc1lF/rim
         jMCnFS1x5qVGua4h8f56T05Lymm+fDBzo4cHu2u0YdKnqQZ960B3bYsReLZxwUoKHsvG
         f2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M6bqb+lWrb/E2mkcX84w3humgmw2uZSZn3Vj/9n2zYU=;
        b=eVB499JLY3lk2dw3Oqv/JhcwY2hHyWVQOnIvNYLD1gYxjS6heLEcyayRVd0wWI3TJw
         h6rTOwAWQ+dWBwQNTMZmYgJYYD7rufVyCDVbOUKE2gVwovuLi+LAAkMOlKi7vKy6CLwD
         xKBq2W8wT7TdeVzVt6TATNXQECKjGGa6+b80qvbiVtU4ObPUnqGdl4sVpXJ3CxFMUg9e
         FQlqCBkWEtBiJ1ifzt+zkpPFdTIXnlGy7wwAgHEdx3JcsZ2ScjMrnoyP/jQgYbxqLspc
         O+kJgh5bfh/iTmM6Wdn2Lqk/3JywOwuP+DpJmoJLX0LJO4eHsQO35Ll6kabNQlA5dHI+
         CI5A==
X-Gm-Message-State: APjAAAWPOSx6eUVC558HCAe5rMGZHOE3OMBHO3YrtS/WvmkS94cKv9i9
        7+rdb+EZRCpKDS9N+nSpwj5bOep9
X-Google-Smtp-Source: APXvYqySczK9ebtVgbcnbN7oerzvLPLtKYJlQx0kZCinuEwbgzkuk8ZNCsinu59oTKo6DTkIw4WrcQ==
X-Received: by 2002:adf:c613:: with SMTP id n19mr70043516wrg.109.1564481421014;
        Tue, 30 Jul 2019 03:10:21 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id 17sm55090119wmx.47.2019.07.30.03.10.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:10:20 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: dsa: mv88e6xxx: extend PTP gettime function to read system clock
Date:   Tue, 30 Jul 2019 12:10:07 +0200
Message-Id: <20190730101007.344-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/ptp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 51cdf4712517..1ff983376f95 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -230,14 +230,17 @@ static int mv88e6xxx_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return 0;
 }
 
-static int mv88e6xxx_ptp_gettime(struct ptp_clock_info *ptp,
-				 struct timespec64 *ts)
+static int mv88e6xxx_ptp_gettimex(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
 {
 	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
 	u64 ns;
 
 	mv88e6xxx_reg_lock(chip);
+	ptp_read_system_prets(sts);
 	ns = timecounter_read(&chip->tstamp_tc);
+	ptp_read_system_postts(sts);
 	mv88e6xxx_reg_unlock(chip);
 
 	*ts = ns_to_timespec64(ns);
@@ -386,7 +389,7 @@ static void mv88e6xxx_ptp_overflow_check(struct work_struct *work)
 	struct mv88e6xxx_chip *chip = dw_overflow_to_chip(dw);
 	struct timespec64 ts;
 
-	mv88e6xxx_ptp_gettime(&chip->ptp_clock_info, &ts);
+	mv88e6xxx_ptp_gettimex(&chip->ptp_clock_info, &ts, NULL);
 
 	schedule_delayed_work(&chip->overflow_work,
 			      MV88E6XXX_TAI_OVERFLOW_PERIOD);
@@ -444,7 +447,7 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	chip->ptp_clock_info.max_adj    = MV88E6XXX_MAX_ADJ_PPB;
 	chip->ptp_clock_info.adjfine	= mv88e6xxx_ptp_adjfine;
 	chip->ptp_clock_info.adjtime	= mv88e6xxx_ptp_adjtime;
-	chip->ptp_clock_info.gettime64	= mv88e6xxx_ptp_gettime;
+	chip->ptp_clock_info.gettimex64	= mv88e6xxx_ptp_gettimex;
 	chip->ptp_clock_info.settime64	= mv88e6xxx_ptp_settime;
 	chip->ptp_clock_info.enable	= ptp_ops->ptp_enable;
 	chip->ptp_clock_info.verify	= ptp_ops->ptp_verify;
-- 
2.22.0

