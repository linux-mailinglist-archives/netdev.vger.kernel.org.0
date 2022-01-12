Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7189748BFD0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351570AbiALI1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351552AbiALI1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:27:03 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54BFC06173F;
        Wed, 12 Jan 2022 00:27:02 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h4so2161079qth.11;
        Wed, 12 Jan 2022 00:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LuNmEw0MfoqSToYP/cUIWFfLjxFvMv1mm3SH85aVwKQ=;
        b=RlCcduVThM/eyUmTcYa89sPCxYPO3H3EMF/lWZ9ZgSB3bM3EQK4az+Gw386qPJTGfs
         OUJWdaAb3SKI2p1hSMUTjxtl9s+5zcdZi+uayv9GQzAYakn4s5UYwTMJyUAUWXuxW62p
         qII8J+DhnaX+q0vL9tciKmZC3SUcFgeDi2EQnhSWTm8WaV5sNa+PB68Gp8eportS2dLw
         K0oL4P+svfifgPQf0ng4U/RHSTd7i0dzeP5LWLtd0qArKgvhx5DYHOM0Yu5FFqFvHJYG
         tqKDleil3ER1C4ln906UPJevCMGRCLdPP49G7eQdV49Fptq8Z13bureq/AioMVjiNR4h
         TZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LuNmEw0MfoqSToYP/cUIWFfLjxFvMv1mm3SH85aVwKQ=;
        b=FjwZ199sXYiDOc0M0LoAy8s5wd/ZDdMm6J9276v/yvfyhycJwJM1LFe8dMHFf1O7ws
         JlhU7YRAs0QE+qTaS03pRKZaoI6SDUdzUk7na2GqP/u6W8p6c8/Lyy4jyNseryXLuJcH
         8sNLL1ZB95kDUZyJIWJx3ROQhfM8vXIs2cjg+TNlCS9wyaWbRQ8MDPY4T6LX5rrfldKQ
         LfrSQnS0DbiGZI4wbisU4pfEeMxDKIxlfU3JsMnpZIFIZrBKGPjaLWaVBPvW+xWyeWcV
         5LLrKihfz/6XLdWztFp2D9GXTwFm2mqb2X03stoMKRpUahmykXcxhxmYOWk6Ams6sj8n
         pZhw==
X-Gm-Message-State: AOAM530+ZEcp5ag2bStiBHegn+xYighNR3UWDrYGFlERbS+vTBay+71z
        lJIrkcc1bw3p2hXbDMoUPhA=
X-Google-Smtp-Source: ABdhPJyK6TI9Lp08GP+vsE0U1arVF3rwlnzsvPSe0pC1quP4SDE0da/CMYFtlmKwflckYBrQAq46gw==
X-Received: by 2002:ac8:5787:: with SMTP id v7mr6569612qta.547.1641976021986;
        Wed, 12 Jan 2022 00:27:01 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l16sm1771562qkl.114.2022.01.12.00.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 00:27:01 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] net/ipv6: remove redundant err variable
Date:   Wed, 12 Jan 2022 08:26:55 +0000
Message-Id: <20220112082655.667680-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from ip6_tnl_err() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 net/ipv6/ip6_tunnel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index fe786df4f849..897194eb3b89 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -698,13 +698,12 @@ mplsip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	    u8 type, u8 code, int offset, __be32 info)
 {
 	__u32 rel_info = ntohl(info);
-	int err, rel_msg = 0;
+	int rel_msg = 0;
 	u8 rel_type = type;
 	u8 rel_code = code;
 
-	err = ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
+	return ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
 			  &rel_msg, &rel_info, offset);
-	return err;
 }
 
 static int ip4ip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
-- 
2.25.1

