Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23357A2A4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiGSPIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiGSPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:08:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3609C50192
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:08:32 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e69so4501468iof.5
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5k0cuBRzxttHE7GVJkk3o+wsYF0B3xx4pPqXHWMLdI=;
        b=DC2gCfCeA3w8wg+Lbij50s0A4AvHV7BOjO1xVFB8eeEd6b+zZ6IFkrYjrU33Mb9IZk
         tbpS2xbZ6+Yh9zAsYIbHxp0wkNoD1+UWGc5Pph8dE0DNw0eHKMQNIP1vyenS6jh5aFy+
         HYt9vWlt0+B79J8V8AZQhwX/3lfZ03gKKBvGAqVbsj5Ck7A3QHSJo6zxwBVIfVWk9HTH
         5icIWD+ufQy8HHrXy10IDz21Q7sQds+s0X2cbKA/fEX579VV06SLe96yPzn6psOtBNti
         QwRaY/IuLY3Lc3d07DvER+X0oHDaKPLGjbOteBkgcZ84snCxiJSFBbSjMZwOrX4ZpPvp
         G7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m5k0cuBRzxttHE7GVJkk3o+wsYF0B3xx4pPqXHWMLdI=;
        b=ak3ZMz672zwzyBdgkM2P8U747pclEid8+BuGxc8tpPstrwNyxv+Ddiyl9obKffIi5d
         AWCUy/M2aVUgkhaEiB9D22/qFG0MBFkn/oYcE4APu/JgjcIE+UmIqg7ekwlACeWOo14z
         wU4jVF3aPTFvq3YyyC4Ow5v93UuszfFRqpoDzXWlPDV+o4+8AyBsYf8Llgc9B4otmHd8
         3YYhHqJU6yyhIWtxkkHqJf/nsESlZAdxnMhqXjve3UWKEC8+cYRKatAGnw9T6PG0CTzI
         QHYmQ0X3uCboTNnQR6l6vdw59Xx5Ua3LBVU3NR82jzobldBY4iX6PpC9AzJ9K5atDDJf
         ZjGA==
X-Gm-Message-State: AJIora/a12MjwxK97jxD7+BzTgpsjX74zHYCkUZkjgkqzYoM3t896J7B
        grKzeOUzAm0PJeJLuDjDUygwLQ==
X-Google-Smtp-Source: AGRyM1u1JU55oW8am5h00wu9CzsUOP0Cp5WsoRmZxjEdxs8MYlKG70wj2RmdH3/TrYerF15CsTsILQ==
X-Received: by 2002:a05:6602:14d6:b0:67b:f961:8c84 with SMTP id b22-20020a05660214d600b0067bf9618c84mr6815436iow.69.1658243311525;
        Tue, 19 Jul 2022 08:08:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm5944899ilu.56.2022.07.19.08.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:08:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: move configuration data files
Date:   Tue, 19 Jul 2022 10:08:25 -0500
Message-Id: <20220719150827.295248-1-elder@linaro.org>
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

This series moves the "ipa_data-vX.Y.c" files into a subdirectory.
The first patch adds a Makefile variable containing the list of
supported IPA versions, and uses it to simplify the way these files
are specified.

					-Alex

Alex Elder (2):
  net: ipa: list supported IPA versions in the Makefile
  net: ipa: move configuration data files into a subdirectory

 drivers/net/ipa/Makefile                     | 10 +++++++---
 drivers/net/ipa/{ => data}/ipa_data-v3.1.c   |  0
 drivers/net/ipa/{ => data}/ipa_data-v3.5.1.c |  0
 drivers/net/ipa/{ => data}/ipa_data-v4.11.c  |  0
 drivers/net/ipa/{ => data}/ipa_data-v4.2.c   |  0
 drivers/net/ipa/{ => data}/ipa_data-v4.5.c   |  0
 drivers/net/ipa/{ => data}/ipa_data-v4.9.c   |  0
 7 files changed, 7 insertions(+), 3 deletions(-)
 rename drivers/net/ipa/{ => data}/ipa_data-v3.1.c (100%)
 rename drivers/net/ipa/{ => data}/ipa_data-v3.5.1.c (100%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.11.c (100%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.2.c (100%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.5.c (100%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.9.c (100%)

-- 
2.34.1

