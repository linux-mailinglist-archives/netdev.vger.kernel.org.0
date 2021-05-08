Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC025376E8B
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 04:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhEHC2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 22:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEHC2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 22:28:24 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6835AC061574;
        Fri,  7 May 2021 19:27:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a5so2139771pfa.11;
        Fri, 07 May 2021 19:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uqMc5TvTB6yCdyyHMniBnZIZU+s48UD4fCLr5hBdMZQ=;
        b=Lnon4udLZ6q+y8nRL31yw6YDvb0EgZOfmfoVJcNtq2/wTv3RHE1huDbT7BA78ckQb1
         F35HmiWMRxAz81ZCJf7PJ283mEdqHBfyuOmbLtefP4rgg8lnQI12qYGNK6A7ferPlOwI
         3RNi6LzhBPsU4Qwfc/RxT8pA8/OHRvE3145v518h+kZwPOlQWwAeCENKu5sZ+hIcBs4K
         VLuDm3ZBae94FRFZGcp9Z37Q9SiDUkjLQq7ZTK6tkPVt/JzfzZ8oTPbtHbSG15JnKbnW
         o9JGKQPLxNQ88Cpn05l91oqkgWmt0+pXZPubj0g+b2IqZdeoL/loo4sHL+04D01esJOX
         fmQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uqMc5TvTB6yCdyyHMniBnZIZU+s48UD4fCLr5hBdMZQ=;
        b=Uuo2Z58LeD8ecuijqp40DHrf6eK/BU/VdTdZzlCFnVzy4GZXM43zjoF5VCZMlur8iw
         lT4i6ps/A2hjGqYjhDOCwTLyrRptPU3W9in998C3mzXb1MHKS8sKvDMNzYZEuwGxNhoY
         WPRpYPYtaB2nniKJBAOdszfZn/RZRHJCNQ6cLUJcqwVu0uHEqZmCtGxjkL3GRjG3ZFYp
         FjD1oh9e0UlFuIYBWOIrq0CCq86UqjAk4yrj5GlBjGo9mEXjli5QlGhM4KqHEELCc0uB
         0XC5AY2MHucXhgtwO//y2LUaMQWtLT+JZUP/vklCBWV/Sj95CWON3HfXyM3b1YbeCXwb
         Yd1A==
X-Gm-Message-State: AOAM532qCDYa3ONhI/vSu25vRn9DTbkUh6it6xlAgTLLeA6WkWSJ62VW
        mmNcMqMCfZn11i+sklLRbJY2R6j1D02l4shs5u4=
X-Google-Smtp-Source: ABdhPJyQMHMM53r4A9ThiGrO/8Q2pReCTcBVaaM5pd9PQhKcIKU+FQXuLUcD33tbAdWXUPdTAM0e6w==
X-Received: by 2002:a63:cc43:: with SMTP id q3mr13240897pgi.50.1620440843080;
        Fri, 07 May 2021 19:27:23 -0700 (PDT)
Received: from sz-dl-056.autox.sz ([45.67.53.159])
        by smtp.gmail.com with ESMTPSA id t19sm5884811pfg.100.2021.05.07.19.27.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 May 2021 19:27:22 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
X-Google-Original-From: Yejune Deng <yejunedeng@gmail.com>
To:     pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yejune Deng <yejunedeng@gmail.com>
Subject: [PATCH] net: openvswitch: Remove unnecessary skb_nfct()
Date:   Sat,  8 May 2021 10:27:07 +0800
Message-Id: <1620440827-17900-1-git-send-email-yejunedeng@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need add 'if (skb_nfct(skb))' assignment, the
nf_conntrack_put() would check it.

Signed-off-by: Yejune Deng <yejunedeng@gmail.com>
---
 net/openvswitch/conntrack.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index cadb6a2..1b5eae5 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -967,8 +967,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			if (skb_nfct(skb))
-				nf_conntrack_put(skb_nfct(skb));
+			nf_conntrack_put(skb_nfct(skb));
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
@@ -1329,11 +1328,9 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 
 int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	if (skb_nfct(skb)) {
-		nf_conntrack_put(skb_nfct(skb));
-		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-		ovs_ct_fill_key(skb, key, false);
-	}
+	nf_conntrack_put(skb_nfct(skb));
+	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+	ovs_ct_fill_key(skb, key, false);
 
 	return 0;
 }
-- 
2.7.4

