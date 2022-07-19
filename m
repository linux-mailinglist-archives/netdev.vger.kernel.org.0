Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA357936E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiGSGtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiGSGtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:49:11 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB7528720
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:07 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r6so18285565edd.7
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=GdxsHS9FbAkl/2IGH3UELZg5QOvjq+amGKb4ALYMki5PN7TqyKeTQW0aCEcmnGzO+V
         wq5FOY7HL+jA3BWrMRnisn3SBNvDdCt6mE5nPgIlsozJxp35kZGnKFu6Dlmj5S8XrsIk
         USRckNED0D0mWhZUgnloe3C5PE3e5P/vN9dUXKXw3lC+zxhPcn8Vx+G8i4ZVwFxBcHkF
         u4Kw3f4Kz/R1ubikki320k9ZHRofRIIMjVBD/J1pd+Lv5v+a5n0fXaX5s4wH04SJvg5o
         8hZFnR5k2NOPlWlKUmQg0hkf0WmHzRlh0g46/toQSZ4uHu65j6vEXB/K7azOceSkhiUA
         lMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7L4Ha1oBjbQvumuTEWh/rgUg6HLMfB7bm1xwqVywznA=;
        b=wkP0mcoVikRzx1NaJI6bTRrtT1ENEzRCUPHAu/SY5vkXS+dabxUFJZUtptXpL2po5U
         jRyjsSVOE3qnoKISQag3Qo3Y7K5Y8RjDg8fyQ4KJ3W1GqUdbOSqDqAHOw3YHBug9r2vi
         +Irg+FO58/cOVP0UMHexbW7uUXfJ1WN8AfUYcrTSIl2CfmwH4W4Arotfz3cAaz8g6toE
         +4iRevFGw/Jv7xndy7NIhQkP6wRa26ksJpOqz9KINBl0PEcqsJkS+rop725cm7aGtEuo
         f6kkXINClTKYTWaHl6GVChAkJ4r564NmGO9m4ah3W3aTlwdR7V8q9aqHfIxPUScdowx/
         /ZFA==
X-Gm-Message-State: AJIora8hMtR6GJa1a1pIVnEp252Oc3oCaqRXeKgIG/pFY5WotvGTbimu
        RJAkYZZwxoMgj7y5qb+VGdSGM+a4gQ/YmlQ7wLM=
X-Google-Smtp-Source: AGRyM1uEwNt5/5ZXFIFCp2zqPfeg4X8eV3/e62ENS/hezOYW6g3y8MroMqAnluYqLavNlQn0famR7w==
X-Received: by 2002:a05:6402:1d50:b0:43a:737c:289c with SMTP id dz16-20020a0564021d5000b0043a737c289cmr41304095edb.47.1658213346543;
        Mon, 18 Jul 2022 23:49:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k16-20020aa7c050000000b0043af8007e7fsm10032796edo.3.2022.07.18.23.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:49:06 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 12/12] selftests: mlxsw: Check line card info on activated line card
Date:   Tue, 19 Jul 2022 08:48:47 +0200
Message-Id: <20220719064847.3688226-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
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

