Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1CEABD30
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395021AbfIFQBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38306 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfIFQBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id o184so7669762wme.3
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NEUwdSPAcpdRH0WG24D8mfbrruBTMnefsqqZUJOLEKI=;
        b=0yhD0lWcrofgyBZHJjv2/HEceVdpvl9frVyayuFSFs3uiX0Q1EW4M71vTuuByXjtnl
         9uEJegIxoMPhJPS+9Fgq7l33nzmZ3Yr+LJm4fg0CNvNku7swCHnAL2Yh5DHtlmvjCLkI
         ICdReuE6DPXDuW7qX6+/fIV/eXFKrp81S3Jamk9CDLJnz78Upy+vwtHQChAY2q7QtP9q
         4Ni5z/YxEPmu0//Njl1gYyNI2t+EkG3hDHii6bwRz5WeLUtnc4Gt4qDmfOa73NiczgjX
         mRsbXdeZ71ObQdq5YrMMKLgjvWf7fdyP8NN/EDCcbOZr9S8XzjWf+bcUABYeTs+Z7154
         1krA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NEUwdSPAcpdRH0WG24D8mfbrruBTMnefsqqZUJOLEKI=;
        b=eI0ake0ga++g0Cz8x2uE8pnv7oqGxYmnaWocaW3TklURL749CSCSG1BzUDf7QFUUf1
         AUdseJx4pCmZG9tRz2FG/OJuXcxxU+gcm2nYtFNOWpVVh7LP8xW8JYdg5SXzmylA6wZ2
         rqJkkpCWcSw2Wt47WD4IL9wvcjKEQ6nmbZ4NisfYFxdrDuz/rrG70qo/ETvzdDs7tIVc
         VYINdW2DBbEG9zttjT0b39+5bqOBxkcyODvxylgAixhNXiJbMHhltL0sYj/zRVHX6UGK
         wEYsnw+c3YfI4PybANrFLi25czjw2E0RzemjKTQcqHw12Rwcmr/f3viiBLQ9IjN4Saty
         Tdqw==
X-Gm-Message-State: APjAAAUiOv6439fHkfobovWER/7i5/Xedu//bn7Y5Tp1tfPOdu537igt
        jJbe64qPEst1TyIg1lDQDZ9EZw==
X-Google-Smtp-Source: APXvYqxt/eEZY1pfLi8dYUqvtfJsadLwF9ODRsu31xQVs4G3eyBei5WZZoFF5dIu0ddpa1AZz3ySyA==
X-Received: by 2002:a1c:b745:: with SMTP id h66mr7732077wmf.70.1567785672670;
        Fri, 06 Sep 2019 09:01:12 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:12 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 01/11] devlink: extend 'fw_load_policy' values
Date:   Fri,  6 Sep 2019 18:00:51 +0200
Message-Id: <20190906160101.14866-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add the 'disk' value to the generic 'fw_load_policy' devlink parameter.
This value indicates that firmware should always be loaded from disk
only.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params.txt | 2 ++
 include/uapi/linux/devlink.h                | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink-params.txt
index 2d26434ddcf8..fadb5436188d 100644
--- a/Documentation/networking/devlink-params.txt
+++ b/Documentation/networking/devlink-params.txt
@@ -48,4 +48,6 @@ fw_load_policy		[DEVICE, GENERIC]
 			  Load firmware version preferred by the driver.
 			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH (1)
 			  Load firmware currently stored in flash.
+			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
+			  Load firmware currently available on host's disk.
 			Type: u8
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 546e75dd74ac..c25cc29a6647 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -202,6 +202,7 @@ enum devlink_param_cmode {
 enum devlink_param_fw_load_policy_value {
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER,
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
+	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
 };
 
 enum {
-- 
2.11.0

