Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C15241C598
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344191AbhI2N3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:29:37 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:56830
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhI2N3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 09:29:36 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id EA6793F357;
        Wed, 29 Sep 2021 13:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632922074;
        bh=llGQWjcAuooB5bvE5ZZK4xVEgoRsG+cLdfSPzcf9Lco=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=KHp+0TgtPX9mm1PDhojx0ukDwJXQWHrn/118jhwqu64i1ErJmQX1OHr/lPp30VFYK
         K9WzbEU7P/1DEQQ6b4HFRRwu0+cVtjtb/LudGtVHrNfN3K5EH1KCsjhVjBe+Jig/Kv
         gp0RAi1sKDY6n+Izb5JxU3zgpoVx+aL2KKXxck8Oo0t9PRfs033bazhPiB/rR6MlsR
         ZNeEEGvi0RS95HquKV4H52n9wavIxIrqkwfOAwbN0H9uni6/S3xQNGsrkBSUGzDupE
         WGc247BUTKrEQlUEwGjBKJ8S+IukWtJ+6nRd6mwKFwGdPZhyWvPJ30/ikHjBvJdqyp
         ZAZptA0f2W3oQ==
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Remove redundant initialization of variable pin
Date:   Wed, 29 Sep 2021 14:27:53 +0100
Message-Id: <20210929132753.216068-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable pin is being initialized with a value that is never
read, it is being updated later on in only one case of a switch
statement.  The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 5e3056a89ee0..bc29ec834967 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -194,7 +194,7 @@ static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
 {
 	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
 					    ptp_info);
-	int pin = -1;
+	int pin;
 
 	if (!ptp->nic)
 		return -ENODEV;
-- 
2.32.0

