Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8164DE90C
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243483AbiCSPc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243477AbiCSPc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:32:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9401C258477
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647703896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RDYbzlAeYYOLKs0jJASD2ePoaygRETdsPOHhL2YcgAw=;
        b=Wv/7y0Atoy9y5Nh2ECQJzKYas2/V27pmOd8H/s0FPY6iE8faoQjCmoqgOCe0Zn9lRIGhda
        JimTwYoi9OFb5vexub+eb5GTFFwP9neo//oSatItlzmI4s6py3zht7n8KJPuCbIkQqfnkp
        Boxf/Lv8L+SUJUecCK98jWDw41r+e3c=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-_ISa7jagM9ynrJFeg7703Q-1; Sat, 19 Mar 2022 11:31:35 -0400
X-MC-Unique: _ISa7jagM9ynrJFeg7703Q-1
Received: by mail-qv1-f72.google.com with SMTP id t16-20020ad44850000000b00440e0f2a561so6547447qvy.11
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RDYbzlAeYYOLKs0jJASD2ePoaygRETdsPOHhL2YcgAw=;
        b=UeSKmiUCi67LVworsLukDfU00idpIAnF+VdFMdQpS/US6u8uyMbqq1jiWDnuw1sSLe
         gHVA4Ljcj5JxEX3iC4ViLOzxHAKEQfdgOKEe783KXYwkhfKPto9mN/NT2okHdXnpLs3f
         6e3bHuKBmd+bFv3v+ujcESBmpO5UW/pK65PuY6zBg9WYChFpeVqiR22TergtVaTEVncY
         eAyGikPvGVJ5xIkLKG9mH7Kp99FjoyxLWjJT99AJuCjfCjpe5EuAE0HTfBjDnGe8A5tI
         Ap+ZTsBLIWrVGSbGAKJHwVADywglhPmX2ZFH+fMRnqeRVPmXIBuAQjePZCp0deXYLJVq
         kV6g==
X-Gm-Message-State: AOAM533af+9VI3/49N0/74NnYaoyvtX7aO+3AxhP8+K941aPEhTxDq0a
        lIWkcyLWyWfbsEOjl9YPqzBEFVNcqyXR951e4jnOi3YcZTJwo5sMpGA8VSL28N+TlyhkA1zpb4m
        AyrSOjNLkUV5vzZ01
X-Received: by 2002:a05:620a:430b:b0:67e:85d1:f53f with SMTP id u11-20020a05620a430b00b0067e85d1f53fmr376982qko.43.1647703894468;
        Sat, 19 Mar 2022 08:31:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylEZz+szJS3qXk/iEXTdbF/WnpVfwDLcvLyw6fK6qEuP1X7aGSWen2MjQL9ePfNbUbvv7PgQ==
X-Received: by 2002:a05:620a:430b:b0:67e:85d1:f53f with SMTP id u11-20020a05620a430b00b0067e85d1f53fmr376962qko.43.1647703894215;
        Sat, 19 Mar 2022 08:31:34 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id b2-20020ac87fc2000000b002e1b9ddb629sm7850596qtk.47.2022.03.19.08.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 08:31:33 -0700 (PDT)
From:   trix@redhat.com
To:     mkl@pengutronix.de, mani@kernel.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] can: mcp251xfd: return errors from mcp251xfd_register_get_dev_id
Date:   Sat, 19 Mar 2022 08:31:28 -0700
Message-Id: <20220319153128.2164120-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this issue
mcp251xfd-core.c:1813:7: warning: The left operand
  of '&' is a garbage value
  FIELD_GET(MCP251XFD_REG_DEVID_ID_MASK, dev_id),
  ^                                      ~~~~~~

dev_id is set in a successful call to
mcp251xfd_register_get_dev_id().  Though the status
of calls made by mcp251xfd_register_get_dev_id()
are checked and handled, their status' are not
returned.  So return err.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 325024be7b045..f9dd8fdba12bc 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1786,7 +1786,7 @@ mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv, u32 *dev_id,
  out_kfree_buf_rx:
 	kfree(buf_rx);
 
-	return 0;
+	return err;
 }
 
 #define MCP251XFD_QUIRK_ACTIVE(quirk) \
-- 
2.26.3

