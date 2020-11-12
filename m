Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450592B0C77
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgKLSWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgKLSWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:17 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A47DC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:17 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id i13so4877177pgm.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=mjlKapZN+gkjiHWaUJiVq/D4dHLG9o2CNH+sZST6xxw=;
        b=YelR5J0wWIwJ3DgTPwe3w8VJllKF2CByqT3/bC4uxWtXXEtQxrlW9wDxO/VzTexTKV
         Fs1MT7g7sJwtCb+96Ssnu7f2dCOorHWmiIsI9BscOsgvE0q8SHN2kUTzCh0+8ZE7kOGj
         9cRTQbpUuMFusvhIOzhsMcGudPlTSEgm8vtfb8A3NUdVhHGvMcWB4yAsuHuPCuGpfQI6
         qUrg6rIhlKdoILajI4yXjClhZ7tmbnmh7Biu9cX/j7L76Iuw1M68A6FWNvErnwWjNhOe
         YLLXiYAxc/F7MKVU2lHFx9585q01b3LUSl1OiI/GRRapsupWu9F3Ja9OSDCg/NKi2feU
         qXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mjlKapZN+gkjiHWaUJiVq/D4dHLG9o2CNH+sZST6xxw=;
        b=uQx7+ks9AeRN4xCqmAQOfilkg1vlGBthhgIzZXjdBRwZ4kfYaChREr+SvRaWq2zLGT
         Z37gsX7Ge9Hc5JaQhwRKkE4Xm+5TtkZ09s6Wk85E+v8Vl+c+aFltj7EKiviLBQvibLSz
         jRDc6bFSF0flEQGyh1YkGw+kiZBUBOX/9en0qD13IE8YV7imZy/CVV59m18lxpeWehrs
         cT51Ja1IEaqNoIOXIpxyzvJA4ftk2x0jcYE2IeMnAiLrNr7W+j6nN9+eb4eKjImIh8R9
         0zZtNVJP9BYm0vcA2x/33fkVdXZllAlXECOwxNQ7D8JZTG9jgjcnicOrML5eRZb4P22z
         lrGw==
X-Gm-Message-State: AOAM533tKFiVjiEucbW2IQUKoULoMALPwkh9alehqEFK8v3sMVg63ek4
        KNKtP+h5pD/gsn6daTUWEE4L6uUSKmKAUA==
X-Google-Smtp-Source: ABdhPJz4vaYU0cKN217iEaA2TqxF9ZUxIQBF+jzfgOzoPW7ehRZsttj403AeqsxixtUkge5PJ7mvyA==
X-Received: by 2002:a17:90a:62c8:: with SMTP id k8mr458277pjs.33.1605205336359;
        Thu, 12 Nov 2020 10:22:16 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:15 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/8] ionic updates
Date:   Thu, 12 Nov 2020 10:22:00 -0800
Message-Id: <20201112182208.46770-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These updates are a bit of code cleaning and a minor
bit of performance tweaking.

v3: convert ionic_lif_quiesce() to void
v2: added void cast on call to ionic_lif_quiesce()
    lowered batching threshold
    added patch to flatten calls to ionic_lif_rx_mode
    added patch to change from_ndo to can_sleep

Shannon Nelson (8):
  ionic: start queues before announcing link up
  ionic: check for link after netdev registration
  ionic: add lif quiesce
  ionic: batch rx buffer refilling
  ionic: use mc sync for multicast filters
  ionic: flatten calls to ionic_lif_rx_mode
  ionic: change set_rx_mode from_ndo to can_sleep
  ionic: useful names for booleans

 .../net/ethernet/pensando/ionic/ionic_dev.c   |   2 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 109 ++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  18 +--
 5 files changed, 81 insertions(+), 58 deletions(-)

-- 
2.17.1

