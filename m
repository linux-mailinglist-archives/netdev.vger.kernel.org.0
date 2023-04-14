Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB76E2BA9
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDNVVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjDNVVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:21:21 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4AE1725;
        Fri, 14 Apr 2023 14:21:20 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id fv6so7372372qtb.9;
        Fri, 14 Apr 2023 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681507280; x=1684099280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oi2O8babklLyox2EN7nagC3RjF+y9LXjfHiQTmAUGuE=;
        b=ohpRk0N3lsNpBGNje2pJtF8MxynvAz7MvarueFpcN2oYcyYT0SLv03ZVsC5iw1N0zx
         4JrMV3/Y6q03e9HIZreASbisTe2aq4MJataYPsTEzcVUKXM7W3ayPtC9+674NEroo9z6
         rYvMKc50QizfTxi6OojOGQd/vSyfl8dl0OMrwli8cI824CmrwP2qqEOOxlZ/8WDg9CT4
         7TBSoAxVGd143pSVP1yUTTlLarSE1qtzB4ZY2h3A5+vOqkq9jJ/ZIPaCMWmmdf6Pcjj/
         VQkF2zhLXRbcIPcdGYx7pG4WXp5D2u7HtGEAJ61IaIhkL1xctxjbAgEyCxMVrQAjSpup
         f0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681507280; x=1684099280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oi2O8babklLyox2EN7nagC3RjF+y9LXjfHiQTmAUGuE=;
        b=FvpIUztwcHg4NJnj9SR8d3250OamXM4OtnV5anD36UxKX6lD8FSk0XKtHTsPXJrUHM
         TzlxI5OcgfoviTM6s5AJT+f41mDwrFbKPrC0SyOVcH7vNu+LDuSn2i2pVKrRRNYPK7Tj
         erHcRF26wRmZ6M/IHy/iuUebVu04dmlJxZ1g1ZyTVyx1jW9u8NyTeqtJgedirqwEOAnT
         HRwgszhQO9I22jZFleycErTtNySXhUN1JmSRU+iM/a1wPvQl3CDuW4aPIA1xjCXkmdfL
         gpQLnofEQFGHgmPI/t0bgdObOVp1u3DtI9kiKwFz0LX/RDvJRnqJIeW6ZcR4JJLEgWI6
         gtUw==
X-Gm-Message-State: AAQBX9cKC/3fAjT+L4BizcPJDojmCXWRLtS6M4dTbm64RjdMkr1g1bhL
        yny+YKxO71cY5d/s9aUWW6Ois4w+JoPZ/w==
X-Google-Smtp-Source: AKy350bMkdREoMYpJAdutNnu3BV7Ik99U9lWhcMT1449xgCx6QX4mNH06/0+YZP0v4AnXQOREtk6Dw==
X-Received: by 2002:ac8:5714:0:b0:3bf:d4c3:365d with SMTP id 20-20020ac85714000000b003bfd4c3365dmr11746800qtw.14.1681507279861;
        Fri, 14 Apr 2023 14:21:19 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b5-20020ac85bc5000000b003e693d92781sm593373qtb.70.2023.04.14.14.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:21:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 2/2] sctp: add intl_capable and reconf_capable in ss peer_capable
Date:   Fri, 14 Apr 2023 17:21:16 -0400
Message-Id: <f5aa5fa493b426331bfd6bba5664bd551cc82e29.1681507192.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1681507192.git.lucien.xin@gmail.com>
References: <cover.1681507192.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two new peer capables have been added since sctp_diag was
introduced into SCTP. When dumping the peer capables, these two new
peer capables should also be included. To not break the old capables,
reconf_capable takes the old hostname_address bit, and intl_capable
uses the higher available bit in sctpi_peer_capable.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 079e726909b4..cda8c2874691 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5192,10 +5192,11 @@ int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 	info->sctpi_peer_rwnd = asoc->peer.rwnd;
 	info->sctpi_peer_tag = asoc->c.peer_vtag;
 
-	mask = asoc->peer.ecn_capable << 1;
+	mask = asoc->peer.intl_capable << 1;
+	mask = (mask | asoc->peer.ecn_capable) << 1;
 	mask = (mask | asoc->peer.ipv4_address) << 1;
 	mask = (mask | asoc->peer.ipv6_address) << 1;
-	mask = mask << 1;
+	mask = (mask | asoc->peer.reconf_capable) << 1;
 	mask = (mask | asoc->peer.asconf_capable) << 1;
 	mask = (mask | asoc->peer.prsctp_capable) << 1;
 	mask = (mask | asoc->peer.auth_capable);
-- 
2.39.1

