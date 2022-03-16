Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6125D4DBA21
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355732AbiCPVc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349891AbiCPVcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:32:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D912612B
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 190-20020a2505c7000000b00629283fec72so2976508ybf.5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ClWHWDT7CX049DHEiNtpDNX5IpgHCXZ+VwyNFz6LgH0=;
        b=BgQoxgdV5GOf73pfQ/WGP4djssW35zmCCWWBcMg3sKVKaKAWoOy478TcfMYceVJP8E
         d78fbbA0woG1yefDfcPn10hFACuxmUhkh7435xs2Fr5UspRjKPdK7tixH+jn45ffsUcW
         Ieiqv5l/vOMll5MF6qYxGRU4iZ1V7BmSQy82orwqmrP4m+BtsynWLXgmDzioTbJVAYTI
         P0errtDwv+j1WQKwZ6PHhWWsJAQnQ3rQif7rrpsb5LjvwkSzzI+6vrP1tDU60hF/Hg26
         tSilzYtb93Tb/PdVXivKjZRL4Il4/TF5yLm0xYleD3waElFNybR1oT+/CNSR5rs+NjoB
         MCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ClWHWDT7CX049DHEiNtpDNX5IpgHCXZ+VwyNFz6LgH0=;
        b=65PTQDaot9wa0R3u/HWLM9852bXl44Sah9F2LeMvYhrxfQoHNm5forXk2L3Fnnys7i
         Ewx1LecAxvcDHfD8hFKbdevnRTeRaysy1JKSK711rP6G42UFtlU81QUFYWL+wWtR6lWN
         l9PjcBnr72dqMERhwkJDL4Ht8YOl81KunNQVg0G7qeaNX+ZG+YYnaGd6h/b2c3R6xUJE
         dh6jRsjogtHJ1MKFMv/X/tmlTeoYl1VZkzNfEVUVtv+2hPxo+paQ8+laVdQ0MApBQPlK
         9xkNAZ4kEGE0WkSL0rARYVHZDl0Q+NzK0MNQwQY4XDMqHd01Zwm41Tow4H/QQiccNxu0
         5cwQ==
X-Gm-Message-State: AOAM533u7Rgp650T5ZOL1evJO9VHzW1MxxzJQSPbtIJbcqhRaC1WewTl
        QY4aZruBPNeDcfcHpy53PVVriLmT
X-Google-Smtp-Source: ABdhPJx/jiIIlpFV/7eSyVqL8KKvmkPZhl1KWSpn6H+MQ7NUic0LfWYxav/NY2cKUYF59mOTgJAKzHruOw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:7dae:6503:2272:5cd1])
 (user=morbo job=sendgmr) by 2002:a81:6c97:0:b0:2e5:7aff:723d with SMTP id
 h145-20020a816c97000000b002e57aff723dmr2560658ywc.144.1647466269060; Wed, 16
 Mar 2022 14:31:09 -0700 (PDT)
Date:   Wed, 16 Mar 2022 14:31:04 -0700
Message-Id: <20220316213104.2351651-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] bnx2x: use correct format characters
From:   Bill Wendling <morbo@google.com>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling with -Wformat, clang emits the following warnings:

drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6181:40: warning: format
specifies type 'unsigned short' but the argument has type 'u32'
(aka 'unsigned int') [-Wformat]
        ret = scnprintf(str, *len, "%hx.%hx", num >> 16, num);
                                    ~~~       ^~~~~~~~~
                                    %x
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6181:51: warning: format
specifies type 'unsigned short' but the argument has type 'u32'
(aka 'unsigned int') [-Wformat]
        ret = scnprintf(str, *len, "%hx.%hx", num >> 16, num);
                                        ~~~              ^~~
                                        %x
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6196:47: warning: format
specifies type 'unsigned char' but the argument has type 'u32'
(aka 'unsigned int') [-Wformat]
        ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
                                    ~~~~             ^~~~~~~~~
                                    %x
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6196:58: warning: format
specifies type 'unsigned char' but the argument has type 'u32'
(aka 'unsigned int') [-Wformat]
        ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
                                         ~~~~                   ^~~~~~~~
                                         %x
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c:6196:68: warning: format
specifies type 'unsigned char' but the argument has type 'u32'
(aka 'unsigned int') [-Wformat]
        ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
                                              ~~~~                        ^~~
                                              %x

The types of these arguments are unconditionally defined, so this patch
updates the format character to the correct ones for ints and unsigned
ints.

Link: ClangBuiltLinux/linux#378
Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 4e85e7dbc2be..bede16760388 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -6178,7 +6178,7 @@ static int bnx2x_format_ver(u32 num, u8 *str, u16 *len)
 		return -EINVAL;
 	}
 
-	ret = scnprintf(str, *len, "%hx.%hx", num >> 16, num);
+	ret = scnprintf(str, *len, "%x.%x", num >> 16, num);
 	*len -= ret;
 	return 0;
 }
@@ -6193,7 +6193,7 @@ static int bnx2x_3_seq_format_ver(u32 num, u8 *str, u16 *len)
 		return -EINVAL;
 	}
 
-	ret = scnprintf(str, *len, "%hhx.%hhx.%hhx", num >> 16, num >> 8, num);
+	ret = scnprintf(str, *len, "%x.%x.%x", num >> 16, num >> 8, num);
 	*len -= ret;
 	return 0;
 }
-- 
2.35.1.723.g4982287a31-goog

