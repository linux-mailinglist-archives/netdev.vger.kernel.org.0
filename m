Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021AF399962
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFCExG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:53:06 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:41831 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhFCExF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:53:05 -0400
Received: by mail-lf1-f50.google.com with SMTP id v8so6839218lft.8;
        Wed, 02 Jun 2021 21:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+nCi9Jm6RS+Yo4xLrj1ulwofTdiOXC2p9T7X0aXtR8w=;
        b=JwxPuEWg1X84SZu+RUEfDIO6hQm8CuzSaB94KXZmH2Cv64ZRN7m2HhOiqc732T1HBa
         GwtyQSay42iBwDN4XGMIRjOHWDOhja9/DTnr6omS61C3ZWRhZPisS42HaQVIEWIEiMjS
         dRFhdJq0BIDwgIjrmNg4xeE9vtwVfMGub23jdPRHr9jEAUJZPiwYEg4WomStCVOEj892
         nXPwOc5yr37bkVPKyQ/kCieFfLAXvlYXdhPijWtOgu6cyAS5C57eQ0MFtx3mKtvzfgow
         mnu7QCy3LYQacFNwVuDkZSnR13OOorIKvl5hWSdYu9iBcBNcYQ2d2kdDBurXRv5eJvrq
         L2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+nCi9Jm6RS+Yo4xLrj1ulwofTdiOXC2p9T7X0aXtR8w=;
        b=e4KHNENbBqGTszEP6fthXYAJ691SqmNzUhMWSIwurtLOOdfU8x5g+IuUtlvSA9jGio
         HR+C48rswfrrf/qdFokeu1Mhjz7CIbYIfiR3kRk9dxpg/7AGCalgQCBpszYn9M/m2+fc
         n0vUgGgOwyLuAcTY6n6liQAgWfWCipWRqdhG9tG7SC0UzOmmxjIqeHWMJHVD7oLPZjvi
         NqcjL+0mfS2Dr/pHIb5T0GB0XsG3gKIv69QdczK8k91r41JbhT4zuiTZwNXCLJYOsIDt
         yr7TUKWDD69ZNGr/zcuIzG13tP/aMgS/tVCtCeZb+UfSRe3cL7ugHGufYF6dLKW/CrUM
         UJlg==
X-Gm-Message-State: AOAM530B+H36hIPJ8oLHVrJX8hH7rhHTcGlZf0mAhG2Mo/jk+b/62evZ
        TQBILG06UMwQwYDhWVG+F7w=
X-Google-Smtp-Source: ABdhPJxoWm3n+xVxYAPRD2ma8LJYiwycuwtUbkKgwG0whdSfB6s07YFMF0pFxo8lP5tArax5zpgWUw==
X-Received: by 2002:a19:c209:: with SMTP id l9mr16177432lfc.277.1622695805129;
        Wed, 02 Jun 2021 21:50:05 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:04 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 2/6] wwan: fix module initialization
Date:   Thu,  3 Jun 2021 07:49:50 +0300
Message-Id: <20210603044954.8091-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
References: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recover the successful return from the module initialization function
that was accidentally lost during the netdev creation support
integration.

Fixes: ???? ("wwan: add interface creation support")
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index e2490c73ac33..32b2096c5036 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -737,7 +737,8 @@ static int __init wwan_init(void)
 		goto destroy;
 	}
 
-	err = 0;
+	return 0;
+
 destroy:
 	class_destroy(wwan_class);
 unregister:
-- 
2.26.3

