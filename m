Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AC44412B1
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhKAEJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhKAEJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:09:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84748C061714;
        Sun, 31 Oct 2021 21:06:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m14so15145453pfc.9;
        Sun, 31 Oct 2021 21:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8H6Gveowsnmst4hWnvLMCPkzCQHS6PgIDuEsJfezFnk=;
        b=kwdlHjVKme8Yh0UHWbl4x4tzWz3TA3qV59YrFZqWIvOBoygAU5iyIO786nly25KYWP
         B/mHOrTrd2oHJicExsACETV+4dF0cQKyP4uHigEmdjoxF/JPfIqW+f29B9zTV/245Q6X
         gUYFSkbMAYAeWDbjGdgQo1rjDtK/WYKGWkqGXVGdF5O5gpyzTk0GYgSr2XKCs6R6y0Wl
         iUy/G/OK7P4EgPHuCeParnOfGUlhap5uOVFmk4RoCaDphF3vk0bjaCGv/IelBoT/qFha
         h39rky/gbEkpW5T1943clRKVTn0TiKgK4Vgpgn031Vfs8tNsEfndTFHCTbQlSFFwtMsS
         l2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8H6Gveowsnmst4hWnvLMCPkzCQHS6PgIDuEsJfezFnk=;
        b=wZ6MjVONaNqTXQczehBzwXLr1Ch5SQ5m9JBqlu2Qfl2qlGEjv0OifMCnIPT4wxDorl
         /TdFQwviiU3afpcke77BKb+eqfNIPWd2QZ4BgDAhwh5eLyjDlMWxdaIPGbOI1T9LTPFk
         KHiNmyHBJG7WfRcXk3FcXG5Ph5TnIjZbyjKWQ/PZ8Gl/zSaYIssr+fu/rliDQHd26CAQ
         LBvRPHUrXQHdplMchoiJMYpZFDQ5syVs8Exu3BU9Ht9JGcbr/fcFuCEFoUMfxulkYZ7E
         mJiy2wHD+mdmSjPwVojJy2A5oKGZxfZwd9BB6XLaQz0o8A9USM7Ao4x6F7SrE2v0uVc1
         reUA==
X-Gm-Message-State: AOAM530LwtDKqCWd2pKsjVwDjt8Rw81hIbWOwclUxtHpH3i2rNDo92vM
        FhdcZSsK2YMYTW+vA+uklDxo13iF/ZQ=
X-Google-Smtp-Source: ABdhPJwssp87If0WWJuog2aUvIRkyVzg364ZOOUJv8IhnfHjEyVbpVG8UmvudDDy3QU/blaS5Yg+Vw==
X-Received: by 2002:a63:90c4:: with SMTP id a187mr6585893pge.297.1635739600957;
        Sun, 31 Oct 2021 21:06:40 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm11132231pgt.7.2021.10.31.21.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:06:40 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 5/5] kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
Date:   Mon,  1 Nov 2021 12:06:09 +0800
Message-Id: <20211101040609.127729-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101040609.127729-1-liuhangbin@gmail.com>
References: <20211101040609.127729-1-liuhangbin@gmail.com>
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
index 514bbed80e68..9452328962f6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -32,6 +32,7 @@ TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += toeplitz.sh
+TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh
 TEST_GEN_FILES =  socket nettest
-- 
2.31.1

