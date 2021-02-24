Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4AC323B76
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhBXLsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbhBXLqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:46:23 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF892C06121C
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:16 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id do6so2541540ejc.3
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RFOX600Q/Cv3HMjqdBygz+3o5JVjShH9AZxw2X5WKRw=;
        b=URQTkSxdTb/EYkTMzw+WRm6jFboadm5OLgpBewr/gfseIFX9xK2bDhHr/5Y+uKpOqL
         qCmolMDNxm0SGeSSDcEdnFoVUlpzC1c3YjbhZBGvKRItYjzw/7wdaNHPYupH5GrL1BYr
         btpC87faiug6F95F0WScGsCQyc83yUiro3Htw+Hc6td0G6XK9gVR0jeIyfuCui9aq8PV
         T0ytJiSv4KgEj0Wysy5oj3JIOh7kty6PzRzJQNA3RG2jT2/X9dK9Rgo9vMsR3+OWNePX
         /2s41fCTe9xk0zW6qAixm70T9pJJuP4Fcbol7gbwQmra/0TNetZemyBOWRTOSSFyF5Ap
         3J0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RFOX600Q/Cv3HMjqdBygz+3o5JVjShH9AZxw2X5WKRw=;
        b=VROkbDy2zoUExu2vD1x2dW91aCeTrtBqy242GuAsZCqpFFDXqSSVuX6ga99KKaNHSk
         sDxkYDo7nZMzCXjttLtS5dO1PIRo6tiEqTdshfBmGkEcdCNYadGNnJPgaZJda2b71c+U
         2PBx5vc+HRF4+N5OM00ln32WwLs/9A7nbblrPTtDqmU7fXx3JbkoyMtO0jqeF9paeQDq
         2XUEhRLrgcWJvqffheD1XTcPL/Pk/7yg6SKK4ElHDnkOSsqoVsJ7MlexA06CnHQEKyXW
         se55VXq2Gje/kZCyOZT4oDEhDewPWMwPoESlaKdBMtCyPeJxKGI9zMgOtWbt6V7OxGfk
         0WAw==
X-Gm-Message-State: AOAM530iu29Fvb8gHD5pwj2cpZZEGJuVNwsxmpvxm9uY+t5eJdtY3Mif
        8vwSpsb3kqYWU97mXaFoGwu9gdyAiLE=
X-Google-Smtp-Source: ABdhPJxFGplH7866kCEzcIob9wviSgA/CL3xFSxVcmMwq08QniYZgFZ2B6IqlkWThWI4kznuGuL7fQ==
X-Received: by 2002:a17:906:4e8f:: with SMTP id v15mr20853013eju.357.1614167055479;
        Wed, 24 Feb 2021 03:44:15 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 13/17] net: dsa: mv88e6xxx: Request assisted learning on CPU port
Date:   Wed, 24 Feb 2021 13:43:46 +0200
Message-Id: <20210224114350.2791260-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

While the hardware is capable of performing learning on the CPU port,
it requires alot of additions to the bridge's forwarding path in order
to handle multi-destination traffic correctly.

Until that is in place, opt for the next best thing and let DSA sync
the relevant addresses down to the hardware FDB.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 903d619e08ed..e25bfcde8324 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5818,6 +5818,7 @@ static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
 	ds->ops = &mv88e6xxx_switch_ops;
 	ds->ageing_time_min = chip->info->age_time_coeff;
 	ds->ageing_time_max = chip->info->age_time_coeff * U8_MAX;
+	ds->assisted_learning_on_cpu_port = true;
 
 	/* Some chips support up to 32, but that requires enabling the
 	 * 5-bit port mode, which we do not support. 640k^W16 ought to
-- 
2.25.1

