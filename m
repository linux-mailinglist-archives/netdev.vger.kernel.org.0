Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149492ACB67
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgKJC6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbgKJC6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 21:58:30 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71147C0613CF;
        Mon,  9 Nov 2020 18:58:30 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id g7so10074277pfc.2;
        Mon, 09 Nov 2020 18:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:to:cc:subject:date;
        bh=F5cpULf6JD3oKvDpY2w/0ouhpNWX4sd6An/RceLKtro=;
        b=oaye5O1fOjAr+od+4iS+Skg4xCD54XCKP19+IoKi3aYSU9p7OrAte1sHSARiW9Bg4H
         B4vM89jX7fT0BULSGhpW2AotbWQmgRT4RY5WZOdyhVnvg0YG5M5+niJQdi8/i+XD2O+H
         +iSo9iA9Og22IBGJMZ0+2WCwZAEGmEYbhoj+7Xrf1PpsrRcCXvIk0QBxfSNyhMCOwZLZ
         AIC49LkPUelrD92Dtn36jEu9hSOmCfAV99HoXSQmBO1YkY3ZJF4A0quuPra3ezjB3nhg
         zLgrwyQk3ah45PL92IkZyMCS8w5nv4tEy09NSVE9oHdxF8n4m6CaW2pryYiTu4CZqiTj
         zKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:date;
        bh=F5cpULf6JD3oKvDpY2w/0ouhpNWX4sd6An/RceLKtro=;
        b=Uj/7ptKjZcz9cLjL1mdsDlr0RVGpRnf9kUZBPF2w+zcWKZf62TqH5nZ3IZH1PyVdh+
         6vm9/wQZir3KcfBc1QfuoJV+qhz4CnPriIOwCKCnzlBalBbK5qC5CfMNBgW+oUwhaok1
         cLSjTOu1/XXfUG6czxiiaK3QY/81LUoLMjkmFt6oIGjhET9Q8m7md0nqWvmSWjiAdnkw
         bQr66Xxz8Lc2KPFKLrTTWPpmIwBd9GVhygI278Qlz4xLcc2vQKwzot8mvTf/Ky9kdzLt
         1/K9qrXU42cLUgbK7fvBmMdc44nMaXHuG9Q5cHoeHwiWSMmaqDHXH0nwn5LV2b18vK2G
         V0tg==
X-Gm-Message-State: AOAM533YpMeAOibEwrCtjLgaTK1FOrcV8CAF+Vr1vL/LYT1sySVI6ayh
        8uga6T1IoCmOcv/VaGEwKkw=
X-Google-Smtp-Source: ABdhPJx3u3hI0C+4er+TyT6S2SzeSYu6L1B4IUQSUoAiUL9u6PxChbflJcm+zdbCvTRUfZDHgOwkfg==
X-Received: by 2002:a63:6243:: with SMTP id w64mr14967793pgb.430.1604977110109;
        Mon, 09 Nov 2020 18:58:30 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id j184sm12899665pfg.207.2020.11.09.18.58.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 18:58:29 -0800 (PST)
Message-ID: <5faa01d5.1c69fb81.8451c.cb5b@mx.google.com>
X-Google-Original-Message-ID: <1604977078-10422-1-git-send-email---global>
From:   menglong8.dong@gmail.com
X-Google-Original-From: --global
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2 net-next] net: udp: remove redundant initialization in udp_gro_complete
Date:   Mon,  9 Nov 2020 21:57:58 -0500
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for 'err' with '-ENOSYS' is redundant and
can be removed, as it is updated soon and not used.

Changes since v1:
- Move the err declaration below struct sock *sk

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index b8b1fde..54c9533 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -554,8 +554,8 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 {
 	__be16 newlen = htons(skb->len - nhoff);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
-	int err = -ENOSYS;
 	struct sock *sk;
+	int err;
 
 	uh->len = newlen;
 
-- 
2.7.4

