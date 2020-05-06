Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9782B1C754D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgEFPrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgEFPrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:47:52 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02F9C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 08:47:52 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s20so644110plp.6
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 08:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VmVT3hJTHH3yWPGozeeDd4qcjrfr8L+7vkXNizT13wM=;
        b=FqxmfmOxhqVUJwi2YGsaixJ9xh7Rn+BZYk9kATVWgscLmsjs5Dsf4N4KdHOTBcmAzm
         RrupuHSFM3ZlVvOwhc3RV6xKxo8Cn7mWNjLedU4lHIjiuBegoXgFnat0lHnY0Ug6dB3a
         JKtH7zdpdsY5vgNxb2W1m/9QVglii/xukbYiUsDd0mEYzCNjAHdgBkLMcTNifrPU6UjJ
         AIVnqp9gRIk9uS0XseEx64K3Y1h533QSBi3Br/jpcM9HAJt/LNpXW9bsREg9S84/kZmu
         RuXUHLksyNshPOPSKCArRZPWz2cL/3HK1I2n2q3bIYd7sMkXDrwkkNGq+K1I26VIW84f
         2QIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VmVT3hJTHH3yWPGozeeDd4qcjrfr8L+7vkXNizT13wM=;
        b=haRHP0jRlCxHtbacCHzVkmYoPk123zTyPaGS2FO/DzHvClD7DnKYvrNW5kHaoNR35N
         +mPiJA+1aBOKpdjcG6qTuyccrJFWEPCwIvX8TDyfJLcbbQonAbe9+N6Mj/8DXqI446SS
         z56Lz4+XAhvDTO+/KEoFcRed8wngR8vfvhswyDWYNucaxhIgXS2dSst2xx7Q4YyOji71
         DSucqVOZh5J3kp7fed38vXq1vPL+5UUcZTCE0OXhgVJWLAo7zCshZqWusR4K4o0NVQew
         khN+Pm+He+UpjRgrabCiYvKJIaY+AD8NQrccf3XZ+VpMVSfl4Izfw8By03r9cqxV2OVe
         SJcQ==
X-Gm-Message-State: AGi0Pubd/ZF31hdALwfLA9wuAhMLylKitfk2re/fkUbKXCIWWI/ntCHZ
        0Ao9RzjrRD4sTZ4BnXLLfcs=
X-Google-Smtp-Source: APiQypIs3lOmp251KYNOpWPGGygZwBDsTF8ChXN9L5sCr68S9s4E6tU/AItKMi+05SflzQ21ytg9bA==
X-Received: by 2002:a17:90a:ea0b:: with SMTP id w11mr7560569pjy.221.1588780072162;
        Wed, 06 May 2020 08:47:52 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id t14sm1920066pgr.61.2020.05.06.08.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:47:51 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 2/2] hsr: remove WARN_ONCE() in hsr_fill_frame_info()
Date:   Wed,  6 May 2020 15:47:45 +0000
Message-Id: <20200506154745.12627-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When VLAN frame is being sent, hsr calls WARN_ONCE() because hsr doesn't
support VLAN. But using WARN_ONCE() is overdoing.
Using netdev_warn_once() is enough.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ddd9605bad04..ed13760463de 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -321,7 +321,7 @@ static int hsr_fill_frame_info(struct hsr_frame_info *frame,
 	if (ethhdr->h_proto == htons(ETH_P_8021Q)) {
 		frame->is_vlan = true;
 		/* FIXME: */
-		WARN_ONCE(1, "HSR: VLAN not yet supported");
+		netdev_warn_once(skb->dev, "VLAN not yet supported");
 	}
 	if (ethhdr->h_proto == htons(ETH_P_PRP) ||
 	    ethhdr->h_proto == htons(ETH_P_HSR)) {
-- 
2.17.1

