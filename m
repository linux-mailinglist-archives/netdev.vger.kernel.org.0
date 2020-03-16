Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E1618611C
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 02:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgCPBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 21:04:25 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:58404 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729315AbgCPBEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 21:04:25 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 15 Mar 2020 18:04:24 -0700
Received: from akronite-sh-dev01.ap.qualcomm.com ([10.231.215.213])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 15 Mar 2020 18:04:21 -0700
Received: by akronite-sh-dev01.ap.qualcomm.com (Postfix, from userid 206661)
        id E81E61FD9C; Mon, 16 Mar 2020 09:04:19 +0800 (CST)
From:   xiaofeis <xiaofeis@codeaurora.org>
To:     davem@davemloft.net
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org,
        xiaofeis <xiaofeis@codeaurora.org>
Subject: [PATCH] net: dsa: input correct header length for skb_cow_head()
Date:   Mon, 16 Mar 2020 09:04:05 +0800
Message-Id: <1584320645-25041-1-git-send-email-xiaofeis@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to ensure there is enough headroom to push QCA header,
so input the QCA header length instead of 0.

Signed-off-by: xiaofeis <xiaofeis@codeaurora.org>
---
 net/dsa/tag_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c958852..72c1629 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -36,7 +36,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
-	if (skb_cow_head(skb, 0) < 0)
+	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
 		return NULL;
 
 	skb_push(skb, QCA_HDR_LEN);
-- 
2.7.4

