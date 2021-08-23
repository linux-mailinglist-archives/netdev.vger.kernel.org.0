Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868A93F45A0
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 09:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhHWHKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 03:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhHWHKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 03:10:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73C7C061575;
        Mon, 23 Aug 2021 00:09:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so6170522pjb.0;
        Mon, 23 Aug 2021 00:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Nh9cOJMrafoLUQICBnICXP4da42X3TBMHLOJtv6el0=;
        b=AxZoV944kTBLUgukjShmgDe0FvhulDu6B3x2ddsY7WplXZl2E8qswgBIl0W+0BOkUV
         c0BspHSChAKwTslLkKvro5VlK5+U1n1QMF9gW3KhfYX4QeiNw4g/zHmyqWEWBYzqcQtG
         1vLJ5x+8GRk8xZ8oOFtReEPhb64xk4ZmtPuQVx48lCNlJHFHp5RF5yCjOhlE9PjPXsx3
         3VKJ9GrXLF/ju2O2QHv0uQRg4KCd/6/uJGtJXVXqp6M1CGTB7GsFn7AHIP/jL0NZwRJZ
         w6qECMP6h94h7oji/Byl/Dp8y4ZQNdZf89TEfUf1A6mJ8eBNCNsadlbCg2sH9rCcP/DA
         /Stg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Nh9cOJMrafoLUQICBnICXP4da42X3TBMHLOJtv6el0=;
        b=JY8soQ2wpbDUU678zHuPmPtFhSqCgBzagK5otZ3brgJBbPwW2SbJvBEFtO02uuEwmI
         PeyT6LoURCkIhqx/y+a8NM0LzCbpW5RaU+AIp1KUaF6JqoTBH8B3jaY7HuHinTOuuiHu
         jVCCnurcX1jaSfiWT3QFHxW2MtmD+TyITkdbqQH8q1aNQ26SYkXeKmWrcqcvOKxJoA5R
         fwQDYy0A9SHc5liWDfeYxsBpwSR0sRa4E9L5ELTM4EyIpoe+bqstNVkmhEnxUHDdzFQb
         wU2iisB5+CUNXm76Z599Id0fRbfOT31KaXEqnfmwIY8MctVgXpX9LJq+KD8U8t+D/ZdU
         48tw==
X-Gm-Message-State: AOAM530gF+WtUmm+UiAV6Fs4siDby2sPLOfiaM2MWXBmYV17Ii1xj3lk
        3c9PHSK5//e1bs1tWKFne4DL/N2tPVqnbY+X
X-Google-Smtp-Source: ABdhPJxoTn09yTVb41VGVSMz5hnPE0hHo+zxZ05BNRUzTGPTrnjYb7hN/zvxg3fQU2bDmXHeLLkRmg==
X-Received: by 2002:a17:90b:370d:: with SMTP id mg13mr18518621pjb.117.1629702578826;
        Mon, 23 Aug 2021 00:09:38 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id j6sm16215974pgh.17.2021.08.23.00.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 00:09:38 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:MEDIATEK SWITCH DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5.4.y] net: dsa: mt7530: fix VLAN traffic leaks again
Date:   Mon, 23 Aug 2021 15:09:27 +0800
Message-Id: <20210823070928.166082-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 7428022b50d0fbb4846dd0f00639ea09d36dff02 ]

When a port leaves a VLAN-aware bridge, the current code does not clear
other ports' matrix field bit. If the bridge is later set to VLAN-unaware
mode, traffic in the bridge may leak to that port.

Remove the VLAN filtering check in mt7530_port_bridge_leave.

Fixes: 4fe4e1f48ba1 ("net: dsa: mt7530: fix VLAN traffic leaks")
Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/dsa/mt7530.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index aec606058d98..fc45af12612f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -840,11 +840,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
-		 * And the other port's port matrix cannot be broken when the
-		 * other port is still a VLAN-aware port.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(&ds->ports[i])) {
+		if (dsa_is_user_port(ds, i) && i != port) {
 			if (dsa_to_port(ds, i)->bridge_dev != bridge)
 				continue;
 			if (priv->ports[i].enable)
-- 
2.25.1

