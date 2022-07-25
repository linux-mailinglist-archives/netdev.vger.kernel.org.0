Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D3B57FB61
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiGYIah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiGYIaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:30:14 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403AC140D6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:57 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id ss3so19121105ejc.11
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=5w2jDgTrwtCiyajrFlFwP52qiY+fVoCBUQPnxQaKFzM24Q92+mqkHjS55vqchYhcYU
         danZBZoVEk1gmzYAOUhQ9fKeoO3vXrckvtyX5GzhWUIGyrsvKaUt7uK7qfk5Fp+59eoY
         D1a8FTQpl3cjMYUaztVnolKADnE6Shqsqw8eaf+MyRh/w8y6ozz2GQVkvqonUWtAtLzQ
         wb7BS6QS/Os8NxfBNX1ZbzWEEkNDxfYFnfhQbWzkQQfordw2mWUL4ar/R9dNHz2C1uL5
         diLJjxSVmJNEPVjDIBDy2m74fempMBOWEX0YxVzUfL4gTFQdzHO5VjXVmqh0XyI5rLH8
         UpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=3+mWQb/e0iIFa5h4GMdhJpiyksbjOoEdjHVM9Wfia9I9K7M8cj0jh3il1eqTirxdF8
         MkDNj3duUK8p48BxG6WvxKkr0aqzaBgWRoIl/ISrcIMEEgtPcyW7sMPqKYZQxJja+41B
         UHy998L2IzIeTWxuUK1wge8t9PjY9QJf/mcmpjt+881JNBxnxPdgfusDgDGxIQj1U2Vh
         +dqXYyWXDg6w1QnR3YZYp9Nm/yAyvGecACdwxdhISKj0+4SE5H+dTmv0hmLo7cO6WEfH
         OkzWPDdktOjNyVO+AGqBTGrYdHVzTWEVCf2CFFXMmVtFUSQ4LScIePyU9Q5wTnpsheOG
         IbSA==
X-Gm-Message-State: AJIora9a0DyPZMEcK7pteNMFmzomFBcMW6M0QC9jzGRCURjVi19KD9vc
        ZR67X/t1nswaT8cyxLwS2t43vtX1vU4gJ2McHN0=
X-Google-Smtp-Source: AGRyM1sl93M5wz0m+GbDkBR7WHURoKRUNBF3WD4nfnQ/jtHcZ3hBdsKRzGwx3dgTyF8d4OWijDFr4g==
X-Received: by 2002:a17:907:2e0d:b0:72b:8cd4:ca52 with SMTP id ig13-20020a1709072e0d00b0072b8cd4ca52mr8928704ejc.541.1658737785134;
        Mon, 25 Jul 2022 01:29:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s20-20020a05640217d400b0043baadb2279sm6874123edy.59.2022.07.25.01.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 12/12] selftests: mlxsw: Check line card info on activated line card
Date:   Mon, 25 Jul 2022 10:29:25 +0200
Message-Id: <20220725082925.366455-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
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

Once line card is activated, check the FW version and PSID are exposed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index ca4e9b08a105..224ca3695c89 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -250,12 +250,32 @@ interface_check()
 	setup_wait
 }
 
+lc_dev_info_active_check()
+{
+	local lc=$1
+	local nested_devlink_dev=$2
+	local fixed_device_fw_psid
+	local running_device_fw
+
+	fixed_device_fw_psid=$(devlink dev info $nested_devlink_dev -j | \
+			       jq -e -r ".[][].versions.fixed" | \
+			       jq -e -r '."fw.psid"')
+	check_err $? "Failed to get linecard $lc fixed fw PSID"
+	log_info "Linecard $lc fixed.fw.psid: \"$fixed_device_fw_psid\""
+
+	running_device_fw=$(devlink dev info $nested_devlink_dev -j | \
+			    jq -e -r ".[][].versions.running.fw")
+	check_err $? "Failed to get linecard $lc running.fw.version"
+	log_info "Linecard $lc running.fw: \"$running_device_fw\""
+}
+
 activation_16x100G_test()
 {
 	RET=0
 	local lc
 	local type
 	local state
+	local nested_devlink_dev
 
 	lc=$LC_SLOT
 	type=$LC_16X100G_TYPE
@@ -268,6 +288,10 @@ activation_16x100G_test()
 
 	interface_check
 
+	nested_devlink_dev=$(lc_nested_devlink_dev_get $lc)
+	check_err $? "Failed to get nested devlink handle of linecard $lc"
+	lc_dev_info_active_check $lc $nested_devlink_dev
+
 	log_test "Activation 16x100G"
 }
 
-- 
2.35.3

