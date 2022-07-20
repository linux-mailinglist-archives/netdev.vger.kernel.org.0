Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8A57B956
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiGTPNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241168AbiGTPNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:13:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D95B5886F
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:54 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id i132-20020a1c3b8a000000b003a2fa488efdso1545153wma.4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=OKjs13hLMaOhH50xbK97aCleR98fOhYkbirIUMVxvmMDTGL3sPg8hvOgi6eP2Eqhgh
         zGCLsD2QJ4Wxtqt1Phb4dsyykq3yBS97MjpwIKVWjl9H0IlHO9fTZLQbFtF3wFOjZM5M
         Tqo/sjUNHAtEbbeIKzv1qc/43059gLlXi+oPcF0li4l0vIDjcYQQPgFbpzR+9c6smP8P
         2d+2pUjn13REF0WljPw/v4fQGfZwPjstuTkvL+Fwq+5e5DjU8bGME/awKO0Fb5GRCm0+
         5kDnPBQWy1dpXvg06fHvEO3rUPqKHsUYeu3uumDzJnhkBuSkn+qGg0LAFzwdrByv8c3B
         DJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBiHGApY9AeZlxNFdVrppuoURWMXeJrxh0IUdxyISek=;
        b=haBgRVynWzHFtKKKrkS58e2NTpH8X5GD2c0Zqns9WPmHDI+0vLaddBE4sKkWRdSWw6
         wX4H1vjJ0oVrNXQwc7sYVKNWCZNmT2tUI2MqbscJPhKul7mhtwMoJNFHJbqweEA0sXiG
         XCEZQ6gjcAxgvjX/FKQEZM2YiJYeBe6x8nIR71w4E/Um3R+LZqICoPLEu9wDGdXZP0T1
         p8G0FAUS5NkKNY2f6zvl7RIWRZ7126VVSJWpCSE6Re9euf1OYFz7IwKhJxNk6Srvznlq
         Fd//eR9ZYXUXUr+aDHEoTUcj2cw5qpsKAK4zaILjI7YY2bw3d+6y6yoFuPPhNVp2jSTx
         wbbw==
X-Gm-Message-State: AJIora8WpXLDxIly31sEi2D/0hLBe/kH+yZeY2aJTX5hLpHKIANJ2b/r
        ExEE2g7N4XYbRP7KF2apW+cYvVlQNfd/IiuJ9bo=
X-Google-Smtp-Source: AGRyM1vVg1i+40KkDc5ukJMm6uTOimb1+GqL3YKPVJcDWGPjn2cZ+3sktz+JBl+quZRNFQiCrFHAPg==
X-Received: by 2002:a05:600c:2ccb:b0:3a2:f171:8d74 with SMTP id l11-20020a05600c2ccb00b003a2f1718d74mr4420633wmc.47.1658329972609;
        Wed, 20 Jul 2022 08:12:52 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o4-20020adfcf04000000b0021d7fa77710sm15837453wrj.92.2022.07.20.08.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 10/11] selftests: mlxsw: Check line card info on provisioned line card
Date:   Wed, 20 Jul 2022 17:12:33 +0200
Message-Id: <20220720151234.3873008-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
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

Once line card is provisioned, check if HW revision and INI version
are exposed on associated nested auxiliary device.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index 08a922d8b86a..ca4e9b08a105 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -84,6 +84,13 @@ lc_wait_until_port_count_is()
 	busywait "$timeout" until_lc_port_count_is "$port_count" lc_port_count_get "$lc"
 }
 
+lc_nested_devlink_dev_get()
+{
+	local lc=$1
+
+	devlink lc show $DEVLINK_DEV lc $lc -j | jq -e -r ".[][][].nested_devlink"
+}
+
 PROV_UNPROV_TIMEOUT=8000 # ms
 POST_PROV_ACT_TIMEOUT=2000 # ms
 PROV_PORTS_INSTANTIATION_TIMEOUT=15000 # ms
@@ -191,12 +198,30 @@ ports_check()
 	check_err $? "Unexpected port count linecard $lc (got $port_count, expected $expected_port_count)"
 }
 
+lc_dev_info_provisioned_check()
+{
+	local lc=$1
+	local nested_devlink_dev=$2
+	local fixed_hw_revision
+	local running_ini_version
+
+	fixed_hw_revision=$(devlink dev info $nested_devlink_dev -j | \
+			    jq -e -r '.[][].versions.fixed."hw.revision"')
+	check_err $? "Failed to get linecard $lc fixed.hw.revision"
+	log_info "Linecard $lc fixed.hw.revision: \"$fixed_hw_revision\""
+	running_ini_version=$(devlink dev info $nested_devlink_dev -j | \
+			      jq -e -r '.[][].versions.running."ini.version"')
+	check_err $? "Failed to get linecard $lc running.ini.version"
+	log_info "Linecard $lc running.ini.version: \"$running_ini_version\""
+}
+
 provision_test()
 {
 	RET=0
 	local lc
 	local type
 	local state
+	local nested_devlink_dev
 
 	lc=$LC_SLOT
 	supported_types_check $lc
@@ -207,6 +232,11 @@ provision_test()
 	fi
 	provision_one $lc $LC_16X100G_TYPE
 	ports_check $lc $LC_16X100G_PORT_COUNT
+
+	nested_devlink_dev=$(lc_nested_devlink_dev_get $lc)
+	check_err $? "Failed to get nested devlink handle of linecard $lc"
+	lc_dev_info_provisioned_check $lc $nested_devlink_dev
+
 	log_test "Provision"
 }
 
-- 
2.35.3

