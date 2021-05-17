Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82476386BF7
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhEQVJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhEQVJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:09:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B66C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mw15-20020a17090b4d0fb0290157199aadbaso287392pjb.7
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eSsi0EGf7GOU5+Zww+xYZFZEOwMtDPlrCjBSHtT9TsQ=;
        b=UWRx0MECQQ6WZjR5v9KrLXzbC7CgoNAdbJjG9XioETgda9UVkvVPph1s1V2xjRsuJX
         gopKwU0tuxOSjuPqQkZ96wgEv+O8GBW8OBwFwQRLey8V+5R7SnvESjTXp+aOFN51aqYK
         r334k34n47MLs7ZsYnAXi8YSfdtHDvQ9EzJM1kk/bExqTL3ohx6Onc9hocfW6Qs3adkj
         sKWV9ih04SZmgciWMQItvGl7xF2TLgcQImRXpDoPIci6H9KiNXl40mkI6KFj04Q3VM+c
         lR9WXu11hoy0HQgoVLdnj4Sx0pCFJTUfYUetrtWRK4RpbW5pL2OKd0Rw9GVzmaSm4s8q
         RQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eSsi0EGf7GOU5+Zww+xYZFZEOwMtDPlrCjBSHtT9TsQ=;
        b=tadrZf5LHxZ7+s9Il+Rmcqu5gIP5p1DnEtbXB6cOH7HZNj8LN+/4VhYPUviQ5f9xwc
         Qp8YmZOWL9JATBScuksz64dF9IzNZLOGH+Jgywtwm+Zh+ruEQd9Bv0zVrXkaq2aFTvvO
         JzlSmg2UgH0KY7XXRZsJDi7q55VwoR8pWecikjYwMenI/OaqzJoiAIbHJMdIFvMBptNE
         z5dA0rLzzTMA3aQZu3L08RNLgpxDiLPMmo3HwlokDa0LzV4VelHOUou3qxxXaJcCaxsk
         FMLNHzubkuRbAH/mAJX0OzI9wFaTb902ewLfOXuduQ6vJnkt1O5KpdTUHTXikA4Wku3u
         IsSA==
X-Gm-Message-State: AOAM531JaRIG51vRxYEUcY/RyXE57NmgLkZDt6iCzoAOOh1oFoHg/TDl
        XjwJJ6WMjmAb2mfGmt+mD6nwIpIjnrr7pZVboMpYK+Vaf/1OvXThsKQg4DyYalIYFlznagaydmS
        qBjPYogxUfw0JG91H8OK77A4MlAe5pD6NnHr0JZEt2k5L43bB5kzpWZuAOE0W02HryVhVuWO4
X-Google-Smtp-Source: ABdhPJzt801aIEcmYbj/Dg0wQL9hqsesk89wNMOYhSVc+K3BoI+MNPTavXl4A/Gvq6QqM1pWcPZ9E/M6KOQbk9PQ
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:ba72:1464:177a:c6d4])
 (user=awogbemila job=sendgmr) by 2002:a63:d242:: with SMTP id
 t2mr1440210pgi.210.1621285710790; Mon, 17 May 2021 14:08:30 -0700 (PDT)
Date:   Mon, 17 May 2021 14:08:10 -0700
Message-Id: <20210517210815.3751286-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH net 0/5] GVE bug fixes
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series includes fixes to some bugs in the gve driver.

Catherine Sullivan (2):
  gve: Check TX QPL was actually assigned
  gve: Upgrade memory barrier in poll routine

David Awogbemila (3):
  gve: Update mgmt_msix_idx if num_ntfy changes
  gve: Add NULL pointer checks when freeing irqs.
  gve: Drop skbs with invalid queue index.

 drivers/net/ethernet/google/gve/gve_main.c | 21 ++++++++++++---------
 drivers/net/ethernet/google/gve/gve_rx.c   |  2 --
 drivers/net/ethernet/google/gve/gve_tx.c   | 10 +++++++---
 3 files changed, 19 insertions(+), 14 deletions(-)

-- 
2.31.1.751.gd2f1c929bd-goog

