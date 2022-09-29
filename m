Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07155EFCE9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbiI2ST5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiI2STz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:19:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D8145F61
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:19:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dc888dc62so21506967b3.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=SPo8cxe5Gv4Icg9WBrTrddqkcf882sEf/dI0Be8XuxM=;
        b=DXJnnm+NdL8nSanlq3PhzlVA2yW8T9I3mOa4xTvpj42zBvFu66FIb2DtQDOjHeG+6v
         HG3cK4hF922dwdGX+x8p7M6qxWMG+f6hDGB2TfxfIDs0H1DDPVDs5ZPI69y+pKxTDeMT
         SpO1i5Gshc3VpB6UyQQDsQzCy3FgY7GG6NVmJ647J6qtYhmcaVPt+8gNr+34nTwANlSa
         QbU/D0nreNEhATK9tXjmehbZPg/h6npv7o0zZWMdjdFVDdsBQQBUkwwgu0CxZL0FgOyG
         duIQJBBQvHvR4F1IfLZu86vzbPpr/r1yF9N17o8yLu1I88CUq0ClhnYOWb683aA7tvTM
         jwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=SPo8cxe5Gv4Icg9WBrTrddqkcf882sEf/dI0Be8XuxM=;
        b=MbAKkJ8XzbaPevGJEAuI3vRDv7Na9nBkA7g8UgeLf7W3kVVL7F0svf2Qv17nhd4+fP
         N1mWBwgQXE9hSuyVZGlOYYOMtNC0GMd6QTN0gydM0i+v/Sbdzgft7quo/b5nNTb5gs+Q
         0okD6ffKDhHPqOUJ7cB9IE3uY7/aC6mlhs8TbSn/YP6b4jYe256/+HWuiR1qtq0HRI9b
         h//D+6vzpWuGIEFf7V7DrDDih2185kDA/MGr8yyBfirFc1KmkTOjdwiBH56yetCQl9Au
         ErMcv2RbJSeneMtAjpK3DR+dLpEV6Zw8hZciBMVgYgjvHzDO195+KRNVseYPCb9EhrBo
         PJBg==
X-Gm-Message-State: ACrzQf14uelQhLCz/MzLWTwW7ELr400eUD7RSkU9YvL0VFfFqqZM3xZT
        2Rk3LlE/3CJ7C/aabCHwwnnWFI8kSQ==
X-Google-Smtp-Source: AMsMyM7hNJtv8eCYHU7H8bJzKkzWK1XeHZnh/Mh4XMITraHR5mnwjiEVoe7+u4ihdbWsT8jjcmHhOIx6uQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a81:c45:0:b0:34d:21de:b794 with SMTP id
 66-20020a810c45000000b0034d21deb794mr4937456ywm.138.1664475593080; Thu, 29
 Sep 2022 11:19:53 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:19:47 -0700
In-Reply-To: <20220920073003.5dab2753@kernel.org>
Mime-Version: 1.0
References: <20220920073003.5dab2753@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929181947.62909-1-nhuck@google.com>
Subject: [PATCH v2] net: sparx5: Fix return type of sparx5_port_xmit_impl
From:   Nathan Huckleberry <nhuck@google.com>
To:     kuba@kernel.org
Cc:     Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        casper.casan@gmail.com, davem@davemloft.net, edumazet@google.com,
        error27@gmail.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        nhuck@google.com, pabeni@redhat.com, trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of sparx5_port_xmit_impl should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---

Changes v1 -> v2
- Updated header file

 drivers/net/ethernet/microchip/sparx5/sparx5_main.h   | 2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 8b42cad0e49c..7a83222caa73 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -305,7 +305,7 @@ struct frame_info {
 void sparx5_xtr_flush(struct sparx5 *sparx5, u8 grp);
 void sparx5_ifh_parse(u32 *ifh, struct frame_info *info);
 irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
-int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
 int sparx5_manual_injection_mode(struct sparx5 *sparx5);
 void sparx5_port_inj_timer_setup(struct sparx5_port *port);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 21844beba72d..83c16ca5b30f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -222,13 +222,13 @@ static int sparx5_inject(struct sparx5 *sparx5,
 	return NETDEV_TX_OK;
 }
 
-int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *sparx5 = port->sparx5;
 	u32 ifh[IFH_LEN];
-	int ret;
+	netdev_tx_t ret;
 
 	memset(ifh, 0, IFH_LEN * 4);
 	sparx5_set_port_ifh(ifh, port->portno);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

