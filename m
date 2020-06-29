Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6959820E73F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391486AbgF2Vza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391555AbgF2Vz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:55:26 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CE7C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:55:26 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w9so15857879ilk.13
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H9u5EsjGLPEPDvUYGsAHJToD2oE+5JpanjVzeW0Wj+U=;
        b=lhqNs3GAXrIZjDtSneiDuNkZXasiD3BYohOiGRdLPEhmj0v6fK1XGeq7Nujg6ictRc
         pwZfzeTqvI86p0Gk9VZ+6gBrWqTnIozJsD/FZED2Zx6HAGKdmSzOheVaEU4r9UID/DSY
         XNyEJerhr0HJ+mYq6hlK4cvgM/B7eEC1swxRTC6KvgcWjYonUlKH1eBevDYSyB2YkRqf
         DiYcTHpaTitkwdHuYLKcM3tWb7ev795IMDZ6exg8ZcaoBoYrlWm3DrNOCbOykjALRACC
         aG+lPKcazbO/vwcKm+2rL31NYSVXJ2ovdVFiz5v1NESTKJEBI48fn/ZS8KP/l1N3WFgj
         QWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H9u5EsjGLPEPDvUYGsAHJToD2oE+5JpanjVzeW0Wj+U=;
        b=c3UXA/7/Jq0Xv3GN1EKEjcauQjdkNnvaRqB1epTdxzDo2ui/c6g4i9/h7n9kGYO+Je
         WyrhNZ5B9VAZFgaW1udRSzvsFANGMDrxM4Iw77b+hVali9+xiraREFtzAcM/GEF9/7e7
         qmJ9gwm4sPAtLG3rOcyI299W04lgsZWr104oTpCwGTYazyDKKK10KjLFgR7out2gTdi0
         SbBfg42JIIiJEqCnbPJUCt8s6E29kPi0DnCnv0iogZf09gM+RJDiKWD/t9bQuLt0HrcJ
         qjt1apYtE9EVrelonAreabs2K7CN96e4EmCq495OK/IX6/9UVta03PaVWjkPcNTi9vAt
         ZiPQ==
X-Gm-Message-State: AOAM533IL4069bKSAO9gNa2vSwMzR06rOigs5PU30anmRhMW7mT84iIm
        xkBhnd4W2UOn4mzQOvlm6Jmt9g==
X-Google-Smtp-Source: ABdhPJyAR3Ravl+6q9AlqAsDMDA2+UgpelD8cpML3OShTfC5xlDGv5qKeVc6I5uaKbFlVKzyt/PBlw==
X-Received: by 2002:a92:cf42:: with SMTP id c2mr18802507ilr.13.1593467726103;
        Mon, 29 Jun 2020 14:55:26 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a187sm543221iog.2.2020.06.29.14.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:55:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: simple refactorizations
Date:   Mon, 29 Jun 2020 16:55:20 -0500
Message-Id: <20200629215523.1196263-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes three small changes to some endpoint configuration
code.  The first uses a constant to represent the frequency of an
internal clock used for timers in the IPA.  The second modifies a
limit used so it matches Qualcomm's internal code.  And the third
reworks a few lines of code, eliminating a multi-line function call.

					-Alex

Alex Elder (3):
  net: ipa: rework ipa_aggr_granularity_val()
  net: ipa: reduce aggregation time limit
  net: ipa: reuse a local variable in ipa_endpoint_init_aggr()

 drivers/net/ipa/ipa_endpoint.c | 17 ++++++++++-------
 drivers/net/ipa/ipa_main.c     |  5 +++++
 drivers/net/ipa/ipa_reg.h      | 17 ++++++++---------
 3 files changed, 23 insertions(+), 16 deletions(-)

-- 
2.25.1

