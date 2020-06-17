Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA2C1FC8AB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgFQIbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgFQIbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 04:31:52 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D972BC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:31:51 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n24so1779393lji.10
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUl9pfAsz4Si0tDa+sd5wm5SlXtGYBUK2ZIBc7MpVLM=;
        b=n8WepE2L4ZYHeJ3Oly0QADCCSjNV4KFQT8lLQt9YfomGx5PPbudefe/qiY0ZFC9LTg
         ViJB2HhPuGPnDnMO8ApltxYtM3ES9pnH7R99SQFyFD7XSs0XoYrFt6SPULvKwoFB7PEz
         Vv5QWjzC8Y+XcBGHS5HtWEtYAxtyeTIg/bwTBFEwbYvIcSOe1Qj8gbWSPetTx7956r7n
         fx3fGJJXNuwzC0DePWI+EicfW49reDZd6eus6/GAuZ9MShP1cPb6DS2mhK2pRxp9a11p
         3aWq7yn2TK080NkuhCR8CZ89nZYRpFydWV4OrdpQ5KKf8a+pwdWsRI26ZXmMv5FKAN1O
         C1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUl9pfAsz4Si0tDa+sd5wm5SlXtGYBUK2ZIBc7MpVLM=;
        b=niSwXEAwio6/DtOxnoUGkguyWBYaoem0wZ/lJ/hpZrrgJXhreVdBWc0HP1inera651
         D/cQanR6i6O/q1KjLvFtp8sR1E5vxxji/bK03NDn/TkXXiJcJmNzH4mILWZ8YM2Ky+QX
         ji+fk6TimTOABoFhzM8vePHdB2VYh6KQOxmaAwiP/99GLFFpo9/J8VuvZ8S56VATOVjI
         djdsdDNmFLDRseAThoTtvrcCNfALMFeR+GTJlj1/6k+A2YJhIMMxqPr7nGpwedFNSZRm
         bQypBzMOOkU9TAMvLEVXU6KvStcmtUO0x6Vioe5uiKgUczCn+9AtIuV2P4XG1zAvVF58
         kLhA==
X-Gm-Message-State: AOAM532I2loObhFZNXnYtAgPhw+eZfw945tLC0SZmVIQ6vuKcAVtBdBu
        7O3gXIBgHdCb2nwDddb8ug9gNA==
X-Google-Smtp-Source: ABdhPJwrrHzQMYHkP3uVyA+oZqep0Fw9qywn4alMakDlUtOzRLyik9ItjvOtfwTO66N5bMDZ9fX1Kw==
X-Received: by 2002:a2e:b5d0:: with SMTP id g16mr3315702ljn.246.1592382710371;
        Wed, 17 Jun 2020 01:31:50 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id c3sm89554lfi.91.2020.06.17.01.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 01:31:49 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 5/5 v2] net: dsa: rtl8366: Use top VLANs for default
Date:   Wed, 17 Jun 2020 10:31:32 +0200
Message-Id: <20200617083132.1847234-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617083132.1847234-1-linus.walleij@linaro.org>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8366 DSA switches will not work unless we set
up a default VLAN for each port. We are currently using
e.g. VLAN 1..6 for a 5-port switch as default VLANs.

This is not very helpful for users, move it to allocate
the top VLANs for default instead, for example on
RTL8366RB there are 16 VLANs so instead of using
VLAN 1..6 as default use VLAN 10..15 so VLAN 1
thru VLAN 9 is available for users.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Rebase on v5.8-rc1.
---
 drivers/net/dsa/rtl8366.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 7f0691a6da13..4e7562b41598 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -260,8 +260,8 @@ static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
 	u16 vid;
 	int ret;
 
-	/* This is the reserved default VLAN for this port */
-	vid = port + 1;
+	/* Use the top VLANs for per-port default VLAN */
+	vid = smi->num_vlan_mc - smi->num_ports + port;
 
 	if (port == smi->cpu_port)
 		/* For the CPU port, make all ports members of this
-- 
2.26.2

