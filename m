Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA9146FD32
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhLJJDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbhLJJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:03:54 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E44BC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:00:20 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z6so5844844plk.6
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=llWTvWJI+VL9yuN1eTASa7Mg14h/Doe4lSzC5WWZ234=;
        b=ExlxfhV9m5qsGRE0HFfIuLC8CWEbM0HMRBwwmydS+pMnnln5Lr6v51LFNRSTZSxUpP
         AA4zsb+rNcShHxpfWUFFA/xkasTp9NpDJdnMT1jnDoMtgoyz6T+PTgcsKqWpdXDK48s2
         0pTgu/59t8OtrRVNOExGgoOx1JwsNcfRycg1rS/hAmvQcE+gyBRbdQxPpKutjiM/FcRN
         CEpB4q00kVEPiDIplDD1UjbW9zsAwZl1OWWHgGOara9fArJHCXaaChmBMWILmOIhsNqM
         RYUJJgM8/ewvKt0tnH4NKGWZrWCz5Ym0E5HkB+0V5OlPrTWYwqaRLQlXdwLDrlace/2F
         OkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=llWTvWJI+VL9yuN1eTASa7Mg14h/Doe4lSzC5WWZ234=;
        b=ZLqjKRNYBaTrlwjrxnkUgcZ49v6x4aiMHmkoBPQGLqqCGEFMj1g/Zt/ijbLzB6Gxlt
         5A2lXlLPkDF7n9UdsW6gmWBV1efzcHkGrGNh1vEhHgkZKiVCWUQFx6/61SjJu8ChknvC
         Q8fBGXLCfEXsD60+zeVDXsuXaGWIteh3lh1jE9Kr6DDjoM/CD4VO7MgEPQXbnQLI3RiY
         iOePvUjje5bsXxJqICJwAYX9xAOj1xSMUN8+Fnqo4OBq5EGInazPDfZSMFOUGaBobZDX
         qkNw2wlR66kUI5F8Z872bHJi8Q/6Z+/Mu0xwP8ydKEY9DQJVpiKrExGyPzGGkiU9tsVE
         gMfA==
X-Gm-Message-State: AOAM533vYGDgzmVR0Dg9de9zUi6niu5W8SxENdsCKjTVVXpqA5OrK6D0
        iiFzdNSXTCWsCQbkEgIJI5kt29bBmm4=
X-Google-Smtp-Source: ABdhPJxN3DqNk6S4/O0y+DUayV9wPJbulUli+xKWGdke9nBTlLBGJfGTRIdlPywrKgVEWmK+R3gmRA==
X-Received: by 2002:a17:90b:4ac9:: with SMTP id mh9mr22212771pjb.25.1639126819562;
        Fri, 10 Dec 2021 01:00:19 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o124sm2383038pfb.177.2021.12.10.01.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 01:00:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net-next 2/2] Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set HWTSTAMP
Date:   Fri, 10 Dec 2021 16:59:59 +0800
Message-Id: <20211210085959.2023644-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210085959.2023644-1-liuhangbin@gmail.com>
References: <20211210085959.2023644-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When there is a failover, the PHC index of bond active interface will be
changed. This may break the user space program if the author didn't aware.

By setting this flag, the user should aware that the PHC index get/set
by syscall is not stable. And the user space is able to deal with it.
Without this flag, the kernel will reject the request forwarding to
bonding.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 94dd016ae538 ("bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v2: change the flag name to HWTSTAMP_FLAG_BONDED_PHC_INDEX
---
 drivers/net/bonding/bond_main.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0f39ad2af81c..268190a624e0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4094,6 +4094,7 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 	struct mii_ioctl_data *mii = NULL;
 	const struct net_device_ops *ops;
 	struct net_device *real_dev;
+	struct hwtstamp_config cfg;
 	struct ifreq ifrr;
 	int res = 0;
 
@@ -4124,21 +4125,29 @@ static int bond_eth_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cm
 		break;
 	case SIOCSHWTSTAMP:
 	case SIOCGHWTSTAMP:
-		rcu_read_lock();
-		real_dev = bond_option_active_slave_get_rcu(bond);
-		rcu_read_unlock();
-		if (real_dev) {
-			strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
-			ifrr.ifr_ifru = ifr->ifr_ifru;
+		if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+			return -EFAULT;
+
+		if (cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX) {
+			rcu_read_lock();
+			real_dev = bond_option_active_slave_get_rcu(bond);
+			rcu_read_unlock();
+			if (real_dev) {
+				strscpy_pad(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
+				ifrr.ifr_ifru = ifr->ifr_ifru;
+
+				ops = real_dev->netdev_ops;
+				if (netif_device_present(real_dev) && ops->ndo_eth_ioctl) {
+					res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 
-			ops = real_dev->netdev_ops;
-			if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
-				res = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
+					if (!res)
+						ifr->ifr_ifru = ifrr.ifr_ifru;
 
-			if (!res)
-				ifr->ifr_ifru = ifrr.ifr_ifru;
+					return res;
+				}
+			}
 		}
-		break;
+		fallthrough;
 	default:
 		res = -EOPNOTSUPP;
 	}
-- 
2.31.1

