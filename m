Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE05C4A656B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbiBAUKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbiBAUKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:10:37 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880BBC06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:10:37 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s9so34147014wrb.6
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AixrX3owaZTtv1mSdx9KEwFJIuPN4vmrGLFwEF0ENic=;
        b=30f6IiDcEXBMvc7lHQGHw13PVv6HT+1Yje5IO2c9BUZcmh1oBICK8zpt3DjIiEfZAx
         ZcNfbpFAb29mh+jfouC8b6M4azJA9EIJv3UsziEM/L1pAGZqJsBa8/Z98FiDd4GW11AT
         soOTd96Mnn4rffwFF6JvkBMh+0/njtWMxGG7PKTbj9GDW5MgYU1NUF4walIBBjsHQeci
         nQRfgzVEop53t/CGVAg/s2HksmAVbfAKM+f89N1UZ9SYq27FtB/VVra2XHbsBhn6qBCF
         0B1YX6IaJ7TZqeYBwao2BrDAzC87ysUvBv5sfKYw6nuo2w1QCZj8huVJcG9FknqMvL17
         PkEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AixrX3owaZTtv1mSdx9KEwFJIuPN4vmrGLFwEF0ENic=;
        b=STmSvwG4FQ9YwNZFEdk4CEMZuRdFDHqB8MWb6jsmSMe3p3oAXoXzae/4i680hczE2c
         z8ayq4pL57y8ZHYTroRIQ8Nuv3P35JgDbxZLFtqCWYzC115rQoWzI7ujCcXhKEPfdl1a
         QlofzblS7GE8nM9pZb4ZnONTFdA2wtf6aDmSdw3CMdWKIJPvc00L1jilOwDAml5htfGE
         PLBY7YE8Bh8LwCl/e1z2u0+PQxwL9W6bpAT5qFth95T/FuqOXBVcVyqA3XaZUbxp6Nmx
         o71WcrNtj/gdEUR6lBlAOauIyLVfa4ETK21JvvO2mnzWNPTZxQLZeU5iXmCgN1lHZn4+
         l63A==
X-Gm-Message-State: AOAM530Z4sx5cRuhYL2pFGiPsY0Q6tewEmezLBmFb/JxarpgEKPRX9sL
        yH7iUnOv5GCC6fyer+P+1SgQpw==
X-Google-Smtp-Source: ABdhPJztfRFct39S9vU/FrJ+1fmOxCYCp9XV7ObeykiFvES5AmnQH4EHXLufXh+YtkglkfOshsK1qQ==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr23364887wrr.618.1643746236069;
        Tue, 01 Feb 2022 12:10:36 -0800 (PST)
Received: from biernacki.c.googlers.com.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id az16sm2797448wmb.15.2022.02.01.12.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 12:10:35 -0800 (PST)
From:   Radoslaw Biernacki <rad@semihalf.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        upstream@semihalf.com, Radoslaw Biernacki <rad@semihalf.com>,
        Angela Czubak <acz@semihalf.com>,
        Marek Maslanka <mm@semihalf.com>
Subject: [PATCH v3 0/2] Bluetooth: Fix skb handling in net/bluetooth/mgmt.c
Date:   Tue,  1 Feb 2022 20:10:31 +0000
Message-Id: <20220201201033.1332733-1-rad@semihalf.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is third version of the fix for skb handling in net/bluetooth/mgmt.c
First patch is fixing the skb allocation which theoretically might push skb
tail beyond its end.
Second patch simplifies operations on eir while using skb.
Patches adds two helper functions to eir.h to align to the goal of
eliminating the necessity of intermediary buffers, which can be achieved
with additional changes done in this spirit.

v2->v3:
 - fixed author email
v1->v2:
 - fix mgmt_device_connected()
 - add eir_skb_put_data() - function for skb handing with eir

Radoslaw Biernacki (2):
  Bluetooth: Fix skb allocation in mgmt_remote_name() &
    mgmt_device_connected()
  Bluetooth: Improve skb handling in mgmt_device_connected()

 net/bluetooth/eir.h  | 20 ++++++++++++++++++++
 net/bluetooth/mgmt.c | 43 ++++++++++++++++---------------------------
 2 files changed, 36 insertions(+), 27 deletions(-)

-- 
2.35.0.rc2.247.g8bbb082509-goog

