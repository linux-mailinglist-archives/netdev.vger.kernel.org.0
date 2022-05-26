Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCE1535154
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 17:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbiEZPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 11:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiEZPXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 11:23:21 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC16941308
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 08:23:19 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id 2so1883820iou.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 08:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UlmIoIXHwMXi02CIUIbYx/gDCtgYsd+85qsswfbTi60=;
        b=lcukDgRzh6gqWw1h4Mle/1Y2mwmaULeGkm0dSvmCLjxX12jRc6cTNrpe3/kQIxT6VR
         BLFPWnpia3CncNic9LXJLWTKkCBk/Yl5RfugOYnyqcbxW8FC0MPaZUFSo6EOkEb66LyY
         YyesJnY7SKTCOURIvcjvF2gghQy6pcRElIObu1Q2HpWpBNrHJhkr98uD54pYKMZyj+hU
         AMxISzEFRMnoio7S9FzHH8F/a6ZkAJKul0WzTN+WSMGfYUVVnvWqSptpab+au9Qrs1Y2
         9gQpq/vDsHRVDggbiBVgy9IzzOQ+w4ibpW4q9prTuCl0uH78qkayL5VaOxo1saThzq4P
         N8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UlmIoIXHwMXi02CIUIbYx/gDCtgYsd+85qsswfbTi60=;
        b=QNDdChiA/Nqytg2vgjB9L4tpxeO0Qdb/4Q1blgPF/3KPfuLNeQSXXBWrtqhi+UO4To
         6Ht+/5Enr+g33RnL/qeOR4g6zOq9h3K720cHqVpRQjo/to2UgHzajPDWAZjpRfNv/a3k
         CS127anG7xWH4ElQgh/EinA4uJrOWEi2sN/zjerdiayLI3qiiuqGUBuCrFNO4rYC8v4h
         pX39bjUZNrU5gvVJg/RXOiapFPU99nPNIjbowhdyI0UbiBDeC9XgvlH8/H4DETQT8tqu
         B8+OCbyRkQMZpXS+H4NQ0SMGJG9/EzJjQ9AWQ23dOeibSRYs2b6719MaK4mwz8LlU8F1
         exdQ==
X-Gm-Message-State: AOAM531z80qSZ2y6OyRBXFp9lXQLdViLGWHPDHoUIQIxAEZxeWABeZ2U
        +4086F/l/VFhDqK/r9+sXko0pA==
X-Google-Smtp-Source: ABdhPJzWHC3ppTv3zcLqCIdHi4Ug4Ffpqkgm/RakXbW4uD5vam6wSj7sPIjK90QZ8w8eRdXhHFvMrA==
X-Received: by 2002:a05:6638:1486:b0:32b:e870:b2a7 with SMTP id j6-20020a056638148600b0032be870b2a7mr19634359jak.200.1653578599316;
        Thu, 26 May 2022 08:23:19 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b59-20020a0295c1000000b0032b3a78176fsm466847jai.51.2022.05.26.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:23:18 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] net: ipa: fix page free in two spots
Date:   Thu, 26 May 2022 10:23:12 -0500
Message-Id: <20220526152314.1405629-1-elder@linaro.org>
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

When a receive buffer is not wrapped in an SKB and passed to the
network stack, the (compound) page gets freed within the IPA driver.
This is currently quite rare.

The pages are freed using __free_pages(), but they should instead be
freed using page_put().  This series fixes this, in two spots.

These patches work for the current linus/master branch, but won't
apply cleanly to earlier stable branches.  (Nevertheless, the fix is
a trivial substitution everwhere __free_pages() is called.)

Version 2 is just rebased on today's net/master branch.

					-Alex

Alex Elder (2):
  net: ipa: fix page free in ipa_endpoint_trans_release()
  net: ipa: fix page free in ipa_endpoint_replenish_one()

 drivers/net/ipa/ipa_endpoint.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

-- 
2.32.0

