Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0833C2024DB
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgFTPn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgFTPn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:43:57 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671B6C0613EE
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:43:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w16so13496806ejj.5
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9jg62zySnR4atAEQtNw2RmwNVO6Rx431QONMhTKW9M=;
        b=aIzYcoGBwcLQItnLR6/isDktJyxCrD542NyAQz9tiV+bPZ26bmxOGR6fivAJwHYl09
         9HZJMabTGvOm8O8UdqwfFsvNcqQGPp6xwMhdwrIDDNGyYIQOo2jQXQUxn/wg3XKfBbFN
         XV7wXwmABnm3Xi7/Fd1ZjExM0iB8JQAZrnkeB44o81lOBp814h+iMDYR1gfwNgQq3hiU
         EPh10MNOPy8/gi2KdSc1giIIzC9II470NwZPrqf2G9Re03XowvF1SogAYTDzH6kVRaOE
         kdIRyTZr31YVh6Fgb3eWCkeI7snTDhekQ5xUraQQar2LHmHq5rJYIUd3n/X9NVLdecHW
         /saQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9jg62zySnR4atAEQtNw2RmwNVO6Rx431QONMhTKW9M=;
        b=qtMSo/+uozLUcg51VhH+RJ0GgN5SPWwxncSX806CNJbltYLHXpyzWpb6kf1d5/zq66
         2D3W86Y6+QXWlgPL2dZ+kqFD3Xz36bJMgaDW8Hh1cJzTElD6TN8DEXE55DLBJi8bu2Kt
         KYu/DHsd2aT/SPUa4e1x39PCNHOw5OvUEp+QPelE5XOUWN3IgH8A6aJ/3JS9xNAvdNWx
         RtURQK5oM8gPmVtd0ymXGQ+4ZpTCLUcdPtYRUpZnLZo+xwWVJrf6jpfbpvCxuvmhGQia
         SHVOejKq+Lepp0BfT/lQG/PUuvoxCniTKac6YxuNA7vuHBJ7fpyk5c5/VW2nDakU++lT
         i+ww==
X-Gm-Message-State: AOAM532qE6CjKzPmxui2ekLvRShJg8HdvX8QjGD5jeHfDn8Z1HasiBJY
        HnLq2s3Ko4uY9vQCpFYa6eU=
X-Google-Smtp-Source: ABdhPJz8hETxtZchVwuVyz0BjBOQhWJ6TZNs9CupYzmUJGQZGk5FgTLXFjJMZIRLEwP6/PbfMIghOw==
X-Received: by 2002:a17:906:6959:: with SMTP id c25mr4519842ejs.375.1592667835904;
        Sat, 20 Jun 2020 08:43:55 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:43:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 01/12] net: dsa: felix: make vcap is2 keys and actions static
Date:   Sat, 20 Jun 2020 18:43:36 +0300
Message-Id: <20200620154347.3587114-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Get rid of some sparse warnings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d..2067776773f7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -557,7 +557,7 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
-struct vcap_field vsc9959_vcap_is2_keys[] = {
+static struct vcap_field vsc9959_vcap_is2_keys[] = {
 	/* Common: 41 bits */
 	[VCAP_IS2_TYPE]				= {  0,   4},
 	[VCAP_IS2_HK_FIRST]			= {  4,   1},
@@ -637,7 +637,7 @@ struct vcap_field vsc9959_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_OAM_IS_Y1731]		= {182,   1},
 };
 
-struct vcap_field vsc9959_vcap_is2_actions[] = {
+static struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
 	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
 	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
-- 
2.25.1

