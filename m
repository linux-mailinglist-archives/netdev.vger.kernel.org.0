Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9522B00DD
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgKLIKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLIKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:10:11 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D2BC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 00:10:11 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id ay21so5163861edb.2
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 00:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=FWxk2gGd5JJaGbG2Vq5urHCAquc6jphaxfHbKJfxVsE=;
        b=R6msML0oqqygdle0hM4Y4r8kZTqxnCq6G9Ij2ASMUC3L21YfnBsNOvs6HSai+W/zQN
         7+miMsg9ds9A8WAKNjKuZHFn0qJIU6AERRo/td5E7/nTuI4NJn5S0QhgS/fyEbvWcWBX
         pbdJuGoVzOZhnt4BpnpqrFrWNC7thT0b37rhPd022MsOCoHwspqsv8cyWlcTN6fC/enQ
         Loh5sf5DhXd14B1XegagLid5zTiqlc/CwvWx/PowNH/l+0HfOXIS/+t7z+9HwSl7tU88
         pYIZ8JrHNy59LkdD8EewYDwaAmeRBqj2UV42WidH9ffetoveEOy4rv0fLdj9FL8NXwBf
         hkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=FWxk2gGd5JJaGbG2Vq5urHCAquc6jphaxfHbKJfxVsE=;
        b=VkE4Nb5pmE6+H1lhodF9o0WDa2mOL5JVpRc3hHtesVuYlOT7fiuIafuwsK8BJ8eqSD
         nnbSugQ3j4dgvFjMycYwe0/OGYG0JqxEGxTaol5HEnl3eWHlGFJe8fu6guremNbfJAQ5
         6kcONH5QI6eHqa047WFI+yT5AYUJvppwVV0188/r9XPZVTKETScysKQiJs8fgVxzzB4M
         f6EL/Yc9GMXXhxrtScWbSmY3ksbe4Lh8DJnpckPDe4kYAcRbcLWAy3sqHm+nlW06DnVq
         OX9vd+ySzhy/UdzRO+GC9gnXVwo8J4K7kHgvHj0D2MDGGsWYQFDwyKN/KQOpuPAm+3qR
         gRVw==
X-Gm-Message-State: AOAM531b4KoxsZcI66nhVnWCFN+hqEQ38Hx2Pp2ZR7kFRsfcGaaxYUQW
        KJdIZzN2eeCmW6ch1o7kA/0=
X-Google-Smtp-Source: ABdhPJwITNVaai69O/51Fn3TRM80+gnNWaMJWAmYnW/4WJ7feD8UIddxM6Q2V/Ya61MgeL4WxEXEtw==
X-Received: by 2002:a50:d885:: with SMTP id p5mr3675713edj.169.1605168609484;
        Thu, 12 Nov 2020 00:10:09 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id rn28sm1789892ejb.22.2020.11.12.00.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 00:10:08 -0800 (PST)
Date:   Thu, 12 Nov 2020 09:10:08 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH] IPv4: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201112081008.GA57799@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an IPv4 routes encapsulation attribute
to the result of netlink RTM_GETROUTE requests
(e.g. ip route get 192.0.2.1).

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv4/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dc2a399cd9f4..b4d3384697cb 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2872,6 +2872,9 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	if (rt->dst.dev &&
 	    nla_put_u32(skb, RTA_OIF, rt->dst.dev->ifindex))
 		goto nla_put_failure;
+	if (rt->dst.lwtstate && lwtunnel_fill_encap(skb, rt->dst.lwtstate,
+		RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
+		goto nla_put_failure;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	if (rt->dst.tclassid &&
 	    nla_put_u32(skb, RTA_FLOW, rt->dst.tclassid))
-- 
2.25.1

