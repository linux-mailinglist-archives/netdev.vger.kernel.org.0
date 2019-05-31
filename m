Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B4B30A59
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfEaIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:33:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44189 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaIdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:33:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id x3so241046pff.11
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 01:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KmJE95XiJao9tFZeoCDszXF8beLw9WwwE8rEwVLBpKQ=;
        b=aXQWkLaUBI/6ydUT957/HaZ/S2C/+YBpBjSjbbqeyE5QuLc3YIZAVkN+XxVIPJIJ11
         wlGHP/RljBJtwJr3HwjaJVwxlVrrAUjwVgB3pd3Sr2P0XKP+VSQZzgeiI/BdYxGSgJ26
         ioQFrwCkOfmW0BSVxstl+VdzGaZEJKB+7/10y8vQrzLNBi0knyOnoVIb5f7R//PwTHSa
         UJcBLRAYZsDrNFarM3HQuGgztz4QsltgP04nbacSb+Lf75Bc+2rRc7HLYapSvEpD9cuK
         yrmEA1TZfPL7JK5JVtbIkFotb8p20a6aP2nMR2cxSH/zazaZgP36+bL4TR9YjXcn2kbq
         A4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KmJE95XiJao9tFZeoCDszXF8beLw9WwwE8rEwVLBpKQ=;
        b=LyePv7grwfL1Tj9u9lB3pO13zMDaqo0VPSqfuZKzgtZvNZnZ63F0dH6eIgZhsMd+vh
         /Fvb8lPWAbjuRfV2wdgetT4Xl5/heXB6mlw9JOO4r36Sox8Iji2L1diJfTbUDWQ2SPgV
         PQiVQm38MQJlLHYIwlEg1Bzi3xD/4tAH4ldDRyEQ/jjurIOuOkTgtfZmqyMgdfgrfk/c
         /YD0XV8+bHGaq11PCFTDKcgioeog01CEmf7RQWb+j8IfAeB6BL9GMQ9yxdS6j1PBdXTZ
         WgnuIzI97L9Jf2aUrrfe6vRkj5qpocscqEcFD5hAmbDnp6mgi+UIHF2/bOecIhpIdeRo
         zuYQ==
X-Gm-Message-State: APjAAAVr2Kkq507mPVa+qrWQt7XtR3vEOlkib4JmBBlRM83q6y4s/asp
        HotkBD7K3h3fyllGuTeoM7U=
X-Google-Smtp-Source: APXvYqwr+bSmiIx45IDr6ZXp9lLCwaxG+ejeEKN4JetatKle3Iozxg4KTH7GJ7OONrwpAChGxwoabQ==
X-Received: by 2002:a17:90a:1951:: with SMTP id 17mr7650380pjh.79.1559291613364;
        Fri, 31 May 2019 01:33:33 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id a22sm6157050pfh.152.2019.05.31.01.33.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 May 2019 01:33:32 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     davem@davemloft.net, petrm@mellanox.com, roopa@cumulusnetworks.com,
        idosch@mellanox.com, sbrivio@redhat.com, netdev@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] net/vxlan: fix potential null pointer deference
Date:   Fri, 31 May 2019 16:34:41 +0800
Message-Id: <1559291681-6002-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possible null pointer deference bug in vxlan_fdb_info(),
which is similar to the bug which was fixed in commit 6adc5fd6a142
("net/neighbour: fix crash at dumping device-agnostic proxy entries").

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5994d54..1ba5977 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -274,7 +274,7 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 	} else
 		ndm->ndm_family	= AF_BRIDGE;
 	ndm->ndm_state = fdb->state;
-	ndm->ndm_ifindex = vxlan->dev->ifindex;
+	ndm->ndm_ifindex = vxlan->dev ? vxlan->dev->ifindex : 0;
 	ndm->ndm_flags = fdb->flags;
 	if (rdst->offloaded)
 		ndm->ndm_flags |= NTF_OFFLOADED;
-- 
2.7.4

