Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD4C2878DA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbgJHP40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730921AbgJHP4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE2FC061755;
        Thu,  8 Oct 2020 08:56:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i2so4655573pgh.7;
        Thu, 08 Oct 2020 08:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Ff1QXHCZO8BHRcufyhuoJs83ZbPFhyOYQkxE1oG25M=;
        b=e07LPXuX2T0SO0In2f93FAvezlDMUZ7/tvgBqqsVK3qYB4NmFOj9jipZjpNlCDq1KV
         t9R7/rbWZf7m5NBUNk4SnM9r+1N0RbpvjFATszlRhRY+5FMDgzSY9D/rY3nI9vcsyuRk
         NnHygZ7B28Cp3L5EJuQsX0AeY5vIZETn5/Y3tzI7dBgs3f5x2TeqKt6LJK1BdVjnNmH4
         XubE57KW3u1I5/OViUfRifrPx7mD4mAyfPXdyI25//ybEPWRDFYdecIEDfJHjUrYzSuq
         WutZ3KvcIWk38JB/Mu0/OYlvYo4AnqEjrFIXcH18OJVTnhTM5o1MuMPbGD1CwitDk1+r
         8stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Ff1QXHCZO8BHRcufyhuoJs83ZbPFhyOYQkxE1oG25M=;
        b=OOZgFxBK4vi4qS0evrRgzpvY0wab1vC8WV3HPwul9Jkq7Kc8y4x9GvnUt3PQIk4Srw
         ohUoSb5JEacLg27AF4Z5ul1tvc8uEN5qVgHNW42X2rZTe5P9GKhH/LX7rwIdQFJ4iTCr
         Uekeyi4MDTg9FlzoMTnnjVyCB08oJkQrDUO+ajsqW3DSEvWH6q/CEN2HO3a4o0L/eOCo
         t6v7rY+61t7xj8X1RntNaBqte+nSSQY2l/vvYrU75cUWk1HiVfeU67w8qzmbV06frtxt
         HJeh4LPl9RlSXv9tNTZzN8TXnK3k/SuOwGrdA98l4MACTibmHOF7oc8+8UIBJSvC0jGw
         QWqQ==
X-Gm-Message-State: AOAM533HUD4kta8i/gjeADek0RM2trtOJmCc3EAb+B+qr1o7TpH1nuVr
        Pqutn3G/ioZOOtbumdp30Mk=
X-Google-Smtp-Source: ABdhPJwEshu3sTxFzI4zMITgdTZt6EcMy9vmjutH1FYs97OY76139IL9ytbGgLqKq/LsIT3+gQylqA==
X-Received: by 2002:a63:703:: with SMTP id 3mr7829837pgh.159.1602172583916;
        Thu, 08 Oct 2020 08:56:23 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 078/117] wil6210: set fops_back.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:30 +0000
Message-Id: <20201008155209.18025-78-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 3277213feb1b ("wil6210: ADDBA/DELBA flows")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6c00d57e743a..57f2d6006fb0 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -868,6 +868,7 @@ static const struct file_operations fops_back = {
 	.read = wil_read_back,
 	.write = wil_write_back,
 	.open  = simple_open,
+	.owner = THIS_MODULE,
 };
 
 /* pmc control, write:
-- 
2.17.1

