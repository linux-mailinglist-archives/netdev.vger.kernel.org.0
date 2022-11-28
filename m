Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8477363AD41
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiK1QF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiK1QF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:05:26 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E151F2E2;
        Mon, 28 Nov 2022 08:05:25 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l11so16073104edb.4;
        Mon, 28 Nov 2022 08:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=JqZg2ywyYLo3zUtTsWH5RWmXeuLvZykORGr/Gb60NAsADF7rtS3KT0EX0WW2u20lJ3
         J6DrGMgEiNI1PQWIheOVJH/eIB1hJd7Z6fjkwr63JE1LAywQWEFxLS9rRrAROfmJZs6z
         CefJrsBdwAloK5qJRW7+3tklBf4blxUcoHszSybR5M6zqIGSAdn8/rbdixdTMFaR+0ZA
         3ohqN6xEGGXpJF1m/+cDaaZOzuQg2GQtDIc9aJGUUGO5zWRnzBHrePRYE9rlkF7QZk8f
         BYsgr67i3VBYt1J2aLZ5zCIBRX5csoJWa5JNx66AHOLkngMNNUaDwIBjTs2bPKBPajD9
         R7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=pZmby+khjHBplMSzxijSlFcx5Fw5cBFkxnAkoeH2gk3FwTIDYQ2seIDmB1NRKG0aVC
         +FNTLEAlqUa2vKGFl05gRrNOPZVhiDhutAAWv9SP+xfF8kbnpDGfzFQe+zrIo2yNa5PH
         vAo2AP1M9nV4oPWyj9GJ8jnFBm6lc2nRo7bkYv9vhwDp+Yhx/oeB+x4L57DKxObjcihI
         qopSdfRXd2fCSzMlYGpgn2UPJ4UvKZxC7KzGZUOXuIL4zbMfFKZdoaJHS+qFL5ophei5
         mo68SFOV1pa4w+a7oL9LbdB+zkylTtYxeR9Q520yKXMFZJAX406OJvwT7/lbRhwy35Kq
         3b2A==
X-Gm-Message-State: ANoB5plJtJruueOfmZkGVD73uErbC4Js1Dz3zoBmVKE+VXeTy1WmMTX8
        rDXTrtpqy2HD9ATEBEW6Pb4=
X-Google-Smtp-Source: AA0mqf6QgiYQF1SffUf9rgrl3sKpFdizd1nyJA1yk7VwKfVSRUBVJis7Eqxz1JyHnm/OI1r7s2EDuQ==
X-Received: by 2002:aa7:ce86:0:b0:46b:1872:4194 with SMTP id y6-20020aa7ce86000000b0046b18724194mr6641043edv.362.1669651523496;
        Mon, 28 Nov 2022 08:05:23 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id w21-20020a170906385500b0077a201f6d1esm5127264ejc.87.2022.11.28.08.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:05:23 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 1/3] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date:   Mon, 28 Nov 2022 18:04:59 +0200
Message-Id: <20221128160501.769892-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128160501.769892-1-eyal.birger@gmail.com>
References: <20221128160501.769892-1-eyal.birger@gmail.com>
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

This change allows adding additional files to the xfrm_interface module.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/Makefile                                    | 2 ++
 net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (100%)

diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 494aa744bfb9..08a2870fdd36 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the XFRM subsystem.
 #
 
+xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
+
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface_core.c
similarity index 100%
rename from net/xfrm/xfrm_interface.c
rename to net/xfrm/xfrm_interface_core.c
-- 
2.34.1

