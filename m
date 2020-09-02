Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E4025A3A1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgIBDCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgIBDBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:35 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A71AC06124F;
        Tue,  1 Sep 2020 20:01:35 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 60so2603989qtc.9;
        Tue, 01 Sep 2020 20:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Yk2pMhGvv9S+U0BqWQnaIboTmUxBkNbJxvGpozTlpY=;
        b=nl351QxCwAgNDVrX8AWDi554Z49St+Gk9HJC+dw044z16k73bHuIgis0AQRvFp3WCC
         Na1DIpB6kOTF8JsZ55upiJScY1r/0HLP80XfankgbR08DTHBGQPvPsenLZkdLSJ309w5
         ff5Xnmx6W0hnzUIM2i3bW34Z3b+p2PePwGrLLRtkrHQIf+3Edj/VGWhRYBdgCi3ZS8YG
         q9JYRnGTVClWerFGt2aNL6WgOEHDxko/BwmCJTheiNzwpyWfdHBnPXNPmTISTryfXsZp
         REcwDV7YuTxquSc7SoDYVCB9Zrkl/Z5wvjn9D3N9IeWVWSBiOi+HGT3Qbfy73AnFFugK
         jIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Yk2pMhGvv9S+U0BqWQnaIboTmUxBkNbJxvGpozTlpY=;
        b=cxLmZNh9XdZuyoF8kgf+UQ11F/ii8ieKCC5dftBkzV1JCCTZrf2n+JgvZRL4pwpxWZ
         ah8E7zeHaGlWh/BWs0QdFBHSuhyNFKuoqWiv+BFAr5SsVjWpwT4ZiJJ0g1qz69Mli8vn
         d0QDmwrAJPNZ+Hwgkcy0h+uv5NyAy0KW02QdlIZDv9wVRGBWwptDCeHF3QlNVtGZBmaC
         1lrCwAULrtk7lzhV/Dwzv1o1PNO2e0itsf9BCFCeL4i1FJjvoi9gFBVpmnp4bqg9AY4z
         cEwIfsUXSjCM2iuOnEdy3y3hEYb87KxJj4ixG8UPiKd42IL3tf9b1dznTvYVuoEUhu+C
         2nXA==
X-Gm-Message-State: AOAM532pWZNFfKDUu2VKDoW6dvXIaeKDNOkuiP3TrH/0C0refazc0FxD
        4drVqQmUuvkeedjwtGquHVg=
X-Google-Smtp-Source: ABdhPJwVDifNLrLwX2BYpPr5AdIdiq7MrnW08KjQn7DQ9xsmOZHfwN1k+/HlcfegXcKrPJ4HAqImvQ==
X-Received: by 2002:ac8:192b:: with SMTP id t40mr4819061qtj.60.1599015694690;
        Tue, 01 Sep 2020 20:01:34 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id q185sm3923186qke.25.2020.09.01.20.01.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:34 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 42E1A27C005B;
        Tue,  1 Sep 2020 23:01:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:33 -0400
X-ME-Sender: <xms:DQtPX_49uPHvFDpbar1hCCJldy68M5Y12vL3hkkmwg1nJHWxKEcEUQ>
    <xme:DQtPX061QiV_WRTBOykf1NogfA3y8mmRu8PCdRQ6rZ9_eVIDmF92TePw3nWyIN9gr
    IOiD93GfcjW7OHP5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:DQtPX2eek4shwAsWMJBuHh90wGggpo5w7s8VVnfSaje4-Xa8WK4lNA>
    <xmx:DQtPXwJoAqx4yBeSpb8D4DWIhtWoq3eF33Ys40FHP7uDOwZ17EDjHA>
    <xmx:DQtPXzLZk0B0FPy_Ub-lyKqfEjDDl586AXTRu9a-aP_Ca9LtcTulWQ>
    <xmx:DQtPX05SKYQzSWB8_11QzOTmAFh41VpUXjFS1B-pbzRTtcBnkDiPFlQTsgs>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id B315130600A3;
        Tue,  1 Sep 2020 23:01:32 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
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
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC v2 08/11] Input: hyperv-keyboard: Make ringbuffer at least take two pages
Date:   Wed,  2 Sep 2020 11:01:04 +0800
Message-Id: <20200902030107.33380-9-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
least 2 * PAGE_SIZE: one page for the header and at least one page of
the data part (because of the alignment requirement for double mapping).

So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
using vmbus_open() to establish the vmbus connection.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/input/serio/hyperv-keyboard.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index df4e9f6f4529..77ba57ba2691 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
 
 #define HK_MAXIMUM_MESSAGE_SIZE 256
 
-#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define KBD_VSC_SEND_RING_BUFFER_SIZE		max(40 * 1024, 2 * PAGE_SIZE)
+#define KBD_VSC_RECV_RING_BUFFER_SIZE		max(40 * 1024, 2 * PAGE_SIZE)
 
 #define XTKBD_EMUL0     0xe0
 #define XTKBD_EMUL1     0xe1
-- 
2.28.0

