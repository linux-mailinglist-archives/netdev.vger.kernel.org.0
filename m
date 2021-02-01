Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5526530A212
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 07:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBAGit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 01:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhBAGZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 01:25:46 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB53C061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 22:24:51 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i63so10890651pfg.7
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 22:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOdBCHpPzgArsZVnKI5l1t4Q78kDQCrwxd6+9upvr40=;
        b=F6x8RvSrR4xG5oCcyeyswuugL18g1/5Ddn0OD5tO86zVRs7IL6eLDi3Q7Oq54yENBr
         JkVACLF5d2avGBMY7xrlWU1PxO1gZgib6MHJFp0xNeotpDQAlIrnuymBgIMgmJw8wpNw
         q8vJyI8leg9WV0ll9Oe66qgSLvPaG6tw/sScRPUtQ4wzhnjrVOT9GXJnOisr22gP4exY
         SsyMJmHbYaIfj4mocXRhshdcTVpwBdVAPls3XD9DZv9fPuQH66o/2GChZPw/MAzjntqD
         mTn1t8Gbt6zL70t1A1IZPVyQDNnPTFJOL1VSC0QHcGOkGI5jTSp9isZnJ9lyjLnaPnAH
         5JKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOdBCHpPzgArsZVnKI5l1t4Q78kDQCrwxd6+9upvr40=;
        b=Xf1tx9MkOHb7ssGkWVhS1FAaAheZ0MSR8W7eUZnt1MaoQmjztm3G+wA898js9qWbr+
         afRJ/tAY7lDqOIAfrFTV5xR9T8L/FTqnzmar4XdtqIcByiRADIkzgC8nJvilQBm2dXvp
         3WIF/go5rOW9goYwfQZKGlzKrYw1xOwM+wp6OgkjPJhDnNgFo8DUFOz6PoWN85KNY6LD
         iMvalmXEpsWRi4YoOMMr1ldjJNPdtF377i3vJQNeIDnevrFCkR1oDnfAwzzwpZPSQbS1
         A5MovpOegojslkrnmzTCUrEPfe9zuXAhysIYjkXdAXtleCliAMgkLiOYRX74dJ66KxZG
         VCnQ==
X-Gm-Message-State: AOAM530R3Z2ozTiUdQCngq0bRfOm52POl542SCUT/gYrYLCYJEJg6W9q
        F+mFPTZ8/rLjugjDX8Uoitc=
X-Google-Smtp-Source: ABdhPJwiNdT6d87Pa0U1+LWB9zj/DIwifiR1cosdb57aiRLUZTiTaeoTjfbnJ+CacMybquu8iBp+RA==
X-Received: by 2002:a63:150b:: with SMTP id v11mr16165636pgl.183.1612160691299;
        Sun, 31 Jan 2021 22:24:51 -0800 (PST)
Received: from container-ubuntu.lan ([61.188.25.180])
        by smtp.gmail.com with ESMTPSA id br21sm14961198pjb.9.2021.01.31.22.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 22:24:50 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [RFC net-next 7/7] net: dsa: mv88e6xxx: Request assisted learning on CPU port
Date:   Mon,  1 Feb 2021 14:24:39 +0800
Message-Id: <20210201062439.15244-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

I've tested your patch series on kernel 5.4 and found that it only works
when VLAN filtering is enabled.
After some debugging, I noticed DSA will add static entries to ATU 0 if
VLAN filtering is disabled, regardless of default_pvid of the bridge,
which is also the ATU# used by the bridge.

Currently I use the hack below to rewrite ATU# to 1, but it obviously
does not solve the root cause.

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b99f27b8c084..9c897c03896f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2106,6 +2106,7 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	vid = vid ? : 1;
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
@@ -2120,6 +2121,7 @@ static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	vid = vid ? : 1;
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
 	mv88e6xxx_reg_unlock(chip);
-- 

Any ideas?
