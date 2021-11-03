Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9266D443B8A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhKCCsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhKCCsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:48:01 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55675C061203;
        Tue,  2 Nov 2021 19:45:26 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gn3so286141pjb.0;
        Tue, 02 Nov 2021 19:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rYOlwzbMjBkpcUBMv4i10d3rtkrjA6+eHZm6q28eQpc=;
        b=mc/IRqPWQuxuO80LxYYLu4yNCgzuHMu9W2Vu92aQjXigSrcRuy3cNVMeJPQIx/J+Sz
         AvwXwW5vCliXNG0iVqGTTPR/03T3UkO+N5i0FEpKBSQWbsH8uhq0jiuHAMg5qVlVG+QU
         wcJvbd5ExQTsiS1ymGpux1Pp6JOMaBipLY9TdOj+crhHacX3+SAWUC1GyCe5HoLVbdrJ
         bUrPMCoWIhrtfxbaCuUMzQyI9TQ/+kLOcAIZD/Fv+bSKVrZQFjg4WY2v3yPqjbmEIVXC
         Lg8/Iy7H2d0pK7C7wn+sprc5+sCCZqEqIEgqArdsxdLbW9F5hPRilYJwHtTv68Lidezz
         FJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rYOlwzbMjBkpcUBMv4i10d3rtkrjA6+eHZm6q28eQpc=;
        b=2EKHkZU+sbMuRE0u4+CfP42WfgiRe/7nWNeJS8uHe+i6fkddHXxtbqM/D9j9MEkIIt
         7TJvkddwacjX+G05kMwHqS3ZJhqhzk3xEoAz2ERUo3oSNlN9ZxSENj4D0VIO24FmKzTd
         CqU5p0mTiOsjWPVrqmOJPjml7zIGVgTWmSQt1SvzqOBKcLoalOiDlVeivTXwV1WbpQFj
         sNZoDGDgRcHs+UZQqBl6vNdQoxf4hWCGfjgq8zi9Nfh4SF2qk7s2PEag3Lig5KVhNb1I
         A5mpHT5uxPc5q+ubaT0IMtaYxmJoKqwLs8S30fBbeR63iUhMuC8WPZkAuuviVT/LsLn2
         TbpA==
X-Gm-Message-State: AOAM530I0hg8On7jhckeEy3893SdczFatZrRxJmBWZ3n8tiNMlCvBxYO
        Sz9CJW1GJJHjuYvJ3DwAQTMbLMP7YSE=
X-Google-Smtp-Source: ABdhPJw6LzDOVZ2n3yey6/QXhrdpqZ79GxBjtt4d4iie/Z+iEqL96971G7swUByKnZ38AC6D3Nw6gQ==
X-Received: by 2002:a17:90b:1bd2:: with SMTP id oa18mr11287256pjb.164.1635907525755;
        Tue, 02 Nov 2021 19:45:25 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm348088pgn.94.2021.11.02.19.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:45:25 -0700 (PDT)
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
Subject: [PATCHv3 net 4/5] kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
Date:   Wed,  3 Nov 2021 10:44:58 +0800
Message-Id: <20211103024459.224690-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103024459.224690-1-liuhangbin@gmail.com>
References: <20211103024459.224690-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the
vrf_strict_mode_test.sh test will miss as it is not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 8735e6eaa438 ("selftests: add selftest for the VRF strict mode")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 256dcd17cd8d..218a24f0567e 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -33,6 +33,7 @@ TEST_PROGS += cmsg_so_mark.sh
 TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
+TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.31.1

