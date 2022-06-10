Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1335546852
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344878AbiFJOax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiFJOau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:30:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EED13C356;
        Fri, 10 Jun 2022 07:30:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so2237787pjq.2;
        Fri, 10 Jun 2022 07:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=feBvHz91O0Ca33nvuwSIX9xdV8Z7lZ5W40GP9R4BSMI=;
        b=KNCPTXO+VU0QU2Rm4rN0b59MrTFIKX8+mjfV+/WPKjAKgslsqh7jZi/m7Bz05XfjU2
         cSu8ME/b8IAFaejqE/4ifyBUuozzF3Hf396yZBuwIkKgiSTn87CUPnCdYde6PNflAmW9
         VQ0LHMuXVhYStBJqNvilmW4oyJwqKRoDCMI7MRtv0y9ee4GLPqJa/rlXL1C+wJyzAbZA
         UXN8kacGMtz97pVQaCsKfzjsNoWL7MGgFTazd3XrBj+1Q6qse/9BTcWI3rr4GhDz0rgn
         vIR4cZugB1ZaMc+/MBBo0kvRWD+H5+faD5iI/IdkdbBlzLzONqxmB+y99e1CuTbKdM0c
         fYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=feBvHz91O0Ca33nvuwSIX9xdV8Z7lZ5W40GP9R4BSMI=;
        b=kTkwKb9Nyn5S9nfX/v9H2Q0S8Bpzj8Lhq7tkf34zS7qf+49XVCkk305w9geNaF4ury
         oHgjbkoWOe4GQfapb2oDE1FZlN8ancslkRt0Jb5/bFQdNSWAf9xM6dl6pbRBWr5djKUL
         FsCxSYRuRNlD2ePibOzQChGkXrPDlH0MDU5p+hv5Bvxhu+nvo5Cwu0Ht0oj4wal2vkTK
         9n+1c/9bhA3OgKHEym0PyPNP+4EekwsbFLihVTHv/GChCcOqSPmYyyMuJ9HYk5AORtwy
         TBx7EtmAcl49dJkSufVwF9XnVQyfD/EkEDuot7HrmaG/qKX3vSlROKw84xpFKr4chFoH
         r/Jw==
X-Gm-Message-State: AOAM5311aZgruhkuvJI8e2Ok1tKSF00fKs63mtWZPGSml+NdBRzEDo7R
        gQJH0z5g5yN/1Xf1JeUsq8I=
X-Google-Smtp-Source: ABdhPJwc+sPVxxzUscFQsTH5xNhZW1V/Co+Jp3TatAN9pQk6QA7xrh+Ru7ObDTs2VeSzX2brrjv6ew==
X-Received: by 2002:a17:902:e847:b0:164:4201:1d1f with SMTP id t7-20020a170902e84700b0016442011d1fmr45165199plg.84.1654871441135;
        Fri, 10 Jun 2022 07:30:41 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm18851339plg.292.2022.06.10.07.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:30:40 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 1/7] can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
Date:   Fri, 10 Jun 2022 23:30:03 +0900
Message-Id: <20220610143009.323579-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the next patches, the scope of the can-dev module will grow to
engloble the software/virtual drivers (slcan, v(x)can). To this
extent, release CAN_DEV by renaming it into CAN_NETLINK. The config
symbol CAN_DEV will be reused to cover this extended scope.

The rationale for the name CAN_NETLINK is that netlink is the
predominant feature added here.

The current description only mentions platform drivers despite the
fact that this symbol is also required by "normal" devices (e.g. USB
or PCI) which do not fall under the platform devices category. The
description is updated accordingly to fix this gap.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Please share if you have any suggestion on the name. I hesitated a lot
between CAN_NETLINK or CAN_DEV_NETLINK (because netlink is the
predominant feature) and CAN_DEV_HW (because this targets the
non-software only drivers, i.e. the hardware ones).
---
 drivers/net/can/Kconfig      | 18 +++++++++++-------
 drivers/net/can/dev/Makefile |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index b2dcc1e5a388..99f189ad35ad 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -48,15 +48,19 @@ config CAN_SLCAN
 	  can be changed by the 'maxdev=xx' module option. This driver can
 	  also be built as a module. If so, the module will be called slcan.
 
-config CAN_DEV
-	tristate "Platform CAN drivers with Netlink support"
+config CAN_NETLINK
+	tristate "CAN device drivers with Netlink support"
 	default y
 	help
-	  Enables the common framework for platform CAN drivers with Netlink
-	  support. This is the standard library for CAN drivers.
-	  If unsure, say Y.
+	  Enables the common framework for CAN device drivers. This is the
+	  standard library and provides features for the Netlink interface such
+	  as bittiming validation, support of CAN error states, device restart
+	  and others.
+
+	  This is required by all platform and hardware CAN drivers. If you
+	  plan to use such devices or if unsure, say Y.
 
-if CAN_DEV
+if CAN_NETLINK
 
 config CAN_CALC_BITTIMING
 	bool "CAN bit-timing calculation"
@@ -164,7 +168,7 @@ source "drivers/net/can/softing/Kconfig"
 source "drivers/net/can/spi/Kconfig"
 source "drivers/net/can/usb/Kconfig"
 
-endif
+endif #CAN_NETLINK
 
 config CAN_DEBUG_DEVICES
 	bool "CAN devices debugging messages"
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index af2901db473c..5b4c813c6222 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CAN_DEV)		+= can-dev.o
+obj-$(CONFIG_CAN_NETLINK) += can-dev.o
 can-dev-y			+= bittiming.o
 can-dev-y			+= dev.o
 can-dev-y			+= length.o
-- 
2.35.1

