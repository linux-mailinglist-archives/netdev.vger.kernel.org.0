Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70B95AB95
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 15:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfF2NeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 09:34:09 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:32951 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfF2NeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 09:34:09 -0400
Received: by mail-pf1-f173.google.com with SMTP id x15so4355386pfq.0
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 06:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j1gRPzC1UG1cQR3lMYY1rnk/EyCJk9RIr5pczce4Di0=;
        b=eb6DeAgAgTDxh3BJeZK/rBq6I1zpy9/MEO0lNJJpOOXTW2WE/kncW06V3Vmcm/6alG
         k3xKONp68Yyk8F8ISpAX5YdwfFokQJnp7D4sS4mIMWZRZ8G1UbaETVVqv+PRwTMfdaOH
         xQwbXtp2J3GUwuknO9x9MDNkMRiCDZ+qLv1umj+M1wsBYo/OS2GxO9ymhRQiK/SjU5kM
         vB9yN8dckII2GBySWPVwqr/NqZ19xVPpg/qekTmH8Wfw48V9Crc2qArPYU8RiEZ9ffHw
         yYxDsD24WrMPVXMHo+WuGLw4Tr3bB3C/HqFFvTsOF1Ip4EHQb9gcbi++oruWAvNgv7Pu
         jDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j1gRPzC1UG1cQR3lMYY1rnk/EyCJk9RIr5pczce4Di0=;
        b=m/u3qS99ZLLX4YW8W9+49PfebH7y1OXhbgDYVYZKgzmSejQI0xh/ZhunQHroAfJDzn
         qa7x+coOk4U859iuPKxZ2X2aWs+Bo6YfRObIoAnbuXicNIPiAIm/ZckAu3mRLmp57tqT
         JwkwkN2EwJ3/Ps8CbhKtPBCQglSgVd7F8u+AxAz5/de4esgZamHkuzXAi2t2+rPmIS+1
         WnC0XHZdk937ehOc016vNLeaHC9rI2LS1BxOr4VHOd+BFpLn1mLZAIf/rjrraaFRjqOX
         WZmNHUQHj3FKNBpQA9InoV3/J9qxL2pRFqetPtpJI0rQFjekyh2toWHIpUnDBaOU/7rM
         SsZg==
X-Gm-Message-State: APjAAAUXPu/+unrn4Byi0O9oZ3dTRVGlAuZcbkN3695h5mQZvW7/RB+t
        Ph43Doy8Ehm9XvNx7BHckf2uc+o3yw==
X-Google-Smtp-Source: APXvYqwJrMgMCfocovMrqU+mIQVezmVvBRsI+yJyd+jazoe4NY9Deji/+MR2rQO+yXdJFFiz02zYeQ==
X-Received: by 2002:a17:90a:d14b:: with SMTP id t11mr19500775pjw.79.1561815248042;
        Sat, 29 Jun 2019 06:34:08 -0700 (PDT)
Received: from localhost.localdomain ([58.76.163.19])
        by smtp.gmail.com with ESMTPSA id d9sm4686148pgj.34.2019.06.29.06.34.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 06:34:07 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 1/2] samples: pktgen: add some helper functions for port parsing
Date:   Sat, 29 Jun 2019 22:33:57 +0900
Message-Id: <20190629133358.8251-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds port parsing and port validate helper function to parse
single or range of port(s) from a given string. (e.g. 1234, 443-444)

Helpers will be used in prior to set target port(s) in samples/pktgen.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/pktgen/functions.sh | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index f8bb3cd0f4ce..4af4046d71be 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -162,3 +162,37 @@ function get_node_cpus()
 
 	echo $node_cpu_list
 }
+
+# Given a single or range of port(s), return minimum and maximum port number.
+function parse_ports()
+{
+    local port_str=$1
+    local port_list
+    local min_port
+    local max_port
+
+    IFS="-" read -ra port_list <<< $port_str
+
+    min_port=${port_list[0]}
+    max_port=${port_list[1]:-$min_port}
+
+    echo $min_port $max_port
+}
+
+# Given a minimum and maximum port, verify port number.
+function validate_ports()
+{
+    local min_port=$1
+    local max_port=$2
+
+    # 0 < port < 65536
+    if [[ $min_port -gt 0 && $min_port -lt 65536 ]]; then
+	if [[ $max_port -gt 0 && $max_port -lt 65536 ]]; then
+	    if [[ $min_port -le $max_port ]]; then
+		return 0
+	    fi
+	fi
+    fi
+
+    err 5 "Invalid port(s): $min_port-$max_port"
+}
-- 
2.17.1

