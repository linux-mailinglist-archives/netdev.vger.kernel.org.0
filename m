Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BD1202552
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgFTQef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 12:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgFTQef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 12:34:35 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040ABC06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:34:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so12513173wrs.11
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 09:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HnfTIYVZ5wB9NzJ0He1gW/q1BGjjos8MabSfnh8sooI=;
        b=GcioExfOe0cVPsVyN5HU71bI0bR5bt2+3aiyIqeondmOv9TKbOKeHuDX0AlI5RsLsc
         PJfK6Pgwej0WWDlntpd9T/8qwr5EnonXwNs/PfnMqtVaMf85NMAq1TtzqK9jVPbh+6xN
         WlFzKgz5X+6z7ySOEjodvGtL4DJgBk+tDUf2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HnfTIYVZ5wB9NzJ0He1gW/q1BGjjos8MabSfnh8sooI=;
        b=DssFmGSrRY7gdqAu5etKSRyG2LTX0RRzpQJzknyrgAXGuDZOk1ivyOlGReVjEiWOJV
         AWlm9geryDJiLcLH5B/rrjIvAd9XGmioCAbFPwM8b+mqOSUTdyUFaozZDl1aW3yHmtXV
         EoNNBljbt4wgNeAW31TnjiM3tqYyEeoAYn8ljI8BJQjC1bPltfGFPepb99zsGTuiKKPJ
         4q3HRxZCsonWWmcBMbEerp8gyIrriZeApO2UYZ7e/jdnE+9gLbhwIzfwXfN1yrwcPpcc
         h0o4l8B7fDeeakT6yMQZuP7hdo/6+/RIMarXZyrBZgw47XefSKhEhuAw0GScRQEdfUrf
         5cRQ==
X-Gm-Message-State: AOAM533QjH2S7rxVvzidSFRZDtpzaAxLV27egEhJLhG+biebip8d67Gc
        8+hkQbk4ofbr/cJ97NE2ZpECXA==
X-Google-Smtp-Source: ABdhPJxiPBv2HTegp9FOj8XL4y5YpoS1mDJFfC7Tf8/ELKuJdmOHcwdFSTgaTgfgBS0u7rYsgtPFxw==
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr1958265wrq.56.1592670873602;
        Sat, 20 Jun 2020 09:34:33 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c6sm10825974wma.15.2020.06.20.09.34.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2020 09:34:33 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, kuba@kernel.org,
        jiri@mellanox.com, jacob.e.keller@intel.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v2 net-next 2/2] bnxt_en: Add board.serial_number field to info_get cb
Date:   Sat, 20 Jun 2020 22:01:57 +0530
Message-Id: <1592670717-28851-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add board.serial_number field info to info_get cb via devlink,
if driver can fetch the information from the device.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
v2: Combine 2 lines as column limit is increased to 100 now.
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb..2bd610f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -411,6 +411,12 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	if (strlen(bp->board_serialno)) {
+		rc = devlink_info_board_serial_number_put(req, bp->board_serialno);
+		if (rc)
+			return rc;
+	}
+
 	sprintf(buf, "%X", bp->chip_num);
 	rc = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
-- 
1.8.3.1

