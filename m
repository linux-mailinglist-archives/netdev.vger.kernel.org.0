Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AEE2941F4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437325AbgJTSM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437320AbgJTSM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:12:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67D3C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:12:56 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q16so1545839pfj.7
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Xx2oNgo4dBG9WUv6kVlgcOEUmr7dWfMgkko4T7vbi+k=;
        b=KWGAsEeMhwa1UrgG1f3mxderivplmiSScvoJxNFeocZHP8Kb8yhWEU7s9nsVkvbYCA
         KsVfeEALeNuMtdlW8qtypHWOtnvNNA32hoA1JfuBlWodqkQiESFQHvLjmj+5Btz3gvXG
         8PpjdGg4Ynak4sjINUMKIWWk9eYQV6hbLw0W3hz7Vc8Vo3zj4//UDZF+hwXhqlq2pgxo
         uJF7aGENvIBUl4bTfXGony0/PQPSUGKOmJUWVSo1YTlmsrmagVqCke9GLC89c2SKbDo+
         omXHlyFG4JjhjMxJ66nEdDKLxDwBRh5fDLfIIEGNjkgAX+nDBeQX+41Z8oEdoOEw1PsT
         yXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Xx2oNgo4dBG9WUv6kVlgcOEUmr7dWfMgkko4T7vbi+k=;
        b=a31TGlu5+wPPu8d4EnHy9GZGg5r54BH+lK+JsvmkdJ0yDzRTlIhX8wj6L5WaYkfbWW
         GrauznZXrLVdIVe/2ZABqpV4rd2/u8gKBfuAa6mf3lGNRshUHKHaXoOkGbggSn+oduy5
         IHkljsOqLd3VSLWKahO9K5pBLubtkReRdnbJKgprxuftLNnPr2Fgu6hUjTqvKlhtJA0O
         MEL1MZJ6KUdS/Ze2UCOTLDOU4aR1Jfd9g1LNPHils/nJIRTX2kF9gNDW/x48yakMOH0w
         4eKiFE0jPPoOc3ICGn8LW7Vm4xR1uSM1LlA3apDEVzsEAatShY5uHefmphzBzhDV2Iwf
         lEOg==
X-Gm-Message-State: AOAM532xg1EQcYJewXrvM35YZ6L/JmRTcyodcsAWRoAnvKMYm1BGFcr8
        4SN27IxBqjMDCo7hGrr1+hvuNK/8IhEtg5SpK7D+s399PlDvIDuJRRPj1HIYFa2ypSQKroX+BXO
        w6lkiHYxy/HgNe0kpUZZ31jYWyy8S/alvIoB3aSL1a/C26aT5ViON6a59FkFzkqnB1bkJoI78
X-Google-Smtp-Source: ABdhPJxc8TY+hgXPMjUmTvgT8DoNhncT9rf3ZinoNsjG0NuWXpO+0OzRQUXvt13t59P1DhRRICP3Y/UqKVINVq3f
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90b:20a:: with SMTP id
 fy10mr3879611pjb.20.1603217576256; Tue, 20 Oct 2020 11:12:56 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:12:48 -0700
Message-Id: <20201020181252.753330-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH net-next v5 0/4] GVE Raw Addressing
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v4:
Patch 2: Remove "#include <linux/device-mapper.h>" gve_rx.c - it was added
	by accident.

Catherine Sullivan (3):
  gve: Add support for raw addressing device option
  gve: Add support for raw addressing to the rx path
  gve: Add support for raw addressing in the tx path

David Awogbemila (1):
  gve: Rx Buffer Recycling

 drivers/net/ethernet/google/gve/gve.h        |  40 +-
 drivers/net/ethernet/google/gve/gve_adminq.c |  70 +++-
 drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
 drivers/net/ethernet/google/gve/gve_desc.h   |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c   |  12 +-
 drivers/net/ethernet/google/gve/gve_rx.c     | 374 ++++++++++++++-----
 drivers/net/ethernet/google/gve/gve_tx.c     | 207 ++++++++--
 7 files changed, 581 insertions(+), 155 deletions(-)

-- 
2.29.0.rc1.297.gfa9743e501-goog

