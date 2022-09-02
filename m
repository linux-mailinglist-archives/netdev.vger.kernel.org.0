Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96AF5AB9CF
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiIBVCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiIBVCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:02:23 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BD3B5A78
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 14:02:22 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d68so2615578iof.11
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 14:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ZPui7nz2t/JidoBEB5DJqHDb5B0r6Z1+2ugl0ACPk+s=;
        b=WS6+Z/enNrHKG2vyzj7Rd6uVC79M2MrNYm1UV5AuT9S9S2WBS516zxqhG2nPuyAdSA
         1tvF7rPqGNB0Vwg8HYjzOFSVs1L3C6nDYK6JW1WD5a9YrwFk82qqqDGJaQfCOU0N/D4a
         ShN/tsSwSiGgagbYX3iz5X+vDtwOvmZO3i4hdlYuvYK4x/s5e4GZWYctkfoAI7enWVN7
         AMIpsH2BrAHQgGXeQR0R/SN47XNSE5BT26yiMUj8+CeBVvnLNKqDl/kTWHBv9xjfl1r8
         paaYqfWl/XO+qocuQRxsv7Drt+gWkAwpf76bdrzEEzHG6i50DNXayRGuuAYj3p1VnabE
         MCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ZPui7nz2t/JidoBEB5DJqHDb5B0r6Z1+2ugl0ACPk+s=;
        b=OdBf1LVwI0+NJf6jshN+CH9irhG8cd3M2I5P3bpmy6IObuMSMSws2tLdfBI+iX7FgF
         mDNXdmUEfG+juopmXP69UssCjsZIEYTQbrHI/+sjKxvvfTIdztDq6Sa087/qwVmqr2mx
         EszgGyKiu/hGpRsTx2aC9OQwt4aYv6a/nzYr9h6p3cy6nSjJvPQ7Zchp36Gz7YNtCBsw
         /3SEWZhq99Bx/0GnSk0cifFL6iRCtqMS4/xeVfAMLcNRVK4vAzNvy7CLiEjOBBufjZ2x
         yercQTZ6AcBDTI7PlumdjS0lHpnIH0H6s0I3kf+Cms3JKiJAHCNVRwcvIXU6tGXyQ/xH
         LsHQ==
X-Gm-Message-State: ACgBeo39RIFqRYv0VuENmt5zU8tVOYGbAlJkzJCyAKe6otiLAy5qpc5O
        TBxlFLdrVhL+8NS/piXjlkyq524brhlOkQ==
X-Google-Smtp-Source: AA6agR5aLVePYhKwuT74x+sX+QCC/FdUuQxIw4dmkdz9/ni8Xn3uI6Od1OobvS1PyfI0yq/kr4BwtA==
X-Received: by 2002:a05:6638:3047:b0:341:de2b:e489 with SMTP id u7-20020a056638304700b00341de2be489mr20991527jak.273.1662152541983;
        Fri, 02 Sep 2022 14:02:21 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b00689e718d971sm1259208iow.51.2022.09.02.14.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 14:02:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: start using transaction IDs
Date:   Fri,  2 Sep 2022 16:02:12 -0500
Message-Id: <20220902210218.745873-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous group of patches added ID fields to track the state of
transactions:
  https://lore.kernel.org/netdev/20220831224017.377745-1-elder@linaro.org

This series starts using those IDs instead of the lists used
previously.  Most of this series involves reworking the function
that determines which transaction is the "last", which determines
when a channel has been quiesed.  The last patch is mainly used to
prove that the new index method of tracking transaction state is
equivalent to the previous use of lists.

					-Alex

Alex Elder (6):
  net: ipa: rework last transaction determination
  net: ipa: use IDs for last allocated transaction
  net: ipa: use IDs exclusively for last transaction
  net: ipa: simplify gsi_channel_trans_last()
  net: ipa: further simplify gsi_channel_trans_last()
  net: ipa: verify a few more IDs

 drivers/net/ipa/gsi.c         | 53 +++++++++++----------------
 drivers/net/ipa/gsi_private.h | 14 ++++++++
 drivers/net/ipa/gsi_trans.c   | 68 ++++++++++++++++++++++-------------
 3 files changed, 78 insertions(+), 57 deletions(-)

-- 
2.34.1

