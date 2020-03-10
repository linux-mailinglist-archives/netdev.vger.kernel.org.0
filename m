Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40778180253
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCJPtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:49:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40045 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgCJPtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:49:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id e26so1925761wme.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I14fiRytJUELoaKXOIcZxdSz3/LwiiAblB6a4UaXMhU=;
        b=HEQD6we/080o24w+LzppQn27ScpblwhD8jACOK9fACkhAUxpzm0Dla6f7J7p8SV+Pl
         ztMZ5urWzy6wuvsY8OAE+VR2N6w5Ly3p0gdaHnAkEpKWuj030bM5e0O1gdDtPgA9kweW
         s0sSYueLSFPMuSHaWIaKixCeW6zPJWWproT01rzsuK4A+6xCZmM9MfnLFe9Y38x29G6A
         IiulT9P0W1IUCTUEDWC28EPogOJvpGYeNA/5avEF/Vv8yNSxbEbh6JNsyx07aUa2zgCq
         nMf4aTGr5dFqtsNBpLXVCArQvuijIZr6NQ+ZAW2mfDK/ogNhpYVsduE3rGx2RxwClGAZ
         NtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I14fiRytJUELoaKXOIcZxdSz3/LwiiAblB6a4UaXMhU=;
        b=MX6WctI3u/mxip9CrbqSrsYmjmN5UaPgEXrjrs/zK8dHXripotpSEfOT5i+YakNUts
         JAevp9lmoNS2hZf4kjU4darU1yuVBm0H3ho/eJnKCnZmXkZNb9h7T/Z2fapRBBKrUZGU
         OHOWzwONMnteJqhvVIlCciJJpAVIChzLbpkByyriF0zSO53PapQFmyUqIIyfn9IxsRih
         /a46tUROeVZuBFPlpGWde0pPc2fWL//LwixpKnIh0d2nMk+XUvq1yc90wwdEJNffuT9u
         AmfIkcd2U/K8GEzPRzZh5KfYRdV6gbfsylsQzzfmlSQSUAl7FQffbjbCA8E3wpnwpFcY
         /Qsw==
X-Gm-Message-State: ANhLgQ0SHOBTsnxlwNdRF6TlTrq/LSpcUPe0X8ef2bFSrfeBjzmthjEl
        4qmlKHJiJetDpi3IOGtM+XAl5Id7cSw=
X-Google-Smtp-Source: ADFU+vvDpcP1R5bjkbKHEjDVLv9x3ITuKs76iLYri0Cbl31Y8QmQBVMjYYQHBiV4W+sbmEcpMO2YUg==
X-Received: by 2002:a1c:2d86:: with SMTP id t128mr2909255wmt.38.1583855351324;
        Tue, 10 Mar 2020 08:49:11 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i6sm1649572wru.40.2020.03.10.08.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:49:10 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: [patch net-next 0/3] flow_offload: follow-ups to HW stats type patchset
Date:   Tue, 10 Mar 2020 16:49:06 +0100
Message-Id: <20200310154909.3970-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes couple of patches in reaction to the discussions
to the original HW stats patchset. The first patch is a fix,
the other two patches are basically cosmetics.

Jiri Pirko (3):
  flow_offload: fix allowed types check
  flow_offload: turn hw_stats_type into dedicated enum
  flow_offload: restrict driver to pass one allowed bit to
    flow_action_hw_stats_types_check()

 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 +-
 include/net/flow_offload.h                    | 46 +++++++++++++------
 2 files changed, 35 insertions(+), 15 deletions(-)

-- 
2.21.1

