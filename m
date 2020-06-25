Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611B920A694
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407110AbgFYUS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:18:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43443 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405054AbgFYUS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593116306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2kgnFQhJlWYIVZyqdhxBuFSs3S0cXmmRAEAdW42hsxE=;
        b=gOEnHHgwLTsKQ2sTqye8Q7wRcflSYV2Ed+YxiRq/muWCj/eHDESEUR1vx+LQAy5AVy/0D8
        Av7OWw6cA5DRM0a5AoNiuBG6A8xrN5SsNer9teC71g/uCplzH/qISFE27wuPfOm8pC7feD
        5/Mc9+n2FyIjEr78q7n94HU7GZ+Oc+c=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-NHiSFa6xNrqLzdQaBZaQxw-1; Thu, 25 Jun 2020 16:18:24 -0400
X-MC-Unique: NHiSFa6xNrqLzdQaBZaQxw-1
Received: by mail-qt1-f200.google.com with SMTP id u93so4845359qtd.8
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2kgnFQhJlWYIVZyqdhxBuFSs3S0cXmmRAEAdW42hsxE=;
        b=OaVKRw9sSi42hdp1MFrYe7OuIdXrmB5brEoL3AENXha8ZnJkdeXtjiabQ1Qb5iDb4D
         m1kEi2HFjl2WZ5/P7CY0qOwKQ4e/xz5fBWRme0r758lHAk/o2CuQk/+Y2BfpYVuBVJms
         vybfpKO0V59MG3o4N1uNf6GaOt/QXioLQltpf9IXvtgQAUkI0s1Ipifxl5ppOFAYIGGV
         OkCiG9RMH4kE3yTgIEiVmrCfZZdF6GrxJs7s5/V06Sw/vSGjkXv5CCuGMhF1E3g4yiVQ
         LKrvYcl1FkphzBpzBy1t1kQiPDEND9Jl0gGIPXgFJYQeIZNEzspNcNzcQTJW2OxGlnFi
         9ThA==
X-Gm-Message-State: AOAM531VzBqbzhtmsp/w1aWV6spnAiyNifgIDlKpB5faIzmE/BFCJLzO
        t3swSB4qUCC9vwozLVigeAn7ojMjcW6YG32lDsUtUny5/+ygiLi15dRdTr9HIRRT4hpDPBZMBQ5
        BVA5PXiBlI1sI3bkq
X-Received: by 2002:ac8:7ca1:: with SMTP id z1mr31613247qtv.334.1593116304155;
        Thu, 25 Jun 2020 13:18:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPw7Hd5yhXoSJ+f27tRx1i2Hjw/rvc0rjOQWLFSubyb0otYpjZLlgpUzedX7L1+gto6vD0Mw==
X-Received: by 2002:ac8:7ca1:: with SMTP id z1mr31613228qtv.334.1593116303907;
        Thu, 25 Jun 2020 13:18:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y16sm6647763qkb.116.2020.06.25.13.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:18:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 594941814F9; Thu, 25 Jun 2020 22:18:20 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH RESEND net-next] sch_cake: add RFC 8622 LE PHB support to CAKE diffserv handling
Date:   Thu, 25 Jun 2020 22:18:00 +0200
Message-Id: <20200625201800.208689-1-toke@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Change tin mapping on diffserv3, 4 & 8 for LE PHB support, in essence
making LE a member of the Bulk tin.

Bulk has the least priority and minimum of 1/16th total bandwidth in the
face of higher priority traffic.

NB: Diffserv 3 & 4 swap tin 0 & 1 priorities from the default order as
found in diffserv8, in case anyone is wondering why it looks a bit odd.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
[ reword commit message slightly ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
Resending this as standalone after splitting out the rest of the series to -net

 net/sched/sch_cake.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 60f8ae578819..cae367515804 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -312,8 +312,8 @@ static const u8 precedence[] = {
 };
 
 static const u8 diffserv8[] = {
-	2, 5, 1, 2, 4, 2, 2, 2,
-	0, 2, 1, 2, 1, 2, 1, 2,
+	2, 0, 1, 2, 4, 2, 2, 2,
+	1, 2, 1, 2, 1, 2, 1, 2,
 	5, 2, 4, 2, 4, 2, 4, 2,
 	3, 2, 3, 2, 3, 2, 3, 2,
 	6, 2, 3, 2, 3, 2, 3, 2,
@@ -323,7 +323,7 @@ static const u8 diffserv8[] = {
 };
 
 static const u8 diffserv4[] = {
-	0, 2, 0, 0, 2, 0, 0, 0,
+	0, 1, 0, 0, 2, 0, 0, 0,
 	1, 0, 0, 0, 0, 0, 0, 0,
 	2, 0, 2, 0, 2, 0, 2, 0,
 	2, 0, 2, 0, 2, 0, 2, 0,
@@ -334,7 +334,7 @@ static const u8 diffserv4[] = {
 };
 
 static const u8 diffserv3[] = {
-	0, 0, 0, 0, 2, 0, 0, 0,
+	0, 1, 0, 0, 2, 0, 0, 0,
 	1, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
-- 
2.27.0

