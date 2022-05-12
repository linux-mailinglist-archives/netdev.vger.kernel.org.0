Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5EB5250F0
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355734AbiELPLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355730AbiELPKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:10:44 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70E0261F98
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 08:10:37 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id i20so5696221ion.0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 08:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ad1tS2K2zc3RIhe/TI0l6WFAVbnu52wLY6K+yLcjvwQ=;
        b=UTGVVXuEEFykXg/1otpStThlOpkwTWVzkPNc+42ZwDWatc/YuR2qeBqjGU9odDC8dH
         91PVrR+b0YPdsPUQSSpSlFKsFjpre9gI03x4h87S9nEFnCZzp32CKS+cvCv3uRnMncPY
         pwzh5trBUg4clZTiu4Iz1YfthUAxxxPlWAbvQo9JLbl4PQiuTEosEhbZdwKX+Mk5hb59
         /K7asn6umCt9XBknnPrW3QCUXfHjvq4xoMgEOdV22+nPQzdB5x64p+zeQuchon8TuG0U
         Diektp/veWqGDU6tZdJxDw8sj2o8MupZosy0ut/jSP0r2LiRe0mNG8Y0vioNe9nKdIqj
         X2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ad1tS2K2zc3RIhe/TI0l6WFAVbnu52wLY6K+yLcjvwQ=;
        b=4gqHkXlWaazwwlkuXRq3LGUXbKXRqtsaSWhMGHhAH5y9VJROFbp/hPM/6MXi8BGbyo
         g1/cg6/I7tDy+9ak0caEcC9I2ptqVu1xWeXPLgvzqgHtE22G/Lq9rXSJFi2BqoCN9Xqd
         nHh40fxhwQ4IOO61TBf1RlI1v64UNAWKNCta2jlPl0fPeD+znCUqgaGdzWBvr8A0XJa8
         CISRPBVlvgVLAzHu7RaADuB2YgR/WBGUz/mXM1uZUOcLs/Sz4h1Ocj3/LIJd7W1M3TWC
         cc3yUnhzWZjlBTaM2EcDLRVBe/Vjbr7uB6PJUdjDZLUGwyhiaN/6bazJHUmwbyWPCukU
         h0ew==
X-Gm-Message-State: AOAM531PFuf8KruhZwgfL3ow5WcFF3onmRoQ0kSt8+WdLRafCyvZqCNO
        DG0m2fRHMYZ4LbfSrRKZnPH7Pw==
X-Google-Smtp-Source: ABdhPJwawANeu/a6gBI1jk/WLo5mdy16CpRlEiEw3ZDR/Qmeeqmf5Ggm/1qkIn1iIszcOwXJoSZDlQ==
X-Received: by 2002:a02:b893:0:b0:32d:c698:1a3a with SMTP id p19-20020a02b893000000b0032dc6981a3amr209196jam.51.1652368237226;
        Thu, 12 May 2022 08:10:37 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p15-20020a6b8d0f000000b0065a47e16f3fsm18217iod.17.2022.05.12.08.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 08:10:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     lkp@intel.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] net: ipa: three bug fixes
Date:   Thu, 12 May 2022 10:10:30 -0500
Message-Id: <20220512151033.211592-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
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

This series contains three somewhat unrelated minor bug fixes.

					-Alex

Alex Elder (3):
  net: ipa: certain dropped packets aren't accounted for
  net: ipa: record proper RX transaction count
  net: ipa: get rid of a duplicate initialization

 drivers/net/ipa/gsi.c          |  6 ++++--
 drivers/net/ipa/ipa_endpoint.c | 13 ++++++-------
 drivers/net/ipa/ipa_qmi.c      |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
2.32.0

