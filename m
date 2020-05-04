Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242EF1C4AAB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgEDXxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgEDXxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:53:51 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C47C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:53:51 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b1so599599qtt.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uU5L3mTKQu7zv3TIEEDa+1AYyusenBY7XS77GDMeGtU=;
        b=dhtEwmdYZyY0rRSaEhvfcNC1vITa/c/X54xRPc3E0yng8bUWygzhzNuicxUYw0p9wx
         Uc/YksC7AF7oeveIe8SZ9pqUUWT1luLkag9l0OUTeIostGlmXMBRCKw6CWhLwmbm7oQ8
         fnuP9O0PS2qxUZvw3QSic2awNcaQdSn326lFZqZ+K89aplT1BDmde15uHh2AePrHezDh
         J32jKYW7mqwaHmgHHu4qHSyrrxmks45wybtVMZgvoK8uaH8ve2sLPQw0fD993jqhY9hX
         f5uunAV4vzbneq4GfLT+I33hcvhPkDQSuGdYqxqRgIRDhNgTUDc19EliQf1p8HFIsF/b
         bGBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uU5L3mTKQu7zv3TIEEDa+1AYyusenBY7XS77GDMeGtU=;
        b=nD5KkGDKqQe7tvA4JguivhezcyKFRG2Z4ep5DmgOITBq7Ngqn5JsMWIoZQwVOHdo7p
         BEqToj3+zaH2NnLPavrSysMKhYacZDOls0Pt1iOYIZ7cSMG/E8bMjYSQKuxtMwadGIe5
         Uiw6+NDYX/HDCSEd6Dq9UetDGmgexClspILGkjnP4IWC/usTRXLEr8upYoIfrgzwkuJK
         Q+3vy3jAZ3kGNuochFS5+QuOVmA6N2i5ilPstcLWahOGG/ZHkkQj19ZMF3j5UJvBTWgN
         S+NKxU+DqDUWGUel5KrHT+rQq+WqRIVvV/l1Sg1Zl1hnzHFUvUvIpTjOi/Cp3X/aATUF
         9OMA==
X-Gm-Message-State: AGi0PuaoMp/4PHiCERe/dROYa5cV+IShRTdT4CnDjo+dYxgMLu/SP2HV
        aEPPOzhP8ZO0Uo0GvuvjhZvClw==
X-Google-Smtp-Source: APiQypJO619AUMvWP6tjl8Otz6evwH1MBuUzxWXt92IyN7ElOczdcZodDUh4lgeHbyyZyfkO5hwADw==
X-Received: by 2002:ac8:65d4:: with SMTP id t20mr36761qto.358.1588636430635;
        Mon, 04 May 2020 16:53:50 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm296004qti.47.2020.05.04.16.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:53:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: kill endpoint stop workaround
Date:   Mon,  4 May 2020 18:53:40 -0500
Message-Id: <20200504235345.17118-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turns out that a workaround that performs a small DMA operation
between retried attempts to stop a GSI channel is not needed for any
supported hardware.  The hardware quirk that required the extra DMA
operation was fixed after IPA v3.1.  So this series gets rid of that
workaround code, along with some other code that was only present to
support it.

NOTE:  This series depends on (and includes/duplicates) another patch
       that has already been committed in the net tree:
         713b6ebb4c37 net: ipa: fix a bug in ipa_endpoint_stop()

					-Alex
Alex Elder (5):
  net: ipa: fix a bug in ipa_endpoint_stop()
  net: ipa: get rid of workaround in ipa_endpoint_stop()
  net: ipa: don't retry in ipa_endpoint_stop()
  net: ipa: kill ipa_endpoint_stop()
  net: ipa: kill ipa_cmd_dma_task_32b_addr_add()

 drivers/net/ipa/ipa_cmd.c      | 59 -------------------------
 drivers/net/ipa/ipa_cmd.h      | 11 -----
 drivers/net/ipa/ipa_endpoint.c | 80 +++-------------------------------
 drivers/net/ipa/ipa_endpoint.h |  2 -
 4 files changed, 6 insertions(+), 146 deletions(-)

-- 
2.20.1

