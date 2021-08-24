Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B53F6B3B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbhHXVhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237947AbhHXVgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAC9C0613A4;
        Tue, 24 Aug 2021 14:35:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g22so3367016edy.12;
        Tue, 24 Aug 2021 14:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WC9CLL+GQfxX/OVHxKvhiDhxNKgqk2CwgSEf4KWoZuk=;
        b=J9qFeUgvYUSBE32GcDCZZHdpI20xKXMGMzihyKPxyGGfp+SVzobHOwoal3WNOL7sIS
         uVwgxz9ShIWQNox9pWTZhm8F9ygbzltebL9MhkEZhiEy4fUyDOqPR15R76xlltUwUPp6
         gXpTH8XEwJ0X5suIf/imw61T7zUwbkIzSZlzbQDX+JBLXzk81sw11bZiiiDPYrgUVIQC
         SUB1P7BNRZ3b7hpw0R3y1/syO3DIT8Q46vtqYOCx03jv7qTJ3SIPc9GyzcSgg5ZV+Xtn
         LRUAlrAA8H5SKgarmYSh8/CO+JlRR4em0E1QpgMfF3f9FfkiT1WNTXxFNilobyjrCC9/
         e5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WC9CLL+GQfxX/OVHxKvhiDhxNKgqk2CwgSEf4KWoZuk=;
        b=oPEDmLShMtMVdKedBUNLBUQnUGk9tJC5UXOxSB5ta2XVMHnGFMV3lPlKs3PkTB78QZ
         ibjkvXZtUJAxvSUtUQ+bdD1AteE8oxBKAPtYzUP2tVxxyEnOgncVLslj6S+j56FGM8Ua
         nxYfPlO9X18DkSIf7n6l/JaIhqMPXJDGOgc9fmoY9gLgdQbvzfELwKA3Q6tnAZaarx5F
         TmA6cWBbPPz6b5iwQvjX64uSycd9qSUDTchCp/vMyFctBb/Nw1lLp02FSmx5YmeT+XoC
         rKDz0d5/2DMiFYHtXFaotm7cLd/JxfhlgIQ2mFSSLpOONO+Vx860lOwYDdQ9i+9bmz/w
         9EPA==
X-Gm-Message-State: AOAM533ho27f8lr8H05LjkDgTNSiiVZ3RZzGlaUltTw6RtOEGAwbgD3Y
        FMbo213lXfiXeOJUdEv9FwI=
X-Google-Smtp-Source: ABdhPJwfUHTMvcgVULz8cVgFtpyKuP4qM2asoKjPBh0JWU38ul86QZuzUjd/o7SGK0gclaS3vvRkwA==
X-Received: by 2002:a05:6402:278b:: with SMTP id b11mr44150896ede.339.1629840948848;
        Tue, 24 Aug 2021 14:35:48 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:48 -0700 (PDT)
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
Subject: [RFCv3 13/15] selftests: Add -t tcp_authopt option for fcnal-test.sh
Date:   Wed, 25 Aug 2021 00:34:46 +0300
Message-Id: <485a15f11d134e489952d48b45891163d9c1a59c.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
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
index ca3b90f6fecb..3fa812789ac2 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1328,10 +1328,21 @@ ipv4_tcp()
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
@@ -4018,10 +4029,11 @@ do
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

