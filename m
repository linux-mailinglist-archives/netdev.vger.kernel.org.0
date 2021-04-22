Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE357367847
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhDVEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhDVEKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B334C06174A;
        Wed, 21 Apr 2021 21:09:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f6-20020a17090a6546b029015088cf4a1eso240191pjs.2;
        Wed, 21 Apr 2021 21:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HlVoF4WBd28mr16LsVXI69/qoWczDKwnY5ulmKa3JqU=;
        b=KCCRAcZRH2q9WePwudcJa7IRn0oj+Hd4SYQlaLwHq3erd6z/UEgaXA0VjZeMEqrIb+
         Q8X+3nvCXsOfPr8nkzGciE8Qer9C3ZMOgUtKoqsebyt8sVkU+sCble0rLFQs7N4yi4uB
         3/VeMjw44NhnRdpvm0GZ/15WBaCM4nf97qah/8NLY+JDxPvVxFma5tF2CQNpPXLCc2Lk
         FNY3+3OziJcva+chnYgwMTneBff5PLp257aFpmSb/HEDus3rUrw8XZ+UASTZcppghyVa
         +97lDFhnWmWG9icoVNkz6om+a07b07Ai1W4qQX0M4NuJd+o07N/spwuzwN+9qdSoae3e
         qtzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HlVoF4WBd28mr16LsVXI69/qoWczDKwnY5ulmKa3JqU=;
        b=AirwF58CrBdSCfuqzKSbGrp+KDPflh1DUqB3KuC/oWGO6XmPcp1JP7uoWZBSP/VxRU
         yM4vQgXz4rUvlU+jk+N3Klf1VLghuEZP+p17aRMBrDf2DiK6BQWWB/222E950+nbyZg3
         DCtfR0Y1cUc5JwSMcTmLFr9+zXl4lBGn4l9+Sjs6y+9/mQLUiMPi9kDydm6bfKMqNIM1
         aKxyKDBGVhbd7iXOtvLJwu9mur/L2WxzuRl7BadgdXFdaNzChqddaAtxQjQa8yPsi7jr
         u1yKxJqsDc+eJFI25neETYNRAXfMlZqXPLS3Xxjq7+hl6j3FOxyRP9z12W/t/5Yhwj2B
         RUJA==
X-Gm-Message-State: AOAM533JNGFB8sbL2Hhtgo83j0Aud6rlkmnkQQ4esQ7AqRyPlfM9498L
        TvrglHxqPRadLEFYyc+sIWg=
X-Google-Smtp-Source: ABdhPJwm/HPuAW+zUXQgRnrXd/od7i7maE9NkKmpXPunzRtlbKEr3GPxchy0RmpvN8P7icTmsyIBTA==
X-Received: by 2002:a17:902:7788:b029:e9:11:5334 with SMTP id o8-20020a1709027788b02900e900115334mr1405530pll.70.1619064580121;
        Wed, 21 Apr 2021 21:09:40 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:39 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 03/14] net: ethernet: mtk_eth_soc: fix build_skb cleanup
Date:   Wed, 21 Apr 2021 21:09:03 -0700
Message-Id: <20210422040914.47788-4-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case build_skb fails, call skb_free_frag on the correct pointer. Also
update the DMA structures with the new mapping before exiting, because
the mapping was successful

Suggested-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 540003f3fcb8..07daa5de8bec 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1304,9 +1304,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		/* receive data */
 		skb = build_skb(data, ring->frag_size);
 		if (unlikely(!skb)) {
-			skb_free_frag(new_data);
+			skb_free_frag(data);
 			netdev->stats.rx_dropped++;
-			goto release_desc;
+			goto skip_rx;
 		}
 		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 
@@ -1326,6 +1326,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb_record_rx_queue(skb, 0);
 		napi_gro_receive(napi, skb);
 
+skip_rx:
 		ring->data[idx] = new_data;
 		rxd->rxd1 = (unsigned int)dma_addr;
 
-- 
2.31.1

