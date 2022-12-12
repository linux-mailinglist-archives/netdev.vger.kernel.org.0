Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA5649851
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 04:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiLLD5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 22:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiLLD5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 22:57:03 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8963D2D9
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:57:02 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id m4so10789496pls.4
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVoau7fdq8XxSEtDirBZFJj3Nuebyui+uwSqHqnQKGk=;
        b=BWW/GAgxn1rdSn4+Cjc4mQ0fRznFSNIhlQcTmv7k9h+A9OXcxKHwDd0wG96QlxDWbY
         PP5m/UoxTr8ROU4BsaLn7wzh/zAG9qdlbpw9hYKJol6PlwBEoma/LUJPLHR4oOBiYmyM
         lp2Dmbbebdsbpc1uK0UOldb7kQIwqvr2Q6e972S3o4u0Vt/ZKjcircUTjQGPb/9EmnKL
         cmlXlGbuezSf3kl1Yw+yJQbZdbvcuMjyBvgx5suBNGmTkSH7rhysR9KAPviwOsqSQ16V
         0hElGoYdlpdbdGTRR33CkpIJPtjQnniMhMD0fXTC/WK0FXh4PNbSnrf/x+437vLxNeMb
         Akqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVoau7fdq8XxSEtDirBZFJj3Nuebyui+uwSqHqnQKGk=;
        b=c/OVPb/69HYzYftFlMvYQrrL50aq7r0+aWs6KybqT2i2S1uJrCAQFiTnyxh0CmWey6
         Wfbwj9mv/tGTaeBtxgGmexh3AsJSV/+ug6ZJKQnvJv9bFgdaMc58/SoeRHPbLQLDnsz8
         3eXaf2rdEUmeeV5n/VXUTjkVo6Md2LQ/RrJXlMR5n9fqXIVnOCI37qZpyDzgMyf7/jSQ
         IEnFy/wDeaRUZIxXGjJFPOqZgL0CySxPPR2koutG/8Z1fV7Y/ziNxH2gDVo23ZSgSADQ
         RMY/ohS9xv8DOYa9UZozPkhajTKwHEAealexrVhFNWTkuFyoC27veLEJZ2okjhvIC64A
         vySw==
X-Gm-Message-State: ANoB5pnc7A60tBfo/HkscSjf1jOoBFC7Ta0DZ4Ws2wyi6JxaJpflMtRH
        t17kCQVPxFfagTGE++emDaAQNPBZxOFGvxcB
X-Google-Smtp-Source: AA0mqf4eYLndcHiBvGr9LaRjc5JQMdvClxnHvEpFQRhbQTk0LJpwSARZx2e4q0+S7y5OEmYhHOG4Iw==
X-Received: by 2002:a17:90a:6f46:b0:219:8144:7965 with SMTP id d64-20020a17090a6f4600b0021981447965mr14852303pjk.17.1670817421600;
        Sun, 11 Dec 2022 19:57:01 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w190-20020a6362c7000000b00476dc914262sm4231207pgb.1.2022.12.11.19.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 19:57:00 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 1/3] bonding: add missed __rcu annotation for curr_active_slave
Date:   Mon, 12 Dec 2022 11:56:45 +0800
Message-Id: <20221212035647.1053865-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212035647.1053865-1-liuhangbin@gmail.com>
References: <20221212035647.1053865-1-liuhangbin@gmail.com>
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

There is one direct accesses to bond->curr_active_slave in
bond_miimon_commit(). Protected it by rcu_access_pointer()
since the later of this function also use this one.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: use rcu_access_pointer() instead of rtnl_dereference().
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b9a882f182d2..0c8a8e0edfca 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2689,7 +2689,7 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!bond->curr_active_slave || slave == primary)
+			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary)
 				goto do_failover;
 
 			continue;
-- 
2.38.1

