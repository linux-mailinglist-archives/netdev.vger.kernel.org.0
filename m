Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D744C6480B7
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLIKNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLIKNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:13:22 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A921A2F3BA
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:13:21 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d3so4390581plr.10
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 02:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQ0epaNqSDiQuqO7IqH176L9cODNUQ76o8ksHLBRnr0=;
        b=UL0bUoI73x2Gn90Av+jmAH4RYz12xK5lkoiWF7sATACuaOhbWS5VmkH2bzsNmn60C9
         EDIrQNgvrW/68q+hPY+t3eDLbiJStMXVB5McfLPKITL6mjCbJO9Ueftgze5cpB07i+N6
         4AsfikOnY9N21VfpIhRvdw/DiEp2A7+/IdrF1P+CkIcZeC+WYKHvArDWDDpnVsSw6Fl5
         Wr4AEBe1mhvTDBFoPKwPXq/mqw8i4c1F8FEeJLwuDPpK3EWLS3Pfdk+sfNK73fjEMOeA
         u8yyPkV4dpQesyDetriSkrAlglxpwV6jgryNNq8XNak8E12Ov5Pz5Haf2AvD2UaP5mPR
         Zwag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQ0epaNqSDiQuqO7IqH176L9cODNUQ76o8ksHLBRnr0=;
        b=WPM5NEdy9FDCdAXbRcF+iWtcssGIHHjikszaBzUkfdEkfU2QLD6IZB9k0zJOLpdNlz
         uoVw3bwoEYXUuRF9eMBx1Wr5YGPe/bymyQPwmjawCx0e9d8ULCTzLJ5UNuUUMz6evf/C
         QbyKc0pNNomwdCxNgYOgO4rDsVtVKnD0E2xP0HHKIUb8hTK0ppwvp/u+hb/hqxxZ7coO
         loJtYFd+bSUuhICJ7CwpeTxOIEyGucrooqfXM6OLPPYFcHb02k1gLN1XVmIHmbWfA06g
         qEgNOC9lt498tCZk4If4XPI04hQK+gexCy9/qNwGPvy2v2DmVhoBrv+9pXaEp+Ykh/4r
         IBjg==
X-Gm-Message-State: ANoB5pmAbf3e9dhjtKhWo/o9WgWgzHcJrXb7jZ0yZyBUXo11l24GAGjJ
        uKTYOwfRUDD8KdM2wSVFsdIUI7Kwkqftk25E
X-Google-Smtp-Source: AA0mqf5ApaFG9K2jTmfC01db9pHdoykVjR4OaZOONgs0ccEx1WNz5ERr4lATDDHGnhrsPqvY+ZUzWw==
X-Received: by 2002:a05:6a20:9c93:b0:a5:6e3d:1055 with SMTP id mj19-20020a056a209c9300b000a56e3d1055mr6724120pzb.16.1670580800658;
        Fri, 09 Dec 2022 02:13:20 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b00561d79f1064sm936677pfb.57.2022.12.09.02.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 02:13:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/3] bonding: access curr_active_slave with rtnl_dereference
Date:   Fri,  9 Dec 2022 18:13:03 +0800
Message-Id: <20221209101305.713073-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209101305.713073-1-liuhangbin@gmail.com>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
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

Looks commit 4740d6382790 ("bonding: add proper __rcu annotation for
curr_active_slave") missed rtnl_dereference for curr_active_slave
in bond_miimon_commit().

Fixes: 4740d6382790 ("bonding: add proper __rcu annotation for curr_active_slave")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b9a882f182d2..2b6cc4dbb70e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2689,7 +2689,7 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!bond->curr_active_slave || slave == primary)
+			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)
 				goto do_failover;
 
 			continue;
-- 
2.38.1

