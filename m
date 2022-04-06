Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E934F663D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiDFQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238047AbiDFQyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:54:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CA2E2B4B09
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649254739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=RIwmvGgMvQX5dtOcxi5oALmKl5+0kyNpDrB+KHZbEBA=;
        b=UvScVGr/Lypyi35E7CmCFRKswkAJHbW2ktMbJlG7LySoBdUAb0jpoun8RDavg5VikB47Eu
        L4QDntavEj2+/4VnGBczpxE+kA62cWu8m9By9J5VsgsqA7z0wuD/OdHx+SBkjbuGsy6zcm
        zZZOZAHJnYhsr7HIsPLmjddCQ5518ws=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-IvmNkGLIMvClNiSsxY108g-1; Wed, 06 Apr 2022 10:18:58 -0400
X-MC-Unique: IvmNkGLIMvClNiSsxY108g-1
Received: by mail-wr1-f72.google.com with SMTP id x17-20020adfbb51000000b002060ff71a3bso554052wrg.22
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 07:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RIwmvGgMvQX5dtOcxi5oALmKl5+0kyNpDrB+KHZbEBA=;
        b=b2CgfUqMZ1wX54ogLBFuM+F+mcZoWtV+HvAZvD2XjURF4y1euvc/Ue/k1Qyx1xQDIt
         JS/lDefH0zTlAlybHJkk3GKiMTS5YQuBd80uiOaFq39pWqQIBDckCIQf9O1+4EkBwWsI
         H9q9efUe6SD51Wro2ne1P2Hq8BhZ2dRNBx6wFm2l0c5W+f/FOUnIEVkAnl1hBpjr+Poe
         qLz9kzxCQF/gcT/TqcCjjBWHGFykgm2vIYnJ7n70Ge5djuglyXOBZ0Mg1UFEDYRbBqEi
         zXplgIXV0qrrThrr6vWFQcQOpULbrvffPyRZzNQ5wgkXw2oPYAAv4xGMWfW0UZr02lIA
         tTmA==
X-Gm-Message-State: AOAM531ExvfAmxJ91KNXWh2wGp/o827xEML6jU3hare8ofHk4Bxhpq05
        KWRLro29lZzxJMIlDmiYSlnPRfkm4wq3lZdRnsL7PTgBocPy4S8CSu6FGSZN/8sjDHUV3ekA2Ls
        ypIhlpe7X719W4iSk
X-Received: by 2002:adf:916d:0:b0:206:db9:7ce9 with SMTP id j100-20020adf916d000000b002060db97ce9mr6819229wrj.556.1649254737140;
        Wed, 06 Apr 2022 07:18:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwM4xkUyjzY0C3z7za+J45Fo9fvhQOkPfwHS1nIrjyHIdcO/4ySAgyv+oJ0rLk2OFCNSVm9XQ==
X-Received: by 2002:adf:916d:0:b0:206:db9:7ce9 with SMTP id j100-20020adf916d000000b002060db97ce9mr6819194wrj.556.1649254736556;
        Wed, 06 Apr 2022 07:18:56 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id i19-20020a05600c355300b0038e1d69af52sm5393235wmq.7.2022.04.06.07.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 07:18:56 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:18:54 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: [PATCH net] veth: Ensure eth header is in skb's linear part
Message-ID: <b09b089827f128f65e9974c1dccdbbd06591f59a.1649254421.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After feeding a decapsulated packet to a veth device with act_mirred,
skb_headlen() may be 0. But veth_xmit() calls __dev_forward_skb(),
which expects at least ETH_HLEN byte of linear data (as
__dev_forward_skb2() calls eth_type_trans(), which pulls ETH_HLEN bytes
unconditionally).

Use pskb_may_pull() to ensure veth_xmit() respects this constraint.

kernel BUG at include/linux/skbuff.h:2328!
RIP: 0010:eth_type_trans+0xcf/0x140
Call Trace:
 <IRQ>
 __dev_forward_skb2+0xe3/0x160
 veth_xmit+0x6e/0x250 [veth]
 dev_hard_start_xmit+0xc7/0x200
 __dev_queue_xmit+0x47f/0x520
 ? skb_ensure_writable+0x85/0xa0
 ? skb_mpls_pop+0x98/0x1c0
 tcf_mirred_act+0x442/0x47e [act_mirred]
 tcf_action_exec+0x86/0x140
 fl_classify+0x1d8/0x1e0 [cls_flower]
 ? dma_pte_clear_level+0x129/0x1a0
 ? dma_pte_clear_level+0x129/0x1a0
 ? prb_fill_curr_block+0x2f/0xc0
 ? skb_copy_bits+0x11a/0x220
 __tcf_classify+0x58/0x110
 tcf_classify_ingress+0x6b/0x140
 __netif_receive_skb_core.constprop.0+0x47d/0xfd0
 ? __iommu_dma_unmap_swiotlb+0x44/0x90
 __netif_receive_skb_one_core+0x3d/0xa0
 netif_receive_skb+0x116/0x170
 be_process_rx+0x22f/0x330 [be2net]
 be_poll+0x13c/0x370 [be2net]
 __napi_poll+0x2a/0x170
 net_rx_action+0x22f/0x2f0
 __do_softirq+0xca/0x2a8
 __irq_exit_rcu+0xc1/0xe0
 common_interrupt+0x83/0xa0

Fixes: e314dbdc1c0d ("[NET]: Virtual ethernet device driver.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1b5714926d81..eb0121a64d6d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -320,7 +320,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	rcu_read_lock();
 	rcv = rcu_dereference(priv->peer);
-	if (unlikely(!rcv)) {
+	if (unlikely(!rcv) || !pskb_may_pull(skb, ETH_HLEN)) {
 		kfree_skb(skb);
 		goto drop;
 	}
-- 
2.21.3

