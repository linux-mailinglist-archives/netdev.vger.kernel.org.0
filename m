Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D7D5EF360
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbiI2KYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiI2KYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:24:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C611181D
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:24:41 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sb3so1817071ejb.9
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8Fvlf7c27fT3O4GYFOpJAwdYhQ9x2pj1QwpQRq3W8Eo=;
        b=u3XyuaGzAFCRZoxipleF7fFfjGWbjrYD/rR8X3ZrIn0tyKgMaN1wZ2qqMK7UJPi3+r
         VKNjRRPK9iIC1/QCKWaRjEfXjkOqSLmV1XSVzojlcyH7Parkcs8jQNj5rX/4HHIYT8pV
         fgmEyMj73O3aPrYH+LZXng0ljjt4wwc+NhFqxAUKVXWqvpXIjgkJNPJEEINjm69m1o2c
         W869lDIPq3dla5im3H6hSTmCl7JMqSc97PHmpCl8N39lWXV90Kg7PxjVive17PILmAMZ
         /B+zbVUR68td1CqFUrkTWl3BsDGvzsaTPl1pyq0VoWAdARrtHc+Z58HyrHiypGl3KBfa
         HE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8Fvlf7c27fT3O4GYFOpJAwdYhQ9x2pj1QwpQRq3W8Eo=;
        b=4tVzbz7Uo0NdZkYyhALU3hgeCrgv33k/YTqwZkyBKXZcj4kKDTnByKB872CO8lAvIe
         /vc3H5KBkp12vqhwogukhVnKH59Ac/MLnJWWQ8p28eQhIAiEhvs5I83EW7/nQvnDoAfq
         GLuBs+LDOIK4KB5uIQsVU/0cxUo6RlvlzT0ti90zhufQj4G7Gg1lNlNotD9aSdl/8vbr
         wRVkBXkjqoNlqyCgeIPcQQSlRHozwS0krztMOHjqRJeN0Fopv5uCZB8Zu3zEbR1Cq/mh
         lJEb192hP20h5YSY8O9SOJTxZWGPyivTerxHttf1+mzXcIlII6WW29orp865zWgFiVbQ
         DjRA==
X-Gm-Message-State: ACrzQf1hzwFQY+md7T+uBuTWxGPBzfiRrquudg18CiUCqmLx+hWa36W5
        FbYeK41Cxp76GOukEQWzC0/67w5d6s6lx8/j
X-Google-Smtp-Source: AMsMyM5fPgnDviaK7P8hsZ7ZB/vWDQkRF+gl6bAfKbRLU89HWo59TyH0O1laD8BdHF0MbNzd+HxemA==
X-Received: by 2002:a17:907:724b:b0:782:f2bb:24d3 with SMTP id ds11-20020a170907724b00b00782f2bb24d3mr2044316ejc.555.1664447080367;
        Thu, 29 Sep 2022 03:24:40 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ky6-20020a170907778600b0073d5948855asm3823168ejc.1.2022.09.29.03.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 03:24:39 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com
Subject: [patch iproute2-next 1/2] devlink: move use_iec into struct dl
Date:   Thu, 29 Sep 2022 12:24:35 +0200
Message-Id: <20220929102436.3047138-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929102436.3047138-1-jiri@resnulli.us>
References: <20220929102436.3047138-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Similar to other bool opts that could be set by the user, move the
global variable use_iec to be part of struct dl.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4f77e42f2d48..0e194c9800b7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -71,8 +71,6 @@ static bool g_indent_newline;
 #define INDENT_STR_MAXLEN 32
 static char g_indent_str[INDENT_STR_MAXLEN + 1] = "";
 
-static bool use_iec = false;
-
 static void __attribute__((format(printf, 1, 2)))
 pr_err(const char *fmt, ...)
 {
@@ -374,6 +372,7 @@ struct dl {
 	bool verbose;
 	bool stats;
 	bool hex;
+	bool use_iec;
 	bool map_loaded;
 	struct {
 		bool present;
@@ -4926,7 +4925,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
 
 		if (rate)
-			print_rate(use_iec, PRINT_ANY, "tx_share",
+			print_rate(dl->use_iec, PRINT_ANY, "tx_share",
 				   " tx_share %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX]) {
@@ -4934,7 +4933,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
 
 		if (rate)
-			print_rate(use_iec, PRINT_ANY, "tx_max",
+			print_rate(dl->use_iec, PRINT_ANY, "tx_max",
 				   " tx_max %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
@@ -9739,7 +9738,7 @@ int main(int argc, char **argv)
 			}
 			break;
 		case 'i':
-			use_iec = true;
+			dl->use_iec = true;
 			break;
 		case 'x':
 			dl->hex = true;
-- 
2.37.1

