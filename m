Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794DF20CA11
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgF1TyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgF1Txz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:55 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C56C03E979;
        Sun, 28 Jun 2020 12:53:54 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n26so572172ejx.0;
        Sun, 28 Jun 2020 12:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pAX77xx+Fo5Ilh4w2wWJbjIyfYoFJR13zsAdUDWP5lI=;
        b=ORtQCAXV5rGZVxdgC4LM/JQWYZQO1MCmsUNk47ky+dXPGagcpzObCeCh75brKbehuI
         lbolaSqKjyD5y/ihh+aDqvxlvtL7bW4I4P398OMVjhibjTt6jOZbsQF+Zedu1G2wsx7d
         6B5iLyawKsB374VRbGMCrGWYNHBF3L8u5+8HA3J1MD3XC5+0OgSD8UBn5w4Gmacr1l38
         fpbaRQsC4oc6n/OsxI5GJ+N4i5fWT2NefU+pXHD5rzsCkJNfjX5SuwJ3ijdyHe1CaVd3
         uKSra5V9M7U4OR7oBZ0A1w0YYBIAH1xm8XoPVSwzwSjgAKk/EPTmIl8a8FeehQqBqcr3
         W3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pAX77xx+Fo5Ilh4w2wWJbjIyfYoFJR13zsAdUDWP5lI=;
        b=mdKnEgR2Xjf9jTLvi3/8bv2Azqyu9KNCghg3L+GIA3UZ6YNjfN6UGWHi9K5uN1XMST
         JQMPbBqvTv1BdL7gm7DHS00r5V9qSYsVtAkSpFQ1GE71MGbXJ9A9HFFJz+h63iqrw/9+
         Ybzp+vX72pn1sN3EBwN1gOYH9XGk7PLXoOVagGOJ6gUq9rsP3YdbqIBjeV8n9es/sYuV
         dcfwproJE8hQwW6ncKXzQsk1PCtyCZzaEP3h4bbzzidW/pnfjQBnVWcan64NSjbHr+yM
         TmHoRJ0fMttZHI1gb7W1VnKvrxaLDMFdMU5hXKG52AO1W7S2WJSvIW7E/qRsKrjH3CiC
         sV5w==
X-Gm-Message-State: AOAM5333ck7bMi7Kwj2zwihJa7QMr+Ip1D8GGxjmHikpqkREa57HVzTM
        JOT+UdMWAA6wmyBqjAqHRvQ=
X-Google-Smtp-Source: ABdhPJzyejn+pNiHCA+LRfTXQ+P4XlARbZ8cDgn8MJz3UieLgYh3RK84aVsGD4qWvoqYGtUhIv4pxQ==
X-Received: by 2002:a17:906:a242:: with SMTP id bi2mr6654719ejb.243.1593374033731;
        Sun, 28 Jun 2020 12:53:53 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:53 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 10/15] net: dwc-xlgmac: fix xlgmac_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:32 +0200
Message-Id: <20200628195337.75889-11-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 07046a2370b3..26aa7f32151f 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -697,7 +697,7 @@ static void xlgmac_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	schedule_work(&pdata->restart_work);
 }
 
-static int xlgmac_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t xlgmac_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 	struct xlgmac_pkt_info *tx_pkt_info;
-- 
2.27.0

