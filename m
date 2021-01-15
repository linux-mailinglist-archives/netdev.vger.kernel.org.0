Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E162F7715
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbhAOLAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729116AbhAOLAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:00:14 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907C4C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:58:59 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id y22so9880837ljn.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=Lci0UTHpkIYsNFQBPDV1HT01WQSMM6Bf9UhKEbTXELc=;
        b=R+c5a8yFSkQnfYsgDLnuMhkKJFIgQXC7k3o4N768paLLLCKA5XLW4kAPha6iqJxcoz
         H/LMfb4qpD7PHY7UjjGEVU/3TcTE66hthS4zLQkRscw5cXGbEfzwKkaMKMKICQNR/2ao
         lGIjYP8HD039F+65xbdKxtdgZX3OB2eGK9IVnlYjG+K7yKF0NdZj5ghe0eBEUApVDHIZ
         ZMKWfEB49rmpLXQ0/q1uUBOAjcqKKurmyMFp39RYdtdRKO34EbMqCTronLBvpvFiY4N6
         k95c/tvfWcMYXzf6yFj41VXSX+lEyOEUFDb1DiFpsC0ANkMdcIl3CXN+eHECCuYy+82a
         ITRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=Lci0UTHpkIYsNFQBPDV1HT01WQSMM6Bf9UhKEbTXELc=;
        b=hFuh+GhqTHLMwWNZD4WuyxPedsWsGmSvmvt0gYteQKdHFP/0RGmrcqXHDmAJUXdc0/
         BhS8BKzaViTrjDaljlYAYkw8/ZT5SqFYHMaTcTStKiLETBwg4p3Hf9utAL+pF0ROv0IB
         qllGa2D8MoERoxSGep8zaW5WeBokk+bUxVZAz+47N0D4KmCoDgGdok9BG1F4sAoPpnnE
         Gn+gQ7iEr7vqVMugdhuKgC6lkFjBxKMEJ9nf2pcksDV0M1bdfeDi2q7qmxeCtRVuvmzW
         cScQ2Lfsv1SWwMKNhedHu8NHJUhSh6jJWxlSa58o43vwSNvYJZOfahDkTRt70vqQmlxZ
         blmA==
X-Gm-Message-State: AOAM533bjaSupGGdFTgj6ogH1aigDatnqaGwgTGu5Kd9RhpNAeZkAiCv
        k7fOkGbp6bJI4RHUwuw8NXw7ew==
X-Google-Smtp-Source: ABdhPJxR6hERgbHEox9DRwrvrtrvPj9VKMsYdkq6rXdZ18OZ6AS1IU0lvK6rKm8lTev8bdGpRekzrw==
X-Received: by 2002:a2e:b047:: with SMTP id d7mr4905635ljl.467.1610708337522;
        Fri, 15 Jan 2021 02:58:57 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p3sm756510lfu.271.2021.01.15.02.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 02:58:57 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy implementations for trunk setters
Date:   Fri, 15 Jan 2021 11:58:33 +0100
Message-Id: <20210115105834.559-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115105834.559-1-tobias@waldekranz.com>
References: <20210115105834.559-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for Global 2 registers is build-time optional. In the case
where it was not enabled the build would fail as no "dummy"
implementation of these functions was available.

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/global2.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 60febaf4da76..253a79582a1d 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -525,6 +525,18 @@ static inline int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip)
 	return -EOPNOTSUPP;
 }
 
+static inline int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip,
+						int num, bool hash, u16 mask)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip,
+						   int id, u16 map)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip,
 						    int target, int port)
 {
-- 
2.17.1

