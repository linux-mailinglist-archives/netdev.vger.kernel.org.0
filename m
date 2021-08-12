Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6833EAC5C
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhHLVYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbhHLVYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 17:24:31 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDA8C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 14:24:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q10so10277667wro.2
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 14:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=DPYnxriP1vdjSQbgxRf+F80mzIPWONGr6oKcTv+Pk8E=;
        b=r4+LXTdmNm6/7cdjC8uYSzy0eYZYgZ3f7IxQs7jf+1rKRiQNG7IhieP0JBOb4LBSku
         uMIGwfmEkFXQQoWS71nwEOYMrao+mVzmztnotRWTlcIwiudMrleQF2zEREOMZsakpCxW
         KbVmx6U+8/J4Qhegl4HSaB6+PhRG8fQiFgsSVlcdj+uQOcHx+VjUc59k6I23cW1uuL9B
         6LxgNa7iIVHozNFjTQKGR22U9RLdZd29MQbjZ3mu+aflu22UlzEvi1pAbvmwUAePGmlO
         dI1WSJa0ABwuthS+eyzLTpTD4ilb/CDWCkcLaReiBkBfIy2vlC6gG7YUASBvEUYybOG7
         dgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DPYnxriP1vdjSQbgxRf+F80mzIPWONGr6oKcTv+Pk8E=;
        b=UG/xPrI93Lt0qjKxTXPi/+U2+6ptbQBkP6HtaE05WlE4t+Mk0YCvviq3MA4IIpCViG
         NCNG6WCjAGRiE316HijpWeJSt1/fo3zBN5fM4M4cnEsdu2nI47Yi+xTCUg+4jOWuKb9x
         ktxehRwKM+IqG9ieoDKDipeKDlckWVW14rzKuGwX6ptV5hXbDDdSo1dpJbmzWz4QSGSK
         4kbXM7CvkZ8NFJvYAgj4rI2QMs5Ph+kp88I7xKPbJzaazW9d9Q3MJPwvk+K3c5MKwcrS
         ybo4k6H52nD3VkylCxx7roVNsJnGblg/HumhFR/swWjCxHiq+JrBJQ92FlOOUUQfbjDy
         NatQ==
X-Gm-Message-State: AOAM533gMbiZrvKsSjgORgx+qvo7XGrhAc+v0MK1wLltpBJsd12ZUZ86
        QqSMcWNS95Ni1cz30qc90RjVPlirsg==
X-Google-Smtp-Source: ABdhPJwrrbj0NgXeVsvS5LeVugg5JVaA9OC9jdYNtTdTo1OTOmhZths/ojkS6Q5YT8L2ul85QM+jkA==
X-Received: by 2002:adf:8102:: with SMTP id 2mr75478wrm.89.1628803444237;
        Thu, 12 Aug 2021 14:24:04 -0700 (PDT)
Received: from localhost.localdomain ([46.53.252.172])
        by smtp.gmail.com with ESMTPSA id t8sm4437691wrx.27.2021.08.12.14.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 14:24:03 -0700 (PDT)
Date:   Fri, 13 Aug 2021 00:24:01 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] netlink: gc useless variable in nlmsg_attrdata()
Message-ID: <YRWRcbWR45+zF9mD@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel permits pointer arithmetic on "void*" so might as well use it
without casts back and forth.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/net/netlink.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -587,8 +587,7 @@ static inline int nlmsg_len(const struct nlmsghdr *nlh)
 static inline struct nlattr *nlmsg_attrdata(const struct nlmsghdr *nlh,
 					    int hdrlen)
 {
-	unsigned char *data = nlmsg_data(nlh);
-	return (struct nlattr *) (data + NLMSG_ALIGN(hdrlen));
+	return nlmsg_data(nlh) + NLMSG_ALIGN(hdrlen);
 }
 
 /**
