Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C61F6E30
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgFKTsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgFKTsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:48:38 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E33FC08C5C2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i25so7772715iog.0
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDDrr/NQDj6ybLizJRwqRnWp4a3Jj0ud89QSXqdxrfg=;
        b=dAUDD2Db2HUmwxvxWn3e+TZvpfaM8TP5nup4C728yyrukfIudVQ6QMGBzh1pS7zVXz
         6GXc5XO7P7tvf8pTuhPpgRNE6h5j+1ft9YnzbSFJHtlyihd+Rc+YoAUXshG471WTufnl
         3bjpOtWm5t51j3tYGDQ7dPqIDqm89n/Zp51H/NprSHVmfFDAnT1PMJXYMo3Gtv5zsfIm
         uNtm9/Ozz//1ckNS56B2bnLM1KrUoP8GgZ3L+fT2XNmmC3mHflRfP8rgCEd++ApYAl8d
         +oaTYntW9q6nP3/oWtaiELJdL2DqMbNGO09Uc82rtYOOTXP5pBXUL2Hjs+cllFkH9WDI
         O5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HDDrr/NQDj6ybLizJRwqRnWp4a3Jj0ud89QSXqdxrfg=;
        b=JtlojUH0k3+Jzjhckk6OKCVA+G43PF22h/aJ54RXHGKnAezdUKftppLSYrrRwKpINe
         vOUQKG7kwZOs6YgdOCuSAmHP22vlM8nI0KPt95e4Kp/iOrf2oTJv23eV68gWzOuyOJrf
         zBigQoGdNvuYCgU+M9Dm5mWkmLamHbpSHZi4GSlWIHUrDO07Wdgfo8H92si4Ny/M3J/q
         0vx1KRQBnM4QnZExvEnK56+t5kntBAobdpoFhb0M4i0mY/8SqTphRdsu/F7aTEdNBL/y
         jgGzd7TVweJQuraYtZyvnpBH/u+087s+n7yYc8E5tZ8Ctcn6vxMUKfcs9sjl0mptJJ4y
         yiTg==
X-Gm-Message-State: AOAM532Bz5azdCNGLwyWX8bK7nWV8o8nJhPjF+CKdMMrE5CUQYjtogDO
        GBRI18kukRwiGkNb65tyFvbM4BoP5LU=
X-Google-Smtp-Source: ABdhPJx0eeURyBNb6xwGY65ZL/56pFNcRcsY80hRs4ZMTasZ3I6dikE9YB1hpK8qhCAR58tRQS1XdA==
X-Received: by 2002:a02:c848:: with SMTP id r8mr4625643jao.15.1591904917587;
        Thu, 11 Jun 2020 12:48:37 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d13sm1981397ilo.40.2020.06.11.12.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 12:48:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/4] net: ipa: endpoint configuration fixes
Date:   Thu, 11 Jun 2020 14:48:29 -0500
Message-Id: <20200611194833.2640177-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes four bugs in the configuration of IPA endpoints.
See the description of each for more information.

In this version I have dropped the last patch from the series, and
restored a "static" keyword that had inadvertently gotten removed.

					-Alex

Alex Elder (4):
  net: ipa: program metadata mask differently
  net: ipa: fix modem LAN RX endpoint id
  net: ipa: program upper nibbles of sequencer type
  net: ipa: header pad field only valid for AP->modem endpoint

 drivers/net/ipa/ipa_data-sc7180.c |  2 +-
 drivers/net/ipa/ipa_endpoint.c    | 95 ++++++++++++++++++-------------
 drivers/net/ipa/ipa_reg.h         |  2 +
 3 files changed, 60 insertions(+), 39 deletions(-)

-- 
2.25.1

