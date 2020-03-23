Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F3196729
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgC1Pqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:46:40 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55268 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgC1Pqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:46:38 -0400
Received: by mail-pj1-f65.google.com with SMTP id np9so5236959pjb.4
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/F5soHZdX+upsGd/QwghyKOQFTKWDBPpvRaxS81m59o=;
        b=fgT3adn0fs7zZUrYAXaxjm17QmCkgA1prZ9HdbFtvgsnyMAVvvPQnlVzKvAu6Y9HrQ
         c51SHqnG4rcvxUqlK3lTF1QLJzSj8nKQkCS2XSqIzj7G/LcblWNEWUNuF/qJU3O1SIZR
         xCtTQjbVLmKlGngezpqy4rYKBqj0FE7HjzxYaRtjilWZSVpfdpFEojpFpHrSU58aDhtD
         rkXNrGqqcoC5IjUCSEgmwEuZoHfIIe3Y6jHwCzITUJycFoJDzDhmNI4IW+rTpKW1eYgt
         bWclqxfYm7yuhuYCV4ksFhQBH8kHbu+Z93nyuPe5SKX/3WNZ7DMJGNe2hP8wym2ZD+3n
         +MVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/F5soHZdX+upsGd/QwghyKOQFTKWDBPpvRaxS81m59o=;
        b=nkSCkRHtmgDSuwBBT+IVJRWVLgxPWUlJTN22miMz/uvUcPRIGsDYp1o13a/20fdpse
         QJGE/+Zfx6l4a/uGVBCEb3F6UMNmPOv/E/OYHqHNsJpyQIdTH/WPDVh0w0O8voa6Ixs6
         4ETmkGIC0LCtCLeak0+vghdy+t7JXvW4fUxRgYDxJ+THW9GLIf/HycX99Vo9iPAckXYC
         SPzuvJlq4zpZuswhukgMQJm8XpqeDEyuWr6fMuFyOpH1Wwg6hdNZ1Mn7MKz1G6wtG1bB
         gL4bsT9ONQU9fCefLCkfLcD471iaNCU2eo1dbkAdNtSoOn3ewFFaHATH6KJMXlnO7qM8
         1wPg==
X-Gm-Message-State: ANhLgQ3QZLeDKnF7RhWnYIEKzr25NrcbWRBpNlchnWzdpmiHCBOjXK9a
        niEYHgSaw5//2TQMzBy+pKc=
X-Google-Smtp-Source: ADFU+vsZNBWoCb5qSXtAEzHIqsSU7xXoLzKUGeFJMtO1JC865/HSednvyZjt2Nl4Y4b7qCy3YESQNQ==
X-Received: by 2002:a17:90a:218b:: with SMTP id q11mr5534138pjc.163.1585410397779;
        Sat, 28 Mar 2020 08:46:37 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id q185sm6375218pfb.154.2020.03.28.08.46.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2020 08:46:37 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Andy Zhou <azhou@ovn.org>
Subject: [PATCH net-next v1 3/3] net: openvswitch: remove the unnecessary check
Date:   Mon, 23 Mar 2020 21:10:39 +0800
Message-Id: <1584969039-74113-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Before calling the ovs_meter_cmd_reply_stats, "meter"
is checked, so don't check it agin in that function.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/meter.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 5efd48e024f0..03b39b0eb4ea 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -212,12 +212,11 @@ static int ovs_meter_cmd_reply_stats(struct sk_buff *reply, u32 meter_id,
 	if (nla_put_u32(reply, OVS_METER_ATTR_ID, meter_id))
 		goto error;
 
-	if (!meter)
-		return 0;
-
 	if (nla_put(reply, OVS_METER_ATTR_STATS,
-		    sizeof(struct ovs_flow_stats), &meter->stats) ||
-	    nla_put_u64_64bit(reply, OVS_METER_ATTR_USED, meter->used,
+		    sizeof(struct ovs_flow_stats), &meter->stats))
+		goto error;
+
+	if (nla_put_u64_64bit(reply, OVS_METER_ATTR_USED, meter->used,
 			      OVS_METER_ATTR_PAD))
 		goto error;
 
-- 
2.23.0

