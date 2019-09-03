Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB0A6221
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfICHBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:01:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43473 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfICHBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 03:01:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id u72so4408172pgb.10
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NagLdWBO+mVhn30698+wliEZ00FrD+Sqb7vGzKlD9Rw=;
        b=ZGril3dAsuGwTavstK9zZ3BJG6PEETVIA/v8TKVQX6K6+iX0Zx9DFKW67oPSqKs0v8
         V6eN3iypDFAfzPfF5kwk2Bx1xR+ZmGLyADXVtKN2r0AdE7sZAiNg6s5CZ1skw9uk5SL6
         CiIDzSIqNerBAgl0+GLmQi/+gl9BrdRCJ5I1hrv+b4Ku2GVOFju2wK07C4ygA25YOe+S
         yEj2KCIBtqsB0WxIr+VItYXU0nuhoP5ERMFbR1mEjPbIU45ywPByWD6gUNi3h9aMsWBo
         8gdyS3znC6ekRkcNQ2q6pXY1d8TXng5msBequzeGcHgr8ozAPLmABOR49tnjehtQWsjm
         LR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NagLdWBO+mVhn30698+wliEZ00FrD+Sqb7vGzKlD9Rw=;
        b=pbz7R/fRJEFPQzhRMPUmsGshodYS7c1kBWe5Al3sxRM3VWj5X0RfdUzGCH+GMTq5MD
         GLX+WV/+sxFQj/LVLn5mQbp2I1QwUuQv00mNdn5xfdJbZQ5FaEJzU4dH5gY91Noxa+pc
         bYHLD9OvxqRTnQkytdsfEoLkH/gTxFbSB6SBqJ12PEzR5ZWjVLDg2ougloVRmUc9MCGF
         xtmWCVMTLbLphAe6ywWF5xjW479q+KY1qI66aPQp31gtV0NiYxYPJhBRGSMdNqY9LkHq
         9LSo/iAhDUFfh9bt8nsW6HIzIOvPdAcfUfch6BFTpgpxlNAKoBRjiPszPCkANmnZ4hwP
         K8MA==
X-Gm-Message-State: APjAAAVEALiKaoDI3lE7rRjNYn91Rt8XeFEsIdLo2oXFR32aYAVqJdNu
        Zj3hY29QDgSbJH56Nyrmk/6O9g==
X-Google-Smtp-Source: APXvYqwqPD2WC070l0e4dPMy2t5gOoCPMQ7fGkPXUQVvc1sMtSMg5yHcMiWp0lBQvavafLlxWi/0SA==
X-Received: by 2002:a65:6859:: with SMTP id q25mr28225218pgt.181.1567494069011;
        Tue, 03 Sep 2019 00:01:09 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id l72sm26377107pjb.7.2019.09.03.00.01.06
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 03 Sep 2019 00:01:08 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, paulus@samba.org
Cc:     ebiggers@google.com, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y 7/8] ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
Date:   Tue,  3 Sep 2019 15:00:38 +0800
Message-Id: <f4b1ac760bbae28721996034be7198458aa68523.1567492316.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567492316.git.baolin.wang@linaro.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit 0e5a610b5ca5 ("ppp: mppe: switch to RC4 library interface"),
which was merged through the crypto tree for v5.3, changed ppp_mppe.c to
use the new arc4_crypt() library function rather than access RC4 through
the dynamic crypto_skcipher API.

Meanwhile commit aad1dcc4f011 ("ppp: mppe: Add softdep to arc4") was
merged through the net tree and added a module soft-dependency on "arc4".

The latter commit no longer makes sense because the code now uses the
"libarc4" module rather than "arc4", and also due to the direct use of
arc4_crypt(), no module soft-dependency is required.

So revert the latter commit.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/net/ppp/ppp_mppe.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index d9eda7c..6c7fd98 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -63,7 +63,6 @@
 MODULE_DESCRIPTION("Point-to-Point Protocol Microsoft Point-to-Point Encryption support");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
-MODULE_SOFTDEP("pre: arc4");
 MODULE_VERSION("1.0.2");
 
 static unsigned int
-- 
1.7.9.5

