Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3EBB13D250
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 03:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAPCwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 21:52:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45301 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgAPCwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 21:52:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so17587888wrj.12;
        Wed, 15 Jan 2020 18:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=OSH3RXS+T/dhyzgURBl5qLmzt92xc5WKMppdhPS4Q94=;
        b=b7DLcl+owfs2QAWAXm37WDQOAc3UWBvxyGPoWQXhPpdrAHFFiKwgcbb3f3lKGMxA0p
         IvHrQSh/P6XXw3LzQdM2iGIDmKXC0uQXPndJ6Siuquqzrh5n+XQnTdDGde/YoKpKi613
         +iAc9QYrFIzxsp/qYoFCtavZJVXr+EWMNfkKP7Q5MhaZyUwzM6OawLb/UITInPhs4Q6S
         tYwuaQGNUpgmzC8RUHe+nqGht1WyDhz8zI2O8Hl+JOO/lOs5li7PgBiHC3I7olyJx3ZZ
         5CP4694GhMD+S2HFhavMB772xOPsI3ah8vomj1yTeCa04bzHlB2n55FU/8N6EC/dhfDm
         2ZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OSH3RXS+T/dhyzgURBl5qLmzt92xc5WKMppdhPS4Q94=;
        b=HKfgekQrmNK5DLEm1hzv6rvp2zuEvjiUHni9zTO9Cc/LJVJwUJTf8wqXp4JyAmUhtk
         NJRlARmkXD7ZMD80IIMVH17f0rr05wYZC8G5qJIDLAl4HcwDTamuUOUQLrG6eF299vbI
         WTDTgcrh4uFFTEqsO89iunpWkwjLmM67W6hoFnCuACHNF3usbw+K22FcF0DdgM+DPOZ9
         OUvy8pRJ4rnV/cOLGgllzfr93+EmDI+RHBLvXq2B2xIH60qfYHGLwhtT58m+OflzTSIb
         JmRZ5KPIZ5R1w1W/hk8qnP5RMfOXhWhfOnyG9wxSD/jcr+1HX2+EyaLNg67xT9d6y2sP
         UNFQ==
X-Gm-Message-State: APjAAAVepJvwvIjFSOJVASrH+JDwRXrJAmcg/DRnhB+4LwdFE8DdVkLX
        2BBLIpt6rEO452ptNpta0SWCKwRt1KTGyQ==
X-Google-Smtp-Source: APXvYqzv7Wq4m+86b5KLd7Lah3v8Ydg7yCJoK2FsSQh+zsfTvwsrhNI8pPLsTMshap6KP6z1eyWqKg==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr464986wrx.253.1579143135637;
        Wed, 15 Jan 2020 18:52:15 -0800 (PST)
Received: from hunterzg-yangtiant6900c-00 ([95.179.219.143])
        by smtp.gmail.com with ESMTPSA id u24sm2417624wml.10.2020.01.15.18.52.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 18:52:15 -0800 (PST)
Date:   Thu, 16 Jan 2020 10:52:04 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     davem@davemloft.net, tglx@linutronix.de, alexios.zavras@intel.com,
        allison@lohutok.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: nfc: Removing unnecessaey code in nci_open_device()
Message-ID: <20200116025204.GA20032@hunterzg-yangtiant6900c-00>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nci_open_device(), since we already call clear_bit(), so set ndev->flags
to 0 is not needed.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 7cd5248..25dae74 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -522,7 +522,6 @@ static int nci_open_device(struct nci_dev *ndev)
 		skb_queue_purge(&ndev->tx_q);
 
 		ndev->ops->close(ndev);
-		ndev->flags = 0;
 	}
 
 done:
