Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB4928AA17
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 22:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgJKUKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 16:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728345AbgJKUKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 16:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602447032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ssnGFoLwUqJFKe61rBUojnGSTJZmS1YRBdYgdg+6zXo=;
        b=hJJuTvKCbTSOzNsFboHqYiqJs0oPkkikDMoaBdwdMRkbTD0RavNSpADiQbsegQiYlNtGrE
        Qg+iE75zeb97M5vN7+A/cxrN7FQgKEbvrj3huwR0rWKMUOs9wUpy0ykWAh0IlKLKH847Pa
        qXuhfgEjOHADcTaKy0NxzryKOoYWX+w=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-xDuaUfPhNIS02dRzHP4wBQ-1; Sun, 11 Oct 2020 16:10:31 -0400
X-MC-Unique: xDuaUfPhNIS02dRzHP4wBQ-1
Received: by mail-qt1-f199.google.com with SMTP id n8so11169396qtf.10
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 13:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ssnGFoLwUqJFKe61rBUojnGSTJZmS1YRBdYgdg+6zXo=;
        b=eH7GX/YSFAQk3FEi5k7wL5m8NVCOG5xlmgu4cEUM7nxvngPEAV+I1g0zl9diNYhN0i
         +E4TkfVpKbFsVzqk2adcNaqbv/zc0WqMFz40qJTid6c0vdoJaz6ilQ7YZOwYtn6eYYd4
         WLZU2+81aEepK8GR7cTFdPDJmJVOTbrfo7ObZUgoZhg+EM/3PdRx+1G+KdJBwliEPosH
         0aRgdtFz4Bd4rmkG4jyYFpNsMpka3gLJgOxXCJPzbblCbILPq1tMVsgWtvq1AYLWir/r
         QRAAyeIxVm9DYrhiryiTOtDogWd7fHo9YpLtHVyOUdfSvCMsbxQlIdtiSaYiyDJyRkic
         AhtQ==
X-Gm-Message-State: AOAM531J0F26BNHHguHcwZF51VSPp+/DNBrpFsfl6otJ9DDJHmj/1cet
        VzrYW4tdOSlzrxRJabj6x14PQ2RaDWwvjwiOQOBN8oGO/2IqSoyNPej/U3zfNdnX/F7n5MLxSvj
        DZXTrlKgwg1xgdO0j
X-Received: by 2002:ad4:4c4a:: with SMTP id cs10mr23027811qvb.48.1602447030645;
        Sun, 11 Oct 2020 13:10:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywLhbYhIpktcD8np3wxqK9pWod7nfAhLITsmquC01UHPV3sw2aXdhVt0OHz7BcmjNphfYa5Q==
X-Received: by 2002:ad4:4c4a:: with SMTP id cs10mr23027785qvb.48.1602447030259;
        Sun, 11 Oct 2020 13:10:30 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id j92sm11082301qtd.1.2020.10.11.13.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 13:10:29 -0700 (PDT)
From:   trix@redhat.com
To:     richardcochran@gmail.com, natechancellor@gmail.com,
        ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, Tom Rix <trix@redhat.com>
Subject: [PATCH] ptp: ptp_clockmatrix: initialize variables
Date:   Sun, 11 Oct 2020 13:09:55 -0700
Message-Id: <20201011200955.29992-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this representative problem

ptp_clockmatrix.c:1852:2: warning: 5th function call argument
  is an uninitialized value
        snprintf(idtcm->version, sizeof(idtcm->version), "%u.%u.%u",
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

idtcm_display_version_info() calls several idtcm_read_*'s without
checking a return status.  Initialize the read variables so if a
read fails, a garbage value is not displayed.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/ptp/ptp_clockmatrix.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index e020faff7da5..47e5e62da5d2 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1832,12 +1832,12 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
 
 static void idtcm_display_version_info(struct idtcm *idtcm)
 {
-	u8 major;
-	u8 minor;
-	u8 hotfix;
-	u16 product_id;
-	u8 hw_rev_id;
-	u8 config_select;
+	u8 major = 0;
+	u8 minor = 0;
+	u8 hotfix = 0;
+	u16 product_id = 0;
+	u8 hw_rev_id = 0;
+	u8 config_select = 0;
 	char *fmt = "%d.%d.%d, Id: 0x%04x  HW Rev: %d  OTP Config Select: %d\n";
 
 	idtcm_read_major_release(idtcm, &major);
-- 
2.18.1

