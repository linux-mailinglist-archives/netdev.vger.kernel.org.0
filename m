Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BE62198D9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgGIGtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:49:12 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:46492 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbgGIGtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 02:49:11 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-05 (Coremail) with SMTP id zQCowABXOerZvQZfBBlVBA--.46028S2;
        Thu, 09 Jul 2020 14:48:57 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     colyli@suse.de, claudiu.manoil@nxp.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] net: enetc: use eth_broadcast_addr() to assign broadcast
Date:   Thu,  9 Jul 2020 06:48:55 +0000
Message-Id: <20200709064855.14183-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowABXOerZvQZfBBlVBA--.46028S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW5uFyxCr1xAFWUtr45GFg_yoWfZwc_uF
        47XFy8Ja1qqasakw48Gws5Zr9Yk3WkXw1rZF4xtFW3Kas3Ar15Aw4kZFn3CwnxWr4rJF9r
        twnFqa43C3y5tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJV
        W0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        AwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfDGOUUU
        UU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAMMA102YRKnzwAAs0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to use eth_broadcast_addr() to assign broadcast address
insetad of memset().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fd3df19eaa32..6fc0c275306f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -487,7 +487,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	cbd.addr[0] = lower_32_bits(dma);
 	cbd.addr[1] = upper_32_bits(dma);
-	memset(si_data->dmac, 0xff, ETH_ALEN);
+	eth_broadcast_addr(si_data->dmac);
 	si_data->vid_vidm_tg =
 		cpu_to_le16(ENETC_CBDR_SID_VID_MASK
 			    + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
-- 
2.17.1

