Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D933D617
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhCPOsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235694AbhCPOr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:47:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45F3C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:55 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id bx7so21839308edb.12
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=An1wBgxdSM2WTqoJiUre4ri4PR+o82AKrBUEKgLUrXo=;
        b=k85jDj2CnrblZnVpdp1KjpvTqV/JB5o3YQ59afFLWG1KLmmPqwmpqVi1v9OEHsGzUT
         hDUOTkxRsoBXyKgxfaKz+HPUM+M6wY8fPJ37a2sBa1Nkn9Enyq8CaLXK3J1Otcs3c2h4
         We9ezMDOPl8e1WkvUjTflhBITzZW8SkFdlqabUJvfRtEyTO1w5qW4WM0qneKlYnqfoK8
         pAYVt2jN/fbp4ZKycKcfxm8zul5oRiwMieMMVExDEmNfyOioa/YzKtlX/vcyQgvQo/3T
         UZ3dxxTkC8GZVboyc2TgQB1vkwClg05L8acd47zLMVAesLE7aUQUtOcTo56tBe7xlwRw
         +XGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=An1wBgxdSM2WTqoJiUre4ri4PR+o82AKrBUEKgLUrXo=;
        b=s2Qu30cHi7coj3QLPx7QS8AJdZtvASp+h0EBZx0trn5qrHX0vLRni/8va/UzHHJcAO
         VgUTPXoHpZuTg9Z9o0madS6jDQTJu7pifkWLhSeHx/KPAtX0J8LBt0tKztDJQQyAbZ8+
         XGhJIdlxQiVDtRJY+Uc0mNbBPpTZgQGIrnI+4+Tujl47kMRNsWR33SFxzm7IXOOz7snc
         VObAP5ojLgi3WtgfTQ3+SkDqVnpBEYd+cw8iageIz1k/NRtk9FoQjhay9Z5eIfD/OoRT
         LgXP2ZhWNRGmtaZDBsKfDsl/6JLylhv9yGVjFV6d1I/aMHU6FaDfzpA4xbkJFccFKfZF
         PH6Q==
X-Gm-Message-State: AOAM533/zYdzuSHCFj4+wQMvjDismvdwEtBABYI/TTSSdzbmg+aJ8esI
        EVKeGNwKtxTc8dC13N3QDb0=
X-Google-Smtp-Source: ABdhPJwak/j/x6Gef8eTZygW5j0Ni2OxfHnTB5AdCbCbvRvJrlGpGRVxCVAIF/a1z+x4ERsg+dA0Ow==
X-Received: by 2002:a05:6402:220a:: with SMTP id cq10mr36580799edb.345.1615906074569;
        Tue, 16 Mar 2021 07:47:54 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id de17sm9467441ejc.16.2021.03.16.07.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:47:54 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: use indirect call wrappers
Date:   Tue, 16 Mar 2021 16:47:27 +0200
Message-Id: <20210316144730.2150767-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The dpaa2-eth driver uses two indirect calls in fast-path, one invoked
on each FD to consume the packet and one for each Tx packet to be
enqueued.

Use the indirect call wrappers infrastructure in both dpaa2-eth and
dpaa2-switch drivers so that we avoid any RETPOLINE overhead.

Ioana Ciornei (3):
  dpaa2-eth: use indirect calls wrapper for FD enqueue
  dpaa2-eth: use indirect calls wrapper for FD consume
  dpaa2-switch: use an indirect call wrapper instead of open-coding

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 15 +++++++++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c   | 12 ++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.h   |  1 +
 3 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.30.0

