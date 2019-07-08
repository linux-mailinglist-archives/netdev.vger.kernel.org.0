Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB8D626B4
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391578AbfGHQ5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:57:34 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40338 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHQ5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:57:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so8587378pla.7;
        Mon, 08 Jul 2019 09:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=o5W8L9T98ksyJmF6q+BJXsHo2tfNqcFsD0iqHa55ePw=;
        b=kvlzKTym/UWlxpBZQTYtkgWNwFPjkMQPgsUhSVN01Wkn7gjY8KazXoAuIpJgEmrkfL
         GXLVpSSyB/KE+OJbv/vbJG1JQUfRi6EKPgZHq1/q4ospm4zHMZAXA5KkavpPfPwhpwDp
         XSUTUY/iCQwnxOPGLkx1am0Ik7j7UxXSKomui9Yq96Sds7D2yom6pa/Xv0wajG9IuDrX
         9UHzjpOIMYe99TKNSCyFxn/B5PO1AM9zj+bzC+liaYj9jcXjzP11FNxHSNVEBRc1sID2
         fGc4WjKgw6bE/n7lbpV/2vldkfzOhhTQL+7Umj/e8iWaZAPEA6YpGVy7hpsMXeoTGEes
         dZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=o5W8L9T98ksyJmF6q+BJXsHo2tfNqcFsD0iqHa55ePw=;
        b=ujobv1MokKH5mKliwbzAN69KV3O5S0W/UbZ/tjbDyRLIFYZISS7DDfXmmP7sra7991
         +BbxdT4ILGrKHbpRvltNu7axtt5NMQxZ+ZwWqrTo2l8+rfkwsEr0ujvJ45orYVDW+SGI
         5w1Dq4F9L32zVdEvZgJqGaKTdYm8rRFvn2k1mxmyJ+4M97kF0W9F/eZNtFsT5SmyQM7C
         T9NEKY1Cu+fsSoIkhagfO1on8GskpxM8Ewjs+1CYA1KyzKyQn9xH/DfcLcLnS4Ik3iRz
         WiNG4DKccdIXrm+06/gCjQm2Dp0g+cHUFjh/lj/d/zmMH1M/8VAc9AomamBak4Nqjrj4
         AqdA==
X-Gm-Message-State: APjAAAW9XZHWItXF8UFZ0Zivm8cwaAQMpLDbAKVMBhov/Jh13WfZa2wb
        RAQ/gMT50em631ZMG6W+ykBKLabQ
X-Google-Smtp-Source: APXvYqznkVrog3OApmmwnLjrX56bNp8/d7UjGAE7cObM6/H9OysV8zIjZ1OmcmQUDG1IkRfWa93oTQ==
X-Received: by 2002:a17:902:d70a:: with SMTP id w10mr24988098ply.251.1562605053094;
        Mon, 08 Jul 2019 09:57:33 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k184sm16856975pgk.7.2019.07.08.09.57.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:57:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 2/4] sctp: remove prsctp_enable from asoc
Date:   Tue,  9 Jul 2019 00:57:05 +0800
Message-Id: <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
 <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like reconf_enable, prsctp_enable should also be removed from asoc,
as asoc->peer.prsctp_capable has taken its job.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 3 +--
 net/sctp/associola.c       | 1 -
 net/sctp/sm_make_chunk.c   | 8 ++++----
 net/sctp/socket.c          | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index d9e0e1a..7f35b8e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2050,8 +2050,7 @@ struct sctp_association {
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
 	     force_delay:1,
-	     intl_enable:1,
-	     prsctp_enable:1;
+	     intl_enable:1;
 
 	__u8 strreset_enable;
 	__u8 strreset_outstanding; /* request param count on the fly */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 321c199..5010cce 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -261,7 +261,6 @@ static struct sctp_association *sctp_association_init(
 		goto stream_free;
 
 	asoc->active_key_id = ep->active_key_id;
-	asoc->prsctp_enable = ep->prsctp_enable;
 	asoc->strreset_enable = ep->strreset_enable;
 
 	/* Save the hmacs and chunks list into this association */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d784dc1..227bbac 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -247,7 +247,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	chunksize += SCTP_PAD4(SCTP_SAT_LEN(num_types));
 	chunksize += sizeof(ecap_param);
 
-	if (asoc->prsctp_enable)
+	if (asoc->ep->prsctp_enable)
 		chunksize += sizeof(prsctp_param);
 
 	/* ADDIP: Section 4.2.7:
@@ -348,7 +348,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		sctp_addto_param(retval, num_ext, extensions);
 	}
 
-	if (asoc->prsctp_enable)
+	if (asoc->ep->prsctp_enable)
 		sctp_addto_chunk(retval, sizeof(prsctp_param), &prsctp_param);
 
 	if (sp->adaptation_ind) {
@@ -2011,7 +2011,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 				asoc->peer.reconf_capable = 1;
 			break;
 		case SCTP_CID_FWD_TSN:
-			if (asoc->prsctp_enable && !asoc->peer.prsctp_capable)
+			if (asoc->ep->prsctp_enable)
 				asoc->peer.prsctp_capable = 1;
 			break;
 		case SCTP_CID_AUTH:
@@ -2636,7 +2636,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 		break;
 
 	case SCTP_PARAM_FWD_TSN_SUPPORT:
-		if (asoc->prsctp_enable) {
+		if (asoc->ep->prsctp_enable) {
 			asoc->peer.prsctp_capable = 1;
 			break;
 		}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0424876..da2a3c2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7343,7 +7343,7 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->prsctp_enable
+	params.assoc_value = asoc ? asoc->peer.prsctp_capable
 				  : sctp_sk(sk)->ep->prsctp_enable;
 
 	if (put_user(len, optlen))
-- 
2.1.0

