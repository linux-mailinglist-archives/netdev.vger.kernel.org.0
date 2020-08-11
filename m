Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B60241792
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgHKHtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgHKHtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 03:49:18 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4539C061787;
        Tue, 11 Aug 2020 00:49:16 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id j10so5523284qvo.13;
        Tue, 11 Aug 2020 00:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOMSJE9xSBil9mXDx2Lia4KUqWqXBp/e2t+xm7m3Qh8=;
        b=F1f7ZE4KDjPF6dImWkq/5Gb5Ibw/zsrD+Y+bAFrUMb2y8iUJult1fm9hB0McdzouIP
         JdDgEL1T2JKzUfHwWYdBwmkOObOmECVPSE43vBjnO8kfMo4FuMKCwhbmdiKeIPv5iz7L
         IE25z3GCJwOCUWTeQCgIZMZ8PIMkHN+IFDgY8wMNCbsC3ngJJuI7/lB+STIlvY2ysxqF
         ldKh+gEuY1fZUGum5vnuiVAGZ4fX/Dcx3RTT3RcYeK3t/7XuKa7ZhV+D86LSpYOVn+GG
         d4Gr2ojxTkHSGSiIKscJVFKq+vyJBGOqJiFz5iMLUNPcjV+SCQjFLjVaYbqOvQ2CLPI0
         j6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOMSJE9xSBil9mXDx2Lia4KUqWqXBp/e2t+xm7m3Qh8=;
        b=flffocutCjA8Eh/YhJjeeEisxilaDpD54uIB0rnaNZKZhgAI+2mUwerOTKh5An2PZN
         uAksgfqeCjsrnaXkxZ5Uj/vw1sztRuuqDNjsBObnL8DsbokzJ2YmEvQrMt5YCxewtSDh
         W8lQ2VGHlKygEnEeqvHNC8wXbdDWzYTl4RthsM0OGW2vUF/a8PudBG/iSKb7UCHmahdu
         5og7JaWHHQtwHWlxaFoUgp2Dwx45TgTSYTAXB/nrkxkEZ5yz05LsELPIeDwr8uGC7qZK
         L7Axf3AOH++f2uKTWnNDstFyZeEJi+9U0DQwMKSVIaB1fHxEc2p4Cj85UgEG/NX6giwV
         ri3Q==
X-Gm-Message-State: AOAM532QgwnoCPJwf/LOypc3EMRh6W0/B23UvvQHcQ9fNADavzMj2ouz
        aa7W7TY0Aa0buECBd7gC0Q==
X-Google-Smtp-Source: ABdhPJyKvjIhgKI2nli71gIsO+GWvcApvoJ6Cm7TU2kBmCv9kYz8IAaCuRaLy8t1HOMGLqJIMFiQtA==
X-Received: by 2002:ad4:44e5:: with SMTP id p5mr32058968qvt.197.1597132155990;
        Tue, 11 Aug 2020 00:49:15 -0700 (PDT)
Received: from localhost.localdomain (146-115-88-66.s3894.c3-0.sbo-ubr1.sbo.ma.cable.rcncustomer.com. [146.115.88.66])
        by smtp.gmail.com with ESMTPSA id j16sm16693897qke.87.2020.08.11.00.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 00:49:15 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net-next v2] ipvs: Fix uninit-value in do_ip_vs_set_ctl()
Date:   Tue, 11 Aug 2020 03:46:40 -0400
Message-Id: <20200811074640.841693-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810220703.796718-1-yepeilin.cs@gmail.com>
References: <20200810220703.796718-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
zero. Fix it.

Reported-by: syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=46ebfb92a8a812621a001ef04d90dfa459520fe2
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Changes in v2:
    - Target net-next tree. (Suggested by Julian Anastasov <ja@ssi.bg>)
    - Reject all `len == 0` requests except `IP_VS_SO_SET_FLUSH`, instead
      of initializing `arg`. (Suggested by Cong Wang
      <xiyou.wangcong@gmail.com>, Julian Anastasov <ja@ssi.bg>)

 net/netfilter/ipvs/ip_vs_ctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 412656c34f20..beeafa42aad7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2471,6 +2471,10 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		/* Set timeout values for (tcp tcpfin udp) */
 		ret = ip_vs_set_timeout(ipvs, (struct ip_vs_timeout_user *)arg);
 		goto out_unlock;
+	} else if (!len) {
+		/* No more commands with len == 0 below */
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	usvc_compat = (struct ip_vs_service_user *)arg;
@@ -2547,9 +2551,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 	case IP_VS_SO_SET_DELDEST:
 		ret = ip_vs_del_dest(svc, &udest);
-		break;
-	default:
-		ret = -EINVAL;
 	}
 
   out_unlock:
-- 
2.25.1

