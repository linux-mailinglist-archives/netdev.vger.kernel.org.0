Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7003C4D1929
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiCHNad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:30:28 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3699544760
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:29:31 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id bn33so25024688ljb.6
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=93c5XXpJUTEPP71ABquCsBO3fHl+NABUZRIP4xIAZT4=;
        b=heMyUJRq4dH8Ia3M4mWZGOtRd8dvoGBM91VXXGu1/kWtQp/VMo6X59SQWtV1AMzpDh
         MVfvYn4mjIAXe+qY7GHXgeQVHqZOfTEQntHrRJfxiB/sNwxYNMAHlWHLqCUSAXvL8p0p
         B33jsszCrTW87YOQToZvNb1uSco2YVN9NxPhKPGSfkoFOGZADGVRLaPNVXmhzZNHGxCV
         +rfu/+NluhgI1mX3sf6gltmR6688ahr4ShYuLz7exWUxg+AnrfUgKozyksiFW0jbFhiY
         bNWJSpvpyGFG2s3qqBazlQww3BRP4fIjbiZqQrAN62dOrs1Zk863f1FYCaXTBDoeMM6v
         oixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=93c5XXpJUTEPP71ABquCsBO3fHl+NABUZRIP4xIAZT4=;
        b=6I0RYatOAZr37AW483MViBbUn+ZaTlZqdQW9RtqtFHk1k+BFOmUoJjDiGS9TQEP71K
         dS0BjQvHx4VvfUKAd0T1l1thuO9Ejf4vTa4glmAXc6Q+0TMo3xF7jkshQO1oBf3muxx5
         lP2JL/ZhZ2REtHuE/vdZaOCKboZzx5g5xt9BKk8Rb4GirEmKJ++0827X9kLgYLmsvK6z
         k3ifpsAU7tSthZxQqMpTDkUHiTZ7b1m5Zs+cku+BzT/ofONm0ppJUCpwRwjj4PYHcZjm
         SGj5C55W7n1HerD0raCv2ofAoam2q/DKhcEQGRbQGxsgqxIssEg1VmIXHjF7N/NVl9Iv
         VHVw==
X-Gm-Message-State: AOAM531/drVuR0aHpvHFt0sB5a3Pgj5UByl+xA3CX6BrxGrzHMptElmZ
        deXsnaazYVymqmXkJkQPIMSpB6ZMO2Q=
X-Google-Smtp-Source: ABdhPJzDFzrn1ntLHjgAAvTZkk8AtDEtW8kCYz8S40prvtLATyJ8oTqI3brhPaTKTrpK1EErUecYbw==
X-Received: by 2002:a2e:90d6:0:b0:246:e44:bcf6 with SMTP id o22-20020a2e90d6000000b002460e44bcf6mr11131973ljg.501.1646746169126;
        Tue, 08 Mar 2022 05:29:29 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id c4-20020ac244a4000000b004482d916b47sm1578711lfm.253.2022.03.08.05.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:29:28 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next 2/2] man: document new bcast_flood config/query support for bridge ports
Date:   Tue,  8 Mar 2022 14:29:15 +0100
Message-Id: <20220308132915.2610480-3-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308132915.2610480-1-troglobit@gmail.com>
References: <20220308132915.2610480-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/bridge.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 81ce9e6f..1d03eef1 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -46,6 +46,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR flood " { " on " | " off " } ] [ "
 .BR hwmode " { " vepa " | " veb " } ] [ "
 .BR mcast_flood " { " on " | " off " } ] [ "
+.BR bcast_flood " { " on " | " off " } ] [ "
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
 .BR neigh_suppress " { " on " | " off " } ] [ "
 .BR vlan_tunnel " { " on " | " off " } ] [ "
@@ -466,6 +467,11 @@ switch.
 Controls whether multicast traffic for which there is no MDB entry will be
 flooded towards this given port. By default this flag is on.
 
+.TP
+.BR "bcast_flood on " or " bcast_flood off "
+Controls flooding of broadcast traffic on the given port.
+By default this flag is on.
+
 .TP
 .BR "mcast_to_unicast on " or " mcast_to_unicast off "
 Controls whether a given port will replicate packets using unicast
-- 
2.25.1

