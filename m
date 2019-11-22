Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38A3107242
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 13:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKVMiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 07:38:13 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36098 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVMiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 07:38:13 -0500
Received: by mail-pl1-f194.google.com with SMTP id d7so3083267pls.3
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 04:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nf7VJBUVNaJ0m1vACk1cOtmPHpR133nGrATn2EE5bfk=;
        b=JnoY1q43xC4mwdWas/rz+Oec9WzWqUDdY3QsOEckUaZSBEOANbPqtuxJutOxopp5sR
         KRN/krRTLTSW5EYvJB4P0AIRS/FnXmeVnPdKr9TEYeKKBzlEVrsYYY8RbC//7ShZjeUh
         7FF2XY+ynbNV8MPO85QKgJIOfIcTi9eeoECQfu7dAcAo05DJV6GF/W1S05RCeOdIXSw0
         /2OsrUlfAH0ULfpOpu0j91eyNLqEh9+RZhhEMlhkvTg41UAzmrrb6YNTyJ1dhYsmNoZK
         HyxnAGOgDNAmvT3HnWeZCQBEIiEycLq45jFjhWmhdUibZXCE7tL6FgFoxRjsFXjdyJ5y
         TwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nf7VJBUVNaJ0m1vACk1cOtmPHpR133nGrATn2EE5bfk=;
        b=G2fPoltJmsmVgUWbXEEOPZybvX8VKT0qKNI7Lb0wz6xxlqoL4B/37/vfqvaeXglkv+
         qBn6xWnJ34XT3D3PVjquXjdhNg2rF7f5Pkpe1Z519Drxbu8FNafytr6zRgWEHa0QtVxq
         Aty2EcqKWdbz7HI7xz3ajPTU+QkXnzMCvoxfq2Bb8ArBUNtxn1lxOlrJdrmOUToqEyA7
         sMBAFnriff5b77+xajGMbwmqfB+RwKXdkMJ1vNmGvJ6Ezne65/4P1LxZLCJFFzEjBjtq
         9tkB2I4FM9U+rdrm32k0wHOczl3ANhUycxYKDyaIuTNC4yFiIXGjVkvFSFZv5Dv/lMSO
         7bjQ==
X-Gm-Message-State: APjAAAX3Amkno2+3LNl+y1SsK5oWPU3XF9Tmwayp5vt7Vypt0O3g7YLG
        jP/eCs7owZ+UQw4V3VxlujTL41Fm
X-Google-Smtp-Source: APXvYqyy+aPjwih7LJaMGIab5CcpZthkYV15aUDz7JSFQEBscDmlz8iABufmuf6XDUQGIuF0fUx5dw==
X-Received: by 2002:a17:902:728e:: with SMTP id d14mr14242798pll.19.1574426292207;
        Fri, 22 Nov 2019 04:38:12 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id m34sm6564730pgb.26.2019.11.22.04.38.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 04:38:11 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH next-net] net: gro: use vlan API instead of accessing directly
Date:   Fri, 22 Nov 2019 20:38:01 +0800
Message-Id: <1574426281-52829-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Use vlan common api to access the vlan_tag info.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index da78a433c10c..c7fc902ccbdc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5586,7 +5586,7 @@ static struct list_head *gro_list_prepare(struct napi_struct *napi,
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
 		diffs |= skb_vlan_tag_present(p) ^ skb_vlan_tag_present(skb);
 		if (skb_vlan_tag_present(p))
-			diffs |= p->vlan_tci ^ skb->vlan_tci;
+			diffs |= skb_vlan_tag_get(p) ^ skb_vlan_tag_get(skb);
 		diffs |= skb_metadata_dst_cmp(p, skb);
 		diffs |= skb_metadata_differs(p, skb);
 		if (maclen == ETH_HLEN)
-- 
2.23.0

