Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA841B2137
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgDUIPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgDUIPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:15:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65782C061A0F;
        Tue, 21 Apr 2020 01:15:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so1049892pjb.3;
        Tue, 21 Apr 2020 01:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=thGbi75eI9H6DD40SMF1HwTJvOfVWIJEMRXNyWynse4=;
        b=uuZFWsXvysfTRaNfjaNktHLdGaC+R4ViOwrRc+waR108Z5186+ffblN0dncyThqND0
         uhJzSKK7pyetQL0mrO+Vd0rQJX+9JMk377CUk8zi3xYKNuoBFiIlECZE686kXPEh44RE
         D7puVGX8YEFIQxpx173oMQ0cD/0pvqz3T3RQfTM9uaahpFt+WqrJyfGtRNHHjpEznDt0
         4edFErilQJcS1QBLMjO2ZpufUHwcyw/iy3itu5mqOfYL3EIuxZWV08i2ERd01pn2/YNh
         4CYp2rbhl8suUlSPh2C9Ow6USYrXeJkbc0tGswWsjWwneXn6C8eXTkn6HmI+1hjOFuhR
         2eQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=thGbi75eI9H6DD40SMF1HwTJvOfVWIJEMRXNyWynse4=;
        b=bz8GoiQDxTvKbVWTSJ6wMINeffmnRMZYkaBL80rBlq091wZ36cVktGyUixnp/uoVUy
         h/VlFoXXNI7qYq81hN6bTGVlH5LvnV7O0xe3kfVAZG4bmd7JRK5w2VStNuX09LfozyRW
         g3302HnDMXkoh//C996lfjPr4EO8T/fBA25M7I/pQjpaymXwktIfxQO2qiBUey+R2olp
         p0EWXNmUlqJPVajR6280TDPqFuxzHC2PWluZEOXDu2By2vlJ5wBtXHxm9ukgePdEoPIX
         HnM1br3jIIIzrsjSGQR1uNOqDXBQnDF2HFEAM+XhaDaY7JWgHKcMuriXV7FwPsaFzP8C
         QIJA==
X-Gm-Message-State: AGi0PuZ5dsanfKdmeV47JrPKRz9ws2GdgQ2e/A9oEt+I+zjhr4d/cuKs
        dlkGxouDBETTzTBg/eHiCl4=
X-Google-Smtp-Source: APiQypKSiOtnIS3rCphya2m+AnNLutRTT2wHN5ptOYz3ywwjumcxaXNqxsZiufWie0q+w3FJFhNaiw==
X-Received: by 2002:a17:902:ff13:: with SMTP id f19mr2684748plj.31.1587456938905;
        Tue, 21 Apr 2020 01:15:38 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id t80sm1801569pfc.23.2020.04.21.01.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:15:38 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] xshared.h - include sys/time.h to fix lack of struct timeval declaration
Date:   Tue, 21 Apr 2020 01:15:34 -0700
Message-Id: <20200421081534.108211-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes compiler warnings:

iptables/xshared.h:176:50: error: declaration of 'struct timeval' will not be visible outside of this function [-Werror,-Wvisibility]
extern int xtables_lock_or_exit(int wait, struct timeval *tv);
                                                 ^
iptables/xshared.h:179:57: error: declaration of 'struct timeval' will not be visible outside of this function [-Werror,-Wvisibility]
void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval);
                                                        ^

Test: builds with less warnings
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 iptables/xshared.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index 490b19ad..c41bd054 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -6,6 +6,7 @@
 #include <stdint.h>
 #include <netinet/in.h>
 #include <net/if.h>
+#include <sys/time.h>
 #include <linux/netfilter_arp/arp_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
-- 
2.26.1.301.g55bc3eb7cb9-goog

