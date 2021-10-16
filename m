Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5A43006F
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 07:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhJPFoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 01:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhJPFoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 01:44:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8A2C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 22:42:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so46528679edv.12
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 22:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQvqR2fsSCKgSd1DWZCEzMyF/A8PbJ0mfnrcCvpD9RA=;
        b=CN8OXMsaBdmbj3xoXn2iQ63wQQQOIRt7DTcebzEc8U+C8Foz8ZEosTYQyjXYuEZhEn
         7GshPDAN7c+CBdwCw4+2gERCylmm3NP5Jp5snaTDAWyLoqp9G5Y09XiXDOR+1enU/qWc
         fLeVcmFpOB0FyANWblrIPHszSt9xa1X9l7guGjMPXr5og2fey3cnIF5TcLqRCh9YtOkF
         K+0IsrbGKY9Um1Y//BT4/tJuva9Dk6E6H8PL6RHFiv6XMpd4Sz+CLYE6FNF1g7JvBwHt
         I4Z70MnrlvKylTlHvmI1D5DBvch6e4IdvHERVRTV3LNmHuoTGwTV/ecrTWNKDVd0MnAW
         6n/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jQvqR2fsSCKgSd1DWZCEzMyF/A8PbJ0mfnrcCvpD9RA=;
        b=pLUx8JFZJY/2FL3R2IegUOi6Jdknf9gyf8JNE5lHx+isfbyLk3yzsDNVSEFrGDK9to
         lgCn8jtTm5D0wx6cg1dFoGhXouq/JSJijPa6QhMXZrwZ4HRRgM2QR/x8FoU4945qej9q
         fxpLrcDJHXqg3SpNcbAQ0lbzwWyjn/rTqaR3BBDqTjhuXYHdJYBaGSF4PGBQ/cehKkmV
         clqhkSM7CZTmhodfQrzQC4IZ1JA9stTA1y0jAjiKR9Vknwqy6LJkYHrAQEFHcWPlfsjc
         2Yx8RvYFEfAue+QdlvEyBmIAHcjQJzf6X9wfS0BsBymtZvFZPG5oeiLTKhx45yDDRtJe
         k74Q==
X-Gm-Message-State: AOAM532LW3bXa69PAfT558nYZJZ5X5x8Yv0vsBgJZfOCekg0MROdsYU1
        Wxh7deklL4iGzH0rJ+FxlFs9L86r5xSgRA==
X-Google-Smtp-Source: ABdhPJyQNPesg1B1ArRaibR0yLeShFlzYl1IBclu+xYbppQ8+CdE1uQbSDdPMglIG02gFJQz50ycfQ==
X-Received: by 2002:a05:6402:34d5:: with SMTP id w21mr24538795edc.358.1634362921495;
        Fri, 15 Oct 2021 22:42:01 -0700 (PDT)
Received: from localhost (tor-exit-relay-8.anonymizing-proxy.digitalcourage.de. [185.220.102.254])
        by smtp.gmail.com with ESMTPSA id ke24sm5384392ejc.73.2021.10.15.22.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 22:42:01 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipvtap: fix template string argument of device_create() call
Date:   Fri, 15 Oct 2021 23:41:35 -0600
Message-Id: <20211016054136.13286-2-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

The last argument of device_create() call should be a template string.
The tap_name variable should be the argument to the string, but not the
argument of the call itself.  We should add the template string and turn
tap_name into its argument.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ipvlan/ipvtap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index 1cedb634f4f7..ef02f2cf5ce1 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -162,7 +162,7 @@ static int ipvtap_device_event(struct notifier_block *unused,
 
 		devt = MKDEV(MAJOR(ipvtap_major), vlantap->tap.minor);
 		classdev = device_create(&ipvtap_class, &dev->dev, devt,
-					 dev, tap_name);
+					 dev, "%s", tap_name);
 		if (IS_ERR(classdev)) {
 			tap_free_minor(ipvtap_major, &vlantap->tap);
 			return notifier_from_errno(PTR_ERR(classdev));
