Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E44F4A4AD0
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378302AbiAaPmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:42:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236278AbiAaPmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643643728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1sW7rzPQhozZJd5bIGL105H+ak+PyChDVEsMpXF5SsA=;
        b=SHXNEavP4wt5WkTAG9cpyC52KbWEffO08a1QVF0ltEDyUCM/XE/I2+JkcSMhn5Cf73CIcC
        XGllYFLKioDIPDnyJxtHnRRUQnH9b8ojZlN6qxXNjC4gj/atSppZMEOQ5cyfTcPi8j04n6
        bgRQe2EELF9Tj2uR7NJJDpckOGbm+mw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-Ika_AB1QOTWLbousKcE1dg-1; Mon, 31 Jan 2022 10:42:05 -0500
X-MC-Unique: Ika_AB1QOTWLbousKcE1dg-1
Received: by mail-wm1-f70.google.com with SMTP id f188-20020a1c1fc5000000b0034d79edde84so3094212wmf.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1sW7rzPQhozZJd5bIGL105H+ak+PyChDVEsMpXF5SsA=;
        b=oOivtnn3cVXZmkK6DNyKPI++1ClIAP1ahsBr3Iq0wD73TAmErLW5H8yO8dYQ2n4cJ2
         G8i/dIZX8QvFWjrSEAdAu51nK3hrs0n+eL1Bqer42iG34WqgNRz+iNMHpNJ4dD+fZeXk
         EVUdYmShLNjh1U1xM3E0giY6ig4bqpX7b6wALdg1M50zLm6NMKy2W2k7qCl3xbz/AuZI
         976Uund/smO7A56t1kv4hD8KVHiYplWY3aG9zHEjC/rUzqMw+jSYEw7uq2uMob4xUQ2V
         +Qam9mXbQ6VfZeB0abBhs5g2v+VtAbeLPOc9FeieqvSUUBfTV6dWGHrWeepbJLLLZxrM
         6+YA==
X-Gm-Message-State: AOAM5303Zq3CmZ4N2sD+c3AzXexJqMCSmTi962r+dv2s2VaVk1NLSILX
        x25ySt7+p1tI43rU/i+KIWANfb8EKQVrQ5sGq7R2uE/2D/sW1KAJaU+o6wl6yxNL0SIHW8JMPpn
        2X2qtbnDXIpiPgVL+
X-Received: by 2002:a05:600c:4606:: with SMTP id m6mr18884794wmo.158.1643643724084;
        Mon, 31 Jan 2022 07:42:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxby5+LXKmhGyrUYjq8E3JvF/Tb4DHqOiKvlAvELRnZXgXmO2oDHs3fV9s7zGDIfs9YNcWdTw==
X-Received: by 2002:a05:600c:4606:: with SMTP id m6mr18884782wmo.158.1643643723938;
        Mon, 31 Jan 2022 07:42:03 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p17sm12454713wrf.112.2022.01.31.07.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:42:03 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:42:01 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net-next 1/4] selftests: fib rule: Make 'getmatch' and
 'match' local variables
Message-ID: <6c58c82747ac8351105a0d25eefc594206d414d6.1643643083.git.gnault@redhat.com>
References: <cover.1643643083.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643643083.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's restrict the scope of these variables to avoid possible
interferences.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 43ea8407a82e..f04f337dd7c6 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -115,6 +115,9 @@ fib_rule6_test_match_n_redirect()
 
 fib_rule6_test()
 {
+	local getmatch
+	local match
+
 	# setup the fib rule redirect route
 	$IP -6 route add table $RTABLE default via $GW_IP6 dev $DEV onlink
 
@@ -184,6 +187,9 @@ fib_rule4_test_match_n_redirect()
 
 fib_rule4_test()
 {
+	local getmatch
+	local match
+
 	# setup the fib rule redirect route
 	$IP route add table $RTABLE default via $GW_IP4 dev $DEV onlink
 
-- 
2.21.3

