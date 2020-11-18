Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2F42B881A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgKRXGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgKRXGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:06:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3569C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:06:53 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 7so5189097ejm.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=1EfTlVlLIu/jZ+jHq2fG+o4I+4FrYLMpEcBCsWlyTuc=;
        b=dtkxmnCy3YiyoOBFdUcdnpkWD+Fq2ktGazMN1FkVdeN/Bzo96ZfgSnnqO/TWf926ZR
         EHWwmftyeWkdxNShKNPG9NR/09zQE1C4r1UVoPdYDoSM5cmrWk4YgGA9PG6V7CcGd0ot
         fG+eCpCF+kIl50WtcNy1bvADkqiVVuOPZ+hAS5gP24c7OiXaiXYQZeTexAAny++pj46B
         eL2OuIkrAQHbSNla76eFe5zdmrGqkas5N8FQD0vvosyn+EeQ1SpjHdSiha4vai7IkO0R
         vDnQItA5u+AozL2ic2mQGtqvP+751eqQnaFMH9Ch2XbhXB45Gkuq5MvBSu/zV/PHh16n
         Y4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1EfTlVlLIu/jZ+jHq2fG+o4I+4FrYLMpEcBCsWlyTuc=;
        b=MTdw6wRpWiJGVdnwKO6jvYL31VZc9Ied6S9LgXirAzTz4Hhv3nV+723jdzXUMp5WDz
         HhkQlNDXRmf0Jg4sh/QJXtV/k8bQpFm3G8SEVwqYAoqA9iTjGKCroGzPXuSDSmRDIjTg
         OeaSES6m6qY/rAHstgq3p1mZL+FLFCfdNDDZjDaA4WLgAqNSr9vG/4lgfCgKXn2DSrWu
         GPz7ASX5Wj0j8hYhDf/x/QAjEyU+vRd4KM9lmkiXPQCxVVAvIYcDQ8V18JhjWF4PfFXO
         PrpkIFKHSRY4vt2hQiKTOyuFOFWtYxQKEHnSyawsG6qIKaLB2f+xNHA5dvUJKdDdipFX
         YPKQ==
X-Gm-Message-State: AOAM533bcekuzDituUCCxJ+3NwupEZ+aoG5LTvuicU0rSi19gjjYwH8m
        kl25Gi4X+Q/SAe4SVHBYfVYxpfuA3XHoHg==
X-Google-Smtp-Source: ABdhPJzmVYPQN8UQtkS1LIQb88lxMSfXvsLAgTul7/fxb6iJLWN4ywWj3zi0UJeLl1evwX6W1quwAQ==
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr25430676ejz.97.1605740812528;
        Wed, 18 Nov 2020 15:06:52 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id u17sm13523440eje.11.2020.11.18.15.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:06:51 -0800 (PST)
Date:   Thu, 19 Nov 2020 00:06:51 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: [PATCH v4] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201118230651.GA8861@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an IPv6 routes encapsulation attribute
to the result of netlink RTM_GETROUTE requests
(i.e. ip route get 2001:db8::).

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv6/route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7e0ce7af8234..64bda402357b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5558,6 +5558,10 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 
 		if (dst->dev && nla_put_u32(skb, RTA_OIF, dst->dev->ifindex))
 			goto nla_put_failure;
+
+		if (dst->lwtstate &&
+		    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
+			goto nla_put_failure;
 	} else if (rt->fib6_nsiblings) {
 		struct fib6_info *sibling, *next_sibling;
 		struct nlattr *mp;
-- 
2.25.1

