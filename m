Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8665C12A9C9
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfLZCdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:21 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:43815 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZCdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:21 -0500
Received: by mail-pg1-f174.google.com with SMTP id k197so12199081pga.10
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q9bJsY3z2kyATyAaL+NSBHkt58yW1QvQynFeadGngaw=;
        b=exETDZU9Ekv+/8GYqmm4/i5zST36NbS47OTUcIuWyMH809BQ7Xqek/KnUsdTA/nT5H
         0ISKI7sI6ylq6bNAK/jjQtHBXSZlVrErfHtoVyYvDeBKdWC4Woc5ZAjPx5lyBNZNdEG3
         UrGm4FDDH2tSFOYaTZebWy5BaG8finaSNHelqWB2ANVDsPw5KBxMetZDnzNXnBLpAn01
         36GFS4fmAIjUsD5FVk3jXDaJlB+aZRNbSmnYS6tN2gSS5VpIy7t8x3VKRCmeYb9Zbep2
         OCzZoTU4w4wj5HXo9FUInw39f8W4p2BZ1BFvWJRRnT3/GmtB4gnTQfGhy0QDe+V+iBiL
         o6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9bJsY3z2kyATyAaL+NSBHkt58yW1QvQynFeadGngaw=;
        b=ggSYNbOv8rPkISRuxO7FXzgy0sWBRXfraSvnZKOxNrdxO2VdAXDiK3GcWVyobr/V32
         JUwYfIMlUgTE2ORESxLci9ga2OAyfvg9RBDSI2YIVg1CNPr+uEhqPqZrkPUng8ug23LG
         EFDNrTu3o5TdAHu4goHBNGcpOv2+SteYC+ufc31uVTB7OR08E5ged6kUCcVBvcIc9MLY
         /os2MnuqfrY9c2InLQtHSiDoAk7elwwqsSYf9drgN0quPan7tOisY4T1wOquGgAb21iZ
         0Gy3kbdKspJqb3sn1+2ZfU5Ywj86eRGS6zTv+3SuQDHHYFXUB5t0s+BOR6pGuCWC9OlN
         TJjA==
X-Gm-Message-State: APjAAAW92vQF+VhbNjjaslm4RPN8aDMkymxwHWsKHYBAuuiRkF1L+FSw
        VXGry6dR3CnU/ZPFBGL1hao=
X-Google-Smtp-Source: APXvYqw6Di5T7pSLeA0bZudtlBrpvoH/onOp/RBWtf39ByJs8M+n1cP7WmTEQBHp/hWK2RIspNrLNw==
X-Received: by 2002:a62:868f:: with SMTP id x137mr43747716pfd.228.1577327600358;
        Wed, 25 Dec 2019 18:33:20 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:19 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC v2 net-next 02/12] tools: sync kernel uapi/linux/if_link.h header
Date:   Thu, 26 Dec 2019 11:31:50 +0900
Message-Id: <20191226023200.21389-3-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if_link.h was out of sync. Also it was recently updated to add
IFLA_XDP_TX attribute.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 tools/include/uapi/linux/if_link.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 8aec8769d944..be97c9787140 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -169,6 +169,8 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_PERM_ADDRESS,
+	IFLA_XDP_TX,
 	__IFLA_MAX
 };
 
-- 
2.21.0

