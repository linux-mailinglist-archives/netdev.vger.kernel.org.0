Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEFF5BAFE5
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 17:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiIPPHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 11:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiIPPHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 11:07:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F4AA8CEE;
        Fri, 16 Sep 2022 08:07:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id e5so21525737pfl.2;
        Fri, 16 Sep 2022 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=1A6ga4kHyY0A/iGdWq+fEtERzLuG2ECuSfJthR6YX8M=;
        b=aq5y/9owXzU7RrxOBlk9W7pnbPVNW5Qp6zaNBOZ9XkyTKoA7H3u1NIjpGCxcp+fOta
         wvsMmDtuJcHKqYEj/DA8Xs24FbnbqDTmrF/Esg51fkJ+oLeK0eDKsXIN0zFJFHSJ+hrl
         1NEM/ZjIVBaAiqQd/Q/MkFln8gUGBG9t6BOvng4QcpFv1I5UpkZeHHw3FYek8xl57qFV
         q8qxfHutYlX7f7xdDZY7GbhXXDSplI0mCwVjQpzYKk5M50lJdPllB6fxKGunfsHYcCki
         RJ2TCaXhQcbs3KpxpSE4QZHIG3iQpsU84Vt1xdBKLU5nALGz+Ac1VRJZmnoP9+uKPy7J
         wxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=1A6ga4kHyY0A/iGdWq+fEtERzLuG2ECuSfJthR6YX8M=;
        b=6kZzB596SPlXeeACPAEzP0gihOoYJUqukJ5+DnV81aCof5Re1yAQklDhI/YVgyhf0k
         TfE6ICABsAMkg0hX5D9IS3cZxYXQmxEQH3OOeb3CkPKJ8DKnkWS+IStMyYDF3Dyn6PxC
         XI9s5V/iHBl2Dnc5BO+E+WsjySfTVW635/VOxYJ62Hq5hUq9tgG3jVbGaMVfguJKrOl7
         2h/dyCd9QPu62+NGhKdDXxVbU/dlFOR5fStzxbs6Gg8k3RBv9hZfcW+foRf1UKzp8QVk
         q3pBqb+KtI4kZxETsP+I7oqs32Kt9JSUBAHysVTrOdlKu4nVQHJN7gmYCE1b4xQyRsDh
         57Wg==
X-Gm-Message-State: ACrzQf0OhL9h0r61x8z6WCwqtKOBbRJohUPAF/RN8awo7yKSFLn/cvcC
        bJyNXt8JE6YfHD/U8ERUyfw=
X-Google-Smtp-Source: AMsMyM5sO6Np80jaydyQwMYW0UVTDQmEtWzcfq8yULy37H1Ucg5Ocob07JMkHK9Y+jKZupAKqQ8AKw==
X-Received: by 2002:a63:eb0a:0:b0:438:a46b:5632 with SMTP id t10-20020a63eb0a000000b00438a46b5632mr4857086pgh.305.1663340839953;
        Fri, 16 Sep 2022 08:07:19 -0700 (PDT)
Received: from rfl-device.localdomain ([39.124.24.102])
        by smtp.gmail.com with ESMTPSA id m6-20020a63ed46000000b0042ba1a95235sm13455861pgk.86.2022.09.16.08.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 08:07:19 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2] liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment
Date:   Sat, 17 Sep 2022 00:07:08 +0900
Message-Id: <20220916150709.19975-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Delete the repeated word 'to' in the comment.

- Add the missing 'use' word within the sentence.

- Correct spelling on 'malformation'.

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
I have reflected all the reviews. Thanks !

 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
 drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
index 3f1c189646f4..244e27ea079c 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
@@ -88,7 +88,7 @@
 #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
 /* The input jabber is used to determine the TSO max size.
  * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * in order to use H/W TSO and avoid the WQE malformation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
index d33dd8f4226f..e85449249670 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
@@ -37,7 +37,7 @@
 
 /* The input jabber is used to determine the TSO max size.
  * Due to H/W limitation, this need to be reduced to 60000
- * in order to to H/W TSO and avoid the WQE malfarmation
+ * in order to use H/W TSO and avoid the WQE malformation
  * PKO_BUG_24989_WQE_LEN
  */
 #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
-- 
2.25.1

