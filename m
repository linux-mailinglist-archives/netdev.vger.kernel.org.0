Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58C8526594
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381703AbiEMPDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381823AbiEMPCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:02:53 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818D54DF73
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:02:38 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id h3so7024037qtn.4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8o2AIqylfLZkog3xkyjBPBeF8N+IzHoGrC+frJH1aPY=;
        b=J3P2ravViG3MxBAvV+R+gEvIjCvzkGjAOAyhkUSsqSQGCxPyWmJLN8fhwHkGhjFi4v
         e8onmX7tSTRs+6ferLVSCzoC8hJso+SkpxQB6P1c64/OuAeW++NHblGRq1Llh/zt3dSj
         O24Z3ScZwACs/29AIqkb5LjSQNAk5CZhFsOcCTArEbgjlI1kpjDpy8FGppywBURhINbj
         zd18/x/IfDztrWtsWDm5JLVqWIRhZkBeFfe/HibYzjShTYIdDeE8d8IumKr57jcZRtF8
         a/H6ORs66fyNRCCNn5JVIPBVZR8Ho4B2aOsGRGq/EdLSUtRLMMzoQl3FqI9DcfqnwMEn
         PrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8o2AIqylfLZkog3xkyjBPBeF8N+IzHoGrC+frJH1aPY=;
        b=Hdv67kYfJkVmeYpeP45xXsjOrah1ySFPwUlIl/6YrQoLzg7ra1IvkemHU67Nw1CXMl
         04DYnUlHQynl3C4EhifcOMbxN7WPbNQEku0m0tqc2GB4ibqLlOUkhk4RS/bzUhqZ9Yaq
         /GTxQn/bBP4IQmdpxwQKC+Ka22nS15LUPZZg8uNOZF+/pUG0ifokevYIfRyZRV7vUbCd
         YyySYWKbfysEnuMXz+gQ1uMwJKdUGmrL1wspRf+1v+bsSuOSvL0oHQ+l1DjVZy0nyYnf
         eHVO2RjsboDE9+5HN87wIFRa4Kag9WC67lxd3Z3V8yubJE00w7K8YPuJ2yQjPOyDS4C0
         gn7A==
X-Gm-Message-State: AOAM5325N7D53tqW3bHDG9z7fd/odPjT+su/aDHT0odoFAe3Tl2vwUjn
        1268vkIDPy3y+fKy56magMrwJ+dv5HY=
X-Google-Smtp-Source: ABdhPJzYyZAqyq7sM72rlSQSeXgY21DYgt/vchKV0vOVUrCSk5+wmDcSRcRfJAGeWCK32tACLG9jfg==
X-Received: by 2002:ac8:5fd3:0:b0:2f3:c522:1369 with SMTP id k19-20020ac85fd3000000b002f3c5221369mr4814443qta.225.1652454157038;
        Fri, 13 May 2022 08:02:37 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bs41-20020a05620a472900b0069fe1fc72e7sm1514984qkb.90.2022.05.13.08.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:02:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCHv2 net] Documentation: add description for net.core.gro_normal_batch
Date:   Fri, 13 May 2022 11:02:35 -0400
Message-Id: <21572bb1e0cc55596965148b8fdf31120606480f.1652454155.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

Describe it in admin-guide/sysctl/net.rst like other Network core options.
Users need to know gro_normal_batch for performance tuning.

v1->v2:
  - Improved the description according to the suggestion from Edward and
    Jakub.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Reported-by: Prijesh Patel <prpatel@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f86b5e1623c6..5cb99403bf03 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -374,6 +374,17 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
 If set to 1 (default), hash rethink is performed on listening socket.
 If set to 0, hash rethink is not performed.
 
+gro_normal_batch
+----------------
+
+Maximum number of the segments to batch up for GRO list-RX. When a packet exits
+GRO, either as a coalesced superframe or as an original packet which GRO has
+decided not to coalesce, it is placed on a per-NAPI list. This list is then
+passed to the stack when the segments in this list count towards the
+gro_normal_batch limit.
+
+Default : 8
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
-- 
2.31.1

