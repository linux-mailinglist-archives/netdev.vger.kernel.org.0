Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010663BE42F
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhGGITG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGITC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:19:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73C1C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 01:16:22 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g22so1425069pgl.7
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 01:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ab+XUpH/sh8gx3EPEeKlEwvD2Buq3wd3nop02wDBVlU=;
        b=LVKXWCqvpxXZwEyU0CIe9VCUHK6gmg64QIMWWv8gSAtJzWzoH3X8OhGqHLW3SNnj/H
         xW6XQgOBrEeaLmdWlIALE2bmo7lKIfa3ypQmm7Sk1J4y+8pzHR5UhlSksZuHh9J3w/P+
         KbqblumSBHlIDerp/lWU6fRgL9VNO4LRQX+n6aJLJQXPsKixnrN8MB5OBuwLBdyMqVt3
         /SWKMD5lmHAolOg7fpg6i0RNyIvfv1eDYV2laMqqbR1TqMCEfVWpA4qwXSAACOwwwoG5
         EG0NwQNrwXLVKqzCEGMno0YA49tELfTu4MjiyMoVDDSFkpiPPvnDkQJd50CNyJT4yQlL
         rwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ab+XUpH/sh8gx3EPEeKlEwvD2Buq3wd3nop02wDBVlU=;
        b=Ai9z1B4850YVwPQCPxWIh5GGpNMQxuuXDEUIlkt0TjoEGgXTdXDqBZvum/eRNTZDNs
         OQu/krrXvwdHheqos4onC6XOfy2Y8Ta8la4mVEES7gRWIw9AfjB96Nc8HppQz/t5JodF
         ZIqHffdxu3km6o8YWqiqpEAo+V4W89GMK7O4+qsNPAw9TJ4+WW7LxqPiAdkJIr0BoF3A
         4ME7Z9keGLTvIA+pXdAdbRIuum8G5NI0pQrUYljvnjX+Xf5a7hkMlYb90HrqR1tnuVhq
         dJtQc/DHD5EkMfJPn+Skq6im/GTLFXsjAGa2yfSTqevba2clHa5yrCwJ9aBx/TC9AIh5
         Rh8g==
X-Gm-Message-State: AOAM530+N8JV+iqMd9Sj7J0Uf+5J7trk14ZNDFU44QbsggRKFAasljc4
        sKBOBToKLbRq5gJlRtHsLcUeb/+capfgzfBv
X-Google-Smtp-Source: ABdhPJxfEYOx4yJAOkntJ5DiqWa+PUdMGjbvHS+waK4nxkK//JTzwdmfwIlgjiulBIZxueT0lR0zfA==
X-Received: by 2002:a05:6a00:21c7:b029:2ec:2bfa:d0d1 with SMTP id t7-20020a056a0021c7b02902ec2bfad0d1mr24421751pfj.14.1625645782257;
        Wed, 07 Jul 2021 01:16:22 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u40sm15476365pfg.19.2021.07.07.01.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 01:16:21 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect
Date:   Wed,  7 Jul 2021 16:15:30 +0800
Message-Id: <20210707081530.1107289-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707081530.1107289-1-liuhangbin@gmail.com>
References: <20210707081530.1107289-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After redirecting, it's already a new path. So the old PMTU info should
be cleared. The IPv6 test "mtu exception plus redirect" should only
has redirect info without old PMTU.

The IPv4 test can not be changed because of legacy.

Fixes: ec8105352869 ("selftests: Add redirect tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/icmp_redirect.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
index 3a111ac1edc3..ecbf57f264ed 100755
--- a/tools/testing/selftests/net/icmp_redirect.sh
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -313,9 +313,10 @@ check_exception()
 	fi
 	log_test $? 0 "IPv4: ${desc}"
 
-	if [ "$with_redirect" = "yes" ]; then
+	# No PMTU info for test "redirect" and "mtu exception plus redirect"
+	if [ "$with_redirect" = "yes" ] && [ "$desc" != "redirect exception plus mtu" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
-		grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0.*${mtu}"
+		grep -v "mtu" | grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0"
 	elif [ -n "${mtu}" ]; then
 		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
 		grep -q "${mtu}"
-- 
2.31.1

