Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B161B116057
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfLHEmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:42:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35319 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLHEmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:42:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so5475997pfo.2;
        Sat, 07 Dec 2019 20:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=UHmg8XpAQ3K1W5SprFjlhQhxEikVaGjbNHyT3thJCc4=;
        b=k6lS9SYwxfHayYEchSFf5VbbjoQu63GNhm2rPT3zkhB+/x1AJB9AYUVe7Rp4/n3mI9
         mnt9AUGPKYeA4haZukyQFMNkCMV4UumWndqYIfQ6ty8afWJpM/hKphAcS9es32FuD2Qn
         XAPxybi4yOb9M7XV63NHG6OXDVD6CY46cVyj9Q0Nqe5zW1IZb0P1NuKUTl8Rjfc2M/a2
         0aXqPBrVUD27wjnB8H/cDZ4SBtaCw21WDyOREHOdHwD4QoetxIoZEhvrFQ/lxNJGty6w
         psrLzojrZPQht5gNmRyp3gDzo7vM9iiMkcS5esztjzUj1+uzVezKl/gM0RR7IVloifLY
         h9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=UHmg8XpAQ3K1W5SprFjlhQhxEikVaGjbNHyT3thJCc4=;
        b=SAjxBxMxU+BkrHxObH85ZW4lIpn02Ka6cHsxfNzZOVTOUTd1KZ1QGNYlZX+K3KSEQV
         dcQ/rHelFHVLWxHpY9pzQ31ZCe9cgjV7lvrP8p5OExwISbpAZ9b7MQQby/KDlafoazUK
         /ldpjhWkNR4n/zuQ9hoK6C79CturS79W92imEynCaKg/PSfaQCknStPtwXWOP04dfTZR
         eqtNU/mzoTCHAEnd8PlQU0v/GyARKl6xoa/6FV0RZz2DzufgQAwYz15TmzHGduV0UWxZ
         x9QFk7Pk+5lVrqDXl7te7LzLrjbBXTgoYeQiklDMDLWe2SemCzzRNQ2pJu+2jzHy46ei
         EDGw==
X-Gm-Message-State: APjAAAXI4Okn5Vg500u9bdBQIz8mHI5c1np161Wk5Cfel4MCASmUT6hH
        IhsNsm+kF5trYG8WSxSd7t1jyVyg
X-Google-Smtp-Source: APXvYqxaoN78iC6eL294Wyme2JQ5JaaIv8+gadXhS/Lej94QQOdmhHScXJWNV+babAnKw2wvUVGf4Q==
X-Received: by 2002:a65:4109:: with SMTP id w9mr678622pgp.383.1575780131085;
        Sat, 07 Dec 2019 20:42:11 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w200sm12731065pfc.93.2019.12.07.20.42.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:42:10 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 3/7] netfilter: nft_tunnel: no need to call htons() when dumping ports
Date:   Sun,  8 Dec 2019 12:41:33 +0800
Message-Id: <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

info->key.tp_src and tp_dst are __be16, when using nla_put_be16()
to dump them, htons() is not needed, so remove it in this patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/nft_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d9d6c0d..e1184fa 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -502,8 +502,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
 				 struct ip_tunnel_info *info)
 {
-	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
-	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
+	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
+	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)
 		return -1;
 
 	return 0;
-- 
2.1.0

