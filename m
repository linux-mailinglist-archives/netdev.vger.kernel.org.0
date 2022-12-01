Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2728463F9A2
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLAVOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLAVOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:14:39 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B83BF66F;
        Thu,  1 Dec 2022 13:14:38 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id h4-20020a1c2104000000b003d0760654d3so3592147wmh.4;
        Thu, 01 Dec 2022 13:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=ZPTju31t9w7xAlbNxYiGePVe4PxjVmWUfFyHrZuFHOpPQ+Om0Kwa1uaMaqRCgKo6iZ
         tKSJIpxE7ZOAUQPZMTfcfzKHNxqZ+ZsuWL7QBiSAfuP3rJeZlTqItEZWcM1qWqSiqm7l
         znQWRzlySND9kCFoCRI/LSLW5O2+TVla+kUbHqx0qyt+Et14bO13+W86L4prXi0xtE11
         MRmj/Fjgnx8ecm9efTOz419r6ftLOo8iEg6s6yV/v6CTlCKuUUk6UBtsziYELkE/wB+R
         Vbx+Oa055ZoogAFSwOOfOeKxGalvlQ1MfkIUexK415zbqxFF1s0M464w46KZkWoOetaF
         zDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=Vd+bZyt2zYzTLr5RFhyTASsctIe81jbbOIG+kazc+6EuV4oGAuwXuLR5EXNEuZ6j6m
         QL76TAl0aGedp/MS/tUdK9WeREWindYS95185kTU9RLHAoCtAtTJJNwISHH1jaeytJmS
         SyySwqVCPHtyUYSyLSYJqzjEkcDDuOSXHxjiS3MScUAgHAtLHgnDtuLJHZvMPS5oPcIk
         Exdpmj71mJ9PTsvoK02IG8q22JEv/vSzA4YCGv0z9M1FRouF1pZ44Oz8PqxuOdMUCZY0
         0l2I0OJlobqBglrRrEMeKvm1c/ObgIyn1sy6bJL2ccJEEIqcXIA1grVjoubXyTGG2YUs
         3Txg==
X-Gm-Message-State: ANoB5pnx5LaPutK7ZjjpWvZi2o3Hal+av5GI/qr6/35MeqAOAj9fz6SO
        9aMyKOf/DS5H/Zu4yTvO1WY=
X-Google-Smtp-Source: AA0mqf6bYHN2wysDrhhAWut6JRqf7x8HmO2pfpuXXvVBpQYFiv5QlFIzAJDbRv/XIzPcQVj+Q0Domg==
X-Received: by 2002:a05:600c:3490:b0:3c2:7211:732e with SMTP id a16-20020a05600c349000b003c27211732emr53564411wmq.191.1669929276400;
        Thu, 01 Dec 2022 13:14:36 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id m35-20020a05600c3b2300b003b50428cf66sm7508708wms.33.2022.12.01.13.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:14:36 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v3 1/4] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date:   Thu,  1 Dec 2022 23:14:22 +0200
Message-Id: <20221201211425.1528197-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201211425.1528197-1-eyal.birger@gmail.com>
References: <20221201211425.1528197-1-eyal.birger@gmail.com>
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

