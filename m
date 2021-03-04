Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917E932D400
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 14:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbhCDNQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 08:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbhCDNQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 08:16:13 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB40C061574;
        Thu,  4 Mar 2021 05:15:33 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e10so27361894wro.12;
        Thu, 04 Mar 2021 05:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lbLQAj1l1KBb5Mb5KKbveCqfWlhpna65plxQzaLC+VM=;
        b=Hh0oiY3+21qTAGApm81uCftDnwItsMwLPjnO8r2wyX2xDBZWdT/tYnrqpmyK6t8H7y
         vVr9B+9xpOyWUhgE33nt8h3Iay/MnTwoL5WrGkKmLdWUlec7opTiHJevUHC5w8HFprcT
         Vt0QYv7geI93jXYJRvBUFRTDYFi9lbyjV0mgjEr8cyQrSexv1qjDyzMnK0Xezuq9OSDH
         buABrvEFTOYJC0HiDKhZitZw7ydf7VfEH9HVitJtOWsYoRZpxuaDjVy3kieIvPVkEbmV
         n6DrKkNjaJe9WaG58egSqScQYKXwNf1ftCi7LIXbDW9un/pMg/OarNfT3KrALhOByPNI
         gTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lbLQAj1l1KBb5Mb5KKbveCqfWlhpna65plxQzaLC+VM=;
        b=KOO4GG3JUgypGvFERFDk7rcPgfVhNlREpjpPkz6xf7/AD+4q6QfDIun69042TA2nrK
         u+Q1bxTHAcHmN6m9XgyCcgOdzltoQsDwTdSrDxhSz4OeHBjwVPG0ctn4X2LsGPbxOBE5
         0YWrSIc0IW+wtjb8reU5dmFmNJ6lUxc2Aqe+lKcG7JiA4DdWAdzq2rcVw9AYV9kj6uGJ
         HEylTV881wfWeqivdnPzXUoAALdtWY7FFskHsoVn6SoRdh2e83oVDTvjOGeMIHewUvCV
         hZI8+UECjL0wlNBX1GZ7itgLd0Eqp6a1xsMjlvJt+a/R2dv/M/oMnxaG2vPDqBt5b1cl
         VDaA==
X-Gm-Message-State: AOAM533YDqv6sb6mLFEwAV8HXk9XWhclWiLRdYVM/2ChedWA5/yORd0L
        QZeu8iLsJEov3WIjlGQqsSc=
X-Google-Smtp-Source: ABdhPJzafVEvpDp33dSIi5+gqz3ksEeDDkj8r7OBAwyiK9in+lUgMP+OyhuvUNlgiPMistgAglJ0Fw==
X-Received: by 2002:adf:82af:: with SMTP id 44mr3813323wrc.279.1614863731974;
        Thu, 04 Mar 2021 05:15:31 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id r26sm6103687wmn.28.2021.03.04.05.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 05:15:31 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: qmi_wwan: allow qmimux add/del with master up
Date:   Thu,  4 Mar 2021 14:15:13 +0100
Message-Id: <20210304131513.3052-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no reason for preventing the creation and removal
of qmimux network interfaces when the underlying interface
is up.

This makes qmi_wwan mux implementation more similar to the
rmnet one, simplifying userspace management of the same
logical interfaces.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Reported-by: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 17a050521b86..6700f1970b24 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -429,13 +429,6 @@ static ssize_t add_mux_store(struct device *d,  struct device_attribute *attr, c
 		goto err;
 	}
 
-	/* we don't want to modify a running netdev */
-	if (netif_running(dev->net)) {
-		netdev_err(dev->net, "Cannot change a running device\n");
-		ret = -EBUSY;
-		goto err;
-	}
-
 	ret = qmimux_register_device(dev->net, mux_id);
 	if (!ret) {
 		info->flags |= QMI_WWAN_FLAG_MUX;
@@ -465,13 +458,6 @@ static ssize_t del_mux_store(struct device *d,  struct device_attribute *attr, c
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	/* we don't want to modify a running netdev */
-	if (netif_running(dev->net)) {
-		netdev_err(dev->net, "Cannot change a running device\n");
-		ret = -EBUSY;
-		goto err;
-	}
-
 	del_dev = qmimux_find_dev(dev, mux_id);
 	if (!del_dev) {
 		netdev_err(dev->net, "mux_id not present\n");
-- 
2.17.1

