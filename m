Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE30F382441
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 08:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhEQG0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 02:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhEQG0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 02:26:35 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1D8C061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 23:25:19 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id r5so7067871lfr.5
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 23:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MS9Vhs75KWNOhxZcqo0I/7ZX2jDFzPzc/s1h9IK+q4Q=;
        b=Gj+SvStwJaesnTQJJyIRlAfVBS7FDD96AoCOA7vGprD2Ht2dVj/ht5EsdlXVwBA4eQ
         tcTKNolon7SGCUnwlwWGuQBDHoD2bvEx7c7qVMZI4r3BLb80jVuFlY9chwYB2r5j8/ZY
         6CQ77SChuOU6AWMJpVdv5h2W1G9zIoWaLCBETOsctmBjG+mpxFplT98kulbI6NgSMzPn
         OhgGkFwktxM6aB7KInjcHnWAbi4L/8RE7B89aGWWOQNw9yhbmn3q3UHx6ty5bOB7t3Ta
         7Vb5gj48wbVNpiceXb0IuIxaU7MZuCcG8wJy5PWyVEbhOPu9gYLLXnrJx4BKn4tXI+lu
         hAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MS9Vhs75KWNOhxZcqo0I/7ZX2jDFzPzc/s1h9IK+q4Q=;
        b=B6WZTsW9T4QjDtWx33FJwRHGovNUl+CDQahY0nsIe3N2Ew6quvmGgYXO6JNdhDTpVq
         4wtFypktQsCMrPnmxnpIlmY1VbygtJuaeHNeg3HWYcrEBsgYp1LC0KwH6cU2xMfgkBQs
         K6N0atg3GrsbrO0DtlKshSjj2GgSElt1PW6Lh7oVn3YaQyXdPal6fTBh+Z9agCu/LSAo
         +iKTvplmvl4+fBsT5csQkkmATyWoFhuHaRDp/6RX4KuJqg3Fs4L1rUpYAKPcbjTFyoq0
         +lelN2NDcDN+IP2QU8YaV24HMBL35dIYHng5XWhqJ+/axwzAn2s2cgPhmlMANUkdhoo5
         xeiA==
X-Gm-Message-State: AOAM530Pw+wn8Okavu4BoW92F4K36F8xC1tlGPbo9xOaDBWf6oqKPwFW
        tBiA600Y56YZ3QbHOTlr+vZhHGhwTxtiBahf
X-Google-Smtp-Source: ABdhPJyWQtB98VF0vPYIPeWdFGsxIUVWZ661oIcDxHSeJqeLkvKYtwC/YKTEjN8yF+BP/nu63GBbvg==
X-Received: by 2002:a05:6512:344d:: with SMTP id j13mr40456116lfr.369.1621232717591;
        Sun, 16 May 2021 23:25:17 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id l3sm1526978lfp.159.2021.05.16.23.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 23:25:17 -0700 (PDT)
From:   Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mv88e6xxx: fixed adding vlan 0
Date:   Mon, 17 May 2021 09:25:06 +0300
Message-Id: <20210517062506.5045-1-eldargasanov2@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8021q module adds vlan 0 to all interfaces when it starts.
When 8021q module is loaded it isn't possible to create bond
with mv88e6xxx interfaces, bonding module dipslay error
"Couldn't add bond vlan ids", because it tries to add vlan 0
to slave interfaces.

Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..961fa6b75cad 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1618,9 +1618,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
@@ -2109,6 +2106,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	int err;
 
+	if (!vlan->vid)
+		return 0;
+
 	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
-- 
2.25.1

