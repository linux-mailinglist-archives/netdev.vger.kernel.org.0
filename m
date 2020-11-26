Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA382C55E3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbgKZNjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390296AbgKZNjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:39:00 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7921C0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:38:59 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d142so2184782wmd.4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYgpjf76kzokq1lw9peNjpiGw2Ji8yFXqiIQfoAuuvM=;
        b=y4FJagoo/uFkFIGb96frMqyuiNZVvOjuzF9cDotLK2J14gCs1/9OOWUKHXWpmu8cn0
         INafeNn2tupT3IlCatcz1uWm1GdKTDqbpCi9ybMRsziKI+C8M7xtadC+38sZw0rhSfsN
         v7czwnA2juH7RgUqK/P1rd3ssDMhnwx2JFGQXPAhcDeMAe+b0nN7zRR/k9LzHSfO7Bm1
         36Fqa4Y2cJEfwFD1YTbn57rKRst/SbOIuvDLA6N1JeA+RNyeW2ZmLJxvPU22Ii+yaS6E
         cfboCQeCTQk/oWmlURxIGqqwUMnyMlKuHWhkHKE+8xuYm/CDuA/bv3T7XzoRaVNPz+oS
         e1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYgpjf76kzokq1lw9peNjpiGw2Ji8yFXqiIQfoAuuvM=;
        b=RzutP5CNMRKk/Wpjrz93CqwMVEBLSlcNG+8+Aj1rKWtXem1b1x7fVkcrYNo0AryZZ4
         r+MOxyguC8oHxpbjJkVqbNFl6iHg+UrYScNgWeLVt8DnWQV2LkOayKdVNl5z5+KQxXiI
         /8e0SjJspJqNJ28YT/tTaWI10iM4BRzX9eQhETiYq8SRTIBSQ6Udm4TuFsiArstRyUc8
         guNoKD6enzLCFG7Y3xNxZYjJGfuZBlsdxeE9NZxCNlcvi+wR8BfXhlto9Bx1+Gugc0al
         4+FalOFS4qg+7XzZB8qThAeSOHjAZjJKbxhxRUAQp9jbPW0WJ9oOMJ0K4ipvDEoDp5kc
         hlcw==
X-Gm-Message-State: AOAM530LZT3ErlyrSxcFGIeTpjXDnAaPbIQU6LF7XzG3SngaEs5tY82D
        9Fo/4DRCMjYdtEEqOvT2MDE2WZMw0TcL322S
X-Google-Smtp-Source: ABdhPJw9d0nl0bdUXvf8PW+xbx0DbCWa+K1+8tzn+QVpmQ3XABcpMY3u0DkVLZAwm02EkA6E+L6HzA==
X-Received: by 2002:a05:600c:2908:: with SMTP id i8mr3521713wmd.182.1606397938612;
        Thu, 26 Nov 2020 05:38:58 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id s133sm7035825wmf.38.2020.11.26.05.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:38:57 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Erik Stahlman <erik@vt.edu>,
        Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH 1/8] net: ethernet: smsc: smc91x: Demote non-conformant kernel function header
Date:   Thu, 26 Nov 2020 13:38:46 +0000
Message-Id: <20201126133853.3213268-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133853.3213268-1-lee.jones@linaro.org>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'dev' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'desc' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'name' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'index' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'value' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'nsdelay' not described in 'try_toggle_control_gpio'

Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Erik Stahlman <erik@vt.edu>
Cc: Peter Cammaert <pc@denkart.be>
Cc: Daris A Nevil <dnevil@snmc.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 56c36798cb111..3b90dc065ff2d 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2191,7 +2191,7 @@ static const struct of_device_id smc91x_match[] = {
 MODULE_DEVICE_TABLE(of, smc91x_match);
 
 #if defined(CONFIG_GPIOLIB)
-/**
+/*
  * of_try_set_control_gpio - configure a gpio if it exists
  * @dev: net device
  * @desc: where to store the GPIO descriptor, if it exists
-- 
2.25.1

