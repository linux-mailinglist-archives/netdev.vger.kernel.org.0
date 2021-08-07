Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC2D3E3541
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhHGMIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhHGMIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 08:08:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44557C0613CF;
        Sat,  7 Aug 2021 05:07:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so22134544pjb.2;
        Sat, 07 Aug 2021 05:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nHNcflnG0a4A9LfEWKsvfNtPEZu1Ro6r81VoleoWmDs=;
        b=mU6imz/bwXHRCKkt9haQM7HUPdT/OsRXdwPx8HHOv6bGROuIqvIVUiSUZDN8WKDIUM
         KeFtZGJ4gWfTGX4EsR8eYSVD7jYimKDOlW6rDMDDNdITOZM8rzRSH7lw3vKBDUIFYp1G
         RF/Y9pDdxLS1Et7lgHPtfDoo78nS8f462Tp66JgUYeKTca07/3Se69S53oMrDXCxBdvz
         Cwj2fQNuiCVIcXHBV0jcm2AFLjp5daTqusG9miXgFyY9oaS8Isik0PgWESSwRMd+dstQ
         RA5+tzLc/pVfY7kZVEgy4l9D46nbrqVbZt40PP1dGxFSD6TEkm/14hCg9Jptv5IUebMk
         2Btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHNcflnG0a4A9LfEWKsvfNtPEZu1Ro6r81VoleoWmDs=;
        b=IU6yLEBRTZwnUA7Z0uxFapctAWel/OybmJFg3ZA6Ctu1qD8yEb+MAnwHpSuEtOsj5H
         /IQiYT5VaU5ugPYKlor7vVrsY/djoAjYHOZH5i8zzpey6JGeySvHuktMdAkhV43uXZgm
         SSQD8fVyB/EMmEw6WL68JzAZbpoO6JNYQNQl4+KnRAu2sqLVVWeYZ7WdKGV0jG8b3/XF
         VoLxr5/6ES7r6eZHPfSn5yi49VunnRFVnfcQM+yIuhcsk9w8dhWSXBAqhsGjfRwGoSAQ
         J9z+TWHkO0ua9mKxk88yYEYbTmNMzqhA+9GECR0u8mJ+/fKxj8RtTHM2RM3mcQXnvRwS
         l1IA==
X-Gm-Message-State: AOAM533jmMG16qH2NhDBa8rc7989PlU66tQIYpco2CQNpmBq6ye5be33
        fM93+hzyp3E+ivji48DInUQ=
X-Google-Smtp-Source: ABdhPJybRBEtj4boTWrozQ+AoJLBGIqC8C4EFEtrv6HMyXSjUgpR4n23eo6084tWzOluZu7jmJZXcw==
X-Received: by 2002:a17:902:d501:b029:12c:3386:96ed with SMTP id b1-20020a170902d501b029012c338696edmr12676391plg.39.1628338074863;
        Sat, 07 Aug 2021 05:07:54 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b15sm16471035pgj.60.2021.08.07.05.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 05:07:54 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?UTF-8?q?Andr=C3=A9=20Valentin?= <avalentin@vmh.kalnet.hooya.de>
Subject: [RFC net-next 2/3] net: dsa: qca8k: enable assisted learning on CPU port
Date:   Sat,  7 Aug 2021 20:07:25 +0800
Message-Id: <20210807120726.1063225-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210807120726.1063225-1-dqfext@gmail.com>
References: <20210807120726.1063225-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable assisted learning on CPU port to fix roaming issues.

Although hardware learning is available, it won't work well with
software bridging fallback or multiple CPU ports.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 798bc548e5b0..de2aa7812d1c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1114,6 +1114,8 @@ qca8k_setup(struct dsa_switch *ds)
 	/* We don't have interrupts for link changes, so we need to poll */
 	ds->pcs_poll = true;
 
+	ds->assisted_learning_on_cpu_port = true;
+
 	return 0;
 }
 
-- 
2.25.1

