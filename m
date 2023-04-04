Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFE56D5973
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjDDHYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjDDHYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:24:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525803C00
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:24:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id r7-20020a17090b050700b002404be7920aso31163362pjz.5
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 00:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680593064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BWqzyo2LBpGmvmS6FGEH5clOoPfVrxC4HoMNPtgXGvA=;
        b=G7k0QBmWQwyvyyc+LFBJInH1KztJwhf+HLmNOmyDu7ZgwRt/BHeVMK1Km3TuljGXqd
         EOzeSlgEPF5pgnhjknhN3+xyW6he3N2uCQ3gfsH8D7/4YwiZLe9sscaqHSfxgmWOxs6R
         H/tDpwOU6SkZUp6DtjbGygxc91fwv5wRLi3RAeJNIR6sZvPLpFF15v91g4sMJQzFxYaG
         +mWFHi5hRp2YbAh/UfLkTkmlYWx9COuQa/AFkvY7On5qn7p5QyQ5R6Pnak6a3BIp4uug
         HuzIpzevBCRSILh/qgDn49z5OM+nU8R8A2fToyP3u6nF6wZA1IJnEXLlfXBERlDQxeB0
         4IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWqzyo2LBpGmvmS6FGEH5clOoPfVrxC4HoMNPtgXGvA=;
        b=bY6iVQ+0QisOcDRnKOWJZOAWisOX0YNFQG5kuaZ3CZ3RXj0+8IQ5SYYqc2o7CYs+e4
         Mbn0R6zPikTmw/JhbEYoxMxhv+xf5g8bCbJAE7YAgfAsMEv6yw65Ad6Ri7hejEiD9Z4f
         jr1CH1/mqLAUZnvrAfaL5FQqvHL5g3pcDDbORmxqjkhZh1a2RbczwMY+kk0Kw1toxFj6
         IshXufrq8pOwJo19wZahp1sTwWBl4yL09pN5Y4jTkTdYVXtec3qMBKKjfj+OoPITPcv4
         QwbJxbdj5RAoNS8xYPPM8+pw5xRX0C0ti8ShuVw6d81yjCnoMvs8TpUYdcpRWNG2tyVe
         PxVg==
X-Gm-Message-State: AAQBX9fN6bfKpYESEfEAeffTSanQ2O3w4mlqPzeGwddsrmLRTJtJcpIT
        9QhKzLaJZLwyhnWza4iyAYsVE5bOBZIfaQ==
X-Google-Smtp-Source: AKy350Y9P6N3mt+iM2k0PO8F5dWFUobbWfzfzOdUU6SvSV+wHaR7x655g1AOSHvYixLQ0Uh0XfUIRg==
X-Received: by 2002:a17:903:788:b0:1a1:aa68:7e61 with SMTP id kn8-20020a170903078800b001a1aa687e61mr1590120plb.33.1680593064368;
        Tue, 04 Apr 2023 00:24:24 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id j17-20020a170902759100b0019c8ef78d52sm7737384pll.21.2023.04.04.00.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 00:24:23 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: net: rps_default_mask.sh: delete veth link specifically
Date:   Tue,  4 Apr 2023 15:24:11 +0800
Message-Id: <20230404072411.879476-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When deleting the netns and recreating a new one while re-adding the
veth interface, there is a small window of time during which the old
veth interface has not yet been removed. This can cause the new addition
to fail. To resolve this issue, we can either wait for a short while to
ensure that the old veth interface is deleted, or we can specifically
remove the veth interface.

Before this patch:
  # ./rps_default_mask.sh
  empty rps_default_mask                                      [ ok ]
  changing rps_default_mask dont affect existing devices      [ ok ]
  changing rps_default_mask dont affect existing netns        [ ok ]
  changing rps_default_mask affect newly created devices      [ ok ]
  changing rps_default_mask don't affect newly child netns[II][ ok ]
  rps_default_mask is 0 by default in child netns             [ ok ]
  RTNETLINK answers: File exists
  changing rps_default_mask in child ns don't affect the main one[ ok ]
  cat: /sys/class/net/vethC11an1/queues/rx-0/rps_cpus: No such file or directory
  changing rps_default_mask in child ns affects new childns devices./rps_default_mask.sh: line 36: [: -eq: unary operator expected
  [fail] expected 1 found
  changing rps_default_mask in child ns don't affect existing devices[ ok ]

After this patch:
  # ./rps_default_mask.sh
  empty rps_default_mask                                      [ ok ]
  changing rps_default_mask dont affect existing devices      [ ok ]
  changing rps_default_mask dont affect existing netns        [ ok ]
  changing rps_default_mask affect newly created devices      [ ok ]
  changing rps_default_mask don't affect newly child netns[II][ ok ]
  rps_default_mask is 0 by default in child netns             [ ok ]
  changing rps_default_mask in child ns don't affect the main one[ ok ]
  changing rps_default_mask in child ns affects new childns devices[ ok ]
  changing rps_default_mask in child ns don't affect existing devices[ ok ]

Fixes: 3a7d84eae03b ("self-tests: more rps self tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/rps_default_mask.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/rps_default_mask.sh b/tools/testing/selftests/net/rps_default_mask.sh
index 0fd0d2db3abc..a26c5624429f 100755
--- a/tools/testing/selftests/net/rps_default_mask.sh
+++ b/tools/testing/selftests/net/rps_default_mask.sh
@@ -60,6 +60,7 @@ ip link set dev $VETH up
 ip -n $NETNS link set dev $VETH up
 chk_rps "changing rps_default_mask affect newly created devices" "" $VETH 3
 chk_rps "changing rps_default_mask don't affect newly child netns[II]" $NETNS $VETH 0
+ip link del dev $VETH
 ip netns del $NETNS
 
 setup
-- 
2.38.1

