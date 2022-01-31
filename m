Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B084A4AD6
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379793AbiAaPmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:42:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350284AbiAaPmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643643734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1JlgLZscDoIFop5dBhXgA1KNuotqIeX45MP+1J3nAYY=;
        b=YeFsNng0zShieqie30KAPYmGtfDhnkTyhyjyaoxkaXQDD6rUrPOC4gPkKFjm/x6O+QoZnw
        Y6lLduTuQsnWqJLcTWbcw8QaBT5tS/9hMGpBTCMR5owlN/CF3Gq40ppbzNV4BN9es2qNEQ
        lcf8VhOXfLzbJ40+C7ex1hSZJsZlsf0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-btatH3vsNJyKAT-dZ1qVIQ-1; Mon, 31 Jan 2022 10:42:13 -0500
X-MC-Unique: btatH3vsNJyKAT-dZ1qVIQ-1
Received: by mail-wm1-f69.google.com with SMTP id m3-20020a7bcb83000000b0034f75d92f27so5922276wmi.2
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:42:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1JlgLZscDoIFop5dBhXgA1KNuotqIeX45MP+1J3nAYY=;
        b=8H/KxlsLn6pOH7+6U0//emxdqjjGhe8sojvk6pM+l2utwojzL0W3ofVUHcbi5TsfYn
         fOIiNqu/O1LpCrjijSy8AXgIJ5HtGKYl+esiP0tpvB56xl6P5mB4vqMKF22eYcQ7Y5tQ
         YRHoxxJA+I+OYKEV5JJziHlKWCkGYjoDpV49G6rBbbNFlGrJKvcTnhVBL8H3rsnfi7DB
         VKtWiGNgSwqQPkK3gK8qIOgYAJ/Hlo60kbTvfaItLwfoEh9y8lc7xRIOWsYulJPr593b
         gKU2gQd8VKiFTy0Uqm1/tBGfqXgCCgP+uz6+vzQMZlm/EAWtEOnogJlLrEctMS4tpg1S
         dCZg==
X-Gm-Message-State: AOAM533H0y/BQ+C+oJmXudJL6s/JSuO2LK6X1tKVpsKFYwYmns9hOXuR
        qpbIc11KbK1ZsFDYhA/QIVUNejikHm35A6QSIbZeVdJnwWTS8ziMogco0xgQ0hz08QIYN0IJpmT
        5j7T/+gUaLELfJC2K
X-Received: by 2002:a05:6000:15c5:: with SMTP id y5mr19027260wry.656.1643643731547;
        Mon, 31 Jan 2022 07:42:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygQlVQ+YgRpR5xEHj4gvtNZSfcyjb7bmNGvYeSOgWRfcZ4vdWME0LKdI1icjsxp88B6wNo3A==
X-Received: by 2002:a05:6000:15c5:: with SMTP id y5mr19027244wry.656.1643643731344;
        Mon, 31 Jan 2022 07:42:11 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id f13sm10379789wmq.29.2022.01.31.07.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:42:10 -0800 (PST)
Date:   Mon, 31 Jan 2022 16:42:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 4/4] selftests: fib rule: Don't echo modified sysctls
Message-ID: <6baa96248e33682166fa295ec98a472d02f4767a.1643643083.git.gnault@redhat.com>
References: <cover.1643643083.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1643643083.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run sysctl in quiet mode. Echoing the modified sysctl doesn't bring any
useful information.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 6a05e81fc81d..3b0489910422 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -200,11 +200,11 @@ fib_rule4_test()
 
 	# need enable forwarding and disable rp_filter temporarily as all the
 	# addresses are in the same subnet and egress device == ingress device.
-	ip netns exec testns sysctl -w net.ipv4.ip_forward=1
-	ip netns exec testns sysctl -w net.ipv4.conf.$DEV.rp_filter=0
+	ip netns exec testns sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec testns sysctl -qw net.ipv4.conf.$DEV.rp_filter=0
 	match="from $SRC_IP iif $DEV"
 	fib_rule4_test_match_n_redirect "$match" "$match" "iif redirect to table"
-	ip netns exec testns sysctl -w net.ipv4.ip_forward=0
+	ip netns exec testns sysctl -qw net.ipv4.ip_forward=0
 
 	match="tos 0x10"
 	fib_rule4_test_match_n_redirect "$match" "$match" "tos redirect to table"
-- 
2.21.3

