Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D6837949B
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhEJQyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:54:07 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:45619 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhEJQyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 12:54:06 -0400
Received: by mail-ej1-f52.google.com with SMTP id u3so25515170eja.12;
        Mon, 10 May 2021 09:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s3fZm1oKAFiR2LH1z5a0f75rqEbK9aM0B+6RlH1/noo=;
        b=kE5ym1r34tdwUpevhsO4D4/fHHUhVWahJ9LvYjVbnp5orBqZYjNnc8FeHdcnscA9BO
         7OM3S+F9z5QD7TeczVNGHS1DfOCVRHYOouc4InJPfH5BuAi7lFZnMEkxNJWc237WxyGS
         kd4Yle9PNIq7uX1VdAYahzFa4V+Z61Lgd+SvUjAFTH0nKhea2re+Lg7QLe1OEBPXoFC7
         YzXyQM/gleHY1NXZabr44sMJOhugyTaFu1AKjq3Pj2FYal0+cyvhpwBwBbj9W+CDr9qI
         3IBMWqVu4exVgO+DlKN8Gahg7pX75gK3re6VjTiuxfJTmhHGtbkC/p7xllOGzlyeFycR
         oy8w==
X-Gm-Message-State: AOAM533OJmqglcZLt+rYWw+ma9mjT3lfO9AC2b4Ubfgf49kBR5tyGFz3
        pUoadId0SUPa9Rg25M+PPXo=
X-Google-Smtp-Source: ABdhPJyFDRgwHiibixIYtfSxw9/B7rRVTJoY/3VDNQF9DMokSCab3HP8tY3sfVZirfIG5IXzvp+wdQ==
X-Received: by 2002:a17:906:a48:: with SMTP id x8mr26577632ejf.127.1620665580594;
        Mon, 10 May 2021 09:53:00 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id t7sm11930469eds.26.2021.05.10.09.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:53:00 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] mvpp2: remove unused parameter
Date:   Mon, 10 May 2021 18:52:31 +0200
Message-Id: <20210510165232.16609-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510165232.16609-1-mcroce@linux.microsoft.com>
References: <20210510165232.16609-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

mvpp2_run_xdp() has an unused parameter rxq, remove it.

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ec706d614cac..28b8d9b3cbe6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3784,9 +3784,9 @@ mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
 }
 
 static int
-mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
-	      struct bpf_prog *prog, struct xdp_buff *xdp,
-	      struct page_pool *pp, struct mvpp2_pcpu_stats *stats)
+mvpp2_run_xdp(struct mvpp2_port *port, struct bpf_prog *prog,
+	      struct xdp_buff *xdp, struct page_pool *pp,
+	      struct mvpp2_pcpu_stats *stats)
 {
 	unsigned int len, sync, err;
 	struct page *page;
@@ -3925,7 +3925,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
 					 rx_bytes, false);
 
-			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
+			ret = mvpp2_run_xdp(port, xdp_prog, &xdp, pp, &ps);
 
 			if (ret) {
 				xdp_ret |= ret;
-- 
2.31.1

