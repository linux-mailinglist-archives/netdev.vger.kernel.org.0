Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055FD297368
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751440AbgJWQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:19:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751432AbgJWQTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603469991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JEpuK5wbf5EappTK6rQ4OSbn1qz2A6hQ1PGrAbTk7j4=;
        b=i1Z6icDnfpmjs0FiN7oeNtl+MG4NAUS70eHPpPOQr6Ypu6sm1D6HGAehORrfjchGSQ58Bu
        /VyEF2zvWeUwOWz+MRFniAlYJ20gGmX0K4+DmlVrmpl8hrSgAZHNeSwT/rCtw8EevUaeYm
        OwYJtrS0B0IGky+IxFneS7vZN5ItFIk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-ySbAQJCyPLiIhAuHzTKPLg-1; Fri, 23 Oct 2020 12:19:48 -0400
X-MC-Unique: ySbAQJCyPLiIhAuHzTKPLg-1
Received: by mail-wr1-f71.google.com with SMTP id i6so757434wrx.11
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:19:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JEpuK5wbf5EappTK6rQ4OSbn1qz2A6hQ1PGrAbTk7j4=;
        b=NLOp/euwCLkPVCO6TdtgFq5f9wYJUdhJbZMm+IvevGA4bZ6GZ5kPS/l00k/hs2jVn5
         2vdmU8t+VIzAwUFk2wIPAfnXcL1aRpORw6K7gp2i5GfaC6OOJiSV0Fw4EOpzYILSdb+N
         E0E7h87FN45DxtTkAmNH3uhweQn1z+p5JdT7U1CvVhZFkCIfW0ly+QkZeP5JcOvcgdkY
         FbhW9eKjNXBOGdKdo5bA9KeG43+a8qhswmFoblWupOWEb/YuPnDYbK1cwMQHqlqStP9T
         MaCcDy9MqDpGlzeNUvS0X2jpVYtXaAc+0ePqNFOlctoqOgx7pRD2QcDO17RFWBPg0zsS
         +4WA==
X-Gm-Message-State: AOAM530UJ18H9ApwKrK0lku/b0UGWkNURRT2rY9Vzt4UplSdiJgl1fEg
        d/1ZOfCF5v/pNUgSvR1pmKORJQC+s7ElhxX+1fMdupihPxNGBTBWzHW/tjTVJ4DZdiygJG5iV2V
        rlWp94hPDAangckFv
X-Received: by 2002:a1c:9854:: with SMTP id a81mr3249726wme.72.1603469986550;
        Fri, 23 Oct 2020 09:19:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZqm1RTGWeZAHmj4MXGjlfd/lwg84Tvbw8VauBzDqmQH3RAw47a8ifRkIwd2g4MI5bbpyvqg==
X-Received: by 2002:a1c:9854:: with SMTP id a81mr3249706wme.72.1603469986382;
        Fri, 23 Oct 2020 09:19:46 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id t62sm4130429wmf.22.2020.10.23.09.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 09:19:45 -0700 (PDT)
Date:   Fri, 23 Oct 2020 18:19:43 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 1/2] mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
Message-ID: <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
References: <cover.1603469145.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1603469145.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
mpls_iptunnel.ko has a softdep on mpls_gso.ko. For this to work, we
need to ensure that mpls_gso.ko is built whenever MPLS_IPTUNNEL is set.

Fixes: b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/mpls/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/Kconfig b/net/mpls/Kconfig
index d672ab72ab12..b83093bcb48f 100644
--- a/net/mpls/Kconfig
+++ b/net/mpls/Kconfig
@@ -33,6 +33,7 @@ config MPLS_ROUTING
 config MPLS_IPTUNNEL
 	tristate "MPLS: IP over MPLS tunnel support"
 	depends on LWTUNNEL && MPLS_ROUTING
+	select NET_MPLS_GSO
 	help
 	 mpls ip tunnel support.
 
-- 
2.21.3

