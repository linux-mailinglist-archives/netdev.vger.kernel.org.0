Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2312B7359
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgKRArP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKRArO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:47:14 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8187CC061A48;
        Tue, 17 Nov 2020 16:47:14 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t21so14228pgl.3;
        Tue, 17 Nov 2020 16:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hjCuBppI/3uQsW5cJkIoidG2uXiaB12HKAMzYdLQZ54=;
        b=CKJartWL0TXPsIcB7k70hBzfGA6ga7Oe/CRB5brq0sVTLLkejgDcHNRQl1erpwncy6
         M3Bhlp31IVj3Fh1utSwgLoaEdAaujO51qaYCy5kHy2N4yJps1YacgSfyDNsCDMAMkGFP
         ggF3lg9GHBrUHsvYQlzHGzBpKtDw8vkt0L8nSG97NjVWcVl6SlHYzIzWTS9BAuEsUcSo
         XfLC6MDQ9juvDpCzr0lgNaB+lrbaZqek4canPJ9WGQMtfk5Hv5XNBE+vWLizvLu11IlQ
         W94EJLhKh9uchNu3hTiMQucfM3MszV2gLw7AVCETklVFRHo8ZxTuCPAy17W8cACQymtZ
         xFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hjCuBppI/3uQsW5cJkIoidG2uXiaB12HKAMzYdLQZ54=;
        b=NOGOpoRSOmuJkxrDHxg+3aJ9QcGdjNtfhJyl6RB/+p9J8TDhGz5LmdFrhJmJqh2/2e
         +s3VlCaVP+7uYZFrkpAnUw2dqje5IqmLCmYGxzALq7i/3sNW+FBmSSGXZFarQaQqK1hX
         NSS90l5PwQuEGpMIhmigyyhJNRiBssj7nV5HWNj831TEIJpmfaljV0WSM50hOcg2WZYV
         sHp9J3441uTQmJFT4M8WrjouuQ6CKVAOycfFn27iDwMHfx8p6TGGarLP2NUOpr9NtS2v
         Rxm7rSJTqMO3keuql3bDoRC2YKOSDEoSdINbHNlHtFbSnd26uHAwMorNatBXZr+lCpAZ
         BLSw==
X-Gm-Message-State: AOAM530A+qyQY2cemtAI83QBiXcXw4OrySTDtvcttv1GjOQ7xg9Jfmcm
        dh1CwU6S7VQNyaDaeiDyLcqptkwgWblV8w==
X-Google-Smtp-Source: ABdhPJy+DA1iyqPbe44+AZuCsTd5V0iQMMd/n6amSJXtQrOvhlWkABzg47MWua4ziNYyEubrw37RqQ==
X-Received: by 2002:a62:8c08:0:b029:197:491c:bab1 with SMTP id m8-20020a628c080000b0290197491cbab1mr2112324pfd.49.1605660434140;
        Tue, 17 Nov 2020 16:47:14 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id k30sm5673612pgb.83.2020.11.17.16.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 16:47:13 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 1/3] icmp: define PROBE message types
Date:   Tue, 17 Nov 2020 16:47:12 -0800
Message-Id: <a4a7002a93a89fff6c5f4e32d9a1289cb3d7facf.1605659597.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The types of ICMP Extended Echo Request and ICMP Extended Echo Reply are
defined in sections 2 and 3 of RFC8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Switch to correct base tree

Changes since v2:
 - Switch to net-next tree 67c70b5eb2bf7d0496fcb62d308dc3096bc11553

Changes since v3:
 - Reorder patches to add defines first
---
 include/uapi/linux/icmp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index fb169a50895e..1a84450f667f 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -66,6 +66,9 @@
 #define ICMP_EXC_TTL		0	/* TTL count exceeded		*/
 #define ICMP_EXC_FRAGTIME	1	/* Fragment Reass time exceeded	*/
 
+/* Codes for EXT_ECHO (Probe) */
+#define ICMP_EXT_ECHO		42
+#define ICMP_EXT_ECHOREPLY	43
 
 struct icmphdr {
   __u8		type;
-- 
2.29.2

