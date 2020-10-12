Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C25D28B029
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgJLIWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgJLIVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1111C0613D0;
        Mon, 12 Oct 2020 01:21:47 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e22so22009148ejr.4;
        Mon, 12 Oct 2020 01:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1wOWozXJ4utk2al1FxKRLR9aiEc2n/7R7pCk8KlT/EY=;
        b=gdWvMc+ds5lggRfkD+SUMGUuH638xQkwAy+e8n5Mo7ZRSDYEPzaQtR9qfL++MOHP20
         va97/CqWm8hgjDrEzG2Hcg36FXA5MGYZqe4cXAP3EtfNmxLRRM+z4aZkd1av+qmz3vKJ
         Hdb/EbLySehHW9Lnwdok4qok7d36BK2J4cmWsgto/oGZRRT9W9X9mBYmgTLe+5XbAzAq
         PlIBELAmZtoMmLhS3/E59H5AU2F7w43TqXNZ1ZGiQAYY5AUfa0/GYYWjvEuf2lOfJgd2
         9NvJWF1sBhqoPd+8EIXuDQRt1to6QYk60Yc3HXpSawKyP0ZIINF96WNCqYC/SkbBjEer
         tiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wOWozXJ4utk2al1FxKRLR9aiEc2n/7R7pCk8KlT/EY=;
        b=nHyVRNssQM28Ay0haSKc5D7HODo+0qbFmIka6jIREo03QcBk3qgEnqa/amhMbwlHrq
         cZMYYYBcbmbugGkIj3WiZmxvBBBJuFU+ZxWGBOL9UvODAh90RKtr4VHaZBTbs+oBiORy
         EjEadmD1xef5Sro/vegRigB+7Y36dHt3CBM+19PFm/hM6EsA66FFfy7TZEeUBHr7KFl1
         49WkuYfWec4Ndld3T/y61DA7YlJoUrTZpzGQgkieQNmNoCQJl4IrJKz1zZADO536kKKM
         yHkzOrOwlWUg1ypfSUZMejc3NFwWEExngk0vn1FRbXG02BnwTk6mD1r0fURDw9r6GvI1
         j66A==
X-Gm-Message-State: AOAM533zayrkUCB1N/SCKm+6msjSDj0Dsk/ag0QY+jmQik8CIBth3b0a
        pIB7hZ7lCe+C/SVuWTxlE7Qe69k+PiU4lw==
X-Google-Smtp-Source: ABdhPJybN133vx8Ykqx0BlhQOoR1nEkI9d6/vMogtaA8z/z2ZiUyyQ5Qlyid6QSVeywYp3JCUY3mxA==
X-Received: by 2002:a17:906:a8b:: with SMTP id y11mr26283425ejf.302.1602490906538;
        Mon, 12 Oct 2020 01:21:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id lb11sm10190517ejb.27.2020.10.12.01.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:46 -0700 (PDT)
Subject: [PATCH net-next v2 04/12] net: usb: qmi_wwan: use new function
 dev_fetch_sw_netstats
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Message-ID: <2c97b75b-107e-0ab6-d9ef-9f38bb03f495@gmail.com>
Date:   Mon, 12 Oct 2020 10:06:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code by using new function dev_fetch_sw_netstats().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/qmi_wwan.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 5ca1356b8..a322f5187 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -126,31 +126,9 @@ static void qmimux_get_stats64(struct net_device *net,
 			       struct rtnl_link_stats64 *stats)
 {
 	struct qmimux_priv *priv = netdev_priv(net);
-	unsigned int start;
-	int cpu;
 
 	netdev_stats_to_stats64(stats, &net->stats);
-
-	for_each_possible_cpu(cpu) {
-		struct pcpu_sw_netstats *stats64;
-		u64 rx_packets, rx_bytes;
-		u64 tx_packets, tx_bytes;
-
-		stats64 = per_cpu_ptr(priv->stats64, cpu);
-
-		do {
-			start = u64_stats_fetch_begin_irq(&stats64->syncp);
-			rx_packets = stats64->rx_packets;
-			rx_bytes = stats64->rx_bytes;
-			tx_packets = stats64->tx_packets;
-			tx_bytes = stats64->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&stats64->syncp, start));
-
-		stats->rx_packets += rx_packets;
-		stats->rx_bytes += rx_bytes;
-		stats->tx_packets += tx_packets;
-		stats->tx_bytes += tx_bytes;
-	}
+	dev_fetch_sw_netstats(stats, priv->stats64);
 }
 
 static const struct net_device_ops qmimux_netdev_ops = {
-- 
2.28.0


