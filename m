Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE973131E17
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 04:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgAGDoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 22:44:06 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39689 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbgAGDoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 22:44:05 -0500
Received: by mail-pj1-f67.google.com with SMTP id t101so8634449pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 19:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VZVhy+Yyn6AdsuXyrtHafMm4sXy0ifL8/0aHmsi6DMU=;
        b=jWDhQzpIzqryLFI2Nd64wCcOBASoBTwgdkKpQj3sDl4lT3n3hcICBCiKjK0IS2gWg0
         W9TD+r3eV0s2fOYNlyydIFn1MY3EfOCvN10s9sBG3tA8IRvJkBYs39u+Wx68SuYo4toW
         c9QpTENa9s9c0rPr46ZnVLhki9k2nbUdAjjIPabAcIhqVwvaarnaN3naeyzzt4f9x24g
         mm8/yPEJrQ9Z5P6CpM56GaJZvsRqEMvnH9v0CLqe2hOQmGXm9RwIQ28D5j7Nd3r9c2gU
         BAmxDIh49ABwN/JpE63GqWieXBj5cZL0xFxRc7C84lYkx1w8GTGRjeMTL9Kx3BNnQxD0
         fk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VZVhy+Yyn6AdsuXyrtHafMm4sXy0ifL8/0aHmsi6DMU=;
        b=EtSp11Tj03YMBc/QSfmuA+8eYiU4f7ptax+wSkLcfL7RZ3Na+acWRyQ+4e4dnzp6vC
         NEhxxQ2ka1ZyQ4J6RmFuaHGCWP2FIRSXPxMG8Np7om46SrhS/N+IcmJpvy7kvP4RGP0U
         8khhU6JC1Lq1X+YFky4AXDjPfiPv1MwizykbHiCIo0HETi9VAFXz5+rZQ0ZL8SQVDeR8
         If9oe5IN43hOU6SzfDJgQ0TGxWkb0578kTb/Yydh0fnROOYo9xe4Wl1flRMvcX5J8F+Z
         4U5MYPqDzhKZirV18KNwf8tquDVtf+RWnVDNljikRlcdzp/oJxaT62P8QxpG3G5g1kxC
         jHoA==
X-Gm-Message-State: APjAAAVhFYNCV+530P+WaGBGugrPX+nVyTM5WuQcL0HvFy5A49gN/d5s
        nCM2ACdVuytOJenx9ejQ/VPgFHmYUmA=
X-Google-Smtp-Source: APXvYqwDz6Ea2rxJZflVxRJRs63PyUmO0+r3+YPhDITniPRemFdRtHIVLRTapvdBbG85rZM2VXCDcA==
X-Received: by 2002:a17:902:9a0c:: with SMTP id v12mr72505035plp.71.1578368644246;
        Mon, 06 Jan 2020 19:44:04 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a22sm85262959pfk.108.2020.01.06.19.44.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 19:44:03 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/4] ionic: clear compiler warning on hb use before set
Date:   Mon,  6 Jan 2020 19:43:49 -0800
Message-Id: <20200107034349.59268-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200107034349.59268-1-snelson@pensando.io>
References: <20200107034349.59268-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build checks have pointed out that 'hb' can theoretically
be used before set, so let's initialize it and get rid
of the compiler complaint.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 837b85f2fed9..a8e3fb73b465 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -330,9 +330,9 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	unsigned long max_wait;
 	unsigned long duration;
 	int opcode;
+	int hb = 0;
 	int done;
 	int err;
-	int hb;
 
 	WARN_ON(in_interrupt());
 
-- 
2.17.1

