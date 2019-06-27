Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1D258C73
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfF0VG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:06:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52183 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:06:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so7036701wma.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zz38ALVL9lz1ilY6dw3RiNCsTbczRg69rQPB0MY45J8=;
        b=tb3fFy/sKB9JhO7KyEYMcAGoXmARi5xzmkoVc/3XMlZ5O9aYVHm2SE/zjh9dqDzqEW
         Fkiq4ymCWkKun2bYsTAyVns/SDRtWSdFk06LAeJw3kpTNsNJ+ZQSaAWSYSz+mz+lE+4d
         hVUkgwJBoc1WUSbB0sLX53Nb+8PqMWzUqnYz9Xd5qyMQPvAqZKciQqqejnK5A4LTTH2J
         O7rTSAm5pc1y/ODZlSe/IMgnnIitUixU9CTHz3jjzLMR/0IHhBt9TIql+MNY3J53+foH
         hT8e4Qo2LudV+GNbntCVWQAEX0QWURJwVI3ic4aBcUzwLIcEtyFoBCiNcZYGuvmBGeOS
         6KGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zz38ALVL9lz1ilY6dw3RiNCsTbczRg69rQPB0MY45J8=;
        b=XruTO2LwJwwaZvPvKQqGjFjIDssAKPLNBf+0xnucGDQuZKY+yTzw4VusKCP6DHXaDU
         9/flyyGvHlVNLeFCWslbL+zv2eqO4r6QWXR6n/SePJ2/LhWcYll+yhYG1/Yan4nHQbHo
         W2mzjvEzRoJ1ZLR6aPyAOfcp7E3zrCUutzyHU1zoDNGm/EYcONObrVxSbUYuUhvVEWtp
         4B5WnKpxCFAWA6UsIZG2JvVGaG3sPQ0l9Q9fcj7gIqJoSGM0ov6VqVuFNKXLkfAkIe5n
         7A2u1zxCbBUad7518KwsCoTVs6vWG/KCGljw/ml0fv9Xghoixs0uW13PEs9NS49qFWDX
         TClg==
X-Gm-Message-State: APjAAAWEtcZJnxW00HAQEkMfX2/20IcFDas8/vodsLbgHgDq6pP86bKg
        mhfc/siYxVGJjaD/R/KRQ4tmiujf
X-Google-Smtp-Source: APXvYqy7dq3uf25E8t3eQarQitgVwycvsomjB368qF4drrbgFUkYtQMNOdKlZpuPitOXKKDCwROBhA==
X-Received: by 2002:a7b:c7c2:: with SMTP id z2mr4147327wmk.147.1561669613136;
        Thu, 27 Jun 2019 14:06:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:3d9e:1690:cd42:495c? (p200300EA8BF3BD003D9E1690CD42495C.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:3d9e:1690:cd42:495c])
        by smtp.googlemail.com with ESMTPSA id 35sm306769wrj.87.2019.06.27.14.06.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:06:52 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve handling VLAN tag
Message-ID: <29fd564b-3279-a36d-a082-1c650168567e@gmail.com>
Date:   Thu, 27 Jun 2019 23:06:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN tag is stored in the descriptor in network byte order.
Using swab16 works on little endian host systems only. Better play safe
and use ntohs or htons respectively.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 48b8a90f7..b4df66bef 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1528,7 +1528,7 @@ static int rtl8169_set_features(struct net_device *dev,
 static inline u32 rtl8169_tx_vlan_tag(struct sk_buff *skb)
 {
 	return (skb_vlan_tag_present(skb)) ?
-		TxVlanTag | swab16(skb_vlan_tag_get(skb)) : 0x00;
+		TxVlanTag | htons(skb_vlan_tag_get(skb)) : 0x00;
 }
 
 static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
@@ -1536,7 +1536,8 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 	u32 opts2 = le32_to_cpu(desc->opts2);
 
 	if (opts2 & RxVlanTag)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), swab16(opts2 & 0xffff));
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				       ntohs(opts2 & 0xffff));
 }
 
 static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
-- 
2.22.0

