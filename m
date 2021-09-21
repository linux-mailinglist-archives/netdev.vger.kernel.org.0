Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC44413731
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhIUQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbhIUQSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:23 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A3BC061574;
        Tue, 21 Sep 2021 09:16:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id u27so4133195edi.9;
        Tue, 21 Sep 2021 09:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SFcfoPPel7lTojPt9vUi/iKxjORTRUrzm14vPDBAPlA=;
        b=okRVqlfk3og9Jtrd65RJID0/aJeYAm8Va0Lr+okgjWMwqTXGx8DVjyHOHkK+b/NiQP
         q5APFtRbieLYz9xoXUUMkS3abJcj87JDvZ3CQwQF0dUHW3h978iey/xnsoSjfkHFIu1q
         qCvEreqfh2tG9hwJEelcHFLg11U6WS1xDD5v4UBkbJ0VU4zSPYrql+J8W8Y6JPFNX7wq
         uQJsPkD8nb9TfyLK7HjKh6LFSY0NnNJkzlzSYbuaHDMGR8f2vo1r/bsUwmpDkoi9fYla
         MzQvdCiF69MeXRU4RMWIt+P3Gdb5rfgCHot7/VfCJqKs9Hig/A/ZawmpbjumbQcUHRiN
         im3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SFcfoPPel7lTojPt9vUi/iKxjORTRUrzm14vPDBAPlA=;
        b=mXM9DdlnZm2wIa8N+hgnv/WD5jXEtPBQjs5Nw2JyEH7YmHA4Vd9v7K8ynt0PIy30jF
         V+N5IvhOdoU4K6xSboozKvdxpR9I0+Rm932uURqF68R9kHx8xOl/ZMdXwiqhA3Nm/uZZ
         SH+5S/FGKxmwA0Fw1DxAsmnrvd+8WhIj6MEgG1/+mFb4jAOaABtBv7QQsnypRC07CGCA
         ldv50n0K+YH27z4eQqRwztGeb0sqbapkiON4NBFo+d3rq5hBdf8ZD+Z6lYb5eANpNkuD
         0khE60BpLeYB2zC07Zo1YS3ylCH/zBZpVfNGSdcJ4CwsfrB5WD0mqvbdhYcDzoFO/cZb
         Qlxg==
X-Gm-Message-State: AOAM532vG+c/Z9uQo0H3NpOgn4svNJvyG54ww3dIRkAAFlB/ZqE6223s
        Uy+re3ExF28cd01J60vILnY=
X-Google-Smtp-Source: ABdhPJyFtJiRAGfWkAT2Olxg6++rMn+qLhemQeDmBPRpx4WcxDa3mjb5C0+/K4EraLJEu6/zZF8dkg==
X-Received: by 2002:a17:907:760d:: with SMTP id jx13mr33129121ejc.194.1632240946508;
        Tue, 21 Sep 2021 09:15:46 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:46 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] selftests: Add -t tcp_authopt option for fcnal-test.sh
Date:   Tue, 21 Sep 2021 19:15:00 +0300
Message-Id: <c52733a1cd9a7bd16aea0b6e056fad9dd1cc5aed.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This script is otherwise very slow to run!

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 74a7580b6bde..484734db708f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1331,10 +1331,21 @@ ipv4_tcp()
 	log_subsection "With VRF"
 	setup "yes"
 	ipv4_tcp_vrf
 }
 
+
+only_tcp_authopt()
+{
+	log_section "TCP Authentication"
+	setup
+	set_sysctl net.ipv4.tcp_l3mdev_accept=0
+	log_subsection "IPv4 no VRF"
+	ipv4_tcp_authopt
+}
+
+
 ################################################################################
 # IPv4 UDP
 
 ipv4_udp_novrf()
 {
@@ -4021,10 +4032,11 @@ do
 	ipv6_bind|bind6) ipv6_addr_bind;;
 	ipv6_runtime)    ipv6_runtime;;
 	ipv6_netfilter)  ipv6_netfilter;;
 
 	use_cases)       use_cases;;
+	tcp_authopt)     only_tcp_authopt;;
 
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
 
-- 
2.25.1

