Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE84A25A39F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgIBDCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgIBDBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:37 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E6AC061251;
        Tue,  1 Sep 2020 20:01:37 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e5so2608296qth.5;
        Tue, 01 Sep 2020 20:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=52azQz5ILPrPTgWCNGUCm2Kg05cZXopRo/XcA02tn40=;
        b=SM48TazsccKI7NO/iH6gV52vthQhftE3qOOUQCOQp05NaLXKKNCg26CSp0/4AdI7eu
         O1EUbI2u8pvAt7C2T82zWM8NwEdQOd334dOLrJBoCbzi4DLkxShpbGQ67Mrt9tvIAUV0
         RtB1yy8L+MJjN1BptIM71GefTnHAtaWbk/FEetXZRGp036SL0xR9Z7RyWgc0xdbAk4K5
         qlJr1mraecwmtJnvhexB8JJW/GoqjojwKPYHawiih+zcE0w8N0NxNpWW7XvX4XhzepJ/
         +yUKhZSHaKqS9ct21VIE2jFgvSkL+ihn3zlGlB92dDJieq3yQ1c5tGXO7qsIKDiIO4cO
         OWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52azQz5ILPrPTgWCNGUCm2Kg05cZXopRo/XcA02tn40=;
        b=Z6OfARsN2aGVrHKZ94BSlF0hUYDSHm+0vDo9Vw+SrO2lVBa5bRLchDJCaCHHhK71qu
         gYomPcmiAdM8vJLWMjnkVy6/8GOEVJzQHcmIS8PQaSvKoCdWZGqg/DqJTbokZOHLbEHm
         30xmvKkr8Jk66URBa9i7YgUdqsWnTfAtIBUKMOHnUWzH86kqXE3wcCexB2s95wc1Dl57
         bZKKGJHoQRQke9PGKjZCWTo2TlHg4LFeYKitYzv9qTeWwSxLIfnam+zVOzAUzqf7k1hp
         3Xc6vOwkRYHAnES0VPBzr/TRq9BIkpmKgKlnYxhgmJqntxStcS4u5QN2VqPoK0ckgHIo
         3MZQ==
X-Gm-Message-State: AOAM531J+hDRZcJenmi7gAgachbGknCQolM6Dvp6ZH94vVmjLCCZE/Ni
        ogPTRXJgFEywgPfj7CJMN1I=
X-Google-Smtp-Source: ABdhPJwIc7QSAggeYZA4p45lAeUc49YSk2qheQN2qpKUhTKsDU92cDo8zejIipQa1XKN6scn2S9Mlg==
X-Received: by 2002:ac8:708c:: with SMTP id y12mr5107582qto.24.1599015696853;
        Tue, 01 Sep 2020 20:01:36 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id r5sm3682435qtd.87.2020.09.01.20.01.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:36 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3AD9627C005B;
        Tue,  1 Sep 2020 23:01:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:35 -0400
X-ME-Sender: <xms:DwtPXyYYS0viVzXmPh-2hxlekB5fTqDqQNEdpl0t_oWMtuuTzNwFCw>
    <xme:DwtPX1aIqQVUKlPFZxQQ-xVEmRu8BrqcFnqg-1RWIVcWUK7eHGU6Gu4Km3lMzOAtX
    xmjsCH_qY7-fKXoPg>
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
X-ME-Proxy: <xmx:DwtPX8-oVPSsav9FL6_zW9lrsH87M3buQonxZPIGqg4QhGOcIGDybg>
    <xmx:DwtPX0pGbX136WnH2bHsa9cZzE0l2Q4xzcTutb713R3SknI7KAamAQ>
    <xmx:DwtPX9otKcnOvfEb4EHDB8sXO-SX1d5kJCJrXYUdxm-3tR1Y-QpOCw>
    <xmx:DwtPX1aQZ09HtctMr_8LzSyfdww0bjbgPVRHKii7YlQd7mt3QkqIsBxUiNU>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC7D03280063;
        Tue,  1 Sep 2020 23:01:34 -0400 (EDT)
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
Subject: [RFC v2 09/11] HID: hyperv: Make ringbuffer at least take two pages
Date:   Wed,  2 Sep 2020 11:01:05 +0800
Message-Id: <20200902030107.33380-10-boqun.feng@gmail.com>
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
 drivers/hid/hid-hyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 0b6ee1dee625..dff032f17ad0 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -104,8 +104,8 @@ struct synthhid_input_report {
 
 #pragma pack(pop)
 
-#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define INPUTVSC_SEND_RING_BUFFER_SIZE		max(40 * 1024, 2 * PAGE_SIZE)
+#define INPUTVSC_RECV_RING_BUFFER_SIZE		max(40 * 1024, 2 * PAGE_SIZE)
 
 
 enum pipe_prot_msg_type {
-- 
2.28.0

