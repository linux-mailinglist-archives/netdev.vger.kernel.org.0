Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194B649BF8E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbiAYXbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiAYXbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:31:12 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB785C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:31:11 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id v14-20020a170902e8ce00b0014b48e8e498so3334335plg.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2OxD7lhWQ8z8mrbAunWzD14dk/y6gG9+Nr2iMdNY+h0=;
        b=B4zcLfUj2Ox6kiViLjEMRa5lHUY71DWHjbZZ7nDAZnI+/cMgn4dsxZHYFR0gRhxsoA
         s33H9DP0RxzoUg9k3FmnhTKuIbMFFtmSMES37CLu+5iMA+gEKbYDRSu6Ys9ahONcLLhc
         U5NiZEqyj+NCvJbh0JGld96xfHlzY7yZhfn4PwCGp17WgF9aNBg+OyOTFYJj/R/aFnYk
         E27VK+uMMmBbhMc/wuXHhIOBAHMX47gTURxaTmpE0ttReDjKtdfmk+UuJlnBit6r3UXK
         B5PXGZzFWX0ZdX2mWZH91FVXmwviewUUn/fJ5Jwz1rJhf7R8gAJjjzR+3KarG0Yzn88+
         bHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2OxD7lhWQ8z8mrbAunWzD14dk/y6gG9+Nr2iMdNY+h0=;
        b=A6XsbrMUL9v0/Dsma0Jzu0Qf4ia3TjHCsrCVdz8lO3XkfpuPegku3KgXDQij6SXFFa
         9pB02k0PVtdIBfqL+RckJuZmDA7DOw3TnyM6KnPsLJA2FxfgPZch+VS0+QIATKnBaRac
         NLPLXm3BdISWdkkzppnmrJaLQXzxUpYV4itS8lcauDQ04SM0LAmeB+Boxx2K6fT97u3a
         BbunbQru7024mkFxQgyrKYkmASsFP51CUOIiF+Y0Da3KlCfQCq3eg4/o0WqbLDz7kFaj
         CY/6STnq6qkgLx6/1Rd8ePt0O0puSqI6rhQvWMN8GofuXEOtsysJ2mCOcHS7T6/QLLea
         zQ2g==
X-Gm-Message-State: AOAM530gY7sjgP255fYawfa3TN9x+Vq+Y0/0wJm3UCc32VrszwEpncBW
        AM86TW6pWQiOfqRBKOCju3ygvmpjUz4hrHUaKRWeRSspqFToFIc07MxVip/6pMNyEeLEWC6MJN5
        3BN6Dk8lZI3N6oS16g4WwDxf9oxjBDVC7R50Didi5qcCV5/b24nDyf8+8CbGCdFHKkfKZceoe
X-Google-Smtp-Source: ABdhPJwxJLbzcv8D2uSCbyauiVD56hA4mQL7jwyOCRkg/UE9uG2OUn4pJlUjO0PnccV28vD/QvJZ/gFIfFhj36Wg
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:89e3:235:ddae:72e0])
 (user=awogbemila job=sendgmr) by 2002:a17:90b:4a86:: with SMTP id
 lp6mr5930273pjb.140.1643153471360; Tue, 25 Jan 2022 15:31:11 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:59:09 -0800
Message-Id: <20220125215910.3551874-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH net-next 0/1] GVE page allocation improvement
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     jeroendb@google.com, David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains one patch which attempts to improve the way gve allocates pages by specifying
GFP_ATOMIC in the hot path instead of GFP_KERNEL.

Catherine Sullivan (1):
  gve: Fix GFP flags when allocing pages

 drivers/net/ethernet/google/gve/gve.h        | 2 +-
 drivers/net/ethernet/google/gve/gve_main.c   | 6 +++---
 drivers/net/ethernet/google/gve/gve_rx.c     | 3 ++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.34.1.703.g22d0c6ccf7-goog

