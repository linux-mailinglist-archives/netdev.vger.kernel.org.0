Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B25423D2C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhJFLts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhJFLtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:46 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800FDC061749;
        Wed,  6 Oct 2021 04:47:54 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x7so8734827edd.6;
        Wed, 06 Oct 2021 04:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vt0NBmFfay7kkrnrDFUj1c9VXYawXVmI+68SUXjE5XQ=;
        b=jUH3vTk4EL2k5O2twAyUHIl+Oq7b7GjhOjSIJlTZOVqGTb5W3rGbTg+hNnO2rrogJ3
         B/cm54x9tqi4dE5pjbzo9y1P8a+BDwzLT/jDMQf8PZqlC3esKlOiwQ+9sP8ua6oAFAix
         sREDOaWy9XnK3c3FuPoq9AOaFXgzyqNpeXIJuW6zJoZ6Rgcn49M8JY1s3EMu3mZRK/Yf
         zoKsd1tKQ/99I+aHCYKOpVuX62pn4PhWn+7O0ge5xTr8ixQ9CLG3LEsiqBmvLxPc56qW
         MCkxYNOjZm7WOONJPY7sgJ3/d7wJUW+pfZpNCnZrcrUvaTPXA8aO2URUCY2MGsWDVOXr
         zM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vt0NBmFfay7kkrnrDFUj1c9VXYawXVmI+68SUXjE5XQ=;
        b=oRU76LhKYEgQKXa76i3Pyk6qDAcLqk/kluk/g8/jT9MJ5qnspQDOjTffAl/cIJ24vf
         A13AmQm8Qe98r4BC0A7uL0tGnr3q2inw/SjRkcULjnvTB+lDHyB/JToWxLlzUCI0xnow
         9Mz/UksOB0SzNttW1U6pT5laGHxIonFxH9TXyqJuGKUQj/w26yE0pixCEvqzTf1d3Yi6
         RcSbcEInj/uwD5Jwaz1E5+pZ8tXyN6x1U+reFvAg7oKWECIPZpmxnLZOlMCNCYH6Wd9a
         8sO8HgNvts59iexRCPFK9XlVX573o06zpoPmUde3CtBiBztkYtx/eDfXlnHsm3ZppfHu
         J2zg==
X-Gm-Message-State: AOAM533tAFX12AHx7Q0JoWdQfCG8qGcngZVS3D0eKfsYhbFrm/NAA1/A
        QtU5dTRTafzUYQ3ZJEPvW/galkTGeqtCu/NJ9vQ=
X-Google-Smtp-Source: ABdhPJxCl+vFpnD4+pHC1ZRtCJYoaz/ysBhS61vfXewSVTlzOYkxOqBr/JNTd+Ra+/skrEFl6OaFqQ==
X-Received: by 2002:a05:6402:376:: with SMTP id s22mr12868841edw.27.1633520872276;
        Wed, 06 Oct 2021 04:47:52 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:51 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] selftests: net/fcnal: Fix {ipv4,ipv6}_bind not run by default
Date:   Wed,  6 Oct 2021 14:47:17 +0300
Message-Id: <44c1cf86c0ff6390f438e307a6a956b554a90055.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inside the TESTS_IPV{4,6} array these are listed as ipv{4,6}_addr_bind
but test running loop only checks for ipv{4,6}_bind and bind{,6} and
ignores everything else.

As a consequence these tests were not run by default, only with an
explicit -t.

Fix inside TESTS_IPV{4,6}.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 13350cd5c8ac..2839bed91afa 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3937,12 +3937,12 @@ EOF
 }
 
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime ipv4_netfilter"
-TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime ipv6_netfilter"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter"
 TESTS_OTHER="use_cases"
 
 PAUSE_ON_FAIL=no
 PAUSE=no
 
-- 
2.25.1

