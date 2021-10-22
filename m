Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CD84380A8
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhJVXfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJVXfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 19:35:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D975C061764;
        Fri, 22 Oct 2021 16:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mvgazD9x12sIYpUGEvDFNeSjpKlhGbYxfsRm+y6UoMQ=; b=YWSpEHWXg/cmTacEC9Ikl/7Xc1
        LDg2kS6QHEnSDgzHN7OoYPgUw2SCcn4kyWz/7hBwvO1/r0CrOLWUeZWko7BlcIEHyPCorMAnIpIkT
        URNn11q7aSAi4416vTSt2xgJvFHumgpHX2F7lV7CP8dlpUZXHvxQtuvcvIV5PCmKrjroMsVevY7Y9
        MIXjvQIbHau6EdhsnTk2T5eoCuZZOLb5ub97PrMseDtMVpg5dHJx6jUxWhD7SxTpo2bUYMcuZ2VTN
        Ozg1pyQaheENfgcXt7ythIofUEnH8lHfI25cv9nt42IZvZ6P40FlD4+a7vpxAk9mQ8sRYPg22eHs5
        48TO2SNA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1me41r-00C8As-Ts; Fri, 22 Oct 2021 23:32:52 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH net] wireless: mediatek: mt7921: fix Wformat build warning
Date:   Fri, 22 Oct 2021 16:32:51 -0700
Message-Id: <20211022233251.29987-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARRAY_SIZE() is of type size_t, so the format specfier should
be %zu instead of %lu.

Fixes this build warning:

../drivers/net/wireless/mediatek/mt76/mt7921/main.c: In function ‘mt7921_get_et_stats’:
../drivers/net/wireless/mediatek/mt76/mt7921/main.c:1024:26: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Wformat=]
   dev_err(dev->mt76.dev, "ei: %d  SSTATS_LEN: %lu",

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211022.orig/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ linux-next-20211022/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1021,7 +1021,7 @@ void mt7921_get_et_stats(struct ieee8021
 
 	ei += wi.worker_stat_count;
 	if (ei != ARRAY_SIZE(mt7921_gstrings_stats))
-		dev_err(dev->mt76.dev, "ei: %d  SSTATS_LEN: %lu",
+		dev_err(dev->mt76.dev, "ei: %d  SSTATS_LEN: %zu",
 			ei, ARRAY_SIZE(mt7921_gstrings_stats));
 }
 
