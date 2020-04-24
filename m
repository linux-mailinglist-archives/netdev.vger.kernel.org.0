Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AED1B759D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgDXMnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgDXMnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 08:43:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B310FC09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 05:43:22 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y25so4747614pfn.5
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 05:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LEHU6fQ/55FuMiAYFvoOaE9pfq2R56vwMl/GwXyNsKE=;
        b=gATHElsVbDXwcH3icGAVQmZS4Hxg05cQztFHhkrGbNziqnJ/dI1jgLgxeUK93vP2KU
         DEonWzF1IQ7jXIyw2IhorMi65s36dbRfWSZJ1PeVeH4gG4lQjar9sc5l1FhLqz0KeV+x
         00vTwLpN7hykygRzaT2DYk2/2pCiJW55WCzAH3CSEczGoL02hmAMZ01gDaQVO85VRDs1
         UF1Y4SCsIAr7C982JWYqDrDkIdCpSbT78NmlAb0kgF3xZv2S8liWqRQJ7PyL0EPNlnsS
         0p72026sKu5oVHEdxeIZnsMJSyLK2emCJ/keBwllcoa1nE/fYzUrO1SEhJY5DG80zHP0
         uxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LEHU6fQ/55FuMiAYFvoOaE9pfq2R56vwMl/GwXyNsKE=;
        b=ZYDYd8xBWdObI2pVVg54q/Y0z6/ooNe9nqptF5mcGIDySR8Bg3lKsYl7mpZRKEIpkf
         nz5P+2eAdWEm4jip7sGQIf9E+cPo/DCGpTZtMgE/ubuJQ+Ww5t2+1kz4DEOxAjiiIt1Z
         w6FUWsk/2Mr3/GkqFbKx+hLkn5gd5qMJXU7NRKUsh3guGNdJLktujw6/sxz0kAVqx0uk
         qMNzU6FnEixjwr4gmJ6EW+SF2Niv+EjBLgCmqrLYuC1H5Gua/sSzTvUe6yFTUWmA5Nwv
         73v/RpznJX4XdAldtweRqPjU2ljM0RIBsw+cciyjeOZC3Czez1vpnXAUYPGqRkeZoxPL
         K7iQ==
X-Gm-Message-State: AGi0PualYSIxuWdIFUhHYCygr5bOYDhw6Lv7gpD1BsvFbvpTefnirP+A
        wvfqq2bNN7kjvA3xfwxyjQI=
X-Google-Smtp-Source: APiQypIF7yZznWnUrmjMo29bJz9egc4fxKg00J3hefQSnFtPGfoTY66jt+HAKLLU8jQzGeXHOg5pjw==
X-Received: by 2002:a63:e050:: with SMTP id n16mr9157010pgj.93.1587732202093;
        Fri, 24 Apr 2020 05:43:22 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id z190sm5652487pfz.84.2020.04.24.05.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 05:43:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] hsr: remove unnecessary code in hsr_dev_change_mtu()
Date:   Fri, 24 Apr 2020 12:43:09 +0000
Message-Id: <20200424124309.29931-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the hsr_dev_change_mtu(), the 'dev' and 'master->dev' pointer are
same. So, the 'master' variable and some code are unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index fc7027314ad8..cd99f548e440 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -125,13 +125,11 @@ int hsr_get_max_mtu(struct hsr_priv *hsr)
 static int hsr_dev_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct hsr_priv *hsr;
-	struct hsr_port *master;
 
 	hsr = netdev_priv(dev);
-	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 
 	if (new_mtu > hsr_get_max_mtu(hsr)) {
-		netdev_info(master->dev, "A HSR master's MTU cannot be greater than the smallest MTU of its slaves minus the HSR Tag length (%d octets).\n",
+		netdev_info(dev, "A HSR master's MTU cannot be greater than the smallest MTU of its slaves minus the HSR Tag length (%d octets).\n",
 			    HSR_HLEN);
 		return -EINVAL;
 	}
-- 
2.17.1

