Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70992309A6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgG1MLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:11:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44842 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbgG1MLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:11:34 -0400
Received: by mail-lf1-f68.google.com with SMTP id y18so10849679lfh.11;
        Tue, 28 Jul 2020 05:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YbhY91q5+cbKaui6Xn8c9WzRHG7wbBm55onNv1D4kWQ=;
        b=RjOGwZQwVsrvThiWuwwScSH4Or5XbbNws9bC8n5EMADORVtlqXyJelBwl0UdXKTCYK
         j1CLwVGIFn5kJM9VoE7Cui46rx6z7YNAunWkEz9NmNSyPV2tZalddT+/ibjF1AUPorFd
         75EP6kOc2Ehskw9gz3uLTDsXOhkysFLdt32Kk/cVmBTykM1uG6HdqD6gLgJTy4DkD01f
         pO60NAgsAnq1/4ppA2YcrCVGgjwyP+7AvohOarZOUi1j5DYhE9VJJ+mNlM6y7eRpZnf6
         XKi79hPbS4K3jw+Rlj+oPaSTskpLj0p3Vnvr6G8vVXz3pmTdD4IK7oXhqkWI7rf1hYmi
         ewrw==
X-Gm-Message-State: AOAM532a2nXz9FtHqzGX4H9apNWgfAIjSIslpZiinER95FnSSRcBmCsA
        2KkIvHwnoiLzzpTs2zBX1cc=
X-Google-Smtp-Source: ABdhPJx7cyVpzBP2fpc28JYPbYEZEM83QMxPnmgF4I1a1Ztd2Im61fsqnfcZpSBSEv9aJhby0Mqr8g==
X-Received: by 2002:a19:7d04:: with SMTP id y4mr14552159lfc.51.1595938291522;
        Tue, 28 Jul 2020 05:11:31 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id j2sm1751468ljb.98.2020.07.28.05.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:11:30 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1k0OS5-0003Dj-HL; Tue, 28 Jul 2020 14:11:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH net 0/3] net: lan78xx: fix NULL deref and memory leak
Date:   Tue, 28 Jul 2020 14:10:28 +0200
Message-Id: <20200728121031.12323-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first two patches fix a NULL-pointer dereference at probe that can
be triggered by a malicious device and a small transfer-buffer memory
leak, respectively.

For another subsystem I would have marked them:

	Cc: stable@vger.kernel.org	# 4.3

The third one replaces the driver's current broken endpoint lookup
helper, which could end up accepting incomplete interfaces and whose
results weren't even useeren
Johan


Johan Hovold (3):
  net: lan78xx: add missing endpoint sanity check
  net: lan78xx: fix transfer-buffer memory leak
  net: lan78xx: replace bogus endpoint lookup

 drivers/net/usb/lan78xx.c | 113 +++++++++++---------------------------
 1 file changed, 31 insertions(+), 82 deletions(-)

-- 
2.26.2

