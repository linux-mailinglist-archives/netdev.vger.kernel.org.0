Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CCB2CBCEF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgLBMYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgLBMYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:24:15 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFADC0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:23:29 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id a9so4422802lfh.2
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1G0LuInnIArsXXKtcOQKFPtvica/lf75PtMTKqoYgoY=;
        b=CvTPe2Xb++RJluxqxNZYxjLpds6wqokopbZGoFETRQ/44GrlFC6qVNaZI52J0sI/dn
         BV2i6bJjoRAyBI2ZvMo1KwI6o6ATpSc53nfK9nSGUUO+mwwU0I8MBQ3i8OtiqGQlSeEs
         JHkj8GRBaGpNbVePc2lynw/PqFrKMAn+SqUl5Oo8zSUDwINsY0nx8DD+6bfdtrFyEj20
         3cj5IaVHKN1wz3cM8MkXF/lWZPhO4cay0LYY/9YOAreLO6Mlk6RyCMUDvDq2GUaGMxX+
         5wkQ/8aSCRsML7ejsTs4gRDsMy9KfDkbW0mNzgHE2Yu8C6CaDSr1Pg/s6+i8lkLEJ/S2
         VWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1G0LuInnIArsXXKtcOQKFPtvica/lf75PtMTKqoYgoY=;
        b=pASv4zYkuJxseI5EjvwgG60YtpengJ6g2Z7u9IfNiG0gm5D1W1ErSK5YZqKAIdIwU9
         lGHDSySYC4717r3KG055iJd/UBlscs0+qEJ19WtcGOZMzlRJRr8cAwlEeKD3aWyKgLlS
         kFEqlTdqNE619ZkulOx61AYYWlGx1sH/zj43hbodoJt1Hx6glrJXQw+XO1FMZqg4G4qs
         cIjOaGQH6gqUuxbHFC/5b1kSXIzSih5ZyXFFUL+LiFxl9QRuXDo8zp6pwBxkGBED9Ryd
         m1m6fOCbShOjEuFj9Fj8GPfDJ5bdRPEOrxviXQv0/50yOdJgyd3GLPyPnkmEsL+bDKID
         e73g==
X-Gm-Message-State: AOAM531nrVNhLYJn4m7muEp4i8LCiJ5LgeSA4hxzqfiO+aU1nwQCqI8B
        v9U3Jlt0gkDKol2PZagvgDQN6GaoH8PunA==
X-Google-Smtp-Source: ABdhPJwqs9r/225QZPjOvH/MjqO9WGzqccMGnT4N/+XslmTaKgC5YD18dJRLfDmwE+DM0DdL7GDtyQ==
X-Received: by 2002:ac2:52b5:: with SMTP id r21mr1055104lfm.349.1606911807937;
        Wed, 02 Dec 2020 04:23:27 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id n14sm413144lfa.4.2020.12.02.04.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:23:26 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 1/1] bareudp: constify device_type declaration
Date:   Wed,  2 Dec 2020 13:23:24 +0100
Message-Id: <20201202122324.564918-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

device_type may be declared as const.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/bareudp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 28257bccec41..85ebd2b7e446 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -522,7 +522,7 @@ static const struct nla_policy bareudp_policy[IFLA_BAREUDP_MAX + 1] = {
 };
 
 /* Info for udev, that this is a virtual tunnel endpoint */
-static struct device_type bareudp_type = {
+static const struct device_type bareudp_type = {
 	.name = "bareudp",
 };
 
-- 
2.27.0

