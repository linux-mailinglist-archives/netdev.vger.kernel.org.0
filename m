Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92CD44D3FD
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhKKJ1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKJ1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:27:04 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AE3C061766;
        Thu, 11 Nov 2021 01:24:15 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q126so4658180pgq.13;
        Thu, 11 Nov 2021 01:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jz69xIULvh5ivMKWg9VPctkb7RXwt7Ipe5sMHPCXLOA=;
        b=Z/TBS3VabaqAPHwNPaw9i4qGg3d5sDiqv1AAfx7yS7weTwJLz6lp9ExS86LfqXp9zz
         lr/Q/81o4A8P8sOxTEb3mGQrc/m8kkaWNHf22SYJqKjROZWXvxXlxy3ItqiVZRIpRsuy
         VfPo9UhImCxpq/E+9VFFoCjoiBh+DUm7+ynvlaQA0Ei7gY5sHpEokPHwALIkikJFZE+G
         IfzjaO/ES9IxLuIu9hsCX50VbknMRDWBa7yIzKNQlHPZ+p3Qjc/YKa7dttZ6rDxT9X96
         klaghGOpbKgxKLW8M9Lnhfp4o6BUPb7opFCBnr5JIHuiAV7zJSLQ7vSNxT1U7nN+6z6M
         exOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jz69xIULvh5ivMKWg9VPctkb7RXwt7Ipe5sMHPCXLOA=;
        b=WfqTwCRU9Sw+POa0jdSWhVjT/xrRNSIt/s274bGIJGKQtST7eqw2fACeZ3cSCTPUVI
         J9lyl8aIxoe3q2EJrONDXX+nr8gz5QB0polO5qR4RV9dcSueOBDiC4BOoEk6YNJtpyTy
         WkLzKto+1sU9e52LRHkgXtW+IbhtqCAsTtYAl05Gv2yLhMG0Apt9mATOchYJsa8BWfAj
         8f7vh+Tadn6jjBYV/rwWOGfYr6So66q6Wqf8hL1yMzWxQezj9d+zUju6zL3ZP5Faf8Ib
         FvetMJlVOTg1Yf908karK4cFvfDaxdzEtFNrs+Y+SSd4TnDeY1l342uCmch9sEPKPbpS
         FKug==
X-Gm-Message-State: AOAM531Rw7Rx9MkVBvOzNOX536qUwEarh67YvXJL+2zBxlANCZzS+h9j
        FhOgPcE757ujLCT38htqDPA=
X-Google-Smtp-Source: ABdhPJx6KnI3PRIq3MoPDsKWdX0lKsiIMEP+VGxelbE/VoZU30ku2LycRqr2IP+r8xX/aMJTN08JcQ==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr3715944pgi.341.1636622654956;
        Thu, 11 Nov 2021 01:24:14 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i185sm2379525pfg.80.2021.11.11.01.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 01:24:14 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] ipv6: Remove assignment to 'newinet'
Date:   Thu, 11 Nov 2021 09:23:46 +0000
Message-Id: <20211111092346.159994-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The same statement will overwrite it afterwards. meanwhile, the
assignment is in the if statement, the variable will not be used

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/ipv6/tcp_ipv6.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b03dd02..80f1fbb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1261,7 +1261,6 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
 
-		newinet = inet_sk(newsk);
 		newnp = tcp_inet6_sk(newsk);
 		newtp = tcp_sk(newsk);
 
-- 
2.15.2


