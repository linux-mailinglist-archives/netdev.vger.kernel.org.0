Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5331AFBC2
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDSPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgDSPoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 11:44:55 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A304C061A0C;
        Sun, 19 Apr 2020 08:44:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d1so3717377pfh.1;
        Sun, 19 Apr 2020 08:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=RclhL8sJsiY5PIfBoAsFTSBZFGfdaFZ8DXC9ZgsXXw4=;
        b=uTjnI2XDLaTrOOUKjI1BiFPHsLHqlIuNMn3tma00R+2fbcxpYSJ4l6JZTZSjpPjnjF
         ueCPGz8/nX3YUfDkuqBPh8zVyttZkh2B5cq9VLVv3fR+HVYM3w62ky6A0cFvAC4BrMBV
         KWxMrpQglhNIEOErZFXu12psn8p8l+4dMsUN83+aZP4g8dB1fLCvmAx8j9gX2fN5JcMX
         SS9KCbSR6xykMww5hAYLsJlMxlwjbXrjtg5M8AxDTJ7VWXCae01d6NqEOSlvtRxikiIM
         QzLlkUzauUKmmIdRZubnSFzCUU3PWXJ3UyzRKxngIzWNLhyWh4dWucyOsZbXHu1TJS0d
         ID2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=RclhL8sJsiY5PIfBoAsFTSBZFGfdaFZ8DXC9ZgsXXw4=;
        b=sIJsbH0tvH61by2cynBVam2pAkP5kqMlHDGa6++B8zVxwmcRkCfBF132zLWEYRWLuj
         vlQsIhszagAtPwwTQq89uNY9zzqg3Wctj4SLOXxcbrawRI2ItbOFAoJR7s8qdy8qn/T6
         p0i+9zJI4bN0gsGzVWkQ7a3VwGJbpDk+myi56keDlsC0pw1Tt/qbGxLaHyco/RKax4NG
         o3GfI/dXkIsG49Ky+FQ1iJf2rmF+dP7RgbqhDeVDLQg+lOH/lN8o6Yd1qLkNg/0X9dLS
         3omrsqKD2xsjg5x3i7ZFe5eilQVcFR9JQO44EIefnwfgJsIEjyIUtQDxDNojSzFCwU8W
         dcIA==
X-Gm-Message-State: AGi0Pub7aOJl43i0TzLNUHo5dQ1lNmIVYApeeMwGGuUT+Xi9QmVNXlcq
        9KKeseNVXMnTuYrF5VZWsCA=
X-Google-Smtp-Source: APiQypK9nS3GvUf6RILsiUG81Hsp+zdW1cOzcbeZ17x1vD0MpdngO0IJXw/cwFyMXsBy2tpjQ0QqsQ==
X-Received: by 2002:a62:6dc6:: with SMTP id i189mr12950516pfc.30.1587311094792;
        Sun, 19 Apr 2020 08:44:54 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:610d:f65:24cf:c6c4:f8fd:66fc])
        by smtp.gmail.com with ESMTPSA id z6sm23199319pgg.39.2020.04.19.08.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 08:44:54 -0700 (PDT)
From:   Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Martin Habets <mhabets@solarflare.com>,
        Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sun: Remove unneeded cast from memory allocation
Date:   Sun, 19 Apr 2020 21:14:43 +0530
Message-Id: <20200419154444.21977-1-aishwaryarj100@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove casting the values returned by memory allocation function.

Coccinelle emits WARNING: casting value returned by memory allocation
function to (struct cas_init_block *) is useless.

This issue was detected by using the Coccinelle software.

Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
---
 drivers/net/ethernet/sun/cassini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index e6d1aa882fa5..3ee6ab104cb9 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5059,7 +5059,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (cp->cas_flags & CAS_FLAG_SATURN)
 		cas_saturn_firmware_init(cp);
 
-	cp->init_block = (struct cas_init_block *)
+	cp->init_block =
 		pci_alloc_consistent(pdev, sizeof(struct cas_init_block),
 				     &cp->block_dvma);
 	if (!cp->init_block) {
-- 
2.17.1

