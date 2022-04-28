Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E01512AAA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 06:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242761AbiD1Eso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 00:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242750AbiD1Esk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 00:48:40 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198067E1CC;
        Wed, 27 Apr 2022 21:45:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so4741562pjb.3;
        Wed, 27 Apr 2022 21:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qqLZH2kT0VZk1aTqY0djLHvcpdD94tYke0uBRNxBxKo=;
        b=C5GChY4u5CBRL+hIkU67WO5B/AEtUj9yLTNI3ZvuwJAF+0pxp4BzAsThqBazrQ36pM
         yBGfAEBffCqxcGXNkoiwFTVLYa5RixeZvSOlbZqGJ1NDyel+JZikML5609hjwQY9aUxJ
         V31lswIPw9Lxtmx7bxlm25+GTIuQ9uVLbH5wr0i/1m3imbsm/eb5nbZGyg8ctHg/qpiz
         3RbfFEawH4sV3HfAOeMFExBxzMWNvzY+brGRGufbnqwrxX5FYXmanUNJ8/s8qnmBBkKi
         HBcb5D7ZrJ5dIQ59JOnn6hhprakFYFjiW2GjcB6gBfBdl+prtPdNRQMfvuvSV/mr1GOa
         0nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qqLZH2kT0VZk1aTqY0djLHvcpdD94tYke0uBRNxBxKo=;
        b=agVVK3WgmJoJKfqkFSN3dxemInI9TWM93BAYQAONqZo41gzfchQMHrp0iUzmyEoScx
         Tjbb2/uQjlKLpIvZIU7dQn2vRS9oX0ywhogtMI1kInkNNlQlP5cM5kC2dy1PdMZyo28C
         TLaCZzmRn+0rsgPAndYb7r0EDr0Hzv8hwqZKrerOyqzVKtIu2RT7+gpSBbLoKbsGe3Yh
         gNCF1gBtqb3DzRZ8eMuGMcR94XGTmg7Zb/SDL8aiSCTHG6wVdccBboHSswbAtYcakvT/
         876lxtHlKb6HA4/ug0vxIVs9VvAiQeIjdgrZovqk/nxDZ3kfzE3VehMxkk9VRJTkp+MK
         NNCg==
X-Gm-Message-State: AOAM532nYGmc+An4PCVFz+EZMd37mmX3tPJyQJLgoltiWj140pQWh8QG
        3zPX3fWk0kmXmf1fmI7XhCRdWwFOvQw=
X-Google-Smtp-Source: ABdhPJxXcrF2Zv46HSOwFqqwZ0pt1cf5lLg0jz0BIQOLJ5LLLijZUgEuxQ9VHnWiyxbWPP01ZbGW7A==
X-Received: by 2002:a17:90a:8591:b0:1b9:da10:2127 with SMTP id m17-20020a17090a859100b001b9da102127mr47623045pjn.13.1651121125346;
        Wed, 27 Apr 2022 21:45:25 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0050d3aa8c904sm14301162pfg.206.2022.04.27.21.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 21:45:24 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        linux-kselftest@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, lkp-owner@lists.01.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/2] selftests/net: add missing tests to Makefile
Date:   Thu, 28 Apr 2022 12:45:10 +0800
Message-Id: <20220428044511.227416-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428044511.227416-1-liuhangbin@gmail.com>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
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

When generating the selftests to another folder, the fixed tests are
missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
  	TARGETS="net" INSTALL_PATH=/tmp/kselftests

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3fe2515aa616..0f2ebc38d893 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -30,7 +30,7 @@ TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
 TEST_PROGS += cmsg_so_mark.sh
-TEST_PROGS += cmsg_time.sh
+TEST_PROGS += cmsg_time.sh cmsg_ipv6.sh
 TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
@@ -54,6 +54,7 @@ TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 TEST_GEN_FILES += toeplitz
 TEST_GEN_FILES += cmsg_sender
+TEST_PROGS += test_vxlan_vnifiltering.sh
 
 TEST_FILES := settings
 
-- 
2.35.1

