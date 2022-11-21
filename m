Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF212631914
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 04:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKUD72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 22:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKUD70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 22:59:26 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F962D1C4;
        Sun, 20 Nov 2022 19:59:24 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v3so10059121pgh.4;
        Sun, 20 Nov 2022 19:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27WM+Y8jWb1LbvGj3DTgTBmDJaPh9BKIXQ56Fw9urpk=;
        b=W2l2otg0QsQqjjC0xylN6Y9Y9t9QgGoBs8DnaTsfc0PZd88sh6kjbLZ16l2+Be0X6+
         wWuTINsam5mP8psCVXL5668tpkGyhqKiQzSnGe+0EU6nd7TPhqOb+OkLz61INCHP/2Ki
         Qvtn52r1ElroAH5F8J196hfAeGmy0SQ56vOxfP/zIf8jBg135myrGz8iUWGII32rfXPU
         k08oKkLkXOEr+louuFRLOcL+G+HcFbJuXZxqn1ZMDfICRx3Max4TOGV/um28QNCs4j+m
         z7PhNB/apyViyzHdTnhcwwtBDw/EWNtWEB4pw7lrYyMAP08B0jKLTTzfxhhVXE6MgkJb
         e5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=27WM+Y8jWb1LbvGj3DTgTBmDJaPh9BKIXQ56Fw9urpk=;
        b=eax4mFKA5UmNDdx3JXWUI30plBUS2zkHe1BzpRxjyJPJjwVzHX2BwuDK4ZcmpFIZ7V
         2573UR14pXrsFGvXgfpMm4A9lxC+JHwEYIPM6bfs78+fmbpYkbajr/NMrWiDZs/TK9CV
         lrYlNHxIGYSU4nPCFuHNNZGT65p0WIpIBbljIDH1GfJXeG6qvZXsYlivjbEbmfxdDR1H
         iS0CkWgdRP/vcdSb2wjbjX521ZP+QSSiC8xK4uCwOeH35jvQYPjVc1VGMft/cZUfTlB/
         t8S6RH5dDrxMR7qk+/8yNE7toDX2veJe/upeM8v6cMg6Cp5lRAzR6g2DRV4F7GuqMxb7
         at7A==
X-Gm-Message-State: ANoB5pmvPqCd5K8Hw3nUCHpgDgC8vXHP6ARV0SuvWF5zFLPevKQoLlg+
        uGt51Oi6Of7I0RJrqXGlRPBvCDnSrFk=
X-Google-Smtp-Source: AA0mqf49jEfvGyxZO0jXVZ81EVi8wO9jpymaMotqlDjuJYfCHuNg7X8sS421I3+cFgNY3VQ6HT9slQ==
X-Received: by 2002:a05:6a00:d66:b0:56a:fd45:d054 with SMTP id n38-20020a056a000d6600b0056afd45d054mr2845822pfv.3.1669003163465;
        Sun, 20 Nov 2022 19:59:23 -0800 (PST)
Received: from debian.. (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902f64900b00176d218889esm8393163plg.228.2022.11.20.19.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 19:59:23 -0800 (PST)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        kernel test robot <lkp@intel.com>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH net-next] Documentation: devlink: Add blank line padding on numbered lists in Devlink Port documentation
Date:   Mon, 21 Nov 2022 10:58:55 +0700
Message-Id: <20221121035854.28411-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <202211200926.kfOPiVti-lkp@intel.com>
References: <202211200926.kfOPiVti-lkp@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2915; i=bagasdotme@gmail.com; h=from:subject; bh=FikTYVYcBbXw6Hy49WYOku8tu7kNbGLfWCUs6r4Xui4=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDMlV3+vWq35h2/c5/h1HMfvSbskN+ypMpH4mH7ohbjXnrIYQ b/C+jlIWBjEOBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExkxzKGP9wKKzxurLq/431XCXOCya 2vvwq7LwsvDrhwp/fr1ZK78pyMDEtbd1u0vd7ocHFyyt5pTrpbBKJfr5L9mPL95HURxdfOUbwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported indentation warnings:

Documentation/networking/devlink/devlink-port.rst:220: WARNING: Unexpected indentation.
Documentation/networking/devlink/devlink-port.rst:222: WARNING: Block quote ends without a blank line; unexpected unindent.

These warnings cause lists (arbitration flow for which the warnings blame to
and 3-step subfunction setup) to be rendered inline instead. Also, for the
former list, automatic list numbering is messed up.

Fix these warnings by adding missing blank line padding.

Link: https://lore.kernel.org/linux-doc/202211200926.kfOPiVti-lkp@intel.com/
Fixes: 242dd64375b80a ("Documentation: Add documentation for new devlink-rate attributes")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/networking/devlink/devlink-port.rst | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 643f5903d1d8aa..98557c2ab1c11f 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -130,10 +130,11 @@ it is deployed. Subfunction is created and deployed in unit of 1. Unlike
 SRIOV VFs, a subfunction doesn't require its own PCI virtual function.
 A subfunction communicates with the hardware through the parent PCI function.
 
-To use a subfunction, 3 steps setup sequence is followed.
-(1) create - create a subfunction;
-(2) configure - configure subfunction attributes;
-(3) deploy - deploy the subfunction;
+To use a subfunction, 3 steps setup sequence is followed:
+
+1) create - create a subfunction;
+2) configure - configure subfunction attributes;
+3) deploy - deploy the subfunction;
 
 Subfunction management is done using devlink port user interface.
 User performs setup on the subfunction management device.
@@ -216,13 +217,17 @@ nodes with the same priority form a WFQ subgroup in the sibling group
 and arbitration among them is based on assigned weights.
 
 Arbitration flow from the high level:
+
 #. Choose a node, or group of nodes with the highest priority that stays
    within the BW limit and are not blocked. Use ``tx_priority`` as a
    parameter for this arbitration.
+
 #. If group of nodes have the same priority perform WFQ arbitration on
    that subgroup. Use ``tx_weight`` as a parameter for this arbitration.
+
 #. Select the winner node, and continue arbitration flow among it's children,
    until leaf node is reached, and the winner is established.
+
 #. If all the nodes from the highest priority sub-group are satisfied, or
    overused their assigned BW, move to the lower priority nodes.
 

base-commit: 8bd8dcc5e47f0f9dc40187c3b8b42d992181eee1
-- 
An old man doll... just what I always wanted! - Clara

