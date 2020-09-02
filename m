Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED725A39D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIBDCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgIBDBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:40 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE8FC061258;
        Tue,  1 Sep 2020 20:01:39 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id o5so3083842qke.12;
        Tue, 01 Sep 2020 20:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JL6sEmPmG1Kozdxn8ORze6+MctkHof6Njmiqz3VMuCo=;
        b=FcTKBXldRJFYQ4QJRVDlwvJwXr5qCD4KLvEAJq1NJQG+mfPFPJOgvIJmDERaeK38Gi
         fGCjn/p23LELRbfI+XsMkAkw5v4IVmsQOOM6ZjM/BUgzA0FYM8SfCxlWNMhizLV6vBG1
         Zmd41VdwFhdqGtjvs64d4KMAbWUOme2DbGiYC3yMXlR1LvKtJ2iJR0X3iWS+NhGwv7je
         z4o6ZKmfx4lYURycV61+YkETY7H/xVpGS2BMR6E28KtoOE6lSwqlQz41h7HAoGCv59Kc
         OxtP6iXgctJGForXMte/TAUn2IDU9wucfPh7XPQM18jmmDPbzyd5mR4eknRvFE3PXcX0
         3Eyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JL6sEmPmG1Kozdxn8ORze6+MctkHof6Njmiqz3VMuCo=;
        b=CLMpJfdcUXliC/YISk38EPXNmTO+ejJgjZqkXAZ+4ZZVxCdVzS573Q69CrNLv/WHTe
         fcMcFL9NNcRYeHFlwkvwPFCRyv5saMYOSg/qGI43sXnd5fZLeFNeOgcarVB62uFy3jlw
         I3Gk8QIP22VqcMKyXKdhLYMnqOycKLl15N1fVvbpzlG9VXfY4AyBnOxx34MZwkoGTYps
         eVEe7eh7Rb2WowhGH3DwCSiF19uy+shnmxxPnder4E0771mKT0cHMhv51EPgIaqLyUvu
         E1jEfb2UJ5NCN1n/YQ49r/hSEuU7FklWi2xvC/3LhHhaX2RmsXAy/62pydyBgJP/km/3
         8s8A==
X-Gm-Message-State: AOAM532TDkBfnuXlPSDdwvPZ+dowMyyCcjHKAMBbinInZQzqT4o3vR/0
        56CvksNXHTPC4gs2SX5pSvo=
X-Google-Smtp-Source: ABdhPJyzJAAwAl3QSJXpRPMaCasr8TW4OKrbzITkSoJw8wuiczxjl5XB8eCtn6bZe7OHiv/vnxhD0A==
X-Received: by 2002:a37:498e:: with SMTP id w136mr4825638qka.187.1599015698735;
        Tue, 01 Sep 2020 20:01:38 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id 82sm4075095qko.106.2020.09.01.20.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:37 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0F60E27C005B;
        Tue,  1 Sep 2020 23:01:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:37 -0400
X-ME-Sender: <xms:EAtPX-nWHdV6U8k-X0YyO3kV6K-rYQrz-mEzIgrA_nUwgHUBPuAa4g>
    <xme:EAtPX13ziwFneILy0Ox11LKMlm8QAXSsNqSHkemxt0t-rdP-X-xma2D9FqeuSeHoL
    rI3aD8qo1JLqEKECQ>
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
X-ME-Proxy: <xmx:EAtPX8qEWFwgz8HcM04R9CUBZOd88VA_EYQS0kvg7sXzn5ouVawv6g>
    <xmx:EAtPXylyGbRQmqiLhJ0fhFo-bHOd9QDBQJm3SzRqGSZHs3jeFEjXPQ>
    <xmx:EAtPX801dpPdhFio4AyQ89irmm8MCtBfoz2ITekAGim6GEoWkG7ngw>
    <xmx:EQtPX_28ElWhu3rnXpPjU4zX_6_3qzrFjFyra14y8zkzxW_IT0MblBAd6xU>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D0D930600B1;
        Tue,  1 Sep 2020 23:01:36 -0400 (EDT)
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
Subject: [RFC v2 10/11] Driver: hv: util: Make ringbuffer at least take two pages
Date:   Wed,  2 Sep 2020 11:01:06 +0800
Message-Id: <20200902030107.33380-11-boqun.feng@gmail.com>
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
 drivers/hv/hv_util.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 92ee0fe4c919..73a77bead2be 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -461,6 +461,14 @@ static void heartbeat_onchannelcallback(void *context)
 	}
 }
 
+/*
+ * The size of each ring should be at least 2 * PAGE_SIZE, because we need one
+ * page for the header and at least another page (because of the alignment
+ * requirement for double mapping) for data part.
+ */
+#define HV_UTIL_RING_SEND_SIZE max(4 * HV_HYP_PAGE_SIZE, 2 * PAGE_SIZE)
+#define HV_UTIL_RING_RECV_SIZE max(4 * HV_HYP_PAGE_SIZE, 2 * PAGE_SIZE)
+
 static int util_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -491,8 +499,8 @@ static int util_probe(struct hv_device *dev,
 
 	hv_set_drvdata(dev, srv);
 
-	ret = vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
-			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
+	ret = vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
+			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
 			 dev->channel);
 	if (ret)
 		goto error;
@@ -551,8 +559,8 @@ static int util_resume(struct hv_device *dev)
 			return ret;
 	}
 
-	ret = vmbus_open(dev->channel, 4 * HV_HYP_PAGE_SIZE,
-			 4 * HV_HYP_PAGE_SIZE, NULL, 0, srv->util_cb,
+	ret = vmbus_open(dev->channel, HV_UTIL_RING_SEND_SIZE,
+			 HV_UTIL_RING_RECV_SIZE, NULL, 0, srv->util_cb,
 			 dev->channel);
 	return ret;
 }
-- 
2.28.0

