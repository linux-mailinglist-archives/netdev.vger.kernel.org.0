Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B7A5141B9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242142AbiD2FU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiD2FU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:20:58 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6081066FA8
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 22:17:39 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p12so12110763lfs.5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 22:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s9wfiyI3JBIiISlABF9nzSzidRhd08PN5K7/7gRJUwU=;
        b=zgh0lqmxqjAmYpfMJeInqwyar5RpKgn6nKPhjU0zE/mRkRAEOsvk01q11mzTkDptGi
         TwBcOx3EARcSI0hAy15m/EW2/0NDVnNDO95agwC6gbWdQLW4BjUE7CMli5n1iR5y8wOa
         g2LGTfB+wEs9BisfMzb6MrrgDQhrA5OanuAZ+TT5md3h2aag3jDAPyzctlDCCG97MKPQ
         e06ZJtfPG7utnP0hWSxpaUVfENEu7U2BcFuBCJbGdkJRiMjrPXJVr2P3nK0MraYFi6sz
         dmNYSv5MxKsD7AUI5Bf0T5Y0G9OWIbekQq8sNqNLeTRfjuqk1lZZeNVGgx24s+tILIfP
         7Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s9wfiyI3JBIiISlABF9nzSzidRhd08PN5K7/7gRJUwU=;
        b=c7U4eN/ZAQIQhy1BAgGcZAtBnpTHZN+UqLY/ROun7ly1rHaQRw9LdQKdTyMhRt9c+t
         MOb0F3QNp56lVVp30qJf5ID1Z+cjPoZsrz6iLTpvKPHfglzrjLBBNQyOn7Txx1AySb6Y
         Ez2P9ACbqCmphouUj9dtPixnorCTFDwmojIMR7V/WcixiUH6b6jLSIccgM+nsn4YhRoO
         RNPwrD0shErQ4ZlCd8Fw4gNiy0DpgHVa5HK6Yvwu19h4inNt0dZ4FO9aqtygxDUriBZW
         pUybDvPjy+8rOL7H34ghpJCKSLjY5R0puyPeuRBIoL+uT+cByrXWh/X3BtP+pTs+lTZn
         6KFg==
X-Gm-Message-State: AOAM5316JhZ9TyEFEnf/TF9sqmDRmyDtnPjyc3PjqJlwY2QmXPf3N3sw
        TSdxFcwi36UCiaPDOU6YYl2tig==
X-Google-Smtp-Source: ABdhPJwelcg5eDVRHLImUr0uIk1M3llTR4bkoNPEBZ5hH7LEHpAFRJhhOG5cuBf+CacuskRyT5R8Qg==
X-Received: by 2002:a05:6512:902:b0:46b:c03f:19e5 with SMTP id e2-20020a056512090200b0046bc03f19e5mr26524304lft.118.1651209457725;
        Thu, 28 Apr 2022 22:17:37 -0700 (PDT)
Received: from [192.168.43.196] ([185.174.128.251])
        by smtp.gmail.com with ESMTPSA id y14-20020a19914e000000b00472085bfdf4sm141451lfj.133.2022.04.28.22.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 22:17:37 -0700 (PDT)
Message-ID: <0b28d49b-605c-ac1a-df85-643164e69039@openvz.org>
Date:   Fri, 29 Apr 2022 08:17:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: [PATCH net] net: enable memcg accounting for veth queues
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>, kernel@openvz.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <1c338b99-8133-6126-2ff2-94a4d3f26451@openvz.org>
 <20220427095854.79554fab@kernel.org>
From:   Vasily Averin <vvs@openvz.org>
In-Reply-To: <20220427095854.79554fab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

veth netdevice defines own rx queues and allocates array containing
up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
is quite huge and should be accounted to memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d29fb9759cc9..bd67f458641a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1310,7 +1310,7 @@ static int veth_alloc_queues(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL);
+	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
 	if (!priv->rq)
 		return -ENOMEM;
 
-- 
2.31.1
