Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297952A2F6F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKBQPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgKBQOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:14:55 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759AAC061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:14:53 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id w14so15256534wrs.9
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 08:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6oQK3SCG2X0OqS0yyKhp7n4T1apDPtlUAe42OHVNz1g=;
        b=U+Gj6XSRpsl6pLpA+QTmOVmB66RFKQJCOwKzcr+1mFCmixjP+nIVTlQAFEso30z1wz
         O0klYqGgOGCslpkhSP7luB/MllmRBxRCytJslqVn3qVMk13gAd8VKRuLL/cEvxm500JV
         9jpcB8e/V+nSFGnmhTGYGtxBWObnG8pJRmMEu/HOnPQ3j88PO9P4e2S9L7kIBd+7LtYA
         NFtYOpPC/+6JJQAfdMOqMpMeyI3ez0bDILbfJuWEqWfPPxkZ9ExZ4A3rwXFcaWLmHGEO
         xPYazqP83Uq99S1QIRVWEDPbeZR9O2e7k6Pu2xVFSRnx2e2o/86ym/Q0Bgbd0OdDx+Ar
         cu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6oQK3SCG2X0OqS0yyKhp7n4T1apDPtlUAe42OHVNz1g=;
        b=hBu2u9EDcCyDRPM/J6OJcm9Fg2QPxBnGEZmKmlCF9FdTxqdpba8Xb3qT2h7Tf3XDMj
         Pikq3Ptz7zIGxxV+X6Ovq3TCDerh68Jke8coXXsqGxImkaJu4sQ8j1ZNJYx76/wwfNrL
         1z+1i2rZ9uuUh08NcvjQMy+HhhG0wtiMAglnrls9S0paWkfsd3eX8cYvNbCndn9cggBH
         7VobVXbXQ2U5aqu5AY4WEuuC56mQOgfRfEapMkvthpo5Td70TrQX0YNWgtvsmtKr79OU
         IsBvXWAS5Z1Md56kH23kppwj0WCCbS9eu4NXGHvJfCGOdq31VW2mV4/XSoWdfIKze84c
         oDpA==
X-Gm-Message-State: AOAM530KDWgXgFCzB3+ynTfPcy4haZKj+8Ck2xWihM+XQi47yhqbmrbw
        X0uw9jmPjyWKDG+jnybuUr3M9zk+5FtCnkzf
X-Google-Smtp-Source: ABdhPJwCEfpj+fMa6liV5sL/DNJ1tclbc/6Zec8uGWaFEja2jNV69ckqw4hFkdzT/4DAxedt7W/r4w==
X-Received: by 2002:adf:9502:: with SMTP id 2mr19336780wrs.5.1604333692119;
        Mon, 02 Nov 2020 08:14:52 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id x18sm24127878wrg.4.2020.11.02.08.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:14:51 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
        syzbot+c43831072e7df506a646@syzkaller.appspotmail.com
Subject: [PATCH v2 2/3] xfrm/compat: memset(0) 64-bit padding at right place
Date:   Mon,  2 Nov 2020 16:14:46 +0000
Message-Id: <20201102161447.1266001-3-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102161447.1266001-1-dima@arista.com>
References: <20201102161447.1266001-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32-bit messages translated by xfrm_compat can have attributes attached.
For all, but XFRMA_SA, XFRMA_POLICY the size of payload is the same
in 32-bit UABI and 64-bit UABI. For XFRMA_SA (struct xfrm_usersa_info)
and XFRMA_POLICY (struct xfrm_userpolicy_info) it's only tail-padding
that is present in 64-bit payload, but not in 32-bit.
The proper size for destination nlattr is already calculated by
xfrm_user_rcv_calculate_len64() and allocated with kvmalloc().

xfrm_attr_cpy32() copies 32-bit copy_len into 64-bit attribute
translated payload, zero-filling possible padding for SA/POLICY.
Due to a typo, *pos already has 64-bit payload size, in a result next
memset(0) is called on the memory after the translated attribute, not on
the tail-padding of it.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Reported-by: syzbot+c43831072e7df506a646@syzkaller.appspotmail.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 17edbf935e35..556e9f33b815 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -388,7 +388,7 @@ static int xfrm_attr_cpy32(void *dst, size_t *pos, const struct nlattr *src,
 
 	memcpy(nla, src, nla_attr_size(copy_len));
 	nla->nla_len = nla_attr_size(payload);
-	*pos += nla_attr_size(payload);
+	*pos += nla_attr_size(copy_len);
 	nlmsg->nlmsg_len += nla->nla_len;
 
 	memset(dst + *pos, 0, payload - copy_len);
-- 
2.28.0

