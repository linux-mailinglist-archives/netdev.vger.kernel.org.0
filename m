Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637F520E586
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgF2ViC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389634AbgF2Vhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:37:46 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36735C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:37:46 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id c16so18803844ioi.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eLTQ/BXwwpfHpVShbhLkZS+cPuKECaCCqq8B2X4LXh4=;
        b=ejhcrD4Y89kBPVJsFpjT/RoUICQrZFfy643iMMYadxxh7gcn8SjEwassGmdFdFqEbi
         tKyy5z7sC9594m9pJDVbfu9kIGgUewkXyPt+UGhiaB7miUhvFjF6/C0NEccVDOJScyco
         yJdb/WJREk3+LhhHnUe2u80siBc1lRe7O2EzoW4fu0X9sPvPn9asBTb+dC75LeU9vUR5
         K5wDGd45/297qxbyqqHv4yYGX70ZfvIRLWRddqMVgMcTQ1eOGmfIHP7VaKOWxAF30B4Q
         yRoBD81nT2teZO3GsVnL9U+ynfwztL4Xzn8IeL/yKciha8neTxsLgiTV8aQbaJCfb/hq
         58IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eLTQ/BXwwpfHpVShbhLkZS+cPuKECaCCqq8B2X4LXh4=;
        b=jhuBJi2NocCxfKX0kVeAqEbibHCHiSVNMDX/OiNed+ny7tKwYZY33dQFil7DaqLj4U
         uglKB3ufp0/C/MQN5LZrXIZu23B7mbelv33qOx0s6MbSQ/0SNWfFWI5WIp2i0hp04YNI
         tzhvq5a3DgjDAExpMreWtymVEwYONF0S4sUXWaJje+VVqY+weyY46LZDERYSQXUhhxnQ
         UmbkfWgrDjiBv668k+NDLCr8VWNXtjoxfaOBXASNE/AAIJ6Ohbr9N8zN43WwvitfSYtC
         80LyMH1yBbr5/dIStDhH7ZmYyAGD7CISrsetz2KUk2UZ4IIr//Up+zH8nG+jYdFjUPKD
         67iw==
X-Gm-Message-State: AOAM530n2mSat24sn8vP/Bz/1Z1PMbbLU/6komNsZ/zq+AQPQVrUSbX8
        ZtaUXQnmO2uzyDsMUnc7pSF1uA==
X-Google-Smtp-Source: ABdhPJy4AtJafFmJl5e85TTe/atf6cKo9tyPof0+mKPn8YE2AwhWzryOwRkRPweMcAkulCAEeDIQIQ==
X-Received: by 2002:a05:6602:22c5:: with SMTP id e5mr19273885ioe.9.1593466665582;
        Mon, 29 Jun 2020 14:37:45 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u6sm571353ilg.32.2020.06.29.14.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:37:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ipa: kill IPA_MEM_UC_OFFSET
Date:   Mon, 29 Jun 2020 16:37:38 -0500
Message-Id: <20200629213738.1180618-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629213738.1180618-1-elder@linaro.org>
References: <20200629213738.1180618-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The microcontroller shared memory area is at the beginning of the
IPA resident memory.  IPA_MEM_UC_OFFSET was defined as the offset
within that region where it's found, but it's 0, and it's never
actually used.  Just get rid of the definition, and move some of the
description it had to be above the definition of the ipa_uc_mem_area
structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_uc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index a1f8db00d55a..9f9980ec2ed3 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -35,12 +35,6 @@
  */
 /* Supports hardware interface version 0x2000 */
 
-/* Offset relative to the base of the IPA shared address space of the
- * shared region used for communication with the microcontroller.  The
- * region is 128 bytes in size, but only the first 40 bytes are used.
- */
-#define IPA_MEM_UC_OFFSET	0x0000
-
 /* Delay to allow a the microcontroller to save state when crashing */
 #define IPA_SEND_DELAY		100	/* microseconds */
 
@@ -60,6 +54,10 @@
  * @hw_state:		state of hardware (including error type information)
  * @warning_counter:	counter of non-fatal hardware errors
  * @interface_version:	hardware-reported interface version
+ *
+ * A shared memory area at the base of IPA resident memory is used for
+ * communication with the microcontroller.  The region is 128 bytes in
+ * size, but only the first 40 bytes (structured this way) are used.
  */
 struct ipa_uc_mem_area {
 	u8 command;		/* enum ipa_uc_command */
-- 
2.25.1

