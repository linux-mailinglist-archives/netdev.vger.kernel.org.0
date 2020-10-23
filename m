Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9E9297369
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751444AbgJWQT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:19:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751432AbgJWQTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603469994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jCJUphoZC6wP0NOCdpMMAGCeMSBb6Vp0HwVzxHnJ7Gw=;
        b=i0grpVSfUbnjQ7F32aZXx9ht0QlNrxUTe6u8Rtew30Aant+uZSeYeVZ1W2XM7fbu9KK13x
        uiFrXlBDgJ9BUnZ6Q/TXWYluyNgsOmUsgRVGuiAKvXF5gkWP6dEtHQr8Yni63a/UKeesp/
        NR5wTJ+j+rNM5wPdYam07/cA34C7ZIU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-pcd8BeN7NaeesoXI0u6rJA-1; Fri, 23 Oct 2020 12:19:52 -0400
X-MC-Unique: pcd8BeN7NaeesoXI0u6rJA-1
Received: by mail-wr1-f70.google.com with SMTP id t17so762767wrm.13
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jCJUphoZC6wP0NOCdpMMAGCeMSBb6Vp0HwVzxHnJ7Gw=;
        b=f5EfKJas3zyMYZDos+Pc8tjoTAqhXCx3EG+JfnHFeG7c0Wp+Ruie50cw2TvEOFmDt8
         QHxfFYTNufZz+uc21Rz/0eyTqvrsH15pyK7lmHl0FmThSGboEwflfIu3YTnWOjmulayg
         yqMLgE3IVugGTQUatWAIwqw3GXW47K0tnM0DGo6SluPZEbaZO6uoyVyU87ZbUYU5jLaA
         c1Q7czVxVjpsYp7BT4xK07uKrQEcKRmHOw8ZLp51RjWW/YTqJ2tq82gvjX55uwJc3wsQ
         /fUXaqcehMMjJHZnl5jwmbZ8g/0sz7EuQeeKLme8IGyeKBNkJeeumE7pijyYtbp8bUef
         Je1Q==
X-Gm-Message-State: AOAM532BIJcsN/JZjTfXIpguqFKL3I4HcZwL0FxSex8DuRNfYPB+XX/T
        2jhjxxhTTH3TShZwiZagWqm0HpogACvKX/9dYQwVhDqoJDPhuSvSkqaMLAW5jpgojqxrJb/vfxy
        Cysfq5JaamxJ8TNTL
X-Received: by 2002:a1c:2901:: with SMTP id p1mr3238521wmp.170.1603469990914;
        Fri, 23 Oct 2020 09:19:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSSULruBEujHAlyTwQ9URD4P2RlT6XdcB7Ycue/VY3d4czf7q/+07R2Opgfl9rt/zcRFXr8w==
X-Received: by 2002:a1c:2901:: with SMTP id p1mr3238501wmp.170.1603469990713;
        Fri, 23 Oct 2020 09:19:50 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id t83sm4333594wmt.43.2020.10.23.09.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 09:19:50 -0700 (PDT)
Date:   Fri, 23 Oct 2020 18:19:48 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 2/2] net/sched: act_mpls: Add softdep on mpls_gso.ko
Message-ID: <6a93961e8f247ff17a83ab08375eba71308ae75d.1603469145.git.gnault@redhat.com>
References: <cover.1603469145.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1603469145.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
packets. Such packets will thus require mpls_gso.ko for segmentation.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/Kconfig    | 2 ++
 net/sched/act_mpls.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..b08b410c8084 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -879,6 +879,8 @@ config NET_ACT_CSUM
 config NET_ACT_MPLS
 	tristate "MPLS manipulation"
 	depends on NET_CLS_ACT
+	select MPLS
+	select NET_MPLS_GSO
 	help
 	  Say Y here to push or pop MPLS headers.
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index f40bf9771cb9..5c7456e5b5cf 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -426,6 +426,7 @@ static void __exit mpls_cleanup_module(void)
 module_init(mpls_init_module);
 module_exit(mpls_cleanup_module);
 
+MODULE_SOFTDEP("post: mpls_gso");
 MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MPLS manipulation actions");
-- 
2.21.3

