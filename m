Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4920E1FC282
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgFPX7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFPX7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:59:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B250C06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id x93so513267ede.9
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYXlLktXgh1IozVgTcr+cHrspDkRD6hvOAJxOY44O3c=;
        b=EvP5up8KkfJua9l3r7kYkyHQMtvv63/WURhJ2fMjF90EAdBNkFZQJlgcU5wLQ+xQpe
         WSkxni0672Fzsaj39CxisziGjLQwArgckKJDzXLw81I/hRthOmgNnBQ/xV1hJmZj3v9v
         hwaw2jYGskKad5pDeW+pT+EN0MMXv4IJyivzl50fRU01bFOMf7nxQWb7Hstj2FT/oZ9W
         GqUv1MZnpmHg60R1VXIIFIDqgDN6GsGXBcTFBnVv7NRiZ6JeRJdTae/99YIyIrHEy9Mj
         IXoupXBWkuZzAgc0F5x2dBuZGZzcWw4pdDRGEunucc2pYZrecsOWgN9ul58zBSmufQm7
         SLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYXlLktXgh1IozVgTcr+cHrspDkRD6hvOAJxOY44O3c=;
        b=ZlYDLDMrzZhzAc20GtJOrVFoC8C/zz4JjM88RApreMDqeU5x5BztAXgZJjjJSxMDhb
         IMQr18WNrG4gI6KY7FVeVY/KjAogm5yJdQgp4t5SiiErjw9AV0keweoqcISwOdsP1LI2
         sgdc8gJJrHrwDgErgZv98GTyRDm6AHCCoRtADsCJZw8IsFKekLhoYaZ1sMn1/FEzMfMZ
         up5xK98nYgZ/2GmM4y5w612hGiCbV5FbwG1GQbnitIqeJTOMTglh7TdKBSm7c/Q5aeXx
         QT3SxRJLDopgxA8Vvs2VehOYFGOAxMmlTYVjBMqYMsEfRK/4DrEelRiuhibqG5aGHWBJ
         1Teg==
X-Gm-Message-State: AOAM533n5IkhH2OSN48W1YYHWxuxbfPk9ipINM4C/sD3lZ0cdNN8hbgt
        B93jbR4zobcGjD7RqMLhlK66YiK2
X-Google-Smtp-Source: ABdhPJxrFMn7PuxJaQT1h5LNcofjsh9jg4JPOfgO8Hj0RF5iKCNe1o126HRyYRGFs97sqFBQjKMy9w==
X-Received: by 2002:aa7:c80c:: with SMTP id a12mr5020457edt.140.1592351958902;
        Tue, 16 Jun 2020 16:59:18 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o24sm11814123ejb.72.2020.06.16.16.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 16:59:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH net 1/3] net: dsa: sja1105: remove debugging code in sja1105_vl_gate
Date:   Wed, 17 Jun 2020 02:58:41 +0300
Message-Id: <20200616235843.756413-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616235843.756413-1-olteanv@gmail.com>
References: <20200616235843.756413-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This shouldn't be there.

Fixes: 834f8933d5dd ("net: dsa: sja1105: implement tc-gate using time-triggered virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index bdfd6c4e190d..32eca3e660e1 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -588,14 +588,10 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 
 	if (priv->vlan_state == SJA1105_VLAN_UNAWARE &&
 	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
-		dev_err(priv->ds->dev, "1: vlan state %d key type %d\n",
-			priv->vlan_state, key->type);
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on DMAC");
 		return -EOPNOTSUPP;
 	} else if (key->type != SJA1105_KEY_VLAN_AWARE_VL) {
-		dev_err(priv->ds->dev, "2: vlan state %d key type %d\n",
-			priv->vlan_state, key->type);
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
-- 
2.25.1

