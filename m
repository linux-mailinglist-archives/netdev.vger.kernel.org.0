Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA34FD667
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 07:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKOGZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 01:25:10 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40512 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfKOGZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 01:25:10 -0500
Received: by mail-pf1-f196.google.com with SMTP id r4so5942986pfl.7;
        Thu, 14 Nov 2019 22:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emY2gm5TsWVFMMimxBC4143icxj0Lbfx5oWae/Wjzvg=;
        b=deE53lHyv3gBGOhbVrzsmx5AS+FgnvHsukhfzzzf8IlWkABanwS1kPT7d9+GGS7SLq
         9vgDdWBzjQ1sqInHEcAwxncYtJ9ANUZRYKU9e3lUOd0rEauvyQOD9S28eJFfG617YpuF
         v9tXvhSw8nJEdeJQuaapRemOoqJTWTdpmkzVOF+1dGRbcONQLOG2GyGC6JbevBPIaJ4L
         Lg2VVozbDvEVzmuh2GSMJ3eS9OpPNshjmxhJMnv6H47/BAvsCf7LY+TwKAMn6f/5M9F4
         5Z6Nt4FOsLwyr6TplE5YbIDUAKYeKFg0armnFHusn0X4SgEYgFV0LJicnKyEZOcVx1hA
         ENjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emY2gm5TsWVFMMimxBC4143icxj0Lbfx5oWae/Wjzvg=;
        b=YkVJiK7Xof7itJDUVUiH3vzeRaam6+ogAqieOwul+sOjYZyNE/HwkC3Uv6b42pWeNT
         EUeaJ9LmlR9E1IdJdy2iPBdyz8zFK3qUm4RdtQbgU75HwT3RltLIXO6rjZRS3UJUHfuG
         OoETaMhcxRDDHRvxwJ5NisvVuKf2oadgCld58l4yjDz9xp/f22BdPqcfLCudkPVsToeA
         8H5+7fX2Blmpe09KpJCZcIMNZJCcWszNY8Fvere27q2myqjm/8iV8sMfbM4dgLjoKLZU
         98qcvpy4YAyNLT5CqozmwXWfcewvOs5oIisPZATaIn489izHJujj2tUJAdtr0jI3g2bt
         GZVA==
X-Gm-Message-State: APjAAAUpC0DB2ra83ZxvuWgC2yNYV567IwCa/p62bSjMKAkaMJOcgDhg
        GYeZyQwZFbOvPB1C9WUp68M=
X-Google-Smtp-Source: APXvYqx2LRk8ZsBsVdFB5I3fmxd1WHEZUGZSqXkZVvYdDc+YC5TohGqEXM7LaPk0zlzoKpxMqoJlAQ==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr17996247pjq.46.1573799109294;
        Thu, 14 Nov 2019 22:25:09 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id u9sm9256060pfm.102.2019.11.14.22.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 22:25:08 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: gemini: add missed free_netdev
Date:   Fri, 15 Nov 2019 14:24:54 +0800
Message-Id: <20191115062454.7025-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver forgets to free allocated netdev in remove like
what is done in probe failure.
Add the free to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/cortina/gemini.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index e736ce2c58ca..a8f4c69252ff 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2524,6 +2524,7 @@ static int gemini_ethernet_port_remove(struct platform_device *pdev)
 	struct gemini_ethernet_port *port = platform_get_drvdata(pdev);
 
 	gemini_port_remove(port);
+	free_netdev(port->netdev);
 	return 0;
 }
 
-- 
2.24.0

