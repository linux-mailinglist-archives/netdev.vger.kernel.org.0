Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE1342D39
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 15:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCTOR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhCTORe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 10:17:34 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDAFC061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:17:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id j26so9173821iog.13
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieGGL6rIftmGUrUPP8WBA7EIeMeymcZEigdcphOIazQ=;
        b=AyIlZKGPBW3eGyJxO0O0uPvBmrF4lKvqtgqSZQeDuly+wQsd8oojNcLxw1XvQfTcLG
         wJPiqhwweEVI3hl1BiTUfI7j+tmO5V9VXtG1N8JecVkXNifS7knjSX5lL88UKd86VRAQ
         aPQAEQ2ZNuACW0x4WZQNLQZTPL+p2x14plohxHe6gyDZVkRwofwCR1rJ4u4bM/iiSl8n
         /4AWuB4o8tyB4im3N1RQ+B6wZcV+KsoIg1eqrIPq65sksKLqs6dH/4gSFn0fhNQHiMFx
         xcSjmeDGrSepdnWGDDVwBkAoXx2fKMzdzRY5QOQpsLu+WTCJvHvopE7+rj3z1bV52+R5
         EwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieGGL6rIftmGUrUPP8WBA7EIeMeymcZEigdcphOIazQ=;
        b=QdgUGJ9dexyXBoYVCJ9VMpfk1IQzoch6GKAwHGXGmXH+Z5BCHbY6UWXqOCPZ+udECp
         kn/fEuRqnVDQzTvYV6qTvAVBccbU8gw8Bl7ihyxT13xXHxPRu+sN6nj564JqspGgbCWx
         rhzt7bgMJ7LvhcrDJ6+LqugLQog2hHL7O1OIgsFgRRlAGrCM5KOrdJFHUMSMn3Dupvx9
         aySNqtADCs0o8CZqsRGiYxkSE2Qzb1HXVxCd+NZ2IbZLZ3Q1jYiQrm6J9stvTrpx0+Z9
         YbI6tqtifUBRvpb4v9MsKftUXV31WhNpcIa2mb8zYxZ+77alocfYcqa102DEmkXZd41b
         07QA==
X-Gm-Message-State: AOAM533rGpbD7esH0X6wOj3Hwa6mRGN4NPuAdBJVAu4ELEpPRrAHWd6N
        pxckocFhLH/AVFxTp+Cu7iPWlA==
X-Google-Smtp-Source: ABdhPJysHApS2IUHUucTm8+Tzo0kQeaczIijUCeFjBK4YCihzwJ3FY8DWqaTzGm9Hxg9cvYwQi3bQQ==
X-Received: by 2002:a5e:d61a:: with SMTP id w26mr6065331iom.40.1616249853034;
        Sat, 20 Mar 2021 07:17:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm4273221ioe.44.2021.03.20.07.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 07:17:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, andrew@lunn.ch, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] net: ipa: fix validation
Date:   Sat, 20 Mar 2021 09:17:27 -0500
Message-Id: <20210320141729.1956732-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is sanity checking code in the IPA driver that's meant to be
enabled only during development.  This allows the driver to make
certain assumptions, but not have to verify those assumptions are
true at (operational) runtime.  This code is built conditional on
IPA_VALIDATION, set (if desired) inside the IPA makefile.

Unfortunately, this validation code has some errors.  First, there
are some mismatched arguments supplied to some dev_err() calls in
ipa_cmd_table_valid() and ipa_cmd_header_valid(), and these are
exposed if validation is enabled.  Second, the tag that enables
this conditional code isn't used consistently (it's IPA_VALIDATE
in some spots and IPA_VALIDATION in others).

This series fixes those two problems with the conditional validation
code.

Version 2 removes the two patches that introduced ipa_assert().  It
also modifies the description in the first patch so that it mentions
the changes made to ipa_cmd_table_valid().

					-Alex

Alex Elder (2):
  net: ipa: fix init header command validation
  net: ipa: fix IPA validation

 drivers/net/ipa/Makefile       |  2 +-
 drivers/net/ipa/gsi_trans.c    |  8 ++---
 drivers/net/ipa/ipa_cmd.c      | 54 ++++++++++++++++++++++------------
 drivers/net/ipa/ipa_cmd.h      |  6 ++--
 drivers/net/ipa/ipa_endpoint.c |  6 ++--
 drivers/net/ipa/ipa_main.c     |  6 ++--
 drivers/net/ipa/ipa_mem.c      |  6 ++--
 drivers/net/ipa/ipa_table.c    |  6 ++--
 drivers/net/ipa/ipa_table.h    |  6 ++--
 9 files changed, 58 insertions(+), 42 deletions(-)

-- 
2.27.0

