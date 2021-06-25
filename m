Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9858A3B4481
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhFYNfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:35:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230386AbhFYNfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 09:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624627998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ISp2QePUMvDjiKjeNxC9ivL80ybCZ6sPLL0br4GSbTI=;
        b=D0uTopDMjxkDuEe3uSDbIUJYuHsjILBkxk6gp5BF7fTEcHs5+gXbTIton9AgJEnshRqNew
        JK5icizP90hMa1+/3pCW95w8DG67pltcIYomh/WGAM32PGJDknGruF5YsfrMOvaTYEnVlR
        IMJn0X1mzyRTvUeJQnbiP12XXQbb+IY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-ZpILfLAANiyCmcdac3od5g-1; Fri, 25 Jun 2021 09:33:16 -0400
X-MC-Unique: ZpILfLAANiyCmcdac3od5g-1
Received: by mail-wm1-f69.google.com with SMTP id k16-20020a7bc3100000b02901d849b41038so4195320wmj.7
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 06:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ISp2QePUMvDjiKjeNxC9ivL80ybCZ6sPLL0br4GSbTI=;
        b=BZdnnNFaaQGLZXivUHK+BxHBPVDx8IZW2BQHcG7PapuiAQC+hDh8Hvms0IEAbo9caK
         pzfT7dg9f+evPStBkQmMg5aXm6ARHaAq4a2u24I7YIlZ17fCs5932h9UqKB/TBw6jkZS
         2xSq0yvzPMp1fP2WOXQvDnZGpa4xJTugo+05eFY6jOteAJGXRjUPUbQpIZ53zfQUKCI1
         DtTkzP+ZTEqE4wq5tRHmgJUIIECdmrakmtNSsYuwv0DfRcK5WFv8bN5hpEONA9SXYgIM
         jaBFbiQIRHG7Pt82B29QFP8Aa7AiuSkKCnFSzPICamz7pJekE62cyLjCplm7c06To/Jx
         BQLw==
X-Gm-Message-State: AOAM530dLtsbpunZWTCW+GTkUy/XqD/Tpa5dsloK8I0yti1sHNB9HItQ
        nyQwbdTEsRFzqDcqfCEozt3iM2GRI6r2A+ggDa3nT1xk8Npv4wySPmzcxVtHwJoBL/OdwGN0w67
        fTT0cXzXz87hfCjpK
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr10724296wmi.176.1624627995607;
        Fri, 25 Jun 2021 06:33:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO5sxM3bN9PYZyaDWB/CUmKkQtaOD1UnFzzhL/0MV01Qosya0yuZViIUjq2/c9gfwG5RubJQ==
X-Received: by 2002:a7b:cb8a:: with SMTP id m10mr10724280wmi.176.1624627995490;
        Fri, 25 Jun 2021 06:33:15 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z3sm11127185wmi.29.2021.06.25.06.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 06:33:15 -0700 (PDT)
Date:   Fri, 25 Jun 2021 15:33:13 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jiri Benc <jbenc@redhat.com>
Subject: [PATCH net-next 4/6] gre: let mac_header point to outer header only
 when necessary
Message-ID: <f96aa9e8c08f7473fcd4b04905bb42d18088cb15.1624572003.git.gnault@redhat.com>
References: <cover.1624572003.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e271c7b4420d ("gre: do not keep the GRE header around in collect
medata mode") did reset the mac_header for the collect_md case. Let's
extend this behaviour to classical gre devices as well.

ipgre_header_parse() seems to be the only case that requires mac_header
to point to the outer header. We can detect this case accurately by
checking ->header_ops. For all other cases, we can reset mac_header.

This allows to push an Ethernet header to ipgre packets and redirect
them to an Ethernet device:

  $ tc filter add dev gre0 ingress matchall          \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Before this patch, this worked only for collect_md gre devices.
Now this works for regular gre devices as well. Only the special case
of gre devices that use ipgre_header_ops isn't supported.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/ip_gre.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index a68bf4c6fe9b..12dca0c85f3c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -107,6 +107,8 @@ module_param(log_ecn_error, bool, 0644);
 MODULE_PARM_DESC(log_ecn_error, "Log packets received with corrupted ECN");
 
 static struct rtnl_link_ops ipgre_link_ops __read_mostly;
+static const struct header_ops ipgre_header_ops;
+
 static int ipgre_tunnel_init(struct net_device *dev);
 static void erspan_build_header(struct sk_buff *skb,
 				u32 id, u32 index,
@@ -364,7 +366,10 @@ static int __ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 					   raw_proto, false) < 0)
 			goto drop;
 
-		if (tunnel->dev->type != ARPHRD_NONE)
+		/* Special case for ipgre_header_parse(), which expects the
+		 * mac_header to point to the outer IP header.
+		 */
+		if (tunnel->dev->header_ops == &ipgre_header_ops)
 			skb_pop_mac_header(skb);
 		else
 			skb_reset_mac_header(skb);
-- 
2.21.3

