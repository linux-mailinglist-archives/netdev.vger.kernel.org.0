Return-Path: <netdev+bounces-8750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E4D725840
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D11B1C20CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C5E8821;
	Wed,  7 Jun 2023 08:45:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D679B6AB9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:45:48 +0000 (UTC)
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D9A1720
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:45:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-256932cea7aso3337324a91.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 01:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686127546; x=1688719546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mIWRFSnC2eAaW8lojBV2BpZA5a1AJ0QwwK24xxO4CWE=;
        b=OqcF2SlU8z5N/tkrYrdyFqZHNudtCzcvyqYlxtK5++D1jtUxHPMmt1zwD0fURbfaym
         a2Eza8iIS2MTMF7/iIp4g+qqwTmp/zaHEL5n8ZaXaCQvd0eVWxq3jbqIBPpOJ7F9cIHf
         PLTs9Q29vNDT5Uuo/zgvSlSphYQXCCqP4GUndH2KAZNqqWkm+AD/3BmmOWhNiSPudUOg
         HLNCsCxsKG407nBRBt4svNuHbwVG6UlZ1QltD/fEk5J+pPFK1LRt7SGn6ZERyx3pqmXw
         /hxh4Rh77vqo6PYhe7l4bgUqb1IusVoV60DaHMcaHeloo/GpFnr7Fnk7p6JAzH5Uj7X9
         5+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686127546; x=1688719546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mIWRFSnC2eAaW8lojBV2BpZA5a1AJ0QwwK24xxO4CWE=;
        b=OR6T23hhauOq7UoSs05II8iI1/Q8TfToLwBQoYbLQ7Ee4qL+f0EOlwXeWVbDeVUn9p
         oBDx1mPUQ7AIbd76XuLvBreMQVA322NBjoGsaqfhERYAA9Sq8AQ+P1bO13AR7wa5M54s
         ooKSrxmVA0NuZqqReLhYuq+W3/C7rp9I1xZbwdzlQ/Y6+z7FUIy7UhS9Rap9p4p1OF/N
         AmqiCiR9aThoxe8mirEZ+u+zd5PHkadQHHgHBnWya+igLVCiyC4wFOwYlE+xR+GZYOI/
         8ScXDonBtXRqYrb4PDlVqBkiRQQo9+4vLPg0B/qJKtqg6vvHjb/y0xBj3GX+YqPb1D+L
         +k7g==
X-Gm-Message-State: AC+VfDxVnvJ230m/a1ewEstjzs79v5BelFx1u3jicPGxxJRt7+LzfzgD
	foBKr3HBK2d7nGGXaVcPdeQ7ywW9jy84og==
X-Google-Smtp-Source: ACHHUZ5x2NIt8BL8iHBIG/H6xQTElWp1x4DzTFt9gWgn8lENKj+cCWyOSBxoerduF4Gc0LJ2gfxGmw==
X-Received: by 2002:a17:90a:1b61:b0:24c:df8:8efa with SMTP id q88-20020a17090a1b6100b0024c0df88efamr2554261pjq.39.1686127546005;
        Wed, 07 Jun 2023 01:45:46 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id qa2-20020a17090b4fc200b002310ed024adsm873903pjb.12.2023.06.07.01.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 01:45:44 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsa@cumulusnetworks.com>,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Mahesh Bandewar <maheshb@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipvlan: fix bound dev checking for IPv6 l3s mode
Date: Wed,  7 Jun 2023 16:45:30 +0800
Message-Id: <20230607084530.2739069-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The commit 59a0b022aa24 ("ipvlan: Make skb->skb_iif track skb->dev for l3s
mode") fixed ipvlan bonded dev checking by updating skb skb_iif. This fix
works for IPv4, as in raw_v4_input() the dif is from inet_iif(skb), which
is skb->skb_iif when there is no route.

But for IPv6, the fix is not enough, because in ipv6_raw_deliver() ->
raw_v6_match(), the dif is inet6_iif(skb), which is returns IP6CB(skb)->iif
instead of skb->skb_iif if it's not a l3_slave. To fix the IPv6 part
issue. Let's set IP6SKB_L3SLAVE flag for ipvlan l3s input packets.

Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2196710
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
I'm not 100% sure if we can use IP6SKB_L3SLAVE flag for ipvlan. But since
the l3s mode is a part of l3mdev enhancements. I assume it should be OK.

BTW, the fixes tag also looks not fit enough. The ipvlan_nf_input() is already
there in commit c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from
other modes"). I think we should use 4fbae7d83c98 ("ipvlan: Introduce l3s
mode"). But I would keep using c675e06a98a4 as a consistence of the IPv4
version fix if no object.
---
 drivers/net/ipvlan/ipvlan_l3s.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 71712ea25403..df675d9d2f21 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -100,6 +100,11 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 	if (!addr)
 		goto out;
 
+#if IS_ENABLED(CONFIG_IPV6)
+	if (addr->atype == IPVL_IPV6)
+		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
+#endif
+
 	skb->dev = addr->master->dev;
 	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
-- 
2.38.1


