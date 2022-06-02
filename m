Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790CC53B224
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 05:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiFBDZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 23:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbiFBDZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 23:25:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AE927F5CE;
        Wed,  1 Jun 2022 20:25:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j7so3753253pjn.4;
        Wed, 01 Jun 2022 20:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AFDK2qPVxqM8+WUlL7u1WOST3T5Ymo7VG05+dcoLhgI=;
        b=mAwnLs1Gaw5S8IQ/QnRPqUFhT9elf7uCzSLvr49n5ykg9KzBWWMviGC8tP2PwK+07c
         mtJ5p2iA1+URyrwS4RqkadmzwJW5tr77bDilQvWgG2bUA+idyw3ErX7mGWMSkdpO50e7
         QTu5kTv14PNv0u0MeQ+dZrYL8JuPcEvHWZ9fHYqPe585Gc+jBoqiippscuopkcX3+atc
         LZETOKjU4eKZQQPxRHsxkHl/VHWY3LSjwcJPsTv886fuaBDR6AiLq8xGi8kL8FM46ecE
         K45ZBma8mu8TbLBc7ooXtfyIEoK/QorYaTp62+n6yG+WhmaMMWGIwnVLs+oOwcG5UICG
         4N/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AFDK2qPVxqM8+WUlL7u1WOST3T5Ymo7VG05+dcoLhgI=;
        b=UuNL4AmMvbV5JeBAOpiUbpF77Rou3tcPDE7voENy5YIQvvmB0TUD4xJ65NbDdEyyYl
         kBJlZsBfr/r+RHe0Q39xPCOS0WlHrL50Zx069XLPwsgvUeiqfblgeSPJJ2WD3JMdKkPs
         id/6ZOSCaHkwFnFsitya84vYyZbSh7sygzDydD3bWMJAvsYK2pgYyJroWwCnrefEnrvw
         YWRIF73HkqdYQdOUP7q9vDYxHnvEGFGjRlESP0JuLJroqvtB6cYtfBuYNKMRYmpYgFW8
         9MVAl/INNaCUa3pQ+xowMV1CFR3l0R9p+ko+dAIZfkWM1xa5R/vn6ofJQntDXCzHCA9P
         c3jg==
X-Gm-Message-State: AOAM532DQcICuoibsfnfrWTLEezC5DKPF+2e+vb4ZQZV8BVH+XUawHHN
        meklsEovQFMc5JQEhZYkGUxrjC2cEXRICw==
X-Google-Smtp-Source: ABdhPJz52twN/zD8CEgdGAN0wIH2Dp5PrfZ3jsI4fm+nCfmpGYnzQAmA5WcA39iOpQQvclRiGoC9OA==
X-Received: by 2002:a17:90b:314b:b0:1e3:1033:f555 with SMTP id ip11-20020a17090b314b00b001e31033f555mr17899334pjb.245.1654140322762;
        Wed, 01 Jun 2022 20:25:22 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 84-20020a621857000000b0050dc7628158sm2200625pfy.50.2022.06.01.20.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 20:25:22 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: add drv mode testing for xdping
Date:   Thu,  2 Jun 2022 11:25:07 +0800
Message-Id: <20220602032507.464453-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

As subject, we only test SKB mode for xdping at present.
Now add DRV mode for xdping.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_xdping.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xdping.sh b/tools/testing/selftests/bpf/test_xdping.sh
index c2f0ddb45531..c3d82e0a7378 100755
--- a/tools/testing/selftests/bpf/test_xdping.sh
+++ b/tools/testing/selftests/bpf/test_xdping.sh
@@ -95,5 +95,9 @@ for server_args in "" "-I veth0 -s -S" ; do
 	test "$client_args" "$server_args"
 done
 
+# Test drv mode
+test "-I veth1 -N" "-I veth0 -s -N"
+test "-I veth1 -N -c 10" "-I veth0 -s -N"
+
 echo "OK. All tests passed"
 exit 0
-- 
2.35.1

