Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936472AA6F0
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgKGRXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgKGRXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 12:23:19 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0B8C0613CF;
        Sat,  7 Nov 2020 09:23:19 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id g12so3515326pgm.8;
        Sat, 07 Nov 2020 09:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tI2A7wrVYPdXVz/TzeQi+IfDXKzGJ3NnGoB/TzjX3uU=;
        b=gDp8axufFz7PoT/7cEm5Ct8IfswZtCeOYN+FspIWjMhIfQyTfl8lKLEhWT8OZ6gsq+
         KjEYIX3W+vYc2q71A/WeiKbOOv/JmxkeB/IVNpJhEiA7mR+rMj5umtx99qtizuuQjre+
         rtKtYFQTsA3ECjQLiKuJG5W5cJWpF6WaeQxU1bbWLe2O5Q8tx/lgsKXDYF3xtQ0l7h7j
         sTzuPyZJWPdnxCNmQtmd0Etrme/KKn7g6o2V8/kOmam1gWU41po7RYQAyN03vMxrNYTx
         tWm/lhMT19tgHxuvt+PWjFOgoiQmQQEr+N/35/o8KujOJ/Extf2a6qQNIFEUgcm2hva0
         qkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tI2A7wrVYPdXVz/TzeQi+IfDXKzGJ3NnGoB/TzjX3uU=;
        b=nWabVov/4lfEJu3hgdgaxDVQhu1j1gAmnySFRsPAg0g9nmNtOdqCmUxe1xjEF2St7i
         R0/x5IuTgnf5CYnFc9OQ0Bo9oFnoTWuaw43aPtRkq4ysUEITiJ3eW5YmNNtkONAAgyjm
         DKstO9/kPl9lPY92XROOBKxBWoqzyMxoxy0qSDb/RDqqGPhlCulfEmYBJ+JSYQFP8shE
         S+dh/WIrKO6SqKtsuDLK4gD8xf/Xz97DzsdKvju5eJqyeIQqMnW0EQ16uiebIiLtq80X
         +2RMywHIYauE4ECODtAYcDPycYX+OYqSrAPAnHrDim5iNO3dOzoUjVWJuxmgOj5kBQ/s
         o8jQ==
X-Gm-Message-State: AOAM533DaWVkr0ojzLbHyremuJ5vIzLXyY3GNrLRidX99687BHrXzPto
        0Q8cSCD3rJTZt51hSeF91K0=
X-Google-Smtp-Source: ABdhPJyJ5X3qCOo2hy4oJjtEYNBB8jnpwIJ9Ropkke72jm52m3EG2XdEIpAm47tjZJpJHlAe9JBUvA==
X-Received: by 2002:a62:8043:0:b029:160:b840:b44 with SMTP id j64-20020a6280430000b0290160b8400b44mr6607219pfd.50.1604769798921;
        Sat, 07 Nov 2020 09:23:18 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id m17sm4916962pgu.21.2020.11.07.09.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:23:18 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, David.Laight@aculab.com,
        johannes@sipsolutions.net, nstange@suse.de, derosier@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, michael.hennerich@analog.com,
        linux-wpan@vger.kernel.org, stefan@datenfreihafen.org,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        stf_xl@wp.pl, pkshih@realtek.com, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, wcn36xx@lists.infradead.org,
        merez@codeaurora.org, pizza@shaftnet.org,
        Larry.Finger@lwfinger.net, amitkarwar@gmail.com,
        ganapathi.bhat@nxp.com, huxinming820@gmail.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chung-hsien.hsu@infineon.com, wright.feng@infineon.com,
        chi-hsien.lin@infineon.com
Subject: [PATCH net v2 04/21] netdevsim: set .owner to THIS_MODULE
Date:   Sat,  7 Nov 2020 17:21:35 +0000
Message-Id: <20201107172152.828-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201107172152.828-1-ap420073@gmail.com>
References: <20201107172152.828-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Fixes: 424be63ad831 ("netdevsim: add UDP tunnel port offload support")
Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Change headline
 - Squash patches into per-driver/subsystem

 drivers/net/netdevsim/dev.c         | 2 ++
 drivers/net/netdevsim/health.c      | 1 +
 drivers/net/netdevsim/udp_tunnels.c | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d07061417675..e7972e88ffe0 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -96,6 +96,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 	.open = simple_open,
 	.write = nsim_dev_take_snapshot_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t nsim_dev_trap_fa_cookie_read(struct file *file,
@@ -188,6 +189,7 @@ static const struct file_operations nsim_dev_trap_fa_cookie_fops = {
 	.read = nsim_dev_trap_fa_cookie_read,
 	.write = nsim_dev_trap_fa_cookie_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 62958b238d50..21e2974660e7 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -261,6 +261,7 @@ static const struct file_operations nsim_dev_health_break_fops = {
 	.open = simple_open,
 	.write = nsim_dev_health_break_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 6ab023acefd6..02dc3123eb6c 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -124,6 +124,7 @@ static const struct file_operations nsim_udp_tunnels_info_reset_fops = {
 	.open = simple_open,
 	.write = nsim_udp_tunnels_info_reset_write,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
-- 
2.17.1

