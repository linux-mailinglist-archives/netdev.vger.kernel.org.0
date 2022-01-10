Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734CC489A35
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiAJNnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:43:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233090AbiAJNnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641822193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HqnBSXTfxIJCjsZx3Wk7+tVQNXlVcU6X/OIDj2oO8No=;
        b=L07iI1tjQhEeGV59yi64dnJKJwirvCXllPq6+KPVERccgmtVnpFzJG4M4ZGNhVmzcOYDXA
        ihq8s4Koq9OtinuJdscZ3Cp+MRwG+jvuoFc9BKnwZJON1pv2CGoMSxFZVAu4xppyPXJs02
        Dvw4BRLz1wAaKcXHuo2r+SBdyD+FfzI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-3c4GV46jP4SXWbmaF9WqyQ-1; Mon, 10 Jan 2022 08:43:10 -0500
X-MC-Unique: 3c4GV46jP4SXWbmaF9WqyQ-1
Received: by mail-wm1-f72.google.com with SMTP id i81-20020a1c3b54000000b003467c58cbddso8561596wma.5
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HqnBSXTfxIJCjsZx3Wk7+tVQNXlVcU6X/OIDj2oO8No=;
        b=WrFt/1ulhXi2x5uMPQISfp7g1V6Op5bwzBkEetDRMqljqRnAelrI6XiVeFO6jsjlRz
         MF/mVG6ibP+uzXquGP4LeD3HxaNWpe6SCy5Wy/tGGuv3irMGgVJYHkPbMZP2BBV7hcXO
         pI48WvwgKxVDS6l5ubyPqDR5Q+KtluukfN/OpfrR5If8j8s1Rb6aSYeO1O2+t65P2mmc
         usevKCUcK+XhRdhOLUQb9pHYPU3ygn+uI0jqb5mVn68HVKJQVDARQ9u6aDf6PDy0NXZO
         Ol8oq05AUX8Cjey2Epr8xMheP+AEBjn+bfYVY1+eY2ACaeodCYscGAaQnQHZtESpMpGS
         2BEA==
X-Gm-Message-State: AOAM531vTJ9BsYD6QirowOSQ7GYdOTqILumIx2uJvBIF/BXk6VkChCAg
        EPh1CatbfQUZLy5wPubmZ8intjcp+tnclxuDmGwX50LhAU9WRhIYtQHJNQ6j+gwDcuQujV+IBgv
        m/BZuIxndivQRlSjc
X-Received: by 2002:a5d:6f07:: with SMTP id ay7mr2537914wrb.333.1641822188863;
        Mon, 10 Jan 2022 05:43:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQg/NvIkDXufpDm7jGrEI2nK7HyQF2YrCuC4T1IiwqZmrmdFQZh9+xFAJGYrshXXrn5L9n5Q==
X-Received: by 2002:a5d:6f07:: with SMTP id ay7mr2537903wrb.333.1641822188721;
        Mon, 10 Jan 2022 05:43:08 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l6sm9180738wry.18.2022.01.10.05.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:43:08 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:43:06 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 net 1/4] xfrm: Don't accidentally set RTO_ONLINK in
 decode_session4()
Message-ID: <ce6a296ddbf7e6700c40adeb24b69dc667a78823.1641821242.git.gnault@redhat.com>
References: <cover.1641821242.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641821242.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 94e2238969e8 ("xfrm4: strip ECN bits from tos field"),
clear the ECN bits from iph->tos when setting ->flowi4_tos.
This ensures that the last bit of ->flowi4_tos is cleared, so
ip_route_output_key_hash() isn't going to restrict the scope of the
route lookup.

Use ~INET_ECN_MASK instead of IPTOS_RT_MASK, because we have no reason
to clear the high order bits.

Found by code inspection, compile tested only.

Fixes: 4da3089f2b58 ("[IPSEC]: Use TOS when doing tunnel lookups")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/xfrm/xfrm_policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 84d2361da015..4924b9135c6e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -31,6 +31,7 @@
 #include <linux/if_tunnel.h>
 #include <net/dst.h>
 #include <net/flow.h>
+#include <net/inet_ecn.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/gre.h>
@@ -3295,7 +3296,7 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 	fl4->flowi4_proto = iph->protocol;
 	fl4->daddr = reverse ? iph->saddr : iph->daddr;
 	fl4->saddr = reverse ? iph->daddr : iph->saddr;
-	fl4->flowi4_tos = iph->tos;
+	fl4->flowi4_tos = iph->tos & ~INET_ECN_MASK;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {
-- 
2.21.3

