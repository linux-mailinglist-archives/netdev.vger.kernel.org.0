Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4C36BA0D9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCNUiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCNUit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:38:49 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BABD1B56C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:38:47 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 97so354526qvb.6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678826326;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K+VJT5XjlpwSB3Rr7WCNyE9jbOJcwAZ64R4PwLUCFfo=;
        b=FT+U50aYfKpkbHSpwNd8+f39NQWRVqBlmGN9Xm5zd6zz1vDQBXMmBOaKfk41DH+7V2
         PHHfk2+Bm+oXTq+nn+FLNB0aSB6Al65rk+iOpadO8mBSAPmi/m7E2qdeopMluuAXO+WQ
         57COnRrx9ISl+7nIWSMDUDZJRBxQwL1ahpj9xoixNF1uBSOuJAUx/nOu2opgfptwOqFE
         Qv0YtuBNPx4GXiNjS7zloaILPcPqkrEzcIhezWx567igyx/50fcqHRZ4Y4nZDoBo3EVO
         NWm+RwNqrAPffgq+Q3uuhlXcX5tIEgnGhJXk+mcw5g7O5j7WPrkq/JanDZ474XiDZiYG
         NseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678826326;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+VJT5XjlpwSB3Rr7WCNyE9jbOJcwAZ64R4PwLUCFfo=;
        b=LW0ngv0Y9LXu5f1SE1OaQORj8e4VpOWzrhUDszkcsKejdXUVlgH29LhRRD9egZBj0e
         h+FYlaKHOURN2Krq/fj3JM+ixNSWc+2Imno8W93lCskZAgrL51iJWgQ5VVWYUvAhxFg9
         NR9nzX85piwOMnECcoKgo+luoz/Yd1Y1Zb0HAx5oZ8SAEoiKsv+gaoF5yWJTRBhRD8Kn
         Zw9lp/seKl47zqqFYRIhA+MD4O/rUQLkRwhxEySlc9J469r3gFhzSs2kdiODNanJrC+7
         iEqn1n/fDfNVmEVH8vgy+Voup6nE1wM2prx8FQkyhsbRLLSNzFh17l+FuzZjTu+WL5Dt
         4dZg==
X-Gm-Message-State: AO0yUKWiIjin7OZL+B2DyVplBZ8uEpFPRJIiWcjYCPR/DU5JToWR92py
        uNL7K1oFMCe+W3oyAwL2/tv4Zg==
X-Google-Smtp-Source: AK7set+4cvV3uB8Us3zIfqydslRFFAGro5l9PRHQNjJgsjwb73t7BLtnRF6N9l+N/F6PcZG6QiawXg==
X-Received: by 2002:ad4:5aa9:0:b0:5aa:fd43:1fbe with SMTP id u9-20020ad45aa9000000b005aafd431fbemr10644506qvg.46.1678826326252;
        Tue, 14 Mar 2023 13:38:46 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id c2-20020a379a02000000b00745ca1c0eb6sm1947828qke.2.2023.03.14.13.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:38:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/4] net: ipa: minor bug fixes
Date:   Tue, 14 Mar 2023 15:38:37 -0500
Message-Id: <20230314203841.1574172-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The four patches in this series fix some errors, though none of them
cause any compile or runtime problems.

The first changes the files included by "drivers/net/ipa/reg.h" to
ensure everything it requires is included with the file.  It also
stops unnecessarily including another file.  The prerequisites are
apparently satisfied other ways, currently.

The second adds two struct declarations to "gsi_reg.h", to ensure
they're declared before they're used later in the file.  Again, it
seems these declarations are currently resolved wherever this file
is included.

The third removes register definitions that were added for IPA v5.0
that are not needed.  And the last updates some validity checks for
IPA v5.0 registers.  No IPA v5.0 platforms are yet supported, so the
issues resolved here were never harmful.

					-Alex

Alex Elder (4):
  net: ipa: reg: include <linux/bug.h>
  net: ipa: add two missing declarations
  net: ipa: kill FILT_ROUT_CACHE_CFG IPA register
  net: ipa: fix some register validity checks

 drivers/net/ipa/gsi_reg.c |  9 ++++++++-
 drivers/net/ipa/gsi_reg.h |  4 ++++
 drivers/net/ipa/ipa_reg.c | 28 ++++++++++++++++++----------
 drivers/net/ipa/ipa_reg.h | 21 ++++++---------------
 drivers/net/ipa/reg.h     |  3 ++-
 5 files changed, 38 insertions(+), 27 deletions(-)

-- 
2.34.1

