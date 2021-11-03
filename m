Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187C7443B88
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhKCCr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhKCCr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:47:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A374C061205;
        Tue,  2 Nov 2021 19:45:21 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso308500pjb.0;
        Tue, 02 Nov 2021 19:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HeUcTaSxkggftmtgRe63BCDaWvI0QHUiMr63WRfCHAY=;
        b=ako3dTmJ1d4z/PmNFyFJ+0xyOW/4DTHZcS7I+rw1LJJMVdnjSZ80j3jsLeR3WmzALW
         a/5OdnEMvxyGbidBBFQVCS+jwZSZF4Rz0rV2hFBzVVavKlF76aO+7lYP3kKZzCE5GaX3
         qGYxjwOljAuLuKg0COfhKo2Pv9eS/aBxSWYJ54QCR/2WnRWIjPEb0WvoaU3i1YkEc9fA
         Hh6AdHKfwFH0JbOWGp8vLqKzIJteG1ha2a4ePBcsuRkFT9WTNC/3XJcSeB4Rc8gFZOfv
         5hgl578wNUNSZIxHVQGkoHvAseWpdKAz/aJKHx0sW7m1VSH5vPHXX6rZuhs4wxCcMz5Z
         nCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HeUcTaSxkggftmtgRe63BCDaWvI0QHUiMr63WRfCHAY=;
        b=uvwsYer5yI4NUq1y/LgeEajGQzyHIVDNi08UNuOyAgwPmDv4Tfq5q7+elKp/v4pEm4
         GUthE9yo8O0TU2kkzlpN5hbX7YmPIP/gVRhhYCRUPDjmWAFXrz7Jk7mw6dXS0ASrDFb/
         seirXMMGYk0VOHSFfJ72EXefJB7Q+EtxmyGoJjw9kkTQHS+Pe/MuEwwAp1NJsCgWV5Ln
         8lHJercJIplJ3IbTpWbZQClNfisZ+h62Z6Mz9qk+2EArs9LXybYkAJtvDzPNYSbTPn7M
         MgcuLtUesDgqdDU1/5MPcVY6WgTaOzGiUkm678lqvV99po/N2yKda72Lvgot1q0mHNwF
         hnUQ==
X-Gm-Message-State: AOAM532Iqj2POr+TaJf8O91HZdIzgbQ1gsO0YJHVCFqxNRrWbbJUf18K
        ulSZMhZ+Gc2Y75Wg2iDiCZLBqJUpgSI=
X-Google-Smtp-Source: ABdhPJw52YqNn9PMhpi5f/vZYeH8n5SCPc1UARUjTvGstYw4CJd07taySLGMxEacEwCaqe8YmVb8KQ==
X-Received: by 2002:a17:902:e749:b0:141:edaa:fde1 with SMTP id p9-20020a170902e74900b00141edaafde1mr15605439plf.72.1635907521422;
        Tue, 02 Nov 2021 19:45:21 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm348088pgn.94.2021.11.02.19.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:45:21 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 3/5] kselftests/net: add missed SRv6 tests
Date:   Wed,  3 Nov 2021 10:44:57 +0800
Message-Id: <20211103024459.224690-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103024459.224690-1-liuhangbin@gmail.com>
References: <20211103024459.224690-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the SRv6 tests are
missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 03a0b567a03d ("selftests: seg6: add selftest for SRv6 End.DT46 Behavior")
Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Fixes: 2bc035538e16 ("selftests: add selftest for the SRv6 End.DT6 (VRF) behavior")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8c3d0709b870..256dcd17cd8d 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -30,6 +30,9 @@ TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
 TEST_PROGS += cmsg_so_mark.sh
+TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.31.1

