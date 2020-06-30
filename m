Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081FC20FB8C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbgF3SRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:17:19 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36953 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgF3SRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:17:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id g20so16886070edm.4;
        Tue, 30 Jun 2020 11:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y5Mt3w62B3XQY5/QbJq7kcGTRM0kicJutPXBswps/no=;
        b=LixeDIWeBO2lXyjxh7/Jrnlr6UUty9VwyYbRtnI1VgxGIelaNVVqk08FScFtmw4+PO
         v1iXrN26gf8mFnd8lE7aNSl++IFff5vq8S3hMAvAxKVI5h1alkcx/Hw0LPaYrOjBRMGO
         wqRUFZcpYCTud9ep/yyi8ZUUl73nGfNgkK0O6Y1QGMk3eI+t4kk/xqTPcJ0iYKTA9occ
         A+4xdJbEwxL4AGlHeQAPH86Y9VjpoDUC+UUNXxwj8DS7EUPY+ctjS4spxRHfTeUTuBbz
         nc4y1Hhj09Ovl0/zTZ450hWKcE9vxT5pfKrQ4vyhzfXYqK1mWM8wkJ7v2itQIs+HR/Me
         Bt7Q==
X-Gm-Message-State: AOAM532YAkER3VLqlLnu82LQp9woWQfmiqlT/NBf2XK/msqMQ1Dlj7kj
        V7NJizv3oVKndFxumwpxLY6mLVvF9pB8wA==
X-Google-Smtp-Source: ABdhPJygbteH4H2nIDkfpYZxCZ8uRZYxp+ahdHSeCt3jc1NsBgprYHwwComNsOJMHASjwjgb5C2K7w==
X-Received: by 2002:a17:906:7283:: with SMTP id b3mr20095438ejl.163.1593540577182;
        Tue, 30 Jun 2020 11:09:37 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id d13sm2492313ejj.95.2020.06.30.11.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:09:36 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 0/4] mvpp2: XDP support
Date:   Tue, 30 Jun 2020 20:09:26 +0200
Message-Id: <20200630180930.87506-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Add XDP support to mvpp2. This series converts the driver to the
page_pool API for RX buffer management, and adds native XDP support.

These are the performance numbers, as measured by Sven:

SKB fwd page pool:
Rx bps     390.38 Mbps
Rx pps     762.46 Kpps

XDP fwd:
Rx bps     1.39 Gbps
Rx pps     2.72 Mpps

XDP Drop:
eth0: 12.9 Mpps
eth1: 4.1 Mpps

Matteo Croce (4):
  mvpp2: refactor BM pool init percpu code
  mvpp2: use page_pool allocator
  mvpp2: add basic XDP support
  mvpp2: XDP TX support

 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  49 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 600 ++++++++++++++++--
 3 files changed, 588 insertions(+), 62 deletions(-)

-- 
2.26.2

