Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E422C32DD21
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhCDWei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhCDWeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:34:36 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852E3C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:34:36 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id d5so183390iln.6
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MnFEnN5RmyJ3fEdCeq5FgUIloZ1Qg9btOxjTlofMuGs=;
        b=YOUlvIZ6vGjjmdarK/YdgLqCpS/wF4ke284UtZhRlJaa7oxOeefH3BiaEB6+6FWjkR
         UjX/WvLgwYqOZRe21tdw0lO9I6u9WjQNxcZC0t8MxPOzJw0HEfLdZqi+4gwZddNdCNX7
         pL9E8Rs3ksjjvulPw+zx91ua76XfWQzeKzxDpO9TbFLfJ/FjuVsxAEukmmnWLOgYu7mm
         t0kf+km8gp4MD6jigR2KwjSbGFef7v2waqP9Yyjwq6W15Xo1PGpOQ5Mfsbi91sB3M/T8
         YXLohZxd4191MG2jOAZS3CuGCzMfYtfyRQlwn5ZiHBXnCpEsIg/N1gAJICuxcM+Zxb6o
         yNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MnFEnN5RmyJ3fEdCeq5FgUIloZ1Qg9btOxjTlofMuGs=;
        b=iG3AeyKGtAR5dXqYzd+X2vOyqi8T4PgvILcLFPC3D25S4MwlE2drb/JLB/mh5BzKqe
         y/PfiqS/JDQsPYIKE/8tppGDCiwJytB2HoxQB9pP0cLOqN6uIsZy2zrAXG9yuAb9Od2Z
         lvVqZhlKuLIrsXOn1UYDEDIe2p9uwIUdxRg1FY7ExBzDM/Ao75Sa5OmhqQO5JsyKVaQZ
         8JvvxN9C5rALuv/jm3GvK2lAobe7nkNel7B+NNikMui4+AKjKDKpHtDypLW+BHLsqfun
         IBornSMq+iKLUkWB9oHf/z/+uSmTFvr5M+AzUpIaq5yIu1hmHQhs03m5Tey59Uyc9RDq
         mP/g==
X-Gm-Message-State: AOAM531KGiyNg+Pmi7jo5/XjBt7E5fXJNJntzmHrXlFKsOAkrYuay6jB
        AVWnfGGtLizQ9LFsD59GNInlOQ==
X-Google-Smtp-Source: ABdhPJyOuAllyWI83JlkOXfAOW+sismtvbKPbE64ScfusGgJtXSVH+IaVKCW/C19UJj5cMAbXCzIWw==
X-Received: by 2002:a92:194b:: with SMTP id e11mr5947483ilm.184.1614897275911;
        Thu, 04 Mar 2021 14:34:35 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s18sm399790ilt.9.2021.03.04.14.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 14:34:35 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: qualcomm: rmnet: mark trailer field endianness
Date:   Thu,  4 Mar 2021 16:34:26 -0600
Message-Id: <20210304223431.15045-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
References: <20210304223431.15045-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fields in the checksum trailer structure used for QMAP protocol
RX packets are all big-endian format, so define them that way.

It turns out these fields are never actually used by the RMNet code.
The start offset is always assumed to be zero, and the length is
taken from the other packet headers.  So making these fields
explicitly big endian has no effect on the behavior of the code.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 include/linux/if_rmnet.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 9661416a9bb47..8c7845baf3837 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -32,8 +32,8 @@ struct rmnet_map_dl_csum_trailer {
 #else
 #error	"Please fix <asm/byteorder.h>"
 #endif
-	u16 csum_start_offset;
-	u16 csum_length;
+	__be16 csum_start_offset;
+	__be16 csum_length;
 	__be16 csum_value;
 } __aligned(1);
 
-- 
2.20.1

