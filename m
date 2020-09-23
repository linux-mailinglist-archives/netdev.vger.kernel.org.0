Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF5E2750F3
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgIWGHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgIWGGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 02:06:38 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD50FC061755;
        Tue, 22 Sep 2020 23:06:37 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id k25so16202285ljk.0;
        Tue, 22 Sep 2020 23:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zhNLPdt3MABy9YGkQQhQ6/eOKIUXSwNa1xulGA5X34I=;
        b=lT7Ov8RiWALgWo1tGW58nncRiqRjEqVnH4H0E5Yobwk9FNfUMCkYZfDjZvfB5orEP1
         +YpacYIhhKTJNnlLPzzbUo0RfIaFLJhb/tDOA/EOCjfS7FGPsOEvvXv6k75sub9w73ng
         wXZETZ/7tVv61t4+eu088LGRF+qzVs+5exUq0Jxflj7BSbmE4BRCG86nliVX+LQ5fj37
         gCqfJIkkELSCCxlMtMl0W+Nu/LOjCHxxPoCDFFg+Eyifj8TyBN/C8r88oDWhxsf3Bg4q
         1hyaMUiWzqUKKCLf4I/EOiD38fvIR+mv6i81Th4zYDo4VoRru7GhoxG5NSmQTVE2WAVa
         wPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zhNLPdt3MABy9YGkQQhQ6/eOKIUXSwNa1xulGA5X34I=;
        b=OjR+O8cWbZMdD4pnYNQA/XL5Ju3R1qrPD501tVgXjSExR4n6OS1DvSmOiHIZB8ioLR
         CWkq1nYm7oEOIYISewcnu2kRZc3ROHw9o1P+JXQAV3mvQN32Q9Pzn9MDq0HeSs3/g07Z
         BpvU1p3p99CBMfABGpMOpvcS1B7qU2uKFjm1aucvNC2JD52b5l6TuGcvSHc+UoYNfCbC
         Hzb5ZyrrK7voieBEkY6d/WK9y2ZgfMMK1V6EZXWa3eo6IOfcTlCX8xiqXE9P4KS9Saza
         LdFAHeaHM1Uzjqd17ccwjeNa1vCzoSdGw74btzajoe3brdJM1Ch0GV9ImuXoB3Y5FePr
         jEyg==
X-Gm-Message-State: AOAM532f0rsuBuIMFFo7A1SgyKj6S34v5bf5qXEXOkMPGQGQi9CH0XSU
        KPYdAEiHFr9aPjSDfCgmQBZhUbqfH8OJ7e6wPJmdV0t3qDSk1g==
X-Google-Smtp-Source: ABdhPJxfzcC+TydkSiRcCojlYcHR2hO+JoT7gp8X19M834MP43Q1uN1L4utP9tCc1HEcdobJ3iR8M8cdOvp5959jYWw=
X-Received: by 2002:a2e:b006:: with SMTP id y6mr2376853ljk.462.1600841196247;
 Tue, 22 Sep 2020 23:06:36 -0700 (PDT)
MIME-Version: 1.0
From:   yue longguang <yuelongguang@gmail.com>
Date:   Wed, 23 Sep 2020 14:06:25 +0800
Message-ID: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
Subject: [PATCH] ipvs: adjust the debug order of src and dst
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ylg <bigclouds@163.com>

adjust the debug order of src and dst when tcp state changes

Signed-off-by: ylg <bigclouds@163.com>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c
b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index dc2e7da2742a..6567eb45a234 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -548,10 +548,10 @@ set_tcp_state(struct ip_vs_proto_data *pd,
struct ip_vs_conn *cp,
       th->fin ? 'F' : '.',
       th->ack ? 'A' : '.',
       th->rst ? 'R' : '.',
-      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
-      ntohs(cp->dport),
       IP_VS_DBG_ADDR(cp->af, &cp->caddr),
       ntohs(cp->cport),
+      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
+      ntohs(cp->dport),
       tcp_state_name(cp->state),
       tcp_state_name(new_state),
       refcount_read(&cp->refcnt));
-- 
2.20.1 (Apple Git-117)
