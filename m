Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5FD635134
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiKWHoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiKWHoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:44:00 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA2BF72C5;
        Tue, 22 Nov 2022 23:43:59 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z63so4704733ede.1;
        Tue, 22 Nov 2022 23:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tVlprrrNke5mFJD3/iYHZS4yaa+3ERCi6F/wJGiXeM=;
        b=D8LMubMYRPyqtEe2Gjzyr9EplHp0q3MLWskKwHjRMUwgenyPDDpRZEkg8Io47uLz1X
         vcDl6SbtlYIBMpNRSnRXNaG6xdLiHpuZBb5MKQUnhy7unO6dCUU15hjW4lMJ3hHSknhn
         m7pALpuyQWFpm2NGNum+Be3YrFprtZqo+ZF+r83Jav+Ke+wO1ArwqZ9M22vAymcDhCY1
         FSiZqhzOXyltmOD+/oVmZe1MihCKzQXP9XXC6AGCNDr4yBvuP6LXERTEGZ2XxNEVuHKw
         VVasILyvML6eAY7oPF8Lw0LPUa9EC+aqfIwJNVY2nmBzCRHTFjbaYE81cNDezVY7xOon
         6U9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tVlprrrNke5mFJD3/iYHZS4yaa+3ERCi6F/wJGiXeM=;
        b=U+BMeXhMX9ETXdS9W5PlRtf4flq+iLXxbX8O8k0jdW1FVD4rC3IK+mGlhRNLLNcP3M
         m6R7q0szv5UmYuVT1ab0yxPRJicQ0lL7xwxR11KdtNLg+2T1XkAPNB3DNQ9CDCJNv1w5
         3FdBmxGgGOw/UC8JxClxL/4dloR9zM57DfKuMTEp5ngG8dX8AnHCBZYkIQl3ym8DOU5l
         CiaYhTDfmzO1//gMzECUQF1FHWZWS7Z+uL/VJEhnUd3+TDzHU1tPUPB0RLN1IkJCBkWp
         E+6ENP21CHzvkdUEiQVkLkAfAzn/xBuomUau5SXRlUuohMpn1KVidkK4CWBZephJ/MoX
         RYmw==
X-Gm-Message-State: ANoB5plcx5N2f1kdk78BDYJFK28Jo5fnHiKvhhsS9yA4IKZp/1M1VHyY
        T1rylr7cY550EmEp7cNyI5k=
X-Google-Smtp-Source: AA0mqf4cajyyEnqd7ZFPlV8ZMXO0wtZID40H63DrcO87cf5SlOZ8JsQQKIBnpLBDkPeYd4KYwGnFGg==
X-Received: by 2002:a50:f602:0:b0:469:4e4f:4827 with SMTP id c2-20020a50f602000000b004694e4f4827mr16435104edn.214.1669189438290;
        Tue, 22 Nov 2022 23:43:58 -0800 (PST)
Received: from felia.fritz.box (200116b826997500d517ac74edd630a9.dip.versatel-1u1.de. [2001:16b8:2699:7500:d517:ac74:edd6:30a9])
        by smtp.gmail.com with ESMTPSA id fi17-20020a056402551100b00459012e5145sm7284446edb.70.2022.11.22.23.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:43:57 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] can: etas_es58x: repair conditional for a verbose debug message
Date:   Wed, 23 Nov 2022 08:42:14 +0100
Message-Id: <20221123074214.21538-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of VERBOSE_DEBUG for detailled debugging is set simply by
adding "#define VERBOSE_DEBUG" in the source code. It is not a kernel
configuration that is prefixed by CONFIG.

As the netdev_vdbg() macro is already defined conditional on
defined(VERBOSE_DEBUG), there is really no need to duplicate the check
before calling netdev_vdbg().

Repair the conditional for a verbose debug message.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 25f863b4f5f0..2708909fb851 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -989,7 +989,7 @@ int es58x_rx_cmd_ret_u32(struct net_device *netdev,
 			break;
 
 		case ES58X_RET_TYPE_TX_MSG:
-			if (IS_ENABLED(CONFIG_VERBOSE_DEBUG) && net_ratelimit())
+			if (net_ratelimit())
 				netdev_vdbg(netdev, "%s: OK\n", ret_desc);
 			break;
 
-- 
2.17.1

