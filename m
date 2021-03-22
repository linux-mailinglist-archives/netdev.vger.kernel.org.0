Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4BB343FD0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCVLbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCVLai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:30:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE169C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:30:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w3so20627833ejc.4
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CrSA+wiijQAKKKT9DLkaZo0kNL81nTfatd/dZH6KY5k=;
        b=D33fZc//sYei/31Amus1LciTQ6o812Y1vyjwFClIOd2s6ijLIZCW6LEPI32d4NB4lx
         OlISpHqXr5d2DQMblS0zAD8l7ERaGtPGBpMCs0b8jfgQx77REgvLt/uv34SE81v8gODd
         1vkGFkyGOCNz2OW7M4rh9tkQtEJNgA3G7UEjU1nXnmMQRkX2Fc2TL/jmq3CZ8+4QMAye
         1o07BYWuVHNglckJszEEwNnBnakrYEI6Id+Q0Fh9HplCJDc94prmHopH2lfB5xMxMjpI
         KWYMpVFmJcK8RwxE6ydxSh31zpJfxcXb8AkQAa0uChkJO6Zm1MSzGP5apJGaqhUyCPEZ
         Y+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CrSA+wiijQAKKKT9DLkaZo0kNL81nTfatd/dZH6KY5k=;
        b=Uyrjkqi1i6k9/Ol4lXSpcedT/IUJeJeq9TKoIY1fFRI7xeXROF9lTdljZ5mUfpRl+X
         FeutE22eLBb9OsfiCO830hz2ErCjCJuE0hfJowzHWGqSYBTGgi4G5NV/CJmHoNu0x4Z1
         +vGsV3+1fO/HjvL4wwtOqw3r16XR81Bu1bQcGv9m6wzp99z+LsMpGmQKNXeZYjDC/UAw
         pPhzo9n+uTJldHLGDT3/dpTInWf1ef/ayzYy52PcI9SEZA1swOD6E7ysv/PZgFTERGRi
         GnxU59+trA7G7ETggytMJgfdzTnZeOY0pORI47jjbdWUDDagxEjcyH1+DFv4SUJ8APSy
         VDkQ==
X-Gm-Message-State: AOAM5308CtSqC46pW+0kWStsHLyfZvr8VUmFkutAlNt+wdwJgOmulsqP
        4t1wrD/mKVmUsIcUdO3eFO0=
X-Google-Smtp-Source: ABdhPJyXKHN+Nyq1F5UTg39T7R/Nv+W/FSF9GEsf85NaXMrJfEMwY9cV9zhQK067KsAn3AtfZDa71Q==
X-Received: by 2002:a17:907:9862:: with SMTP id ko2mr18398449ejc.222.1616412636773;
        Mon, 22 Mar 2021 04:30:36 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id m14sm11380569edr.13.2021.03.22.04.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:30:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>
Subject: [PATCH net-next] net: make xps_needed and xps_rxqs_needed static
Date:   Mon, 22 Mar 2021 13:30:19 +0200
Message-Id: <20210322113019.3788474-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since their introduction in commit 04157469b7b8 ("net: Use static_key
for XPS maps"), xps_needed and xps_rxqs_needed were never used outside
net/core/dev.c, so I don't really understand why they were exported as
symbols in the first place.

This is needed in order to silence a "make W=1" warning about these
static keys not being declared as static variables, but not having a
previous declaration in a header file nonetheless.

Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index be941ed754ac..ffab3928eeeb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2451,10 +2451,8 @@ int netdev_txq_to_tc(struct net_device *dev, unsigned int txq)
 EXPORT_SYMBOL(netdev_txq_to_tc);
 
 #ifdef CONFIG_XPS
-struct static_key xps_needed __read_mostly;
-EXPORT_SYMBOL(xps_needed);
-struct static_key xps_rxqs_needed __read_mostly;
-EXPORT_SYMBOL(xps_rxqs_needed);
+static struct static_key xps_needed __read_mostly;
+static struct static_key xps_rxqs_needed __read_mostly;
 static DEFINE_MUTEX(xps_map_mutex);
 #define xmap_dereference(P)		\
 	rcu_dereference_protected((P), lockdep_is_held(&xps_map_mutex))
-- 
2.25.1

