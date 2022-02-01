Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F91E4A654C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiBAUD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiBAUD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:03:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D969C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:03:58 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a13so34173334wrh.9
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fkSgioWMLTkoGqDIWLCMutKn9jLySdUQ1z5vlGZxV6U=;
        b=YpXqGIV2xajDvz/AyCf84Z84DIJMY5LWHcF7m1Wl+JNx9uLVn99PhIm02pgkxdNJci
         WQUhQlO5O5TL7tKJJtepsJDxS7TpCxfoW6UjSf7tiiCtlbcon42ptbIyMUEuy+J/BTqU
         U9mtJEm9935C9ygtdwfRa1JKqjOPxCyFYBs5EYb4uf8NHp03nuJC3DW7u55CYxJbbHle
         0YmaEQYu8rGxRJbhJtHJCk9VIpR1sRsnv7jTEggIbYpQkPdXRPQ7Vk1DFtuUuWwmUQN5
         uHSW+rpsKydP6AFn5Rk4HpL0wxv7P9rzbJ7OJvv2f1bHAzGsuCu6H1rHWYDY9mXZpz77
         ZnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fkSgioWMLTkoGqDIWLCMutKn9jLySdUQ1z5vlGZxV6U=;
        b=3kYuGwb+bM/aH1GT8HrFuqReCWD0mf6/BhvOnVvc5mAyBT2dXDXnfQnRrsOc0V+ZxS
         G265mTOfx+mm2zJCV0M/2puy9VtrwyEHk/blQeg5YO/dQb1kDGq7SJRIkcg2g83xm3Kf
         IN/MOeZfma/IKN+5+S2jSng570YRln8LzrTIfB8G1JocQQpwx0J2HzXUW0tHlkF3bWnR
         zeN9YTX7k7oQIk3Dh+t/aj9Y3WQBdJmFphrdlCvWRlxUP1+zG0yjOgX1wJTX/ICffqmt
         WUzLm4WiOnIrlX3IggGrEnVNp5dvS7FYLWXqoLPMqBjcqUPvvYLPZUuyOB5PFYzuM91+
         Ff2w==
X-Gm-Message-State: AOAM531nPpJQLJG9W0SncTMoDLXDtyI6Q7TVxt07OSVH0Wuuvu4hTplz
        Eadk6MZVDB46RwQId98GqiG2pw==
X-Google-Smtp-Source: ABdhPJwBVoJ+wrFxx/APcr+nBCT9totWanxEoRnTZs35TqYnQamUL6C8DYh7A9BoM5v+B7XbfZgvvg==
X-Received: by 2002:adf:e6c9:: with SMTP id y9mr23944872wrm.389.1643745836719;
        Tue, 01 Feb 2022 12:03:56 -0800 (PST)
Received: from biernacki.c.googlers.com.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id m6sm3367280wmq.6.2022.02.01.12.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 12:03:56 -0800 (PST)
From:   Radoslaw Biernacki <rad@semihalf.com>
X-Google-Original-From: Radoslaw Biernacki <rad@semihalf.ocm>
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
        Marek Maslanka <mm@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.ocm>
Subject: [PATCH v2 0/2] Bluetooth: Fix skb handling in net/bluetooth/mgmt.c
Date:   Tue,  1 Feb 2022 20:03:51 +0000
Message-Id: <20220201200353.1331443-1-rad@semihalf.ocm>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is second version of the fix for skb handling in net/bluetooth/mgmt.c
First patch is fixing the skb allocation which theoretically might push skb
tail beyond its end.
Second patch simplifies operations on eir while using skb.
Patches adds two helper functions to eir.h to align to the goal of
eliminating the necessity of intermediary buffers, which can be achieved
with additional changes done in this spirit.

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

