Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5185659F248
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 05:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiHXD6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 23:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiHXD6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 23:58:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271DE8F95C;
        Tue, 23 Aug 2022 20:58:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x14-20020a17090a8a8e00b001fb61a71d99so316303pjn.2;
        Tue, 23 Aug 2022 20:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=XnJ7AMrJzuV2TwTrvWhzSRhCdIxVJCjq6yXNAYW+UB0=;
        b=qGK7He4OKI6UkdsAVTBcp5mFGw6DozGbw4RMgVuHY6abRaD6a2QiqR3EraVZOeWKiz
         EsufOOzo8PX8eVy95zhrB/l6E2R6n0AVEZGMLOMsXsJMuh7mhIxkX3gV5Yj9ttyF/Aoh
         vNanOPIbTHomaL9q+donu7/3qwcAMjs66SftAaqp8ljbgzwqjH+9C6p0RwJqK2Hk93pj
         Qoh+MyyFHTs/4BqCF+Opn8I8CLb2h5OXYYCWReV6YYlz3XO10VF6hxtLeWfxLsk3wi+C
         OGkjtOdTHkAuMklxnDhmb7XD+/HWDlqXFYe9a/2VpHcLGxChNVcInSs97p0GcbFf5Ere
         7UdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=XnJ7AMrJzuV2TwTrvWhzSRhCdIxVJCjq6yXNAYW+UB0=;
        b=iOyUjJB1aL3nz75s0Ujp4l5JVIosLBtpcPaFXSg2bCLCZiLvd2ilDYc1FueGO8iRXb
         1VDDgXQRcbjKPJAN1cmThw/3FSx+/txQJelOopx+beiL78j1wm3Wt4ktW9gR1rgfmo8X
         MY76MtS2kw6yStiLs1pSakKz3E3TDRT+WuV5GWISPhcB4ul0G7JLS60EyxwAMGqCyMed
         rrcgSfvIZzHDryd83p19mD01inEAeNn/Sv4lCqf6MVPNZpyDgxWrg+z693cCbTEydOQW
         Bd3JH03Iobxc3/Ihe9qhxNxgbFVQW1DtaSF5dSWnvsfGQudasHc7o1CI9PwD6fzaROyw
         lTnw==
X-Gm-Message-State: ACgBeo0fgDe6zJyF4nSU3aMr411jxuwa5cDTr1RdSfREcFq5hhdfNqQJ
        E/Hp38X6mIzSshVGn31HHVe9c0OO4J904g==
X-Google-Smtp-Source: AA6agR59gu4SgV+3SCD2JTnXnnPlWcDI64Pj075ODTxeqJ+ZiU+oEAf0Hmn07VcQ9yGFJvc6ilgfVQ==
X-Received: by 2002:a17:90b:4a82:b0:1f5:5eaa:68a with SMTP id lp2-20020a17090b4a8200b001f55eaa068amr6234491pjb.13.1661313516349;
        Tue, 23 Aug 2022 20:58:36 -0700 (PDT)
Received: from debian.. (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ce8600b0016db441edd7sm4515195plg.40.2022.08.23.20.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 20:58:36 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Xin Long <lucien.xin@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Antoine Tenart <atenart@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] Documentation: sysctl: align cells in second content column
Date:   Wed, 24 Aug 2022 10:58:04 +0700
Message-Id: <20220824035804.204322-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3249; i=bagasdotme@gmail.com; h=from:subject; bh=CTzfIwVkMQLEVH+/0qZoBRwFnHgAU1IjqVicj/qKXfE=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDMmsC4+Z325/MbOZ54j5h8LOr08sKu8vrFz/7mP/tNb5omGd rPV/O0pZGMQ4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRr6cZ/tf1dLY9XnNp2dVTuhsrf5 9tb7E99qzqS411H9vzGpVja5QY/rua8U6YEb/9t/9kq6LU9hWuTm6mBpdCzUPmRsZqbnOW5AYA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
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

Stephen Rothwell reported htmldocs warning when merging net-next tree:

Documentation/admin-guide/sysctl/net.rst:37: WARNING: Malformed table.
Text in column margin in table line 4.

========= =================== = ========== ==================
Directory Content               Directory  Content
========= =================== = ========== ==================
802       E802 protocol         mptcp     Multipath TCP
appletalk Appletalk protocol    netfilter Network Filter
ax25      AX25                  netrom     NET/ROM
bridge    Bridging              rose      X.25 PLP layer
core      General parameter     tipc      TIPC
ethernet  Ethernet protocol     unix      Unix domain sockets
ipv4      IP version 4          x25       X.25 protocol
ipv6      IP version 6
========= =================== = ========== ==================

The warning above is caused by cells in second "Content" column of
/proc/sys/net subdirectory table which are in column margin.

Align these cells against the column header to fix the warning.

Link: https://lore.kernel.org/linux-next/20220823134905.57ed08d5@canb.auug.org.au/
Fixes: 1202cdd665315c ("Remove DECnet support from kernel")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/sysctl/net.rst | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 82879a9d5683ef..68d7239d3f75dd 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -31,18 +31,18 @@ see only some of them, depending on your kernel's configuration.
 
 Table : Subdirectories in /proc/sys/net
 
- ========= =================== = ========== ==================
+ ========= =================== = ========== ===================
  Directory Content               Directory  Content
- ========= =================== = ========== ==================
- 802       E802 protocol         mptcp     Multipath TCP
- appletalk Appletalk protocol    netfilter Network Filter
+ ========= =================== = ========== ===================
+ 802       E802 protocol         mptcp      Multipath TCP
+ appletalk Appletalk protocol    netfilter  Network Filter
  ax25      AX25                  netrom     NET/ROM
- bridge    Bridging              rose      X.25 PLP layer
- core      General parameter     tipc      TIPC
- ethernet  Ethernet protocol     unix      Unix domain sockets
- ipv4      IP version 4          x25       X.25 protocol
+ bridge    Bridging              rose       X.25 PLP layer
+ core      General parameter     tipc       TIPC
+ ethernet  Ethernet protocol     unix       Unix domain sockets
+ ipv4      IP version 4          x25        X.25 protocol
  ipv6      IP version 6
- ========= =================== = ========== ==================
+ ========= =================== = ========== ===================
 
 1. /proc/sys/net/core - Network core options
 ============================================

base-commit: fa2bc96259098a3bc1f32a10bfe1139c0f742256
-- 
An old man doll... just what I always wanted! - Clara

