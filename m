Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDAD63F9F2
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiLAVlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAVlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:41:20 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE9A85CB
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 13:41:19 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h12so4916601wrv.10
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 13:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ITfVqjrQNG7fWql8z6Uk87ufUs8LJ0NiEA7WM1x2p2Q=;
        b=gWbN/olPmiW0rZbS28dI75pNo1bYaNNwqLxqvpdhwOvMeoTem7t8JwO0A/0tWd7x/l
         n88E4mIfsfBn39yHJAKfkL/XoOb/V+0pwvWCJHdA4T5cb3aWM74Z5/rPh5QeJQB6qRXG
         B7FQ4jIUTiKW3VfpDA1VGcVl6ytbkP2DanSwh2onBvR/b8/lcmYcXD5VYwGjix6WcEIU
         XrxQhOgFNhNSSEQJb3MSK4hvsIdFl9b5Axt7BErjE6yjN6a5vNkoH6xo8knuUqnFXFq3
         2TRhu3vpBXRLvnd97jWFBY1IFdgAf3f1ch4pDJfkelplLkC7MBO9jj+1RvMCzY6oAgOS
         Axcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ITfVqjrQNG7fWql8z6Uk87ufUs8LJ0NiEA7WM1x2p2Q=;
        b=wZeRz252gocMQ6RUbGMFMOpWRZtEOOe2otBrJBgM+oUTS7V00Z63qvRmzZ1AohdF1u
         yYuJ/e2IzUlzRQLvksRk4yVIj1OZXQmI4xEs6/EJciJVkKgyJXo3kWOGL6cfWaKAk02W
         zENQm/MxooicYkr1nO9nzmPEBTN2htqv2UDW4fhheQlpiym01GYjYgRchDlU2ZQppews
         WKTIb3zWOQ3cnWDsCZvy7wFRw/B9mzllAnc+6l6xVLFphj/9jEuy9pgiED1OCyojEP+o
         xRIFPiI0v1eaurio0LYH+VMjQh81taX914E5aJHrkBg6okucpjL16wEyGuhPGYnxjdaB
         SHWw==
X-Gm-Message-State: ANoB5pkvp1JDFruQqmuHI4+SHcYOyMhHz+iTriOr1Hno9HAj14KBxQC8
        /RJ40RZSUjTJLlMeBWUVWkRuHDysDQg=
X-Google-Smtp-Source: AA0mqf73+c9FkVjH0UZsnEYwwG9uGoJu/+R3/PQEp2r8aAlec1TKvHnygo2tyR3cIYGM1mJBQZWmWg==
X-Received: by 2002:adf:f011:0:b0:241:c78c:3671 with SMTP id j17-20020adff011000000b00241c78c3671mr36148944wro.129.1669930877766;
        Thu, 01 Dec 2022 13:41:17 -0800 (PST)
Received: from localhost.localdomain ([2a04:241e:502:a080:d550:2713:91f3:c113])
        by smtp.gmail.com with ESMTPSA id i2-20020adff302000000b002421a8f4fa6sm5294662wro.92.2022.12.01.13.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:41:17 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2 1/2] ip neigh: Support --json on ip neigh get
Date:   Thu,  1 Dec 2022 23:41:05 +0200
Message-Id: <63b6585719b0307d81191bbcf5228b94f81c112f.1669930736.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip neigh command supports --json for "list" but not for "get". Add
json support for the "get" command so that it's possible to fetch
information about specific neighbors without regular expressions.

Fixes: aac7f725fa46 ("ipneigh: add color and json support")
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 ip/ipneigh.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 61b0a4a22cbf..0cf7bb60553a 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -727,16 +727,19 @@ static int ipneigh_get(int argc, char **argv)
 
 	if (rtnl_talk(&rth, &req.n, &answer) < 0)
 		return -2;
 
 	ipneigh_reset_filter(0);
+	new_json_obj(json);
 	if (print_neigh(answer, stdout) < 0) {
 		fprintf(stderr, "An error :-)\n");
 		free(answer);
+		delete_json_obj();
 		return -1;
 	}
 	free(answer);
+	delete_json_obj();
 
 	return 0;
 }
 
 int do_ipneigh(int argc, char **argv)
-- 
2.34.1

