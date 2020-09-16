Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DAE26BB0C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIPDuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIPDsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:40 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8EEC06178B;
        Tue, 15 Sep 2020 20:48:39 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g72so6805220qke.8;
        Tue, 15 Sep 2020 20:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wlvdgZkz5rubXgtH71Tv9xjseTgD9CKo6CIvDkCg1ho=;
        b=aoWstjHBuXZCkzEoj2P/jCOGFaJTHmtAqtaNQSOWXIdyg/bVtPece9bMLhE0fqFw40
         dSlbW8pWEkqS1IhIagb6/msDVoECIYI7vo7VoyNoqmne3hiHKPqZyvmioXL49PmHJyJ+
         PkZr+B4g3qMIqCGNv/RAMmEnUYy56LsmIrjRa8BNTknZF17xeyYIE48pA8XvBz2E7aiW
         jfLc1EiSh3eovnCc6ZV+86sYDAXK1ipYKFkbjpqB3yvTHM1g2F86p02SKjFzY09f4+DK
         QY069k+sFUWvitieaw/KXZTcFzGpqJX6D86EM4M5b6o1AhjOjM2FcpX4kqAeOOE0BU5+
         qIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wlvdgZkz5rubXgtH71Tv9xjseTgD9CKo6CIvDkCg1ho=;
        b=rZ01Ause3ATkS/JpW8gga9BlA/k58QaJjMgvMD6Om+3Ko5AnRKNTMnnf9a7KwC9Wx3
         IHuLZdr91OT7DhdjkDqXaZIfYR4MBpskiQD92ZlXG4Xa2i4s3mHrJAJ0s/DMD84tIf5d
         n4aqHi2+3zqW7/K+FpnYJgKh+P64jHfYR6yHvFlIAKjBW2Bpdk20Plv7j52zY4ojYwym
         +Zqc3YK9DMLbchIostWt0rwjDsyRBjcPzACkQtdZfiKH0KQtGy3qLdYCLzbUpBJ9e/o8
         Nvv9ll0g9xbtM0ZxyfDkmpswSBghHnicEnqct0sov9O2PvhSCm1ZvGKUBnv264GsCBgE
         qt/A==
X-Gm-Message-State: AOAM531oZGEpH0bM8whsDUGUA6EUbOlI/bMgjEmg7Uv+9wyePO0sCLYh
        svvgNDEqG+OGt3rtF/7Kwd6lI/zzSNQ=
X-Google-Smtp-Source: ABdhPJzYGrU2u0ar3Wns7j8V+2EOoQZcarV5adkEHze3ObhyFjYFNwQh5DMkluYetJY2zArrh8jRIg==
X-Received: by 2002:a05:620a:981:: with SMTP id x1mr19618540qkx.404.1600228119236;
        Tue, 15 Sep 2020 20:48:39 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id s20sm17604516qkg.65.2020.09.15.20.48.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:38 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id E6DA127C0054;
        Tue, 15 Sep 2020 23:48:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:37 -0400
X-ME-Sender: <xms:FYthX45qPG4KNnkKI0b1FYuv4dGe8-soC805kRiS5SLuukIStnM0fg>
    <xme:FYthX54OU94t1sfdT6V3Yx-2nZ5LTYkBPyz6cKacGhOrLxypUxyc8s9dHMjB11nWR
    gSxJ1hU6aNS3bSfag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhepkeejkeekudekieevuedufefh
    udeiheevvddvtddtveffteegvdehueeltdduhfeunecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphephedvrdduheehrdduuddurdejudenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthh
    hpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhn
    rdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:FYthX3eFh71hdvU3y4HM42P9llcwQ-N6s3HORbm8XYmX_j8m1SRAAg>
    <xmx:FYthX9IpNPWf2ByVFNnKGytM272PWnvl0riO4zexxzB0fbVXZvmViQ>
    <xmx:FYthX8I-pCqkCaij30dmNyVm_mhZ9xQyt2YUMTK4o_639MIl2PZFWg>
    <xmx:FYthX87jL4LDENrwKeB6z744ZX6WOPze49G-18dfCV8pahvxIl8PN91SZC4>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14549328005A;
        Tue, 15 Sep 2020 23:48:37 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v4 08/11] Input: hyperv-keyboard: Use VMBUS_RING_SIZE() for ringbuffer sizes
Date:   Wed, 16 Sep 2020 11:48:14 +0800
Message-Id: <20200916034817.30282-9-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a Hyper-V vmbus, the size of the ringbuffer has two requirements:

1)	it has to take one PAGE_SIZE for the header

2)	it has to be PAGE_SIZE aligned so that double-mapping can work

VMBUS_RING_SIZE() could calculate a correct ringbuffer size which
fulfills both requirements, therefore use it to make sure vmbus work
when PAGE_SIZE != HV_HYP_PAGE_SIZE (4K).

Note that since the argument for VMBUS_RING_SIZE() is the size of
payload (data part), so it will be minus 4k (the size of header when
PAGE_SIZE = 4k) than the original value to keep the ringbuffer total
size unchanged when PAGE_SIZE = 4k.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
Michael and Dmitry,

I change the code because of a problem I found:

	https://lore.kernel.org/lkml/20200914084600.GA45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net/

, so I drop your Reviewed-by or Acked-by tag. If the update version
looks good to you, may I add your tag again? Thanks in advance, and
apologies for the inconvenience.

Regards,
Boqun

 drivers/input/serio/hyperv-keyboard.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index df4e9f6f4529..1a7b72a9016d 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
 
 #define HK_MAXIMUM_MESSAGE_SIZE 256
 
-#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define KBD_VSC_SEND_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
+#define KBD_VSC_RECV_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
 
 #define XTKBD_EMUL0     0xe0
 #define XTKBD_EMUL1     0xe1
-- 
2.28.0

