Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9504546CF9B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhLHJC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 04:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLHJCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 04:02:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F25C0617A1;
        Wed,  8 Dec 2021 00:59:21 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y8so1129751plg.1;
        Wed, 08 Dec 2021 00:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3rKzjENNvAvq/epFlb0+479WQyvQ4+o/61h3HZ+3R9s=;
        b=EG1iybwtQUPhwcFP1tTo7TaWi/COvGXEZtWpjfXDWq8Q6zC/4y7YHUVKVrT7m95+1a
         Bw291CSUa2CYaQ+v46GR6ALBPxjkssBVQre11ddk4otRfd2V+E+t3hXSo2XvceOC+7aZ
         LAbS5pUv/QI0gmIkxKc6CSDnz1Yd6RzuU7zBs0bsU8zpo7FBhvMvjV7SyKSstmMqY13t
         ZYOqpS62PSKMK2rNuGNILcrTSDLA1IGwqu3YjvChLs3LLnhVsqfk4E5cCrxL0jdvxvni
         fS4OQwAGjNLJoA7xLp1OiT4TvVYWALjKNraDgHFkPSKwi+EAZxeMOZ3QQC4qWhJLc3Ud
         +TmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3rKzjENNvAvq/epFlb0+479WQyvQ4+o/61h3HZ+3R9s=;
        b=AXuThxPuA5+iEVIno5XW+jdwVfFd9sYXK1j5f1OZZz+XLEAfp1aC+NjyBjq915UBnH
         HTGq4R57OTjXCk9dTwskTCA6rWWuWLVyizmgtTLQkX0mvEq+0wx5+njmZbwgREsRQKSY
         rMlId5VD5szVp5o5EmunraNKTllUCBR9qCAfZxBzRQgQi0hfF9CPUwSGkWUwT1LN3+Ei
         TkwPrrlCvDh+LCYVKBVR+D0g3g4MKuh9uglGzwd3eyHoBVl3gNj9edWcdU+UpO2tb5VC
         M3Rl1JMrYI+ZiTyBnVwbjtuxNnJUmT0uJKDr05OAhlbFoL0Zlw+XnD5g1iUKAmv1IoRx
         UNxw==
X-Gm-Message-State: AOAM5337j9gWxvfDkwIl/Q2QnpxdYrkF0P4GTX5gKZVnFVhfVD5ibsWY
        0w2tD2eISrzwbMb8lSWVe3Y=
X-Google-Smtp-Source: ABdhPJyrgYKY+o8ohzs5QG9Z3kRFA/6+qVMfeWexlWx9K8I9W7B3rd0Zcmu1aZZvJR7b2WAPusV+Pw==
X-Received: by 2002:a17:90a:af97:: with SMTP id w23mr5593738pjq.128.1638953961134;
        Wed, 08 Dec 2021 00:59:21 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id oj11sm302557pjb.46.2021.12.08.00.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 00:59:20 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, xu xin <xu.xin16@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH net-next] net: Enable neighbor sysctls that is save for userns root
Date:   Wed,  8 Dec 2021 08:58:44 +0000
Message-Id: <20211208085844.405570-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Inside netns owned by non-init userns, sysctls about ARP/neighbor is
currently not visible and configurable.

For the attributes these sysctls correspond to, any modifications make
effects on the performance of networking(ARP, especilly) only in the
scope of netns, which does not affect other netns.

Actually, some tools via netlink can modify these attribute. iproute2 is
an example. see as follows:

$ unshare -ur -n
$ cat /proc/sys/net/ipv4/neigh/lo/retrans_time
cat: can't open '/proc/sys/net/ipv4/neigh/lo/retrans_time': No such file
or directory
$ ip ntable show dev lo
inet arp_cache
    dev lo
    refcnt 1 reachable 19494 base_reachable 30000 retrans 1000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000

inet6 ndisc_cache
    dev lo
    refcnt 1 reachable 42394 base_reachable 30000 retrans 1000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0
$ ip ntable change name arp_cache dev <if> retrans 2000
inet arp_cache
    dev lo
    refcnt 1 reachable 22917 base_reachable 30000 retrans 2000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000

inet6 ndisc_cache
    dev lo
    refcnt 1 reachable 35524 base_reachable 30000 retrans 1000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 net/core/neighbour.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0cdd4d9ad942..44d90cc341ea 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3771,10 +3771,6 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 			neigh_proc_base_reachable_time;
 	}
 
-	/* Don't export sysctls to unprivileged users */
-	if (neigh_parms_net(p)->user_ns != &init_user_ns)
-		t->neigh_vars[0].procname = NULL;
-
 	switch (neigh_parms_family(p)) {
 	case AF_INET:
 	      p_name = "ipv4";
-- 
2.25.1

