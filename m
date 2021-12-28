Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99C848055F
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 01:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhL1Apq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 19:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhL1App (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 19:45:45 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2208DC06173E;
        Mon, 27 Dec 2021 16:45:45 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id s1so35225309wrg.1;
        Mon, 27 Dec 2021 16:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XaV/r3ZN+eYxYzo3M6I/TvOftLKV5Px1SaFfM14mJiw=;
        b=Vf5TTiCXk0cnJUD3QC0y7FeI4qSwYQ/PGWiiHoiIcYcdWpu2JHa9MO2vtykbV6SGTO
         Lmkbvs/picY7xAHERjmVlAiMlIB+KepySstshohEa8LDXzF7CLMTv2XYjHEMPT01nekR
         sdK6G+ag18c/Gnd1/43SH5NqNxCX/bI7tNShFPmuoTQLp31hjxEOh2a0W5uURs+6DHq9
         mOEBwWepmqle5LblqmHQMLIaMgfhLVjohZt3UbhljvPQmex6cVO636s9HPcGZ9/yyFEH
         neHozZAMP7jsC8JK1scTjVZ/JT0qX2mU8haIirz24femwGBR+hmIMk+LZRWAKUJh7upB
         uY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XaV/r3ZN+eYxYzo3M6I/TvOftLKV5Px1SaFfM14mJiw=;
        b=HhWIN2is0soWsgywfOSfTbKqwbagIyqjz9gOx9k7hgqk8+b2SV5D2/3jtrgqS2iKxB
         xS8GPxKPjMl7FMSKJGxpe9CCNxizTM96bECmXls3luh5Gu7gfr/AgiJ9LjC9UJgh5L4u
         rAOdKkNa9DAOzDpYnKKedJzUQnNY+L6dAUcknwz2SVur+yE5XbRquJo4b+phwo1sOWr5
         nazgHq8fhTyQA5qpFEFOb3NSWTd6c+8KwqtT/giNNa4FRaYVddBUTBvWPkcZEpv3S2vA
         r6OaDl/qSqO+BjZ5LdxIC7V8vFE9HPomEULck8696o4+uK6rzAD12Ay+Lq6I1VldjgeY
         0LWg==
X-Gm-Message-State: AOAM531g+APn6YLKWinLCHMvVqmkm62Ogd9jAi6Fm6doeCeowYUlu37M
        yhbK2TBDqBsDrlT/U2DsYgY=
X-Google-Smtp-Source: ABdhPJz15yzi2RBiXai0IBvh2zoAoXsjhhHM0H5xEoj1qLmDFgdLUaIVLTB1UPX1K1+jt0BDGV5rBQ==
X-Received: by 2002:a5d:4588:: with SMTP id p8mr14365697wrq.106.1640652343581;
        Mon, 27 Dec 2021 16:45:43 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id d143sm16464332wmd.6.2021.12.27.16.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 16:45:43 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: caif: remove redundant assignment to variable expectlen
Date:   Tue, 28 Dec 2021 00:45:42 +0000
Message-Id: <20211228004542.568277-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable expectlen is being assigned a value that is never read, the
assignment occurs before a return statement. The assignment is
redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/caif/cfserl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/caif/cfserl.c b/net/caif/cfserl.c
index 40cd57ad0a0f..aee11c74d3c8 100644
--- a/net/caif/cfserl.c
+++ b/net/caif/cfserl.c
@@ -128,7 +128,6 @@ static int cfserl_receive(struct cflayer *l, struct cfpkt *newpkt)
 				if (pkt != NULL)
 					cfpkt_destroy(pkt);
 				layr->incomplete_frm = NULL;
-				expectlen = 0;
 				spin_unlock(&layr->sync);
 				return -EPROTO;
 			}
-- 
2.33.1

