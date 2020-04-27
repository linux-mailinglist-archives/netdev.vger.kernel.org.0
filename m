Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5716F1BB226
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgD0Xu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgD0Xu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:50:59 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E069C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:50:59 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id n16so9419345pgb.7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ypBQ5jthy0XRcCaAMzZ9hsDAIfs3C091LgxU9hbwyEc=;
        b=S48JZg6qOgyb6OnCfopPK5C22KrR9Cn/FM2vQixWD2Ac15A4RtA5Nd7umiANX9fo01
         7EsNZPlF+/eSanXFnbPxC22/bvPJ1bcv9U06OGePbkAEj/WJakGnFt0HhfJ7vQ+MeVCW
         eSez9RB83J4/f6LyFJlmXn9zydR5EG9FnTwUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ypBQ5jthy0XRcCaAMzZ9hsDAIfs3C091LgxU9hbwyEc=;
        b=YRFcEFDwCntTuzAJJODrgk0sidhnW/yV3bTFnrsDOClodJgtWUCcqhfFRQ/yzS41/0
         KPntpF7KiVjerdXBsV0wWnOkg/P8ZYkDyfbBGx6iRtZcBoBC+/L3ox0R/Vj3LFjYyWU/
         dGSD7hFkTE/Gd3+UCKrIlYyoZ72Qrok9aGpPJqi5cBjIWXOlIw3pWFQLD/GEJA5GUXKf
         3TM+WNrCbs/A7axEv33YOvPSWoQJDtfHF0OWrWvKZ6i27538DtroeB7nVVobva2VsUx2
         pVbnbaA3x1dA1JWGlsAApueAGdkHgVxICZnf8zknAyq2W6Kah2R6joGhLz3PP43izOHB
         83Zw==
X-Gm-Message-State: AGi0PuZXVAtwsKfJQ5UNZg7NSKdAI4tH3EzX9WqULcck2uY3eesWpNuV
        w+I9DVVKeN5+YPMwQO2xtreeYYCEldI=
X-Google-Smtp-Source: APiQypI2SbFRE2wE1Q0wqT9to7TIdnbpK6+ODTepu6hvuf40HHhQVPOa4vJD17+p3irFOsyiQS0eWA==
X-Received: by 2002:a63:111d:: with SMTP id g29mr23017841pgl.403.1588031458311;
        Mon, 27 Apr 2020 16:50:58 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 128sm13058106pfy.5.2020.04.27.16.50.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:50:57 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 0/7] bridge vlan output fixes
Date:   Tue, 28 Apr 2020 08:50:44 +0900
Message-Id: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More fixes for `bridge vlan` and `bridge vlan tunnelshow` normal and JSON
mode output.

Most of the changes are cosmetic except for changes to JSON format (flag
names, no empty lists).

Benjamin Poirier (7):
  bridge: Use the same flag names in input and output
  bridge: Use consistent column names in vlan output
  bridge: Fix typo
  bridge: Fix output with empty vlan lists
  json_print: Return number of characters printed
  bridge: Align output columns
  Replace open-coded instances of print_nl()

 bridge/vlan.c                            | 115 +++++++++++++++--------
 include/json_print.h                     |  24 +++--
 lib/json_print.c                         |  95 ++++++++++++-------
 tc/m_action.c                            |  14 +--
 tc/m_connmark.c                          |   4 +-
 tc/m_ctinfo.c                            |   4 +-
 tc/m_ife.c                               |   4 +-
 tc/m_mpls.c                              |   2 +-
 tc/m_nat.c                               |   4 +-
 tc/m_sample.c                            |   4 +-
 tc/m_skbedit.c                           |   4 +-
 tc/m_tunnel_key.c                        |  16 ++--
 tc/q_taprio.c                            |   8 +-
 tc/tc_util.c                             |   4 +-
 testsuite/tests/bridge/vlan/show.t       |  30 ++++++
 testsuite/tests/bridge/vlan/tunnelshow.t |   2 +-
 16 files changed, 212 insertions(+), 122 deletions(-)
 create mode 100755 testsuite/tests/bridge/vlan/show.t

-- 
2.26.0

