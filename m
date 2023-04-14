Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BE96E2BA8
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDNVVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjDNVVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:21:21 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159A1E52;
        Fri, 14 Apr 2023 14:21:20 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id bn8so17912969qtb.2;
        Fri, 14 Apr 2023 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681507279; x=1684099279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ez0UQH8rbBx4CTsACR0qZrL7eQpbPtc6iwV9+6O2860=;
        b=BhQI/GRZYvszKRD2tAVi4IBxluU1ayKSN8kO559+9kXpBQWZevvfurd1juRB96lpww
         9wKbXSCMV9Crv7FXKanKY+KHfR+nVJccn3oE9ISK4q0iUqqFPBDH+B8ygsF6B+026wVv
         /eYoKrhYAB8YSmUOJB0UCXkQiEmu6rZAUKcmQa8h1QVebWjXvjZJLb8vflejk9LAm6Mn
         FavV4WYqbLntUkHgoDhpReK6KipKU6ecJSPwHNpNvq0OzNihFveybNuJLd6zzLASb8ki
         lLFcJZAg+WB6JrsRW3851afbp1/LzmkEoVPtxEz8l91MyX64rvkrN0hoRRj3DWOdiXJM
         jTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681507279; x=1684099279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ez0UQH8rbBx4CTsACR0qZrL7eQpbPtc6iwV9+6O2860=;
        b=kXp8mGyBtA4vWrg9vpBhWgE4F+hbdQ1grbUeE9BM/KWCjJP3l77CK8BSWy+hVGMXoU
         VNe/ZtOO8Ut/VqWBM+b+GIupewunTtqHqJ2xf0LgPhrONuQki5DzO1Q7Mv3XExpGQpN9
         pCwwTs4C19D3PuYuSXv/eo3Yoq3tSsxKoAcDFINNN0tK5aaYACFy4N7TXjGunuCE+4GQ
         fvq6x8+hYwXT6CaepySBsU56VzXwnCqgNax1BuniXc1acyHPGmzaYboxyJj2wjJI4iL9
         ZHNJ7HGuZm99jV/0GLmIRwZpJkJpG3oVb7fN8NWx4bCpQg1nUwaKUiRxuWqLB6pCqMqc
         leow==
X-Gm-Message-State: AAQBX9ftVJ3VbRZWORG30pr2bZoChTgjGwGQNHh0ljA/i4SnXfEe9Wi1
        h8j3ZA5ZsHDQCuA+4Z3l65IQXX5KhZBCaQ==
X-Google-Smtp-Source: AKy350aAjCNwsezm0vsoe5h6o6hFrnZKIdN8vJmj0vKstFFjbyqqEyvVKjizX/A7cmwUmOZ7rQBZAg==
X-Received: by 2002:ac8:7f09:0:b0:3e9:4d19:d9b8 with SMTP id f9-20020ac87f09000000b003e94d19d9b8mr11715380qtk.19.1681507278967;
        Fri, 14 Apr 2023 14:21:18 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b5-20020ac85bc5000000b003e693d92781sm593373qtb.70.2023.04.14.14.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:21:18 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next 1/2] sctp: delete the obsolete code for the host name address param
Date:   Fri, 14 Apr 2023 17:21:15 -0400
Message-Id: <f239d43df64292469fbe5dcc398fca545b8bacb4.1681507192.git.lucien.xin@gmail.com>
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

In the latest RFC9260, the Host Name Address param has been deprecated.
For INIT chunk:

  Note 3: An INIT chunk MUST NOT contain the Host Name Address
  parameter.  The receiver of an INIT chunk containing a Host Name
  Address parameter MUST send an ABORT chunk and MAY include an
  "Unresolvable Address" error cause.

For Supported Address Types:

  The value indicating the Host Name Address parameter MUST NOT be
  used when sending this parameter and MUST be ignored when receiving
  this parameter.

Currently Linux SCTP doesn't really support Host Name Address param,
but only saves some flag and print debug info, which actually won't
even be triggered due to the verification in sctp_verify_param().
This patch is to delete those dead code.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  1 -
 net/sctp/sm_make_chunk.c   | 10 +---------
 net/sctp/socket.c          |  2 +-
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a0933efd93c3..070c9458fff4 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1711,7 +1711,6 @@ struct sctp_association {
 		__u16	ecn_capable:1,      /* Can peer do ECN? */
 			ipv4_address:1,     /* Peer understands IPv4 addresses? */
 			ipv6_address:1,     /* Peer understands IPv6 addresses? */
-			hostname_address:1, /* Peer understands DNS addresses? */
 			asconf_capable:1,   /* Does peer support ADDIP? */
 			prsctp_capable:1,   /* Can peer do PR-SCTP? */
 			reconf_capable:1,   /* Can peer do RE-CONFIG? */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index c7503fd64915..c8f4ec5d5f98 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2207,7 +2207,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 		break;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
-		/* Tell the peer, we won't support this param.  */
+		/* This param has been Deprecated, send ABORT.  */
 		sctp_process_hn_param(asoc, param, chunk, err_chunk);
 		retval = SCTP_IERROR_ABORT;
 		break;
@@ -2589,10 +2589,6 @@ static int sctp_process_param(struct sctp_association *asoc,
 		asoc->cookie_life = ktime_add_ms(asoc->cookie_life, stale);
 		break;
 
-	case SCTP_PARAM_HOST_NAME_ADDRESS:
-		pr_debug("%s: unimplemented SCTP_HOST_NAME_ADDRESS\n", __func__);
-		break;
-
 	case SCTP_PARAM_SUPPORTED_ADDRESS_TYPES:
 		/* Turn off the default values first so we'll know which
 		 * ones are really set by the peer.
@@ -2624,10 +2620,6 @@ static int sctp_process_param(struct sctp_association *asoc,
 					asoc->peer.ipv6_address = 1;
 				break;
 
-			case SCTP_PARAM_HOST_NAME_ADDRESS:
-				asoc->peer.hostname_address = 1;
-				break;
-
 			default: /* Just ignore anything else.  */
 				break;
 			}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 218e0982c370..079e726909b4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5195,7 +5195,7 @@ int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 	mask = asoc->peer.ecn_capable << 1;
 	mask = (mask | asoc->peer.ipv4_address) << 1;
 	mask = (mask | asoc->peer.ipv6_address) << 1;
-	mask = (mask | asoc->peer.hostname_address) << 1;
+	mask = mask << 1;
 	mask = (mask | asoc->peer.asconf_capable) << 1;
 	mask = (mask | asoc->peer.prsctp_capable) << 1;
 	mask = (mask | asoc->peer.auth_capable);
-- 
2.39.1

