Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071A22651F2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgIJVFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731162AbgIJOhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:37:23 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C52C0617AA;
        Thu, 10 Sep 2020 07:35:26 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id ay8so6532144edb.8;
        Thu, 10 Sep 2020 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tyJXvA8EaR+XSTkGzm3iM/Tde3qccPQP5bZuy8OPyP8=;
        b=l1bI5ss4UryzwKjYgm10fxFz8W2McHW4Rg/aMe38ZkyRaSFJ82KHNXFdINMtHhNUaY
         1o7IzPZ50slcLpR/lKAkh5A0n5jEb229Ff+nnz4O7gDwZZBO82//B1KTsqk3JkOgqgkZ
         vRe9sCHjSoYZke3HXkcIU++JbAKtirYO4vREVU27v+UO6DjXKjQlzVhJJOzjzEwQGjzn
         ssJXTSo+HEOJN5E+zvFHSZ+zMqRQZJDP/7QqhvSHmUXr7tmZoxzpHj2Oa82mWUAkHCcJ
         vtBUsf7uQ4zhqBSgUtp0CyA0ioCMV0e1TqUC2gyfbvjzyqclfhQczKdZPwTRiAvBKpX/
         U7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tyJXvA8EaR+XSTkGzm3iM/Tde3qccPQP5bZuy8OPyP8=;
        b=dvAhSjWBeuExT5zRHn09etf8IEYCAWiIF5eicLjH/+m6r9QQQALGO/KY6OZA+iaTMr
         r3rpeQcE3utt/UyXjEpAG7XHWyAJRuWVrLe/XGw/X0tIkGkRSANZXlBRWvXA93OLh8lk
         pszwe4D0Vtz9+W1slBFOznMp8yM9L78cQWznTL35seBGVrQflHVF2D35YYBrPaqSN16V
         y9z9QHE4afwyXEQ40eD/tB6xj7GhtyKbHHoAN3MLEYW3SLMDjnLDJ7DNmYDIxpSPAXLk
         U/xmeDpvgiw7WlogSlsexiA4QRxz3dM7IYtNon/H9iqWw3i/wTEwvM8L1BiVIGFALtBy
         Og2g==
X-Gm-Message-State: AOAM531udK24Z+0vMxJ+Ry3MH9cr64D2xXJ5s2/FPcwLvHmmuImMsZS6
        y3JqWEMTYAMX4hgD+iJxSsg=
X-Google-Smtp-Source: ABdhPJzuJ7HW8QVBuvHdERpLFcDaQ5GApnk5ppeYFcSB3KLXqN0xGv8p0J4Q/CqLBelSwXaw3ft15Q==
X-Received: by 2002:aa7:de82:: with SMTP id j2mr10109782edv.3.1599748523652;
        Thu, 10 Sep 2020 07:35:23 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id f21sm7441952edw.83.2020.09.10.07.35.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:22 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 8E5B127C00A2;
        Thu, 10 Sep 2020 10:35:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:19 -0400
X-ME-Sender: <xms:pzlaXy4xRlys2COCqWSKwyu3nmtZhBKYzMOwjdkngPtKAlPJH4k_Ew>
    <xme:pzlaX75gcNwK2jOhCYhXqm2ilpB1iQi-ixMiXx7SOIu1CWjvvq6NoQ6uoTCxZbW6v
    I-msoa69uxHM9A7cA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:pzlaXxc9TL1W0A5sUhDulsafFHl-lobkjK__G5xXbXkRYzNpmZGQPA>
    <xmx:pzlaX_IYcKAFb4dP1VLz_BmGZXUSCPgq7tJ6s6HqtX10z5JKUJliqw>
    <xmx:pzlaX2LPfx3mEkmZn6d1bod1Yw8vCVfk_eCfMgoWXmwML7uWrNw3lw>
    <xmx:pzlaX7aH2lz7VEF3n9OjnYcDGn0wp3IddzLJ8Q1OwSQynZ-I9A5Po-SqMN4>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0931306468D;
        Thu, 10 Sep 2020 10:35:18 -0400 (EDT)
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
Subject: [PATCH v3 09/11] HID: hyperv: Make ringbuffer at least take two pages
Date:   Thu, 10 Sep 2020 22:34:53 +0800
Message-Id: <20200910143455.109293-10-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
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
Acked-by: Jiri Kosina <jkosina@suse.cz>
---
Hi Jiri,

Thanks for your acked-by. I make a small change in this version (casting
2 * PAGE_SIZE into int to avoid compiler warnings), and it make no
functional change. If the change is inappropriate, please let me know.

 drivers/hid/hid-hyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 0b6ee1dee625..8905559b3882 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -104,8 +104,8 @@ struct synthhid_input_report {
 
 #pragma pack(pop)
 
-#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define INPUTVSC_SEND_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
+#define INPUTVSC_RECV_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
 
 
 enum pipe_prot_msg_type {
-- 
2.28.0

