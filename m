Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D866228A22
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgGUUre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:47:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726658AbgGUUrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595364450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vJQdVCFU+bbg1bLHFMdzaVvzuHDTychMnPcWRjdwPXE=;
        b=EGTFod0AF3XfN9NhoBOa4u2jowPoicfREoQN3Gfr3Q0Ih1LJRAE7kVIYGP0rUO/z4rJk8d
        X1vNn1ol0DXp0OMCxYtTVffj4lK13xv9CdycslrCL1Xllt54KlT6fycmddfrXyXkR9nvF6
        wHWvowedYhqWC1IPi0yIKCB7nfZ3UKo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-U-e2p-HlPMKSsnl5nLLAcA-1; Tue, 21 Jul 2020 16:47:27 -0400
X-MC-Unique: U-e2p-HlPMKSsnl5nLLAcA-1
Received: by mail-qv1-f71.google.com with SMTP id u1so43371qvu.18
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJQdVCFU+bbg1bLHFMdzaVvzuHDTychMnPcWRjdwPXE=;
        b=X3OvYDrdx5yZCWmfAhonIFVaYBF0o3a0CzIInzl10kBBsh4evhqsJqAHt5NneZfD1o
         TiED0LP3Fi89NWJJzSliUUFxZfgjHGCWO2QEgfqomgyJfkDaIHXxEUCp34difRtYXH3D
         0Cldqx1isQIOL2aRtPcZ1vRmv0J8krLtY8dFZTOkS/poJ+XC0D87h8rRTV8edDFKCucg
         S47SAYXKWwX5qR4JVU/ZN2z1JnmtgnYvKZ9jVHjPDQ/M39w0kWc+JEz7nQ4Xg9Hwxnxq
         6l9QzOkFAHZpInO/OubOXFDDXayuqcNqBq5eSxaiGjXGElrRr4aLpogztrwkw1aVr7AO
         lIQg==
X-Gm-Message-State: AOAM531CqlyR+jUFmm3C8D5/ihkLbOJV0gRuOfg5E8WQpn5Pqipffy/m
        BOWmyAFcTBmKXh1/iyMbT+Ne9OwfsxLHLvnypQt0Dxs1eCStTQd5UvlNP9lGmVujLrBD7LfAfby
        UHpWEiak9JNoOqksb
X-Received: by 2002:ad4:458a:: with SMTP id x10mr28322119qvu.223.1595364446677;
        Tue, 21 Jul 2020 13:47:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygQOKEOiEw1Sm7Q966C1eHUbaxdV8Q8TNJehm6XP/ZzoJqq/cPLBShuRJKbZI5HehL42Biew==
X-Received: by 2002:ad4:458a:: with SMTP id x10mr28322104qvu.223.1595364446452;
        Tue, 21 Jul 2020 13:47:26 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id u6sm24008373qtc.34.2020.07.21.13.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 13:47:26 -0700 (PDT)
From:   trix@redhat.com
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pablo@netfilter.org, kim.andrewsy@gmail.com
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] ipvs: add prameter name to ip_vs_enqueue_expire_nodest_conns
Date:   Tue, 21 Jul 2020 13:47:20 -0700
Message-Id: <20200721204720.7818-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Compile error here

In file included from net/netfilter/ipvs/ip_vs_conn.c:37:
ip_vs.h: In function ‘ip_vs_enqueue_expire_nodest_conns’:
ip_vs.h:1536:54: error: parameter name omitted

So add parameter name

Fixes: 04231e52d355 ("ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 include/net/ip_vs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 91a9e1d590a6..9a59a33787cb 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1533,7 +1533,7 @@ static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs)
 
 void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs);
 #else
-static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs) {}
+static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs) {}
 #endif
 
 #define IP_VS_DFWD_METHOD(dest) (atomic_read(&(dest)->conn_flags) & \
-- 
2.18.1

