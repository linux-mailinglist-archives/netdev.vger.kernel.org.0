Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACF657A625
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbiGSSK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239856AbiGSSK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:10:26 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2A04A821
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:24 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id w9so4573292ilg.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JJzJdSN4mx1unTTYHy8WAkiuSN/NS3rGpjLdlkjRGlo=;
        b=pSA3p02hSVdsyRZ4kG90DUEwztwP9KzGqlTPjN3LfLb9pfeyoT6tYI2XZyMmIcFzSN
         TjTjI61pc4XT21TXmrpv0anRpZYfi6nBmlEMePOFzLnRY9r4v+sj1zrPHcURSDqU8fR8
         C8Uy5WFJPwQOJUEukI+JSa1sMTTr9v3Hnp4gysUNd2zm9BWZWYaXbWcAuEm1oz007gUU
         wN2vtKqy4PIxDsHPeaQ1L8aSygXs6uezk38U4AkM24EfaKHCeOzDb96u2BvpEMmSOsM+
         EjIVp7lSBCv57lrPhv/ni0bztr/DbtsoSFhwL60LrGYmtZmxBqelT62uQVTnQ7iwIKWW
         IDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JJzJdSN4mx1unTTYHy8WAkiuSN/NS3rGpjLdlkjRGlo=;
        b=r14dvm0jdbhRrTRlr8oKkkRq4IbcifJjKDOW57RtuhLV9RF1nf9QDWCB9bepyOvCd7
         1qLqTTuq1bQ4pg+9oOIO4Sp5XMUJB8CDclTeGXgvYLL1VoQtcTFf3NGHnUPB/vVkq3Mp
         xvwyQH3h9tuo33gpkZu15d+iqnc8MJ1qdSE4CzfHF5EQ1g7DCpih2KT3lTRNjHdi8emT
         2cXsB5+4PvhVj3/YLKrZY6IgGjXCsu4fLXK1MDFUBwDt1jEYxiyvoJOvjLPN32pbuLmc
         ZBPuz4agrR/04/e8/t5F2Z4u8cy4go9Q1e5GfEGGWXQJGCxy4hXBd4KsQiFU7aRXY4c5
         0Rdg==
X-Gm-Message-State: AJIora/duIYrh531gTgPC1FOdBM+xSLyakpc0oeL1IyJWy39IeV5KwwZ
        Bl973jGF9yD4RcZC453VdCVcB3r1q6sR0Q==
X-Google-Smtp-Source: AGRyM1ucep2BSORS30efwbLFKp7cqppOBS7GnE3E8g0MW5OyhSiyEhsXUlgltK37QHT7ppEtncVbQA==
X-Received: by 2002:a05:6e02:1043:b0:2dc:dab6:c704 with SMTP id p3-20020a056e02104300b002dcdab6c704mr8029909ilj.69.1658254223958;
        Tue, 19 Jul 2022 11:10:23 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm6089552ilu.56.2022.07.19.11.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:10:23 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/5] net: ipa: small transaction updates
Date:   Tue, 19 Jul 2022 13:10:15 -0500
Message-Id: <20220719181020.372697-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 2 of this series corrects a misspelling of "outstanding"
pointed out by the netdev test bots.  (For some reason I don't see
that when I run "checkpatch".)  I found and fixed a second instance
of that word being misspelled as well.

This series includes three changes to the transaction code.  The
first adds a new transaction list that represents a distinct state
that has not been maintained.  The second moves a field in the
transaction information structure, and reorders its initialization
a bit.  The third skips a function call when it is known not to be
necessary.

The last two are very small "leftover" patches.

					-Alex

Alex Elder (5):
  net: ipa: add a transaction committed list
  net: ipa: rearrange transaction initialization
  net: ipa: skip some cleanup for unused transactions
  net: ipa: report when the driver has been removed
  net: ipa: fix an outdated comment

 drivers/net/ipa/gsi.c       |  5 ++-
 drivers/net/ipa/gsi.h       |  8 ++--
 drivers/net/ipa/gsi_trans.c | 89 +++++++++++++++++++++++--------------
 drivers/net/ipa/ipa_main.c  |  2 +
 4 files changed, 66 insertions(+), 38 deletions(-)

-- 
2.34.1

