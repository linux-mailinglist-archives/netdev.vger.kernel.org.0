Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CCE26BAFE
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgIPDuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIPDsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:42 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BA9C06174A;
        Tue, 15 Sep 2020 20:48:42 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k25so5135586qtu.4;
        Tue, 15 Sep 2020 20:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIFc7LuWq6/SDZOUTHn9GVK3D00/m3BkPHzN5DCgsD4=;
        b=ZYg6DHCJgiXOqLkRAE0G4EuSglr3059AHlu3tNYRSz5hfrmExqoC+YkbGRNsxSB5TN
         TOGawGXiVOFeG4uIqoceMSKyB7l9Q/mm0x8odMexr7Cyqu6iHFpdj90PkjxGCMMwmCpm
         UqhmVs/9a8QrqRXNMXE3On+WdqE1GQahBSqRIvA+OvLSE2C5sQz81NwYcBNoXuSY6QAM
         qcfopsb6b63hKw2X1BMnF605hRr+nB7TIbeJQUWkqRD24R+zkqAHU9545oCiTkWNhS7j
         GDnzbRKFkA9VdwKd/ZUNpgRNoyk+0x6xxcKQVey4n7/VbAQAArOju1TWMkx2+b+al829
         LdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIFc7LuWq6/SDZOUTHn9GVK3D00/m3BkPHzN5DCgsD4=;
        b=VFeqL0idTWwOkAl4VMV3jqyuNYUEJw5EYZ2OCKbEtaE/Taa8KJYaxHA575qpapSrHj
         IARoI1gkfqwCdc7A6tb7DjkmH//LLjPVh7UjEIeqvHHNpXI6EzxB/bnXihZUZfVuE0ph
         2XQ5/U4tJTDPyKgX0V1VtnSYiJ7YnRueg3C+gJ/XBn4ppvGl3glYxQofJvhGxXCrn1RR
         kSy9Ek2F2b7UCtvpILqjHTmz2wCQa1Xb8WnSngsFvhjcEF/l9/u4b413ZbDZpT0Qdy+F
         wYWAxVf67+ZuyonS38VwOwBLkr/A40+j5qQwLTb812E2k/gimHxDitDqdJxyqsvaRCII
         m85g==
X-Gm-Message-State: AOAM530WdXv6U0ZKi6XHtNuwDb+iLzS8aqx1vNO6q4qu24JWi2S58g4H
        biAbmXRP+/cyLV5Xbzqvm2w=
X-Google-Smtp-Source: ABdhPJxAEKBLSYWAASkG0EfOqz16F5fTimww8YjtayjnuN9Q6t9VQbZyyEDYo5e6sr5mn+1hCGte6g==
X-Received: by 2002:ac8:44da:: with SMTP id b26mr8615198qto.147.1600228121341;
        Tue, 15 Sep 2020 20:48:41 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id j1sm18472218qtk.91.2020.09.15.20.48.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:40 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0F0CD27C0054;
        Tue, 15 Sep 2020 23:48:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:40 -0400
X-ME-Sender: <xms:F4thX1C1ifaoOInDU5aRgjn-BnyBsphWSbmHxwTwXoK4SAJGZwms5Q>
    <xme:F4thXzgvPn8vhjzXGlGPUjokvd4RPHjM5o_wsW4TGOkSsQh_W132nk9wuyampGkN6
    E-qP3fr7DvV-5QLew>
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
X-ME-Proxy: <xmx:F4thXwnD5hopykGfvr24iJhTirv6A-wUFlExYHeWmGBHX24Fx-PyUA>
    <xmx:F4thX_yMqqYeWJH1LuL_HcL7jLZ3Z-COkI6LTs7dItXStrE0tRr9Jg>
    <xmx:F4thX6Qz3O3yNWVGv72IODHeI44yv2ZCGddoOnWTdxUbKvnjxWJGxA>
    <xmx:GIthXzAbo-V7rm97xI42Z9xWR1nOV8R5EpeAONCvMhR-Z0Mk_fYkbYPM22g>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 148333280059;
        Tue, 15 Sep 2020 23:48:39 -0400 (EDT)
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
        Boqun Feng <boqun.feng@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v4 09/11] HID: hyperv: Use VMBUS_RING_SIZE() for ringbuffer sizes
Date:   Wed, 16 Sep 2020 11:48:15 +0800
Message-Id: <20200916034817.30282-10-boqun.feng@gmail.com>
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
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Michael Kelley <mikelley@microsoft.com>
---
Michael and Jiri,

I change the code because of a problem I found:

	https://lore.kernel.org/lkml/20200914084600.GA45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net/

, so I drop your Reviewed-by or Acked-by tag. If the update version
looks good to you, may I add your tag again? Thanks in advance, and
apologies for the inconvenience.

Regards,
Boqun

 drivers/hid/hid-hyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 0b6ee1dee625..978ee2aab2d4 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -104,8 +104,8 @@ struct synthhid_input_report {
 
 #pragma pack(pop)
 
-#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define INPUTVSC_SEND_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
+#define INPUTVSC_RECV_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
 
 
 enum pipe_prot_msg_type {
-- 
2.28.0

