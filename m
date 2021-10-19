Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C36432E47
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhJSG3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhJSG3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:29:14 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5656C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 23:27:01 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y74-20020a1c7d4d000000b00322f53b9bbfso1482391wmc.3
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 23:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=14hE/HoE6tI4nLAwXo08uiDYhtvPAOKko4QhE8iZARI=;
        b=II2ZxrvILPeniVGmWmayH6beEHaywlnezDv3NoQZ0mt5egBe5M/k1X/EYUQn7k/6C4
         m//bcLWW9Vd+12jkuaMFHpoAuunDP2K9J6AQ9zH33R2gXV3z3grNiTccQIoh9pOtFnuS
         OefonCb+w8UwojzEX0runMKOe3E3ztWWKdR022clAZUlohuVwYZyfk67Kr3Nf4wppIG8
         feLA4o17KVc5IOZLqj6Q+gylBfBTfP3jES5uP5S/2eNqBKcM4W1r5Q6SiFTOTV0trdWn
         giJs7PZSIqwGCX6Iv6hPDjZdvjz5BwOc2xn9g/fCjgAKLQiY7BlbgD3RWf9HUhS8bmOM
         xIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=14hE/HoE6tI4nLAwXo08uiDYhtvPAOKko4QhE8iZARI=;
        b=C8Sx3kj/owarcqLx9j0D42rwp8eWsfEqBO/Ygu55a3TkYpVpLca0XY5uy1K5rnghBC
         eZUfm0Jaque/92MuSCsTvRyu2xydcy2zy6n1byX8A5etCLEohN8AXHC4x07qOPLLYt/g
         BsPpmWOFTJkCg0vMEia8NSa8Mbd9FS6EOvuSkjNZ+UWTjIy7E1AVz2C6uc09eygTbLh4
         Ix1I3XJ6MgnEZU13hk+2x0/2O5qStJpoqIOjaKnjXVfyYRfGnHJUYFEz6TL7GqHm8RUE
         euT6X+XJnwJaymY+B9v5RY7c05s23CeWTzQwaTRNQ4sjBwNMUkg+bNYy4AXEl8jek5Kt
         y7wA==
X-Gm-Message-State: AOAM532ox+jdOwSkGkoAoTqIjx4seud9g1uoAiKHkh1DYNO9tVJ4aQCH
        iNkrJsbrcXy7f/gLJCWIchy3mswoBPlcmw==
X-Google-Smtp-Source: ABdhPJy/sGuJDXfEiLv9HQxmbUmbeQID2mzqTm6rznR6FLLJSlqgWcraA88PbNPFcdg7nnNZokFtEA==
X-Received: by 2002:a1c:7212:: with SMTP id n18mr3970223wmc.87.1634624820365;
        Mon, 18 Oct 2021 23:27:00 -0700 (PDT)
Received: from localhost (tor-exit-15.zbau.f3netze.de. [185.220.100.242])
        by smtp.gmail.com with ESMTPSA id y191sm1586582wmc.36.2021.10.18.23.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 23:27:00 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Small fixes for redundant checks
Date:   Tue, 19 Oct 2021 00:26:43 -0600
Message-Id: <cover.1634621525.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1634621525.git.sakiwit@gmail.com>
References: <cover.1634621525.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

This series fixes some redundant checks of certain variables and
expressions.

Jean Sacren (2):
  net: qed_ptp: fix redundant check of rc and against -EINVAL
  net: qed_dev: fix redundant check of rc and against -EINVAL

 drivers/net/ethernet/qlogic/qed/qed_dev.c | 35 +++++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 12 ++++----
 2 files changed, 27 insertions(+), 20 deletions(-)

