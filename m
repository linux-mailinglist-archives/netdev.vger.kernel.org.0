Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE92D3B68E7
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhF1TQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 15:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbhF1TQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 15:16:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C63C061760;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v7so16307190pgl.2;
        Mon, 28 Jun 2021 12:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BCs+o6gnuZtfNOzQ4frdEyd2QHilOo8Pj6iWOjokB3s=;
        b=BplzLOLNxYA00SkMeaix/bUXKP0Kf0s4DsFQ6TD9ikLPsurY14W4kuDuOiwfqjYl5s
         k39d9S9aZ1KdXAbguHNeCzzET8EnW0DopvD9I7vVL6/KPQVYmXKKFT88WD295SD1tj5V
         pmyp1IR/C4IEUlaOmOGzQFwNCgjDE+hazP/637Lb+uZ4PmlXtKxaBlT14DsHva+tuirB
         QVPu+JdfMBK6H+66pxfKCvVthb9mHgxQDt2niAmTxgatLyaSuGjfP9sadw+KDQWbVPoA
         aq2bfQuIkeyV0/lLCsqyEq2phZEPWnq++J+jxqxx/vanexoW+LF/+X8Zz8pyM1Fkh138
         D4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BCs+o6gnuZtfNOzQ4frdEyd2QHilOo8Pj6iWOjokB3s=;
        b=IyXiFHikLwkI1rms5MIBOvSbcf7yvA/8eAsJ+ZEvAe2QsHke/cENOpXGJcEoh/Q1ZL
         CELNreHOOWDnH1rHE2x7boERy8AbGLghT3v9RhNcjJ7aPcYUTAmeCHI7yPzX2BKRYpSP
         hXrNXoiXBx4NVsZVF/zTzQwpcEIJAs/s+zDgRodPIdZ5ujzezU8w5QYY4/ng7VKF2zTG
         sZtsBKZXA0JmT0i//ALK6mkI55q2BY+6X6gwdZ5gOpsTBoON8A6YjzPVeHAafoEQSsOC
         RUGflO0KHmN8LfotbUc5xKbrvt8F0JAwCojigWRoVPrxYM2P2ztDdVcoRCjFCzYs2ejl
         c9Vg==
X-Gm-Message-State: AOAM5308b2POZc/If1kRDGF9QC7LkpK23mN7Z1eFmpRkdX8ALAQq9S19
        OueERWy0bwjzaonE0Y24Yg8=
X-Google-Smtp-Source: ABdhPJyiKFIdr3hbu7dZXAZ4/QDE46GPyiYAXPA58rfCzU2ZMzC8su6No4EYhe1C7WLFw2ebhI8sVQ==
X-Received: by 2002:a05:6a00:168a:b029:2fb:6bb0:aba with SMTP id k10-20020a056a00168ab02902fb6bb00abamr26557996pfc.32.1624907634902;
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.71])
        by smtp.gmail.com with ESMTPSA id g123sm10203999pfb.187.2021.06.28.12.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:13:54 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 3604DC13E9; Mon, 28 Jun 2021 16:13:52 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net 4/4] sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
Date:   Mon, 28 Jun 2021 16:13:44 -0300
Message-Id: <e39b372644b6e5bf48df25e54b9172f34ec223a1.1624904195.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624904195.git.marcelo.leitner@gmail.com>
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When SCTP handles an INIT chunk, it calls for example:
sctp_sf_do_5_1B_init
  sctp_verify_init
    sctp_verify_param
  sctp_process_init
    sctp_process_param
      handling of SCTP_PARAM_SET_PRIMARY

sctp_verify_init() wasn't doing proper size validation and neither the
later handling, allowing it to work over the chunk itself, possibly being
uninitialized memory.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_make_chunk.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f33a870b483da7123e2ddb4473b6200a1aca5ade..587fb3cb88e29f53148cd21f13a2a86487ce292b 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2166,9 +2166,16 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
-		if (ep->asconf_enable)
-			break;
-		goto unhandled;
+		if (!ep->asconf_enable)
+			goto unhandled;
+
+		if (ntohs(param.p->length) < sizeof(struct sctp_addip_param) +
+					     sizeof(struct sctp_paramhdr)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
+		break;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
 		/* Tell the peer, we won't support this param.  */
-- 
2.31.1

