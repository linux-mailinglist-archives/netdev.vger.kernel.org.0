Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE79B5E6F8D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiIVWVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiIVWVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:21:07 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6381710CA42
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:04 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id v1so3549542ilq.1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2pOEJWOoYFOGpdqE1FgVQVl0AeDp60SOokXdUjzLK5M=;
        b=YXgZ9ShoeRNkSG2dEDTn9RgAHowJ+8AA2Y7PSvCzOD1Z7vYW8o40422/lQqQBSt6D2
         6hGmiDFoOC5Qcn31+1Qx19uifYzH4XUeLgRCSqXnim1YmdjJpqM7/9othl9kDanft1Qx
         RLYZ3qKO/5oJRmEtPqOGZfMCmWrUU8snV4owkD8HOUT8Pnmy6tm3LgTjPOyoM1RLB3CP
         g8dwLMQOtkpNPg6f3CneIzg/jMcH8LNBVjwAZ1ibsVlX8p2QsTca0QNWM4WP47gErIvo
         dhnlflsSmlIq3hhZP4t6/uJDRInItOk8wtlXXQp3pqLq+edc1knL5sExcmJHAjWM/neo
         OW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2pOEJWOoYFOGpdqE1FgVQVl0AeDp60SOokXdUjzLK5M=;
        b=uo6asA9yyyRtQ8BAcb/pYaYdPJlPmzocFNOaYoSP42JjGhBRiFHCNCuGpmdbSWXPot
         BhpdD/WnHZFNrbOzfJcx4+Q4A4phbJGtyqb6an9TbZR8fsPHOYUFt5pMrHa1QOxj2kDP
         +oQfzVRKFUY0u2peH/hHeCPG3oVZolYfnqj/D9oZAyReU6xyV8OjrBITgSYurj2o1gZX
         yLoMX2uBJ6chSfC39euqm1vuCvsqNwjacGN+olbn+bGbRmjO1EaWaFqKtuGddHAAXMdv
         v3erzqzfRzkkQ1yqvf/BEukx8QDKVbcnoPNoNiScIMt35fV44Mh4FA2oxrAZoE8923SB
         WsmA==
X-Gm-Message-State: ACrzQf08xtTNFzcfv42kc3IHn82Lz3AFnQrEQnUF3vOsxdLm/UEfqUsN
        cvEETQ+CYseIGPadIu3zVqjPsg==
X-Google-Smtp-Source: AMsMyM5v5Hq3MgJjw/7okNUee6lOQl+KRgEDW7iYRH0HU81pnnP2WY6s+G7Xmud6/XmLKjSHSr2i4A==
X-Received: by 2002:a92:b106:0:b0:2dc:eebb:e6f6 with SMTP id t6-20020a92b106000000b002dceebbe6f6mr2778890ilh.54.1663885263823;
        Thu, 22 Sep 2022 15:21:03 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g12-20020a92d7cc000000b002f592936fbfsm2483332ilq.41.2022.09.22.15.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:21:03 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] net: ipa: another set of cleanups
Date:   Thu, 22 Sep 2022 17:20:52 -0500
Message-Id: <20220922222100.2543621-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains another set of cleanups done in preparation for
an upcoming series that reworks how IPA registers and their fields
are defined.

The first replaces the use of u32_replace_bits() with a simple
logical AND operation in two places.

The second creates a new function to encapsulate some common code,
and renames another for consistency.  The third restructures two
other functions that do similar things to make their similarity more
obvious.

The fourth defines the flag bits in a register using an enumerated
type.  And the fifth updates "ipa_reg.h" so the values assigned to
enumerated type members are aligned consistently.

The last three encapsulate the code that assigns values to a few
registers into separate functions.

					-Alex

Alex Elder (8):
  net: ipa: don't use u32p_replace_bits()
  net: ipa: introduce ipa_qtime_val()
  net: ipa: rearrange functions for similarity
  net: ipa: define BCR values using an enum
  net: ipa: tidy up register enum definitions
  net: ipa: encapsulate setting the FILT_ROUT_HASH_EN register
  net: ipa: encapsulate updating the COUNTER_CFG register
  net: ipa: encapsulate updating three more registers

 drivers/net/ipa/data/ipa_data-v3.1.c   |   2 +-
 drivers/net/ipa/data/ipa_data-v3.5.1.c |  10 +-
 drivers/net/ipa/ipa_endpoint.c         | 138 +++++++++++++------------
 drivers/net/ipa/ipa_main.c             | 135 +++++++++++++++---------
 drivers/net/ipa/ipa_reg.h              |  68 ++++++------
 drivers/net/ipa/ipa_table.c            |   4 +-
 6 files changed, 200 insertions(+), 157 deletions(-)

-- 
2.34.1

