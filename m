Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03C62B1838
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKMJ1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMJ1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:27:34 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BA4C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 01:27:34 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t11so9848650edj.13
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 01:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=9fNbzgPON6KHDunvl15bGkh4oFDVo6Bko7uyvRmoQSc=;
        b=AYiLwogs8kf6Iwr8kXyup8n3ucLyqf1J2I3xU3xc+I5CSgUysu1s/jeDdmUEr9DAmk
         CGnoQAqio8NBSo4ZtYkb62zdsQ8imzawCp11YjTXfAdQiEHmrB9hhsp4dV4X1u16RfHn
         emtHSFbzOuCcrzJ0+MQuPay3vV9HbA7nO5vsYfy2wNqfnTs/mlBvCY68Ea4YWT5+XaZi
         Y9ZbaVys/KtZjrzZ5lhvD2ZTGNF6gtQxP+BZKAxfAwZDkHRuvg5hB+bdnnnCgR35f7RE
         52eL7nOAhsb3KqchDukHYbVutdzmcHne5l/qFg0GRmo6PiAPBRfbUbr2vFoIISwA8t9O
         kG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=9fNbzgPON6KHDunvl15bGkh4oFDVo6Bko7uyvRmoQSc=;
        b=pUYKKrt1pCj1mmTUW4yp8aWSZF6BT593xLnFnpj0kdJNOwPvYWQwBG69cxoKD8OKrl
         e7AiP4PcdbERRMQ3AFqvTQDXDmUgSULAhcekTejLB3UY4CvkujZlU6F1my7JRRmI3zg8
         MkShCDHQ4NdTkX5U7wJTiwY/oHCL0h359L8rB2jwpk4pnSMAlgDFZKmwza/8m6dkgf2z
         YT+EYZyhx5zKAQY0bmUBIlC4nJ2MkwkM1h4i3ocVcmAYF+FUONUjusAvKrTt2hTLlTAx
         OzolDhdkH6CELK19HIklQvFDjJ9Ar+F0nm7Xce3HRNkFohshJR5rgf5+4WsGBYQ25GBn
         BLxA==
X-Gm-Message-State: AOAM530+41Oeo+/OtpqQeQiEPz+WFGw9HTg5wR6w2dPh9+25cflkmYKI
        DCJOQK++T5p+sdwCswammNEpP12lHRY5SA==
X-Google-Smtp-Source: ABdhPJxEFT/2KJjDV/37dfW14P06RBqhHPqm/0ARcnY+bXbdasWJRu8uJuCrel0yfmNux+ayNESU9A==
X-Received: by 2002:a50:c19a:: with SMTP id m26mr1480464edf.302.1605259653116;
        Fri, 13 Nov 2020 01:27:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:e113:5d8d:7b96:ca98? (p200300ea8f232800e1135d8d7b96ca98.dip0.t-ipconnect.de. [2003:ea:8f23:2800:e113:5d8d:7b96:ca98])
        by smtp.googlemail.com with ESMTPSA id jw7sm3176430ejb.54.2020.11.13.01.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 01:27:32 -0800 (PST)
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: bridge: add missing counters to ndo_get_stats64
 callback
Message-ID: <58ea9963-77ad-a7cf-8dfd-fc95ab95f606@gmail.com>
Date:   Fri, 13 Nov 2020 10:27:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In br_forward.c and br_input.c fields dev->stats.tx_dropped and
dev->stats.multicast are populated, but they are ignored in
ndo_get_stats64.

Fixes: 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Patch will not apply cleanly on kernel versions that don't have
dev_fetch_sw_netstats() yet.
---
 net/bridge/br_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 387403931..77bcc8487 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -207,6 +207,7 @@ static void br_get_stats64(struct net_device *dev,
 {
 	struct net_bridge *br = netdev_priv(dev);
 
+	netdev_stats_to_stats64(stats, &dev->stats);
 	dev_fetch_sw_netstats(stats, br->stats);
 }
 
-- 
2.29.2

