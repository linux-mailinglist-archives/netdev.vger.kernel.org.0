Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C717755895C
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiFWToO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiFWToB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:44:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64FF69259
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 12:35:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m68-20020a253f47000000b006683bd91962so407312yba.0
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MAXurkH5YIvUK83RyTev2ultyjV4VR5HwNSHHeg+BOM=;
        b=IakdnuylQHewX6zbazfIuobiRafKXKDncjqAHOQxKP8yKpKuxaoIu+6B1PwspzEnDP
         o6JCgYyKVvuZIkeL5TFY1y0WNMAbwrcvvBiX1u1f/fRd0Us9+YAOx/Rfme1wEl1sIq3r
         5J3mluZKzaq3bELEhIeQaE29gSn8SlXBZVvUXKidWzx3VuVBLKeCQZNgBEG+EWH11p+v
         CvbzlO4wQDEG96BiKyJ2oQegSLJfxqHDEp7USBV90yqSFN9Y0h7LEXxwArCG31WWTHV5
         F5nSorm6D50d6F/Sjiq5dUJ/Mt1pdhkldJR0qfturCby2OXCV/X8rayfdcKFAJUI/K+R
         qeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MAXurkH5YIvUK83RyTev2ultyjV4VR5HwNSHHeg+BOM=;
        b=Vgw79q+nI+3xP/49hO3t5Sc5FOuEp/ZssEavVhe8B+D5fPjvbFjOynueN2RZhBdeM5
         +DIryvYlWWS5a9ks6XoKdxB9sZDHwEw+1yoHyTBftnwIOH2tVB1co3fHoduHIBqQWvPH
         RhcHg/Z8Dhza0Iah8ULo3YmOfzHR+reM7MfFeHEb07dNnFqExSXXc3cvN7WgkjW32MG/
         VlOboH1T9gLQOakaphM3nzulBagrRe+/qtd3h+AUplDXWkRPxvg8WW2Y0G9v7xSAY2fG
         RpH181Mang9TIAAlopOhpH1KWUN1pHTRumeAPGJEq0gg0aXK8juZlMmRWlqmyJupJkqb
         yePQ==
X-Gm-Message-State: AJIora8M48n6gaEu7069V3ngZcl29rLX/XzcsJnniKfxS7vDa12oVCGo
        i5oWGEaXqikS9RaYZXMHUOPGCxRKEwZ1pg==
X-Google-Smtp-Source: AGRyM1u7QOVUPg40OzyXpOoyLbOM6XsfPIyZL609yXeNZ3Glxmj44h5MO+fyLIsKltJOC4wP7RkhfHxQENoXbg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:1b4b:0:b0:317:a2dd:31fa with SMTP id
 b72-20020a811b4b000000b00317a2dd31famr12613260ywb.476.1656012942007; Thu, 23
 Jun 2022 12:35:42 -0700 (PDT)
Date:   Thu, 23 Jun 2022 19:35:40 +0000
Message-Id: <20220623193540.2851799-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next] raw: fix a typo in raw_icmp_error()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        John Sperbeck <jsperbeck@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I accidentally broke IPv4 traceroute, by swaping iph->saddr and iph->daddr.

Probably because raw_icmp_error() and raw_v4_input()
use different order for iph->saddr and iph->daddr.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: John Sperbeck<jsperbeck@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 027389969915e456b0009e2a0b4ad81afb836e9d..006c1f0ed8b4731a8c64de282409e4bb03a6c1a6 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -278,7 +278,7 @@ void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 	sk_nulls_for_each(sk, hnode, hlist) {
 		iph = (const struct iphdr *)skb->data;
 		if (!raw_v4_match(net, sk, iph->protocol,
-				  iph->saddr, iph->daddr, dif, sdif))
+				  iph->daddr, iph->saddr, dif, sdif))
 			continue;
 		raw_err(sk, skb, info);
 	}
-- 
2.37.0.rc0.104.g0611611a94-goog

