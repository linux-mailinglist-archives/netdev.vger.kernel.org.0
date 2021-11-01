Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9224412AF
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhKAEJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhKAEJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:09:10 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFDBC061714;
        Sun, 31 Oct 2021 21:06:37 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s5so3605767pfg.2;
        Sun, 31 Oct 2021 21:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ydCiHuoFxhd0hBQ1X5cwb5OGuQIdpYWnvRNhvSEBmC8=;
        b=WInSSc2ut2cjqZm3CktSMngOu9cR9uiE4KhY03NFE59UUyzwXgH+T4HAAxjjo4w/AP
         geZc/AxUcyzhfAvIj051Uqm9POl7kbe9u7FfSc2d3HMroFDqRPmBgM/EwWlDOgjCJl8z
         0nHGQgu5IsMuSMd0TLT/g7Cki1R9EEI1l1luZSmllXnT8DlHnBrBGq75pBgfoLW9AK7e
         LbkCYBifnc/sDjXh8DuXkVpyigy5u2bEEVX3CGYYa1bF6WPzmIe817tG37OWMkLG45ay
         vb2pFIswUFfaksfj60wuAhkrKvFxzsloEdwl4yqHVu9LDxAk1uSif9cmcpAGkEMULLTj
         4r9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ydCiHuoFxhd0hBQ1X5cwb5OGuQIdpYWnvRNhvSEBmC8=;
        b=nztNIAwdd+ibxfbucycuhoa7Zw63045l7WiK56guz8hRYcmfXwL9H0MKMESMhpcteH
         zs9+X3+TEefp0XnNKIbcFUNLaiJkobqP5z/n4biVvtBQ0Rh3r9/F7Zbnsqgsp+vsWK8J
         2+vzmzXaLvHf/mE+eQJQF8PXtYxayT7xmXxe7/hCnLoFnmfFQMsONHz6macZNAe2Vl4j
         tYU3cf9VQESgx40TBHJxx2c15Vna4csiDl/Am6gzGo7lkWbnI3w+5lM7x+GiaobDNHQ1
         Md+qvigwB9AnxPOmkTX8l6zqi0aaGrW3m+4Hd+6SFRHcxEeplbZZacNstWdDVNgXo0KK
         d45w==
X-Gm-Message-State: AOAM530As8AF2gjSDxkbNUDXK3eNFU8A5qT1G5U9AS2Rwd1RNhVK2P9I
        JamymBpP6BDCkc757ne5LzvE6tRa4R8=
X-Google-Smtp-Source: ABdhPJysbPeNgDBLy+QbsqcrAj0K6IQryK3gzTi8t/PjV7iaCDXo2nBtZD9Vrd2dN2Wd06k3RgOTGw==
X-Received: by 2002:a63:1c03:: with SMTP id c3mr20004294pgc.207.1635739597292;
        Sun, 31 Oct 2021 21:06:37 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm11132231pgt.7.2021.10.31.21.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:06:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 4/5] kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
Date:   Mon,  1 Nov 2021 12:06:08 +0800
Message-Id: <20211101040609.127729-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101040609.127729-1-liuhangbin@gmail.com>
References: <20211101040609.127729-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the toeplitz.sh
and toeplitz_client.sh are missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8a6264da5276..514bbed80e68 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -31,7 +31,9 @@ TEST_PROGS += gre_gso.sh
 TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
+TEST_PROGS += toeplitz.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
+TEST_PROGS_EXTENDED += toeplitz_client.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
-- 
2.31.1

