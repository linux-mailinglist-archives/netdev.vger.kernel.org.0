Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482E425E842
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 16:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgIEOEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 10:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgIEODp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 10:03:45 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C586C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 07:03:44 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t10so10239638wrv.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 07:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n6w3nK8xHEZQLDx1ZWmkRM/JPSMFVDVJw4W6fxo3ljM=;
        b=Jg9foA5T+vE8UB0F0p6HvIxR1kp9W7w92wbu1Ilm9BfEAKEmAs4K8P7vq07u4Rpwjq
         Eyul5BazBuIASEUBLKmK7QdvyHP6xlRMMiCm5nkVwlOTVTpY3OYJBFlQIOLqCPhwB+aV
         9d3I+Cer4gxwjPTLqvUwqckCv4HTa5ReKCgvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n6w3nK8xHEZQLDx1ZWmkRM/JPSMFVDVJw4W6fxo3ljM=;
        b=QiUzOb7ddP3mbs3KYK4FsAAOWW6xHjr8vClBtm3ZqkkCZcrXPts6LCYdml7tvRPnCx
         HQFQ75jET7vtySxe4ipjZtSvVEl2W00fcaDtKWoeBdEJziqO4ePdL9maujw3uqy+cwgh
         OoKFXrZDBo1MkIaRFPpYmmvAhBcR3ZoM5UxQi2YLWIFmWvCBf79TvjvQUCV0lk4+Z1i0
         F5uz32H0YI40/n/sEAGgqWC4ndWekCwwg5Mnj5LMUMNfnChnu14dw1kpcVy2OZUDm5Cp
         f5t9wQIsbZ98droNVQTIk1wZJorTPRCC/fpJ2sMOJdCeidgYxuNrtQMYMOzzar2rdUj3
         fGjw==
X-Gm-Message-State: AOAM531ve3X1zQwGSy644I+PcIyn+RcpxDB45mfBjEUdClqmEshnH+GK
        T2llQRIxwCRGu9RyrtuRV5qEOHnh5BqG7g==
X-Google-Smtp-Source: ABdhPJwJ7tJYzDg5p0OGI5bYLnXP/js17rroymPdiKsxEC9s7qXF/iLO6ZWswXDTH6QMKGUkmK+m3A==
X-Received: by 2002:a5d:6547:: with SMTP id z7mr12429103wrv.322.1599314616513;
        Sat, 05 Sep 2020 07:03:36 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id b2sm17390369wmh.47.2020.09.05.07.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 07:03:35 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 0/4] ksz9477 dsa switch driver improvements
Date:   Sat,  5 Sep 2020 15:03:21 +0100
Message-Id: <20200905140325.108846-1-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These changes were made while debugging the ksz9477 driver for use on a
custom board which uses the ksz9893 switch supported by this driver. The
patches have been runtime tested on top of Linux 5.8.4, I couldn't
runtime test them on top of 5.9-rc3 due to unrelated issues. They have
been build tested on top of 5.9-rc3.

Paul Barker (4):
  net: dsa: microchip: Make switch detection more informative
  net: dsa: microchip: Add debug print for XMII port mode
  net: dsa: microchip: Disable RGMII in-band status on KSZ9893
  net: dsa: microchip: Implement recommended reset timing

 drivers/net/dsa/microchip/ksz9477.c    | 11 +++++++++++
 drivers/net/dsa/microchip/ksz_common.c |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.28.0

