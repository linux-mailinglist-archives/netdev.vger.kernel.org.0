Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C342D45CB
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgLIPu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:50:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgLIPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:50:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607528928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=pxtrL3FuwLm6to1JoqqYIg5sQTY8SBBkqlL1fyreDPs=;
        b=iQp+kwvRmPS0wwa8BoYsfuErsJcS+oK2p9Da3XIE7d/Udv51AWr4jHhxsiM+GFHBK+oLFM
        ED6DMUC/fWN/3HYHmO9XPkJyQKXF/Z8+LRmRYc7DCbVf1g4UxXYNXE+8sFT23Vl55F4vrS
        9yAlzHHP9U/Z30kfSV0fF2gzskk7NtM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-BMbrQEszNKynmW7sO6QW6w-1; Wed, 09 Dec 2020 10:48:45 -0500
X-MC-Unique: BMbrQEszNKynmW7sO6QW6w-1
Received: by mail-wr1-f70.google.com with SMTP id x10so825665wrs.2
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 07:48:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=pxtrL3FuwLm6to1JoqqYIg5sQTY8SBBkqlL1fyreDPs=;
        b=f169NX5snTn9NUuKiGPL8QRILusU7xd0/tM5XYxRH4rDrW/RpWOKQqAvhKgJIvIcLx
         4iV+1L9l9B9txPmDytxwfgodRoTRIWcq9Ky6Xoj48FUDeBtckEduuU7rCmPHCrIDI/io
         q9GQJx3eq/hEyOkLWqvYzuO6mhU6a6j6qxDT24XwSQZDAypsp8kyX/2hduG6tmAXHLjr
         yXbkiI1xGgs98qyFeCHirGFy97O4ZHlTcq6p1IAqxIFMPedwNQdwK2mazLFNhgvuL9OC
         xVy2mR/igUIQafG2lP44SlIVeYykZHyNBmIU50o5z1ssIAv8pwYGQSb41XdVEsHHfxaz
         KQMg==
X-Gm-Message-State: AOAM533yp6gF787DPuvB952q9+FaF+na/dT565L7I+nniCapiw/w+uir
        1yIJ2yyXlS/YuJVR4P8lQQBpAstf7JxGir/Y6pCGJA1kNJRVLIcimpRmZxCy7StnPRpWMRvL4nE
        aEyHc5udK7bA4jsdU
X-Received: by 2002:a5d:4ccf:: with SMTP id c15mr3419609wrt.237.1607528924460;
        Wed, 09 Dec 2020 07:48:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4SHt7t7bJl9dEK2lZByvyKIDpLCLQfyY4oyAMLP8agqVfgoex4dJXfHH2RFmFeDD+BKfpqw==
X-Received: by 2002:a5d:4ccf:: with SMTP id c15mr3419595wrt.237.1607528924281;
        Wed, 09 Dec 2020 07:48:44 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id c9sm4519476wrn.65.2020.12.09.07.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 07:48:43 -0800 (PST)
Date:   Wed, 9 Dec 2020 16:48:41 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net: sched: Fix dump of MPLS_OPT_LSE_LABEL attribute in
 cls_flower
Message-ID: <0e248b0464673b412d428666d10b6d3c208809bf.1607528860.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL is a u32 attribute (MPLS label is
20 bits long).

Fixes the following bug:

 $ tc filter add dev ethX ingress protocol mpls_uc \
     flower mpls lse depth 2 label 256             \
     action drop

 $ tc filter show dev ethX ingress
   filter protocol mpls_uc pref 49152 flower chain 0
   filter protocol mpls_uc pref 49152 flower chain 0 handle 0x1
     eth_type 8847
     mpls
       lse depth 2 label 0  <-- invalid label 0, should be 256
   ...

Fixes: 61aec25a6db5 ("cls_flower: Support filtering on multiple MPLS Label Stack Entries")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/cls_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index fed18fd2c50b..1319986693fc 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2424,8 +2424,8 @@ static int fl_dump_key_mpls_opt_lse(struct sk_buff *skb,
 			return err;
 	}
 	if (lse_mask->mpls_label) {
-		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
-				 lse_key->mpls_label);
+		err = nla_put_u32(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+				  lse_key->mpls_label);
 		if (err)
 			return err;
 	}
-- 
2.21.3

