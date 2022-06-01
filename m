Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB353AC23
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 19:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356406AbiFARnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 13:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356403AbiFARnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 13:43:45 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5B16FD0C;
        Wed,  1 Jun 2022 10:43:43 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d5-20020a05600c34c500b0039776acee62so2587290wmq.1;
        Wed, 01 Jun 2022 10:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7cbknEZGUGD2cxU937ieJPI9qyLodJRcbX0FPdvitY4=;
        b=ifBZEtRLIZDgnjgCirPIRbDpD4+2k0ji6YiTOqqGf3vyBHkTGgWU2FrXcQ65T2Nv6E
         LY/qQy0xpRocxt2MjbXIYNEzJ5ZIbgr8eTQtVAtSoW0BMfJq0KRJGhn615hQkdbri0zQ
         J4oMNV2moa3q/9jdiTR/9qVYAwv34VDvnA+b7Nb0aYmKo41fEnWhToQzLiAG3RAG8Jo5
         2VA9+UXbujviKWjeHig9tJohVjITD6sctW6AlJ/tglBmib/ME5dB1G7nHe4FYASNaTOo
         OCCI2o7RMJeTcCEgRKYNnNhJKsKpHmpDmIZnH8q8UkySlK0gc8Mbf4q2rkJpPrWkXmIi
         ZnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7cbknEZGUGD2cxU937ieJPI9qyLodJRcbX0FPdvitY4=;
        b=VIXfzlOZUnRhA8XL6w/h2qNY7igHEAUO/5MDEwG1UcCNfTrkY3s8K3eiJWBfrXgQj5
         4tgpRDmiFGFSWxLYd965xeW3U76oe/XKX0ecZFgr7nNZwXm+p6v7Ibr4O7UCX/PQnQl+
         QiUtoPkFf6y2bhwn8Hf1FXHH8g/JKQteuqI/pP3i5G+KYGHOrexoTOvxswxeCG+n5XbN
         d3TSarKda17yrJEt3sikKRlKJPBVmGKW9NPcQO9Uxml030swLSFpTmmZ0lJOP1OeHy6k
         IX9AXX1Fz0bvf8+dqA1Rtb7vRDHteDMmL1COunambumI8e6zbZpdcSj4jiEO6CQtHm/p
         r+Nw==
X-Gm-Message-State: AOAM531KW7T8Xk5IQUh0sOV/v7RddKYV08Ta28+4O7hGD1F2YW84ufkJ
        6jDLbfwD2qkwrN9RXrd2rdDjkzBGvK4=
X-Google-Smtp-Source: ABdhPJwLxV/v4JoM4W2W2dE7sIidkESeRh7JcIp8hPqVguQXHIYFoQQsNd4zVoXzYP27YjKcYKfeGw==
X-Received: by 2002:a05:600c:1f0e:b0:397:707f:5a60 with SMTP id bd14-20020a05600c1f0e00b00397707f5a60mr463432wmb.3.1654105422243;
        Wed, 01 Jun 2022 10:43:42 -0700 (PDT)
Received: from localhost.localdomain ([197.57.182.33])
        by smtp.gmail.com with ESMTPSA id az29-20020a05600c601d00b00398d2f6b5d8sm2940824wmb.4.2022.06.01.10.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 10:43:41 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2] selftests: net: fib_rule_tests: fix support for running individual tests
Date:   Wed,  1 Jun 2022 19:43:16 +0200
Message-Id: <20220601174316.4278-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parsing and usage of -t got missed in the previous patch.
this patch fixes it

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in v2:
	edit commit subject and message.
---
 tools/testing/selftests/net/fib_rule_tests.sh | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index bbe3b379927a..c245476fa29d 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -303,6 +303,29 @@ run_fibrule_tests()
 	log_section "IPv6 fib rule"
 	fib_rule6_test
 }
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+EOF
+}
+
+################################################################################
+# main
+
+while getopts ":t:h" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
 
 if [ "$(id -u)" -ne 0 ];then
 	echo "SKIP: Need root privileges"
-- 
2.25.1

