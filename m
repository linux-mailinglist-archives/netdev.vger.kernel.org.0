Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5272857B17
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 07:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfF0FE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 01:04:28 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45454 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfF0FE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 01:04:28 -0400
Received: by mail-ot1-f65.google.com with SMTP id x21so921499otq.12;
        Wed, 26 Jun 2019 22:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GlXuhQWQA/lVSG/8HetE1/x5ZAIJM14lwCSaZv97Mbs=;
        b=GqasVPRyHsVP+n5oyg1FJnExioUyVr7LOvsRmg7nY8YTxCb0/VlZ1jAyRzVNEaWFoC
         HUFzOJiJwnPcznh/+E3LDwhVR3v5T2YgSmwrHhlAGHICEm5JCGzeVsvbi6BSKj7AOy3Z
         C5R21bhmDPvyxieLtsTLE3aZdVU2FpcAJ8kCw2PV0s69/zF4hNNQkYdbzJlXhcBDPfbb
         w9+mOVHOdOm0xStnXh5QWoVvAQRxRFndNXp9e2U+BeE3DLyskkrqOpx95kUBSnNfeg14
         5e5sC8ZEEa2KdeJ/zeWd+t19imImVvpiSBRMTT/5nw+V2TCQAgJzWRtJfTlTyfn1paYG
         PvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GlXuhQWQA/lVSG/8HetE1/x5ZAIJM14lwCSaZv97Mbs=;
        b=ZF8cfwANkGhImeIlM5P80sDYSzvphOHgo1SXcihzQywG+bdJvKkcrTspmevoq3k4M9
         mWgpEo41VDcVRJliOtCRheYx+JaZrsO7FvurKcUb2bUqBAdONLXZHYNU0B/ls1hf/dLD
         MRUFjdM2406jDn/mMCK5/46ocIvQPFlU66zv/03ABhqRfmWP4Hh7ddAayhCZyWA8XAy8
         9xpt4Mlx79fIfzbcQQdZdbwGVZc5hqxDLgkuwhmoeTaERNCO+gIYHXiFz4Dlm4bjLw9s
         l5JeIMZ/IwycHJpGc0fDdztKept9eOpk0p/Zvn6LDeWVtkBe0Bo9fvM+3S7+9MSPmSkM
         GIqg==
X-Gm-Message-State: APjAAAU8yiYCsXUMAeSig/D3MsAjQc472mYMB6O8KPgvh+p/GkwTTeeX
        7st6EkxB0QpuGxrJTKYu6V3CXmKfkVI=
X-Google-Smtp-Source: APXvYqzlBt0nC4Nh0aSm4GdOeVGei8vVZTcgOpYYcXvGT8+r/17syQs5DkT1yXnmlyT0kU/UJ/HmGg==
X-Received: by 2002:a05:6830:148c:: with SMTP id s12mr1724595otq.274.1561611867630;
        Wed, 26 Jun 2019 22:04:27 -0700 (PDT)
Received: from rYz3n.attlocal.net ([2600:1700:210:3790::48])
        by smtp.googlemail.com with ESMTPSA id v18sm613318otn.17.2019.06.26.22.04.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 22:04:27 -0700 (PDT)
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     skhan@linuxfoundation.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: [Linux-kernel-mentees][PATCH v3] packet: Fix undefined behavior in bit shift
Date:   Thu, 27 Jun 2019 00:04:24 -0500
Message-Id: <20190627050426.17925-1-c0d1n61at3@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190627032532.18374-2-c0d1n61at3@gmail.com>
References: <20190627032532.18374-2-c0d1n61at3@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shifting signed 32-bit value by 31 bits is undefined.  Changing most
significant bit to unsigned.

Signed-off-by: Jiunn Chang <c0d1n61at3@gmail.com>
---
Changes included in v3:
  - remove change log from patch description

Changes included in v2:
  - use subsystem specific subject lines
  - CC required mailing lists

 include/uapi/linux/if_packet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 467b654bd4c7..3d884d68eb30 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -123,7 +123,7 @@ struct tpacket_auxdata {
 /* Rx and Tx ring - header status */
 #define TP_STATUS_TS_SOFTWARE		(1 << 29)
 #define TP_STATUS_TS_SYS_HARDWARE	(1 << 30) /* deprecated, never set */
-#define TP_STATUS_TS_RAW_HARDWARE	(1 << 31)
+#define TP_STATUS_TS_RAW_HARDWARE	(1U << 31)
 
 /* Rx ring - feature request bits */
 #define TP_FT_REQ_FILL_RXHASH	0x1
-- 
2.22.0

