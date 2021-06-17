Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A1B3ABDFF
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFQVaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231319AbhFQVaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESlzoBrCtV1p5Bz5L61JWXgmG5edOzrWTpf13f6lwsQ=;
        b=EUNzvsFw1gUIvG2m24sl/ooKd0gr/8H4zQ7xV3X+3nUQMQ3pemtMyGQYnUwe0UpCDk+MAb
        hrTFNdCiHlBjvTPSE5Yec49g3fVC1LcqQzabvfS12SIH/1RxIONYQMhGgHNX6e7r39KGVC
        5h9UwmpcYgvw5XrRG41kQdwJ/sc4C4E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-RAlx-oEhOrCWzs-0P0Ozbw-1; Thu, 17 Jun 2021 17:27:57 -0400
X-MC-Unique: RAlx-oEhOrCWzs-0P0Ozbw-1
Received: by mail-ed1-f69.google.com with SMTP id cb4-20020a0564020b64b02903947455afa5so577617edb.9
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESlzoBrCtV1p5Bz5L61JWXgmG5edOzrWTpf13f6lwsQ=;
        b=Wdm4UeVfxkAS3u2CiQ8Rj4TOV/RpDPQ1CxyRnsda2JhSnZxGj8O+eTp3JW2/6A/ufX
         7hZybsG3ZFDeNvEVRYJ7yZBO2TRRR1CpMV4EnY9alQEJKupvlzvsOQKXLltCpqv/WAXC
         Mb99h6hoQbKcsK2Rd/LmskWtmt9t6GuisOObSb+Bn5BePLgPm2KdIDsxj5TZd19bBLub
         NzmpuveqkKmn+94nhP3idV6qCmB2cZt05xiSVgEvf8S/HSxC7nlFfnB3fBI6dIwqzT88
         VTOt3GZ1FHSelLqTkjlCYkNATztOCk4WdIO5+Ylt+byg2a1ZnSxkT41LQOJweTgtlSHS
         3OAg==
X-Gm-Message-State: AOAM530+o2lIDdTve3PPHn8Su/y23pz1Bl9xVT54iZsDU5zwFNC5Jv0I
        THY0I6Zzu4l8uKPKJ4s+bVtw/8S4Qc/5OBOQCikIdILNPeoAStuYKXHHZ4TKm03/St5Ge4GC2yu
        u6nDD+usZ4rJCOxbm
X-Received: by 2002:a17:906:b03:: with SMTP id u3mr7263305ejg.95.1623965275935;
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVq90bXdFT/ATvZR+KbPRvFhmdGeDC2xS3RJdzmjp7zYHS+Yy5ZefFxwZeuZ2Lr3aFcVh7Nw==
X-Received: by 2002:a17:906:b03:: with SMTP id u3mr7263295ejg.95.1623965275782;
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h9sm5028627edt.18.2021.06.17.14.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 775961802A5; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v3 01/16] rcu: Create an unrcu_pointer() to remove __rcu from a pointer
Date:   Thu, 17 Jun 2021 23:27:33 +0200
Message-Id: <20210617212748.32456-2-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

The xchg() and cmpxchg() functions are sometimes used to carry out RCU
updates.  Unfortunately, this can result in sparse warnings for both
the old-value and new-value arguments, as well as for the return value.
The arguments can be dealt with using RCU_INITIALIZER():

        old_p = xchg(&p, RCU_INITIALIZER(new_p));

But a sparse warning still remains due to assigning the __rcu pointer
returned from xchg to the (most likely) non-__rcu pointer old_p.

This commit therefore provides an unrcu_pointer() macro that strips
the __rcu.  This macro can be used as follows:

        old_p = unrcu_pointer(xchg(&p, RCU_INITIALIZER(new_p)));

Reported-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/rcupdate.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9455476c5ba2..d7895b81264e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -363,6 +363,20 @@ static inline void rcu_preempt_sleep_check(void) { }
 #define rcu_check_sparse(p, space)
 #endif /* #else #ifdef __CHECKER__ */
 
+/**
+ * unrcu_pointer - mark a pointer as not being RCU protected
+ * @p: pointer needing to lose its __rcu property
+ *
+ * Converts @p from an __rcu pointer to a __kernel pointer.
+ * This allows an __rcu pointer to be used with xchg() and friends.
+ */
+#define unrcu_pointer(p)						\
+({									\
+	typeof(*p) *_________p1 = (typeof(*p) *__force)(p);		\
+	rcu_check_sparse(p, __rcu); 					\
+	((typeof(*p) __force __kernel *)(_________p1)); 		\
+})
+
 #define __rcu_access_pointer(p, space) \
 ({ \
 	typeof(*p) *_________p1 = (typeof(*p) *__force)READ_ONCE(p); \
-- 
2.32.0

