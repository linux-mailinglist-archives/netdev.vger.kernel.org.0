Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7E46E689
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhLIK2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhLIK2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:28:50 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E93C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:25:16 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u17so3521365plg.9
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 02:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=llWTvWJI+VL9yuN1eTASa7Mg14h/Doe4lSzC5WWZ234=;
        b=gFLMEHt6qsetOyYobSPhCriGDm5mhd9VWNXSfIOjeKq60ABCJeSAGKed8VEFgHgsfQ
         LJbxd1cu4MVj3IgSUw4Btqcj2lOZG3//yYgTikQm1sZ/oizcQ5hdN6H7VoNJn3ftU5JJ
         7HSk1wEj6ae4GAa3XnUPI2sRseCvL5vtIJ/rNHCt+Z8WUrD5y7kHHRIYzScr/CJlwS/9
         QJdDB+s9vCEt8gTlKPlIgsfkLRh/1GjIqyka92GaU9kebIIejhjWiNKkndqFSnOnPDfi
         jZ/1Qd+Y4JAyi6Es3U0NV+XFfXOiVLoXCP4g0c4SWnoHWlWWMqNMLdj2bmpO+bLR0Pe3
         h/ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=llWTvWJI+VL9yuN1eTASa7Mg14h/Doe4lSzC5WWZ234=;
        b=FeG1SjhS92Tlx5DA6Ecpw5GhAOniijG9zUPhpDUZcOAHqkK6n9V4DHdoxVpmX6Tm+G
         llR7xuuqM8dSOjAe6s8XShSS/ceUembj2pGyAagUQiSou7aoaqyxE5pfd2uwK66Y6qS1
         oU6z0mPuHSCa0zXoMEYM/mUiEnpd8TYTCq+U4o4uZ37OBlu6BFJ9OlgSCb/5M4+EXHSQ
         XTkWiwSGmZNyp6EwdYaLBFvLaqdgqLZK5eTQ1eSPEqsQgifPbsy9nFi8I9+L3Hk4p5hb
         EAich9WIil3l1ngSWEGEqixTVIN9qBby/r3wQvZP70Z5q9BZiobRQPURlWFjQu7u6Kvp
         qB0A==
X-Gm-Message-State: AOAM533041hnJmtgs5y8rLM+Db6i391zF/ovBcPE4vupZSdXT1LD3lrn
        v2XeqfpFPwj5hNdQChq2EDYdwRnbi3g=
X-Google-Smtp-Source: ABdhPJw1ff+RL+zo5M9A5Llun+TrMU+R7Db5HfdfFAkW0Gs1pfXcSAgRdcDSPrCLjsiY5N4XXPWeew==
X-Received: by 2002:a17:90b:3a83:: with SMTP id om3mr14622097pjb.0.1639045515817;
        Thu, 09 Dec 2021 02:25:15 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t4sm6708507pfj.168.2021.12.09.02.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:25:15 -0800 (PST)
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
Subject: [PATCHv2 net-next 2/2] Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set HWTSTAMP
Date:   Thu,  9 Dec 2021 18:24:49 +0800
Message-Id: <20211209102449.2000401-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209102449.2000401-1-liuhangbin@gmail.com>
References: <20211209102449.2000401-1-liuhangbin@gmail.com>
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

