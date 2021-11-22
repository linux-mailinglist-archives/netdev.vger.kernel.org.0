Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D519F458799
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhKVBHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhKVBHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:07 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65162C061574;
        Sun, 21 Nov 2021 17:04:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so69450271eda.12;
        Sun, 21 Nov 2021 17:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ftwtbT4XbFCZQT7VPD4psqcTJwSVlgyOn3T1ZZZieSE=;
        b=dcHDL3FqGM4oi7vxyJJk6CQuIalYkB3g+5bB/kcBOM1GAwF7ZuqV90buOxmdCRL+yh
         w0UyDkvAZTRdTTbJrSFyf8M8eaFwjIg6nJpQqYiUcWDuD/qXNR38RHmOWuPcxChX+mzB
         hlSYwBQChQvVuuTEaHpjAPeogfGfeVLt8ObHzJ9eBi+1sljkMuteXCdhLQW2EVt+kwtK
         9j0kXdsimb+34BYHmStC3Xgv/bf//WaV8TzkU+5fDIhemP6tilsGkSg3H2EtVGWhF6/e
         nqyCwcSZgj1wt+X3GJ7W/0qtnHroE0NOc5TVC2zF/jgBGtfeeu8shGBtcysRiLz/q8O1
         P7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ftwtbT4XbFCZQT7VPD4psqcTJwSVlgyOn3T1ZZZieSE=;
        b=LLWMg3hkZ4iDIhEQ01VCtO2GMdu8q/ca+PCFoWSjX5DTgm3svPhwxLXK+Myf6BoVYU
         57qBK8YHXQbUiXxc04cKHU6F+S3uJCpNaei5aqkFSqkT/XO7EZDijGnElzyNrTyP1TIS
         milRPZXDGEd4w6Aaa69C+aAS6LDwwUvDImxy+spWW2HRfARDYSt6MuYdpzWzzckdSQ8Y
         Zggo2AGEDIaX9r+IlJOI2pMSlwr19oIVRDvhNznH+TvDsCp3etlNsun1k2z5q4Z7pmm0
         N8ZV/ncKiisx8SVdZ2DFgVheG4xjA8asT0lnVqqsmzajUkFJKeQW18NSaoQvo1mlpYme
         KfsA==
X-Gm-Message-State: AOAM533ZNf768uJuVPNz/lolLBqmPuAXZ1UgOXZYi0xi9atq6XTlOH6o
        tqKT27o/GJzPCNxcfqVOpt8=
X-Google-Smtp-Source: ABdhPJyowNujOYkuvEf1oABcVHysHmifY25Xonm+eE92jaUlAYp+7EEtS8NSpNVGjJKfSy2NBwY1WA==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr59764243edt.168.1637543039932;
        Sun, 21 Nov 2021 17:03:59 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:03:59 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net-next PATCH v2 1/9] net: dsa: qca8k: remove redundant check in parse_port_config
Date:   Mon, 22 Nov 2021 02:03:05 +0100
Message-Id: <20211122010313.24944-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The very next check for port 0 and 6 already makes sure we don't go out
of bounds with the ports_config delay table.
Remove the redundant check.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 147ca39531a3..783298cf859f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -983,7 +983,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 	u32 delay;
 
 	/* We have 2 CPU port. Check them */
-	for (port = 0; port < QCA8K_NUM_PORTS && cpu_port_index < QCA8K_NUM_CPU_PORTS; port++) {
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
 		/* Skip every other port */
 		if (port != 0 && port != 6)
 			continue;
-- 
2.32.0

