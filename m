Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E062A708C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgKDWeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDWeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 17:34:03 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40645C0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 14:34:03 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z3so3105725pfb.10
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 14:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=E1T4sPL3vLwt9SglNdxfOo3TjEF9/se397GTzA62bg4=;
        b=03xFRP66pEg8uj6qyKtY0UPqP8KbgVOP4EYAnWIFY+/uE6iz9mVAI5AUE6oXBoY5dr
         yGZVvYlOsnx+w8RWD2TMOREZqY2zYDU+tnR3BXeWnx/niw/j14AfgVGb/WLxT22DlLKz
         R995r//pCNTtLdANSlihUbpvEVau/sK6tc3fEHq2XYfm2S5A6ut/XAsPft6zKidtne55
         RxUtLJbJSC58ESd/J0nXcdvBAxHFLKC8ld9zzTD9s64qnEjP6A56Joa9MiW0idMbCzf5
         uUxlTUKAvWlG9v9P/W5w5Iovz8Xw8USm3h4tq1tpf/1imVTsRzNLEQvyk66E8GFwiOrW
         56Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E1T4sPL3vLwt9SglNdxfOo3TjEF9/se397GTzA62bg4=;
        b=YmH5ypEv/TOk36V0qCjU8OxYGFsTxFLguyuarev4PVVw+mGS9pz9+agft4Y3Ttsm/v
         uNUfDQjogis0hSAvGGkVppjK9/MsUQMXeViw+FQkaWYdbqpDLFe+bUaUtN5I0goqVd2u
         AX6ZLTJVf19I1epauCX69jQAIEjOUfmPU7DDAYuOgkdztt2NAimWxyz55qY6CLHbh6YR
         YCALRefy8owi0BzWL5gc3WEvL/Piyo5qibQ1LtuhyTuYPDeh21Cgt4Cz6sN3T7HCCHFn
         eAXKTNszlvrB436I4jJacmKehJoiERMW4e+I26sgeerBWc68gwpICbKP2J/j3H6KZAB/
         Txxw==
X-Gm-Message-State: AOAM5323VGk12ea77RzHzio/CvoVNae8VttGGSQ/CQBgZOlL/qldzETe
        jM3KL26EcnHEX+Sozt6Yt/fAWvNhJ+NTAg==
X-Google-Smtp-Source: ABdhPJzXw1FPGzgTKorPH3bKqkxxxGDiOaTIf3wmNGQtgBgzh+uF5y68WpfAXMHagny3RNdTNUZjAg==
X-Received: by 2002:a63:8d4b:: with SMTP id z72mr142346pgd.327.1604529242556;
        Wed, 04 Nov 2020 14:34:02 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z10sm3284559pff.218.2020.11.04.14.34.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 14:34:01 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/6] ionic updates
Date:   Wed,  4 Nov 2020 14:33:48 -0800
Message-Id: <20201104223354.63856-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These updates are a bit of code cleaning and a minor
bit of performance tweaking.

Shannon Nelson (6):
  ionic: start queues before announcing link up
  ionic: check for link after netdev registration
  ionic: add lif quiesce
  ionic: batch rx buffer refilling
  ionic: use mc sync for multicast filters
  ionic: useful names for booleans

 .../net/ethernet/pensando/ionic/ionic_dev.h   |  4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 64 ++++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 +++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 18 +++---
 4 files changed, 70 insertions(+), 24 deletions(-)

-- 
2.17.1

