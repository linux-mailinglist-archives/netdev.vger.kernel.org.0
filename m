Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF4ECBFD
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKAXms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:42:48 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:39755 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAXmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:42:47 -0400
Received: by mail-pg1-f171.google.com with SMTP id p12so7400071pgn.6
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 16:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gHOfO3UXl0K9k2z78DoJ00iPD7GRixkTFuQhmaFYXZM=;
        b=BUZSEsYXSXaLNRjx3t5udyb1bSeSLEOs/RBEDbhtaoozVt86G4zmnWdAG+s2mtspFN
         ftn1/T8m1l7RYE7kLXSJQAnxpD/5D3DEuxaMAWh6GIshDdvJYTPO8HkzfmGLR3tS07wq
         P1bqhr9rYqUkJOBxMmaaNBcDyAcW52dVEo0Jif9fW+X6Ab9Lx5m/6IHGWZ+eONPXJQU7
         i0a8V3DzhLIgORlYQuvFO8pvnl95/7knnCptQS1OfCz1TIx2w+3AYdK0qa9MsDZqes4K
         tHC9ZwQ90hiCNDrSRlJE6wLg1rrINcLbsB9kC6Z2zUEo/6+CYwli4Idz+xY3DEoBCDvm
         uOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gHOfO3UXl0K9k2z78DoJ00iPD7GRixkTFuQhmaFYXZM=;
        b=rYfp/8UhiAXt3trdjkxuQRXuw277N/JKpYPu7/Mkhad5fDKTNJVcliiTnc/o42CNHg
         hYeX2dLtumHxVG4zEnrpcXzstk4UzdAZSicH5AGuA/i2z1+LzOW0EuyBvy9LyUkT6rS7
         ZOCk9+k0TIZ6MiErKcpX8iYfH6PMMCLsRHcJ3D4dHqlYzFUXivIjRy1lLpA1k+OvBFia
         mkGno1xKTrPEjBfW4EZUNK+kmjwP51UDSJhjICQNMNNTaLxgHknU94CH6f4QyVT8ARXC
         xHP5TxrfhtwDxaRxJHETEQzliKqBkuarxc3fShOpNVHljI6M5fCUInkSBXYvuiwjuNiG
         qAmw==
X-Gm-Message-State: APjAAAUXDqeYvQGSZC9dDVeodGN0iLkk/BgIuXSOJO96j2z7Gw1cEfLR
        suviAdH9HMHvIN+ZyiyRTOjFXw==
X-Google-Smtp-Source: APXvYqwHMMkmRtQM8MHe+DNd8NK3+CM4hTWXqgdxD5E+q/1LBbfDHMzYtSOay7fJ7OE8He1QWuKfmw==
X-Received: by 2002:a63:a5b:: with SMTP id z27mr16720846pgk.416.1572651766706;
        Fri, 01 Nov 2019 16:42:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c19sm7948128pfn.44.2019.11.01.16.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 16:42:45 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net, haiyangz@microsoft.com, kys@microsoft.com,
        sashal@kernel.org
Cc:     netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next 0/2] netvsc: RSS related patches
Date:   Fri,  1 Nov 2019 16:42:36 -0700
Message-Id: <20191101234238.23921-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address a couple of issues related to recording RSS hash
value in skb. These were found by reviewing RSS support.

Stephen Hemminger (2):
  hv_netvsc: flag software created hash value
  hv_netvsc: record hardware hash in skb

 drivers/net/hyperv/hyperv_net.h   |  1 +
 drivers/net/hyperv/netvsc_drv.c   | 11 +++++++----
 drivers/net/hyperv/rndis_filter.c |  8 +++++++-
 3 files changed, 15 insertions(+), 5 deletions(-)

-- 
2.20.1

