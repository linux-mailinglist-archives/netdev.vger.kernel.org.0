Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C7B29350A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 08:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404329AbgJTGe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 02:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730776AbgJTGe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 02:34:28 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B27C061755;
        Mon, 19 Oct 2020 23:34:27 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so608519pfb.4;
        Mon, 19 Oct 2020 23:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88n0uu/xuS20DKfdAem15q9rKph9xB77+Uoiqz9GArQ=;
        b=RSblhhQ9DLB+Nd3my50b/lKvgi5pp4/l16rpC060pEtzVCDVCK/kQgMGxcuemqqoLQ
         uDMEVs3e1e+5bTFoGphjr16gdHwccbhNDQ8/ogxx7fwQl5aZzlixiEsQ/9W8B5Po9ij/
         WV6W+S5p+KuP9pFOAbNgpLifCXFSOZQg+1jKUGYgkilzEnY0ppLrFTqqMXqvderoOzTT
         /VXkXvaCZbT2jlDogYgjeSPosrrvetDVcJ48B/1oPniCVrJJXqOPDo2xlXj7TnBJf3XZ
         0Y1kylKfcTS5sljLLQh75vRNL2n/+9qQh2d/oQPJu6LaKplO1kN8oWHg9Vt6k5RSvMaQ
         wRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=88n0uu/xuS20DKfdAem15q9rKph9xB77+Uoiqz9GArQ=;
        b=Dmuerc/fiRUiPR03AfY/uCFPY1wAfC/0QakPMKoc8BHv7q2ZfMPrkHHNn82zv/bq9I
         2HR4JggTwWTBdmHmJcqGMN0a9IvOq6SbQDu8j93L9Xx6Foo2wBxrySfFSzv0HBSZf7Um
         OFuFvu3SgcwI2nixggYHoUTO2AxbRlpz5TcdefsUiGvh/pio6M2iTWo2vwSzlJD5V1+z
         XTPWv9kyiW3Bajt4YoGSKpALnRjPBf5CDnVG0tiwUpL/FUiYIhd6cMsvRiro8EAzUeHK
         cUfJTX+RbGie4+9RkRjSQBLPj/UZigzqvvoMeQSNt+xeOSoNwetmLoljUigM7a8ImTeo
         V94A==
X-Gm-Message-State: AOAM531E5eknn7nY20pVnv9rAgJ8bC9ih9HzeXddeNoKPumclJxwr6tq
        0SqqL7gmbqHPOSenlJPRsqh8y0WjqII=
X-Google-Smtp-Source: ABdhPJwCBUpOn5ELeqqcSyeRUEzrSxyoot7K8BwTlJMp3G6jWmU7XKnHLdcRCMW5kLp5OqHfg32vpw==
X-Received: by 2002:a62:144d:0:b029:157:7e01:94a5 with SMTP id 74-20020a62144d0000b02901577e0194a5mr1446261pfu.56.1603175666695;
        Mon, 19 Oct 2020 23:34:26 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6caa:ebf2:3bbb:f04e])
        by smtp.gmail.com with ESMTPSA id ha24sm776992pjb.27.2020.10.19.23.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:34:26 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag after calling ether_setup
Date:   Mon, 19 Oct 2020 23:34:20 -0700
Message-Id: <20201020063420.187497-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver calls ether_setup to set up the network device.
The ether_setup function would add the IFF_TX_SKB_SHARING flag to the
device. This flag indicates that it is safe to transmit shared skbs to
the device.

However, this is not true. This driver may pad the frame (in eth_tx)
before transmission, so the skb may be modified.

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_raw_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/hdlc_raw_eth.c b/drivers/net/wan/hdlc_raw_eth.c
index 08e0a46501de..c70a518b8b47 100644
--- a/drivers/net/wan/hdlc_raw_eth.c
+++ b/drivers/net/wan/hdlc_raw_eth.c
@@ -99,6 +99,7 @@ static int raw_eth_ioctl(struct net_device *dev, struct ifreq *ifr)
 		old_qlen = dev->tx_queue_len;
 		ether_setup(dev);
 		dev->tx_queue_len = old_qlen;
+		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 		eth_hw_addr_random(dev);
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);
-- 
2.25.1

