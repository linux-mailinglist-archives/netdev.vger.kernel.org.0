Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744BC3B1872
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhFWLKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhFWLJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESlzoBrCtV1p5Bz5L61JWXgmG5edOzrWTpf13f6lwsQ=;
        b=JvdeHr3ZeKjNAmk0OMjuCoWxpabr8i7XZpDKIpWuY/n1lwUgWvHHFLCO7H8rkZrsMKzcMY
        yy4SJjqwSvEUjGtU6/ofq4uw3NvVVta6dZEZm5zALkG9rT32+u1y1kMIDyIYMl6bVJ5Qc7
        7TO/fsxFuTTeMToCG6BhqSKk99dtxyA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-D1rlL5IKN2WEhj0whTiVjg-1; Wed, 23 Jun 2021 07:07:30 -0400
X-MC-Unique: D1rlL5IKN2WEhj0whTiVjg-1
Received: by mail-ej1-f72.google.com with SMTP id p20-20020a1709064994b02903cd421d7803so826882eju.22
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESlzoBrCtV1p5Bz5L61JWXgmG5edOzrWTpf13f6lwsQ=;
        b=hl3XUeSQd/y2kpRHvt2KNdgBgelNCM4HbgMv/KLTjxZXc8NDUBTZ7l7VyIXeTQSYDI
         LqsXcOE9e+eaTcJ7KqqYVcTC6vfLKKOBXsPBQQ0drK1BbhxBzoDd3XGIzPCcZ+M4Gh2R
         bnjclSWP+S/P+W2/5yOEl1xuZqzaiN8L4ohaxfgIorGvhRw+3LeN9L+YZg5IvcPbQccW
         0AnvM79Eig7o9CXl7gpDeO5SasxMQpidlf3hasGLj8coBp/x9W3abgVE9jGrDNdhM6zr
         Z+gqCou9PBTgfdjFoplflFna8AI1AiZDDDNkjZYRxeJIGA/Ezxfj/iSzylsWGa2oJsUj
         +sEA==
X-Gm-Message-State: AOAM533XsWWTfbNpjZGJvgyWP1jnO0E6KehxPk7V/wgnf1XaMc4SaavJ
        c/qppkGZq0ee/h3futPX7slw5Rb7liTBc1pkNWEvbxXx7Pnjt0gqITb4igl/G4DO6lIQGTpo/g5
        XqziRt0qZd3mxOFBv
X-Received: by 2002:a17:907:207c:: with SMTP id qp28mr9051768ejb.311.1624446449575;
        Wed, 23 Jun 2021 04:07:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxUlmnTLWoQ9knMdWrbhkqZubUp9BhrNkGuD5ssEZcNVY6+xHag0CjUssqmpLH5HV7XgNf+Q==
X-Received: by 2002:a17:907:207c:: with SMTP id qp28mr9051736ejb.311.1624446449212;
        Wed, 23 Jun 2021 04:07:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g12sm512481edb.23.2021.06.23.04.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 030B31802B8; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 01/19] rcu: Create an unrcu_pointer() to remove __rcu from a pointer
Date:   Wed, 23 Jun 2021 13:07:09 +0200
Message-Id: <20210623110727.221922-2-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
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

