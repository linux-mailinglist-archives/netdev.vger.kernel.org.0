Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF563ED378
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhHPMAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:00:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229884AbhHPMAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 08:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629115178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JnuIBapx/DIqUD04cPgw31GDRqK+09qdpfB7ZewdXOc=;
        b=VSJAcvEmCYoEo8JIzg80wxhJYWMA3tqFCJ5kAbT+G7x+d9CNHNgPBwLCfzKMptLmwIfxWG
        yo6m53I4j6NJpr6VEh2cTU5n8tJUo04jJetV7aVODWgHXt3T9nZLBk4os3x6naOxOhNtZ9
        A4omtPGokq3INkqZWSPRdhLO6HN92Cg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-jCIOrR_oO8aARdS4pqnafA-1; Mon, 16 Aug 2021 07:59:36 -0400
X-MC-Unique: jCIOrR_oO8aARdS4pqnafA-1
Received: by mail-ed1-f69.google.com with SMTP id x24-20020aa7dad8000000b003bed477317eso2593485eds.18
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 04:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JnuIBapx/DIqUD04cPgw31GDRqK+09qdpfB7ZewdXOc=;
        b=eTk8dPI50dX8kCpePN7RqOv/zIfkXjrpcMfr3PI7Fw1APxLWXHBCKD32YPg0GCtVyb
         TYYBnXWqKK8EhiHhO6j6upb1IrPET5zOQh2F+K2I9704EEm/fvVpJKxOacjRs9vOKkjG
         3emckDKSM5evTIp1hizM9svNjyvGwrb05UfF0C7MDRcN0bWCWJRFsCUVWzRl+IJRRm5P
         +DUoLlHICLWa1QN7PnYytRRd63d9MZasCU92Uf1Z60hK4bS9WjHcvt4N02akjToqgq4y
         1M3B7+Gz3wOtLxWDZetd4WXjtgOe82LsT0Df3gtkWISJbURcSPgGQr8pHtzUv54lYv3x
         HwDA==
X-Gm-Message-State: AOAM530AO3sRmO02iAL3ViAg9UrZOwwZCLTDVnB47uVgF/Csz5RE4VTZ
        jNpA7NAI7EeSN/if2Of5KlBcJHhRiWVgINGzZ8HlNbZTWvDx1mtRt/H0VVi9/p2nJtKAJWkcply
        QMMiqjMrVOODyOUhA
X-Received: by 2002:a17:906:f8d5:: with SMTP id lh21mr15409869ejb.6.1629115175644;
        Mon, 16 Aug 2021 04:59:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3hyTtQS+QPnGyvy7sgct91YG8I8LsQGaYkTACmr0cG34RW2EcT8JUcuLHqeiSdRvz+t1/MA==
X-Received: by 2002:a17:906:f8d5:: with SMTP id lh21mr15409848ejb.6.1629115175326;
        Mon, 16 Aug 2021 04:59:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c28sm3595681ejc.102.2021.08.16.04.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 04:59:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 59D04180185; Mon, 16 Aug 2021 13:59:34 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        cake@lists.bufferbloat.net, Pete Heist <pete@heistp.net>
Subject: [PATCH net] sch_cake: fix srchost/dsthost hashing mode
Date:   Mon, 16 Aug 2021 13:59:17 +0200
Message-Id: <20210816115917.16800-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding support for using the skb->hash value as the flow hash in CAKE,
I accidentally introduced a logic error that broke the host-only isolation
modes of CAKE (srchost and dsthost keywords). Specifically, the flow_hash
variable should stay initialised to 0 in cake_hash() in pure host-based
hashing mode. Add a check for this before using the skb->hash value as
flow_hash.

Fixes: b0c19ed6088a ("sch_cake: Take advantage of skb->hash where appropriate")
Reported-by: Pete Heist <pete@heistp.net>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 951542843cab..28af8b1e1bb1 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -720,7 +720,7 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 skip_hash:
 	if (flow_override)
 		flow_hash = flow_override - 1;
-	else if (use_skbhash)
+	else if (use_skbhash && (flow_mode & CAKE_FLOW_FLOWS))
 		flow_hash = skb->hash;
 	if (host_override) {
 		dsthost_hash = host_override - 1;
-- 
2.32.0

