Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE989314D3F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBIKgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhBIKdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:33:44 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FD0C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:33:04 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id y9so30370458ejp.10
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OhhvLdoOK7dxyc+gvAhgeQCMVCrU1oV8jog6YlfY3yg=;
        b=TmzUP9nI/4qAljODWPPC9mEv9cgbOdHt565Jmb5QVf8YZedcu8xkJ6B6WBBmfrqeF2
         AnN7ObEEPjKl65CE2muD2fDa24Squ9MNa8FBhDIqZyLEvu1aV1ToYSW0B1la/w9HtT7k
         hup0lsTPVvxRo8Iwakziv6q1fy0/J9zcNP28yyHax7d7P7aQGg851Ju2y2jZGjGp2KLQ
         l9yGVRBR4pAcd/9vAx0DCyMvb+Kg+m7hwowUvLB5QFdbTkXt7cMNF71fg84QIAw9yG6f
         juFdM3RUZcPXHgm9uEousAtWA3iBk4XrC5qshR6EcFtm+pSSqIjhcUndUPxvlR1T76oM
         BTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OhhvLdoOK7dxyc+gvAhgeQCMVCrU1oV8jog6YlfY3yg=;
        b=WuNHek8fGR8eHTnyIDtQsa0Ev1zAQaU7Hm+PL2ug6B6BTC6h3QXgHXAuVGXYK36Isl
         d5/5jHZG5usHSLFP3TM5bGJP81pfvLWiXc20DylxKLxOebCbYAMNCIcygSSFTExjMOgA
         V3G/ChRIdneNZRTXUNz71A13DANH/2q2G6SoPv5fZutzP8fuwkiqrdJXYbFLS9g5JLJx
         2FX9aoHbkrOJUJXad57BnviD4C8XBGsiK7s9iUvA+qiG0NC6zfFUdATN4IYKINfHlgoz
         s1kwPTbedoaGpEqoOcMYSP1/7k0ZCcOR7KLJ3gHGPsguXXRXHPWNi4aL++D0wOUNb1Gt
         lk0w==
X-Gm-Message-State: AOAM532RuyGg+bVVwrWmG+afkmOLR+8x1e27Yl5Z8mAKL/u3t+O0II5H
        5+d+UIQFOrnPYT8uiTCsaViAoWD3frrR/5EqGx+GIQ==
X-Google-Smtp-Source: ABdhPJzJNrdM1ev8iQX7T7xdlL+V/bbVeuObX5Bm4jZ1IePWwB7dWN1Aa98Bpq1r1d2gtRju/a3vIA==
X-Received: by 2002:a17:906:5fc1:: with SMTP id k1mr14593150ejv.16.1612866782403;
        Tue, 09 Feb 2021 02:33:02 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q20sm8486896ejs.17.2021.02.09.02.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 02:33:01 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@nvidia.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/3] bonding: 3ad: support for 200G/400G ports and more verbose warning
Date:   Tue,  9 Feb 2021 12:32:06 +0200
Message-Id: <20210209103209.482770-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
We'd like to have proper 200G and 400G support with 3ad bond mode, so we
need to add new definitions for them in order to have separate oper keys,
aggregated bandwidth and proper operation (patches 01 and 02). In
patch 03 Ido changes the code to use WARN_ONCE() instead of
pr_warn_once which would help future detection of unsupported speeds.
These warnings are usually detected by automated tools and regression
tests.

Thanks,
 Nik

Ido Schimmel (1):
  bonding: 3ad: Use a more verbose warning for unknown speeds

Nikolay Aleksandrov (2):
  bonding: 3ad: add support for 200G speed
  bonding: 3ad: add support for 400G speed

 drivers/net/bonding/bond_3ad.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

-- 
2.29.2

