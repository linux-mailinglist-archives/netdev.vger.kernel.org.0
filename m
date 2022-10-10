Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC15F5F9D11
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 12:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiJJKvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 06:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiJJKvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 06:51:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F9C286CE;
        Mon, 10 Oct 2022 03:51:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso12753168pjf.2;
        Mon, 10 Oct 2022 03:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=xDAJhO6nMeWEoNHiOlooadZpm12/jqYN+cZC7C+A+cU=;
        b=X8rxYGns2BxQ0rORK5lw0t1/xZ5f20NItWAJX7RAfaCTGH2bhAA7wfzlafa7RYJnUk
         r7EHv4NtDfS8+0M/09O0RoJokEHP4madb4Pxh3O7z6Am0Sap2FFnPFgVCwFLw8hUt9l2
         CA3vL2ENcH8hIqcKS8I1NCdxoenWiIrTAxFWp6W5S0qf2XZiKmVEYL7rCpuCsHOcjTYj
         lV6HMidga2tytXs5nZ2xVrgnROZV/m8TYX5Azit45G0tCoeQglfGY5oSghLWgMf3JRW7
         Z6W4s5pGIbBaXlr1RILrFwstir8tXPQhaWfqBIU/Lw4GOxZmhC3m4YM290NvR9kD1KaI
         TMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDAJhO6nMeWEoNHiOlooadZpm12/jqYN+cZC7C+A+cU=;
        b=aNlyXfLg87s3DWkz+TmZGvZW84eRzZFdqDGf5HVylnyqqG0aERZCW/4a8EoGR0Tff0
         njO4Alxg2Dvd5dTPuWIUdATDEacSWEKlXKuo9NozTlkaNBFj200WqJfRz6faZsmv7xbl
         W0Wde6jomIPQbjQG3GrVTK7ufsnJUeoTRwVqcnsKg04G6NYBZGWtN9vG1IvqrF/XpX0J
         KbGkYFOvB2iSpFCAhB7/8Ssykb9YjEITTLK7RkNXzZ6ooJmLxQG/XG4xRdiNXpDvN55U
         uHQkxfGPYjTVV9OE3gfXnUh1CerUh/r1MH/CpvLfT3edv7gKf358i113cHN9RYwQq31B
         0HXw==
X-Gm-Message-State: ACrzQf1uNke5rv+VBESDz+9xcHtF+p/XldAJbGpyXPc2ZHbEqqoVnPJv
        9RMd6X2MVyHgoHNrC7/VdOcWSyy0sDU=
X-Google-Smtp-Source: AMsMyM4DTqQ8cOATpFoLxmw11Pf0bdewgdfPXjp2BItmroHRq4xdb0vNhpMNph+Qs8AP0Vt7UtLV5Q==
X-Received: by 2002:a17:902:d54d:b0:180:202c:ad78 with SMTP id z13-20020a170902d54d00b00180202cad78mr16025103plf.84.1665399072017;
        Mon, 10 Oct 2022 03:51:12 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902710100b00178af82a000sm6279134pll.122.2022.10.10.03.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 03:51:11 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH] iplink_can: add missing `]' of the bitrate, dbitrate and termination arrays
Date:   Mon, 10 Oct 2022 19:50:41 +0900
Message-Id: <20221010105041.65736-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The command "ip --details link show canX" misses the closing bracket
`]' of the bitrate, the dbitrate and the termination arrays. The JSON
output is not impacted.

Change the first argument of close_json_array() from PRINT_JSON to
PRINT_ANY to fix the problem. The second argument is already set
correctly.

Fixes: 67f3c7a5cc0d ("iplink_can: use PRINT_ANY to factorize code and fix signedness")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de> via vger.kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 0e670a6c..9bbe3d95 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -519,7 +519,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 				   i < bitrate_cnt - 1 ? "%8u, " : "%8u",
 				   bitrate_const[i]);
 		}
-		close_json_array(PRINT_JSON, " ]");
+		close_json_array(PRINT_ANY, " ]");
 	}
 
 	/* data bittiming is irrelevant if fixed bitrate is defined */
@@ -606,7 +606,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 				   i < dbitrate_cnt - 1 ? "%8u, " : "%8u",
 				   dbitrate_const[i]);
 		}
-		close_json_array(PRINT_JSON, " ]");
+		close_json_array(PRINT_ANY, " ]");
 	}
 
 	if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
@@ -623,7 +623,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			print_hu(PRINT_ANY, NULL,
 				 i < trm_cnt - 1 ? "%hu, " : "%hu",
 				 trm_const[i]);
-		close_json_array(PRINT_JSON, " ]");
+		close_json_array(PRINT_ANY, " ]");
 	}
 
 	if (tb[IFLA_CAN_CLOCK]) {
-- 
2.35.1

