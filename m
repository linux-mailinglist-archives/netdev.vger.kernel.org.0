Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9394FA573
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 08:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbiDIGi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 02:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiDIGi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 02:38:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AF7A1470
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 23:36:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id n6so21047293ejc.13
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 23:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QIadV+02aife5O5acIeg03pteZkbniQhtMavKParwPo=;
        b=4TrE0p8nGdolXnaaBW8lx2AsYPF74Q+Ek8ggEGCM/y6gRyKGD2olfAfb5oBe/zf4om
         s8Rf/FT+ZnJzY+/SVvC0BM/Cqn8DSzFWM4p+gFqA+/RteBXJtbeL7GqFDxc3zsz9WrNk
         JoefpChTrqpQv+XBt2iDbnPr9ZVy8Xj3tduqY1Mjhh2LAtJCIVekq00fYXQPmlP/U/pF
         rRZSEoKAeVQ3VEvFZ54jrfP9udoAuzEx7Tpi6x3OR8zU1t9gtdmfeIxgB2kym9NsMR54
         IiYaOM4Fi7n/kBP+4/sTKvldkMMaf4tZVkBt6xg66sHfj/st+C6ZokGXFn79fDLgN8gz
         bK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QIadV+02aife5O5acIeg03pteZkbniQhtMavKParwPo=;
        b=hcMKTj4q9UHPqyO2HCXGgv6k2ojoqorPfmfG6Mjk1oW/cw4xw2JMgoNeR26TT1HbE9
         0MaFUguT75GvyE+9h0YDFc4zXdGYlDpsRiKaiEnuj6qA3CKlCBblCw4i6BIHVs4JffqY
         eQdYN9TgphzoGKwGhfxmx+hEhUDfp/9po1r7ZT/GR/wEbC5LZjTCx7J92GJ4KwUmX14/
         9yPLFOYzCHUpTgC6PP5y7ja8/SYlh+S2OQNI7Hx2EU55wv1GGkOt/b0qY1nhXnRdcqz5
         qLwOsOqTNfu439TjoYlNCGgwb2Tpfs5YGVjUJ1ueYzt3yprBhxOvPmZmoo6CB/V+JfXD
         XK8w==
X-Gm-Message-State: AOAM531yJtOl1+22lnOpCILBCo5BlABGc5fRrDN1qFcXqjSOM4fq8BCp
        LdudP7JbtIgIzJ5JSffPjcvQ05jYh+gT0VMG
X-Google-Smtp-Source: ABdhPJw15MeLiCGc0ArY7J1Zn7ZYjAL0lhyP5omP3RmpQKrGvXdnKG3V7Ai9Uslk1sgeD/tWB4tPSQ==
X-Received: by 2002:a17:907:3f18:b0:6e0:df2d:c76a with SMTP id hq24-20020a1709073f1800b006e0df2dc76amr22280753ejc.55.1649486208717;
        Fri, 08 Apr 2022 23:36:48 -0700 (PDT)
Received: from ntb.petris.klfree.czf ([2a02:8070:d4c1:3a00:ceb5:41c:b517:660f])
        by smtp.googlemail.com with ESMTPSA id m3-20020a17090679c300b006cf9ce53354sm9381437ejo.190.2022.04.08.23.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 23:36:48 -0700 (PDT)
From:   Petr Malat <oss@malat.biz>
To:     netdev@vger.kernel.org
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        Petr Malat <oss@malat.biz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH] sctp: Initialize daddr on peeled off socket
Date:   Sat,  9 Apr 2022 08:36:11 +0200
Message-Id: <20220409063611.673193-1-oss@malat.biz>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YlByDe3YttU5K8dU@t14s.localdomain>
References: <YlByDe3YttU5K8dU@t14s.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function sctp_do_peeloff() wrongly initializes daddr of the original
socket instead of the peeled off socket, which makes getpeername()
return zeroes instead of the primary address. Initialize the new socket
instead.

Fixes: d570ee490fb1 ("[SCTP]: Correctly set daddr for IPv6 sockets during peeloff")
Signed-off-by: Petr Malat <oss@malat.biz>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3e1a9600be5e..7b0427658056 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5636,7 +5636,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	 * Set the daddr and initialize id to something more random and also
 	 * copy over any ip options.
 	 */
-	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
+	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sock->sk);
 	sp->pf->copy_ip_options(sk, sock->sk);
 
 	/* Populate the fields of the newsk from the oldsk and migrate the
-- 
2.30.2

