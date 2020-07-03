Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791A9213B0F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgGCNeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:34:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgGCNeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 09:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593783247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=b6C/Ke+4UY+EMY2gXlTOC95fqvFQa1Hgh6TTQR1ucBY=;
        b=NM2L1hAdqEgFk32WqVtjlEejDXy1gyKDp5XS3YAC6iE+iGkPr2xTaYyvi7ehMvwqYr38jw
        Ecu4nDI3NDkwsZDK5ls6XFXQIyB3SQJ4mIxBxQehuaMm56bpCrKnAyvdCx7CHTUSvqJ0AR
        Vykr9e5wUfczBe7EM7buqyvGkgbHMRw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-4Mgo0-XBOtCSYkYaiiRowQ-1; Fri, 03 Jul 2020 09:34:06 -0400
X-MC-Unique: 4Mgo0-XBOtCSYkYaiiRowQ-1
Received: by mail-qt1-f200.google.com with SMTP id c5so21763413qtv.20
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 06:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b6C/Ke+4UY+EMY2gXlTOC95fqvFQa1Hgh6TTQR1ucBY=;
        b=TIdVE/0/dP8GTDdVGs1rp8B86EO7WndSTYq8oAQqybRhZnSTkCOTItqp9tmfD4Yjws
         IMAqSBLDCYb7U8pQGawdY/wCA8Gny5XtErfwyAb6KfhGCQRFYa5EGxxrfjX6S0n7IKtQ
         COXn1cB/QriF9OftzOSXAQPd8j1EFmaN1QDDAU3Tkd4FG1A0zrez0zp10F4ieiNn2W70
         s8GG929LE0TO9mu0jP8usOd5AAbk47uYWKXmkdCc6szhcojadvKQ+o39NFShiG1Jm+Wj
         WvVMx3yBRKniqgL5hRmsNojLlA0w2tJMmjadBdfiMVQaVlv1otwaojnIlnMDJyM0oOyi
         Is8g==
X-Gm-Message-State: AOAM5335Ep7NAtEGoWQ3oNY6zgkACnPugV3fzdaGaLtO1fZ6rQWoFqkh
        uXt5SFemKk7EU7WVUB9p0Hh5xqLyjRN8Yg9yHjoo0MQXCbv48HGGYHRUfL3ps6OcPelelWmEYx7
        BWBZ1aqZvDv+Sng4B
X-Received: by 2002:a05:620a:218e:: with SMTP id g14mr35187135qka.430.1593783245595;
        Fri, 03 Jul 2020 06:34:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlTZUIIj7eIyFLZ29LTns3xpC8Vhrn52+AncVRKpMxxruUBcZ8Se0pRH7bfF6O9AfT2fFIjw==
X-Received: by 2002:a05:620a:218e:: with SMTP id g14mr35187106qka.430.1593783245345;
        Fri, 03 Jul 2020 06:34:05 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id y40sm11869060qtc.29.2020.07.03.06.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 06:34:04 -0700 (PDT)
From:   trix@redhat.com
To:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: sky2: initialize return of gm_phy_read
Date:   Fri,  3 Jul 2020 06:33:59 -0700
Message-Id: <20200703133359.22723-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags this garbage return

drivers/net/ethernet/marvell/sky2.c:208:2: warning: Undefined or garbage value returned to caller [core.uninitialized.UndefReturn]
        return v;
        ^~~~~~~~

static inline u16 gm_phy_read( ...
{
	u16 v;
	__gm_phy_read(hw, port, reg, &v);
	return v;
}

__gm_phy_read can return without setting v.

So handle similar to skge.c's gm_phy_read, initialize v.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 241f00716979..fe54764caea9 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -203,7 +203,7 @@ static int __gm_phy_read(struct sky2_hw *hw, unsigned port, u16 reg, u16 *val)
 
 static inline u16 gm_phy_read(struct sky2_hw *hw, unsigned port, u16 reg)
 {
-	u16 v;
+	u16 v = 0;
 	__gm_phy_read(hw, port, reg, &v);
 	return v;
 }
-- 
2.18.1

