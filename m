Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB22F5B7E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbhANHpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbhANHpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:45:23 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD70C061575;
        Wed, 13 Jan 2021 23:44:42 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id x18so2489377pln.6;
        Wed, 13 Jan 2021 23:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6BUdNw0q/DNAijNL8F7/pETEH9/f34TPh7vUh83FEZw=;
        b=IYUZfiEgVRcNwcPekBnpByrwWKE4s215rBFF8hyFf5144I1mZG0JK3nvd3TCsFu5lj
         tMq23SbvZOInjsu/gMMFxSmZ3q5k9vRCkquEmVE6HeNBlLJFdjZV+ToJAXE3ZncdJwih
         9m0Uf6pGPSAaGdHP2Y3F52PFocbBkAlrVEi4tOCzVIT5l/X9RJzt5WGnwMoVWz15qVyM
         YZ5R5B7c2ptkskTCEsMfO15o/RxrzxltCD34QxqvTW31MQg3isjD/8QjBQPQ3itcOGq/
         CD7W7SJnVaUJu64huIWAYKADPnsKAAMkI3IDFcpR7rZn4UpIRUoYZlRTdL+xKdeqcPRo
         XvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6BUdNw0q/DNAijNL8F7/pETEH9/f34TPh7vUh83FEZw=;
        b=eNVIkXA1Imdf7iOGvwclFoxla6oLhvtSXdlIunu1bNwYUJD4tYK6k0JrxNL5sv9wpK
         +EFnBqHvBUDR4La8DJviQf+oS2yV6i+KfleceVbo9TdESKPHjgEDN/OBCoQgUbr5rtFe
         AkRonbKxhMBUYEp6Z9eNN1WqHVT1mNUmRcTBaYgHFAZTBJ1uMNX7OgnbkolG9Rfi94T0
         lj5DgjpknCFYiAq03mGvfbfL9jjYc2RJZ/5GebsBhGPpmpoiJfnjxb6Lpd+x4azMIuVr
         NNKJqq5bcyVJVtpWRXEzJkmUJjvKeOCZp03ENeFcVb/yWSVNgULgQD6Gdh34yyDBZ4zn
         niBw==
X-Gm-Message-State: AOAM530KQ57KP/Sp+1wp8KLqx4X2Xxk3yeHl5NEKV2i2DxynsrQuNpbm
        M3txk8QeU7IabgVUC3He9iHrn1iL4b8=
X-Google-Smtp-Source: ABdhPJyAVXesyHUBVjRk9j9HGrckt0QudlV4Vm14LH+aaq/xHo4kiJhITMSZurGfO8xEDRRxqI4l/Q==
X-Received: by 2002:a17:902:9a49:b029:da:b3b0:94a1 with SMTP id x9-20020a1709029a49b02900dab3b094a1mr6402203plv.11.1610610282333;
        Wed, 13 Jan 2021 23:44:42 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id z15sm4367662pfn.34.2021.01.13.23.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 23:44:41 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     ast@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net: core: use eth_type_vlan in tap_get_user_xdp
Date:   Wed, 13 Jan 2021 23:44:36 -0800
Message-Id: <20210114074436.6268-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Replace the check for ETH_P_8021Q and ETH_P_8021AD in
tap_get_user_xdp with eth_type_vlan.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 drivers/net/tap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3c652c8ac5ba..e007583b5bd1 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1164,8 +1164,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	}
 
 	/* Move network header to the right position for VLAN tagged packets */
-	if ((skb->protocol == htons(ETH_P_8021Q) ||
-	     skb->protocol == htons(ETH_P_8021AD)) &&
+	if (eth_type_vlan(skb->protocol) &&
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-- 
2.25.1

