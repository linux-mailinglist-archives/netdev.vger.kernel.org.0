Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DF664D180
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 21:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLNUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 15:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLNUw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 15:52:26 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AE82C109;
        Wed, 14 Dec 2022 12:52:25 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id p8so12457391lfu.11;
        Wed, 14 Dec 2022 12:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zFLdAfKk9Qm17jrt7feddSvQWDFpf/HIJxK3WcQxEl8=;
        b=KTR///vKb6FkMxCfJhmBVJsixjYCRwNf3SNNxkY8Kcyk1KH6qKMIz1yymZbQztUH7A
         /fOUPhDfjc1In1qZYxs8oaFdbkiae/9zT+LqK0bcnb1WHfFYPtyYJGeTt3j6GDK3kv2D
         YicD4G7d9btkexKcOYUsSgEm6FIm/pso6E8YoQ3a0OyTk5S74l6AMPeCO6hFCZgcOXpN
         zA+lj9Tc0iPDSMzzBPsEmM3pSmzNoCEW2MpNIq23sF3tSsj5oakULwThMcR42YqZaCcy
         aR3tmPxvjMji1QYZsENBSNjRjyLSiteyMW+cV9GwXjvaQr45VdgdsRemcBbYxI8m3uKA
         GuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zFLdAfKk9Qm17jrt7feddSvQWDFpf/HIJxK3WcQxEl8=;
        b=nDeyYA5JY7gu69MfbXBi8MADHdv7Co7kFdQJT9l5KI8kNqKIoj2IIU6rUtt0gcJsan
         h7rIJ9Uw2FPEKWMpAC0DfXU3mBSjWoswBZFbXJNkaR0gMvReM5R/7a+ALsz+6fZxSeae
         H/cpgqxfLXrkBxTUKOFcBh9aVK+LRkgSNZ7Sa7QoUDPEa8hwYBQ4rJKCJ64qRNGJEdhU
         QC76F3TWDoxIXlczE1akxFc9WZN7bbVniwnq6x28WxDGaOanJ0I3YBJCFDwVt/ppnfxU
         siy8LZD9FRZbcLjcbqniIEszkZpFi5sbrg4RctXkjCWrXGT7WHKMQAuPQ+ztyLT55Ag4
         LPrg==
X-Gm-Message-State: ANoB5pkgjf74i/OPe2QCnNxLXuGQqr7+SQ157HoMNEtJrxYF1NI8Zu9O
        A8HKRMfJWveyJAGvXydIriM=
X-Google-Smtp-Source: AA0mqf6g4WD45xmyq30OdOjmCP1Uum4pVhBkE7h363BDFRriY9G1l8cO/jYy8Ir/u/cgIdwktccJlQ==
X-Received: by 2002:a05:6512:3499:b0:4b5:4079:c824 with SMTP id v25-20020a056512349900b004b54079c824mr5844679lfr.46.1671051143634;
        Wed, 14 Dec 2022 12:52:23 -0800 (PST)
Received: from DESKTOP-5EKDQDN.localdomain (78-63-10-115.static.zebra.lt. [78.63.10.115])
        by smtp.gmail.com with ESMTPSA id p17-20020ac246d1000000b0049e9122bd0esm930105lfo.114.2022.12.14.12.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 12:52:23 -0800 (PST)
From:   =?UTF-8?q?Aldas=20Tara=C5=A1kevi=C4=8Dius?= <aldas60@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?q?Aldas=20Tara=C5=A1kevi=C4=8Dius?= <aldas60@gmail.com>
Subject: [PATCH] staging: qlge: remove unnecessary spaces before function pointer args
Date:   Wed, 14 Dec 2022 22:51:47 +0200
Message-Id: <20221214205147.2172-1-aldas60@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary spaces before the function pointer arguments as
warned by checkpatch.

Signed-off-by: Aldas Taraškevičius <aldas60@gmail.com>
---
 drivers/staging/qlge/qlge.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index fc8c5ca89..05e4f4744 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2057,8 +2057,8 @@ enum {
 };
 
 struct nic_operations {
-	int (*get_flash) (struct ql_adapter *);
-	int (*port_initialize) (struct ql_adapter *);
+	int (*get_flash)(struct ql_adapter *);
+	int (*port_initialize)(struct ql_adapter *);
 };
 
 /*
-- 
2.37.2

