Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAC068F41C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjBHRO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjBHROy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:14:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AE624C99
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675876445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nrWSBA54Eqk6lCTqjIgDktjUnYtJh78nx36TSW8eak0=;
        b=gX9Mx59gX8cpvnv/1qBcEQBbcO1m2TJMZs+7MF3vEPL1GUtN+tBKJCx63ap0lL9tPTqSMC
        1gZwDQjIUmzdupDrJs7V6PEIXDv61ucRFQbr0MNqrIGlr5OcBLkiP6C/Y3oMe0oCiQMWh8
        DoFkFewojK+k/V7yLRwJ8+1VIW/Y/Ck=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-17-fs_kKYsGNQ2nWK4fx5X2sA-1; Wed, 08 Feb 2023 12:14:04 -0500
X-MC-Unique: fs_kKYsGNQ2nWK4fx5X2sA-1
Received: by mail-qv1-f72.google.com with SMTP id o12-20020a056214108c00b0056c0896ed81so3233789qvr.2
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 09:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrWSBA54Eqk6lCTqjIgDktjUnYtJh78nx36TSW8eak0=;
        b=wOGvdYBHAp5bl7iJQYdCQhRRg6Zx7jjISdJdc39KSQ4mowyjrWwdvNs/gMayloH5hQ
         YheT3GQyt+xuFof5MhnyekIgMiyP5VJ0Jn2jfFvpbH0EsESMJZ4sz2oqwW0oBouTQHE0
         +GwukXEeFx8IWhPolKeyiXro/tPVDpAvlrGWK0EAiju57/yDBUkaGIYT7eIpJuWECRG4
         PriYRDiahQqRKAwX812rR0Cidd8nLfekpoDtcxXED9fBYiATHY7bC8jf5WVwLq8U6yDw
         BflukRFnN/tD+548ahOHb6EZGounujoxdknnen+I8sJ1snwa5qu/MSMltLT9ykLitE9l
         lNpg==
X-Gm-Message-State: AO0yUKWo/qtr4Dq+xzaavpG9K/GcTolbZae/P2pr+Gl0pEtOsvLlVOSt
        sVIkzXjqFBGGgwh88Fsk/R78uzGzZ6nv1gWkyrujMeceyxz4awoBFsUKUsOSIz9h7+GBhyAZZie
        XG69e4MG5rdU8Qic7
X-Received: by 2002:ac8:4e56:0:b0:3b8:61df:1c2 with SMTP id e22-20020ac84e56000000b003b861df01c2mr13643369qtw.56.1675876444040;
        Wed, 08 Feb 2023 09:14:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/M+AU6g3S1JIYYo7aaVExFT+8TTroUWkOjdmuRXmTZMfR7FaVETnSRmnMUyWiMArdMrzhSng==
X-Received: by 2002:ac8:4e56:0:b0:3b8:61df:1c2 with SMTP id e22-20020ac84e56000000b003b861df01c2mr13643335qtw.56.1675876443785;
        Wed, 08 Feb 2023 09:14:03 -0800 (PST)
Received: from debian (2a01cb058918ce00464fe7234b8f6f47.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:464f:e723:4b8f:6f47])
        by smtp.gmail.com with ESMTPSA id d19-20020ac847d3000000b003b6325dfc4esm11650969qtr.67.2023.02.08.09.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:14:03 -0800 (PST)
Date:   Wed, 8 Feb 2023 18:13:59 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 1/3] ipv6: Fix datagram socket connection with DSCP.
Message-ID: <b827a871f8dbc204f08e7f741242ba7f7d5cb8ab.1675875519.git.gnault@redhat.com>
References: <cover.1675875519.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675875519.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account the IPV6_TCLASS socket option (DSCP) in
ip6_datagram_flow_key_init(). Otherwise fib6_rule_match() can't
properly match the DSCP value, resulting in invalid route lookup.

For example:

  ip route add unreachable table main 2001:db8::10/124

  ip route add table 100 2001:db8::10/124 dev eth0
  ip -6 rule add dsfield 0x04 table 100

  echo test | socat - UDP6:[2001:db8::11]:54321,ipv6-tclass=0x04

Without this patch, socat fails at connect() time ("No route to host")
because the fib-rule doesn't jump to table 100 and the lookup ends up
being done in the main table.

Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv6/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index e624497fa992..9b6818453afe 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -51,7 +51,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
-	fl6->flowlabel = np->flow_label;
+	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6->flowi6_uid = sk->sk_uid;
 
 	if (!oif)
-- 
2.30.2

