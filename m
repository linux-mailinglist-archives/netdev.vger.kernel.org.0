Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE6690D63
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjBIPn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjBIPnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:43:46 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D5764D83
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:43:18 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id gr7so7598320ejb.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4dqEUDE9TT3v5WYQVTEABMK+I4AxBfn/2LZe716e9w=;
        b=WkHLKTG3o3wgpHqoPvb3xYo0SakssQJu9FkhE03xCr2PL7gr6xx1uB9WRkVYZH38ev
         05f+Bepuys6dCZZi5ZHU/W2MGmWuoMwKmbftO7i288o9S0VQaS7UzAvy+8Z0d05/nKT5
         9GCSjswHlDUfmijuLd8rTHSpvez0tK24rkRx4bmBfF/43CNx9cdVomaK8zLV5QR6ZYk8
         m/BerYjnjg/Z9otkuvncib/kA0L+rwVkaRHMKuzN3RUr+K5mfXjcpBC2dJ1ONcQaJ/ir
         NItiGMOcrcSwStbsiKLWQCndJlvXgL6EyBPOYR+88xb6YJfOTQc+zQCAFqiiUhb2jLDr
         Hjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4dqEUDE9TT3v5WYQVTEABMK+I4AxBfn/2LZe716e9w=;
        b=YVa/wHMufflMozCTwyKTsinxh2ZCcIfzgiBwJY+yaQKTFQWCncAQUA+ex+MCn/zlt8
         azB+Xnr/v6MXOABwkPZNqYturU6gbQraZ4kkH1lCd9OOpM98ALHxx2vplb37BQGD2RNh
         J0J82WTgkMtNcFr+Bi2SBdFhyW6GEdC+49/pXk152sfW21vo8OVmS06r+fwwIjTUxQyK
         fJQurCqGG8K8+jnEsGYeDICXXt7vzBKlUv/VVdTslM9mfte4AqTKpDw9MQgd96j6HQVO
         GDw3FRY/mPUYOIgftQcMorVFvoTMGzD/xRp0dRVooKc8mYPwSB2OPr07dcqlqZkNmK66
         pqUQ==
X-Gm-Message-State: AO0yUKU11SaFa/Hd6pfVNEsVF8F7xxAaR3CT42Dzd7xahHi+I9JMTCly
        QyRRurhpUXZVzLxI/ZAB2/cxQSLJ1NE+BEOz2KE=
X-Google-Smtp-Source: AK7set9kkL6zJ0uBQDXCTSin4Hga5IFG4fyWQPM+SCsu2Voa/KzovrTD0V+KCcaBXdJUYKsAt/C5Jg==
X-Received: by 2002:a17:906:1ec8:b0:888:a72f:1599 with SMTP id m8-20020a1709061ec800b00888a72f1599mr12607045ejj.11.1675957393190;
        Thu, 09 Feb 2023 07:43:13 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k2-20020a1709063e0200b00878b89075adsm1029887eji.51.2023.02.09.07.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:43:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com
Subject: [patch net-next 1/7] devlink: don't use strcpy() to copy param value
Date:   Thu,  9 Feb 2023 16:43:02 +0100
Message-Id: <20230209154308.2984602-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
References: <20230209154308.2984602-1-jiri@resnulli.us>
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

No need to treat string params any different comparing to other types.
Rely on the struct assign to copy the whole struct, including the
string.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 9d6373603340..6225651e34b9 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4388,10 +4388,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 		return -EOPNOTSUPP;
 
 	if (cmode == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-		if (param->type == DEVLINK_PARAM_TYPE_STRING)
-			strcpy(param_item->driverinit_value.vstr, value.vstr);
-		else
-			param_item->driverinit_value = value;
+		param_item->driverinit_value = value;
 		param_item->driverinit_value_valid = true;
 	} else {
 		if (!param->set)
@@ -9652,10 +9649,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return -EOPNOTSUPP;
 
-	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
-		strcpy(init_val->vstr, param_item->driverinit_value.vstr);
-	else
-		*init_val = param_item->driverinit_value;
+	*init_val = param_item->driverinit_value;
 
 	return 0;
 }
@@ -9686,10 +9680,7 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return;
 
-	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
-		strcpy(param_item->driverinit_value.vstr, init_val.vstr);
-	else
-		param_item->driverinit_value = init_val;
+	param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
 
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
-- 
2.39.0

